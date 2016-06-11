PewterMartScript:
	call EnableAutoTextBoxDrawing
	ld a, $1
	ld [wAutoTextBoxDrawingControl], a
	ret

PewterMartTextPointers:
	dw PewterMartText1
	dw PewterMartText2
	dw PewterMartText3

PewterMartText2:
	TX_ASM
	ld hl, PewterMartText_74cc6
	call PrintText
	jp TextScriptEnd

PewterMartText_74cc6:
	TX_FAR _PewterMartText_74cc6
	db "@"

PewterMartText3:
	TX_ASM
	ld hl, PewterMartText_74cd5
	call PrintText
	jp TextScriptEnd

PewterMartText_74cd5:
	TX_FAR _PewterMartText_74cd5
	db "@"
