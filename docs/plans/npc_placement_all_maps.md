# Plan: Programmatic NPC Placement — All Maps + Trainer Encounter Stub

## Context

Pallet Town's 3 NPCs (Oak, Girl, Fisher) are fully working end-to-end: binary blob via
`gen_map_headers.py`, sprite tiles in `assets/npc_*.inc`, dialog text in
`assets/npc_dialogs_pallet_town.inc`, and `CheckNPCInteraction` hardwired to
`PalletTownTextTable`. All other maps have NPC object data already embedded in
`map_headers.inc` (the generator reads all 224 `.asm` files), but they have no sprite
includes, no dialog includes, and no dispatch to their text tables. This plan delivers:

1. Sprite tile includes for every unique sprite ID used across all maps (auto-generated).
2. Dialog text tables for every map with NPCs (auto-generated).
3. A per-map text table dispatch so `CheckNPCInteraction` works on any map.
4. A trainer encounter stub: sight detection → `!` bubble → walk-up → pre-battle text →
   skip battle → mark beaten, so trainer flow is playable before the battle engine exists.

---

## Stage 1 — Extend sprite generators to all sprites

**Files: `dos_port/tools/gen_all_assets.py` and `dos_port/tools/gen_overworld_assets.py`**

Both tools have a hardcoded 3-entry list `[(label, fname, base_offset), ...]`. Replace it
with a dynamic enumeration.

Shared sprite enumeration logic (used by both generators):
- Parse `constants/sprite_constants.asm` → `{SPRITE_FOO: id}` mapping.
- Scan every `data/maps/objects/*.asm` file for `object_event` lines; collect the
  `SPRITE_*` token from field 3. Build a set of unique sprite IDs used across all maps.
- Derive the 2bpp filename: strip `SPRITE_` prefix, lowercase
  (`SPRITE_COOLTRAINER_F` → `cooltrainer_f`, `SPRITE_BALDING_GUY` → `balding_guy`).
- Manual override dict for edge cases:
  - `SPRITE_GAMBLER_ASLEEP` → `gambler.2bpp` (reuses same sheet, different start frame)
  - `SPRITE_UNUSED_RED_1/2/3` → `None` (emit `dd 0` in table)
- Log a warning for any sprite where `gfx/sprites/<stem>.2bpp` is missing.

### 1a. `gen_all_assets.py` — full 24-tile sprite sheets

- [x] Replace hardcoded 3-entry NPC list with dynamic sprite enumeration.
- [x] For each used sprite: emit `assets/npc_sprites/<stem>.inc`
      (label `npc_<stem>:`, 24 tiles = full 2bpp sheet).
- [x] Emit `assets/npc_sprite_data_table.inc`:
      - `%include` each per-sprite `.inc` file.
      - `npc_sprite_data_table:` with one `dd` per sprite ID (0x00–0x52), `dd 0` for absent.

### 1b. `gen_overworld_assets.py` — 12-tile still subsets

**SUPERSEDED**: `npc_*_still.inc` files were dead code — `LoadNPCSpriteTiles` reads both
still and walk halves directly from the full 384-byte sheet. No `_still` table needed.

### 1c. Update `map_sprites.asm` — sprite data table

- [x] Replaced 3 hardcoded sprite includes with `%include "assets/npc_sprite_data_table.inc"`.
- [x] Updated `LoadNPCSpriteTiles`: flat table lookup by sprite_id, bounds-check, skip if 0.

### 1d. Update `overworld.asm` — still sprite table

- [x] Removed dead `npc_*_still.inc` includes; all sprite loading via full-sheet table.

---

## Stage 2 — Extend `gen_npc_dialogs.py` to all maps

**File: `dos_port/tools/gen_npc_dialogs.py`**

- [x] Load the ordered `(map_id, MapPascalName)` list from `constants/map_constants.asm`.
- [x] For each map: parse `data/maps/objects/` + `scripts/` for NPC entries and text pointers.
- [x] Trainer/script/item NPCs get appropriate stubs; normal NPCs get charmap-encoded text.
- [x] Emit `assets/npc_dialogs/<map_snake>_dialogs.inc` per map (137 maps with NPCs).
- [x] Emit `assets/npc_dialogs/all_dialogs.inc` with `MapTextTablePointers` (249 entries).
- [x] Fixed label collisions: slot index `i` appended to all labels to ensure uniqueness.

---

## Stage 3 — Per-map text table dispatch

**Files: `map_sprites.asm`, `overworld.asm`**

- [x] `w_map_text_table_ptr: resd 1` in `map_sprites.asm` BSS; exported as `global`.
- [x] Dispatch in `LoadMapData` (initial load) and `.mapTransition` and `.warpTransition`
      in `overworld.asm`: `MapTextTablePointers[W_CUR_MAP*4] → w_map_text_table_ptr`.
- [x] `CheckNPCInteraction`: null-pointer guard + uses `[w_map_text_table_ptr]` not
      hardcoded `PalletTownTextTable`.
- [x] `%include "assets/npc_dialogs/all_dialogs.inc"` replaces old pallet-town-only include.
- [x] `extern MapTextTablePointers` / `extern w_map_text_table_ptr` added to `overworld.asm`.
- [x] Full build verified: `make clean && make SKIP_TITLE=1` → `Built: PKMN.EXE`.

---

## Stage 4 — Trainer encounter stub

**Files: `map_sprites.asm`, `overworld.asm`**

### 4a. New BSS state

- [x] `npc_beaten_flags: resw 1`, `w_trainer_enc_slot: resb 1`, `w_player_frozen: resb 1`
      added to BSS in `map_sprites.asm` with `; TODO-GLOBAL-EVENTS` comment.
- [x] `InitMapSprites` resets all three on every map load.

### 4b. `CheckTrainerSight` subroutine

- [x] Scans slots 1-15; skips inactive, non-trainer, and beaten slots.
- [x] Sight check: FACINGDIRECTION-based LOS (all 4 directions), distance ≤ 4 blocks,
      using `bt word [npc_beaten_flags], dx` for the beaten test.
- [x] Sets `w_trainer_enc_slot = esi & 0xFF`, returns CF=1 if found.
- [x] `OverworldLoop` calls `CheckTrainerSight` before joypad read; CF=1 → `TrainerEncounterFlow`.

### 4c. `TrainerEncounterFlow` subroutine

- [x] Sets `w_player_frozen = 1`.
- [x] ~45-frame freeze (TODO: add `!` bubble over trainer head).
- [x] `MakeNPCFacePlayer` + freeze NPC movement flag.
- [x] Pre-battle text via shared `npc_dialog_wait_impl` helper.
- [x] Marks beaten via `bts word [npc_beaten_flags], dx`.
- [x] Clears `w_trainer_enc_slot = 0xFF`, `w_player_frozen = 0`.

### 4d. Gate beaten trainers

- [x] `CheckNPCInteraction` at `.found_npc`: if ISTRAINER=1 and beaten bit set → `jmp .not_found`.

---

## Stage 5 — Build system wiring

**File: `dos_port/Makefile`**

- [x] `assets/npc_sprite_data_table.inc` target → `python3 tools/gen_all_assets.py`.
- [x] `assets/npc_dialogs/all_dialogs.inc` target → `python3 tools/gen_npc_dialogs.py`.
- [x] `map_sprites.o` dependency updated to new generated targets.
- [x] `assets:` phony target updated to include both new generated files.
- [x] `make clean && make SKIP_TITLE=1` → `Built: PKMN.EXE` — clean build verified.

---

## Verification checklist

- [ ] Pallet Town regression: Oak / Girl / Fisher dialog still works after all changes.
- [ ] New map smoke-test: add a temporary `DEBUG_WARP` to Viridian City; walk to a
      Youngster, press A → Youngster's dialog renders correctly.
- [ ] Trainer encounter on Route 1: walk into line-of-sight of a Youngster trainer →
      `!` appears → trainer walks to player → "TRAINER!" stub text shows → trainer
      marked beaten → re-entering Youngster's line-of-sight does NOT re-trigger.
- [ ] Map warp reset: warp to another map and back → trainer can be triggered again
      (expected given per-map-load simplification; confirm via `; TODO-GLOBAL-EVENTS`).
- [ ] Assembly unit check:
      ```sh
      nasm -f coff -o /dev/null dos_port/src/engine/overworld/map_sprites.asm
      nasm -f coff -o /dev/null dos_port/src/engine/overworld/overworld.asm
      ```

---

## Files created / modified

### New (generated — never hand-edit)
- `dos_port/assets/npc_sprites/<stem>.inc` — full 24-tile sheet per sprite
- `dos_port/assets/npc_sprites/<stem>_still.inc` — 12-tile still subset per sprite
- `dos_port/assets/npc_sprite_data_table.inc` — pointer table indexed by sprite_id
- `dos_port/assets/npc_still_sprite_data_table.inc` — still pointer table
- `dos_port/assets/npc_dialogs/<mapname>_dialogs.inc` — dialog table per map
- `dos_port/assets/npc_dialogs/all_dialogs.inc` — master include + `MapTextTablePointers`

### Modified (tools)
- `dos_port/tools/gen_all_assets.py`
- `dos_port/tools/gen_overworld_assets.py`
- `dos_port/tools/gen_npc_dialogs.py`

### Modified (asm)
- `dos_port/src/engine/overworld/map_sprites.asm`
- `dos_port/src/engine/overworld/overworld.asm`
- `dos_port/Makefile`
