Func_f1a0f:
	CheckEvent EVENT_GOT_SQUIRTLE_FROM_OFFICER_JENNY
	jr nz, .asm_f1a69
	ld a, [wBeatGymFlags]
	bit 2, a ; THUNDERBADGE
	jr nz, .asm_f1a24
	ld hl, OfficerJennyText1
	call PrintText
	ret

.asm_f1a24
	ld hl, OfficerJennyText2
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_f1a62
	ld a, SQUIRTLE
	ld [wd11e], a
	ld [wcf91], a
	call GetMonName
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	lb bc, SQUIRTLE, 10
	call GivePokemon
	ret nc
	ld a, [wAddedToParty]
	and a
	call z, WaitForTextScrollButtonPress
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, OfficerJennyText3
	call PrintText
	SetEvent EVENT_GOT_SQUIRTLE_FROM_OFFICER_JENNY
	ret

.asm_f1a62
	ld hl, OfficerJennyText4
	call PrintText
	ret

.asm_f1a69
	ld hl, OfficerJennyText5
	call PrintText
	ret

OfficerJennyText1:
	TX_FAR _OfficerJennyText1
	db "@"

OfficerJennyText2:
	TX_FAR _OfficerJennyText2
	db "@"

OfficerJennyText3:
	TX_FAR _OfficerJennyText3
	db $d
	db "@"

OfficerJennyText4:
	TX_FAR _OfficerJennyText4
	db "@"

OfficerJennyText5:
	TX_FAR _OfficerJennyText5
	db "@"

Func_f1a8a:
	ld hl, VermilionCityText_f1a91
	call PrintText
	ret

VermilionCityText_f1a91:
	TX_FAR _VermilionCityText8
	db "@"

Func_f1a96:
	ld hl, VermilionCityText_f1a9d
	call PrintText
	ret

VermilionCityText_f1a9d:
	TX_FAR _VermilionCityText9
	db "@"

Func_f1aa2:
	ld hl, VermilionCityText_f1aa9
	call PrintText
	ret

VermilionCityText_f1aa9:
	TX_FAR _VermilionCityText12
	db "@"

Func_f1aae:
	ld hl, VermilionCityText_f1ab5
	call PrintText
	ret

VermilionCityText_f1ab5:
	TX_FAR _VermilionCityText13
	db "@"

Func_f1aba:
	ld hl, VermilionCityText_f1ac1
	call PrintText
	ret

VermilionCityText_f1ac1:
	TX_FAR _VermilionCityText14
	db "@"
