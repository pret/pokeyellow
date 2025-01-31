_Start::
	cp CGB
	jr z, .cgb
	xor a
	jr .ok
.cgb
	ld a, TRUE
.ok
	ldh [hOnCGB], a
	jp Init
