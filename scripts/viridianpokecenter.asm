ViridianPokeCenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

ViridianPokecenterTextPointers:
	dw ViridianPokeCenterText1
	dw ViridianPokeCenterText2
	dw ViridianPokeCenterText3
	dw ViridianPokeCenterText4
	dw ViridianPokeCenterText5

ViridianPokeCenterText1:
	TX_POKECENTER_NURSE

ViridianPokeCenterText2:
	TX_FAR _ViridianPokeCenterText1
	db "@"

ViridianPokeCenterText3:
	TX_FAR _ViridianPokeCenterText3
	db "@"

ViridianPokeCenterText4:
	TX_CABLE_CLUB_RECEPTIONIST

ViridianPokeCenterText5:
	TX_ASM
	callab PokecenterChanseyText
	jp TextScriptEnd
