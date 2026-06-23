%include "gb_memmap.inc"
%include "gb_macros.inc"
%include "gb_text.inc"

GRASS equ 22
SEEDED equ 7

extern MoveHitTest
extern PlayCurrentMoveAnimation
extern PrintText
extern DelayFrames
extern _WasSeededText
extern _EvadedAttackText

extern wMoveMissed
extern wEnemyBattleStatus2
extern wEnemyMonType1
extern hWhoseTurn
extern wPlayerBattleStatus2
extern wBattleMonType1

global LeechSeedEffect_

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
	cmp al, GRASS
	jz .moveMissed
	inc edi
	mov al, [ebp + edi]
	cmp al, GRASS
	jz .moveMissed
	test byte [ebp + esi], 1 << SEEDED
	jnz .moveMissed
	or byte [ebp + esi], 1 << SEEDED
	call PlayCurrentMoveAnimation
	mov esi, WasSeededText
	jmp PrintText
.moveMissed:
	mov cl, 50
	call DelayFrames
	mov esi, EvadedAttackText
	jmp PrintText

WasSeededText:
	text_far _WasSeededText
	text_end

EvadedAttackText:
	text_far _EvadedAttackText
	text_end
