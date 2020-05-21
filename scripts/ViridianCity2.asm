Func_f18bb:
	ld hl, ViridianCityText_f18c2
	call PrintText
	ret

ViridianCityText_f18c2:
	TX_FAR _ViridianCityText1
	db "@"

Func_f18c7:
	ld hl, ViridianCityText_f18e4
	ld a, [wObtainedBadges]
	cp %01111111
	jr z, .printAndDone
	CheckEvent EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
	jr nz, .printAndDone
	ld hl, ViridianCityText_f18df
.printAndDone
	call PrintText
	ret

ViridianCityText_f18df:
	TX_FAR _ViridianCityText_19122
	db "@"

ViridianCityText_f18e4:
	TX_FAR _ViridianCityText_19127
	db "@"

Func_f18e9:
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
	TX_FAR _ViridianCityText_1914d
	db "@"

ViridianCityText_f1907:
	TX_FAR _ViridianCityText_19152
	db "@"

ViridianCityText_f190c:
	TX_FAR _ViridianCityText_19157
	db "@"

Func_f1911:
	ld hl, ViridianCityText_f1927
	CheckEvent EVENT_GOT_POKEDEX
	jr nz, .gotPokedex
	ld hl, ViridianCityText_f1922
.gotPokedex
	call PrintText
	ret

ViridianCityText_f1922:
	TX_FAR _ViridianCityText_19175
	db "@"

ViridianCityText_f1927:
	TX_FAR _ViridianCityText_1917a
	db "@"

Func_f192c:
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
	TX_FAR _ViridianCityText_19191
	db "@"

Func_f194a:
	CheckEvent EVENT_GOT_TM42
	jr nz, .gotTm42
	ld hl, ViridianCityText_f1979
	call PrintText
	lb bc, TM_42, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, ViridianCityText_f197e
	call PrintText
	SetEvent EVENT_GOT_TM42
	ret
.BagFull
	ld hl, ViridianCityText_f1989
	call PrintText
	ret
.gotTm42
	ld hl, ViridianCityText_f1984
	call PrintText
	ret

ViridianCityText_f1979:
	TX_FAR _ViridianCityText_191ca
	db "@"

ViridianCityText_f197e:
	TX_FAR _ReceivedTM42Text
	TX_SFX_ITEM_2
	db "@"

ViridianCityText_f1984:
	TX_FAR _TM42Explanation
	db "@"

ViridianCityText_f1989:
	TX_FAR _TM42NoRoomText
	db "@"

Func_f198e:
	ld hl, ViridianCityText_f19b6
	call PrintText
	ld c, 2
	call DelayFrames
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .hurry
	ld hl, ViridianCityText_f19bb
	call PrintText
	ld a, $3
	ld [wViridianCityCurScript], a
	jr .done
.hurry
	ld hl, ViridianCityText_f19c0
	call PrintText
.done
	ret

ViridianCityText_f19b6:
	TX_FAR _OldManAgainText1
	db "@"

ViridianCityText_f19bb:
	TX_FAR _OldManAgainText2
	db "@"

ViridianCityText_f19c0:
	TX_FAR _OldManAgainText3
	db "@"

Func_f19c5:
	ld hl, ViridianCityText_f19cc
	call PrintText
	ret

ViridianCityText_f19cc:
	TX_FAR _ViridianCityText8
	db "@"

Func_f19d1:
	ld hl, ViridianCityText_f19d8
	call PrintText
	ret

ViridianCityText_f19d8:
	TX_FAR _ViridianCityText9
	db "@"

Func_f19dd:
	ld hl, ViridianCityText_f19e4
	call PrintText
	ret

ViridianCityText_f19e4:
	TX_FAR _ViridianCityText10
	db "@"

Func_f19e9:
	ld hl, ViridianCityText_f19f0
	call PrintText
	ret

ViridianCityText_f19f0:
	TX_FAR _ViridianCityText13
	db "@"

Func_f19f5:
	ld hl, ViridianCityText_f19fc
	call PrintText
	ret

ViridianCityText_f19fc:
	TX_FAR _ViridianCityText14
	db "@"


Func_f1a01:
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
