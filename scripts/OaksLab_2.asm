OaksLabPikachuMovementScript::
	ld a, [wYCoord]
	cp 3
	jr z, .movement2
	ld b, SPRITE_FACING_DOWN
	ld hl, OaksLabPikachuMovementData1
	call TryApplyPikachuMovementData
	ret

.movement2
	ld b, SPRITE_FACING_LEFT
	ld hl, OaksLabPikachuMovementData2
	call TryApplyPikachuMovementData
	ret

OaksLabPikachuMovementData1:
	db PIKAMOVEMENT_DELAY
	db PIKAMOVEMENT_STEP_LEFT
	db PIKAMOVEMENT_STEP_UP
	db PIKAMOVEMENT_LOOK_RIGHT
	db PIKAMOVEMENT_END

OaksLabPikachuMovementData2:
	db PIKAMOVEMENT_DELAY
	db PIKAMOVEMENT_STEP_DOWN
	db PIKAMOVEMENT_STEP_RIGHT
	db PIKAMOVEMENT_LOOK_UP
	db PIKAMOVEMENT_END
