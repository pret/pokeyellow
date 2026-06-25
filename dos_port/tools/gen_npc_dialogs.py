#!/usr/bin/env python3
"""Generate NPC dialog byte streams for ALL maps and the master dispatch table.

Outputs:
  assets/npc_dialogs/<map_snake>_dialogs.inc  — one file per map with NPCs
  assets/npc_dialogs/all_dialogs.inc          — master %include + MapTextTablePointers

Sources:
  constants/map_constants.asm   — map IDs and names
  constants/charmap.asm         — charmap encoding
  text/<PascalMapName>.asm      — raw text label definitions
  scripts/<PascalMapName>.asm   — TextPointers table + local label resolution
  data/maps/objects/<Pascal>.asm — object_event entries (NPC count + trainer flag)

Run from dos_port/ or repo root:
    python3 tools/gen_npc_dialogs.py
"""
import re
import sys
from pathlib import Path

# Reuse gen_map_headers' map/sprite parsing so the dialog tables stay in lockstep
# with the map-object binary: same map→label resolution, same _DEBUG stripping,
# same object_event list (count + order + trainer/item flags).  This guarantees
# table_entries == header sprite_count for every map, and that table index i
# matches the text_id (= slot index i) the binary stores.
sys.path.insert(0, str(Path(__file__).resolve().parent))
import gen_map_headers as gmh

ROOT   = Path(__file__).resolve().parent.parent.parent
ASSETS = ROOT / "dos_port" / "assets"
DIALOGS_DIR = ASSETS / "npc_dialogs"
MAP_CONSTANTS_FILE = ROOT / "constants" / "map_constants.asm"

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
# Stubs for trainers and script NPCs
# ---------------------------------------------------------------------------
# TRAINER stub: TX_START + "TRAINER!" + CHAR_DONE + TX_END
_TRAINER_STUB = bytes(
    [TX_START,
     0x93,0x91,0x80,0x88,0x8D,0x84,0x91,0xE7,   # "TRAINER!"
     CHAR_DONE, TX_END]
)
# SCRIPT stub: TX_START + "..." + CHAR_DONE + TX_END
# NOTE: "." is charmap 0xE8 (0xE3 is "-"); three periods render as "...".
_SCRIPT_STUB = bytes(
    [TX_START,
     0xE8,0xE8,0xE8,                              # "..."
     CHAR_DONE, TX_END]
)

# ---------------------------------------------------------------------------
# Hand-written text_asm script overrides
# ---------------------------------------------------------------------------
# Faithfully-translated text_asm scripts (event/var-gated dialog, give-item, etc.)
# live as NASM routines in dos_port/src/scripts/<map>.asm. A slot whose pret text
# pointer label is listed here emits a SCRIPT table entry — `dd <ScriptLabel>,
# 0xFFFFFFFF` — instead of a static byte stream. The sentinel size tells the
# dialog dispatcher (CheckNPCInteraction) to CALL the flat routine (which runs its
# own logic + ShowTextStream) rather than copy+print a stream.
# Key   = pret text-pointer local label (from scripts/<Map>.asm _TextPointers).
# Value = NASM global label of the hand-written script (extern'd in the table).
SCRIPT_SENTINEL = 0xFFFFFFFF
SCRIPT_OVERRIDES = {
    'PalletTownOakText': 'PalletTownOakText',
}

# ---------------------------------------------------------------------------
# Map constants
# ---------------------------------------------------------------------------

def const_to_pascal(const: str) -> str:
    """CONST_NAME → PascalCase.  REDS_HOUSE_1F → RedsHouse1F"""
    return "".join(w.capitalize() for w in const.split("_"))

def parse_map_constants() -> list:
    """Return [(id, const_name, pascal_name)] sorted by id."""
    result = []
    for line in MAP_CONSTANTS_FILE.read_text().splitlines():
        m = re.match(r"\s*map_const\s+(\w+),\s*\d+,\s*\d+\s*;\s*\$([0-9A-Fa-f]+)", line)
        if m:
            const = m.group(1)
            mid = int(m.group(2), 16)
            result.append((mid, const, const_to_pascal(const)))
    result.sort()
    return result

# ---------------------------------------------------------------------------
# Charmap
# ---------------------------------------------------------------------------

def _load_charmap(path: Path) -> list:
    cm = []
    for line in path.read_text(encoding='utf-8').splitlines():
        m = re.match(r'\s+charmap\s+"((?:[^"\\]|\\.)*)",\s*\$([0-9a-fA-F]+)', line)
        if m:
            key = m.group(1)
            val = int(m.group(2), 16)
            cm.append((key, val))
    cm.sort(key=lambda x: -len(x[0]))
    return cm

def _encode(s: str, charmap: list) -> bytes:
    out = []
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
# text/<Map>.asm → {label: bytes}
# ---------------------------------------------------------------------------

def _parse_text_file(path: Path, charmap: list) -> dict:
    entries = {}
    cur_label = None
    cur_bytes = []

    for raw in path.read_text(encoding='utf-8').splitlines():
        line = raw.strip()
        m = re.match(r'(_\w+)::?', line)
        if m:
            if cur_label is not None:
                entries[cur_label] = bytes(cur_bytes)
            cur_label = m.group(1)
            cur_bytes = []
            continue
        if cur_label is None or not line or line.startswith(';'):
            continue

        def _add(s):
            cur_bytes.extend(_encode(s, charmap))

        m = re.match(r'text\s+"(.*)"', line)
        if m:
            cur_bytes.append(TX_START); _add(m.group(1)); continue
        m = re.match(r'line\s+"(.*)"', line)
        if m:
            cur_bytes.append(CHAR_LINE); _add(m.group(1)); continue
        m = re.match(r'next\s+"(.*)"', line)
        if m:
            cur_bytes.append(0x4E); _add(m.group(1)); continue
        m = re.match(r'para\s+"(.*)"', line)
        if m:
            cur_bytes.append(CHAR_PARA); _add(m.group(1)); continue
        m = re.match(r'cont\s+"(.*)"', line)
        if m:
            cur_bytes.append(CHAR_CONT); _add(m.group(1)); continue
        if line == 'prompt':
            cur_bytes.append(0x58); continue
        if line == 'done':
            cur_bytes.extend([CHAR_DONE, TX_END])
            entries[cur_label] = bytes(cur_bytes)
            cur_label = None; cur_bytes = []; continue
        if line == 'text_end':
            cur_bytes.append(TX_END)
            entries[cur_label] = bytes(cur_bytes)
            cur_label = None; cur_bytes = []; continue

    if cur_label is not None and cur_bytes:
        entries[cur_label] = bytes(cur_bytes)
    return entries

# ---------------------------------------------------------------------------
# scripts/<Map>.asm — TextPointers table
# ---------------------------------------------------------------------------

def _parse_text_pointers(path: Path, map_pascal: str) -> list:
    target = f"{map_pascal}_TextPointers:"
    in_table = False
    result = []
    for line in path.read_text(encoding='utf-8').splitlines():
        s = line.strip()
        if s == target:
            in_table = True; continue
        if not in_table:
            continue
        if not s or s.startswith(';') or s == 'def_text_pointers':
            continue
        m = re.match(r'dw_const\s+(\w+)', s)
        if m:
            result.append(m.group(1))
        else:
            break
    return result

def _resolve_local_label(path: Path, label: str) -> str | None:
    """Find text_far _FarLabel under `label:` in scripts file, or None."""
    in_label = False
    for line in path.read_text(encoding='utf-8').splitlines():
        s = line.strip()
        if re.match(rf'{re.escape(label)}\s*:', s):
            in_label = True; continue
        if not in_label:
            continue
        if re.match(r'[A-Z]\w+:', s):
            break
        m = re.match(r'text_far\s+(_\w+)', s)
        if m:
            return m.group(1)
    return None

# ---------------------------------------------------------------------------
# data/maps/objects/<Map>.asm — NPC entries
# ---------------------------------------------------------------------------

def _read_npc_entries(path: Path) -> list:
    """Return list of {is_trainer, is_item} dicts for each object_event."""
    result = []
    for line in path.read_text(encoding='utf-8').splitlines():
        m = re.match(r'\s*object_event\s+(.+)', line)
        if m:
            # Strip inline comment, split on commas
            args_str = re.sub(r';.*', '', m.group(1))
            args = [a.strip() for a in args_str.split(',') if a.strip()]
            is_trainer = len(args) >= 8
            is_item    = len(args) == 7
            result.append({'is_trainer': is_trainer, 'is_item': is_item})
    return result

def _count_npcs(path: Path) -> int:
    """Count const_export lines in the object_const_def block."""
    in_block = False
    count = 0
    for line in path.read_text(encoding='utf-8').splitlines():
        s = line.strip()
        if s == 'object_const_def':
            in_block = True; continue
        if not in_block:
            continue
        if s.startswith('const_export'):
            count += 1
        elif s and not s.startswith(';'):
            break
    return count

# ---------------------------------------------------------------------------
# NASM helpers
# ---------------------------------------------------------------------------

def _bytes_to_nasm(data: bytes, indent: str = '    ') -> str:
    lines = []
    for i in range(0, len(data), 16):
        chunk = data[i:i+16]
        row = ', '.join(f'0x{b:02X}' for b in chunk)
        lines.append(f'{indent}db {row}')
    return '\n'.join(lines)

# ---------------------------------------------------------------------------
# Per-map generation
# ---------------------------------------------------------------------------

def generate_map(map_id: int, const: str, label: str, charmap: list,
                 text_db_cache: dict) -> tuple | None:
    """Generate dialog for one map.

    `label` is the map-header label (e.g. "RedsHouse1F") — correctly cased, so it
    matches the data/maps/objects, scripts/ and text/ filenames (const_to_pascal
    mangles floor suffixes like "1F"→"1f", which silently dropped ~87 maps).

    Returns (table_label, out_path) if any NPCs exist, else None.
    Emits exactly one table entry per object_event slot (stub where the text can't
    be resolved) so the table is never shorter than the map-object binary's sprite
    count — otherwise text_id (= slot index) can index past the table and fault.
    """
    map_snake  = const.lower()
    table_label = f"{label}TextTable"

    scripts_path = ROOT / "scripts" / f"{label}.asm"
    text_path    = ROOT / "text"    / f"{label}.asm"

    # Authoritative NPC list: identical parse to gen_map_headers (same _DEBUG
    # stripping + object_event order + trainer/item flags) → table stays in sync.
    parsed = gmh.parse_object_file(label)
    if parsed is None:
        return None
    _border, _warps, _sign_count, sprites = parsed
    npc_count = len(sprites)
    if npc_count == 0:
        return None

    # Need text pointers from scripts
    if not scripts_path.exists():
        print(f"[dialogs] {const}: no scripts file — emitting {npc_count} stubs",
              file=sys.stderr)
        pointers = []
    else:
        pointers = _parse_text_pointers(scripts_path, label)

    # Always emit one entry per sprite slot; slots beyond the resolvable text
    # pointers fall back to a stub (local_label = None below).
    npc_count_eff = npc_count

    # Lazy-load text db for this map
    text_db = {}
    if text_path.exists() and text_path not in text_db_cache:
        try:
            text_db_cache[text_path] = _parse_text_file(text_path, charmap)
        except Exception as e:
            print(f"[dialogs] {const}: text parse error: {e}", file=sys.stderr)
            text_db_cache[text_path] = {}
    text_db = text_db_cache.get(text_path, {})

    # Resolve each slot
    npc_entries = []
    for i in range(npc_count_eff):
        is_trainer = sprites[i].get('is_trainer', False)
        is_item    = sprites[i].get('is_item', False)

        if i < len(pointers):
            local_label = pointers[i]
        else:
            local_label = None

        # Build NASM label: always include slot index i to guarantee uniqueness
        # (two NPCs can share the same text pointer, which would produce duplicate labels).
        if local_label:
            suffix = local_label
            if suffix.startswith(label):
                suffix = suffix[len(label):]
            if suffix.endswith('Text'):
                suffix = suffix[:-4]
            snake_suffix = re.sub(r'(?<=[a-z0-9])(?=[A-Z])', '_', suffix).lower()
            nasm_label = f"{map_snake}_{snake_suffix}_{i}_text"
        else:
            nasm_label = f"{map_snake}_npc{i}_text"

        # Hand-written text_asm script override? Emit a SCRIPT entry (flat routine
        # pointer + sentinel size) instead of a static byte stream.
        script_label = SCRIPT_OVERRIDES.get(local_label) if local_label else None
        if script_label:
            npc_entries.append((nasm_label, None, script_label))
            continue

        # Resolve text bytes
        if is_trainer:
            # Try to resolve the actual pre-battle text; fall back to stub
            data = _TRAINER_STUB
            if local_label and scripts_path.exists():
                far = _resolve_local_label(scripts_path, local_label)
                if far and far in text_db:
                    data = text_db[far]
        elif is_item:
            data = _SCRIPT_STUB
        else:
            data = None
            if local_label and scripts_path.exists():
                far = _resolve_local_label(scripts_path, local_label)
                if far is None:
                    # text_asm script NPC: the script does `farcall <PrintFunc>`
                    # instead of `text_far _X`, so there is no direct far label.
                    # Most single-line NPCs follow the convention that the real
                    # text label is just the script label with a '_' prefix
                    # (e.g. ViridianCityYoungster1Text -> _ViridianCityYoungster1Text).
                    # Resolve that exact match when it exists — it can only help
                    # (no match => unchanged stub). NPCs whose print function
                    # branches on game state (e.g. ViridianCityGambler1Text ->
                    # _ViridianCityGambler1GymAlwaysClosedText / ...ReturnedText)
                    # have no single static string and correctly stay stubs until
                    # the script engine lands.
                    cand = '_' + local_label
                    if cand in text_db:
                        data = text_db[cand]
                    else:
                        data = _SCRIPT_STUB
                        print(f"[dialogs] {const}[{i}] {local_label}: "
                              f"text_asm script NPC — emitting stub", file=sys.stderr)
                elif far not in text_db:
                    data = _SCRIPT_STUB
                    print(f"[dialogs] {const}[{i}] {local_label}: "
                          f"far label {far!r} not found — emitting stub", file=sys.stderr)
                else:
                    data = text_db[far]
            if data is None:
                data = _SCRIPT_STUB

        npc_entries.append((nasm_label, data, None))

    # Emit NASM include file
    out_path = DIALOGS_DIR / f"{map_snake}_dialogs.inc"
    script_externs = [s for _, _, s in npc_entries if s]
    lines = [
        f"; {out_path.name} — generated by tools/gen_npc_dialogs.py. DO NOT EDIT BY HAND.",
        f"; Map: {const} (id=0x{map_id:02X}), {len(npc_entries)} NPC slot(s).",
        f"; Source: text/{label}.asm + scripts/{label}.asm",
        f";",
        f"; section .data so labels never land in an orphaned section.",
        f"",
    ]
    for s in script_externs:
        lines.append(f"extern {s}   ; hand-written text_asm script")
    if script_externs:
        lines.append("")
    lines += ["section .data", ""]
    for nasm_label, data, script_label in npc_entries:
        if script_label:
            continue   # SCRIPT slots reference the extern routine, no data stream
        lines.append(f"{nasm_label}:")
        lines.append(_bytes_to_nasm(data))
        lines.append(f"{nasm_label}_end:")
        lines.append("")
    lines.append(f"{table_label}:")
    for nasm_label, _data, script_label in npc_entries:
        if script_label:
            lines.append(f"    dd {script_label}, 0xFFFFFFFF  ; SCRIPT (text_asm)")
        else:
            lines.append(f"    dd {nasm_label}, {nasm_label}_end - {nasm_label}")
    lines.append("    dd 0, 0  ; sentinel")
    lines.append("")
    out_path.write_text('\n'.join(lines), encoding='utf-8')
    return (table_label, out_path)

# ---------------------------------------------------------------------------
# Master all_dialogs.inc
# ---------------------------------------------------------------------------

def generate_all() -> None:
    DIALOGS_DIR.mkdir(parents=True, exist_ok=True)

    charmap = _load_charmap(ROOT / 'constants' / 'charmap.asm')
    all_maps = parse_map_constants()
    max_id   = max(mid for mid, _, _ in all_maps)

    # const → map-header label (correctly cased; handles floor suffixes that
    # const_to_pascal mangles). Source of truth shared with gen_map_headers.
    const_to_label, _ = gmh.parse_all_headers()

    # {map_id: table_label} for maps with NPCs
    map_table: dict = {}
    text_db_cache: dict = {}

    for mid, const, pascal in all_maps:
        label = const_to_label.get(const)
        if label is None:
            continue   # map has no header (should not happen for real maps)
        result = generate_map(mid, const, label, charmap, text_db_cache)
        if result is not None:
            table_label, out_path = result
            map_table[mid] = table_label
            print(f"  wrote {out_path.relative_to(ROOT)}")

    # Emit all_dialogs.inc
    all_path = DIALOGS_DIR / "all_dialogs.inc"
    lines = [
        "; all_dialogs.inc — generated by tools/gen_npc_dialogs.py. DO NOT EDIT BY HAND.",
        "; Includes all per-map dialog tables and defines MapTextTablePointers.",
        "; %included from map_sprites.asm in section .data.",
        "",
    ]

    for mid, const, pascal in all_maps:
        if mid in map_table:
            snake = const.lower()
            lines.append(f'%include "assets/npc_dialogs/{snake}_dialogs.inc"')

    lines += [
        "",
        f"; MapTextTablePointers — flat dd array indexed by map_id (0x00..0x{max_id:02X}).",
        f"; Entry is a flat pointer to the map's TextTable, or 0 if no NPCs.",
        "MapTextTablePointers:",
    ]
    for i in range(max_id + 1):
        # Find if any map uses this id
        label = map_table.get(i)
        if label:
            # Look up the const name for the comment
            const_for_id = next((c for mid, c, _ in all_maps if mid == i), f"0x{i:02X}")
            lines.append(f"    dd {label}  ; 0x{i:02X} {const_for_id}")
        else:
            lines.append(f"    dd 0  ; 0x{i:02X} (no NPCs)")
    lines.append("")

    all_path.write_text('\n'.join(lines), encoding='utf-8')
    print(f"  wrote {all_path.relative_to(ROOT)} "
          f"({len(map_table)} maps with NPCs, {max_id+1} table entries)")

# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

if __name__ == '__main__':
    generate_all()
