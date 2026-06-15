; init.asm — Init / ClearVram / StopAllSounds / GBPalNormal.
;
; Source: home/init.asm (pret/pokeyellow)
;
; Init is the power-on / soft-reset entry. It clears WRAM, VRAM, HRAM, OAM and
; resets I/O shadows to DMG power-up values, then falls through to the title
; screen. Hardware / not-yet-ported subsystem steps are marked TODO and skipped
; so the routine stays linkable and faithful in structure:
;
;   di/ei, rIF/rIE writes        → no GB interrupt controller; shadows only
;   WriteDMACodeToHRAM + rROMB   → ; TODO-HW: OAM DMA + ROM banking
;   predef LoadSGB               → ; TODO-HW: SGB detect (wOnSGB stays 0)
;   predef PlayIntro             → ; TODO: Pikachu intro (later in Phase 2)
;   audio engine setup           → ; TODO: audio HAL (Phase 3)
;   jp PrepareTitleScreen        → ; TODO: title screen (Phase 2); returns for now
;
; Constants resolved from the rgbds build (pokeyellow.sym):
;   LCDC_DEFAULT = $E3, LCDC_ON = $80, IE = $0D, BGP normal = $E4, OBP0 = $D0
;
; Build: nasm -f coff -I include/ -o init.o init.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

LCDC_ON_VAL      equ 0x80
LCDC_DEFAULT_VAL equ 0xE3
IE_DEFAULT_VAL   equ 0x0D
CONNECTION_NONE  equ 0xFF
BGP_NORMAL       equ 0xE4
OBP0_NORMAL      equ 0xD0
WRAM0_SIZE       equ 0x1000
VRAM_SIZE        equ 0x2000

extern FillMemory
extern DisableLCD
extern ClearBgMap
extern ClearSprites
extern PrepareTitleScreen
%ifdef SKIP_TITLE
extern EnterMap
%endif

global Init
global ClearVram
global StopAllSounds
global GBPalNormal
extern g_tilecache_dirty

section .text

; ---------------------------------------------------------------------------
; Init — power-on / soft-reset routine.
; ---------------------------------------------------------------------------
Init:
    ; Reset I/O shadows to 0 (di/rIF/rIE — no GB interrupt controller)
    xor al, al
    mov byte [ebp + IO_SCX],  al
    mov byte [ebp + IO_SCY],  al
    mov byte [ebp + IO_SB],   al
    mov byte [ebp + IO_SC],   al
    mov byte [ebp + IO_WX],   al
    mov byte [ebp + IO_WY],   al
    mov byte [ebp + IO_TMA],  al
    mov byte [ebp + IO_TAC],  al
    mov byte [ebp + IO_BGP],  al
    mov byte [ebp + IO_OBP0], al
    mov byte [ebp + IO_OBP1], al

    mov byte [ebp + IO_LCDC], LCDC_ON_VAL
    call DisableLCD

    ; Zero WRAM0 ($C000, $1000 bytes)
    push edi
    push ecx
    lea edi, [ebp + GB_WRAM0]
    mov ecx, WRAM0_SIZE
    xor eax, eax
    rep stosb
    pop ecx
    pop edi

    call ClearVram

    ; Fill HRAM with 0 (SIZEOF(HRAM) - 1 bytes, matching the SM83 original)
    mov esi, GB_HRAM
    mov bx, GB_HRAM_SIZE - 1
    xor al, al
    call FillMemory

    call ClearSprites

    ; WriteDMACodeToHRAM / rROMB — ; TODO-HW: OAM DMA + ROM banking.
    ; The software PPU reads shadow OAM directly; no HRAM stub needed.

    xor al, al
    mov byte [ebp + H_TILE_ANIMATIONS],   al
    mov byte [ebp + IO_STAT],             al
    mov byte [ebp + H_SCX],              al
    mov byte [ebp + H_SCY],              al
    ; wc0f3 / wc0f3+1 — zeroed by the WRAM0 clear above

    mov byte [ebp + GB_IE], IE_DEFAULT_VAL

    ; Move window off-screen
    mov byte [ebp + H_WY],   144
    mov byte [ebp + IO_WY],  144
    mov byte [ebp + IO_WX],  7

    mov byte [ebp + H_SERIAL_CONN_STATUS], CONNECTION_NONE

    ; Clear both BG tilemaps to blank space ($7F)
    mov esi, GB_TILEMAP0
    call ClearBgMap
    mov esi, GB_TILEMAP1
    call ClearBgMap

    mov byte [ebp + IO_LCDC],       LCDC_DEFAULT_VAL
    mov byte [ebp + H_SOFT_RESET],  16
    call StopAllSounds

    ; ei — no GB interrupt controller

    ; predef LoadSGB — ; TODO-HW: SGB detection. wOnSGB stays 0 (zeroed above).

    ; Audio ROM-bank setup — ; TODO: audio HAL (Phase 3).

    ; hAutoBGTransferDest = vBGMap1 ($9C00)
    mov byte [ebp + H_AUTO_BG_TRANSFER_DEST + 1], (GB_TILEMAP1 >> 8) & 0xFF
    mov byte [ebp + H_AUTO_BG_TRANSFER_DEST],      GB_TILEMAP1 & 0xFF

    ; predef PlayIntro — ; TODO: Pikachu intro animation (later Phase 2).

    call DisableLCD
    call ClearVram
    call GBPalNormal
    call ClearSprites
    mov byte [ebp + IO_LCDC], LCDC_DEFAULT_VAL

%ifdef SKIP_TITLE
    jmp EnterMap             ; test build: skip title screen, go straight to overworld
%else
    jmp PrepareTitleScreen   ; tail call — runs title screen, never returns normally
%endif

; ---------------------------------------------------------------------------
; ClearVram — zero all of VRAM ($8000, $2000 bytes).
; ---------------------------------------------------------------------------
ClearVram:
    mov byte [g_tilecache_dirty], 1     ; VRAM tile data changes → rebuild decode cache
    mov esi, GB_VRAM0
    mov bx,  VRAM_SIZE & 0xFFFF
    xor al,  al
    jmp FillMemory              ; tail-call (jp FillMemory in the original)

; ---------------------------------------------------------------------------
; StopAllSounds — stub. WRAM scratch is zeroed by Init's WRAM clear.
; ; TODO: audio HAL — wire StopAllMusic when Phase 3 lands.
; ---------------------------------------------------------------------------
StopAllSounds:
    ret

; ---------------------------------------------------------------------------
; GBPalNormal — reset BGP/OBP0/OBP1 shadows to DMG normal palettes.
; CGB palette updates deferred to Phase 5.
; ---------------------------------------------------------------------------
GBPalNormal:
    mov byte [ebp + IO_BGP],  BGP_NORMAL
    mov byte [ebp + IO_OBP0], OBP0_NORMAL
    ret
