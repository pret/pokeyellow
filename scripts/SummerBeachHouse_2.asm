SummerBeachHousePrintHighScoreScript:
	call SaveScreenTilesToBuffer2
	xor a
	ld [wUpdateSpritesEnabled], a
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	callfar PrintSurfingMinigameHighScore
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	call GBPalWhiteOutWithDelay3
	call ReloadTilesetTilePatterns
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadScreenTilesFromBuffer2
	call Delay3
	call GBPalNormal
	ld hl, SummerBeachHousePrinterText6
	ldh a, [hCanceledPrinting]
	and a
	jr nz, .print_canceled
	ld hl, SummerBeachHousePrinterText5
.print_canceled
	call PrintText
	jp TextScriptEnd

SummerBeachHousePrinterText5:
	text_far _SummerBeachHousePrinterText5
	text_waitbutton
	text_end

SummerBeachHousePrinterText6:
	text_far _SummerBeachHousePrinterText6
	text_waitbutton
	text_end
