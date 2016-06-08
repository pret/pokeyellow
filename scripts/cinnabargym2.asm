CinnabarGymScript_753de:
	callab Func_f2150
	jp TextScriptEnd

CinnabarGymScript_753e9:
	push hl
	ld hl, wd475
	bit 7, [hl]
	res 7, [hl]
	pop hl
	ret

CinnabarGymScript_753f3:
	push hl
	ld hl, wd475
	bit 7, [hl]
	pop hl
	ret
