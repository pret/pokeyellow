Route22GateScript:
	call EnableAutoTextBoxDrawing
	ld hl, Route22GateScriptPointers
	ld a, [wRoute22GateCurScript]
	call JumpTable
	ld a, [wYCoord]
	cp $4
	ld a, ROUTE_23
	jr c, .asm_1e69a
	ld a, ROUTE_22
.asm_1e69a
	ld [wLastMap], a
	ret

Route22GateScriptPointers:
	dw Route22GateScript0
	dw Route22GateScript1
	dw Route22GateScript2

Route22GateScript0:
	ld hl, Route22GateScriptCoords
	call ArePlayerCoordsInArray
	ret nc
	xor a
	ld [hJoyHeld], a
	ld a, SPRITE_FACING_LEFT
	ld [wSpriteStateData1 + 1 * $10 + 9], a
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ret

Route22GateScriptCoords:
	db 2,4
	db 2,5
	db $ff

Route22GateScript_1e6ba:
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	ld [wPlayerFacingDirection], a
	ld [wJoyIgnore], a
	jp StartSimulatingJoypadStates

Route22GateScript1:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	xor a
	ld [wJoyIgnore], a
	call Delay3
	ld a, $0
	ld [wRoute22GateCurScript], a
Route22GateScript2:
	ret

Route22GateTextPointers:
	dw Route22GateText1

Route22GateText1:
	TX_ASM
	ld a, [wObtainedBadges]
	bit 0, a ; BOULDERBADGE
	jr nz, .asm_1e6f6
	ld hl, Route22GateText_1e704
	call PrintText
	call Route22GateScript_1e6ba
	ld a, $1
	jr .asm_1e6fe
.asm_1e6f6
	ld hl, Route22GateText_1e71a
	call PrintText
	ld a, $2
.asm_1e6fe
	ld [wRoute22GateCurScript], a
	jp TextScriptEnd

Route22GateText_1e704:
	TX_FAR _Route22GateText_1e704
	TX_ASM
	ld a, SFX_DENIED
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	ld hl, Route22GateText_1e715
	ret

Route22GateText_1e715:
	TX_FAR _Route22GateText_1e715
	db "@"

Route22GateText_1e71a:
	TX_FAR _Route22GateText_1e71a
	TX_SFX_ITEM
	db "@"
