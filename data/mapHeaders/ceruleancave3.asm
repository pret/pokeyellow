CeruleanCave3_h:
	db CAVERN ; tileset
	db CERULEAN_CAVE_3_HEIGHT, CERULEAN_CAVE_3_WIDTH ; dimensions (y, x)
	dw CeruleanCave3Blocks, CeruleanCave3TextPointers, CeruleanCave3Script ; blocks, texts, scripts
	db $00 ; connections
	dw CeruleanCave3Object ; objects
