PokemonTower2FPikachuMovementScript::
	ld hl, PokemonTower2FPikachuMovement
	ld b, SPRITE_FACING_RIGHT
	call TryApplyPikachuMovementData
	ret

PokemonTower2FPikachuMovement:
	db $00
	db $1d
	db $1f
	db $38
	db $3f
