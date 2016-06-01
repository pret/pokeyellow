LavenderPokecenterScript: ; 5c8da (17:48da)
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

LavenderPokecenterTextPointers: ; 5c8e0 (17:48e0)
	dw LavenderPokecenterText1
	dw LavenderPokecenterText2
	dw LavenderPokecenterText3
	dw LavenderPokecenterText4
	dw LavenderPokecenterText5

LavenderPokecenterText4: ; 5c8e8 (17:48e8)
	TX_CABLE_CLUB_RECEPTIONIST

LavenderPokecenterText1: ; 5c8e9 (17:48e9)
	TX_POKECENTER_NURSE

LavenderPokecenterText2: ; 5c8ea (17:48ea)
	TX_FAR _LavenderPokecenterText1
	db "@"

LavenderPokecenterText3: ; 5c8ef (17:48ef)
	TX_FAR _LavenderPokecenterText3
	db "@"

LavenderPokecenterText5:
	TX_ASM
	callab PokecenterChanseyText
	jp TextScriptEnd
