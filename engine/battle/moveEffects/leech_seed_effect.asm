LeechSeedEffect_: ; 2bdba (a:7dba)
	callab MoveHitTest
	ld a, [wMoveMissed]
	and a
	jr nz, .moveMissed
	ld hl, wEnemyBattleStatus2
	ld de, wEnemyMonType1
	ld a, [H_WHOSETURN]
	and a
	jr z, .leechSeedEffect
	ld hl, wPlayerBattleStatus2
	ld de, wBattleMonType1
.leechSeedEffect
; miss if the target is grass-type or already seeded
	ld a, [de]
	cp GRASS
	jr z, .moveMissed
	inc de
	ld a, [de]
	cp GRASS
	jr z, .moveMissed
	bit Seeded, [hl]
	jr nz, .moveMissed
	set Seeded, [hl]
	callab PlayCurrentMoveAnimation
	ld hl, WasSeededText
	jp PrintText
.moveMissed
	ld c, 50
	call DelayFrames
	ld hl, EvadedAttackText
	jp PrintText

WasSeededText: ; 2be03 (a:7e03)
	TX_FAR _WasSeededText
	db "@"

EvadedAttackText: ; 2be08 (a:7e08)
	TX_FAR _EvadedAttackText
	db "@"
