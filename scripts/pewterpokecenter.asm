PewterPokecenterScript:
	ld hl, wd492
	set 7, [hl]
	call Serial_TryEstablishingExternallyClockedConnection
	call EnableAutoTextBoxDrawing
	ret

PewterPokecenterTextPointers:
	dw PewterHealNurseText
	dw PewterPokecenterText2
	dw PewterJigglypuffText
	dw PewterTradeNurseText
	dw PewterPokecenterText5
	dw PewterPokecenterText6

PewterHealNurseText:
	TX_POKECENTER_NURSE

PewterPokecenterText2:
	TX_FAR _PewterPokecenterText2
	db "@"

PewterJigglypuffText:
	TX_ASM
	callba PewterJigglypuff
	jp TextScriptEnd

PewterTradeNurseText:
	TX_CABLE_CLUB_RECEPTIONIST

PewterPokecenterText5:
	TX_ASM
	callba Func_f1d98
	jp TextScriptEnd

PewterPokecenterText6:
	TX_ASM
	callab PokecenterChanseyText
	jp TextScriptEnd
