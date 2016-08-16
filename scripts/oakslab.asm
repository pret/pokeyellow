OaksLabScript:
	CheckEvent EVENT_PALLET_AFTER_GETTING_POKEBALLS_2
	call nz, OaksLabScript_1d076
	ld a, $1
	ld [wAutoTextBoxDrawingControl], a
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, OaksLabScriptPointers
	ld a, [wOaksLabCurScript]
	call JumpTable
	ret

OaksLabScriptPointers:
	dw OaksLabScript0
	dw OaksLabScript1
	dw OaksLabScript2
	dw OaksLabScript3
	dw OaksLabScript4
	dw OaksLabScript5
	dw OaksLabScript6
	dw OaksLabScript7
	dw OaksLabScript8
	dw OaksLabScript9
	dw OaksLabScript10
	dw OaksLabScript11
	dw OaksLabScript12
	dw OaksLabScript13
	dw OaksLabScript14
	dw OaksLabScript15
	dw OaksLabScript16
	dw OaksLabScript17
	dw OaksLabScript18
	dw OaksLabScript19
	dw OaksLabScript20
	dw OaksLabScript21
	dw OaksLabScript22

OaksLabScript0:
	CheckEvent EVENT_OAK_APPEARED_IN_PALLET
	ret z
	ld a, [wNPCMovementScriptFunctionNum]
	and a
	ret nz
	ld a, HS_OAKS_LAB_OAK_2
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld hl, wd72e
	res 4, [hl]

	ld a, $1
	ld [wOaksLabCurScript], a
	ret

OaksLabScript1:
	ld a, $6
	ld [H_SPRITEINDEX], a
	ld de, OakEntryMovement
	call MoveSprite

	ld a, $2
	ld [wOaksLabCurScript], a
	ret

OakEntryMovement:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db $FF

OaksLabScript2:
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, HS_OAKS_LAB_OAK_2
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_OAKS_LAB_OAK_1
	ld [wMissableObjectIndex], a
	predef ShowObject

	ld a, $3
	ld [wOaksLabCurScript], a
	ret

OaksLabScript3:
	call Delay3
	ld hl, wSimulatedJoypadStatesEnd
	ld de, PlayerEntryMovementRLE
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $1
	ld [H_SPRITEINDEX], a
	xor a
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $3
	ld [H_SPRITEINDEX], a
	xor a
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay

	ld a, $4
	ld [wOaksLabCurScript], a
	ret

PlayerEntryMovementRLE:
	db D_UP,$8
	db $ff

OaksLabScript4:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	SetEvent EVENT_FOLLOWED_OAK_INTO_LAB
	SetEvent EVENT_FOLLOWED_OAK_INTO_LAB_2
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, SPRITE_FACING_UP
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld hl, wFlags_D733
	res 1, [hl]
	call PlayDefaultMusic

	ld a, $5
	ld [wOaksLabCurScript], a
	ret

OaksLabScript5:
	SetEvent EVENT_OAK_ASKED_TO_CHOOSE_MON
	ld a, $fc
	ld [wJoyIgnore], a
	ld a, $d
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	call Delay3
	ld a, $e
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	call Delay3
	ld a, $2
	ld [wSpriteStateData1 + 1 * $10 + 1], a
	ld a, SPRITE_FACING_UP
	ld [wSpriteStateData1 + 1 * $10 + 9], a
	ld a, $f
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	call Delay3
	ld a, $10
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wJoyIgnore], a

	ld a, $6
	ld [wOaksLabCurScript], a
	ret

OaksLabScript6:
	ld a, [wYCoord]
	cp $6
	ret nz
	ld a, $3
	ld [H_SPRITEINDEX], a
	xor a ; SPRITE_FACING_DOWN
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $1
	ld [H_SPRITEINDEX], a
	xor a
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	call UpdateSprites
	ld a, $a
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	call StartSimulatingJoypadStates
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a

	ld a, $7
	ld [wOaksLabCurScript], a
	ret

OaksLabScript7:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3

	ld a, $6
	ld [wOaksLabCurScript], a
	ret

OaksLabScript8:
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	ld de, .SonyPushesPlayerAwayFromEeveeBall
	call MoveSprite
	ld a, $9
	ld [wOaksLabCurScript], a
	ret

.SonyPushesPlayerAwayFromEeveeBall
	db $00
	db $07
	db $07
	db $07
	db $FF

OaksLabScript9:
	ld a, [wd730]
	bit 0, a
	jr nz, .asm_1c564
	ld a, HS_STARTER_BALL_1
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, SPRITE_FACING_UP
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, 1
	ld [wRivalStarter], a
	ld a, EEVEE
	ld [wd11e], a
	call GetMonName
	ld a, $FF ^ (A_BUTTON | B_BUTTON)
	ld [wJoyIgnore], a
	ld a, $11
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID

	ld a, $a
	ld [wOaksLabCurScript], a
	ret

.asm_1c564
	ld a, [wYCoord]
	cp $4
	ret nz
	ld a, [wNPCNumScriptedSteps]
	cp 1
	ret nz
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a
	ld a, $2
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_RIGHT
	ld [wSimulatedJoypadStatesEnd], a
	ld [wSimulatedJoypadStatesEnd + 1], a
	call StartSimulatingJoypadStates
	ret

OaksLabScript10:
	ld a, [wYCoord]
	cp $4
	jr z, .asm_1c599
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_LEFT
	ld [wSimulatedJoypadStatesEnd], a
	jr .asm_1c5a6

.asm_1c599
	ld hl, wSimulatedJoypadStatesEnd
	ld de, OaksLabRLE_PlayerWalksToOak
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
.asm_1c5a6
	call StartSimulatingJoypadStates
	ld a, $b
	ld [wOaksLabCurScript], a
	ret

OaksLabRLE_PlayerWalksToOak:
	db D_UP, 2
	db D_LEFT, 3
	db D_DOWN, 1
	db D_LEFT, 1
	db $FF

OaksLabScript11:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld a, $12
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wJoyIgnore], a

	ld a, $c
	ld [wOaksLabCurScript], a
	ret

OaksLabScript12:
	ld a, [wYCoord]
	cp $6
	ret nz
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	xor a
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld c, BANK(Music_MeetRival)
	ld a, MUSIC_MEET_RIVAL
	call PlayMusic
	ld a, $b
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $1
	ld [hNPCPlayerRelativePosPerspective], a
	ld a, $1
	swap a
	ld [hNPCPlayerYDistance], a
	predef CalcPositionOfPlayerRelativeToNPC
	ld a, [hNPCPlayerYDistance]
	dec a
	ld [hNPCPlayerYDistance], a
	predef FindPathToPlayer
	ld de, wNPCMovementDirections2
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	call MoveSprite
	ld a, $d
	ld [wOaksLabCurScript], a
	ret

OaksLabScript13:
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, $1
	ld [wSpriteIndex], a
	call GetSpritePosition1
	ld a, OPP_SONY1
	ld [wCurOpponent], a
	ld a, $1
	ld [wTrainerNo], a
	ld hl, OaksLabRivalDefeatedText
	ld de, OaksLabRivalBeatYouText
	call SaveEndBattleTextPointers
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	xor a
	ld [wJoyIgnore], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, $e
	ld [wOaksLabCurScript], a
	ret

OaksLabScript14:
	ld a, $ff
	ld [wJoyIgnore], a

	; If you beat your rival here, his Eevee will evolve into
	; Jolteon if you beat him on Route 22, or Flareon if you
	; skip or lose that battle.
	; Otherwise, it will evolve into Vaporeon.
	ld a, [wBattleResult]
	and a
	ld b, $3
	jr nz, .asm_1c660
	ld b, $2
.asm_1c660
	ld a, b
	ld [wRivalStarter], a

	ld a, $ff ^ (A_BUTTON | B_BUTTON)
	ld [wJoyIgnore], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	call UpdateSprites
	ld a, $1
	ld [wSpriteIndex], a
	call SetSpritePosition1
	ld a, $2
	ld [wSpriteStateData1 + 1 * $10 + 1], a
	xor a
	ld [wSpriteStateData1 + 1 * $10 + 9], a
	predef HealParty
	SetEvent EVENT_BATTLED_RIVAL_IN_OAKS_LAB
	ld a, $f
	ld [wOaksLabCurScript], a
	ret

OaksLabScript15:
	ld c, 20
	call DelayFrames
	ld a, $c
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	callba Music_RivalAlternateStart
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	ld de, .OaksLabMovement_RivalWalksOut1
	call MoveSprite
	ld a, [wXCoord]
	cp $4
	jr nz, .asm_1c6bb
	ld a, NPC_MOVEMENT_RIGHT
	jr .asm_1c6bd

.asm_1c6bb
	ld a, NPC_MOVEMENT_LEFT
.asm_1c6bd
	ld [wNPCMovementDirections], a
	ld a, $10
	ld [wOaksLabCurScript], a
	ret

.OaksLabMovement_RivalWalksOut1
	db $e0
	db $00
	db $04
	db $04
	db $04
	db $04
	db $04
	db $ff

OaksLabScript16:
	ld a, [wd730]
	bit 0, a
	jr nz, .asm_1c6ed
	ld a, $ff ^ (A_BUTTON | B_BUTTON)
	ld [wJoyIgnore], a
	ld a, HS_OAKS_LAB_RIVAL
	ld [wMissableObjectIndex], a
	predef HideObject
	call PlayDefaultMusic
	ld a, $11
	ld [wOaksLabCurScript], a
	ret

.asm_1c6ed
	ld a, [wNPCNumScriptedSteps]
	cp 5
	jr nz, .asm_1c703
	ld a, [wXCoord]
	cp 4
	jr nz, .asm_1c6ff
	ld a, SPRITE_FACING_RIGHT
	jr .asm_1c707

.asm_1c6ff
	ld a, SPRITE_FACING_LEFT
	jr .asm_1c707

.asm_1c703
	cp 4
	ret nz
	xor a
.asm_1c707
	ld [wPlayerFacingDirection], a
	ret

OaksLabScript17:
; Pikachu comes out
	ld a, SPRITE_FACING_UP
	ld [wPlayerFacingDirection], a
	ld a, $2
	ld [wPikachuSpawnState], a
	callba SchedulePikachuSpawnForAfterText
	call EnablePikachuOverworldSpriteDrawing
	ld a, $1a
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $12
	ld [wOaksLabCurScript], a
	ret

OaksLabScript18:
	ld a, $1b
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wJoyIgnore], a
	ld a, $16
	ld [wOaksLabCurScript], a
	ret

OaksLabScript19:
	xor a
	ld [hJoyHeld], a
	call EnableAutoTextBoxDrawing
	call StopAllMusic
	callba Music_RivalAlternateStart
	ld a, $13
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	callab Func_f1be0
	call OaksLabScript_1c8b9
	ld a, HS_OAKS_LAB_RIVAL
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, [wNPCMovementDirections2Index]
	ld [wSavedNPCMovementDirections2Index], a
	ld b, 0
	ld c, a
	ld hl, wNPCMovementDirections2
	ld a, NPC_MOVEMENT_UP
	call FillMemory
	ld [hl], $ff
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	ld de, wNPCMovementDirections2
	call MoveSprite
	ld a, $14
	ld [wOaksLabCurScript], a
	ret

OaksLabScript_1c78e:
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	ld a, SPRITE_FACING_UP
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $6
	ld [hSpriteIndexOrTextID], a
	xor a
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ret

OaksLabScript20:
	ld a, [wd730]
	bit 0, a
	ret nz
	call EnableAutoTextBoxDrawing
	call PlayDefaultMusic
	ld a, $ff ^ (A_BUTTON | B_BUTTON)
	ld [wJoyIgnore], a
	call OaksLabScript_1c78e
	ld a, $14
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	call DelayFrame
	call OaksLabScript_1c78e
	ld a, $15
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	call DelayFrame
	call OaksLabScript_1c78e
	ld a, $16
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	call DelayFrame
	ld a, $17
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	call Delay3
	ld a, HS_POKEDEX_1
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_POKEDEX_2
	ld [wMissableObjectIndex], a
	predef HideObject
	call OaksLabScript_1c78e
	ld a, $18
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	ld a, SPRITE_FACING_RIGHT
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	call Delay3
	ld a, $19
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_POKEDEX
	ld a, $1
	ld [wViridianCityCurScript], a
	SetEvent EVENT_OAK_GOT_PARCEL
	ld a, HS_LYING_OLD_MAN
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_OLD_MAN
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, [wSavedNPCMovementDirections2Index]
	ld b, 0
	ld c, a
	ld hl, wNPCMovementDirections2
	xor a
	call FillMemory
	ld [hl], $ff
	call StopAllMusic
	callba Music_RivalAlternateStart
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	ld de, wNPCMovementDirections2
	call MoveSprite
	ld a, $15
	ld [wOaksLabCurScript], a
	ret

OaksLabScript21:
	ld a, [wd730]
	bit 0, a
	ret nz
	call PlayDefaultMusic
	ld a, HS_OAKS_LAB_RIVAL
	ld [wMissableObjectIndex], a
	predef HideObject
	SetEvent EVENT_1ST_ROUTE22_RIVAL_BATTLE
	ResetEventReuseHL EVENT_2ND_ROUTE22_RIVAL_BATTLE
	SetEventReuseHL EVENT_ROUTE22_RIVAL_WANTS_BATTLE
	ld a, HS_ROUTE_22_RIVAL_1
	ld [wMissableObjectIndex], a
	predef ShowObject
	xor a
	ld [wJoyIgnore], a
	ld a, $16
	ld [wOaksLabCurScript], a
	ret

OaksLabScript22:
	ret

OaksLabScript_1c897:
	ld hl, wBagItems
	ld bc, 0
.asm_1c89d
	ld a, [hli]
	cp $ff
	ret z
	cp OAKS_PARCEL
	jr z, .asm_1c8a9
	inc hl
	inc c
	jr .asm_1c89d

.asm_1c8a9
	ld hl, wNumBagItems
	ld a, c
	ld [wWhichPokemon], a
	ld a, 1
	ld [wItemQuantity], a
	call RemoveItemFromInventory
	ret

OaksLabScript_1c8b9:
	ld a, $7c
	ld [$ffeb], a
	ld a, $8
	ld [$ffee], a
	ld a, [wYCoord]
	cp 3
	jr nz, .asm_1c8d3
	ld a, $4
	ld [wNPCMovementDirections2Index], a
	ld a, $30
	ld b, $b
	jr .asm_1c8f6

.asm_1c8d3
	cp $1
	jr nz, .asm_1c8e2
	ld a, $2
	ld [wNPCMovementDirections2Index], a
	ld a, $30
	ld b, $9
	jr .asm_1c8f6

.asm_1c8e2
	ld a, $3
	ld [wNPCMovementDirections2Index], a
	ld b, $a
	ld a, [wXCoord]
	cp $4
	jr nz, .asm_1c8f4
	ld a, $40
	jr .asm_1c8f6

.asm_1c8f4
	ld a, $20
.asm_1c8f6
	ld [$ffec], a
	ld a, b
	ld [$ffed], a
	ld a, $1
	ld [wSpriteIndex], a
	call SetSpritePosition1
	ret

OaksLabScript_1d076:
	ld hl, OaksLabTextPointers2
	ld a, l
	ld [wMapTextPtr], a
	ld a, h
	ld [wMapTextPtr + 1], a
	ret

OaksLabTextPointers:
	dw OaksLabText1
	dw OaksLabText2
	dw OaksLabText3
	dw OaksLabText4
	dw OaksLabText5
	dw OaksLabText6
	dw OaksLabText7
	dw OaksLabText8
	dw OaksLabText9
	dw OaksLabText10
	dw OaksLabText11
	dw OaksLabText12
	dw OaksLabText13
	dw OaksLabText14
	dw OaksLabText15
	dw OaksLabText16
	dw OaksLabText17
	dw OaksLabText18
	dw OaksLabText19
	dw OaksLabText20
	dw OaksLabText21
	dw OaksLabText22
	dw OaksLabText23
	dw OaksLabText24
	dw OaksLabText25
	dw OaksLabText26
	dw OaksLabText27

OaksLabTextPointers2:
	dw OaksLabText1
	dw OaksLabText2
	dw OaksLabText3
	dw OaksLabText4
	dw OaksLabText5
	dw OaksLabText6
	dw OaksLabText7
	dw OaksLabText8
	dw OaksLabText9

OaksLabText1:
	TX_ASM
	CheckEvent EVENT_FOLLOWED_OAK_INTO_LAB_2
	jr nz, .asm_1c968
	ld hl, OaksLabText_1c97d
	call PrintText
	jr .asm_1c97a

.asm_1c968
	CheckEventReuseA EVENT_GOT_STARTER
	jr nz, .asm_1c974
	ld hl, OaksLabText_1c982
	call PrintText
	jr .asm_1c97a

.asm_1c974
	ld hl, OaksLabText_1c987
	call PrintText
.asm_1c97a
	jp TextScriptEnd

OaksLabText_1c97d:
	TX_FAR _OaksLabGaryText1
	db "@"

OaksLabText_1c982:
	TX_FAR _OaksLabText40
	db "@"

OaksLabText_1c987:
	TX_FAR _OaksLabText41
	db "@"

OaksLabText2:
	TX_ASM
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	CheckEvent EVENT_OAK_ASKED_TO_CHOOSE_MON
	jr nz, OaksLabScript_1c9ac
	ld a, $0
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, OaksLabText_1c9a7
	call PrintText
	jp TextScriptEnd

OaksLabText_1c9a7:
	TX_FAR _OaksLabText39
	db "@"

OaksLabScript_1c9ac:
	ld a, $1
	ld [wEmotionBubbleSpriteIndex], a
	xor a ; EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	ld a, $8
	ld [wOaksLabCurScript], a
	jp TextScriptEnd

OaksLabText3:
	TX_ASM
	CheckEvent EVENT_PALLET_AFTER_GETTING_POKEBALLS
	jr nz, .asm_1c9d9
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	cp 2
	jr c, .asm_1c9ec
.asm_1c9d9
	ld hl, OaksLabText_1ca9f
	call PrintText
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	predef DisplayDexRating
	jp .asm_1ca6f

.asm_1c9ec
	ld b, POKE_BALL
	call IsItemInBag
	jr nz, .asm_1ca69
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	cp 2
	jr nc, .asm_1ca69
	CheckEvent EVENT_BEAT_ROUTE22_RIVAL_1ST_BATTLE
	jr nz, .asm_1ca52
	CheckEvent EVENT_GOT_POKEDEX
	jr nz, .asm_1ca4a
	CheckEventReuseA EVENT_BATTLED_RIVAL_IN_OAKS_LAB
	jr nz, .asm_1ca2b
	ld a, [wd72e]
	bit 3, a
	jr nz, .asm_1ca23
	ld hl, OaksLabText_1ca72
	call PrintText
	jr .asm_1ca6f

.asm_1ca23
	ld hl, OaksLabText_1ca77
	call PrintText
	jr .asm_1ca6f

.asm_1ca2b
	ld b, OAKS_PARCEL
	call IsItemInBag
	jr nz, .asm_1ca3a
	ld hl, OaksLabText_1ca7c
	call PrintText
	jr .asm_1ca6f

.asm_1ca3a
	ld hl, OaksLabText_1ca81
	call PrintText
	call OaksLabScript_1c897
	ld a, $13
	ld [wOaksLabCurScript], a
	jr .asm_1ca6f

.asm_1ca4a
	ld hl, OaksLabText_1ca8b
	call PrintText
	jr .asm_1ca6f

.asm_1ca52
	CheckAndSetEvent EVENT_GOT_POKEBALLS_FROM_OAK
	jr nz, .asm_1ca69
	lb bc, POKE_BALL, 5
	call GiveItem
	ld hl, OaksLabText_1ca90
	call PrintText
	jr .asm_1ca6f

.asm_1ca69
	ld hl, OaksLabText_1ca9a
	call PrintText
.asm_1ca6f
	jp TextScriptEnd

OaksLabText_1ca72:
	TX_FAR _OaksLabPikachuText
	db "@"

OaksLabText_1ca77:
	TX_FAR _OaksLabText_1d2f5
	db "@"

OaksLabText_1ca7c:
	TX_FAR _OaksLabText_1d2fa
	db "@"

OaksLabText_1ca81:
	TX_FAR _OaksLabDeliverParcelText1
	TX_SFX_KEY_ITEM
	TX_FAR _OaksLabDeliverParcelText2
	db "@"

OaksLabText_1ca8b:
	TX_FAR _OaksLabAroundWorldText
	db "@"

OaksLabText_1ca90:
	TX_FAR _OaksLabGivePokeballsText1
	TX_SFX_KEY_ITEM
	TX_FAR _OaksLabGivePokeballsText2
	db "@"

OaksLabText_1ca9a:
	TX_FAR _OaksLabPleaseVisitText
	db "@"

OaksLabText_1ca9f:
	TX_FAR _OaksLabText_1d31d
	db "@"

OaksLabText4:
OaksLabText5:
	TX_ASM
	ld hl, OaksLabText_1caae
	call PrintText
	jp TextScriptEnd

OaksLabText_1caae:
	TX_FAR _OaksLabText_1d32c
	db "@"

OaksLabText6:
	TX_FAR _OaksLabText8
	db "@"

OaksLabText7:
	TX_ASM
	ld hl, OaksLabText_1cac2
	call PrintText
	jp TextScriptEnd

OaksLabText_1cac2:
	TX_FAR _OaksLabText_1d340
	db "@"

OaksLabText13:
	TX_ASM
	ld hl, OaksLabText_1cad1
	call PrintText
	jp TextScriptEnd

OaksLabText_1cad1:
	TX_FAR _OaksLabRivalWaitingText
	db "@"

OaksLabText14:
	TX_ASM
	ld hl, OaksLabText_1cae0
	call PrintText
	jp TextScriptEnd

OaksLabText_1cae0:
	TX_FAR _OaksLabChooseMonText
	db "@"

OaksLabText15:
	TX_ASM
	ld hl, OaksLabText_1caef
	call PrintText
	jp TextScriptEnd

OaksLabText_1caef:
	TX_FAR _OaksLabRivalInterjectionText
	db "@"

OaksLabText16:
	TX_ASM
	ld hl, OaksLabText_1cafe
	call PrintText
	jp TextScriptEnd

OaksLabText_1cafe:
	TX_FAR _OaksLabBePatientText
	db "@"

OaksLabText17:
	TX_ASM
	ld hl, OaksLabText_1cb25
	call PrintText
	ld hl, OaksLabText_1cb2a
	call PrintText
	ld hl, OaksLabText_1cb30
	call PrintText
	ld hl, OaksLabText_1cb35
	call PrintText
	ld hl, OaksLabText_1cb3a
	call PrintText
	jp TextScriptEnd

OaksLabText_1cb25:
	TX_FAR _OaksLabRivalTakesText1
	db "@"

OaksLabText_1cb2a:
	TX_FAR _OaksLabRivalTakesText2
	TX_SFX_KEY_ITEM
	db "@"

OaksLabText_1cb30:
	TX_FAR _OaksLabRivalTakesText3
	db "@"

OaksLabText_1cb35:
	TX_FAR _OaksLabRivalTakesText4
	db "@"

OaksLabText_1cb3a:
	TX_FAR _OaksLabRivalTakesText5
	db "@"

OaksLabText18:
	TX_ASM
	ld a, PIKACHU
	ld [wPlayerStarter], a
	ld [wd11e], a
	call GetMonName
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, OaksLabText_1cb85
	call PrintText
	ld hl, OaksLabText_1cb8a
	call PrintText
	xor a
	ld [wMonDataLocation], a
	ld a, 5
	ld [wCurEnemyLVL], a
	ld a, PIKACHU
	ld [wd11e], a
	ld [wcf91], a
	call AddPartyMon
	ld a, 163
	ld [wPartyMon1CatchRate], a
	call DisablePikachuOverworldSpriteDrawing
	SetEvent EVENT_GOT_STARTER
	ld hl, wd72e
	set 3, [hl]
	jp TextScriptEnd

OaksLabText_1cb85:
	TX_FAR _OaksLabOakGivesText
	db "@"

OaksLabText_1cb8a:
	TX_FAR _OaksLabReceivedText
	TX_SFX_KEY_ITEM
	db "@"

OaksLabText10:
	TX_ASM
	ld hl, OaksLabText_1cb9a
	call PrintText
	jp TextScriptEnd

OaksLabText_1cb9a:
	TX_FAR _OaksLabLeavingText
	db "@"

OaksLabText11:
	TX_ASM
	ld hl, OaksLabText_1cba9
	call PrintText
	jp TextScriptEnd

OaksLabText_1cba9:
	TX_FAR _OaksLabRivalChallengeText
	db "@"

OaksLabRivalDefeatedText:
	TX_FAR _OaksLabText_1d3be
	db "@"

OaksLabRivalBeatYouText:
	TX_FAR _OaksLabText_1d3c3
	db "@"

OaksLabText12:
	TX_ASM
	ld hl, OaksLabText_1cbc2
	call PrintText
	jp TextScriptEnd

OaksLabText_1cbc2:
	TX_FAR _OaksLabRivalToughenUpText
	db "@"

OaksLabText26:
	TX_ASM
	ldpikacry e, PikachuCry2
	callab PlayPikachuSoundClip
	ld hl, OaksLabText_1cbdb
	call PrintText
	jp TextScriptEnd

OaksLabText_1cbdb:
	TX_FAR _OaksLabPikachuDislikesPokeballsText1
	db "@"

OaksLabText27:
	TX_ASM
	ld hl, OaksLabText_1cbea
	call PrintText
	jp TextScriptEnd

OaksLabText_1cbea:
	TX_FAR _OaksLabPikachuDislikesPokeballsText2
	db "@"

OaksLabText19:
	TX_FAR _OaksLabText21
	db "@"

OaksLabText20:
	TX_FAR _OaksLabText22
	db "@"

OaksLabText21:
	TX_FAR _OaksLabText23
	db "@"

OaksLabText22:
	TX_FAR _OaksLabText24
	db "@"

OaksLabText23:
	TX_FAR _OaksLabText25
	TX_SFX_KEY_ITEM
	db "@"

OaksLabText24:
	TX_FAR _OaksLabText26
	db "@"

OaksLabText25:
	TX_FAR _OaksLabText27
	db "@"

OaksLabText8:
OaksLabText9:
	TX_ASM
	ld hl, OaksLabText_1c31d
	call PrintText
	jp TextScriptEnd

OaksLabText_1c31d:
	TX_FAR _OaksLabText_1d405
	db "@"
