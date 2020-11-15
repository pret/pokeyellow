Func_f18bb::
	ld hl, ViridianCityText_f18c2
	call PrintText
	ret

ViridianCityText_f18c2:
	text_far _ViridianCityText1
	text_end

Func_f18c7::
	ld hl, ViridianCityText_19127
	ld a, [wObtainedBadges]
	cp $ff ^ (1 << BIT_EARTHBADGE)
	jr z, .done
	CheckEvent EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
	jr nz, .done
	ld hl, ViridianCityText_19122
.done
	call PrintText
	ret

ViridianCityText_19122:
	text_far _ViridianCityText_19122
	text_end

ViridianCityText_19127:
	text_far _ViridianCityText_19127
	text_end

Func_f18e9::
	ld hl, ViridianCityText_f1902
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ld hl, ViridianCityText_f1907
	jr nz, .no
	ld hl, ViridianCityText_f190c
.no
	call PrintText
	ret

ViridianCityText_f1902:
	text_far _ViridianCityText_1914d
	text_end

ViridianCityText_f1907:
	text_far _ViridianCityText_19152
	text_end

ViridianCityText_f190c:
	text_far _ViridianCityText_19157
	text_end

Func_f1911::
	ld hl, ViridianCityText_f1927
	CheckEvent EVENT_GOT_POKEDEX
	jr nz, .gotPokedex
	ld hl, ViridianCityText_f1922
.gotPokedex
	call PrintText
	ret

ViridianCityText_f1922:
	text_far _ViridianCityText_19175
	text_end

ViridianCityText_f1927:
	text_far _ViridianCityText_1917a
	text_end

Func_f192c::
	ld hl, ViridianCityText_f1945
	call PrintText
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	ld a, $5
	ld [wViridianCityCurScript], a
	ret

ViridianCityText_f1945:
	text_far _ViridianCityText_19191
	text_end

Func_f194a::
	CheckEvent EVENT_GOT_TM42
	jr nz, .got_item
	ld hl, ViridianCityText_191ca
	call PrintText
	lb bc, TM_DREAM_EATER, 1
	call GiveItem
	jr nc, .bag_full
	ld hl, ReceivedTM42Text
	call PrintText
	SetEvent EVENT_GOT_TM42
	ret
.bag_full
	ld hl, TM42NoRoomText
	call PrintText
	ret
.got_item
	ld hl, TM42Explanation
	call PrintText
	ret

ViridianCityText_191ca:
	text_far _ViridianCityText_191ca
	text_end

ReceivedTM42Text:
	text_far _ReceivedTM42Text
	sound_get_item_2
	text_end

TM42Explanation:
	text_far _TM42Explanation
	text_end

TM42NoRoomText:
	text_far _TM42NoRoomText
	text_end

Func_f198e::
	ld hl, ViridianCityText_f19b6
	call PrintText
	ld c, 2
	call DelayFrames
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .refused
	ld hl, ViridianCityText_f19bb
	call PrintText
	ld a, $3
	ld [wViridianCityCurScript], a
	jr .done
.refused
	ld hl, ViridianCityText_f19c0
	call PrintText
.done
	ret

ViridianCityText_f19b6:
	text_far _OldManAgainText1
	text_end

ViridianCityText_f19bb:
	text_far _OldManAgainText2
	text_end

ViridianCityText_f19c0:
	text_far _OldManAgainText3
	text_end

Func_f19c5::
	ld hl, ViridianCityText_f19cc
	call PrintText
	ret

ViridianCityText_f19cc:
	text_far _ViridianCityText8
	text_end

Func_f19d1::
	ld hl, ViridianCityText_f19d8
	call PrintText
	ret

ViridianCityText_f19d8:
	text_far _ViridianCityText9
	text_end

Func_f19dd::
	ld hl, ViridianCityText_f19e4
	call PrintText
	ret

ViridianCityText_f19e4:
	text_far _ViridianCityText10
	text_end

Func_f19e9::
	ld hl, ViridianCityText_f19f0
	call PrintText
	ret

ViridianCityText_f19f0:
	text_far _ViridianCityText13
	text_end

Func_f19f5::
	ld hl, ViridianCityText_f19fc
	call PrintText
	ret

ViridianCityText_f19fc:
	text_far _ViridianCityText14
	text_end


Func_f1a01::
	ld hl, Data_f1a0a
	ld b, SPRITE_FACING_RIGHT
	call TryApplyPikachuMovementData
	ret

Data_f1a0a:
	db $00
	db $1d
	db $1f
	db $38
	db $3f
