%include "include/gb_memmap.inc"

SECTION .text

global CalcExpToLevelUp

extern CalcExperience
extern wLoadedMonLevel
extern MAX_LEVEL

CalcExpToLevelUp:
    ; ld a, [wLoadedMonLevel]
    mov al, [ebp + wLoadedMonLevel]

    ; cp MAX_LEVEL
    cmp al, MAX_LEVEL
    
    ; jr z, .atMaxLevel
    jz .atMaxLevel

    ; inc a
    inc al

    ; ld d, a
    mov dh, al

    ; callfar CalcExperience
    call CalcExperience

    ; ld hl, wLoadedMonExp + 2
    mov esi, W_LOADED_MON_EXP + 2

    ; ldh a, [hExperience + 2]
    mov al, [ebp + H_EXPERIENCE + 2]

    ; sub [hl]
    sub al, [ebp + esi]

    ; ld [hld], a
    mov [ebp + esi], al
    dec esi

    ; ldh a, [hExperience + 1]
    mov al, [ebp + H_EXPERIENCE + 1]

    ; sbb [hl]
    sbb al, [ebp + esi]

    ; ld [hld], a
    mov [ebp + esi], al
    dec esi

    ; ldh a, [hExperience]
    mov al, [ebp + H_EXPERIENCE]

    ; sbb [hl]
    sbb al, [ebp + esi]

    ; ld [hld], a
    mov [ebp + esi], al
    dec esi

    ret

.atMaxLevel:
    ; ld hl, wLoadedMonExp
    mov esi, W_LOADED_MON_EXP

    ; xor a
    xor al, al

    ; ld [hli], a
    mov [ebp + esi], al
    inc esi

    ; ld [hli], a
    mov [ebp + esi], al
    inc esi

    ; ld [hl], a
    mov [ebp + esi], al

    ret
