#!/usr/bin/env python3
"""gen_base_stats.py — generate dos_port/assets/base_stats.inc from pret source.

Emits two NASM data tables, resolving all symbolic constants from the pret
disassembly so the byte layout matches the original ROM exactly:

  BaseStats:      151 records of BASE_DATA_SIZE (28) bytes, in DEX order
                  (data/pokemon/base_stats.asm INCLUDE order).
  IndexToPokedex: PokedexOrder (data/pokemon/dex_order.asm) — internal index
                  (1-based) -> national dex number. GetMonHeader uses it.

Per-record layout (constants/pokemon_data_constants.asm):
  +0  dex_no   (overwritten with internal index at load time)
  +1  hp atk def spd spc
  +6  type1 type2
  +8  catch_rate
  +9  base_exp
  +10 sprite_dim  + dw front,back   -> 5 bytes ZEROED (DOS has no battle pics yet)
  +15 4 level-1 moves
  +19 growth_rate
  +20 tm/hm bitfield (7 bytes) -> ZEROED for now (TODO: Stage 6 generates this)
  +27 padding 0

Run from repo root (or dos_port/); paths resolve relative to the repo root.
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]          # repo root
ASSETS = ROOT / "dos_port" / "assets"
BASE_DATA_SIZE = 28


def parse_consts(rel_path: str) -> dict:
    """Parse an rgbds const_def/const enum file into {NAME: value}."""
    out = {}
    val = 0
    for line in (ROOT / rel_path).read_text().splitlines():
        s = line.strip()
        if s.startswith(";") or not s:
            continue
        s = s.split(";", 1)[0].strip()
        m = re.match(r"const_def(?:\s+(-?\w+))?$", s)
        if m:
            val = int(m.group(1)) if m.group(1) else 0
            continue
        m = re.match(r"const_next\s+(-?\w+)$", s)
        if m:
            val = int(m.group(1), 0)
            continue
        m = re.match(r"const_skip(?:\s+(\w+))?$", s)
        if m:
            val += int(m.group(1), 0) if m.group(1) else 1
            continue
        m = re.match(r"const\s+(\w+)$", s)
        if m:
            out[m.group(1)] = val
            val += 1
            continue
    return out


def parse_int(tok: str, consts: dict) -> int:
    """Resolve a numeric literal or a known constant name to an int."""
    tok = tok.strip()
    if tok in consts:
        return consts[tok]
    if tok.startswith("$"):
        return int(tok[1:], 16)
    return int(tok, 0)


def species_order() -> list:
    """Dex-ordered list of base_stats/<name>.asm paths (table INCLUDE order)."""
    files = []
    for line in (ROOT / "data/pokemon/base_stats.asm").read_text().splitlines():
        m = re.search(r'INCLUDE\s+"(data/pokemon/base_stats/[^"]+)"', line)
        if m:
            files.append(m.group(1))
    return files


def parse_species(rel_path: str, types, moves, growth) -> bytes:
    """Parse one base_stats/<name>.asm into its 28-byte record.

    Every species file has a fixed row order (after stripping comments/blanks):
      0 db DEX_x | 1 db hp,atk,def,spd,spc | 2 db type1,type2 | 3 db catch |
      4 db base_exp | 5 INCBIN sprite_dim | 6 dw front,back | 7 db move1..4 |
      8 db GROWTH_x | 9.. tmhm (continuation) | last db 0
    We parse positionally (robust) and zero the DOS-irrelevant sprite + TM/HM
    blocks.
    """
    rows = []
    for line in (ROOT / rel_path).read_text().splitlines():
        s = line.split(";", 1)[0].strip()
        if s:
            rows.append(s)

    def vals(row):
        return [x.strip() for x in row.split(None, 1)[1].split(",")]

    rec = bytearray()
    rec.append(parse_int(rows[0].split()[1], DEX) & 0xFF)          # dex id
    rec += bytes(int(x) & 0xFF for x in vals(rows[1]))             # hp atk def spd spc
    rec += bytes(types[t] & 0xFF for t in vals(rows[2])[:2])       # type1 type2
    rec.append(int(rows[3].split()[1]) & 0xFF)                     # catch rate
    rec.append(int(rows[4].split()[1]) & 0xFF)                     # base exp
    rec += bytes(5)                                                # sprite dim + 2 ptrs (zeroed)
    rec += bytes(moves[m] & 0xFF for m in vals(rows[7])[:4])       # level-1 moves
    rec.append(growth[rows[8].split()[1]] & 0xFF)                  # growth rate
    rec += bytes(7)                                                # tm/hm bitfield (TODO Stage 6)
    rec += bytes(1)                                                # padding

    if len(rec) != BASE_DATA_SIZE:
        raise ValueError(f"{rel_path}: produced {len(rec)} bytes != {BASE_DATA_SIZE}")
    return bytes(rec)


def emit_table(label: str, data: bytes) -> str:
    out = [f"{label}:"]
    for i in range(0, len(data), 16):
        out.append("    db " + ", ".join(f"0x{b:02X}" for b in data[i:i + 16]))
    out += [f"{label}_end:", ""]
    return "\n".join(out)


# Resolve constants up front (DEX is module-global for parse_species).
DEX = parse_consts("constants/pokedex_constants.asm")


def main():
    types = parse_consts("constants/type_constants.asm")
    moves = parse_consts("constants/move_constants.asm")
    growth = parse_consts("constants/pokemon_data_constants.asm")

    base = bytearray()
    for f in species_order():
        base += parse_species(f, types, moves, growth)
    if len(base) != 151 * BASE_DATA_SIZE:
        sys.exit(f"BaseStats wrong size: {len(base)} != {151 * BASE_DATA_SIZE}")

    # IndexToPokedex = PokedexOrder, resolving DEX_* names.
    idx = bytearray()
    for line in (ROOT / "data/pokemon/dex_order.asm").read_text().splitlines():
        m = re.search(r"db\s+(\w+)", line)
        if m:
            idx.append(parse_int(m.group(1), DEX) & 0xFF)

    header = (
        "; base_stats.inc — generated by tools/gen_base_stats.py. DO NOT EDIT BY HAND.\n"
        "; BaseStats: 151 x 28-byte records in DEX order. Sprite block (5 bytes at\n"
        "; +10) and TM/HM bitfield (7 bytes at +20) are zeroed (DOS backend; Stage 6\n"
        "; will fill TM/HM). IndexToPokedex: internal index (1-based) -> dex number.\n"
    )
    ASSETS.mkdir(parents=True, exist_ok=True)
    out = header + "\n" + emit_table("BaseStats", bytes(base)) + "\n" + \
        emit_table("IndexToPokedex", bytes(idx)) + "\n"
    (ASSETS / "base_stats.inc").write_text(out)
    print(f"  wrote {ASSETS / 'base_stats.inc'} "
          f"(BaseStats {len(base)} bytes / 151 mons, IndexToPokedex {len(idx)} bytes)")


if __name__ == "__main__":
    main()
