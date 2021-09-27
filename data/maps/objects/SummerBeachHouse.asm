SummerBeachHouse_Object:
	db $a ; border block

	def_warp_events
	warp_event  2,  7, LAST_MAP, 0
	warp_event  3,  7, LAST_MAP, 0

	def_bg_events
	bg_event  3,  0, 3
	bg_event  7,  0, 4
	bg_event 11,  0, 5
	bg_event 13,  1, 6

	def_object_events
	object_event 2, 3, SPRITE_FISHING_GURU, STAY, DOWN, 1 ; surfin' dude
	object_event 5, 3, SPRITE_PIKACHU, WALK, 1, 2 ; pikachu

	def_warps_to SUMMER_BEACH_HOUSE
