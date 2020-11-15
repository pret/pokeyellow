VermilionCity_Object:
	db $43 ; border block

	def_warps
	warp 11,  3, 0, VERMILION_POKECENTER
	warp  9, 13, 0, POKEMON_FAN_CLUB
	warp 23, 13, 0, VERMILION_MART
	warp 12, 19, 0, VERMILION_GYM
	warp 23, 19, 0, VERMILION_PIDGEY_HOUSE
	warp 18, 31, 0, VERMILION_DOCK
	warp 19, 31, 0, VERMILION_DOCK
	warp 15, 13, 0, VERMILION_TRADE_HOUSE
	warp  7,  3, 0, VERMILION_OLD_ROD_HOUSE

	def_signs
	sign 27,  3, 8 ; VermilionCityText7
	sign 37, 13, 9 ; VermilionCityText8
	sign 24, 13, 10 ; MartSignText
	sign 12,  3, 11 ; PokeCenterSignText
	sign  7, 13, 12 ; VermilionCityText11
	sign  7, 19, 13 ; VermilionCityText12
	sign 29, 15, 14 ; VermilionCityText13

	def_objects
	object SPRITE_COOLTRAINER_F, 19, 7, WALK, LEFT_RIGHT, 1 ; person
	object SPRITE_GAMBLER, 14, 6, STAY, NONE, 2 ; person
	object SPRITE_SAILOR, 19, 30, STAY, UP, 3 ; person
	object SPRITE_GAMBLER, 30, 7, STAY, NONE, 4 ; person
	object SPRITE_MONSTER, 29, 9, WALK, UP_DOWN, 5 ; person
	object SPRITE_SAILOR, 25, 27, WALK, LEFT_RIGHT, 6 ; person
	object SPRITE_OFFICER_JENNY, 19, 15, STAY, NONE, 7 ; person

	def_warps_to VERMILION_CITY
