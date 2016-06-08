Museum2FScript:
	call EnableAutoTextBoxDrawing
	ret

Museum2FTextPointers:
	dw Museum2FText1
	dw Museum2FText2
	dw Museum2FText3
	dw Museum2FText4
	dw Museum2FText5
	dw Museum2FText6
	dw Museum2FText7

Museum2FText1:
	TX_FAR _Museum2FText1
	db "@"

Museum2FText2:
	TX_FAR _Museum2FText2
	db "@"

Museum2FText3:
	TX_FAR _Museum2FText3
	db "@"

Museum2FText4:
	TX_FAR _Museum2FText4
	db "@"

Museum2FText5:
	TX_ASM
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
	TX_FAR _Museum2FText5
	db "@"

Museum2FText_5c213:
	TX_FAR _Museum2FPikachuText1
	db "@"

Museum2FText_5c218:
	TX_FAR _Museum2FPikachuText2
	db "@"

Museum2FText6:
	TX_FAR _Museum2FText6
	db "@"

Museum2FText7:
	TX_FAR _Museum2FText7
	db "@"
