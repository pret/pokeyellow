%include "gb_memmap.inc"

section .text

; ---------------------------------------------------------------------------
; CallBankF — stub: in the GB this bankswitches to bank F for PrintButItFailed.
; In the DOS port there are no banks; just call through.
; ---------------------------------------------------------------------------
extern Bankswitch
extern BANK_PrintButItFailedText_

CallBankF:
    push eax
    mov eax, BANK_PrintButItFailedText_
    mov bh, al
    pop eax
    jmp Bankswitch

; ---------------------------------------------------------------------------
; ConversionEffect_
; ---------------------------------------------------------------------------
global ConversionEffect_

extern wEnemyMonType1
extern wBattleMonType1
extern hWhoseTurn
extern wEnemyBattleStatus1
extern wPlayerBattleStatus1
extern PlayCurrentMoveAnimation
extern PrintText
extern PrintButItFailedText_

INVULNERABLE equ 6

ConversionEffect_:
    mov esi, wEnemyMonType1
    mov edx, wBattleMonType1
    mov al, [ebp + hWhoseTurn]
    test al, al
    mov al, [ebp + wEnemyBattleStatus1]
    jz .conversionEffect

    xchg esi, edx
    mov al, [ebp + wPlayerBattleStatus1]

.conversionEffect:
    bt ax, INVULNERABLE
    jc PrintButItFailedText

    mov al, [ebp + esi]
    inc esi
    mov [ebp + edx], al
    inc edx
    mov al, [ebp + esi]
    mov [ebp + edx], al

    call PlayCurrentMoveAnimation
    mov esi, ConvertedTypeText
    jmp PrintText

ConvertedTypeText:
    db 0x17
    dw 0
    db 0
    db 0x50

PrintButItFailedText:
    jmp PrintButItFailedText_
