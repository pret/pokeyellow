PrizeDifferentMenuPtrs: ; 527ae (14:67ae)
	dw PrizeMenuMon1Entries
	dw PrizeMenuMon1Cost

	dw PrizeMenuMon2Entries
	dw PrizeMenuMon2Cost

	dw PrizeMenuTMsEntries
	dw PrizeMenuTMsCost

PrizeMenuMon1Entries: ; 527b9 (14:67b9)
	db ABRA
	db VULPIX
	db WIGGLYTUFF
	db "@"

PrizeMenuMon1Cost: ; 527be (14:67be)
	coins 230
	coins 1000
	coins 2680
	db "@"

PrizeMenuMon2Entries: ; 527c5 (14:67c5)
	db SCYTHER
	db PINSIR
	db PORYGON
	db "@"

PrizeMenuMon2Cost: ; 527c9 (14:67c9)
	coins 6500
	coins 6500
	coins 9999
	db "@"

PrizeMenuTMsEntries: ; 527df (14:67df)
	db TM_23
	db TM_15
	db TM_50
	db "@"

PrizeMenuTMsCost: ; 527e4 (14:67e4)
	coins 3300
	coins 5500
	coins 7700
	db "@"
