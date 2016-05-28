SchoolScript: ; 1d54c (7:554c)
	call EnableAutoTextBoxDrawing
	ret

SchoolTextPointers: ; 1d54f (7:554f)
	dw SchoolText1
	dw SchoolText2
	dw SchoolText3

SchoolText1: ; 1d553 (7:5553)
	TX_FAR _SchoolText1
	db "@"

SchoolText2: ; 1d558 (7:5558)
	TX_ASM
	callba Func_f1c0f
	jp TextScriptEnd

SchoolText3: ; 1d558 (7:5558)
	TX_ASM
	callba Func_f1c03
	jp TextScriptEnd
