CinnabarGymPrintGymGuideText::
	CheckEvent EVENT_BEAT_BLAINE
	jr nz, .afterBeat
	ld hl, .ChampInMakingText
	jr .done
.afterBeat
	ld hl, .BeatBlaineText
.done
	call PrintText
	ret

.ChampInMakingText:
	text_far _CinnabarGymGymGuideChampInMakingText
	text_end

.BeatBlaineText:
	text_far _CinnabarGymGymGuideBeatBlaineText
	text_end

PrintCinnabarGymTrainerText::
	ld hl, CinnabarGymTrainerTextPointers
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp PrintText

CinnabarGymTrainerTextPointers:
	dw CinnabarGymText_1
	dw CinnabarGymText_2
	dw CinnabarGymText_3
	dw CinnabarGymText_4
	dw CinnabarGymText_5
	dw CinnabarGymText_6

CinnabarGymText_1:
	text_far _CinnabarGymText_1
	text_end

CinnabarGymText_2:
	text_far _CinnabarGymText_2
	text_end

CinnabarGymText_3:
	text_far _CinnabarGymText_3
	text_end

CinnabarGymText_4:
	text_far _CinnabarGymText_4
	text_end

CinnabarGymText_5:
	text_far _CinnabarGymText_5
	text_end

CinnabarGymText_6:
	text_far _CinnabarGymText_6
	text_end

CinnabarGymText_7: ; unreferenced
	text_far _CinnabarGymText_7
	text_end
