VermilionCityScript:
	call EnableAutoTextBoxDrawing
	ld hl, wd492
	res 7, [hl]
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	push hl
	call nz, InitCityScript
	pop hl
	bit 5, [hl]
	res 5, [hl]
	call nz, SetFirstLockTrashCanIndex
	ld hl, VermilionCityScriptPointers
	ld a, [wVermilionCityCurScript]
	call JumpTable
	call VermilionCityScript_19869
	ret

VermilionCityScript_19869:
	CheckEventHL EVENT_152
	ret nz
	CheckEventReuseHL EVENT_GOT_BIKE_VOUCHER
	ret z
	SetEventReuseHL EVENT_152
	ret

SetFirstLockTrashCanIndex:
	call Random
	ld a, [hRandomAdd]
	ld b, a
	ld a, [hRandomSub]
	adc b
	and $e
	ld [wFirstLockTrashCanIndex], a
	ret

InitCityScript:
	CheckEventHL EVENT_SS_ANNE_LEFT
	ret z
	CheckEventReuseHL EVENT_WALKED_PAST_GUARD_AFTER_SS_ANNE_LEFT
	SetEventReuseHL EVENT_WALKED_PAST_GUARD_AFTER_SS_ANNE_LEFT
	ret nz
	ld a, $2
	ld [wVermilionCityCurScript], a
	ret

VermilionCityScriptPointers:
	dw VermilionCityScript0
	dw VermilionCityScript1
	dw VermilionCityScript2
	dw VermilionCityScript3
	dw VermilionCityScript4

VermilionCityScript0:
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a ; cp SPRITE_FACING_DOWN
	jr nz, .return
	ld hl, SSAnneTicketCheckCoords
	call ArePlayerCoordsInArray
	jr nc, .return
	xor a
	ld [hJoyHeld], a
	ld [wcf0d], a
	ld a, $3
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .shipHasDeparted
	ld b, S_S_TICKET
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	ret nz
.shipHasDeparted
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wVermilionCityCurScript], a
	ret

.return
	ret

SSAnneTicketCheckCoords:
	db $1e,$12 ; y, x
	db $ff

VermilionCityScript4:
	ld hl, SSAnneTicketCheckCoords
	call ArePlayerCoordsInArray
	ret c
	ld a, $0
	ld [wVermilionCityCurScript], a
	ret

VermilionCityScript2:
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld [wSimulatedJoypadStatesEnd + 1], a
	ld a, 2
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $3
	ld [wVermilionCityCurScript], a
	ret

VermilionCityScript3:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld [hJoyHeld], a
	ld a, $0
	ld [wVermilionCityCurScript], a
	ret

VermilionCityScript1:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld c, 10
	call DelayFrames
	ld a, $0
	ld [wVermilionCityCurScript], a
	ret

VermilionCityTextPointers:
	dw VermilionCityText1
	dw VermilionCityText2
	dw VermilionCityText3
	dw VermilionCityText4
	dw VermilionCityText5
	dw VermilionCityText6
	dw VermilionCityText7
	dw VermilionCityText8
	dw VermilionCityText9
	dw MartSignText
	dw PokeCenterSignText
	dw VermilionCityText12
	dw VermilionCityText13
	dw VermilionCityText14

VermilionCityText1:
	TX_FAR _VermilionCityText1
	db "@"

VermilionCityText2:
	TX_ASM
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .shipHasDeparted
	ld hl, VermillionCityTextDidYouSee
	call PrintText
	jr .end
.shipHasDeparted
	ld hl, VermilionCityTextSSAnneDeparted
	call PrintText
.end
	jp TextScriptEnd

VermillionCityTextDidYouSee:
	TX_FAR _VermillionCityTextDidYouSee
	db "@"

VermilionCityTextSSAnneDeparted:
	TX_FAR _VermilionCityTextSSAnneDeparted
	db "@"

VermilionCityText3:
	TX_ASM
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .shipHasDeparted
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_RIGHT
	jr z, .greetPlayer
	ld hl, .inFrontOfOrBehindGuardCoords
	call ArePlayerCoordsInArray
	jr nc, .greetPlayerAndCheckTicket
.greetPlayer
	ld hl, SSAnneWelcomeText4
	call PrintText
	jr .end
.greetPlayerAndCheckTicket
	ld hl, SSAnneWelcomeText9
	call PrintText
	ld b, S_S_TICKET
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	jr nz, .playerHasTicket
	ld hl, SSAnneNoTicketText
	call PrintText
	jr .end
.playerHasTicket
	ld hl, SSAnneFlashedTicketText
	call PrintText
	ld a, $4
	ld [wVermilionCityCurScript], a
	jr .end
.shipHasDeparted
	ld hl, SSAnneNotHereText
	call PrintText
.end
	jp TextScriptEnd

.inFrontOfOrBehindGuardCoords:
	db $1d,$13 ; y, x of tile in front of guard
	db $1f,$13 ; y, x of tile behind guard
	db $ff

SSAnneWelcomeText4:
	TX_FAR _SSAnneWelcomeText4
	db "@"

SSAnneWelcomeText9:
	TX_FAR _SSAnneWelcomeText9
	db "@"

SSAnneFlashedTicketText:
	TX_FAR _SSAnneFlashedTicketText
	db "@"

SSAnneNoTicketText:
	TX_FAR _SSAnneNoTicketText
	db "@"

SSAnneNotHereText:
	TX_FAR _SSAnneNotHereText
	db "@"

VermilionCityText4:
	TX_FAR _VermilionCityText4
	db "@"

VermilionCityText5:
	TX_FAR _VermilionCityText5
	TX_ASM
	ld a, MACHOP
	call PlayCry
	call WaitForSoundToFinish
	ld hl, VermilionCityText15
	ret

VermilionCityText15:
	TX_FAR _VermilionCityText15
	db "@"

VermilionCityText6:
	TX_FAR _VermilionCityText6
	db "@"

VermilionCityText8:
	TX_ASM
	callba Func_f1a8a
	jp TextScriptEnd

VermilionCityText9:
	TX_ASM
	callba Func_f1a96
	jp TextScriptEnd

VermilionCityText12:
	TX_ASM
	callba Func_f1aa2
	jp TextScriptEnd

VermilionCityText13:
	TX_ASM
	callba Func_f1aae
	jp TextScriptEnd

VermilionCityText14:
	TX_ASM
	callba Func_f1aba
	jp TextScriptEnd

VermilionCityText7:
	TX_ASM
	callba Func_f1a0f
	jp TextScriptEnd
