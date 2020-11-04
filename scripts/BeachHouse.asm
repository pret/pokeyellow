BeachHouse_Script:
	call EnableAutoTextBoxDrawing
	ret

BeachHouse_TextPointers:
	dw SurfinDudeText
	dw BeachHousePikachuText
	dw BeachHouseSign1Text
	dw BeachHouseSign2Text
	dw BeachHouseSign3Text
	dw BeachHouseSign4Text

SurfinDudeText:
	text_asm
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
	farcall SurfingPikachuMinigame
	ld hl, wd492
	set 1, [hl]
	jr .done
.asm_f226b
	ld hl, .SurfinDudeText2
	call PrintText
.done
	jp TextScriptEnd

.SurfinDudeText1
	text_far _SurfinDudeText1
	text_end
.SurfinDudeText2
	text_far _SurfinDudeText2
	text_end
.SurfinDudeText3
	text_far _SurfinDudeText3
	text_end
.SurfinDudeText4
	text_far _SurfinDudeText4
	text_end

BeachHousePikachuText:
	text_asm
	ld hl, .BeachHousePikachuText
	call PrintText
	ld a, PIKACHU
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

.BeachHousePikachuText
	text_far _BeachHousePikachuText
	text_end

BeachHouseSign1Text:
	text_asm
	ld hl, .BeachHouseSign1Text2
	ld a, [wd472]
	bit 6, a
	jr z, .next
	ld hl, .BeachHouseSign1Text1
.next
	call PrintText
	jp TextScriptEnd

.BeachHouseSign1Text1
	text_far _BeachHouseSign1Text1
	text_end
.BeachHouseSign1Text2
	text_far _BeachHouseSign1Text2
	text_end

BeachHouseSign2Text:
	text_asm
	ld hl, .BeachHouseSign2Text2
	ld a, [wd472]
	bit 6, a
	jr z, .next
	ld hl, .BeachHouseSign2Text1
.next
	call PrintText
	jp TextScriptEnd

.BeachHouseSign2Text1
	text_far _BeachHouseSign2Text1
	text_end
.BeachHouseSign2Text2
	text_far _BeachHouseSign2Text2
	text_end

BeachHouseSign3Text:
	text_asm
	ld hl, .BeachHouseSign3Text2
	ld a, [wd472]
	bit 6, a
	jr z, .next
	ld hl, .BeachHouseSign3Text1
.next
	call PrintText
	jp TextScriptEnd

.BeachHouseSign3Text1
	text_far _BeachHouseSign3Text1
	text_end
.BeachHouseSign3Text2
	text_far _BeachHouseSign3Text2
	text_end

BeachHouseSign4Text:
	text_asm
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
	callfar Printer_PrepareSurfingMinigameHighScoreTileMap
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
	text_far _BeachHousePrinterText1
	text_waitbutton
	text_end
.BeachHousePrinterText2
	text_far _BeachHousePrinterText2
	text_waitbutton
	text_end
.BeachHousePrinterText3
	text_far _BeachHousePrinterText3
	text_end
.BeachHousePrinterText4
	text_far _BeachHousePrinterText4
	text_end
