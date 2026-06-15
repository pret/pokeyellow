; load_font.asm — expand the 1bpp text font to 2bpp and load it into vFont;
; also copy the 2bpp extra-char / box-drawing tiles to vChars2+$60.
;
; LoadFontTilePatterns — source: home/load_font.asm.
; Mirrors home/copy2.asm:FarCopyDataDouble (1bpp → 2bpp expansion).
; The font art (gfx/font/font.png) is embedded as NASM data via
; assets/font_1bpp.inc (tools/gen_font_inc.py). With LCDC_DEFAULT ($8800
; signed addressing), char code C ('A'=$80) maps to tile at $8800+(C-$80)*16.
;
; LoadTextBoxTilePatterns — source: home/load_font.asm:LoadTextBoxTilePatterns.
; Copies 2bpp data (gfx/font/font_extra.png, chars $60-$7F) to vChars2+$60
; (EBP offset $9600). Includes box-drawing tiles $79-$7E used by TextBoxBorder.
; Data embedded via assets/font_extra_2bpp.inc (tools/gen_font_extra_inc.py).
;
; Build: nasm -f coff -I include/ -I . -o load_font.o load_font.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

global LoadFontTilePatterns
global LoadTextBoxTilePatterns
extern g_tilecache_dirty

section .data
align 4
%include "assets/font_1bpp.inc"
%include "assets/font_extra_2bpp.inc"

section .text

; ---------------------------------------------------------------------------
; LoadFontTilePatterns — expand embedded 1bpp font into vFont ($8800) as 2bpp.
; In:  EBP = GB memory base.
; Out: all registers preserved.
; ---------------------------------------------------------------------------
LoadFontTilePatterns:
    mov byte [g_tilecache_dirty], 1     ; VRAM tile data changes → rebuild decode cache
    push eax
    push ecx
    push esi
    push edi

    mov esi, font_1bpp_data
    lea edi, [ebp + GB_VFONT]
    mov ecx, FONT_1BPP_SIZE
.loop:
    lodsb
    mov ah, al
    mov [edi],     al    ; low bitplane
    mov [edi + 1], ah    ; high bitplane (duplicate → colors 0 or 3)
    add edi, 2
    dec ecx
    jnz .loop

    pop edi
    pop esi
    pop ecx
    pop eax
    ret

; ---------------------------------------------------------------------------
; LoadTextBoxTilePatterns — copy 2bpp box/extra-char tiles to vChars2+$60.
;
; Source: home/load_font.asm:LoadTextBoxTilePatterns.
; Destination: vChars2 tile $60 = EBP + GB_VCHARS2 + $60*TILE_SIZE = EBP+$9600.
; Data: 32 tiles (chars $60-$7F, including box-drawing tiles $79-$7E).
; In:  EBP = GB memory base.
; Out: all registers preserved.
; ---------------------------------------------------------------------------
LoadTextBoxTilePatterns:
    mov byte [g_tilecache_dirty], 1     ; VRAM tile data changes → rebuild decode cache
    push eax
    push ecx
    push esi
    push edi

    mov esi, font_extra_2bpp_data
    lea edi, [ebp + GB_VCHARS2 + 0x60 * TILE_SIZE]
    mov ecx, FONT_EXTRA_2BPP_SIZE / 4
    rep movsd

    pop edi
    pop esi
    pop ecx
    pop eax
    ret
