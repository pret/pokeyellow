Func_f1ad2:
	CheckAndSetEvent EVENT_GOT_POTION_SAMPLE
	jr nz, .asm_1cada
	ld hl, Route1ViridianMartSampleText
	call PrintText
	lb bc, POTION, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, Route1Text_f1aff
	jr .asm_1cadd
.BagFull
	ld hl, Route1Text_f1b0a
	jr .asm_1cadd
.asm_1cada
	ld hl, Route1Text_f1b05
.asm_1cadd
	call PrintText
	ret

Route1ViridianMartSampleText:
	TX_FAR _Route1ViridianMartSampleText
	db "@"

Route1Text_f1aff:
	TX_FAR _Route1Text_1cae8
	TX_SFX_ITEM
	db "@"

Route1Text_f1b05:
	TX_FAR _Route1Text_1caee
	db "@"

Route1Text_f1b0a:
	TX_FAR _Route1Text_1caf3
	db "@"

Func_f1b0f:
	ld hl, Route1Text_f1b16
	call PrintText
	ret

Route1Text_f1b16:
	TX_FAR _Route1Text2
	db "@"

Func_f1b1b:
	ld hl, Route1Text_f1b22
	call PrintText
	ret

Route1Text_f1b22:
	TX_FAR _Route1Text3
	db "@"
