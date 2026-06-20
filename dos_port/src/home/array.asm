; dos_port/home/array.asm
global SkipFixedLengthTextEntries
global AddNTimes

extern NAME_LENGTH

section .text

; skips AL (A) text entries, each of size NAME_LENGTH
; ESI (HL): base pointer, will be incremented by NAME_LENGTH * AL
SkipFixedLengthTextEntries:
    test al, al
    jz .done
    movzx eax, al
    mov ecx, NAME_LENGTH
    imul ecx, eax
    add esi, ecx
    xor al, al
    mov bx, NAME_LENGTH
.done:
    ret

; add BX (BC) to ESI (HL) AL (A) times
AddNTimes:
    test al, al
    jz .done2
    movzx eax, al
    movzx ecx, bx
    imul ecx, eax
    add esi, ecx
    xor al, al
.done2:
    ret
