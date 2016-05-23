OpenOaksPC: ; 1e2ae (7:62ae)
	call SaveScreenTilesToBuffer2
	ld hl, AccessedOaksPCText
	call PrintText
	ld hl, GetDexRatedText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .closePC
	predef DisplayDexRating
.closePC
	ld hl, ClosedOaksPCText
	call PrintText
	jp LoadScreenTilesFromBuffer2

GetDexRatedText: ; 1e2d4 (7:62d4)
	TX_FAR _GetDexRatedText
	db "@"

ClosedOaksPCText: ; 1e2d9 (7:62d9)
	TX_FAR _ClosedOaksPCText
	db $0d,"@"

AccessedOaksPCText: ; 1e2df (7:62df)
	TX_FAR _AccessedOaksPCText
	db "@"
