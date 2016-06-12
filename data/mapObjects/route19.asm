Route19Object:
	db $43 ; border block

	db $1 ; warps
	db $9, $5, $0, BEACH_HOUSE

	db $1 ; signs
	db $b,$b,$b

	db $a ; objects

	object SPRITE_BLACK_HAIR_BOY_1, $09, $07, STAY, RIGHT,  $1, OPP_SWIMMER, $2
	object SPRITE_BLACK_HAIR_BOY_1, $0c, $09, STAY, LEFT,   $2, OPP_SWIMMER, $3
	object SPRITE_SWIMMER,          $0d, $19, STAY, LEFT,   $3, OPP_SWIMMER, $4
	object SPRITE_SWIMMER,          $04, $1b, STAY, RIGHT,  $4, OPP_SWIMMER, $5
	object SPRITE_SWIMMER,          $10, $1f, STAY, UP,     $5, OPP_SWIMMER, $6
	object SPRITE_SWIMMER,          $09, $0d, STAY, DOWN,   $6, OPP_SWIMMER, $7
	object SPRITE_SWIMMER,          $08, $2b, STAY, LEFT,   $7, OPP_BEAUTY,  $c
	object SPRITE_SWIMMER,          $0b, $2b, STAY, RIGHT,  $8, OPP_BEAUTY,  $d
	object SPRITE_SWIMMER,          $09, $2a, STAY, UP,     $9, OPP_SWIMMER, $8
	object SPRITE_SWIMMER,          $0a, $2c, STAY, DOWN,   $a, OPP_BEAUTY,  $e

	; warp-to
	EVENT_DISP ROUTE_19_WIDTH, $9, $5 ; BEACH_HOUSE
