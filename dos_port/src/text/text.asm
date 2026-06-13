; text.asm — TextBoxBorder and PlaceString translated from SM83 to x86.
;
; Source: home/text.asm (pret/pokeyellow)
;
; The text engine writes character codes (charmap.asm) into the screen tile
; buffer (wTileMap, $C3A0, 20×18). Each code is also the VRAM tile index, so
; the buffer transfers verbatim to the BG tilemap. Coordinates:
;   wTileMap + y * SCREEN_W_TILES + x  ("coord" macro equivalent)
;
; Register map: HL→ESI (dest, EBP-relative), DE→EDX (src string, EBP-relative),
; BC→EBX, A→AL.
;
; CONTROL CODES handled here: '@' ($50 terminator), '<NEXT>' ($4E, next line),
; '<LINE>' ($4F, dialogue line 2). Substitution codes ($49–$5F: <PLAYER>, <PARA>,
; <CONT>, …) are skipped (advance past, place nothing) pending their subsystems.
; ; TODO: wire dictionary control codes when those subsystems land.
;
; Build: nasm -f coff -I include/ -o text.o text.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

CHAR_TERMINATOR  equ 0x50
CHAR_NEXT        equ 0x4E
CHAR_LINE        equ 0x4F
CHAR_FIRST_GLYPH equ 0x60

; Box-drawing tile codes (charmap.asm $79–$7E); graphics from TextBoxGraphics.
; ; TODO: load TextBoxGraphics so box tiles are visible.
BOX_TL    equ 0x79
BOX_H     equ 0x7A
BOX_TR    equ 0x7B
BOX_V     equ 0x7C
BOX_BL    equ 0x7D
BOX_BR    equ 0x7E
TILE_SPACE equ 0x7F

SCREEN_W_TILES equ 20

global TextBoxBorder
global PlaceString
global PlaceNextChar

section .text

; ---------------------------------------------------------------------------
; TextBoxBorder — draw a BL-wide × BH-tall bordered text box at ESI.
;
; In:  ESI = top-left tile-buffer offset (HL), BL = interior width (C),
;      BH = interior height (B).
; Out: ESI unchanged. EBX preserved.
; ---------------------------------------------------------------------------
TextBoxBorder:
    push esi
    push ebx

    movzx ecx, bl
    movzx edx, bh
    lea edi, [ebp + esi]

    ; top row: ┌ ─×width ┐
    mov byte [edi], BOX_TL
    call .fill_h
    mov byte [edi + ecx + 1], BOX_TR
    add edi, SCREEN_W_TILES

    ; middle rows: │ ' '×width │
.mid:
    mov byte [edi], BOX_V
    push eax
    mov al, TILE_SPACE
    call .fill_chars
    pop eax
    mov byte [edi + ecx + 1], BOX_V
    add edi, SCREEN_W_TILES
    dec edx
    jnz .mid

    ; bottom row: └ ─×width ┘
    mov byte [edi], BOX_BL
    call .fill_h
    mov byte [edi + ecx + 1], BOX_BR

    pop ebx
    pop esi
    ret

.fill_h:
    push eax
    mov al, BOX_H
    call .fill_chars
    pop eax
    ret

; fill ECX copies of AL at [edi+1]; preserves edi, ecx
.fill_chars:
    push ecx
    push edi
    inc edi
.fc:
    mov [edi], al
    inc edi
    dec ecx
    jnz .fc
    pop edi
    pop ecx
    ret

; ---------------------------------------------------------------------------
; PlaceString — render '@'-terminated string at EDX into tile buffer at ESI.
;
; In:  EDX = source string offset (DE, EBP-relative)
;      ESI = dest tile-buffer offset (HL, EBP-relative)
; Out: EBX = offset just past the last tile written (BC in SM83).
;      ESI restored to line start. EAX, EDX clobbered.
; ---------------------------------------------------------------------------
PlaceString:
    push esi                    ; save line start (SM83: push hl)
PlaceNextChar:
    movzx eax, byte [ebp + edx]

    cmp al, CHAR_TERMINATOR
    jne .not_term
    mov ebx, esi
    pop esi
    ret

.not_term:
    cmp al, CHAR_NEXT
    jne .not_next
    ; advance to next line (1 or 2 rows depending on single-spaced flag)
    pop esi
    add esi, SCREEN_W_TILES
    test byte [ebp + H_UI_LAYOUT_FLAGS], 1 << BIT_SINGLE_SPACED_LINES
    jnz .next_push
    add esi, SCREEN_W_TILES
.next_push:
    push esi
    jmp .advance

.not_next:
    cmp al, CHAR_LINE
    jne .not_line
    ; dialogue continuation: coord (1, 16)
    pop esi
    mov esi, W_TILEMAP + 16 * SCREEN_W_TILES + 1
    push esi
    jmp .advance

.not_line:
    cmp al, CHAR_FIRST_GLYPH
    jb .advance                 ; unhandled control code — skip silently
    ; literal glyph
    mov [ebp + esi], al
    inc esi

.advance:
    inc edx
    jmp PlaceNextChar
