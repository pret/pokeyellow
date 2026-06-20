%include "gb_memmap.inc"
%include "gb_macros.inc"

extern wEnemyMonStatus
extern wPlayerMoveType
extern hWhoseTurn
extern wBattleMonStatus
extern wEnemyMoveType
extern wMoveMissed
extern MoveHitTest
extern QuarterSpeedDueToParalysis
extern DelayFrames
extern PlayCurrentMoveAnimation
extern PrintMayNotAttackText
extern PrintDidntAffectText
extern PrintDoesntAffectText

ELECTRIC equ 23
GROUND equ 4
PAR equ 6

section .text
global ParalyzeEffect_

ParalyzeEffect_:
    mov esi, wEnemyMonStatus
    mov edi, wPlayerMoveType
    mov al, byte [ebp + hWhoseTurn]
    test al, al
    jz .next
    mov esi, wBattleMonStatus
    mov edi, wEnemyMoveType
.next:
    mov al, byte [ebp + esi]
    test al, al ; does the target already have a status ailment?
    jnz .didntAffect
; check if the target is immune due to types
    mov al, byte [ebp + edi]
    cmp al, ELECTRIC
    jnz .hitTest
    mov ebx, esi
    inc ebx
    mov al, byte [ebp + ebx]
    cmp al, GROUND
    jz .doesntAffect
    inc ebx
    mov al, byte [ebp + ebx]
    cmp al, GROUND
    jz .doesntAffect
.hitTest:
    push esi
    call MoveHitTest
    pop esi
    mov al, byte [ebp + wMoveMissed]
    test al, al
    jnz .didntAffect
    or byte [ebp + esi], 1 << PAR
    call QuarterSpeedDueToParalysis
    mov bl, 30
    call DelayFrames
    call PlayCurrentMoveAnimation
    jmp PrintMayNotAttackText
.didntAffect:
    mov bl, 50
    call DelayFrames
    jmp PrintDidntAffectText
.doesntAffect:
    mov bl, 50
    call DelayFrames
    jmp PrintDoesntAffectText
