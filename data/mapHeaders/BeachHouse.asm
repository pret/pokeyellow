BeachHouse_h:
	db BEACH_HOUSE_TILESET
	db BEACH_HOUSE_HEIGHT, BEACH_HOUSE_WIDTH ; dimensions (y, x)
	dw BeachHouse_Blocks ; blocks
	dw BeachHouse_TextPointers ; texts
	dw BeachHouse_Script ; scripts
	db 0 ; connections
	dw BeachHouse_Object ; objects
