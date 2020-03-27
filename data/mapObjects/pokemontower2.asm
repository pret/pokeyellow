PokemonTower2Object:
	db $1 ; border block

	db 2 ; warps
	warp 3, 9, 0, POKEMONTOWER_3
	warp 18, 9, 2, POKEMONTOWER_1

	db 0 ; signs

	db 2 ; objects
	object SPRITE_BLUE, 14, 5, STAY, NONE, 1 ; person
	object SPRITE_MEDIUM, 3, 7, STAY, RIGHT, 2 ; person

	; warp-to
	warp_to 3, 9, POKEMONTOWER_2_WIDTH ; POKEMON_TOWER_3F
	warp_to 18, 9, POKEMONTOWER_2_WIDTH ; POKEMON_TOWER_1F
