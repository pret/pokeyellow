DebugMenu:
IF DEF(_DEBUG)
	call ClearScreen

	ld hl, DebugPlayerName
	ld de, wPlayerName
	ld bc, NAME_LENGTH
	call CopyData

	ld hl, DebugRivalName
	ld de, wRivalName
	ld bc, NAME_LENGTH
	call CopyData

	call LoadFontTilePatterns
	call LoadHpBarAndStatusTilePatterns
	call ClearSprites
	call RunDefaultPaletteCommand

	hlcoord 5, 6
	lb bc, 3, 9
	call TextBoxBorder

	hlcoord 7, 7
	ld de, DebugMenuOptions
	call PlaceString

	ld a, 3 ; medium speed
	ld [wOptions], a

	ld a, A_BUTTON | B_BUTTON | START
	ld [wMenuWatchedKeys], a
	xor a
	ld [wMenuJoypadPollCount], a
	inc a
	ld [wMaxMenuItem], a
	ld a, 7
	ld [wTopMenuItemY], a
	dec a
	ld [wTopMenuItemX], a
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld [wMenuWatchMovingOutOfBounds], a

	call HandleMenuInput
	bit BIT_B_BUTTON, a
	ld hl, DisplayTitleScreen
	ret nz

	ld a, [wCurrentMenuItem]
	and a ; FIGHT?
	jp z, TestBattle

	; DEBUG
	ld hl, wd732
	set 1, [hl]
	ld hl, StartNewGameDebug
	ret

DebugPlayerName:
	db "Tom@"

DebugRivalName:
	db "Juerry@"

DebugMenuOptions:
	db   "FIGHT"
	next "DEBUG@"

TestBattle:
	ld a, 1
	ldh [hJoy7], a

	; Don't mess around
	; with obedience.
	ld a, 1 << BIT_EARTHBADGE
	ld [wObtainedBadges], a

	ld hl, wFlags_D733
	set BIT_TEST_BATTLE, [hl]

	ld hl, wNumBagItems
	ld de, Data_feded
.loop
	ld a, [de]
	cp -1
	jr z, .done
	inc de
	ld [wcf91], a
	ld a, [de]
	inc de
	ld [wItemQuantity], a
	push de
	call AddItemToInventory
	pop de
	jr .loop
.done
	call LoadHpBarAndStatusTilePatterns
	call ClearScreen
	call ClearSprites
	hlcoord 0, 0
	lb bc, 1, 18
	call TextBoxBorder
	hlcoord 6, 1
	ld de, Text_fed18
	call PlaceString
	hlcoord 4, 4
	ld de, Text_fed21
	call PlaceString
	hlcoord 1, 6
	ld de, Text_fed30
	call PlaceString
	xor a
	ld [wWhichPokemon], a
	ld [wEnemyMon], a
	ld [wEnemyMonLevel], a
	ld [wTrainerClass], a
	ld [wGrassMons + 1], a
	ld b, a
	ld c, a
	ld hl, wEnemyPartyMons
	call Func_fe809
	ld hl, wPartyCount
	call Func_fe809
	ld de, wPartySpecies
	hlcoord 4, 6
	; fallthrough
Func_fe7ca:
	push hl
	push bc
	dec hl
	ld a, "▶"
	ld [hl], a
	ld bc, 11
	add hl, bc
	ld a, " "
	ld [hl], a
	push de
	pop de
	pop bc
	pop hl
	; fallthrough
Func_fe7db:
	push bc
	push de
	call JoypadLowSensitivity
	pop de
	pop bc
	ldh a, [hJoy5]
	bit BIT_A_BUTTON, a
	jp nz, Func_fe812
	bit BIT_B_BUTTON, a
	jp nz, Func_fe850
	bit BIT_SELECT, a
	jp nz, DebugMenu
	bit BIT_START, a
	jp nz, Func_fe97f
	bit BIT_D_RIGHT, a
	jp nz, Func_fe8a1
	bit BIT_D_UP, a
	jp nz, Func_fe85d
	bit BIT_D_DOWN, a
	jp nz, Func_fe880
	jr Func_fe7db

Func_fe809:
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

Func_fe812:
	inc b
	ld a, b
	cp NUM_POKEMON_INDEXES + 1
	jr c, Func_fe81a
	xor a
	ld b, a
	; fallthrough
Func_fe81a:
	ld [de], a
	ld [wd11e], a
	push bc
	push hl
	push de
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	inc hl
	push hl
	ld de, Text_fed9c
	call PlaceString
	ld bc, hSavedMapTextPtr
	add hl, bc
	ld de, Text_fed9c
	call PlaceString
	pop hl
	ld a, [wd11e]
	and a
	jr nz, .asm_fe845
	ld de, Text_feda2
	jr .asm_fe848
.asm_fe845
	call GetMonName
.asm_fe848
	call PlaceString
	pop de
	pop hl
	pop bc
	jr Func_fe7db

Func_fe850:
	dec b
	ld a, b
	cp OPP_ID_OFFSET + 1
	jp c, Func_fe81a
	ld a, NUM_POKEMON_INDEXES
	ld b, a
	jp Func_fe81a

Func_fe85d:
	ld a, [wWhichPokemon]
	dec a
	cp -1
	jp z, Func_fe7db
	ld [wWhichPokemon], a
	dec de
	dec hl
	ld a, " "
	ld [hl], a
	push bc
	ld bc, hMovingBGTilesCounter1
	add hl, bc
	pop bc
	ld a, "▶"
	ld [hl], a
	inc hl
	push hl
	call Func_fe964
	pop hl
	jp Func_fe7db

Func_fe880:
	ld a, [wWhichPokemon]
	inc a
	cp 6
	jp nc, Func_fe7db
	ld [wWhichPokemon], a
	inc de
	dec hl
	ld a, " "
	ld [hl], a
	ld bc, SCREEN_WIDTH * 2
	add hl, bc
	ld a, "▶"
	ld [hl], a
	inc hl
	push hl
	call Func_fe964
	pop hl
	jp Func_fe7db

Func_fe8a1:
	push hl
	push bc
	dec hl
	ld a, " "
	ld [hl], a
	ld bc, 11
	add hl, bc
	ld a, "▶"
	ld [hl], a
	pop bc
	pop hl
	; fallthrough
Func_fe8b0:
	push bc
	push de
	call JoypadLowSensitivity
	pop de
	pop bc
	ldh a, [hJoy5]
	bit BIT_A_BUTTON, a
	jp nz, Func_fe8d9
	bit BIT_B_BUTTON, a
	jp nz, Func_fe902
	bit BIT_START, a
	jp nz, Func_fe97f
	bit BIT_D_LEFT, a
	jp nz, Func_fe7ca
	bit BIT_D_UP, a
	jp nz, Func_fe912
	bit BIT_D_DOWN, a
	jp nz, Func_fe93b
	jr Func_fe8b0

Func_fe8d9:
	inc c
	ld a, c
	cp MAX_LEVEL + 1
	jr c, Func_fe8e2
	ld a, 1
	ld c, a
	; fallthrough
Func_fe8e2:
	ld a, [wWhichPokemon]
	push de
	ld de, wEnemyPartyMons
	add e
	ld e, a
	jr nc, .asm_fe8ee
	inc d
.asm_fe8ee
	ld a, c
	ld [de], a
	push bc
	push hl
	ld bc, 11
	add hl, bc
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	pop hl
	pop bc
	pop de
	jp Func_fe8b0

Func_fe902:
	dec c
	ld a, c
	cp MAX_LEVEL + 1
	jr nc, .asm_fe90c
	and a
	jp nz, Func_fe8e2
.asm_fe90c
	ld a, MAX_LEVEL
	ld c, a
	jp Func_fe8e2

Func_fe912:
	ld a, [wWhichPokemon]
	dec a
	cp -1
	jp z, Func_fe8b0
	ld [wWhichPokemon], a
	dec de
	push hl
	ld bc, 10
	add hl, bc
	ld a, " "
	ld [hl], a
	pop hl
	ld bc, hMovingBGTilesCounter1
	add hl, bc
	push hl
	ld bc, 10
	add hl, bc
	ld a, "▶"
	ld [hl], a
	call Func_fe964
	pop hl
	jp Func_fe8b0

Func_fe93b:
	ld a, [wWhichPokemon]
	inc a
	cp 6
	jp nc, Func_fe8b0
	ld [wWhichPokemon], a
	inc de
	push hl
	ld bc, 10
	add hl, bc
	ld a, " "
	ld [hl], a
	pop hl
	ld bc, SCREEN_WIDTH * 2
	add hl, bc
	push hl
	ld bc, 10
	add hl, bc
	ld a, "▶"
	ld [hl], a
	call Func_fe964
	pop hl
	jp Func_fe8b0

Func_fe964:
	ld hl, wPartySpecies
	ld a, [wWhichPokemon]
	add l
	ld l, a
	jr nc, .asm_fe96f
	inc h
.asm_fe96f
	ld a, [hl]
	ld b, a
	ld hl, wEnemyPartyMons
	ld a, [wWhichPokemon]
	add l
	ld l, a
	jr nc, .asm_fe97c
	inc h
.asm_fe97c
	ld a, [hl]
	ld c, a
	ret

Func_fe97f:
	ld hl, wPartyCount
	ld de, wEnemyPartyCount
	xor a
	ld [hl], a
	inc hl
	ld a, [hli]
	ld b, a
	ld c, 6
	xor a
	ld [wIsInBattle], a
.asm_fe990
	ld a, b
	ld [wcf91], a
	ld a, [hl]
	ld b, a
	inc de
	ld a, [de]
	and a
	jr z, .asm_fe9ab
	ld [wCurEnemyLVL], a
	xor a
	ld [wMonDataLocation], a
	ld a, [wcf91]
	and a
	jr z, .asm_fe9ab
	call AddPartyMon
.asm_fe9ab
	inc hl
	dec c
	jr nz, .asm_fe990
	ld b, 7
	ld hl, wPartySpecies
	ld de, wEnemyPartyCount
.asm_fe9b7
	inc de
	dec b
	jp z, TestBattle
	ld a, [hli]
	and a
	jr z, .asm_fe9b7
	ld a, [de]
	and a
	jr z, .asm_fe9b7
	hlcoord 0, 3
	lb bc, 15, 20
	call ClearScreenArea
	hlcoord 0, 3
	lb bc, 15, 20
	call ClearScreenArea
	hlcoord 0, 3
	lb bc, 15, 20
	call ClearScreenArea
	ld c, 20
	call DelayFrames
	ld a, 1
	ld [wIsInBattle], a
	ld de, Text_feda8
	ld a, [wGrassMons + 1]
	cp MAX_LEVEL + 1
	jr c, .asm_fe9fb
	ld a, 2
	ld [wIsInBattle], a
	ld de, Text_fedb2
.asm_fe9fb
	hlcoord 1, 4
	call PlaceString
	hlcoord 1, 6
	ld de, Text_fedbc
	call PlaceString
	ld a, [wEnemyMon]
	ld b, a
	ld a, [wIsInBattle]
	dec a
	jr z, .asm_fea40
	ld a, [wTrainerClass]
	ld [wd11e], a
	ld b, a
	ld de, wd11e
	hlcoord 1, 8
	push bc
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	hlcoord 5, 8
	ld de, Text_fede2
	call PlaceString
	call GetTrainerName
	hlcoord 5, 8
	ld de, wTrainerName
	call PlaceString
	pop bc
	jr .asm_fea65
.asm_fea40
	ld a, b
	and a
	jr z, .asm_fea65
	ld de, wd11e
	ld [de], a
	hlcoord 1, 8
	push bc
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	hlcoord 5, 8
	ld de, Text_fede2
	call PlaceString
	call GetMonName
	hlcoord 5, 8
	call PlaceString
	pop bc
.asm_fea65
	ld a, [wEnemyMonLevel]
	ld c, a
	ld de, wd11e
	ld [de], a
	hlcoord 16, 8
	push bc
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	pop bc
	; fallthrough
Func_fea78:
	ld a, " "
	ldcoord_a 0, 8
	ldcoord_a 15, 8
	ld a, "▶"
	ldcoord_a 0, 4
	; fallthrough
Func_fea85:
	push bc
	call JoypadLowSensitivity
	pop bc
	ldh a, [hJoy5]
	bit BIT_A_BUTTON, a
	jp nz, Func_fea9d
	bit BIT_START, a
	jp nz, Func_fec10
	bit BIT_D_DOWN, a
	jp nz, Func_feae4
	jr Func_fea85

Func_fea9d:
	hlcoord 1, 8
	ld de, Text_fedcf
	call PlaceString
	hlcoord 5, 7
	ld de, Text_fede2
	call PlaceString
	xor a
	ld b, a
	ld c, a
	ld a, [wIsInBattle]
	dec a
	jr nz, .asm_feace
	ld a, 2
	ld [wIsInBattle], a
	ld a, " "
	ldcoord_a 4, 3
	hlcoord 1, 4
	ld de, Text_fedb2
	call PlaceString
	jp Func_fea85
.asm_feace
	ld a, 1
	ld [wIsInBattle], a
	ld a, " "
	ldcoord_a 1, 3
	hlcoord 1, 4
	ld de, Text_feda8
	call PlaceString
	jp Func_fea85

Func_feae4:
	ld a, "▶"
	ldcoord_a 0, 8
	ld a, " "
	ldcoord_a 15, 8
	ldcoord_a 0, 4
	; fallthrough
Func_feaf1:
	push bc
	call JoypadLowSensitivity
	pop bc
	ldh a, [hJoy5]
	bit BIT_A_BUTTON, a
	jp nz, Func_feb13
	bit BIT_B_BUTTON, a
	jp nz, Func_feb82
	bit BIT_START, a
	jp nz, Func_fec10
	bit BIT_D_RIGHT, a
	jp nz, Func_febba
	bit BIT_D_UP, a
	jp nz, Func_fea78
	jr Func_feaf1

Func_feb13:
	push bc
	hlcoord 5, 7
	ld de, Text_fede2
	call PlaceString
	hlcoord 5, 8
	ld de, Text_fede2
	call PlaceString
	pop bc
	ld a, [wIsInBattle]
	dec a
	jr z, Func_feb35.asm_feb5c
	inc b
	ld a, b
	cp 48
	jr c, Func_feb35
	ld b, 1
	; fallthrough
Func_feb35:
	ld a, b
	ld [wd11e], a
	ld de, wd11e
	hlcoord 1, 8
	push bc
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	ld a, [wd11e]
	ld [wTrainerClass], a
	call GetTrainerName
	hlcoord 5, 8
	ld de, wTrainerName
	call PlaceString
	pop bc
	jp Func_feaf1
.asm_feb5c
	inc b
	ld a, b
	cp NUM_POKEMON_INDEXES + 1
	jr c, Func_feb64
	ld b, 1
	; fallthrough
Func_feb64:
	ld a, b
	ld [wd11e], a
	ld de, wd11e
	hlcoord 1, 8
	push bc
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	call GetMonName
	hlcoord 5, 8
	call PlaceString
	pop bc
	jp Func_feaf1

Func_feb82:
	push bc
	hlcoord 5, 7
	ld de, Text_fede2
	call PlaceString
	hlcoord 5, 8
	ld de, Text_fede2
	call PlaceString
	pop bc
	ld a, [wIsInBattle]
	dec a
	jr z, .asm_febab
	dec b
	ld a, b
	cp 48
	jr nc, .asm_feba6
	and a
	jp nz, Func_feb35
.asm_feba6
	ld b, 47
	jp Func_feb35
.asm_febab
	dec b
	ld a, b
	cp NUM_POKEMON_INDEXES + 1
	jr nc, .asm_febb5
	and a
	jp nz, Func_feb64
.asm_febb5
	ld b, NUM_POKEMON_INDEXES
	jp Func_feb64

Func_febba:
	ld a, " "
	ldcoord_a 0, 8
	ld a, "▶"
	ldcoord_a 15, 8
	; fallthrough
Func_febc4:
	push bc
	call JoypadLowSensitivity
	pop bc
	ldh a, [hJoy5]
	bit BIT_A_BUTTON, a
	jp nz, Func_febe6
	bit BIT_B_BUTTON, a
	jp nz, Func_fec01
	bit BIT_START, a
	jp nz, Func_fec10
	bit BIT_D_LEFT, a
	jp nz, Func_feae4
	bit BIT_D_UP, a
	jp nz, Func_fea78
	jr Func_febc4

Func_febe6:
	inc c
	ld a, c
	cp MAX_LEVEL + 1
	jr c, Func_febee
	ld c, 1
Func_febee:
	hlcoord 16, 8
	ld a, c
	ld de, wCurEnemyLVL
	ld [de], a
	push bc
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	pop bc
	jp Func_febc4

Func_fec01:
	dec c
	ld a, c
	cp MAX_LEVEL + 1
	jr nc, .asm_fec0b
	and a
	jp nz, Func_febee
.asm_fec0b
	ld c, MAX_LEVEL
	jp Func_febee

Func_fec10:
	ld a, b
	and a
	jp z, Func_fea78
	ld a, c
	and a
	jp z, Func_fea78
	ld a, [wIsInBattle]
	dec a
	jr z, .asm_fec28
	ld a, b
	add OPP_ID_OFFSET
	ld b, a
	ld a, c
	ld [wTrainerNo], a
.asm_fec28
	ld a, c
	ld [wCurEnemyLVL], a
	ld a, b
	ld [wCurOpponent], a
	xor a
	ld [wd72d], a
	predef InitOpponent
	xor a
	ld [wNumRunAttempts], a
	ld hl, wPlayerStatsToDouble
	ld bc, wEnemyStatsToDouble - wPlayerStatsToDouble
	call FillMemory
	ld hl, wEnemyStatsToDouble
	ld bc, wPlayerNumAttacksLeft - wEnemyStatsToDouble
	call FillMemory
	call LoadFontTilePatterns
	call ClearScreen
	call ClearSprites
	ld a, %11100100
	ldh [rBGP], a
	ldh [rOBP0], a
	ldh [rOBP1], a
	call UpdateGBCPal_BGP
	call UpdateGBCPal_OBP0
	call UpdateGBCPal_OBP1
	hlcoord 0, 0
	lb bc, 1, 18
	call TextBoxBorder
	hlcoord 6, 1
	ld de, Text_fed18
	call PlaceString
	hlcoord 4, 4
	ld de, Text_fed21
	call PlaceString
	hlcoord 1, 6
	ld de, Text_fed30
	call PlaceString
	ld de, wPartyCount
	xor a
	ld [de], a
	ld [wWhichPokemon], a
	inc de
	hlcoord 4, 6
	push de
	push hl
	; fallthrough
Func_fec9b:
	ld a, [wWhichPokemon]
	ld de, wPartySpecies
	add e
	ld e, a
	jr nc, .asm_feca6
	inc d
.asm_feca6
	ld a, [de]
	cp -1
	jp z, Func_fed01
	ld [wd11e], a
	push hl
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	inc hl
	ld de, Text_fed9c
	call PlaceString
	call GetMonName
	call PlaceString
	pop hl
	push hl
	ld bc, 11
	add hl, bc
	push hl
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1Level
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld d, h
	ld e, l
	ld a, [de]
	ld [wCurEnemyLVL], a
	pop hl
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	ld a, [wWhichPokemon]
	ld de, wEnemyPartyMons
	add e
	ld e, a
	jr nc, .asm_fecee
	inc d
.asm_fecee
	ld a, [wCurEnemyLVL]
	ld [de], a
	pop hl
	ld a, [wWhichPokemon]
	inc a
	ld [wWhichPokemon], a
	ld bc, SCREEN_WIDTH * 2
	add hl, bc
	jp Func_fec9b

Func_fed01:
	pop hl
	pop de
	ld a, [wPartyMon1]
	ld b, a
	ld a, [wPartyMon1Level]
	ld c, a
	xor a
	ld [wWhichPokemon], a
	jp Func_fe7ca

Text_fed12:
	db   "けんしろう@"

Text_fed18:
	db   "テスト ファイト@"

Text_fed21:
	db   "№．  なまえ    レべル@"

Text_fed30:
	db   "１．▶０００ ーーーーー  ０００"
	next "２． ０００ ーーーーー  ０００"
	next "３． ０００ ーーーーー  ０００"
	next "４． ０００ ーーーーー  ０００"
	next "５． ０００ ーーーーー  ０００"
	next "６． ０００ ーーーーー  ０００@"

Text_fed9c:
	db   "     @"

Text_feda2:
	db   "ーーーーー@"

Text_feda8:
	db   "ワイルドモンスター@"

Text_fedb2:
	db   "ディーラー    @"

Text_fedbc:
	db   "№．  なまえ        レべル"
	next ""
Text_fedcf:
	db   "０００ ーーーーーーーーーー ０００@"

Text_fede2:
	db   "          @"

Data_feded:
	db GREAT_BALL, 99
	db POKE_BALL, 99
	db ANTIDOTE, 99
	db FULL_RESTORE, 99
	db MAX_POTION, 99
	db HYPER_POTION, 99
	db SUPER_POTION, 99
	db POTION, 99
	db -1 ; end

Func_fedfe:
	ld a, [wNumInBox]
	cp 30
	jp nc, Func_ff1ad
	call ClearScreen
	call UpdateSprites
	ld a, [wLetterPrintingDelayFlags]
	push af
	xor a
	ld [wLetterPrintingDelayFlags], a
	ld hl, wEnemyMonOT
	ld [hli], a
	ld [hli], a
	ld [hl], a
	inc a
	ldh [hJoy7], a
	ld [wcf91], a
	ld [wCurEnemyLVL], a
	; fallthrough
Func_fee23:
	hlcoord 0, 3
	ld [hl], " "
	hlcoord 0, 1
	ld [hl], "▶"
	call Func_fee60
.asm_fee30
	call DelayFrame
	call JoypadLowSensitivity
	ldh a, [hJoy5]
	bit BIT_A_BUTTON, a
	jp nz, Func_fee49
	bit BIT_B_BUTTON, a
	jp nz, Func_fee56
	bit BIT_D_DOWN, a
	jp nz, Func_fee96
	jr .asm_fee30

Func_fee49:
	ld hl, wcf91
	inc [hl]
	ld a, [hl]
	cp NUM_POKEMON + 1
	jr c, Func_fee23
	ld [hl], DEX_BULBASAUR
	jr Func_fee23

Func_fee56:
	ld hl, wcf91
	dec [hl]
	jr nz, Func_fee23
	ld [hl], DEX_MEW
	jr Func_fee23

Func_fee60:
	hlcoord 1, 0
	lb bc, 2, 9
	call ClearScreenArea
	hlcoord 1, 1
	ld de, wcf91
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	inc hl
	push hl
	ld a, [wcf91]
	ld [wd11e], a
	callfar PokedexToIndex
	call GetMonName
	pop hl
	call PlaceString
	ld a, [wd11e]
	ld [wd0b5], a
	call GetMonHeader
	ret

Func_fee96:
	hlcoord 0, 1
	ld [hl], " "
	hlcoord 0, 3
	ld [hl], "▶"
	hlcoord 0, 5
	ld [hl], " "
	call Func_feee2
	call Func_feeef
.asm_feeab
	call DelayFrame
	call JoypadLowSensitivity
	ld hl, wCurEnemyLVL
	ldh a, [hJoy5]
	bit BIT_A_BUTTON, a
	jp nz, Func_feed1
	bit BIT_B_BUTTON, a
	jp nz, Func_feedb
	bit BIT_START, a
	jp nz, Func_ff12c
	bit BIT_D_UP, a
	jp nz, Func_fee23
	bit BIT_D_DOWN, a
	jp nz, Func_fef60
	jr .asm_feeab

Func_feed1:
	inc [hl]
	ld a, [hl]
	cp MAX_LEVEL + 1
	jr c, Func_fee96
	ld [hl], 1
	jr Func_fee96

Func_feedb:
	dec [hl]
	jr nz, Func_fee96
	ld [hl], MAX_LEVEL
	jr Func_fee96

Func_feee2:
	hlcoord 1, 3
	ld de, wCurEnemyLVL
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	ret

Func_feeef:
	hlcoord 1, 4
	lb bc, 8, 11
	call ClearScreenArea
	ld a, [wcf91]
	push af
	ld [wd11e], a
	ld hl, BaseStats + 15
	dec a
	ld bc, MonBaseStatsEnd - MonBaseStats
	call AddNTimes
	ld de, wMoves
	ld bc, NUM_MOVES
	ld a, BANK(BaseStats)
	call FarCopyData
	callfar PokedexToIndex
	ld a, [wd11e]
	ld [wcf91], a
	xor a
	ld [wChangeMonPicEnemyTurnSpecies], a
	ld de, wMoves
	predef WriteMonMoves
	hlcoord 1, 5
	ld de, wMoves
	ld b, NUM_MOVES
.asm_fef36
	ld a, [de]
	inc de
	and a
	jr z, .asm_fef5b
	push de
	push bc
	push hl
	ld [wd11e], a
	ld de, wd11e
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	inc hl
	call GetMoveName
	call PlaceString
	pop hl
	ld bc, SCREEN_WIDTH * 2
	add hl, bc
	pop bc
	pop de
	dec b
	jr nz, .asm_fef36
.asm_fef5b
	pop af
	ld [wcf91], a
	ret

Func_fef60:
	ld de, wMoves
	hlcoord 0, 5
	ld b, 1
	; fallthrough
Func_fef68:
	call Func_fefc5
.asm_fef6b
	call DelayFrame
	push de
	push bc
	call JoypadLowSensitivity
	pop bc
	pop de
	ldh a, [hJoy5]
	bit BIT_A_BUTTON, a
	jp nz, Func_fef92
	bit BIT_B_BUTTON, a
	jp nz, Func_fef9e
	bit BIT_START, a
	jp nz, Func_ff12c
	bit BIT_D_UP, a
	jp nz, Func_fefa8
	bit BIT_D_DOWN, a
	jp nz, Func_fefb5
	jr .asm_fef6b

Func_fef92:
	ld a, [de]
	inc a
	ld [de], a
	cp NUM_ATTACKS + 1
	jr c, Func_fef68
	ld a, 1
	ld [de], a
	jr Func_fef68

Func_fef9e:
	ld a, [de]
	dec a
	ld [de], a
	jr nz, Func_fef68
	ld a, NUM_ATTACKS
	ld [de], a
	jr Func_fef68

Func_fefa8:
	dec de
	dec b
	jp z, Func_fee96
	push bc
	ld bc, hMovingBGTilesCounter1
	add hl, bc
	pop bc
	jr Func_fef68

Func_fefb5:
	inc de
	inc b
	ld a, b
	cp 5
	jp z, Func_ff03b
	push bc
	ld bc, SCREEN_WIDTH * 2
	add hl, bc
	pop bc
	jr Func_fef68

Func_fefc5:
	push hl
	push de
	push bc
	push hl
	push de
	ld bc, hSpriteMapYCoord
	add hl, bc
	lb bc, 2, 11
	call ClearScreenArea
	pop de
	pop hl
	push hl
	ld [hl], "▶"
	ld bc, hMovingBGTilesCounter1
	add hl, bc
	ld [hl], " "
	ld bc, SCREEN_WIDTH * 4
	add hl, bc
	ld [hl], " "
	pop hl
	inc hl
	ld a, [de]
	ld de, wd11e
	ld [de], a
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	ld a, [wd11e]
	and a
	jr z, .asm_ff002
	call Func_ff006
	inc hl
	call GetMoveName
	call PlaceString
.asm_ff002
	pop bc
	pop de
	pop hl
	ret

Func_ff006:
	ld a, [wcf91]
	push af
	ld a, [wd11e]
	push af
	push hl
	ld a, [wcf91]
	ld [wd11e], a
	callfar PokedexToIndex
	ld a, [wd11e]
	ld [wcf91], a
	pop hl
	pop af
	ld [wd11e], a
	push hl
	callfar Func_3b079
	pop hl
	jr c, .asm_ff036
	ld [hl], "×"
.asm_ff036
	pop af
	ld [wcf91], a
	ret

Func_ff03b:
	ld de, wEnemyMonOT
	hlcoord 0, 13
	ld b, 1
	; fallthrough
Func_ff043:
	call Func_ff09e
.asm_ff046
	call DelayFrame
	push de
	push bc
	call JoypadLowSensitivity
	pop bc
	pop de
	ldh a, [hJoy5]
	bit BIT_A_BUTTON, a
	jp nz, Func_ff06d
	bit BIT_B_BUTTON, a
	jp nz, Func_ff072
	bit BIT_START, a
	jp nz, Func_ff12c
	bit BIT_D_UP, a
	jp nz, Func_ff077
	bit BIT_D_DOWN, a
	jp nz, Func_ff08f
	jr .asm_ff046

Func_ff06d:
	ld a, [de]
	inc a
	ld [de], a
	jr Func_ff043

Func_ff072:
	ld a, [de]
	dec a
	ld [de], a
	jr Func_ff043

Func_ff077:
	dec de
	dec b
	jp z, Func_ff084
	push bc
	ld bc, hMovingBGTilesCounter1
	add hl, bc
	pop bc
	jr Func_ff043

Func_ff084:
	ld de, wMoves + 3
	hlcoord 0, 11
	ld b, NUM_MOVES
	jp Func_fef68

Func_ff08f:
	ld a, b
	cp 3
	jr z, Func_ff043
	inc b
	inc de
	push bc
	ld bc, SCREEN_WIDTH * 2
	add hl, bc
	pop bc
	jr Func_ff043

Func_ff09e:
	push hl
	push de
	push bc
	push hl
	ld [hl], "▶"
	ld bc, hMovingBGTilesCounter1
	add hl, bc
	ld [hl], " "
	ld bc, SCREEN_WIDTH * 4
	add hl, bc
	ld [hl], " "
	pop hl
	inc hl
	ld a, [de]
	ld de, wd11e
	ld [de], a
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	call Func_ff0c4
	pop bc
	pop de
	pop hl
	ret

Func_ff0c4:
	hlcoord 12, 0
	lb bc, 18, 8
	call ClearScreenArea
	hlcoord 13, 1
	ld de, Text_ff113
	call PlaceString
	ld b, 10
	ld hl, wLoadedMonHPExp
	ld a, [wEnemyMonOT + 2]
.asm_ff0de
	ld [hli], a
	dec b
	jr nz, .asm_ff0de
	ld a, [wEnemyMonOT]
	ld [hli], a
	ld a, [wEnemyMonOT + 1]
	ld [hl], a
	ld hl, wLoadedMonExp + 2
	ld de, wLoadedMonStats
	ld b, 1
	call CalcStats
	hlcoord 17, 1
	ld de, wLoadedMonStats
	ld b, 5
.asm_ff0fd
	push bc
	push de
	push hl
	lb bc, LEADING_ZEROES | 2, 3
	call PrintNumber
	pop hl
	ld bc, SCREEN_WIDTH * 2
	add hl, bc
	pop de
	inc de
	inc de
	pop bc
	dec b
	jr nz, .asm_ff0fd
	ret

Text_ff113:
	db   "たいりき"  ; hp
	next "こうげき"  ; attack
	next "ぼうぎょ"  ; defense
	next "すばやさ"  ; speed
	next "とくしゅ@" ; special

Func_ff12c:
	ld a, [wCurEnemyLVL]
	ld [wEnemyMonLevel], a
	ld a, [wcf91]
	ld [wd11e], a
	callfar PokedexToIndex
	ld a, [wd11e]
	ld [wcf91], a
	ld [wd0b5], a
	call GetMonHeader
	ld hl, wEnemyMon
	ld a, [wcf91]
	ld [hli], a
	ld a, [wLoadedMonStats]
	ld [hli], a
	ld a, [wLoadedMonStats + 1]
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld a, [wMonHTypes]
	ld [hli], a
	ld a, [wMonHType2]
	ld [hli], a
	ld a, [wMonHCatchRate]
	ld [hli], a
	ld a, [wMoves]
	ld [hli], a
	ld a, [wMoves + 1]
	ld [hli], a
	ld a, [wMoves + 2]
	ld [hli], a
	ld a, [wMoves + 3]
	ld [hl], a
	ld hl, wEnemyMonPP
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, [wEnemyMonOT]
	ld [wEnemyMonDVs], a
	ld a, [wEnemyMonOT + 1]
	ld [wEnemyMonDVs + 1], a
	callfar SendNewMonToBox
	ld b, 10
	ld hl, wBoxMon1HPExp
	ld a, [wEnemyMonOT + 2]
.asm_ff19e
	ld [hli], a
	dec b
	jr nz, .asm_ff19e
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	pop af
	ld [wLetterPrintingDelayFlags], a
	jr Func_ff1b3
Func_ff1ad:
	ld hl, Text_ff1b4
	call PrintText
Func_ff1b3:
	ret

Text_ff1b4:
	text_far _BoxFullDebugText
	text_end

Func_ff1b9:
	ld a, 1
	ldh [hJoy7], a
	ld a, 2
	ld [wCurEnemyLVL], a
	ld hl, Text_ff290
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jp nz, Func_ff286
	ld hl, Text_ff28f
	call PrintText
	callfar EmptyAllSRAMBoxes
	ld hl, wNumInBox
	xor a
	ld [hli], a
	dec a
	ld [hl], a
	; fallthrough
Func_ff1e7:
	hlcoord 2, 13
	ld [hl], "ﾞ"
	hlcoord 1, 14
	ld [hl], "レ"
	inc hl
	ld [hl], "へ"
	inc hl
	ld [hl], "ル"
	inc hl
	inc hl
	ld de, wCurEnemyLVL
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	call DelayFrame
	call JoypadLowSensitivity
	ldh a, [hJoy5]
	bit BIT_A_BUTTON, a
	jp nz, Func_ff21b
	bit BIT_B_BUTTON, a
	jp nz, Func_ff227
	bit BIT_START, a
	jp nz, Func_ff236
	jr Func_ff1e7

Func_ff21b:
	ld a, [wCurEnemyLVL]
	inc a
	cp MAX_LEVEL + 1
	jr c, Func_ff231
	ld a, 2
	jr Func_ff231
Func_ff227:
	ld a, [wCurEnemyLVL]
	dec a
	cp 2
	jr nc, Func_ff231
	ld a, MAX_LEVEL
Func_ff231:
	ld [wCurEnemyLVL], a
	jr Func_ff1e7

Func_ff236:
	ld c, 0
	ld d, 0
.asm_ff23a
	push bc
	push de
	call Func_ff295
	ld hl, wChangeMonPicEnemyTurnSpecies
	inc [hl]
	pop de
	pop bc
	ld b, 30
.asm_ff247
	inc c
	push bc
	push de
	ld a, c
	ld [wd11e], a
	callfar PokedexToIndex
	ld a, [wd11e]
	ld [wEnemyMonSpecies2], a
	ld [wcf91], a
	xor a
	ld [wEnemyBattleStatus3], a
	callfar LoadEnemyMonData
	ld a, [wEnemyMonSpecies2]
	ld [wcf91], a
	callfar SendNewMonToBox
	pop de
	pop bc
	ld a, c
	cp NUM_POKEMON
	jr z, Func_ff286
	dec b
	jr nz, .asm_ff247
	inc d
	jr .asm_ff23a
	; fallthrough
Func_ff286:
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	xor a
	ldh [hJoy7], a
	ret

Text_ff28f:
	text_end

Text_ff290:
	text_far _BoxWillBeClearedText
	text_end

Func_ff295:
	push de
	ld a, SFX_SAVE
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	call Func_ff2d1
	ld e, l
	ld d, h
	ld hl, wNumInBox
	call Func_ff2f3
	pop de
	ld a, d
	set 7, a
	ld [wCurrentBoxNum], a
	push de
	call Func_ff2d1
	ld de, wNumInBox
	call Func_ff2f3
	ld a, [wLetterPrintingDelayFlags]
	push af
	ld a, 1
	ld [wLetterPrintingDelayFlags], a
	callfar SaveSAVtoSRAM
	pop af
	ld [wLetterPrintingDelayFlags], a
	pop de
	ret

Func_ff2d1:
	ld hl, Data_ff2eb
	ld a, [wCurrentBoxNum]
	and %01111111
	cp 4
	ld b, 2
	jr c, .asm_ff2e2
	inc b
	and 3
.asm_ff2e2
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

Data_ff2eb:
	dw sBox1
	dw sBox2
	dw sBox3
	dw sBox4

Func_ff2f3:
	push hl
	call Func_ff316
	ld a, b
	ld [MBC1SRamBank], a
	ld bc, sBox2 - sBox1
	call CopyData
	pop hl
	xor a
	ld [hli], a
	dec a
	ld [hl], a
	ld hl, sBox1
	ld bc, sBox5 - sBox1 + 1
	call Func_ff32a
	ld [sBox5], a
	call Func_ff321
	ret

Func_ff316:
	ld a, 1
	ld [MBC1SRamBankingMode], a
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	ret

Func_ff321:
	ld a, 0
	ld [MBC1SRamBankingMode], a
	ld [MBC1SRamEnable], a
	ret

Func_ff32a:
	ld d, 0
.asm_ff32c
	ld a, [hli]
	add d
	ld d, a
	dec bc
	ld a, b
	or c
	jr nz, .asm_ff32c
	ld a, d
	cpl
	ret
ELSE
	ret
ENDC
