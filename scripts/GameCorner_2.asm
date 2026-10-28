GameCornerPikachuMovementScript::
	ld hl, GameCornerPikachuMovementData
	ld b, SPRITE_FACING_DOWN
	call TryApplyPikachuMovementData
	ret

GameCornerPikachuMovementData:
	db PIKAMOVEMENT_DELAY
	db PIKAMOVEMENT_STEP_RIGHT
	db PIKAMOVEMENT_STEP_UP
	db PIKAMOVEMENT_LOOK_DOWN
	db PIKAMOVEMENT_END
