Museum1F_Script:
	ld a, TRUE
	ld [wAutoTextBoxDrawingControl], a
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, Museum1F_ScriptPointers
	ld a, [wMuseum1FCurScript]
	call CallFunctionInTable
	ret

Museum1F_ScriptPointers:
	dw Museum1FScript0
	dw Museum1FScript1

Museum1FScript0:
	ld a, [wYCoord]
	cp 4
	ret nz
	ld a, [wXCoord]
	cp 9
	jr z, .asm_5c120
	ld a, [wXCoord]
	cp 10
	ret nz
.asm_5c120
	xor a
	ldh [hJoyHeld], a
	ld a, $1
	ldh [hSpriteIndexOrTextID], a
	jp DisplayTextID

Museum1FScript1:
	ret

Museum1F_TextPointers:
	dw Museum1FText1
	dw Museum1FText2
	dw Museum1FText3
	dw Museum1FText4
	dw Museum1FText5

Museum1FText1:
	text_asm
	farcall Func_f1c1b
	jp TextScriptEnd

Museum1FText2:
	text_asm
	farcall Func_f1d2a
	jp TextScriptEnd

Museum1FText3:
	text_asm
	farcall Func_f1d36
	jp TextScriptEnd

Museum1FText4:
	text_asm
	farcall Func_f1d80
	jp TextScriptEnd

Museum1FText5:
	text_asm
	farcall Func_f1d8c
	jp TextScriptEnd
