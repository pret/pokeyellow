CeruleanPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

CeruleanPokecenterTextPointers:
	dw CeruleanPokecenterText1
	dw CeruleanPokecenterText2
	dw CeruleanPokecenterText3
	dw CeruleanPokecenterText4
	dw CeruleanPokecenterText5

CeruleanPokecenterText4:
	TX_CABLE_CLUB_RECEPTIONIST

CeruleanPokecenterText1:
	TX_POKECENTER_NURSE

CeruleanPokecenterText2:
	TX_FAR _CeruleanPokecenterText2
	db "@"

CeruleanPokecenterText3:
	TX_FAR _CeruleanPokecenterText3
	db "@"

CeruleanPokecenterText5:
	TX_ASM
	callab PokecenterChanseyText
	jp TextScriptEnd
