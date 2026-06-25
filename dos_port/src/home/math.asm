; dos_port/home/math.asm
global Multiply
global Divide

extern _Multiply
extern _Divide

section .text

; FF96-FF98 = multiplicand
; FF99 = multiplier
; FF95-FF98 = product
Multiply:
    push esi
    push edx                 ; GB _Multiply preserves de; our _Multiply clobbers
    push bx                  ; edx via `mul ecx`, so save it (CalcStat keeps the
    call _Multiply           ; base stat in e/dl across the stat-exp multiply loop).
    pop bx
    pop edx
    pop esi
    ret

; FF95-FF98 = dividend
; FF99 = divisor
; b = number of bytes in the dividend
; FF95-FF98 = quotient
; FF99 = remainder
Divide:
    push esi
    push dx
    push bx
    call _Divide
    pop bx
    pop dx
    pop esi
    ret
