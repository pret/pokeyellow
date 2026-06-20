; dos_port/src/items/itemfinder.asm

%include "gb_macros.inc"
%include "gb_memmap.inc"

section .text

global HiddenItemNear
global Sub5ClampTo0

extern IsInRestOfArray
extern FlagActionPredef
extern HiddenItemCoords

; -----------------------------------------------------------------------------
; HiddenItemNear
; Checks if there is a hidden item near the player's coordinates.
; Sets carry flag if an item is near, clears carry flag otherwise.
; -----------------------------------------------------------------------------
HiddenItemNear:
    lea esi, [HiddenItemCoords]
    mov bh, 0
.loop:
    mov dx, 3
    mov al, byte [ebp + W_CUR_MAP]
    call IsInRestOfArray
    jnc .done ; return if current map has no hidden items
    
    push bx
    push esi
    
    mov edi, W_OBTAINED_HIDDEN_ITEMS_FLAGS
    mov cl, bh
    mov bh, 1 ; FLAG_TEST is 1
    call FlagActionPredef
    mov ah, cl
    
    pop esi
    pop bx
    
    inc bh
    test ah, ah
    
    inc esi
    mov dh, byte [esi] ; d = [hl]
    inc esi
    mov dl, byte [esi] ; e = [hl]
    inc esi
    jnz .loop ; if item has already been obtained
    
    ; check if the item is within 4-5 tiles
    mov al, byte [ebp + W_Y_COORD]
    call Sub5ClampTo0
    cmp al, dh
    jnc .loop
    
    mov al, byte [ebp + W_Y_COORD]
    add al, 4
    cmp al, dh
    jc .loop
    
    mov al, byte [ebp + W_X_COORD]
    call Sub5ClampTo0
    cmp al, dl
    jnc .loop
    
    mov al, byte [ebp + W_X_COORD]
    add al, 5
    cmp al, dl
    jc .loop
    
    stc
    ret

.done:
    clc
    ret

; -----------------------------------------------------------------------------
; Sub5ClampTo0
; subtract 5 but clamp to 0
; -----------------------------------------------------------------------------
Sub5ClampTo0:
    sub al, 5
    cmp al, 0xF0
    jc .ret
    mov al, 0
.ret:
    ret
