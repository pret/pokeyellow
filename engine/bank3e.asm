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

Func_f80b7:
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

Func_f8470
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

Func_f87fb:
	ld hl, $4
	add hl, bc
	ld a, [hl]
	cp $58
	ret z
	add $4
	ld [hl], a
	ret

Func_f8807:
	call Func_fbbe8
	ret

Func_f880b:
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

Func_f882b:
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
	call Func_f9279
	call ClearSprites
	call DisableLCD
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	call Func_fbb5a
	ld hl, $6324
	ld de, $8800
	ld bc, $900
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
	ld a, $c
	ld de, $7458
	call Func_fbb93
	call Func_f9053
	xor a
	ld [hSCX], a
	ld [hSCY], a
	ld a, $90
	ld [hWY], a
	ld b, $f
	call RunPaletteCommand
	ld a, $e3
	ld [rLCDC], a
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	call DelayFrame
	call DelayFrame
	call DelayFrame
	call Func_f81e9
	ld a, $e4
	ld [rOBP0], a
	ld a, $e0
	ld [rOBP1], a
	call UpdateGBCPal_OBP0
	call UpdateGBCPal_OBP1
	call DelayFrame
	ld a, $99
	ld c, $20
	call PlayMusic
	xor a
	ld [$c633], a
.asm_f9041
	ld a, [$c633]
	and a
	ret nz
	ld a, $0
	ld [$c5bd], a
	call Func_fbb65
	call DelayFrame
	jr .asm_f9041

Func_f9053:
	ld hl, wTileMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, $ff
	call FillMemory
	ld hl, Unkn_f90bc
	coord de, 0, 6
	ld bc, 12 * SCREEN_WIDTH
	call CopyData
	ld de, Unkn_f91c8
	coord hl, 4, 0
	lb bc, 6, 12
	call Func_f9098
	coord hl, 3, 7
	lb bc, 3, 15
	call Func_f90aa
	ld hl, Unkn_f91ac
	coord de, 3, 7
	ld bc, 15
	call CopyData
	ld hl, Unkn_f91bb
	coord de, 4, 9
	ld bc, 13
	call CopyData
	ret

Func_f9098:
.asm_f9098
	push bc
	push hl
.asm_f909a
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .asm_f909a
	ld bc, $14
	pop hl
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_f9098
	ret

Func_f90aa:
.asm_f90aa
	push bc
	push hl
.asm_f90ac
	ld [hl], $ff
	inc hl
	dec c
	jr nz, .asm_f90ac
	pop hl
	ld bc, $14
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_f90aa
	ret

Unkn_f90bc:
	dr $f90bc,$f91ac
Unkn_f91ac:
	dr $f91ac,$f91bb
Unkn_f91bb:
	dr $f91bb,$f91c8
Unkn_f91c8:
	dr $f91c8,$f9210

Func_f9210:
	ld hl, $c710
	ld de, $c711
	ld c, $80
	ld a, [hl]
	push af
.asm_f921a
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .asm_f921a
	pop af
	ld [hl], a
	ret

Func_f9223:
	ld hl, $c700
	ld bc, $100
	ld de, $0
.asm_f922c
	ld a, e
	and $1f
	ld e, a
	push hl
	ld hl, Unkn_f96c5
	add hl, de
	ld a, [hl]
	pop hl
	ld [hli], a
	inc e
	dec bc
	ld a, c
	or b
	jr nz, .asm_f922c
	ret

Func_f923f:
	call Joypad
	ld a, [H_FRAMECOUNTER]
	and a
	jr nz, .asm_f9250
	ld a, [hJoyHeld]
	ld [hJoy5], a
	ld a, $2
	ld [H_FRAMECOUNTER], a
	ret

.asm_f9250
	xor a
	ld [hJoy5], a
	ret

Func_f9254:
	xor a
	ld [rBGP], a
	ld [rOBP0], a
	ld [rOBP1], a
	call UpdateGBCPal_BGP
	call UpdateGBCPal_OBP0
	call UpdateGBCPal_OBP1
	ret

Func_f9265:
	ld a, $e4
	ld [rBGP], a
	ld [rOBP0], a
	ld a, $e0
	ld [rOBP1], a
	call UpdateGBCPal_BGP
	call UpdateGBCPal_OBP0
	call UpdateGBCPal_OBP1
	ret

Func_f9279:
	ld hl, wTileMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	xor a
	call FillMemory
	ret

Func_f9284:
	xor a
	ld [$c5ed], a
	ld [$c5ee], a
	ret

Func_f928c:
	ld a, [$c5ed]
	and a
	jr nz, .asm_f92e4
	ld a, [$c5ec]
	ld d, a
	ld a, [$c5ee]
	or d
	jr z, .asm_f92dd
	ld a, [$c5ee]
	ld e, a
	ld hl, $ff80
	add hl, de
	ld a, l
	ld [$c5ee], a
	ld a, h
	ld [$c5ec], a
	ld e, a
	ld d, $0
	call Func_f9340
	ld e, l
	ld d, h
	ld a, $4
	call Func_f9340
	ld a, l
	xor $ff
	inc a
	ld l, a
	ld a, h
	xor $ff
	ld h, a
	push hl
	ld hl, $5
	add hl, bc
	ld d, [hl]
	ld hl, $c
	add hl, bc
	ld e, [hl]
	pop hl
	add hl, de
	ld e, l
	ld d, h
	ld hl, $5
	add hl, bc
	ld [hl], d
	ld hl, $c
	add hl, bc
	ld [hl], e
	and a
	ret

.asm_f92dd
	ld a, $1
	ld [$c5ed], a
	and a
	ret

.asm_f92e4
	ld a, [$c5ea]
	ld e, a
	ld hl, $5
	add hl, bc
	ld a, [hl]
	cp $90
	jr nc, .asm_f92f4
	cp e
	jr nc, .asm_f9330
.asm_f92f4
	ld a, [$c5ec]
	ld d, a
	ld a, [$c5ee]
	ld e, a
	ld hl, $80
	add hl, de
	ld a, l
	ld [$c5ee], a
	ld a, h
	ld [$c5ec], a
	ld e, a
	ld d, $0
	call Func_f9340
	ld e, l
	ld d, h
	ld a, $4
	call Func_f9340
	push hl
	ld hl, $5
	add hl, bc
	ld d, [hl]
	ld hl, $c
	add hl, bc
	ld e, [hl]
	pop hl
	add hl, de
	ld e, l
	ld d, h
	ld hl, $5
	add hl, bc
	ld [hl], d
	ld hl, $c
	add hl, bc
	ld [hl], e
	and a
	ret

.asm_f9330
	ld hl, $5
	add hl, bc
	ld a, [$c5ea]
	ld [hl], a
	ld hl, $c
	add hl, bc
	ld [hl], $0
	scf
	ret

Func_f9340:
	ld hl, $0
.asm_f9343
	srl a
	jr nc, .asm_f9348
	add hl, de
.asm_f9348
	sla e
	rl d
	and a
	jr nz, .asm_f9343
	ret

Func_f9350:
	ld c, a
	swap a
	and $f
	add $d0
	ld [hli], a
	ld a, c
	and $f
	add $d0
	ld [hl], a
	dec de
	ret

Func_f9360: ; cosine
	add $10
Func_f9362: ; sine
	and $3f
	cp $20
	jr nc, .asm_f936d
	call Func_f9377
	ld a, h
	ret

.asm_f936d
	and $1f
	call Func_f9377
	ld a, h
	xor $ff
	inc a
	ret

Func_f9377:
	ld e, a
	ld a, d
	ld d, $0
	ld hl, Unkn_f9393
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $0
.asm_f9386
	srl a
	jr nc, .asm_f938b
	add hl, de
.asm_f938b
	sla e
	rl d
	and a
	jr nz, .asm_f9386
	ret

Unkn_f9393:
	sine_wave $100

Unkn_f93d3:
	dr $f93d3,$f96c5
	
Unkn_f96c5:
	db 0
	db 0
	db 0
	db 1
	db 1
	db 1
	db 1
	db 2
	db 2
	db 2
	db 1
	db 1
	db 1
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db -1
	db -1
	db -1
	db -1
	db -2
	db -2
	db -2
	db -1
	db -1
	db -1
	db -1
	db 0
	db 0

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

PlayIntroScene:
	ld a, [rIE]
	push af
	xor a
	ld [rIF], a
	ld a, $f
	ld [rIE], a
	ld a, $8
	ld [rSTAT], a
	call Func_f9f0d
	call DelayFrame
.asm_f9841
	ld a, [$c634]
	bit 7, a
	jr nz, .asm_f986e
	call JoypadLowSensitivity
	ld a, [hJoyPressed]
	and $b
	jr nz, .asm_f986e
	call Func_f98fc
	ld a, $0
	ld [$c5bd], a
	call Func_fbb65
	ld a, [$c634]
	cp $7
	call z, Func_f98a2
	cp $b
	call z, Func_f98cb
	call DelayFrame
	jr .asm_f9841

.asm_f986e
	call Func_f9fc9
	xor a
	ld [hLCDCPointer], a
	call DelayFrame
	xor a
	ld [rIF], a
	pop af
	ld [rIE], a
	ld a, $90
	ld [hWY], a
	call Func_fbb5a
	ld hl, wTileMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	xor a
	call Func_f9fb3
	call Func_f9fbe
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	call DelayFrame
	call DelayFrame
	call DelayFrame
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ret

Func_f98a2:
	ld a, [$c323]
	or $1
	ld [$c323], a
	ld a, [$c33b]
	or $1
	ld [$c33b], a
	ld a, [$c343]
	or $1
	ld [$c343], a
Func_f98b8:
	ld a, [$c34b]
	or $1
	ld [$c34b], a
	ld a, [$c34f]
	or $1
	ld [$c34f], a
	ret

Func_f98cb:
	ld a, [$c34b]
	or $1
	ld [$c34b], a
	ld a, [$c34f]
	or $1
	ld [$c34f], a
	ld a, [$c353]
	or $1
	ld [$c353], a
	ld a, [$c367]
	or $1
	ld [$c367], a
	ld a, [$c36b]
	or $1
	ld [$c36b], a
	ld a, [$c373]
	or $1
	ld [$c373], a
	ret

Func_f98fc:
	ld a, [$c634]
	ld hl, Jumptable_f9906
	call Func_fa06e
	jp [hl]

Jumptable_f9906:
	dw Func_f992f
	dw Func_f995f
	dw Func_f996a
	dw Func_f9a08
	dw Func_f9a1e
	dw Func_f9a60
	dw Func_f9a6b
	dw Func_f9ab1
	dw Func_f9ad8
	dw Func_f9af9
	dw Func_f9b04
	dw Func_f9bf6
	dw Func_f9cac
	dw Func_f9d12
	dw Func_f9d22
	dw Func_f9d8f
	dw Func_f9dbf
	dw Func_f9e12

Func_f992a:
	ld hl, $c634
	inc [hl]
	ret

Func_f992f:
	xor a
	ld [hLCDCPointer], a
	ld de, $5858
	ld a, $1
	call Func_f9e1d
	xor a
	ld [hSCX], a
	ld [hSCY], a
	ld a, $90
	ld [hWY], a
	ld a, $e4
	ld [rBGP], a
	ld [rOBP0], a
	ld a, $c4
	ld [rOBP1], a
	call UpdateGBCPal_BGP
	call UpdateGBCPal_OBP0
	call UpdateGBCPal_OBP1
	ld a, $82
	ld [$c635], a
	call Func_f992a
	ret

Func_f995f:
	call Func_f9e41
	ret nc
	call Func_f9e29
	call Func_f992a
	ret

Func_f996a:
	call Func_f9e80
	ld c, $8
	call UpdateMusicCTimes
	xor a
	ld [hLCDCPointer], a
	ld hl, $9800
	ld bc, $400
	xor a
	call Func_f9fb3
	call Func_f9996
	ld de, $58b8
	ld a, $4
	call Func_f99d2
	ld a, $1
	call Func_f9e9a
	call Func_f9e35
	call Func_f992a
	ret

Func_f9996:
	ld hl, $98d4
	ld de, $20
	ld b, $6
	ld a, $90
.asm_f99a0
	ld c, $6
	push af
	push hl
.asm_f99a4
	ld [hli], a
	inc a
	dec c
	jr nz, .asm_f99a4
	pop hl
	add hl, de
	pop af
	add $10
	dec b
	jr nz, .asm_f99a0
	ld a, [hGBC]
	and a
	jr z, .asm_f99d1
	ld hl, $98d4
	ld de, $20
	ld b, $6
	ld a, $1
	ld [rVBK], a
.asm_f99c2
	ld c, $6
	push hl
.asm_f99c5
	ld [hli], a
	dec c
	jr nz, .asm_f99c5
	pop hl
	add hl, de
	dec b
	jr nz, .asm_f99c2
	xor a
	ld [rVBK], a
.asm_f99d1
	ret

Func_f99d2:
	ld hl, Unkn_f99f0
	ld a, $8
.asm_f99d7
	push af
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld a, [hli]
	push hl
	push af
	ld a, $8
	call Func_fbb93
	pop af
	ld hl, $b
	add hl, bc
	ld [hl], a
	pop hl
	pop af
	dec a
	jr nz, .asm_f99d7
	ret

Unkn_f99f0:
	dr $f99f0,$f9a08

Func_f9a08:
	call Func_f9e41
	jr c, .asm_f9a17
	ld a, [hSCX]
	cp $68
	ret z
	add $4
	ld [hSCX], a
	ret

.asm_f9a17
	call Func_fbbef
	call Func_f992a
	ret

Func_f9a1e:
	call Func_f9e80
	ld c, $5
	call UpdateMusicCTimes
	ld a, [hGBC]
	and a
	jr z, .asm_f9a47
	ld hl, $98d4
	ld de, $20
	ld b, $6
	ld a, $1
	ld [rVBK], a
	xor a
.asm_f9a38
	ld c, $6
	push hl
.asm_f9a3b
	ld [hli], a
	dec c
	jr nz, .asm_f9a3b
	pop hl
	add hl, de
	dec b
	jr nz, .asm_f9a38
	xor a
	ld [rVBK], a
.asm_f9a47
	xor a
	ld [hLCDCPointer], a
	call Func_f9e5f
	ld de, $5858
	ld a, $2
	call Func_f9e1d
	xor a
	call Func_f9e9a
	call Func_f9e35
	call Func_f992a
	ret

Func_f9a60:
	call Func_f9e41
	ret nc
	call Func_f9e29
	call Func_f992a
	ret

Func_f9a6b:
	call Func_f9e80
	ld c, $5
	call UpdateMusicCTimes
	ld a, $42
	ld [hLCDCPointer], a
	call Func_f9ec4
	ld hl, $9800
	ld bc, $60
	xor a
	call Func_f9fb3
	ld hl, $9860
	ld c, $10
	ld a, $20
.asm_f9a8b
	ld [hli], a
	inc a
	ld [hli], a
	dec a
	dec c
	jr nz, .asm_f9a8b
	ld hl, $9880
	ld bc, $300
	ld a, $10
	call Func_f9fb3
	ld de, $40f8
	ld a, $5
	call Func_f9e1d
	ld a, $1
	call Func_f9e9a
	call Func_f9e3b
	call Func_f992a
	ret

Func_f9ab1:
	call Func_f9e41
	jr c, .asm_f9ad1
	ld hl, hSCX
	inc [hl]
	inc [hl]
	ld hl, $c800
	ld de, $c801
	ld a, [hl]
	push af
	ld c, $ff
.asm_f9ac5
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .asm_f9ac5
	pop af
	ld [hl], a
	call Func_f9ef8
	ret

.asm_f9ad1
	call Func_f9e29
	call Func_f992a
	ret

Func_f9ad8:
	call Func_f9e80
	ld c, $5
	call UpdateMusicCTimes
	xor a
	ld [hLCDCPointer], a
	call Func_f9e5f
	ld de, $5858
	ld a, $3
	call Func_f9e1d
	xor a
	call Func_f9e9a
	call Func_f9e35
	call Func_f992a
	ret

Func_f9af9:
	call Func_f9e41
	ret nc
	call Func_f9e29
	call Func_f992a
	ret

Func_f9b04:
	call Func_f9e80
	ld c, $5
	call UpdateMusicCTimes
	xor a
	ld [hLCDCPointer], a
	ld hl, $9800
	ld bc, $400
	xor a
	call Func_f9fb3
	ld hl, $9800
	ld bc, $100
	ld a, $2
	call Func_f9fb3
	ld hl, $9900
	ld de, Unkn_f9b6e
	ld bc, $614
	call Func_f9b5c
	ld hl, $988c
	lb de, $5b, $e6
	ld bc, $304
	call Func_f9b5c
	ld hl, $98e3
	lb de, $5b, $f2
	ld bc, $202
	call Func_f9b5c
	ld de, $9858
	ld a, $6
	call Func_f9e1d
	ld a, $1
	call Func_f9e9a
	call Func_f9e35
	call Func_f992a
	ret

Func_f9b5c:
	push bc
	push hl
.asm_f9b5e
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .asm_f9b5e
	pop hl
	ld bc, $20
	add hl, bc
	pop bc
	dec b
	jr nz, Func_f9b5c
	ret

Unkn_f9b6e:
	dr $f9b6e,$f9bf6

Func_f9bf6:
	call Func_f9e41
	jr c, .asm_f9c25
	ld a, [$c635]
	and $7
	ret nz
	ld a, [$c635]
	and $8
	sla a
	sla a
	sla a
	ld e, a
	ld d, $0
	ld hl, Unkn_f9c2c
	add hl, de
	ld a, l
	ld [H_VBCOPYSRC], a
	ld a, h
	ld [$ffc8], a
.asm_f9c19
	xor a
	ld [H_VBCOPYDEST], a
	ld a, $96
	ld [$ffca], a
	ld a, $4
	ld [H_VBCOPYSIZE], a
	ret

.asm_f9c25
	call Func_f9e29
	call Func_f992a
	ret

Unkn_f9c2c:
	dr $f9c2c,$f9cac

Func_f9cac:
	call Func_f9e80
	ld c, $5
	call UpdateMusicCTimes
	xor a
	ld [hLCDCPointer], a
	ld hl, $9800
	ld bc, $80
	ld a, $1
	call Func_f9fb3
	ld hl, $9880
	ld bc, $140
	xor a
	call Func_f9fb3
	ld hl, $99c0
	ld bc, $80
	ld a, $1
	call Func_f9fb3
	ld hl, $98c5
	ld de, $20
	ld a, $4
	ld b, $8
.asm_f9ce1
	ld c, $c
	push hl
.asm_f9ce4
	ld [hli], a
	inc a
	dec c
	jr nz, .asm_f9ce4
	pop hl
	add hl, de
	add $4
	dec b
	jr nz, .asm_f9ce1
	ld hl, $98c4
	ld [hl], $3
	ld hl, $98e4
	ld [hl], $74
	ld hl, $99a5
	ld [hl], $0
	lb de, $60, $58
	ld a, $9
	call Func_f9e1d
	xor a
	call Func_f9e9a
	call Func_f9e35
	call Func_f992a
	ret

Func_f9d12:
	call Func_f9e41
	ret nc
	lb de, $68, $58
	ld a, $a
	call Func_fbb93
	call Func_f992a
	ret

Func_f9d22:
	ld de, Unkn_f9dd6
	call Func_f9e4d
	jr c, .asm_f9d3c
	ld [rBGP], a
	ld [rOBP0], a
	and $f0
	ld [rOBP1], a
	call UpdateGBCPal_BGP
	call UpdateGBCPal_OBP0
	call UpdateGBCPal_OBP1
	ret

.asm_f9d3c
	call Func_fbbef
	call Func_f9fbe
	ld hl, wTileMap
	ld bc, $50
	ld a, $1
	call Func_f9fb3
	coord hl, 0, 4
	ld bc, CopyVideoDataAlternate
	xor a
	call Func_f9fb3
	coord hl, 0, 14
	ld bc, $50
	ld a, $1
	call Func_f9fb3
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	call DelayFrame
	call DelayFrame
	call DelayFrame
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld a, $e4
	ld [rOBP0], a
	ld [rBGP], a
	call UpdateGBCPal_BGP
	call UpdateGBCPal_OBP0
	ld de, $5858
	ld a, $7
	call Func_f9e1d
	call Func_f992a
	ld a, $28
	ld [$c635], a
	ret

Func_f9d8f:
	call Func_f9e41
	jr c, .asm_f9dad
	ld a, [$c635]
	and $3
	ret nz
	ld a, [rOBP0]
	xor $ff
	ld [rOBP0], a
	ld a, [rBGP]
	xor $3
	ld [rBGP], a
	call UpdateGBCPal_BGP
	call UpdateGBCPal_OBP0
	ret

.asm_f9dad
	xor a
	ld [hLCDCPointer], a
	ld a, $e4
	ld [rBGP], a
	ld [rOBP0], a
	call UpdateGBCPal_BGP
	call UpdateGBCPal_OBP0
	call Func_f992a
Func_f9dbf:
	lb de, $5e, $0a
	call Func_f9e4d
	jr c, .asm_f9dd2
	ld [rOBP0], a
	ld [rBGP], a
	call UpdateGBCPal_BGP
	call UpdateGBCPal_OBP0
	ret

.asm_f9dd2
	call Func_f992a
	ret

Unkn_f9dd6:
	dr $f9dd6,$f9e12

Func_f9e12:
	ld c, $40
	call DelayFrames
	ld hl, $c634
	set 7, [hl]
	ret

Func_f9e1d:
	call Func_fbb93
	ld a, c
	ld [$c636], a
	ld a, b
	ld [$c637], a
	ret

Func_f9e29:
	ld a, [$c636]
	ld c, a
	ld a, [$c637]
	ld b, a
	call Func_fbbe8
	ret

Func_f9e35:
	ld a, $80
	ld [$c635], a
	ret

Func_f9e3b:
	ld a, $58
	ld [$c635], a
	ret

Func_f9e41:
	ld hl, $c635
	ld a, [hl]
	and a
	jr z, .asm_f9e4b
	dec [hl]
	and a
	ret

.asm_f9e4b
	scf
	ret

Func_f9e4d:
	ld hl, $c635
	ld a, [hl]
	inc [hl]
	ld l, a
	ld h, $0
	add hl, de
	ld a, [hl]
	cp $ff
	jr z, .asm_f9e5d
	and a
	ret

.asm_f9e5d
	scf
	ret

Func_f9e5f:
	ld hl, $9800
	ld bc, $80
	ld a, $1
	call Func_f9fb3
	ld hl, $9880
	ld bc, $140
	xor a
	call Func_f9fb3
	ld hl, $99c0
	ld bc, $80
	ld a, $1
	call Func_f9fb3
	ret

Func_f9e80:
	xor a
	ld [rBGP], a
	ld [rOBP0], a
	ld [rOBP1], a
	call UpdateGBCPal_BGP
	call UpdateGBCPal_OBP0
	call UpdateGBCPal_OBP1
	call DelayFrame
	call DelayFrame
	call DisableLCD
	ret

Func_f9e9a:
	ld e, a
	callab Func_720ad
	xor a
	ld [hSCX], a
	ld [hSCY], a
	ld a, $90
	ld [hWY], a
	ld a, $e3
	ld [rLCDC], a
	ld a, $e4
	ld [rBGP], a
	ld [rOBP0], a
	ld a, $e0
	ld [rOBP1], a
	call UpdateGBCPal_BGP
	call UpdateGBCPal_OBP0
	call UpdateGBCPal_OBP1
	ret

Func_f9ec4:
	ld de, $c800
	ld a, $8
.asm_f9ec9
	push af
	ld hl, Unkn_f9ed8
	ld bc, $20
	call Func_f9faa
	pop af
	dec a
	jr nz, .asm_f9ec9
	ret

Unkn_f9ed8:
	dr $f9ed8,$f9ef8

Func_f9ef8:
	ld a, $10
	ld [H_VBCOPYSRC], a
	ld a, $c8
	ld [$ffc8], a
	ld a, $10
	ld [H_VBCOPYDEST], a
	ld a, $c7
	ld [$ffca], a
	ld a, $7
	ld [H_VBCOPYSIZE], a
	ret

Func_f9f0d:
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld [hSCX], a
	ld [hSCY], a
	ld [H_AUTOBGTRANSFERDEST], a
	ld a, $98
	ld [$ffbd], a
	call Func_f9f9e
	ld hl, wTileMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, $1
	call Func_f9fb3
	coord hl, 0, 4
	ld bc, CopyVideoDataAlternate
	xor a
	call Func_f9fb3
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	call DelayFrame
	call DelayFrame
	call DelayFrame
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld de, $6b5a
	ld hl, $8000
	ld bc, $3eff
	call CopyVideoData
	ld de, $635a
	ld hl, $9000
	ld bc, $3e80
	call CopyVideoData
	call Func_fbb5a
	call Func_f9f75
	ld b, $8
	call RunPaletteCommand
	xor a
	ld hl, $c634
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, MUSIC_INTRO_BATTLE
	ld c, BANK(Music_IntroBattle)
	call PlayMusic
	ret

Func_f9f75:
	ld a, Unkn_f9fda % $100
	ld [$c5c0], a
	ld a, Unkn_f9fda / $100
	ld [$c5c1], a
	ld a, Unkn_f9ffb % $100
	ld [$c5c4], a
	ld a, Unkn_f9ffb / $100
	ld [$c5c5], a
	ld a, Unkn_fa13d % $100
	ld [$c5c6], a
	ld a, Unkn_fa13d / $100
	ld [$c5c7], a
	ld a, Unkn_fa0ea % $100
	ld [$c5c2], a
	ld a, Unkn_fa0ea / $100
	ld [$c5c3], a
	ret

Func_f9f9e:
	ld hl, wTileMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, $7f
	call Func_f9fb3
	ret

Func_f9faa:
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or b
	jr nz, Func_f9faa
	ret

Func_f9fb3:
	push de
	ld e, a
.asm_f9fb5
	ld a, e
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .asm_f9fb5
	pop de
	ret

Func_f9fbe:
	ld hl, wSpriteDataEnd
	ld bc, $a0
	xor a
	call Func_f9fb3
	ret

Func_f9fc9:
	xor a
	ld [rBGP], a
	ld [rOBP0], a
	ld [rOBP1], a
	call UpdateGBCPal_BGP
	call UpdateGBCPal_OBP0
	call UpdateGBCPal_OBP1
	ret

Unkn_f9fda:
	dr $f9fda,$f9ffb
Unkn_f9ffb:
	dr $f9ffb,$fa008

Func_fa008:
	ld hl, $4
	add hl, bc
	ld a, [hl]
	cp $58
	ret z
	sub $4
	ld [hl], a
	ret

Func_fa014:
	ld hl, $4
	add hl, bc
	ld a, [hl]
	cp $58
	jr z, .asm_fa020
	add $4
	ld [hl], a
.asm_fa020
	ld hl, $5
	add hl, bc
	cp $58
	ret z
	add $1
	ld [hl], a
	ret

Func_fa02b:
	ld hl, $b
	add hl, bc
	ld e, [hl]
	ld d, $0
	ld hl, Jumptable_fa03b
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

Jumptable_fa03b:
	dw Func_fa03f
	dw Func_fa051

Func_fa03f:
	ld hl, $5
	add hl, bc
	ld a, [hl]
	cp $58
	jr z, .asm_fa04c
	sub $2
	ld [hl], a
	ret

.asm_fa04c
	ld hl, $b
	add hl, bc
	inc [hl]
Func_fa051:
	ld hl, $c
	add hl, bc
	ld a, [hl]
	inc [hl]
	ld d, $8
	call Func_fa079
	ld hl, $7
	add hl, bc
	ld [hl], a
	ret

Func_fa062:
	ld hl, $b
	add hl, bc
	ld a, [hl]
	ld hl, $4
	add hl, bc
	add [hl]
	ld [hl], a
	ret

Func_fa06e:
	ld e, a
	ld d, $0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

Func_fa077: ; cosine
	add $10
Func_fa079:
	and $3f
	cp $20
	jr nc, .asm_fa084
	call Func_fa08e
	ld a, h
	ret

.asm_fa084
	and $1f
	call Func_fa08e
	ld a, h
	xor $ff
	inc a
	ret

Func_fa08e:
	ld e, a
	ld a, d
	ld d, $0
	ld hl, Unkn_fa0aa
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $0
.asm_fa09d
	srl a
	jr nc, .asm_fa0a2
	add hl, de
.asm_fa0a2
	sla e
	rl d
	and a
	jr nz, .asm_fa09d
	ret

Unkn_fa0aa:
	sine_wave $100

Unkn_fa0ea:
	dr $fa0ea,$fa13d

Unkn_fa13d:
	dr $fa13d,$fa35a

YellowIntroGraphics:  INCBIN "gfx/yellow_intro.2bpp"

Func_fbb5a: ; fbb5a (3e:7b5a)
	ld hl, wTileMapBackup
	ld bc, 10 * SCREEN_WIDTH
	xor a
	call FillMemory
	ret

Func_fbb65:
	ld hl, $c51c
	ld e, $a
.asm_fbb6a
	ld a, [hl]
	and a
	jr z, .asm_fbb7c
	ld c, l
	ld b, h
	push hl
	push de
	call Func_fbd61
	call Func_fbbfe
	pop de
	pop hl
	jr c, .asm_fbb92
.asm_fbb7c
	ld bc, $10
	add hl, bc
	dec e
	jr nz, .asm_fbb6a
	ld a, [$c5bd]
	ld l, a
	ld h, $c3
.asm_fbb89
	ld a, l
	cp $a0
	jr nc, .asm_fbb92
	xor a
	ld [hli], a
	jr .asm_fbb89

.asm_fbb92
	ret

Func_fbb93:
	push de
	push af
	ld hl, $c51c
	ld e, $a
.asm_fbb9a
	ld a, [hl]
	and a
	jr z, .asm_fbba9
	ld bc, $10
	add hl, bc
	dec e
	jr nz, .asm_fbb9a
	pop af
	pop de
	scf
	ret

.asm_fbba9
	pop af
	ld c, l
	ld b, h
	ld hl, $c5bc
	inc [hl]
	ld e, a
	ld d, $0
	ld a, [$c5c0]
	ld l, a
	ld a, [$c5c1]
	ld h, a
	add hl, de
	add hl, de
	add hl, de
	ld e, l
	ld d, h
	ld hl, $0
	add hl, bc
	ld a, [$c5bc]
	ld [hli], a
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	xor a
	ld [hli], a
	pop de
	ld hl, $4
	add hl, bc
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	dec a
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

Func_fbbe8:
	ld hl, $0
	add hl, bc
	ld [hl], $0
	ret

Func_fbbef:
	ld hl, $c51c
	ld e, $a
.asm_fbbf4
	ld [hl], $0
	ld bc, $10
	add hl, bc
	dec e
	jr nz, .asm_fbbf4
	ret

Func_fbbfe:
	xor a
	ld [$c5c8], a
	ld hl, $3
	add hl, bc
	ld a, [hli]
	ld [$c5c9], a
	ld a, [hli]
	ld [$c5ca], a
	ld a, [hli]
	ld [$c5cb], a
	ld a, [hli]
	ld [$c5cc], a
	ld a, [hl]
	ld [$c5cd], a
	call Func_fbcec
	cp $fd
	jr z, .asm_fbc8d
	cp $fc
	jr z, .asm_fbc8a
	call Func_fbcc5
	ld a, [$c5c9]
	add [hl]
	ld [$c5c9], a
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push bc
	ld a, [$c5bd]
	ld e, a
	ld d, $c3
	ld a, [hli]
	ld c, a
.asm_fbc3c
	ld a, [$c5cb]
	ld b, a
	ld a, [$c5cd]
	add b
	ld b, a
	ld a, [$c5ce]
	add b
	ld b, a
	call Func_fbc92
	add b
	ld [de], a
	inc hl
	inc de
	ld a, [$c5ca]
	ld b, a
	ld a, [$c5cc]
	add b
	ld b, a
	ld a, [$c5cf]
	add b
	ld b, a
	call Func_fbca2
	add b
	ld [de], a
	inc hl
	inc de
	ld a, [$c5c9]
	add [hl]
	ld [de], a
	inc hl
	inc de
	call Func_fbcb2
	ld b, a
	ld a, [$c634]
	cp $7
	ld a, b
	jr z, .asm_fbc7a
	ld [de], a
.asm_fbc7a
	inc hl
	inc de
	ld a, e
	ld [$c5bd], a
	cp $a0
	jr nc, .asm_fbc8f
	dec c
	jr nz, .asm_fbc3c
	pop bc
	jr .asm_fbc8d

.asm_fbc8a
	call Func_fbbe8
.asm_fbc8d
	and a
	ret

.asm_fbc8f
	pop bc
	scf
	ret

Func_fbc92:
	push hl
	ld a, [hl]
	ld hl, $c5c8
	bit 6, [hl]
	jr z, .asm_fbca0
	add $8
	xor $ff
	inc a
.asm_fbca0
	pop hl
	ret

Func_fbca2:
	push hl
	ld a, [hl]
	ld hl, $c5c8
	bit 5, [hl]
	jr z, .asm_fbcb0
	add $8
	xor $ff
	inc a
.asm_fbcb0
	pop hl
	ret

Func_fbcb2:
	ld a, [$c5c8]
	ld b, a
	ld a, [hl]
	xor b
	and $e0
	ld b, a
	ld a, [hl]
	and $10
	or b
	bit 4, a
	ret z
	or $4
	ret

Func_fbcc5:
	ld e, a
	ld d, $0
	ld a, [$c5c6]
	ld l, a
	ld a, [$c5c7]
	ld h, a
	add hl, de
	add hl, de
	add hl, de
	ret

Func_fbcd4:
	ld hl, $1
	add hl, bc
	ld [hl], a
	ld hl, $8
	add hl, bc
	ld [hl], $0
	ld hl, $9
	add hl, bc
	ld [hl], $0
	ld hl, $a
	add hl, bc
	ld [hl], $ff
	ret

Func_fbcec:
	ld hl, $8
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_fbcfc
	dec [hl]
	call Func_fbd43
	ld a, [hli]
	push af
	jr .asm_fbd1d

.asm_fbcfc
	ld hl, $a
	add hl, bc
	inc [hl]
	call Func_fbd43
	ld a, [hli]
	cp $fe
	jr z, .asm_fbd35
	cp $ff
	jr z, .asm_fbd27
	push af
	ld a, [hl]
	push hl
	and $3f
	ld hl, $9
	add hl, bc
	add [hl]
	ld hl, $8
	add hl, bc
	ld [hl], a
	pop hl
.asm_fbd1d
	ld a, [hl]
	and $c0
	srl a
	ld [$c5c8], a
	pop af
	ret

.asm_fbd27
	xor a
	ld hl, $8
	add hl, bc
	ld [hl], a
	ld hl, $a
	add hl, bc
	dec [hl]
	dec [hl]
	jr Func_fbcec

.asm_fbd35
	xor a
	ld hl, $8
	add hl, bc
	ld [hl], a
	dec a
	ld hl, $a
	add hl, bc
	ld [hl], a
	jr Func_fbcec

Func_fbd43:
	ld hl, $1
	add hl, bc
	ld e, [hl]
	ld d, $0
	ld a, [$c5c2]
	ld l, a
	ld a, [$c5c3]
	ld h, a
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $a
	add hl, bc
	ld l, [hl]
	ld h, $0
	add hl, hl
	add hl, de
	ret

Func_fbd61:
	ld hl, $2
	add hl, bc
	ld e, [hl]
	ld d, $0
	ld a, [$c5c4]
	ld l, a
	ld a, [$c5c5]
	ld h, a
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
