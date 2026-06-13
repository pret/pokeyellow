; sprites.asm — ClearSprites / HideSprites translated from SM83 to x86.
;
; Source: home/clear_sprites.asm:ClearSprites, HideSprites
;
; Operate on shadow OAM (wShadowOAM, $C300, 40 sprites × 4 bytes each).
; ClearSprites zeroes it; HideSprites sets each sprite's Y to 160 (off-screen).
;
; Build: nasm -f coff -I include/ -o sprites.o sprites.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

OBJ_SIZE         equ 4
SCREEN_HEIGHT_PX equ 144
OAM_Y_OFS        equ 16

global ClearSprites
global HideSprites

section .text

; ---------------------------------------------------------------------------
; ClearSprites — zero the entire shadow OAM buffer. All registers preserved.
; ---------------------------------------------------------------------------
ClearSprites:
    push eax
    push ecx
    push edi
    lea edi, [ebp + W_SHADOW_OAM]
    mov ecx, W_SHADOW_OAM_SIZE
    xor eax, eax
    rep stosb
    pop edi
    pop ecx
    pop eax
    ret

; ---------------------------------------------------------------------------
; HideSprites — set every sprite's Y to SCREEN_HEIGHT_PX + OAM_Y_OFS (= 160).
; All registers preserved.
; ---------------------------------------------------------------------------
HideSprites:
    push eax
    push ecx
    push edi
    lea edi, [ebp + W_SHADOW_OAM]
    mov al, SCREEN_HEIGHT_PX + OAM_Y_OFS
    mov ecx, OAM_COUNT
.loop:
    mov [edi], al
    add edi, OBJ_SIZE
    dec ecx
    jnz .loop
    pop edi
    pop ecx
    pop eax
    ret
