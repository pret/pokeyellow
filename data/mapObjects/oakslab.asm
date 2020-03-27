OaksLabObject:
	db $3 ; border block

	db 2 ; warps
	warp 4, 11, 2, -1
	warp 5, 11, 2, -1

	db 0 ; signs

	db 9 ; objects
	object SPRITE_BLUE, 4, 3, STAY, NONE, 1, OPP_SONY1, 1
	object SPRITE_BALL, 7, 3, STAY, NONE, 2 ; person
	object SPRITE_OAK, 5, 2, STAY, DOWN, 3 ; person
	object SPRITE_BOOK_MAP_DEX, 2, 1, STAY, NONE, 4 ; person
	object SPRITE_BOOK_MAP_DEX, 3, 1, STAY, NONE, 5 ; person
	object SPRITE_OAK, 5, 10, STAY, UP, 6 ; person
	object SPRITE_GIRL, 1, 9, WALK, 1, 7 ; person
	object SPRITE_OAK_AIDE, 2, 10, STAY, NONE, 8 ; person
	object SPRITE_OAK_AIDE, 8, 10, STAY, NONE, 9 ; person

	; warp-to
	warp_to 4, 11, OAKS_LAB_WIDTH
	warp_to 5, 11, OAKS_LAB_WIDTH
