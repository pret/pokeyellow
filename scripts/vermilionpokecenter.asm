VermilionPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

VermilionPokecenterTextPointers:
	dw VermilionPokecenterText1
	dw VermilionPokecenterText2
	dw VermilionPokecenterText3
	dw VermilionPokecenterText4
	dw VermilionPokecenterText5

VermilionPokecenterText1:
	TX_POKECENTER_NURSE

VermilionPokecenterText2:
	TX_FAR _VermilionPokecenterText1
	db "@"

VermilionPokecenterText3:
	TX_FAR _VermilionPokecenterText3
	db "@"

VermilionPokecenterText4:
	TX_CABLE_CLUB_RECEPTIONIST

VermilionPokecenterText5:
	TX_ASM
	callab PokecenterChanseyText
	jp TextScriptEnd
