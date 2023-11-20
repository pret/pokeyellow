RedsHouse1F_Script:
	call EnableAutoTextBoxDrawing
	ret

RedsHouse1F_TextPointers:
	def_text_pointers
	dw_const RedsHouse1FMomText, TEXT_REDSHOUSE1F_MOM
	dw_const RedsHouse1FTVText,  TEXT_REDSHOUSE1F_TV

RedsHouse1FMomText:
	text_asm
	callfar RedsHouse1FPrintMomText
	jp TextScriptEnd

RedsHouse1FTVText:
	text_asm
	callfar RedsHouse1FPrintTVText
	jp TextScriptEnd
