CeladonPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

CeladonPokecenterTextPointers:
	dw CeladonPokecenterText1
	dw CeladonPokecenterText2
	dw CeladonPokecenterText3
	dw CeladonPokecenterText4
	dw CeladonPokecenterText5

CeladonPokecenterText4:
	TX_CABLE_CLUB_RECEPTIONIST

CeladonPokecenterText1:
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
