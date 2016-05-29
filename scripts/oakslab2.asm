Func_f1be0:
	ld a, [wYCoord]
	cp 3
	jr z, .asm_f1bf0
	ld b, SPRITE_FACING_DOWN
	ld hl, Data_f1bf9
	call Func_f0a82
	ret

.asm_f1bf0
	ld b, SPRITE_FACING_LEFT
	ld hl, Data_f1bfe
	call Func_f0a82
	ret

Data_f1bf9:
	db $00
	db $1f
	db $1e
	db $38
	db $3f

Data_f1bfe:
	db $00
	db $1d
	db $20
	db $36
	db $3f
