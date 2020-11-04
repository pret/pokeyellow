Func_f1f77::
	ld hl, .WelcomeText
	call PrintText
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jp nz, .declined
	ld hl, wPlayerMoney
	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	jr nz, .has_positive_balance
	call SafariZoneEntranceGetLowCostAdmissionText
	jr c, .deny_entry
	jr .poor_mans_discount

.has_positive_balance
	xor a
	ldh [hMoney], a
	ld a, $5
	ldh [hMoney + 1], a
	ld a, $0
	ldh [hMoney + 2], a
	call HasEnoughMoney
	jr nc, .has_enough_money
	ld hl, .NotEnoughMoneyText
	call PrintText
	call SafariZoneEntranceCalculateLowCostAdmission
	jr c, .deny_entry
	jr .poor_mans_discount

.has_enough_money
	xor a
	ld [wPriceTemp + 0], a
	ld a, $5
	ld [wPriceTemp + 1], a
	ld a, $0
	ld [wPriceTemp + 2], a
	ld hl, wTrainerInfoTextBoxNextRowOffset
	ld de, wPlayerMoney + 2
	ld c, 3
	predef SubBCDPredef
	ld a, SFX_PURCHASE
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld hl, .MakePaymentText
	call PrintText
	ld a, 30
	ld hl, 502
.poor_mans_discount
	ld [wNumSafariBalls], a
	ld a, h
	ld [wSafariSteps], a
	ld a, l
	ld [wSafariSteps + 1], a
	ld a, D_UP
	ld c, 3
	call SafariZoneEntranceStartSimulatingJoypadStates
	SetEvent EVENT_IN_SAFARI_ZONE
	ResetEventReuseHL EVENT_SAFARI_GAME_OVER
	ld a, $3
	ld [wSafariZoneGateCurScript], a
	jr .asm_f2024
.declined:
	ld hl, .PleaseComeAgainText
	call PrintText
.deny_entry
	ld a, D_DOWN
	ld c, 1
	call SafariZoneEntranceStartSimulatingJoypadStates
	ld a, $4
	ld [wSafariZoneGateCurScript], a
.asm_f2024
	ret

.WelcomeText
	text_far SafariZoneEntranceText_9e6e4
	text_end

.MakePaymentText
	text_far SafariZoneEntranceText_9e747
	sound_get_item_1
	text_far _SafariZoneEntranceText_75360
	text_end

.PleaseComeAgainText
	text_far _SafariZoneEntranceText_75365
	text_end

.NotEnoughMoneyText
	text_far _SafariZoneEntranceText_7536a
	text_end

Func_f203e::
	ld hl, .FirstTimeQuestionText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ld hl, .RegularText
	jr nz, .Explanation
	ld hl, .ExplanationText
.Explanation
	call PrintText
	ret

.FirstTimeQuestionText
	text_far _SafariZoneEntranceText_753e6
	text_end

.ExplanationText
	text_far _SafariZoneEntranceText_753eb
	text_end

.RegularText
	text_far _SafariZoneEntranceText_753f0
	text_end

SafariZoneEntranceStartSimulatingJoypadStates:
	push af
	ld b, $0
	ld a, c
	ld [wSimulatedJoypadStatesIndex], a
	ld hl, wParentMenuItem
	pop af
	call FillMemory
	jp StartSimulatingJoypadStates

SafariZoneEntranceCalculateLowCostAdmission:
	ld hl, wPlayerMoney
	ld de, hMoney
	ld bc, $3
	call CopyData
	xor a
	ldh [hDivideBCDDivisor], a
	ldh [hDivideBCDDivisor + 1], a
	ld a, 23
	ldh [hDivideBCDDivisor + 2], a
	predef DivideBCDPredef3
	ldh a, [hDivideBCDQuotient + 2]
	call SafariZoneEntranceConvertBCDtoNumber
	push af
	ld hl, wPlayerMoney
	xor a
	ld bc, $3
	call FillMemory
	ld hl, SafariZoneEntranceText_f20c4
	call PrintText_NoCreatingTextBox
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld hl, SafariZoneEntranceText_f20c9
	call PrintText
	pop af
	inc a
	jr z, .max_balls
	cp 29
	jr c, .load_balls
.max_balls
	ld a, 29
.load_balls
	ld hl, 502
	and a
	ret

SafariZoneEntranceText_f20c4:
	text_far _SafariZoneLowCostText1
	text_end

SafariZoneEntranceText_f20c9:
	text_far _SafariZoneLowCostText2
	text_end

SafariZoneEntranceGetLowCostAdmissionText:
	ld hl, wSafariSteps
	ld a, [hl]
	push af
	inc [hl]
	ld e, a
	ld d, $0
	ld hl, Pointers_f2100
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintText
	pop af
	cp $3
	jr z, .give_one_ball
	scf
	ret

.give_one_ball
	ld hl, SafariZoneEntranceText_f20f6
	call PrintText_NoCreatingTextBox
	ld a, $1
	ld hl, 502
	and a
	ret

SafariZoneEntranceText_f20f6:
	text_far _SafariZoneLowCostText3
	sound_get_item_1
	text_far _SafariZoneLowCostText4
	text_end

Pointers_f2100:
	dw SafariZoneEntranceText_f210a
	dw SafariZoneEntranceText_f210f
	dw SafariZoneEntranceText_f2114
	dw SafariZoneEntranceText_f2119
	dw SafariZoneEntranceText_f2119

SafariZoneEntranceText_f210a:
	text_far _SafariZoneLowCostText5
	text_end

SafariZoneEntranceText_f210f:
	text_far _SafariZoneLowCostText6
	text_end

SafariZoneEntranceText_f2114:
	text_far _SafariZoneLowCostText7
	text_end

SafariZoneEntranceText_f2119:
	text_far _SafariZoneLowCostText8
	text_end

SafariZoneEntranceConvertBCDtoNumber:
	push hl
	ld c, a
	and $f
	ld l, a
	ld h, $0
	ld a, c
	and $f0
	swap a
	ld bc, 10
	call AddNTimes
	ld a, l
	pop hl
	ret
