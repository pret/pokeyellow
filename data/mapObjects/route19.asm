Route19Object: ; 0x54e9a (size=87)
	db $43 ; border block

	db $1 ; warps
	db $9, $5, $0, BEACH_HOUSE

	db $1 ; signs
	db $b,$b,$b

	db $a ; objects
	
	object SPRITE_BLACK_HAIR_BOY_1, $9, $7, STAY, RIGHT, 1, OPP_SWIMMER, 2
	object SPRITE_BLACK_HAIR_BOY_1, $c, $9, STAY, LEFT, 2, OPP_SWIMMER, 3
	object SPRITE_SWIMMER, $9, $d, STAY, DOWN, $6, OPP_SWIMMER, $7
	object SPRITE_SWIMMER, $8, $2b, STAY, LEFT, $7, OPP_BEAUTY, $c
	object SPRITE_SWIMMER, $b, $2b, STAY, RIGHT, $8, OPP_BEAUTY, $d
	object SPRITE_SWIMMER, $9, $2a, STAY, UP, $9, OPP_SWIMMER, $8
	object SPRITE_SWIMMER, $a, $2c, STAY, DOWN, $a, OPP_BEAUTY, $e

	; warp-to
	EVENT_DISP ROUTE_19_WIDTH, $9, $5 ; BEACH_HOUSE
