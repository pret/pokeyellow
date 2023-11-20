	object_const_def
	const_export SUMMERBEACHHOUSE_SURFINDUDE
	const_export SUMMERBEACHHOUSE_PIKACHU
	const_export SUMMERBEACHHOUSE_POSTER1
	const_export SUMMERBEACHHOUSE_POSTER2
	const_export SUMMERBEACHHOUSE_POSTER3
	const_export SUMMERBEACHHOUSE_PRINTER

SummerBeachHouse_Object:
	db $a ; border block

	def_warp_events
	warp_event  2,  7, LAST_MAP, 1
	warp_event  3,  7, LAST_MAP, 1

	def_bg_events
	bg_event  3,  0, TEXT_SUMMERBEACHHOUSE_POSTER1
	bg_event  7,  0, TEXT_SUMMERBEACHHOUSE_POSTER2
	bg_event 11,  0, TEXT_SUMMERBEACHHOUSE_POSTER3
	bg_event 13,  1, TEXT_SUMMERBEACHHOUSE_PRINTER

	def_object_events
	object_event  2,  3, SPRITE_FISHING_GURU, STAY, DOWN, TEXT_SUMMERBEACHHOUSE_SURFINDUDE
	object_event  5,  3, SPRITE_PIKACHU, WALK, 1, TEXT_SUMMERBEACHHOUSE_PIKACHU

	def_warps_to SUMMER_BEACH_HOUSE
