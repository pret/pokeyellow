Func_f218c:
	CheckEvent EVENT_BOUGHT_MAGIKARP, 1
	jp c, .alreadyBoughtMagikarp
	ld hl, MtMoonPokecenterText_4935c
	call PrintText
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jp nz, .choseNo
	; $000500
	xor a
	ld [hMoney], a
	ld [hMoney + 2], a
	ld a, $5
	ld [hMoney + 1], a
	call HasEnoughMoney
	jr nc, .enoughMoney
	ld hl, MtMoonPokecenterText_49366
	jr .printText
.enoughMoney
	lb bc, MAGIKARP, 5
	call GivePokemon
	jr nc, .done
	; $000500
	xor a
	ld [wPriceTemp], a
	ld [wPriceTemp + 2], a
	ld a, $5
	ld [wPriceTemp + 1], a
	ld hl, wPriceTemp + 2
	ld de, wPlayerMoney + 2
	ld c, $3
	predef SubBCDPredef
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	SetEvent EVENT_BOUGHT_MAGIKARP
	jr .done
.choseNo
	ld hl, MtMoonPokecenterText_49361
	jr .printText
.alreadyBoughtMagikarp
	ld hl, MtMoonPokecenterText_4936b
.printText
	call PrintText
.done
	ret

MtMoonPokecenterText_4935c:
	TX_FAR _MtMoonPokecenterText_4935c
	db "@"

MtMoonPokecenterText_49361:
	TX_FAR _MtMoonPokecenterText_49361
	db "@"

MtMoonPokecenterText_49366:
	TX_FAR _MtMoonPokecenterText_49366
	db "@"

MtMoonPokecenterText_4936b:
	TX_FAR _MtMoonPokecenterText_4936b
	db "@"
