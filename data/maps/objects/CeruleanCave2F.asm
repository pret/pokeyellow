CeruleanCave2F_Object:
	db $7d ; border block

	def_warps
	warp 29,  1, 2, CERULEAN_CAVE_1F
	warp 22,  6, 3, CERULEAN_CAVE_1F
	warp 19,  7, 4, CERULEAN_CAVE_1F
	warp  9,  1, 5, CERULEAN_CAVE_1F
	warp  1,  3, 6, CERULEAN_CAVE_1F
	warp  3, 11, 7, CERULEAN_CAVE_1F

	def_signs

	def_objects
	object SPRITE_POKE_BALL, 0, 11, STAY, NONE, 1, RARE_CANDY
	object SPRITE_POKE_BALL, 16, 7, STAY, NONE, 2, ULTRA_BALL
	object SPRITE_POKE_BALL, 19, 11, STAY, NONE, 3, MAX_REVIVE
	object SPRITE_POKE_BALL, 27, 9, STAY, NONE, 4, FULL_RESTORE

	def_warps_to CERULEAN_CAVE_2F
