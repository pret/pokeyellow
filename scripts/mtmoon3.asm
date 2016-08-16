MtMoon3Script:
	call EnableAutoTextBoxDrawing
	ld hl, MtMoon3TrainerHeaders
	ld de, MtMoon3ScriptPointers
	ld a, [wMtMoon3CurScript]
	call ExecuteCurMapScriptInTable
	ld [wMtMoon3CurScript], a
	CheckEvent EVENT_BEAT_MT_MOON_EXIT_SUPER_NERD
	ret z
	ld hl, CoordsData_49d37
	call ArePlayerCoordsInArray
	jr nc, .asm_49d31
	ld hl, wd72e
	set 4, [hl]
	ret
.asm_49d31
	ld hl, wd72e
	res 4, [hl]
	ret

CoordsData_49d37:
	db $05,$0B
	db $05,$0C
	db $05,$0D
	db $05,$0E
	db $06,$0B
	db $06,$0C
	db $06,$0D
	db $06,$0E
	db $07,$0B
	db $07,$0C
	db $07,$0D
	db $07,$0E
	db $08,$0B
	db $08,$0C
	db $08,$0D
	db $08,$0E
	db $FF

MtMoon3Script_49cd7:
	CheckAndResetEvent EVENT_57E
	call nz, MtMoon3Script_49cec
	xor a
	ld [wJoyIgnore], a
MtMoon3Script_49ce5:
	ld [wMtMoon3CurScript], a
	ld [wCurMapScript], a
	ret

MtMoon3Script_49cec:
	ld a, HS_MT_MOON_JESSIE
	call MtMoon3Script_49f93
	ld a, HS_MT_MOON_JAMES
	call MtMoon3Script_49f93
	ret

MtMoon3ScriptPointers:
	dw MtMoon3Script0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw MtMoon3Script3
	dw MtMoon3Script4
	dw MtMoon3Script5
	dw MtMoon3Script6
	dw MtMoon3Script7
	dw MtMoon3Script8
	dw MtMoon3Script9
	dw MtMoon3Script10
	dw MtMoon3Script11
	dw MtMoon3Script12
	dw MtMoon3Script13
	dw MtMoon3Script14
	dw MtMoon3Script15

MtMoon3Script0:
	CheckEitherEventSet EVENT_GOT_DOME_FOSSIL, EVENT_GOT_HELIX_FOSSIL
	call z, MtMoon3Script_49d28
	CheckEvent EVENT_BEAT_MT_MOON_3_TRAINER_0
	call z, MtMoon3Script_49e15
	ret

MtMoon3Script_49d28:
	CheckEvent EVENT_BEAT_MT_MOON_EXIT_SUPER_NERD
	jp nz, .asm_49d4b
	ld a, [wYCoord]
	cp $8
	jp nz, .asm_49d4b
	ld a, [wXCoord]
	cp $d
	jp nz, .asm_49d4b
	xor a
	ld [hJoyHeld], a
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ret

.asm_49d4b
	CheckEitherEventSet EVENT_GOT_DOME_FOSSIL, EVENT_GOT_HELIX_FOSSIL
	jp z, CheckFightingMapTrainers
	ret

MtMoon3Script3:
	ld a, [wIsInBattle]
	cp $ff
	jp z, MtMoon3Script_49cd7
	call UpdateSprites
	call Delay3
	SetEvent EVENT_BEAT_MT_MOON_EXIT_SUPER_NERD
	xor a
	ld [wJoyIgnore], a
	ld a, $0
	call MtMoon3Script_49ce5
	ret

MtMoon3Script4:
	ld a, $1
	ld [H_SPRITEINDEX], a
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
	call MtMoon3Script_4a325
.asm_49da3
	ld de, MovementData_49ddd
	jr .asm_49db3

.asm_49da8
	ld b, SPRITE_FACING_RIGHT
	ld hl, PikachuMovementData_49dca
	call MtMoon3Script_4a325
.asm_49db0
	ld de, MovementData_49ddc
.asm_49db3
	ld a, $1
	ld [H_SPRITEINDEX], a
	call MoveSprite
	ld a, $5
	call MtMoon3Script_49ce5
	ret

CoordsData_49dc0:
	db $07,$0C
	db $06,$0B
	db $05,$0C
	db $FF

CoordsData_49dc7:
	db $07,$0C
	db $FF

PikachuMovementData_49dca:
	db $00
	db $35
	db $33
	db $3f

CoordsData_49dce:
	db $07,$0D
	db $06,$0E
	db $05,$0E
	db $FF

CoordsData_49dd5:
	db $07,$0D
	db $FF

PikachuMovementData_49dd8:
	db $00
	db $35
	db $34
	db $3f

MovementData_49ddc:
	db NPC_MOVEMENT_RIGHT
MovementData_49ddd:
	db NPC_MOVEMENT_UP
	db $FF

MtMoon3Script5:
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, $b
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	CheckEvent EVENT_GOT_HELIX_FOSSIL
	jr z, .asm_49e1d
	ld a, HS_MT_MOON_3_FOSSIL_1
	jr .asm_49e1f
.asm_49e1d
	ld a, HS_MT_MOON_3_FOSSIL_2
.asm_49e1f
	ld [wMissableObjectIndex], a
	predef HideObject
	xor a
	ld [wJoyIgnore], a
	ld a, $0
	call MtMoon3Script_49ce5
	ret

MtMoon3Script_49e15:
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
	ld [hJoyHeld], a
	ld a, $FF ^ (A_BUTTON | B_BUTTON)
	ld [wJoyIgnore], a
	ld a, HS_MT_MOON_JESSIE
	call MtMoon3Script_49f84
	ld a, HS_MT_MOON_JAMES
	call MtMoon3Script_49f84
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, $c
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	call StartSimulatingJoypadStates
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, $6
	call MtMoon3Script_49ce5
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

MtMoon3Script6:
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	ld a, $2
	ld [H_SPRITEINDEX], a
	ld de, MovementData_f9e65
	call MoveSprite
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, $7
	call MtMoon3Script_49ce5
	ret

MtMoon3Script7:
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, [wd730]
	bit 0, a
	ret nz
MtMoon3Script8:
	ld a, $2
	ld [wSpriteStateData1 + 2 * $10 + 1], a
	ld a, SPRITE_FACING_DOWN
	ld [wSpriteStateData1 + 2 * $10 + 9], a
MtMoon3Script9:
	ld a, $6
	ld [H_SPRITEINDEX], a
	ld de, MovementData_f9e66
	call MoveSprite
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, $a
	call MtMoon3Script_49ce5
	ret

MtMoon3Script10:
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, [wd730]
	bit 0, a
	ret nz
MtMoon3Script11:
	ld a, $2
	ld [wSpriteStateData1 + 6 * $10 + 1], a
	ld a, SPRITE_FACING_LEFT
	ld [wSpriteStateData1 + 6 * $10 + 9], a
	call Delay3
	ld a, $FF ^ (A_BUTTON | B_BUTTON)
	ld [wJoyIgnore], a
	ld a, $d
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
MtMoon3Script12:
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, MtMoon3JessieJamesEndBattleText
	ld de, MtMoon3JessieJamesEndBattleText
	call SaveEndBattleTextPointers
	ld a, OPP_ROCKET
	ld [wCurOpponent], a
	ld a, $2a
	ld [wTrainerNo], a
	xor a
	ld [hJoyHeld], a
	ld [wJoyIgnore], a
	SetEvent EVENT_57E
	ld a, $d
	call MtMoon3Script_49ce5
	ret

MtMoon3Script13:
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, [wIsInBattle]
	cp $ff
	jp z, MtMoon3Script_49cd7
	ld a, $2
	ld [wSpriteStateData1 + 2 * $10 + 1], a
	ld [wSpriteStateData1 + 6 * $10 + 1], a
	xor a
	ld [wSpriteStateData1 + 2 * $10 + 9], a
	ld [wSpriteStateData1 + 6 * $10 + 9], a
	ld a, $FF ^ (A_BUTTON | B_BUTTON)
	ld [wJoyIgnore], a
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, $e
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
	ld a, $e
	call MtMoon3Script_49ce5
	ret

MtMoon3Script14:
	ld a, $ff
	ld [wJoyIgnore], a
	call GBFadeOutToBlack
	ld a, HS_MT_MOON_JESSIE
	call MtMoon3Script_49f93
	ld a, HS_MT_MOON_JAMES
	call MtMoon3Script_49f93
	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack
	ld a, $f
	call MtMoon3Script_49ce5
	ret

MtMoon3Script15:
	call PlayDefaultMusic
	xor a
	ld [hJoyHeld], a
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_MT_MOON_3_TRAINER_0
	ResetEventReuseHL EVENT_57E
	ld a, $0
	call MtMoon3Script_49ce5
	ret

MtMoon3Script_49f84:
	ld [wMissableObjectIndex], a
	predef ShowObject
	call UpdateSprites
	call Delay3
	ret

MtMoon3Script_49f93:
	ld [wMissableObjectIndex], a
	predef HideObject
	ret

MtMoon3TextPointers:
	dw MtMoon3Text1
	dw MtMoon3Text2
	dw MtMoon3Text3
	dw MtMoon3Text4
	dw MtMoon3Text5
	dw MtMoon3Text6
	dw MtMoon3Text7
	dw MtMoon3Text8
	dw PickUpItemText
	dw PickUpItemText
	dw MtMoon3Text11
	dw MtMoon3Text12
	dw MtMoon3Text13
	dw MtMoon3Text14

MtMoon3TrainerHeaders:
MtMoon3TrainerHeader0:
	dbEventFlagBit EVENT_BEAT_MT_MOON_3_TRAINER_2
	db ($4 << 4)
	dwEventFlagAddress EVENT_BEAT_MT_MOON_3_TRAINER_2
	dw MtMoon3BattleText3
	dw MtMoon3AfterBattleText3
	dw MtMoon3EndBattleText3
	dw MtMoon3EndBattleText3

MtMoon3TrainerHeader1:
	dbEventFlagBit EVENT_BEAT_MT_MOON_3_TRAINER_3
	db ($4 << 4)
	dwEventFlagAddress EVENT_BEAT_MT_MOON_3_TRAINER_3
	dw MtMoon3BattleText4
	dw MtMoon3AfterBattleText4
	dw MtMoon3EndBattleText4
	dw MtMoon3EndBattleText4

MtMoon3TrainerHeader2:
	dbEventFlagBit EVENT_BEAT_MT_MOON_3_TRAINER_4
	db ($4 << 4)
	dwEventFlagAddress EVENT_BEAT_MT_MOON_3_TRAINER_4
	dw MtMoon3BattleText5
	dw MtMoon3AfterBattleText5
	dw MtMoon3EndBattleText5
	dw MtMoon3EndBattleText5

	db $FF

MtMoon3Text2:
MtMoon3Text6:
	db "@"

MtMoon3Text12:
	TX_FAR _MtMoonJessieJamesText1
	TX_ASM
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

MtMoon3Text13:
	TX_FAR _MtMoonJessieJamesText2
	db "@"

MtMoon3JessieJamesEndBattleText:
	TX_FAR _MtMoonJessieJamesText3
	db "@"

MtMoon3Text14:
	TX_FAR _MtMoonJessieJamesText4
	TX_ASM
	ld c, 64
	call DelayFrames
	jp TextScriptEnd

MtMoon3Text1:
	TX_ASM
	CheckEvent EVENT_BEAT_MT_MOON_EXIT_SUPER_NERD
	jr z, .asm_4a02f
	and $81 ; CheckEitherEventSetReuseA EVENT_GOT_DOME_FOSSIL, EVENT_GOT_HELIX_FOSSIL
	jr nz, .asm_4a057
	ld hl, MtMoon3Text_4a116
	call PrintText
	jr .asm_4a05d

.asm_4a02f
	ld hl, MtMoon3Text_4a10c
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, MtMoon3SuperNerdEndBattleText
	ld de, MtMoon3SuperNerdEndBattleText
	call SaveEndBattleTextPointers
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $3
	call MtMoon3Script_49ce5
	jr .asm_4a05d

.asm_4a057
	ld hl, MtMoon3Text_4a11b
	call PrintText
.asm_4a05d
	jp TextScriptEnd

MtMoon3Text3:
	TX_ASM
	ld hl, MtMoon3TrainerHeader0
	jr MtMoon3TalkToTrainer

MtMoon3Text4:
	TX_ASM
	ld hl, MtMoon3TrainerHeader1
	jr MtMoon3TalkToTrainer


MtMoon3Text5:
	TX_ASM
	ld hl, MtMoon3TrainerHeader2
MtMoon3TalkToTrainer:
	call TalkToTrainer
	jp TextScriptEnd

MtMoon3Text7:
	TX_ASM
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, MtMoon3Text_4a0ae
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_4a0ab
	lb bc, DOME_FOSSIL, 1
	call GiveItem
	jp nc, MtMoon3Script_4a0fd
	call MtMoon3Script_4a0f0
	ld a, HS_MT_MOON_3_FOSSIL_1
	ld [wMissableObjectIndex], a
	predef HideObject
	SetEvent EVENT_GOT_DOME_FOSSIL
	ld a, $4
	call MtMoon3Script_49ce5
.asm_4a0ab
	jp TextScriptEnd

MtMoon3Text_4a0ae:
	TX_FAR _MtMoon3Text_49f24
	db "@"

MtMoon3Text8:
	TX_ASM
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, MtMoon3Text_4a0eb
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_4a0e8
	lb bc, HELIX_FOSSIL, 1
	call GiveItem
	jp nc, MtMoon3Script_4a0fd
	call MtMoon3Script_4a0f0
	ld a, HS_MT_MOON_3_FOSSIL_2
	ld [wMissableObjectIndex], a
	predef HideObject
	SetEvent EVENT_GOT_HELIX_FOSSIL
	ld a, $4
	call MtMoon3Script_49ce5
.asm_4a0e8
	jp TextScriptEnd

MtMoon3Text_4a0eb:
	TX_FAR _MtMoon3Text_49f64
	db "@"

MtMoon3Script_4a0f0:
	ld hl, MtMoon3Text_4a0f6
	jp PrintText

MtMoon3Text_4a0f6:
	TX_FAR _MtMoon3Text_49f6f
	TX_SFX_KEY_ITEM
	TX_WAIT_BUTTON
	db "@"

MtMoon3Script_4a0fd:
	ld hl, MtMoon3Text_4a106
	call PrintText
	jp TextScriptEnd

MtMoon3Text_4a106:
	TX_FAR _MtMoon3Text_49f7f
	TX_WAIT_BUTTON
	db "@"

MtMoon3Text_4a10c:
	TX_FAR _MtMoon3Text_49f85
	db "@"

MtMoon3SuperNerdEndBattleText:
	TX_FAR _MtMoon3Text_49f8a
	db "@"

MtMoon3Text_4a116:
	TX_FAR _MtMoon3Text_49f8f
	db "@"

MtMoon3Text_4a11b:
	TX_FAR _MtMoon3Text_49f94
	db "@"

MtMoon3Text11:
	TX_FAR _MtMoon3Text_49f99
	TX_SFX_KEY_ITEM
	db "@"

MtMoon3BattleText3:
	TX_FAR _MtMoon3BattleText3
	db "@"

MtMoon3EndBattleText3:
	TX_FAR _MtMoon3EndBattleText3
	db "@"

MtMoon3AfterBattleText3:
	TX_FAR _MtMoon3AfterBattleText3
	db "@"

MtMoon3BattleText4:
	TX_FAR _MtMoon3BattleText4
	db "@"

MtMoon3EndBattleText4:
	TX_FAR _MtMoon3EndBattleText4
	db "@"

MtMoon3AfterBattleText4:
	TX_FAR _MtMoon3AfterBattleText4
	db "@"

MtMoon3BattleText5:
	TX_FAR _MtMoon3BattleText5
	db "@"

MtMoon3EndBattleText5:
	TX_FAR _MtMoon3EndBattleText5
	db "@"

MtMoon3AfterBattleText5:
	TX_FAR _MtMoon3AfterBattleText5
	db "@"

