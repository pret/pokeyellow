PokemonTower7Object: ; 0x60ef6 (size=42)
	db $1 ; border block

	db $1 ; warps
	db $10, $9, $1, POKEMONTOWER_6

	db $0 ; signs

	db 3 ; people
	db SPRITE_JESSIE, 8 + 4, $a + 4, $ff, $d0, 1
	db SPRITE_JAMES, 8 + 4, $b + 4, $ff, $d0, 2
	db SPRITE_MR_FUJI, 3 + 4, $a + 4, $ff, $d0, 3

	; warp-to
	EVENT_DISP POKEMONTOWER_7_WIDTH, $10, $9 ; POKEMONTOWER_6
