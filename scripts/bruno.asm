BrunoScript:
	call BrunoScript_762ec
	call EnableAutoTextBoxDrawing
	ld hl, BrunoTrainerHeaders
	ld de, BrunoScriptPointers
	ld a, [W_BRUNOCURSCRIPT]
	call ExecuteCurMapScriptInTable
	ld [W_BRUNOCURSCRIPT], a
	ret

BrunoScript_762ec:
	ld hl, wd126
	bit 5, [hl]
	res 5, [hl]
	ret z
	CheckEvent EVENT_BEAT_BRUNOS_ROOM_TRAINER_0
	jr z, .asm_76300
	ld a, $5
	jp BrunoScript_76302
.asm_76300
	ld a, $24

BrunoScript_76302:
	ld [wNewTileBlockID], a
	lb bc, 0, 2
	predef_jump ReplaceTileBlock

BrunoScript_7630d:
	xor a
	ld [W_BRUNOCURSCRIPT], a
	ret

BrunoScriptPointers:
	dw BrunoScript0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw BrunoScript2
	dw BrunoScript3
	dw BrunoScript4

BrunoScript4:
	ret

BrunoScript_7631d:
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
	ld [W_BRUNOCURSCRIPT], a
	ld [W_CURMAPSCRIPT], a
	ret

BrunoScript0:
	ld hl, CoordsData_7637a
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
	xor a
	ld [hJoyPressed], a
	ld [hJoyHeld], a
	ld [wSimulatedJoypadStatesEnd], a
	ld [wSimulatedJoypadStatesIndex], a
	ld a, [wCoordIndex]
	cp $3
	jr c, .asm_7635d
	CheckAndSetEvent EVENT_AUTOWALKED_INTO_BRUNOS_ROOM
	jr z, BrunoScript_7631d
.asm_7635d
	ld a, $2
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $3
	ld [W_BRUNOCURSCRIPT], a
	ld [W_CURMAPSCRIPT], a
	ret

CoordsData_7637a:
	db $0A,$04
	db $0A,$05
	db $0B,$04
	db $0B,$05
	db $FF

BrunoScript3:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	xor a
	ld [wJoyIgnore], a
	ld [W_BRUNOCURSCRIPT], a
	ld [W_CURMAPSCRIPT], a
	ret

BrunoScript2:
	call EndTrainerBattle
	ld a, [wIsInBattle]
	cp $ff
	jp z, BrunoScript_7630d
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	jp DisplayTextID

BrunoTextPointers:
	dw BrunoText1
	dw BrunoDontRunAwayText

BrunoTrainerHeaders:
BrunoTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_BRUNOS_ROOM_TRAINER_0
	db ($0 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_BRUNOS_ROOM_TRAINER_0
	dw BrunoBeforeBattleText ; TextBeforeBattle
	dw BrunoAfterBattleText ; TextAfterBattle
	dw BrunoEndBattleText ; TextEndBattle
	dw BrunoEndBattleText ; TextEndBattle

	db $ff

BrunoText1:
	TX_ASM
	ld hl, BrunoTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

BrunoBeforeBattleText:
	TX_FAR _BrunoBeforeBattleText
	db "@"

BrunoEndBattleText:
	TX_FAR _BrunoEndBattleText
	db "@"

BrunoAfterBattleText:
	TX_FAR _BrunoAfterBattleText
	db "@"

BrunoDontRunAwayText:
	TX_FAR _BrunoDontRunAwayText
	db "@"
