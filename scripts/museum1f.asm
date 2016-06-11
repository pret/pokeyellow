Museum1FScript:
	ld a, $1
	ld [wAutoTextBoxDrawingControl], a
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, Museum1FScriptPointers
	ld a, [wMuseum1FCurScript]
	call JumpTable
	ret

Museum1FScriptPointers:
	dw Museum1FScript0
	dw Museum1FScript1

Museum1FScript0:
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

Museum1FScript1:
	ret

Museum1FTextPointers:
	dw Museum1FText1
	dw Museum1FText2
	dw Museum1FText3
	dw Museum1FText4
	dw Museum1FText5

Museum1FText1:
	TX_ASM
	callba Func_f1c1b
	jp TextScriptEnd

Museum1FText2:
	TX_ASM
	callba Func_f1d2a
	jp TextScriptEnd

Museum1FText3:
	TX_ASM
	callba Func_f1d36
	jp TextScriptEnd

Museum1FText4:
	TX_ASM
	callba Func_f1d80
	jp TextScriptEnd

Museum1FText5:
	TX_ASM
	callba Func_f1d8c
	jp TextScriptEnd
