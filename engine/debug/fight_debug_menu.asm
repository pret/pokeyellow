FightDebugMenu:
	ld a, 1
	ldh [hJoy7], a

	; Don't mess around with obedience.
	ld a, 1 << BIT_EARTHBADGE
	ld [wObtainedBadges], a

	ld hl, wStatusFlags7
	set BIT_TEST_BATTLE, [hl]

	ld hl, wNumBagItems
	ld de, .ItemTable
.loop
	ld a, [de]
	cp -1
	jr z, .done
	inc de
	ld [wCurItem], a
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
	ld de, .FightTestText
	call PlaceString
	hlcoord 4, 4
	ld de, .NumNameLevelText
	call PlaceString
	hlcoord 1, 6
	ld de, .LayoutText
	call PlaceString
	xor a
	ld [wWhichPokemon], a
	ld [wEnemyMon], a
	ld [wEnemyMonLevel], a
	ld [wTrainerClass], a
	ld [wLinkEnemyTrainerName + 2], a
	ld b, a
	ld c, a
	ld hl, wEnemyPartySpecies
	call .ClearMonsData
	ld hl, wPartyCount
	call .ClearMonsData
	ld de, wPartySpecies
	hlcoord 4, 6
	; fallthrough
.MonsNumber:
	push hl ; monster number print position
	push bc ; b = monster number c = level
	dec hl
	ld a, '▶'
	ld [hl], a
	ld bc, NAME_LENGTH
	add hl, bc
	ld a, ' '
	ld [hl], a
	push de
	pop de
	pop bc ; b = monster number c = level
	pop hl ; monster number print position
	; fallthrough
.MonsNumberLoop:
	push bc ; b = monster number c = level
	push de
	call JoypadLowSensitivity
	pop de
	pop bc ; b = monster number c = level
	ldh a, [hJoy5]
	bit B_PAD_A, a
	jp nz, .CountUp
	bit B_PAD_B, a
	jp nz, .CountDown
	bit B_PAD_SELECT, a
	jp nz, DebugMenu
	bit B_PAD_START, a
	jp nz, .EnemySet
	bit B_PAD_RIGHT, a
	jp nz, .MonsLevel
	bit B_PAD_UP, a
	jp nz, .BeforeMons
	bit B_PAD_DOWN, a
	jp nz, .NextMons
	jr .MonsNumberLoop

.ClearMonsData:
	xor	a
rept PARTY_LENGTH
	ld [hli], a
endr
	ld [hl], a
	ret

.CountUp:
	inc b ; monster number
	ld a, b
	cp NUM_POKEMON_INDEXES + 1
	jr c, .CountUp_1
	xor a
	ld b, a
	; fallthrough
.CountUp_1:
	ld [de], a
	ld [wTempByteValue], a
	push bc
	push hl
	push de
	lb bc, LEADING_ZEROES | 1, 3

	call PrintNumber
	inc hl
	push hl
	ld de, .5SpacesText
	call PlaceString
	ld bc, -SCREEN_WIDTH
	add hl, bc
	ld de, .5SpacesText
	call PlaceString
	pop hl
	ld a, [wNamedObjectIndex]
	and a
	jr nz, .CountUp_2

	ld de, .5DashesText
	jr .CountUp_3
.CountUp_2
	call GetMonName
.CountUp_3
	call PlaceString
	pop de
	pop hl
	pop bc
	jr .MonsNumberLoop

.CountDown:
	dec b ; monster number
	ld a, b
	cp OPP_ID_OFFSET + 1
	jp c, .CountUp_1
	ld a, NUM_POKEMON_INDEXES
	ld b, a
	jp .CountUp_1

.BeforeMons:
	ld a, [wWhichPokemon]
	dec a
	cp -1
	jp z, .MonsNumberLoop
	ld [wWhichPokemon], a
	dec de
	dec hl
	ld a, ' '
	ld [hl], a
	push bc
	ld bc, -SCREEN_WIDTH * 2
	add hl, bc
	pop bc
	ld a, '▶'
	ld [hl], a
	inc hl
	push hl
	call .PositionMove
	pop hl
	jp .MonsNumberLoop

.NextMons:
	ld a, [wWhichPokemon]
	inc a
	cp PARTY_LENGTH
	jp nc, .MonsNumberLoop
	ld [wWhichPokemon], a
	inc de
	dec hl
	ld a, ' '
	ld [hl], a
	ld bc, SCREEN_WIDTH * 2
	add hl, bc
	ld a, '▶'
	ld [hl], a
	inc hl
	push hl
	call .PositionMove
	pop hl
	jp .MonsNumberLoop

.MonsLevel:
	push hl ; monster number print posision
	push bc ; b = monster number c = level
	dec hl
	ld a, ' '
	ld [hl], a
	ld bc, NAME_LENGTH
	add hl, bc
	ld a, '▶'
	ld [hl], a
	pop bc ; b = monster number c = level
	pop hl ; monster number print posision
	; fallthrough
.MonsLevelLoop:
	push bc ; b = monster number c = level
	push de
	call JoypadLowSensitivity
	pop de
	pop bc ; b = monster number c = level
	ldh a, [hJoy5]
	bit B_PAD_A, a
	jp nz, .LevelCountUp
	bit B_PAD_B, a
	jp nz, .LevelCountDown
	bit B_PAD_START, a
	jp nz, .EnemySet
	bit B_PAD_LEFT, a
	jp nz, .MonsNumber
	bit B_PAD_UP, a
	jp nz, .LevelBeforeMons
	bit B_PAD_DOWN, a
	jp nz, .LevelNextMons
	jr .MonsLevelLoop

.LevelCountUp:
	inc c ; monster level
	ld a, c
	cp MAX_LEVEL + 1
	jr c, .LevelCountUp_1
	ld a, 1
	ld c, a
	; fallthrough
.LevelCountUp_1:
	ld a, [wWhichPokemon]
	push de
	ld de, wEnemyPartySpecies
	add e
	ld e, a
	jr nc, .LevelCountUp_2
	inc d
.LevelCountUp_2
	ld a, c
	ld [de], a
	push bc ; b = monster No.  c = level
	push hl ; monster number print posision
	ld bc, NAME_LENGTH
	add hl, bc ; level print position
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber

	pop hl ; monster number print position
	pop bc ; b = monster No.  c = level
	pop de
	jp .MonsLevelLoop
.LevelCountDown:
	dec c ; monster level
	ld a, c
	cp MAX_LEVEL + 1
	jr nc, .LevelCountDown_1
	and a
	jp nz, .LevelCountUp_1
.LevelCountDown_1
	ld a, MAX_LEVEL
	ld c, a
	jp .LevelCountUp_1

.LevelBeforeMons:
	ld a, [wWhichPokemon]
	dec a
	cp -1
	jp z, .MonsLevelLoop
	ld [wWhichPokemon], a
	dec de
	push hl ; monster number print position
	ld bc, NAME_LENGTH - 1
	add hl, bc
	ld a, ' '
	ld [hl], a
	pop hl
	ld bc, -SCREEN_WIDTH * 2
	add hl, bc
	push hl
	ld bc, NAME_LENGTH - 1
	add hl, bc
	ld a, '▶'
	ld [hl], a
	call .PositionMove
	pop hl ; monster number print position
	jp .MonsLevelLoop

.LevelNextMons:
	ld a, [wWhichPokemon]
	inc a
	cp PARTY_LENGTH
	jp nc, .MonsLevelLoop
	ld [wWhichPokemon], a
	inc de
	push hl ; monster number print position
	ld bc, NAME_LENGTH - 1
	add hl, bc
	ld a, ' '
	ld [hl], a
	pop hl
	ld bc, SCREEN_WIDTH * 2
	add hl, bc
	push hl
	ld bc, NAME_LENGTH - 1
	add hl, bc
	ld a, '▶'
	ld [hl], a
	call .PositionMove
	pop hl ; monster number print position
	jp .MonsLevelLoop

.PositionMove:
	ld hl, wPartySpecies
	ld a, [wWhichPokemon]
	add l
	ld l, a
	jr nc, .PositionMove_1
	inc h
.PositionMove_1
	ld a, [hl] ; monster number
	ld b, a
	ld hl, wEnemyPartySpecies
	ld a, [wWhichPokemon]
	add l
	ld l, a
	jr nc, .PositionMove_2
	inc h
.PositionMove_2
	ld a, [hl] ; monster level
	ld c, a
	ret

.EnemySet:
	ld hl, wPartyCount
	ld de, wEnemyPartyCount ; level saved
	xor a
	ld [hl], a
	inc hl
	ld a, [hli] ; first monster number
	ld b, a
	ld c, PARTY_LENGTH
	xor a
	ld [wIsInBattle], a

.EnemySet_1
	ld a, b ; monster number
	ld [wCurPartySpecies], a
	ld a, [hl] ; next monster number
	ld b, a
	inc de
	ld a, [de] ; level
	and a
	jr z, .EnemySet_2

	ld [wCurEnemyLevel], a
	xor a
	ld [wMonDataLocation], a ; 0 = none
	ld a, [wCurPartySpecies]
	and a
	jr z, .EnemySet_2

	call AddPartyMon
.EnemySet_2
	inc hl
	dec c
	jr nz, .EnemySet_1

	ld b, PARTY_LENGTH + 1
	ld hl, wPartySpecies
	ld de, wEnemyPartyCount

.EnemySet_2_0
	inc de
	dec b
	jp z, FightDebugMenu
	ld a, [hli]
	and a
	jr z, .EnemySet_2_0
	ld a, [de]
	and a
	jr z, .EnemySet_2_0

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

	ld a, WILD_BATTLE
	ld [wIsInBattle], a
	ld de, .WildPokemonText
	ld a, [wLinkEnemyTrainerName + 2]
	cp MAX_LEVEL + 1
	jr c, .EnemySet_2_1
	ld a, TRAINER_BATTLE
	ld [wIsInBattle], a
	ld de, .TrainerText

.EnemySet_2_1
	hlcoord 1, 4
	call PlaceString
	hlcoord 1, 6
	ld de, .EnemyNumNameLevelText
	call PlaceString

	ld a, [wEnemyMon]
	ld b, a
	ld a, [wIsInBattle]
	dec a
	jr z, .EnemySet_3

	ld a, [wTrainerClass]
	ld [wTempByteValue], a
	ld b, a
	ld de, wTempByteValue
	hlcoord 1, 8
	push bc
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	hlcoord 5, 8
	ld de, .10SpacesText
	call PlaceString
	call GetTrainerName
	hlcoord 5, 8
	ld de, wTrainerName
	call PlaceString
	pop bc
	jr .EnemySet_4

.EnemySet_3
	ld a, b
	and a
	jr z, .EnemySet_4

	ld de, wTempByteValue
	ld [de], a
	hlcoord 1, 8
	push bc
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber

	hlcoord 5, 8
	ld de, .10SpacesText
	call PlaceString

	call GetMonName
	hlcoord 5, 8
	call PlaceString
	pop bc

.EnemySet_4
	ld a, [wEnemyMonLevel]
	ld c, a ; level
	ld de, wTempByteValue
	ld [de], a
	hlcoord 16, 8
	push bc
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	pop bc
	; fallthrough
.EnemyType:
	ld a, ' '
	ldcoord_a 0, 8
	ldcoord_a 15, 8
	ld a, '▶'
	ldcoord_a 0, 4
	; fallthrough
.EnemyTypeLoop:
	push bc ; b = monster number c = level
	call JoypadLowSensitivity
	pop bc ; b = monster number c = level
	ldh a, [hJoy5]
	bit B_PAD_A, a
	jp nz, .TypeChange
	bit B_PAD_START, a
	jp nz, .GoFight
	bit B_PAD_DOWN, a
	jp nz, .EnemyMons
	jr .EnemyTypeLoop

.TypeChange:
	hlcoord 1, 8
	ld de, .EnemyLayoutText
	call PlaceString
	hlcoord 5, 7
	ld de, .10SpacesText
	call PlaceString

	xor a
	ld b, a ; monster or trainer number
	ld c, a ; monster or trainer level
	ld a, [wIsInBattle]
	dec a
	jr nz, .TypeChange_1

	ld a, TRAINER_BATTLE
	ld [wIsInBattle], a
	ld a, ' '
	ldcoord_a 4, 3
	hlcoord 1, 4
	ld de, .TrainerText
	call PlaceString

	jp .EnemyTypeLoop

.TypeChange_1
	ld a, 1
	ld [wIsInBattle], a
	ld a, ' '
	ldcoord_a 1, 3
	hlcoord 1, 4
	ld de, .WildPokemonText
	call PlaceString

	jp .EnemyTypeLoop

.EnemyMons:
	ld a, '▶'
	ldcoord_a 0, 8
	ld a, ' '
	ldcoord_a 15, 8
	ldcoord_a 0, 4
	; fallthrough
.EnemyMonsLoop:
	push bc ; b = monster number c = level
	call JoypadLowSensitivity
	pop bc ; b = monster number c = level
	ldh a, [hJoy5]
	bit B_PAD_A, a
	jp nz, .EnemyMonsCountUp
	bit B_PAD_B, a
	jp nz, .EnemyMonsCountDown
	bit B_PAD_START, a
	jp nz, .GoFight
	bit B_PAD_RIGHT, a
	jp nz, .EnemyLevel
	bit B_PAD_UP, a
	jp nz, .EnemyType
	jr .EnemyMonsLoop

.EnemyMonsCountUp:
	push bc ; b = monster number c = level
	hlcoord 5, 7
	ld de, .10SpacesText
	call PlaceString
	hlcoord 5, 8
	ld de, .10SpacesText
	call PlaceString
	pop bc ; b = monster number c = level
	ld a, [wIsInBattle]
	dec a
	jr z, .MonsCountUp
	inc b ; trainer number
	ld a, b
	cp NUM_TRAINERS + 1
	jr c, .TrainerCountUp

	ld b, 1
	; fallthrough
.TrainerCountUp:
	ld a, b
	ld [wTempByteValue], a ; trainer number
	ld de, wTempByteValue
	hlcoord 1, 8
	push bc ; b = monster number c = level
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	ld a, [wTempByteValue]
	ld [wTrainerClass], a
	call GetTrainerName
	hlcoord 5, 8
	ld de, wTrainerName
	call PlaceString

	pop bc ; b = monster number c = level
	jp .EnemyMonsLoop
.MonsCountUp
	inc b
	ld a, b
	cp NUM_POKEMON_INDEXES + 1
	jr c, .MonsCountUp_1

	ld b, 1
	; fallthrough
.MonsCountUp_1:
	ld a, b
	ld [wTempByteValue], a
	ld de, wTempByteValue
	hlcoord 1, 8
	push bc
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	call GetMonName
	hlcoord 5, 8
	call PlaceString

	pop bc
	jp .EnemyMonsLoop

.EnemyMonsCountDown:
	push bc
	hlcoord 5, 7
	ld de, .10SpacesText
	call PlaceString
	hlcoord 5, 8
	ld de, .10SpacesText
	call PlaceString
	pop bc

	ld a, [wIsInBattle]
	dec a
	jr z, .MonsCountDown

	dec b
	ld a, b
	cp NUM_TRAINERS + 1
	jr nc, .TrainerCountDown
	and a
	jp nz, .TrainerCountUp

.TrainerCountDown
	ld b, NUM_TRAINERS
	jp .TrainerCountUp

.MonsCountDown
	dec b ; monster number
	ld a, b
	cp NUM_POKEMON_INDEXES + 1
	jr nc, .MonsCountDown_1
	and a
	jp nz, .MonsCountUp_1
.MonsCountDown_1
	ld b, NUM_POKEMON_INDEXES ; monster number
	jp .MonsCountUp_1

.EnemyLevel:
	ld a, ' '
	ldcoord_a 0, 8
	ld a, '▶'
	ldcoord_a 15, 8
	; fallthrough
.EnemyLevelLoop:
	push bc ; b = monster number c = level
	call JoypadLowSensitivity
	pop bc ; b = monster number c = level
	ldh a, [hJoy5]
	bit B_PAD_A, a
	jp nz, .EnemyLevelCountUp
	bit B_PAD_B, a
	jp nz, .EnemyLevelCountDown
	bit B_PAD_START, a
	jp nz, .GoFight
	bit B_PAD_LEFT, a
	jp nz, .EnemyMons
	bit B_PAD_UP, a
	jp nz, .EnemyType
	jr .EnemyLevelLoop

.EnemyLevelCountUp:
	inc c ; level
	ld a, c
	cp MAX_LEVEL + 1
	jr c, .EnemyLevelCountUp_1

	ld c, 1

.EnemyLevelCountUp_1:
	hlcoord 16, 8
	ld a, c
	ld de, wCurEnemyLevel
	ld [de], a
	push bc
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	pop bc
	jp .EnemyLevelLoop

.EnemyLevelCountDown:
	dec c ; level
	ld a, c
	cp MAX_LEVEL + 1
	jr nc, .EnemyLevelCountDown_1
	and a
	jp nz, .EnemyLevelCountUp_1

.EnemyLevelCountDown_1
	ld c, MAX_LEVEL
	jp .EnemyLevelCountUp_1

.GoFight:
	ld a, b
	and a
	jp z, .EnemyType
	ld a, c
	and a
	jp z, .EnemyType

	ld a, [wIsInBattle]
	dec a
	jr z, .GoFight_1

	ld a, b ; trainer number
	add OPP_ID_OFFSET
	ld b, a
	ld a, c
	ld [wTrainerNo], a
.GoFight_1
	ld a, c
	ld [wCurEnemyLevel], a
	ld a, b
	ld [wCurOpponent], a

	xor a
	ld [wStatusFlags3], a
	predef InitOpponent

	xor a
	ld [wNumRunAttempts], a

	ld hl, wPlayerStatsToDouble
	ld bc, wPlayerBattleStatusEnd - wPlayerStatsToDouble
	call FillMemory

	ld hl, wEnemyStatsToDouble
	ld bc, wEnemyBattleStatusEnd - wEnemyStatsToDouble
	call FillMemory

	call LoadFontTilePatterns
	call ClearScreen
	call ClearSprites
	ld a, %11100100
	ldh [rBGP], a
	ldh [rOBP0], a
	ldh [rOBP1], a
	call UpdateCGBPal_BGP
	call UpdateCGBPal_OBP0
	call UpdateCGBPal_OBP1
	hlcoord 0, 0
	lb bc, 1, 18
	call TextBoxBorder
	hlcoord 6, 1
	ld de, .FightTestText
	call PlaceString

	hlcoord 4, 4
	ld de, .NumNameLevelText
	call PlaceString

	hlcoord 1, 6
	ld de, .LayoutText
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
.GoFight_2:
	ld a, [wWhichPokemon]
	ld de, wPartySpecies
	add e
	ld e, a
	jr nc, .GoFight_3
	inc d

.GoFight_3
	ld a, [de]
	cp -1
	jp z, .GoFight_5

	ld [wTempByteValue], a
	push hl
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	inc hl
	ld de, .5SpacesText
	call PlaceString
	call GetMonName
	call PlaceString
	pop hl
	push hl
	ld bc, NAME_LENGTH
	add hl, bc
	push hl

	ld a, [wWhichPokemon]
	ld hl, wPartyMon1Level
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld d, h
	ld e, l
	ld a, [de]
	ld [wCurEnemyLevel], a
	pop hl
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	ld a, [wWhichPokemon]
	ld de, wEnemyPartySpecies
	add e
	ld e, a
	jr nc, .GoFight_4
	inc d
.GoFight_4
	ld a, [wCurEnemyLevel]
	ld [de], a
	pop hl
	ld a, [wWhichPokemon]
	inc a
	ld [wWhichPokemon], a
	ld bc, SCREEN_WIDTH * 2
	add hl, bc
	jp .GoFight_2

.GoFight_5:
	pop hl
	pop de
	ld a, [wPartyMon1]
	ld b, a
	ld a, [wPartyMon1Level]
	ld c, a
	xor a
	ld [wWhichPokemon], a
	jp .MonsNumber

.PlayerNameText:
	db   "けんしろう@" ; "KENSHIROU@"

.FightTestText:
	db   "テスト ファイト@" ; "FIGHT TEST@"

.NumNameLevelText:
	db   "№．  なまえ    レべル@" ; "№．  NAME  LEVEL@"

.LayoutText:
	db   "１．▶０００ ーーーーー  ０００"
for x, 2, PARTY_LENGTH + 1
	next "{d:x}．　０００　ーーーーー　　０００"
endr
	db	"@"

.5SpacesText:
	db   "     @"

.5DashesText:
	db   "ーーーーー@"

.WildPokemonText :
	db   "ワイルドモンスター@" ; "WILD #MON@"

.TrainerText:
	db   "ディーラー    @" ; "TRAINER      @"

.EnemyNumNameLevelText:
	db   "№．  なまえ        レべル" ; "№．  NAME     LABEL"
	next ""
.EnemyLayoutText:
	db   "０００ ーーーーーーーーーー ０００@"

.10SpacesText:
	db   "          @"

.ItemTable:
	db GREAT_BALL, 99
	db POKE_BALL, 99
	db ANTIDOTE, 99
	db FULL_RESTORE, 99
	db MAX_POTION, 99
	db HYPER_POTION, 99
	db SUPER_POTION, 99
	db POTION, 99
	db -1 ; end
