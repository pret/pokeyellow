GameCornerPikachuMovementScript::
	ld hl, GameCornerPikachuMovementData
	ld b, SPRITE_FACING_DOWN
	call TryApplyPikachuMovementData
	ret

GameCornerPikachuMovementData:
	db $00
	db $20
	db $1e
	db $35
	db $3f
