CeladonMansion1FPrintGrannyText::
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, CeladonMansion1Text_f1e96
	call PrintText
	callfar IsStarterPikachuAliveInOurParty
	ret nc
	ld hl, CeladonMansionText_f1e9c
	call PrintText
	ld a, $0
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call Func_f1ea2
	call PrintText
	ret

CeladonMansion1Text_f1e96:
	text_far _CeladonMansion1Text2
	text_waitbutton
	text_end

CeladonMansionText_f1e9c:
	text_far _CeladonMansion1Text6
	text_promptbutton
	text_end

Func_f1ea2:
	ld hl, PikachuHappinessThresholds_f1eb9
.asm_f1ea5
	ld a, [hli]
	inc hl
	and a
	jr z, .asm_f1eb5
	ld b, a
	ld a, [wPikachuHappiness]
	cp b
	jr c, .asm_f1eb5
	inc hl
	inc hl
	jr .asm_f1ea5

.asm_f1eb5
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

PikachuHappinessThresholds_f1eb9:
	dw   51, CeladonMansion1Text_f1ed5
	dw  101, CeladonMansion1Text_f1eda
	dw  131, CeladonMansion1Text_f1edf
	dw  161, CeladonMansion1Text_f1ee4
	dw  201, CeladonMansion1Text_f1ee9
	dw  255, CeladonMansion1Text_f1eee
	dw -256, CeladonMansion1Text_f1eee

CeladonMansion1Text_f1ed5:
	text_far _CeladonMansion1Text7
	text_end

CeladonMansion1Text_f1eda:
	text_far _CeladonMansion1Text8
	text_end

CeladonMansion1Text_f1edf:
	text_far _CeladonMansion1Text9
	text_end

CeladonMansion1Text_f1ee4:
	text_far _CeladonMansion1Text10
	text_end

CeladonMansion1Text_f1ee9:
	text_far _CeladonMansion1Text11
	text_end

CeladonMansion1Text_f1eee:
	text_far _CeladonMansion1Text12
	text_end
