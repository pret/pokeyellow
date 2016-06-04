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
	ld de, Unkn_f88e0
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
	dr $f8440,$f844c
Func_f844c:
	dr $f844c,$f8848
Func_f8848:
	dr $f8848,$f886b
Func_f886b:
	dr $f886b,$f88ae
Func_f88ae:
	dr $f88ae,$f88e0
Unkn_f88e0:
	dr $f88e0,$f88e4
Func_f88e4:
	dr $f88e4,$f88fd
Func_f88fd:
	dr $f88fd,$f891e
Func_f891e:
	dr $f891e,$f8a7c
Func_f8a7c:
	dr $f8a7c,$f8a92
Func_f8a92:
	dr $f8a92,$f8aa9
Func_f8aa9:
	dr $f8aa9,$f8ae4
Func_f8ae4:
	dr $f8ae4,$f8afb
Func_f8afb:
	dr $f8afb,$f8b5d
Func_f8b5d:
	dr $f8b5d,$f8b7a
Func_f8b7a:
	dr $f8b7a,$f8b92
Func_f8b92:
	dr $f8b92,$f8bcb

Func_f8bcb: ; f8bcb (3e:4bcb)
	push de
	callab IsSurfingPikachuInThePlayersParty
	pop de
	ret nc
	callab PlayPikachuSoundClip
	ret

Func_f8bdf: ; f8bdf (3e:4bdf)
	dr $f8bdf,$f8c97
Func_f8c97:
	dr $f8c97,$f8cb0

Func_f8cb0:
	dr $f8cb0,$f8cc7
Func_f8cc7:
	dr $f8cc7,$f8fb3
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
	dr $f9279,$f982d
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
	dr $fbb93,$fbd76