# Pokemon Yellow Nuzlocke - Dev Notes

## Project Overview

ROM hack of Pokemon Yellow (Game Boy Assembly / RGBDS) that enforces Nuzlocke rules.
Built with `make` → outputs `pokeyellow.gbc`.

Toolchain requirement: RGBDS v1.0.1 (see `.rgbds-version`).

## Architecture

| Directory | Purpose |
|-----------|---------|
| `engine/` | Core game logic (battle, menus, overworld, items, events) |
| `data/` | Pokemon stats, moves, items, wild encounters, trainers |
| `gfx/` | Sprites and tilesets |
| `audio/` | Music and SFX |
| `maps/` / `scripts/` | Map data and in-game events |
| `constants/` | Shared constant definitions |
| `ram/wram.asm` | WRAM layout — all global variables |
| `home/` | Home bank code (always-loaded routines) |

Main entry: `main.asm` → `home.asm` → `engine/`

---

## In-Progress: Nuzloptions Randomiser Menu

### What's Done

The Nuzloptions screen is wired into the main menu and fully functional as a UI:

- **Main menu text** (`engine/menus/main_menu.asm:193`): "NUZLOPTIONS" added as 4th menu item
- **Menu routing** (`main_menu.asm:88`): `cp 3` → `call DisplayNuzloptionsMenu`
- **Full menu UI** implemented:
  - `InitNuzloptionsMenu` — draws border, labels, initial ON/OFF values
  - `NuzloptionsControl` — D-pad UP/DOWN moves cursor between options
  - `NuzloptionsMenu_UpdateSelectedOption` — LEFT/RIGHT toggles ON/OFF
  - `NuzloptionsMenu_UpdateCursorPosition` — draws `▶` cursor
  - `DisplayNuzloptionsMenu` — main loop, exits on START/B (CANCEL)
- **Two options displayed**:
  - Row 2: `ALL POKEMON:` (ON/OFF)
  - Row 4: `RANDOMISE  :` (ON/OFF)
  - Row 16: `CANCEL` (press B or START)

### Flags & Constants

Flags stored as bits in `wUnusedObtainedBadges` (1 byte, reusing a spare WRAM slot):

```
constants/ram_constants.asm:
  BIT_NUZLOPTIONS_ALL_151_POKEMON = 0
  BIT_NUZLOPTIONS_RANDOMISE       = 1
```

Bit manipulation in menu (`main_menu.asm:216-232`):
```asm
ld b, 1 << BIT_NUZLOPTIONS_RANDOMISE   ; or BIT_NUZLOPTIONS_ALL_151_POKEMON
ld hl, wUnusedObtainedBadges
ld a, [hl]
xor b       ; toggle the bit
ld [hl], a
```

### Known Issues / Inconsistencies

1. **Orphaned WRAM labels** (`ram/wram.asm:1943-1945`): Three labels were defined but are
   never written to by the menu — the menu uses `wUnusedObtainedBadges` + `wOptionsCursorLocation`
   instead:
   ```
   wNuzloptionsAll151Pokemon:: db   ← never used
   wNuzloptionsRandomise:: db       ← never used
   wNuzloptionsCursorLocation:: db  ← never used (menu uses wOptionsCursorLocation)
   ```
   These should either be removed or the menu repointed to use them.

2. **Not saved to SRAM**: `wUnusedObtainedBadges` is not included in save/load routines.
   Options reset to OFF every time the game boots. Needs wiring into the save block.

3. **No game logic hooked up yet**: Neither flag is read anywhere outside `main_menu.asm`.
   The menu sets the flags but nothing acts on them.

---

## Next Steps (Suggested Order)

### 1. Clean up WRAM (quick)
Either remove the orphaned labels (`wNuzloptionsAll151Pokemon`, etc.) or switch the menu
to use them directly instead of bit-packing into `wUnusedObtainedBadges`.

Using separate bytes is simpler to read in game logic:
```asm
ld a, [wNuzloptionsRandomise]
and a
jr z, .notRandomised
```

### 2. Persist settings across saves
Wire `wNuzloptionsRandomise` and `wNuzloptionsAll151Pokemon` (or `wUnusedObtainedBadges`)
into the SRAM save/load block so the options survive a power cycle.

Look at how `wOptions` is saved — it lives at `wram.asm:1942`, one byte before the
nuzloptions vars, so they should be nearby in the save block.

### 3. Implement RANDOMISE flag

The wild encounter picker is in `engine/battle/wild_encounters.asm`.
The slot is chosen by comparing `hRandomSub` against `WildMonEncounterSlotChances`.
After the slot is determined, the species ID is read from the route's wild data table.

**Hook point**: After the encounter slot is decided and the species loaded, intercept
and replace with a random species (1–151) when `BIT_NUZLOPTIONS_RANDOMISE` is set.

Rough approach:
```asm
; after species is loaded into register
ld a, [wNuzloptionsRandomise]   ; or check bit in wUnusedObtainedBadges
and a
jr z, .notRandomised
; pick a random species 1-151
call Random          ; home/random.asm — result in hRandomAdd
ldh a, [hRandomAdd]
; map to 1-151 range, store as species
```

`home/random.asm` and `engine/math/random.asm` contain the RNG routines.

### 4. Implement ALL POKEMON flag

The Nuzlocke catch restriction (one catch per route) is in the nuzlocke engine logic.
When `BIT_NUZLOPTIONS_ALL_151_POKEMON` is set, skip the one-per-route restriction so
all 151 can be caught normally.

Also consider: the original Yellow has version-exclusive Pokemon — this flag could
unlock those too (trade evolutions, etc.).

### 5. Trainer randomiser (stretch goal)
Extend the RANDOMISE flag (or add a new option) to also randomise trainer Pokemon teams.
Trainer data is in `data/trainers/`.

---

## Key Files for Randomiser Work

| File | Relevance |
|------|-----------|
| `engine/menus/main_menu.asm` | Nuzloptions menu (complete) |
| `engine/battle/wild_encounters.asm` | Wild Pokemon slot selection — hook randomiser here |
| `engine/battle/init_battle.asm` | Battle initialisation, species assignment |
| `home/random.asm` | RNG routines (`hRandomAdd`, `hRandomSub`) |
| `engine/math/random.asm` | Additional math/RNG helpers |
| `ram/wram.asm:1942` | `wOptions`, `wNuzloptionsRandomise`, `wUnusedObtainedBadges` |
| `constants/ram_constants.asm:51` | `BIT_NUZLOPTIONS_*` constants |
| `data/wild/` | Wild encounter tables per route |
| `data/trainers/` | Trainer team data |
