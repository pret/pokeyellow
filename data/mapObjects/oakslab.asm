OaksLabObject:
	db $3 ; border block

	db $2 ; warps
	db $b, $4, $2, $ff
	db $b, $5, $2, $ff

	db $0 ; signs

	db $9 ; objects
	object SPRITE_BLUE, $4, $3, STAY, NONE, $1, OPP_SONY1, $1
	object SPRITE_BALL, $7, $3, STAY, NONE, $2 ; person
	object SPRITE_OAK, $5, $2, STAY, DOWN, $3 ; person
	object SPRITE_BOOK_MAP_DEX, $2, $1, STAY, NONE, $4 ; person
	object SPRITE_BOOK_MAP_DEX, $3, $1, STAY, NONE, $5 ; person
	object SPRITE_OAK, $5, $a, STAY, UP, $6 ; person
	object SPRITE_GIRL, $1, $9, WALK, $1, $7 ; person
	object SPRITE_OAK_AIDE, $2, $a, STAY, NONE, $8 ; person
	object SPRITE_OAK_AIDE, $8, $a, STAY, NONE, $9 ; person

	; warp-to
	EVENT_DISP OAKS_LAB_WIDTH, $b, $4
	EVENT_DISP OAKS_LAB_WIDTH, $b, $5
