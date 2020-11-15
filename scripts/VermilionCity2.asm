Func_f1a0f::
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
	text_far _OfficerJennyText1
	text_end

OfficerJennyText2:
	text_far _OfficerJennyText2
	text_end

OfficerJennyText3:
	text_far _OfficerJennyText3
	text_waitbutton
	text_end

OfficerJennyText4:
	text_far _OfficerJennyText4
	text_end

OfficerJennyText5:
	text_far _OfficerJennyText5
	text_end

Func_f1a8a::
	ld hl, VermilionCityText_f1a91
	call PrintText
	ret

VermilionCityText_f1a91:
	text_far _VermilionCityText8
	text_end

Func_f1a96::
	ld hl, VermilionCityText_f1a9d
	call PrintText
	ret

VermilionCityText_f1a9d:
	text_far _VermilionCityText9
	text_end

Func_f1aa2::
	ld hl, VermilionCityText_f1aa9
	call PrintText
	ret

VermilionCityText_f1aa9:
	text_far _VermilionCityText12
	text_end

Func_f1aae::
	ld hl, VermilionCityText_f1ab5
	call PrintText
	ret

VermilionCityText_f1ab5:
	text_far _VermilionCityText13
	text_end

Func_f1aba::
	ld hl, VermilionCityText_f1ac1
	call PrintText
	ret

VermilionCityText_f1ac1:
	text_far _VermilionCityText14
	text_end
