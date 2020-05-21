RedsHouse1F_Script:
	call EnableAutoTextBoxDrawing
	ret

RedsHouse1F_TextPointers:
	dw RedsHouse1FText1
	dw RedsHouse1FText2

RedsHouse1FText1: ; Mom
	TX_ASM
	callab Func_f1b73
	jp TextScriptEnd

RedsHouse1FText2: ; TV
	TX_ASM
	callab Func_f1bc4
	jp TextScriptEnd
