CeladonMansion3FPrintGameProgramPCText::
	ld hl, .text
	call PrintText
	ret

.text
	text_far _CeladonMansion3FGameProgramPCText
	text_end

CeladonMansion3FPrintPlayingGamePCText::
	ld hl, .text
	call PrintText
	ret

.text
	text_far _CeladonMansion3FPlayingGamePCText
	text_end

CeladonMansion3FPrintGameScriptPCText::
	ld hl, .text
	call PrintText
	ret

.text
	text_far _CeladonMansion3FGameScriptPCText
	text_end

CeladonMansion3FPrintDevRoomSignText::
	ld hl, .text
	call PrintText
	ret

.text
	text_far _CeladonMansion3FDevRoomSignText
	text_end
