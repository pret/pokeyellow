LavenderPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

LavenderPokecenterTextPointers:
	dw LavenderPokecenterText1
	dw LavenderPokecenterText2
	dw LavenderPokecenterText3
	dw LavenderPokecenterText4
	dw LavenderPokecenterText5

LavenderPokecenterText4:
	TX_CABLE_CLUB_RECEPTIONIST

LavenderPokecenterText1:
	TX_POKECENTER_NURSE

LavenderPokecenterText2:
	TX_FAR _LavenderPokecenterText1
	db "@"

LavenderPokecenterText3:
	TX_FAR _LavenderPokecenterText3
	db "@"

LavenderPokecenterText5:
	TX_ASM
	callab PokecenterChanseyText
	jp TextScriptEnd
