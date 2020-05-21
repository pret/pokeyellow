ViridianSchoolHouse_Script:
	call EnableAutoTextBoxDrawing
	ret

ViridianSchoolHouse_TextPointers:
	dw SchoolText1
	dw SchoolText2
	dw SchoolText3

SchoolText1:
	TX_FAR _SchoolText1
	db "@"

SchoolText2:
	TX_ASM
	callba Func_f1c0f
	jp TextScriptEnd

SchoolText3:
	TX_ASM
	callba Func_f1c03
	jp TextScriptEnd
