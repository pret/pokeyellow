BeachHouse_h: ; f220e (3c:620e)

	db BEACH_HOUSE_TILESET
	db BEACH_HOUSE_HEIGHT, BEACH_HOUSE_WIDTH ; dimensions (y, x)
	dw BeachHouseBlockdata,BeachHouseTextPointers,BeachHouseScript ; blocks, texts, scripts
	db 0 ; connections
	dw BeachHouseObjects ; objects
