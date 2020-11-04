BeachHouse_Object:
	db $a ; border block

	def_warps
	warp  2,  7, 0, LAST_MAP
	warp  3,  7, 0, LAST_MAP

	def_signs
	sign  3,  0, 3
	sign  7,  0, 4
	sign 11,  0, 5
	sign 13,  1, 6

	def_objects
	object SPRITE_FISHING_GURU, 2, 3, STAY, DOWN, 1 ; surfin' dude
	object SPRITE_PIKACHU, 5, 3, WALK, 1, 2 ; pikachu

	def_warps_to BEACH_HOUSE
