Func_f23d0:
	call SaveScreenTilesToBuffer2
	xor a
	ld [wUpdateSpritesEnabled], a
	ld hl, wd730
	set 6, [hl]
	callfar PrintSurfingMinigameHighScore
	ld hl, wd730
	res 6, [hl]
	call GBPalWhiteOutWithDelay3
	call ReloadTilesetTilePatterns
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadScreenTilesFromBuffer2
	call Delay3
	call GBPalNormal
	ld hl, Text_f2412
	ldh a, [hOaksAideResult]
	and a
	jr nz, .asm_f2406
	ld hl, Text_f240c
.asm_f2406
	call PrintText
	jp TextScriptEnd

Text_f240c:
	text_far _SummerBeachHousePrinterText5
	text_waitbutton
	text_end

Text_f2412:
	text_far _SummerBeachHousePrinterText6
	text_waitbutton
	text_end
