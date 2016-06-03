MtMoonPokecenterScript: ; 492cf (12:52cf)
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

MtMoonPokecenterTextPointers: ; 492d5 (12:52d5)
	dw MtMoonPokecenterText1
	dw MtMoonPokecenterText2
	dw MtMoonPokecenterText3
	dw MtMoonPokecenterText4
	dw MtMoonPokecenterText5
	dw MtMoonPokecenterText6
	dw MtMoonPokecenterText7

MtMoonPokecenterText1: ; 492e1 (12:52e1)
	TX_POKECENTER_NURSE

MtMoonPokecenterText2: ; 492e2 (12:52e2)
	TX_FAR _MtMoonPokecenterText1
	db "@"

MtMoonPokecenterText3: ; 492e7 (12:52e7)
	TX_FAR _MtMoonPokecenterText3
	db "@"

MtMoonPokecenterText4: ; 492ec (12:52ec)
	TX_ASM
	callab Func_f218c
	jp TextScriptEnd

MtMoonPokecenterText5: ; 49370 (12:5370)
	TX_FAR _MtMoonPokecenterText5
	db "@"

MtMoonPokecenterText6: ; 49375 (12:5375)
	TX_CABLE_CLUB_RECEPTIONIST

MtMoonPokecenterText7:
	TX_ASM
	callab PokecenterChanseyText
	jp TextScriptEnd
