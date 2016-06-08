SeafoamIslands5Script:
	call EnableAutoTextBoxDrawing
	ld a, [wSeafoamIslands5CurScript]
	ld hl, SeafoamIslands5ScriptPointers
	jp JumpTable

SeafoamIslands5Script_467a5:
	xor a
	ld [wJoyIgnore], a
	ld [wSeafoamIslands5CurScript], a
	ld [W_CURMAPSCRIPT], a
	ret

SeafoamIslands5ScriptPointers:
	dw SeafoamIslands5Script0
	dw SeafoamIslands5Script1
	dw SeafoamIslands5Script2
	dw SeafoamIslands5Script3
	dw SeafoamIslands5Script4

SeafoamIslands5Script4:
	ld a, [wIsInBattle]
	cp $ff
	jr z, SeafoamIslands5Script_467a5
	call EndTrainerBattle
	ld a, $0
	ld [wSeafoamIslands5CurScript], a
	ret

SeafoamIslands5Script0:
	CheckBothEventsSet EVENT_SEAFOAM3_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM3_BOULDER2_DOWN_HOLE
	ret z
	ld hl, CoordsData_467fe
	call ArePlayerCoordsInArray
	ret nc
	ld a, [wCoordIndex]
	cp $3
	jr nc, .asm_467e6
	ld a, NPC_MOVEMENT_UP
	ld [wSimulatedJoypadStatesEnd + 1], a
	ld a, 2
	jr .asm_467e8
.asm_467e6
	ld a, 1
.asm_467e8
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	call StartSimulatingJoypadStates
	ld hl, wFlags_D733
	res 2, [hl]
	ld a, $1
	ld [wSeafoamIslands5CurScript], a
	ret

CoordsData_467fe:
	db $11,$14
	db $11,$15
	db $10,$14
	db $10,$15
	db $FF

SeafoamIslands5Script1:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, $0
	ld [wSeafoamIslands5CurScript], a
	ret

SeafoamIslands5Script2:
	CheckBothEventsSet EVENT_SEAFOAM4_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM4_BOULDER2_DOWN_HOLE
	ld a, $0
	jr z, .asm_46849
	ld hl, CoordsData_4684d
	call ArePlayerCoordsInArray
	ld a, $0
	jr nc, .asm_46849
	ld a, [wCoordIndex]
	cp $1
	jr nz, .asm_46837
	ld de, RLEMovementData_46859
	jr .asm_4683a
.asm_46837
	ld de, RLEMovementData_46852
.asm_4683a
	ld hl, wSimulatedJoypadStatesEnd
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $3
.asm_46849
	ld [wSeafoamIslands5CurScript], a
	ret

CoordsData_4684d:
	db $0E,$04
	db $0E,$05
	db $FF

RLEMovementData_46852:
	db D_UP,$03
	db D_RIGHT,$02
	db D_UP,$01
	db $FF

RLEMovementData_46859:
	db D_UP,$03
	db D_RIGHT,$03
	db D_UP,$01
	db $FF

SeafoamIslands5Script3:
	ld a, [wSimulatedJoypadStatesIndex]
	ld b, a
	cp $1
	call z, SeaFoamIslands5Script_46872
	ld a, b
	and a
	ret nz
	ld a, $0
	ld [wSeafoamIslands5CurScript], a
	ret

SeaFoamIslands5Script_46872:
	xor a
	ld [wWalkBikeSurfState], a
	ld [wWalkBikeSurfStateCopy], a
	jp ForceBikeOrSurf

SeafoamIslands5TextPointers:
	dw BoulderText
	dw BoulderText
	dw SeafoamIslands5Text3
	dw SeafoamIslands5Text4
	dw SeafoamIslands5Text5

SeafoamIslands5TrainerHeaders:
SeafoamIslands5TrainerHeader0:
	dbEventFlagBit EVENT_BEAT_SEAFOAM_ISLANDS_5_TRAINER_0
	db ($0 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_SEAFOAM_ISLANDS_5_TRAINER_0
	dw SeafoamIslands5BattleText2 ; TextBeforeBattle
	dw SeafoamIslands5BattleText2 ; TextAfterBattle
	dw SeafoamIslands5BattleText2 ; TextEndBattle
	dw SeafoamIslands5BattleText2 ; TextEndBattle

	db $ff

SeafoamIslands5Text3:
	TX_ASM
	ld hl, SeafoamIslands5TrainerHeader0
	call TalkToTrainer
	ld a, $4
	ld [wSeafoamIslands5CurScript], a
	jp TextScriptEnd

SeafoamIslands5BattleText2:
	TX_FAR _SeafoamIslands5BattleText2
	TX_ASM
	ld a, ARTICUNO
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

SeafoamIslands5Text4:
	TX_FAR _SeafoamIslands5Text4
	db "@"

SeafoamIslands5Text5:
	TX_FAR _SeafoamIslands5Text5
	db "@"
