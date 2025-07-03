PalletTown_Script:
	CheckEvent EVENT_GOT_POKEBALLS_FROM_OAK
	jr z, .next
	SetEvent EVENT_PALLET_AFTER_GETTING_POKEBALLS
.next
	call EnableAutoTextBoxDrawing
	ld hl, PalletTown_ScriptPointers
	ld a, [wPalletTownCurScript]
	jp CallFunctionInTable

PalletTown_ScriptPointers:
	def_script_pointers
	dw_const PalletTownDefaultScript,              SCRIPT_PALLETTOWN_DEFAULT
	dw_const PalletTownOakHeyWaitScript,           SCRIPT_PALLETTOWN_OAK_HEY_WAIT
	dw_const PalletTownOakWalksToPlayerScript,     SCRIPT_PALLETTOWN_OAK_WALKS_TO_PLAYER
	dw_const PalletTownOakGreetsPlayerScript,      SCRIPT_PALLETTOWN_OAK_GREETS_PLAYER
	dw_const PalletTownPikachuBattleScript,        SCRIPT_PALLETTOWN_PIKACHU_BATTLE
	dw_const PalletTownAfterPikachuBattleScript,   SCRIPT_PALLETTOWN_AFTER_PIKACHU_BATTLE
	dw_const PalletTownOakNotSafeComeWithMeScript, SCRIPT_PALLETTOWN_OAK_NOT_SAFE_COME_WITH_ME
	dw_const PalletTownPlayerFollowsOakScript,     SCRIPT_PALLETTOWN_PLAYER_FOLLOWS_OAK
	dw_const PalletTownDaisyScript,                SCRIPT_PALLETTOWN_DAISY
	dw_const PalletTownNoopScript,                 SCRIPT_PALLETTOWN_NOOP

PalletTownDefaultScript:
	CheckEvent EVENT_FOLLOWED_OAK_INTO_LAB
	ret nz
	ld a, [wYCoord]
	cp 0 ; is player at north exit?
	ret nz
	ResetEvent EVENT_PLAYER_AT_RIGHT_EXIT_TO_PALLET_TOWN
	ld a, [wXCoord]
	cp 10
	jr z, .asm_18e40
	SetEventReuseHL EVENT_PLAYER_AT_RIGHT_EXIT_TO_PALLET_TOWN
.asm_18e40
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	call StopAllMusic
	ld a, BANK(Music_MeetProfOak)
	ld c, a
	ld a, MUSIC_MEET_PROF_OAK ; "oak appears" music
	call PlayMusic
	SetEvent EVENT_OAK_APPEARED_IN_PALLET

	; trigger the next script
	ld a, SCRIPT_PALLETTOWN_OAK_HEY_WAIT
	ld [wPalletTownCurScript], a
	ret

PalletTownOakHeyWaitScript:
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	xor a
	ld [wOakWalkedToPlayer], a
	ld a, TEXT_PALLETTOWN_OAK
	ldh [hTextID], a
	call DisplayTextID
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld hl, wSprite01StateData2MapY
	ld a, 8
	ld [hli], a ; SPRITESTATEDATA2_MAPY
	ld a, 14
	ld [hl], a ; SPRITESTATEDATA2_MAPX
	ld a, HS_PALLET_TOWN_OAK
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, $2
	ld [wSprite01StateData1MovementStatus], a
	ld a, SPRITE_FACING_UP
	ld [wSprite01StateData1FacingDirection], a

	; trigger the next script
	ld a, SCRIPT_PALLETTOWN_OAK_WALKS_TO_PLAYER
	ld [wPalletTownCurScript], a
	ret

PalletTownOakWalksToPlayerScript:
	call Delay3
	ld a, 0
	ld [wYCoord], a
	ld a, 1
	ldh [hNPCPlayerRelativePosPerspective], a
	ld a, 1
	swap a
	ldh [hNPCSpriteOffset], a
	predef CalcPositionOfPlayerRelativeToNPC
	ld hl, hNPCPlayerYDistance
	dec [hl]
	predef FindPathToPlayer ; load Oak's movement into wNPCMovementDirections2
	ld de, wNPCMovementDirections2
	ld a, PALLETTOWN_OAK
	ldh [hSpriteIndex], a
	call MoveSprite

	; trigger the next script
	ld a, SCRIPT_PALLETTOWN_OAK_GREETS_PLAYER
	ld [wPalletTownCurScript], a
	ret

PalletTownOakGreetsPlayerScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, 1
	ld [wOakWalkedToPlayer], a
	ld a, $2
	ld [wSprite01StateData1MovementStatus], a
	ld a, SPRITE_FACING_UP
	ld [wSprite01StateData1FacingDirection], a
	ld a, TEXT_PALLETTOWN_OAK
	ldh [hTextID], a
	call DisplayTextID
	; oak faces the horizontally adjacent patch of grass to face pikachu
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, $2
	ld [wSprite01StateData1MovementStatus], a
	CheckEvent EVENT_PLAYER_AT_RIGHT_EXIT_TO_PALLET_TOWN
	ld a, SPRITE_FACING_RIGHT
	jr z, .asm_18f01
	ld a, SPRITE_FACING_LEFT
.asm_18f01
	ld [wSprite01StateData1FacingDirection], a

	; trigger the next script
	ld a, SCRIPT_PALLETTOWN_PIKACHU_BATTLE
	ld [wPalletTownCurScript], a
	ret

PalletTownPikachuBattleScript:
	; start the pikachu battle
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	xor a
	ld [wListScrollOffset], a
	ld a, BATTLE_TYPE_PIKACHU
	ld [wBattleType], a
	ld a, STARTER_PIKACHU
	ld [wCurOpponent], a
	ld a, 5
	ld [wCurEnemyLevel], a

	; trigger the next script
	ld a, SCRIPT_PALLETTOWN_AFTER_PIKACHU_BATTLE
	ld [wPalletTownCurScript], a
	ret

PalletTownAfterPikachuBattleScript:
	ld a, 2
	ld [wOakWalkedToPlayer], a
	ld a, TEXT_PALLETTOWN_OAK
	ldh [hTextID], a
	call DisplayTextID
	ld a, $2
	ld [wSprite01StateData1MovementStatus], a
	ld a, SPRITE_FACING_UP
	ld [wSprite01StateData1FacingDirection], a
	ld a, TEXT_PALLETTOWN_OAK_COME_WITH_ME
	ldh [hTextID], a
	call DisplayTextID
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a

	; trigger the next script
	ld a, SCRIPT_PALLETTOWN_OAK_NOT_SAFE_COME_WITH_ME
	ld [wPalletTownCurScript], a
	ret

PalletTownOakNotSafeComeWithMeScript:
	xor a
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, PALLETTOWN_OAK
	ld [wSpriteIndex], a
	xor a
	ld [wNPCMovementScriptFunctionNum], a
	ld a, 1
	ld [wNPCMovementScriptPointerTableNum], a
	ldh a, [hLoadedROMBank]
	ld [wNPCMovementScriptBank], a

	; trigger the next script
	ld a, SCRIPT_PALLETTOWN_PLAYER_FOLLOWS_OAK
	ld [wPalletTownCurScript], a
	ret

PalletTownPlayerFollowsOakScript:
	ld a, [wNPCMovementScriptPointerTableNum]
	and a ; is the movement script over?
	ret nz

	; trigger the next script
	ld a, SCRIPT_PALLETTOWN_DAISY
	ld [wPalletTownCurScript], a
	ret

PalletTownDaisyScript:
	CheckEvent EVENT_DAISY_WALKING
	jr nz, .next
	CheckBothEventsSet EVENT_GOT_TOWN_MAP, EVENT_ENTERED_BLUES_HOUSE, 1
	jr nz, .next
	SetEvent EVENT_DAISY_WALKING
	ld a, HS_DAISY_SITTING
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_DAISY_WALKING
	ld [wMissableObjectIndex], a
	predef_jump ShowObject
.next
	CheckEvent EVENT_GOT_POKEBALLS_FROM_OAK
	ret z
	SetEvent EVENT_PALLET_AFTER_GETTING_POKEBALLS_2
PalletTownNoopScript:
	ret

PalletTown_TextPointers:
	def_text_pointers
	dw_const PalletTownOakText,              TEXT_PALLETTOWN_OAK
	dw_const PalletTownGirlText,             TEXT_PALLETTOWN_GIRL
	dw_const PalletTownFisherText,           TEXT_PALLETTOWN_FISHER
	dw_const PalletTownOaksLabSignText,      TEXT_PALLETTOWN_OAKSLAB_SIGN
	dw_const PalletTownSignText,             TEXT_PALLETTOWN_SIGN
	dw_const PalletTownPlayersHouseSignText, TEXT_PALLETTOWN_PLAYERSHOUSE_SIGN
	dw_const PalletTownRivalsHouseSignText,  TEXT_PALLETTOWN_RIVALSHOUSE_SIGN
	dw_const PalletTownOakComeWithMe,        TEXT_PALLETTOWN_OAK_COME_WITH_ME

PalletTownOakText:
	text_asm
	ld a, [wOakWalkedToPlayer]
	and a
	jr nz, .next
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, .HeyWaitDontGoOutText
	jr .done
.next
	dec a
	jr nz, .whew
	ld hl, .ThatWasCloseText
	jr .done
.whew
	ld hl, .WhewText
.done
	call PrintText
	jp TextScriptEnd

.HeyWaitDontGoOutText:
	text_far _PalletTownOakHeyWaitDontGoOutText
	text_asm
	ld c, 10
	call DelayFrames
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld a, 0
	ld [wEmotionBubbleSpriteIndex], a ; player's sprite
	ld a, EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	jp TextScriptEnd

.ThatWasCloseText:
	text_far _PalletTownOakThatWasCloseText
	text_end

.WhewText:
	text_far _PalletTownOakWhewText
	text_end

PalletTownOakComeWithMe:
	text_far _PalletTownOakComeWithMe
	text_end

PalletTownGirlText:
	text_far _PalletTownGirlText
	text_end

PalletTownFisherText:
	text_far _PalletTownFisherText
	text_end

PalletTownOaksLabSignText:
	text_far _PalletTownOaksLabSignText
	text_end

PalletTownSignText:
IF DEF(_DEBUG)
	text_asm
	ld a, 239
	inc a
	ld [wWhichPewterGuy], a
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_decimal wWhichPewterGuy, 1, 3
	text "bit"
	done
ELSE
	text_far _PalletTownSignText
	text_end
ENDC

PalletTownPlayersHouseSignText:
	text_far _PalletTownPlayersHouseSignText
	text_end

PalletTownRivalsHouseSignText:
	text_far _PalletTownRivalsHouseSignText
	text_end
