PewterPokecenterScript:
	ld hl, wd492
	set 7, [hl]
	call Serial_TryEstablishingExternallyClockedConnection
	call EnableAutoTextBoxDrawing
	ret

PewterPokecenterTextPointers:
	dw PewterPokecenterText1
	dw PewterPokecenterText2
	dw PewterPokecenterText3
	dw PewterPokecenterText4
	dw PewterPokecenterText5
	dw PewterPokecenterText6

PewterPokecenterText1:
	TX_POKECENTER_NURSE

PewterPokecenterText2:
	TX_FAR _PewterPokecenterText1
	db "@"

PewterPokecenterText3:
	TX_ASM
	callba Func_f1da4
	jp TextScriptEnd

PewterPokecenterText4:
	TX_CABLE_CLUB_RECEPTIONIST

PewterPokecenterText5:
	TX_ASM
	callba Func_f1d98
	jp TextScriptEnd

PewterPokecenterText6:
	TX_ASM
	callab PokecenterChanseyText
	jp TextScriptEnd
