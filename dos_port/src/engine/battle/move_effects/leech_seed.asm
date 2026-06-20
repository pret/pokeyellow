%include "gb_memmap.inc"
%include "gb_macros.inc"

extern MoveHitTest
extern PlayCurrentMoveAnimation
extern DelayFrames
extern PrintText
extern wMoveMissed
extern wEnemyBattleStatus2
extern wEnemyMonType1
extern hWhoseTurn
extern wPlayerBattleStatus2
extern wBattleMonType1
extern _WasSeededText
extern _EvadedAttackText

section .text
global LeechSeedEffect_
global WasSeededText
global EvadedAttackText

LeechSeedEffect_:
	call MoveHitTest
	mov al, [ebp + wMoveMissed]
	test al, al
	jnz .moveMissed
	mov esi, wEnemyBattleStatus2
	mov edi, wEnemyMonType1
	mov al, [ebp + hWhoseTurn]
	test al, al
	jz .leechSeedEffect
	mov esi, wPlayerBattleStatus2
	mov edi, wBattleMonType1
.leechSeedEffect:
; miss if the target is grass-type or already seeded
	mov al, [ebp + edi]
	cmp al, 22 ; GRASS
	jz .moveMissed
	inc edi
	mov al, [ebp + edi]
	cmp al, 22 ; GRASS
	jz .moveMissed
	test byte [ebp + esi], 1 << 7 ; SEEDED is bit 7
	jnz .moveMissed
	or byte [ebp + esi], 1 << 7
	call PlayCurrentMoveAnimation
	mov esi, WasSeededText
	jmp PrintText
.moveMissed:
	mov cl, 50
	call DelayFrames
	mov esi, EvadedAttackText
	jmp PrintText

WasSeededText:
    db 0x0A ; TX_PAUSE
    db 0x17 ; TX_FAR
    dd _WasSeededText
    db 0x50 ; TX_END

EvadedAttackText:
    db 0x0A ; TX_PAUSE
    db 0x17 ; TX_FAR
    dd _EvadedAttackText
    db 0x50 ; TX_END
