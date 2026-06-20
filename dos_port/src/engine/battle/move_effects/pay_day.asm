%include "gb_memmap.inc"
%include "gb_macros.inc"

extern Divide
extern AddBCDPredef
extern PrintText
extern wPayDayMoney
extern hWhoseTurn
extern wBattleMonLevel
extern wEnemyMonLevel
extern hDividend
extern hDivisor
extern hQuotient
extern hRemainder
extern wTotalPayDayMoney
extern _CoinsScatteredText

section .text
global PayDayEffect_
global CoinsScatteredText

PayDayEffect_:
    xor al, al
    mov esi, wPayDayMoney
    mov [ebp + esi], al
    inc esi

    mov al, [ebp + hWhoseTurn]
    test al, al
    mov al, [ebp + wBattleMonLevel]
    jz .payDayEffect
    mov al, [ebp + wEnemyMonLevel]
.payDayEffect:
    ; level * 2
    add al, al
    mov [ebp + hDividend + 3], al
    xor al, al
    mov [ebp + hDividend], al
    mov [ebp + hDividend + 1], al
    mov [ebp + hDividend + 2], al

    ; convert to BCD
    mov al, 100
    mov [ebp + hDivisor], al
    mov ebx, 4
    call Divide
    mov al, [ebp + hQuotient + 3]
    mov [ebp + esi], al ; wPayDayMoney + 1
    inc esi

    mov al, [ebp + hRemainder]
    mov [ebp + hDividend + 3], al
    mov al, 10
    mov [ebp + hDivisor], al
    mov ebx, 4
    call Divide
    mov al, [ebp + hQuotient + 3]
    
    ; swap a
    rol al, 4
    ; ld b, a
    mov bl, al
    ; ldh a, [hRemainder]
    mov al, [ebp + hRemainder]
    ; add b
    add al, bl
    ; ld [hl], a ; wPayDayMoney + 2
    mov [ebp + esi], al

    ; ld de, wTotalPayDayMoney + 2
    mov edi, wTotalPayDayMoney + 2
    ; ld c, $3
    mov ebx, 3
    ; predef AddBCDPredef
    call AddBCDPredef
    
    ; ld hl, CoinsScatteredText
    mov esi, CoinsScatteredText
    ; jp PrintText
    jmp PrintText

CoinsScatteredText:
    db 0x0A ; TX_PAUSE
    db 0x17 ; TX_FAR
    dd _CoinsScatteredText
    db 0x50 ; TX_END
