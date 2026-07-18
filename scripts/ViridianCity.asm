ViridianCity_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ViridianCity_ScriptPointers
	ld a, [wViridianCityCurScript]
	call CallFunctionInTable
	ret

ViridianCity_ScriptPointers:
	def_script_pointers
	dw_const ViridianCityDefaultScript,                       SCRIPT_VIRIDIANCITY_DEFAULT
	dw_const ViridianCityAfterPokedexScript,                  SCRIPT_VIRIDIANCITY_AFTER_POKEDEX
	dw_const ViridianCityPostCatchTraining,                   SCRIPT_VIRIDIANCITY_POST_CATCH_TRAINING
	dw_const ViridianCityOldManStartCatchTrainingScript,      SCRIPT_VIRIDIANCITY_OLD_MAN_START_CATCH_TRAINING
	dw_const ViridianCityOldManEndCatchTrainingScript,        SCRIPT_VIRIDIANCITY_OLD_MAN_END_CATCH_TRAINING
	dw_const ViridianCityPlayerMovingDownScript,              SCRIPT_VIRIDIANCITY_PLAYER_MOVING_DOWN
	dw_const ViridianCityPlayerMovingDownPostTrainingScript,  SCRIPT_VIRIDIANCITY_PLAYER_MOVING_DOWN_POST_TRAINING
	dw_const ViridianCityOldManInitialCatchTrainingScript,    SCRIPT_VIRIDIANCITY_OLD_MAN_INITIAL_CATCH_TRAINING
	dw_const ViridianCityOldManEndInitialCatchTrainingScript, SCRIPT_VIRIDIANCITY_OLD_MAN_END_INITIAL_CATCH_TRAINING
	dw_const ViridianCityPostInitialCatchTraining,            SCRIPT_VIRIDIANCITY_POST_INITIAL_CATCH_TRAINING
	dw_const ViridianCityOldManMovingDownScript,              SCRIPT_VIRIDIANCITY_OLD_MAN_MOVING_DOWN

ViridianCityDefaultScript:
	call ViridianCityCheckGymOpenScript
	call ViridianCityCheckSleepingOldMan
	ret

ViridianCityAfterPokedexScript:
	call ViridianCityCheckWaitingOldMan
ViridianCityPostCatchTraining:
	call ViridianCityCheckGymOpenScript
	ret

ViridianCityCheckGymOpenScript:
	CheckEvent EVENT_VIRIDIAN_GYM_OPEN
	ret nz
	ld a, [wObtainedBadges]
	cp ~(1 << BIT_EARTHBADGE)
	jr nz, .gym_closed
	SetEvent EVENT_VIRIDIAN_GYM_OPEN
	ret
.gym_closed
	ld a, [wYCoord]
	cp 8
	ret nz
	ld a, [wXCoord]
	cp 32
	ret nz
	ld a, TEXT_VIRIDIANCITY_GYM_LOCKED
	ldh [hTextID], a
	call DisplayTextID
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wSpritePlayerStateData1FacingDirection], a
	ld [wJoyIgnore], a
	ldh [hJoyHeld], a
	ld a, SCRIPT_VIRIDIANCITY_PLAYER_MOVING_DOWN_POST_TRAINING
	ld [wViridianCityCurScript], a
	ret

ViridianCityPlayerMovingDownPostTrainingScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	ld a, SCRIPT_VIRIDIANCITY_POST_CATCH_TRAINING
	ld [wViridianCityCurScript], a
	ret

ViridianCityCheckSleepingOldMan:
	ld a, [wYCoord]
	cp 9
	ret nz
	ld a, [wXCoord]
	cp 19
	ret nz
	ld a, TEXT_VIRIDIANCITY_OLD_MAN_SLEEPY
	ldh [hTextID], a
	call DisplayTextID
	xor a
	ldh [hJoyHeld], a
	call ViridianCityMovePlayerDownScript
	ld a, SCRIPT_VIRIDIANCITY_PLAYER_MOVING_DOWN
	ld [wViridianCityCurScript], a
	ret

ViridianCityOldManStartCatchTrainingScript:
	call .SetupSprite
	call .SetupBattle
	ResetEvent EVENT_INITIAL_CATCH_TRAINING
	ld a, SCRIPT_VIRIDIANCITY_OLD_MAN_END_CATCH_TRAINING
	ld [wViridianCityCurScript], a
	ret

.SetupBattle:
	xor a
	ld [wListScrollOffset], a
	ld a, BATTLE_TYPE_OLD_MAN
	ld [wBattleType], a
	ld a, 5
	ld [wCurEnemyLevel], a
	ld a, RATTATA
	ld [wCurOpponent], a
	ret

.SetupSprite:
	ld a, [wSprite03StateData1YPixels]
	ldh [hSpriteScreenYCoord], a
	ld a, [wSprite03StateData1XPixels]
	ldh [hSpriteScreenXCoord], a
	ld a, [wSprite03StateData2MapY]
	ldh [hSpriteMapYCoord], a
	ld a, [wSprite03StateData2MapX]
	ldh [hSpriteMapXCoord], a
	ret

ViridianCityOldManEndCatchTrainingScript:
	call .SetupSprite
	call UpdateSprites
	call Delay3
	SetEvent EVENT_COMPLETED_CATCH_TRAINING_AGAIN
	xor a
	ld [wJoyIgnore], a
	ld a, TEXT_VIRIDIANCITY_OLD_MAN_YOU_NEED_TO_WEAKEN_THE_TARGET
	ldh [hTextID], a
	call DisplayTextID
	xor a
	ld [wBattleType], a
	ld [wJoyIgnore], a
	ld a, SCRIPT_VIRIDIANCITY_POST_CATCH_TRAINING
	ld [wViridianCityCurScript], a
	ret

.SetupSprite:
	ldh a, [hSpriteScreenYCoord]
	ld [wSprite03StateData1YPixels], a
	ldh a, [hSpriteScreenXCoord]
	ld [wSprite03StateData1XPixels], a
	ldh a, [hSpriteMapYCoord]
	ld [wSprite03StateData2MapY], a
	ldh a, [hSpriteMapXCoord]
	ld [wSprite03StateData2MapX], a
	ret

ViridianCityPlayerMovingDownScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	ld a, SCRIPT_VIRIDIANCITY_DEFAULT
	ld [wViridianCityCurScript], a
	ret

ViridianCityMovePlayerDownScript:
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wSpritePlayerStateData1FacingDirection], a
	ld [wJoyIgnore], a
	ret

ViridianCityCheckWaitingOldMan:
	CheckEvent EVENT_COMPLETED_CATCH_TRAINING
	ret nz
	ld a, [wYCoord]
	cp 9
	ret nz
	ld a, [wXCoord]
	cp 19
	ret nz
	ld a, VIRIDIANCITY_OLD_MAN2
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_RIGHT
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, SPRITE_FACING_LEFT
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, TEXT_VIRIDIANCITY_OLD_MAN2
	ldh [hTextID], a
	call DisplayTextID
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ret

ViridianCityOldManInitialCatchTrainingScript:
	call ViridianCityOldManStartCatchTrainingScript.SetupSprite
	call ViridianCityOldManStartCatchTrainingScript.SetupBattle
	SetEvent EVENT_INITIAL_CATCH_TRAINING
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_VIRIDIANCITY_OLD_MAN_END_INITIAL_CATCH_TRAINING
	ld [wViridianCityCurScript], a
	ret

ViridianCityOldManEndInitialCatchTrainingScript:
	call ViridianCityOldManEndCatchTrainingScript.SetupSprite
	call UpdateSprites
	call Delay3
	SetEvent EVENT_COMPLETED_CATCH_TRAINING
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, TEXT_VIRIDIANCITY_OLD_MAN2
	ldh [hTextID], a
	call DisplayTextID
	xor a
	ld [wBattleType], a
	dec a
	ld [wJoyIgnore], a
	ld a, SCRIPT_VIRIDIANCITY_POST_INITIAL_CATCH_TRAINING
	ld [wViridianCityCurScript], a
	ret

ViridianCityPostInitialCatchTraining:
	ld de, ViridianCityOldManMovementData2
	ld a, [wXCoord]
	cp 19
	jr z, .move_old_man
	callfar ViridianCityMovePikachu
	ld de, ViridianCityOldManMovementData1
.move_old_man
	ld a, VIRIDIANCITY_OLD_MAN2
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, SCRIPT_VIRIDIANCITY_OLD_MAN_MOVING_DOWN
	ld [wViridianCityCurScript], a
	ret

ViridianCityOldManMovementData1:
	db NPC_MOVEMENT_RIGHT
ViridianCityOldManMovementData2:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db $ff

ViridianCityOldManMovingDownScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, TOGGLE_OLD_MAN_2
	ld [wToggleableObjectIndex], a
	predef HideObject
	xor a
	ld [wJoyIgnore], a
	ld a, SCRIPT_VIRIDIANCITY_POST_CATCH_TRAINING
	ld [wViridianCityCurScript], a
	ret

ViridianCity_TextPointers:
	def_text_pointers
	dw_const ViridianCityYoungster1Text,                     TEXT_VIRIDIANCITY_YOUNGSTER1
	dw_const ViridianCityGambler1Text,                       TEXT_VIRIDIANCITY_GAMBLER1
	dw_const ViridianCityYoungster2Text,                     TEXT_VIRIDIANCITY_YOUNGSTER2
	dw_const ViridianCityGirlText,                           TEXT_VIRIDIANCITY_GIRL
	dw_const ViridianCityOldManSleepyText,                   TEXT_VIRIDIANCITY_OLD_MAN_SLEEPY
	dw_const ViridianCityFisherText,                         TEXT_VIRIDIANCITY_FISHER
	dw_const ViridianCityOldManText,                         TEXT_VIRIDIANCITY_OLD_MAN
	dw_const ViridianCityOldMan2Text,                        TEXT_VIRIDIANCITY_OLD_MAN2
	dw_const ViridianCitySignText,                           TEXT_VIRIDIANCITY_SIGN
	dw_const ViridianCityTrainerTips1Text,                   TEXT_VIRIDIANCITY_TRAINER_TIPS1
	dw_const ViridianCityTrainerTips2Text,                   TEXT_VIRIDIANCITY_TRAINER_TIPS2
	dw_const MartSignText,                                   TEXT_VIRIDIANCITY_MART_SIGN
	dw_const PokeCenterSignText,                             TEXT_VIRIDIANCITY_POKECENTER_SIGN
	dw_const ViridianCityGymSignText,                        TEXT_VIRIDIANCITY_GYM_SIGN
	dw_const ViridianCityGymLockedText,                      TEXT_VIRIDIANCITY_GYM_LOCKED
	dw_const ViridianCityOldManYouNeedToWeakenTheTargetText, TEXT_VIRIDIANCITY_OLD_MAN_YOU_NEED_TO_WEAKEN_THE_TARGET

ViridianCityYoungster1Text:
	text_asm
	farcall ViridianCityPrintYoungster1Text
	jp TextScriptEnd

ViridianCityGambler1Text:
	text_asm
	farcall ViridianCityPrintGambler1Text
	jp TextScriptEnd

ViridianCityYoungster2Text:
	text_asm
	farcall ViridianCityPrintYoungster2Text
	jp TextScriptEnd

ViridianCityGirlText:
	text_asm
	farcall ViridianCityPrintGirlText
	jp TextScriptEnd

ViridianCityOldManSleepyText:
	text_asm
	farcall ViridianCityPrintOldManSleepyText
	jp TextScriptEnd

ViridianCityFisherText:
	text_asm
	farcall ViridianCityPrintFisherText
	jp TextScriptEnd

ViridianCityOldManText:
	text_asm
	farcall ViridianCityPrintOldManText
	jp TextScriptEnd

ViridianCityOldManYouNeedToWeakenTheTargetText:
	text_far _ViridianCityOldManYouNeedToWeakenTheTargetText
	text_end

ViridianCityOldMan2Text:
	text_asm
	CheckEvent EVENT_COMPLETED_CATCH_TRAINING
	jr nz, .completed_training
	ld hl, .HadMyCoffeeNowText
	call PrintText
	ld c, 2
	call DelayFrames
	ld a, SCRIPT_VIRIDIANCITY_OLD_MAN_INITIAL_CATCH_TRAINING
	ld [wViridianCityCurScript], a
	jr .done

.completed_training
	ld hl, .LosingMyTouchText
	call PrintText
.done
	jp TextScriptEnd

.HadMyCoffeeNowText:
	text_far _ViridianCityOldManHadMyCoffeeNowText
	text_end

.LosingMyTouchText:
	text_far _ViridianCityOldManLosingMyTouchText
	text_end

ViridianCitySignText:
	text_asm
	farcall ViridianCityPrintSignText
	jp TextScriptEnd

ViridianCityTrainerTips1Text:
	text_asm
	farcall ViridianCityPrintTrainerTips1Text
	jp TextScriptEnd

ViridianCityTrainerTips2Text:
	text_asm
	farcall ViridianCityPrintTrainerTips2Text
	jp TextScriptEnd

ViridianCityGymSignText:
	text_asm
	farcall ViridianCityPrintGymSignText
	jp TextScriptEnd

ViridianCityGymLockedText:
	text_asm
	farcall ViridianCityPrintGymLockedText
	jp TextScriptEnd
