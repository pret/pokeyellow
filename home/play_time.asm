TrackPlayTime:
	call CountDownIgnoreInputBitReset
	ld hl, wd47a
	bit 0, [hl]
	jr nz, .maxIGT
	ld a,[wd732]
	bit 0,a
	ret z
	ld a, [wPlayTimeMaxed]
	and a
	ret nz
	ld a, [wPlayTimeFrames]
	inc a
	ld [wPlayTimeFrames], a
	cp 60
	ret nz
	xor a
	ld [wPlayTimeFrames], a
	ld a, [wPlayTimeSeconds]
	inc a
	ld [wPlayTimeSeconds], a
	cp 60
	ret nz
	xor a
	ld [wPlayTimeSeconds], a
	ld a, [wPlayTimeMinutes]
	inc a
	ld [wPlayTimeMinutes], a
	cp 60
	ret nz
	xor a
	ld [wPlayTimeMinutes], a
	ld a, [wPlayTimeHours]
	inc a
	ld [wPlayTimeHours], a
	cp $ff
	ret nz
	ld hl, wd47a
	set 0, [hl]
.maxIGT
	ld a, 59
	ld [wPlayTimeSeconds], a
	ld [wPlayTimeMinutes], a
	ld a, $ff
	ld [wPlayTimeHours], a
	ld [wPlayTimeMaxed], a
	ret

CountDownIgnoreInputBitReset:
	ld a, [wIgnoreInputCounter]
	and a
	jr nz, .asm_1f5e
	ld a, $ff
	jr .asm_1f5f
.asm_1f5e
	dec a
.asm_1f5f
	ld [wIgnoreInputCounter], a
	and a
	ret nz
	ld a, [wd730]
	res 1, a
	res 2, a
	bit 5, a
	res 5, a
	ld [wd730], a
	ret z
	xor a
	ld [hJoyPressed], a
	ld [hJoyHeld], a
	ret
