BeachHouseObjects:
	db $a ; border block

	db 2 ; warps
	warp 2,7,0,-1
	warp 3,7,0,-1

	db 4 ; signs
	sign 3,0,3
	sign 7,0,4
	sign 11,0,5
	sign 13,1,6

	db 2 ; objects
	object SPRITE_FISHER, 2, 3, STAY, DOWN, 1 ; surfin' dude
	object $3d, 5, 3, WALK, $01, 2 ; pikachu

	; warp-to
	warp_to 2,7, BEACH_HOUSE_WIDTH
	warp_to 3,7, BEACH_HOUSE_WIDTH
