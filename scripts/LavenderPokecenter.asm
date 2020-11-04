LavenderPokecenter_Script:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

LavenderPokecenter_TextPointers:
	dw LavenderHealNurseText
	dw LavenderPokecenterText2
	dw LavenderPokecenterText3
	dw LavenderTradeNurseText
	dw LavenderPokecenterText5

LavenderTradeNurseText:
	script_cable_club_receptionist

LavenderHealNurseText:
	script_pokecenter_nurse

LavenderPokecenterText2:
	text_far _LavenderPokecenterText2
	text_end

LavenderPokecenterText3:
	text_far _LavenderPokecenterText3
	text_end

LavenderPokecenterText5:
	text_asm
	callfar PokecenterChanseyText
	jp TextScriptEnd
