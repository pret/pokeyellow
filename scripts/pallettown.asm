PalletTownScript: ; 18e5b (6:4e5b)
	CheckEvent EVENT_GOT_POKEBALLS_FROM_OAK
	jr z, .next
	SetEvent EVENT_PALLET_AFTER_GETTING_POKEBALLS
.next
	call EnableAutoTextBoxDrawing
	ld hl, PalletTownScriptPointers
	ld a, [W_PALLETTOWNCURSCRIPT]
	jp CallFunctionInTable

PalletTownScriptPointers: ; 18e73 (6:4e73)
	dw PalletTownScript0
	dw PalletTownScript1
	dw PalletTownScript2
	dw PalletTownScript3
	dw PalletTownScript4
	dw PalletTownScript5
	dw PalletTownScript6
	dw PalletTownScript7
	dw PalletTownScript8
	dw PalletTownScript9

PalletTownScript0: ; 18e81 (6:4e81)
	CheckEvent EVENT_FOLLOWED_OAK_INTO_LAB
	ret nz
	ld a, [wYCoord]
	cp 0 ; is player at north exit?
	ret nz
	ResetEvent EVENT_005
	ld a, [wXCoord]
	cp 10
	jr z, .asm_18e40
	SetEventReuseHL EVENT_005
.asm_18e40
	xor a
	ld [hJoyHeld], a
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	call StopAllMusic
	ld a, BANK(Music_MeetProfOak)
	ld c, a
	ld a, MUSIC_MEET_PROF_OAK ; “oak appears” music
	call PlayMusic
	SetEvent EVENT_OAK_APPEARED_IN_PALLET

	; trigger the next script
	ld a, 1
	ld [W_PALLETTOWNCURSCRIPT], a
	ret

PalletTownScript1: ; 18eb2 (6:4eb2)
	ld a, $FF ^ (A_BUTTON | B_BUTTON)
	ld [wJoyIgnore], a
	xor a
	ld [wcf0d], a
	ld a, 1
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $FF
	ld [wJoyIgnore], a
	ld hl, wSpriteStateData2 + 1 * $10 + 4
	ld a, $8
	ld [hli], a
	ld a, $e
	ld [hl], a
	ld a, HS_PALLET_TOWN_OAK
	ld [wMissableObjectIndex], a
	predef ShowObject

	; trigger the next script
	ld a, $2
	ld [wSpriteStateData1 + 1 * $10 + 1], a
	ld a, SPRITE_FACING_UP
	ld [wSpriteStateData1 + 1 * $10 + 9], a
	ld a, 2
	ld [W_PALLETTOWNCURSCRIPT], a
	ret

PalletTownScript2: ; 18ed2 (6:4ed2)
	call Delay3
	ld a, 0
	ld [wYCoord], a
	ld a, 1
	ld [hNPCPlayerRelativePosPerspective], a
	ld a, 1
	swap a
	ld [hNPCSpriteOffset], a
	predef CalcPositionOfPlayerRelativeToNPC
	ld hl, hNPCPlayerYDistance
	dec [hl]
	predef FindPathToPlayer ; load Oak’s movement into wNPCMovementDirections2
	ld de, wNPCMovementDirections2
	ld a, 1 ; oak
	ld [H_SPRITEINDEX], a
	call MoveSprite

	; trigger the next script
	ld a, 3
	ld [W_PALLETTOWNCURSCRIPT], a
	ret

PalletTownScript3: ; 18f12 (6:4f12)
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, $FF ^ (A_BUTTON | B_BUTTON)
	ld [wJoyIgnore], a
	ld a, 1
	ld [wcf0d], a
	ld a, $2
	ld [wSpriteStateData1 + 1 * $10 + 1], a
	ld a, SPRITE_FACING_UP
	ld [wSpriteStateData1 + 1 * $10 + 9], a
	ld a, 1
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	; oak faces the horizontally adjacent patch of grass to face pikachu
	ld a, $FF
	ld [wJoyIgnore], a
	ld a, $2
	ld [wSpriteStateData1 + 1 * $10 + 1], a
	CheckEvent EVENT_005
	ld a, SPRITE_FACING_RIGHT
	jr z, .asm_18f01
	ld a, SPRITE_FACING_LEFT
.asm_18f01
	ld [wSpriteStateData1 + 1 * $10 + 9], a
	
	; trigger the next script
	ld a, 4
	ld [W_PALLETTOWNCURSCRIPT], a
	ret

PalletTownScript4: ; 18f4b (6:4f4b)
	; start the pikachu battle
	ld a, $FF ^ (A_BUTTON | B_BUTTON)
	ld [wJoyIgnore], a
	xor a
	ld [wListScrollOffset], a
	ld a, STARTER_PIKACHU_BATTLE
	ld [wBattleType], a
	ld a, PIKACHU
	ld [wCurOpponent], a
	ld a, 5
	ld [wCurEnemyLVL], a

	; trigger the next script
	ld a, 5
	ld [W_PALLETTOWNCURSCRIPT], a
	ret

PalletTownScript5: ; 18f56 (6:4f56)
	ld a, $2
	ld [wcf0d], a
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $2
	ld [wSpriteStateData1 + 1 * $10 + 1], a
	ld a, SPRITE_FACING_UP
	ld [wSpriteStateData1 + 1 * $10 + 9], a
	ld a, $8
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $ff
	ld [wJoyIgnore], a

	; trigger the next script
	ld a, 6
	ld [W_PALLETTOWNCURSCRIPT], a
	ret

PalletTownScript6: ; 18f87 (6:4f87)
	xor a
	ld [wSpriteStateData1 + 9], a
	ld a, $1
	ld [wSpriteIndex], a
	xor a
	ld [wNPCMovementScriptFunctionNum], a
	ld a, $1
	ld [wNPCMovementScriptPointerTableNum], a
	ld a, [H_LOADEDROMBANK]
	ld [wNPCMovementScriptBank], a

	; trigger the next script
	ld a, 7
	ld [W_PALLETTOWNCURSCRIPT], a
	ret
	
PalletTownScript7:
	ld a, [wNPCMovementScriptPointerTableNum]
	and a
	ret nz

	; trigger the next script
	ld a, 8
	ld [W_PALLETTOWNCURSCRIPT], a
	ret
	
PalletTownScript8:
	CheckEvent EVENT_DAISY_WALKING
	jr nz, .asm_18f9e
	and $3 ; (EVENT_GOT_TOWN_MAP | EVENT_ENTERED_BLUES_HOUSE)
	cp $3
	jr nz, .asm_18f9e
	SetEvent EVENT_DAISY_WALKING
	ld a, HS_DAISY_SITTING
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_DAISY_WALKING
	ld [wMissableObjectIndex], a
	predef_jump ShowObject

.asm_18f9e
	CheckEvent EVENT_GOT_POKEBALLS_FROM_OAK
	ret z
	SetEvent EVENT_PALLET_AFTER_GETTING_POKEBALLS_2
PalletTownScript9:
	ret

PalletTownTextPointers: ; 18f88 (6:4f88)
	dw PalletTownText1
	dw PalletTownText2
	dw PalletTownText3
	dw PalletTownText4
	dw PalletTownText5
	dw PalletTownText6
	dw PalletTownText7
	dw PalletTownText8

PalletTownText1: ; 18f96 (6:4f96)
	TX_ASM
	ld a, [wcf0d]
	and a
	jr nz, .next
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, OakAppearsText
	jr .done
.next
	dec a
	jr nz, .asm_18fd3
	ld hl, OakWalksUpText
	jr .done

.asm_18fd3
	ld hl, PalletTownText_19002
.done
	call PrintText
	jp TextScriptEnd

OakAppearsText: ; 18fb0 (6:4fb0)
	TX_FAR _OakAppearsText
	TX_ASM
	ld c, 10
	call DelayFrames
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld a, 0
	ld [wEmotionBubbleSpriteIndex], a ; player's sprite
	ld a, 0
	ld [wWhichEmotionBubble], a ; EXCLAMATION_BUBBLE
	predef EmotionBubble
	jp TextScriptEnd

OakWalksUpText: ; 18fce (6:4fce)
	TX_FAR _OakWalksUpText
	db "@"

PalletTownText_19002:
	TX_FAR _OakWhewText
	db "@"

PalletTownText8: ; 0x18fd3 girl
	TX_FAR _OakGrassText
	db "@"

PalletTownText2: ; 0x18fd8 fat man
	TX_FAR _PalletTownText2
	db "@"

PalletTownText3: ; 0x18fdd sign by lab
	TX_FAR _PalletTownText3
	db "@"

PalletTownText4: ; 0x18fe2 sign by fence
	TX_FAR _PalletTownText4
	db "@"

PalletTownText5: ; 0x18fe7 sign by Red’s house
	TX_FAR _PalletTownText5
	db "@"

PalletTownText6: ; 0x18fec sign by Blue’s house
	TX_FAR _PalletTownText6
	db "@"

PalletTownText7:
	TX_FAR _PalletTownText7
	db "@"
