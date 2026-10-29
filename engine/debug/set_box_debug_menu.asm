; unreferenced debug code for pc boxes.

BoxDebugMenu:
	ld a, [wBoxCount]
	cp MONS_PER_BOX_JP
	jp nc, DebugPrintBoxIsFull
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

DebugAdjustSpecies:
.mainLoop
	hlcoord 0, 3
	ld [hl], ' '
	hlcoord 0, 1
	ld [hl], '▶'
	call .PrintSpecies
.inputLoop
	call DelayFrame
	call JoypadLowSensitivity
	ldh a, [hJoy5]
	bit B_PAD_A, a
	jp nz, .incrementSpecies
	bit B_PAD_B, a
	jp nz, .decrementSpecies
	bit B_PAD_DOWN, a
	jp nz, DebugAdjustLevel
	jr .inputLoop

.incrementSpecies:
	ld hl, wCurPartySpecies
	inc [hl]
	ld a, [hl]
	cp NUM_POKEMON + 1
	jr c, .mainLoop
	ld [hl], DEX_BULBASAUR
	jr .mainLoop

.decrementSpecies:
	ld hl, wCurPartySpecies
	dec [hl]
	jr nz, .mainLoop
	ld [hl], DEX_MEW
	jr .mainLoop

.PrintSpecies:
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

DebugAdjustLevel:
.mainLoop
	hlcoord 0, 1
	ld [hl], ' '
	hlcoord 0, 3
	ld [hl], '▶'
	hlcoord 0, 5
	ld [hl], ' '
	call .PrintLevel
	call DebugPrintMonData
.inputLoop
	call DelayFrame
	call JoypadLowSensitivity
	ld hl, wCurEnemyLevel
	ldh a, [hJoy5]
	bit B_PAD_A, a
	jp nz, .incrementLevel
	bit B_PAD_B, a
	jp nz, .decrementLevel
	bit B_PAD_START, a
	jp nz, DebugSendMonToBox
	bit B_PAD_UP, a
	jp nz, DebugAdjustSpecies
	bit B_PAD_DOWN, a
	jp nz, DebugAdjustMoves
	jr .inputLoop

.incrementLevel
	inc [hl]
	ld a, [hl]
	cp MAX_LEVEL + 1
	jr c, .mainLoop
	ld [hl], 1
	jr .mainLoop

.decrementLevel
	dec [hl]
	jr nz, .mainLoop
	ld [hl], MAX_LEVEL
	jr .mainLoop

.PrintLevel:
	hlcoord 1, 3
	ld de, wCurEnemyLevel
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	ret

DebugPrintMonData:
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
.moveLoop
	ld a, [de]
	inc de
	and a
	jr z, .done
	push de
	push bc
	push hl
	ld [wNamedObjectIndex], a
	ld de, wNamedObjectIndex
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
	jr nz, .moveLoop
.done
	pop af
	ld [wCurPartySpecies], a
	ret

DebugAdjustMoves:
	ld de, wMoves
	hlcoord 0, 5
	ld b, 1
_DebugAdjustMoves:
.mainLoop
	call PrintMoveNameAndLearnability
.inputLoop
	call DelayFrame
	push de
	push bc
	call JoypadLowSensitivity
	pop bc
	pop de
	ldh a, [hJoy5]
	bit B_PAD_A, a
	jp nz, .incrementMove
	bit B_PAD_B, a
	jp nz, .decrementMove
	bit B_PAD_START, a
	jp nz, DebugSendMonToBox
	bit B_PAD_UP, a
	jp nz, .prevMove
	bit B_PAD_DOWN, a
	jp nz, .nextMove
	jr .inputLoop

.incrementMove
	ld a, [de]
	inc a
	ld [de], a
	cp NUM_ATTACKS
	jr c, .mainLoop
	ld a, 1
	ld [de], a
	jr .mainLoop

.decrementMove
	ld a, [de]
	dec a
	ld [de], a
	jr nz, .mainLoop
	ld a, NUM_ATTACKS - 1
	ld [de], a
	jr .mainLoop

.prevMove
	dec de
	dec b
	jp z, DebugAdjustLevel
	push bc
	ld bc, -(SCREEN_WIDTH * 2)
	add hl, bc
	pop bc
	jr .mainLoop

.nextMove
	inc de
	inc b
	ld a, b
	cp NUM_MOVES + 1
	jp z, DebugAdjustStatExp
	push bc
	ld bc, SCREEN_WIDTH * 2
	add hl, bc
	pop bc
	jr .mainLoop

PrintMoveNameAndLearnability:
	push hl
	push de
	push bc
	push hl
	push de
	ld bc, -(SCREEN_WIDTH - 1)
	add hl, bc
	lb bc, 2, 11
	call ClearScreenArea
	pop de
	pop hl
	push hl
	ld [hl], '▶'
	ld bc, -(SCREEN_WIDTH * 2)
	add hl, bc
	ld [hl], ' '
	ld bc, SCREEN_WIDTH * 4
	add hl, bc
	ld [hl], ' '
	pop hl
	inc hl
	ld a, [de]
	ld de, wNamedObjectIndex
	ld [de], a
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	ld a, [wNamedObjectIndex]
	and a
	jr z, .noMove
	call MarkMoveIfNotLearnable
	inc hl
	call GetMoveName
	call PlaceString
.noMove
	pop bc
	pop de
	pop hl
	ret

MarkMoveIfNotLearnable:
	ld a, [wCurPartySpecies]
	push af
	ld a, [wNamedObjectIndex]
	push af
	push hl
	ld a, [wCurPartySpecies]
	ld [wPokedexNum], a
	callfar PokedexToIndex
	ld a, [wPokedexNum]
	ld [wCurPartySpecies], a
	pop hl
	pop af
	ld [wNamedObjectIndex], a
	push hl
	callfar CheckAnyStageCanLearnMove
	pop hl
	jr c, .canLearnMove
	ld [hl], '×'
.canLearnMove
	pop af
	ld [wCurPartySpecies], a
	ret

DebugAdjustStatExp:
	ld de, wEnemyMonOT
	hlcoord 0, 13
	ld b, 1
.mainLoop:
	call DebugPrintCursorAndStats
.inputLoop
	call DelayFrame
	push de
	push bc
	call JoypadLowSensitivity
	pop bc
	pop de
	ldh a, [hJoy5]
	bit B_PAD_A, a
	jp nz, .incrementStatExp
	bit B_PAD_B, a
	jp nz, .decrementStatExp
	bit B_PAD_START, a
	jp nz, DebugSendMonToBox
	bit B_PAD_UP, a
	jp nz, .prevStat
	bit B_PAD_DOWN, a
	jp nz, .nextStat
	jr .inputLoop

.incrementStatExp
	ld a, [de]
	inc a
	ld [de], a
	jr .mainLoop

.decrementStatExp
	ld a, [de]
	dec a
	ld [de], a
	jr .mainLoop

.prevStat
	dec de
	dec b
	jp z, .underflow
	push bc
	ld bc, -(SCREEN_WIDTH * 2)
	add hl, bc
	pop bc
	jr .mainLoop
.underflow
	ld de, wMoves + NUM_MOVES - 1
	hlcoord 0, 11
	ld b, NUM_MOVES
	jp _DebugAdjustMoves

.nextStat
	ld a, b
	cp NUM_MOVES - 1
	jr z, .mainLoop
	inc b
	inc de
	push bc
	ld bc, SCREEN_WIDTH * 2
	add hl, bc
	pop bc
	jr .mainLoop

DebugPrintCursorAndStats:
	push hl
	push de
	push bc
	push hl
	ld [hl], '▶'
	ld bc, -(SCREEN_WIDTH * 2)
	add hl, bc
	ld [hl], ' '
	ld bc, SCREEN_WIDTH * 4
	add hl, bc
	ld [hl], ' '
	pop hl
	inc hl
	ld a, [de]
	ld de, wNamedObjectIndex
	ld [de], a
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	call DebugCalcAndPrintStats
	pop bc
	pop de
	pop hl
	ret

DebugCalcAndPrintStats:
	hlcoord 12, 0
	lb bc, 18, 8
	call ClearScreenArea
	hlcoord 13, 1
	ld de, DebugStatsJP
	call PlaceString
	ld b, NUM_STATS * 2
	ld hl, wLoadedMonHPExp
	ld a, [wEnemyMonOT + 2]
.statExpLoop
	ld [hli], a
	dec b
	jr nz, .statExpLoop
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
	ld b, NUM_STATS
.printLoop
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
	jr nz, .printLoop
	ret

DebugStatsJP:
	db   "たいりき"  ; hp
	next "こうげき"  ; attack
	next "ぼうぎょ"  ; defense
	next "すばやさ"  ; speed
	next "とくしゅ@" ; special

DebugSendMonToBox:
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
	ld b, NUM_STATS * 2
	ld hl, wBoxMon1HPExp
	ld a, [wEnemyMonOT + 2]
.statExpLoop
	ld [hli], a
	dec b
	jr nz, .statExpLoop
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	pop af
	ld [wLetterPrintingDelayFlags], a
	jr _DebugRet

DebugPrintBoxIsFull:
	ld hl, BoxFullDebugText
	call PrintText
_DebugRet:
	ret

BoxFullDebugText:
	text_far _BoxFullDebugText
	text_end

DebugFillBoxesWithEverySpecies:
	ld a, 1
	ldh [hJoy7], a
	ld a, 2
	ld [wCurEnemyLevel], a
	ld hl, BoxWillBeClearedText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jp nz, FinishBoxDebugMenu
	ld hl, DebugClearText
	call PrintText
	callfar EmptyAllSRAMBoxes
	ld hl, wBoxCount
	xor a
	ld [hli], a
	dec a
	ld [hl], a
	; fallthrough
.inputLoop
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
	jp nz, .incrementLevel
	bit B_PAD_B, a
	jp nz, .decrementLevel
	bit B_PAD_START, a
	jp nz, DebugFillBoxesWithAllSpecies
	jr .inputLoop

.incrementLevel
	ld a, [wCurEnemyLevel]
	inc a
	cp MAX_LEVEL + 1
	jr c, .updateLevel
	ld a, 2
	jr .updateLevel

.decrementLevel
	ld a, [wCurEnemyLevel]
	dec a
	cp 2
	jr nc, .updateLevel
	ld a, MAX_LEVEL
.updateLevel
	ld [wCurEnemyLevel], a
	jr .inputLoop

DebugFillBoxesWithAllSpecies:
	ld c, 0 ; species
	ld d, 0 ; box number
.speciesLoop
	push bc
	push de
	call DebugForceChangeBox
	ld hl, wChangeMonPicEnemyTurnSpecies
	inc [hl]
	pop de
	pop bc
	ld b, MONS_PER_BOX_JP
.boxLoop
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
	jr z, FinishBoxDebugMenu
	dec b
	jr nz, .boxLoop
	inc d
	jr .speciesLoop

FinishBoxDebugMenu:
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	xor a
	ldh [hJoy7], a
	ret

DebugClearText:
	text_end

BoxWillBeClearedText:
	text_far _BoxWillBeClearedText
	text_end

DebugForceChangeBox: ; similar to the end of ChangeBox
	push de
	ld a, SFX_SAVE
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	call DebugGetBoxSRAMLocation
	ld e, l
	ld d, h
	ld hl, wBoxDataStart
	call DebugCopyBoxToOrFromSRAM ; copy old box from WRAM to SRAM
	pop de
	ld a, d
	set BIT_HAS_CHANGED_BOXES, a
	ld [wCurrentBoxNum], a
	push de
	call DebugGetBoxSRAMLocation
	ld de, wBoxDataStart
	call DebugCopyBoxToOrFromSRAM ; copy new box from SRAM to WRAM
	ld a, [wLetterPrintingDelayFlags]
	push af
	ld a, 1 << BIT_FAST_TEXT_DELAY
	ld [wLetterPrintingDelayFlags], a
	callfar SaveGameData
	pop af
	ld [wLetterPrintingDelayFlags], a
	pop de
	ret

DebugGetBoxSRAMLocation: ; duplicate of GetBoxSRAMLocation with JP values
	ld hl, DebugBoxSRAMPointerTable
	ld a, [wCurrentBoxNum]
	and BOX_NUM_MASK
	cp NUM_BOXES_JP / 2
	ld b, 2
	jr c, .next
	inc b
	and 3
.next
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

DebugBoxSRAMPointerTable: ; duplicate of BoxSRAMPointerTable with JP values
	dw sBox1 ; sBox4
	dw sBox2 ; sBox5
	dw sBox3 ; sBox6
	dw sBox4 ; sBox7

DebugCopyBoxToOrFromSRAM: ; duplicate of CopyBoxToOrFromSRAM with JP values
; copy an entire box from hl to de with b as the SRAM bank
	push hl
	call DebugEnableSRAM
	ld a, b
	ld [rRAMB], a
	ld bc, wBoxDataEnd - wBoxDataStart
	call CopyData
	pop hl

; mark the source box as an empty box
	xor a
	ld [hli], a
	dec a
	ld [hl], a

	ld hl, sBox1 ; sBox5
	ld bc, sBox5 - sBox1 + 1 ; BUG: sBox5 should be sBank2AllBoxesChecksum
	call DebugCalcCheckSum
	ld [sBox5], a ; BUG: sBox5 should be sBank2AllBoxesChecksum
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

DebugCalcCheckSum: ; duplicate of CalcCheckSum
	ld d, 0
.loop
	ld a, [hli]
	add d
	ld d, a
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ld a, d
	cpl
	ret
