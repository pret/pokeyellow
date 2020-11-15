CeladonDiner_Script:
	call EnableAutoTextBoxDrawing
	ret

CeladonDiner_TextPointers:
	dw CeladonDinerText1
	dw CeladonDinerText2
	dw CeladonDinerText3
	dw CeladonDinerText4
	dw CeladonDinerText5

CeladonDinerText1:
	text_far _CeladonDinerText1
	text_end

CeladonDinerText2:
	text_far _CeladonDinerText2
	text_end

CeladonDinerText3:
	text_far _CeladonDinerText3
	text_end

CeladonDinerText4:
	text_far _CeladonDinerText4
	text_end

CeladonDinerText5:
	text_asm
	callfar Func_f1f31
	jp TextScriptEnd
