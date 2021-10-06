SummerBeachHouse_Object:
	db $a ; border block

	def_warp_events
	warp_event  2,  7, LAST_MAP, 1
	warp_event  3,  7, LAST_MAP, 1

	def_bg_events
	bg_event  3,  0, 3 ; SummerBeachHouseSign1Text
	bg_event  7,  0, 4 ; SummerBeachHouseSign2Text
	bg_event 11,  0, 5 ; SummerBeachHouseSign3Text
	bg_event 13,  1, 6 ; SummerBeachHouseSign4Text

	def_object_events
	object_event  2,  3, SPRITE_FISHING_GURU, STAY, DOWN, 1 ; person
	object_event  5,  3, SPRITE_PIKACHU, WALK, 1, 2 ; person

	def_warps_to SUMMER_BEACH_HOUSE
