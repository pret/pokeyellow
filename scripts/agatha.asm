AgathaScript:
	call AgathaScript_76443
	call EnableAutoTextBoxDrawing
	ld hl, AgathaTrainerHeaders
	ld de, AgathaScriptPointers
	ld a, [W_AGATHACURSCRIPT]
	call ExecuteCurMapScriptInTable
	ld [W_AGATHACURSCRIPT], a
	ret

AgathaScript_76443:
	ld hl, wd126
	bit 5, [hl]
	res 5, [hl]
	ret z
	CheckEvent EVENT_BEAT_AGATHAS_ROOM_TRAINER_0
	jr z, .asm_76457
	ld a, $e
	jp AgathaScript_76459
.asm_76457
	ld a, $3b

AgathaScript_76459:
	ld [wNewTileBlockID], a
	lb bc, 0, 2
	predef_jump ReplaceTileBlock

AgathaScript_76464:
	xor a
	ld [W_AGATHACURSCRIPT], a
	ret

AgathaScriptPointers:
	dw AgathaScript0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw AgathaScript2
	dw AgathaScript3
	dw AgathaScript4

AgathaScript4:
	ret

AgathaScript_76474:
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
	ld [W_AGATHACURSCRIPT], a
	ld [W_CURMAPSCRIPT], a
	ret

AgathaScript0:
	ld hl, CoordsData_764d1
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
	xor a
	ld [hJoyPressed], a
	ld [hJoyHeld], a
	ld [wSimulatedJoypadStatesEnd], a
	ld [wSimulatedJoypadStatesIndex], a
	ld a, [wCoordIndex]
	cp $3
	jr c, .asm_764b4
	CheckAndSetEvent EVENT_AUTOWALKED_INTO_AGATHAS_ROOM
	jr z, AgathaScript_76474
.asm_764b4
	ld a, $2
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $3
	ld [W_AGATHACURSCRIPT], a
	ld [W_CURMAPSCRIPT], a
	ret

CoordsData_764d1:
	db $0A,$04
	db $0A,$05
	db $0B,$04
	db $0B,$05
	db $FF

AgathaScript3:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	xor a
	ld [wJoyIgnore], a
	ld [W_AGATHACURSCRIPT], a
	ld [W_CURMAPSCRIPT], a
	ret

AgathaScript2:
	call EndTrainerBattle
	ld a, [wIsInBattle]
	cp $ff
	jp z, AgathaScript_76464
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $1
	ld [W_GARYCURSCRIPT], a
	ret

AgathaTextPointers:
	dw AgathaText1
	dw AgathaDontRunAwayText

AgathaTrainerHeaders:
AgathaTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_AGATHAS_ROOM_TRAINER_0
	db ($0 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_AGATHAS_ROOM_TRAINER_0
	dw AgathaBeforeBattleText ; TextBeforeBattle
	dw AgathaAfterBattleText ; TextAfterBattle
	dw AgathaEndBattleText ; TextEndBattle
	dw AgathaEndBattleText ; TextEndBattle

	db $ff

AgathaText1:
	TX_ASM
	ld hl, AgathaTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

AgathaBeforeBattleText:
	TX_FAR _AgathaBeforeBattleText
	db "@"

AgathaEndBattleText:
	TX_FAR _AgathaEndBattleText
	db "@"

AgathaAfterBattleText:
	TX_FAR _AgathaAfterBattleText
	db "@"

AgathaDontRunAwayText:
	TX_FAR _AgathaDontRunAwayText
	db "@"
