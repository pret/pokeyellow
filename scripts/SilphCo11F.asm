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
	cp $ff
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
	dw_const SilphCo11FDefaultScript,               SCRIPT_SILPHCO11F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILPHCO11F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILPHCO11F_END_BATTLE
	dw_const SilphCo11FGiovanniAfterBattleScript,   SCRIPT_SILPHCO11F_GIOVANNI_AFTER_BATTLE
	dw_const SilphCo11FGiovanniStartBattleScript,   SCRIPT_SILPHCO11F_GIOVANNI_START_BATTLE
	dw_const SilphCo11FScript5,                     SCRIPT_SILPHCO11F_SCRIPT5
	dw_const SilphCo11FScript6,                     SCRIPT_SILPHCO11F_SCRIPT6
	dw_const SilphCo11FScript7,                     SCRIPT_SILPHCO11F_SCRIPT7
	dw_const SilphCo11FScript8,                     SCRIPT_SILPHCO11F_SCRIPT8
	dw_const SilphCo11FScript9,                     SCRIPT_SILPHCO11F_SCRIPT9
	dw_const SilphCo11FScript10,                    SCRIPT_SILPHCO11F_SCRIPT10
	dw_const SilphCo11FScript11,                    SCRIPT_SILPHCO11F_SCRIPT11
	dw_const SilphCo11FScript12,                    SCRIPT_SILPHCO11F_SCRIPT12
	dw_const SilphCo11FScript13,                    SCRIPT_SILPHCO11F_SCRIPT13
	dw_const SilphCo11FScript14,                    SCRIPT_SILPHCO11F_SCRIPT14

SilphCo11FDefaultScript:
IF DEF(_DEBUG)
	call DebugPressedOrHeldB
	ret nz
ENDC
	CheckEvent EVENT_BEAT_SILPH_CO_11F_JESSIE_JAMES
	call z, SilphCo11FScript_6229c
	CheckEvent EVENT_782
	ret nz
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	call z, SilphCo11FScript_621c5
	ret

SilphCo11FScript_621c5:
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

SilphCo11FScript_621ff:
	ld [wPlayerMovingDirection], a
	ld a, b
	ld [wSprite03StateData1FacingDirection], a
	ld a, $2
	ld [wSprite03StateData1MovementStatus], a
	ret

SilphCo11FGiovanniAfterBattleScript:
	ld a, [wIsInBattle]
	cp $ff
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
	call SilphCo11FScript_621ff
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
	call SilphCo11FScript_621ff
	call Delay3
	xor a
	ld [wJoyIgnore], a
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, SilphCo10FGiovanniILostAgainText
	ld de, SilphCo10FGiovanniILostAgainText
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, SCRIPT_SILPHCO11F_GIOVANNI_AFTER_BATTLE
	jp SilphCo11FSetCurScript

SilphCo11FScript_6229c:
	ld a, [wYCoord]
	cp $3
	ret nz
	ld a, [wXCoord]
	cp $4
	ret nc
	ResetEvents EVENT_780, EVENT_781
	ld a, [wXCoord]
	cp $3
	jr z, .asm_622c3
	SetEventReuseHL EVENT_780
	ld a, [wXCoord]
	cp $2
	jr z, .asm_622c3
	ResetEventReuseHL EVENT_780
	SetEventReuseHL EVENT_781
.asm_622c3
	call StopAllMusic
	ld c, BANK(Music_MeetJessieJames)
	ld a, MUSIC_MEET_JESSIE_JAMES
	call PlayMusic
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, TEXT_SILPHCO11F_TEXT8
	ldh [hTextID], a
	call DisplayTextID
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	SetEvent EVENT_782
	ld a, SCRIPT_SILPHCO11F_SCRIPT5
	call SilphCo11FSetCurScript
	ret

SilphCo11FMovementData_622f5:
	db $5
	db $5
	db $5
	db $5
	db $5
	db $ff

SilphCo11FMovementData_622fb:
	db $5
	db $5
	db $5
	db $5
	db $ff

SilphCo11FMovementData_62300:
	db $5
	db $5
	db $5
	db $5
	db $ff

SilphCo11FMovementData_62305:
	db $5
	db $5
	db $5
	db $5
	db $5
	db $ff

SilphCo11FMovementData_6230b:
	db $5
	db $5
	db $6
	db $5
	db $5
	db $ff

SilphCo11FMovementData_62311:
	db $5
	db $5
	db $5
	db $6
	db $5
	db $5
	db $ff

SilphCo11FScript5:
	ld de, SilphCo11FMovementData_622f5
	CheckEitherEventSet EVENT_780, EVENT_781
	and a
	jr z, .asm_6232d
	ld de, SilphCo11FMovementData_62300
	cp $1
	jr z, .asm_6232d
	ld de, SilphCo11FMovementData_6230b
.asm_6232d
	ld a, SILPHCO11F_JAMES
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_SILPHCO11F_SCRIPT6
	call SilphCo11FSetCurScript
	ret

SilphCo11FScript6:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
SilphCo11FScript7:
	ld a, $2
	ld [wSprite04StateData1MovementStatus], a
	ld hl, wSprite04StateData1FacingDirection
	ld [hl], SPRITE_FACING_RIGHT
	CheckEitherEventSet EVENT_780, EVENT_781
	and a
	jr z, .asm_6235e
	ld [hl], SPRITE_FACING_UP
.asm_6235e
	call Delay3
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
SilphCo11FScript8:
	ld de, SilphCo11FMovementData_622fb
	CheckEitherEventSet EVENT_780, EVENT_781
	and a
	jr z, .asm_6237b
	ld de, SilphCo11FMovementData_62305
	cp $1
	jr z, .asm_6237b
	ld de, SilphCo11FMovementData_62311
.asm_6237b
	ld a, SILPHCO11F_JESSIE
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_SILPHCO11F_SCRIPT9
	call SilphCo11FSetCurScript
	ret

SilphCo11FScript9:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
SilphCo11FScript10:
	ld a, $2
	ld [wSprite06StateData1MovementStatus], a
	ld hl, wSprite06StateData1FacingDirection
	ld [hl], SPRITE_FACING_UP
	CheckEitherEventSet EVENT_780, EVENT_781
	and a
	jr z, .asm_623b1
	ld [hl], SPRITE_FACING_LEFT
.asm_623b1
	call Delay3
	ld a, TEXT_SILPHCO11F_TEXT9
	ldh [hTextID], a
	call DisplayTextID
SilphCo11FScript11:
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, SilphCo11FText_624c2
	ld de, SilphCo11FText_624c2
	call SaveEndBattleTextPointers
	ld a, OPP_ROCKET
	ld [wCurOpponent], a
	ld a, $2d
	ld [wTrainerNo], a
	xor a
	ldh [hJoyHeld], a
	ld [wJoyIgnore], a
	ld a, SCRIPT_SILPHCO11F_SCRIPT12
	call SilphCo11FSetCurScript
	ret

SilphCo11FScript12:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wIsInBattle]
	cp $ff
	jp z, SilphCo11FResetCurScript
	ld a, $2
	ld [wSprite04StateData1MovementStatus], a
	ld [wSprite06StateData1MovementStatus], a
	xor a
	ld [wSprite04StateData1FacingDirection], a
	ld [wSprite06StateData1FacingDirection], a
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, TEXT_SILPHCO11F_TEXT10
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
	ld a, SCRIPT_SILPHCO11F_SCRIPT13
	call SilphCo11FSetCurScript
	ret

SilphCo11FScript13:
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
	ld a, SCRIPT_SILPHCO11F_SCRIPT14
	call SilphCo11FSetCurScript
	ret

SilphCo11FScript14:
	call PlayDefaultMusic
	xor a
	ldh [hJoyHeld], a
	ld [wJoyIgnore], a
	ResetEvent EVENT_782
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
	dw_const SilphCo11FJessieJamesText,               TEXT_SILPHCO11F_TEXT8
	dw_const SilphCo11FText9,                         TEXT_SILPHCO11F_TEXT9
	dw_const SilphCo11FText10,                        TEXT_SILPHCO11F_TEXT10

SilphCo11TrainerHeaders:
	def_trainers 5
SilphCo11TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_11F_TRAINER_0, 3, SilphCo11FRocketBattleText, SilphCo11FRocketEndBattleText, SilphCo11FRocketAfterBattleText
	db -1 ; end

SilphCo11FJessieJamesText:
	text_far _SilphCoJessieJamesText1
	text_asm
	ld c, 10
	call DelayFrames
	ld a, $4
	ld [wPlayerMovingDirection], a
	ld a, $0
	ld [wEmotionBubbleSpriteIndex], a
	ld a, EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	ld c, 20
	call DelayFrames
	jp TextScriptEnd

SilphCo11FText9:
	text_far _SilphCoJessieJamesText2
	text_end

SilphCo11FText_624c2:
	text_far _SilphCoJessieJamesText3
	text_end

SilphCo11FText10:
	text_far _SilphCoJessieJamesText4
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

SilphCo10FGiovanniILostAgainText:
	text_far _SilphCo10FGiovanniILostAgainText
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
