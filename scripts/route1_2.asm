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

Route1ViridianMartSampleText: ; 1cae3 (7:4ae3)
	TX_FAR _Route1ViridianMartSampleText
	db "@"

Route1Text_f1aff: ; 1cae8 (7:4ae8)
	TX_FAR _Route1Text_1cae8
	TX_SFX_ITEM
	db "@"

Route1Text_f1b05: ; 1caee (7:4aee)
	TX_FAR _Route1Text_1caee
	db "@"

Route1Text_f1b0a: ; 1caf3 (7:4af3)
	TX_FAR _Route1Text_1caf3
	db "@"

Func_f1b0f: ; 1caf8 (7:4af8)
	ld hl, Route1Text_f1b16
	call PrintText
	ret

Route1Text_f1b16:
	TX_FAR _Route1Text2
	db "@"

Func_f1b1b: ; 1cafd (7:4afd)
	ld hl, Route1Text_f1b22
	call PrintText
	ret

Route1Text_f1b22:
	TX_FAR _Route1Text3
	db "@"
