Func_f2133:
	CheckEvent EVENT_BEAT_BLAINE
	jr nz, .asm_627d9
	ld hl, CinnabarGymText_75ac2
	jr .asm_0b11d
.asm_627d9
	ld hl, CinnabarGymText_75ac7
.asm_0b11d
	call PrintText
	ret

CinnabarGymText_75ac2:
	TX_FAR _CinnabarGymText_75ac2
	db "@"

CinnabarGymText_75ac7:
	TX_FAR _CinnabarGymText_75ac7
	db "@"

Func_f2150:
	ld hl, TextPointers_f215d
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp PrintText

TextPointers_f215d:
	dw CinnabarGymText_f2169
	dw CinnabarGymText_f216e
	dw CinnabarGymText_f2173
	dw CinnabarGymText_f2178
	dw CinnabarGymText_f217d
	dw CinnabarGymText_f2182

CinnabarGymText_f2169:
	TX_FAR _CinnabarGymText_1
	db "@"

CinnabarGymText_f216e:
	TX_FAR _CinnabarGymText_2
	db "@"

CinnabarGymText_f2173:
	TX_FAR _CinnabarGymText_3
	db "@"

CinnabarGymText_f2178:
	TX_FAR _CinnabarGymText_4
	db "@"

CinnabarGymText_f217d:
	TX_FAR _CinnabarGymText_5
	db "@"

CinnabarGymText_f2182:
	TX_FAR _CinnabarGymText_6
	db "@"

CinnabarGymText_f2187:
	TX_FAR _CinnabarGymText_7 ; unused
	db "@"
