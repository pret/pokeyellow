BillsHouse_Script:
	call BillsHouseScript_1e09e
	call EnableAutoTextBoxDrawing
	ld a, [wBillsHouseCurScript]
	ld hl, BillsHouse_ScriptPointers
	call CallFunctionInTable
	ret

BillsHouse_ScriptPointers:
	dw BillsHouseScript0
	dw BillsHouseScript1
	dw BillsHouseScript2
	dw BillsHouseScript3
	dw BillsHouseScript4
	dw BillsHouseScript5
	dw BillsHouseScript6
	dw BillsHouseScript7
	dw BillsHouseScript8
	dw BillsHouseScript9

BillsHouseScript_1e09e:
	ld hl, wd492
	bit 7, [hl]
	set 7, [hl]
	ret nz
	CheckEventHL EVENT_MET_BILL_2
	jr z, .asm_1e0af
	jr .asm_1e0b3

.asm_1e0af
	ld a, $0
	jr .asm_1e0b5

.asm_1e0b3
	ld a, $9
.asm_1e0b5
	ld [wBillsHouseCurScript], a
	ret

BillsHouseScript0:
	ld a, [wd472]
	bit 7, a
	jr z, .asm_1e0d2
	callfar CheckPikachuFaintedOrStatused
	jr c, .asm_1e0d2
	callfar Func_f24d5
.asm_1e0d2
	xor a
	ld [wJoyIgnore], a
	ld a, $1
	ld [wBillsHouseCurScript], a
	ret

BillsHouseScript1:
	ret

BillsHouseScript2:
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a ; cp SPRITE_FACING_DOWN
	ld de, MovementData_1e79c
	jr nz, .notDown
	call CheckPikachuFollowingPlayer
	jr nz, .asm_1e0f8
	callfar Func_f250b
.asm_1e0f8
	ld de, MovementData_1e7a0
.notDown
	ld a, $1
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, $3
	ld [wBillsHouseCurScript], a
	ret

MovementData_1e79c:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db -1 ; end

; make Bill walk around the player
MovementData_1e7a0:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db -1 ; end

BillsHouseScript3:
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, HS_BILL_POKEMON
	ld [wMissableObjectIndex], a
	predef HideObject
	call CheckPikachuFollowingPlayer
	jr z, .asm_1e13e
	ld hl, PikachuMovementData_1e14d
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a ; cp SPRITE_FACING_DOWN
	jr nz, .asm_1e133
	ld hl, PikachuMovementData_1e152
.asm_1e133
	call ApplyPikachuMovementData
	callfar InitializePikachuTextID
.asm_1e13e
	xor a
	ld [wJoyIgnore], a
	SetEvent EVENT_BILL_SAID_USE_CELL_SEPARATOR
	ld a, $4
	ld [wBillsHouseCurScript], a
	ret

PikachuMovementData_1e14d:
	db $00
	db $1e
	db $1e
	db $1e
	db $3f

PikachuMovementData_1e152:
	db $00
	db $1e
	db $1f
	db $1e
	db $1e
	db $20
	db $36
	db $3f

BillsHouseScript4:
	CheckEvent EVENT_USED_CELL_SEPARATOR_ON_BILL
	ret z
	ld a, $fc
	ld [wJoyIgnore], a
	ld a, $5
	ld [wBillsHouseCurScript], a
	ret

BillsHouseScript5:
	ld a, $2
	ld [wSpriteIndex], a
	ld a, $c
	ldh [hSpriteScreenYCoord], a
	ld a, $40
	ldh [hSpriteScreenXCoord], a
	ld a, 6
	ldh [hSpriteMapYCoord], a
	ld a, 5
	ldh [hSpriteMapXCoord], a
	call SetSpritePosition1
	ld a, HS_BILL_1
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld c, 8
	call DelayFrames
	ld hl, wd472
	bit 7, [hl]
	jr z, .asm_1e1c6
	call CheckPikachuFollowingPlayer
	jr z, .asm_1e1c6
	ld a, $2
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld hl, PikachuMovementData_1e1a9
	call ApplyPikachuMovementData
	ld a, $f
	ld [wEmotionBubbleSpriteIndex], a
	ld a, EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	callfar InitializePikachuTextID
.asm_1e1c6
	ld a, $2
	ldh [hSpriteIndex], a
	ld de, MovementData_1e807
	call MoveSprite
	ld a, $6
	ld [wBillsHouseCurScript], a
	ret

MovementData_1e807:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_DOWN
	db -1 ; end

PikachuMovementData_1e1a9:
	db $00
	db $37
	db $3f

BillsHouseScript6:
	ld a, [wd730]
	bit 0, a
	ret nz
	SetEvent EVENT_MET_BILL_2 ; this event seems redundant
	SetEvent EVENT_MET_BILL
	ld a, $7
	ld [wBillsHouseCurScript], a
	ret

BillsHouseScript7:
	xor a
	ld [wPlayerMovingDirection], a
	ld a, SPRITE_FACING_UP
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, ~(A_BUTTON | B_BUTTON)
	ld [wJoyIgnore], a
	ld de, RLE_1e219
	ld hl, wSimulatedJoypadStatesEnd
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $8
	ld [wBillsHouseCurScript], a
	ret

RLE_1e219:
	db D_RIGHT, $3
	db $FF

BillsHouseScript8:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	xor a
	ld [wPlayerMovingDirection], a
	ld a, SPRITE_FACING_UP
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, $2
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	xor a
	ld [wJoyIgnore], a
	ld a, $2
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $9
	ld [wBillsHouseCurScript], a
	ret

BillsHouseScript9:
	ret

BillsHouse_TextPointers:
	dw BillsHouseText1
	dw BillsHouseText2
	dw BillsHouseText3
	dw BillsHouseText4

BillsHouseText4:
	text_far _BillsHouseDontLeaveText
	text_end

BillsHouseText1:
	text_asm
	farcall Func_f2418
	jp TextScriptEnd

BillsHouseText2:
	text_asm
	farcall Func_f244a
	jp TextScriptEnd

BillsHouseText3:
	text_asm
	farcall Func_f24a2
	jp TextScriptEnd
