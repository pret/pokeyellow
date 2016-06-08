LavenderMartScript:
	jp EnableAutoTextBoxDrawing

LavenderMartTextPointers:
	dw LavenderMartText1
	dw LavenderMartText2
	dw LavenderMartText3

LavenderMartText2:
	TX_FAR _LavenderMartText2
	db "@"

LavenderMartText3:
	TX_ASM
	CheckEvent EVENT_RESCUED_MR_FUJI
	jr nz, .asm_c88d4
	ld hl, LavenderMart_5c953
	call PrintText
	jr .asm_6d225
.asm_c88d4
	ld hl, LavenderMart_5c958
	call PrintText
.asm_6d225
	jp TextScriptEnd

LavenderMart_5c953:
	TX_FAR _LavenderMart_5c953
	db "@"

LavenderMart_5c958:
	TX_FAR _LavenderMart_5c958
	db "@"
