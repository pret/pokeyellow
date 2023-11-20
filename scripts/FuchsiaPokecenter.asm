FuchsiaPokecenter_Script:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

FuchsiaPokecenter_TextPointers:
	def_text_pointers
	dw_const FuchsiaPokecenterNurseText,            TEXT_FUCHSIAPOKECENTER_NURSE
	dw_const FuchsiaPokecenterRockerText,           TEXT_FUCHSIAPOKECENTER_ROCKER
	dw_const FuchsiaPokecenterCooltrainerFText,     TEXT_FUCHSIAPOKECENTER_COOLTRAINER_F
	dw_const FuchsiaPokecenterLinkReceptionistText, TEXT_FUCHSIAPOKECENTER_LINK_RECEPTIONIST
	dw_const FuchsiaPokecenterChanseyText,          TEXT_FUCHSIAPOKECENTER_CHANSEY

FuchsiaPokecenterNurseText:
	script_pokecenter_nurse

FuchsiaPokecenterRockerText:
	text_far _FuchsiaPokecenterRockerText
	text_end

FuchsiaPokecenterCooltrainerFText:
	text_far _FuchsiaPokecenterCooltrainerFText
	text_end

FuchsiaPokecenterLinkReceptionistText:
	script_cable_club_receptionist

FuchsiaPokecenterChanseyText:
	text_asm
	callfar PokecenterChanseyText
	jp TextScriptEnd
