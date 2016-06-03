ViridianPokeCenterScript: ; 4425d (11:425d)
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

ViridianPokecenterTextPointers: ; 44263 (11:4263)
	dw ViridianPokeCenterText1
	dw ViridianPokeCenterText2
	dw ViridianPokeCenterText3
	dw ViridianPokeCenterText4
	dw ViridianPokeCenterText5

ViridianPokeCenterText1: ; 4426b (11:426b)
	TX_POKECENTER_NURSE

ViridianPokeCenterText2: ; 4426c (11:426c)
	TX_FAR _ViridianPokeCenterText1
	db "@"

ViridianPokeCenterText3: ; 44271 (11:4271)
	TX_FAR _ViridianPokeCenterText3
	db "@"

ViridianPokeCenterText4: ; 44276 (11:4276)
	TX_CABLE_CLUB_RECEPTIONIST

ViridianPokeCenterText5:
	TX_ASM
	callab PokecenterChanseyText
	jp TextScriptEnd
