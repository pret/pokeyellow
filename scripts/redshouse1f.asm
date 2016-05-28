RedsHouse1FScript: ; 48168 (12:4168)
	call EnableAutoTextBoxDrawing
	ret

RedsHouse1FTextPointers: ; 4816b (12:416b)
	dw RedsHouse1FText1
	dw RedsHouse1FText2

RedsHouse1FText1: ; 4816f (12:416f) Mom
	TX_ASM
	callab Func_f1b73
	jp TextScriptEnd

RedsHouse1FText2: ; 0x481c6 TV
	TX_ASM
	callab Func_f1bc4
	jp TextScriptEnd
