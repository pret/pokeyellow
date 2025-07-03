MtMoonB2F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, MtMoon3TrainerHeaders
	ld de, MtMoonB2F_ScriptPointers
	ld a, [wMtMoonB2FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wMtMoonB2FCurScript], a
	CheckEvent EVENT_BEAT_MT_MOON_EXIT_SUPER_NERD
	ret z
	ld hl, MtMoonB2FFossilAreaCoords
	call ArePlayerCoordsInArray
	jr nc, .enable_battles
	ld hl, wStatusFlags4
	set BIT_NO_BATTLES, [hl]
	ret
.enable_battles
	ld hl, wStatusFlags4
	res BIT_NO_BATTLES, [hl]
	ret

MtMoonB2FFossilAreaCoords:
	dbmapcoord 11,  5
	dbmapcoord 12,  5
	dbmapcoord 13,  5
	dbmapcoord 14,  5
	dbmapcoord 11,  6
	dbmapcoord 12,  6
	dbmapcoord 13,  6
	dbmapcoord 14,  6
	dbmapcoord 11,  7
	dbmapcoord 12,  7
	dbmapcoord 13,  7
	dbmapcoord 14,  7
	dbmapcoord 11,  8
	dbmapcoord 12,  8
	dbmapcoord 13,  8
	dbmapcoord 14,  8
	db -1 ; end

MtMoonB2FResetScripts:
	CheckAndResetEvent EVENT_57E
	call nz, MtMoonB2FScript_HideJessieJames
	xor a
	ld [wJoyIgnore], a
MtMoonB2FSetScript:
	ld [wMtMoonB2FCurScript], a
	ld [wCurMapScript], a
	ret

MtMoonB2FScript_HideJessieJames:
	ld a, HS_MT_MOON_B2F_JESSIE
	call MtMoonB2FScript_HideObject
	ld a, HS_MT_MOON_B2F_JAMES
	call MtMoonB2FScript_HideObject
	ret

MtMoonB2F_ScriptPointers:
	def_script_pointers
	dw_const MtMoonB2FDefaultScript,                   SCRIPT_MTMOONB2F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle,    SCRIPT_MTMOONB2F_START_BATTLE
	dw_const EndTrainerBattle,                         SCRIPT_MTMOONB2F_END_BATTLE
	dw_const MtMoonB2FDefeatedSuperNerdScript,         SCRIPT_MTMOONB2F_DEFEATED_SUPER_NERD
	dw_const MtMoonB2FMoveSuperNerdScript,             SCRIPT_MTMOONB2F_MOVE_SUPER_NERD
	dw_const MtMoonB2FSuperNerdTakesOtherFossilScript, SCRIPT_MTMOONB2F_SUPER_NERD_TAKES_OTHER_FOSSIL
	dw_const MtMoonB2FScript6,                         SCRIPT_MTMOONB2F_SCRIPT6
	dw_const MtMoonB2FScript7,                         SCRIPT_MTMOONB2F_SCRIPT7
	dw_const MtMoonB2FScript8,                         SCRIPT_MTMOONB2F_SCRIPT8
	dw_const MtMoonB2FScript9,                         SCRIPT_MTMOONB2F_SCRIPT9
	dw_const MtMoonB2FScript10,                        SCRIPT_MTMOONB2F_SCRIPT10
	dw_const MtMoonB2FScript11,                        SCRIPT_MTMOONB2F_SCRIPT11
	dw_const MtMoonB2FScript12,                        SCRIPT_MTMOONB2F_SCRIPT12
	dw_const MtMoonB2FScript13,                        SCRIPT_MTMOONB2F_SCRIPT13
	dw_const MtMoonB2FScript14,                        SCRIPT_MTMOONB2F_SCRIPT14
	dw_const MtMoonB2FScript15,                        SCRIPT_MTMOONB2F_SCRIPT15

MtMoonB2FDefaultScript:
IF DEF(_DEBUG)
	call DebugPressedOrHeldB
	ret nz
ENDC
	CheckEitherEventSet EVENT_GOT_DOME_FOSSIL, EVENT_GOT_HELIX_FOSSIL
	call z, MtMoonB2FScript_49d28
	CheckEvent EVENT_BEAT_MT_MOON_3_JESSIE_JAMES
	call z, MtMoonB2FScript_49e15
	ret

MtMoonB2FScript_49d28:
	CheckEvent EVENT_BEAT_MT_MOON_EXIT_SUPER_NERD
	jp nz, .asm_49d4b
	ld a, [wYCoord]
	cp 8
	jp nz, .asm_49d4b
	ld a, [wXCoord]
	cp 13
	jp nz, .asm_49d4b
	xor a
	ldh [hJoyHeld], a
	ld a, TEXT_MTMOONB2F_SUPER_NERD
	ldh [hTextID], a
	call DisplayTextID
	ret

.asm_49d4b
	CheckEitherEventSet EVENT_GOT_DOME_FOSSIL, EVENT_GOT_HELIX_FOSSIL
	jp z, CheckFightingMapTrainers
	ret

MtMoonB2FDefeatedSuperNerdScript:
	ld a, [wIsInBattle]
	cp $ff
	jp z, MtMoonB2FResetScripts
	call UpdateSprites
	call Delay3
	SetEvent EVENT_BEAT_MT_MOON_EXIT_SUPER_NERD
	xor a
	ld [wJoyIgnore], a
	ld a, SCRIPT_MTMOONB2F_DEFAULT
	call MtMoonB2FSetScript
	ret

MtMoonB2FMoveSuperNerdScript:
	ld a, MTMOONB2F_SUPER_NERD
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	ld hl, CoordsData_49dc7
	call ArePlayerCoordsInArray
	jr c, .asm_49da8
	ld hl, CoordsData_49dc0
	call ArePlayerCoordsInArray
	jr c, .asm_49db0
	ld hl, CoordsData_49dd5
	call ArePlayerCoordsInArray
	jr c, .asm_49d9b
	ld hl, CoordsData_49dce
	call ArePlayerCoordsInArray
	jr c, .asm_49da3
	jp CheckFightingMapTrainers

.asm_49d9b
	ld b, SPRITE_FACING_LEFT
	ld hl, PikachuMovementData_49dd8
	call MtMoonB2FScript_ApplyPikachuMovementData
.asm_49da3
	ld de, MovementData_49ddd
	jr .asm_49db3

.asm_49da8
	ld b, SPRITE_FACING_RIGHT
	ld hl, PikachuMovementData_49dca
	call MtMoonB2FScript_ApplyPikachuMovementData
.asm_49db0
	ld de, MovementData_49ddc
.asm_49db3
	ld a, MTMOONB2F_SUPER_NERD
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, SCRIPT_MTMOONB2F_SUPER_NERD_TAKES_OTHER_FOSSIL
	call MtMoonB2FSetScript
	ret

CoordsData_49dc0:
	dbmapcoord 12,  7
	dbmapcoord 11,  6
	dbmapcoord 12,  5
	db -1 ; end

CoordsData_49dc7:
	dbmapcoord 12,  7
	db -1 ; end

PikachuMovementData_49dca:
	db $00
	db $35
	db $33
	db $3f

CoordsData_49dce:
	dbmapcoord 13,  7
	dbmapcoord 14,  6
	dbmapcoord 14,  5
	db -1 ; end

CoordsData_49dd5:
	dbmapcoord 13,  7
	db -1 ; end

PikachuMovementData_49dd8:
	db $00
	db $35
	db $34
	db $3f

MovementData_49ddc:
	db NPC_MOVEMENT_RIGHT
MovementData_49ddd:
	db NPC_MOVEMENT_UP
	db -1 ; end

MtMoonB2FSuperNerdTakesOtherFossilScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, TEXT_MTMOONB2F_SUPER_NERD_THEN_THIS_IS_MINE
	ldh [hTextID], a
	call DisplayTextID
	CheckEvent EVENT_GOT_HELIX_FOSSIL
	jr z, .asm_49e1d
	ld a, HS_MT_MOON_B2F_FOSSIL_1
	jr .asm_49e1f
.asm_49e1d
	ld a, HS_MT_MOON_B2F_FOSSIL_2
.asm_49e1f
	ld [wMissableObjectIndex], a
	predef HideObject
	xor a
	ld [wJoyIgnore], a
	ld a, SCRIPT_MTMOONB2F_DEFAULT
	call MtMoonB2FSetScript
	ret

MtMoonB2FScript_49e15:
	ld a, [wXCoord]
	cp $3
	ret nz
	ld a, [wYCoord]
	cp $5
	ret nz
	call StopAllMusic
	ld c, BANK(Music_MeetJessieJames)
	ld a, MUSIC_MEET_JESSIE_JAMES
	call PlayMusic
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, HS_MT_MOON_B2F_JESSIE
	call MtMoonB2FScript_ShowObject
	ld a, HS_MT_MOON_B2F_JAMES
	call MtMoonB2FScript_ShowObject
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, TEXT_MTMOONB2F_TEXT12
	ldh [hTextID], a
	call DisplayTextID
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_UP
	ld [wSimulatedJoypadStatesEnd], a
	call StartSimulatingJoypadStates
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_MTMOONB2F_SCRIPT6
	call MtMoonB2FSetScript
	ret

MovementData_f9e65:
	db $06
MovementData_f9e66:
	db $06
	db $06
	db $06
	db $06
	db $06
	db $FF

MtMoonB2FScript6:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	ld a, MTMOONB2F_JESSIE
	ldh [hSpriteIndex], a
	ld de, MovementData_f9e65
	call MoveSprite
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_MTMOONB2F_SCRIPT7
	call MtMoonB2FSetScript
	ret

MtMoonB2FScript7:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
MtMoonB2FScript8:
	ld a, $2
	ld [wSprite02StateData1MovementStatus], a
	ld a, SPRITE_FACING_DOWN
	ld [wSprite02StateData1FacingDirection], a
MtMoonB2FScript9:
	ld a, MTMOONB2F_JAMES
	ldh [hSpriteIndex], a
	ld de, MovementData_f9e66
	call MoveSprite
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_MTMOONB2F_SCRIPT10
	call MtMoonB2FSetScript
	ret

MtMoonB2FScript10:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
MtMoonB2FScript11:
	ld a, $2
	ld [wSprite06StateData1MovementStatus], a
	ld a, SPRITE_FACING_LEFT
	ld [wSprite06StateData1FacingDirection], a
	call Delay3
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, TEXT_MTMOONB2F_TEXT13
	ldh [hTextID], a
	call DisplayTextID
MtMoonB2FScript12:
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, MtMoonB2FJessieJamesEndBattleText
	ld de, MtMoonB2FJessieJamesEndBattleText
	call SaveEndBattleTextPointers
	ld a, OPP_ROCKET
	ld [wCurOpponent], a
	ld a, $2a
	ld [wTrainerNo], a
	xor a
	ldh [hJoyHeld], a
	ld [wJoyIgnore], a
	SetEvent EVENT_57E
	ld a, SCRIPT_MTMOONB2F_SCRIPT13
	call MtMoonB2FSetScript
	ret

MtMoonB2FScript13:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wIsInBattle]
	cp $ff
	jp z, MtMoonB2FResetScripts
	ld a, $2
	ld [wSprite02StateData1MovementStatus], a
	ld [wSprite06StateData1MovementStatus], a
	xor a
	ld [wSprite02StateData1FacingDirection], a
	ld [wSprite06StateData1FacingDirection], a
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, TEXT_MTMOONB2F_TEXT14
	ldh [hTextID], a
	call DisplayTextID
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call StopAllMusic
	ld c, BANK(Music_MeetJessieJames)
	ld a, MUSIC_MEET_JESSIE_JAMES
	call PlayMusic
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_MTMOONB2F_SCRIPT14
	call MtMoonB2FSetScript
	ret

MtMoonB2FScript14:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	call GBFadeOutToBlack
	ld a, HS_MT_MOON_B2F_JESSIE
	call MtMoonB2FScript_HideObject
	ld a, HS_MT_MOON_B2F_JAMES
	call MtMoonB2FScript_HideObject
	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack
	ld a, SCRIPT_MTMOONB2F_SCRIPT15
	call MtMoonB2FSetScript
	ret

MtMoonB2FScript15:
	call PlayDefaultMusic
	xor a
	ldh [hJoyHeld], a
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_MT_MOON_3_JESSIE_JAMES
	ResetEventReuseHL EVENT_57E
	ld a, SCRIPT_MTMOONB2F_DEFAULT
	call MtMoonB2FSetScript
	ret

MtMoonB2FScript_ShowObject:
	ld [wMissableObjectIndex], a
	predef ShowObject
	call UpdateSprites
	call Delay3
	ret

MtMoonB2FScript_HideObject:
	ld [wMissableObjectIndex], a
	predef HideObject
	ret

MtMoonB2F_TextPointers:
	def_text_pointers
	dw_const MtMoonB2FSuperNerdText,                TEXT_MTMOONB2F_SUPER_NERD
	dw_const MtMoonB2FJessieJamesText,              TEXT_MTMOONB2F_JESSIE
	dw_const MtMoonB2FRocket1Text,                  TEXT_MTMOONB2F_ROCKET1
	dw_const MtMoonB2FRocket2Text,                  TEXT_MTMOONB2F_ROCKET2
	dw_const MtMoonB2FRocket3Text,                  TEXT_MTMOONB2F_ROCKET3
	dw_const MtMoonB2FJessieJamesText,              TEXT_MTMOONB2F_JAMES
	dw_const MtMoonB2FDomeFossilText,               TEXT_MTMOONB2F_DOME_FOSSIL
	dw_const MtMoonB2FHelixFossilText,              TEXT_MTMOONB2F_HELIX_FOSSIL
	dw_const PickUpItemText,                        TEXT_MTMOONB2F_HP_UP
	dw_const PickUpItemText,                        TEXT_MTMOONB2F_TM_MEGA_PUNCH
	dw_const MtMoonB2FSuperNerdThenThisIsMineText,  TEXT_MTMOONB2F_SUPER_NERD_THEN_THIS_IS_MINE
	dw_const MtMoonB2FText12,                       TEXT_MTMOONB2F_TEXT12
	dw_const MtMoonB2FText13,                       TEXT_MTMOONB2F_TEXT13
	dw_const MtMoonB2FText14,                       TEXT_MTMOONB2F_TEXT14

MtMoon3TrainerHeaders:
	def_trainers 3
MtMoon3TrainerHeader0:
	trainer EVENT_BEAT_MT_MOON_3_TRAINER_0, 4, MtMoonB2FRocket2BattleText, MtMoonB2FRocket2EndBattleText, MtMoonB2FRocket2AfterBattleText
MtMoon3TrainerHeader1:
	trainer EVENT_BEAT_MT_MOON_3_TRAINER_1, 4, MtMoonB2FRocket3BattleText, MtMoonB2FRocket3EndBattleText, MtMoonB2FRocket3AfterBattleText
MtMoon3TrainerHeader2:
	trainer EVENT_BEAT_MT_MOON_3_TRAINER_2, 4, MtMoonB2FRocket4BattleText, MtMoonB2FRocket4EndBattleText, MtMoonB2FRocket4AfterBattleText
	db -1 ; end

MtMoonB2FJessieJamesText:
	text_end

MtMoonB2FText12:
	text_far _MtMoonJessieJamesText1
	text_asm
	ld c, 10
	call DelayFrames
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, $0
	ld [wEmotionBubbleSpriteIndex], a
	ld a, EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	ld c, 20
	call DelayFrames
	jp TextScriptEnd

MtMoonB2FText13:
	text_far _MtMoonJessieJamesText2
	text_end

MtMoonB2FJessieJamesEndBattleText:
	text_far _MtMoonJessieJamesText3
	text_end

MtMoonB2FText14:
	text_far _MtMoonJessieJamesText4
	text_asm
	ld c, 64
	call DelayFrames
	jp TextScriptEnd

MtMoonB2FSuperNerdText:
	text_asm
	CheckEvent EVENT_BEAT_MT_MOON_EXIT_SUPER_NERD
	jr z, .beat_super_nerd
	CheckEitherEventSet EVENT_GOT_DOME_FOSSIL, EVENT_GOT_HELIX_FOSSIL, 1
	jr nz, .got_a_fossil
	ld hl, MtMoonB2fSuperNerdEachTakeOneText
	call PrintText
	jr .done
.beat_super_nerd
	ld hl, MtMoonB2FSuperNerdTheyreBothMineText
	call PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, MtMoonB2FSuperNerdOkIllShareText
	ld de, MtMoonB2FSuperNerdOkIllShareText
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, SCRIPT_MTMOONB2F_DEFEATED_SUPER_NERD
	call MtMoonB2FSetScript
	jr .done
.got_a_fossil
	ld hl, MtMoonB2FSuperNerdTheresAPokemonLabText
	call PrintText
.done
	jp TextScriptEnd

MtMoonB2FRocket1Text:
	text_asm
	ld hl, MtMoon3TrainerHeader0
	jr MtMoonB2FTalkToTrainer

MtMoonB2FRocket2Text:
	text_asm
	ld hl, MtMoon3TrainerHeader1
	jr MtMoonB2FTalkToTrainer

MtMoonB2FRocket3Text:
	text_asm
	ld hl, MtMoon3TrainerHeader2
MtMoonB2FTalkToTrainer:
	call TalkToTrainer
	jp TextScriptEnd

MtMoonB2FDomeFossilText:
	text_asm
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, .YouWantText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .done
	lb bc, DOME_FOSSIL, 1
	call GiveItem
	jp nc, MtMoonB2FYouHaveNoRoomText
	call MtMoonB2FReceivedFossilText
	ld a, HS_MT_MOON_B2F_FOSSIL_1
	ld [wMissableObjectIndex], a
	predef HideObject
	SetEvent EVENT_GOT_DOME_FOSSIL
	ld a, SCRIPT_MTMOONB2F_MOVE_SUPER_NERD
	call MtMoonB2FSetScript
.done
	jp TextScriptEnd

.YouWantText:
	text_far _MtMoonB2FDomeFossilYouWantText
	text_end

MtMoonB2FHelixFossilText:
	text_asm
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, .YouWantText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .done
	lb bc, HELIX_FOSSIL, 1
	call GiveItem
	jp nc, MtMoonB2FYouHaveNoRoomText
	call MtMoonB2FReceivedFossilText
	ld a, HS_MT_MOON_B2F_FOSSIL_2
	ld [wMissableObjectIndex], a
	predef HideObject
	SetEvent EVENT_GOT_HELIX_FOSSIL
	ld a, SCRIPT_MTMOONB2F_MOVE_SUPER_NERD
	call MtMoonB2FSetScript
.done
	jp TextScriptEnd

.YouWantText:
	text_far _MtMoonB2FHelixFossilYouWantText
	text_end

MtMoonB2FReceivedFossilText:
	ld hl, .Text
	jp PrintText

.Text:
	text_far _MtMoonB2FReceivedFossilText
	sound_get_key_item
	text_waitbutton
	text_end

MtMoonB2FYouHaveNoRoomText:
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _MtMoonB2FYouHaveNoRoomText
	text_waitbutton
	text_end

MtMoonB2FSuperNerdTheyreBothMineText:
	text_far _MtMoonB2FSuperNerdTheyreBothMineText
	text_end

MtMoonB2FSuperNerdOkIllShareText:
	text_far _MtMoonB2FSuperNerdOkIllShareText
	text_end

MtMoonB2fSuperNerdEachTakeOneText:
	text_far _MtMoonB2fSuperNerdEachTakeOneText
	text_end

MtMoonB2FSuperNerdTheresAPokemonLabText:
	text_far _MtMoonB2FSuperNerdTheresAPokemonLabText
	text_end

MtMoonB2FSuperNerdThenThisIsMineText:
	text_far _MtMoonB2FSuperNerdThenThisIsMineText
	sound_get_key_item
	text_end

MtMoonB2FRocket2BattleText:
	text_far _MtMoonB2FRocket2BattleText
	text_end

MtMoonB2FRocket2EndBattleText:
	text_far _MtMoonB2FRocket2EndBattleText
	text_end

MtMoonB2FRocket2AfterBattleText:
	text_far _MtMoonB2FRocket2AfterBattleText
	text_end

MtMoonB2FRocket3BattleText:
	text_far _MtMoonB2FRocket3BattleText
	text_end

MtMoonB2FRocket3EndBattleText:
	text_far _MtMoonB2FRocket3EndBattleText
	text_end

MtMoonB2FRocket3AfterBattleText:
	text_far _MtMoonB2FRocket3AfterBattleText
	text_end

MtMoonB2FRocket4BattleText:
	text_far _MtMoonB2FRocket4BattleText
	text_end

MtMoonB2FRocket4EndBattleText:
	text_far _MtMoonB2FRocket4EndBattleText
	text_end

MtMoonB2FRocket4AfterBattleText:
	text_far _MtMoonB2FRocket4AfterBattleText
	text_end
