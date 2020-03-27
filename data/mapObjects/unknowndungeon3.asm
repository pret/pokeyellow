UnknownDungeon3Object:
	db $7d ; border block

	db 1 ; warps
	warp 3, 6, 8, UNKNOWN_DUNGEON_1

	db 0 ; signs

	db 5 ; objects
	object SPRITE_SLOWBRO, 27, 13, STAY, DOWN, 1, MEWTWO, 70
	object SPRITE_BALL, 26, 1, STAY, NONE, 2, ULTRA_BALL
	object SPRITE_BALL, 2, 13, STAY, NONE, 3, ULTRA_BALL
	object SPRITE_BALL, 3, 13, STAY, NONE, 4, MAX_REVIVE
	object SPRITE_BALL, 15, 3, STAY, NONE, 5, MAX_ELIXER

	; warp-to
	warp_to 3, 6, UNKNOWN_DUNGEON_3_WIDTH ; UNKNOWN_DUNGEON_1
