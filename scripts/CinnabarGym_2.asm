CinnabarGymPrintTrainerTextE:
	callfar PrintCinnabarGymTrainerText
	jp TextScriptEnd

CinnabarGymClearWrongAnswer:
	push hl
	ld hl, wCinnabarGymQuizWrongAnswer
	bit 7, [hl]
	res 7, [hl]
	pop hl
	ret

CinnabarGymCheckWrongAnswer:
	push hl
	ld hl, wCinnabarGymQuizWrongAnswer
	bit 7, [hl]
	pop hl
	ret
