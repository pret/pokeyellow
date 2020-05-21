Func_f1f31:
	CheckEvent EVENT_GOT_COIN_CASE
	jr nz, .asm_eb14d
	ld hl, CeladonDinerText_491a7
	call PrintText
	lb bc, COIN_CASE, 1
	call GiveItem
	jr nc, .BagFull
	SetEvent EVENT_GOT_COIN_CASE
	ld hl, ReceivedCoinCaseText
	call PrintText
	jr .asm_68b61
.BagFull
	ld hl, CoinCaseNoRoomText
	call PrintText
	jr .asm_68b61
.asm_eb14d
	ld hl, CeladonDinerText_491b7
	call PrintText
.asm_68b61
	ret

CeladonDinerText_491a7:
	TX_FAR _CeladonDinerText_491a7
	db "@"

ReceivedCoinCaseText:
	TX_FAR _ReceivedCoinCaseText
	TX_SFX_KEY_ITEM
	db "@"

CoinCaseNoRoomText:
	TX_FAR _CoinCaseNoRoomText
	db "@"

CeladonDinerText_491b7:
	TX_FAR _CeladonDinerText_491b7
	db "@"
