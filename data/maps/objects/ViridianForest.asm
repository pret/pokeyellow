ViridianForest_Object:
	db $3 ; border block

	def_warps
	warp  1,  0, 2, VIRIDIAN_FOREST_NORTH_GATE
	warp  2,  0, 2, VIRIDIAN_FOREST_NORTH_GATE
	warp 15, 47, 1, VIRIDIAN_FOREST_SOUTH_GATE
	warp 16, 47, 1, VIRIDIAN_FOREST_SOUTH_GATE
	warp 17, 47, 1, VIRIDIAN_FOREST_SOUTH_GATE
	warp 18, 47, 1, VIRIDIAN_FOREST_SOUTH_GATE

	def_signs
	sign 24, 40, 11 ; ViridianForestText9
	sign 16, 32, 12 ; ViridianForestText10
	sign 26, 17, 13 ; ViridianForestText11
	sign  4, 24, 14 ; ViridianForestText12
	sign 18, 45, 15 ; ViridianForestText13
	sign  2,  1, 16 ; ViridianForestText14

	def_objects
	object SPRITE_YOUNGSTER, 16, 43, STAY, NONE, 1 ; person
	object SPRITE_YOUNGSTER, 30, 33, STAY, LEFT, 2, OPP_BUG_CATCHER, 1
	object SPRITE_YOUNGSTER, 30, 19, STAY, LEFT, 3, OPP_BUG_CATCHER, 2
	object SPRITE_YOUNGSTER, 2, 18, STAY, LEFT, 4, OPP_BUG_CATCHER, 3
	object SPRITE_COOLTRAINER_F, 2, 41, STAY, NONE, 5, OPP_LASS, 19
	object SPRITE_YOUNGSTER, 13, 17, STAY, RIGHT, 6, OPP_BUG_CATCHER, 15
	object SPRITE_POKE_BALL, 25, 11, STAY, NONE, 7, POTION
	object SPRITE_POKE_BALL, 12, 29, STAY, NONE, 8, POTION
	object SPRITE_POKE_BALL, 1, 31, STAY, NONE, 9, POKE_BALL
	object SPRITE_YOUNGSTER, 27, 40, STAY, NONE, 10 ; person

	def_warps_to VIRIDIAN_FOREST
