Func_f1f23:
	ld hl, PikachuMovementData_f1f2c
	ld b, SPRITE_FACING_DOWN
	call TryApplyPikachuMovementData
	ret

PikachuMovementData_f1f2c:
	db $00
	db $20
	db $1e
	db $35
	db $3f
