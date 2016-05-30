Route1Script: ; 1caaf (7:4aaf)
	call EnableAutoTextBoxDrawing
	ret

Route1TextPointers: ; 1cab2 (7:4ab2)
	dw Route1Text1
	dw Route1Text2
	dw Route1Text3

Route1Text1: ; 1cab8 (7:4ab8)
	TX_ASM
	callba Func_f1ad2
	jp TextScriptEnd

Route1Text2: ; 1caf8 (7:4af8)
	TX_ASM
	callba Func_f1b0f
	jp TextScriptEnd

Route1Text3: ; 1cafd (7:4afd)
	TX_ASM
	callba Func_f1b1b
	jp TextScriptEnd
