CeladonPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

CeladonPokecenterTextPointers:
	dw CeladonHealNurseText
	dw CeladonPokecenterText2
	dw CeladonPokecenterText3
	dw CeladonTradeNurseText
	dw CeladonPokecenterText5

CeladonTradeNurseText:
	TX_CABLE_CLUB_RECEPTIONIST

CeladonHealNurseText:
	TX_POKECENTER_NURSE

CeladonPokecenterText2:
	TX_FAR _CeladonPokecenterText2
	db "@"

CeladonPokecenterText3:
	TX_FAR _CeladonPokecenterText3
	db "@"

CeladonPokecenterText5:
	TX_ASM
	callab PokecenterChanseyText
	jp TextScriptEnd
