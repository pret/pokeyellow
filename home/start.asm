_Start::
	cp BOOTUP_A_CGB
	jr z, .cgb
	xor a
	jr .ok
.cgb
	ld a, TRUE
.ok
	ldh [hOnCGB], a
	jp Init
