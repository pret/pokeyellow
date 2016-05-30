Museum2FScript: ; 5c317 (17:4317)
	call EnableAutoTextBoxDrawing
	ret

Museum2FTextPointers: ; 5c31a (17:431a)
	dw Museum2FText1
	dw Museum2FText2
	dw Museum2FText3
	dw Museum2FText4
	dw Museum2FText5
	dw Museum2FText6
	dw Museum2FText7

Museum2FText1: ; 5c328 (17:4328)
	TX_FAR _Museum2FText1
	db "@"

Museum2FText2: ; 5c32d (17:432d)
	TX_FAR _Museum2FText2
	db "@"

Museum2FText3: ; 5c332 (17:4332)
	TX_FAR _Museum2FText3
	db "@"

Museum2FText4: ; 5c337 (17:4337)
	TX_FAR _Museum2FText4
	db "@"

Museum2FText5: ; 5c33c (17:433c)
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

Museum2FText6: ; 5c341 (17:4341)
	TX_FAR _Museum2FText6
	db "@"

Museum2FText7: ; 5c346 (17:4346)
	TX_FAR _Museum2FText7
	db "@"
