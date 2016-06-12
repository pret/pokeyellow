PokemonTower7Object:
	db $1 ; border block

	db $1 ; warps
	db $10, $9, $1, POKEMONTOWER_6

	db $0 ; signs

	db $3 ; objects
	object SPRITE_JESSIE, $a, $8, STAY, DOWN, $1
	object SPRITE_JAMES, $b, $8, STAY, DOWN, $2
	object SPRITE_MR_FUJI, $a, $3, STAY, DOWN, $3

	; warp-to
	EVENT_DISP POKEMONTOWER_7_WIDTH, $10, $9 ; POKEMONTOWER_6
