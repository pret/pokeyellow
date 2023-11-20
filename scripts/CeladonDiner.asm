CeladonDiner_Script:
	call EnableAutoTextBoxDrawing
	ret

CeladonDiner_TextPointers:
	def_text_pointers
	dw_const CeladonDinerCookText,            TEXT_CELADONDINER_COOK
	dw_const CeladonDinerMiddleAgedWomanText, TEXT_CELADONDINER_MIDDLE_AGED_WOMAN
	dw_const CeladonDinerMiddleAgedManText,   TEXT_CELADONDINER_MIDDLE_AGED_MAN
	dw_const CeladonDinerFisherText,          TEXT_CELADONDINER_FISHER
	dw_const CeladonDinerGymGuideText,        TEXT_CELADONDINER_GYM_GUIDE

CeladonDinerCookText:
	text_far _CeladonDinerCookText
	text_end

CeladonDinerMiddleAgedWomanText:
	text_far _CeladonDinerMiddleAgedWomanText
	text_end

CeladonDinerMiddleAgedManText:
	text_far _CeladonDinerMiddleAgedManText
	text_end

CeladonDinerFisherText:
	text_far _CeladonDinerFisherText
	text_end

CeladonDinerGymGuideText:
	text_asm
	callfar CeladonDinerPrintGymGuideText
	jp TextScriptEnd
