VendingMachineMenu: ; 74726 (1d:4726)
	ld hl, VendingMachineText1
	call PrintText
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld a, A_BUTTON | B_BUTTON
	ld [wMenuWatchedKeys], a
	ld a, 3
	ld [wMaxMenuItem], a
	ld a, 5
	ld [wTopMenuItemY], a
	ld a, 1
	ld [wTopMenuItemX], a
	ld hl, wd730
	set 6, [hl]
	coord hl, 0, 3
	lb bc, 8, 12
	call TextBoxBorder
	call UpdateSprites
	coord hl, 2, 5
	ld de, DrinkText
	call PlaceString
	coord hl, 9, 6
	ld de, DrinkPriceText
	call PlaceString
	ld hl, wd730
	res 6, [hl]
	call HandleMenuInput
	bit 1, a ; pressed B?
	jr nz, .notThirsty
	ld a, [wCurrentMenuItem]
	cp 3 ; chose Cancel?
	jr z, .notThirsty
	xor a
	ld [hMoney], a
	ld [hMoney + 2], a
	ld a, $2
	ld [hMoney + 1], a
	call HasEnoughMoney
	jr nc, .enoughMoney
	ld hl, VendingMachineText4
	jp PrintText
.enoughMoney
	call LoadVendingMachineItem
	ld a, [hVendingMachineItem]
	ld b, a
	ld c, 1
	call GiveItem
	jr nc, .BagFull

	ld b, 60 ; number of times to play the "brrrrr" sound
.playDeliverySound
	ld c, 2
	call DelayFrames
	push bc
	ld a, SFX_PUSH_BOULDER
	call PlaySound
	pop bc
	dec b
	jr nz, .playDeliverySound

	ld hl, VendingMachineText5
	call PrintText
	ld hl, hVendingMachinePrice + 2
	ld de, wPlayerMoney + 2
	ld c, $3
	predef SubBCDPredef
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	jp DisplayTextBoxID
.BagFull
	ld hl, VendingMachineText6
	jp PrintText
.notThirsty
	ld hl, VendingMachineText7
	jp PrintText

VendingMachineText1: ; 747de (1d:47de)
	TX_FAR _VendingMachineText1
	db "@"

DrinkText: ; 747e3 (1d:47e3)
	db   "FRESH WATER"
	next "SODA POP"
	next "LEMONADE"
	next "CANCEL@"

DrinkPriceText: ; 74808 (1d:4808)
	db   "¥200"
	next "¥300"
	next "¥350",$4E,"@"

VendingMachineText4: ; 74818 (1d:4818)
	TX_FAR _VendingMachineText4
	db "@"

VendingMachineText5: ; 7481d (1d:481d)
	TX_FAR _VendingMachineText5
	db "@"

VendingMachineText6: ; 74822 (1d:4822)
	TX_FAR _VendingMachineText6
	db "@"

VendingMachineText7: ; 74827 (1d:4827)
	TX_FAR _VendingMachineText7
	db "@"

LoadVendingMachineItem: ; 7482c (1d:482c)
	ld hl, VendingPrices
	ld a, [wCurrentMenuItem]
	add a
	add a
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hli]
	ld [hVendingMachineItem], a
	ld a, [hli]
	ld [hVendingMachinePrice], a
	ld a, [hli]
	ld [hVendingMachinePrice + 1], a
	ld a, [hl]
	ld [hVendingMachinePrice + 2], a
	ret

VendingPrices: ; 74845 (1d:4845)
	db FRESH_WATER
	money 200
	db SODA_POP
	money 300
	db LEMONADE
	money 350
