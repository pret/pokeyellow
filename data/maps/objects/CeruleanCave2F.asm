CeruleanCave2F_Object:
	db $7d ; border block

	def_warp_events
	warp_event 29,  1, CERULEAN_CAVE_1F, 3
	warp_event 22,  6, CERULEAN_CAVE_1F, 4
	warp_event 19,  7, CERULEAN_CAVE_1F, 5
	warp_event  9,  1, CERULEAN_CAVE_1F, 6
	warp_event  1,  3, CERULEAN_CAVE_1F, 7
	warp_event  3, 11, CERULEAN_CAVE_1F, 8

	def_bg_events

	def_object_events
	object_event  0, 11, SPRITE_POKE_BALL, STAY, NONE, 1, RARE_CANDY
	object_event 16,  7, SPRITE_POKE_BALL, STAY, NONE, 2, ULTRA_BALL
	object_event 19, 11, SPRITE_POKE_BALL, STAY, NONE, 3, MAX_REVIVE
	object_event 27,  9, SPRITE_POKE_BALL, STAY, NONE, 4, FULL_RESTORE

	def_warps_to CERULEAN_CAVE_2F
