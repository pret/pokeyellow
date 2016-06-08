LoreleiScript:
	call LoreleiScript_76191
	call EnableAutoTextBoxDrawing
	ld hl, LoreleiTrainerHeaders
	ld de, LoreleiScriptPointers
	ld a, [W_LORELEICURSCRIPT]
	call ExecuteCurMapScriptInTable
	ld [W_LORELEICURSCRIPT], a
	ret

LoreleiScript_76191:
	ld hl, wd126
	bit 5, [hl]
	res 5, [hl]
	ret z
	ld hl, wBeatLorelei
	set 1, [hl]
	CheckEvent EVENT_BEAT_LORELEIS_ROOM_TRAINER_0
	jr z, .asm_761a9
	ld a, $5
	jr .asm_761ab
.asm_761a9
	ld a, $24
.asm_761ab
	ld [wNewTileBlockID], a
	lb bc, 0, 2
	predef_jump ReplaceTileBlock

LoreleiScript_761b6:
	xor a
	ld [W_LORELEICURSCRIPT], a
	ret

LoreleiScriptPointers:
	dw LoreleiScript0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw LoreleiScript2
	dw LoreleiScript3
	dw LoreleiScript4

LoreleiScript4:
	ret

LoreleiScript_761c6:
	ld hl, wSimulatedJoypadStatesEnd
	ld a, D_UP
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $6
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $3
	ld [W_LORELEICURSCRIPT], a
	ld [W_CURMAPSCRIPT], a
	ret

LoreleiScript0:
	ld hl, CoordsData_76223
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
	xor a
	ld [hJoyPressed], a
	ld [hJoyHeld], a
	ld [wSimulatedJoypadStatesEnd], a
	ld [wSimulatedJoypadStatesIndex], a
	ld a, [wCoordIndex]
	cp $3
	jr c, .asm_76206
	CheckAndSetEvent EVENT_AUTOWALKED_INTO_LORELEIS_ROOM
	jr z, LoreleiScript_761c6
.asm_76206
	ld a, $2
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $3
	ld [W_LORELEICURSCRIPT], a
	ld [W_CURMAPSCRIPT], a
	ret

CoordsData_76223:
	db $0A,$04
	db $0A,$05
	db $0B,$04
	db $0B,$05
	db $FF

LoreleiScript3:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	xor a
	ld [wJoyIgnore], a
	ld [W_LORELEICURSCRIPT], a
	ld [W_CURMAPSCRIPT], a
	ret
LoreleiScript2:
	call EndTrainerBattle
	ld a, [wIsInBattle]
	cp $ff
	jp z, LoreleiScript_761b6
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	jp DisplayTextID

LoreleiTextPointers:
	dw LoreleiText1
	dw LoreleiDontRunAwayText

LoreleiTrainerHeaders:
LoreleiTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_LORELEIS_ROOM_TRAINER_0
	db ($0 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_LORELEIS_ROOM_TRAINER_0
	dw LoreleiBeforeBattleText ; TextBeforeBattle
	dw LoreleiAfterBattleText ; TextAfterBattle
	dw LoreleiEndBattleText ; TextEndBattle
	dw LoreleiEndBattleText ; TextEndBattle

	db $ff

LoreleiText1:
	TX_ASM
	ld hl, LoreleiTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

LoreleiBeforeBattleText:
	TX_FAR _LoreleiBeforeBattleText
	db "@"

LoreleiEndBattleText:
	TX_FAR _LoreleiEndBattleText
	db "@"

LoreleiAfterBattleText:
	TX_FAR _LoreleiAfterBattleText
	db "@"

LoreleiDontRunAwayText:
	TX_FAR _LoreleiDontRunAwayText
	db "@"
