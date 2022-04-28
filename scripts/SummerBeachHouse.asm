SummerBeachHouse_Script:
	call EnableAutoTextBoxDrawing
	ret

SummerBeachHouse_TextPointers:
	dw SurfinDudeText
	dw SummerBeachHousePikachuText
	dw SummerBeachHouseSign1Text
	dw SummerBeachHouseSign2Text
	dw SummerBeachHouseSign3Text
	dw SummerBeachHouseSign4Text

SurfinDudeText:
	text_asm
	ld a, [wd472]
	vc_patch Bypass_need_Pikachu_with_Surf_for_minigame
IF DEF (_YELLOW_VC)
	bit 7, a
ELSE
	bit 6, a
ENDC
	vc_patch_end
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

SummerBeachHousePikachuText:
	text_asm
	ld hl, .SummerBeachHousePikachuText
	call PrintText
	ld a, PIKACHU
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

.SummerBeachHousePikachuText
	text_far _SummerBeachHousePikachuText
	text_end

SummerBeachHouseSign1Text:
	text_asm
	ld hl, .SummerBeachHouseSign1Text2
	ld a, [wd472]
	bit 6, a
	jr z, .next
	ld hl, .SummerBeachHouseSign1Text1
.next
	call PrintText
	jp TextScriptEnd

.SummerBeachHouseSign1Text1
	text_far _SummerBeachHouseSign1Text1
	text_end
.SummerBeachHouseSign1Text2
	text_far _SummerBeachHouseSign1Text2
	text_end

SummerBeachHouseSign2Text:
	text_asm
	ld hl, .SummerBeachHouseSign2Text2
	ld a, [wd472]
	bit 6, a
	jr z, .next
	ld hl, .SummerBeachHouseSign2Text1
.next
	call PrintText
	jp TextScriptEnd

.SummerBeachHouseSign2Text1
	text_far _SummerBeachHouseSign2Text1
	text_end
.SummerBeachHouseSign2Text2
	text_far _SummerBeachHouseSign2Text2
	text_end

SummerBeachHouseSign3Text:
	text_asm
	ld hl, .SummerBeachHouseSign3Text2
	ld a, [wd472]
	bit 6, a
	jr z, .next
	ld hl, .SummerBeachHouseSign3Text1
.next
	call PrintText
	jp TextScriptEnd

.SummerBeachHouseSign3Text1
	text_far _SummerBeachHouseSign3Text1
	text_end
.SummerBeachHouseSign3Text2
	text_far _SummerBeachHouseSign3Text2
	text_end

SummerBeachHouseSign4Text:
	text_asm
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, [wd472]
	vc_patch Bypass_need_Pikachu_with_Surf_for_high_score
IF DEF(_YELLOW_VC)
	bit 7, a
ELSE
	bit 6, a
ENDC
	vc_patch_end
	jr z, .asm_f2369

	ld hl, wd492
	bit 1, [hl]
	jr z, .next2
	ld a, 0
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
.next2
	ld hl, .SummerBeachHousePrinterText2
	call PrintText
	ld a, [wd492]
	bit 1, a
	jr z, .asm_f236f

	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, .SummerBeachHousePrinterText3
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
	ld hl, .SummerBeachHousePrinterText1
	call PrintText
.asm_f236f
	jp TextScriptEnd

.SummerBeachHousePrinterText1
	text_far _SummerBeachHousePrinterText1
	text_waitbutton
	text_end

.SummerBeachHousePrinterText2
	text_far _SummerBeachHousePrinterText2
	text_waitbutton
	text_end

.SummerBeachHousePrinterText3
	text_far _SummerBeachHousePrinterText3
	text_end

.SummerBeachHousePrinterText4
	text_far _SummerBeachHousePrinterText4
	text_end
