Route2TradeHouse_Script:
	jp EnableAutoTextBoxDrawing

Route2TradeHouse_TextPointers:
	def_text_pointers
	dw_const Route2TradeHouseScientistText,  TEXT_ROUTE2TRADEHOUSE_SCIENTIST
	dw_const Route2TradeHouseGameboyKidText, TEXT_ROUTE2TRADEHOUSE_GAMEBOY_KID

Route2TradeHouseScientistText:
	text_far _Route2TradeHouseScientistText
	text_end

Route2TradeHouseGameboyKidText:
	text_asm
	ld a, [wUnusedObtainedBadges]
	bit BIT_NUZLOPTIONS_ALL_151_POKEMON, a
	jr z, .standard
	ld a, TRADE_FOR_JACKIE
	jr .doTrade
.standard
	ld a, TRADE_FOR_MILES
.doTrade
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
	jp TextScriptEnd
