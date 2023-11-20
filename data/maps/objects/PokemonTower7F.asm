	object_const_def
	const_export POKEMONTOWER7F_JESSIE
	const_export POKEMONTOWER7F_JAMES
	const_export POKEMONTOWER7F_MR_FUJI

PokemonTower7F_Object:
	db $1 ; border block

	def_warp_events
	warp_event  9, 16, POKEMON_TOWER_6F, 2

	def_bg_events

	def_object_events
	object_event 10,  8, SPRITE_JESSIE, STAY, DOWN, TEXT_POKEMONTOWER7F_JESSIE
	object_event 11,  8, SPRITE_JAMES, STAY, DOWN, TEXT_POKEMONTOWER7F_JAMES
	object_event 10,  3, SPRITE_MR_FUJI, STAY, DOWN, TEXT_POKEMONTOWER7F_MR_FUJI

	def_warps_to POKEMON_TOWER_7F
