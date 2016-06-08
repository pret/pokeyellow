FuchsiaPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

FuchsiaPokecenterTextPointers:
	dw FuchsiaPokecenterText1
	dw FuchsiaPokecenterText2
	dw FuchsiaPokecenterText3
	dw FuchsiaPokecenterText4
	dw FuchsiaPokecenterText5

FuchsiaPokecenterText1:
	db $ff

FuchsiaPokecenterText2:
	TX_FAR _FuchsiaPokecenterText1
	db "@"

FuchsiaPokecenterText3:
	TX_FAR _FuchsiaPokecenterText3
	db "@"

FuchsiaPokecenterText4:
	db $f6

FuchsiaPokecenterText5:
	TX_ASM
	callab PokecenterChanseyText
	jp TextScriptEnd
