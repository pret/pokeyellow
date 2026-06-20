; dos_port/engine/menus/text_box.asm
global SearchTextBoxTable
global GetTextBoxIDCoords
global GetAddressOfScreenCoords

extern wTileMap

section .text

; INPUT:
; ESI (HL) = address of table
; BL (C) = byte to search for
; DX (DE) = stride (increments of DE)
; OUTPUT:
; CF = 1 if match found, CF = 0 if not
SearchTextBoxTable:
    movzx edx, dx
    dec edx ; compensate for the fact that GB incs HL during read
.loop:
    mov al, [ebp + esi]
    inc esi ; corresponds to [hli]
    cmp al, 0xff
    jz .notFound
    cmp al, bl
    jz .found
    add esi, edx
    jmp .loop
.found:
    stc
    ret
.notFound:
    clc
    ret

; INPUT:
; ESI (HL) = address of coordinates
; OUTPUT:
; BH (B) = height
; BL (C) = width
; DH (D) = row
; DL (E) = column
GetTextBoxIDCoords:
    mov dl, [ebp + esi]
    inc esi
    
    mov dh, [ebp + esi]
    inc esi
    
    mov al, [ebp + esi]
    inc esi
    sub al, dl
    dec al
    mov bl, al
    
    mov al, [ebp + esi]
    inc esi
    sub al, dh
    dec al
    mov bh, al
    ret

; INPUT:
; DH (D) = row
; DL (E) = column
; OUTPUT:
; ESI (HL) = address of upper left corner of text box
GetAddressOfScreenCoords:
    ; O(1) 386 optimized calculation: wTileMap + row * 20 + col
    movzx eax, dh
    movzx ecx, dl
    imul eax, 20
    add eax, ecx
    
    mov esi, wTileMap
    add esi, eax
    
    xor dh, dh ; original GB code modifies D to 0 in the loop
    ret
