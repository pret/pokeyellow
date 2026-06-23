%include "gb_memmap.inc"
%include "gb_macros.inc"

extern wPlayerMonAttackMod
extern wEnemyMonAttackMod
extern wPlayerMonUnmodifiedAttack
extern wBattleMonAttack
extern wEnemyMonUnmodifiedAttack
extern wEnemyMonAttack
extern wEnemyMonStatus
extern wEnemySelectedMove
extern hWhoseTurn
extern wBattleMonStatus
extern wPlayerSelectedMove
extern wPlayerDisabledMove
extern wEnemyDisabledMove
extern wPlayerDisabledMoveNumber
extern wPlayerBattleStatus1
extern wEnemyBattleStatus1
extern PlayCurrentMoveAnimation
extern CallBankF
extern PrintText
extern _StatusChangesEliminatedText

CONFUSED equ 7
USING_X_ACCURACY equ 0
PROTECTED_BY_MIST equ 1
GETTING_PUMPED equ 2
TRANSFORMED equ 3
SEEDED equ 7

NUM_STAT_MODS equ 8
NUM_STATS equ 5

FRZ equ 5
SLP_MASK equ 7

section .text
global HazeEffect_
global CureVolatileStatuses
global ResetStatMods

HazeEffect_:
    mov al, 7
    ; store 7 on every stat mod
    mov esi, wPlayerMonAttackMod
    call ResetStatMods
    mov esi, wEnemyMonAttackMod
    call ResetStatMods
    ; copy unmodified stats to battle stats
    mov esi, wPlayerMonUnmodifiedAttack
    mov edx, wBattleMonAttack
    call ResetStats
    mov esi, wEnemyMonUnmodifiedAttack
    mov edx, wEnemyMonAttack
    call ResetStats
    ; cure non-volatile status, but only for the target
    mov esi, wEnemyMonStatus
    mov edx, wEnemySelectedMove
    mov al, byte [ebp + hWhoseTurn]
    and al, al
    jz .cureStatuses
    mov esi, wBattleMonStatus
    dec edx ; wPlayerSelectedMove

.cureStatuses:
    mov al, byte [ebp + esi]
    mov byte [ebp + esi], 0
    and al, (1 << FRZ) | SLP_MASK
    jz .cureVolatileStatuses
    ; prevent the Pokemon from executing a move if it was asleep or frozen
    mov byte [ebp + edx], 0xff

.cureVolatileStatuses:
    xor al, al
    mov byte [ebp + wPlayerDisabledMove], al
    mov byte [ebp + wEnemyDisabledMove], al
    mov esi, wPlayerDisabledMoveNumber
    mov byte [ebp + esi], al
    inc esi
    mov byte [ebp + esi], al
    mov esi, wPlayerBattleStatus1
    call CureVolatileStatuses
    mov esi, wEnemyBattleStatus1
    call CureVolatileStatuses
    mov esi, PlayCurrentMoveAnimation
    call CallBankF
    mov esi, StatusChangesEliminatedText
    jmp PrintText

CureVolatileStatuses:
    ; res CONFUSED, [hl]
    and byte [ebp + esi], ~((1 << 7)) & 0xFF ; CONFUSED = 7

    ; inc hl ; BATTSTATUS2
    inc esi

    ; ld a, [hl]
    mov al, [ebp + esi]

    ; clear USING_X_ACCURACY, PROTECTED_BY_MIST, GETTING_PUMPED, and SEEDED statuses
    ; and ~((1 << USING_X_ACCURACY) | (1 << PROTECTED_BY_MIST) | (1 << GETTING_PUMPED) | (1 << SEEDED))
    and al, ~((1 << 0) | (1 << 1) | (1 << 2) | (1 << 7)) & 0xFF

    ; ld [hli], a ; BATTSTATUS3
    mov [ebp + esi], al
    inc esi

    ; ld a, [hl]
    mov al, [ebp + esi]

    ; and %11110000 | (1 << TRANSFORMED) ; clear Bad Poison, Reflect and Light Screen statuses
    and al, 11110000b | (1 << 3) ; TRANSFORMED = 3

    ; ld [hl], a
    mov [ebp + esi], al

    ; ret
    ret

ResetStatMods:
    mov bh, NUM_STAT_MODS
.loop:
    mov byte [ebp + esi], al
    inc esi
    dec bh
    jnz .loop
    ret

ResetStats:
    mov bh, (NUM_STATS - 1) * 2 ; doesn't reset STAT_HEALTH
.loop:
    mov al, byte [ebp + esi]
    inc esi
    mov byte [ebp + edx], al
    inc edx
    dec bh
    jnz .loop
    ret

StatusChangesEliminatedText:
    db 0x0A ; TX_PAUSE
    db 0x17 ; TX_FAR
    dd _StatusChangesEliminatedText
    db 0x50 ; TX_END
