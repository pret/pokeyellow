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
	cp $7f ; all but EARTHBADGE
	jr z, .asm_f18db
	CheckEvent EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
	jr nz, .asm_f18db
	ld hl, ViridianCityText_f18df
.asm_f18db
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
	jr nz, .asm_f18fe
	ld hl, ViridianCityText_f190c
.asm_f18fe
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
	jr nz, .asm_f191e
	ld hl, ViridianCityText_f1922
.asm_f191e
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
	jr nz, .asm_f1972
	ld hl, ViridianCityText_f1979
	call PrintText
	lb bc, TM_42, 1
	call GiveItem
	jr nc, .asm_f196b
	ld hl, ViridianCityText_f197e
	call PrintText
	SetEvent EVENT_GOT_TM42
	ret

.asm_f196b
	ld hl, ViridianCityText_f1989
	call PrintText
	ret

.asm_f1972
	ld hl, ViridianCityText_f1984
	call PrintText
	ret

ViridianCityText_f1979:
	TX_FAR _ViridianCityText_191ca
	db "@"

ViridianCityText_f197e:
	TX_FAR _ReceivedTM42Text
	TX_SFX_CONGRATS
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
	jr nz, .asm_f19af
	ld hl, ViridianCityText_f19bb
	call PrintText
	ld a, $3
	ld [wViridianCityCurScript], a
	jr .asm_f19b5

.asm_f19af
	ld hl, ViridianCityText_f19c0
	call PrintText
.asm_f19b5
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
