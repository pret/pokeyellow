RedsHouse2F_Object:
	db $a ; border block

	def_warps
	warp  7,  1, 2, REDS_HOUSE_1F
IF DEF(_DEBUG)
	warp  7,  2, 3, MT_MOON_B2F
	warp  7,  3, 0, ROCKET_HIDEOUT_ELEVATOR
	warp  7,  4, 0, POKEMON_TOWER_7F
	warp  7,  5, 3, SILPH_CO_11F
ENDC

	def_signs

	def_objects

	def_warps_to REDS_HOUSE_2F
