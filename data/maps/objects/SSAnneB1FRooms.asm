SSAnneB1FRooms_Object:
	db $c ; border block

	def_warp_events
	warp_event  2,  5, SS_ANNE_B1F, 5
	warp_event  3,  5, SS_ANNE_B1F, 5
	warp_event 12,  5, SS_ANNE_B1F, 4
	warp_event 13,  5, SS_ANNE_B1F, 4
	warp_event 22,  5, SS_ANNE_B1F, 3
	warp_event 23,  5, SS_ANNE_B1F, 3
	warp_event  2, 15, SS_ANNE_B1F, 2
	warp_event  3, 15, SS_ANNE_B1F, 2
	warp_event 12, 15, SS_ANNE_B1F, 1
	warp_event 13, 15, SS_ANNE_B1F, 1

	def_bg_events

	def_object_events
	object_event 12, 14, SPRITE_SAILOR, STAY, DOWN, 1, OPP_SAILOR, 3
	object_event  1, 15, SPRITE_SAILOR, STAY, RIGHT, 2, OPP_SAILOR, 4
	object_event  2, 14, SPRITE_SAILOR, STAY, DOWN, 3, OPP_SAILOR, 5
	object_event 22,  3, SPRITE_SAILOR, STAY, DOWN, 4, OPP_SAILOR, 6
	object_event 13,  5, SPRITE_SAILOR, STAY, RIGHT, 5, OPP_SAILOR, 7
	object_event  1,  5, SPRITE_FISHER, STAY, RIGHT, 6, OPP_FISHER, 2
	object_event 10, 13, SPRITE_SUPER_NERD, STAY, RIGHT, 7 ; person
	object_event 11, 12, SPRITE_MONSTER, STAY, NONE, 8 ; person
	object_event 20,  2, SPRITE_POKE_BALL, STAY, NONE, 9, LEAF_STONE
	object_event 10,  2, SPRITE_POKE_BALL, STAY, NONE, 10, TM_SUBMISSION
	object_event  0, 12, SPRITE_POKE_BALL, STAY, NONE, 11, FIRE_STONE

	def_warps_to SS_ANNE_B1F_ROOMS
