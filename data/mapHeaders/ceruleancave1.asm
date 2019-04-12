CeruleanCave1_h:
	db CAVERN ; tileset
	db CERULEAN_CAVE_1_HEIGHT, CERULEAN_CAVE_1_WIDTH ; dimensions (y, x)
	dw CeruleanCave1Blocks, CeruleanCave1TextPointers, CeruleanCave1Script ; blocks, texts, scripts
	db $00 ; connections
	dw CeruleanCave1Object ; objects
