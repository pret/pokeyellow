CeruleanCave2_h:
	db CAVERN ; tileset
	db CERULEAN_CAVE_2_HEIGHT, CERULEAN_CAVE_2_WIDTH ; dimensions (y, x)
	dw CeruleanCave2Blocks, CeruleanCave2TextPointers, CeruleanCave2Script ; blocks, texts, scripts
	db $00 ; connections
	dw CeruleanCave2Object ; objects
