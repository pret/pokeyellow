; dos_port/src/pokemon/experience.asm

%include "gb_macros.inc"
%include "gb_memmap.inc"

section .text

global CalcLevelFromExperience
global CalcExperience
global CalcDSquared

extern GetMonHeader
extern Multiply
extern Divide

; -----------------------------------------------------------------------------
; CalcLevelFromExperience
;
; Calculates the level a mon should be based on its current exp.
; -----------------------------------------------------------------------------
CalcLevelFromExperience:
    ; W_LOADED_MON_SPECIES -> W_CUR_SPECIES
    mov al, byte [ebp + W_LOADED_MON_SPECIES]
    mov byte [ebp + W_CUR_SPECIES], al
    call GetMonHeader
    
    mov dh, 1 ; dh = level (d in GB)

.loop:
    inc dh
    call CalcExperience
    
    ; compare exp needed for level (H_EXPERIENCE) with current exp (W_LOADED_MON_EXP)
    ; H_EXPERIENCE is 3 bytes big-endian.
    ; W_LOADED_MON_EXP is 3 bytes big-endian.
    ; We can do a 24-bit compare.
    ; Wait, we can just load them into 32-bit registers!
    movzx eax, byte [ebp + H_EXPERIENCE + 0]
    shl eax, 8
    mov al, byte [ebp + H_EXPERIENCE + 1]
    shl eax, 8
    mov al, byte [ebp + H_EXPERIENCE + 2]
    
    movzx ecx, byte [ebp + W_LOADED_MON_EXP + 0]
    shl ecx, 8
    mov cl, byte [ebp + W_LOADED_MON_EXP + 1]
    shl ecx, 8
    mov cl, byte [ebp + W_LOADED_MON_EXP + 2]
    
    cmp ecx, eax
    jnc .loop ; if current exp >= needed exp, try next level

    dec dh ; go back to previous level
    ret

; -----------------------------------------------------------------------------
; CalcExperience
;
; Calculates the amount of experience needed for level in DH.
; -----------------------------------------------------------------------------
CalcExperience:
    mov al, byte [ebp + W_MON_H_GROWTH_RATE]
    shl al, 2
    mov cl, al ; c = wMonHGrowthRate * 4
    
    ; hl = GrowthRateTable + c
    extern GrowthRateTable
    lea esi, [GrowthRateTable]
    movzx ecx, cl
    add esi, ecx

    call CalcDSquared
    
    mov al, dh
    mov byte [ebp + H_MULTIPLIER], al
    call Multiply
    
    mov al, byte [ebp + esi]
    and al, 0xF0
    shr al, 4
    mov byte [ebp + H_MULTIPLIER], al
    call Multiply
    
    inc esi
    mov al, byte [ebp + esi]
    and al, 0x0F
    mov byte [ebp + H_DIVISOR], al
    mov bh, 4
    call Divide
    
    ; push hQuotient 1, 2, 3
    mov al, byte [ebp + H_QUOTIENT + 1]
    push ax
    mov al, byte [ebp + H_QUOTIENT + 2]
    push ax
    mov al, byte [ebp + H_QUOTIENT + 3]
    push ax
    
    call CalcDSquared
    
    mov al, byte [ebp + esi]
    and al, 0x7F
    mov byte [ebp + H_MULTIPLIER], al
    call Multiply
    
    ; push hProduct 1, 2, 3
    mov al, byte [ebp + H_PRODUCT + 1]
    push ax
    mov al, byte [ebp + H_PRODUCT + 2]
    push ax
    mov al, byte [ebp + H_PRODUCT + 3]
    push ax
    
    inc esi
    mov al, byte [ebp + esi]
    push ax
    
    mov byte [ebp + H_MULTIPLICAND], 0
    mov byte [ebp + H_MULTIPLICAND + 1], 0
    mov al, dh
    mov byte [ebp + H_MULTIPLICAND + 2], al
    
    inc esi
    mov al, byte [ebp + esi]
    mov byte [ebp + H_MULTIPLIER], al
    call Multiply
    
    mov bl, byte [ebp + esi]
    mov al, byte [ebp + H_PRODUCT + 3]
    sub al, bl
    mov byte [ebp + H_PRODUCT + 3], al
    
    mov bl, 0
    mov al, byte [ebp + H_PRODUCT + 2]
    sbb al, bl
    mov byte [ebp + H_PRODUCT + 2], al
    
    mov al, byte [ebp + H_PRODUCT + 1]
    sbb al, bl
    mov byte [ebp + H_PRODUCT + 1], al
    
    pop ax
    test al, 0x80
    jnz .subtractSquaredTerm
    
    pop bx ; b = product 3
    mov al, byte [ebp + H_EXPERIENCE + 2]
    add al, bl
    mov byte [ebp + H_EXPERIENCE + 2], al
    
    pop bx ; b = product 2
    mov al, byte [ebp + H_EXPERIENCE + 1]
    adc al, bl
    mov byte [ebp + H_EXPERIENCE + 1], al
    
    pop bx ; b = product 1
    mov al, byte [ebp + H_EXPERIENCE]
    adc al, bl
    mov byte [ebp + H_EXPERIENCE], al
    jmp .addCubedTerm

.subtractSquaredTerm:
    pop bx
    mov al, byte [ebp + H_EXPERIENCE + 2]
    sub al, bl
    mov byte [ebp + H_EXPERIENCE + 2], al
    
    pop bx
    mov al, byte [ebp + H_EXPERIENCE + 1]
    sbb al, bl
    mov byte [ebp + H_EXPERIENCE + 1], al
    
    pop bx
    mov al, byte [ebp + H_EXPERIENCE]
    sbb al, bl
    mov byte [ebp + H_EXPERIENCE], al

.addCubedTerm:
    pop bx
    mov al, byte [ebp + H_EXPERIENCE + 2]
    add al, bl
    mov byte [ebp + H_EXPERIENCE + 2], al
    
    pop bx
    mov al, byte [ebp + H_EXPERIENCE + 1]
    adc al, bl
    mov byte [ebp + H_EXPERIENCE + 1], al
    
    pop bx
    mov al, byte [ebp + H_EXPERIENCE]
    adc al, bl
    mov byte [ebp + H_EXPERIENCE], al
    ret

; -----------------------------------------------------------------------------
; CalcDSquared
;
; Calculates d*d (DH * DH).
; -----------------------------------------------------------------------------
CalcDSquared:
    mov byte [ebp + H_MULTIPLICAND], 0
    mov byte [ebp + H_MULTIPLICAND + 1], 0
    mov al, dh
    mov byte [ebp + H_MULTIPLICAND + 2], al
    mov byte [ebp + H_MULTIPLIER], al
    jmp Multiply
