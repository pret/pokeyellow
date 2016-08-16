SilphCo11Script:
	call SilphCo11Script_62127
	call EnableAutoTextBoxDrawing
	ld hl, SilphCo11TrainerHeaders
	ld de, SilphCo11ScriptPointers
	ld a, [wSilphCo11CurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo11CurScript], a
	ret

SilphCo11Script_62127:
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	ld hl, SilphCo11GateCoords
	call SilphCo11Script_6214f
	call SilphCo11Script_6217b
	CheckEvent EVENT_SILPH_CO_11_UNLOCKED_DOOR
	ret nz
	ld a, $20
	ld [wNewTileBlockID], a
	lb bc, 6, 3
	predef ReplaceTileBlock
	ret

SilphCo11GateCoords:
	db $06,$03
	db $FF

SilphCo11Script_6214f:
	push hl
	ld hl, wCardKeyDoorY
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	xor a
	ld [$ffe0], a
	pop hl
.asm_62143
	ld a, [hli]
	cp $ff
	jr z, .asm_6215f
	push hl
	ld hl, $ffe0
	inc [hl]
	pop hl
	cp b
	jr z, .asm_62154
	inc hl
	jr .asm_62143
.asm_62154
	ld a, [hli]
	cp c
	jr nz, .asm_62143
	ld hl, wCardKeyDoorY
	xor a
	ld [hli], a
	ld [hl], a
	ret
.asm_6215f
	xor a
	ld [$ffe0], a
	ret

SilphCo11Script_6217b:
	ld a, [$ffe0]
	and a
	ret z
	SetEvent EVENT_SILPH_CO_11_UNLOCKED_DOOR
	ret

SilphCo11Script_62185:
	xor a
	ld [wJoyIgnore], a
SilphCo11Script_62189:
	ld [wSilphCo11CurScript], a
	ld [wCurMapScript], a
	ret

SilphCo11ScriptPointers:
	dw SilphCo11Script0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw SilphCo11Script3
	dw SilphCo11Script4
	dw SilphCo11Script5
	dw SilphCo11Script6
	dw SilphCo11Script7
	dw SilphCo11Script8
	dw SilphCo11Script9
	dw SilphCo11Script10
	dw SilphCo11Script11
	dw SilphCo11Script12
	dw SilphCo11Script13
	dw SilphCo11Script14

SilphCo11Script0:
	CheckEvent EVENT_BEAT_SILPH_CO_11F_TRAINER_0
	call z, SilphCo11Script_6229c
	CheckEvent EVENT_782
	ret nz
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	call z, SilphCo11Script_621c5
	ret

SilphCo11Script_621c5:
	ld hl, CoordsData_62211
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
	ld a, [wCoordIndex]
	ld [wcf0d], a
	xor a
	ld [hJoyHeld], a
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, $3
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $3
	ld [H_SPRITEINDEX], a
	call SetSpriteMovementBytesToFF
	ld de, MovementData_62216
	call MoveSprite
	ld a, $4
	call SilphCo11Script_62189
	ret

CoordsData_62211:
	db $0D,$06
	db $0C,$07
	db $FF

MovementData_62216:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db $FF

SilphCo11Script_621ff:
	ld [wPlayerMovingDirection], a
	ld a, b
	ld [wSpriteStateData1 + 3 * $10 + 9], a
	ld a, $2
	ld [wSpriteStateData1 + 3 * $10 + 1], a
	ret

SilphCo11Script3:
	ld a, [wIsInBattle]
	cp $ff
	jp z, SilphCo11Script_62185
	ld a, [wcf0d]
	cp $1
	jr z, .asm_6223c
	ld a, PLAYER_DIR_LEFT
	ld b, SPRITE_FACING_RIGHT
	jr .asm_62240
.asm_6223c
	ld a, PLAYER_DIR_UP
	ld b, SPRITE_FACING_DOWN
.asm_62240
	call SilphCo11Script_621ff
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, $7
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	call GBFadeOutToBlack
	callba Func_f25a0
	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack
	SetEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	xor a
	ld [wJoyIgnore], a
	jp SilphCo11Script_62189

SilphCo11Script4:
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, $3
	ld [H_SPRITEINDEX], a
	call SetSpriteMovementBytesToFF
	ld a, [wcf0d]
	cp $1
	jr z, .asm_62284
	ld a, PLAYER_DIR_LEFT
	ld b, SPRITE_FACING_RIGHT
	jr .asm_62288
.asm_62284
	ld a, PLAYER_DIR_UP
	ld b, SPRITE_FACING_DOWN
.asm_62288
	call SilphCo11Script_621ff
	call Delay3
	xor a
	ld [wJoyIgnore], a
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, SilphCo10Text_62528
	ld de, SilphCo10Text_62528
	call SaveEndBattleTextPointers
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $3
	jp SilphCo11Script_62189

SilphCo11Script_6229c:
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
	ld [hJoyHeld], a
	ld a, $fc
	ld [wJoyIgnore], a
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, $8
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, $ff
	ld [wJoyIgnore], a
	SetEvent EVENT_782
	ld a, $5
	call SilphCo11Script_62189
	ret

SilphCo11MovementData_622f5:
	db $5
	db $5
	db $5
	db $5
	db $5
	db $ff

SilphCo11MovementData_622fb:
	db $5
	db $5
	db $5
	db $5
	db $ff

SilphCo11MovementData_62300:
	db $5
	db $5
	db $5
	db $5
	db $ff

SilphCo11MovementData_62305:
	db $5
	db $5
	db $5
	db $5
	db $5
	db $ff

SilphCo11MovementData_6230b:
	db $5
	db $5
	db $6
	db $5
	db $5
	db $ff

SilphCo11MovementData_62311:
	db $5
	db $5
	db $5
	db $6
	db $5
	db $5
	db $ff

SilphCo11Script5:
	ld de, SilphCo11MovementData_622f5
	CheckEitherEventSet EVENT_780, EVENT_781
	and a
	jr z, .asm_6232d
	ld de, SilphCo11MovementData_62300
	cp $1
	jr z, .asm_6232d
	ld de, SilphCo11MovementData_6230b
.asm_6232d
	ld a, $4
	ld [hSpriteIndexOrTextID], a
	call MoveSprite
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, $6
	call SilphCo11Script_62189
	ret

SilphCo11Script6:
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, [wd730]
	bit 0, a
	ret nz
SilphCo11Script7:
	ld a, $2
	ld [wSpriteStateData1 + 4 * $10 + 1], a
	ld hl, wSpriteStateData1 + 4 * $10 + 9
	ld [hl], SPRITE_FACING_RIGHT
	CheckEitherEventSet EVENT_780, EVENT_781
	and a
	jr z, .asm_6235e
	ld [hl], SPRITE_FACING_UP
.asm_6235e
	call Delay3
	ld a, $fc
	ld [wJoyIgnore], a
SilphCo11Script8:
	ld de, SilphCo11MovementData_622fb
	CheckEitherEventSet EVENT_780, EVENT_781
	and a
	jr z, .asm_6237b
	ld de, SilphCo11MovementData_62305
	cp $1
	jr z, .asm_6237b
	ld de, SilphCo11MovementData_62311
.asm_6237b
	ld a, $6
	ld [hSpriteIndexOrTextID], a
	call MoveSprite
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, $9
	call SilphCo11Script_62189
	ret

SilphCo11Script9:
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, $fc
	ld [wJoyIgnore], a
SilphCo11Script10:
	ld a, $2
	ld [wSpriteStateData1 + 6 * $10 + 1], a
	ld hl, wSpriteStateData1 + 6 * $10 + 9
	ld [hl], SPRITE_FACING_UP
	CheckEitherEventSet EVENT_780, EVENT_781
	and a
	jr z, .asm_623b1
	ld [hl], SPRITE_FACING_LEFT
.asm_623b1
	call Delay3
	ld a, $9
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
SilphCo11Script11:
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, SilphCo11Text_624c2
	ld de, SilphCo11Text_624c2
	call SaveEndBattleTextPointers
	ld a, OPP_ROCKET
	ld [wCurOpponent], a
	ld a, $2d
	ld [wTrainerNo], a
	xor a
	ld [hJoyHeld], a
	ld [wJoyIgnore], a
	ld a, $c
	call SilphCo11Script_62189
	ret

SilphCo11Script12:
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, [wIsInBattle]
	cp $ff
	jp z, SilphCo11Script_62185
	ld a, $2
	ld [wSpriteStateData1 + 4 * $10 + 1], a
	ld [wSpriteStateData1 + 6 * $10 + 1], a
	xor a
	ld [wSpriteStateData1 + 4 * $10 + 9], a
	ld [wSpriteStateData1 + 6 * $10 + 9], a
	ld a, $fc
	ld [wJoyIgnore], a
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, $a
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
	ld a, $d
	call SilphCo11Script_62189
	ret

SilphCo11Script13:
	ld a, $ff
	ld [wJoyIgnore], a
	call GBFadeOutToBlack
	ld a, HS_SILPH_CO_11F_JAMES
	call SilphCo11Script_6246d
	ld a, HS_SILPH_CO_11F_JESSIE
	call SilphCo11Script_6246d
	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack
	ld a, $e
	call SilphCo11Script_62189
	ret

SilphCo11Script14:
	call PlayDefaultMusic
	xor a
	ld [hJoyHeld], a
	ld [wJoyIgnore], a
	ResetEvent EVENT_782
	SetEventReuseHL EVENT_BEAT_SILPH_CO_11F_TRAINER_0
	ld a, $0
	call SilphCo11Script_62189
	ret

SilphCo11Script_6245e:
	ld [wMissableObjectIndex], a
	predef ShowObject
	call UpdateSprites
	call Delay3
	ret

SilphCo11Script_6246d:
	ld [wMissableObjectIndex], a
	predef HideObject
	ret

SilphCo11TextPointers:
	dw SilphCo11Text1
	dw SilphCo11Text2
	dw SilphCo11Text3
	dw SilphCo11Text4
	dw SilphCo11Text5
	dw SilphCo11Text6
	dw SilphCo11Text7
	dw SilphCo11Text8
	dw SilphCo11Text9
	dw SilphCo11Text10

SilphCo11TrainerHeaders:
SilphCo11TrainerHeader0:
	dbEventFlagBit EVENT_BEAT_SILPH_CO_11F_TRAINER_1
	db ($3 << 4)
	dwEventFlagAddress EVENT_BEAT_SILPH_CO_11F_TRAINER_1
	dw SilphCo11Trainer1BattleText
	dw SilphCo11Trainer1AfterBattleText
	dw SilphCo11Trainer1EndBattleText
	dw SilphCo11Trainer1EndBattleText

	db $ff ; no more trainers

SilphCo11Text4:
SilphCo11Text6:
SilphCo11Text8:
	TX_FAR _SilphCoJessieJamesText1
	TX_ASM
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

SilphCo11Text9:
	TX_FAR _SilphCoJessieJamesText2
	db "@"

SilphCo11Text_624c2:
	TX_FAR _SilphCoJessieJamesText3
	db "@"

SilphCo11Text10:
	TX_FAR _SilphCoJessieJamesText4
	TX_ASM
	ld c, 64
	call DelayFrames
	jp TextScriptEnd

SilphCo11Text1:
	TX_ASM
	CheckEvent EVENT_GOT_MASTER_BALL
	jp nz, .asm_62500
	ld hl, SilphCo11Text_62509
	call PrintText
	lb bc, MASTER_BALL, 1
	call GiveItem
	jr nc, .asm_624f8
	ld hl, SilphCo11Text_6250e
	call PrintText
	SetEvent EVENT_GOT_MASTER_BALL
	jr .asm_62506
.asm_624f8
	ld hl, SilphCo11Text_62519
	call PrintText
	jr .asm_62506

.asm_62500
	ld hl, SilphCo11Text_62514
	call PrintText
.asm_62506
	jp TextScriptEnd

SilphCo11Text_62509:
	TX_FAR _SilphCoPresidentText
	db "@"

SilphCo11Text_6250e:
	TX_FAR _ReceivedSilphCoMasterBallText
	TX_SFX_KEY_ITEM
	db "@"

SilphCo11Text_62514:
	TX_FAR _SilphCo10Text_6231c
	db "@"

SilphCo11Text_62519:
	TX_FAR _SilphCoMasterBallNoRoomText
	db "@"

SilphCo11Text2:
	TX_FAR _SilphCo11Text2
	db "@"

SilphCo11Text3:
	TX_FAR _SilphCo11Text3
	db "@"

SilphCo10Text_62528:
	TX_FAR _SilphCo10Text_62330
	db "@"

SilphCo11Text7:
	TX_FAR _SilphCo10Text_62335
	db "@"

SilphCo11Text5:
	TX_ASM
	ld hl, SilphCo11TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SilphCo11Trainer1BattleText:
	TX_FAR _SilphCo11BattleText2
	db "@"

SilphCo11Trainer1EndBattleText:
	TX_FAR _SilphCo11EndBattleText2
	db "@"

SilphCo11Trainer1AfterBattleText:
	TX_FAR _SilphCo11AfterBattleText2
	db "@"
