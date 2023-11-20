	object_const_def
	const_export SILPHCO11F_SILPH_PRESIDENT
	const_export SILPHCO11F_BEAUTY
	const_export SILPHCO11F_GIOVANNI
	const_export SILPHCO11F_JAMES
	const_export SILPHCO11F_ROCKET
	const_export SILPHCO11F_JESSIE

SilphCo11F_Object:
	db $d ; border block

	def_warp_events
	warp_event  9,  0, SILPH_CO_10F, 2
	warp_event 13,  0, SILPH_CO_ELEVATOR, 1
	warp_event  5,  5, LAST_MAP, 10
	warp_event  3,  2, SILPH_CO_7F, 4

	def_bg_events

	def_object_events
	object_event  7,  5, SPRITE_SILPH_PRESIDENT, STAY, DOWN, TEXT_SILPHCO11F_SILPH_PRESIDENT
	object_event 10,  5, SPRITE_BEAUTY, STAY, DOWN, TEXT_SILPHCO11F_BEAUTY
	object_event  6,  9, SPRITE_GIOVANNI, STAY, DOWN, TEXT_SILPHCO11F_GIOVANNI, OPP_GIOVANNI, 2
	object_event  2,  8, SPRITE_JAMES, STAY, UP, TEXT_SILPHCO11F_JAMES
	object_event 15,  9, SPRITE_ROCKET, STAY, UP, TEXT_SILPHCO11F_ROCKET, OPP_ROCKET, 40
	object_event  3,  8, SPRITE_JESSIE, STAY, UP, TEXT_SILPHCO11F_JESSIE

	def_warps_to SILPH_CO_11F
