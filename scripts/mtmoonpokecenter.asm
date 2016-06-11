MtMoonPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

MtMoonPokecenterTextPointers:
	dw MtMoonHealNurseText
	dw MtMoonPokecenterText2
	dw MtMoonPokecenterText3
	dw MagikarpSalesmanText
	dw MtMoonPokecenterText5
	dw MtMoonTradeNurseText
	dw MtMoonPokecenterText7

MtMoonHealNurseText:
	TX_POKECENTER_NURSE

MtMoonPokecenterText2:
	TX_FAR _MtMoonPokecenterText1
	db "@"

MtMoonPokecenterText3:
	TX_FAR _MtMoonPokecenterText3
	db "@"

MagikarpSalesmanText:
	TX_ASM
	callab MagikarpSalesman
	jp TextScriptEnd

MtMoonPokecenterText5:
	TX_FAR _MtMoonPokecenterText5
	db "@"

MtMoonTradeNurseText:
	TX_CABLE_CLUB_RECEPTIONIST

MtMoonPokecenterText7:
	TX_ASM
	callab PokecenterChanseyText
	jp TextScriptEnd
