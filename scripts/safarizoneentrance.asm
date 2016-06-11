SafariZoneEntranceScript:
	call EnableAutoTextBoxDrawing
	ld hl, SafariZoneEntranceScriptPointers
	ld a, [wSafariZoneEntranceCurScript]
	call JumpTable
	ret

SafariZoneEntranceScriptPointers:
	dw .SafariZoneEntranceScript0
	dw .SafariZoneEntranceScript1
	dw .SafariZoneEntranceScript2
	dw .SafariZoneEntranceScript3
	dw .SafariZoneEntranceScript4
	dw .SafariZoneEntranceScript5
	dw .SafariZoneEntranceScript6

.SafariZoneEntranceScript0
	ld hl, .CoordsData_75221
	call ArePlayerCoordsInArray
	ret nc
	ld a, $3
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $ff
	ld [wJoyIgnore], a
	xor a
	ld [hJoyHeld], a
	ld a, SPRITE_FACING_RIGHT
	ld [wPlayerFacingDirection], a
	ld a, [wCoordIndex]
	cp $1
	jr z, .asm_7520f
	ld a, $2
	ld [wSafariZoneEntranceCurScript], a
	ret
.asm_7520f
	ld a, D_RIGHT
	ld c, $1
	call SafariZoneEntranceAutoWalk
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, $1
	ld [wSafariZoneEntranceCurScript], a
	ret

.CoordsData_75221:
	db $02, $03
	db $02, $04
	db $FF

.SafariZoneEntranceScript1
	call SafariZoneEntranceScript_752b4
	ret nz
.SafariZoneEntranceScript2
	xor a
	ld [hJoyHeld], a
	ld [wJoyIgnore], a
	call UpdateSprites
	ld a, $4
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $ff
	ld [wJoyIgnore], a
	ret

.SafariZoneEntranceScript3
	call SafariZoneEntranceScript_752b4
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, $5
	ld [wSafariZoneEntranceCurScript], a
	ret

.SafariZoneEntranceScript5
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	CheckAndResetEvent EVENT_SAFARI_GAME_OVER
	jr z, .asm_7527f
	ResetEventReuseHL EVENT_IN_SAFARI_ZONE
	call UpdateSprites
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, $6
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wNumSafariBalls], a
	ld [wSafariSteps], a
	ld [wSafariSteps], a ; ?????
	ld a, D_DOWN
	ld c, $3
	call SafariZoneEntranceAutoWalk
	ld a, $4
	ld [wSafariZoneEntranceCurScript], a
	jr .asm_75286
.asm_7527f
	ld a, $5
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.asm_75286
	ret

.SafariZoneEntranceScript4
	call SafariZoneEntranceScript_752b4
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, $0
	ld [wSafariZoneEntranceCurScript], a
	ret

.SafariZoneEntranceScript6
	call SafariZoneEntranceScript_752b4
	ret nz
	call Delay3
	ld a, [wcf0d]
	ld [wSafariZoneEntranceCurScript], a
	ret

SafariZoneEntranceAutoWalk:
	push af
	ld b, 0
	ld a, c
	ld [wSimulatedJoypadStatesIndex], a
	ld hl, wSimulatedJoypadStatesEnd
	pop af
	call FillMemory
	jp StartSimulatingJoypadStates

SafariZoneEntranceScript_752b4:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret

SafariZoneEntranceTextPointers:
	dw .SafariZoneEntranceText1
	dw .SafariZoneEntranceText2
	dw .SafariZoneEntranceText1
	dw .SafariZoneEntranceText4
	dw .SafariZoneEntranceText5
	dw .SafariZoneEntranceText6

.SafariZoneEntranceText1
	TX_FAR _SafariZoneEntranceText1
	db "@"

.SafariZoneEntranceText4
	TX_ASM
	callab Func_f1f77
	jp TextScriptEnd

.SafariZoneEntranceText5
	TX_FAR SafariZoneEntranceText_9e814
	TX_ASM
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_7539c
	ld hl, .SafariZoneEntranceText_753bb
	call PrintText
	xor a
	ld [wPlayerFacingDirection], a
	ld a, D_DOWN
	ld c, $3
	call SafariZoneEntranceAutoWalk
	ResetEvents EVENT_SAFARI_GAME_OVER, EVENT_IN_SAFARI_ZONE
	ld a, $0
	ld [wcf0d], a
	jr .asm_753b3
.asm_7539c
	ld hl, .SafariZoneEntranceText_753c0
	call PrintText
	ld a, SPRITE_FACING_UP
	ld [wPlayerFacingDirection], a
	ld a, D_UP
	ld c, $1
	call SafariZoneEntranceAutoWalk
	ld a, $5
	ld [wcf0d], a
.asm_753b3
	ld a, $6
	ld [wSafariZoneEntranceCurScript], a
	jp TextScriptEnd

.SafariZoneEntranceText_753bb
	TX_FAR _SafariZoneEntranceText_753bb
	db "@"

.SafariZoneEntranceText_753c0
	TX_FAR _SafariZoneEntranceText_753c0
	db "@"

.SafariZoneEntranceText6
	TX_FAR _SafariZoneEntranceText_753c5
	db "@"

.SafariZoneEntranceText2
	TX_ASM
	callab Func_f203e
	jp TextScriptEnd
