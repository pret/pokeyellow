# Skill: path-map

Correct/wrong path table for placing translated files.

## Rule

`dos_port/src/` output path = `dos_port/src/` + pret source path verbatim.
Never drop prefix segments. Never rename directories.

## Correct Examples

| Pret source | dos_port/src/ destination |
|---|---|
| `engine/battle/experience.asm` | `dos_port/src/engine/battle/experience.asm` |
| `engine/math/bcd.asm` | `dos_port/src/engine/math/bcd.asm` |
| `engine/math/multiply_divide.asm` | `dos_port/src/engine/math/multiply_divide.asm` |
| `engine/pokemon/bills_pc.asm` | `dos_port/src/engine/pokemon/bills_pc.asm` |
| `engine/items/inventory.asm` | `dos_port/src/engine/items/inventory.asm` |
| `engine/items/get_bag_item_quantity.asm` | `dos_port/src/engine/items/get_bag_item_quantity.asm` |
| `engine/slots/slot_machine.asm` | `dos_port/src/engine/slots/slot_machine.asm` |
| `engine/debug/debug_party.asm` | `dos_port/src/engine/debug/debug_party.asm` |
| `home/math.asm` | `dos_port/src/home/math.asm` |
| `home/copy2.asm` | `dos_port/src/home/copy2.asm` |

## Wrong (DO NOT USE)

| Pret source | Wrong path |
|---|---|
| `engine/math/bcd.asm` | `dos_port/src/util/bcd.asm` ← drops engine/, renames |
| `engine/math/multiply_divide.asm` | `dos_port/src/util/multiply_divide.asm` |
| `engine/pokemon/bills_pc.asm` | `dos_port/src/pokemon/bills_pc.asm` ← drops engine/ |
| `engine/items/inventory.asm` | `dos_port/src/items/inventory.asm` ← drops engine/ |
| `engine/slots/slot_machine.asm` | `dos_port/src/slots/slot_machine.asm` |
| `engine/debug/debug_party.asm` | `dos_port/src/debug/debug_party.asm` |
| `home/copy2.asm` | `dos_port/src/home/copy.asm` ← wrong filename |

## Exception

Manually-written Claude Code files may use different names. These are listed in
`dos_port/tools/build_index` in `VERIFIED_MAP` and are not governed by this rule.
