PrizeDifferentMenuPtrs:
	dw PrizeMenuMon1Entries, PrizeMenuMon1Cost
	dw PrizeMenuMon2Entries, PrizeMenuMon2Cost
	dw PrizeMenuTMsEntries,  PrizeMenuTMsCost

PrizeMenuMon1Entries:
	db ABRA
	db VULPIX
	db WIGGLYTUFF
	db "@"

PrizeMenuMon1Cost:
	bcd2 230
	bcd2 1000
	bcd2 2680
	db "@"

PrizeMenuMon2Entries:
	db SCYTHER
	db PINSIR
	db PORYGON
	db "@"

PrizeMenuMon2Cost:
	bcd2 6500
	bcd2 6500
	bcd2 9999
	db "@"

PrizeMenuTMsEntries:
	db TM_DRAGON_RAGE
	db TM_HYPER_BEAM
	db TM_SUBSTITUTE
	db "@"

PrizeMenuTMsCost:
	bcd2 3300
	bcd2 5500
	bcd2 7700
	db "@"

; All151 alternate prize data — used when BIT_NUZLOPTIONS_ALL_151_POKEMON is set
PrizeDifferentMenuPtrs_All151:
	dw PrizeMenuMon1Entries_All151, PrizeMenuMon1Cost_All151
	dw PrizeMenuMon2Entries, PrizeMenuMon2Cost        ; Vendor 2 unchanged
	dw PrizeMenuTMsEntries_All151, PrizeMenuTMsCost_All151

PrizeMenuMon1Entries_All151:
	db EEVEE
	db SLOWPOKE
	db CLEFAIRY
	db "@"

PrizeMenuMon1Cost_All151:
	bcd2 3000
	bcd2 3000
	bcd2 1000
	db "@"

PrizeMenuTMsEntries_All151:
	db HELIX_FOSSIL
	db DOME_FOSSIL
	db MOON_STONE
	db "@"

PrizeMenuTMsCost_All151:
	bcd2 2000
	bcd2 2000
	bcd2 1000
	db "@"
