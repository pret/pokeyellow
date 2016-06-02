SaffronPokecenterScript: ; 5d535 (17:5535)
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

SaffronPokecenterTextPointers: ; 5d53b (17:553b)
	dw SaffronPokecenterText1
	dw SaffronPokecenterText2
	dw SaffronPokecenterText3
	dw SaffronPokecenterText4
	dw SaffronPokecenterText5

SaffronPokecenterText1: ; 5d543 (17:5543)
	TX_POKECENTER_NURSE

SaffronPokecenterText2: ; 5d544 (17:5544)
	TX_FAR _SaffronPokecenterText1
	db "@"

SaffronPokecenterText3: ; 5d549 (17:5549)
	TX_FAR _SaffronPokecenterText3
	db "@"

SaffronPokecenterText4: ; 5d54e (17:554e)
	TX_CABLE_CLUB_RECEPTIONIST

SaffronPokecenterText5:
	TX_ASM
	callab PokecenterChanseyText
	jp TextScriptEnd
