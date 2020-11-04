PokemonTower7F_Object:
	db $1 ; border block

	def_warps
	warp  9, 16, 1, POKEMON_TOWER_6F

	def_signs

	def_objects
	object SPRITE_JESSIE, 10, 8, STAY, DOWN, 1
	object SPRITE_JAMES, 11, 8, STAY, DOWN, 2
	object SPRITE_MR_FUJI, 10, 3, STAY, DOWN, 3

	def_warps_to POKEMON_TOWER_7F
