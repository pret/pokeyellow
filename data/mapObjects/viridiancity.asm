ViridianCityObject:
	db $f ; border block

	db $5 ; warps
	db $19, $17, $0, VIRIDIAN_POKECENTER
	db $13, $1d, $0, VIRIDIAN_MART
	db $f, $15, $0, VIRIDIAN_SCHOOL
	db $9, $15, $0, VIRIDIAN_HOUSE
	db $7, $20, $0, VIRIDIAN_GYM

	db $6 ; signs
	db $11, $11, $9 ; ViridianCityText8
	db $1, $13, $a ; ViridianCityText9
	db $1d, $15, $b ; ViridianCityText10
	db $13, $1e, $c ; MartSignText
	db $19, $18, $d ; PokeCenterSignText
	db $7, $1b, $e ; ViridianCityText13

	db $8 ; objects
	object SPRITE_BUG_CATCHER, $d, $14, WALK, $0, $1 ; person
	object SPRITE_GAMBLER, $1e, $8, STAY, NONE, $2 ; person
	object SPRITE_BUG_CATCHER, $1e, $19, WALK, $0, $3 ; person
	object SPRITE_GIRL, $11, $9, STAY, RIGHT, $4 ; person
	object SPRITE_LYING_OLD_MAN, $12, $9, STAY, NONE, $5 ; person
	object SPRITE_FISHER2, $6, $17, STAY, DOWN, $6 ; person
	object SPRITE_GAMBLER, $11, $5, WALK, $2, $7 ; person
	object SPRITE_GAMBLER, $12, $9, STAY, NONE, $8

	; warp-to
	EVENT_DISP VIRIDIAN_CITY_WIDTH, $19, $17 ; VIRIDIAN_POKECENTER
	EVENT_DISP VIRIDIAN_CITY_WIDTH, $13, $1d ; VIRIDIAN_MART
	EVENT_DISP VIRIDIAN_CITY_WIDTH, $f, $15 ; VIRIDIAN_SCHOOL
	EVENT_DISP VIRIDIAN_CITY_WIDTH, $9, $15 ; VIRIDIAN_HOUSE
	EVENT_DISP VIRIDIAN_CITY_WIDTH, $7, $20 ; VIRIDIAN_GYM
