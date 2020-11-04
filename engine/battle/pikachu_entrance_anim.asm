StarterPikachuBattleEntranceAnimation:
	hlcoord 0, 5
	ld c, 0
.loop1
	inc c
	ld a, c
	cp 9
	ret z
	ld d, 7 * 13
	push bc
	push hl
.loop2
	call .PlaceColumn
	dec hl
	ld a, d
	sub 7
	ld d, a
	dec c
	jr nz, .loop2
	ld c, 2
	call DelayFrames
	pop hl
	pop bc
	inc hl
	jr .loop1

.PlaceColumn:
	push hl
	push de
	push bc
	ld e, 7
.loop3
	ld a, d
	cp 7 * 7
	jr nc, .okay
	ld a, $7f
.okay
	ld [hl], a
	ld bc, SCREEN_WIDTH
	add hl, bc
	inc d
	dec e
	jr nz, .loop3
	pop bc
	pop de
	pop hl
	ret
