CinnabarPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

CinnabarPokecenterTextPointers:
	dw CinnabarPokecenterText1
	dw CinnabarPokecenterText2
	dw CinnabarPokecenterText3
	dw CinnabarPokecenterText4
	dw CinnabarPokecenterText5

CinnabarPokecenterText1:
	TX_POKECENTER_NURSE

CinnabarPokecenterText2:
	TX_FAR _CinnabarPokecenterText1
	db "@"

CinnabarPokecenterText3:
	TX_FAR _CinnabarPokecenterText3
	db "@"

CinnabarPokecenterText4:
	TX_CABLE_CLUB_RECEPTIONIST

CinnabarPokecenterText5:
	TX_ASM
	callab PokecenterChanseyText
	jp TextScriptEnd
