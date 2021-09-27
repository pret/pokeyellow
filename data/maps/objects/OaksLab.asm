OaksLab_Object:
	db $3 ; border block

	def_warp_events
	warp_event  4, 11, LAST_MAP, 2
	warp_event  5, 11, LAST_MAP, 2

	def_bg_events

	def_object_events
	object_event  4,  3, SPRITE_BLUE, STAY, NONE, 1, OPP_RIVAL1, 1
	object_event  7,  3, SPRITE_POKE_BALL, STAY, NONE, 2 ; person
	object_event  5,  2, SPRITE_OAK, STAY, DOWN, 3 ; person
	object_event  2,  1, SPRITE_POKEDEX, STAY, NONE, 4 ; person
	object_event  3,  1, SPRITE_POKEDEX, STAY, NONE, 5 ; person
	object_event  5, 10, SPRITE_OAK, STAY, UP, 6 ; person
	object_event  1,  9, SPRITE_GIRL, WALK, UP_DOWN, 7 ; person
	object_event  2, 10, SPRITE_SCIENTIST, STAY, NONE, 8 ; person
	object_event  8, 10, SPRITE_SCIENTIST, STAY, NONE, 9 ; person

	def_warps_to OAKS_LAB
