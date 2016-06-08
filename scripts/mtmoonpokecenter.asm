MtMoonPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

MtMoonPokecenterTextPointers:
	dw MtMoonPokecenterText1
	dw MtMoonPokecenterText2
	dw MtMoonPokecenterText3
	dw MtMoonPokecenterText4
	dw MtMoonPokecenterText5
	dw MtMoonPokecenterText6
	dw MtMoonPokecenterText7

MtMoonPokecenterText1:
	TX_POKECENTER_NURSE

MtMoonPokecenterText2:
	TX_FAR _MtMoonPokecenterText1
	db "@"

MtMoonPokecenterText3:
	TX_FAR _MtMoonPokecenterText3
	db "@"

MtMoonPokecenterText4:
	TX_ASM
	callab Func_f218c
	jp TextScriptEnd

MtMoonPokecenterText5:
	TX_FAR _MtMoonPokecenterText5
	db "@"

MtMoonPokecenterText6:
	TX_CABLE_CLUB_RECEPTIONIST

MtMoonPokecenterText7:
	TX_ASM
	callab PokecenterChanseyText
	jp TextScriptEnd
