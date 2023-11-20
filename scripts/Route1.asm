Route1_Script:
	call EnableAutoTextBoxDrawing
	ret

Route1_TextPointers:
	def_text_pointers
	dw_const Route1Youngster1Text, TEXT_ROUTE1_YOUNGSTER1
	dw_const Route1Youngster2Text, TEXT_ROUTE1_YOUNGSTER2
	dw_const Route1SignText,       TEXT_ROUTE1_SIGN

Route1Youngster1Text:
	text_asm
	farcall Route1PrintYoungster1Text
	jp TextScriptEnd

Route1Youngster2Text:
	text_asm
	farcall Route1PrintYoungster2Text
	jp TextScriptEnd

Route1SignText:
	text_asm
	farcall Route1PrintSignText
	jp TextScriptEnd
