Func_f23d0:
	call SaveScreenTilesToBuffer2
	xor a
	ld [wUpdateSpritesEnabled], a
	ld hl, wd730
	set 6, [hl]
	callab PrintSurfingMinigameHighScore
	ld hl, wd730
	res 6, [hl]
	call GBPalWhiteOutWithDelay3
	call ReloadTilesetTilePatterns
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadScreenTilesFromBuffer2
	call Delay3
	call GBPalNormal
	ld hl, Text_f2412
	ld a, [hOaksAideResult]
	and a
	jr nz, .asm_f2406
	ld hl, Text_f240c
.asm_f2406
	call PrintText
	jp TextScriptEnd

Text_f240c:
	TX_FAR _BeachHousePrinterText5
	TX_WAIT_BUTTON
	db "@"

Text_f2412:
	TX_FAR _BeachHousePrinterText6
	TX_WAIT_BUTTON
	db "@"
