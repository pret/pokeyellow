; inverts the BGP for 4 (6 on CGB due to lag) frames
InvertBGPal_4Frames: ; 2bd4c (a:7d4c)
	call GetPredefRegisters ; leftover of red/blue, has no use here
	ld a, [rBGP]
	xor $ff
	ld [rBGP], a
	call UpdateGBCPal_BGP
	ld c, 4
	call DelayFrames
	ld a, [rBGP]
	xor $ff
	ld [rBGP], a
	call UpdateGBCPal_BGP
	ret

PredefShakeScreenVertically: ; 2bd67 (a:7d67)
; Moves the window down and then back in a sequence of progressively smaller
; numbers of pixels, starting at b.
	call GetPredefRegisters
	ld a, 1
	ld [wDisableVBlankWYUpdate], a
	xor a
.loop
	ld [$ff96], a
	call .MutateWY
	call .MutateWY
	dec b
	ld a, b
	jr nz, .loop
	xor a
	ld [wDisableVBlankWYUpdate], a
	ret

.MutateWY ; 2bd81 (a:7d81)
	ld a, [$ff96]
	xor b
	ld [$ff96], a
	ld [rWY], a
	ld c, 3
	jp DelayFrames

PredefShakeScreenHorizontally: ; 2bd8d (a:7d8d)
; Moves the window right and then back in a sequence of progressively smaller
; numbers of pixels, starting at b.
	call GetPredefRegisters
	xor a
.loop
	ld [$ff97], a
	call .MutateWX
	ld c, 1
	call DelayFrames
	call .MutateWX
	dec b
	ld a, b
	jr nz, .loop

; restore normal WX
	ld a, 7
	ld [rWX], a
	ret

.MutateWX ; 2bda7 (a:4da7)
	ld a, [$ff97]
	xor b
	ld [$ff97], a
	bit 7, a
	jr z, .skipZeroing
	xor a ; zero a if it's negative
.skipZeroing
	add 7
	ld [rWX], a
	ld c, 4
	jp DelayFrames
