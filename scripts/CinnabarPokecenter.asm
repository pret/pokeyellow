CinnabarPokecenter_Script:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

CinnabarPokecenter_TextPointers:
	dw CinnabarHealNurseText
	dw CinnabarPokecenterText2
	dw CinnabarPokecenterText3
	dw CinnabarTradeNurseText
	dw CinnabarPokecenterText5

CinnabarHealNurseText:
	script_pokecenter_nurse

CinnabarPokecenterText2:
	text_far _CinnabarPokecenterText2
	text_end

CinnabarPokecenterText3:
	text_far _CinnabarPokecenterText3
	text_end

CinnabarTradeNurseText:
	script_cable_club_receptionist

CinnabarPokecenterText5:
	text_asm
	callfar PokecenterChanseyText
	jp TextScriptEnd
