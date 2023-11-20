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
	db $00
	db $1f
	db $1e
	db $38
	db $3f

OaksLabPikachuMovementData2:
	db $00
	db $1d
	db $20
	db $36
	db $3f
