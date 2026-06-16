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

; wCurrentTileBlockMapViewPointer for Pallet Town at block origin (0,0):
;   wOverworldMap + MAP_BORDER * stride + MAP_BORDER
;   stride = PALLET_TOWN_WIDTH + 2*MAP_BORDER = 10 + 6 = 16
;   = 0xC6E8 + 3*16 + 3 = 0xC6E8 + 51 = 0xC71B
PALLET_TOWN_VIEW_PTR        equ W_OVERWORLD_MAP + MAP_BORDER * (PALLET_TOWN_WIDTH + MAP_BORDER * 2) + MAP_BORDER

; Number of connections in the Block/Connect strips (0xFF = none — disables strip loading)
MAP_NO_CONNECTION           equ 0xFF

; Pallet Town map connections (computed from the pret `connection` macro for the
; north=Route1 / south=Route21 connections, both at offset 0). See
; macros/scripts/maps.asm:connection. Route1 = 10×18, Route21 = 10×45.
MAP_ID_ROUTE_1              equ 0x0C
MAP_ID_ROUTE_21             equ 0x20
CONNECTION_NORTH           equ 1 << 3   ; wCurMapConnections bits (EAST=1,WEST=2,SOUTH=4,NORTH=8)
CONNECTION_SOUTH           equ 1 << 2

; north (Route1): _blk = ROUTE1_W*(ROUTE1_H-3) = 10*15 = 150; _map = 3;
;   _len = min(CUR_W+3, ROUTE1_W) = 10; _y = ROUTE1_H*2-1 = 35; _x = 0;
;   _win = (ROUTE1_W+6)*ROUTE1_H + 1 = 16*18+1 = 289
NORTH_STRIP_SRC            equ OW_ROUTE1_BLK_GBADDR + 150
NORTH_STRIP_DEST           equ W_OVERWORLD_MAP + 3
NORTH_STRIP_LENGTH         equ 10
NORTH_CONN_MAP_WIDTH       equ 10
NORTH_Y_ALIGN              equ 35
NORTH_X_ALIGN              equ 0
; NOTE: DEAD CODE. The live north view pointer is the one emitted into
; assets/map_headers.inc by tools/gen_map_headers.py (currently 0xE691 = base+273)
; and loaded into the connection header by LoadMapHeader. This equ is no longer
; read at runtime (SetupPalletTown, which used it, was removed). Kept only as a
; reference value; edit gen_map_headers.py / map_headers.inc to change behavior.
NORTH_VIEW_PTR             equ W_OVERWORLD_MAP + 273   ; (conn_width+6)*(conn_height-1)+1

; south (Route21): _blk = 0; _map = (CUR_W+6)*(CUR_H+3)+3 = 16*12+3 = 195;
;   _len = min(CUR_W+3, ROUTE21_W) = 10; _y = 0; _x = 0; _win = ROUTE21_W+7 = 17
SOUTH_STRIP_SRC            equ OW_ROUTE21_BLK_GBADDR + 0
SOUTH_STRIP_DEST           equ W_OVERWORLD_MAP + 195
SOUTH_STRIP_LENGTH         equ 10
SOUTH_CONN_MAP_WIDTH       equ 10
SOUTH_Y_ALIGN              equ 0
SOUTH_X_ALIGN              equ 0
SOUTH_VIEW_PTR             equ W_OVERWORLD_MAP + 17

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
    call UpdateSprites                         ; advance player facing + walk animation
    call DelayFrame
.lessDelay:                                  ; OverworldLoopLessDelay
    call DelayFrame

    cmp byte [ebp + W_WALK_COUNTER], 0
    jne .moveAhead                           ; still mid-step → keep walking

    ; --- idle: clear step vectors, then sample the held D-pad ---
    mov byte [ebp + W_SPRITE_PLAYER_Y_STEP_VECTOR], 0
    mov byte [ebp + W_SPRITE_PLAYER_X_STEP_VECTOR], 0
    movzx eax, byte [ebp + H_JOY_HELD]

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
    mov [ebp + W_PLAYER_DIRECTION],        dl
    mov [ebp + W_PLAYER_MOVING_DIRECTION], dl
    mov [ebp + W_SPRITE_PLAYER_FACING_DIR], dh

    call CollisionCheckOnLand                 ; CF = 1 → blocked (face that way, don't move)
    jc OverworldLoop

    mov byte [ebp + W_WALK_COUNTER], 8        ; begin an 8-frame step

.noDirection:
    ; No direction held while standing: zero wPlayerMovingDirection so
    ; UpdatePlayerSprite takes its standing path and stops the walk animation.
    ; (Faithful to home/overworld.asm:.noDirectionButtonsPressed, which zeroes
    ; the moving direction; wPlayerDirection keeps the last facing.)
    mov byte [ebp + W_PLAYER_MOVING_DIRECTION], 0
    jmp OverworldLoop

.moveAhead:
    call AdvancePlayerSprite
    jc .mapTransition                         ; CF=1 means a map connection was crossed
    jmp OverworldLoop

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
    mov byte [ebp + W_SPRITE_PLAYER_Y_PIXELS],        0x60 ; fixed screen Y (96 = center of 200)
    mov byte [ebp + W_SPRITE_PLAYER_X_PIXELS],        0xA0 ; fixed screen X (160 = center of 320)
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
    call SetupPalletTownNPCs            ; scaffold: NPC still tiles + slot init
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

; ---------------------------------------------------------------------------
; SetupPalletTownNPCs — Phase 2 scaffold: load NPC still tiles + init slots 1-3.
; NOT a faithful translation. Replaces InitMapSprites (to be ported later).
;
; VRAM layout (imageBaseOffset N → tile base (N-1)*12 in OBJ tile space):
;   Slot 1 Girl   imageBaseOffset 3 → tiles $18-$23 at GB_VCHARS0+$180 ($8180)
;   Slot 2 Fisher imageBaseOffset 4 → tiles $24-$2F at GB_VCHARS0+$240 ($8240)
;   Slot 3 Oak    imageBaseOffset 5 → tiles $30-$3B at GB_VCHARS0+$300 ($8300)
;
; Scaffold positions (player wYCoord=wXCoord=8 at startup; all on-screen):
;   Girl   MAPY=10 MAPX=10  screen≈(32, 28)
;   Fisher MAPY=12 MAPX=14  screen≈(96, 60)
;   Oak    MAPY=14 MAPX=11  screen≈(48, 92)
; (screen Y = (MAPY-8)*16-4, screen X = (MAPX-8)*16)
;
; MOVEMENTSTATUS is set to 0 so UpdateNonPlayerSprite runs InitializeSpriteStatus
; on the first overworld frame to set screen positions from MAPY/MAPX.
; ---------------------------------------------------------------------------
SetupPalletTownNPCs:
    mov byte [g_tilecache_dirty], 1     ; VRAM tile data changes → rebuild decode cache
    push esi
    push edi
    push ecx

    ; --- VRAM: still tiles for each NPC (192 bytes = 12 tiles each) ---
    mov esi, npc_girl_still
    lea edi, [ebp + GB_VCHARS0 + 0x18 * 16]   ; tile $18 = $8180
    mov ecx, 192
    rep movsb

    mov esi, npc_fisher_still
    lea edi, [ebp + GB_VCHARS0 + 0x24 * 16]   ; tile $24 = $8240
    mov ecx, 192
    rep movsb

    mov esi, npc_oak_still
    lea edi, [ebp + GB_VCHARS0 + 0x30 * 16]   ; tile $30 = $8300
    mov ecx, 192
    rep movsb

    ; --- Slot 1: Girl (imageBaseOffset 3, MAPY=10, MAPX=10) ---
    mov byte [ebp + W_SPRITE_STATE_DATA_1 + 0x10 + SPRITESTATEDATA1_PICTUREID],      1
    mov byte [ebp + W_SPRITE_STATE_DATA_1 + 0x10 + SPRITESTATEDATA1_MOVEMENTSTATUS], 0
    mov byte [ebp + W_SPRITE_STATE_DATA_1 + 0x10 + SPRITESTATEDATA1_FACINGDIRECTION], SPRITE_FACING_DOWN
    mov byte [ebp + W_SPRITE_STATE_DATA_2 + 0x10 + SPRITESTATEDATA2_MAPY],           10
    mov byte [ebp + W_SPRITE_STATE_DATA_2 + 0x10 + SPRITESTATEDATA2_MAPX],           10
    mov byte [ebp + W_SPRITE_STATE_DATA_2 + 0x10 + SPRITESTATEDATA2_MOVEMENTBYTE1],  STAY
    mov byte [ebp + W_SPRITE_STATE_DATA_2 + 0x10 + SPRITESTATEDATA2_IMAGEBASEOFFSET], 3

    ; --- Slot 2: Fisher (imageBaseOffset 4, MAPY=12, MAPX=14) ---
    mov byte [ebp + W_SPRITE_STATE_DATA_1 + 0x20 + SPRITESTATEDATA1_PICTUREID],      1
    mov byte [ebp + W_SPRITE_STATE_DATA_1 + 0x20 + SPRITESTATEDATA1_MOVEMENTSTATUS], 0
    mov byte [ebp + W_SPRITE_STATE_DATA_1 + 0x20 + SPRITESTATEDATA1_FACINGDIRECTION], SPRITE_FACING_DOWN
    mov byte [ebp + W_SPRITE_STATE_DATA_2 + 0x20 + SPRITESTATEDATA2_MAPY],           12
    mov byte [ebp + W_SPRITE_STATE_DATA_2 + 0x20 + SPRITESTATEDATA2_MAPX],           14
    mov byte [ebp + W_SPRITE_STATE_DATA_2 + 0x20 + SPRITESTATEDATA2_MOVEMENTBYTE1],  STAY
    mov byte [ebp + W_SPRITE_STATE_DATA_2 + 0x20 + SPRITESTATEDATA2_IMAGEBASEOFFSET], 4

    ; --- Slot 3: Oak (imageBaseOffset 5, MAPY=14, MAPX=11) ---
    mov byte [ebp + W_SPRITE_STATE_DATA_1 + 0x30 + SPRITESTATEDATA1_PICTUREID],      1
    mov byte [ebp + W_SPRITE_STATE_DATA_1 + 0x30 + SPRITESTATEDATA1_MOVEMENTSTATUS], 0
    mov byte [ebp + W_SPRITE_STATE_DATA_1 + 0x30 + SPRITESTATEDATA1_FACINGDIRECTION], SPRITE_FACING_DOWN
    mov byte [ebp + W_SPRITE_STATE_DATA_2 + 0x30 + SPRITESTATEDATA2_MAPY],           14
    mov byte [ebp + W_SPRITE_STATE_DATA_2 + 0x30 + SPRITESTATEDATA2_MAPX],           11
    mov byte [ebp + W_SPRITE_STATE_DATA_2 + 0x30 + SPRITESTATEDATA2_MOVEMENTBYTE1],  STAY
    mov byte [ebp + W_SPRITE_STATE_DATA_2 + 0x30 + SPRITESTATEDATA2_IMAGEBASEOFFSET], 5

    pop ecx
    pop edi
    pop esi
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
    ; Advance ESI to start of next tile row: +21 = SURROUNDING_WIDTH - (BLOCK_WIDTH-1)
    add esi, SURROUNDING_WIDTH - BLOCK_WIDTH + 1   ; = 24 - 3 = 21
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

    ; Skip SURROUNDING_WIDTH - SCREEN_WIDTH = 4 bytes to reach next row in wSurroundingTiles
    add esi, SURROUNDING_WIDTH - SCREEN_WIDTH      ; = 44 - 40 = 4
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
    jne .updateMapView
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
    push eax
    push ecx
    push esi
    call GetTileInFrontOfPlayer                    ; CL = tile in front
    call IsTilePassable                            ; CF = 1 if not passable
    pop esi
    pop ecx
    pop eax
    ret

; ---------------------------------------------------------------------------
; GetTileInFrontOfPlayer — simplified translation.
; Pret ref: engine/overworld/player_state.asm:_GetTileAndCoordsInFrontOfPlayer
;
; Reads the tile the player faces from wTileMap at the fixed screen coordinate
; pret uses for each facing (the player is always centered). Stores it in
; wTileInFrontOfPlayer and returns it in CL.
; ---------------------------------------------------------------------------
GetTileInFrontOfPlayer:
    mov al, [ebp + W_SPRITE_PLAYER_FACING_DIR]
    cmp al, SPRITE_FACING_DOWN
    jne .notDown
    mov esi, W_TILEMAP + 13 * SCREEN_TILES_W + 20   ; lda_coord 20, 13
    jmp .read
.notDown:
    cmp al, SPRITE_FACING_UP
    jne .notUp
    mov esi, W_TILEMAP + 11 * SCREEN_TILES_W + 20   ; lda_coord 20, 11
    jmp .read
.notUp:
    cmp al, SPRITE_FACING_LEFT
    jne .notLeft
    mov esi, W_TILEMAP + 12 * SCREEN_TILES_W + 19   ; lda_coord 19, 12
    jmp .read
.notLeft:
    mov esi, W_TILEMAP + 12 * SCREEN_TILES_W + 21   ; lda_coord 21, 12 (facing right)
.read:
    movzx ecx, byte [ebp + esi]
    mov [ebp + W_TILE_IN_FRONT_OF_PLAYER], cl
    ret

; ---------------------------------------------------------------------------
; IsTilePassable — faithful translation.
; Pret ref: engine/gfx/sprite_oam.asm:_IsTilePassable
;
; In:  CL = tile ID. Scans the $FF-terminated passable-tile list pointed to by
;      wTilesetCollisionPtr.
; Out: CF = 0 if CL is in the list (passable), CF = 1 otherwise.
; Clobbers AL, ESI.
; ---------------------------------------------------------------------------
IsTilePassable:
    movzx esi, word [ebp + W_TILESET_COLLISION_PTR]
.loop:
    mov al, [ebp + esi]
    inc esi
    cmp al, 0xFF
    je  .notPassable
    cmp al, cl
    jne .loop
    clc
    ret
.notPassable:
    stc
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
    
    ; Skip warps
    mov bl, [eax]
    mov [ebp + W_NUMBER_OF_WARPS], bl
    inc eax
    movzx ebx, bl
    shl ebx, 2 ; * 4 bytes per warp
    add eax, ebx
    
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
; LoadTilesetHeader — faithful translation.
; Pret ref: home/overworld.asm:LoadTilesetHeader (or engine/overworld/tilesets.asm)
; ---------------------------------------------------------------------------
LoadTilesetHeader:
    push eax
    push esi
    push edi
    push ecx
    
    ; We only have 1 tileset for now: OVERWORLD, located at OW_TILESET_HDR_GBADDR
    ; In the future we'll use wCurMapTileset as an index.
    lea esi, [ebp + OW_TILESET_HDR_GBADDR]
    
    lea edi, [ebp + W_TILESET_BANK]
    mov ecx, W_TILESET_HEADER_COPY_SIZE ; 11 bytes
    rep movsb
    
    ; 12th byte is hTileAnimations
    mov al, [esi]
    mov [ebp + H_TILE_ANIMATIONS], al
    
    pop ecx
    pop edi
    pop esi
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
    pop edx
    pop ebx
    stc                                        ; CF=1 → transition occurred
    ret

; ---------------------------------------------------------------------------
; Embedded overworld asset data (Phase 2 scaffold).
; gen_overworld_assets.py regenerates these from source binaries.
; ---------------------------------------------------------------------------

section .rodata

%include "assets/overworld_gfx.inc"
%include "assets/overworld_blocks.inc"
%include "assets/pallet_town_blk.inc"
%include "assets/route1_blk.inc"
%include "assets/route21_blk.inc"
%include "assets/overworld_coll.inc"
%include "assets/player_sprite.inc"
%include "assets/npc_girl_still.inc"
%include "assets/npc_fisher_still.inc"
%include "assets/npc_oak_still.inc"
%include "assets/map_headers.inc"
