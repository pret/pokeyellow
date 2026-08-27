; unreferenced debug code for pc boxes.
Func_fedfe:
	ld a, [wBoxCount]
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
	ld [wCurPartySpecies], a
	ld [wCurEnemyLevel], a
	; fallthrough
Func_fee23:
	hlcoord 0, 3
	ld [hl], ' '
	hlcoord 0, 1
	ld [hl], '▶'
	call Func_fee60
.asm_fee30
	call DelayFrame
	call JoypadLowSensitivity
	ldh a, [hJoy5]
	bit B_PAD_A, a
	jp nz, Func_fee49
	bit B_PAD_B, a
	jp nz, Func_fee56
	bit B_PAD_DOWN, a
	jp nz, Func_fee96
	jr .asm_fee30

Func_fee49:
	ld hl, wCurPartySpecies
	inc [hl]
	ld a, [hl]
	cp NUM_POKEMON + 1
	jr c, Func_fee23
	ld [hl], DEX_BULBASAUR
	jr Func_fee23

Func_fee56:
	ld hl, wCurPartySpecies
	dec [hl]
	jr nz, Func_fee23
	ld [hl], DEX_MEW
	jr Func_fee23

Func_fee60:
	hlcoord 1, 0
	lb bc, 2, 9
	call ClearScreenArea
	hlcoord 1, 1
	ld de, wCurPartySpecies
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	inc hl
	push hl
	ld a, [wCurPartySpecies]
	ld [wPokedexNum], a
	callfar PokedexToIndex
	call GetMonName
	pop hl
	call PlaceString
	ld a, [wPokedexNum]
	ld [wCurSpecies], a
	call GetMonHeader
	ret

Func_fee96:
	hlcoord 0, 1
	ld [hl], ' '
	hlcoord 0, 3
	ld [hl], '▶'
	hlcoord 0, 5
	ld [hl], ' '
	call Func_feee2
	call Func_feeef
.asm_feeab
	call DelayFrame
	call JoypadLowSensitivity
	ld hl, wCurEnemyLevel
	ldh a, [hJoy5]
	bit B_PAD_A, a
	jp nz, Func_feed1
	bit B_PAD_B, a
	jp nz, Func_feedb
	bit B_PAD_START, a
	jp nz, Func_ff12c
	bit B_PAD_UP, a
	jp nz, Func_fee23
	bit B_PAD_DOWN, a
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
	ld de, wCurEnemyLevel
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	ret

Func_feeef:
	hlcoord 1, 4
	lb bc, 8, 11
	call ClearScreenArea
	ld a, [wCurPartySpecies]
	push af
	ld [wPokedexNum], a
	ld hl, BaseStats + 15
	dec a
	ld bc, BASE_DATA_SIZE
	call AddNTimes
	ld de, wMoves
	ld bc, NUM_MOVES
	ld a, BANK(BaseStats)
	call FarCopyData
	callfar PokedexToIndex
	ld a, [wPokedexNum]
	ld [wCurPartySpecies], a
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
	ld [wTempByteValue], a
	ld de, wTempByteValue
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
	ld [wCurPartySpecies], a
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
	bit B_PAD_A, a
	jp nz, Func_fef92
	bit B_PAD_B, a
	jp nz, Func_fef9e
	bit B_PAD_START, a
	jp nz, Func_ff12c
	bit B_PAD_UP, a
	jp nz, Func_fefa8
	bit B_PAD_DOWN, a
	jp nz, Func_fefb5
	jr .asm_fef6b

Func_fef92:
	ld a, [de]
	inc a
	ld [de], a
	cp NUM_ATTACKS
	jr c, Func_fef68
	ld a, 1
	ld [de], a
	jr Func_fef68

Func_fef9e:
	ld a, [de]
	dec a
	ld [de], a
	jr nz, Func_fef68
	ld a, NUM_ATTACKS - 1
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
	ld [hl], '▶'
	ld bc, hMovingBGTilesCounter1
	add hl, bc
	ld [hl], ' '
	ld bc, SCREEN_WIDTH * 4
	add hl, bc
	ld [hl], ' '
	pop hl
	inc hl
	ld a, [de]
	ld de, wTempByteValue
	ld [de], a
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	ld a, [wTempByteValue]
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
	ld a, [wCurPartySpecies]
	push af
	ld a, [wPokedexNum]
	push af
	push hl
	ld a, [wCurPartySpecies]
	ld [wPokedexNum], a
	callfar PokedexToIndex
	ld a, [wPokedexNum]
	ld [wCurPartySpecies], a
	pop hl
	pop af
	ld [wPokedexNum], a
	push hl
	callfar Func_3b079
	pop hl
	jr c, .asm_ff036
	ld [hl], '×'
.asm_ff036
	pop af
	ld [wCurPartySpecies], a
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
	bit B_PAD_A, a
	jp nz, Func_ff06d
	bit B_PAD_B, a
	jp nz, Func_ff072
	bit B_PAD_START, a
	jp nz, Func_ff12c
	bit B_PAD_UP, a
	jp nz, Func_ff077
	bit B_PAD_DOWN, a
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
	ld [hl], '▶'
	ld bc, hMovingBGTilesCounter1
	add hl, bc
	ld [hl], ' '
	ld bc, SCREEN_WIDTH * 4
	add hl, bc
	ld [hl], ' '
	pop hl
	inc hl
	ld a, [de]
	ld de, wTempByteValue
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
	ld a, [wCurEnemyLevel]
	ld [wEnemyMonLevel], a
	ld a, [wCurPartySpecies]
	ld [wPokedexNum], a
	callfar PokedexToIndex
	ld a, [wPokedexNum]
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call GetMonHeader
	ld hl, wEnemyMon
	ld a, [wCurPartySpecies]
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
	ld [wCurEnemyLevel], a
	ld hl, Text_ff290
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jp nz, Func_ff286
	ld hl, Text_ff28f
	call PrintText
	callfar EmptyAllSRAMBoxes
	ld hl, wBoxCount
	xor a
	ld [hli], a
	dec a
	ld [hl], a
	; fallthrough
Func_ff1e7:
	hlcoord 2, 13
	ld [hl], 'ﾞ'
	hlcoord 1, 14
	ld [hl], 'レ'
	inc hl
	ld [hl], 'へ'
	inc hl
	ld [hl], 'ル'
	inc hl
	inc hl
	ld de, wCurEnemyLevel
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	call DelayFrame
	call JoypadLowSensitivity
	ldh a, [hJoy5]
	bit B_PAD_A, a
	jp nz, Func_ff21b
	bit B_PAD_B, a
	jp nz, Func_ff227
	bit B_PAD_START, a
	jp nz, Func_ff236
	jr Func_ff1e7

Func_ff21b:
	ld a, [wCurEnemyLevel]
	inc a
	cp MAX_LEVEL + 1
	jr c, Func_ff231
	ld a, 2
	jr Func_ff231
Func_ff227:
	ld a, [wCurEnemyLevel]
	dec a
	cp 2
	jr nc, Func_ff231
	ld a, MAX_LEVEL
Func_ff231:
	ld [wCurEnemyLevel], a
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
	ld [wPokedexNum], a
	callfar PokedexToIndex
	ld a, [wPokedexNum]
	ld [wEnemyMonSpecies2], a
	ld [wCurPartySpecies], a
	xor a
	ld [wEnemyBattleStatus3], a
	callfar LoadEnemyMonData
	ld a, [wEnemyMonSpecies2]
	ld [wCurPartySpecies], a
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
	ld hl, wBoxCount
	call Func_ff2f3
	pop de
	ld a, d
	set BIT_HAS_CHANGED_BOXES, a
	ld [wCurrentBoxNum], a
	push de
	call Func_ff2d1
	ld de, wBoxCount
	call Func_ff2f3
	ld a, [wLetterPrintingDelayFlags]
	push af
	ld a, 1 << BIT_FAST_TEXT_DELAY
	ld [wLetterPrintingDelayFlags], a
	callfar SaveGameData
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
	call DebugEnableSRAM
	ld a, b
	ld [rRAMB], a
	ld bc, sBox2 - sBox1
	call CopyData
	pop hl
	xor a
	ld [hli], a
	dec a
	ld [hl], a
	ld hl, sBox1
	ld bc, sBox5 - sBox1 + 1 ; BUG: SBox5 should be sBank2AllBoxesChecksum
	call Func_ff32a
	ld [sBox5], a ; BUG: SBox5 should be sBank2AllBoxesChecksum
	call DebugDisableSRAM
	ret

DebugEnableSRAM: ; duplicate of EnableSRAM
	ld a, BMODE_ADVANCED
	ld [rBMODE], a
	ld a, RAMG_SRAM_ENABLE
	ld [rRAMG], a
	ret

DebugDisableSRAM: ; duplicate of DisableSRAM
	ld a, 0
	ld [rBMODE], a
	ld [rRAMG], a
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
