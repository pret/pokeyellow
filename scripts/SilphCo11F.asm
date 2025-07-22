SilphCo11F_Script:
	call SilphCo11FGateCallbackScript
	call EnableAutoTextBoxDrawing
	ld hl, SilphCo11TrainerHeaders
	ld de, SilphCo11F_ScriptPointers
	ld a, [wSilphCo11FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo11FCurScript], a
	ret

SilphCo11FGateCallbackScript:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	ld hl, SilphCo11GateCoords
	call SilphCo11F_SetCardKeyDoorYScript
	call SilphCo11FSetUnlockedDoorEventScript
	CheckEvent EVENT_SILPH_CO_11_UNLOCKED_DOOR
	ret nz
	ld a, $20
	ld [wNewTileBlockID], a
	lb bc, 6, 3
	predef ReplaceTileBlock
	ret

SilphCo11GateCoords:
	dbmapcoord  3,  6
	db -1 ; end

SilphCo11F_SetCardKeyDoorYScript:
	push hl
	ld hl, wCardKeyDoorY
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	xor a
	ldh [hUnlockedSilphCoDoors], a
	pop hl
.loop_check_doors
	ld a, [hli]
	cp -1
	jr z, .exit_loop
	push hl
	ld hl, hUnlockedSilphCoDoors
	inc [hl]
	pop hl
	cp b
	jr z, .check_y_coord
	inc hl
	jr .loop_check_doors
.check_y_coord
	ld a, [hli]
	cp c
	jr nz, .loop_check_doors
	ld hl, wCardKeyDoorY
	xor a
	ld [hli], a
	ld [hl], a
	ret
.exit_loop
	xor a
	ldh [hUnlockedSilphCoDoors], a
	ret

SilphCo11FSetUnlockedDoorEventScript:
	ldh a, [hUnlockedSilphCoDoors]
	and a
	ret z
	SetEvent EVENT_SILPH_CO_11_UNLOCKED_DOOR
	ret

SilphCo11FResetCurScript:
	xor a
	ld [wJoyIgnore], a
; fallthrough
SilphCo11FSetCurScript:
	ld [wSilphCo11FCurScript], a
	ld [wCurMapScript], a
	ret

SilphCo11F_ScriptPointers:
	def_script_pointers
	dw_const SilphCo11FDefaultScript,                 SCRIPT_SILPHCO11F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle,   SCRIPT_SILPHCO11F_START_BATTLE
	dw_const EndTrainerBattle,                        SCRIPT_SILPHCO11F_END_BATTLE
	dw_const SilphCo11FGiovanniAfterBattleScript,     SCRIPT_SILPHCO11F_GIOVANNI_AFTER_BATTLE
	dw_const SilphCo11FGiovanniStartBattleScript,     SCRIPT_SILPHCO11F_GIOVANNI_START_BATTLE
	dw_const SilphCo11FJamesMoveScript,               SCRIPT_SILPHCO11F_JAMES_MOVE
	dw_const SilphCo11FJamesWaitScript,               SCRIPT_SILPHCO11F_JAMES_WAIT
	dw_const SilphCo11FJamesSetFacingDirectionScript, SCRIPT_SILPHCO11F_JAMES_FACING
	dw_const SilphCo11FJesseMoveScript,               SCRIPT_SILPHCO11F_JESSE_MOVE
	dw_const SilphCo11FJesseWaitScript,               SCRIPT_SILPHCO11F_JESSE_WAIT
	dw_const SilphCo11FJesseSetFacingDirectionScript, SCRIPT_SILPHCO11F_JESSE_FACING
	dw_const SilphCo11FJesseJamesStartBattleScript,   SCRIPT_SILPHCO11F_JESSE_JAMES_START_BATTLE
	dw_const SilphCo11FJesseJamesAfterBattleScript,   SCRIPT_SILPHCO11F_JESSE_JAMES_AFTER_BATTLE
	dw_const SilphCo11FJesseJamesExitScript,          SCRIPT_SILPHCO11F_JESSE_JAMES_EXIT
	dw_const SilphCo11FJesseJamesCleanupScript,       SCRIPT_SILPHCO11F_JESSE_JAMES_CLEANUP

SilphCo11FDefaultScript:
IF DEF(_DEBUG)
	call DebugPressedOrHeldB
	ret nz
ENDC
	CheckEvent EVENT_BEAT_SILPH_CO_11F_JESSIE_JAMES
	call z, SilphCo11FJesseJamesScript
	CheckEvent EVENT_SILPH_CO_11F_JESSIE_JAMES_BATTLE_IN_PROGRESS
	ret nz
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	call z, SilphCo11FGiovanniScript
	ret

SilphCo11FGiovanniScript:
	ld hl, .PlayerCoordsArray
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
	ld a, [wCoordIndex]
	ld [wSavedCoordIndex], a
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, TEXT_SILPHCO11F_GIOVANNI
	ldh [hTextID], a
	call DisplayTextID
	ld a, SILPHCO11F_GIOVANNI
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	ld de, .GiovanniMovement
	call MoveSprite
	ld a, SCRIPT_SILPHCO11F_GIOVANNI_START_BATTLE
	call SilphCo11FSetCurScript
	ret

.PlayerCoordsArray:
	dbmapcoord  6, 13
	dbmapcoord  7, 12
	db -1 ; end

.GiovanniMovement:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db -1 ; end

SilphCo11FGiovanniSetFacingDirectionScript:
	ld [wPlayerMovingDirection], a
	ld a, b
	ld [wSprite03StateData1FacingDirection], a
	ld a, 2
	ld [wSprite03StateData1MovementStatus], a
	ret

SilphCo11FGiovanniAfterBattleScript:
	ld a, [wIsInBattle]
	cp -1
	jp z, SilphCo11FResetCurScript
	ld a, [wSavedCoordIndex]
	cp 1 ; index of second, upper-right entry in SilphCo11FDefaultScript.PlayerCoordsArray
	jr z, .face_player_up
	ld a, PLAYER_DIR_LEFT
	ld b, SPRITE_FACING_RIGHT
	jr .continue
.face_player_up
	ld a, PLAYER_DIR_UP
	ld b, SPRITE_FACING_DOWN
.continue
	call SilphCo11FGiovanniSetFacingDirectionScript
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, TEXT_SILPHCO11F_GIOVANNI_YOU_RUINED_OUR_PLANS
	ldh [hTextID], a
	call DisplayTextID
	call GBFadeOutToBlack
	farcall SilphCo11FTeamRocketLeavesScript
	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack
	SetEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	xor a
	ld [wJoyIgnore], a
	jp SilphCo11FSetCurScript

SilphCo11FGiovanniStartBattleScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, SILPHCO11F_GIOVANNI
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	ld a, [wSavedCoordIndex]
	cp 1 ; index of second, upper-right entry in SilphCo11FDefaultScript.PlayerCoordsArray
	jr z, .face_player_up
	ld a, PLAYER_DIR_LEFT
	ld b, SPRITE_FACING_RIGHT
	jr .continue
.face_player_up
	ld a, PLAYER_DIR_UP
	ld b, SPRITE_FACING_DOWN
.continue
	call SilphCo11FGiovanniSetFacingDirectionScript
	call Delay3
	xor a
	ld [wJoyIgnore], a
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, SilphCo11FGiovanniILostAgainText
	ld de, SilphCo11FGiovanniILostAgainText
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, SCRIPT_SILPHCO11F_GIOVANNI_AFTER_BATTLE
	jp SilphCo11FSetCurScript

SilphCo11FJesseJamesScript:
	ld a, [wYCoord]
	cp 3
	ret nz
	ld a, [wXCoord]
	cp 4
	ret nc
	; Player standing right
	ResetEvents EVENT_SILPH_CO_11F_JESSIE_JAMES_IN_MIDDLE, EVENT_SILPH_CO_11F_JESSIE_JAMES_ON_LEFT
	ld a, [wXCoord]
	cp 3
	jr z, .playerXCoordFound
	; player standing middle
	SetEventReuseHL EVENT_SILPH_CO_11F_JESSIE_JAMES_IN_MIDDLE
	ld a, [wXCoord]
	cp 2
	jr z, .playerXCoordFound
	; player standing left
	ResetEventReuseHL EVENT_SILPH_CO_11F_JESSIE_JAMES_IN_MIDDLE
	SetEventReuseHL EVENT_SILPH_CO_11F_JESSIE_JAMES_ON_LEFT
.playerXCoordFound
	call StopAllMusic
	ld c, BANK(Music_MeetJessieJames)
	ld a, MUSIC_MEET_JESSIE_JAMES
	call PlayMusic
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, TEXT_SILPHCO11F_JESSE_JAMES_SPOTTED
	ldh [hTextID], a
	call DisplayTextID
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	SetEvent EVENT_SILPH_CO_11F_JESSIE_JAMES_BATTLE_IN_PROGRESS
	ld a, SCRIPT_SILPHCO11F_JAMES_MOVE
	call SilphCo11FSetCurScript
	ret

JamesMovement_PlayerStandingRight:
	db NPC_MOVEMENT_UP_FAST
	db NPC_MOVEMENT_UP_FAST
	db NPC_MOVEMENT_UP_FAST
	db NPC_MOVEMENT_UP_FAST
	db NPC_MOVEMENT_UP_FAST
	db -1

JesseMovement_PlayerStandingRight:
	db NPC_MOVEMENT_UP_FAST
	db NPC_MOVEMENT_UP_FAST
	db NPC_MOVEMENT_UP_FAST
	db NPC_MOVEMENT_UP_FAST
	db -1

JamesMovement_PlayerStandingMiddle: ; james
	db NPC_MOVEMENT_UP_FAST
	db NPC_MOVEMENT_UP_FAST
	db NPC_MOVEMENT_UP_FAST
	db NPC_MOVEMENT_UP_FAST
	db -1

JesseMovement_PlayerStandingMiddle: ; jesse
	db NPC_MOVEMENT_UP_FAST
	db NPC_MOVEMENT_UP_FAST
	db NPC_MOVEMENT_UP_FAST
	db NPC_MOVEMENT_UP_FAST
	db NPC_MOVEMENT_UP_FAST
	db -1

JamesMovement_PlayerStandingLeft:
	db NPC_MOVEMENT_UP_FAST
	db NPC_MOVEMENT_UP_FAST
	db NPC_MOVEMENT_LEFT_FAST
	db NPC_MOVEMENT_UP_FAST
	db NPC_MOVEMENT_UP_FAST
	db -1

JesseMovement_PlayerStandingLeft:
	db NPC_MOVEMENT_UP_FAST
	db NPC_MOVEMENT_UP_FAST
	db NPC_MOVEMENT_UP_FAST
	db NPC_MOVEMENT_LEFT_FAST
	db NPC_MOVEMENT_UP_FAST
	db NPC_MOVEMENT_UP_FAST
	db -1

SilphCo11FJamesMoveScript:
	ld de, JamesMovement_PlayerStandingRight
	CheckEitherEventSet EVENT_SILPH_CO_11F_JESSIE_JAMES_IN_MIDDLE, EVENT_SILPH_CO_11F_JESSIE_JAMES_ON_LEFT
	and a
	jr z, .JamesMovementFound
	ld de, JamesMovement_PlayerStandingMiddle
	cp 1
	jr z, .JamesMovementFound
	ld de, JamesMovement_PlayerStandingLeft
.JamesMovementFound
	ld a, SILPHCO11F_JAMES
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_SILPHCO11F_JAMES_WAIT
	call SilphCo11FSetCurScript
	ret

SilphCo11FJamesWaitScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
SilphCo11FJamesSetFacingDirectionScript:
	ld a, 2
	ld [wSprite04StateData1MovementStatus], a
	ld hl, wSprite04StateData1FacingDirection
	ld [hl], SPRITE_FACING_RIGHT
	CheckEitherEventSet EVENT_SILPH_CO_11F_JESSIE_JAMES_IN_MIDDLE, EVENT_SILPH_CO_11F_JESSIE_JAMES_ON_LEFT
	and a
	jr z, .playerStandingRight
	ld [hl], SPRITE_FACING_UP
.playerStandingRight
	call Delay3
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
SilphCo11FJesseMoveScript:
	ld de, JesseMovement_PlayerStandingRight
	CheckEitherEventSet EVENT_SILPH_CO_11F_JESSIE_JAMES_IN_MIDDLE, EVENT_SILPH_CO_11F_JESSIE_JAMES_ON_LEFT
	and a
	jr z, .JesseMovementFound
	ld de, JesseMovement_PlayerStandingMiddle
	cp 1
	jr z, .JesseMovementFound
	ld de, JesseMovement_PlayerStandingLeft
.JesseMovementFound
	ld a, SILPHCO11F_JESSIE
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_SILPHCO11F_JESSE_WAIT
	call SilphCo11FSetCurScript
	ret

SilphCo11FJesseWaitScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
SilphCo11FJesseSetFacingDirectionScript:
	ld a, 2
	ld [wSprite06StateData1MovementStatus], a
	ld hl, wSprite06StateData1FacingDirection
	ld [hl], SPRITE_FACING_UP
	CheckEitherEventSet EVENT_SILPH_CO_11F_JESSIE_JAMES_IN_MIDDLE, EVENT_SILPH_CO_11F_JESSIE_JAMES_ON_LEFT
	and a
	jr z, .playerStandingRight
	ld [hl], SPRITE_FACING_LEFT
.playerStandingRight
	call Delay3
	ld a, TEXT_SILPHCO11F_JESSE_JAMES_PREBATTLE
	ldh [hTextID], a
	call DisplayTextID
SilphCo11FJesseJamesStartBattleScript:
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, SilphCo11FJessieJamesEndBattleText
	ld de, SilphCo11FJessieJamesEndBattleText
	call SaveEndBattleTextPointers
	ld a, OPP_ROCKET
	ld [wCurOpponent], a
	ld a, 45
	ld [wTrainerNo], a
	xor a
	ldh [hJoyHeld], a
	ld [wJoyIgnore], a
	ld a, SCRIPT_SILPHCO11F_JESSE_JAMES_AFTER_BATTLE
	call SilphCo11FSetCurScript
	ret

SilphCo11FJesseJamesAfterBattleScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wIsInBattle]
	cp -1
	jp z, SilphCo11FResetCurScript
	ld a, 2
	ld [wSprite04StateData1MovementStatus], a
	ld [wSprite06StateData1MovementStatus], a
	xor a ; 
	ld [wSprite04StateData1FacingDirection], a
	ld [wSprite06StateData1FacingDirection], a
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, TEXT_SILPHCO11F_JESSE_JAMES_POSTBATTLE
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
	ld a, SCRIPT_SILPHCO11F_JESSE_JAMES_EXIT
	call SilphCo11FSetCurScript
	ret

SilphCo11FJesseJamesExitScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	call GBFadeOutToBlack
	ld a, HS_SILPH_CO_11F_JAMES
	call SilphCo11FScript_HideObject
	ld a, HS_SILPH_CO_11F_JESSIE
	call SilphCo11FScript_HideObject
	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack
	ld a, SCRIPT_SILPHCO11F_JESSE_JAMES_CLEANUP
	call SilphCo11FSetCurScript
	ret

SilphCo11FJesseJamesCleanupScript:
	call PlayDefaultMusic
	xor a
	ldh [hJoyHeld], a
	ld [wJoyIgnore], a
	ResetEvent EVENT_SILPH_CO_11F_JESSIE_JAMES_BATTLE_IN_PROGRESS
	SetEventReuseHL EVENT_BEAT_SILPH_CO_11F_JESSIE_JAMES
	ld a, SCRIPT_SILPHCO11F_DEFAULT
	call SilphCo11FSetCurScript
	ret

SilphCo11FScript_ShowObject:
	ld [wMissableObjectIndex], a
	predef ShowObject
	call UpdateSprites
	call Delay3
	ret

SilphCo11FScript_HideObject:
	ld [wMissableObjectIndex], a
	predef HideObject
	ret

SilphCo11F_TextPointers:
	def_text_pointers
	dw_const SilphCo11FSilphPresidentText,            TEXT_SILPHCO11F_SILPH_PRESIDENT
	dw_const SilphCo11FBeautyText,                    TEXT_SILPHCO11F_BEAUTY
	dw_const SilphCo11FGiovanniText,                  TEXT_SILPHCO11F_GIOVANNI
	dw_const SilphCo11FJessieJamesText,               TEXT_SILPHCO11F_JAMES
	dw_const SilphCo11FRocketText,                    TEXT_SILPHCO11F_ROCKET
	dw_const SilphCo11FJessieJamesText,               TEXT_SILPHCO11F_JESSIE
	dw_const SilphCo11FGiovanniYouRuinedOurPlansText, TEXT_SILPHCO11F_GIOVANNI_YOU_RUINED_OUR_PLANS
	dw_const SilphCo11FJessieJamesText,               TEXT_SILPHCO11F_JESSE_JAMES_SPOTTED
	dw_const SilphCo11FJessieJamesPreBattleText,      TEXT_SILPHCO11F_JESSE_JAMES_PREBATTLE
	dw_const SilphCo11FJessieJamesPostBattleText,     TEXT_SILPHCO11F_JESSE_JAMES_POSTBATTLE

SilphCo11TrainerHeaders:
	def_trainers 5
SilphCo11TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_11F_TRAINER_0, 3, SilphCo11FRocketBattleText, SilphCo11FRocketEndBattleText, SilphCo11FRocketAfterBattleText
	db -1 ; end

SilphCo11FJessieJamesText:
	text_far _SilphCo11FJessieJamesText
	text_asm
	ld c, 10
	call DelayFrames
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld a, 0
	ld [wEmotionBubbleSpriteIndex], a
	ld a, EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	ld c, 20
	call DelayFrames
	jp TextScriptEnd

SilphCo11FJessieJamesPreBattleText:
	text_far _SilphCo11FJessieJamesPreBattleText
	text_end

SilphCo11FJessieJamesEndBattleText:
	text_far _SilphCo11FJessieJamesEndBattleText
	text_end

SilphCo11FJessieJamesPostBattleText:
	text_far _SilphCo11FJessieJamesPostBattleText
	text_asm
	ld c, 64
	call DelayFrames
	jp TextScriptEnd

SilphCo11FSilphPresidentText:
	text_asm
	CheckEvent EVENT_GOT_MASTER_BALL
	jp nz, .got_item
	ld hl, .Text
	call PrintText
	lb bc, MASTER_BALL, 1
	call GiveItem
	jr nc, .bag_full
	ld hl, .ReceivedMasterBallText
	call PrintText
	SetEvent EVENT_GOT_MASTER_BALL
	jr .done
.bag_full
	ld hl, .NoRoomText
	call PrintText
	jr .done
.got_item
	ld hl, .MasterBallDescriptionText
	call PrintText
.done
	jp TextScriptEnd

.Text:
	text_far _SilphCo11FSilphPresidentText
	text_end

.ReceivedMasterBallText:
	text_far _SilphCo11FSilphPresidentReceivedMasterBallText
	sound_get_key_item
	text_end

.MasterBallDescriptionText:
	text_far _SilphCo11FSilphPresidentMasterBallDescriptionText
	text_end

.NoRoomText:
	text_far _SilphCo11FSilphPresidentNoRoomText
	text_end

SilphCo11FBeautyText:
	text_far _SilphCo11FBeautyText
	text_end

SilphCo11FGiovanniText:
	text_far _SilphCo11FGiovanniText
	text_end

SilphCo11FGiovanniILostAgainText:
	text_far _SilphCo11FGiovanniILostAgainText
	text_end

SilphCo11FGiovanniYouRuinedOurPlansText:
	text_far _SilphCo11FGiovanniYouRuinedOurPlansText
	text_end

SilphCo11FRocketText:
	text_asm
	ld hl, SilphCo11TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SilphCo11FRocketBattleText:
	text_far _SilphCo11FRocket2BattleText
	text_end

SilphCo11FRocketEndBattleText:
	text_far _SilphCo11FRocket2EndBattleText
	text_end

SilphCo11FRocketAfterBattleText:
	text_far _SilphCo11FRocket2AfterBattleText
	text_end
