CeladonMansion1FPrintGrannyText::
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, CeladonMansion1Text2
	call PrintText
	callfar IsStarterPikachuAliveInOurParty
	ret nc
	ld hl, CeladonMansion1Text6
	call PrintText
	ld a, $0
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call GetPikachuHappinessText
	call PrintText
	ret

CeladonMansion1Text2:
	text_far _CeladonMansion1Text2
	text_waitbutton
	text_end

CeladonMansion1Text6:
	text_far _CeladonMansion1Text6
	text_promptbutton
	text_end

GetPikachuHappinessText:
	ld hl, PikachuHappinessThresholds
.loop
	ld a, [hli]
	inc hl
	and a
	jr z, .got_text
	ld b, a
	ld a, [wPikachuHappiness]
	cp b
	jr c, .got_text
	inc hl
	inc hl
	jr .loop

.got_text
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

MACRO pikahappiness
	db \1 ; happiness threshold
	IF \1
		db 0 ; unused
	ELSE
		db -1 ; unused
	ENDC
	dw \2 ; text
ENDM

PikachuHappinessThresholds:
	pikahappiness  51, CeladonMansion1Text7
	pikahappiness 101, CeladonMansion1Text8
	pikahappiness 131, CeladonMansion1Text9
	pikahappiness 161, CeladonMansion1Text10
	pikahappiness 201, CeladonMansion1Text11
	pikahappiness 255, CeladonMansion1Text12
	pikahappiness   0, CeladonMansion1Text12

CeladonMansion1Text7:
	text_far _CeladonMansion1Text7
	text_end

CeladonMansion1Text8:
	text_far _CeladonMansion1Text8
	text_end

CeladonMansion1Text9:
	text_far _CeladonMansion1Text9
	text_end

CeladonMansion1Text10:
	text_far _CeladonMansion1Text10
	text_end

CeladonMansion1Text11:
	text_far _CeladonMansion1Text11
	text_end

CeladonMansion1Text12:
	text_far _CeladonMansion1Text12
	text_end
