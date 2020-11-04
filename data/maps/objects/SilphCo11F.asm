SilphCo11F_Object:
	db $d ; border block

	def_warps
	warp  9,  0, 1, SILPH_CO_10F
	warp 13,  0, 0, SILPH_CO_ELEVATOR
	warp  5,  5, 9, LAST_MAP
	warp  3,  2, 3, SILPH_CO_7F

	def_signs

	def_objects
	object SPRITE_SILPH_PRESIDENT, 7, 5, STAY, DOWN, 1 ; person
	object SPRITE_BEAUTY, 10, 5, STAY, DOWN, 2 ; person
	object SPRITE_GIOVANNI, 6, 9, STAY, DOWN, 3, OPP_GIOVANNI, 2
	object SPRITE_JAMES, 2, 8, STAY, UP, 4
	object SPRITE_ROCKET, 15, 9, STAY, UP, 5, OPP_ROCKET, 40
	object SPRITE_JESSIE, 3, 8, STAY, UP, 6

	def_warps_to SILPH_CO_11F
