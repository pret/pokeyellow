BillsHouse_Script:
	call BillsHouse_CheckMetBill
	call EnableAutoTextBoxDrawing
	ld a, [wBillsHouseCurScript]
	ld hl, BillsHouse_ScriptPointers
	call CallFunctionInTable
	ret

BillsHouse_ScriptPointers:
	def_script_pointers
	dw_const BillsHouseScript0, SCRIPT_BILLSHOUSE_SCRIPT0
	dw_const BillsHouseScript1, SCRIPT_BILLSHOUSE_SCRIPT1
	dw_const BillsHouseScript2, SCRIPT_BILLSHOUSE_SCRIPT2
	dw_const BillsHouseScript3, SCRIPT_BILLSHOUSE_SCRIPT3
	dw_const BillsHouseScript4, SCRIPT_BILLSHOUSE_SCRIPT4
	dw_const BillsHouseScript5, SCRIPT_BILLSHOUSE_SCRIPT5
	dw_const BillsHouseScript6, SCRIPT_BILLSHOUSE_SCRIPT6
	dw_const BillsHouseScript7, SCRIPT_BILLSHOUSE_SCRIPT7
	dw_const BillsHouseScript8, SCRIPT_BILLSHOUSE_SCRIPT8
	dw_const BillsHouseScript9, SCRIPT_BILLSHOUSE_SCRIPT9

BillsHouse_CheckMetBill:
	ld hl, wPikachuMapScriptFlags
	bit BIT_PIKACHU_MAP_SCRIPT_ACTIVE, [hl]
	set BIT_PIKACHU_MAP_SCRIPT_ACTIVE, [hl]
	ret nz
	CheckEventHL EVENT_MET_BILL_2
	jr z, .notMetBill
	jr .metBill

.notMetBill
	ld a, SCRIPT_BILLSHOUSE_SCRIPT0
	jr .setScript

.metBill
	ld a, SCRIPT_BILLSHOUSE_SCRIPT9
.setScript
	ld [wBillsHouseCurScript], a
	ret

BillsHouseScript0:
	ld a, [wPikachuSpawnStateFlags]
	bit BIT_PIKACHU_SPAWN_STARTER, a
	jr z, .done
	callfar CheckPikachuStatusCondition
	jr c, .done
	callfar BillsHousePikachuConfused
.done
	xor a
	ld [wJoyIgnore], a
	ld a, SCRIPT_BILLSHOUSE_SCRIPT1
	ld [wBillsHouseCurScript], a
	ret

BillsHouseScript1:
	ret

BillsHouseScript2:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a ; cp SPRITE_FACING_DOWN
	ld de, BillMovement_WalkToCellSeparator
	jr nz, .notDown
	call CheckPikachuFollowingPlayer
	jr nz, .pikachuNotFollowing
	callfar BillsHousePikachuWatchPlayer
.pikachuNotFollowing
	ld de, BillMovement_WalkAroundPlayer
.notDown
	ld a, BILLSHOUSE_BILL_POKEMON
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, SCRIPT_BILLSHOUSE_SCRIPT3
	ld [wBillsHouseCurScript], a
	ret

BillMovement_WalkToCellSeparator:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db -1 ; end

; make Bill walk around the player
BillMovement_WalkAroundPlayer:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db -1 ; end

BillsHouseScript3:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, TOGGLE_BILL_POKEMON
	ld [wToggleableObjectIndex], a
	predef HideObject
	call CheckPikachuFollowingPlayer
	jr z, .pikachuNotFollowing
	ld hl, PikachuMovement_EnterCellSeparatorDown
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a ; cp SPRITE_FACING_DOWN
	jr nz, .applyPikachuMovement
	ld hl, PikachuMovement_EnterCellSeparatorNotDown
.applyPikachuMovement
	call ApplyPikachuMovementData
	callfar InitializePikachuTextID
.pikachuNotFollowing
	xor a
	ld [wJoyIgnore], a
	SetEvent EVENT_BILL_SAID_USE_CELL_SEPARATOR
	ld a, SCRIPT_BILLSHOUSE_SCRIPT4
	ld [wBillsHouseCurScript], a
	ret

PikachuMovement_EnterCellSeparatorDown:
	db PIKAMOVEMENT_DELAY
	db PIKAMOVEMENT_STEP_UP
	db PIKAMOVEMENT_STEP_UP
	db PIKAMOVEMENT_STEP_UP
	db PIKAMOVEMENT_END

PikachuMovement_EnterCellSeparatorNotDown:
	db PIKAMOVEMENT_DELAY
	db PIKAMOVEMENT_STEP_UP
	db PIKAMOVEMENT_STEP_LEFT
	db PIKAMOVEMENT_STEP_UP
	db PIKAMOVEMENT_STEP_UP
	db PIKAMOVEMENT_STEP_RIGHT
	db PIKAMOVEMENT_LOOK_UP
	db PIKAMOVEMENT_END

BillsHouseScript4:
	CheckEvent EVENT_USED_CELL_SEPARATOR_ON_BILL
	ret z
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_BILLSHOUSE_SCRIPT5
	ld [wBillsHouseCurScript], a
	ret

BillsHouseScript5:
	ld a, BILLSHOUSE_BILL1
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
	ld a, TOGGLE_BILL_1
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ld c, 8
	call DelayFrames
	ld hl, wPikachuSpawnStateFlags
	bit BIT_PIKACHU_SPAWN_STARTER, [hl]
	jr z, .pikachuNotFollowing
	call CheckPikachuFollowingPlayer
	jr z, .pikachuNotFollowing
	ld a, BILLSHOUSE_BILL1
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld hl, PikachuMovement_ExitCellSeparator
	call ApplyPikachuMovementData
	ld a, $f
	ld [wEmotionBubbleSpriteIndex], a
	ld a, EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	callfar InitializePikachuTextID
.pikachuNotFollowing
	ld a, BILLSHOUSE_BILL1
	ldh [hSpriteIndex], a
	ld de, .BillExitMachineMovement
	call MoveSprite
	ld a, SCRIPT_BILLSHOUSE_SCRIPT6
	ld [wBillsHouseCurScript], a
	ret

.BillExitMachineMovement:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_DOWN
	db -1 ; end

PikachuMovement_ExitCellSeparator:
	db PIKAMOVEMENT_DELAY
	db PIKAMOVEMENT_LOOK_LEFT
	db PIKAMOVEMENT_END

BillsHouseScript6:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	SetEvent EVENT_MET_BILL_2 ; this event seems redundant
	SetEvent EVENT_MET_BILL
	ld a, SCRIPT_BILLSHOUSE_SCRIPT7
	ld [wBillsHouseCurScript], a
	ret

BillsHouseScript7:
	xor a
	ld [wPlayerMovingDirection], a
	ld a, SPRITE_FACING_UP
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld de, RLE_1e219
	ld hl, wSimulatedJoypadStatesEnd
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, SCRIPT_BILLSHOUSE_SCRIPT8
	ld [wBillsHouseCurScript], a
	ret

RLE_1e219:
	db PAD_RIGHT, $3
	db $FF

BillsHouseScript8:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	xor a
	ld [wPlayerMovingDirection], a
	ld a, SPRITE_FACING_UP
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, BILLSHOUSE_BILL1
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	xor a
	ld [wJoyIgnore], a
	ld a, TEXT_BILLSHOUSE_BILL_SS_TICKET
	ldh [hTextID], a
	call DisplayTextID
	ld a, SCRIPT_BILLSHOUSE_SCRIPT9
	ld [wBillsHouseCurScript], a
	ret

BillsHouseScript9:
	ret

BillsHouse_TextPointers:
	def_text_pointers
	dw_const BillsHouseBillPokemonText,               TEXT_BILLSHOUSE_BILL_POKEMON
	dw_const BillsHouseBillSSTicketText,              TEXT_BILLSHOUSE_BILL_SS_TICKET
	dw_const BillsHouseBillCheckOutMyRarePokemonText, TEXT_BILLSHOUSE_BILL_CHECK_OUT_MY_RARE_POKEMON
	dw_const BillsHouseBillDontLeaveText,             TEXT_BILLSHOUSE_BILL_DONT_LEAVE

BillsHouseBillDontLeaveText:
	text_far _BillsHouseBillDontLeaveText
	text_end

BillsHouseBillPokemonText:
	text_asm
	farcall BillsHousePrintBillPokemonText
	jp TextScriptEnd

BillsHouseBillSSTicketText:
	text_asm
	farcall BillsHousePrintBillSSTicketText
	jp TextScriptEnd

BillsHouseBillCheckOutMyRarePokemonText:
	text_asm
	farcall BillsHousePrintBillCheckOutMyRarePokemonText
	jp TextScriptEnd
