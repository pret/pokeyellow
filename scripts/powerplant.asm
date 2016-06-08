PowerPlantScript:
	call EnableAutoTextBoxDrawing
	ld hl, PowerPlantTrainerHeaders
	ld de, PowerPlantScriptPointers
	ld a, [W_POWERPLANTCURSCRIPT]
	call ExecuteCurMapScriptInTable
	ld [W_POWERPLANTCURSCRIPT], a
	ret

PowerPlantScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

PowerPlantTextPointers:
	dw PowerPlantText1
	dw PowerPlantText2
	dw PowerPlantText3
	dw PowerPlantText4
	dw PowerPlantText5
	dw PowerPlantText6
	dw PowerPlantText7
	dw PowerPlantText8
	dw PowerPlantText9
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText

PowerPlantTrainerHeaders:
PowerPlantTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_POWER_PLANT_TRAINER_0
	db 0 ; view range
	dwEventFlagAddress EVENT_BEAT_POWER_PLANT_TRAINER_0
	dw VoltorbBattleText ; TextBeforeBattle
	dw VoltorbBattleText ; TextAfterBattle
	dw VoltorbBattleText ; TextEndBattle
	dw VoltorbBattleText ; TextEndBattle

PowerPlantTrainerHeader1:
	dbEventFlagBit EVENT_BEAT_POWER_PLANT_TRAINER_1
	db 0 ; view range
	dwEventFlagAddress EVENT_BEAT_POWER_PLANT_TRAINER_1
	dw VoltorbBattleText ; TextBeforeBattle
	dw VoltorbBattleText ; TextAfterBattle
	dw VoltorbBattleText ; TextEndBattle
	dw VoltorbBattleText ; TextEndBattle

PowerPlantTrainerHeader2:
	dbEventFlagBit EVENT_BEAT_POWER_PLANT_TRAINER_2
	db 0 ; view range
	dwEventFlagAddress EVENT_BEAT_POWER_PLANT_TRAINER_2
	dw VoltorbBattleText ; TextBeforeBattle
	dw VoltorbBattleText ; TextAfterBattle
	dw VoltorbBattleText ; TextEndBattle
	dw VoltorbBattleText ; TextEndBattle

PowerPlantTrainerHeader3:
	dbEventFlagBit EVENT_BEAT_POWER_PLANT_TRAINER_3
	db 0 ; view range
	dwEventFlagAddress EVENT_BEAT_POWER_PLANT_TRAINER_3
	dw VoltorbBattleText ; TextBeforeBattle
	dw VoltorbBattleText ; TextAfterBattle
	dw VoltorbBattleText ; TextEndBattle
	dw VoltorbBattleText ; TextEndBattle

PowerPlantTrainerHeader4:
	dbEventFlagBit EVENT_BEAT_POWER_PLANT_TRAINER_4
	db 0 ; view range
	dwEventFlagAddress EVENT_BEAT_POWER_PLANT_TRAINER_4
	dw VoltorbBattleText ; TextBeforeBattle
	dw VoltorbBattleText ; TextAfterBattle
	dw VoltorbBattleText ; TextEndBattle
	dw VoltorbBattleText ; TextEndBattle

PowerPlantTrainerHeader5:
	dbEventFlagBit EVENT_BEAT_POWER_PLANT_TRAINER_5
	db 0 ; view range
	dwEventFlagAddress EVENT_BEAT_POWER_PLANT_TRAINER_5
	dw VoltorbBattleText ; TextBeforeBattle
	dw VoltorbBattleText ; TextAfterBattle
	dw VoltorbBattleText ; TextEndBattle
	dw VoltorbBattleText ; TextEndBattle

PowerPlantTrainerHeader6:
	dbEventFlagBit EVENT_BEAT_POWER_PLANT_TRAINER_6
	db 0 ; view range
	dwEventFlagAddress EVENT_BEAT_POWER_PLANT_TRAINER_6
	dw VoltorbBattleText ; TextBeforeBattle
	dw VoltorbBattleText ; TextAfterBattle
	dw VoltorbBattleText ; TextEndBattle
	dw VoltorbBattleText ; TextEndBattle

PowerPlantTrainerHeader7:
	dbEventFlagBit EVENT_BEAT_POWER_PLANT_TRAINER_7, 1
	db 0 ; view range
	dwEventFlagAddress EVENT_BEAT_POWER_PLANT_TRAINER_7, 1
	dw VoltorbBattleText ; TextBeforeBattle
	dw VoltorbBattleText ; TextAfterBattle
	dw VoltorbBattleText ; TextEndBattle
	dw VoltorbBattleText ; TextEndBattle

PowerPlantTrainerHeader8:
	dbEventFlagBit EVENT_BEAT_POWER_PLANT_TRAINER_8, 1
	db 0 ; view range
	dwEventFlagAddress EVENT_BEAT_POWER_PLANT_TRAINER_8, 1
	dw ZapdosBattleText ; TextBeforeBattle
	dw ZapdosBattleText ; TextAfterBattle
	dw ZapdosBattleText ; TextEndBattle
	dw ZapdosBattleText ; TextEndBattle

	db $ff

InitVoltorbBattle:
	call TalkToTrainer
	ld a, [W_CURMAPSCRIPT]
	ld [W_POWERPLANTCURSCRIPT], a
	jp TextScriptEnd

PowerPlantText1:
	TX_ASM
	ld hl, PowerPlantTrainerHeader0
	jr InitVoltorbBattle

PowerPlantText2:
	TX_ASM
	ld hl, PowerPlantTrainerHeader1
	jr InitVoltorbBattle

PowerPlantText3:
	TX_ASM
	ld hl, PowerPlantTrainerHeader2
	jr InitVoltorbBattle

PowerPlantText4:
	TX_ASM
	ld hl, PowerPlantTrainerHeader3
	jr InitVoltorbBattle

PowerPlantText5:
	TX_ASM
	ld hl, PowerPlantTrainerHeader4
	jr InitVoltorbBattle

PowerPlantText6:
	TX_ASM
	ld hl, PowerPlantTrainerHeader5
	jr InitVoltorbBattle

PowerPlantText7:
	TX_ASM
	ld hl, PowerPlantTrainerHeader6
	jr InitVoltorbBattle

PowerPlantText8:
	TX_ASM
	ld hl, PowerPlantTrainerHeader7
	jr InitVoltorbBattle

PowerPlantText9:
	TX_ASM
	ld hl, PowerPlantTrainerHeader8
	jr InitVoltorbBattle

VoltorbBattleText:
	TX_FAR _VoltorbBattleText
	db "@"

ZapdosBattleText:
	TX_FAR _ZapdosBattleText
	TX_ASM
	ld a, ZAPDOS
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd
