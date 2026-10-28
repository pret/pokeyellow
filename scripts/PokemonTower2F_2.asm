PokemonTower2FPikachuMovementScript::
	ld hl, PokemonTower2FPikachuMovement
	ld b, SPRITE_FACING_RIGHT
	call TryApplyPikachuMovementData
	ret

PokemonTower2FPikachuMovement:
	db PIKAMOVEMENT_DELAY
	db PIKAMOVEMENT_STEP_DOWN
	db PIKAMOVEMENT_STEP_LEFT
	db PIKAMOVEMENT_LOOK_RIGHT
	db PIKAMOVEMENT_END
