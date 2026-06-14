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
; OverworldLoop — minimal frame loop. Runs indefinitely (Phase 2 stub).
; Pret ref: home/overworld.asm:OverworldLoop (DelayFrame + joypad only)
; ---------------------------------------------------------------------------
OverworldLoop:
    call DelayFrame
    ; TODO: joypad → player movement (Phase 2 next step)
    ; TODO: UpdateSprites, CollisionCheckOnLand, StepCountCheck (Phase 2)
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
    mov byte  [ebp + W_TILESET_BANK],       TILESET_BANK_FLAT
    mov word  [ebp + W_TILESET_GFX_PTR],    OW_GFX_GBADDR
    mov word  [ebp + W_TILESET_BLOCKS_PTR], OW_BLOCKS_GBADDR

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
    ; RunPaletteCommand(SET_PAL_OVERWORLD) — ; TODO-HW: palette (Phase 5)
    ; LoadPlayerSpriteGraphics — ; TODO: sprite engine (Phase 2)
    ; UpdateMusic / PlayDefaultMusicFadeOutCurrent — ; TODO-HW: audio (Phase 3)
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
; Embedded overworld asset data (Phase 2 scaffold).
; gen_overworld_assets.py regenerates these from source binaries.
; ---------------------------------------------------------------------------

section .rodata

%include "assets/overworld_gfx.inc"
%include "assets/overworld_blocks.inc"
%include "assets/pallet_town_blk.inc"
