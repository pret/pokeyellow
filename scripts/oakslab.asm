OaksLabScript: ; 1cb0e (7:4b0e)
	CheckEvent EVENT_PALLET_AFTER_GETTING_POKEBALLS_2
	call nz, OaksLabScript_1d076
	ld a, $1
	ld [wAutoTextBoxDrawingControl], a
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, OaksLabScriptPointers
	ld a, [W_OAKSLABCURSCRIPT]
	call JumpTable
	ret

OaksLabScriptPointers: ; 1cb28 (7:4b28)
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

OaksLabScript0: ; 1cb4e (7:4b4e)
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
	ld [W_OAKSLABCURSCRIPT], a
	ret

OaksLabScript1: ; 1cb6e (7:4b6e)
	ld a, $6
	ld [H_SPRITEINDEX], a
	ld de, OakEntryMovement
	call MoveSprite

	ld a, $2
	ld [W_OAKSLABCURSCRIPT], a
	ret

OakEntryMovement: ; 1cb7e (7:4b7e)
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db $FF

OaksLabScript2: ; 1cb82 (7:4b82)
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
	ld [W_OAKSLABCURSCRIPT], a
	ret

OaksLabScript3: ; 1cba2 (7:4ba2)
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
	ld [W_OAKSLABCURSCRIPT], a
	ret

PlayerEntryMovementRLE: ; 1cbcf (7:4bcf)
	db D_UP,$8
	db $ff

OaksLabScript4: ; 1cbd2 (7:445f)
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
	ld [W_OAKSLABCURSCRIPT], a
	ret

OaksLabScript5: ; 1cbfd (7:4bfd)
	ld hl, wd74b
	set 1, [hl]
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
	ld [W_OAKSLABCURSCRIPT], a
	ret

OaksLabScript6: ; 1cc36 (7:4c36)
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
	ld [W_OAKSLABCURSCRIPT], a
	ret

OaksLabScript7: ; 1cc72 (7:4c72)
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3

	ld a, $6
	ld [W_OAKSLABCURSCRIPT], a
	ret

OaksLabScript8: ; 1cc80 (7:4c80)
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	ld de, .SonyPushesPlayerAwayFromEeveeBall
	call MoveSprite
	ld a, $9
	ld [W_OAKSLABCURSCRIPT], a
	ret

.SonyPushesPlayerAwayFromEeveeBall
	db $00
	db $07
	db $07
	db $07
	db $FF

OaksLabScript9: ; 1cd00 (7:4d00)
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
	ld [W_RIVALSTARTER], a
	ld a, EEVEE
	ld [wd11e], a
	call GetMonName
	ld a, $FF ^ (A_BUTTON | B_BUTTON)
	ld [wJoyIgnore], a
	ld a, $11
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID

	ld a, $a
	ld [W_OAKSLABCURSCRIPT], a
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

OaksLabScript10: ; 1cd6d (7:4d6d)
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
	ld [W_OAKSLABCURSCRIPT], a
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
	ld [W_OAKSLABCURSCRIPT], a
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
	ld [W_OAKSLABCURSCRIPT], a
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
	ld [W_OAKSLABCURSCRIPT], a
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
	ld [W_RIVALSTARTER], a

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
	ld hl, wd74b
	set 3, [hl]
	ld a, $f
	ld [W_OAKSLABCURSCRIPT], a
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
	ld [W_OAKSLABCURSCRIPT], a
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
	ld [W_OAKSLABCURSCRIPT], a
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
	ld [wSpriteStateData1 + 9], a
	ret

OaksLabScript17:
; Pikachu comes out
	ld a, SPRITE_FACING_UP
	ld [wSpriteStateData1 + 9], a
	ld a, $2
	ld [wd431], a
	callba Func_fc4fa
	call Func_1525
	ld a, $1a
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $12
	ld [W_OAKSLABCURSCRIPT], a
	ret

OaksLabScript18:
	ld a, $1b
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wJoyIgnore], a
	ld a, $16
	ld [W_OAKSLABCURSCRIPT], a
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
	ld [W_OAKSLABCURSCRIPT], a
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
	ld [W_VIRIDIANCITYCURSCRIPT], a
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
	ld [W_OAKSLABCURSCRIPT], a
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
	ld [W_OAKSLABCURSCRIPT], a
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
	ld hl, OaksLabText_1c946
	ld a, l
	ld [wMapTextPtr], a
	ld a, h
	ld [wMapTextPtr + 1], a
	ret

OaksLabTextPointers: ; 1d082 (7:5082)
	dr $1c910,$1c946

OaksLabText_1c946:
	dr $1c946,$1cbae

OaksLabRivalDefeatedText:
	dr $1cbae,$1cbb3

OaksLabRivalBeatYouText:
	dr $1cbb3,$1cc22
