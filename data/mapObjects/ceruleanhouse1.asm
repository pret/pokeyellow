CeruleanHouse1Object:
	db $a ; border block

	db 2 ; warps
	warp 2, 7, 1, -1
	warp 3, 7, 1, -1

	db 0 ; signs

	db 4 ; objects
	object SPRITE_GIRL, 3, 1, STAY, DOWN, 1 ; person
	object SPRITE_BULBASAUR, 4, 1, STAY, DOWN, 2 ; person
	object SPRITE_ODDISH, 1, 4, STAY, NONE, 3 ; person
	object SPRITE_SANDSHREW, 5, 3, STAY, LEFT, 4 ; person

	; warp-to
	warp_to 2, 7, CERULEAN_HOUSE_1_WIDTH
	warp_to 3, 7, CERULEAN_HOUSE_1_WIDTH
