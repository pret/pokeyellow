AnimateHallOfFame: ; 701c6 (1c:41c6)
	call Func_7047b
	call ClearScreen
	ld c, 100
	call DelayFrames
	call LoadFontTilePatterns
	call LoadTextBoxTilePatterns
	call DisableLCD
	ld hl,vBGMap0
	ld bc, $800
	ld a, $7f
	call FillMemory
	call EnableLCD
	ld hl, rLCDC ; $ff40
	set 3, [hl]
	xor a
	ld hl, wHallOfFame
	ld bc, HOF_TEAM
	call FillMemory
	xor a
	ld [wUpdateSpritesEnabled], a
	ld [hTilesetType], a
	ld [W_SPRITEFLIPPED], a
	ld [wd358], a
	ld [wTrainerScreenY], a
	inc a
	ld [H_AUTOBGTRANSFERENABLED], a ; $ffba
	ld hl, wd5a2
	ld a, [hl]
	inc a
	jr z, .asm_70211
	inc [hl]
.asm_70211
	ld a, $90
	ld [hWY], a
	ld c, $1f ; BANK(Music_HallOfFame)
	ld a, $ca ; MUSIC_HALL_OF_FAME
	call PlayMusic
	ld hl, wPartySpecies
	ld c, $ff
.asm_70221
	ld a, [hli]
	cp $ff
	jr z, .asm_70266
	inc c
	push hl
	push bc
	ld [wWhichTrade], a ; wWhichTrade
	ld a, c
	ld [wTrainerEngageDistance], a
	ld hl, wPartyMon1Level ; wPartyMon1Level
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a, [hl]
	ld [wTrainerFacingDirection], a
	call Func_702a2
	call Func_7030e
	ld c, $50
	call DelayFrames
	hlCoord 2, 13
	ld bc, $30e
	call TextBoxBorder
	hlCoord 4, 15
	ld de, HallOfFameText
	call PlaceString
	ld c, 180
	call DelayFrames
	call GBFadeOutToWhite
	pop bc
	pop hl
	jr .asm_70221
.asm_70266
	ld a, c
	inc a
	ld hl, wHallOfFame
	ld bc, HOF_MON
	call AddNTimes
	ld [hl], $ff
	callab SaveHallOfFameTeams ; useless since in same bank
	xor a
	ld [wWhichTrade], a ; wWhichTrade
	inc a
	ld [wTrainerScreenY], a
	call Func_702a2
	call Func_703d1
	call Func_7047b
	xor a
	ld [hWY], a
	ld hl, rLCDC ; $ff40
	res 3, [hl]
	ret

HallOfFameText: ; 70295 (1c:4295)
	db "HALL OF FAME@"

Func_702a2: ; 702a2 (1c:42a2)
	call ClearScreen
	ld a, $d0
	ld [hSCY], a
	ld a, $c0
	ld [hSCX], a
	ld a, [wWhichTrade] ; wWhichTrade
	ld [wcf91], a
	ld [wd0b5], a
	ld [wBattleMonSpecies2], a
	ld [wcf1d], a
	ld a, [wTrainerScreenY]
	and a
	jr z, .asm_702c7
	call Func_70390
	jr .asm_702d5
.asm_702c7
	hlCoord 12, 5
	call GetMonHeader
	call LoadFrontSpriteByMonIndex
	predef LoadMonBackPic
.asm_702d5
	ld b, $b
	ld c, $0
	call GoPAL_SET
	ld a, $e4
	ld [rBGP], a ; $ff47
	call Func_3021
	ld c, $31
	call Func_703c7
	ld d, $a0
	ld e, $4
	ld a, [wOnSGB]
	and a
	jr z, .asm_702f4
	sla e
.asm_702f4
	call .asm_70302
	xor a
	ld [hSCY], a
	ld c, a
	call Func_703c7
	ld d, $0
	ld e, $fc
.asm_70302
	call DelayFrame
	ld a, [hSCX]
	add e
	ld [hSCX], a
	cp d
	jr nz, .asm_70302
	ret

Func_7030e: ; 7030e (1c:430e)
	ld a, [wTrainerEngageDistance]
	ld hl, wPartyMonNicks ; wPartyMonNicks
	call GetPartyMonName
	call Func_70348
	ld a, [wTrainerEngageDistance]
	ld [wWhichPokemon], a
	callab Func_fce18 ; 3f:4e18
	jr nc, .asm_70336
	ld e,$22
	callab Func_f0000
	jr .asm_7033c
.asm_70336
	ld a,[wWhichTrade]
	call PlayCry
.asm_7033c
	jp Func_7045c
	
Func_7033f: ; 7033f (1c:433f)
	call Func_70348
	ld a,[wWhichTrade]
	jp PlayCry
	
Func_70348: ; 70348 (1c:4348)
	hlCoord 0, 2
	ld bc, $90a
	call TextBoxBorder
	hlCoord 2, 6
	ld de, HoFMonInfoText
	call PlaceString
	hlCoord 1, 4
	ld de, wcd6d
	call PlaceString
	ld a, [wTrainerFacingDirection]
	hlCoord 8, 7
	call PrintLevelCommon
	ld a, [wWhichTrade] ; wWhichTrade
	ld [wd0b5], a
	hlCoord 3, 9
	predef PrintMonType
	ret
	;ld a, [wWhichTrade] ; wWhichTrade
	;jp PlayCry

HoFMonInfoText: ; 7037b (1c:437b)
	db   "LEVEL/"
	next "TYPE1/"
	next "TYPE2/@"

Func_70390: ; 70390 (1c:433e)
	ld de, RedPicFront ; $6ede
	ld a, BANK(RedPicFront)
	call UncompressSpriteFromDE
	ld a,$0
	call SwitchSRAMBankAndLatchClockData
	ld hl, S_SPRITEBUFFER1
	ld de, $a000
	ld bc, $310
	call CopyData
	call PrepareRTCDataAndDisableSRAM
	ld de, vFrontPic
	call InterlaceMergeSpriteBuffers
	ld de, RedPicBack ; $7e0a
	ld a, BANK(RedPicBack)
	call UncompressSpriteFromDE
	predef ScaleSpriteByTwo
	ld de, vBackPic
	call InterlaceMergeSpriteBuffers
	ld c, $1

Func_703c7: ; 703c7 (1c:43c7)
	ld b, $0
	hlCoord 12, 5
	predef_jump CopyTileIDsFromList

Func_703d1: ; 703d1 (1c:43d1)
	ld hl, wd747
	set 3, [hl]
	predef DisplayDexRating
	hlCoord 0, 4
	ld bc, $60a
	call TextBoxBorder
	hlCoord 5, 0
	ld bc, $209
	call TextBoxBorder
	hlCoord 7, 2
	ld de, wPlayerName ; wd158
	call PlaceString
	hlCoord 1, 6
	ld de, HoFPlayTimeText
	call PlaceString
	hlCoord 5, 7
	ld de, W_PLAYTIMEHOURS + 1
	ld bc, $103
	call PrintNumber
	ld [hl], $6d
	inc hl
	ld de, W_PLAYTIMEMINUTES + 1
	ld bc, $8102
	call PrintNumber
	hlCoord 1, 9
	ld de, HoFMoneyText
	call PlaceString
	hlCoord 4, 10
	ld de, wPlayerMoney ; wPlayerMoney
	ld c, $a3
	call PrintBCDNumber
	ld hl, DexSeenOwnedText
	call Func_7043a
	ld hl, DexRatingText
	call Func_7043a
	ld hl, wcc5d

Func_7043a: ; 7043a (1c:443a)
	call PrintText
	ld c, $78
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

Func_7045c: ; 7045c (1c:445c)
	ld hl, wHallOfFame
	ld bc, HOF_MON
	ld a, [wTrainerEngageDistance]
	call AddNTimes
	ld a, [wWhichTrade] ; wWhichTrade
	ld [hli], a
	ld a, [wTrainerFacingDirection]
	ld [hli], a
	ld e, l
	ld d, h
	ld hl, wcd6d
	ld bc, $b
	jp CopyData

Func_7047b: ; 7047b (1c:447b)
	ld a, $a
	ld [wcfc8], a
	ld [wcfc9], a
	ld a, $ff
	ld [wMusicHeaderPointer], a
	jp GBFadeOutToWhite
