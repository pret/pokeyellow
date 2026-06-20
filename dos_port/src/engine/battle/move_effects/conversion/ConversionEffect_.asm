; ╔══════════════════════════════════════════════════════════╗
; ║              PKMNDOS TRANSLATION MANIFEST               ║
; ╚══════════════════════════════════════════════════════════╝
; queue_id   : 1832
; label      : ConversionEffect_
; source     : engine/battle/move_effects/conversion.asm
; category   : simple
; scratch    : dos_port/scratch/1832__ConversionEffect_.asm
; -----------------------------------------------------------
; target      : dos_port/src/engine/battle/move_effects/conversion/ConversionEffect_.asm
; aggregator  : dos_port/src/engine/battle/move_effects/conversion.asm
; -----------------------------------------------------------
; WORKER NOTES — fill in before calling work_queue complete
; registers   : HL→ESI, DE→EDX, A→AL
; hflag       : not involved
; bug_tags    : none
; notes       : removed Bankswitch logic, evaluated INVULNERABLE to 6
; ╔══════════════════════════════════════════════════════════╗
; ║  CODE BELOW — do not modify the header above            ║
; ╚══════════════════════════════════════════════════════════╝

%include "gb_memmap.inc"

SECTION .text

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
    
    ; copy target's types to user
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
    ret

PrintButItFailedText:
    jmp PrintButItFailedText_
