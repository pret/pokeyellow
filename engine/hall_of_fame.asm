AnimateHallOfFame: ; 701c6 (1c:41c6)
	call HoFFadeOutScreenAndMusic
	call ClearScreen
	ld c, 100
	call DelayFrames
	call LoadFontTilePatterns
	call LoadTextBoxTilePatterns
	call DisableLCD
	ld hl,vBGMap0
	ld bc, $800
	ld a, " "
	call FillMemory
	call EnableLCD
	ld hl, rLCDC
	set 3, [hl]
	xor a
	ld hl, wHallOfFame
	ld bc, HOF_TEAM
	call FillMemory
	xor a
	ld [wUpdateSpritesEnabled], a
	ld [hTilesetType], a
	ld [W_SPRITEFLIPPED], a
	ld [wLetterPrintingDelayFlags], a ; no delay
	ld [wHoFMonOrPlayer], a ; mon
	inc a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld hl, wNumHoFTeams
	ld a, [hl]
	inc a
	jr z, .skipInc ; don't wrap around to 0
	inc [hl]
.skipInc
	ld a, $90
	ld [hWY], a
	ld c, $1f ; BANK(Music_HallOfFame)
	ld a, $ca ; MUSIC_HALL_OF_FAME
	call PlayMusic
	ld hl, wPartySpecies
	ld c, $ff
.partyMonLoop
	ld a, [hli]
	cp $ff
	jr z, .doneShowingParty
	inc c
	push hl
	push bc
	ld [wHoFMonSpecies], a
	ld a, c
	ld [wHoFPartyMonIndex], a
	ld hl, wPartyMon1Level
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a, [hl]
	ld [wHoFMonLevel], a
	call HoFShowMonOrPlayer
	call HoFDisplayAndRecordMonInfo
	ld c, 80
	call DelayFrames
	coord hl, 2, 13
	lb bc, $3, $e
	call TextBoxBorder
	coord hl, 4, 15
	ld de, HallOfFameText
	call PlaceString
	ld c, 180
	call DelayFrames
	call GBFadeOutToWhite
	pop bc
	pop hl
	jr .partyMonLoop
.doneShowingParty
	ld a, c
	inc a
	ld hl, wHallOfFame
	ld bc, HOF_MON
	call AddNTimes
	ld [hl], $ff
	callab SaveHallOfFameTeams ; useless since in same bank
	xor a
	ld [wHoFMonSpecies], a
	inc a
	ld [wHoFMonOrPlayer], a ; player
	call HoFShowMonOrPlayer
	call HoFDisplayPlayerStats
	call HoFFadeOutScreenAndMusic
	xor a
	ld [hWY], a
	ld hl, rLCDC
	res 3, [hl]
	ret

HallOfFameText: ; 70295 (1c:4295)
	db "HALL OF FAME@"

HoFShowMonOrPlayer: ; 702a2 (1c:42a2)
	call ClearScreen
	ld a, $d0
	ld [hSCY], a
	ld a, $c0
	ld [hSCX], a
	ld a, [wHoFMonSpecies]
	ld [wcf91], a
	ld [wd0b5], a
	ld [wBattleMonSpecies2], a
	ld [wWholeScreenPaletteMonSpecies], a
	ld a, [wHoFMonOrPlayer]
	and a
	jr z, .showMon
; show player
	call HoFLoadPlayerPics
	jr .next1
.showMon
	coord hl, 12, 5
	call GetMonHeader
	call LoadFrontSpriteByMonIndex
	predef LoadMonBackPic
.next1
	ld b, SET_PAL_POKEMON_WHOLE_SCREEN
	ld c, 0
	call RunPaletteCommand
	ld a, %11100100
	ld [rBGP], a
	call Func_3021
	ld c, $31 ; back pic
	call HoFLoadMonPlayerPicTileIDs
	ld d, $a0
	ld e, 4
	ld a, [wOnSGB]
	and a
	jr z, .next2
	sla e ; scroll more slowly on SGB
.next2
	call .ScrollPic ; scroll back pic left
	xor a
	ld [hSCY], a
	ld c, a ; front pic
	call HoFLoadMonPlayerPicTileIDs
	ld d, 0
	ld e, -4
; scroll front pic right

.ScrollPic
	call DelayFrame
	ld a, [hSCX]
	add e
	ld [hSCX], a
	cp d
	jr nz, .ScrollPic
	ret

HoFDisplayAndRecordMonInfo: ; 7030e (1c:430e)
	ld a, [wHoFPartyMonIndex]
	ld hl, wPartyMonNicks ; wPartyMonNicks
	call GetPartyMonName
	call HoFDisplayMonInfo
	ld a, [wHoFPartyMonIndex]
	ld [wWhichPokemon], a
	callab Func_fce18 ; 3f:4e18
	jr nc, .asm_70336
	ld e, $22
	callab Func_f0000
	jr .asm_7033c
.asm_70336
	ld a,[wHoFMonSpecies]
	call PlayCry
.asm_7033c
	jp HoFRecordMonInfo
	
Func_7033f: ; 7033f (1c:433f)
	call HoFDisplayMonInfo
	ld a,[wHoFMonSpecies]
	jp PlayCry
	
HoFDisplayMonInfo: ; 70348 (1c:4348)
	hlCoord 0, 2
	lb bc, 9, 10
	call TextBoxBorder
	coord hl, 2, 6
	ld de, HoFMonInfoText
	call PlaceString
	coord hl, 1, 4
	ld de, wcd6d
	call PlaceString
	ld a, [wHoFMonLevel]
	coord hl, 8, 7
	call PrintLevelCommon
	ld a, [wHoFMonSpecies]
	ld [wd0b5], a
	coord hl, 3, 9
	predef PrintMonType
	ret

HoFMonInfoText: ; 7037b (1c:437b)
	db   "LEVEL/"
	next "TYPE1/"
	next "TYPE2/@"

HoFLoadPlayerPics: ; 70390 (1c:433e)
	ld de, RedPicFront ; $6ede
	ld a, BANK(RedPicFront)
	call UncompressSpriteFromDE
	ld a,$0
	call SwitchSRAMBankAndLatchClockData
	ld hl, S_SPRITEBUFFER1
	ld de, S_SPRITEBUFFER0
	ld bc, $310
	call CopyData
	call PrepareRTCDataAndDisableSRAM
	ld de, vFrontPic
	call InterlaceMergeSpriteBuffers
	ld de, RedPicBack
	ld a, BANK(RedPicBack)
	call UncompressSpriteFromDE
	predef ScaleSpriteByTwo
	ld de, vBackPic
	call InterlaceMergeSpriteBuffers
	ld c, $1

HoFLoadMonPlayerPicTileIDs: ; 703c7 (1c:43c7)
	ld b, $0
	coord hl, 12, 5
	predef_jump CopyTileIDsFromList

HoFDisplayPlayerStats: ; 703d1 (1c:43d1)
	ld hl, wd747
	set 3, [hl]
	predef DisplayDexRating
	hlCoord 0, 4
	lb bc, 6, 10
	call TextBoxBorder
	hlCoord 5, 0
	lb bc, 2, 9
	call TextBoxBorder
	coord hl, 7, 2
	ld de, wPlayerName
	call PlaceString
	coord hl, 1, 6
	ld de, HoFPlayTimeText
	call PlaceString
	coord hl, 5, 7
	ld de, W_PLAYTIMEHOURS + 1
	lb bc, 1, 3
	call PrintNumber
	ld [hl], $6d
	inc hl
	ld de, W_PLAYTIMEMINUTES + 1
	lb bc, LEADING_ZEROES | 1, 2
	call PrintNumber
	coord hl, 1, 9
	ld de, HoFMoneyText
	call PlaceString
	coord hl, 4, 10
	ld de, wPlayerMoney
	ld c, $a3
	call PrintBCDNumber
	ld hl, DexSeenOwnedText
	call HoFPrintTextAndDelay
	ld hl, DexRatingText
	call HoFPrintTextAndDelay
	ld hl, wDexRatingText

HoFPrintTextAndDelay: ; 7043a (1c:443a)
	call PrintText
	ld c, 120
	jp DelayFrames

HoFPlayTimeText: ; 70442 (1c:4442)
	db "PLAY TIME@"

HoFMoneyText: ; 7044c (1c:444c)
	db "MONEY@"

DexSeenOwnedText: ; 70452 (1c:4452)
	TX_FAR _DexSeenOwnedText
	db "@"

DexRatingText: ; 70457 (1c:4457)
	TX_FAR _DexRatingText
	db "@"

HoFRecordMonInfo: ; 7045c (1c:445c)
	ld hl, wHallOfFame
	ld bc, HOF_MON
	ld a, [wHoFPartyMonIndex]
	call AddNTimes
	ld a, [wHoFMonSpecies]
	ld [hli], a
	ld a, [wHoFMonLevel]
	ld [hli], a
	ld e, l
	ld d, h
	ld hl, wcd6d
	ld bc, NAME_LENGTH
	jp CopyData

HoFFadeOutScreenAndMusic: ; 7047b (1c:447b)
	ld a, 10
	ld [wAudioFadeOutCounterReloadValue], a
	ld [wAudioFadeOutCounter], a
	ld a, $ff
	ld [wAudioFadeOutControl], a
	jp GBFadeOutToWhite
