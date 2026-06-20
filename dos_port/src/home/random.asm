; dos_port/home/random.asm
global Random

extern Random_
extern hRandomAdd

section .text

; Return a random number in AL.
Random:
    push esi
    push dx
    push bx
    
    call Random_
    
    mov al, [ebp + hRandomAdd]
    
    pop bx
    pop dx
    pop esi
    ret
