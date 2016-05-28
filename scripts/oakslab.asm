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
	dr $1c5b8,$1c5ce
OaksLabScript12:
	dr $1c5ce,$1c61a
OaksLabScript13:
	dr $1c61a,$1c651
OaksLabScript14:
	dr $1c651,$1c692
OaksLabScript15:
	dr $1c692,$1c6ce
OaksLabScript16:
	dr $1c6ce,$1c70b
OaksLabScript17:
	dr $1c70b,$1c72d
OaksLabScript18:
	dr $1c72d,$1c73e
OaksLabScript19:
	dr $1c73e,$1c7a4
OaksLabScript20:
	dr $1c7a4,$1c866
OaksLabScript21:
	dr $1c866,$1c896
OaksLabScript22:
	dr $1c896,$1c904
OaksLabScript_1d076:
	dr $1c904,$1c910

OaksLabTextPointers: ; 1d082 (7:5082)
	dr $1c910,$1cc22
