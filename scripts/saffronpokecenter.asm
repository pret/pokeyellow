SaffronPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

SaffronPokecenterTextPointers:
	dw SaffronPokecenterText1
	dw SaffronPokecenterText2
	dw SaffronPokecenterText3
	dw SaffronPokecenterText4
	dw SaffronPokecenterText5

SaffronPokecenterText1:
	TX_POKECENTER_NURSE

SaffronPokecenterText2:
	TX_FAR _SaffronPokecenterText1
	db "@"

SaffronPokecenterText3:
	TX_FAR _SaffronPokecenterText3
	db "@"

SaffronPokecenterText4:
	TX_CABLE_CLUB_RECEPTIONIST

SaffronPokecenterText5:
	TX_ASM
	callab PokecenterChanseyText
	jp TextScriptEnd
