Func_f8000:
	call Func_f9254
	call DelayFrame
	call DelayFrame
	call DelayFrame
	ld a, [hTilesetType]
	push af
	xor a
	ld [hTilesetType], a
	ld a, [wUpdateSpritesEnabled]
	push af
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	ld a, [rIE]
	push af
	xor a
	ld [rIF], a
	ld a, $f
	ld [rIE], a
	ld a, $8
	ld [rSTAT], a
	ld a, [$ffbd]
	push af
	ld a, $98
	ld [$ffbd], a
	call Func_f8fb3
	call Func_f807a
	xor a
	ld [rBGP], a
	ld [rOBP0], a
	ld [rOBP1], a
	call UpdateGBCPal_BGP
	call UpdateGBCPal_OBP0
	call UpdateGBCPal_OBP1
	call Func_fbb5a
	call ClearSprites
	xor a
	ld [hLCDCPointer], a
	ld [hSCX], a
	ld [hSCY], a
	ld a, $90
	ld [hWY], a
	call DelayFrame
	pop af
	ld [$ffbd], a
	xor a
	ld [rIF], a
	pop af
	ld [rIE], a
	xor a
	ld [rSTAT], a
	call RunDefaultPaletteCommand
	call Func_0f16
	call PlayDefaultMusic
	call GBPalNormal
	pop af
	ld [wUpdateSpritesEnabled], a
	pop af
	ld [hTilesetType], a
	ret

Func_f807a:
	call Func_f8116
	call DelayFrame
	ld b, $e
	call RunPaletteCommand
.asm_f8085
	ld a, [$c5d1]
	bit 7, a
	ret nz
	call Func_f923f
	call Func_f80ac
	ret nz
	call Func_f8282
	ld a, $3c
	ld [$c5bd], a
	call Func_fbb65
	call Func_f8848
	call Func_f80a8
	call Func_f80c4
	jr .asm_f8085

Func_f80a8:
	call DelayFrame
	ret

Func_f80ac:
	ld hl, wPreventBlackout
	bit 1, [hl]
	ret z
	ld a, [hJoyPressed]
	and $4
	ret
	ld a, [hJoyPressed]
	and $8
	ret z
	ld hl, $c5e2
	ld a, [hl]
	xor $1
	ld [hl], a
	ret

Func_f80c4:
	ld a, [$c634]
	and a
	ret z
	ld hl, wChannelNoteDelayCounters
	ld a, $1
	cp [hl]
	ret nz
	inc hl
	cp [hl]
	ret nz
	inc hl
	cp [hl]
	ret nz
	ld a, [$c5e3]
	ld e, a
	ld a, [$c5e4]
	and $3
	ld d, a
	sla e
	rl d
	ld e, d
	ld d, $0
	ld hl, Unkn_f80f5
	add hl, de
	add hl, de
	ld a, [hli]
	ld [$c0e9], a
	ld a, [hl]
	ld [wMusicTempo], a
	ret

Unkn_f80f5:
	dw $75
	dw $6d
	dw $65
	dw $5d
	dw $55

Func_f80ff:
	ld hl, wChannelNoteDelayCounters
	ld a, $1
	cp [hl]
	ret nz
	inc hl
	cp [hl]
	ret nz
	inc hl
	cp [hl]
	ret nz
	ld a, $75
	ld [$c0e9], a
	xor a
	ld [wMusicTempo], a
	ret

Func_f8116:
	call Func_f9279
	call ClearSprites
	call DisableLCD
	ld hl, wSerialEnemyMonsPatchList
	ld bc, $67
	xor a
	call FillMemory
	ld hl, $c700
	ld bc, $200
	xor a
	call FillMemory
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	call Func_fbb5a
	ld hl, $4f14
	ld de, $9000
	ld bc, $500
	ld a, $20
	call FarCopyData
	ld hl, $5324
	ld de, $8000
	ld bc, $1000
	ld a, $20
	call FarCopyData
	ld a, $d3
	ld [$c5c0], a
	ld a, $53
	ld [$c5c1], a
	ld a, $fa
	ld [$c5c4], a
	ld a, $53
	ld [$c5c5], a
	ld a, $7
	ld [$c5c6], a
	ld a, $55
	ld [$c5c7], a
	ld a, $5
	ld [$c5c2], a
	ld a, $54
	ld [$c5c3], a
	ld hl, $9800
	ld bc, $800
	ld a, $0
	call FillMemory
	ld hl, $98c0
	ld bc, $180
	ld a, $b
	call FillMemory
	ld a, $1
	ld de, $7458
	call Func_fbb93
	ld a, $74
	ld [$c5ea], a
	call Func_f9223
	xor a
	ld [hSCX], a
	ld [hSCY], a
	ld a, $7e
	ld [hWY], a
	ld a, $42
	ld [hLCDCPointer], a
	ld a, $40
	ld [$c5e3], a
	xor a
	ld [$c5e4], a
	xor a
	ld [$c5d6], a
	ld a, $60
	ld [$c5d7], a
	ld hl, $c61a
	ld bc, $14
	ld a, $74
	call FillMemory
	call Func_f81ff
	call Func_f8256
	ld a, $e3
	ld [rLCDC], a
	call Func_f81e9
	ld a, $e4
	ld [rOBP0], a
	ld a, $e0
	ld [rOBP1], a
	call UpdateGBCPal_OBP0
	call UpdateGBCPal_OBP1
	ret

Func_f81e9:
	ld a, [wOnSGB]
	and a
	jr nz, .asm_f81f7
	ld a, $d0
	ld [rBGP], a
	call UpdateGBCPal_BGP
	ret

.asm_f81f7
	ld a, $e4
	ld [rBGP], a
	call UpdateGBCPal_BGP
	ret

Func_f81ff:
	ld hl, wSpriteDataEnd
	ld de, Unkn_f8249
	ld b, $97
	ld c, $80
	ld a, $4
	call Func_f8233
	ld de, Unkn_f8248
	ld b, $96
	ld c, $50
	ld a, $1
	call Func_f8233
	ld de, Unkn_f824d
	ld b, $14
	ld c, $20
	ld a, $5
	call Func_f8233
	ld de, Unkn_f8252
	ld b, $20
	ld c, $80
	ld a, $4
	call Func_f8233
	ret

Func_f8233:
.asm_f8233
	push af
	ld [hl], b
	inc hl
	ld [hl], c
	inc hl
	ld a, [de]
	ld [hl], a
	inc hl
	ld [hl], $0
	inc hl
	ld a, c
	add $8
	ld c, a
	inc de
	pop af
	dec a
	jr nz, .asm_f8233
	ret

Unkn_f8248:
	db $fe

Unkn_f8249:
	db $d0
	db $d0
	db $d0
	db $d0

Unkn_f824d:
	db $ec
	db $ed
	db $ed
	db $ee
	db $ef

Unkn_f8252:
	db $ec
	db $ed
	db $ee
	db $ef

Func_f8256:
	ld de, $9c21
	ld hl, Unkn_f8279
	ld c, $9
.asm_f825e
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .asm_f825e
	ld hl, $9c01
	ld [hl], $15
	ld hl, $9c02
	ld [hl], $16
	ld hl, $9c2c
	ld [hl], $1b
	ld hl, $9c2d
	ld [hl], $1c
	ret

Unkn_f8279:
	db $17
	db $18
	db $19
	db $19
	db $19
	db $19
	db $19
	db $19
	db $19

Func_f8282:
	ld a, [$c5d1]
	ld e, a
	ld d, $0
	ld hl, Jumptable_f8291
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

Jumptable_f8291:
	dw Func_f82ab
	dw Func_f82bd
	dw Func_f8324
	dw Func_f835c
	dw Func_f838c
	dw Func_f8399
	dw Func_f83aa
	dw Func_f83bb
	dw Func_f83cc
	dw Func_f83e3
	dw Func_f8406
	dw Func_f840f
	dw Func_f841d

Func_f82ab:
	ld a, $2
	ld de, $48e0
	call Func_fbb93
	ld hl, $c5d1
	inc [hl]
	ld a, $1
	ld [$c634], a
	ret

Func_f82bd:
	ld a, [$c5e5]
	cp $18
	jr nc, .asm_f82e8
	ld hl, $c5d6
	ld a, [hli]
	or [hl]
	and a
	jr z, .asm_f82f6
	call Random
	ld [$c5d5], a
	call Func_f9210
	call Func_f88ae
	call Func_f886b
	call Func_f8cb0
	call Func_f844c
	call Func_f88e4
	call Func_f88fd
	ret

.asm_f82e8
	ld hl, $c5d1
	inc [hl]
	xor a
	ld [$c634], a
	ld a, $c0
	ld [$c632], a
	ret

.asm_f82f6
	ld a, $1
Func_f82f8:
	ld [$c630], a
	ld a, $c
	ld [$c5d1], a
Func_f8300:
	ld a, $80
	ld [$c631], a
	ld a, $b
	ld de, $8858
	call Func_fbb93
	ld hl, $7
	add hl, bc
	ld [hl], $80
	ld hl, $b
	add hl, bc
	ld [hl], $80
	ld hl, $c
	add hl, bc
	ld [hl], $30
	xor a
	ld [$c634], a
	ret

Func_f8324:
	call Func_f8440
	jr c, .asm_f833d
	xor a
	ld [$c5d5], a
	call Func_f9210
	call Func_f88ae
	call Func_f886b
	call Func_f8c97
	call Func_f80ff
	ret

.asm_f833d
	ld hl, $c5d1
	inc [hl]
	ld a, $90
	ld [hSCX], a
	ld a, $72
	ld [$c5d3], a
	ld a, $4
	ld [$c5d2], a
	xor a
	ld [hLCDCPointer], a
	ld [$c617], a
	ld [$c618], a
	ld [$c619], a
	ret

Func_f835c:
	ld a, [hSCX]
	and a
	jr z, .asm_f837b
	call Func_f9210
	call Func_f88ae
	call Func_f886b
	ld a, [hSCX]
	dec a
	dec a
	dec a
	dec a
	ld [hSCX], a
	ld a, $e0
	ld [$c62e], a
	call Func_f8cc7
	ret

.asm_f837b
	xor a
	ld [$c5e3], a
	ld [$c5e4], a
	ld hl, $c5d1
	inc [hl]
	ld a, $5
	ld [$c5d2], a
	ret

Func_f838c:
	call Func_f891e
	ld a, $20
	ld [$c632], a
	ld hl, $c5d1
	inc [hl]
	ret

Func_f8399:
	call Func_f8440
	ret nc
	call Func_f8a92
	ld a, $40
	ld [$c632], a
	ld hl, $c5d1
	inc [hl]
	ret

Func_f83aa:
	call Func_f8440
	ret nc
	call Func_f8ae4
	ld a, $40
	ld [$c632], a
	ld hl, $c5d1
	inc [hl]
	ret

Func_f83bb:
	call Func_f8440
	ret nc
	call Func_f8b7a
	ld a, $40
	ld [$c632], a
	ld hl, $c5d1
	inc [hl]
	ret

Func_f83cc:
	call Func_f8440
	ret nc
	call Func_f8aa9
	push af
	call Func_f8b5d
	pop af
	ret nc
	ld a, $40
	ld [$c632], a
	ld hl, $c5d1
	inc [hl]
	ret

Func_f83e3:
	call Func_f8440
	ret nc
	call Func_f8afb
	push af
	call Func_f8b5d
	pop af
	ret nc
	ld a, $80
	ld [$c632], a
	ld hl, $c5d1
	inc [hl]
	call Func_f8b92
	ret nc
	call Func_f8a7c
Func_f83ff:
	ld a, $6
	ld [$c5d2], a
	ret

Func_f8406:
	call Func_f8440
Func_f8408:
	ret nc
	ld hl, $c5d1
	inc [hl]
	ret

Func_f840f:
	call Func_f9210
	ld a, [hJoyPressed]
	and $1
	ret z
	ld hl, $c5d1
	set 7, [hl]
	ret

Func_f841d:
	call Func_f9210
	call Func_f88ae
	call Func_f886b
	call Func_f8cb0
	call Func_f80ff
	ld hl, $c631
	ld a, [hl]
	and a
	jr z, .asm_f8435
	dec [hl]
	ret

.asm_f8435
	ld a, [hJoyPressed]
	and $1
	ret z
	ld hl, $c5d1
	set 7, [hl]
	ret

Func_f8440:
	ld hl, $c632
	ld a, [hl]
	and a
	jr z, .asm_f844a
	dec [hl]
	and a
	ret

.asm_f844a
	scf
	ret

Func_f844c:
	ld a, [$c5e6]
	ld h, a
	ld a, [$c5e7]
	ld l, a
	ld a, [$c5e3]
	ld e, a
	ld a, [$c5e4]
	ld d, a
	add hl, de
	ld a, h
	ld [$c5e6], a
	ld a, l
	ld [$c5e7], a
	ret nc
	ld hl, $c5e5
	inc [hl]
	ld hl, $c311
	dec [hl]
	dec [hl]
	ret
	ld a, [$c5d2]
	ld e, a
	ld d, $0
	ld hl, Jumptable_f847f
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

Jumptable_f847f:
	dw Func_f848d
	dw Func_f84e2
	dw Func_f8516
	dw Func_f8545
	dw Func_f8561
	dw Func_f856d
	dw Func_f8579

Func_f848d:
	ld a, [$c630]
	and a
	jr nz, .asm_f84d2
	call Func_f87b5
	ld a, [$c5ea]
	ld hl, $5
	add hl, bc
	ld [hl], a
	call Func_f871e
	jr c, .asm_f84aa
	call Func_f8742
	call Func_f86b8
	ret

.asm_f84aa
	call Func_f8742
	ld a, $1
	ld [$c5d2], a
	xor a
	ld hl, $c
	add hl, bc
	ld [hl], a
	ld hl, $d
	add hl, bc
	ld [hl], a
	ld hl, $e
	add hl, bc
	ld [hl], a
	ld [$c5d9], a
	ld [$c62f], a
	xor a
	ld [$c02d], a
	ld a, $91
	call PlaySound
	ret

.asm_f84d2
	xor a
	ld [$c5e3], a
	ld [$c5e4], a
	ld a, $4
	ld [$c5d2], a
	call Func_f8742
	ret

Func_f84e2:
	call Func_f8598
	call Func_f928c
	ret nc
	call Func_f8606
	jr c, .asm_f84fd
	call Func_f8bed
	ld hl, $c
	add hl, bc
	ld [hl], $0
	ld a, $2
	ld [$c5d2], a
	ret

.asm_f84fd
	ld a, $3
	ld [$c5d2], a
	ld a, $60
	ld [$c5e1], a
	ld a, $10
	call Func_fbcd4
	xor a
	ld [$c02d], a
	ld a, $93
	call PlaySound
	ret

Func_f8516:
	ld hl, $c
	add hl, bc
	ld a, [hl]
	cp $20
	jr nc, .asm_f8539
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	ld d, $4
	call Func_f9362
	ld hl, $7
	add hl, bc
	ld [hl], a
	call Func_f87b5
	ld a, [$c5ea]
	ld hl, $5
	add hl, bc
	ld [hl], a
	ret

.asm_f8539
	ld hl, $7
	add hl, bc
	ld [hl], $0
	ld a, $0
	ld [$c5d2], a
	ret

Func_f8545:
	ld hl, $c5e1
	ld a, [hl]
	and a
	jr z, .asm_f8556
	dec [hl]
	ld a, [$c5ea]
	ld hl, $5
	add hl, bc
	ld [hl], a
	ret

.asm_f8556
	ld a, $0
	ld [$c5d2], a
	ld a, $4
	call Func_fbcd4
	ret

Func_f8561:
	ld a, [$c5ea]
	ld hl, $5
	add hl, bc
	ld [hl], a
	call Func_f8742
	ret

Func_f856d:
	ld a, $f
	call Func_fbcd4
	ld hl, $c
	add hl, bc
	ld [hl], $0
	ret

Func_f8579:
	ld hl, $c
	add hl, bc
	ld a, [hl]
	inc [hl]
	inc [hl]
	and $3f
	cp $20
	jr c, .asm_f8591
	ld d, $10
	call Func_f9362
	ld hl, $7
	add hl, bc
	ld [hl], a
	ret

.asm_f8591
	ld hl, $7
	add hl, bc
	ld [hl], $0
	ret

Func_f8598:
	ld de, hJoy5
	ld a, [de]
	and $20
	jr nz, .asm_f85a6
	ld a, [de]
	and $10
	jr nz, .asm_f85cc
	ret

.asm_f85a6
	ld hl, $e
	add hl, bc
	ld [hl], $0
	ld hl, $d
	add hl, bc
	ld a, [hl]
	inc [hl]
	cp $b
	jr c, .asm_f85be
	call Func_f85f2
	ld hl, $c62f
	set 0, [hl]
.asm_f85be
	ld hl, $1
	add hl, bc
	ld a, [hl]
	cp $e
	jr nc, .asm_f85c9
	inc [hl]
	ret

.asm_f85c9
	ld [hl], $1
	ret

.asm_f85cc
	ld hl, $d
	add hl, bc
	ld [hl], $0
	ld hl, $e
	add hl, bc
	ld a, [hl]
	inc [hl]
	cp $d
	jr c, .asm_f85e4
	call Func_f85f2
	ld hl, $c62f
	set 1, [hl]
.asm_f85e4
	ld hl, $1
	add hl, bc
	ld a, [hl]
	cp $1
	jr z, .asm_f85ef
	dec [hl]
	ret

.asm_f85ef
	ld [hl], $e
	ret

Func_f85f2:
	call Func_f8bdf
	xor a
	ld hl, $d
	add hl, bc
	ld [hl], a
	ld hl, $e
	add hl, bc
	ld [hl], a
	ld a, $92
	call PlaySound
	ret

Func_f8606:
	ld hl, $1
	add hl, bc
	ld a, [$c5ef]
	cp $6
	jr z, .asm_f863d
	cp $14
	jr z, .asm_f867b
	cp $12
	jr z, .asm_f867b
	cp $7
	jr z, .asm_f865c
	ld a, [hl]
	cp $1
	jp z, .asm_f86ad
	cp $2
	jr z, .asm_f869a
	cp $3
	jr z, .asm_f869f
	cp $4
	jr z, .asm_f86a2
	cp $5
	jr z, .asm_f869f
	cp $6
	jr z, .asm_f869a
	cp $7
	jr z, .asm_f86ad
	jr .asm_f86ad

.asm_f863d
	ld a, [hl]
	cp $1
	jr z, .asm_f86ad
	cp $2
	jr z, .asm_f86ad
	cp $3
	jr z, .asm_f86ad
	cp $4
	jr z, .asm_f869a
	cp $5
	jr z, .asm_f869f
	cp $6
	jr z, .asm_f86a2
	cp $7
	jr z, .asm_f869f
	jr .asm_f86ad

.asm_f865c
	ld a, [hl]
	cp $1
	jr z, .asm_f869f
	cp $2
	jr z, .asm_f86a2
	cp $3
	jr z, .asm_f869f
	cp $4
	jr z, .asm_f869a
	cp $5
	jr z, .asm_f86ad
	cp $6
	jr z, .asm_f86ad
	cp $7
	jr z, .asm_f86ad
	jr .asm_f86ad

.asm_f867b
	ld a, [hl]
	cp $1
	jr z, .asm_f86ad
	cp $2
	jr z, .asm_f869a
	cp $3
	jr z, .asm_f869f
	cp $4
	jr z, .asm_f86a2
	cp $5
	jr z, .asm_f86a2
	cp $6
	jr z, .asm_f869f
	cp $7
	jr z, .asm_f869a
	jr .asm_f86ad

.asm_f869a
	call Func_f86f7
	jr .asm_f86a2

.asm_f869f
	call Func_f86d0
.asm_f86a2
	xor a
	ld [$c02d], a
	ld a, $95
	call PlaySound
	and a
	ret

.asm_f86ad
	ld a, $40
	ld [$c5e3], a
	xor a
	ld [$c5e4], a
	scf
	ret

Func_f86b8:
	ld a, [$c5e4]
	cp $2
	ret nc
	ld h, a
	ld a, [$c5e3]
	ld l, a
	ld de, $2
	add hl, de
	ld a, h
	ld [$c5e4], a
	ld a, l
	ld [$c5e3], a
	ret

Func_f86d0:
	ld a, [$c5e4]
	and a
	jr nz, .asm_f86e2
	ld a, [$c5e3]
	cp $40
	jr nc, .asm_f86e2
	xor a
	ld [$c5e3], a
	ret

.asm_f86e2
	ld a, [$c5e4]
	ld h, a
	ld a, [$c5e3]
	ld l, a
	ld de, $ffc0
	add hl, de
	ld a, h
	ld [$c5e4], a
	ld a, l
	ld [$c5e3], a
	ret

Func_f86f7:
	ld a, [$c5e4]
	and a
	jr nz, .asm_f8709
	ld a, [$c5e3]
	cp $80
	jr nc, .asm_f8709
	xor a
	ld [$c5e3], a
	ret

.asm_f8709
	ld a, [$c5e4]
	ld h, a
	ld a, [$c5e3]
	ld l, a
	ld de, $ff80
	add hl, de
	ld a, h
	ld [$c5e4], a
	ld a, l
	ld [$c5e3], a
	ret

Func_f871e:
	ld a, [hSCX]
	and $7
	cp $3
	jr c, .asm_f8740
	cp $5
	jr nc, .asm_f8740
	ld a, [$c5ef]
	cp $14
	jr nz, .asm_f8740
	call Func_f87a8
	cp $a
	jr c, .asm_f8740
	ld [$c5ec], a
	call Func_f9284
	scf
	ret

.asm_f8740
	and a
	ret

Func_f8742:
	ld a, [hSCX]
	and $7
	cp $3
	ret c
	cp $5
	ret nc
	ld a, [$c5ef]
	cp $6
	jr z, .asm_f8766
	cp $14
	jr z, .asm_f8766
	cp $7
	jr z, .asm_f876a
	call Func_f8778
	ld a, $4
	ld hl, $1
	add hl, bc
	ld [hl], a
	ret

.asm_f8766
	ld a, $6
	jr .asm_f876c

.asm_f876a
	ld a, $2
.asm_f876c
	ld e, a
	ld a, [$c5de]
	dec a
	add e
	ld hl, $1
	add hl, bc
	ld [hl], a
	ret

Func_f8778:
	ld hl, $c5e0
	ld a, [hl]
	inc [hl]
	and $7
	ret nz
	ld a, [$c5df]
	and a
	jr z, .asm_f8796
	ld a, [$c5de]
	and a
	jr z, .asm_f8791
	dec a
	ld [$c5de], a
	ret

.asm_f8791
	xor a
	ld [$c5df], a
	ret

.asm_f8796
	ld a, [$c5de]
	cp $2
	jr z, .asm_f87a2
	inc a
	ld [$c5de], a
	ret

.asm_f87a2
	ld a, $1
	ld [$c5df], a
	ret

Func_f87a8:
	ld a, [$c5e3]
	ld l, a
	ld a, [$c5e4]
	ld h, a
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, h
	ret

Func_f87b5:
	ld hl, $c5eb
	ld a, [hl]
	inc [hl]
	and $3
	ret nz
	call Func_f87ce
	ld d, a
	ld hl, $4
	add hl, bc
	ld e, [hl]
	ld a, $a
	push bc
	call Func_fbb93
	pop bc
	ret

Func_f87ce:
	ld a, [hSCX]
	and $8
	jr nz, .asm_f87d9
	ld hl, $c622
	jr .asm_f87dc

.asm_f87d9
	ld hl, $c623
.asm_f87dc
	ld a, [$c5f0]
	cp $6
	jr z, .asm_f87ed
	cp $14
	jr z, .asm_f87ed
	cp $7
	jr z, .asm_f87f5
	ld a, [hl]
	ret

.asm_f87ed
	ld a, [hSCX]
	and $7
	ld e, a
	ld a, [hl]
	sub e
	ret

.asm_f87f5
	ld a, [hSCX]
	and $7
	add [hl]
	ret
	ld hl, $4
	add hl, bc
	ld a, [hl]
	cp $58
	ret z
	add $4
	ld [hl], a
	ret
	call Func_fbbe8
	ret
	ld hl, $b
	add hl, bc
	ld a, [hl]
	and a
	ret z
	dec [hl]
	dec [hl]
	ld d, a
	ld hl, $c
	add hl, bc
	ld a, [hl]
	inc [hl]
	call Func_f9362
	cp $80
	jr nc, .asm_f8825
	xor $ff
	inc a
.asm_f8825
	ld hl, $7
	add hl, bc
	ld [hl], a
	ret
	ld hl, $b
	add hl, bc
	ld a, [hl]
	inc [hl]
	and $1
	ret z
	ld hl, $4
	add hl, bc
	ld a, [hl]
	cp $c0
	jr z, .asm_f883f
	inc [hl]
	ret

.asm_f883f
	ld a, $1
	ld [$c633], a
	call Func_fbbe8
	ret

Func_f8848:
	ld a, [$c635]
	ld e, a
	ld d, $0
	ld a, [$c5e3]
	ld l, a
	ld a, [$c5e4]
	ld h, a
	add hl, de
	ld a, l
	ld [$c635], a
	ld d, h
	ld hl, $c315
	ld e, $9
.asm_f8861
	ld a, [hl]
	add d
	ld [hli], a
	inc hl
	inc hl
	inc hl
	dec e
	jr nz, .asm_f8861
	ret

Func_f886b:
	ld a, [$c5ef]
	ld a, [hSCX]
	add $48
	ld e, a
	srl e
	srl e
	srl e
	ld d, $0
	ld hl, $9800
	add hl, de
	ld a, [$c5ea]
	srl a
	srl a
	srl a
	ld c, a
.asm_f8889
	ld a, c
	and a
	jr z, .asm_f889a
	dec c
	ld de, $20
	add hl, de
	ld a, h
	and $3
	or $98
	ld h, a
	jr .asm_f8889

.asm_f889a
	ld de, $c5ef
	ld a, e
	ld [H_VBCOPYDEST], a
	ld a, d
	ld [$ffca], a
	ld a, l
	ld [H_VBCOPYSRC], a
	ld a, h
	ld [$ffc8], a
	ld a, $1
	ld [H_VBCOPYSIZE], a
	ret

Func_f88ae:
	ld a, [hSCX]
	and $8
	jr nz, .asm_f88b9
	ld hl, $c621
	jr .asm_f88bc

.asm_f88b9
	ld hl, $c622
.asm_f88bc
	ld a, [$c5ef]
	cp $6
	jr z, .asm_f88d0
	cp $14
	jr z, .asm_f88d0
	cp $7
	jr z, .asm_f88db
	ld a, [hl]
	ld [$c5ea], a
	ret

.asm_f88d0
	ld a, [hSCX]
	and $7
	ld e, a
	ld a, [hl]
	sub e
	ld [$c5ea], a
	ret

.asm_f88db
	ld a, [hSCX]
	and $7
	add [hl]
	ld [$c5ea], a
	ret

Func_f88e4:
	ld hl, $c5d6
	ld e, $99
	call Func_f88f0
	ret nc
	inc hl
	ld e, $99
Func_f88f0:
	ld a, [hl]
	and a
	jr z, .asm_f88fa
	sub $1
	daa
	ld [hl], a
	and a
	ret

.asm_f88fa
	ld [hl], e
	scf
	ret

Func_f88fd:
	ld de, $c5d7
	ld hl, $c302
	ld a, [de]
	call Func_f890b
	ld hl, $c30a
	ld a, [de]
Func_f890b:
	ld c, a
	swap a
	and $f
	add $d0
	ld [hli], a
	inc hl
	inc hl
	inc hl
	ld a, c
	and $f
	add $d0
	ld [hl], a
	dec de
	ret

Func_f891e:
	ld hl, wTileMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	xor a
	call FillMemory
	ld hl, Tilemap_f8946
	coord de, 0, 6
	ld bc, Tilemap_f8946End - Tilemap_f8946
	call CopyData
	call Func_f8a0e
	ld hl, $c315
	ld bc, $24
	xor a
	call FillMemory
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	ret

Tilemap_f8946:
INCBIN "gfx/unknown_f8946.map"
Tilemap_f8946End:

Func_f8a0e:
	coord hl, 1, 1
	lb de, $3b, $3c
	ld a, $40
	call Func_f8a72
	coord hl, 1, 2
	lb de, $3f, $3f
	ld a, $ff
	call Func_f8a72
	coord hl, 1, 3
	lb de, $3f, $3f
	ld a, $ff
	call Func_f8a72
	coord hl, 1, 4
	lb de, $3f, $3f
	ld a, $ff
	call Func_f8a72
	coord hl, 1, 5
	lb de, $3f, $3f
	ld a, $ff
	call Func_f8a72
	coord hl, 1, 6
	lb de, $3f, $3f
	ld a, $ff
	call Func_f8a72
	coord hl, 1, 7
	lb de, $3f, $3f
	ld a, $ff
	call Func_f8a72
	coord hl, 1, 8
	lb de, $3f, $3f
	ld a, $ff
	call Func_f8a72
	coord hl, 1, 9
	lb de, $3d, $3e
	ld a, $40
	call Func_f8a72
	ret

Func_f8a72:
	ld [hl], d
	inc hl
	ld c, $10
.asm_f8a76
	ld [hli], a
	dec c
	jr nz, .asm_f8a76
	ld [hl], e
	ret

Func_f8a7c:
	ld hl, Tilemap_f8a89
	coord de, 6, 8
	ld bc, $9
	call CopyData
	ret

Tilemap_f8a89:
	db $20,$2e,$2f,$30,$31,$2c,$32,$23,$33

Func_f8a92:
	ld hl, Tilemap_f8aa2
	coord de, 2, 2
	ld bc, $7
	call CopyData
	call Func_f8aca
	ret

Tilemap_f8aa2:
	db $20,$21,$ff,$22,$23,$24,$25

Func_f8aa9:
	ld c, $63
.asm_f8aab
	push bc
	ld hl, $c5d6
	ld a, [hli]
	or [hl]
	and a
	jr z, .asm_f8ac7
	call Func_f88e4
	ld e, $1
.asm_f8ab9
	call Func_f8b42
	pop bc
	dec c
	jr nz, .asm_f8aab
.asm_f8abf
	ld a, $90
	call PlaySound
.asm_f8ac5
	and a
	ret

.asm_f8ac7
	pop bc
	scf
	ret

Func_f8aca:
	coord hl, 10, 2
	ld de, $c5d7
	ld a, [de]
	call Func_f9350
	inc hl
	ld a, [de]
	call Func_f9350
	inc hl
	inc hl
	ld [hl], $21
	inc hl
	ld [hl], $25
	inc hl
	ld [hl], $26
	ret

Func_f8ae4:
	ld hl, Tilemap_f8af4
	coord de, 2, 4
	ld bc, $7
	call CopyData
	call Func_f8b25
	ret

Tilemap_f8af4:
	db $27,$28,$29,$2a,$23,$26,$26

Func_f8afb:
	ld c, $63
.asm_f8afd
	push bc
	ld hl, $c5da
	ld a, [hli]
	ld e, a
	or [hl]
	jr z, .asm_f8b22
	ld d, [hl]
	ld a, e
	sub $1
	daa
	ld e, a
	ld a, d
	sbc $0
	daa
	ld [hld], a
	ld [hl], e
	ld e, $1
	call Func_f8b42
	pop bc
	dec c
	jr nz, .asm_f8afd
	ld a, $90
	call PlaySound
.asm_f8b20
	and a
	ret

.asm_f8b22
	pop bc
	scf
	ret

Func_f8b25:
	ld a, [$c5db]
	coord hl, 10, 4
	call Func_f9350
	ld a, [$c5da]
	coord hl, 12, 4
	call Func_f9350
	inc hl
	inc hl
	ld [hl], $21
	inc hl
	ld [hl], $25
	inc hl
	ld [hl], $26
	ret

Func_f8b42:
	ld a, [$c5dc]
	add e
	daa
	ld [$c5dc], a
	ld a, [$c5dd]
	adc $0
	daa
	ld [$c5dd], a
	ret nc
	ld a, $99
	ld [$c5dc], a
	ld [$c5dd], a
	ret

Func_f8b5d:
	ld a, [$c5dd]
	coord hl, 10, 6
	call Func_f9350
	ld a, [$c5dc]
	coord hl, 12, 6
	call Func_f9350
	inc hl
	inc hl
	ld [hl], $21
	inc hl
	ld [hl], $25
	inc hl
	ld [hl], $26
	ret

Func_f8b7a:
	ld hl, Tilemap_f8b8d
	coord de, 2, 6
	ld bc, $5
	call CopyData
	call Func_f8b25
	call Func_f8b5d
	ret

Tilemap_f8b8d:
	db $2b,$2c,$25,$28,$2d
	
Func_f8b92:
	ld hl, wd496
	ld a, [$c5dd]
	cp [hl]
	jr c, .asm_f8ba6
	jr nz, .asm_f8bb0
	dec hl
	ld a, [$c5dc]
	cp [hl]
	jr c, .asm_f8ba6
	jr nz, .asm_f8bb0
.asm_f8ba6
	call WaitForSoundToFinish
	ld e, $1b
	call Func_f8bcb
	and a
	ret

.asm_f8bb0
	ld a, [$c5dc]
	ld [wd495], a
	ld a, [$c5dd]
	ld [wd496], a
	call WaitForSoundToFinish
	ld e, $21
	call Func_f8bcb
	ld a, $96
	call PlaySound
	scf
	ret

Func_f8bcb: ; f8bcb (3e:4bcb)
	push de
	callab IsSurfingPikachuInThePlayersParty
	pop de
	ret nc
	callab PlayPikachuSoundClip
	ret

Func_f8bdf:
	ld a, [$c5d9]
	inc a
	cp $4
	jr c, .asm_f8be9
	ld a, $3
.asm_f8be9
	ld [$c5d9], a
	ret

Func_f8bed:
	ld a, [$c5d9]
	and a
	ret z
	ld a, [$c62f]
	and $3
	cp $3
	jr z, .asm_f8c2b
	ld a, [$c5d9]
	ld d, a
	ld e, $1
	ld a, $0
.asm_f8c03
	add e
	sla e
	dec d
	jr nz, .asm_f8c03
.asm_f8c09
	push af
	ld e, $50
	call Func_f8c7c
	pop af
	dec a
	jr nz, .asm_f8c09
	ld hl, $5
	add hl, bc
	ld a, [hl]
	sub $10
	ld d, a
	ld hl, $4
	add hl, bc
	ld e, [hl]
	ld a, [$c5d9]
	add $3
	push bc
	call Func_fbb93
	pop bc
	ret

.asm_f8c2b
	ld a, [$c5d9]
	cp $3
	jr c, .asm_f8c53
	ld a, $a
.asm_f8c34
	push af
	ld e, $50
	call Func_f8c7c
	pop af
	dec a
	jr nz, .asm_f8c34
	ld hl, $5
	add hl, bc
	ld a, [hl]
	sub $10
	ld d, a
	ld hl, $4
	add hl, bc
	ld e, [hl]
	ld a, $9
	push bc
	call Func_fbb93
	pop bc
	ret

.asm_f8c53
	ld e, $50
	call Func_f8c7c
	ld e, $50
	call Func_f8c7c
	ld e, $50
	call Func_f8c7c
	ld e, $30
	call Func_f8c7c
	ld hl, $5
	add hl, bc
	ld a, [hl]
	sub $10
	ld d, a
	ld hl, $4
	add hl, bc
	ld e, [hl]
	ld a, $8
	push bc
	call Func_fbb93
	pop bc
	ret

Func_f8c7c:
	ld a, [$c5da]
	add e
	daa
	ld [$c5da], a
	ld a, [$c5db]
	adc $0
	daa
	ld [$c5db], a
	ret nc
	ld a, $99
	ld [$c5da], a
	ld [$c5db], a
	ret

Func_f8c97:
	ld a, $a0
	ld [$c62e], a
	ld a, [hSCX]
	ld h, a
	ld a, [$c617]
	ld l, a
	ld de, $900
	add hl, de
	ld a, l
	ld [$c617], a
	ld a, h
	ld [hSCX], a
	jr Func_f8cc7

Func_f8cb0:
	ld a, $a0
	ld [$c62e], a
	ld a, [hSCX]
	ld h, a
	ld a, [$c617]
	ld l, a
	ld de, $180
	add hl, de
	ld a, l
	ld [$c617], a
	ld a, h
	ld [hSCX], a
Func_f8cc7:
	ld hl, $c618
	ld a, [hSCX]
	cp [hl]
	ret z
	ld [hl], a
	and $f0
	ld hl, $c619
	cp [hl]
	ret z
	ld [hl], a
	call Func_f8d44
	ld a, b
	ld [$c5e8], a
	ld a, c
	ld [$c5e9], a
	push de
	ld hl, $c61a
	ld de, $c61c
	ld c, $12
.asm_f8ceb
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .asm_f8ceb
	ld a, [$c5e8]
	ld [hli], a
	ld a, [$c5e9]
	ld [hl], a
	pop de
	ld hl, wRedrawRowOrColumnSrcTiles
	ld c, $8
.asm_f8cff
	ld a, [de]
	call Func_f8d28
	inc de
	dec c
	jr nz, .asm_f8cff
	ld a, [$c62e]
	ld e, a
	ld a, [hSCX]
	add e
	and $f0
	srl a
	srl a
	srl a
	ld e, a
	ld d, $0
	ld hl, $9800
	add hl, de
	ld a, l
	ld [hRedrawRowOrColumnDest], a
	ld a, h
	ld [$ffd2], a
	ld a, $1
	ld [hRedrawRowOrColumnMode], a
	ret

Func_f8d28:
	push de
	push hl
	ld l, a
	ld h, $0
	ld de, Unkn_f96e5
	add hl, hl
	add hl, hl
	add hl, de
	ld e, l
	ld d, h
	pop hl
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	pop de
	ret

Func_f8d44:
	ld a, [$c5d3]
	ld e, a
	ld d, $0
	ld hl, Jumptable_f8d53
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

Jumptable_f8d53:
	dw Func_f8e4b
	dw Func_f8f28
	dw Func_f8f31
	dw Func_f8f3a
	dw Func_f8f43
	dw Func_f8e7d
	dw Func_f8f4c
	dw Func_f8f55
	dw Func_f8f5e
	dw Func_f8e7d
	dw Func_f8e7d
	dw Func_f8e7d
	dw Func_f8e7d
	dw Func_f8f94
	dw Func_f8ec5
	dw Func_f8ece
	dw Func_f8ed7
	dw Func_f8ee0
	dw Func_f8ee9
	dw Func_f8ef2
	dw Func_f8e7d
	dw Func_f8e7d
	dw Func_f8e7d
	dw Func_f8e7d
	dw Func_f8e7d
	dw Func_f8f94
	dw Func_f8efb
	dw Func_f8f04
	dw Func_f8f0d
	dw Func_f8f16
	dw Func_f8f1f
	dw Func_f8efb
	dw Func_f8f04
	dw Func_f8f0d
	dw Func_f8f16
	dw Func_f8f1f
	dw Func_f8e7d
	dw Func_f8e7d
	dw Func_f8e7d
	dw Func_f8e7d
	dw Func_f8f94
	dw Func_f8f28
	dw Func_f8f31
	dw Func_f8f3a
	dw Func_f8f43
	dw Func_f8e7d
	dw Func_f8e7d
	dw Func_f8e7d
	dw Func_f8e7d
	dw Func_f8f94
	dw Func_f8f4c
	dw Func_f8f55
	dw Func_f8f5e
	dw Func_f8f4c
	dw Func_f8f55
	dw Func_f8f5e
	dw Func_f8f4c
	dw Func_f8f55
	dw Func_f8f5e
	dw Func_f8e7d
	dw Func_f8e7d
	dw Func_f8e7d
	dw Func_f8e7d
	dw Func_f8f94
	dw Func_f8f67
	dw Func_f8f70
	dw Func_f8efb
	dw Func_f8f04
	dw Func_f8f0d
	dw Func_f8f16
	dw Func_f8f1f
	dw Func_f8f67
	dw Func_f8f70
	dw Func_f8e7d
	dw Func_f8e7d
	dw Func_f8e7d
	dw Func_f8f94
	dw Func_f8ec5
	dw Func_f8ece
	dw Func_f8ed7
	dw Func_f8ee0
	dw Func_f8ee9
	dw Func_f8ef2
	dw Func_f8e7d
	dw Func_f8f67
	dw Func_f8f70
	dw Func_f8f67
	dw Func_f8f70
	dw Func_f8e7d
	dw Func_f8e7d
	dw Func_f8e7d
	dw Func_f8f94
	dw Func_f8efb
	dw Func_f8f04
	dw Func_f8f0d
	dw Func_f8f16
	dw Func_f8f1f
	dw Func_f8f28
	dw Func_f8f31
	dw Func_f8f3a
	dw Func_f8f43
	dw Func_f8e7d
	dw Func_f8e7d
	dw Func_f8e7d
	dw Func_f8e7d
	dw Func_f8f94
	dw Func_f8e86
	dw Func_f8e8f
	dw Func_f8e98
	dw Func_f8ea1
	dw Func_f8eaa
	dw Func_f8eb3
	dw Func_f8ebc
	dw Func_f8f9d
	dw Func_f8e7d
	dw Func_f8f79
	dw Func_f8f82
	dw Func_f8f82
	dw Func_f8f82
	dw Func_f8f82
	dw Func_f8f82
	dw Func_f8f82
	dw Func_f8f82
	dw Func_f8f8b

Func_f8e4b:
	ld a, [$c5e5]
	cp $16
	jr c, .asm_f8e5a
	jr z, .asm_f8e56
	jr nc, .asm_f8e6e
.asm_f8e56
	ld a, $6a
	jr .asm_f8e6b

.asm_f8e5a
	ld a, [$c5d5]
	and a
	jr z, .asm_f8e6e
	dec a
	and $7
	ld e, a
	ld d, $0
	ld hl, Unkn_f8e75
	add hl, de
	ld a, [hl]
.asm_f8e6b
	ld [$c5d3], a
.asm_f8e6e
	lb bc, $74, $74
	ld de, Unkn_f973d
	ret

Unkn_f8e75:
	db $01,$0e,$1a,$29,$32,$40,$4d,$5c

Func_f8e7d:
	lb bc, $74, $74
	ld de, Unkn_f973d
	jp Func_f8fa9

Func_f8e86:
	lb bc, $74, $6c
	ld de, Unkn_f9745
	jp Func_f8fa9

Func_f8e8f:
	lb bc, $64, $5c
	ld de, Unkn_f974d
	jp Func_f8fa9

Func_f8e98:
	lb bc, $54, $4c
	ld de, Unkn_f9755
	jp Func_f8fa9

Func_f8ea1:
	lb bc, $44, $44
	ld de, Unkn_f975d
	jp Func_f8fa9

Func_f8eaa:
	lb bc, $44, $4c
	ld de, Unkn_f9765
	jp Func_f8fa9

Func_f8eb3:
	lb bc, $54, $5c
	ld de, Unkn_f976d
	jp Func_f8fa9

Func_f8ebc:
	lb bc, $64, $6c
	ld de, Unkn_f9775
	jp Func_f8fa9

Func_f8ec5:
	lb bc, $74, $6c
	ld de, Unkn_f977d
	jp Func_f8fa9

Func_f8ece:
	lb bc, $64, $5c
	ld de, Unkn_f9785
	jp Func_f8fa9

Func_f8ed7:
	lb bc, $54, $4c
	ld de, Unkn_f978d
	jp Func_f8fa9

Func_f8ee0:
	lb bc, $4c, $4c
	ld de, Unkn_f9795
	jp Func_f8fa9

Func_f8ee9:
	lb bc, $54, $5c
	ld de, Unkn_f979d
	jp Func_f8fa9

Func_f8ef2:
	lb bc, $64, $6c
	ld de, Unkn_f97a5
	jp Func_f8fa9

Func_f8efb:
	lb bc, $74, $6c
	ld de, Unkn_f97ad
	jp Func_f8fa9

Func_f8f04:
	lb bc, $64, $5c
	ld de, Unkn_f97b5
	jp Func_f8fa9

Func_f8f0d:
	lb bc, $54, $54
	ld de, Unkn_f97bd
	jp Func_f8fa9

Func_f8f16:
	lb bc, $54, $5c
	ld de, Unkn_f97c5
	jp Func_f8fa9

Func_f8f1f:
	lb bc, $64, $6c
	ld de, Unkn_f97cd
	jp Func_f8fa9

Func_f8f28:
	lb bc, $74, $6c
	ld de, Unkn_f97d5
	jp Func_f8fa9

Func_f8f31:
	lb bc, $64, $5c
	ld de, Unkn_f97dd
	jp Func_f8fa9

Func_f8f3a:
	lb bc, $5c, $5c
	ld de, Unkn_f97e5
	jp Func_f8fa9

Func_f8f43:
	lb bc, $64, $6c
	ld de, Unkn_f97ed
	jp Func_f8fa9

Func_f8f4c:
	lb bc, $74, $6c
	ld de, Unkn_f97f5
	jp Func_f8fa9

Func_f8f55:
	lb bc, $64, $64
	ld de, Unkn_f97fd
	jp Func_f8fa9

Func_f8f5e:
	lb bc, $64, $6c
	ld de, Unkn_f9805
	jp Func_f8fa9

Func_f8f67:
	lb bc, $74, $6c
	ld de, Unkn_f980d
	jp Func_f8fa9

Func_f8f70:
	lb bc, $6c, $6c
	ld de, Unkn_f9815
	jp Func_f8fa9

Func_f8f79:
	lb bc, $74, $74
	ld de, Unkn_f981d
	jp Func_f8fa9

Func_f8f82:
	lb bc, $74, $74
	ld de, Unkn_f9825
	jp Func_f8fa9

Func_f8f8b:
	lb bc, $74, $74
	ld de, Unkn_f9825
	jp Func_f8fae

Func_f8f94:
	lb bc, $74, $74
	ld de, Unkn_f973d
	jp Func_f8fae

Func_f8f9d:
	lb bc, $74, $74
	ld de, Unkn_f973d
	ret

Func_f8fa4:
	inc a
	ld [$c5d3], a
	ret

Func_f8fa9:
	ld hl, $c5d3
	inc [hl]
	ret

Func_f8fae:
	xor a
	ld [$c5d3], a
	ret

Func_f8fb3:
	dr $f8fb3,$f9210
Func_f9210:
	dr $f9210,$f9223
Func_f9223:
	dr $f9223,$f923f
Func_f923f:
	dr $f923f,$f9254
Func_f9254:
	dr $f9254,$f9279
Func_f9279:
	dr $f9279,$f9284
Func_f9284:
	dr $f9284,$f928c
Func_f928c:
	dr $f928c,$f9350
Func_f9350:
	dr $f9350,$f9362
Func_f9362:
	dr $f9362,$f96e5

Unkn_f96e5:
	dr $f96e5,$f973d
Unkn_f973d:
	dr $f973d,$f9745
Unkn_f9745:
	dr $f9745,$f974d
Unkn_f974d:
	dr $f974d,$f9755
Unkn_f9755:
	dr $f9755,$f975d
Unkn_f975d:
	dr $f975d,$f9765
Unkn_f9765:
	dr $f9765,$f976d
Unkn_f976d:
	dr $f976d,$f9775
Unkn_f9775:
	dr $f9775,$f977d
Unkn_f977d:
	dr $f977d,$f9785
Unkn_f9785:
	dr $f9785,$f978d
Unkn_f978d:
	dr $f978d,$f9795
Unkn_f9795:
	dr $f9795,$f979d
Unkn_f979d:
	dr $f979d,$f97a5
Unkn_f97a5:
	dr $f97a5,$f97ad
Unkn_f97ad:
	dr $f97ad,$f97b5
Unkn_f97b5:
	dr $f97b5,$f97bd
Unkn_f97bd:
	dr $f97bd,$f97c5
Unkn_f97c5:
	dr $f97c5,$f97cd
Unkn_f97cd:
	dr $f97cd,$f97d5
Unkn_f97d5:
	dr $f97d5,$f97dd
Unkn_f97dd:
	dr $f97dd,$f97e5
Unkn_f97e5:
	dr $f97e5,$f97ed
Unkn_f97ed:
	dr $f97ed,$f97f5
Unkn_f97f5:
	dr $f97f5,$f97fd
Unkn_f97fd:
	dr $f97fd,$f9805
Unkn_f9805:
	dr $f9805,$f980d
Unkn_f980d:
	dr $f980d,$f9815
Unkn_f9815:
	dr $f9815,$f981d
Unkn_f981d:
	dr $f981d,$f9825
Unkn_f9825:
	dr $f9825,$f982d
PlayIntroScene: ; f982d (3e:582d)
	dr $f982d,$fa35a

YellowIntroGraphics:  INCBIN "gfx/yellow_intro.2bpp"

Func_fbb5a: ; fbb5a (3e:7b5a)
	ld hl, wTileMapBackup
	ld bc, 10 * SCREEN_WIDTH
	xor a
	call FillMemory
	ret

Func_fbb65: ; fbb65 (3e:7b65)
	dr $fbb65,$fbb93
Func_fbb93:
	dr $fbb93,$fbbe8
Func_fbbe8:
	dr $fbbe8,$fbcd4
Func_fbcd4:
	dr $fbcd4,$fbd76
