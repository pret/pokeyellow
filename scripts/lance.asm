LanceScript:
	call LanceScript_5a2c4
	call EnableAutoTextBoxDrawing
	ld hl, LanceTrainerHeaders
	ld de, LanceScriptPointers
	ld a, [W_LANCECURSCRIPT]
	call ExecuteCurMapScriptInTable
	ld [W_LANCECURSCRIPT], a
	ret

LanceScript_5a2c4:
	ld hl, wd126
	bit 5, [hl]
	res 5, [hl]
	ret z
	CheckEvent EVENT_LANCES_ROOM_LOCK_DOOR
	jr nz, .asm_5a2da
	ld a, $31
	ld b, $32
	jp .asm_5a2de

.asm_5a2da
	ld a, $72
	ld b, $73
.asm_5a2de
	push bc
	ld [wNewTileBlockID], a
	lb bc, 6, 2
	call .asm_5a2f0
	pop bc
	ld a, b
	ld [wNewTileBlockID], a
	lb bc, 6, 3
.asm_5a2f0
	predef_jump ReplaceTileBlock

LanceScript_5a2f5:
	xor a
	ld [W_LANCECURSCRIPT], a
	ret

LanceScriptPointers:
	dw LanceScript0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw LanceScript2
	dw LanceScript3
	dw LanceScript4

LanceScript4:
	ret

LanceScript0:
	CheckEvent EVENT_BEAT_LANCE
	ret nz
	ld hl, CoordsData_5a33e
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
	xor a
	ld [hJoyHeld], a
	ld a, [wCoordIndex]
	cp $3
	jr nc, .asm_5a325
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	jp DisplayTextID
.asm_5a325
	cp $5
	jr z, LanceScript_5a35b
	CheckAndSetEvent EVENT_LANCES_ROOM_LOCK_DOOR
	ret nz
	ld hl, wd126
	set 5, [hl]
	ld a, SFX_GO_INSIDE
	call PlaySound
	jp LanceScript_5a2c4

CoordsData_5a33e:
	db $01,$05
	db $02,$06
	db $0B,$05
	db $0B,$06
	db $10,$18
	db $FF

LanceScript2:
	call EndTrainerBattle
	ld a, [wIsInBattle]
	cp $ff
	jp z, LanceScript_5a2f5
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	jp DisplayTextID

LanceScript_5a35b:
	ld a, $ff
	ld [wJoyIgnore], a
	ld hl, wSimulatedJoypadStatesEnd
	ld de, RLEList_5a379
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $3
	ld [W_LANCECURSCRIPT], a
	ld [W_CURMAPSCRIPT], a
	ret

RLEList_5a379:
	db D_UP, $0D
	db D_LEFT, $0C
	db D_DOWN, $07
	db D_LEFT, $06
	db $FF

LanceScript3:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	xor a
	ld [wJoyIgnore], a
	ld [W_LANCECURSCRIPT], a
	ld [W_CURMAPSCRIPT], a
	ret

LanceTextPointers:
	dw LanceText1

LanceTrainerHeaders:
LanceTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_LANCES_ROOM_TRAINER_0
	db ($0 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_LANCES_ROOM_TRAINER_0
	dw LanceBeforeBattleText ; TextBeforeBattle
	dw LanceAfterBattleText ; TextAfterBattle
	dw LanceEndBattleText ; TextEndBattle
	dw LanceEndBattleText ; TextEndBattle

	db $ff

LanceText1:
	TX_ASM
	ld hl, LanceTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

LanceBeforeBattleText:
	TX_FAR _LanceBeforeBattleText
	db "@"

LanceEndBattleText:
	TX_FAR _LanceEndBattleText
	db "@"

LanceAfterBattleText:
	TX_FAR _LanceAfterBattleText
	TX_ASM
	SetEvent EVENT_BEAT_LANCE
	jp TextScriptEnd
