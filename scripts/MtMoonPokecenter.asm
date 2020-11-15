MtMoonPokecenter_Script:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

MtMoonPokecenter_TextPointers:
	dw MtMoonHealNurseText
	dw MtMoonPokecenterText2
	dw MtMoonPokecenterText3
	dw MagikarpSalesmanText
	dw MtMoonPokecenterText5
	dw MtMoonTradeNurseText
	dw MtMoonPokecenterText7

MtMoonHealNurseText:
	script_pokecenter_nurse

MtMoonPokecenterText2:
	text_far _MtMoonPokecenterText1
	text_end

MtMoonPokecenterText3:
	text_far _MtMoonPokecenterText3
	text_end

MagikarpSalesmanText:
	text_asm
	callfar MagikarpSalesman
	jp TextScriptEnd

MtMoonPokecenterText5:
	text_far _MtMoonPokecenterText5
	text_end

MtMoonTradeNurseText:
	script_cable_club_receptionist

MtMoonPokecenterText7:
	text_asm
	callfar PokecenterChanseyText
	jp TextScriptEnd
