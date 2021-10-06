CeruleanCave1F_Object:
	db $7d ; border block

	def_warp_events
	warp_event 24, 17, LAST_MAP, 7
	warp_event 25, 17, LAST_MAP, 7
	warp_event 27,  1, CERULEAN_CAVE_2F, 1
	warp_event 23,  7, CERULEAN_CAVE_2F, 2
	warp_event 18,  9, CERULEAN_CAVE_2F, 3
	warp_event  7,  1, CERULEAN_CAVE_2F, 4
	warp_event  1,  3, CERULEAN_CAVE_2F, 5
	warp_event  3, 11, CERULEAN_CAVE_2F, 6
	warp_event  0,  6, CERULEAN_CAVE_B1F, 1

	def_bg_events

	def_object_events
	object_event 29, 16, SPRITE_POKE_BALL, STAY, NONE, 1, RARE_CANDY
	object_event  7, 11, SPRITE_POKE_BALL, STAY, NONE, 2, MAX_ELIXER
	object_event 29,  9, SPRITE_POKE_BALL, STAY, NONE, 3, MAX_REVIVE
	object_event 18,  3, SPRITE_POKE_BALL, STAY, NONE, 4, ULTRA_BALL

	def_warps_to CERULEAN_CAVE_1F
