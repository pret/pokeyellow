ViridianSchoolHouse_Script:
	call EnableAutoTextBoxDrawing
	ret

ViridianSchoolHouse_TextPointers:
	dw SchoolText1
	dw SchoolText2
	dw SchoolText3

SchoolText1:
	text_far _SchoolText1
	text_end

SchoolText2:
	text_asm
	farcall Func_f1c0f
	jp TextScriptEnd

SchoolText3:
	text_asm
	farcall Func_f1c03
	jp TextScriptEnd
