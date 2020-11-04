Museum2F_Script:
	call EnableAutoTextBoxDrawing
	ret

Museum2F_TextPointers:
	dw Museum2FText1
	dw Museum2FText2
	dw Museum2FText3
	dw Museum2FText4
	dw Museum2FText5
	dw Museum2FText6
	dw Museum2FText7

Museum2FText1:
	text_far _Museum2FText1
	text_end

Museum2FText2:
	text_far _Museum2FText2
	text_end

Museum2FText3:
	text_far _Museum2FText3
	text_end

Museum2FText4:
	text_far _Museum2FText4
	text_end

Museum2FText5:
	text_asm
	ld a, [wd472]
	bit 7, a
	jr nz, .asm_5c1f6
	ld hl, Museum2FText_5c20e
	call PrintText
	jr .asm_5c20b

.asm_5c1f6
	ld a, [wPikachuHappiness]
	cp 101
	jr c, .asm_5c205
	ld hl, Museum2FText_5c218
	call PrintText
	jr .asm_5c20b

.asm_5c205
	ld hl, Museum2FText_5c213
	call PrintText
.asm_5c20b
	jp TextScriptEnd

Museum2FText_5c20e:
	text_far _Museum2FText5
	text_end

Museum2FText_5c213:
	text_far _Museum2FPikachuText1
	text_end

Museum2FText_5c218:
	text_far _Museum2FPikachuText2
	text_end

Museum2FText6:
	text_far _Museum2FText6
	text_end

Museum2FText7:
	text_far _Museum2FText7
	text_end
