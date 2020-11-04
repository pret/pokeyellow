Func_f2133::
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
	text_far _CinnabarGymText_75ac2
	text_end

CinnabarGymText_75ac7:
	text_far _CinnabarGymText_75ac7
	text_end

Func_f2150::
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
	text_far _CinnabarGymText_1
	text_end

CinnabarGymText_f216e:
	text_far _CinnabarGymText_2
	text_end

CinnabarGymText_f2173:
	text_far _CinnabarGymText_3
	text_end

CinnabarGymText_f2178:
	text_far _CinnabarGymText_4
	text_end

CinnabarGymText_f217d:
	text_far _CinnabarGymText_5
	text_end

CinnabarGymText_f2182:
	text_far _CinnabarGymText_6
	text_end

CinnabarGymText_f2187:
	text_far _CinnabarGymText_7 ; unused
	text_end
