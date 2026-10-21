CeruleanMelaniesHouse_Script:
	call EnableAutoTextBoxDrawing
	ret

CeruleanMelaniesHouse_TextPointers:
	def_text_pointers
	dw_const CeruleanMelaniesHouseMelanieText,   TEXT_CERULEANMELANIESHOUSE_MELANIE
	dw_const CeruleanMelaniesHouseBulbasaurText, TEXT_CERULEANMELANIESHOUSE_BULBASAUR
	dw_const CeruleanMelaniesHouseOddishText,    TEXT_CERULEANMELANIESHOUSE_ODDISH
	dw_const CeruleanMelaniesHouseSandshrewText, TEXT_CERULEANMELANIESHOUSE_SANDSHREW

CeruleanMelaniesHouseMelanieText:
	text_asm
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	CheckEvent EVENT_GOT_BULBASAUR_IN_CERULEAN
	jr nz, .got_bulbasaur
	ld hl, MelanieText1
	call PrintText
	ld a, [wPikachuHappiness]
	cp 147
	jr c, .no_bulbasaur
	ld hl, MelanieText2
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .refused
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, BULBASAUR
	ld [wNamedObjectIndex], a
	ld [wCurPartySpecies], a
	call GetMonName
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	lb bc, BULBASAUR, 10
	call GivePokemon
	jr nc, .no_bulbasaur
	ld a, [wAddedToParty]
	and a
	call z, WaitForTextScrollButtonPress
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, MelanieText3
	call PrintText
	ld a, TOGGLE_CERULEAN_BULBASAUR
	ld [wToggleableObjectIndex], a
	predef HideObject
	SetEvent EVENT_GOT_BULBASAUR_IN_CERULEAN
.no_bulbasaur
	jp TextScriptEnd

.refused
	ld hl, MelanieText5
	call PrintText
	jp TextScriptEnd

.got_bulbasaur
	ld hl, MelanieText4
	call PrintText
	jp TextScriptEnd

MelanieText1:
	text_far _MelanieText1
	text_waitbutton
	text_end

MelanieText2:
	text_far _MelanieText2
	text_end

MelanieText3:
	text_far _MelanieText3
	text_waitbutton
	text_end

MelanieText4:
	text_far _MelanieText4
	text_waitbutton
	text_end

MelanieText5:
	text_far _MelanieText5
	text_waitbutton
	text_end

CeruleanMelaniesHouseBulbasaurText:
	text_far _CeruleanMelaniesHouseBulbasaurText
	text_asm
	ld a, BULBASAUR
	call PlayCry
	jp TextScriptEnd

CeruleanMelaniesHouseOddishText:
	text_far _CeruleanMelaniesHouseOddishText
	text_asm
	ld a, ODDISH
	call PlayCry
	jp TextScriptEnd

CeruleanMelaniesHouseSandshrewText:
	text_far _CeruleanMelaniesHouseSandshrewText
	text_asm
	ld a, SANDSHREW
	call PlayCry
	jp TextScriptEnd
