; title.asm — PrepareTitleScreen / DisplayTitleScreen and helpers.
;
; Source: engine/movie/title.asm, engine/movie/title_yellow.asm,
;         home/tilemap.asm (SaveScreenTiles/LoadScreenTiles)
;
; Animation overview:
;   1. Load all title graphics to VRAM.
;   2. Place Pokemon logo (no pikachu) in wTileMap; save to Buffer2.
;   3. Add pikachu to wTileMap; copy to physical tilemap at $9B00 (row 24);
;      save to Buffer1.  hSCY = 64.
;   4. Restore Buffer2 (logo only); copy to physical tilemap at $9800 (row 0).
;   5. Bounce hSCY from 64 → 0 over ~32 frames (DelayFrame each step).
;      do_bg_transfer in each DelayFrame keeps copying logo-only to $9800 so
;      the renderer sees the correct tilemap as SCY slides.
;   6. After bounce, restore Buffer1 (logo+pikachu); DelayFrames(36) commits
;      it to $9800 via auto-BG transfer — Pikachu appears.
;   7. Place speech bubble; play PCM (stub); play music (stub).
;   8. Main idle loop: blink Pikachu's eyes, await A/Start → main menu.
;      Inactivity for ~51 s resets to Init.
;
; Hardware I/O boundaries in this file:
;   OBP0 write     — ; TODO-HW: OBP0 palette (no sprite renderer yet)
;   UpdateCGBPal   — ; TODO-HW: CGB palette (Phase 5)
;   RunPaletteCommand — ; TODO-HW: CGB/SGB palette (Phase 5)
;   PlaySound / StopAllMusic / TitleScreen_PlayPikachuPCM — ; TODO-HW: audio (Phase 3)
;   FillSpriteBuffer0WithAA — SRAM not yet emulated; stub no-op
;
; Build: nasm -f coff -I include/ -I . -o title.o title.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

; ---------------------------------------------------------------------------
; Externs
; ---------------------------------------------------------------------------
extern FillMemory
extern DisableLCD
extern EnableLCD
extern ClearSprites
extern LoadFontTilePatterns
extern LoadTextBoxTilePatterns
extern text_engine_init
extern DelayFrame
extern DelayFrames
extern Delay3
extern GBPalNormal
extern Init
extern EnterMap

; ---------------------------------------------------------------------------
; Globals
; ---------------------------------------------------------------------------
global PrepareTitleScreen
global ClearScreen

; ---------------------------------------------------------------------------
; Constants
; ---------------------------------------------------------------------------
NAME_LENGTH          equ 11      ; wPlayerName / wRivalName field size

; LCDC bit 7 — LCD enable (used by EnableLCD/DisableLCD in lcd_control.asm)
LCDC_DEFAULT_VAL     equ 0xE3

; GB joypad bits in the hJoyHeld shadow (active HIGH)
PAD_A                equ 0x01
PAD_B                equ 0x02
PAD_SELECT           equ 0x04
PAD_START            equ 0x08
PAD_RIGHT            equ 0x10
PAD_LEFT             equ 0x20
PAD_UP               equ 0x40
PAD_DOWN             equ 0x80

SCREEN_HEIGHT_PX     equ 144     ; hWY value to hide the window layer

; VRAM tile destination constants
VCHARS1_TILE_60      equ GB_VFONT + 0x60 * 16   ; = $8E00  (copyright tiles)
VCHARS1_TILE_65      equ GB_VFONT + 0x65 * 16   ; = $8E50  (GameFreak logo)
VCHARS1_TILE_6E      equ GB_VFONT + 0x6E * 16   ; = $8EE0  (Nine tile)
VCHARS1_TILE_70      equ GB_VFONT + 0x70 * 16   ; = $8F00  (Pikachu OBJ sprites)
VCHARS1_TILE_7D      equ GB_VFONT + 0x7D * 16   ; = $8FD0  (logo corner tiles)

; Tilemap destination addresses (high bytes passed to TitleScreenCopyTileMapToVRAM)
TILEMAP_DEST_HI_ROW0 equ (GB_TILEMAP0 >> 8)      ; $98  → $9800 (row 0)
TILEMAP_DEST_HI_ROW24 equ ((GB_TILEMAP0 + 0x300) >> 8) ; $9B → $9B00 (row 24)

; ---------------------------------------------------------------------------
; Data
; ---------------------------------------------------------------------------
section .data
align 4

; Pikachu eye OAM data — 8 sprites × 4 bytes = 32 bytes
; Copied to wShadowOAM by TitleScreen_PlacePikachu.
; Phase 1 open item: OAM sprite renderer not yet implemented; sprites won't
; render until Phase 1 OAM pass, but writes are kept for correctness.
TitleScreenPikachuEyesOAMData:
    db 0x60, 0x40, 0xf1, 0x22
    db 0x60, 0x48, 0xf0, 0x22
    db 0x68, 0x40, 0xf3, 0x22
    db 0x68, 0x48, 0xf2, 0x22
    db 0x60, 0x60, 0xf0, 0x02
    db 0x60, 0x68, 0xf1, 0x02
    db 0x68, 0x60, 0xf2, 0x02
    db 0x68, 0x68, 0xf3, 0x02

; Copyright row tile indices ($FF = end sentinel).
; ©1995-1999 GAME FREAK inc.
; $e0-$e4 = © 1 9 9 5 (signed → vChars1 $8E00-)
; $ee = Nine tile (signed → $8EE0)
; $e5-$ed = GAME FREAK inc. (signed → vChars1 $8E50-)
CopyrightRowTiles:
    db 0xe0,0xe1,0xe2,0xe3,0xe1,0xe2,0xee,0xe5,0xe6,0xe7,0xe8,0xe9,0xea,0xeb,0xec,0xed,0xff

; Bounce table: pairs of (signed SCY delta, repeat count); $00 = end.
TitleScreenYScrolls:
    db -4, 16
    db  3,  4
    db -3,  4
    db  2,  2
    db -2,  2
    db  1,  2
    db -1,  2
    db  0

; Debug player/rival names (pret charmap encoding).
; Copied to W_PLAYER_NAME / W_RIVAL_NAME in PrepareTitleScreen.
; N=$8D I=$88 N=$8D T=$93 E=$84 N=$8D @=$50 (terminator)
DebugPlayerName:
    db 0x8D,0x88,0x8D,0x93,0x84,0x8D,0x50,0x50,0x50,0x50,0x50
; S=$92 O=$8E N=$8D Y=$98 @=$50
DebugRivalName:
    db 0x92,0x8E,0x8D,0x98,0x50,0x50,0x50,0x50,0x50,0x50,0x50

; ---------------------------------------------------------------------------
; Tile graphics and tilemaps (generated by tools/gen_title_gfx_inc.py)
; ---------------------------------------------------------------------------
%include "assets/pokemon_logo_2bpp.inc"
%include "assets/pokemon_logo_corner_2bpp.inc"
%include "assets/pikachu_bg_2bpp.inc"
%include "assets/pikachu_ob_2bpp.inc"
%include "assets/title_copyright_2bpp.inc"
%include "assets/gamefreak_inc_2bpp.inc"
%include "assets/nine_2bpp.inc"
%include "assets/pokemon_logo_tilemap.inc"
%include "assets/pikachu_tilemap.inc"
%include "assets/pika_bubble_tilemap.inc"

; ---------------------------------------------------------------------------
; Code
; ---------------------------------------------------------------------------
section .text

; ---------------------------------------------------------------------------
; PrepareTitleScreen — reset title-screen-relevant flags and fall through.
; Source: engine/movie/title.asm:PrepareTitleScreen
; ---------------------------------------------------------------------------
PrepareTitleScreen:
    ; Copy debug player/rival names to WRAM (matches original; overwritten later)
    lea esi, [DebugPlayerName]         ; flat address of our data
    lea edi, [ebp + W_PLAYER_NAME]
    mov ecx, NAME_LENGTH
    rep movsb
    lea esi, [DebugRivalName]
    lea edi, [ebp + W_RIVAL_NAME]
    mov ecx, NAME_LENGTH
    rep movsb

    ; Zero hWY (window on-screen at y=0 initially, DisableLCD will move it)
    mov byte [ebp + H_WY], 0

    ; Clear letter-printing / status / Elite4 flags
    xor al, al
    mov byte [ebp + W_LETTER_PRINTING_DELAY], al
    mov byte [ebp + W_STATUS_FLAGS_6],        al
    mov byte [ebp + W_STATUS_FLAGS_7],        al
    mov byte [ebp + W_ELITE4_FLAGS],          al

    ; Audio ROM bank — TODO: audio HAL (Phase 3); write placeholder
    ; BANK(Music_TitleScreen) = 0 for now (stub)
    mov byte [ebp + W_AUDIO_ROM_BANK],        al
    mov byte [ebp + W_AUDIO_SAVED_ROM_BANK],  al

    ; Fall through to DisplayTitleScreen

; ---------------------------------------------------------------------------
; DisplayTitleScreen — load graphics, bounce animation, idle loop.
; Source: engine/movie/title.asm:DisplayTitleScreen
; ---------------------------------------------------------------------------
DisplayTitleScreen:
    call GBPalWhiteOut

    ; Initialise HRAM display state
    mov byte [ebp + H_AUTO_BG_TRANSFER_EN], 1
    mov byte [ebp + H_TILE_ANIMATIONS],     0
    mov byte [ebp + H_SCX],                 0
    mov byte [ebp + H_SCY],                 0x40   ; start with SCY=64
    mov byte [ebp + H_WY],                  0x90   ; window off-screen (144)

    call ClearScreen
    call DisableLCD

    ; Load the game font (needed for text tiles displayed later)
    call LoadFontTilePatterns
    call LoadTextBoxTilePatterns
    call text_engine_init

    ; Load title-screen tile graphics to VRAM (all via direct rep movsb since
    ; source is in program image, not in GB memory; CopyData is for GB→GB copies)
    pushad

    ; Nintendo copyright tiles → vChars1 tile $60 ($8E00), 5 tiles
    lea esi, [title_copyright_2bpp]
    lea edi, [ebp + VCHARS1_TILE_60]
    mov ecx, 5 * 16
    rep movsb

    ; Nine tile → vChars1 tile $6E ($8EE0), 1 tile
    lea esi, [nine_2bpp]
    lea edi, [ebp + VCHARS1_TILE_6E]
    mov ecx, 1 * 16
    rep movsb

    ; GameFreak inc. logo → vChars1 tile $65 ($8E50), 9 tiles
    lea esi, [gamefreak_inc_2bpp]
    lea edi, [ebp + VCHARS1_TILE_65]
    mov ecx, 9 * 16
    rep movsb

    ; Yellow-specific graphics (logo, corner, pikachu BG/OBJ)
    ; LoadYellowTitleScreenGFX also uses pushad/popad; safe to nest
    popad
    call LoadYellowTitleScreenGFX

    ; Fill physical BG tilemap 0 + first half of tilemap 1 with blank space.
    ; Original: FillMemory(vBGMap0, (vBGMap1+$40*32)-vBGMap0, ' ')
    ; = $9800..$9C3F = $43F bytes. We fill the whole tilemap0 + 64 rows of TM1.
    ; Simplification: fill both tilemaps entirely with $7F (space).
    mov esi, GB_TILEMAP0
    mov bx, (TILEMAP_AREA * 2) & 0xFFFF  ; 2 × 1024 = 2048 bytes
    mov al, 0x7F
    call FillMemory

    ; Place Pokemon logo (16×7 tiles) at tilemap coord (col=2, row=1)
    call TitleScreen_PlacePokemonLogo

    ; FillSpriteBuffer0WithAA — SRAM not emulated; stub no-op.
    ; ; TODO-HW: fill sSpriteBuffer0 with $AA when SRAM is emulated.

    ; Write copyright row tiles at tilemap row 17 (bottom row)
    call WriteCopyrightTiles

    ; Save logo-only tilemap to Buffer2
    call SaveScreenTilesToBuffer2

    ; Load Buffer2 back (no-op: same content, but matches original sequence)
    call LoadScreenTilesFromBuffer2

    call EnableLCD

    ; Add Pikachu to the tilemap (logo+pikachu)
    call TitleScreen_PlacePikachu

    ; Copy logo+pikachu to physical tilemap at row 24 ($9B00)
    mov al, TILEMAP_DEST_HI_ROW24
    call TitleScreenCopyTileMapToVRAM

    ; Save logo+pikachu tilemap to Buffer1
    call SaveScreenTilesToBuffer1

    ; Set SCY=64 (viewport 8 tile rows down; logo slides in from below)
    mov byte [ebp + H_SCY], 0x40

    ; Restore logo-only tilemap and copy to row 0 ($9800)
    call LoadScreenTilesFromBuffer2
    mov al, TILEMAP_DEST_HI_ROW0
    call TitleScreenCopyTileMapToVRAM

    ; RunPaletteCommand / GBPalNormal — ; TODO-HW: CGB palette (Phase 5)
    call GBPalNormal

    ; rOBP0 = %11100000 — ; TODO-HW: OBP0 (sprite renderer Phase 1)
    ; mov byte [ebp + IO_OBP0], 0xE0

    ; ---------------------------------------------------------------------------
    ; Bounce animation: SCY slides from 64 → 0 with spring-damped overshoot.
    ; Table: pairs (delta, count); $00 = end of table.
    ; ---------------------------------------------------------------------------
    lea esi, [TitleScreenYScrolls]    ; ESI = table pointer (flat DS address)

.bounceLoop:
    movsx eax, byte [esi]             ; AL = delta (signed)
    test al, al
    jz .finishedBouncing
    inc esi
    movzx ecx, byte [esi]             ; CL = repeat count
    inc esi

    ; SFX_INTRO_CRASH on first -3 scroll step — ; TODO-HW: audio (Phase 3)

.scrollStep:
    call DelayFrame
    ; hSCY += delta
    mov dl, [ebp + H_SCY]
    add dl, al
    mov [ebp + H_SCY], dl
    loop .scrollStep                  ; ECX-- until zero

    jmp .bounceLoop

.finishedBouncing:
    ; Restore logo+pikachu and let auto-BG-transfer commit it to $9800
    call LoadScreenTilesFromBuffer1
    mov bl, 36
    call DelayFrames                  ; 36 frames → Pikachu appears

    ; SFX_INTRO_WHOOSH — ; TODO-HW: audio (Phase 3)

    ; Add speech bubble to current wTileMap (logo+pikachu)
    call TitleScreen_PlacePikaSpeechBubble
    mov byte [ebp + H_WY], SCREEN_HEIGHT_PX   ; window off-screen
    call Delay3

    ; TitleScreen_PlayPikachuPCM — ; TODO-HW: audio (Phase 3)
    ; WaitForSoundToFinish         — ; TODO-HW: audio (Phase 3)
    ; StopAllMusic                 — ; TODO-HW: audio (Phase 3)
    ; PlaySound(MUSIC_TITLE_SCREEN)— ; TODO-HW: audio (Phase 3)

    ; ---------------------------------------------------------------------------
    ; Main idle loop: blink Pikachu's eyes, wait for input, reset on timeout.
    ; ---------------------------------------------------------------------------
.loop:
    ; Reset per-loop title screen state
    xor al, al
    mov byte [ebp + W_UNUSED_FLAG],            al
    mov byte [ebp + W_TITLE_SCREEN_SCENE],     al
    mov byte [ebp + W_TITLE_SCREEN_TIMER],     al
    mov byte [ebp + W_TITLE_SCREEN_SCENE + 2], al  ; reset counter low
    mov byte [ebp + W_TITLE_SCREEN_SCENE + 3], al  ; reset counter high
    mov byte [ebp + W_TITLE_SCREEN_SCENE + 4], 0x0F

.titleScreenLoop:
    call IncrementResetCounter
    jc   .doTitlescreenReset
    call DelayFrame
    call JoypadLowSensitivity
    mov al, [ebp + H_JOY_HELD]
    cmp al, PAD_UP | PAD_SELECT | PAD_B       ; secret reset-save combo
    je  .go_to_main_menu
    and al, PAD_A | PAD_START
    jnz .go_to_main_menu
    call DoTitleScreenFunction
    jmp .titleScreenLoop

.go_to_main_menu:
    ; GBPalWhiteOutWithDelay3 — ; TODO-HW: palette fade (Phase 5)
    call ClearSprites
    xor al, al
    mov byte [ebp + H_WY], al
    inc al
    mov byte [ebp + H_AUTO_BG_TRANSFER_EN], al
    call ClearScreen
    mov al, TILEMAP_DEST_HI_ROW0
    call TitleScreenCopyTileMapToVRAM
    mov al, (GB_TILEMAP1 >> 8) & 0xFF
    call TitleScreenCopyTileMapToVRAM
    call Delay3
    ; LoadGBPal — TODO: when CGB palettes land (Phase 5); GBPalNormal suffices
    call GBPalNormal

    ; Check if the reset-save combo was pressed (PAD_UP|PAD_SELECT|PAD_B)
    mov al, [ebp + H_JOY_HELD]
    and al, PAD_UP | PAD_SELECT | PAD_B
    cmp al, PAD_UP | PAD_SELECT | PAD_B
    je  .doClearSaveDialogue

    ; jp MainMenu → EnterMap (Phase 2: load Pallet Town directly)
    jmp EnterMap

.doClearSaveDialogue:
    ; DoClearSaveDialogue — ; TODO: save clear screen (Phase 5). Reset for now.
    jmp Init

.doTitlescreenReset:
    ; Audio fade — ; TODO-HW: audio (Phase 3)
    ; StopAllMusic — ; TODO-HW: audio (Phase 3)
    jmp Init

; ---------------------------------------------------------------------------
; TitleScreenCopyTileMapToVRAM — set hAutoBGTransferDest hi byte, wait 3 frames.
; In:  AL = high byte of the GB tilemap destination.
; Source: engine/movie/title.asm:TitleScreenCopyTileMapToVRAM
; ---------------------------------------------------------------------------
TitleScreenCopyTileMapToVRAM:
    mov byte [ebp + H_AUTO_BG_TRANSFER_DEST + 1], al
    jmp Delay3    ; tail call

; ---------------------------------------------------------------------------
; WriteCopyrightTiles — place ©1995-1999 GAME FREAK inc. at tilemap row 17.
; Source: engine/movie/title.asm:.WriteCopyrightTiles
; ---------------------------------------------------------------------------
WriteCopyrightTiles:
    push esi
    push edi
    lea esi, [CopyrightRowTiles]
    ; coord(2, 17) in wTileMap = W_TILEMAP + 17*20 + 2
    lea edi, [ebp + W_TILEMAP + 17 * SCREEN_TILES_W + 2]
.copy:
    mov al, [esi]
    inc esi
    cmp al, 0xFF
    je .done
    mov [edi], al
    inc edi
    jmp .copy
.done:
    pop edi
    pop esi
    ret

; ---------------------------------------------------------------------------
; ClearScreen — fill wTileMap with $7F (space), enable auto-BG-transfer,
; wait 3 frames.
; Source: home/copy2.asm:ClearScreen
; ---------------------------------------------------------------------------
ClearScreen:
    push esi
    push ebx
    push eax
    mov esi, W_TILEMAP
    mov bx,  SCREEN_AREA & 0xFFFF
    mov al,  0x7F
    call FillMemory
    mov byte [ebp + H_AUTO_BG_TRANSFER_EN], 1
    pop eax
    pop ebx
    pop esi
    jmp Delay3    ; tail call

; ---------------------------------------------------------------------------
; GBPalWhiteOut — fade palette to white (Phase 5 stub: set BGP=00).
; ---------------------------------------------------------------------------
GBPalWhiteOut:
    mov byte [ebp + IO_BGP], 0x00
    ret

; ---------------------------------------------------------------------------
; JoypadLowSensitivity — joypad read, low sensitivity debounce.
; In the DOS port, DelayFrame already calls joypad_update which populates
; H_JOY_HELD. Nothing more needed here.
; Source: home/joypad.asm:JoypadLowSensitivity
; ---------------------------------------------------------------------------
JoypadLowSensitivity:
    ret

; ---------------------------------------------------------------------------
; SaveScreenTilesToBuffer1 — copy wTileMap → wTileMapBackup.
; Source: home/tilemap.asm:SaveScreenTilesToBuffer1
; ---------------------------------------------------------------------------
SaveScreenTilesToBuffer1:
    pushad
    lea esi, [ebp + W_TILEMAP]
    lea edi, [ebp + W_TILEMAP_BACKUP]
    mov ecx, SCREEN_AREA
    rep movsb
    popad
    ret

; ---------------------------------------------------------------------------
; SaveScreenTilesToBuffer2 — copy wTileMap → wTileMapBackup2.
; Source: home/tilemap.asm:SaveScreenTilesToBuffer2
; ---------------------------------------------------------------------------
SaveScreenTilesToBuffer2:
    pushad
    lea esi, [ebp + W_TILEMAP]
    lea edi, [ebp + W_TILEMAP_BACKUP2]
    mov ecx, SCREEN_AREA
    rep movsb
    popad
    ret

; ---------------------------------------------------------------------------
; LoadScreenTilesFromBuffer1 — disable auto-BG, copy wTileMapBackup → wTileMap,
; re-enable auto-BG.
; Source: home/tilemap.asm:LoadScreenTilesFromBuffer1
; ---------------------------------------------------------------------------
LoadScreenTilesFromBuffer1:
    pushad
    mov byte [ebp + H_AUTO_BG_TRANSFER_EN], 0
    lea esi, [ebp + W_TILEMAP_BACKUP]
    lea edi, [ebp + W_TILEMAP]
    mov ecx, SCREEN_AREA
    rep movsb
    mov byte [ebp + H_AUTO_BG_TRANSFER_EN], 1
    popad
    ret

; ---------------------------------------------------------------------------
; LoadScreenTilesFromBuffer2 — disable auto-BG, copy wTileMapBackup2 → wTileMap,
; re-enable auto-BG.
; Source: home/tilemap.asm:LoadScreenTilesFromBuffer2
; ---------------------------------------------------------------------------
LoadScreenTilesFromBuffer2:
    pushad
    mov byte [ebp + H_AUTO_BG_TRANSFER_EN], 0
    lea esi, [ebp + W_TILEMAP_BACKUP2]
    lea edi, [ebp + W_TILEMAP]
    mov ecx, SCREEN_AREA
    rep movsb
    mov byte [ebp + H_AUTO_BG_TRANSFER_EN], 1
    popad
    ret

; ---------------------------------------------------------------------------
; LoadYellowTitleScreenGFX — load all Pokemon Yellow title tile graphics.
; Source: engine/movie/title_yellow.asm:LoadYellowTitleScreenGFX
;
; VRAM layout (signed tile mode, LCDC_DEFAULT=$E3, bit4=0, base $9000):
;   $9000 (vChars2)           ← Pokemon logo main tiles (128 tiles = $800 bytes)
;   $8FD0 (vChars1 tile $7D)  ← Logo corner tiles (3 tiles = $30 bytes)
;   $8800 (vChars1)           ← Pikachu BG tiles (64 tiles = $400 bytes)
;   $8F00 (vChars1 tile $70)  ← Pikachu OBJ sprite tiles (12 tiles = $C0 bytes)
; ---------------------------------------------------------------------------
LoadYellowTitleScreenGFX:
    pushad

    ; Pokemon logo → vChars2 ($9000), 128 tiles
    lea esi, [pokemon_logo_2bpp]
    lea edi, [ebp + GB_VCHARS2]
    mov ecx, POKEMON_LOGO_2BPP_SIZE
    rep movsb

    ; Logo corner tiles → vChars1 tile $7D ($8FD0), 3 tiles
    lea esi, [pokemon_logo_corner_2bpp]
    lea edi, [ebp + VCHARS1_TILE_7D]
    mov ecx, POKEMON_LOGO_CORNER_2BPP_SIZE
    rep movsb

    ; Pikachu BG tiles → vChars1 ($8800), 64 tiles
    lea esi, [pikachu_bg_2bpp]
    lea edi, [ebp + GB_VFONT]
    mov ecx, PIKACHU_BG_2BPP_SIZE
    rep movsb

    ; Pikachu OBJ sprite tiles → vChars1 tile $70 ($8F00), 12 tiles
    lea esi, [pikachu_ob_2bpp]
    lea edi, [ebp + VCHARS1_TILE_70]
    mov ecx, PIKACHU_OB_2BPP_SIZE
    rep movsb

    popad
    ret

; ---------------------------------------------------------------------------
; TitleScreen_PlacePokemonLogo — copy 16×7 logo tilemap into wTileMap at (2,1).
; Source: engine/movie/title_yellow.asm:TitleScreen_PlacePokemonLogo
; ---------------------------------------------------------------------------
TitleScreen_PlacePokemonLogo:
    pushad
    lea esi, [pokemon_logo_tilemap]
    ; dest = wTileMap + row=1 * SCREEN_TILES_W + col=2
    lea edi, [ebp + W_TILEMAP + 1 * SCREEN_TILES_W + 2]
    mov ebx, POKEMON_LOGO_TILEMAP_HEIGHT   ; 7 rows
.logo_row:
    mov ecx, POKEMON_LOGO_TILEMAP_WIDTH    ; 16 tiles per row
    rep movsb
    add edi, SCREEN_TILES_W - POKEMON_LOGO_TILEMAP_WIDTH  ; skip to next row (4 bytes)
    dec ebx
    jnz .logo_row
    popad
    ret

; ---------------------------------------------------------------------------
; TitleScreen_PlacePikachu — add pikachu tilemap (12×9) to wTileMap at (4,8),
; place tail tiles, and copy eye OAM data to wShadowOAM.
; Source: engine/movie/title_yellow.asm:TitleScreen_PlacePikachu
; ---------------------------------------------------------------------------
TitleScreen_PlacePikachu:
    pushad

    ; Place 12×9 pikachu tilemap at coord (col=4, row=8)
    lea esi, [pikachu_tilemap]
    lea edi, [ebp + W_TILEMAP + 8 * SCREEN_TILES_W + 4]
    mov ebx, PIKACHU_TILEMAP_HEIGHT       ; 9 rows
.pika_row:
    mov ecx, PIKACHU_TILEMAP_WIDTH        ; 12 tiles per row
    rep movsb
    add edi, SCREEN_TILES_W - PIKACHU_TILEMAP_WIDTH  ; skip remaining 8 cols
    dec ebx
    jnz .pika_row

    ; Place extra tail/overlap tiles at column 16, rows 10-13
    mov byte [ebp + W_TILEMAP + 10 * SCREEN_TILES_W + 16], 0x96
    mov byte [ebp + W_TILEMAP + 11 * SCREEN_TILES_W + 16], 0x9D
    mov byte [ebp + W_TILEMAP + 12 * SCREEN_TILES_W + 16], 0xA7
    mov byte [ebp + W_TILEMAP + 13 * SCREEN_TILES_W + 16], 0xB1

    ; Copy eye OAM data to wShadowOAM (32 bytes = 8 sprites × 4 bytes)
    ; OAM rendering is a Phase 1 open item; writes are correct for when it lands.
    ; ; TODO-HW: OAM sprite renderer (Phase 1)
    lea esi, [TitleScreenPikachuEyesOAMData]
    lea edi, [ebp + W_SHADOW_OAM]
    mov ecx, 32
    rep movsb

    popad
    ret

; ---------------------------------------------------------------------------
; TitleScreen_PlacePikaSpeechBubble — place 7×4 speech bubble at (6,4)
; and overlay two logo tiles at (9,8).
; Source: engine/movie/title_yellow.asm:TitleScreen_PlacePikaSpeechBubble
; ---------------------------------------------------------------------------
TitleScreen_PlacePikaSpeechBubble:
    pushad

    ; 7×4 bubble tilemap at coord (col=6, row=4)
    lea esi, [pika_bubble_tilemap]
    lea edi, [ebp + W_TILEMAP + 4 * SCREEN_TILES_W + 6]
    mov ebx, PIKA_BUBBLE_TILEMAP_HEIGHT   ; 4 rows
.bubble_row:
    mov ecx, PIKA_BUBBLE_TILEMAP_WIDTH    ; 7 tiles per row
    rep movsb
    add edi, SCREEN_TILES_W - PIKA_BUBBLE_TILEMAP_WIDTH
    dec ebx
    jnz .bubble_row

    ; Two logo-area tiles placed at (9,8) and (10,8)
    ; $64 = logo tile 100 (signed + → vChars2), $65 = logo tile 101
    mov byte [ebp + W_TILEMAP + 8 * SCREEN_TILES_W + 9],  0x64
    mov byte [ebp + W_TILEMAP + 8 * SCREEN_TILES_W + 10], 0x65

    popad
    ret

; ---------------------------------------------------------------------------
; DoTitleScreenFunction — drive Pikachu eye-blink state machine.
; Source: engine/movie/title.asm:DoTitleScreenFunction
;
; Jumptable (12 entries, indexed by wTitleScreenScene 0-11):
;   0→Nop, 1→BlinkHalf, 2-3→BlinkWait, 4→BlinkClosed, 5-6→BlinkWait,
;   7→BlinkHalf, 8-9→BlinkWait, 10→BlinkOpen, 11→GoBackToStart
; ---------------------------------------------------------------------------
DoTitleScreenFunction:
    call .CheckTimer
    movzx eax, byte [ebp + W_TITLE_SCREEN_SCENE]
    cmp al, 11
    ja .Nop           ; clamp out-of-range scenes
    lea edi, [.Jumptable]
    jmp [edi + eax * 4]

section .data
.Jumptable:
    dd .Nop, .BlinkHalf, .BlinkWait, .BlinkWait, .BlinkClosed
    dd .BlinkWait, .BlinkWait, .BlinkHalf, .BlinkWait, .BlinkWait
    dd .BlinkOpen, .GoBackToStart

section .text

.GoBackToStart:
    mov byte [ebp + W_TITLE_SCREEN_SCENE], 0
.Nop:
    ret

.BlinkOpen:
    xor dl, dl
    jmp .LoadBlinkFrame
.BlinkHalf:
    mov dl, 4
    jmp .LoadBlinkFrame
.BlinkClosed:
    mov dl, 8
.LoadBlinkFrame:
    ; Modify TileID byte of 8 OAM sprites: clear bits 2-3, OR with DL (blink state)
    ; ; TODO-HW: OAM sprite renderer (Phase 1) — writes correct but not visible yet
    lea esi, [ebp + W_SHADOW_OAM + 2]    ; TileID of sprite 0
    mov ecx, 8
.blink_loop:
    mov al, [esi]
    and al, 0xF3
    or  al, dl
    mov [esi], al
    add esi, 4                             ; advance to next sprite's TileID
    dec ecx
    jnz .blink_loop
.BlinkWait:
    inc byte [ebp + W_TITLE_SCREEN_SCENE]
    ret

.CheckTimer:
    push eax
    lea esi, [ebp + W_TITLE_SCREEN_TIMER]
    mov al, [esi]
    inc byte [esi]
    test al, al
    jz .restart
    cmp al, 0x80
    je .restart
    cmp al, 0x90
    jne .timer_done
.restart:
    mov byte [ebp + W_TITLE_SCREEN_SCENE], 1
.timer_done:
    pop eax
    ret

; ---------------------------------------------------------------------------
; IncrementResetCounter — increment the 16-bit inactivity counter at
; wTitleScreenScene+2/+3. Sets CF if high byte reaches $0C (~51 s at 60 Hz).
; Source: engine/movie/title.asm:IncrementResetCounter
; ---------------------------------------------------------------------------
IncrementResetCounter:
    pushad
    lea esi, [ebp + W_TITLE_SCREEN_SCENE + 2]
    movzx eax, byte [esi]       ; lo byte of counter
    movzx edx, byte [esi + 1]   ; hi byte of counter
    inc eax
    cmp eax, 0x100
    jb .no_carry
    xor eax, eax
    inc edx
.no_carry:
    cmp edx, 0x0C
    je .do_reset
    mov [esi],     al
    mov [esi + 1], dl
    popad
    clc
    ret
.do_reset:
    popad
    stc
    ret
