ReadJoypad_::
; Poll joypad input.
; Unlike the hardware register, button
; presses are indicated by a set bit.
	ldh a, [hDisableJoypadPolling]
	and a
	ret nz

	ld a, 1 << 5 ; select direction keys

	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	cpl
	and %1111
	swap a
	ld b, a

	ld a, 1 << 4 ; select button keys
	ldh [rJOYP], a
REPT 6
	ldh a, [rJOYP]
ENDR
	cpl
	and %1111
	or b

	ldh [hJoyInput], a

	ld a, 1 << 4 + 1 << 5 ; deselect keys
	ldh [rJOYP], a
	ret

_Joypad::
; hJoyReleased: (hJoyLast ^ hJoyInput) & hJoyLast
; hJoyPressed:  (hJoyLast ^ hJoyInput) & hJoyInput

	ldh a, [hJoyInput]
	ld b, a
	and A_BUTTON + B_BUTTON + SELECT + START + D_UP
	cp A_BUTTON + B_BUTTON + SELECT + START ; soft reset
	jp z, TrySoftReset

	ldh a, [hJoyLast]
	ld e, a
	xor b
	ld d, a
	and e
	ldh [hJoyReleased], a
	ld a, d
	and b
	ldh [hJoyPressed], a
	ld a, b
	ldh [hJoyLast], a

	ld a, [wd730]
	bit 5, a
	jr nz, DiscardButtonPresses

	ldh a, [hJoyLast]
	ldh [hJoyHeld], a

	ld a, [wJoyIgnore]
	and a
	ret z

	cpl
	ld b, a
	ldh a, [hJoyHeld]
	and b
	ldh [hJoyHeld], a
	ldh a, [hJoyPressed]
	and b
	ldh [hJoyPressed], a
	ret

DiscardButtonPresses:
	xor a
	ldh [hJoyHeld], a
	ldh [hJoyPressed], a
	ldh [hJoyReleased], a
	ret

TrySoftReset:
	call DelayFrame

	; deselect (redundant)
	ld a, $30
	ldh [rJOYP], a

	ld hl, hSoftReset
	dec [hl]
	jp z, SoftReset

	jp Joypad
