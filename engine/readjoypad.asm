ReadJoypad_:: ; c000 (3:4000)
; Poll joypad input.
; Unlike the hardware register, button
; presses are indicated by a set bit.

	ld a, 1 << 5 ; select direction keys
	ld c, 0

	ld [rJOYP], a
	rept 6
	ld a, [rJOYP]
	endr
	cpl
	and %1111
	swap a
	ld b, a

	ld a, 1 << 4 ; select button keys
	ld [rJOYP], a
	rept 10
	ld a, [rJOYP]
	endr
	cpl
	and %1111
	or b

	ld [hJoyInput], a

	ld a, 1 << 4 + 1 << 5 ; deselect keys
	ld [rJOYP], a
	ret
