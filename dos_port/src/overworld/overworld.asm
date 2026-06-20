; overworld.asm — Overworld map-loading and rendering routines.
;
; Faithful translations (pret cross-reference maintained):
;   ResetMapVariables          home/overworld.asm:ResetMapVariables
;   CopyMapViewToVRAM          home/overworld.asm:CopyMapViewToVRAM
;   DrawTileBlock              home/overworld.asm:DrawTileBlock
;   LoadCurrentMapView         home/overworld.asm:LoadCurrentMapView
;   LoadTilesetTilePatternData home/overworld.asm:LoadTilesetTilePatternData
;   LoadTileBlockMap           home/overworld.asm:LoadTileBlockMap (N/S/W/E strips translated;
;                               Phase 2 scaffold sets all connected maps to $FF so they skip)
;   LoadScreenRelatedData      home/overworld.asm:LoadScreenRelatedData
;   LoadMapData                home/overworld.asm:LoadMapData  (faithful structure; stubs for
;                               InitMapSprites, RunPaletteCommand, LoadPlayerSpriteGraphics,
;                               UpdateMusic — ; TODO-HW tags below)
;
; Phase 2 scaffold (not a faithful translation):
;   SetupPalletTown      — hardcoded Pallet Town map-header variables + asset copy to
;                           ROM window; initializes player sprite-state slot (slot 0)
;   SetupPalletTownNPCs  — loads NPC still tiles to VRAM and inits slots 1-3 with
;                           visible scaffold positions (canonical InitMapSprites later)
;   EnterMap             — scaffold entry from title screen
;   OverworldLoop        — player-movement frame loop: UpdateSprites (facing + walk
;                           animation), AdvancePlayerSprite scroll, land collision
;   LoadPlayerSpriteGraphics — loads Red's standing tiles to $8000 and walking
;                           tiles to $8800 (the VRAM layout the sprite engine indexes)
;
; The player now renders through the real sprite engine: UpdateSprites
; (src/overworld/movement.asm) drives the per-slot image index, and PrepareOAMData
; (src/gfx/sprite_oam.asm, run in the DelayFrame pipeline) builds shadow OAM from it.
;
; Asset layout in ROM window (EBP + $4000–$4FFF):
;   $4000 : overworld.2bpp  (94 tiles, 1504 bytes)  → wTilesetGfxPtr
;   $4600 : overworld.bst   (128 blocks × 16 bytes) → wTilesetBlocksPtr
;   $4E00 : PalletTown.blk  (10×9 = 90 bytes)       → wCurMapDataPtr
;
; Build: nasm -f coff -I include/ -I . -o overworld.o src/overworld/overworld.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

extern FillMemory
extern CopyData
extern FarCopyData
extern DisableLCD
extern EnableLCD
extern DelayFrame
extern LoadTextBoxTilePatterns
extern GBPalNormal
extern g_player_marker_on
extern UpdateSprites
extern ClearSprites
extern g_tilecache_dirty
%ifdef DEBUG_DUMP
extern DebugDumpMemory
%endif
%ifdef DEBUG_TRANSITION
extern DumpBackbuffer
%elifdef DEBUG_WALK_NORTH
extern DumpBackbuffer
%endif
%ifdef DEBUG_NOCLIP
extern pad_noclip
%endif

global EnterMap
global ResetMapVariables
global LoadScreenRelatedData
global LoadTilesetTilePatternData
global LoadTileBlockMap
global DrawTileBlock
global LoadCurrentMapView
global CopyMapViewToVRAM
global OverworldLoop
global AdvancePlayerSprite
global AdvancePlayerSprite

; ---------------------------------------------------------------------------
; Map and tileset constants
; ---------------------------------------------------------------------------
MAP_ID_PALLET_TOWN          equ 0x00
TILESET_OVERWORLD           equ 0x00
PALLET_TOWN_WIDTH           equ 10
PALLET_TOWN_HEIGHT          equ 9
PALLET_TOWN_BORDER_BLOCK    equ 0x0B   ; border block from PalletTown_Object
TILESET_BANK_FLAT           equ 0x01   ; ignored in flat model (TODO-HW: ROM banking)

; wCurrentTileBlockMapViewPointer for Pallet Town: view top-left at block (6, 4) so
; player block (10, 10) sits at view offset (4, 6) → wSurroundingTiles (16, 24).
;   stride = PALLET_TOWN_WIDTH + 2*MAP_BORDER = 10 + 12 = 22
;   = W_OVERWORLD_MAP + MAP_BORDER * 22 + (MAP_BORDER - 2) = W_OVERWORLD_MAP + 136
PALLET_TOWN_VIEW_PTR        equ W_OVERWORLD_MAP + (MAP_BORDER) * (PALLET_TOWN_WIDTH + MAP_BORDER * 2) + (MAP_BORDER - 2)

; Number of connections in the Block/Connect strips (0xFF = none — disables strip loading)
MAP_NO_CONNECTION           equ 0xFF

; Pallet Town map connections (computed from the pret `connection` macro for the
; north=Route1 / south=Route21 connections, both at offset 0). See
; macros/scripts/maps.asm:connection. Route1 = 10×18, Route21 = 10×45.
MAP_ID_ROUTE_1              equ 0x0C
MAP_ID_ROUTE_21             equ 0x20
CONNECTION_NORTH           equ 1 << 3   ; wCurMapConnections bits (EAST=1,WEST=2,SOUTH=4,NORTH=8)
CONNECTION_SOUTH           equ 1 << 2

; north (Route1): _blk = ROUTE1_W*(ROUTE1_H-3) = 10*15 = 150; _map = MAP_BORDER = 6;
;   _len = min(CUR_W+3, ROUTE1_W) = 10; _y = ROUTE1_H*2-1 = 35; _x = 0;
;   _win = (ROUTE1_W+12)*ROUTE1_H + 1 = 22*18+1 = 397
NORTH_STRIP_SRC            equ OW_ROUTE1_BLK_GBADDR + 150
NORTH_STRIP_DEST           equ W_OVERWORLD_MAP + 6
NORTH_STRIP_LENGTH         equ 10
NORTH_CONN_MAP_WIDTH       equ 10
NORTH_Y_ALIGN              equ 35
NORTH_X_ALIGN              equ 0
; NOTE: DEAD CODE. The live north view pointer is the one emitted into
; assets/map_headers.inc by tools/gen_map_headers.py (currently 0xE691 = base+273)
; and loaded into the connection header by LoadMapHeader. This equ is no longer
; read at runtime (SetupPalletTown, which used it, was removed). Kept only as a
; reference value; edit gen_map_headers.py / map_headers.inc to change behavior.
NORTH_VIEW_PTR             equ W_OVERWORLD_MAP + 397   ; (conn_width+12)*(conn_height-1)+1

; south (Route21): _blk = 0; _map = (CUR_W+12)*(CUR_H+6)+6 = 22*15+6 = 336;
;   _len = min(CUR_W+3, ROUTE21_W) = 10; _y = 0; _x = 0; _win = ROUTE21_W+13 = 23
SOUTH_STRIP_SRC            equ OW_ROUTE21_BLK_GBADDR + 0
SOUTH_STRIP_DEST           equ W_OVERWORLD_MAP + 336
SOUTH_STRIP_LENGTH         equ 10
SOUTH_CONN_MAP_WIDTH       equ 10
SOUTH_Y_ALIGN              equ 0
SOUTH_X_ALIGN              equ 0
SOUTH_VIEW_PTR             equ W_OVERWORLD_MAP + 23

ROUTE1_BLK_GB_SIZE         equ 180        ; 10×18
ROUTE21_BLK_GB_SIZE        equ 450        ; 10×45

section .text

; ---------------------------------------------------------------------------
; EnterMap — Phase 2 scaffold entry point.
; Called from title.asm after A/Start pressed. Sets up Pallet Town variables,
; copies assets to ROM window, then runs LoadMapData + OverworldLoop.
;
; Pret ref: home/overworld.asm:EnterMap (simplified; no fly/warp logic yet)
; ---------------------------------------------------------------------------
EnterMap:
    call LoadOverworldAssets
    call SetupPlayerSprite
    call LoadMapData
%ifdef DEBUG_DUMP
    call DebugDumpMemory     ; dump GB memory to DUMP.BIN, then exit (debug only)
%endif
%ifdef DEBUG_WALK_NORTH
    ; Walk-simulation harness: drive the REAL movement primitives north for
    ; DEBUG_WALK_STEPS steps (default 8: wYCoord 8 -> 0, the north edge), then
    ; dump the frame. Reveals where the player is VISUALLY when it reaches the
    ; map edge / when CheckMapConnections fires — i.e. whether the transition
    ; triggers at an appropriate point. Collision is skipped so the walk is
    ; unconditional. If a crossing fires mid-walk, we dump immediately.
%ifndef DEBUG_WALK_STEPS
%define DEBUG_WALK_STEPS 8
%endif
    mov ecx, DEBUG_WALK_STEPS
.wn_step:
    push ecx
    mov byte [ebp + W_SPRITE_PLAYER_Y_STEP_VECTOR], 0xFF   ; -1 (north)
    mov byte [ebp + W_SPRITE_PLAYER_X_STEP_VECTOR], 0
    mov byte [ebp + W_PLAYER_DIRECTION],        PLAYER_DIR_UP
    mov byte [ebp + W_PLAYER_MOVING_DIRECTION], PLAYER_DIR_UP
    mov byte [ebp + W_SPRITE_PLAYER_FACING_DIR], SPRITE_FACING_UP
    mov byte [ebp + W_WALK_COUNTER], 8
.wn_frames:
    call UpdateSprites
    call AdvancePlayerSprite
    jc .wn_crossed                ; CF=1 → CheckMapConnections fired this step
    call DelayFrame
    cmp byte [ebp + W_WALK_COUNTER], 0
    jne .wn_frames
    pop ecx
    dec ecx
    jnz .wn_step
    call DumpBackbuffer           ; reached edge without crossing — dump it
.wn_crossed:
    pop ecx                       ; (balance stack; ecx unused after)
    call DumpBackbuffer           ; dump the frame at the moment of crossing
%endif
%ifdef DEBUG_TRANSITION
    ; Deterministic transition test: simulate stepping off the north edge of
    ; Pallet Town (wYCoord wraps to 255), run the real CheckMapConnections, then
    ; the same reload .mapTransition does. Lets us screenshot the post-crossing
    ; render of Route 1's bottom without keyboard input.
%ifndef DEBUG_BASELINE
    mov byte [ebp + W_X_COORD], 8
    mov byte [ebp + W_Y_COORD], 255
    call CheckMapConnections                  ; sets W_CUR_MAP + view ptr for Route 1
%endif
    mov byte [ebp + W_WALK_COUNTER], 0
    mov byte [ebp + W_SPRITE_PLAYER_Y_STEP_VECTOR], 0
    mov byte [ebp + W_SPRITE_PLAYER_X_STEP_VECTOR], 0
    mov byte [ebp + H_SCY], 0
    mov byte [ebp + H_SCX], 0
    mov word [ebp + W_MAP_VIEW_VRAM_POINTER], GB_TILEMAP0
    call LoadMapHeader
    call LoadTileBlockMap
    call LoadCurrentMapView
    ; Render a few frames so GB_BACKBUF holds the post-transition image, then
    ; exfiltrate the exact rendered pixels to FRAME.BIN for host inspection.
    call DelayFrame
    call DelayFrame
    call DelayFrame
    call DumpBackbuffer        ; writes FRAME.BIN then exits (never returns)
%endif
    ; fall through to OverworldLoop

; ---------------------------------------------------------------------------
; OverworldLoop — player-movement frame loop.
; Pret ref: home/overworld.asm:OverworldLoop / OverworldLoopLessDelay (the
; movement-relevant subset; no menus, warps, NPCs, battles, or scripts yet).
;
; Cadence matches the original: two DelayFrame calls per iteration, then one
; AdvancePlayerSprite (2 px scroll) — so a 16 px step takes ~16 frames.
;
; State machine:
;   - mid-walk (wWalkCounter != 0): keep advancing the sprite.
;   - idle: read held D-pad; on a press, set the step vector + facing, run the
;     land collision check, and (if passable) start an 8-frame walk.
; ---------------------------------------------------------------------------
OverworldLoop:
    call RunNPCMovementScript                    ; door-exit auto-walk (BIT_STANDING_ON_DOOR path)
    ; Count down wIgnoreInputCounter each frame — pret: CountDownIgnoreInputBitReset (home/play_time.asm)
    cmp byte [ebp + W_IGNORE_INPUT_COUNTER], 0
    je .joyCountDone
    dec byte [ebp + W_IGNORE_INPUT_COUNTER]
    jnz .joyCountDone
    ; counter hit 0 → clear BIT_DISABLE_JOYPAD | BIT_UNKNOWN_5_2 | BIT_UNKNOWN_5_1
    and byte [ebp + W_STATUS_FLAGS_5], ~((1 << BIT_DISABLE_JOYPAD) | (1 << 2) | (1 << 1))
    mov byte [ebp + H_JOY_HELD], 0
.joyCountDone:
    call UpdateSprites                         ; advance player facing + walk animation
    call DelayFrame
.lessDelay:                                  ; OverworldLoopLessDelay
    call DelayFrame

    cmp byte [ebp + W_WALK_COUNTER], 0
    jne .moveAhead                           ; still mid-step → keep walking

    ; --- idle: clear step vectors, then sample the held D-pad ---
    mov byte [ebp + W_SPRITE_PLAYER_Y_STEP_VECTOR], 0
    mov byte [ebp + W_SPRITE_PLAYER_X_STEP_VECTOR], 0

    ; Simulated joypad state overrides real input (pret: AreInputsSimulated).
    ; BIT_SCRIPTED_MOVEMENT_STATE is set by PlayerStepOutFromDoor for one idle frame.
    movzx eax, byte [ebp + H_JOY_HELD]
    test byte [ebp + W_STATUS_FLAGS_5], (1 << BIT_SCRIPTED_MOVEMENT_STATE)
    jz .checkJoyDisable
    movzx eax, byte [ebp + W_SIMULATED_JOYPAD_STATES_END]
    and byte [ebp + W_STATUS_FLAGS_5], ~(1 << BIT_SCRIPTED_MOVEMENT_STATE)
    jmp .checkPADDown

.checkJoyDisable:
    test byte [ebp + W_STATUS_FLAGS_5], (1 << BIT_DISABLE_JOYPAD)
    jnz .noDirection                            ; input suppressed during warp-arrival window

.checkPADDown:
    test al, PAD_DOWN
    jz .checkUp
    mov byte [ebp + W_SPRITE_PLAYER_Y_STEP_VECTOR], 1
    mov dl, PLAYER_DIR_DOWN
    mov dh, SPRITE_FACING_DOWN
    jmp .handleDirection
.checkUp:
    test al, PAD_UP
    jz .checkLeft
    mov byte [ebp + W_SPRITE_PLAYER_Y_STEP_VECTOR], 0xFF   ; -1
    mov dl, PLAYER_DIR_UP
    mov dh, SPRITE_FACING_UP
    jmp .handleDirection
.checkLeft:
    test al, PAD_LEFT
    jz .checkRight
    mov byte [ebp + W_SPRITE_PLAYER_X_STEP_VECTOR], 0xFF   ; -1
    mov dl, PLAYER_DIR_LEFT
    mov dh, SPRITE_FACING_LEFT
    jmp .handleDirection
.checkRight:
    test al, PAD_RIGHT
    jz .noDirection                          ; nothing held → idle (stop animating)
    mov byte [ebp + W_SPRITE_PLAYER_X_STEP_VECTOR], 1
    mov dl, PLAYER_DIR_RIGHT
    mov dh, SPRITE_FACING_RIGHT

.handleDirection:
    ; Always commit the new direction/facing — this happens even on turn-only presses.
    mov [ebp + W_PLAYER_DIRECTION],         dl
    mov [ebp + W_PLAYER_MOVING_DIRECTION],  dl
    mov [ebp + W_SPRITE_PLAYER_FACING_DIR], dh

    ; pret: bit BIT_SCRIPTED_MOVEMENT_STATE, a / jr nz, .noDirectionChange
    ; Scripted movement (door auto-walk) bypasses the 180° turn-delay entirely.
    test byte [ebp + W_STATUS_FLAGS_5], (1 << BIT_SCRIPTED_MOVEMENT_STATE)
    jnz .walkStart

    ; Turn delay (pret: wCheckFor180DegreeTurn / wPlayerLastStopDirection).
    ; First press after idle with a NEW direction: update facing but don't walk.
    ; Second press (same direction, or same as last-stop dir): walk normally.
    cmp byte [ebp + W_CHECK_FOR_TURN], 0
    je .walkStart                             ; already committed to walking direction
    mov byte [ebp + W_CHECK_FOR_TURN], 0     ; consume the turn-check token
    cmp dl, [ebp + W_PLAYER_LAST_STOP_DIRECTION]
    jne OverworldLoop                         ; new direction → facing updated, no walk

.walkStart:
    call CollisionCheckOnLand                 ; CF=1 → blocked
    jnc .startWalk

    ; Blocked. Collision-exit path (pret: bit BIT_STANDING_ON_WARP / ExtraWarpCheck).
    ; Suppress during BIT_EXITING_DOOR window (auto-walk PAD_DOWN after door arrival).
    test byte [ebp + W_MOVEMENT_FLAGS], (1 << BIT_EXITING_DOOR)
    jnz OverworldLoop
    ; Only attempt exit if player IS on a warp tile (pret: bit BIT_STANDING_ON_WARP guard).
    test byte [ebp + W_MOVEMENT_FLAGS], (1 << BIT_STANDING_ON_WARP)
    jz OverworldLoop
    cmp dl, PLAYER_DIR_DOWN
    jne OverworldLoop
    call CheckWarpTile
    jnc OverworldLoop
    jmp .warpTransition

.startWalk:
    mov byte [ebp + W_WALK_COUNTER], 8        ; begin an 8-frame step
    jmp .moveAhead                             ; pret: jr .moveAhead2 — advance immediately, no extra delay

.noDirection:
    ; Save the last-used moving direction so the next press can check for a turn.
    ; (Pret: .noDirectionButtonsPressed — saves wPlayerMovingDirection to
    ; wPlayerLastStopDirection, zeroes moving dir, sets wCheckFor180DegreeTurn=1.)
    mov al, [ebp + W_PLAYER_MOVING_DIRECTION]
    mov [ebp + W_PLAYER_LAST_STOP_DIRECTION], al
    mov byte [ebp + W_PLAYER_MOVING_DIRECTION], 0
    mov byte [ebp + W_CHECK_FOR_TURN], 1
    jmp OverworldLoop

.moveAhead:
    call AdvancePlayerSprite
    jc .mapTransition
    cmp byte [ebp + W_WALK_COUNTER], 0
    jne OverworldLoop
    ; Edge-detect: save previous BIT_STANDING_ON_WARP then clear it.
    ; Mirrors pret: res BIT_STANDING_ON_WARP first, then set it if coords match.
    test byte [ebp + W_MOVEMENT_FLAGS], (1 << BIT_STANDING_ON_WARP)
    setnz bh                                  ; BH=1 if player WAS on warp tile
    and byte [ebp + W_MOVEMENT_FLAGS], ~(1 << BIT_STANDING_ON_WARP)
    call CheckWarpTile
    jnc OverworldLoop                         ; no match → bit cleared, loop
    ; Coord matched: always set BIT_STANDING_ON_WARP so .walkStart collision-exit works
    ; even when the player arrives laterally (and shouldn't warp immediately).
    or byte [ebp + W_MOVEMENT_FLAGS], (1 << BIT_STANDING_ON_WARP)
    ; Walk-on warp only fires for north/south movement (PLAYER_DIR_UP | PLAYER_DIR_DOWN).
    ; Lateral (EAST/WEST) approach to a multi-tile mat sets the bit (above) but doesn't
    ; fire, matching pret's IsPlayerFacingEdgeOfMap returning false for left/right.
    test dl, (PLAYER_DIR_DOWN | PLAYER_DIR_UP)
    jz OverworldLoop                          ; lateral → no fire
    ; Fire only on non-warp→warp transition (BH=0).
    ; warp→warp (BH=1): lateral mat side step, or first step after arrival.
    test bh, bh
    jnz OverworldLoop                         ; warp→warp → no fire
.warpTransition:
    ; BL = resolved destination map; W_DESTINATION_WARP_ID = 0-based spawn warp index
    mov al, [ebp + W_CUR_MAP]
    mov [ebp + W_LAST_MAP], al
    mov [ebp + W_CUR_MAP], bl
    mov byte [ebp + W_WALK_COUNTER], 0
    mov byte [ebp + W_SPRITE_PLAYER_Y_STEP_VECTOR], 0
    mov byte [ebp + W_SPRITE_PLAYER_X_STEP_VECTOR], 0
    mov byte [ebp + H_SCY], 0
    mov byte [ebp + H_SCX], 0
    mov word [ebp + W_MAP_VIEW_VRAM_POINTER], GB_TILEMAP0
    call LoadWarpDestination
    ; pret: home/overworld.asm:515 (WarpFound2.indoorMaps) — clear BIT_EXITING_DOOR,
    ; then set BIT_STANDING_ON_DOOR to trigger RunNPCMovementScript→PlayerStepOutFromDoor
    ; on the next idle frame. PlayerStepOutFromDoor re-sets BIT_EXITING_DOOR only if the
    ; arrival tile is a door tile; stair arrivals leave it clear.
    and byte [ebp + W_MOVEMENT_FLAGS], ~(1 << BIT_EXITING_DOOR)
    or byte [ebp + W_MOVEMENT_FLAGS], (1 << BIT_STANDING_ON_DOOR)
    call IgnoreInputForHalfSecond
    jmp OverworldLoop                          ; pret: jp EnterMap → OverworldLoop top; RunNPCMovementScript fires on first post-warp frame

.mapTransition:
    ; A connection was crossed — reload everything for the new map.
    mov byte [ebp + W_WALK_COUNTER], 0
    mov byte [ebp + W_SPRITE_PLAYER_Y_STEP_VECTOR], 0
    mov byte [ebp + W_SPRITE_PLAYER_X_STEP_VECTOR], 0

    ; Reset scroll and VRAM pointer. During the walk, H_SCY/H_SCX accumulated
    ; 2 px/frame (e.g. −144 px over 9 north steps). CopyMapViewToVRAM always
    ; writes to GB_TILEMAP0 ($9800), so the PPU must start reading from row 0
    ; (SCY=0). W_MAP_VIEW_VRAM_POINTER must also reset so RedrawRowOrColumn
    ; uses the correct base address on subsequent frames.
    mov byte [ebp + H_SCY], 0
    mov byte [ebp + H_SCX], 0
    mov word [ebp + W_MAP_VIEW_VRAM_POINTER], GB_TILEMAP0

    call LoadMapHeader
    call LoadTileBlockMap
    call LoadCurrentMapView

    jmp OverworldLoop.lessDelay

; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; LoadOverworldAssets — Phase 2 scaffold.
; Copies the generated map headers and overworld assets from .rodata into the
; ROM-window area of GB memory (EBP+$4000–$54FF).
; ---------------------------------------------------------------------------
LoadOverworldAssets:
    push esi
    push edi
    push ecx

    ; --- Copy overworld.2bpp to ROM window at OW_GFX_GBADDR ---
    mov esi, overworld_gfx
    lea edi, [ebp + OW_GFX_GBADDR]
    mov ecx, OVERWORLD_GFX_SIZE
    rep movsb

    ; --- Copy overworld.bst to ROM window at OW_BLOCKS_GBADDR ---
    mov esi, overworld_blocks
    lea edi, [ebp + OW_BLOCKS_GBADDR]
    mov ecx, OVERWORLD_BLOCKS_SIZE
    rep movsb

    ; --- Copy map block data to ROM window ---
    mov esi, pallet_town_blk
    lea edi, [ebp + OW_PALLET_BLK_GBADDR]
    mov ecx, PALLET_TOWN_BLK_SIZE
    rep movsb

    mov esi, route1_blk
    lea edi, [ebp + OW_ROUTE1_BLK_GBADDR]
    mov ecx, ROUTE1_BLK_SIZE
    rep movsb

    mov esi, route21_blk
    lea edi, [ebp + OW_ROUTE21_BLK_GBADDR]
    mov ecx, ROUTE21_BLK_SIZE
    rep movsb

    ; --- Copy all remaining OVERWORLD-tileset map block data ---
    mov esi, viridian_city_blk
    lea edi, [ebp + OW_VIRIDIAN_CITY_BLK_GBADDR]
    mov ecx, VIRIDIAN_CITY_BLK_SIZE
    rep movsb

    mov esi, pewter_city_blk
    lea edi, [ebp + OW_PEWTER_CITY_BLK_GBADDR]
    mov ecx, PEWTER_CITY_BLK_SIZE
    rep movsb

    mov esi, cerulean_city_blk
    lea edi, [ebp + OW_CERULEAN_CITY_BLK_GBADDR]
    mov ecx, CERULEAN_CITY_BLK_SIZE
    rep movsb

    mov esi, lavender_town_blk
    lea edi, [ebp + OW_LAVENDER_TOWN_BLK_GBADDR]
    mov ecx, LAVENDER_TOWN_BLK_SIZE
    rep movsb

    mov esi, vermilion_city_blk
    lea edi, [ebp + OW_VERMILION_CITY_BLK_GBADDR]
    mov ecx, VERMILION_CITY_BLK_SIZE
    rep movsb

    mov esi, celadon_city_blk
    lea edi, [ebp + OW_CELADON_CITY_BLK_GBADDR]
    mov ecx, CELADON_CITY_BLK_SIZE
    rep movsb

    mov esi, fuchsia_city_blk
    lea edi, [ebp + OW_FUCHSIA_CITY_BLK_GBADDR]
    mov ecx, FUCHSIA_CITY_BLK_SIZE
    rep movsb

    mov esi, cinnabar_island_blk
    lea edi, [ebp + OW_CINNABAR_ISLAND_BLK_GBADDR]
    mov ecx, CINNABAR_ISLAND_BLK_SIZE
    rep movsb

    mov esi, saffron_city_blk
    lea edi, [ebp + OW_SAFFRON_CITY_BLK_GBADDR]
    mov ecx, SAFFRON_CITY_BLK_SIZE
    rep movsb

    mov esi, route2_blk
    lea edi, [ebp + OW_ROUTE_2_BLK_GBADDR]
    mov ecx, ROUTE2_BLK_SIZE
    rep movsb

    mov esi, route3_blk
    lea edi, [ebp + OW_ROUTE_3_BLK_GBADDR]
    mov ecx, ROUTE3_BLK_SIZE
    rep movsb

    mov esi, route4_blk
    lea edi, [ebp + OW_ROUTE_4_BLK_GBADDR]
    mov ecx, ROUTE4_BLK_SIZE
    rep movsb

    mov esi, route5_blk
    lea edi, [ebp + OW_ROUTE_5_BLK_GBADDR]
    mov ecx, ROUTE5_BLK_SIZE
    rep movsb

    mov esi, route6_blk
    lea edi, [ebp + OW_ROUTE_6_BLK_GBADDR]
    mov ecx, ROUTE6_BLK_SIZE
    rep movsb

    mov esi, route7_blk
    lea edi, [ebp + OW_ROUTE_7_BLK_GBADDR]
    mov ecx, ROUTE7_BLK_SIZE
    rep movsb

    mov esi, route8_blk
    lea edi, [ebp + OW_ROUTE_8_BLK_GBADDR]
    mov ecx, ROUTE8_BLK_SIZE
    rep movsb

    mov esi, route9_blk
    lea edi, [ebp + OW_ROUTE_9_BLK_GBADDR]
    mov ecx, ROUTE9_BLK_SIZE
    rep movsb

    mov esi, route10_blk
    lea edi, [ebp + OW_ROUTE_10_BLK_GBADDR]
    mov ecx, ROUTE10_BLK_SIZE
    rep movsb

    mov esi, route11_blk
    lea edi, [ebp + OW_ROUTE_11_BLK_GBADDR]
    mov ecx, ROUTE11_BLK_SIZE
    rep movsb

    mov esi, route12_blk
    lea edi, [ebp + OW_ROUTE_12_BLK_GBADDR]
    mov ecx, ROUTE12_BLK_SIZE
    rep movsb

    mov esi, route13_blk
    lea edi, [ebp + OW_ROUTE_13_BLK_GBADDR]
    mov ecx, ROUTE13_BLK_SIZE
    rep movsb

    mov esi, route14_blk
    lea edi, [ebp + OW_ROUTE_14_BLK_GBADDR]
    mov ecx, ROUTE14_BLK_SIZE
    rep movsb

    mov esi, route15_blk
    lea edi, [ebp + OW_ROUTE_15_BLK_GBADDR]
    mov ecx, ROUTE15_BLK_SIZE
    rep movsb

    mov esi, route16_blk
    lea edi, [ebp + OW_ROUTE_16_BLK_GBADDR]
    mov ecx, ROUTE16_BLK_SIZE
    rep movsb

    mov esi, route17_blk
    lea edi, [ebp + OW_ROUTE_17_BLK_GBADDR]
    mov ecx, ROUTE17_BLK_SIZE
    rep movsb

    mov esi, route18_blk
    lea edi, [ebp + OW_ROUTE_18_BLK_GBADDR]
    mov ecx, ROUTE18_BLK_SIZE
    rep movsb

    mov esi, route19_blk
    lea edi, [ebp + OW_ROUTE_19_BLK_GBADDR]
    mov ecx, ROUTE19_BLK_SIZE
    rep movsb

    mov esi, route20_blk
    lea edi, [ebp + OW_ROUTE_20_BLK_GBADDR]
    mov ecx, ROUTE20_BLK_SIZE
    rep movsb

    mov esi, route22_blk
    lea edi, [ebp + OW_ROUTE_22_BLK_GBADDR]
    mov ecx, ROUTE22_BLK_SIZE
    rep movsb

    mov esi, route24_blk
    lea edi, [ebp + OW_ROUTE_24_BLK_GBADDR]
    mov ecx, ROUTE24_BLK_SIZE
    rep movsb

    mov esi, route25_blk
    lea edi, [ebp + OW_ROUTE_25_BLK_GBADDR]
    mov ecx, ROUTE25_BLK_SIZE
    rep movsb

    mov esi, route23_blk
    lea edi, [ebp + OW_ROUTE_23_BLK_GBADDR]
    mov ecx, ROUTE23_BLK_SIZE
    rep movsb

    mov esi, indigo_plateau_blk
    lea edi, [ebp + OW_INDIGO_PLATEAU_BLK_GBADDR]
    mov ecx, INDIGO_PLATEAU_BLK_SIZE
    rep movsb

    ; --- Copy Overworld_Coll passable-tile list to ROM window at OW_COLL_GBADDR ---
    mov esi, overworld_coll
    lea edi, [ebp + OW_COLL_GBADDR]
    mov ecx, OVERWORLD_COLL_SIZE
    rep movsb

    ; --- Copy map_headers.inc data to ROM window ---
    mov esi, map_headers_data
    lea edi, [ebp + OW_TILESET_HDR_GBADDR] ; Starts at tileset header
    mov ecx, MAP_HEADERS_DATA_SIZE
    rep movsb

    pop ecx
    pop edi
    pop esi
    ret

; ---------------------------------------------------------------------------
; SetupPlayerSprite — Phase 2 scaffold.
; Initializes the player sprite WRAM variables and starting map. W_CUR_MAP
; must be set here so LoadMapHeader knows which map to load.
; ---------------------------------------------------------------------------
SetupPlayerSprite:
    mov byte [ebp + W_CUR_MAP], MAP_ID_PALLET_TOWN
    mov byte [ebp + W_Y_COORD], 8
    mov byte [ebp + W_X_COORD], 8
    mov byte [ebp + W_Y_BLOCK_COORD], 0
    mov byte [ebp + W_X_BLOCK_COORD], 0
    mov word [ebp + W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR], PALLET_TOWN_VIEW_PTR

    ; Face down, standing still (no in-progress walk).
    mov byte [ebp + W_SPRITE_PLAYER_FACING_DIR],   SPRITE_FACING_DOWN
    mov byte [ebp + W_PLAYER_DIRECTION],           0
    mov byte [ebp + W_PLAYER_MOVING_DIRECTION],    0
    mov byte [ebp + W_SPRITE_PLAYER_Y_STEP_VECTOR], 0
    mov byte [ebp + W_SPRITE_PLAYER_X_STEP_VECTOR], 0
    mov byte [ebp + W_WALK_COUNTER],               0

    mov byte [ebp + W_SPRITE_PLAYER_PICTURE_ID],      1   ; non-zero → slot in use
    mov byte [ebp + W_SPRITE_PLAYER_IMAGE_BASE_OFFSET], 1 ; player VRAM slot
    mov byte [ebp + W_SPRITE_PLAYER_Y_PIXELS],        0x3C ; fixed screen Y ($3C = GB center 72 - 12)
    mov byte [ebp + W_SPRITE_PLAYER_X_PIXELS],        0x40 ; fixed screen X ($40 = GB center 80 - 16)
    mov byte [ebp + W_SPRITE_PLAYER_IMAGE_INDEX],     SPRITE_FACING_DOWN
    mov byte [ebp + W_SPRITE_PLAYER_INTRA_ANIM],      0
    mov byte [ebp + W_SPRITE_PLAYER_ANIM_FRAME],      0
    mov byte [ebp + W_SPRITE_PLAYER_WALK_ANIM_COUNTER], 0
    mov byte [ebp + W_SPRITE_PLAYER_GRASS_PRIORITY],  0

    mov byte [ebp + W_GRASS_TILE],    0xFF
    mov byte [ebp + W_FONT_LOADED],   0
    mov byte [ebp + W_MOVEMENT_FLAGS], 0

    mov byte [ebp + H_AUTO_BG_TRANSFER_EN],        0
    mov byte [g_player_marker_on], 0
    ret

; ---------------------------------------------------------------------------
; LoadMapData — faithful translation.
; Pret ref: home/overworld.asm:LoadMapData
; ---------------------------------------------------------------------------
LoadMapData:
    call DisableLCD
    call ResetMapVariables
    call LoadTextBoxTilePatterns
    call LoadMapHeader
    ; TODO: InitMapSprites — ; TODO: sprite engine (Phase 2)
    call LoadScreenRelatedData
    call LoadScreenRelatedData

    mov byte [ebp + W_UPDATE_SPRITES_ENABLED], 1
    call EnableLCD
    call GBPalNormal
    call LoadPlayerSpriteGraphics       ; scaffold: player tiles → OBJ VRAM, hide OAM
    ; RunPaletteCommand(SET_PAL_OVERWORLD) — ; TODO-HW: palette (Phase 5)
    ; UpdateMusic / PlayDefaultMusicFadeOutCurrent — ; TODO-HW: audio (Phase 3)
    ret

; ---------------------------------------------------------------------------
; LoadPlayerSpriteGraphics — Phase 2 scaffold (player-only sprite VRAM load).
; Lays out the 24-tile Red overworld sprite the way the engine indexes it:
;   tiles 0-11  (standing/turn poses) → OBJ tiles $00-$0B at GB_VCHARS0 ($8000)
;   tiles 12-23 (walking poses)       → OBJ tiles $80-$8B at GB_VFONT  ($8800)
; The walking tiles share VRAM with the text font (vChars1); the GB does the
; same and reloads sprite/font tiles when switching between map and text, which
; is why UpdatePlayerSprite hides the player when a text box is in front of it.
; The real engine (InitMapSprites / VRAM-slot allocation / Pikachu) comes later.
; ---------------------------------------------------------------------------
PLAYER_STANDING_TILES equ 12               ; tiles 0-11
PLAYER_TILE_BYTES     equ PLAYER_STANDING_TILES * TILE_SIZE  ; 192 bytes

LoadPlayerSpriteGraphics:
    mov byte [g_tilecache_dirty], 1     ; VRAM tile data changes → rebuild decode cache
    push eax
    push ecx
    push esi
    push edi

    ; --- standing tiles (0-11) → OBJ tiles $00-$0B at $8000 ---
    mov esi, player_sprite
    lea edi, [ebp + GB_VCHARS0]
    mov ecx, PLAYER_TILE_BYTES
    rep movsb

    ; --- walking tiles (12-23) → OBJ tiles $80-$8B at $8800 (vChars1) ---
    mov esi, player_sprite + PLAYER_TILE_BYTES
    lea edi, [ebp + GB_VFONT]
    mov ecx, PLAYER_TILE_BYTES
    rep movsb

    ; clear shadow OAM (PrepareOAMData fills it; nothing stale before then)
    call ClearSprites

    pop edi
    pop esi
    pop ecx
    pop eax
    ret

    ret

; ---------------------------------------------------------------------------
; ResetMapVariables — faithful translation.
; Pret ref: home/overworld.asm:ResetMapVariables
;
; Sets wMapViewVRAMPointer = vBGMap0 ($9800), zeroes SCX/SCY and walk state.
; ---------------------------------------------------------------------------
ResetMapVariables:
    xor al, al
    mov byte [ebp + H_SCY],                       al
    mov byte [ebp + H_SCX],                       al
    mov byte [ebp + W_WALK_COUNTER],              al
    mov byte [ebp + W_UNUSED_CUR_MAP_TILESET_COPY], al
    mov byte [ebp + W_SPRITE_SET_ID],             al
    mov byte [ebp + W_WALK_BIKE_SURF_STATE_COPY], al
    ret

; ---------------------------------------------------------------------------
; LoadScreenRelatedData — faithful translation.
; Pret ref: home/overworld.asm:LoadScreenRelatedData
; ---------------------------------------------------------------------------
LoadScreenRelatedData:
    call LoadTileBlockMap
    call LoadTilesetTilePatternData
    call LoadCurrentMapView
    ret

; ---------------------------------------------------------------------------
; LoadTilesetTilePatternData — faithful translation.
; Pret ref: home/overworld.asm:LoadTilesetTilePatternData
;
; Reads wTilesetGfxPtr (16-bit GB address) and copies $600 bytes (1536) from
; that ROM-window address to vTileset ($9000 = GB_VCHARS2).
; In the flat model wTilesetBank (FarCopyData bank arg) is ignored.
; ---------------------------------------------------------------------------
LoadTilesetTilePatternData:
    mov byte [g_tilecache_dirty], 1     ; VRAM tile data changes → rebuild decode cache
    ; ESI = wTilesetGfxPtr (16-bit GB address, LE word)
    movzx esi, word [ebp + W_TILESET_GFX_PTR]    ; ESI = HL = 0x4000
    mov edx, GB_VCHARS2                            ; EDX = DE = 0x9000 (vTileset)
    mov bx,  0x0600                                ; BX = BC = $600 bytes
    movzx eax, byte [ebp + W_TILESET_BANK]         ; AL = bank (ignored)
    jmp FarCopyData                                ; tail call

; ---------------------------------------------------------------------------
; LoadTileBlockMap — faithful translation.
; Pret ref: home/overworld.asm:LoadTileBlockMap
;
; 1. Fills wOverworldMap with wMapBackgroundTile (border block).
; 2. Copies PalletTown.blk data (from wCurMapDataPtr) into wOverworldMap,
;    offset by MAP_BORDER rows and MAP_BORDER columns.
; 3. Processes N/S/W/E connection strips (all $FF = none for Phase 2).
; ---------------------------------------------------------------------------
LoadTileBlockMap:
    push esi
    push edi
    push ebx
    push ecx

    ; Fill wOverworldMap..wOverworldMapEnd with wMapBackgroundTile
    mov esi, W_OVERWORLD_MAP
    mov bx,  W_OVERWORLD_MAP_SIZE & 0xFFFF
    movzx eax, byte [ebp + W_MAP_BACKGROUND_TILE]
    call FillMemory

    ; HL = ESI = wOverworldMap
    mov esi, W_OVERWORLD_MAP

    ; hMapWidth = wCurMapWidth; hMapStride = width + MAP_BORDER*2
    movzx ecx, byte [ebp + W_CUR_MAP_WIDTH]       ; ECX = width (= 10)
    mov byte [ebp + H_MAP_WIDTH], cl
    add cl, MAP_BORDER * 2                         ; CL = stride (= 16)
    mov byte [ebp + H_MAP_STRIDE], cl

    ; Skip MAP_BORDER rows: ESI += stride * MAP_BORDER
    movzx eax, cl                                  ; EAX = stride
    imul eax, MAP_BORDER                           ; EAX = stride * 3
    add esi, eax                                   ; ESI = row MAP_BORDER start

    ; Skip MAP_BORDER cols: ESI += MAP_BORDER
    add esi, MAP_BORDER                            ; ESI = first cell of map data

    ; DE = wCurMapDataPtr (source: .blk data in ROM window)
    movzx edx, word [ebp + W_CUR_MAP_DATA_PTR]    ; EDX = 0x4E00

    ; B (BH) = wCurMapHeight (row count)
    movzx eax, byte [ebp + W_CUR_MAP_HEIGHT]
    mov bh, al

.row_loop:
    push esi                                       ; save row-start write ptr
    movzx ecx, byte [ebp + H_MAP_WIDTH]            ; CL = map width (without border)
.row_inner_loop:
    mov al, byte [ebp + edx]                       ; read block ID from .blk
    inc edx
    mov byte [ebp + esi], al                       ; write block ID to wOverworldMap
    inc esi
    dec cl
    jnz .row_inner_loop
    pop esi                                        ; restore row-start ptr
    movzx eax, byte [ebp + H_MAP_STRIDE]           ; EAX = stride
    add esi, eax                                   ; advance ESI to next row
    dec bh
    jnz .row_loop

    ; --- Connection strips: copy each connected map's edge into the wOverworldMap
    ;     border. SwitchToMapRomBank is a no-op in the flat model. The strip src
    ;     pointers (CONN_STRIP_SRC) index into the connected maps' block data
    ;     loaded at OW_ROUTE*_BLK_GBADDR. hNorthSouthConnectionStripWidth and the
    ;     connected-map width reuse H_MAP_STRIDE/H_MAP_WIDTH (they are HRAM unions).

.north_connection:
    cmp byte [ebp + W_NORTH_CONNECTED_MAP], MAP_NO_CONNECTION
    je  .south_connection
    movzx esi, word [ebp + W_NORTH_CONNECTED_MAP + CONN_STRIP_SRC]   ; HL = strip src
    movzx edx, word [ebp + W_NORTH_CONNECTED_MAP + CONN_STRIP_DEST]  ; DE = strip dest
    mov al, [ebp + W_NORTH_CONNECTED_MAP + CONN_STRIP_LENGTH]
    mov [ebp + H_MAP_STRIDE], al                                     ; hNSConnectionStripWidth
    mov al, [ebp + W_NORTH_CONNECTED_MAP + CONN_MAP_WIDTH]
    mov [ebp + H_MAP_WIDTH], al                                      ; hNSConnectedMapWidth
    call LoadNorthSouthConnectionsTileMap

.south_connection:
    cmp byte [ebp + W_SOUTH_CONNECTED_MAP], MAP_NO_CONNECTION
    je  .west_connection
    movzx esi, word [ebp + W_SOUTH_CONNECTED_MAP + CONN_STRIP_SRC]
    movzx edx, word [ebp + W_SOUTH_CONNECTED_MAP + CONN_STRIP_DEST]
    mov al, [ebp + W_SOUTH_CONNECTED_MAP + CONN_STRIP_LENGTH]
    mov [ebp + H_MAP_STRIDE], al
    mov al, [ebp + W_SOUTH_CONNECTED_MAP + CONN_MAP_WIDTH]
    mov [ebp + H_MAP_WIDTH], al
    call LoadNorthSouthConnectionsTileMap

.west_connection:
    cmp byte [ebp + W_WEST_CONNECTED_MAP], MAP_NO_CONNECTION
    je  .east_connection
    movzx esi, word [ebp + W_WEST_CONNECTED_MAP + CONN_STRIP_SRC]
    movzx edx, word [ebp + W_WEST_CONNECTED_MAP + CONN_STRIP_DEST]
    movzx ebx, byte [ebp + W_WEST_CONNECTED_MAP + CONN_STRIP_LENGTH] ; B = row count
    mov al, [ebp + W_WEST_CONNECTED_MAP + CONN_MAP_WIDTH]
    mov [ebp + H_MAP_WIDTH], al                                      ; hEWConnectedMapWidth
    call LoadEastWestConnectionsTileMap

.east_connection:
    cmp byte [ebp + W_EAST_CONNECTED_MAP], MAP_NO_CONNECTION
    je  .done
    movzx esi, word [ebp + W_EAST_CONNECTED_MAP + CONN_STRIP_SRC]
    movzx edx, word [ebp + W_EAST_CONNECTED_MAP + CONN_STRIP_DEST]
    movzx ebx, byte [ebp + W_EAST_CONNECTED_MAP + CONN_STRIP_LENGTH]
    mov al, [ebp + W_EAST_CONNECTED_MAP + CONN_MAP_WIDTH]
    mov [ebp + H_MAP_WIDTH], al
    call LoadEastWestConnectionsTileMap

.done:
    pop ecx
    pop ebx
    pop edi
    pop esi
    ret

; ---------------------------------------------------------------------------
; LoadNorthSouthConnectionsTileMap — faithful translation.
; Pret ref: home/overworld.asm:LoadNorthSouthConnectionsTileMap
;
; Copies MAP_BORDER (3) rows of the connected map's edge into the wOverworldMap
; border. Each row copies hNorthSouthConnectionStripWidth (=H_MAP_STRIDE) bytes;
; src advances by hNorthSouthConnectedMapWidth (=H_MAP_WIDTH), dest by the
; wOverworldMap stride (wCurMapWidth + 2*MAP_BORDER).
;
; In:  ESI = HL = strip src, EDX = DE = strip dest, [H_MAP_STRIDE] = strip width,
;      [H_MAP_WIDTH] = connected-map width. EBP = GB base.
; Clobbers: EAX, EBX, ECX, ESI, EDX.
; ---------------------------------------------------------------------------
LoadNorthSouthConnectionsTileMap:
    mov ecx, MAP_BORDER                  ; C = 3 rows
.row:
    push esi
    push edx
    movzx ebx, byte [ebp + H_MAP_STRIDE] ; B = strip width
.inner:
    mov al, [ebp + esi]
    mov [ebp + edx], al
    inc esi
    inc edx
    dec bl
    jnz .inner
    pop edx
    pop esi
    movzx eax, byte [ebp + H_MAP_WIDTH]  ; src += connected-map width
    add esi, eax
    movzx eax, byte [ebp + W_CUR_MAP_WIDTH]
    add eax, MAP_BORDER * 2
    add edx, eax                         ; dest += wOverworldMap stride
    dec ecx
    jnz .row
    ret

; ---------------------------------------------------------------------------
; LoadEastWestConnectionsTileMap — faithful translation.
; Pret ref: home/overworld.asm:LoadEastWestConnectionsTileMap
;
; Copies MAP_BORDER (3) columns of the connected map's edge into the
; wOverworldMap border, for B (strip length) rows. Each row copies 3 bytes; src
; advances by hEastWestConnectedMapWidth (=H_MAP_WIDTH), dest by the wOverworldMap
; stride. (Pallet Town has no E/W connection, but kept faithful for completeness.)
;
; In:  ESI = HL = strip src, EDX = DE = strip dest, BL = row count,
;      [H_MAP_WIDTH] = connected-map width. EBP = GB base.
; Clobbers: EAX, EBX(bl=counter), ECX, ESI, EDX.
; ---------------------------------------------------------------------------
LoadEastWestConnectionsTileMap:
.row:
    push esi
    push edx
    mov ecx, MAP_BORDER                  ; 3 columns
.inner:
    mov al, [ebp + esi]
    mov [ebp + edx], al
    inc esi
    inc edx
    dec ecx
    jnz .inner
    pop edx
    pop esi
    movzx eax, byte [ebp + H_MAP_WIDTH]  ; src += connected-map width
    add esi, eax
    movzx eax, byte [ebp + W_CUR_MAP_WIDTH]
    add eax, MAP_BORDER * 2
    add edx, eax                         ; dest += wOverworldMap stride
    dec bl
    jnz .row
    ret

; ---------------------------------------------------------------------------
; DrawTileBlock — faithful translation.
; Pret ref: home/overworld.asm:DrawTileBlock
;
; Expands one 4×4 map block into tile IDs in wSurroundingTiles.
;
; In:  ESI = write ptr in wSurroundingTiles (HL)
;      BL  = block ID (C)
; Out: ESI advanced by 4*SURROUNDING_WIDTH (past all 4 tile rows of this block)
;      BL unchanged (saved/restored by caller via push/pop ecx before call)
; Clobbers: AL, ECX (internal row counter), EDX (tile data source ptr)
; ---------------------------------------------------------------------------
DrawTileBlock:
    push ecx
    push edx

    ; Compute tile data source: [EBP + wTilesetBlocksPtr + blockID*16]
    movzx edx, word [ebp + W_TILESET_BLOCKS_PTR]  ; EDX = 0x4600 (DE in SM83)
    movzx eax, bl                                  ; EAX = blockID (C in SM83)
    shl eax, 4                                     ; EAX = blockID * 16
    add edx, eax                                   ; EDX = pointer into blockset

    ; TEMPORARY (no GB equivalent — remove once map data is extended): clamp
    ; out-of-range block IDs to block 0 (the black/border tile). The extended
    ; 40×25-tile draw can pull the camera viewport into uninitialized
    ; wOverworldMap padding, handing us a block ID past the embedded blockset;
    ; without this the tile read walks off the blockset and paints garbage. This
    ; is a stopgap: the plan is to extend the map data so those regions hold real
    ; blocks (no blank area exists), at which point this clamp is dead code and
    ; should be deleted. See TODO.md (Phase 2) and CLAUDE.md.
    cmp edx, OW_BLOCKS_GBADDR + OVERWORLD_BLOCKS_SIZE
    jb  .block_in_range
    mov edx, OW_BLOCKS_GBADDR
.block_in_range:

    mov cl, BLOCK_HEIGHT                           ; CL = 4 (row count)

.draw_row:
    push ecx
    ; Tiles 0–2: write to [ESI] with post-increment
    mov al, byte [ebp + edx]
    mov byte [ebp + esi], al
    inc esi
    inc edx
    mov al, byte [ebp + edx]
    mov byte [ebp + esi], al
    inc esi
    inc edx
    mov al, byte [ebp + edx]
    mov byte [ebp + esi], al
    inc esi
    inc edx
    ; Tile 3: write to [ESI] without incrementing ESI (SM83: ld [hl], a)
    mov al, byte [ebp + edx]
    mov byte [ebp + esi], al
    inc edx
    ; Advance ESI to start of next tile row: +45 = SURROUNDING_WIDTH - (BLOCK_WIDTH-1)
    add esi, SURROUNDING_WIDTH - BLOCK_WIDTH + 1   ; = 48 - 4 + 1 = 45
    pop ecx
    dec cl
    jnz .draw_row

    pop edx
    pop ecx
    ret

; ---------------------------------------------------------------------------
; LoadCurrentMapView — faithful translation.
; Pret ref: home/overworld.asm:LoadCurrentMapView
;
; Reads SCREEN_BLOCK_HEIGHT×SCREEN_BLOCK_WIDTH blocks from wOverworldMap
; (starting at wCurrentTileBlockMapViewPointer) and expands each via
; DrawTileBlock into wSurroundingTiles (SURROUNDING_WIDTH×SURROUNDING_HEIGHT).
; Then adjusts for wYBlockCoord/wXBlockCoord and copies the 20×18 view to
; wTileMap.
;
; The bank-switch (BankswitchCommon) is a no-op in the flat model.
; ---------------------------------------------------------------------------
LoadCurrentMapView:
    push esi
    push edi
    push ebx
    push ecx

    ; ; TODO-HW: BankswitchCommon (flat model — no-op)

    ; DE = wCurrentTileBlockMapViewPointer (block map source ptr)
    movzx edx, word [ebp + W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR]

    ; HL = ESI = wSurroundingTiles (tile write destination)
    mov esi, W_SURROUNDING_TILES

    ; B (BH) = SCREEN_BLOCK_HEIGHT outer loop count
    mov bh, SCREEN_BLOCK_HEIGHT

.row_loop:
    push esi                                       ; save row-start of wSurroundingTiles
    push edx                                       ; save row-start of block map

    mov cl, SCREEN_BLOCK_WIDTH                     ; CL = C = inner block count

.row_inner_loop:
    push ecx                                       ; push bc (saves CL=inner count)
    push edx                                       ; push de
    push esi                                       ; push hl

    ; STOPGAP (no GB equivalent — remove once map data is extended): the 40×25
    ; viewport is larger than the GB's 20×18, so a player-centered camera near a
    ; map edge reaches past wOverworldMap. wOverworldMap ($E580) sits directly
    ; above wSurroundingTiles ($E000) in WRAM, so reads above its top border land
    ; in the tile buffer and decode tile IDs as block IDs → a garbage band. Any
    ; read outside [wOverworldMap, wOverworldMapEnd) instead yields the map's
    ; border block, so the extended/out-of-map area renders as clean dummy tiles
    ; (matching the in-bounds border) rather than garbage. See CLAUDE.md / TODO.md:
    ; the real fix is to extend map data to fill the larger viewport.
    cmp edx, W_OVERWORLD_MAP
    jb  .oobBlock
    cmp edx, W_OVERWORLD_MAP + W_OVERWORLD_MAP_SIZE
    jae .oobBlock
    movzx eax, byte [ebp + edx]                   ; A = block ID from wOverworldMap
    jmp .haveBlock
.oobBlock:
    movzx eax, byte [ebp + W_MAP_BACKGROUND_TILE] ; dummy = map border block
.haveBlock:
    mov bl, al                                     ; BL = block ID arg to DrawTileBlock (C)
    call DrawTileBlock                             ; writes 4×4 tiles to [EBP+ESI..]
                                                   ; ECX preserved by DrawTileBlock

    pop esi                                        ; pop hl (restore wSurroundingTiles ptr)
    pop edx                                        ; pop de (restore block map ptr)
    pop ecx                                        ; pop bc (restores CL=inner count)

    add esi, BLOCK_WIDTH                           ; HL += 4 (next block column in wSurroundingTiles)
    inc edx                                        ; DE++ (next block in block-map row)
    dec cl                                         ; dec C (inner count, not block ID)
    jnz .row_inner_loop

    ; Advance block-map pointer to next row
    pop edx                                        ; restore row-start of block map
    movzx eax, byte [ebp + W_CUR_MAP_WIDTH]
    add al, MAP_BORDER * 2                         ; stride = width + 6
    add edx, eax                                   ; EDX += stride (next block-map row)

    ; Advance wSurroundingTiles pointer to next block row (4 tile rows down)
    pop esi                                        ; restore row-start of wSurroundingTiles
    add esi, SURROUNDING_WIDTH * BLOCK_HEIGHT      ; ESI += 96 (= 24 * 4)

    dec bh                                         ; dec B (outer row count)
    jnz .row_loop

    ; --- Adjust for sub-block Y coordinate ---
    mov esi, W_SURROUNDING_TILES                   ; reset HL to base of wSurroundingTiles

    cmp byte [ebp + W_Y_BLOCK_COORD], 0
    je  .adjust_x_coord
    add esi, SURROUNDING_WIDTH * 2                 ; skip 2 tile rows (bottom half of block)

.adjust_x_coord:
    cmp byte [ebp + W_X_BLOCK_COORD], 0
    je  .copy_to_tilemap
    add esi, BLOCK_WIDTH / 2                       ; skip 2 tiles (right half of block)

.copy_to_tilemap:
    ; decoord 0,0 → wTileMap = W_TILEMAP
    mov edx, W_TILEMAP                             ; EDX = DE = wTileMap dest ptr

    mov bh, SCREEN_HEIGHT                          ; BH = B = 25 (row count)

.copy_row_loop:
    mov bl, SCREEN_WIDTH                           ; BL = C = 40 (col count)

.copy_col_loop:
    mov al, byte [ebp + esi]
    mov byte [ebp + edx], al
    inc esi
    inc edx
    dec bl
    jnz .copy_col_loop

    ; Skip SURROUNDING_WIDTH - SCREEN_WIDTH = 8 bytes to reach next row in wSurroundingTiles
    add esi, SURROUNDING_WIDTH - SCREEN_WIDTH      ; = 48 - 40 = 8
    dec bh
    jnz .copy_row_loop

    ; ; TODO-HW: BankswitchCommon restore (flat model — no-op)

    pop ecx
    pop ebx
    pop edi
    pop esi
    ret

; ---------------------------------------------------------------------------
; CopyMapViewToVRAM — faithful translation.
; Pret ref: home/overworld.asm:CopyMapViewToVRAM / CopyMapViewToVRAM2
;
; Copies wTileMap (SCREEN_TILES_H×SCREEN_TILES_W = 25×40) to vBGMap0.
; Each 40-tile row is split: first 32 tiles fill a VRAM row, remaining 8
; wrap to columns 0-7 of the same VRAM row (handled by the tile-blitter's
; (SCX/8+col)&31 modular addressing).
; ---------------------------------------------------------------------------
; AdvancePlayerSprite — faithful translation.
; Pret ref: home/overworld.asm:AdvancePlayerSprite +
;           engine/overworld/advance_player_sprite.asm:_AdvancePlayerSprite
;
; Runs once per advanced frame of a walk. Decrements wWalkCounter; on the first
; frame (counter == 7) it slides wMapViewVRAMPointer by 2 tiles, advances the
; tile-block-map pointer when a block boundary is crossed, rebuilds the map view,
; and schedules the newly exposed row/column for VBlank redraw. Every frame it
; scrolls the BG by 2 px (hSCX/hSCY) in the direction of motion.
;
; Phase 2 omissions vs. pret: wUpdateSprites save/restore, IsSpinning, and the
; Pikachu overworld-state flag.
;
; b (SM83) = wSpritePlayerStateData1YStepVector → kept in BL  (+1 / -1 / 0)
; c (SM83) = wSpritePlayerStateData1XStepVector → kept in CL  (+1 / -1 / 0)
; ---------------------------------------------------------------------------
AdvancePlayerSprite:
    push eax
    push ebx
    push ecx
    push edx

    mov bl, [ebp + W_SPRITE_PLAYER_Y_STEP_VECTOR]    ; BL = b (Y step)
    mov cl, [ebp + W_SPRITE_PLAYER_X_STEP_VECTOR]    ; CL = c (X step)

    dec byte [ebp + W_WALK_COUNTER]
    jnz .afterUpdateMapCoords
    ; end of animation → commit the player's map coordinates
    mov al, [ebp + W_Y_COORD]
    add al, bl
    mov [ebp + W_Y_COORD], al
    mov al, [ebp + W_X_COORD]
    add al, cl
    mov [ebp + W_X_COORD], al
    call CheckMapConnections
    jc .transitionExit                         ; CF=1 → map changed, abort frame
.afterUpdateMapCoords:
    cmp byte [ebp + W_WALK_COUNTER], 7
    jne .scroll                                       ; only the first frame slides the view

    jmp .adjustXCoordWithinBlock

.adjustXCoordWithinBlock:
    mov al, [ebp + W_X_BLOCK_COORD]
    add al, cl
    mov [ebp + W_X_BLOCK_COORD], al
    cmp al, 0x02
    jne .checkForMoveToWestBlock
    ; crossed into the block to the east
    mov byte [ebp + W_X_BLOCK_COORD], 0
    inc byte [ebp + W_X_OFFSET_SINCE_LAST_SPECIAL_WARP]
    call MoveTileBlockMapPointerEast
    jmp .updateMapView
.checkForMoveToWestBlock:
    cmp al, 0xFF
    jne .adjustYCoordWithinBlock
    ; crossed into the block to the west
    mov byte [ebp + W_X_BLOCK_COORD], 1
    dec byte [ebp + W_X_OFFSET_SINCE_LAST_SPECIAL_WARP]
    call MoveTileBlockMapPointerWest
    jmp .updateMapView
.adjustYCoordWithinBlock:
    mov al, [ebp + W_Y_BLOCK_COORD]
    add al, bl
    mov [ebp + W_Y_BLOCK_COORD], al
    cmp al, 0x02
    jne .checkForMoveToNorthBlock
    ; crossed into the block to the south
    mov byte [ebp + W_Y_BLOCK_COORD], 0
    inc byte [ebp + W_Y_OFFSET_SINCE_LAST_SPECIAL_WARP]
    mov al, [ebp + W_CUR_MAP_WIDTH]
    call MoveTileBlockMapPointerSouth
    jmp .updateMapView
.checkForMoveToNorthBlock:
    cmp al, 0xFF
    jne .scroll
    ; crossed into the block to the north
    mov byte [ebp + W_Y_BLOCK_COORD], 1
    dec byte [ebp + W_Y_OFFSET_SINCE_LAST_SPECIAL_WARP]
    mov al, [ebp + W_CUR_MAP_WIDTH]
    call MoveTileBlockMapPointerNorth

.updateMapView:
    call LoadCurrentMapView

.scroll:
    ; Sprite-shift loop: slide each NPC's screen position by 2*step pixels to
    ; keep them world-anchored while the BG scrolls under the player.
    ; Pret ref: engine/overworld/advance_player_sprite.asm lines 162-192.
    push esi
    mov bl, [ebp + W_SPRITE_PLAYER_Y_STEP_VECTOR]
    add bl, bl                                          ; BL = 2 * Ystep (+2/-2/0)
    mov cl, [ebp + W_SPRITE_PLAYER_X_STEP_VECTOR]
    add cl, cl                                          ; CL = 2 * Xstep
    mov esi, W_SPRITE_STATE_DATA_1 + 0x10 + SPRITESTATEDATA1_YPIXELS  ; slot 1 YPixels
    mov edx, 15                                         ; 15 NPC/Pikachu slots
.spriteShift:
    mov al, [ebp + esi]
    sub al, bl
    mov [ebp + esi], al                                 ; YPixels -= 2*Ystep
    mov al, [ebp + esi + 2]                             ; XPixels is YPIXELS+2 in data1
    sub al, cl
    mov [ebp + esi + 2], al                             ; XPixels -= 2*Xstep
    add esi, 0x10                                       ; next slot
    dec edx
    jnz .spriteShift
    pop esi
    ; hSCY += 2*Yvec ; hSCX += 2*Xvec
    mov al, [ebp + W_SPRITE_PLAYER_Y_STEP_VECTOR]
    add al, al
    add [ebp + H_SCY], al
    mov al, [ebp + W_SPRITE_PLAYER_X_STEP_VECTOR]
    add al, al
    add [ebp + H_SCX], al

    pop edx
    pop ecx
    pop ebx
    pop eax
    clc                                        ; CF=0 → no transition
    ret

.transitionExit:
    ; CheckMapConnections set CF=1 → propagate up to caller
    pop edx
    pop ecx
    pop ebx
    pop eax
    stc                                        ; CF=1 → transition occurred
    ret

; ---------------------------------------------------------------------------
; MoveTileBlockMapPointer{East,West,South,North} — faithful translations.
; Pret ref: engine/overworld/advance_player_sprite.asm
;
; Move wCurrentTileBlockMapViewPointer (the upper-left corner of the visible
; block-map region) by one block in the given direction. South/North take the
; row stride (wCurMapWidth + 2*MAP_BORDER) in AL on entry.
; All registers except the pointer are preserved.
; ---------------------------------------------------------------------------
MoveTileBlockMapPointerEast:
    push eax
    mov al, [ebp + W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR]
    add al, 0x01
    mov [ebp + W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR], al
    jnc .done
    inc byte [ebp + W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR + 1]
.done:
    pop eax
    ret

MoveTileBlockMapPointerWest:
    push eax
    mov al, [ebp + W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR]
    sub al, 0x01
    mov [ebp + W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR], al
    jnc .done
    dec byte [ebp + W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR + 1]
.done:
    pop eax
    ret

MoveTileBlockMapPointerSouth:            ; AL = wCurMapWidth
    push eax
    push ebx
    add al, MAP_BORDER * 2                ; AL = row stride
    movzx ebx, al
    mov al, [ebp + W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR]
    add al, bl
    mov [ebp + W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR], al
    jnc .done
    inc byte [ebp + W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR + 1]
.done:
    pop ebx
    pop eax
    ret

MoveTileBlockMapPointerNorth:            ; AL = wCurMapWidth
    push eax
    push ebx
    add al, MAP_BORDER * 2                ; AL = row stride
    movzx ebx, al
    mov al, [ebp + W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR]
    sub al, bl
    mov [ebp + W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR], al
    jnc .done
    dec byte [ebp + W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR + 1]
.done:
    pop ebx
    pop eax
    ret

; ---------------------------------------------------------------------------
; CollisionCheckOnLand — simplified translation.
; Pret ref: home/overworld.asm:CollisionCheckOnLand (tile-passability path only;
; no sprite collisions, ledges, tile-pair collisions, or simulated input yet).
;
; Out: CF = 1 if the tile the player faces is impassable (movement blocked).
; ---------------------------------------------------------------------------
CollisionCheckOnLand:
%ifdef DEBUG_NOCLIP
    cmp byte [pad_noclip], 0
    jne .passable                 ; noclip active: always passable
%endif
    push eax
    push ecx
    push esi
    call GetTileInFrontOfPlayer                    ; CL = tile in front
    call IsTilePassable                            ; CF = 1 if not passable
    pop esi
    pop ecx
    pop eax
    ret
%ifdef DEBUG_NOCLIP
.passable:
    clc
    ret
%endif

; ---------------------------------------------------------------------------
; GetTileInFrontOfPlayer — simplified translation.
; Pret ref: engine/overworld/player_state.asm:_GetTileAndCoordsInFrontOfPlayer
;
; Reads the tile the player faces from wTileMap at the fixed screen coordinate
; pret uses for each facing (the player is always centered). Stores it in
; wTileInFrontOfPlayer and returns it in CL.
; ---------------------------------------------------------------------------
GetTileInFrontOfPlayer:
    ; Pret ref: engine/overworld/player_state.asm:_GetTileAndCoordsInFrontOfPlayer
    ;   lda_coord c, r  = W_TILEMAP + r*20 + c  (pret 20-wide tilemap)
    ; DOS tilemap is 40 wide; player standing tile = PLAYER_STANDING_ROW=17,
    ; PLAYER_STANDING_COL=24. Fronts are ±2 rows/cols from the standing tile.
    ;
    ;   Down  (row+2, col+0) = (19, 24)
    ;   Up    (row-2, col+0) = (15, 24)
    ;   Left  (row+0, col-2) = (17, 22)
    ;   Right (row+0, col+2) = (17, 26)
    mov al, [ebp + W_SPRITE_PLAYER_FACING_DIR]
    cmp al, SPRITE_FACING_DOWN
    jne .notDown
    mov esi, W_TILEMAP + (PLAYER_STANDING_ROW + 2) * SCREEN_TILES_W + PLAYER_STANDING_COL
    jmp .read
.notDown:
    cmp al, SPRITE_FACING_UP
    jne .notUp
    mov esi, W_TILEMAP + (PLAYER_STANDING_ROW - 2) * SCREEN_TILES_W + PLAYER_STANDING_COL
    jmp .read
.notUp:
    cmp al, SPRITE_FACING_LEFT
    jne .notLeft
    mov esi, W_TILEMAP + PLAYER_STANDING_ROW * SCREEN_TILES_W + (PLAYER_STANDING_COL - 2)
    jmp .read
.notLeft:
    mov esi, W_TILEMAP + PLAYER_STANDING_ROW * SCREEN_TILES_W + (PLAYER_STANDING_COL + 2)
.read:
    movzx ecx, byte [ebp + esi]
    mov [ebp + W_TILE_IN_FRONT_OF_PLAYER], cl
    ret

; ---------------------------------------------------------------------------
; IsTilePassable — faithful translation.
; Pret ref: engine/gfx/sprite_oam.asm:_IsTilePassable
;
; In:  CL = tile ID. Scans the $FF-terminated passable-tile list pointed to by
;      wTilesetCollisionPtr (GB pointer to list in ROM window at OW_COLL_GBADDR).
; Out: CF = 0 if CL is in the list (passable), CF = 1 otherwise.
; Clobbers AL, ESI.
;
; SM83 original:
;   ld hl, wTilesetCollisionPtr  ; load the pointer-to-pointer
;   ld a, [hli]
;   ld h, [hl]
;   ld l, a                       ; HL = *wTilesetCollisionPtr (the actual list address)
;   .loop:
;     ld a, [hli]
;     cp $ff
;     jr z, .tileNotPassable
;     cp c                         ; c = tile to test
;     jr nz, .loop
;     xor a                        ; ZF=1 CF=0 → passable
;     ret
;   .tileNotPassable:
;     scf                          ; CF=1 → not passable
;     ret
; ---------------------------------------------------------------------------
IsTilePassable:
    ; ESI = *wTilesetCollisionPtr (the flat GB address of the passable-tile list)
    movzx esi, word [ebp + W_TILESET_COLLISION_PTR]
.loop:
    mov al, byte [ebp + esi]
    inc esi
    cmp al, 0xFF
    je  .tileNotPassable            ; hit terminator → blocked
    cmp al, cl
    jne .loop                       ; not this tile → keep scanning
    clc                             ; found in list → passable
    ret
.tileNotPassable:
    stc                             ; not found → blocked
    ret

; ---------------------------------------------------------------------------
; LoadMapHeader — faithful translation.
; Pret ref: home/overworld.asm:LoadMapHeader
; ---------------------------------------------------------------------------
LoadMapHeader:
    push eax
    push ebx
    push ecx
    push esi
    push edi
    
    ; W_CUR_MAP_HEADER is a 10-byte buffer: tileset(1), h(1), w(1), blkptr(2), txtptr(2), scrptr(2), conn(1)
    movzx eax, byte [ebp + W_CUR_MAP]
    add eax, eax ; * 2 (MapHeaderPointers table is 2 bytes per entry)
    mov esi, MapHeaderPointers
    movzx ebx, word [esi + eax]
    add ebx, ebp ; EBX = address of map header in flat space (rom window)
    
    ; Copy 10 bytes to W_CUR_MAP_HEADER
    mov esi, ebx
    lea edi, [ebp + W_CUR_MAP_HEADER]
    mov ecx, W_CUR_MAP_HEADER_SIZE
    rep movsb
    
    ; Initialize all 4 connected maps to $FF (disabled) before loading actual values.
    ; Faithful to pret: home/overworld.asm line 1820-1825.
    ; Without this, stale connection data from the previous map persists.
    mov byte [ebp + W_NORTH_CONNECTED_MAP], MAP_NO_CONNECTION
    mov byte [ebp + W_SOUTH_CONNECTED_MAP], MAP_NO_CONNECTION
    mov byte [ebp + W_WEST_CONNECTED_MAP],  MAP_NO_CONNECTION
    mov byte [ebp + W_EAST_CONNECTED_MAP],  MAP_NO_CONNECTION
    
    ; ESI now points past the 10-byte header. Check connections bitmask.
    mov al, [ebp + W_CUR_MAP_CONNECTIONS]
    test al, CONNECTION_NORTH
    jz .noNorth
    mov edi, W_NORTH_CONNECTED_MAP
    call CopyMapConnectionHeader
.noNorth:
    mov al, [ebp + W_CUR_MAP_CONNECTIONS]
    test al, CONNECTION_SOUTH
    jz .noSouth
    mov edi, W_SOUTH_CONNECTED_MAP
    call CopyMapConnectionHeader
.noSouth:
    mov al, [ebp + W_CUR_MAP_CONNECTIONS]
    test al, CONNECTION_WEST
    jz .noWest
    mov edi, W_WEST_CONNECTED_MAP
    call CopyMapConnectionHeader
.noWest:
    mov al, [ebp + W_CUR_MAP_CONNECTIONS]
    test al, CONNECTION_EAST
    jz .noEast
    mov edi, W_EAST_CONNECTED_MAP
    call CopyMapConnectionHeader
.noEast:

    ; ESI now points to object_data_ptr
    movzx eax, word [esi]
    add eax, ebp ; EAX = object data flat address
    
    ; Read border block
    mov bl, [eax]
    mov [ebp + W_MAP_BACKGROUND_TILE], bl
    inc eax
    
    ; Copy warps to W_WARP_ENTRIES
    mov bl, [eax]
    mov [ebp + W_NUMBER_OF_WARPS], bl
    inc eax
    movzx ecx, bl
    shl ecx, 2                          ; * 4 bytes per warp entry
    mov esi, eax
    lea edi, [ebp + W_WARP_ENTRIES]
    rep movsb                           ; copy all warp entries to WRAM
    mov eax, esi                        ; advance EAX past copied warp bytes
    
    ; Skip signs
    mov bl, [eax]
    mov [ebp + W_NUM_SIGNS], bl
    inc eax
    movzx ebx, bl
    lea ebx, [ebx + ebx * 2] ; * 3 bytes per sign
    add eax, ebx
    
    ; Save object data pointer temp
    sub eax, ebp
    mov [ebp + W_OBJECT_DATA_PTR_TEMP], ax
    
    call LoadTilesetHeader
    
    pop edi
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret

CopyMapConnectionHeader:
    push ecx
    push edi
    add edi, ebp
    mov ecx, CONN_HEADER_SIZE
    rep movsb
    pop edi
    pop ecx
    ret

; ---------------------------------------------------------------------------
; LoadTilesetHeader — dynamic dispatch via W_CUR_MAP_TILESET.
; Pret ref: home/overworld.asm:LoadTilesetHeader
; Copies current tileset gfx/blocks/coll from .data section → fixed EBP slots,
; then sets g_tilecache_dirty so render_bg rebuilds the decoded-tile cache.
; ---------------------------------------------------------------------------
LoadTilesetHeader:
    push eax
    push ebx
    push esi
    push edi
    push ecx

    movzx eax, byte [ebp + W_CUR_MAP_TILESET]   ; tileset index 0-24

    ; Copy tileset GFX to fixed EBP slot
    mov esi, [TilesetGfxPtrs + eax*4]
    lea edi, [ebp + OW_GFX_GBADDR]
    mov ecx, [TilesetGfxSizes + eax*4]
    rep movsb

    ; Copy blockset to fixed EBP slot
    mov esi, [TilesetBlocksPtrs + eax*4]
    lea edi, [ebp + OW_BLOCKS_GBADDR]
    mov ecx, [TilesetBlocksSizes + eax*4]
    rep movsb

    ; Copy collision list to fixed EBP slot (max 64 bytes, $FF-terminated)
    mov esi, [TilesetCollPtrs + eax*4]
    lea edi, [ebp + OW_COLL_GBADDR]
    mov ecx, 64
    rep movsb

    ; Mark tile cache dirty — render_bg must rebuild decoded tiles
    mov byte [g_tilecache_dirty], 1

    ; Populate tileset header fields in WRAM (stub values; grass/anim tile TBD)
    mov byte [ebp + W_TILESET_BANK], 0x01
    mov word [ebp + W_TILESET_BLOCKS_PTR], OW_BLOCKS_GBADDR
    mov word [ebp + W_TILESET_GFX_PTR],   OW_GFX_GBADDR
    mov word [ebp + W_TILESET_COLLISION_PTR],  OW_COLL_GBADDR
    mov byte [ebp + W_GRASS_TILE],   0xFF  ; no grass (overridden per-tileset later)
    mov byte [ebp + H_TILE_ANIMATIONS], 0x00

    pop ecx
    pop edi
    pop esi
    pop ebx
    pop eax
    ret

; ---------------------------------------------------------------------------
; IgnoreInputForHalfSecond — suppress player input for ~30 frames after a warp.
; Sets wIgnoreInputCounter=30 and BIT_DISABLE_JOYPAD in wStatusFlags5.
; The countdown runs at the top of OverworldLoop; joypad is re-enabled when it
; reaches 0. OverworldLoop's idle path skips direction reads while the bit is set.
; Pret ref: home/overworld.asm:IgnoreInputForHalfSecond
; ---------------------------------------------------------------------------
IgnoreInputForHalfSecond:
    mov byte [ebp + W_IGNORE_INPUT_COUNTER], 30
    or byte [ebp + W_STATUS_FLAGS_5], (1 << BIT_DISABLE_JOYPAD) | (1 << 2) | (1 << 1)
    ret

; ---------------------------------------------------------------------------
; IsPlayerStandingOnDoorTile — check if the player's current tile is a door tile.
; Returns CF=1 if yes, CF=0 otherwise (stair, ladder, or unknown tileset).
; Reads W_CUR_MAP_TILESET, looks up DoorTileTable, then checks W_TILEMAP at
; PLAYER_STANDING_ROW/COL (the tile directly under the player sprite).
; All registers preserved.
; Pret ref: engine/overworld/doors.asm:IsPlayerStandingOnDoorTile
; ---------------------------------------------------------------------------
IsPlayerStandingOnDoorTile:
    push eax
    push esi

    movzx eax, byte [ebp + W_CUR_MAP_TILESET]
    mov esi, DoorTileTable

.search_tileset:
    cmp byte [esi], 0xFF               ; end of table → tileset not listed
    je .not_door
    cmp byte [esi], al                 ; tileset match?
    je .found_tileset
    inc esi                            ; skip tileset byte, then scan past 0-terminated tile list
.skip_tiles:
    cmp byte [esi], 0
    je .skip_done
    inc esi
    jmp .skip_tiles
.skip_done:
    inc esi                            ; skip the 0 terminator
    jmp .search_tileset

.found_tileset:
    inc esi                            ; ESI now points at first tile ID for this tileset
    movzx eax, byte [ebp + W_TILEMAP + PLAYER_STANDING_ROW * SCREEN_TILES_W + PLAYER_STANDING_COL]
.check_tile:
    cmp byte [esi], 0
    je .not_door
    cmp [esi], al
    je .is_door
    inc esi
    jmp .check_tile

.is_door:
    pop esi
    pop eax
    stc
    ret
.not_door:
    pop esi
    pop eax
    clc
    ret

; ---------------------------------------------------------------------------
; PlayerStepOutFromDoor — force one auto-step south off a warp-arrival tile.
; Called by RunNPCMovementScript when BIT_STANDING_ON_DOOR is detected.
; Calls IsPlayerStandingOnDoorTile first: if not a door tile (stair/ladder),
; clears the flags with no auto-walk. If on a door tile, sets BIT_EXITING_DOOR
; (suppresses CheckWarpTile) and BIT_SCRIPTED_MOVEMENT_STATE (injects PAD_DOWN
; into the idle-path direction logic for one frame so the normal movement code
; runs the step). Pret ref: engine/overworld/auto_movement.asm:PlayerStepOutFromDoor
; ---------------------------------------------------------------------------
PlayerStepOutFromDoor:
    call IsPlayerStandingOnDoorTile
    jnc .notStandingOnDoor
    ; Door tile — set up one forced south step to walk off the arrival warp tile.
    or byte [ebp + W_MOVEMENT_FLAGS], (1 << BIT_EXITING_DOOR)
    or byte [ebp + W_STATUS_FLAGS_5], (1 << BIT_SCRIPTED_MOVEMENT_STATE)
    mov byte [ebp + W_SIMULATED_JOYPAD_STATES_END], PAD_DOWN
    mov byte [ebp + W_SIMULATED_JOYPAD_STATES_INDEX], 1
    ret
.notStandingOnDoor:
    ; Stair/ladder arrival — no auto-walk. Clear standing and exiting flags.
    ; pret: engine/overworld/auto_movement.asm:PlayerStepOutFromDoor:.notStandingOnDoor
    and byte [ebp + W_MOVEMENT_FLAGS], ~((1 << BIT_STANDING_ON_DOOR) | (1 << BIT_EXITING_DOOR))
    and byte [ebp + W_STATUS_FLAGS_5], ~(1 << BIT_SCRIPTED_MOVEMENT_STATE)
    ret

; ---------------------------------------------------------------------------
; RunNPCMovementScript — dispatch door-exit auto-walk on warp arrival.
; Checks BIT_STANDING_ON_DOOR (set by .warpTransition), clears it, and calls
; PlayerStepOutFromDoor to inject one forced DOWN step and set BIT_EXITING_DOOR.
; Phase 2: door path only. Full NPC movement script dispatch deferred to Phase 3.
; Pret ref: home/npc_movement.asm:RunNPCMovementScript
; ---------------------------------------------------------------------------
RunNPCMovementScript:
    test byte [ebp + W_MOVEMENT_FLAGS], (1 << BIT_STANDING_ON_DOOR)
    jz .done
    and byte [ebp + W_MOVEMENT_FLAGS], ~(1 << BIT_STANDING_ON_DOOR)
    call PlayerStepOutFromDoor
.done:
    ret

; ---------------------------------------------------------------------------
; CheckWarpTile — scan W_WARP_ENTRIES for a player coord match.
; Returns CF=1 if a warp matches; BL = resolved destination map ID;
; W_DESTINATION_WARP_ID = 0-based warp index in the destination map.
; Returns CF=0 if no match.
; Pret ref: home/overworld.asm:CheckForWarpTile (approach)
; ---------------------------------------------------------------------------
CheckWarpTile:
    push eax
    push ecx
    push esi

    movzx ecx, byte [ebp + W_NUMBER_OF_WARPS]
    test ecx, ecx
    jz .none
    mov al, [ebp + W_Y_COORD]
    mov ah, [ebp + W_X_COORD]
    lea esi, [ebp + W_WARP_ENTRIES]
.loop:
    cmp al, [esi]               ; Y match?
    jne .next
    cmp ah, [esi+1]             ; X match?
    jne .next
    mov bl, [esi+2]             ; dest_warp_id (0-based index in dest map)
    mov [ebp + W_DESTINATION_WARP_ID], bl
    mov bl, [esi+3]             ; dest_map_id (0xFF = LAST_MAP)
    cmp bl, 0xFF
    jne .found
    mov bl, [ebp + W_LAST_MAP]  ; resolve LAST_MAP to the previous map
.found:
    pop esi
    pop ecx
    pop eax
    stc
    ret
.next:
    add esi, 4
    dec ecx
    jnz .loop
.none:
    pop esi
    pop ecx
    pop eax
    clc
    ret

; ---------------------------------------------------------------------------
; LoadWarpDestination — load the destination map after a warp transition.
; Preconditions: W_CUR_MAP = destination map ID already set by caller;
;                W_DESTINATION_WARP_ID = 0-based index into that map's warp
;                table, used to resolve the player spawn coords.
; ---------------------------------------------------------------------------
LoadWarpDestination:
    push eax
    push ebx
    push ecx
    push esi
    push edi

    ; Indoor maps use a shared EBP slot (INDOOR_BLK_GBADDR).  Copy this map's
    ; .blk bytes there before calling LoadMapHeader, which reads blk_ptr=0x7600
    ; from the header and stores it in W_CUR_MAP_DATA_PTR → LoadTileBlockMap
    ; then reads the block layout from that address.
    movzx eax, byte [ebp + W_CUR_MAP]
    cmp eax, FIRST_INDOOR_MAP_ID
    jb .outdoor
    sub eax, FIRST_INDOOR_MAP_ID              ; 0-based table index
    mov esi, [IndoorMapBlkPtrs + eax*4]       ; flat DS label for this map's .blk
    lea edi, [ebp + INDOOR_BLK_GBADDR]
    mov ecx, [IndoorMapBlkSizes + eax*4]      ; byte count
    rep movsb
.outdoor:
    ; Load map header: copies fixed header to WRAM, copies warp entries to
    ; W_WARP_ENTRIES, and calls LoadTilesetHeader (which swaps tileset data
    ; into the fixed EBP ROM-window slots and sets g_tilecache_dirty).
    call LoadMapHeader

    ; After a tileset switch, copy GFX from OW_GFX_GBADDR → GB_VCHARS2 so
    ; render_bg rebuilds the tile decode cache from the new tileset.
    call LoadTilesetTilePatternData

    ; Resolve spawn coords from the destination map's warp table.
    ; W_DESTINATION_WARP_ID is the 0-based index set by CheckWarpTile.
    movzx eax, byte [ebp + W_DESTINATION_WARP_ID]
    shl eax, 2                                ; * 4 bytes per entry
    lea esi, [ebp + W_WARP_ENTRIES]
    add esi, eax
    mov al, [esi]                             ; spawn Y tile
    mov [ebp + W_Y_COORD], al
    and al, 1
    mov [ebp + W_Y_BLOCK_COORD], al
    mov al, [esi+1]                           ; spawn X tile
    mov [ebp + W_X_COORD], al
    and al, 1
    mov [ebp + W_X_BLOCK_COORD], al

    ; Recompute W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR from the spawn coordinates.
    ;   stride   = W_CUR_MAP_WIDTH + 2*MAP_BORDER
    ;   view_row = block_y + MAP_BORDER - SCREEN_BLOCK_HEIGHT/2   (block_y = Y/2)
    ;   view_col = block_x + MAP_BORDER - SCREEN_BLOCK_WIDTH/2    (block_x = X/2)
    ;   ptr      = W_OVERWORLD_MAP + view_row * stride + view_col
    movzx eax, byte [ebp + W_CUR_MAP_WIDTH]
    add eax, MAP_BORDER * 2                   ; EAX = stride

    movzx ebx, byte [ebp + W_Y_COORD]
    shr ebx, 1                                ; EBX = block_y
    add ebx, MAP_BORDER
    sub ebx, SCREEN_BLOCK_HEIGHT / 2          ; EBX = view_row

    movzx ecx, byte [ebp + W_X_COORD]
    shr ecx, 1                                ; ECX = block_x
    add ecx, MAP_BORDER
    sub ecx, SCREEN_BLOCK_WIDTH / 2           ; ECX = view_col

    imul eax, ebx                             ; EAX = view_row * stride
    add eax, ecx                              ; + view_col
    add eax, W_OVERWORLD_MAP                  ; + base = EBP-relative ptr
    mov [ebp + W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR], ax

    call LoadTileBlockMap
    call LoadCurrentMapView

    ; Reset turn state: player spawns stopped, so the next press should turn
    ; first rather than immediately walking (prevents accidental exit on entry).
    mov byte [ebp + W_CHECK_FOR_TURN], 1
    mov byte [ebp + W_PLAYER_LAST_STOP_DIRECTION], 0
    mov byte [ebp + W_PLAYER_MOVING_DIRECTION], 0

    pop edi
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret

; ---------------------------------------------------------------------------
; CheckMapConnections — faithful translation.
; Pret ref: home/overworld.asm:CheckMapConnections
; ---------------------------------------------------------------------------
CheckMapConnections:
    push ebx
    push edx

    ; Edge thresholds
    mov al, [ebp + W_CUR_MAP_HEIGHT]
    add al, al
    mov [ebp + W_CURRENT_MAP_HEIGHT_2], al
    mov al, [ebp + W_CUR_MAP_WIDTH]
    add al, al
    mov [ebp + W_CURRENT_MAP_WIDTH_2], al

    ; East connection check
    mov al, [ebp + W_X_COORD]
    cmp al, [ebp + W_CURRENT_MAP_WIDTH_2]
    jne .checkWest
    mov al, [ebp + W_EAST_CONNECTED_MAP]
    cmp al, MAP_NO_CONNECTION
    je .checkWest
    mov ebx, W_EAST_CONNECTED_MAP
    
    mov [ebp + W_CUR_MAP], al
    mov al, [ebp + W_EAST_CONNECTED_MAP + CONN_X_ALIGN]
    mov [ebp + W_X_COORD], al
    mov al, [ebp + W_Y_COORD]
    mov cl, al
    mov al, [ebp + W_EAST_CONNECTED_MAP + CONN_Y_ALIGN]
    add cl, al
    mov [ebp + W_Y_COORD], cl
    
    mov al, [ebp + W_EAST_CONNECTED_MAP + CONN_VIEW_PTR]
    mov dl, al
    mov al, [ebp + W_EAST_CONNECTED_MAP + CONN_VIEW_PTR + 1]
    mov dh, al
    
    shr cl, 1
    jz .savePointer2
    
.pointerAdjustmentLoop2:
    mov al, [ebp + W_EAST_CONNECTED_MAP + CONN_MAP_WIDTH]
    add al, MAP_BORDER * 2
    movzx eax, al
    add edx, eax
    dec cl
    jnz .pointerAdjustmentLoop2
.savePointer2:
    mov [ebp + W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR], dx
    jmp .loadNewMap

.checkWest:
    mov al, [ebp + W_X_COORD]
    cmp al, 255
    jne .checkSouth
    mov al, [ebp + W_WEST_CONNECTED_MAP]
    cmp al, MAP_NO_CONNECTION
    je .checkSouth
    mov ebx, W_WEST_CONNECTED_MAP
    
    mov [ebp + W_CUR_MAP], al
    mov al, [ebp + W_WEST_CONNECTED_MAP + CONN_X_ALIGN]
    mov [ebp + W_X_COORD], al
    mov al, [ebp + W_Y_COORD]
    mov cl, al
    mov al, [ebp + W_WEST_CONNECTED_MAP + CONN_Y_ALIGN]
    add cl, al
    mov [ebp + W_Y_COORD], cl
    
    mov al, [ebp + W_WEST_CONNECTED_MAP + CONN_VIEW_PTR]
    mov dl, al
    mov al, [ebp + W_WEST_CONNECTED_MAP + CONN_VIEW_PTR + 1]
    mov dh, al
    
    shr cl, 1
    jz .savePointer1
    
.pointerAdjustmentLoop1:
    mov al, [ebp + W_WEST_CONNECTED_MAP + CONN_MAP_WIDTH]
    add al, MAP_BORDER * 2
    movzx eax, al
    add edx, eax
    dec cl
    jnz .pointerAdjustmentLoop1
.savePointer1:
    mov [ebp + W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR], dx
    jmp .loadNewMap

.checkSouth:
    mov al, [ebp + W_Y_COORD]
    cmp al, [ebp + W_CURRENT_MAP_HEIGHT_2]
    jne .checkNorth
    mov al, [ebp + W_SOUTH_CONNECTED_MAP]
    cmp al, MAP_NO_CONNECTION
    je .checkNorth
    mov ebx, W_SOUTH_CONNECTED_MAP
    
    mov [ebp + W_CUR_MAP], al
    mov al, [ebp + W_SOUTH_CONNECTED_MAP + CONN_Y_ALIGN]
    mov [ebp + W_Y_COORD], al
    mov al, [ebp + W_X_COORD]
    mov cl, al
    mov al, [ebp + W_SOUTH_CONNECTED_MAP + CONN_X_ALIGN]
    add cl, al
    mov [ebp + W_X_COORD], cl
    
    mov al, [ebp + W_SOUTH_CONNECTED_MAP + CONN_VIEW_PTR]
    mov dl, al
    mov al, [ebp + W_SOUTH_CONNECTED_MAP + CONN_VIEW_PTR + 1]
    mov dh, al
    
    shr cl, 1
    jz .savePointer4
    movzx ecx, cl
    add edx, ecx
.savePointer4:
    mov [ebp + W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR], dx
    jmp .loadNewMap

.checkNorth:
    mov al, [ebp + W_Y_COORD]
    cmp al, 255
    jne .done
    mov al, [ebp + W_NORTH_CONNECTED_MAP]
    cmp al, MAP_NO_CONNECTION
    je .done
    mov ebx, W_NORTH_CONNECTED_MAP
    
    mov [ebp + W_CUR_MAP], al
    mov al, [ebp + W_NORTH_CONNECTED_MAP + CONN_Y_ALIGN]
    mov [ebp + W_Y_COORD], al
    mov al, [ebp + W_X_COORD]
    mov cl, al
    mov al, [ebp + W_NORTH_CONNECTED_MAP + CONN_X_ALIGN]
    add cl, al
    mov [ebp + W_X_COORD], cl
    
    mov al, [ebp + W_NORTH_CONNECTED_MAP + CONN_VIEW_PTR]
    mov dl, al
    mov al, [ebp + W_NORTH_CONNECTED_MAP + CONN_VIEW_PTR + 1]
    mov dh, al
    
    shr cl, 1
    jz .savePointer3
    movzx ecx, cl
    add edx, ecx
.savePointer3:
    mov [ebp + W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR], dx
    jmp .loadNewMap

.done:
    pop edx
    pop ebx
    clc                                        ; CF=0 → no transition
    ret

.loadNewMap:
    ; A connection was crossed. Return CF=1 to signal the caller.
    ; First, synchronize block coordinates with the new tile coordinates.
    mov al, [ebp + W_X_COORD]
    and al, 1
    mov [ebp + W_X_BLOCK_COORD], al
    mov al, [ebp + W_Y_COORD]
    and al, 1
    mov [ebp + W_Y_BLOCK_COORD], al

    pop edx
    pop ebx
    stc                                        ; CF=1 → transition occurred
    ret

; ---------------------------------------------------------------------------
; Embedded overworld asset data (Phase 2 scaffold).
; gen_overworld_assets.py regenerates these from source binaries.
; ---------------------------------------------------------------------------

section .data

; Door tile IDs per tileset — pret ref: data/tilesets/door_tile_ids.asm
; Format: tileset_id, tile_id..., 0  (one entry per tileset); 0xFF = end table.
; IsPlayerStandingOnDoorTile scans this to decide whether the arrival tile
; after a warp is a building entrance/exit (needs auto-walk) or a stair/ladder (skip).
DoorTileTable:
    db  0, 0x1B, 0x58, 0       ; OVERWORLD
    db  2, 0x5E, 0             ; MART
    db  3, 0x3A, 0             ; FOREST
    db  8, 0x54, 0             ; HOUSE
    db  9, 0x3B, 0             ; FOREST_GATE
    db 10, 0x3B, 0             ; MUSEUM
    db 12, 0x3B, 0             ; GATE
    db 13, 0x1E, 0             ; SHIP
    db 16, 0x04, 0x15, 0       ; INTERIOR
    db 18, 0x1C, 0x38, 0x1A, 0 ; LOBBY
    db 19, 0x1A, 0x1C, 0x53, 0 ; MANSION
    db 20, 0x34, 0             ; LAB
    db 22, 0x43, 0x58, 0x1B, 0 ; FACILITY
    db 23, 0x3B, 0x1B, 0       ; PLATEAU
    db 0xFF                     ; end

section .rodata

%include "assets/overworld_gfx.inc"
%include "assets/overworld_blocks.inc"
%include "assets/pallet_town_blk.inc"
%include "assets/route1_blk.inc"
%include "assets/route21_blk.inc"
%include "assets/viridian_city_blk.inc"
%include "assets/pewter_city_blk.inc"
%include "assets/cerulean_city_blk.inc"
%include "assets/lavender_town_blk.inc"
%include "assets/vermilion_city_blk.inc"
%include "assets/celadon_city_blk.inc"
%include "assets/fuchsia_city_blk.inc"
%include "assets/cinnabar_island_blk.inc"
%include "assets/saffron_city_blk.inc"
%include "assets/route2_blk.inc"
%include "assets/route3_blk.inc"
%include "assets/route4_blk.inc"
%include "assets/route5_blk.inc"
%include "assets/route6_blk.inc"
%include "assets/route7_blk.inc"
%include "assets/route8_blk.inc"
%include "assets/route9_blk.inc"
%include "assets/route10_blk.inc"
%include "assets/route11_blk.inc"
%include "assets/route12_blk.inc"
%include "assets/route13_blk.inc"
%include "assets/route14_blk.inc"
%include "assets/route15_blk.inc"
%include "assets/route16_blk.inc"
%include "assets/route17_blk.inc"
%include "assets/route18_blk.inc"
%include "assets/route19_blk.inc"
%include "assets/route20_blk.inc"
%include "assets/route22_blk.inc"
%include "assets/route24_blk.inc"
%include "assets/route25_blk.inc"
%include "assets/overworld_coll.inc"
%include "assets/player_sprite.inc"
%include "assets/npc_girl_still.inc"
%include "assets/npc_fisher_still.inc"
%include "assets/npc_oak_still.inc"
%include "assets/map_headers.inc"
%include "assets/extra_includes.inc"
