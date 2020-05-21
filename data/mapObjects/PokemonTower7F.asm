PokemonTower7F_Object:
	db $1 ; border block

	db 1 ; warps
	warp 9, 16, 1, POKEMON_TOWER_6F

	db 0 ; signs

	db 3 ; objects
	object SPRITE_JESSIE, 10, 8, STAY, DOWN, 1
	object SPRITE_JAMES, 11, 8, STAY, DOWN, 2
	object SPRITE_MR_FUJI, 10, 3, STAY, DOWN, 3

	; warp-to
	warp_to 9, 16, POKEMON_TOWER_7F_WIDTH ; POKEMON_TOWER_6F
