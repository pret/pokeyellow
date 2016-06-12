PrizeDifferentMenuPtrs:
	dw PrizeMenuMon1Entries
	dw PrizeMenuMon1Cost

	dw PrizeMenuMon2Entries
	dw PrizeMenuMon2Cost

	dw PrizeMenuTMsEntries
	dw PrizeMenuTMsCost

PrizeMenuMon1Entries:
	db ABRA
	db VULPIX
	db WIGGLYTUFF
	db "@"

PrizeMenuMon1Cost:
	coins 230
	coins 1000
	coins 2680
	db "@"

PrizeMenuMon2Entries:
	db SCYTHER
	db PINSIR
	db PORYGON
	db "@"

PrizeMenuMon2Cost:
	coins 6500
	coins 6500
	coins 9999
	db "@"

PrizeMenuTMsEntries:
	db TM_23
	db TM_15
	db TM_50
	db "@"

PrizeMenuTMsCost:
	coins 3300
	coins 5500
	coins 7700
	db "@"
