CinnabarLabTradeRoom_Script:
	jp EnableAutoTextBoxDrawing

CinnabarLabTradeRoom_TextPointers:
	def_text_pointers
	dw_const CinnabarLabTradeRoomSuperNerdText, TEXT_CINNABARLABTRADEROOM_SUPER_NERD
	dw_const CinnabarLabTradeRoomGrampsText,    TEXT_CINNABARLABTRADEROOM_GRAMPS
	dw_const CinnabarLabTradeRoomBeautyText,    TEXT_CINNABARLABTRADEROOM_BEAUTY

CinnabarLabTradeRoomSuperNerdText:
	text_far _CinnabarLabTradeRoomSuperNerdText
	text_end

CinnabarLabTradeRoomGrampsText:
	text_asm
	ld a, [wUnusedObtainedBadges]
	bit BIT_NUZLOPTIONS_ALL_151_POKEMON, a
	jr z, .standard
	ld a, TRADE_FOR_ROCKY
	jr CinnabarLabTradeRoomDoTrade
.standard
	ld a, TRADE_FOR_BUFFY
	jr CinnabarLabTradeRoomDoTrade

CinnabarLabTradeRoomBeautyText:
	text_asm
	ld a, [wUnusedObtainedBadges]
	bit BIT_NUZLOPTIONS_ALL_151_POKEMON, a
	jr z, .standard
	ld a, TRADE_FOR_TOSHIO
	jr CinnabarLabTradeRoomDoTrade
.standard
	ld a, TRADE_FOR_CEZANNE
CinnabarLabTradeRoomDoTrade:
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
	jp TextScriptEnd
