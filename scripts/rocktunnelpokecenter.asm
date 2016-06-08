RockTunnelPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

RockTunnelPokecenterTextPointers:
	dw RockTunnelPokecenterText1
	dw RockTunnelPokecenterText2
	dw RockTunnelPokecenterText3
	dw RockTunnelPokecenterText4
	dw RockTunnelPokecenterText5

RockTunnelPokecenterText1:
	TX_POKECENTER_NURSE

RockTunnelPokecenterText2:
	TX_FAR _RockTunnelPokecenterText1
	db "@"

RockTunnelPokecenterText3:
	TX_FAR _RockTunnelPokecenterText3
	db "@"

RockTunnelPokecenterText4:
	TX_CABLE_CLUB_RECEPTIONIST

RockTunnelPokecenterText5:
	TX_ASM
	callab PokecenterChanseyText
	jp TextScriptEnd
