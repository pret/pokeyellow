CeruleanHouse1Script:
	call EnableAutoTextBoxDrawing
	ret

CeruleanHouse1TextPointers:
	dw CeruleanHouse1Text1
	dw CeruleanHouse1Text2
	dw CeruleanHouse1Text3
	dw CeruleanHouse1Text4

CeruleanHouse1Text1:
	TX_ASM
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	CheckEvent EVENT_GOT_BULBASAUR_IN_CERULEAN
	jr nz, .asm_1cfbf
	ld hl, CeruleanHouse1Text_1cfc8
	call PrintText
	ld a, [wPikachuHappiness]
	cp 147
	jr c, .asm_1cfb3
	ld hl, CeruleanHouse1Text_1cfce
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_1cfb6
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, BULBASAUR
	ld [wd11e], a
	ld [wcf91], a
	call GetMonName
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	lb bc, BULBASAUR, 10
	call GivePokemon
	jr nc, .asm_1cfb3
	ld a, [wAddedToParty]
	and a
	call z, WaitForTextScrollButtonPress
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, CeruleanHouse1Text_1cfd3
	call PrintText
	ld a, HS_CERULEAN_BULBASAUR
	ld [wMissableObjectIndex], a
	predef HideObject
	SetEvent EVENT_GOT_BULBASAUR_IN_CERULEAN
.asm_1cfb3
	jp TextScriptEnd

.asm_1cfb6
	ld hl, CeruleanHouse1Text_1cfdf
	call PrintText
	jp TextScriptEnd

.asm_1cfbf
	ld hl, CeruleanHouse1Text_1cfd9
	call PrintText
	jp TextScriptEnd

CeruleanHouse1Text_1cfc8:
	TX_FAR MelanieText1
	TX_WAIT_BUTTON
	db "@"

CeruleanHouse1Text_1cfce:
	TX_FAR MelanieText2
	db "@"

CeruleanHouse1Text_1cfd3:
	TX_FAR MelanieText3
	TX_WAIT_BUTTON
	db "@"

CeruleanHouse1Text_1cfd9:
	TX_FAR MelanieText4
	TX_WAIT_BUTTON
	db "@"

CeruleanHouse1Text_1cfdf:
	TX_FAR MelanieText5
	TX_WAIT_BUTTON
	db "@"

CeruleanHouse1Text2:
	TX_FAR MelanieBulbasaurText
	TX_ASM
	ld a, BULBASAUR
	call PlayCry
	jp TextScriptEnd

CeruleanHouse1Text3:
	TX_FAR MelanieOddishText
	TX_ASM
	ld a, ODDISH
	call PlayCry
	jp TextScriptEnd

CeruleanHouse1Text4:
	TX_FAR MelanieSandshrewText
	TX_ASM
	ld a, SANDSHREW
	call PlayCry
	jp TextScriptEnd
