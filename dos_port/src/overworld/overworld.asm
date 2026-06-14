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
;   SetupPalletTown  — hardcoded Pallet Town map-header variables + asset copy to ROM window
;   EnterMap         — scaffold entry from title screen
;   OverworldLoop    — minimal frame loop (DelayFrame + joypad; no movement yet)
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
%ifdef DEBUG_DUMP
extern DebugDumpMemory
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
global RedrawRowOrColumn       ; called from frame.asm DelayFrame (VBlank pipeline)

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

section .text

; ---------------------------------------------------------------------------
; EnterMap — Phase 2 scaffold entry point.
; Called from title.asm after A/Start pressed. Sets up Pallet Town variables,
; copies assets to ROM window, then runs LoadMapData + OverworldLoop.
;
; Pret ref: home/overworld.asm:EnterMap (simplified; no fly/warp logic yet)
; ---------------------------------------------------------------------------
EnterMap:
    call SetupPalletTown
    call LoadMapData
%ifdef DEBUG_DUMP
    call DebugDumpMemory     ; dump GB memory to DUMP.BIN, then exit (debug only)
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
    call UpdatePlayerOAM                      ; refresh the player sprite for the facing
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
    jz OverworldLoop                          ; nothing held → idle
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

.moveAhead:
    call AdvancePlayerSprite
    jmp OverworldLoop

; ---------------------------------------------------------------------------
; SetupPalletTown — Phase 2 scaffold. NOT a faithful translation.
; Hardcodes Pallet Town map-header WRAM variables and copies asset binaries
; from .rodata into the ROM-window area of GB memory (EBP+$4000–$4EFF).
; ---------------------------------------------------------------------------
SetupPalletTown:
    push esi
    push edi
    push ecx

    ; --- Set map identity ---
    mov byte [ebp + W_CUR_MAP],          MAP_ID_PALLET_TOWN
    mov byte [ebp + W_CUR_MAP_TILESET],  TILESET_OVERWORLD
    mov byte [ebp + W_CUR_MAP_HEIGHT],   PALLET_TOWN_HEIGHT
    mov byte [ebp + W_CUR_MAP_WIDTH],    PALLET_TOWN_WIDTH

    ; wCurMapDataPtr = OW_MAP_GBADDR ($4E00) — pointer into ROM window
    mov word [ebp + W_CUR_MAP_DATA_PTR], OW_MAP_GBADDR

    ; --- Tileset pointers ---
    mov byte  [ebp + W_TILESET_BANK],         TILESET_BANK_FLAT
    mov word  [ebp + W_TILESET_GFX_PTR],      OW_GFX_GBADDR
    mov word  [ebp + W_TILESET_BLOCKS_PTR],   OW_BLOCKS_GBADDR
    mov word  [ebp + W_TILESET_COLLISION_PTR], OW_COLL_GBADDR

    ; --- Map object data (normally read from PalletTown_Object by LoadMapHeader) ---
    mov byte [ebp + W_MAP_BACKGROUND_TILE], PALLET_TOWN_BORDER_BLOCK
    mov byte [ebp + W_NUMBER_OF_WARPS],     0

    ; --- Disable all connected maps ($FF = none) ---
    mov byte [ebp + W_NORTH_CONNECTED_MAP], MAP_NO_CONNECTION
    mov byte [ebp + W_SOUTH_CONNECTED_MAP], MAP_NO_CONNECTION
    mov byte [ebp + W_WEST_CONNECTED_MAP],  MAP_NO_CONNECTION
    mov byte [ebp + W_EAST_CONNECTED_MAP],  MAP_NO_CONNECTION

    ; wCurrentTileBlockMapViewPointer = block (0,0) of Pallet Town in wOverworldMap
    mov word [ebp + W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR], PALLET_TOWN_VIEW_PTR

    ; Player starts at block (0,0) — WRAM1 is not zeroed by Init, so must initialize
    mov byte [ebp + W_Y_BLOCK_COORD], 0
    mov byte [ebp + W_X_BLOCK_COORD], 0

    ; Player map tile coords (only used by warp/connection logic, not rendering).
    ; Start in the middle of Pallet Town so a stroll stays inside the map border.
    mov byte [ebp + W_Y_COORD], 8
    mov byte [ebp + W_X_COORD], 8

    ; Face down, standing still (no in-progress walk).
    mov byte [ebp + W_SPRITE_PLAYER_FACING_DIR],   SPRITE_FACING_DOWN
    mov byte [ebp + W_PLAYER_DIRECTION],           0
    mov byte [ebp + W_PLAYER_MOVING_DIRECTION],    0
    mov byte [ebp + W_SPRITE_PLAYER_Y_STEP_VECTOR], 0
    mov byte [ebp + W_SPRITE_PLAYER_X_STEP_VECTOR], 0
    mov byte [ebp + W_WALK_COUNTER],               0

    ; The overworld scrolls via RedrawRowOrColumn, not the auto-BG transfer
    ; (which would fight it by re-blitting wTileMap to $9800 every frame).
    mov byte [ebp + H_AUTO_BG_TRANSFER_EN],        0

    ; The real player OAM sprite now renders (UpdatePlayerOAM); keep the legacy
    ; placeholder marker off.
    mov byte [g_player_marker_on], 0

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

    ; --- Copy PalletTown.blk to ROM window at OW_MAP_GBADDR ---
    mov esi, pallet_town_blk
    lea edi, [ebp + OW_MAP_GBADDR]
    mov ecx, PALLET_TOWN_BLK_SIZE
    rep movsb

    ; --- Copy Overworld_Coll passable-tile list to ROM window at OW_COLL_GBADDR ---
    mov esi, overworld_coll
    lea edi, [ebp + OW_COLL_GBADDR]
    mov ecx, OVERWORLD_COLL_SIZE
    rep movsb

    pop ecx
    pop edi
    pop esi
    ret

; ---------------------------------------------------------------------------
; LoadMapData — faithful translation.
; Pret ref: home/overworld.asm:LoadMapData
;
; Stubs (; TODO-HW or Phase 2 next):
;   LoadMapHeader    — replaced by SetupPalletTown scaffold
;   InitMapSprites   — ; TODO: sprite engine (Phase 2)
;   RunPaletteCommand(SET_PAL_OVERWORLD) — ; TODO-HW: palette (Phase 5)
;   LoadPlayerSpriteGraphics — ; TODO: sprite engine (Phase 2)
;   UpdateMusic6Times / PlayDefaultMusicFadeOutCurrent — ; TODO-HW: audio (Phase 3)
; ---------------------------------------------------------------------------
LoadMapData:
    call DisableLCD
    call ResetMapVariables
    call LoadTextBoxTilePatterns
    ; LoadMapHeader — setup done by SetupPalletTown scaffold; skip here.
    ; TODO: InitMapSprites — ; TODO: sprite engine (Phase 2)
    call LoadScreenRelatedData
    call CopyMapViewToVRAM

    mov byte [ebp + W_UPDATE_SPRITES_ENABLED], 1
    call EnableLCD
    call GBPalNormal
    call LoadPlayerSpriteGraphics       ; scaffold: player tiles → OBJ VRAM, hide OAM
    ; RunPaletteCommand(SET_PAL_OVERWORLD) — ; TODO-HW: palette (Phase 5)
    ; UpdateMusic / PlayDefaultMusicFadeOutCurrent — ; TODO-HW: audio (Phase 3)
    ret

; ---------------------------------------------------------------------------
; LoadPlayerSpriteGraphics — Phase 2 scaffold (NOT a faithful translation).
; Copies the Red overworld sprite (24 tiles) into the OBJ tile area at
; GB_VCHARS0 ($8000) and clears OAM so no stale entries render. The real engine
; (InitMapSprites / sprite VRAM slot allocation / Pikachu) comes later.
; ---------------------------------------------------------------------------
LoadPlayerSpriteGraphics:
    push eax
    push ecx
    push esi
    push edi

    ; --- player sprite tiles → OBJ VRAM ($8000) ---
    mov esi, player_sprite
    lea edi, [ebp + GB_VCHARS0]
    mov ecx, PLAYER_SPRITE_SIZE
    rep movsb

    ; --- hide all 40 OAM entries (Y = 0 → off the top of the screen) ---
    lea edi, [ebp + GB_OAM]
    xor eax, eax
    mov ecx, GB_OAM_SIZE
    rep stosb

    pop edi
    pop esi
    pop ecx
    pop eax
    ret

; ---------------------------------------------------------------------------
; ResetMapVariables — faithful translation.
; Pret ref: home/overworld.asm:ResetMapVariables
;
; Sets wMapViewVRAMPointer = vBGMap0 ($9800), zeroes SCX/SCY and walk state.
; ---------------------------------------------------------------------------
ResetMapVariables:
    ; wMapViewVRAMPointer = $9800 (little-endian word: lo=0x00, hi=0x98)
    mov word [ebp + W_MAP_VIEW_VRAM_POINTER], GB_TILEMAP0
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

    ; --- Connection strips (all $FF = none for Phase 2; faithful structure kept) ---

.north_connection:
    cmp byte [ebp + W_NORTH_CONNECTED_MAP], MAP_NO_CONNECTION
    je  .south_connection
    ; TODO: SwitchToMapRomBank + LoadNorthSouthConnectionsTileMap (Phase 2 movement)

.south_connection:
    cmp byte [ebp + W_SOUTH_CONNECTED_MAP], MAP_NO_CONNECTION
    je  .west_connection
    ; TODO: SwitchToMapRomBank + LoadNorthSouthConnectionsTileMap (Phase 2 movement)

.west_connection:
    cmp byte [ebp + W_WEST_CONNECTED_MAP], MAP_NO_CONNECTION
    je  .east_connection
    ; TODO: SwitchToMapRomBank + LoadEastWestConnectionsTileMap (Phase 2 movement)

.east_connection:
    cmp byte [ebp + W_EAST_CONNECTED_MAP], MAP_NO_CONNECTION
    je  .done
    ; TODO: SwitchToMapRomBank + LoadEastWestConnectionsTileMap (Phase 2 movement)

.done:
    pop ecx
    pop ebx
    pop edi
    pop esi
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

    movzx eax, byte [ebp + edx]                   ; A = block ID from wOverworldMap
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

    mov bh, SCREEN_HEIGHT                          ; BH = B = 18 (row count)

.copy_row_loop:
    mov bl, SCREEN_WIDTH                           ; BL = C = 20 (col count)

.copy_col_loop:
    mov al, byte [ebp + esi]
    mov byte [ebp + edx], al
    inc esi
    inc edx
    dec bl
    jnz .copy_col_loop

    ; Skip SURROUNDING_WIDTH - SCREEN_WIDTH = 4 bytes to reach next row in wSurroundingTiles
    add esi, SURROUNDING_WIDTH - SCREEN_WIDTH      ; = 24 - 20 = 4
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
; Copies wTileMap (SCREEN_HEIGHT×SCREEN_WIDTH) to vBGMap0 (GB_TILEMAP0),
; with a stride of TILEMAP_WIDTH (32) in the destination.
; ---------------------------------------------------------------------------
CopyMapViewToVRAM:
    mov edx, GB_TILEMAP0                           ; DE = vBGMap0 = $9800

CopyMapViewToVRAM2:
    mov esi, W_TILEMAP                             ; HL = wTileMap
    mov bh, SCREEN_HEIGHT                          ; B = 18

.vram_row_loop:
    mov bl, SCREEN_WIDTH                           ; C = 20

.vram_col_loop:
    mov al, byte [ebp + esi]
    mov byte [ebp + edx], al
    inc esi
    inc edx
    dec bl
    jnz .vram_col_loop

    ; Skip TILEMAP_WIDTH - SCREEN_WIDTH = 12 bytes to reach next row in VRAM
    add edx, TILEMAP_WIDTH - SCREEN_WIDTH          ; = 12
    dec bh
    jnz .vram_row_loop
    ret

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
; Phase 2 omissions vs. pret: the sprite-shift loop (no OAM yet), wUpdateSprites
; save/restore, IsSpinning, and the Pikachu overworld-state flag.
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
.afterUpdateMapCoords:
    cmp byte [ebp + W_WALK_COUNTER], 7
    jne .scroll                                       ; only the first frame slides the view

    ; --- first frame: slide wMapViewVRAMPointer by 2 tiles in the move dir ---
    cmp cl, 0x01
    jne .checkWest
    ; moving east: low = (low+2 & $1f) | (low & $e0)
    movzx eax, byte [ebp + W_MAP_VIEW_VRAM_POINTER]
    mov dl, al
    and al, 0xE0
    mov dh, al
    mov al, dl
    add al, 0x02
    and al, 0x1F
    or  al, dh
    mov [ebp + W_MAP_VIEW_VRAM_POINTER], al
    jmp .adjustXCoordWithinBlock
.checkWest:
    cmp cl, 0xFF
    jne .checkSouth
    ; moving west: low = (low-2 & $1f) | (low & $e0)
    movzx eax, byte [ebp + W_MAP_VIEW_VRAM_POINTER]
    mov dl, al
    and al, 0xE0
    mov dh, al
    mov al, dl
    sub al, 0x02
    and al, 0x1F
    or  al, dh
    mov [ebp + W_MAP_VIEW_VRAM_POINTER], al
    jmp .adjustXCoordWithinBlock
.checkSouth:
    cmp bl, 0x01
    jne .checkNorth
    ; moving south: 16-bit pointer += $40, wrap high byte into $98xx
    mov al, [ebp + W_MAP_VIEW_VRAM_POINTER]
    add al, 0x40
    mov [ebp + W_MAP_VIEW_VRAM_POINTER], al
    jnc .adjustXCoordWithinBlock
    mov al, [ebp + W_MAP_VIEW_VRAM_POINTER + 1]
    inc al
    and al, 0x03
    or  al, 0x98
    mov [ebp + W_MAP_VIEW_VRAM_POINTER + 1], al
    jmp .adjustXCoordWithinBlock
.checkNorth:
    cmp bl, 0xFF
    jne .adjustXCoordWithinBlock
    ; moving north: 16-bit pointer -= $40, wrap high byte into $98xx
    mov al, [ebp + W_MAP_VIEW_VRAM_POINTER]
    sub al, 0x40
    mov [ebp + W_MAP_VIEW_VRAM_POINTER], al
    jnc .adjustXCoordWithinBlock
    mov al, [ebp + W_MAP_VIEW_VRAM_POINTER + 1]
    dec al
    and al, 0x03
    or  al, 0x98
    mov [ebp + W_MAP_VIEW_VRAM_POINTER + 1], al

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
    ; schedule the freshly exposed edge for redraw, based on move direction
    mov al, [ebp + W_SPRITE_PLAYER_Y_STEP_VECTOR]
    cmp al, 0x01
    jne .schedNorth
    call ScheduleSouthRowRedraw
    jmp .scroll
.schedNorth:
    cmp al, 0xFF
    jne .schedEast
    call ScheduleNorthRowRedraw
    jmp .scroll
.schedEast:
    mov al, [ebp + W_SPRITE_PLAYER_X_STEP_VECTOR]
    cmp al, 0x01
    jne .schedWest
    call ScheduleEastColumnRedraw
    jmp .scroll
.schedWest:
    cmp al, 0xFF
    jne .scroll
    call ScheduleWestColumnRedraw

.scroll:
    ; hSCY += 2*Yvec ; hSCX += 2*Xvec  (sprite-shift loop omitted — no OAM yet)
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
; Schedule{North,South}RowRedraw / Schedule{East,West}ColumnRedraw — faithful.
; Pret ref: home/overworld.asm
;
; Copy the exposed 2-tile-deep row (or 2-tile-wide column) from wTileMap into
; wRedrawRowOrColumnSrcTiles, compute its VRAM destination from
; wMapViewVRAMPointer, and arm hRedrawRowOrColumnMode for the next VBlank.
; All registers preserved.
; ---------------------------------------------------------------------------
ScheduleNorthRowRedraw:
    push eax
    push esi
    push edi
    push ecx
    mov esi, W_TILEMAP                              ; hlcoord 0, 0
    call CopyToRedrawRowOrColumnSrcTiles
    mov al, [ebp + W_MAP_VIEW_VRAM_POINTER]
    mov [ebp + H_REDRAW_ROW_COL_DEST], al
    mov al, [ebp + W_MAP_VIEW_VRAM_POINTER + 1]
    mov [ebp + H_REDRAW_ROW_COL_DEST + 1], al
    mov byte [ebp + H_REDRAW_ROW_COL_MODE], REDRAW_ROW
    pop ecx
    pop edi
    pop esi
    pop eax
    ret

ScheduleSouthRowRedraw:
    push eax
    push ebx
    push esi
    push edi
    push ecx
    mov esi, W_TILEMAP + 16 * SCREEN_WIDTH          ; hlcoord 0, 16
    call CopyToRedrawRowOrColumnSrcTiles
    ; dest = wMapViewVRAMPointer + $200, high byte wrapped into $98xx
    movzx ebx, byte [ebp + W_MAP_VIEW_VRAM_POINTER]
    movzx eax, byte [ebp + W_MAP_VIEW_VRAM_POINTER + 1]
    shl eax, 8
    or  ebx, eax
    add ebx, 0x200
    mov al, bh
    and al, 0x03
    or  al, 0x98
    mov [ebp + H_REDRAW_ROW_COL_DEST + 1], al
    mov [ebp + H_REDRAW_ROW_COL_DEST], bl
    mov byte [ebp + H_REDRAW_ROW_COL_MODE], REDRAW_ROW
    pop ecx
    pop edi
    pop esi
    pop ebx
    pop eax
    ret

ScheduleEastColumnRedraw:
    push eax
    push ebx
    push esi
    push edi
    push ecx
    mov esi, W_TILEMAP + 18                         ; hlcoord 18, 0
    call ScheduleColumnRedrawHelper
    ; dest low = (low & $e0) | ((low + 18) & $1f)
    movzx eax, byte [ebp + W_MAP_VIEW_VRAM_POINTER]
    mov bl, al
    and bl, 0xE0
    add al, 18
    and al, 0x1F
    or  al, bl
    mov [ebp + H_REDRAW_ROW_COL_DEST], al
    mov al, [ebp + W_MAP_VIEW_VRAM_POINTER + 1]
    mov [ebp + H_REDRAW_ROW_COL_DEST + 1], al
    mov byte [ebp + H_REDRAW_ROW_COL_MODE], REDRAW_COL
    pop ecx
    pop edi
    pop esi
    pop ebx
    pop eax
    ret

ScheduleWestColumnRedraw:
    push eax
    push esi
    push edi
    push ecx
    mov esi, W_TILEMAP                              ; hlcoord 0, 0
    call ScheduleColumnRedrawHelper
    mov al, [ebp + W_MAP_VIEW_VRAM_POINTER]
    mov [ebp + H_REDRAW_ROW_COL_DEST], al
    mov al, [ebp + W_MAP_VIEW_VRAM_POINTER + 1]
    mov [ebp + H_REDRAW_ROW_COL_DEST + 1], al
    mov byte [ebp + H_REDRAW_ROW_COL_MODE], REDRAW_COL
    pop ecx
    pop edi
    pop esi
    pop eax
    ret

; CopyToRedrawRowOrColumnSrcTiles — copy 2*SCREEN_WIDTH tiles from [ESI] in
; wTileMap to wRedrawRowOrColumnSrcTiles. Clobbers EAX, ESI, EDI, ECX.
CopyToRedrawRowOrColumnSrcTiles:
    mov edi, W_REDRAW_ROW_OR_COLUMN_SRC_TILES
    mov ecx, 2 * SCREEN_WIDTH
.loop:
    mov al, [ebp + esi]
    mov [ebp + edi], al
    inc esi
    inc edi
    dec ecx
    jnz .loop
    ret

; ScheduleColumnRedrawHelper — copy a 2-tile-wide, SCREEN_HEIGHT-tall column
; starting at [ESI] in wTileMap to wRedrawRowOrColumnSrcTiles (2 bytes/row,
; advancing one full screen row each iteration). Clobbers EAX, ESI, EDI, ECX.
ScheduleColumnRedrawHelper:
    mov edi, W_REDRAW_ROW_OR_COLUMN_SRC_TILES
    mov ecx, SCREEN_HEIGHT
.loop:
    mov al, [ebp + esi]
    mov [ebp + edi], al
    inc edi
    mov al, [ebp + esi + 1]
    mov [ebp + edi], al
    inc edi
    add esi, SCREEN_WIDTH
    dec ecx
    jnz .loop
    ret

; ---------------------------------------------------------------------------
; RedrawRowOrColumn — faithful translation.
; Pret ref: home/vcopy.asm:RedrawRowOrColumn
;
; Runs in the per-frame (VBlank) pipeline. If a redraw is armed
; (hRedrawRowOrColumnMode), copies the staged 2-row band or 2-column strip from
; wRedrawRowOrColumnSrcTiles into VRAM at hRedrawRowOrColumnDest, wrapping inside
; the 32×32 / 1 KB tilemap exactly as the GB does. All registers preserved.
; ---------------------------------------------------------------------------
RedrawRowOrColumn:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    movzx eax, byte [ebp + H_REDRAW_ROW_COL_MODE]
    test al, al
    jz .done
    mov bl, al
    mov byte [ebp + H_REDRAW_ROW_COL_MODE], 0
    dec bl
    jnz .redrawRow

.redrawColumn:
    mov esi, W_REDRAW_ROW_OR_COLUMN_SRC_TILES
    movzx edi, byte [ebp + H_REDRAW_ROW_COL_DEST]
    movzx eax, byte [ebp + H_REDRAW_ROW_COL_DEST + 1]
    shl eax, 8
    or  edi, eax                                   ; EDI = GB VRAM dest address
    mov ecx, SCREEN_HEIGHT
.colLoop:
    mov al, [ebp + esi]
    inc esi
    mov [ebp + edi], al
    inc edi
    mov al, [ebp + esi]
    inc esi
    mov [ebp + edi], al
    ; advance to the same column on the next VRAM row (+32), wrap within the
    ; 1 KB tilemap ($9800-$9BFF): addr = (addr + 31) & $3FF | $9800
    add edi, TILEMAP_WIDTH - 1
    and edi, 0x03FF
    or  edi, GB_TILEMAP0
    dec ecx
    jnz .colLoop
    jmp .done

.redrawRow:
    mov esi, W_REDRAW_ROW_OR_COLUMN_SRC_TILES
    movzx edi, byte [ebp + H_REDRAW_ROW_COL_DEST]
    movzx eax, byte [ebp + H_REDRAW_ROW_COL_DEST + 1]
    shl eax, 8
    or  edi, eax                                   ; EDI = GB VRAM dest address
    call .drawHalf                                 ; upper half (SCREEN_WIDTH tiles)
    ; next VRAM row: add TILEMAP_WIDTH to the low byte only (matches GB, no carry)
    mov eax, edi
    and eax, 0xFF
    add eax, TILEMAP_WIDTH
    and eax, 0xFF
    and edi, 0xFFFFFF00
    or  edi, eax
    call .drawHalf                                 ; lower half
    jmp .done

; .drawHalf — write SCREEN_WIDTH tiles from [ESI] to VRAM [EDI], wrapping the
; column within the 32-tile VRAM row (low 5 bits of the low byte). ESI advances
; by SCREEN_WIDTH; EDI ends on the same VRAM row. Clobbers EAX, ECX, EDX.
.drawHalf:
    mov ecx, SCREEN_WIDTH / 2
.halfLoop:
    mov al, [ebp + esi]
    inc esi
    mov [ebp + edi], al
    inc edi
    mov al, [ebp + esi]
    inc esi
    mov [ebp + edi], al
    ; e = ((e + 1) & $1f) | (e & $e0)   (EDI low byte already inc'd once above)
    mov eax, edi
    and eax, 0xFF
    mov edx, eax
    inc edx
    and edx, 0x1F
    and eax, 0xE0
    or  eax, edx
    and edi, 0xFFFFFF00
    or  edi, eax
    dec ecx
    jnz .halfLoop
    ret

.done:
    pop edi
    pop esi
    pop edx
    pop ecx
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
    mov esi, W_TILEMAP + 11 * SCREEN_WIDTH + 8      ; lda_coord 8, 11
    jmp .read
.notDown:
    cmp al, SPRITE_FACING_UP
    jne .notUp
    mov esi, W_TILEMAP + 7 * SCREEN_WIDTH + 8       ; lda_coord 8, 7
    jmp .read
.notUp:
    cmp al, SPRITE_FACING_LEFT
    jne .notLeft
    mov esi, W_TILEMAP + 9 * SCREEN_WIDTH + 6       ; lda_coord 6, 9
    jmp .read
.notLeft:
    mov esi, W_TILEMAP + 9 * SCREEN_WIDTH + 10      ; lda_coord 10, 9 (facing right)
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
; UpdatePlayerOAM — Phase 2 scaffold (NOT a faithful translation of
; PrepareOAMData). Writes the player's four 8×8 OAM entries to $FE00 for the
; current facing, composing the 16×16 standing pose from tiles 0–11 of the Red
; sprite. The player is camera-locked at screen center; the BG scrolls under it.
;
; Pret refs for the layout: engine/gfx/sprite_oam.asm:PrepareOAMData (OAM byte
; order Y, X, tile, attr) and data/sprites/facings.asm (the standing poses).
; Walk-frame leg animation and NPC sprites are deferred (needs the $80+ walking
; tiles and the VRAM-slot/sprite-state engine).
; ---------------------------------------------------------------------------
PLAYER_SCREEN_X equ 64                       ; top-left of the 16×16 player, px
PLAYER_SCREEN_Y equ 64

UpdatePlayerOAM:
    push eax
    push ecx
    push edx
    push esi
    push edi

    ; Select the 4-entry pose block for the current facing (0,4,8,12 → 0..3).
    movzx eax, byte [ebp + W_SPRITE_PLAYER_FACING_DIR]
    shr eax, 2
    shl eax, 4                               ; 16 bytes per pose (4 entries × 4)
    lea esi, [player_oam_table + eax]

    lea edi, [ebp + GB_OAM]                  ; OAM entry 0
    mov ecx, 4
.entry:
    movzx edx, byte [esi + 0]                ; Y offset within the 16×16
    add edx, PLAYER_SCREEN_Y + OAM_Y_OFS
    mov [edi + 0], dl
    movzx edx, byte [esi + 1]                ; X offset
    add edx, PLAYER_SCREEN_X + OAM_X_OFS
    mov [edi + 1], dl
    mov dl, [esi + 2]                        ; tile id
    mov [edi + 2], dl
    mov dl, [esi + 3]                        ; attributes
    mov [edi + 3], dl
    add esi, 4
    add edi, 4
    dec ecx
    jnz .entry

    pop edi
    pop esi
    pop edx
    pop ecx
    pop eax
    ret

; ---------------------------------------------------------------------------
; Embedded overworld asset data (Phase 2 scaffold).
; gen_overworld_assets.py regenerates these from source binaries.
; ---------------------------------------------------------------------------

section .rodata

%include "assets/overworld_gfx.inc"
%include "assets/overworld_blocks.inc"
%include "assets/pallet_town_blk.inc"
%include "assets/overworld_coll.inc"
%include "assets/player_sprite.inc"

; ---------------------------------------------------------------------------
; player_oam_table — four 8×8 OAM entries per facing (UpdatePlayerOAM).
; Each entry: db Yoffset, Xoffset, tileID, attributes. Derived from the standing
; poses in data/sprites/facings.asm (pret's internal UNDER_GRASS/FACING_END
; markers drop out — they aren't OAM hardware bits and the player isn't in grass).
; Facing order matches SPRITE_FACING_* >> 2: down(0), up(1), left(2), right(3).
; ---------------------------------------------------------------------------
player_oam_table:
    ; facing down — tiles 0-3
    db 0, 0, 0, 0
    db 0, 8, 1, 0
    db 8, 0, 2, 0
    db 8, 8, 3, 0
    ; facing up — tiles 4-7
    db 0, 0, 4, 0
    db 0, 8, 5, 0
    db 8, 0, 6, 0
    db 8, 8, 7, 0
    ; facing left — tiles 8-11
    db 0, 0,  8, 0
    db 0, 8,  9, 0
    db 8, 0, 10, 0
    db 8, 8, 11, 0
    ; facing right — tiles 8-11, X-flipped (left pose mirrored)
    db 0, 8,  8, OAM_XFLIP
    db 0, 0,  9, OAM_XFLIP
    db 8, 8, 10, OAM_XFLIP
    db 8, 0, 11, OAM_XFLIP
