Func_f1e22::
	ld hl, PikachuMovementData_f1e2b
	ld b, SPRITE_FACING_RIGHT
	call TryApplyPikachuMovementData
	ret

PikachuMovementData_f1e2b:
	db $00
	db $1d
	db $1f
	db $38
	db $3f
