_Start::
	cp GBC
	jr z, .gbc
	xor a
	jr .ok
.gbc
	ld a, TRUE
.ok
	ldh [hGBC], a
	jp Init
