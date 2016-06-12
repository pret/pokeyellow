LavenderPokecenterObject:
	db $0 ; border block

	db $2 ; warps
	db $7, $3, $0, $ff
	db $7, $4, $0, $ff

	db $0 ; signs

	db $5 ; objects
	object SPRITE_NURSE, $3, $1, STAY, DOWN, $1 ; person
	object SPRITE_GENTLEMAN, $5, $3, STAY, NONE, $2 ; person
	object SPRITE_LITTLE_GIRL, $a, $5, WALK, $2, $3 ; person
	object SPRITE_CABLE_CLUB_WOMAN, $b, $2, STAY, DOWN, $4 ; person
	object SPRITE_CHANSEY, $4, $1, STAY, DOWN, $5 ; person

	; warp-to
	EVENT_DISP LAVENDER_POKECENTER_WIDTH, $7, $3
	EVENT_DISP LAVENDER_POKECENTER_WIDTH, $7, $4
