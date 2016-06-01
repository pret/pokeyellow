CeladonDinerScript: ; 49151 (12:5151)
	call EnableAutoTextBoxDrawing
	ret

CeladonDinerTextPointers: ; 49155 (12:5155)
	dw CeladonDinerText1
	dw CeladonDinerText2
	dw CeladonDinerText3
	dw CeladonDinerText4
	dw CeladonDinerText5

CeladonDinerText1: ; 4915f (12:515f)
	TX_FAR _CeladonDinerText1
	db "@"

CeladonDinerText2: ; 49164 (12:5164)
	TX_FAR _CeladonDinerText2
	db "@"

CeladonDinerText3: ; 49169 (12:5169)
	TX_FAR _CeladonDinerText3
	db "@"

CeladonDinerText4: ; 4916e (12:516e)
	TX_FAR _CeladonDinerText4
	db "@"

CeladonDinerText5: ; 49173 (12:5173)
	TX_ASM
	callab Func_f1f31
	jp TextScriptEnd
