PewterPokecenterScript: ; 5c587 (17:4587)
	ld hl, wPreventBlackout
	set 7, [hl]
	call Serial_TryEstablishingExternallyClockedConnection
	call EnableAutoTextBoxDrawing
	ret

PewterPokecenterTextPointers: ; 5c58d (17:458d)
	dw PewterPokecenterText1
	dw PewterPokecenterText2
	dw PewterPokecenterText3
	dw PewterPokecenterText4
	dw PewterPokecenterText5
	dw PewterPokecenterText6

PewterPokecenterText1: ; 5c595 (17:4595)
	db $ff

PewterPokecenterText2: ; 5c596 (17:4596)
	TX_FAR _PewterPokecenterText1
	db "@"

PewterPokecenterText3: ; 5c59b (17:459b)
	TX_ASM
	callba Func_f1da4
	jp TextScriptEnd

PewterPokecenterText4: ; 5c60c (17:460c)
	db $f6

PewterPokecenterText5: ; 5c603 (17:4603)
	TX_ASM
	callba Func_f1d98
	jp TextScriptEnd

PewterPokecenterText6:
	TX_ASM
	callab Func_f0f12
	jp TextScriptEnd
