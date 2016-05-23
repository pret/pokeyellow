Func_e8783: ; e8783 (3a:4783)
	ld a, 9
	push af
	ld hl, wOverworldMap
	lb bc, 4, 13
	xor a
	call Func_e8a2e
	xor a
	ld [rSB], a
	ld [rSC], a
	ld [wUnknownSerialFlag_d49b], a
	ld hl, wUnknownSerialFlag_d49a
	set 0, [hl]
	ld a, [wd498]
	ld [$cae3], a
	pop af
	ld [$caf4], a
	ret

; e87a8
Func_e87a8: ; e87a8 (3a:47a8)
	ld a, [wOverworldMap]
	ld e, a
	ld d, 0
	ld hl, Jumptable_e87b7
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

Jumptable_e87b7:
	dw Func_e87fd
	dw Func_e88c9
	dw Func_e88a6
	dw Func_e881f
	dw Func_e8906
	dw Func_e88b4
	dw Func_e884b
	dw Func_e8906
	dw Func_e88a6
	dw Func_e8864
	dw Func_e8906
	dw Func_e88a6
	dw Func_e8927
	dw Func_e87e9
	dw Func_e87f3
	dw Func_e88a6
	dw Func_e8889
	dw Func_e87f7
	dw Func_e8936
	dw Func_e8939

Func_e87df:
	ld hl, wOverworldMap
	inc [hl]
	ret

Func_e87e4:
	ld hl, wOverworldMap
	dec [hl]
	ret

Func_e87e9:
	xor a
	ld [$c971], a
	ld hl, wOverworldMap
	set 7, [hl]
	ret

Func_e87f3:
	call Func_e87df
	ret

Func_e87f7:
	ld a, $01
	ld [wOverworldMap], a
	ret

Func_e87fd:
	call Func_e8981
	ld hl, Data_e8a3a
	call Func_e8968
	xor a
	ld [$c976], a
	ld [$c977], a
	ld a, [$caf4]
	ld [$c6e9], a
	call Func_e87df
	call Func_e8949
	ld a, $01
	ld [$cae0], a
	ret

Func_e881f:
	call Func_e8981
	ld hl, $c6e9
	ld a, [hl]
	and a
	jr z, Func_e884b
	ld hl, Data_e8a46
	call Func_e8968
	call Func_e89e6
	ld a, $80
	ld [$c976], a
	ld a, $02
	ld [$c977], a
	call Func_e899f
	call Func_e87df
	call Func_e8949
	ld a, $02
	ld [$cae0], a
	ret

Func_e884b:
	ld a, $06
	ld [wOverworldMap], a
	ld hl, Data_e8a4c
	call Func_e8968
	xor a
	ld [$c976], a
	ld [$c977], a
	call Func_e87df
	call Func_e8949
	ret

Func_e8864:
	call Func_e8981
	ld hl, Data_e8a40
	call Func_e8968
	call Func_e89cf
	ld a, $04
	ld [$c976], a
	ld a, $00
	ld [$c977], a
	call Func_e899f
	call Func_e87df
	call Func_e8949
	ld a, $03
	ld [$cae0], a
	ret

Func_e8889:
	call Func_e8981
	ld hl, Data_e8a3a
	call Func_e8968
	xor a
	ld [$c976], a
	ld [$c977], a
	ld a, [$caf4]
	ld [$c6e9], a
	call Func_e87df
	call Func_e8949
	ret

Func_e88a6:
	ld hl, $c973
	inc [hl]
	ld a, [hl]
	cp a, $06
	ret c
	xor a
	ld [hl], a
	call Func_e87df
	ret

Func_e88b4:
	ld hl, $c973
	inc [hl]
	ld a, [hl]
	cp a, $06
	ret c
	xor a
	ld [hl], a
	ld hl, $c6e9
	dec [hl]
	call Func_e87e4
	call Func_e87e4
	ret

Func_e88c9:
	ld a, [wUnknownSerialFlag_d49b]
	and a
	ret nz
	ld a, [$c970]
	cp a, $ff
	jr nz, .asm_e88dc
	ld a, [$c971]
	cp a, $ff
	jr z, .asm_e88f8
.asm_e88dc
	ld a, [$c970]
	cp a, $81
	jr nz, .asm_e88f8
	ld a, [$c971]
	cp a, $00
	jr nz, .asm_e88f8
	ld hl, wUnknownSerialFlag_d49a
	set 1, [hl]
	ld a, $05
	ld [$c972], a
	call Func_e87df
	ret

.asm_e88f8
	ld a, $ff
	ld [$c970], a
	ld [$c971], a
	ld a, $0e
	ld [wOverworldMap], a
	ret

Func_e8906:
	ld a, [wUnknownSerialFlag_d49b]
	and a
	ret nz
	ld a, [$c971]
	and a, $f0
	jr nz, .asm_e8921
	ld a, [$c971]
	and a, $01
	jr nz, .asm_e891d
	call Func_e87df
	ret

.asm_e891d
	call Func_e87e4
	ret

.asm_e8921
	ld a, $12
	ld [wOverworldMap], a
	ret

Func_e8927:
	ld a, [wUnknownSerialFlag_d49b]
	and a
	ret nz
	ld a, [$c971]
	and a, $f3
	ret nz
	call Func_e87df
	ret

Func_e8936:
	call Func_e87df
Func_e8939:
	ld a, [wUnknownSerialFlag_d49b]
	and a
	ret nz
	ld a, [$c971]
	and a, $f0
	ret nz
	xor a
	ld [wOverworldMap], a
	ret

Func_e8949:
.asm_e8949
	ld a, [wUnknownSerialFlag_d49b]
	and a
	jr nz, .asm_e8949
	xor a
	ld [$c974], a
	ld [$c975], a
	ld a, $01
	ld [wUnknownSerialFlag_d49b], a
	ld a, $88
	ld [rSB], a
	ld a, $01
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	ret

Func_e8968:
	ld a, [hli]
	ld [$c6ea], a
	ld a, [hli]
	ld [$c6eb], a
	ld a, [hli]
	ld [$c6ec], a
	ld a, [hli]
	ld [$c6ed], a
	ld a, [hli]
	ld [$c6ee], a
	ld a, [hl]
	ld [$c6ef], a
	ret

Func_e8981:
	xor a
	ld hl, $c6ea
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, $c6ee
	ld [hli], a
	ld [hl], a
	xor a
	ld [$c976], a
	ld [$c977], a
	ld hl, $c6f0
	ld bc, $0280
	call Func_e8a2e
	ret

Func_e899f:
	ld hl, $0000
	ld bc, $0004
	ld de, $c6ea
	call Func_e89c2
	ld a, [$c976]
	ld c, a
	ld a, [$c977]
	ld b, a
	ld de, $c6f0
	call Func_e89c2
	ld a, l
	ld [$c6ee], a
	ld a, h
	ld [$c6ef], a
	ret

Func_e89c2:
.asm_e89c2
	ld a, [de]
	inc de
	add l
	jr nc, .asm_e89c8
	inc h
.asm_e89c8
	ld l, a
	dec bc
	ld a, c
	or b
	jr nz, .asm_e89c2
	ret

Func_e89cf:
	ld a, $01
	ld [$c6f0], a
	ld a, [$cae2]
	ld [$c6f1], a
	ld a, $e4
	ld [$c6f2], a
	ld a, [$cae3]
	ld [$c6f3], a
	ret

Func_e89e6:
	ld a, [$c6e9]
	ld b, a
	ld a, [$caf4]
	sub b
	ld hl, $c978
	ld de, $0028
.asm_e89f4
	and a
	jr z, .asm_e89fb
	add hl, de
	dec a
	jr .asm_e89f4

.asm_e89fb
	ld e, l
	ld d, h
	ld hl, $c6f0
	ld c, $28
.asm_e8a02
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	swap a
	ld d, a
	and a, $f0
	ld e, a
	ld a, d
	and a, $0f
	ld d, a
	and a, $08
	ld a, d
	jr nz, .asm_e8a1a
	or a, $90
	jr .asm_e8a1c

.asm_e8a1a
	or a, $80
.asm_e8a1c
	ld d, a
	ld bc, $3a01
	call CopyVideoData
	pop hl
	ld de, $0010
	add hl, de
	pop de
	pop bc
	dec c
	jr nz, .asm_e8a02
	ret

Func_e8a2e: ; e8a2e (3a:4a2e)
	push de
	ld e, a
.asm_e8a30
	ld [hl], e
	inc hl
	dec bc
	ld a, c
	or b
	jr nz, .asm_e8a30
	ld a, e
	pop de
	ret

Data_e8a3a:
	db $01, $00, $00, $00, $01, $00
Data_e8a40:
	db $02, $00, $04, $00, $00, $00
Data_e8a46:
	db $04, $00, $80, $02, $00, $00
Data_e8a4c:
	db $04, $00, $00, $00, $04, $00
Data_e8a52:
	db $08, $00, $00, $00, $08, $00
Data_e8a58:
	db $0f, $00, $00, $00, $0f, $00

Func_e8a5e: ; e8a5e (3a:4a5e)
	ld a, [$d49a]
	ld e, a
	ld d, 0
	ld hl, Jumptable_e8a6d
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

Jumptable_e8a6d:
	dw Func_e8ab2
	dw Func_e8ab3
	dw Func_e8abc
	dw Func_e8ac6
	dw Func_e8ad0
	dw Func_e8ada
	dw Func_e8ae4
	dw Func_e8b0f
	dw Func_e8b19
	dw Func_e8b23
	dw Func_e8b2c
	dw Func_e8b3a
	dw Func_e8ab3
	dw Func_e8b44
	dw Func_e8b4d
	dw Func_e8b4d
	dw Func_e8b4d
	dw Func_e8b44
	dw Func_e8b4d
	dw Func_e8b23
	dw Func_e8b2c
	dw Func_e8b6a
	dw Func_e8ab3
	dw Func_e8b56
	dw Func_e8b4d
	dw Func_e8b4d
	dw Func_e8b4d
	dw Func_e8b56
	dw Func_e8b4d
	dw Func_e8b23
	dw Func_e8b2c
	dw Func_e8b3a

Func_e8aad:
	ld hl, wUnknownSerialFlag_d49b
	inc [hl]
	ret

Func_e8ab2:
	ret

Func_e8ab3:
	ld a, $33
	call Func_e8b5f
	call Func_e8aad
	ret

Func_e8abc:
	ld a, [$c6ea]
	call Func_e8b5f
	call Func_e8aad
	ret

Func_e8ac6:
	ld a, [$c6eb]
	call Func_e8b5f
	call Func_e8aad
	ret

Func_e8ad0:
	ld a, [$c6ec]
	call Func_e8b5f
	call Func_e8aad
	ret

Func_e8ada:
	ld a, [$c6ed]
	call Func_e8b5f
	call Func_e8aad
	ret

Func_e8ae4:
	ld hl, $c976
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, e
	or d
	jr z, .asm_e8b0c
	dec de
	ld [hl], d
	dec hl
	ld [hl], e
	ld a, [$c974]
	ld e, a
	ld a, [$c975]
	ld d, a
	ld hl, $c6f0
	add hl, de
	inc de
	ld a, e
	ld [$c974], a
	ld a, d
	ld [$c975], a
	ld a, [hl]
	call Func_e8b5f
	ret

.asm_e8b0c
	call Func_e8aad
Func_e8b0f:
	ld a, [$c6ee]
	call Func_e8b5f
	call Func_e8aad
	ret

Func_e8b19:
	ld a, [$c6ef]
	call Func_e8b5f
	call Func_e8aad
	ret

Func_e8b23:
	ld a, $00
	call Func_e8b5f
	call Func_e8aad
	ret

Func_e8b2c:
	ld a, [rSB]
	ld [$c970], a
	ld a, $00
	call Func_e8b5f
	call Func_e8aad
	ret

Func_e8b3a:
	ld a, [rSB]
	ld [$c971], a
	xor a
	ld [wUnknownSerialFlag_d49b], a
	ret

Func_e8b44:
	ld a, $0f
	call Func_e8b5f
	call Func_e8aad
	ret

Func_e8b4d:
	ld a, $00
	call Func_e8b5f
	call Func_e8aad
	ret

Func_e8b56:
	ld a, $08
	call Func_e8b5f
	call Func_e8aad
	ret

Func_e8b5f:
	ld [rSB], a
	ld a, $01
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	ret

Func_e8b6a:
	ld a, [rSB]
	ld [$c971], a
	xor a
	ld [wUnknownSerialFlag_d49b], a
	ret

Func_e8b74: ; e8b74 (3a:4b74)
	dr $e8b74,$e8d35
	
Func_e8d35:: ; e8d35 (3a:4e79)
	ld a, [wBoxDataStart]
	and a
	jp z, Func_e8df4
	ld a, [wUpdateSpritesEnabled]
	push af
	xor a
	ld [wUpdateSpritesEnabled], a
	ld [hItemCounter], a
	call Func_e8f24
	ld a, [rIE]
	push af
	xor a
	ld [rIF], a
	ld a, $09
	ld [rIE], a
	call SaveScreenTilesToBuffer1
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	call $588a ; Func_e988a
	call Func_e8783
	ld a, $10
	ld [$cae2], a
	call Func_e8efc
	call LoadScreenTilesFromBuffer1
	call Func_e8dfb
	jr c, .asm_e8ddc
	xor a
	ld [wUnknownSerialFlag_d49a], a
	ld [wUnknownSerialFlag_d49b], a
	ld c, 12
	call DelayFrames
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	call $58ec ; Func_e98ec
	call Func_e8783
	ld a, $00
	ld [$cae2], a
	call Func_e8efc
	call LoadScreenTilesFromBuffer1
	call Func_e8dfb
	jr c, .asm_e8ddc
	xor a
	ld [wUnknownSerialFlag_d49a], a
	ld [wUnknownSerialFlag_d49b], a
	ld c, 12
	call DelayFrames
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	call $5907 ; Func_e9907
	call Func_e8783
	ld a, $00
	ld [$cae2], a
	call Func_e8efc
	call LoadScreenTilesFromBuffer1
	call Func_e8dfb
	jr c, .asm_e8ddc
	xor a
	ld [wUnknownSerialFlag_d49a], a
	ld [wUnknownSerialFlag_d49b], a
	ld c, 12
	call DelayFrames
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	call $5922 ; Func_e9922
	call Func_e8783
	ld a, $03
	ld [$cae2], a
	call Func_e8efc
	call LoadScreenTilesFromBuffer1
	call Func_e8dfb
.asm_e8ddc
	xor a
	ld [wUnknownSerialFlag_d49a], a
	ld [wUnknownSerialFlag_d49b], a
	xor a
	ld [rIF], a
	pop af
	ld [rIE], a
	call Func_0f3d
	call Func_e8f3b
	pop af
	ld [wUpdateSpritesEnabled], a
	ret

Func_e8df4: ; e8df4
	ld hl, String_e8e1f
	call PrintText
	ret

Func_e8dfb: ; e8dfb
	call Func_e8f16
.asm_e8dfe
	call JoypadLowSensitivity
	call Func_e8eca
	jr c, .asm_e8e1d
	ld a, [wOverworldMap]
	bit 7, a
	jr nz, .asm_e8e1b
	call Func_e87a8
	call Func_e8f51
	call Func_e8f82
	call DelayFrame
	jr .asm_e8dfe

.asm_e8e1b
	and a
	ret

.asm_e8e1d
	scf
	ret

String_e8e1f: ; e8e1f
	TX_FAR _NoPokemonText
	db "@"

Func_e8e24: ; e8e24
	xor a
	ld [hItemCounter], a
	call Func_e8f24
	call Func_ea3ea
	ld a, [rIE]
	push af
	xor a
	ld [rIF], a
	ld a, $09
	ld [rIE], a
	call Func_e8783
	ld a, $13
	ld [$cae2], a
	call Func_e8efc
	call Func_e8f16
.asm_e8e45
	call JoypadLowSensitivity
	call Func_e8eca
	jr c, .asm_e8e62
	ld a, [wOverworldMap]
	bit 7, a
	jr nz, .asm_e8e62
	call Func_e87a8
	call Func_e8f51
	call Func_e8f82
	call DelayFrame
	jr .asm_e8e45

.asm_e8e62
	xor a
	ld [wUnknownSerialFlag_d49a], a
	ld [wUnknownSerialFlag_d49b], a
	call Func_e8f09
	xor a
	ld [rIF], a
	pop af
	ld [rIE], a
	call Func_0f3d
	call Func_e8f3b
	ret
