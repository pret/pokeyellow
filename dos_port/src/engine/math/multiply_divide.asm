; dos_port/engine/math/multiply_divide.asm
;
; _Multiply / _Divide — emulate the Game Boy 24-bit×8-bit multiply and the
; multi-byte ÷ 8-bit divide, preserving the exact HRAM scratch side-effects so
; callers (CalcStat, CalcExperience, damage calc, …) see identical results.
;
; Source: engine/math/multiply_divide.asm (pret/pokeyellow).
;
; HRAM map (gb_memmap.inc): H_PRODUCT=FF95(4) ; H_MULTIPLICAND=FF96(3) ;
; H_MULTIPLIER=FF99 ; H_DIVIDEND=FF95(4) ; H_DIVISOR=FF99 ; H_QUOTIENT=FF95(4) ;
; H_REMAINDER=FF99. (Quotient overlaps dividend; remainder overlaps divisor.)

%include "gb_macros.inc"
%include "gb_memmap.inc"

section .text

global _Multiply
global _Divide

; -----------------------------------------------------------------------------
; _Multiply — 24-bit multiplicand (H_MULTIPLICAND, big-endian) × 8-bit multiplier
; (H_MULTIPLIER) -> 32-bit product (H_PRODUCT, big-endian). Zeros H_MULTIPLIER,
; matching the GB loop's end state. Caller (wrapper) preserves esi/edx/bx.
; -----------------------------------------------------------------------------
_Multiply:
    movzx ecx, byte [ebp + H_MULTIPLIER]

    movzx eax, byte [ebp + H_MULTIPLICAND + 0]
    shl eax, 8
    mov al, byte [ebp + H_MULTIPLICAND + 1]
    shl eax, 8
    mov al, byte [ebp + H_MULTIPLICAND + 2]

    mul ecx                                  ; EDX:EAX = eax * ecx (fits in EAX)

    mov byte [ebp + H_PRODUCT + 3], al
    shr eax, 8
    mov byte [ebp + H_PRODUCT + 2], al
    shr eax, 8
    mov byte [ebp + H_PRODUCT + 1], al
    shr eax, 8
    mov byte [ebp + H_PRODUCT + 0], al

    mov byte [ebp + H_MULTIPLIER], 0
    ret

; -----------------------------------------------------------------------------
; _Divide — divide the BH-byte big-endian dividend at H_DIVIDEND by the 8-bit
; divisor at H_DIVISOR. Writes the 32-bit quotient big-endian to H_QUOTIENT and
; the remainder to H_REMAINDER. BH = dividend length in bytes (1..4).
;
; Rewritten from the original (broken) draft, which used the SM83 mnemonic `sbc`
; (invalid x86; the file never assembled) and an unverified byte-level emulation.
; This uses a single hardware divide with the same memory contract.
; -----------------------------------------------------------------------------
_Divide:
    push ebx
    push edx
    push edi

    movzx ecx, byte [ebp + H_DIVISOR]        ; divisor
    test ecx, ecx
    jz .done                                 ; guard divide-by-zero (GB would loop forever)

    movzx ebx, bh                            ; ebx = dividend length in bytes
    test ebx, ebx
    jz .done

    ; Assemble the big-endian dividend (first BH bytes of H_DIVIDEND) into EAX
    ; before any quotient store, since H_QUOTIENT overlaps H_DIVIDEND.
    xor eax, eax
    xor edi, edi
.assemble:
    shl eax, 8
    mov al, byte [ebp + H_DIVIDEND + edi]
    inc edi
    cmp edi, ebx
    jb .assemble

    xor edx, edx
    div ecx                                  ; EAX = quotient, EDX = remainder

    mov byte [ebp + H_QUOTIENT + 3], al
    shr eax, 8
    mov byte [ebp + H_QUOTIENT + 2], al
    shr eax, 8
    mov byte [ebp + H_QUOTIENT + 1], al
    shr eax, 8
    mov byte [ebp + H_QUOTIENT + 0], al

    mov byte [ebp + H_REMAINDER], dl
.done:
    pop edi
    pop edx
    pop ebx
    ret
