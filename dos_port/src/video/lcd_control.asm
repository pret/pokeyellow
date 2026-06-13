; lcd_control.asm — DisableLCD / EnableLCD / ClearBgMap / FillBgMap.
;
; Sources: home/lcd.asm:DisableLCD, EnableLCD
;          home/vcopy.asm:ClearBgMap, FillBgMapCommon
;
; The LCD on/off dance on real hardware races the PPU scanline counter and
; toggles rLCDC bit 7. In this port the renderer is driven by the main loop,
; so we only keep/clear the shadow bit — there is no scanline hazard.
; ; TODO-HW: honour LCD-off timing if a scanline-accurate renderer is added.
;
; Build: nasm -f coff -I include/ -o lcd_control.o lcd_control.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

LCDC_ON_BIT equ 7

global DisableLCD
global EnableLCD
global ClearBgMap
global FillBgMap

section .text

; ---------------------------------------------------------------------------
; DisableLCD — clear LCD-enable bit in the LCDC shadow. All registers preserved.
; ---------------------------------------------------------------------------
DisableLCD:
    and byte [ebp + IO_LCDC], ~(1 << LCDC_ON_BIT) & 0xFF
    ret

; ---------------------------------------------------------------------------
; EnableLCD — set LCD-enable bit in the LCDC shadow. All registers preserved.
; ---------------------------------------------------------------------------
EnableLCD:
    or byte [ebp + IO_LCDC], (1 << LCDC_ON_BIT)
    ret

; ---------------------------------------------------------------------------
; ClearBgMap — fill a BG tilemap (TILEMAP_AREA bytes) with the blank tile ($7F).
; In:  ESI = tilemap base offset (GB_TILEMAP0 or GB_TILEMAP1)
; Out: all registers preserved.
; ---------------------------------------------------------------------------
ClearBgMap:
    push eax
    mov al, 0x7F
    call FillBgMap
    pop eax
    ret

; ---------------------------------------------------------------------------
; FillBgMap — fill a BG tilemap with tile AL.
; In:  ESI = tilemap base offset, AL = tile index
; Out: all registers preserved.
; ---------------------------------------------------------------------------
FillBgMap:
    push ecx
    push edi
    lea edi, [ebp + esi]
    mov ecx, TILEMAP_AREA
    rep stosb
    pop edi
    pop ecx
    ret
