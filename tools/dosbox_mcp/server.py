#!/usr/bin/env python3
"""
DOSBox-X MCP Debug Server for the Pokemon Yellow DOS Port.

Exposes tools that let an LLM drive the DOSBox-X heavy debugger via a
Unix domain socket patched into DOSBox-X.  High-level tools know about
the GB address space (EBP + gb_offset) and translate symbol names via
pkmn.map / gb_memmap.inc.

Usage (started by run_with_mcp.sh or Claude Code MCP config):
  python3 tools/dosbox_mcp/server.py

Environment:
  DOSBOX_MCP_SOCKET  path to Unix socket  (default /tmp/dosbox-mcp.sock)
  PKMN_MAP           path to pkmn.map     (default dos_port/pkmn.map)
  GB_MEMMAP_INC      path to gb_memmap.inc
  DOSBOX_MCP_DIR     directory where MEMDUMP.BIN / FRAME.BIN are written
                     (default: same dir as PKMN.EXE, typically dos_port/)
"""

import os
import sys
import json
import struct
import subprocess
from pathlib import Path
from typing import Optional

# Allow running from repo root or tools/ dir
_HERE = Path(__file__).parent
_REPO = _HERE.parent.parent  # tools/dosbox_mcp → tools → repo root

sys.path.insert(0, str(_HERE))
from symbol_map import SymbolMap
from socket_client import DebugSocketClient

from mcp.server.fastmcp import FastMCP

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

SOCK_PATH  = os.environ.get('DOSBOX_MCP_SOCKET', '/tmp/dosbox-mcp.sock')
MAP_FILE   = os.environ.get('PKMN_MAP',    str(_REPO / 'dos_port' / 'pkmn.map'))
MEMMAP_INC = os.environ.get('GB_MEMMAP_INC', str(_REPO / 'dos_port' / 'include' / 'gb_memmap.inc'))
DUMP_DIR   = os.environ.get('DOSBOX_MCP_DIR', str(_REPO / 'dos_port'))
RENDER_PY  = str(_REPO / 'tools' / 'render_frame.py')

# ---------------------------------------------------------------------------
# Singletons
# ---------------------------------------------------------------------------

_syms = SymbolMap(MAP_FILE, MEMMAP_INC)
_client = DebugSocketClient(SOCK_PATH, timeout=120.0)

# Cached after first get_registers() call — constant across a session
_cached_ebp: Optional[int] = None
_cached_ds_base: Optional[int] = None  # ds_base VMA from pkmn.map

mcp = FastMCP("dosbox-debugger")

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _cmd(raw: str, timeout: float = 60.0) -> str:
    """Send a raw debugger command, return captured output."""
    try:
        _client.connect()
    except OSError as e:
        return f"ERROR: cannot connect to {SOCK_PATH}: {e}"
    return _client.command(raw, timeout=timeout)


def _regs() -> dict:
    """Return current x86 registers as a dict, caching EBP."""
    global _cached_ebp, _cached_ds_base
    out = _cmd('REGJSON')
    try:
        regs = json.loads(out)
    except json.JSONDecodeError:
        return {'error': out}
    _cached_ebp = int(regs.get('EBP', '0'), 16)
    if _cached_ds_base is None:
        addr = _syms.resolve('ds_base')
        if addr is not None:
            _cached_ds_base = addr
    return regs


def _gb_linear(gb_offset: int) -> Optional[int]:
    """Convert a GB address offset to a x86 linear address for MEMDUMPBIN."""
    global _cached_ebp, _cached_ds_base
    if _cached_ebp is None:
        _regs()
    if _cached_ebp is None:
        return None
    # Linear = ds_base + EBP + gb_offset
    # ds_base is what the VMA symbols are relative to in our flat memory model.
    # In the running process, EBP already IS the biased (VMA) pointer to the
    # GB allocation, so: linear = EBP + gb_offset (no ds_base adjustment needed
    # for MEMDUMPBIN which takes linear addresses).
    return _cached_ebp + gb_offset


# ---------------------------------------------------------------------------
# MCP Tools
# ---------------------------------------------------------------------------

@mcp.tool()
def dbg_command(cmd: str) -> str:
    """
    Send any raw DOSBox-X debugger command and return its text output.
    Examples: "BPLM 1234", "SR EAX 0", "BPLIST", "REGJSON", "LOG 10"
    RUN blocks until the next breakpoint hits.
    """
    return _cmd(cmd)


@mcp.tool()
def get_registers() -> str:
    """
    Return all x86 registers as JSON (EAX, EBX, ECX, EDX, ESI, EDI, EBP,
    ESP, EIP, EFLAGS, CS, DS, ES, SS).  EBP is the base of the emulated GB
    address space; HL maps to ESI; BC→BX; DE→DX; A→AL.
    """
    regs = _regs()
    return json.dumps(regs, indent=2)


@mcp.tool()
def lookup_symbol(name: str) -> str:
    """
    Resolve a symbol name to its linear address using pkmn.map.
    Also searches GB memory constants from gb_memmap.inc when prefix is 'gb:'.
    Example: lookup_symbol("OverworldLoop") or lookup_symbol("gb:wCurMap")
    """
    if name.startswith('gb:'):
        gb_name = name[3:]
        off = _syms.gb_offset(gb_name)
        if off is None:
            return f"Not found in gb_memmap.inc: {gb_name}"
        lin = _gb_linear(off)
        return f"{gb_name}: GB offset=0x{off:04X}, linear=0x{lin:08X}" if lin else f"{gb_name}: GB offset=0x{off:04X}"
    addr = _syms.resolve(name)
    if addr is None:
        matches = _syms.search(name)
        if matches:
            lines = [f"{n}: 0x{a:08X}" for n, a in matches[:10]]
            return "Partial matches:\n" + "\n".join(lines)
        return f"Symbol not found: {name}"
    return f"{name}: 0x{addr:08X}"


@mcp.tool()
def search_symbols(pattern: str) -> str:
    """
    Search pkmn.map symbol names by regex pattern (case-insensitive).
    Returns up to 20 matches with their addresses.
    Example: search_symbols("Overworld") or search_symbols("^wSprite")
    """
    matches = _syms.search(pattern)[:20]
    if not matches:
        return f"No symbols match: {pattern}"
    return "\n".join(f"0x{a:08X}  {n}" for n, a in sorted(matches, key=lambda x: x[1]))


@mcp.tool()
def set_breakpoint(symbol_or_addr: str) -> str:
    """
    Set a linear-address breakpoint (BPLM) at a symbol name or hex address.
    Example: set_breakpoint("OverworldLoop") or set_breakpoint("0x1234")
    """
    addr = _syms.resolve(symbol_or_addr)
    if addr is None:
        return f"Cannot resolve: {symbol_or_addr}"
    return _cmd(f"BPLM {addr:X}")


@mcp.tool()
def list_breakpoints() -> str:
    """List all currently set breakpoints."""
    return _cmd("BPLIST")


@mcp.tool()
def delete_breakpoint(number: int) -> str:
    """Delete breakpoint by its list index (from list_breakpoints)."""
    return _cmd(f"BPDEL {number}")


@mcp.tool()
def continue_exec(wait_for_break: bool = True) -> str:
    """
    Resume execution (RUN command).  If wait_for_break=True (default), blocks
    until a breakpoint is hit and returns the break location.
    If False, returns immediately with 'RUNNING' and the game continues.
    """
    if wait_for_break:
        # RUN blocks at the socket level until the break notification arrives
        return _cmd('RUN', timeout=300.0)
    else:
        # Fire and forget — connect with very short timeout for the immediate ACK
        return _cmd('RUN', timeout=5.0)


@mcp.tool()
def gb_read(offset_or_name: str, length: int) -> str:
    """
    Read bytes from the emulated GB address space.
    offset_or_name: hex GB offset (e.g. "C000") or gb_memmap.inc constant name
                    (e.g. "wSpriteStateData1").
    length: number of bytes to read (max 4096).
    Returns hex dump of the memory contents.
    """
    # Resolve offset
    if offset_or_name.startswith('0x') or all(c in '0123456789abcdefABCDEF' for c in offset_or_name):
        gb_off = int(offset_or_name, 16)
    else:
        gb_off = _syms.gb_offset(offset_or_name)
        if gb_off is None:
            return f"Unknown GB symbol: {offset_or_name}"

    lin = _gb_linear(gb_off)
    if lin is None:
        return "ERROR: cannot compute linear address (get_registers first)"

    length = min(length, 4096)
    out = _cmd(f"MEMDUMPBIN 0 {lin:X} {length:X}")

    # MEMDUMPBIN writes MEMDUMP.BIN in the working dir of DOSBox-X (DUMP_DIR)
    dump_path = Path(DUMP_DIR) / 'MEMDUMP.BIN'
    if not dump_path.exists():
        return f"MEMDUMP.BIN not found in {DUMP_DIR}. Debugger output:\n{out}"

    data = dump_path.read_bytes()[:length]
    dump_path.unlink()  # clean up for next call

    # Format as hex dump
    lines = []
    for i in range(0, len(data), 16):
        chunk = data[i:i+16]
        hex_part = ' '.join(f'{b:02X}' for b in chunk)
        asc_part = ''.join(chr(b) if 32 <= b < 127 else '.' for b in chunk)
        lines.append(f"GB+{gb_off+i:04X}  {hex_part:<48}  {asc_part}")
    return '\n'.join(lines)


@mcp.tool()
def x86_read(linear_addr: str, length: int) -> str:
    """
    Read raw x86 linear memory (not GB-space-relative).
    Useful for reading code, stack, or other non-GB regions.
    linear_addr: hex address (e.g. "1000" for code start).
    """
    addr = int(linear_addr, 16)
    length = min(length, 4096)
    out = _cmd(f"MEMDUMPBIN 0 {addr:X} {length:X}")
    dump_path = Path(DUMP_DIR) / 'MEMDUMP.BIN'
    if not dump_path.exists():
        return f"MEMDUMP.BIN not found. Debugger output:\n{out}"
    data = dump_path.read_bytes()[:length]
    dump_path.unlink()
    lines = []
    for i in range(0, len(data), 16):
        chunk = data[i:i+16]
        hex_part = ' '.join(f'{b:02X}' for b in chunk)
        asc_part = ''.join(chr(b) if 32 <= b < 127 else '.' for b in chunk)
        lines.append(f"{addr+i:08X}  {hex_part:<48}  {asc_part}")
    return '\n'.join(lines)


@mcp.tool()
def dump_frame(output_png: str = '/tmp/dosbox_frame.png') -> str:
    """
    Dump the current DOSBox-X back-buffer (GB_BACKBUF, 320×200 pixels) to a
    PNG file and return the path.  Requires the game to be paused at a
    breakpoint.  The PNG uses the DMG-green palette (values 0-3) plus sprite
    overlay colors.
    """
    GB_BACKBUF = 0x12000  # from gb_memmap.inc
    GB_BACKBUF_SIZE = 64000  # 320 × 200

    lin = _gb_linear(GB_BACKBUF)
    if lin is None:
        return "ERROR: cannot compute linear address"

    out = _cmd(f"MEMDUMPBIN 0 {lin:X} {GB_BACKBUF_SIZE:X}")
    frame_src = Path(DUMP_DIR) / 'MEMDUMP.BIN'
    if not frame_src.exists():
        return f"MEMDUMP.BIN not found. Output:\n{out}"

    frame_dst = Path(DUMP_DIR) / 'FRAME.BIN'
    frame_src.rename(frame_dst)

    result = subprocess.run(
        [sys.executable, RENDER_PY, str(frame_dst), output_png],
        capture_output=True, text=True
    )
    frame_dst.unlink(missing_ok=True)

    if result.returncode != 0:
        return f"render_frame.py failed:\n{result.stderr}"
    return f"Frame rendered to {output_png}"


@mcp.tool()
def disassemble(symbol_or_addr: str, count: int = 10) -> str:
    """
    Disassemble 'count' instructions starting at a symbol or linear address.
    Uses the DOSBox-X debugger's LOG command to capture the trace.
    """
    addr = _syms.resolve(symbol_or_addr)
    if addr is None:
        return f"Cannot resolve: {symbol_or_addr}"
    # Set CS:EIP to the address (flat model: CS=flat selector, EIP=addr)
    # Use LOG to disassemble without running
    out = _cmd(f"SR EIP {addr:X}")
    out += '\n' + _cmd(f"LOGC {count:X}")
    log_path = Path(DUMP_DIR) / 'LOGCPU.TXT'
    if log_path.exists():
        text = log_path.read_text()
        log_path.unlink()
        return text
    return out


if __name__ == '__main__':
    mcp.run()
