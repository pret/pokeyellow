RocketHideout4Script:
	call EnableAutoTextBoxDrawing
	ld hl, RocketHideout4TrainerHeader0
	ld de, RocketHideout4ScriptPointers
	ld a, [wRocketHideout4CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRocketHideout4CurScript], a
	ret

RocketHideout4Script_45510:
	CheckAndResetEvent EVENT_6A0
	call nz, RocketHideout4Script_45525
	xor a
	ld [wJoyIgnore], a
RocketHideout4Script_4551e:
	ld [wRocketHideout4CurScript], a
	ld [wCurMapScript], a
	ret

RocketHideout4Script_45525:
	ld a, HS_ROCKET_HIDEOUT_4_JAMES
	call RocketHideout4Script_45756
	ld a, HS_ROCKET_HIDEOUT_4_JESSIE
	call RocketHideout4Script_45756
	ret

RocketHideout4ScriptPointers:
	dw RocketHideout4Script0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw RocketHideout4Script3
	dw RocketHideout4Script4
	dw RocketHideout4Script5
	dw RocketHideout4Script6
	dw RocketHideout4Script7
	dw RocketHideout4Script8
	dw RocketHideout4Script9
	dw RocketHideout4Script10
	dw RocketHideout4Script11
	dw RocketHideout4Script12
	dw RocketHideout4Script13

RocketHideout4Script3:
	ld a, [wIsInBattle]
	cp $ff
	jp z, RocketHideout4Script_45510
	ld a, $fc
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_ROCKET_HIDEOUT_GIOVANNI
	ld a, $a
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	call GBFadeOutToBlack
	ld a, HS_ROCKET_HIDEOUT_4_GIOVANNI
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_ROCKET_HIDEOUT_4_ITEM_4
	ld [wMissableObjectIndex], a
	predef ShowObject
	call UpdateSprites
	call GBFadeInFromBlack
	xor a
	ld [wJoyIgnore], a
	ld hl, wCurrentMapScriptFlags
	set 5, [hl]
	ld a, $0
	ld [wRocketHideout4CurScript], a
	ld [wCurMapScript], a
	ret

RocketHideout4Script0:
	CheckEvent EVENT_BEAT_ROCKET_HIDEOUT_4_TRAINER_0
	call z, RocketHideout4Script_455a5
	CheckEvent EVENT_BEAT_ROCKET_HIDEOUT_4_TRAINER_3
	call z, CheckFightingMapTrainers
	ret

RocketHideout4Script_455a5:
	ld a, [wYCoord]
	cp $e
	ret nz
	ResetEvent EVENT_BEAT_ROCKET_HIDEOUT_4_TRAINER_2
	ld a, [wXCoord]
	cp $18
	jr z, .asm_455c2
	ld a, [wXCoord]
	cp $19
	ret nz
	SetEvent EVENT_BEAT_ROCKET_HIDEOUT_4_TRAINER_2
.asm_455c2
	xor a
	ld [hJoyHeld], a
	ld a, $fc
	ld [wJoyIgnore], a
	call StopAllMusic
	ld c, BANK(Music_MeetJessieJames)
	ld a, MUSIC_MEET_JESSIE_JAMES
	call PlayMusic
	call UpdateSprites
	call Delay3
	call UpdateSprites
	call Delay3
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, $b
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, HS_ROCKET_HIDEOUT_4_JAMES
	call RocketHideout4Script_45747
	ld a, HS_ROCKET_HIDEOUT_4_JESSIE
	call RocketHideout4Script_45747
	ld a, $4
	call RocketHideout4Script_4551e
	ret

RocketHideout4JessieJamesMovementData_45605:
	db $4
RocketHideout4JessieJamesMovementData_45606:
	db $4
	db $4
	db $4
	db $ff

RocketHideout4Script4:
	ld de, RocketHideout4JessieJamesMovementData_45605
	CheckEvent EVENT_BEAT_ROCKET_HIDEOUT_4_TRAINER_2
	jr z, .asm_45617
	ld de, RocketHideout4JessieJamesMovementData_45606
.asm_45617
	ld a, $2
	ld [hSpriteIndexOrTextID], a
	call MoveSprite
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, $5
	call RocketHideout4Script_4551e
	ret

RocketHideout4Script5:
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, [wd730]
	bit 0, a
	ret nz
RocketHideout4Script6:
	ld a, $2
	ld [wSpriteStateData1 + 2 * $10 + 1], a
	ld a, SPRITE_FACING_LEFT
	ld [wSpriteStateData1 + 2 * $10 + 9], a
	CheckEvent EVENT_BEAT_ROCKET_HIDEOUT_4_TRAINER_2
	jr z, .asm_4564a
	ld a, SPRITE_FACING_DOWN
	ld [wSpriteStateData1 + 2 * $10 + 9], a
.asm_4564a
	call Delay3
	ld a, $fc
	ld [wJoyIgnore], a
RocketHideout4Script7:
	ld de, RocketHideout4JessieJamesMovementData_45606
	CheckEvent EVENT_BEAT_ROCKET_HIDEOUT_4_TRAINER_2
	jr z, .asm_4565f
	ld de, RocketHideout4JessieJamesMovementData_45605
.asm_4565f
	ld a, $3
	ld [hSpriteIndexOrTextID], a
	call MoveSprite
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, $8
	call RocketHideout4Script_4551e
	ret

RocketHideout4Script8:
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, $fc
	ld [wJoyIgnore], a
RocketHideout4Script9:
	ld a, $2
	ld [wSpriteStateData1 + 3 * $10 + 1], a
	ld a, SPRITE_FACING_DOWN
	ld [wSpriteStateData1 + 3 * $10 + 9], a
	CheckEvent EVENT_BEAT_ROCKET_HIDEOUT_4_TRAINER_2
	jr z, .asm_45697
	ld a, SPRITE_FACING_RIGHT
	ld [wSpriteStateData1 + 3 * $10 + 9], a
.asm_45697
	call Delay3
	ld a, $c
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
RocketHideout4Script10:
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, RocketHideout4JessieJamesEndBattleText
	ld de, RocketHideout4JessieJamesEndBattleText
	call SaveEndBattleTextPointers
	ld a, OPP_ROCKET
	ld [wCurOpponent], a
	ld a, $2b
	ld [wTrainerNo], a
	xor a
	ld [hJoyHeld], a
	ld [wJoyIgnore], a
	SetEvent EVENT_6A0
	ld a, $b
	call RocketHideout4Script_4551e
	ret

RocketHideout4Script11:
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, [wIsInBattle]
	cp $ff
	jp z, RocketHideout4Script_45510
	ld a, $2
	ld [wSpriteStateData1 + 2 * $10 + 1], a
	ld [wSpriteStateData1 + 3 * $10 + 1], a
	xor a
	ld [wSpriteStateData1 + 2 * $10 + 9], a
	ld [wSpriteStateData1 + 3 * $10 + 9], a
	ld a, $fc
	ld [wJoyIgnore], a
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, $d
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call StopAllMusic
	ld c, BANK(Music_MeetJessieJames)
	ld a, MUSIC_MEET_JESSIE_JAMES
	call PlayMusic
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, $c
	call RocketHideout4Script_4551e
	ret

RocketHideout4Script12:
	ld a, $ff
	ld [wJoyIgnore], a
	call GBFadeOutToBlack
	ld a, HS_ROCKET_HIDEOUT_4_JAMES
	call RocketHideout4Script_45756
	ld a, HS_ROCKET_HIDEOUT_4_JESSIE
	call RocketHideout4Script_45756
	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack
	ld a, $d
	call RocketHideout4Script_4551e
	ret

RocketHideout4Script13:
	call PlayDefaultMusic
	xor a
	ld [hJoyHeld], a
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_ROCKET_HIDEOUT_4_TRAINER_0
	ld a, $0
	call RocketHideout4Script_4551e
	ret

RocketHideout4Script_45747:
	ld [wMissableObjectIndex], a
	predef ShowObject
	call UpdateSprites
	call Delay3
	ret

RocketHideout4Script_45756:
	ld [wMissableObjectIndex], a
	predef HideObject
	ret

RocketHideout4TextPointers:
	dw RocketHideout4Text0
	dw RocketHideout4Text1
	dw RocketHideout4Text2
	dw RocketHideout4Text3
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw RocketHideout4Text9
	dw RocketHideout4Text10
	dw RocketHideout4Text11
	dw RocketHideout4Text12

RocketHideout4TrainerHeaders:
RocketHideout4TrainerHeader0:
	dbEventFlagBit EVENT_BEAT_ROCKET_HIDEOUT_4_TRAINER_3
	db ($1 << 4)
	dwEventFlagAddress EVENT_BEAT_ROCKET_HIDEOUT_4_TRAINER_3
	dw RocketHideout4Trainer0BeforeText
	dw RocketHideout4Trainer0AfterText
	dw RocketHideout4Trainer0EndBattleText
	dw RocketHideout4Trainer0EndBattleText
	db $ff

RocketHideout4Text1:
RocketHideout4Text2:
	db "@"

RocketHideout4Text10:
	TX_FAR _RocketHideoutJessieJamesText1
	TX_ASM
	ld c, 10
	call DelayFrames
	ld a, $8
	ld [wPlayerMovingDirection], a
	ld a, $0
	ld [wEmotionBubbleSpriteIndex], a
	ld a, EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	ld c, 20
	call DelayFrames
	jp TextScriptEnd

RocketHideout4Text11:
	TX_FAR _RocketHideoutJessieJamesText2
	db "@"

RocketHideout4JessieJamesEndBattleText:
	TX_FAR _RocketHideoutJessieJamesText3
	db "@"

RocketHideout4Text12:
	TX_FAR _RocketHideoutJessieJamesText4
	TX_ASM
	ld c, 64
	call DelayFrames
	jp TextScriptEnd

RocketHideout4Text0:
	TX_ASM
	CheckEvent EVENT_BEAT_ROCKET_HIDEOUT_GIOVANNI
	jp nz, .asm_457fb
	ld hl, RocketHideout4Text_45804
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, RocketHideout4Text_45809
	ld de, RocketHideout4Text_45809
	call SaveEndBattleTextPointers
	ld a, [hSpriteIndexOrTextID]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	xor a
	ld [hJoyHeld], a
	ld a, $3
	ld [wRocketHideout4CurScript], a
	ld [wCurMapScript], a
	jr .asm_45801

.asm_457fb
	ld hl, RocketHideout4Text9
	call PrintText
.asm_45801
	jp TextScriptEnd

RocketHideout4Text_45804:
	TX_FAR _RocketHideout4Text_4557a
	db "@"

RocketHideout4Text_45809:
	TX_FAR _RocketHideout4Text_4557f
	db "@"

RocketHideout4Text9:
	TX_FAR _RocketHideout4Text_45584
	db "@"

RocketHideout4Text3:
	TX_ASM
	ld hl, RocketHideout4TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

RocketHideout4Trainer0BeforeText:
	TX_FAR _RocketHideout4BattleText4
	db "@"

RocketHideout4Trainer0EndBattleText:
	TX_FAR _RocketHideout4EndBattleText4
	TX_BUTTON_SOUND
	TX_ASM
	SetEvent EVENT_ROCKET_DROPPED_LIFT_KEY
	ld a, HS_ROCKET_HIDEOUT_4_ITEM_5
	ld [wMissableObjectIndex], a
	predef ShowObject
	jp TextScriptEnd

RocketHideout4Trainer0AfterText:
	TX_ASM
	ld hl, RocketHideout4Text_45844
	call PrintText
	jp TextScriptEnd

RocketHideout4Text_45844:
	TX_FAR _RocketHideout4Text_455ec
	db "@"
