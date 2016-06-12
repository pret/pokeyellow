UnknownDungeon3Object:
	db $7d ; border block

	db $1 ; warps
	db $6, $3, $8, UNKNOWN_DUNGEON_1

	db $0 ; signs

	db $5 ; objects
	object SPRITE_SLOWBRO, $1b, $d, STAY, DOWN, $1, MEWTWO, 70
	object SPRITE_BALL, $1a, $1, STAY, NONE, $2, ULTRA_BALL
	object SPRITE_BALL, $2, $d, STAY, NONE, $3, ULTRA_BALL
	object SPRITE_BALL, $3, $d, STAY, NONE, $4, MAX_REVIVE
	object SPRITE_BALL, $f, $3, STAY, NONE, $5, MAX_ELIXER

	; warp-to
	EVENT_DISP UNKNOWN_DUNGEON_3_WIDTH, $6, $3 ; UNKNOWN_DUNGEON_1
