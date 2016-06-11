BeachHouseScript:
	call $3c29
	ret

BeachHouseTextPointers:
	dw SurfinDudeText
	dw BeachHousePikachuText
	dw BeachHouseSign1Text
	dw BeachHouseSign2Text
	dw BeachHouseSign3Text
	dw BeachHouseSign4Text

SurfinDudeText:
	TX_ASM
	ld a, [wd472]
	bit 6, a
	jr nz, .next
	ld hl, .SurfinDudeText4
	call PrintText
	jr .done
.next
	ld hl, wd492
	bit 0, [hl]
	set 0, [hl]
	jr nz, .next2
	ld hl, .SurfinDudeText1
	jr .next3
.next2
	ld hl, .SurfinDudeText3
.next3
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_f226b
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	callba SurfingPikachuMinigame
	ld hl, wd492
	set 1, [hl]
	jr .done
.asm_f226b
	ld hl, .SurfinDudeText2
	call PrintText
.done
	jp TextScriptEnd

.SurfinDudeText1
	TX_FAR _SurfinDudeText1
	db "@"
.SurfinDudeText2
	TX_FAR _SurfinDudeText2
	db "@"
.SurfinDudeText3
	TX_FAR _SurfinDudeText3
	db "@"
.SurfinDudeText4
	TX_FAR _SurfinDudeText4
	db "@"

BeachHousePikachuText:
	TX_ASM
	ld hl, .BeachHousePikachuText
	call PrintText
	ld a, PIKACHU
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

.BeachHousePikachuText
	TX_FAR _BeachHousePikachuText
	db "@"

BeachHouseSign1Text:
	TX_ASM
	ld hl, .BeachHouseSign1Text2
	ld a, [wd472]
	bit 6, a
	jr z, .next
	ld hl, .BeachHouseSign1Text1
.next
	call PrintText
	jp TextScriptEnd

.BeachHouseSign1Text1
	TX_FAR _BeachHouseSign1Text1
	db "@"
.BeachHouseSign1Text2
	TX_FAR _BeachHouseSign1Text2
	db "@"

BeachHouseSign2Text:
	TX_ASM
	ld hl, .BeachHouseSign2Text2
	ld a, [wd472]
	bit 6, a
	jr z, .next
	ld hl, .BeachHouseSign2Text1
.next
	call PrintText
	jp TextScriptEnd

.BeachHouseSign2Text1
	TX_FAR _BeachHouseSign2Text1
	db "@"
.BeachHouseSign2Text2
	TX_FAR _BeachHouseSign2Text2
	db "@"

BeachHouseSign3Text:
	TX_ASM
	ld hl, .BeachHouseSign3Text2
	ld a, [wd472]
	bit 6, a
	jr z, .next
	ld hl, .BeachHouseSign3Text1
.next
	call PrintText
	jp TextScriptEnd

.BeachHouseSign3Text1
	TX_FAR _BeachHouseSign3Text1
	db "@"
.BeachHouseSign3Text2
	TX_FAR _BeachHouseSign3Text2
	db "@"

BeachHouseSign4Text:
	TX_ASM
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, [wd472]
	bit 6, a
	jr z, .asm_f2369

	ld hl, wd492
	bit 1, [hl]
	jr z, .next2
	ld a, 0
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
.next2
	ld hl, .BeachHousePrinterText2
	call PrintText
	ld a, [wd492]
	bit 1, a
	jr z, .asm_f236f

	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, .BeachHousePrinterText3
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jp z, Func_f23d0
	call SaveScreenTilesToBuffer2
	ld hl, wd730
	set 6, [hl]
	xor a
	ld [wUpdateSpritesEnabled], a
	callab Printer_PrepareSurfingMinigameHighScoreTileMap
	call WaitForTextScrollButtonPress
	ld hl, wd730
	res 6, [hl]
	call GBPalWhiteOutWithDelay3
	call ReloadTilesetTilePatterns
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadScreenTilesFromBuffer2
	call Delay3
	call GBPalNormal
	ld a, 1
	ld [wUpdateSpritesEnabled], a
	jr .asm_f236f
.asm_f2369
	ld hl, .BeachHousePrinterText1
	call PrintText
.asm_f236f
	jp TextScriptEnd

.BeachHousePrinterText1
	TX_FAR _BeachHousePrinterText1
	db $d, "@"
.BeachHousePrinterText2
	TX_FAR _BeachHousePrinterText2
	db $d, "@"
.BeachHousePrinterText3
	TX_FAR _BeachHousePrinterText3
	db "@"
.BeachHousePrinterText4
	TX_FAR _BeachHousePrinterText4
	db "@"
