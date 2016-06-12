FuchsiaPokecenterObject:
	db $0 ; border block

	db $2 ; warps
	db $7, $3, $2, $ff
	db $7, $4, $2, $ff

	db $0 ; signs

	db $5 ; objects
	object SPRITE_NURSE, $3, $1, STAY, DOWN, $1 ; person
	object SPRITE_ROCKER, $4, $3, STAY, UP, $2 ; person
	object SPRITE_LASS, $6, $5, WALK, $2, $3 ; person
	object SPRITE_CABLE_CLUB_WOMAN, $b, $2, STAY, DOWN, $4 ; person
	object SPRITE_CHANSEY, $4, $1, STAY, DOWN, $5 ; person

	; warp-to
	EVENT_DISP FUCHSIA_POKECENTER_WIDTH, $7, $3
	EVENT_DISP FUCHSIA_POKECENTER_WIDTH, $7, $4
