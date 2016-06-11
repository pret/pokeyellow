RockTunnelPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

RockTunnelPokecenterTextPointers:
	dw RockTunnelHealNurseText
	dw RockTunnelPokecenterText2
	dw RockTunnelPokecenterText3
	dw RockTunnelTradeNurseText
	dw RockTunnelPokecenterText5

RockTunnelHealNurseText:
	TX_POKECENTER_NURSE

RockTunnelPokecenterText2:
	TX_FAR _RockTunnelPokecenterText2
	db "@"

RockTunnelPokecenterText3:
	TX_FAR _RockTunnelPokecenterText3
	db "@"

RockTunnelTradeNurseText:
	TX_CABLE_CLUB_RECEPTIONIST

RockTunnelPokecenterText5:
	TX_ASM
	callab PokecenterChanseyText
	jp TextScriptEnd
