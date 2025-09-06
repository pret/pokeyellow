RocketHideoutB4F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, RocketHideout4TrainerHeaders
	ld de, RocketHideoutB4F_ScriptPointers
	ld a, [wRocketHideoutB4FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wRocketHideoutB4FCurScript], a
	ret

RocketHideoutB4FResetScripts:
	CheckAndResetEvent EVENT_6A0
	call nz, RocketHideoutB4FScript_HideJessieJames
	xor a
	ld [wJoyIgnore], a
RocketHideoutB4FSetScript:
	ld [wRocketHideoutB4FCurScript], a
	ld [wCurMapScript], a
	ret

RocketHideoutB4FScript_HideJessieJames:
	ld a, HS_ROCKET_HIDEOUT_B4F_JAMES
	call RocketHideoutB4FScript_HideObject
	ld a, HS_ROCKET_HIDEOUT_B4F_JESSIE
	call RocketHideoutB4FScript_HideObject
	ret

RocketHideoutB4F_ScriptPointers:
	def_script_pointers
	dw_const RocketHideoutB4FDefaultScript,                 SCRIPT_ROCKETHIDEOUTB4F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle,         SCRIPT_ROCKETHIDEOUTB4F_SCRIPT1
	dw_const EndTrainerBattle,                              SCRIPT_ROCKETHIDEOUTB4F_SCRIPT2
	dw_const RocketHideoutB4FBeatGiovanniScript,            SCRIPT_ROCKETHIDEOUTB4F_BEAT_GIOVANNI
	dw_const RocketHideoutB4FJamesMoveScript,               SCRIPT_ROCKETHIDEOUTB4F_JAMES_MOVE
	dw_const RocketHideoutB4FJamesWaitScript,               SCRIPT_ROCKETHIDEOUTB4F_JAMES_WAIT
	dw_const RocketHideoutB4FJamesSetFacingDirectionScript, SCRIPT_ROCKETHIDEOUTB4F_JAMES_FACING
	dw_const RocketHideoutB4FJesseMoveScript,               SCRIPT_ROCKETHIDEOUTB4F_JESSE_MOVE
	dw_const RocketHideoutB4FJesseWaitScript,               SCRIPT_ROCKETHIDEOUTB4F_JESSE_WAIT
	dw_const RocketHideoutB4FJesseSetFacingDirectionScript, SCRIPT_ROCKETHIDEOUTB4F_JESSE_FACING
	dw_const RocketHideoutB4FJesseJamesStartBattleScript,   SCRIPT_ROCKETHIDEOUTB4F_JESSE_JAMES_START_BATTLE
	dw_const RocketHideoutB4FJesseJamesAfterBattleScript,   SCRIPT_ROCKETHIDEOUTB4F_JESSE_JAMES_AFTER_BATTLE
	dw_const RocketHideoutB4FJesseJamesExitScript,          SCRIPT_ROCKETHIDEOUTB4F_JESSE_JAMES_EXIT
	dw_const RocketHideoutB4FJesseJamesCleanupScript,       SCRIPT_ROCKETHIDEOUTB4F_JESSE_JAMES_CLEANUP

RocketHideoutB4FBeatGiovanniScript:
	ld a, [wIsInBattle]
	cp -1
	jp z, RocketHideoutB4FResetScripts
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_ROCKET_HIDEOUT_GIOVANNI
	ld a, TEXT_ROCKETHIDEOUTB4F_GIOVANNI_HOPE_WE_MEET_AGAIN
	ldh [hTextID], a
	call DisplayTextID
	call GBFadeOutToBlack
	ld a, HS_ROCKET_HIDEOUT_B4F_GIOVANNI
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_ROCKET_HIDEOUT_B4F_ITEM_4
	ld [wMissableObjectIndex], a
	predef ShowObject
	call UpdateSprites
	call GBFadeInFromBlack
	xor a
	ld [wJoyIgnore], a
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]
	ld a, SCRIPT_ROCKETHIDEOUTB4F_DEFAULT
	ld [wRocketHideoutB4FCurScript], a
	ld [wCurMapScript], a
	ret

RocketHideoutB4FDefaultScript:
IF DEF(_DEBUG)
	call DebugPressedOrHeldB
	ret nz
ENDC
	CheckEvent EVENT_BEAT_ROCKET_HIDEOUT_4_JESSIE_JAMES
	call z, RocketHideoutB4FJesseJamesScript
	CheckEvent EVENT_BEAT_ROCKET_HIDEOUT_4_TRAINER_2
	call z, CheckFightingMapTrainers
	ret

RocketHideoutB4FJesseJamesScript:
	ld a, [wYCoord]
	cp 14
	ret nz
	ResetEvent EVENT_ROCKET_HIDEOUT_4_JESSIE_JAMES_ON_LEFT
	ld a, [wXCoord]
	cp 24
	jr z, .playerOnLeft
	ld a, [wXCoord]
	cp 25
	ret nz
	SetEvent EVENT_ROCKET_HIDEOUT_4_JESSIE_JAMES_ON_LEFT
.playerOnLeft
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	call StopAllMusic
	ld c, BANK(Music_MeetJessieJames)
	ld a, MUSIC_MEET_JESSIE_JAMES
	call PlayMusic
	call UpdateSprites
	call Delay3
	call UpdateSprites
	call Delay3
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, TEXT_ROCKETHIDEOUTB4F_JESSE_JAMES_SPOTTED
	ldh [hTextID], a
	call DisplayTextID
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, HS_ROCKET_HIDEOUT_B4F_JAMES
	call RocketHideoutB4FScript_ShowObject
	ld a, HS_ROCKET_HIDEOUT_B4F_JESSIE
	call RocketHideoutB4FScript_ShowObject
	ld a, SCRIPT_ROCKETHIDEOUTB4F_JAMES_MOVE
	call RocketHideoutB4FSetScript
	ret

RocketHideoutB4FJessieJamesLongMove:
	db NPC_MOVEMENT_DOWN_FAST 
RocketHideoutB4FJessieJamesShortMove:
	db NPC_MOVEMENT_DOWN_FAST 
	db NPC_MOVEMENT_DOWN_FAST 
	db NPC_MOVEMENT_DOWN_FAST 
	db -1
	
RocketHideoutB4FJamesMoveScript:
	ld de, RocketHideoutB4FJessieJamesLongMove
	CheckEvent EVENT_ROCKET_HIDEOUT_4_JESSIE_JAMES_ON_LEFT
	jr z, .playerStandingRight
	ld de, RocketHideoutB4FJessieJamesShortMove
.playerStandingRight
	ld a, ROCKETHIDEOUTB4F_JAMES
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_ROCKETHIDEOUTB4F_JAMES_WAIT
	call RocketHideoutB4FSetScript
	ret

RocketHideoutB4FJamesWaitScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
RocketHideoutB4FJamesSetFacingDirectionScript:
	ld a, 2
	ld [wSprite02StateData1MovementStatus], a
	ld a, SPRITE_FACING_LEFT
	ld [wSprite02StateData1FacingDirection], a
	CheckEvent EVENT_ROCKET_HIDEOUT_4_JESSIE_JAMES_ON_LEFT
	jr z, .playerStandingRight
	ld a, SPRITE_FACING_DOWN
	ld [wSprite02StateData1FacingDirection], a
.playerStandingRight
	call Delay3
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
RocketHideoutB4FJesseMoveScript:
	ld de, RocketHideoutB4FJessieJamesShortMove
	CheckEvent EVENT_ROCKET_HIDEOUT_4_JESSIE_JAMES_ON_LEFT
	jr z, .playerStandingRight
	ld de, RocketHideoutB4FJessieJamesLongMove
.playerStandingRight
	ld a, ROCKETHIDEOUTB4F_JESSIE
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_ROCKETHIDEOUTB4F_JESSE_WAIT
	call RocketHideoutB4FSetScript
	ret

RocketHideoutB4FJesseWaitScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
RocketHideoutB4FJesseSetFacingDirectionScript:
	ld a, 2
	ld [wSprite03StateData1MovementStatus], a
	ld a, SPRITE_FACING_DOWN
	ld [wSprite03StateData1FacingDirection], a
	CheckEvent EVENT_ROCKET_HIDEOUT_4_JESSIE_JAMES_ON_LEFT
	jr z, .playerStandingRight
	ld a, SPRITE_FACING_RIGHT
	ld [wSprite03StateData1FacingDirection], a
.playerStandingRight
	call Delay3
	ld a, TEXT_ROCKETHIDEOUTB4F_JESSE_JAMES_PREBATTLE
	ldh [hTextID], a
	call DisplayTextID
RocketHideoutB4FJesseJamesStartBattleScript:
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, RocketHideoutB4FJessieJamesEndBattleText
	ld de, RocketHideoutB4FJessieJamesEndBattleText
	call SaveEndBattleTextPointers
	ld a, OPP_ROCKET
	ld [wCurOpponent], a
	ld a, $2b
	ld [wTrainerNo], a
	xor a
	ldh [hJoyHeld], a
	ld [wJoyIgnore], a
	SetEvent EVENT_6A0
	ld a, SCRIPT_ROCKETHIDEOUTB4F_JESSE_JAMES_AFTER_BATTLE
	call RocketHideoutB4FSetScript
	ret

RocketHideoutB4FJesseJamesAfterBattleScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wIsInBattle]
	cp -1
	jp z, RocketHideoutB4FResetScripts
	ld a, 2
	ld [wSprite02StateData1MovementStatus], a
	ld [wSprite03StateData1MovementStatus], a
	xor a
	ld [wSprite02StateData1FacingDirection], a
	ld [wSprite03StateData1FacingDirection], a
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, TEXT_ROCKETHIDEOUTB4F_JESSE_JAMES_POSTBATTLE
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
	ld a, SCRIPT_ROCKETHIDEOUTB4F_JESSE_JAMES_EXIT
	call RocketHideoutB4FSetScript
	ret

RocketHideoutB4FJesseJamesExitScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	call GBFadeOutToBlack
	ld a, HS_ROCKET_HIDEOUT_B4F_JAMES
	call RocketHideoutB4FScript_HideObject
	ld a, HS_ROCKET_HIDEOUT_B4F_JESSIE
	call RocketHideoutB4FScript_HideObject
	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack
	ld a, SCRIPT_ROCKETHIDEOUTB4F_JESSE_JAMES_CLEANUP
	call RocketHideoutB4FSetScript
	ret

RocketHideoutB4FJesseJamesCleanupScript:
	call PlayDefaultMusic
	xor a
	ldh [hJoyHeld], a
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_ROCKET_HIDEOUT_4_JESSIE_JAMES
	ld a, SCRIPT_ROCKETHIDEOUTB4F_DEFAULT
	call RocketHideoutB4FSetScript
	ret

RocketHideoutB4FScript_ShowObject:
	ld [wMissableObjectIndex], a
	predef ShowObject
	call UpdateSprites
	call Delay3
	ret

RocketHideoutB4FScript_HideObject:
	ld [wMissableObjectIndex], a
	predef HideObject
	ret

RocketHideoutB4F_TextPointers:
	def_text_pointers
	dw_const RocketHideoutB4FGiovanniText,                TEXT_ROCKETHIDEOUTB4F_GIOVANNI
	dw_const RocketHideoutB4FJessieJamesText,             TEXT_ROCKETHIDEOUTB4F_JAMES
	dw_const RocketHideoutB4FJessieJamesText,             TEXT_ROCKETHIDEOUTB4F_JESSIE
	dw_const RocketHideoutB4FRocketText,                  TEXT_ROCKETHIDEOUTB4F_ROCKET
	dw_const PickUpItemText,                              TEXT_ROCKETHIDEOUTB4F_HP_UP
	dw_const PickUpItemText,                              TEXT_ROCKETHIDEOUTB4F_TM_RAZOR_WIND
	dw_const PickUpItemText,                              TEXT_ROCKETHIDEOUTB4F_IRON
	dw_const PickUpItemText,                              TEXT_ROCKETHIDEOUTB4F_SILPH_SCOPE
	dw_const PickUpItemText,                              TEXT_ROCKETHIDEOUTB4F_LIFT_KEY
	dw_const RocketHideoutB4FGiovanniHopeWeMeetAgainText, TEXT_ROCKETHIDEOUTB4F_GIOVANNI_HOPE_WE_MEET_AGAIN
	dw_const RocketHideoutB4FJesseJamesSpottedText,       TEXT_ROCKETHIDEOUTB4F_JESSE_JAMES_SPOTTED
	dw_const RocketHideoutB4FJesseJamesPreBattleText,     TEXT_ROCKETHIDEOUTB4F_JESSE_JAMES_PREBATTLE
	dw_const RocketHideoutB4FJesseJamesPostBattleText,    TEXT_ROCKETHIDEOUTB4F_JESSE_JAMES_POSTBATTLE

RocketHideout4TrainerHeaders:
	def_trainers 4
RocketHideout4TrainerHeader0:
	trainer EVENT_BEAT_ROCKET_HIDEOUT_4_TRAINER_2, 1, RocketHideoutB4FRocketBattleText, RocketHideoutB4FRocketEndBattleText, RocketHideoutB4FRocketAfterBattleText
	db -1 ; end

RocketHideoutB4FJessieJamesText:
	text_end

RocketHideoutB4FJesseJamesSpottedText:
	text_far _RocketHideoutJessieJamesSpottedText
	text_asm
	ld c, 10
	call DelayFrames
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, 0
	ld [wEmotionBubbleSpriteIndex], a
	ld a, EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	ld c, 20
	call DelayFrames
	jp TextScriptEnd

RocketHideoutB4FJesseJamesPreBattleText:
	text_far _RocketHideoutB4FJesseJamesPreBattleText
	text_end

RocketHideoutB4FJessieJamesEndBattleText:
	text_far _RocketHideoutB4FJessieJamesEndBattleText
	text_end

RocketHideoutB4FJesseJamesPostBattleText:
	text_far _RocketHideoutB4FJesseJamesPostBattleText
	text_asm
	ld c, 64
	call DelayFrames
	jp TextScriptEnd

RocketHideoutB4FGiovanniText:
	text_asm
	CheckEvent EVENT_BEAT_ROCKET_HIDEOUT_GIOVANNI
	jp nz, .beat_giovanni
	ld hl, .ImpressedYouGotHereText
	call PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, .WhatCannotBeText
	ld de, .WhatCannotBeText
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	xor a
	ldh [hJoyHeld], a
	ld a, SCRIPT_ROCKETHIDEOUTB4F_BEAT_GIOVANNI
	ld [wRocketHideoutB4FCurScript], a
	ld [wCurMapScript], a
	jr .done
.beat_giovanni
	ld hl, RocketHideoutB4FGiovanniHopeWeMeetAgainText
	call PrintText
.done
	jp TextScriptEnd

.ImpressedYouGotHereText:
	text_far _RocketHideoutB4FGiovanniImpressedYouGotHereText
	text_end

.WhatCannotBeText:
	text_far _RocketHideoutB4FGiovanniWhatCannotBeText
	text_end

RocketHideoutB4FGiovanniHopeWeMeetAgainText:
	text_far _RocketHideoutB4FGiovanniHopeWeMeetAgainText
	text_end

RocketHideoutB4FRocketText:
	text_asm
	ld hl, RocketHideout4TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

RocketHideoutB4FRocketBattleText:
	text_far _RocketHideoutB4FRocketBattleText
	text_end

RocketHideoutB4FRocketEndBattleText:
	text_far _RocketHideoutB4FRocketEndBattleText
	text_promptbutton
	text_asm
	SetEvent EVENT_ROCKET_DROPPED_LIFT_KEY
	ld a, HS_ROCKET_HIDEOUT_B4F_ITEM_5
	ld [wMissableObjectIndex], a
	predef ShowObject
	jp TextScriptEnd

RocketHideoutB4FRocketAfterBattleText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _RocketHideoutB4FRocketAfterBattleText
	text_end
