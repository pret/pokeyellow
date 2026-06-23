# Plan: NPC Implementation — Standard (non-trainer) + Trainer Stub

**Status (2026-06-23):** Stages 1–4 complete. All "Deferred to Phase 3" items below are
now also done except the three listed as OPEN. Remaining deferred work is in the section
at the bottom.

## Context

The sprite engine is ~80% complete. `PrepareOAMData`, `UpdateNonPlayerSprite` (STAY path),
and `DetectCollisionBetweenSprites` are fully implemented. The single missing link is
`InitMapSprites` — without it every NPC slot has `PICTUREID=0` and is invisible to the
entire engine. This plan wires the data pipeline from the map object binary → sprite slots →
VRAM, then adds WALK movement and A-press stub interaction.

**Pallet Town NPCs** (the reference target):
- Oak: SPRITE\_OAK (0x03), STAY, NONE — should stand at map block (x=10, y=4)
- Girl: SPRITE\_GIRL (0x0D), WALK, ANY\_DIR — should wander near (x=3, y=8)
- Fisher: SPRITE\_FISHER (0x2F), WALK, ANY\_DIR — should wander near (x=11, y=14)

**Scope note:** Walking leg animation (tiles 0x80–0x8B) requires walk-tile `.inc` assets not
yet generated; deferred to Phase 3. WALK NPCs slide smoothly but without leg animation
this pass. NPC dialog text is stub "..." only — real GB text scripts not yet translated.

---

## Implementation is divided into 4 stages. Test after each stage before proceeding.

---

## Stage 1 — Static NPC Render (no movement) ✅ DONE (commit 59d55835)

**Files edited:** `dos_port/tools/gen_map_headers.py`, `dos_port/include/gb_memmap.inc`,
`dos_port/src/engine/overworld/map_sprites.asm` (new), `dos_port/src/engine/overworld/overworld.asm`,
`dos_port/Makefile`

Goal: Oak, Girl, Fisher appear at correct tile positions, facing down. Verified with FRAME.BIN.

### 1a. gen\_map\_headers.py — emit per-NPC binary records

**File:** `dos_port/tools/gen_map_headers.py`

Extend `parse_object_file` to parse each `object_event` line (using an extended regex)
and return a `sprites` list of dicts alongside the existing `sprite_count`. Each dict:
`{sprite_id, mapy, mapx, mov, dir, text_idx, is_trainer, trainer_class, trainer_num}`.

Constant resolution tables to add in the generator:
```python
SPRITE_CONSTS = {
    'SPRITE_OAK': 0x03, 'SPRITE_GIRL': 0x0D, 'SPRITE_FISHER': 0x2F,
    # extend as more NPCs are needed
}
MOV_CONSTS  = {'WALK': 0xFE, 'STAY': 0xFF}
DIR_CONSTS  = {'NONE': 0xFF, 'ANY_DIR': 0x00, 'UP_DOWN': 0x01, 'LEFT_RIGHT': 0x02}
TRAINER_FLAG = 0x40
```

**Macro arg order:** `object_event x, y, sprite, mov, dir, text` — bytes are emitted
as `sprite_id, y+4, x+4, mov, dir, text` (y before x in the binary, x before y in the call).

In `emit_map_header`, after the `db N ; sprite count` emit, add:
```python
for i, npc in enumerate(m['sprites']):
    text_byte = (TRAINER_FLAG | i) if npc['is_trainer'] else i
    hdr_lines.append(
        f"    db 0x{npc['sprite_id']:02X}, 0x{npc['mapy']:02X}, 0x{npc['mapx']:02X},"
        f" 0x{npc['mov']:02X}, 0x{npc['dir']:02X}, 0x{text_byte:02X}"
    )
    current_addr += 6
    if npc['is_trainer']:
        hdr_lines.append(
            f"    db 0x{npc['trainer_class']:02X}, 0x{npc['trainer_num']:02X}"
        )
        current_addr += 2
```

`current_addr` is already tracked dynamically throughout `emit_map_header`; updating it
here corrects the `object_data_ptr` and all subsequent map header pointers automatically
— no hardcoded offsets to fix.

**Expected bytes after `db 3 ; sprite count` for `map_object_PALLET_TOWN`:**
```
db 0x03, 0x08, 0x0E, 0xFF, 0xFF, 0x00   ; Oak:    sprite=3 MAPY=8 MAPX=14 STAY NONE text=0
db 0x0D, 0x0C, 0x07, 0xFE, 0x00, 0x01   ; Girl:   sprite=13 MAPY=12 MAPX=7 WALK ANY text=1
db 0x2F, 0x12, 0x0F, 0xFE, 0x00, 0x02   ; Fisher: sprite=47 MAPY=18 MAPX=15 WALK ANY text=2
```

Note MAPY/MAPX byte order (y before x); note x=10 → MAPX=14, not 10. Verify immediately
after `make assets` with `grep -A8 "map_object_PALLET_TOWN" dos_port/assets/map_headers.inc`.

### 1b. gb\_memmap.inc — add missing data2 offsets

**File:** `dos_port/include/gb_memmap.inc`

Add to the SPRITESTATEDATA2 section:
```nasm
SPRITESTATEDATA2_WALKANIMCOUNTER    equ 0x0  ; 8-frame countdown while walking (0=standing)
SPRITESTATEDATA2_MOVEMENTDELAY      equ 0x1  ; frames until next random walk attempt
SPRITESTATEDATA2_MOVEMENTBYTE2      equ 0x8  ; dir constraint from map object (ANY/UP_DOWN/LR)
SPRITESTATEDATA2_ISTRAINER          equ 0x9  ; 1 if trainer NPC, 0 otherwise
```

Note: pret stores MOVEMENTBYTE2 at data2[0x7], but the DOS port uses 0x7 for
`GRASSPRIORITY` (read by sprite\_oam.asm). Storing the dir constraint at 0x8 avoids
the alias; 0x8 and 0x9 are currently undefined and free.

### 1c. New file: dos\_port/src/engine/overworld/map\_sprites.asm

Exports: `InitMapSprites`, `MakeNPCFacePlayer`, `CheckNPCInteraction`.

#### InitMapSprites

Pret ref: `engine/overworld/map_sprites.asm:InitMapSprites` + `InitOutsideMapSprites`.

```
ESI = GB address from [ebp + W_MAP_OBJECTS_PTR]
Skip border block (1 byte)
Read warp_count, skip warps × 4 bytes
Read sign_count, skip signs × 3 bytes
Read sprite_count → ECX (0 → return immediately)

Local arrays on stack: sprite_set[12] = sprite IDs seen so far (zeroed)
                       vram_slots[12] = imageBaseOffset for each sprite_set entry
next_vram_slot = 3   ; slots 1=player, 2=Pikachu, 3+ = NPCs

for i = 1..ECX:
    read 6 bytes: sprite_id, mapy, mapx, mov_byte, dir_byte, text_byte
    if text_byte & TRAINER_FLAG: read 2 more (trainer_class, trainer_num), set is_trainer=1

    slot1 = W_SPRITE_STATE_DATA_1 + i*16
    slot2 = W_SPRITE_STATE_DATA_2 + i*16

    [slot1 + PICTUREID]      = sprite_id
    [slot1 + MOVEMENTSTATUS] = 0
    [slot1 + FACINGDIRECTION]= SPRITE_FACING_DOWN   ; always default
    [slot2 + MAPY]           = mapy
    [slot2 + MAPX]           = mapx
    [slot2 + MOVEMENTBYTE1]  = mov_byte
    [slot2 + MOVEMENTBYTE2]  = dir_byte
    [slot2 + MOVEMENTDELAY]  = 30
    [slot2 + ISTRAINER]      = is_trainer

    imageBaseOffset = FindOrAssignVramSlot(sprite_id)
    [slot2 + IMAGEBASEOFFSET] = imageBaseOffset

call LoadNPCSpriteTiles
```

**Facing default is always `SPRITE_FACING_DOWN`** — the dir_byte values NONE(0xFF),
ANY\_DIR(0x00), UP\_DOWN(0x01), LEFT\_RIGHT(0x02) are movement constraints, not initial
facing. Do not attempt to derive initial facing from dir_byte; only 0xD0–0xD3 encode a
fixed direction and none appear in Pallet Town.

#### FindOrAssignVramSlot (local helper)

Scan sprite\_set for existing sprite\_id → return cached imageBaseOffset.
If not found: add entry, imageBaseOffset = next\_vram\_slot, next\_vram\_slot++, return it.

#### LoadNPCSpriteTiles

For each (sprite\_id, imageBaseOffset) pair in sprite\_set:
```nasm
; vram_dst = host ptr to [ebp + GB_VCHARS0 + (imageBaseOffset-1)*192]
; src       = NpcSpriteAssets table lookup by sprite_id
; rep movsb 192 bytes (12 tiles × 16 bytes/tile)
; set g_tilecache_dirty = 1
```

**NpcSpriteAssets table** (in `.data` section):
```nasm
NpcSpriteAssets:
    db 0x03  ; SPRITE_OAK
    dd npc_oak_still
    db 0x0D  ; SPRITE_GIRL
    dd npc_girl_still
    db 0x2F  ; SPRITE_FISHER
    dd npc_fisher_still
    db 0x00  ; terminator
```

The asset labels come from `dos_port/assets/npc_*.inc` files. Add `%include` directives
at the top of map\_sprites.asm for each used asset. Asset sizes are fixed at 192 bytes
(`NPC_TILE_BYTES equ 192`).

### 1d. overworld.asm — wire InitMapSprites call

At `LoadMapData` (around line 687), replace the TODO comment:
```nasm
    call InitMapSprites   ; pret ref: home/overworld.asm:LoadMapData
```

Add `extern InitMapSprites` at the top of overworld.asm.

### 1e. Makefile — add map\_sprites.asm

Add `src/engine/overworld/map_sprites.o` to the object list, mirroring `movement.o` and
`overworld.o` entries.

**Stage 1 verification:**
```sh
make -C dos_port assets
make -C dos_port SKIP_TITLE=1
# Run in DOSBox-X, dump FRAME.BIN, render_frame.py
```
Oak, Girl, Fisher should appear at their correct tile positions, all facing south (down).
No movement yet.

---

## Stage 2 — WALK NPC Movement ✅ DONE (commit 59d55835)

**Files edited:** `dos_port/src/engine/overworld/movement.asm`,
`dos_port/src/engine/overworld/overworld.asm`, `dos_port/include/gb_memmap.inc`,
`dos_port/src/engine/math/random.asm` (new)

Goal: Girl and Fisher wander in their areas; Oak stays still.

### 2a. UpdateNonPlayerSprite — add WALK dispatch

**File:** `dos_port/src/engine/overworld/movement.asm`

After the existing STAY path (and after `CheckSpriteAvailability` + `InitializeSpriteScreenPosition`),
dispatch on MOVEMENTBYTE1:
```nasm
    movzx eax, byte [ebp + data2 + MOVEMENTBYTE1]
    cmp al, STAY
    je .stay_path       ; existing code
    cmp al, WALK
    je .walk_path
    jmp .stay_path      ; scripted: fall through to STAY in Phase 2
.walk_path:
    call UpdateNPCWalk
    ret
```

### 2b. UpdateNPCWalk

```nasm
UpdateNPCWalk:
    ; Mid-step: advance pixel position, decrement counter
    movzx eax, byte [ebp + data2 + WALKANIMCOUNTER]
    test al, al
    jnz .mid_step

    ; Standing: decrement delay
    movzx eax, byte [ebp + data2 + MOVEMENTDELAY]
    dec al
    mov [ebp + data2 + MOVEMENTDELAY], al
    jnz .done
    ; Delay expired: pick direction and try to start a walk
    call PickNPCDirection       ; -> DL = SPRITE_FACING_*
    call TryInitiateNPCWalk     ; CF=1 if blocked
    jnc .done
    mov byte [ebp + data2 + MOVEMENTDELAY], 20   ; blocked: retry in 20 frames
    ret

.mid_step:
    ; Advance 2px per frame in facing direction (8 frames × 2px = 16px = 1 block)
    movzx eax, byte [ebp + data1 + FACINGDIRECTION]
    ; FACING_DOWN: add 2 to YPIXELS; UP: sub 2; LEFT: sub 2 from XPIXELS; RIGHT: add 2
    ; (implement with a 4-entry jump table indexed by facing/4)
    dec byte [ebp + data2 + WALKANIMCOUNTER]
    jnz .done
    ; Step complete: commit new block position
    ; add ±1 to MAPY or MAPX based on facing
    ; reset delay for next walk
    mov byte [ebp + data2 + MOVEMENTDELAY], 20
.done:
    ret
```

**Do NOT call Func\_5274 (leg animation advance) for WALK NPCs in Phase 2.**
Walking tile IDs (0x80–0x8B) are not loaded into vChars1 for NPCs; keeping
`animFrameCounter=0` ensures only standing tiles (0x00–0x0B) are referenced.

### 2c. PickNPCDirection

Reads `MOVEMENTBYTE2` (data2[0x8]) for direction constraint. Uses
`H_FRAME_COUNTER ^ current_slot_index` as a cheap pseudo-random source:
```nasm
PickNPCDirection:
    ; Returns DL = SPRITE_FACING_DOWN/UP/LEFT/RIGHT
    movzx ecx, byte [ebp + H_FRAME_COUNTER]
    ; XOR with slot index (derived from ESI offset / 16) for per-sprite variance
    ...
    movzx eax, byte [ebp + data2 + MOVEMENTBYTE2]
    cmp al, 0x01   ; UP_DOWN
    je .updown
    cmp al, 0x02   ; LEFT_RIGHT
    je .leftright
    ; ANY_DIR or NONE or anything else: all 4 dirs
    ; random 0-3 → {SPRITE_FACING_DOWN, SPRITE_FACING_UP, SPRITE_FACING_LEFT, SPRITE_FACING_RIGHT}
    and ecx, 3
    mov dl, [npc_dir_table + ecx]
    ret
.updown:
    and ecx, 1
    ; 0→DOWN, 1→UP
    ...
.leftright:
    and ecx, 1
    ; 0→LEFT, 1→RIGHT
    ...
```

### 2d. TryInitiateNPCWalk

```nasm
TryInitiateNPCWalk:
    ; DL = new SPRITE_FACING_*
    mov [ebp + data1 + FACINGDIRECTION], dl
    ; Compute target block (MAPY+dy, MAPX+dx) from facing
    ; Call GetNPCTargetTile (extern from overworld.asm)
    call GetNPCTargetTile   ; CL = tile, CF=1 if impassable
    jc .blocked
    ; Passable: start 8-frame walk
    mov byte [ebp + data2 + WALKANIMCOUNTER], 8
    ; Set YSTEPVECTOR/XSTEPVECTOR = ±2 from facing
    ; (down: YSTEP=+2 XSTEP=0; up: YSTEP=-2; left: YSTEP=0 XSTEP=-2; right: XSTEP=+2)
    clc
    ret
.blocked:
    stc
    ret
```

### 2e. GetNPCTargetTile (new helper in overworld.asm)

Reads the passability tile at an NPC's target block from `wTileMap`, using the same
indexing approach as `GetTileInFrontOfPlayer`:

```nasm
; In: MAPY+delta (target block Y), MAPX+delta (target block X)
;     (passed in registers, e.g. BH/BL)
; Out: CL = tile ID, CF from IsTilePassable
GetNPCTargetTile:
    ; row = PLAYER_STANDING_ROW + (target_mapy - wYCoord) * 2 + 1
    ; col = PLAYER_STANDING_COL + (target_mapx - wXCoord) * 2 + 1
    movzx eax, byte [ebp + W_Y_COORD]
    ; sub from target_mapy, scale by 2, add PLAYER_STANDING_ROW+1
    ...
    ; tile_offset = row * SCREEN_TILES_W + col
    ; CL = [ebp + W_TILEMAP + tile_offset]
    movzx ecx, byte [ebp + esi]
    call IsTilePassable
    ret
```

`IsTilePassable` is already implemented at `overworld.asm:1465` — reuse it directly.
Export `GetNPCTargetTile` from overworld.asm; declare `extern GetNPCTargetTile` in
movement.asm.

**Stage 2 verification:** Build, boot. Oak stands. Girl/Fisher wander (slide without leg
animation). No garbage tile bleed. Verify in FRAME.BIN capture after a few seconds.

---

## Stage 3 — A-Press NPC Interaction ✅ DONE (commit 59d55835)

**Files edited:** `dos_port/src/engine/overworld/map_sprites.asm`,
`dos_port/src/engine/overworld/overworld.asm`

### 3a. MakeNPCFacePlayer (in map\_sprites.asm)

```nasm
; In: ESI = data1 base address of the NPC slot
MakeNPCFacePlayer:
    movzx eax, byte [ebp + W_SPRITE_PLAYER_FACING_DIR]
    xor al, 4    ; XOR 4 reverses all facings: 0↔4 (DOWN↔UP), 8↔12 (LEFT↔RIGHT)
    mov [ebp + esi + FACINGDIRECTION], al
    ret
```

### 3b. CheckNPCInteraction (in map\_sprites.asm)

```nasm
; Called from OverworldLoop when A pressed and wWalkCounter=0
CheckNPCInteraction:
    ; Compute target block (player + 1 step in facing direction)
    movzx eax, byte [ebp + W_SPRITE_PLAYER_FACING_DIR]
    ; Derive delta_y, delta_x (block units): DOWN→dy=1, UP→dy=-1, etc.
    movzx ebx, byte [ebp + W_Y_COORD]   ; player Y (block)
    movzx ecx, byte [ebp + W_X_COORD]   ; player X (block)
    ; add delta_y to BL, delta_x to CL

    ; Scan NPC slots 1..15
    mov edx, 1
.loop:
    cmp edx, 16
    jge .done
    ; slot1 = W_SPRITE_STATE_DATA_1 + edx*16
    ; slot2 = W_SPRITE_STATE_DATA_2 + edx*16
    movzx eax, byte [ebp + slot1 + PICTUREID]
    test al, al
    jz .next            ; empty slot
    movzx eax, byte [ebp + slot2 + MAPY]
    cmp al, bl          ; target_y
    jne .next
    movzx eax, byte [ebp + slot2 + MAPX]
    cmp al, cl          ; target_x
    jne .next
    ; Found NPC: face player
    mov esi, slot1
    call MakeNPCFacePlayer
    ; Show dialog (pass is_trainer flag from slot2[0x9])
    movzx eax, byte [ebp + slot2 + ISTRAINER]
    call ShowNPCDialogStub     ; AL = 0 for standard, 1 for trainer stub
    ret
.next:
    inc edx
    jmp .loop
.done:
    ret
```

### 3c. ShowNPCDialogStub (in map\_sprites.asm or new src/text/dialog\_stubs.asm)

```nasm
; AL = 0 → "...", AL = 1 → "TRAINER!" stub
ShowNPCDialogStub:
    ; Draw text box border using existing TextBoxBorder
    ; PlaceString at dialog row position
    ; Force render with DelayFrame
    ; Wait for A button press
    ; Clear box: call LoadCurrentMapView

stub_npc_text:     db "...", 0x50
stub_trainer_text: db "TRAINER!", 0x50
```

Reuse `TextBoxBorder` and `PlaceString` from `src/text/text.asm` (already implemented).
Dismiss on A button via `H_JOY_HELD` polling in a `DelayFrame` loop.

### 3d. Wire into OverworldLoop (overworld.asm)

After joypad read, before movement processing:
```nasm
    test byte [ebp + H_JOY_PRESSED], A_BUTTON
    jz .no_interact
    cmp byte [ebp + W_WALK_COUNTER], 0
    jne .no_interact
    call CheckNPCInteraction
.no_interact:
```

Add `extern CheckNPCInteraction` at the top of overworld.asm.

**Stage 3 verification:** Walk up to Oak, press A. Text box "..." appears. Press A,
dismissed. Approach Girl/Fisher mid-wander, press A: they face player, text box appears.

---

## Stage 4 — Trainer Stub (no battle) ✅ DONE (commit 59d55835)

**Files edited:** `dos_port/src/engine/overworld/map_sprites.asm`

Trainers are identified during `InitMapSprites` via `text_byte & TRAINER_FLAG (0x40)`,
with `ISTRAINER` stored at data2[0x9]. `CheckNPCInteraction` passes this flag to
`ShowNPCDialogStub` which shows "TRAINER!" placeholder text and returns — no battle
engine call is made.

Pallet Town has no trainers; this path activates on later maps (Route 1, etc.).

**Trainer verification:** Use a DEBUG\_DUMP or manual slot inspection to confirm the
flag is set correctly for a trainer-containing map when one is reached.

---

## Files Changed

| File | Change |
|---|---|
| `dos_port/tools/gen_map_headers.py` | parse NPC records; emit 6/8 bytes per NPC after sprite count |
| `dos_port/include/gb_memmap.inc` | add data2 offsets: WALKANIMCOUNTER(0x0), MOVEMENTDELAY(0x1), MOVEMENTBYTE2(0x8), ISTRAINER(0x9) |
| `dos_port/src/engine/overworld/map_sprites.asm` | **NEW**: InitMapSprites, FindOrAssignVramSlot, LoadNPCSpriteTiles, MakeNPCFacePlayer, CheckNPCInteraction, ShowNPCDialogStub |
| `dos_port/src/engine/overworld/overworld.asm` | call InitMapSprites; add GetNPCTargetTile; add A-press dispatch in OverworldLoop |
| `dos_port/src/engine/overworld/movement.asm` | extend UpdateNonPlayerSprite: WALK dispatch, UpdateNPCWalk, PickNPCDirection, TryInitiateNPCWalk |
| `dos_port/Makefile` | add map_sprites.o to object list |

---

## Deferred to Phase 3 — completion status

- [x] **Walking leg animation**: NPC walk-tile assets now emitted as full 384-byte sheets
  by `gen_all_assets.py`; `LoadNPCSpriteTiles` copies walk tiles to `GB_VFONT` slot.
  `Func_5274` already runs for NPC slots. Done — commit c8d82400.
- [x] **NPC-NPC tile collision**: `CanWalkOntoTile` calls `DetectCollisionBetweenSprites`
  and gates on `COLLISIONDATA & direction_bit`. Wired as part of commit 59d55835. The
  plan note "not called in the NPC walk path" was written before that commit.
- [ ] **Real NPC dialog**: All NPCs show "..." — GB text scripts not yet translated.
  Needs `PrintText` + text-script data per NPC slot (text_id → GB text address table).
  **Files to edit:** `dos_port/src/engine/overworld/map_sprites.asm` (ShowNPCDialogStub
  → real PrintText call), `dos_port/src/text/text.asm` (PrintText already exists; wire
  NPC text_id → GB text pointer lookup), `dos_port/tools/gen_map_headers.py` (may need
  to embed NPC text strings in map header binary).

- [ ] **Scripted NPC movement** (MOVEMENTBYTE1 < 0xFE): falls through to STAY.
  Needs `DoScriptedNPCMovement` path in `UpdateNonPlayerSprite`.
  **Files to edit:** `dos_port/src/engine/overworld/movement.asm` (add scripted-movement
  dispatch after WALK/STAY check in UpdateNonPlayerSprite); pret ref:
  `engine/overworld/auto_movement.asm` + `engine/overworld/sprite_collisions.asm` line 43
  (`DoScriptedNPCMovement`). Separate path from random WALK.

- [ ] **Trainer battle engine**: `ShowNPCDialogStub` exits without battle trigger.
  Needs trainer-sight check + battle-intro flow (Phase 2 battle engine milestone).
  **Files to edit:** `dos_port/src/engine/overworld/map_sprites.asm` (ShowNPCDialogStub
  → battle call when ISTRAINER=1), new `dos_port/src/engine/battle/` directory for battle
  engine stubs. Pret ref: `engine/overworld/trainer_sight.asm`; `engine/battle/`.
