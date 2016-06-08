GaryScript:
	call EnableAutoTextBoxDrawing
	ld hl, GaryScriptPointers
	ld a, [W_GARYCURSCRIPT]
	call JumpTable
	ret

GaryScript_75f29:
	xor a
	ld [wJoyIgnore], a
	ld [W_GARYCURSCRIPT], a
	ret

GaryScriptPointers:
	dw GaryScript0
	dw GaryScript1
	dw GaryScript2
	dw GaryScript3
	dw GaryScript4
	dw GaryScript5
	dw GaryScript6
	dw GaryScript7
	dw GaryScript8
	dw GaryScript9
	dw GaryScript10

GaryScript0:
	ret

GaryScript1:
	ld a, $ff
	ld [wJoyIgnore], a
	ld hl, wSimulatedJoypadStatesEnd
	ld de, RLEMovement75f63
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $2
	ld [W_GARYCURSCRIPT], a
	ret

RLEMovement75f63:
	db D_UP, 1
	db D_RIGHT, 1
	db D_UP, 3
	db $ff

GaryScript2:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	xor a
	ld [wJoyIgnore], a
	ld hl, wOptions
	res 7, [hl]
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	call Delay3
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, GaryText_760f9
	ld de, GaryText_760fe
	call SaveEndBattleTextPointers
	ld a, OPP_SONY3
	ld [wCurOpponent], a

	; select which team to use during the encounter
	ld a, [W_RIVALSTARTER]
	add $0 ; Wow GameFreak
	ld [wTrainerNo], a

	xor a
	ld [hJoyHeld], a
	ld a, $3
	ld [W_GARYCURSCRIPT], a
	ret

GaryScript3:
	ld a, [wIsInBattle]
	cp $ff
	jp z, GaryScript_75f29
	call UpdateSprites
	SetEvent EVENT_BEAT_CHAMPION_RIVAL
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	call GaryScript_760c8
	ld a, $1
	ld [H_SPRITEINDEX], a
	call SetSpriteMovementBytesToFF
	ld a, $4
	ld [W_GARYCURSCRIPT], a
	ret

GaryScript4:
	callba Music_Cities1AlternateTempo
	ld a, $2
	ld [hSpriteIndexOrTextID], a
	call GaryScript_760c8
	ld a, $2
	ld [H_SPRITEINDEX], a
	call SetSpriteMovementBytesToFF
	ld de, MovementData_76014
	ld a, $2
	ld [H_SPRITEINDEX], a
	call MoveSprite
	ld a, HS_CHAMPIONS_ROOM_OAK
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, $5
	ld [W_GARYCURSCRIPT], a
	ret

MovementData_76014:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db $FF

GaryScript5:
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, SPRITE_FACING_LEFT
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $2
	ld [H_SPRITEINDEX], a
	xor a ; SPRITE_FACING_DOWN
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $3
	ld [hSpriteIndexOrTextID], a
	call GaryScript_760c8
	ld a, $6
	ld [W_GARYCURSCRIPT], a
	ret

GaryScript6:
	ld a, $2
	ld [H_SPRITEINDEX], a
	ld a, SPRITE_FACING_RIGHT
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $4
	ld [hSpriteIndexOrTextID], a
	call GaryScript_760c8
	ld a, $7
	ld [W_GARYCURSCRIPT], a
	ret

GaryScript7:
	ld a, $2
	ld [H_SPRITEINDEX], a
	xor a ; SPRITE_FACING_DOWN
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $5
	ld [hSpriteIndexOrTextID], a
	call GaryScript_760c8
	ld de, MovementData_76080
	ld a, $2
	ld [H_SPRITEINDEX], a
	call MoveSprite
	ld a, $8
	ld [W_GARYCURSCRIPT], a
	ret

MovementData_76080:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db $FF

GaryScript8:
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, HS_CHAMPIONS_ROOM_OAK
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, $9
	ld [W_GARYCURSCRIPT], a
	ret

GaryScript9:
	ld a, $ff
	ld [wJoyIgnore], a
	ld hl, wSimulatedJoypadStatesEnd
	ld de, RLEMovement760b4
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $a
	ld [W_GARYCURSCRIPT], a
	ret

RLEMovement760b4:
	db D_UP, 4
	db D_LEFT, 1
	db $ff

GaryScript10:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, $0
	ld [W_GARYCURSCRIPT], a
	ret

GaryScript_760c8:
	ld a, $f0
	ld [wJoyIgnore], a
	call DisplayTextID
	ld a, $ff
	ld [wJoyIgnore], a
	ret

GaryTextPointers:
	dw GaryText1
	dw GaryText2
	dw GaryText3
	dw GaryText4
	dw GaryText5

GaryText1:
	TX_ASM
	CheckEvent EVENT_BEAT_CHAMPION_RIVAL
	ld hl, GaryText_760f4
	jr z, .asm_17e9f
	ld hl, GaryText_76103
.asm_17e9f
	call PrintText
	jp TextScriptEnd

GaryText_760f4:
	TX_FAR _GaryChampionIntroText
	db "@"

GaryText_760f9:
	TX_FAR _GaryText_760f9
	db "@"

GaryText_760fe:
	TX_FAR _GaryText_760fe
	db "@"

GaryText_76103:
	TX_FAR _GaryText_76103
	db "@"

GaryText2:
	TX_FAR _GaryText2
	db "@"

GaryText3:
	TX_ASM
	ld a, [W_PLAYERSTARTER]
	ld [wd11e], a
	call GetMonName
	ld hl, GaryText_76120
	call PrintText
	jp TextScriptEnd

GaryText_76120:
	TX_FAR _GaryText_76120
	db "@"

GaryText4:
	TX_FAR _GaryText_76125
	db "@"

GaryText5:
	TX_FAR _GaryText_7612a
	db "@"
