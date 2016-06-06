PrintNewBikeText: ; 1e2e4 (7:62e4)
	call EnableAutoTextBoxDrawing
	tx_pre_jump NewBicycleText

NewBicycleText: ; 1e2ec (7:62ec)
	TX_FAR _NewBicycleText
	db "@"

DisplayOakLabLeftPoster: ; 1e2f1 (7:62f1)
	call EnableAutoTextBoxDrawing
	tx_pre_jump PushStartText

PushStartText: ; 1e2f9 (7:62f9)
	TX_FAR _PushStartText
	db "@"

DisplayOakLabRightPoster: ; 1e2fe (7:62fe)
	call EnableAutoTextBoxDrawing
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	cp 2
	tx_pre_id SaveOptionText
	jr c, .ownOneMon
	tx_pre_id StrengthsAndWeaknessesText
.ownOneMon
	jp PrintPredefTextID

SaveOptionText: ; 1e317 (7:6317)
	TX_FAR _SaveOptionText
	db "@"

StrengthsAndWeaknessesText: ; 1e31c (7:631c)
	TX_FAR _StrengthsAndWeaknessesText
	db "@"

SafariZoneCheck: ; 1e321 (7:6321)
	CheckEventHL EVENT_IN_SAFARI_ZONE ; if we are not in the Safari Zone,
	jr z, SafariZoneGameStillGoing ; don't bother printing game over text
	ld a, [wNumSafariBalls]
	and a
	jr z, SafariZoneGameOver
	jr SafariZoneGameStillGoing

SafariZoneCheckSteps: ; 1e330 (7:6330)
	ld a, [wSafariSteps]
	ld b, a
	ld a, [wSafariSteps + 1]
	ld c, a
	or b
	jr z, SafariZoneGameOver
	dec bc
	ld a, b
	ld [wSafariSteps], a
	ld a, c
	ld [wSafariSteps + 1], a
SafariZoneGameStillGoing: ; 1e344 (7:6344)
	xor a
	ld [wSafariZoneGameOver], a
	ret

SafariZoneGameOver: ; 1e349 (7:6349)
	call EnableAutoTextBoxDrawing
	xor a
	ld [wAudioFadeOutControl], a
	call StopAllMusic
	ld c, BANK(SFX_Safari_Zone_PA)
	ld a, SFX_SAFARI_ZONE_PA
	call PlayMusic
.waitForMusicToPlay
	ld a, [wChannelSoundIDs + CH4]
	cp SFX_SAFARI_ZONE_PA
	jr nz, .waitForMusicToPlay
	ld a, TEXT_SAFARI_GAME_OVER
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wPlayerMovingDirection], a
	ld a, SAFARI_ZONE_ENTRANCE
	ld [hWarpDestinationMap], a
	ld a, $3
	ld [wDestinationWarpID], a
	ld a, $5
	ld [wSafariZoneEntranceCurScript], a
	SetEvent EVENT_SAFARI_GAME_OVER
	ld a, $1
	ld [wSafariZoneGameOver], a
	ret

PrintSafariGameOverText: ; 1e385 (7:6385)
	xor a
	ld [wJoyIgnore], a
	ld hl, SafariGameOverText
	jp PrintText

SafariGameOverText: ; 1e38f (7:638f)
	TX_ASM
	ld a, [wNumSafariBalls]
	and a
	jr z, .noMoreSafariBalls
	ld hl, TimesUpText
	call PrintText
.noMoreSafariBalls
	ld hl, GameOverText
	call PrintText
	jp TextScriptEnd

TimesUpText: ; 1e3a5 (7:63a5)
	TX_FAR _TimesUpText
	db "@"

GameOverText: ; 1e3aa (7:63aa)
	TX_FAR _GameOverText
	db "@"

PrintCinnabarQuiz: ; 1e3af (7:63af)
	ld a, [wPlayerFacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	call EnableAutoTextBoxDrawing
	tx_pre_jump CinnabarGymQuiz

CinnabarGymQuiz: ; 1e3be (7:63be)
	TX_ASM
	xor a
	ld [wOpponentAfterWrongAnswer], a
	ld hl, wd475
	res 7, [hl]
	ld a, [wHiddenObjectFunctionArgument]
	push af
	and $f
	ld [hGymGateIndex], a
	pop af
	and $f0
	swap a
	ld [$ffdc], a
	ld a, [hGymGateIndex]
	ld hl, CinnabarGymQuizIntroText
	cp $1
	jr z, .onFirstQuestion
	ld hl, CinnabarGymQuizShortIntroText
.onFirstQuestion
	call PrintText
	ld a, [hGymGateIndex]
	dec a
	add a
	ld d, 0
	ld e, a
	ld hl, CinnabarQuizQuestions
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintText
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call CinnabarGymQuiz_1ea92
	jp TextScriptEnd

CinnabarGymQuizDummyIntroText: ; 1e401 (7:6401)
	TX_FAR _CinnabarGymQuizDummyIntroText
	db "@"
	
CinnabarGymQuizIntroText: ; 1e406 (7:6406)
	TX_FAR _CinnabarGymQuizIntroText
	db "@"

CinnabarGymQuizShortIntroText: ; 1e40b (7:640b)
	TX_FAR _CinnabarGymQuizShortIntroText
	db "@"
	
CinnabarQuizQuestions: ; 1e410 (7:6410)
	dw CinnabarQuizQuestionsText1
	dw CinnabarQuizQuestionsText2
	dw CinnabarQuizQuestionsText3
	dw CinnabarQuizQuestionsText4
	dw CinnabarQuizQuestionsText5
	dw CinnabarQuizQuestionsText6

CinnabarQuizQuestionsText1: ; 1e41c (7:641c)
	TX_FAR _CinnabarQuizQuestionsText1
	db "@"

CinnabarQuizQuestionsText2: ; 1e421 (7:6421)
	TX_FAR _CinnabarQuizQuestionsText2
	db "@"

CinnabarQuizQuestionsText3: ; 1e426 (7:6426)
	TX_FAR _CinnabarQuizQuestionsText3
	db "@"

CinnabarQuizQuestionsText4: ; 1e42b (7:642b)
	TX_FAR _CinnabarQuizQuestionsText4
	db "@"

CinnabarQuizQuestionsText5: ; 1e430 (7:6430)
	TX_FAR _CinnabarQuizQuestionsText5
	db "@"

CinnabarQuizQuestionsText6: ; 1e435 (7:6435)
	TX_FAR _CinnabarQuizQuestionsText6
	db "@"

CinnabarGymQuiz_1ea92: ; 1e43a (7:643a)
	call YesNoChoice
	ld a, [$ffdc]
	ld c, a
	ld a, [wCurrentMenuItem]
	cp c
	jr nz, .wrongAnswer
	ld hl, wd126
	set 5, [hl]
	ld a, [hGymGateIndex]
	ld [$ffe0], a
	ld hl, CinnabarGymQuizCorrectText
	call PrintText
	ld a, [$ffe0]
	AdjustEventBit EVENT_CINNABAR_GYM_GATE0_UNLOCKED, 0
	ld c, a
	ld b, FLAG_SET
	call CinnabarGymGateFlagAction
	jp UpdateCinnabarGymGateTileBlocks_
.wrongAnswer
	call WaitForSoundToFinish
	ld a, SFX_DENIED
	call PlaySound
	call WaitForSoundToFinish
	ld hl, CinnabarGymQuizIncorrectText
	call PrintText
	ld a, [hGymGateIndex]
	add $2
	AdjustEventBit EVENT_BEAT_CINNABAR_GYM_TRAINER_0, 2
	ld c, a
	ld b, FLAG_TEST
	EventFlagAddress hl, EVENT_BEAT_CINNABAR_GYM_TRAINER_0
	predef FlagActionPredef
	ld a, c
	and a
	ret nz
	ld a, [hGymGateIndex]
	add $2
	ld [wOpponentAfterWrongAnswer], a
	ld hl, wd475
	set 7, [hl]
	ret

CinnabarGymQuizCorrectText: ; 1e490 (7:6490)
	db $0b
	TX_FAR _CinnabarGymQuizCorrectText
	db $06
	TX_ASM

	ld a, [$ffe0]
	AdjustEventBit EVENT_CINNABAR_GYM_GATE0_UNLOCKED, 0
	ld c, a
	ld b, FLAG_TEST
	call CinnabarGymGateFlagAction
	ld a, c
	and a
	jp nz, TextScriptEnd
	call WaitForSoundToFinish
	ld a, SFX_GO_INSIDE
	call PlaySound
	call WaitForSoundToFinish
	jp TextScriptEnd

CinnabarGymQuizIncorrectText: ; 1e4b2 (7:64b2)
	TX_FAR _CinnabarGymQuizIncorrectText
	db "@"

CinnabarGymGateFlagAction: ; 1e4b7 (7:64b7)
	EventFlagAddress hl, EVENT_CINNABAR_GYM_GATE0_UNLOCKED
	predef_jump FlagActionPredef

UpdateCinnabarGymGateTileBlocks_: ; 1e4bf (7:64bf)
; Update the overworld map with open floor blocks or locked gate blocks
; depending on event flags.
	ld a, 6
	ld [hGymGateIndex], a
.loop
	ld a, [hGymGateIndex]
	dec a
	add a
	add a
	ld d, 0
	ld e, a
	ld hl, CinnabarGymGateCoords
	add hl, de
	ld a, [hli]
	ld b, [hl]
	ld c, a
	inc hl
	ld a, [hl]
	ld [wGymGateTileBlock], a
	push bc
	ld a, [hGymGateIndex]
	ld [$ffe0], a
	AdjustEventBit EVENT_CINNABAR_GYM_GATE0_UNLOCKED, 0
	ld c, a
	ld b, FLAG_TEST
	call CinnabarGymGateFlagAction
	ld a, c
	and a
	jr nz, .unlocked
	ld a, [wGymGateTileBlock]
	jr .next
.unlocked
	ld a, $e
.next
	pop bc
	ld [wNewTileBlockID], a
	call CinnabarGym_ReplaceTileBlock
	ld hl, hGymGateIndex
	dec [hl]
	jr nz, .loop
	callab RedrawMapView
	ret

CinnabarGymGateCoords: ; 1e503 (7:6503)
	; format: x-coord, y-coord, direction, padding
	; direction: $54 = horizontal gate, $5f = vertical gate
	db $09,$03,$54,$00
	db $06,$03,$54,$00
	db $06,$06,$54,$00
	db $03,$08,$5f,$00
	db $02,$06,$54,$00
	db $02,$03,$54,$00

	
CinnabarGym_ReplaceTileBlock: ; 1e51b (7:651b)
; basically a copy of the first half of ReplaceTileBlock
; before checking if it is necessary to redraw the map view
	ld hl, wOverworldMap
	ld a, [wCurMapWidth]
	add $6
	ld e, a
	ld d, $0
	add hl, de
	add hl, de
	add hl, de
	ld e, $3
	add hl, de
	ld e, a
	ld a, b
	and a
	jr z, .addX
.addWidthYTimesLoop
	add hl, de
	dec b
	jr nz, .addWidthYTimesLoop
.addX
	add hl, bc
	ld a, [wNewTileBlockID]
	ld [hl], a
	ret

PrintMagazinesText: ; 1e53b (7:653b)
	call EnableAutoTextBoxDrawing
	tx_pre MagazinesText
	ret

MagazinesText: ; 1e544 (7:6544)
	TX_FAR _MagazinesText
	db "@"

BillsHousePC: ; 1e549 (7:6549)
	call EnableAutoTextBoxDrawing
	ld a, [wPlayerFacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	CheckEvent EVENT_LEFT_BILLS_HOUSE_AFTER_HELPING
	jr nz, .displayBillsHousePokemonList
	CheckEventReuseA EVENT_USED_CELL_SEPARATOR_ON_BILL
	jr nz, .displayBillsHouseMonitorText
	CheckEventReuseA EVENT_BILL_SAID_USE_CELL_SEPARATOR
	jr nz, .doCellSeparator
.displayBillsHouseMonitorText
	tx_pre_jump BillsHouseMonitorText
.doCellSeparator
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	tx_pre BillsHouseInitiatedText
	ld c, 32
	call DelayFrames
	ld a, SFX_TINK
	call PlaySound
	call WaitForSoundToFinish
	ld c, 80
	call DelayFrames
	ld a, SFX_SHRINK
	call PlaySound
	call WaitForSoundToFinish
	ld c, 48
	call DelayFrames
	ld a, SFX_TINK
	call PlaySound
	call WaitForSoundToFinish
	ld c, 32
	call DelayFrames
	ld a, SFX_GET_ITEM_1
	call PlaySound
	call WaitForSoundToFinish
	call PlayDefaultMusic
	SetEvent EVENT_USED_CELL_SEPARATOR_ON_BILL
	ret
.displayBillsHousePokemonList
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	tx_pre BillsHousePokemonList
	ret

BillsHouseMonitorText: ; 1e5b8 (7:65b8)
	TX_FAR _BillsHouseMonitorText
	db "@"

BillsHouseInitiatedText: ; 1e5bd (7:65b2)
	TX_FAR _BillsHouseInitiatedText
	db $06
	TX_ASM
	call StopAllMusic
	ld c, 16
	call DelayFrames
	ld a, SFX_SWITCH
	call PlaySound
	call WaitForSoundToFinish
	ld c, 60
	call DelayFrames
	jp TextScriptEnd

BillsHousePokemonList: ; 1e5dc (7:65dc)
	TX_ASM
	call SaveScreenTilesToBuffer1
	ld hl, BillsHousePokemonListText1
	call PrintText
	xor a
	ld [wAnimationID], a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld a, A_BUTTON | B_BUTTON
	ld [wMenuWatchedKeys], a
	ld a, $4
	ld [wMaxMenuItem], a
	ld a, $2
	ld [wTopMenuItemY], a
	ld a, $1
	ld [wTopMenuItemX], a
.billsPokemonLoop
	ld hl, wd730
	set 6, [hl]
	coord hl, 0, 0
	lb bc, 10, 9
	call TextBoxBorder
	coord hl, 2, 2
	ld de, BillsMonListText
	call PlaceString
	ld hl, BillsHousePokemonListText2
	call PrintText
	call SaveScreenTilesToBuffer2
	call HandleMenuInput
	bit 1, a ; pressed b
	jr nz, .cancel
	ld a, [wCurrentMenuItem]
	add EEVEE
	cp EEVEE
	jr z, .displayPokedex
	cp FLAREON
	jr z, .displayPokedex
	cp JOLTEON
	jr z, .displayPokedex
	cp VAPOREON
	jr z, .displayPokedex
	jr .cancel
.displayPokedex
	call DisplayPokedex
	call LoadScreenTilesFromBuffer2
	jr .billsPokemonLoop
.cancel
	ld hl, wd730
	res 6, [hl]
	call LoadScreenTilesFromBuffer2
	jp TextScriptEnd

BillsHousePokemonListText1: ; 1e654 (7:6654)
	TX_FAR _BillsHousePokemonListText1
	db "@"

BillsMonListText: ; 1e659 (7:6659)
	db   "EEVEE"
	next "FLAREON"
	next "JOLTEON"
	next "VAPOREON"
	next "CANCEL@"

BillsHousePokemonListText2: ; 1e67f (7:667f)
	TX_FAR _BillsHousePokemonListText2
	db "@"

DisplayOakLabEmailText: ; 1e684 (7:6684)
	ld a, [wPlayerFacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	call EnableAutoTextBoxDrawing
	tx_pre OakLabEmailText
	ret

OakLabEmailText: ; 1e693 (7:6693)
	TX_FAR _OakLabEmailText
	db "@"
