Func_f1c1b:
	ld a, [wYCoord]
	cp $4
	jr nz, .asm_f1c2c
	ld a, [wXCoord]
	cp $d
	jp z, .asm_f1cde
	jr .asm_f1c48

.asm_f1c2c
	cp $3
	jr nz, .asm_f1c38
	ld a, [wXCoord]
	cp a, $c
	jp z, .asm_f1cde
.asm_f1c38
	CheckEvent EVENT_BOUGHT_MUSEUM_TICKET
	jr nz, .asm_f1c4f
	ld hl, Museum1FText_f1d20
	call PrintText
	jp .asm_f1cfc

.asm_f1c48
	CheckEvent EVENT_BOUGHT_MUSEUM_TICKET
	jr z, .asm_f1c58
.asm_f1c4f
	ld hl, Museum1FText_f1d25
	call PrintText
	jp .asm_f1cfc

.asm_f1c58
	ld a, $13
	ld [wTextBoxID], a
	call DisplayTextBoxID
	xor a
	ld [hJoyHeld], a
	ld hl, Museum1FText_f1d02
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_f1cbf
	xor a
	ld [hMoney], a
	ld [hMoney + 1], a
	ld a, $50
	ld [hMoney + 2], a
	call HasEnoughMoney
	jr nc, .asm_f1c89
	ld hl, Museum1FText_f1d0c
	call PrintText
	jp .asm_f1cbf

.asm_f1c89
	ld hl, Museum1FText_f1d07
	call PrintText
	SetEvent EVENT_BOUGHT_MUSEUM_TICKET
	xor a
	ld [wPriceTemp], a
	ld [wPriceTemp + 1], a
	ld a, $50
	ld [wPriceTemp + 2], a
	ld hl, wPriceTemp + 2
	ld de, wPlayerMoney + 2
	ld c, 3
	predef SubBCDPredef
	ld a, $13
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld a, SFX_PURCHASE
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	jr .asm_f1cd7

.asm_f1cbf
	ld hl, Museum1FText_f1cfd
	call PrintText
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	call StartSimulatingJoypadStates
	call UpdateSprites
	jr .asm_f1cfc

.asm_f1cd7
	ld a, $1
	ld [wMuseum1FCurScript], a
	jr .asm_f1cfc

.asm_f1cde
	ld hl, Museum1FText_f1d11
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	cp 0
	jr nz, .asm_f1cf6
	ld hl, Museum1FText_f1d16
	call PrintText
	jr .asm_f1cfc

.asm_f1cf6
	ld hl, Museum1FText_f1d1b
	call PrintText
.asm_f1cfc
	ret

Museum1FText_f1cfd:
	TX_FAR _Museum1FText_5c21a
	db "@"

Museum1FText_f1d02:
	TX_FAR _Museum1FText_5c21f
	db "@"

Museum1FText_f1d07:
	TX_FAR _Museum1FText_5c224
	db "@"

Museum1FText_f1d0c:
	TX_FAR _Museum1FText_5c229
	db "@"

Museum1FText_f1d11:
	TX_FAR _Museum1FText_5c22e
	db "@"

Museum1FText_f1d16:
	TX_FAR _Museum1FText_5c233
	db "@"

Museum1FText_f1d1b:
	TX_FAR _Museum1FText_5c238
	db "@"

Museum1FText_f1d20:
	TX_FAR _Museum1FText_5c23d
	db "@"

Museum1FText_f1d25:
	TX_FAR _Museum1FText_5c242
	db "@"

Func_f1d2a:
	ld hl, Museum1FText_f1d31
	call PrintText
	ret

Museum1FText_f1d31:
	TX_FAR _Museum1FText_5c251
	db "@"

Func_f1d36:
	CheckEvent EVENT_GOT_OLD_AMBER
	jr nz, .asm_f1d64
	ld hl, Museum1FText_f1d6b
	call PrintText
	lb bc, OLD_AMBER, 1
	call GiveItem
	jr nc, .asm_f1d5f
	SetEvent EVENT_GOT_OLD_AMBER
	ld a, HS_OLD_AMBER
	ld [wMissableObjectIndex], a
	predef HideObject
	ld hl, Museum1FText_f1d70
	jr .asm_f1d67

.asm_f1d5f
	ld hl, Museum1FText_f1d7b
	jr .asm_f1d67

.asm_f1d64
	ld hl, Museum1FText_f1d76
.asm_f1d67
	call PrintText
	ret

Museum1FText_f1d6b:
	TX_FAR _Museum1FText_5c28e
	db "@"

Museum1FText_f1d70:
	TX_FAR _ReceivedOldAmberText
	TX_SFX_ITEM
	db "@"

Museum1FText_f1d76:
	TX_FAR _Museum1FText_5c299
	db "@"

Museum1FText_f1d7b:
	TX_FAR _Museum1FText_5c29e
	db "@"

Func_f1d80:
	ld hl, Museum1FText_f1d87
	call PrintText
	ret

Museum1FText_f1d87:
	TX_FAR _Museum1FText_5c2ad
	db "@"

Func_f1d8c:
	ld hl, Museum1FText_f1d93
	call PrintText
	ret

Museum1FText_f1d93:
	TX_FAR _Museum1FText_5c2bc
	db "@"
