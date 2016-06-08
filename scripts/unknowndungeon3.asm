UnknownDungeon3Script:
	call EnableAutoTextBoxDrawing
	ld hl, UnknownDungeon3TrainerHeaders
	ld de, UnknownDungeon3ScriptPointers
	ld a, [W_UNKNOWNDUNGEON3CURSCRIPT]
	call ExecuteCurMapScriptInTable
	ld [W_UNKNOWNDUNGEON3CURSCRIPT], a
	ret

UnknownDungeon3ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

UnknownDungeon3TextPointers:
	dw UnknownDungeon3Text1
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText

UnknownDungeon3TrainerHeaders:
UnknownDungeon3TrainerHeader0:
	dbEventFlagBit EVENT_BEAT_UNKNOWN_DUNGEON_3_TRAINER_0
	db ($0 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_UNKNOWN_DUNGEON_3_TRAINER_0
	dw UnknownDungeon3MewtwoText ; TextBeforeBattle
	dw UnknownDungeon3MewtwoText ; TextAfterBattle
	dw UnknownDungeon3MewtwoText ; TextEndBattle
	dw UnknownDungeon3MewtwoText ; TextEndBattle

	db $ff

UnknownDungeon3Text1:
	TX_ASM
	ld hl, UnknownDungeon3TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

UnknownDungeon3MewtwoText:
	TX_FAR _UnknownDungeon3MewtwoText
	TX_ASM
	ld a, MEWTWO
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd
