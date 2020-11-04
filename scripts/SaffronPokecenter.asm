SaffronPokecenter_Script:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

SaffronPokecenter_TextPointers:
	dw SaffronHealNurseText
	dw SaffronPokecenterText2
	dw SaffronPokecenterText3
	dw SaffronTradeNurseText
	dw SaffronPokecenterText5

SaffronHealNurseText:
	script_pokecenter_nurse

SaffronPokecenterText2:
	text_far _SaffronPokecenterText2
	text_end

SaffronPokecenterText3:
	text_far _SaffronPokecenterText3
	text_end

SaffronTradeNurseText:
	script_cable_club_receptionist

SaffronPokecenterText5:
	text_asm
	callfar PokecenterChanseyText
	jp TextScriptEnd
