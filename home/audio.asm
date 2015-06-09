PlayDefaultMusic:: ; 216b (0:216b)
	call WaitForSoundToFinish
	xor a
	ld c, a
	ld d, a
	ld [wcfca], a
	jr asm_2188

Func_2312:: ; 2312 (0:2312)
	ld c, $a
	ld d, $0
	ld a, [wd72e]
	bit 5, a
	jr z, asm_2118
	xor a
	ld [wcfca], a
	ld c, $8
	ld d, c
asm_2118:: ; 2118 (0:2118)
	ld a, [wWalkBikeSurfState]
	and a
	jr z, .asm_21ac
	cp $2
	jr z, .asm_219b
	call Func_21c8
	jr c, .asm_21ac
	ld a, MUSIC_BIKE_RIDING
	jr .asm_219d
.asm_219b
	ld a, MUSIC_SURFING
.asm_219d
	ld b, a
	ld a, d
	and a
	ld a, BANK(Music_BikeRiding)
	jr nz, .asm_21a7
	ld [wc0ef], a
.asm_21a7
	ld [wc0f0], a
	jr .asm_21b5
.asm_21ac
	ld a, [wd35b]
	ld b, a
	call Func_21f5
	jr c, .asm_21ba
.asm_21b5
	ld a, [wcfca]
	cp b
	ret z
.asm_21ba
	ld a, c
	ld [wMusicHeaderPointer], a
	ld a, b
	ld [wcfca], a
	ld [wc0ee], a
	jp PlaySound

Func_21c8:: ; 21c8 (0:21c8)
	ld a,[W_CURMAP]
	cp ROUTE_23
	jr z,.asm_21e1
	cp VICTORY_ROAD_1
	jr z,.asm_21e1
	cp VICTORY_ROAD_2
	jr z,.asm_21e1
	cp VICTORY_ROAD_3
	jr z,.asm_21e1
	cp INDIGO_PLATEAU
	jr z,.asm_21e1
	and a
	ret
.asm_21e1
	scf
	ret

Func_235f:: ; 235f (0:235f)
	ld a, [wc0ef]
	ld b, a
	cp BANK(Music2_UpdateMusic)
	jr nz, .checkForBank08
.bank02
	ld hl, Music2_UpdateMusic
	jr .asm_2378
.checkForBank08
	cp BANK(Music8_UpdateMusic)
	jr nz, .bank1F
.bank08
	ld hl, Music8_UpdateMusic
	jr .asm_2378
.bank1F
	ld hl, Music1f_UpdateMusic
.asm_2378
	ld c, $6
.asm_237a
	push bc
	push hl
	call Bankswitch
	pop hl
	pop bc
	dec c
	jr nz, .asm_237a
	ret

Func_21f5:: ; 21f5 (0:21f5)
	ld a, [wd35c]
	ld e, a
	ld a, [wc0ef]
	cp e
	jr nz, .asm_2394
	ld [wc0f0], a
	and a
	ret
.asm_2394
	ld a, c
	and a
	ld a, e
	jr nz, .asm_239c
	ld [wc0ef], a
.asm_239c
	ld [wc0f0], a
	scf
	ret

PlayMusic:: ; 23a1 (0:23a1)
	ld b, a
	ld [wc0ee], a
	xor a
	ld [wMusicHeaderPointer], a
	ld a, c
	ld [wc0ef], a
	ld [wc0f0], a
	ld a, b

StopAllMusic:: ; 2233 (0:2233)
	ld a,$FF
	ld [wc0ee],a
; plays music specified by a. If value is $ff, music is stopped
PlaySound:: ; 23b1 (0:23b1)
	push hl
	push de
	push bc
	ld b, a
	ld a, [wc0ee]
	and a
	jr z, .asm_23c8
	xor a
	ld [wc02a], a
	ld [wc02b], a
	ld [wc02c], a
	ld [wc02d], a
.asm_23c8
	ld a, [wMusicHeaderPointer]
	and a
	jr z, .asm_23e3
	ld a, [wc0ee]
	and a
	jr z, .asm_2425
	xor a
	ld [wc0ee], a
	ld a, [wcfca]
	cp $ff
	jr nz, .asm_2414
	xor a
	ld [wMusicHeaderPointer], a
.asm_23e3
	xor a
	ld [wc0ee], a
	ld a, [H_LOADEDROMBANK]
	ld [$ffb9], a
	ld a, [wc0ef]
	ld [H_LOADEDROMBANK], a
	ld [$2000], a
	cp BANK(Func_9876)
	jr nz, .checkForBank08
.bank02
	ld a, b
	call Func_9876
	jr .asm_240b
.checkForBank08
	cp BANK(Func_22035)
	jr nz, .bank1F
.bank08
	ld a, b
	call Func_22035
	jr .asm_240b
.bank1F
	ld a, b
	call Func_7d8ea
.asm_240b
	ld a, [$ffb9]
	ld [H_LOADEDROMBANK], a
	ld [$2000], a
	jr .asm_2425
.asm_2414
	ld a, b
	ld [wcfca], a
	ld a, [wMusicHeaderPointer]
	ld [wcfc8], a
	ld [wcfc9], a
	ld a, b
	ld [wMusicHeaderPointer], a
.asm_2425
	pop bc
	pop de
	pop hl
	ret
