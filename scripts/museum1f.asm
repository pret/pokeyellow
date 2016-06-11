Museum1FScript: ; 5c0f7 (17:40f7)
	ld a, $1
	ld [wAutoTextBoxDrawingControl], a
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, Museum1FScriptPointers
	ld a, [wMuseum1FCurScript]
	call JumpTable
	ret

Museum1FScriptPointers: ; 5c109 (17:4109)
	dw Museum1FScript0
	dw Museum1FScript1

Museum1FScript0: ; 5c10d (17:410d)
	ld a, [wYCoord]
	cp $4
	ret nz
	ld a, [wXCoord]
	cp $9
	jr z, .asm_5c120
	ld a, [wXCoord]
	cp $a
	ret nz
.asm_5c120
	xor a
	ld [hJoyHeld], a
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	jp DisplayTextID

Museum1FScript1: ; 5c12a (17:412a)
	ret

Museum1FTextPointers: ; 5c12b (17:412b)
	dw Museum1FText1
	dw Museum1FText2
	dw Museum1FText3
	dw Museum1FText4
	dw Museum1FText5

Museum1FText1: ; 5c135 (17:4135)
	TX_ASM
	callba Func_f1c1b
	jp TextScriptEnd

Museum1FText2: ; 5c135 (17:4135)
	TX_ASM
	callba Func_f1d2a
	jp TextScriptEnd

Museum1FText3: ; 5c135 (17:4135)
	TX_ASM
	callba Func_f1d36
	jp TextScriptEnd

Museum1FText4: ; 5c135 (17:4135)
	TX_ASM
	callba Func_f1d80
	jp TextScriptEnd

Museum1FText5: ; 5c135 (17:4135)
	TX_ASM
	callba Func_f1d8c
	jp TextScriptEnd
