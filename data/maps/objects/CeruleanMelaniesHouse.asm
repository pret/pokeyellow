CeruleanMelaniesHouse_Object:
	db $a ; border block

	def_warps
	warp  2,  7, 1, LAST_MAP
	warp  3,  7, 1, LAST_MAP

	def_signs

	def_objects
	object SPRITE_GIRL, 3, 1, STAY, DOWN, 1 ; person
	object SPRITE_BULBASAUR, 4, 1, STAY, DOWN, 2 ; person
	object SPRITE_ODDISH, 1, 4, STAY, NONE, 3 ; person
	object SPRITE_SANDSHREW, 5, 3, STAY, LEFT, 4 ; person

	def_warps_to CERULEAN_MELANIES_HOUSE
