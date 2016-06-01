CeruleanPokecenterScript: ; 5c645 (17:4645)
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

CeruleanPokecenterTextPointers: ; 5c64b (17:464b)
	dw CeruleanPokecenterText1
	dw CeruleanPokecenterText2
	dw CeruleanPokecenterText3
	dw CeruleanPokecenterText4
	dw CeruleanPokecenterText5

CeruleanPokecenterText4: ; 5c653 (17:4653)
	TX_CABLE_CLUB_RECEPTIONIST

CeruleanPokecenterText1: ; 5c654 (17:4654)
	TX_POKECENTER_NURSE

CeruleanPokecenterText2: ; 5c655 (17:4655)
	TX_FAR _CeruleanPokecenterText1
	db "@"

CeruleanPokecenterText3: ; 5c65a (17:465a)
	TX_FAR _CeruleanPokecenterText3
	db "@"

CeruleanPokecenterText5:
	TX_ASM
	callab PokecenterChanseyText
	jp TextScriptEnd
