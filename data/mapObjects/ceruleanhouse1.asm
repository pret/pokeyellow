CeruleanHouse1Object:
	db $a ; border block

	db $2 ; warps
	db $7, $2, $1, $ff
	db $7, $3, $1, $ff

	db $0 ; signs

	db $4 ; objects
	object SPRITE_GIRL, $3, $1, STAY, DOWN, $1 ; person
	object SPRITE_BULBASAUR, $4, $1, STAY, DOWN, $2 ; person
	object SPRITE_ODDISH, $1, $4, STAY, NONE, $3 ; person
	object SPRITE_SANDSHREW, $5, $3, STAY, LEFT, $4 ; person

	; warp-to
	EVENT_DISP CERULEAN_HOUSE_1_WIDTH, $7, $2
	EVENT_DISP CERULEAN_HOUSE_1_WIDTH, $7, $3
