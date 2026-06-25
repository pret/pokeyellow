#!/usr/bin/env python3
"""Generate the toggleable-object (event) flag tables for NPC spawn gating.

Pokeyellow's "toggleable objects" (pret's missable objects) are NPCs / items that
are hidden or shown based on game events.  Each has a default state (OFF = hidden,
ON = shown) in data/maps/toggleable_objects.asm.  At new game the engine seeds a
global flag bit array from those defaults (OFF -> flag set -> hidden); scripts then
toggle bits as events happen.  Until the script engine exists, the DOS port still
honours the *defaults* so default-hidden NPCs (e.g. Oak standing in Pallet Town)
do not spawn.

Outputs assets/toggleable_objects.inc (section .data):
  TOGGLEABLE_COUNT       equ N          ; number of toggleable objects (global)
  TOGGLEABLE_FLAG_BYTES  equ ceil(N/8)
  toggleable_default_flags:             ; bit g set => object g hidden by default
  toggle_list_<mapsnake>:               ; db runtime_slot, global_index ... db 0xFF
  ToggleableMapPointers:                ; dd per map id -> list ptr (0 = none)

Runtime mapping note: the global index g is the object's position in the flat
ToggleableObjectStates list (pret order).  runtime_slot is the NPC's slot index as
the DOS port sees it — the position in the _DEBUG-stripped object_event list, which
matches the text_id the map-object binary stores (gen_map_headers).  For the two
maps where a _DEBUG object_event shifts indices (Saffron City, Silph Co 7F) we map
the object-const index through the stripped list so the right slot is gated.

Run from dos_port/ or repo root:
    python3 tools/gen_toggleable_objects.py
"""
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import gen_map_headers as gmh

ROOT   = Path(__file__).resolve().parent.parent.parent
ASSETS = ROOT / "dos_port" / "assets"
TOGGLE_FILE = ROOT / "data" / "maps" / "toggleable_objects.asm"

OFF_TOKEN = "OFF"   # constants/toggle_constants.asm: OFF=$11 (hidden), ON=$15 (shown)


def parse_object_consts(label: str) -> dict:
    """Return {CONST_NAME: index} for a map's object_const_def block (file order)."""
    f = ROOT / "data" / "maps" / "objects" / f"{label}.asm"
    if not f.exists():
        return {}
    consts = {}
    in_block = False
    idx = 0
    for line in f.read_text().splitlines():
        s = line.strip()
        if s == "object_const_def":
            in_block = True
            continue
        if not in_block:
            continue
        m = re.match(r"const_export\s+(\w+)", s)
        if m:
            consts[m.group(1)] = idx
            idx += 1
        elif s and not s.startswith(";") and "def_object_events" not in s:
            break
    return consts


def object_event_survival(label: str) -> list:
    """Return a list (file order) of bools: does object_event[k] survive _DEBUG
    stripping?  Mirrors gen_map_headers.strip_debug_blocks' depth tracking so the
    surviving order matches the runtime slot order."""
    f = ROOT / "data" / "maps" / "objects" / f"{label}.asm"
    if not f.exists():
        return []
    survival = []
    depth = 0
    debug_depth = None
    for line in f.read_text().splitlines():
        stripped = line.strip().upper()
        if stripped.startswith("IF DEF(_DEBUG)"):
            if debug_depth is None:
                debug_depth = depth
            depth += 1
            continue
        elif stripped == "IF" or stripped.startswith("IF "):
            depth += 1
        elif stripped == "ENDC":
            if depth > 0:
                depth -= 1
            if debug_depth is not None and depth < debug_depth:
                debug_depth = None
            continue
        if re.match(r"OBJECT_EVENT\b", stripped):
            survival.append(debug_depth is None)
    return survival


def runtime_slot_for(survival: list, k: int):
    """Map object-const index k (file order) to the _DEBUG-stripped slot index, or
    None if that object_event was stripped (no runtime slot)."""
    if k >= len(survival):
        return None
    if not survival[k]:
        return None
    return sum(1 for s in survival[:k] if s)


def parse_toggleables():
    """Parse data/maps/toggleable_objects.asm.

    Returns (objects, max_map_id) where objects is a list of dicts in global-index
    order: {map_const, obj_const, off (bool), global_index}.
    """
    objects = []
    cur_map = None
    g = 0
    for line in TOGGLE_FILE.read_text().splitlines():
        s = line.strip()
        m = re.match(r"toggleable_objects_for\s+(\w+)", s)
        if m:
            cur_map = m.group(1)
            continue
        m = re.match(r"toggle_object_state\s+(\w+),\s*(\w+)", s)
        if m:
            objects.append({
                "map_const": cur_map,
                "obj_const": m.group(1),
                "off": (m.group(2).strip() == OFF_TOKEN),
                "global_index": g,
            })
            g += 1
    return objects


def generate_all():
    objects = parse_toggleables()
    n = len(objects)
    flag_bytes = (n + 7) // 8

    map_info = gmh.parse_map_constants()              # {const: (id, w, h)}
    const_to_label, _ = gmh.parse_all_headers()
    max_map_id = max(mid for mid, _, _ in map_info.values())

    # Default-hidden bitmap (bit g set => OFF => hidden).
    bitmap = bytearray(flag_bytes)
    for o in objects:
        if o["off"]:
            bitmap[o["global_index"] >> 3] |= 1 << (o["global_index"] & 7)

    # Per-map list of (runtime_slot, global_index), keyed by map id.
    per_map: dict = {}          # map_id -> list of (slot, g)
    label_cache_consts: dict = {}
    label_cache_surv: dict = {}
    warnings = []
    for o in objects:
        mc = o["map_const"]
        if mc not in map_info:
            warnings.append(f"unknown map const {mc}")
            continue
        map_id = map_info[mc][0]
        label = const_to_label.get(mc)
        if label is None:
            warnings.append(f"no header label for {mc}")
            continue
        if label not in label_cache_consts:
            label_cache_consts[label] = parse_object_consts(label)
            label_cache_surv[label] = object_event_survival(label)
        consts = label_cache_consts[label]
        surv = label_cache_surv[label]
        k = consts.get(o["obj_const"])
        if k is None:
            warnings.append(f"{mc}: const {o['obj_const']} not in object block")
            continue
        slot = runtime_slot_for(surv, k)
        if slot is None:
            # object_event stripped at build time — no runtime slot to gate
            continue
        per_map.setdefault(map_id, []).append((slot, o["global_index"]))

    # Emit
    lines = [
        "; toggleable_objects.inc — generated by tools/gen_toggleable_objects.py. DO NOT EDIT BY HAND.",
        "; Toggleable-object (event) flags for NPC spawn gating. See the generator header.",
        "; %included from map_sprites.asm in section .data.",
        "",
        "section .data",
        "",
        f"TOGGLEABLE_COUNT      equ {n}",
        f"TOGGLEABLE_FLAG_BYTES equ {flag_bytes}",
        "",
        "; Default-hidden bitmap: bit g (LSB-first) set => object g hidden at new game.",
        "toggleable_default_flags:",
    ]
    for i in range(0, flag_bytes, 16):
        chunk = bitmap[i:i+16]
        lines.append("    db " + ", ".join(f"0x{b:02X}" for b in chunk))
    lines.append("")

    # Per-map lists
    id_to_const = {mid: c for c, (mid, _, _) in map_info.items()}
    for map_id in sorted(per_map):
        const = id_to_const.get(map_id, f"MAP_{map_id:02X}")
        snake = const.lower()
        lines.append(f"toggle_list_{snake}:  ; {const}")
        body = "".join(f"    db {slot}, {g}\n" for slot, g in per_map[map_id])
        lines.append(body + "    db 0xFF")
        lines.append("")

    # Map pointer table (indexed by map id)
    lines.append("; ToggleableMapPointers — flat dd array indexed by map_id; 0 if no toggleables.")
    lines.append("ToggleableMapPointers:")
    for map_id in range(max_map_id + 1):
        if map_id in per_map:
            const = id_to_const.get(map_id, f"MAP_{map_id:02X}")
            lines.append(f"    dd toggle_list_{const.lower()}  ; 0x{map_id:02X} {const}")
        else:
            lines.append(f"    dd 0  ; 0x{map_id:02X}")
    lines.append("")

    out = ASSETS / "toggleable_objects.inc"
    out.write_text("\n".join(lines))
    for w in warnings:
        print(f"[toggleable] WARNING: {w}", file=sys.stderr)
    print(f"  wrote {out.relative_to(ROOT)} "
          f"({n} toggleable objects, {flag_bytes} flag bytes, "
          f"{len(per_map)} maps gated)")


if __name__ == "__main__":
    generate_all()
