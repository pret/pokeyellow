RedsHouse2F_Object:
	db $a ; border block

	def_warp_events
	warp_event  7,  1, REDS_HOUSE_1F, 2
IF DEF(_DEBUG)
	warp_event  7,  2, MT_MOON_B2F, 3
	warp_event  7,  3, ROCKET_HIDEOUT_ELEVATOR, 0
	warp_event  7,  4, POKEMON_TOWER_7F, 0
	warp_event  7,  5, SILPH_CO_11F, 3
ENDC

	def_bg_events

	def_object_events

	def_warps_to REDS_HOUSE_2F
