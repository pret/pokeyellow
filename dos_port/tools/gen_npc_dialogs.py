#!/usr/bin/env python3
"""Generate NPC dialog byte streams from pret text sources.

Usage: python3 tools/gen_npc_dialogs.py [MAP_NAME]
  MAP_NAME defaults to PALLET_TOWN.
  Output: dos_port/assets/npc_dialogs_<map_name>.inc

Sources:
  constants/charmap.asm              — charmap → byte encoding
  text/<PascalMapName>.asm           — raw text label definitions
  scripts/<PascalMapName>.asm        — TextPointers table → far-text labels
  data/maps/objects/<PascalMapName>.asm — object_const_def → NPC count

For each NPC slot i in the TextPointers table:
  - If the slot's local_label uses text_asm (scripted/trainer) or is not found:
      emit a stub (b"TRAINER!" stub bytes — Phase 3+ will flesh out).
  - Otherwise:
      resolve local_label → text_far _FarLabel → encode from text/<Map>.asm

Output NASM:
  section .data     ← safe: data lands in .data, never orphaned as .rodata
  pallet_oak_text: / pallet_girl_text: / etc.
  PalletTownTextTable:  dd ptr, size  (matches CheckNPCInteraction layout)

The table name and per-NPC label names follow the existing hand-encoded
convention in map_sprites.asm so that file can drop in the %include with
no other changes to CheckNPCInteraction.

Run from dos_port/:
    python3 tools/gen_npc_dialogs.py PALLET_TOWN
"""
import re
import sys
from pathlib import Path

ROOT   = Path(__file__).resolve().parent.parent.parent
ASSETS = ROOT / "dos_port" / "assets"

# ---------------------------------------------------------------------------
# TX_* / CHAR_* byte constants (must match text.asm)
# ---------------------------------------------------------------------------
TX_START    = 0x00
TX_END      = 0x50
CHAR_LINE   = 0x4F
CHAR_PARA   = 0x51
CHAR_CONT   = 0x55
CHAR_DONE   = 0x57

# ---------------------------------------------------------------------------
# Charmap loader
# ---------------------------------------------------------------------------

def _load_charmap(path: Path) -> list[tuple[str, int]]:
    """Return (key_str, byte_val) pairs sorted by length desc for greedy match."""
    cm: list[tuple[str, int]] = []
    for line in path.read_text(encoding='utf-8').splitlines():
        m = re.match(r'\s+charmap\s+"((?:[^"\\]|\\.)*)",\s*\$([0-9a-fA-F]+)', line)
        if m:
            key = m.group(1)
            val = int(m.group(2), 16)
            cm.append((key, val))
    cm.sort(key=lambda x: -len(x[0]))
    return cm

def _encode(s: str, charmap: list[tuple[str, int]]) -> bytes:
    """Encode a pret text string to bytes using greedy charmap matching."""
    out: list[int] = []
    i = 0
    while i < len(s):
        matched = False
        for key, val in charmap:
            if s[i:].startswith(key):
                out.append(val)
                i += len(key)
                matched = True
                break
        if not matched:
            raise ValueError(f"Unrecognised char at offset {i}: {s[i:i+6]!r}")
    return bytes(out)

# ---------------------------------------------------------------------------
# text/<Map>.asm parser → {label: bytes}
# ---------------------------------------------------------------------------

def _parse_text_file(path: Path, charmap: list[tuple[str, int]]) -> dict[str, bytes]:
    """Parse text/<MapName>.asm; return {double-underscore label: encoded bytes}."""
    TX_START_B = bytes([TX_START])
    entries: dict[str, bytes] = {}
    cur_label: str | None = None
    cur_bytes: list[int]   = []

    for raw in path.read_text(encoding='utf-8').splitlines():
        line = raw.strip()

        # New exported label  _Name:: or _Name:
        m = re.match(r'(_\w+)::?', line)
        if m:
            if cur_label is not None:
                entries[cur_label] = bytes(cur_bytes)
            cur_label = m.group(1)
            cur_bytes = []
            continue

        if cur_label is None or not line or line.startswith(';'):
            continue

        def _add_str(s: str) -> None:
            cur_bytes.extend(_encode(s, charmap))

        # text "..."
        m = re.match(r'text\s+"(.*)"', line)
        if m:
            cur_bytes.append(TX_START)
            _add_str(m.group(1))
            continue

        # line "..."
        m = re.match(r'line\s+"(.*)"', line)
        if m:
            cur_bytes.append(CHAR_LINE)
            _add_str(m.group(1))
            continue

        # next "..."
        m = re.match(r'next\s+"(.*)"', line)
        if m:
            cur_bytes.append(0x4E)   # CHAR_NEXT
            _add_str(m.group(1))
            continue

        # para "..."
        m = re.match(r'para\s+"(.*)"', line)
        if m:
            cur_bytes.append(CHAR_PARA)
            _add_str(m.group(1))
            continue

        # cont "..."
        m = re.match(r'cont\s+"(.*)"', line)
        if m:
            cur_bytes.append(CHAR_CONT)
            _add_str(m.group(1))
            continue

        # prompt
        if line == 'prompt':
            cur_bytes.append(0x58)   # CHAR_PROMPT
            continue

        # done → CHAR_DONE + TX_END; close entry
        if line == 'done':
            cur_bytes.extend([CHAR_DONE, TX_END])
            entries[cur_label] = bytes(cur_bytes)
            cur_label = None
            cur_bytes = []
            continue

        # text_end → TX_END (string already terminated by '@' in last encoded str)
        if line == 'text_end':
            cur_bytes.append(TX_END)
            entries[cur_label] = bytes(cur_bytes)
            cur_label = None
            cur_bytes = []
            continue

    # Flush last entry if file ends without done/text_end
    if cur_label is not None and cur_bytes:
        entries[cur_label] = bytes(cur_bytes)

    return entries

# ---------------------------------------------------------------------------
# scripts/<Map>.asm — TextPointers table + local label resolution
# ---------------------------------------------------------------------------

def _parse_text_pointers(path: Path, map_pascal: str) -> list[str]:
    """Return ordered list of local-label names from <Map>_TextPointers:."""
    target = f"{map_pascal}_TextPointers:"
    lines = path.read_text(encoding='utf-8').splitlines()
    in_table = False
    result: list[str] = []
    for line in lines:
        s = line.strip()
        if s == target:
            in_table = True
            continue
        if not in_table:
            continue
        # def_text_pointers / blank / comment — skip
        if not s or s.startswith(';') or s == 'def_text_pointers':
            continue
        m = re.match(r'dw_const\s+(\w+)', s)
        if m:
            result.append(m.group(1))
        else:
            break   # non-dw_const line terminates the table
    return result

def _resolve_local_label(path: Path, label: str) -> str | None:
    """
    Find the first text_far _FarLabel reference under `label:` in the scripts file.
    Returns the far label string (with leading underscore) or None if not found
    (e.g. pure text_asm without a fallback text_far — stub territory).
    """
    lines = path.read_text(encoding='utf-8').splitlines()
    in_label = False
    for line in lines:
        s = line.strip()
        if re.match(rf'{re.escape(label)}\s*:', s):
            in_label = True
            continue
        if not in_label:
            continue
        # A NEW non-local Pascal-case label (first char uppercase) ends the section
        if re.match(r'[A-Z]\w+:', s):
            break
        # text_far _FarLabel
        m = re.match(r'text_far\s+(_\w+)', s)
        if m:
            return m.group(1)
    return None

# ---------------------------------------------------------------------------
# data/maps/objects/<Map>.asm — count NPC slots from object_const_def
# ---------------------------------------------------------------------------

def _count_npcs(path: Path) -> int:
    """Count const_export lines inside the object_const_def block."""
    lines = path.read_text(encoding='utf-8').splitlines()
    in_block = False
    count = 0
    for line in lines:
        s = line.strip()
        if s == 'object_const_def':
            in_block = True
            continue
        if not in_block:
            continue
        if s.startswith('const_export'):
            count += 1
        elif s and not s.startswith(';'):
            break   # first non-const-export non-blank line ends the block
    return count

# ---------------------------------------------------------------------------
# Stub bytes for trainer / unresolvable NPCs (Phase 3+)
# ---------------------------------------------------------------------------

# TRAINER stub: TX_START + "TRAINER!" + CHAR_DONE + TX_END
_TRAINER_STUB = bytes(
    [TX_START,
     0x93,0x91,0x80,0x88,0x8D,0x84,0x91,0xE7,   # "TRAINER!"
     CHAR_DONE, TX_END]
)

# ---------------------------------------------------------------------------
# NASM emitter helpers
# ---------------------------------------------------------------------------

def _bytes_to_nasm(data: bytes, indent: str = '    ') -> str:
    """Format a bytes object as db lines with 16 bytes per row."""
    lines = []
    for i in range(0, len(data), 16):
        chunk = data[i:i+16]
        row = ', '.join(f'0x{b:02X}' for b in chunk)
        lines.append(f'{indent}db {row}')
    return '\n'.join(lines)

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def _to_pascal(snake: str) -> str:
    """'PALLET_TOWN' → 'PalletTown'"""
    return ''.join(w.capitalize() for w in snake.split('_'))

def generate(map_name: str) -> None:
    map_pascal  = _to_pascal(map_name)        # 'PalletTown'
    map_snake   = map_name.lower()            # 'pallet_town'

    charmap_path  = ROOT / 'constants' / 'charmap.asm'
    text_path     = ROOT / 'text' / f'{map_pascal}.asm'
    scripts_path  = ROOT / 'scripts' / f'{map_pascal}.asm'
    objects_path  = ROOT / 'data' / 'maps' / 'objects' / f'{map_pascal}.asm'
    out_path      = ASSETS / f'npc_dialogs_{map_snake}.inc'

    # Load resources
    charmap = _load_charmap(charmap_path)
    text_db = _parse_text_file(text_path, charmap)
    pointers = _parse_text_pointers(scripts_path, map_pascal)
    npc_count = _count_npcs(objects_path)

    if npc_count == 0:
        print(f'[gen_npc_dialogs] {map_name}: no NPCs — skipping', file=sys.stderr)
        return

    if npc_count > len(pointers):
        print(
            f'[gen_npc_dialogs] WARNING: {map_name}: npc_count={npc_count} '
            f'but only {len(pointers)} TextPointers entries — truncating',
            file=sys.stderr
        )
        npc_count = len(pointers)

    # Resolve each NPC slot's text bytes
    npc_label_prefix = map_snake.replace('_', '_')   # keep as-is for now
    npc_entries: list[tuple[str, bytes]] = []
    table_label = f'{map_pascal}TextTable'

    for i in range(npc_count):
        local_label = pointers[i]
        asm_label   = local_label[0].lower() + local_label[1:]  # PalletTownOakText → palletTownOakText
        # Build the label used in NASM (e.g. pallet_oak_text)
        # Match existing hand-encoded names exactly for Pallet Town NPCs:
        # PalletTownOakText → pallet_oak_text
        # PalletTownGirlText → pallet_girl_text
        # PalletTownFisherText → pallet_fisher_text
        # General rule: strip map prefix ('PalletTown'), snake_case remainder, prepend map_snake.
        suffix = local_label
        if suffix.startswith(map_pascal):
            suffix = suffix[len(map_pascal):]  # 'OakText', 'GirlText', 'FisherText'
        # Strip trailing 'Text'
        if suffix.endswith('Text'):
            suffix = suffix[:-4]
        # Convert PascalCase suffix to snake_case
        snake_suffix = re.sub(r'(?<=[a-z])(?=[A-Z])', '_', suffix).lower()
        nasm_label = f'{map_snake}_{snake_suffix}_text'

        # Resolve: local_label → text_far → far_label → bytes
        far_label = _resolve_local_label(scripts_path, local_label)
        if far_label is None:
            # text_asm without a text_far: use stub (should not happen for normal NPCs)
            data = _TRAINER_STUB
            print(
                f'[gen_npc_dialogs] {map_name}[{i}] {local_label}: '
                f'no text_far found — emitting stub',
                file=sys.stderr
            )
        elif far_label not in text_db:
            data = _TRAINER_STUB
            print(
                f'[gen_npc_dialogs] {map_name}[{i}] {local_label}: '
                f'far label {far_label} not in text file — emitting stub',
                file=sys.stderr
            )
        else:
            data = text_db[far_label]

        npc_entries.append((nasm_label, data))

    # Emit NASM include
    ASSETS.mkdir(exist_ok=True)
    lines = [
        f'; Auto-generated by tools/gen_npc_dialogs.py — DO NOT EDIT',
        f'; Source: text/{map_pascal}.asm + scripts/{map_pascal}.asm',
        f'; Map: {map_name}  ({npc_count} NPC slot(s))',
        f';',
        f'; Data is in section .data so it is never orphaned into .rodata.',
        f'; (Orphaned sections read as zero at runtime; see docs/translation_log.md)',
        f'',
        f'section .data',
        f'',
    ]

    for nasm_label, data in npc_entries:
        lines.append(f'{nasm_label}:')
        lines.append(_bytes_to_nasm(data))
        lines.append(f'{nasm_label}_end:')
        lines.append('')

    lines.append(f'{table_label}:')
    for nasm_label, _ in npc_entries:
        lines.append(f'    dd {nasm_label}, {nasm_label}_end - {nasm_label}')
    lines.append('    dd 0, 0')
    lines.append('')

    out_path.write_text('\n'.join(lines), encoding='utf-8')
    print(f'[gen_npc_dialogs] Wrote {out_path.relative_to(ROOT)} ({npc_count} NPCs)')

if __name__ == '__main__':
    map_name = sys.argv[1] if len(sys.argv) > 1 else 'PALLET_TOWN'
    generate(map_name)
