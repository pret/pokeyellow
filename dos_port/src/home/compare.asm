; dos_port/home/compare.asm
global StringCmp

section .text

; Compare strings, BL (C) bytes in length, at DX (DE) and ESI (HL).
StringCmp:
.loop:
    movzx edx, dx
    mov al, [ebp + edx]
    cmp al, [ebp + esi]
    jnz .done
    
    inc dx
    inc esi
    
    dec bl
    jnz .loop
.done:
    ret
