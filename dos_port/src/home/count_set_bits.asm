; dos_port/home/count_set_bits.asm
global CountSetBits

extern wNumSetBits

section .text

; INPUT:
; ESI (HL) = address of string of bytes
; BH (B) = length of string of bytes
; OUTPUT:
; [EBP + wNumSetBits] = number of set bits
CountSetBits:
    xor bl, bl

.loop:
    mov al, [ebp + esi]
    inc esi
    
    mov dl, al
    mov dh, 8

.innerLoop:
    shr dl, 1
    adc bl, 0
    dec dh
    jnz .innerLoop
    
    dec bh
    jnz .loop
    
    mov al, bl
    mov [ebp + wNumSetBits], al
    ret
