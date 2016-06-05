Func_e8783: ; e8783 (3a:4783)
	ld a, 9
Func_e8785:
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
	ld [wcae3], a
	pop af
	ld [wcaf4], a
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
	ld [wc971], a
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
	ld [wc976], a
	ld [wc977], a
	ld a, [wcaf4]
	ld [wc6e9], a
	call Func_e87df
	call Func_e8949
	ld a, $01
	ld [wPrinterStatusIndicator], a
	ret

Func_e881f:
	call Func_e8981
	ld hl, wc6e9
	ld a, [hl]
	and a
	jr z, Func_e884b
	ld hl, Data_e8a46
	call Func_e8968
	call Func_e89e6
	ld a, $80
	ld [wc976], a
	ld a, $02
	ld [wc977], a
	call Func_e899f
	call Func_e87df
	call Func_e8949
	ld a, $02
	ld [wPrinterStatusIndicator], a
	ret

Func_e884b:
	ld a, $06
	ld [wOverworldMap], a
	ld hl, Data_e8a4c
	call Func_e8968
	xor a
	ld [wc976], a
	ld [wc977], a
	call Func_e87df
	call Func_e8949
	ret

Func_e8864:
	call Func_e8981
	ld hl, Data_e8a40
	call Func_e8968
	call Func_e89cf
	ld a, $04
	ld [wc976], a
	ld a, $00
	ld [wc977], a
	call Func_e899f
	call Func_e87df
	call Func_e8949
	ld a, $03
	ld [wPrinterStatusIndicator], a
	ret

Func_e8889:
	call Func_e8981
	ld hl, Data_e8a3a
	call Func_e8968
	xor a
	ld [wc976], a
	ld [wc977], a
	ld a, [wcaf4]
	ld [wc6e9], a
	call Func_e87df
	call Func_e8949
	ret

Func_e88a6:
	ld hl, wc973
	inc [hl]
	ld a, [hl]
	cp a, $06
	ret c
	xor a
	ld [hl], a
	call Func_e87df
	ret

Func_e88b4:
	ld hl, wc973
	inc [hl]
	ld a, [hl]
	cp a, $06
	ret c
	xor a
	ld [hl], a
	ld hl, wc6e9
	dec [hl]
	call Func_e87e4
	call Func_e87e4
	ret

Func_e88c9:
	ld a, [wUnknownSerialFlag_d49b]
	and a
	ret nz
	ld a, [wc970]
	cp a, $ff
	jr nz, .asm_e88dc
	ld a, [wc971]
	cp a, $ff
	jr z, .asm_e88f8
.asm_e88dc
	ld a, [wc970]
	cp a, $81
	jr nz, .asm_e88f8
	ld a, [wc971]
	cp a, $00
	jr nz, .asm_e88f8
	ld hl, wUnknownSerialFlag_d49a
	set 1, [hl]
	ld a, $05
	ld [wc972], a
	call Func_e87df
	ret

.asm_e88f8
	ld a, $ff
	ld [wc970], a
	ld [wc971], a
	ld a, $0e
	ld [wOverworldMap], a
	ret

Func_e8906:
	ld a, [wUnknownSerialFlag_d49b]
	and a
	ret nz
	ld a, [wc971]
	and a, $f0
	jr nz, .asm_e8921
	ld a, [wc971]
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
	ld a, [wc971]
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
	ld a, [wc971]
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
	ld [wc974], a
	ld [wc975], a
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
	ld [wc6ea], a
	ld a, [hli]
	ld [wc6eb], a
	ld a, [hli]
	ld [wc6ec], a
	ld a, [hli]
	ld [wc6ed], a
	ld a, [hli]
	ld [wc6ee], a
	ld a, [hl]
	ld [wc6ef], a
	ret

Func_e8981:
	xor a
	ld hl, wc6ea
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wc6ee
	ld [hli], a
	ld [hl], a
	xor a
	ld [wc976], a
	ld [wc977], a
	ld hl, wc6f0
	ld bc, $0280
	call Func_e8a2e
	ret

Func_e899f:
	ld hl, $0000
	ld bc, $0004
	ld de, wc6ea
	call Func_e89c2
	ld a, [wc976]
	ld c, a
	ld a, [wc977]
	ld b, a
	ld de, wc6f0
	call Func_e89c2
	ld a, l
	ld [wc6ee], a
	ld a, h
	ld [wc6ef], a
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
	ld [wc6f0], a
	ld a, [wcae2]
	ld [wc6f1], a
	ld a, $e4
	ld [wc6f2], a
	ld a, [wcae3]
	ld [wc6f3], a
	ret

Func_e89e6:
	ld a, [wc6e9]
	ld b, a
	ld a, [wcaf4]
	sub b
	ld hl, wPrinterTileBuffer
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
	ld hl, wc6f0
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
	ld a, [wUnknownSerialFlag_d49b]
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
	ld a, [wc6ea]
	call Func_e8b5f
	call Func_e8aad
	ret

Func_e8ac6:
	ld a, [wc6eb]
	call Func_e8b5f
	call Func_e8aad
	ret

Func_e8ad0:
	ld a, [wc6ec]
	call Func_e8b5f
	call Func_e8aad
	ret

Func_e8ada:
	ld a, [wc6ed]
	call Func_e8b5f
	call Func_e8aad
	ret

Func_e8ae4:
	ld hl, wc976
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
	ld a, [wc974]
	ld e, a
	ld a, [wc975]
	ld d, a
	ld hl, wc6f0
	add hl, de
	inc de
	ld a, e
	ld [wc974], a
	ld a, d
	ld [wc975], a
	ld a, [hl]
	call Func_e8b5f
	ret

.asm_e8b0c
	call Func_e8aad
Func_e8b0f:
	ld a, [wc6ee]
	call Func_e8b5f
	call Func_e8aad
	ret

Func_e8b19:
	ld a, [wc6ef]
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
	ld [wc970], a
	ld a, $00
	call Func_e8b5f
	call Func_e8aad
	ret

Func_e8b3a:
	ld a, [rSB]
	ld [wc971], a
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
	ld [wc971], a
	xor a
	ld [wUnknownSerialFlag_d49b], a
	ret

Func_e8b74: ; e8b74 (3a:4b74)
	ld a, [wUpdateSpritesEnabled]
	push af
	xor a
	ld [wUpdateSpritesEnabled], a
	ld [$ffdb], a
	call Func_e8f24
	ld a, [rIE]
	push af
	xor a
	ld [rIF], a
	ld a, $09
	ld [rIE], a
	xor a
	ld [$ffba], a
	call Func_e8c30
	call Func_e8785
	ld a, [wcaf9]
	and a
	jr z, .asm_e8b9e
	ld a, $10
	jr .asm_e8ba0

.asm_e8b9e
	ld a, $13
.asm_e8ba0
	ld [wcae2], a
	call Func_e8efc
	call ClearScreen
	callab Func_401c2
	callab Func_4027c
	ld a, $01
	ld [$ffba], a
	call Func_e8c0c
	jr c, .asm_e8bf4
	ld a, [wcaf9]
	and a
	jr z, .asm_e8bf4
	xor a
	ld [wUnknownSerialFlag_d49a], a
	ld [wUnknownSerialFlag_d49b], a
	ld c, $0c
	call DelayFrames
	call SaveScreenTilesToBuffer1
	xor a
	ld [$ffba], a
	call Func_e8c50
	ld a, $07
	call Func_e8785
	ld a, $03
	ld [wcae2], a
	call Func_e8efc
	call LoadScreenTilesFromBuffer1
	ld a, $01
	ld [$ffba], a
	call Func_e8c0c
.asm_e8bf4
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

Func_e8c0c:
	call Func_e8f16
.asm_e8c0f
	call JoypadLowSensitivity
	call Func_e8eca
	jr c, .asm_e8c2e
	ld a, [wc6e8]
	bit 7, a
	jr nz, .asm_e8c2c
	call Func_e87a8
	call GBPrinter_CheckForErrors
	call GBPrinter_UpdateStatusMessage
	call DelayFrame
	jr .asm_e8c0f

.asm_e8c2c
	and a
	ret

.asm_e8c2e
	scf
	ret

Func_e8c30:
	callab Func_4039c
	ld a, l
	ld [wcaf5], a
	ld a, h
	ld [wcaf6], a
	ld a, $00
	rla ; copy carry flag state to bit 0
	ld [wcaf9], a
	and a
	jr z, .asm_e8c4d
	ld a, $05
	jr .asm_e8c4f

.asm_e8c4d
	ld a, $09
.asm_e8c4f
	ret

Func_e8c50:
	call ClearScreen
	callab Func_404bc
	ret

Func_e8c5c:
	xor a
	ld [$ffdb], a
	call Func_e8f24
	call Func_e910a
	ld a, [rIE]
	push af
	xor a
	ld [rIF], a
	ld a, $09
	ld [rIE], a
	call Func_e8783
	ld a, $13
	ld [wcae2], a
	call Func_e8efc
	call Func_e8f16
.asm_e8c7d
	call JoypadLowSensitivity
	call Func_e8eca
	jr c, .asm_e8c9a
	ld a, [wc6e8]
	bit 7, a
	jr nz, .asm_e8c9a
	call Func_e87a8
	call GBPrinter_CheckForErrors
	call GBPrinter_UpdateStatusMessage
	call DelayFrame
	jr .asm_e8c7d

.asm_e8c9a
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

Func_e8cb1:
	xor a
	ld [$ffdb], a
	call Func_e8f24
	call _DisplayDiploma
	ld a, [rIE]
	push af
	xor a
	ld [rIF], a
	ld a, $09
	ld [rIE], a
	call Func_e8783
	ld a, $10
	ld [wcae2], a
	call Func_e8efc
	call Func_e8d11
	jr c, .asm_e8cfa
	xor a
	ld [wUnknownSerialFlag_d49a], a
	ld [wUnknownSerialFlag_d49b], a
	ld c, $0c
	call DelayFrames
	call SaveScreenTilesToBuffer1
	xor a
	ld [$ffba], a
	call Func_e9ad3
	call Func_e8783
	ld a, $03
	ld [wcae2], a
	call Func_e8efc
	call LoadScreenTilesFromBuffer1
	call Func_e8d11
.asm_e8cfa
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

Func_e8d11:
	call Func_e8f16
.asm_e8d14
	call JoypadLowSensitivity
	call Func_e8eca
	jr c, .asm_e8d33
	ld a, [wc6e8]
	bit 7, a
	jr nz, .asm_e8d31
	call Func_e87a8
	call GBPrinter_CheckForErrors
	call GBPrinter_UpdateStatusMessage
	call DelayFrame
	jr .asm_e8d14

.asm_e8d31
	and a
	ret

.asm_e8d33
	scf
	ret


	
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
	call Func_e988a
	call Func_e8783
	ld a, $10
	ld [wcae2], a
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
	call Func_e98ec
	call Func_e8783
	ld a, $00
	ld [wcae2], a
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
	call Func_e9907
	call Func_e8783
	ld a, $00
	ld [wcae2], a
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
	call Func_e9922
	call Func_e8783
	ld a, $03
	ld [wcae2], a
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
	call GBPrinter_CheckForErrors
	call GBPrinter_UpdateStatusMessage
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
	ld [wcae2], a
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
	call GBPrinter_CheckForErrors
	call GBPrinter_UpdateStatusMessage
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

Func_e8e79: ; e8e79 (3a:4e79)
	push af
	push bc
	push de
	push hl
	call StopAllMusic
	ld a, [rIE]
	push af
	xor a
	ld [rIF], a
	ld a, $09
	ld [rIE], a
	call Func_e8783
	ld a, $13
	ld [wcae2], a
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	call Func_e8efc
	call Func_ea573
.asm_e8e9c
	ld a, [wOverworldMap]
	bit 7, a
	jr nz, .asm_e8eae
	call Func_ea5d1
	call Func_ea5b7
	call DelayFrame
	jr .asm_e8e9c

.asm_e8eae
	xor a
	ld [wUnknownSerialFlag_d49a], a
	ld [wUnknownSerialFlag_d49b], a
	ld hl, wOAMBuffer + 32 * 4
	ld bc, $0020
	xor a
	call FillMemory
	xor a
	ld [rIF], a
	pop af
	ld [rIE], a
	pop hl
	pop de
	pop bc
	pop af
	ret

Func_e8eca: ; e8eca (3a:4eca)
	ld a, [hJoyHeld]
	and B_BUTTON
	jr nz, .asm_e8ed2
	and a
	ret

.asm_e8ed2
	ld a, [wOverworldMap]
	cp $0c
	jr nz, .asm_e8ef6
.asm_e8ed9
	ld a, [wUnknownSerialFlag_d49b]
	and a
	jr nz, .asm_e8ed9
	ld a, $16
	ld [wUnknownSerialFlag_d49b], a
	ld a, $88
	ld [rSB], a
	ld a, $01
	ld [rSC], a
	ld a, $81
	ld [rSC], a
.asm_e8ef0
	ld a, [wUnknownSerialFlag_d49b]
	and a
	jr nz, .asm_e8ef0
.asm_e8ef6
	ld a, $01
	ld [hItemCounter], a
	scf
	ret

Func_e8efc: ; e8efc (3a:4efc)
	coord hl, 0, 0
	coord de, 0, 0, wPrinterTileBuffer
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	call CopyData
	ret

Func_e8f09: ; e8f09 (3a:4f09)
	coord hl, 0, 0, wPrinterTileBuffer
	coord de, 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	call CopyData
	ret

Func_e8f16: ; e8f16 (3a:4f16)
	xor a
	ld [hJoyLast], a
	ld [hJoyReleased], a
	ld [hJoyPressed], a
	ld [hJoyHeld], a
	ld [hJoy5], a
	ld [hJoy6], a
	ret

Func_e8f24: ; e8f24 (3a:4f24)
	call Func_e8f42
	ld a, [wAudioROMBank]
	ld [wAudioSavedROMBank], a
	ld a, BANK(Music_GBPrinter)
	ld [wAudioROMBank], a
	ld a, MUSIC_GB_PRINTER
	ld [wNewSoundID], a
	call PlaySound
	ret

Func_e8f3b: ; e8f3b (3a:4f3b)
	call Func_e8f42
	call PlayDefaultMusic
	ret

Func_e8f42: ; e8f42 (3a:4f42)
	ld a, $4
	ld [wAudioFadeOutControl], a
	call StopAllMusic
.asm_e8f4a
	ld a, [wAudioFadeOutControl]
	and a
	jr nz, .asm_e8f4a
	ret

GBPrinter_CheckForErrors: ; e8f51 (3a:4f51)
	ld a, [wc970]
	cp $81
	jr z, .check_other_errors
	ld a, [wc971]
	cp $ff
	jr z, .error2
	xor a
	jr .load_status

.check_other_errors
	ld a, [wc971]
	and $e0
	ret z
	bit 7, a
	jr nz, .error1
	bit 6, a
	jr nz, .error4
	; error 3
	ld a, 6
	jr .load_status

.error4
	ld a, 7
	jr .load_status

.error1
	ld a, 4
	jr .load_status

.error2
	ld a, 5
.load_status
	ld [wPrinterStatusIndicator], a
	ret

GBPrinter_UpdateStatusMessage:
	ld a, [wPrinterStatusIndicator]
	and a
	ret z
	push af
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	coord hl, 0, 5
	lb bc, 10, 18
	call TextBoxBorder
	pop af
	ld e, a
	ld d, $0
	ld hl, Table_e8fca
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	coord hl, 1, 7
	call PlaceString
	coord hl, 2, 15
	ld de, String_e8fb8
	call PlaceString
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	xor a
	ld [wPrinterStatusIndicator], a
	ret

String_e8fb8:
	db "Press B to Cancel@"

Table_e8fca:
	dw .Blank
	dw .CheckingLink
	dw .Transmitting
	dw .Printing
	dw .Error1
	dw .Error2
	dw .Error3
	dw .Error4
	dw .WrongDevice

.Blank:
	db   "@"
.CheckingLink:
	db   ""
	next " CHECKING LINK...@"
.Transmitting:
	db   ""
	next "  TRANSMITTING...@"
.Printing:
	db   ""
	next "    PRINTING...@"
.Error1:
	db   " Printer Error 1"
	next ""
	next "Check the Game Boy"
	next "Printer Manual.@"
.Error2:
	db   " Printer Error 2"
	next ""
	next "Check the Game Boy"
	next "Printer Manual.@"
.Error3:
	db   " Printer Error 3"
	next ""
	next "Check the Game Boy"
	next "Printer Manual.@"
.Error4:
	db   " Printer Error 4"
	next ""
	next "Check the Game Boy"
	next "Printer Manual.@"
.WrongDevice:
	db   "This is not the"
	next "Game Boy Printer!@"

Func_e910a:
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	ld de, SurfingPikachu2Graphics
	ld hl, vChars2
	lb bc, BANK(SurfingPikachu2Graphics), (SurfingPikachu2GraphicsEnd - SurfingPikachu2Graphics) / $10
	call CopyVideoData
	coord hl, 0, 0
	call Func_e91a9
	coord hl, 0, 17
	call Func_e91a9
	coord hl, 0, 0
	call Func_e91b5
	coord hl, 19, 0
	call Func_e91b5
	ld a, $04
	coord hl, 0, 0
	ld [hl], a
	coord hl, 0, 17
	ld [hl], a
	coord hl, 19, 0
	ld [hl], a
	coord hl, 19, 17
	ld [hl], a
	ld de, Data_e91c4
	coord hl, 10, 8
	lb bc, 3, 8
	call Func_e925d
	ld de, Data_e91dc
	coord hl, 2, 11
	lb bc, 6, 16
	call Func_e925d
	ld de, String_e923c
	coord hl, 3, 2
	call PlaceString
	ld de, String_e924b
	coord hl, 9, 4
	call PlaceString
	ld de, String_e9256
	coord hl, 12, 6
	call PlaceString
	ld de, wPlayerName
	ld hl, wPlayerName
	ld bc, 0
.asm_e9182
	ld a, [hli]
	inc c
	cp "@"
	jr nz, .asm_e9182
	ld a, 8
	sub c
	jr nc, .asm_e918e
	xor a
.asm_e918e
	ld c, a
	coord hl, 2, 4
	add hl, bc
	call PlaceString
	call Func_e926f
	ld b, 8
	call RunPaletteCommand
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	call Delay3
	call GBPalNormal
	ret

Func_e91a9:
	ld c, SCREEN_WIDTH / 2
.asm_e91ab
	ld [hl], $00
	inc hl
	ld [hl], $01
	inc hl
	dec c
	jr nz, .asm_e91ab
	ret

Func_e91b5:
	ld c, SCREEN_HEIGHT / 2
	ld de, SCREEN_WIDTH
.asm_e91ba
	ld [hl], $02
	add hl, de
	ld [hl], $03
	add hl, de
	dec c
	jr nz, .asm_e91ba
	ret
Data_e91c4:
	db $7f, $7f, $10, $11, $12, $13, $14, $15
	db $0f, $3c, $3d, $3e, $20, $21, $30, $31
	db $4c, $4d, $4e, $50, $34, $1a, $51, $2d


Data_e91dc:
	db $7f, $7f, $7f, $7f, $7f, $7f, $16, $17, $18, $19, $7f, $1b, $1c, $1d, $1e, $1f
	db $7f, $7f, $22, $23, $24, $25, $26, $27, $28, $29, $2a, $2b, $2c, $7f, $2e, $2f
	db $7f, $7f, $32, $33, $33, $35, $36, $37, $38, $39, $3a, $3b, $7f, $7f, $7f, $3f
	db $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b, $40, $40, $40, $4f
	db $52, $52, $52, $53, $54, $55, $56, $57, $58, $59, $5a, $5b, $5c, $5d, $5d, $5e
	db $7f, $7f, $7f, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $7f, $7f, $7f


String_e923c:
	db "Pikachu's Beach@"
String_e924b:
	db "'s Hi-Score@"
String_e9256:
	db "Points@"

Func_e925d:
.asm_e925d
	push bc
	push hl
.asm_e925f
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .asm_e925f
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_e925d
	ret

Func_e926f:
	ld de, wd496
	coord hl, 7, 6
	ld a, [de]
	call Func_e927a
	ld a, [de]
Func_e927a:
	ld c, a
	swap a
	and $f
	add -10
	ld [hli], a
	ld a, c
	and $f
	add -10
	ld [hli], a
	dec de
	ret

SurfingPikachu2Graphics:  INCBIN "gfx/surfing_pikachu_2.2bpp"
SurfingPikachu2GraphicsEnd:

Func_e988a:
	xor a
	ld [wBoxNumString], a
	call ClearScreen
	call Func_e99de
	coord hl, 0, 0
	ld bc, 11 * SCREEN_WIDTH
	ld a, " "
	call FillMemory
	call Func_e99b9
	call Func_e99a7
	coord hl, 4, 4
	ld de, String_e98db
	call PlaceString
	coord hl, 7, 6
	ld de, String_e98e8
	call PlaceString
	coord hl, 11, 6
	ld a, [wCurrentBoxNum]
	and $7f
	cp 9
	jr c, .asm_e98cc
	sub 9
	ld [hl], "1"
	inc hl
	add "0"
	jr .asm_e98ce

.asm_e98cc
	add "1"
.asm_e98ce
	ld [hl], a
	coord hl, 4, 9
	ld de, wBoxSpecies
	ld c, $03
	call Func_e994e
	ret


String_e98db: db "POKéMON LIST@"
String_e98e8: db "BOX@"

Func_e98ec:
	call ClearScreen
	call Func_e99de
	call Func_e99b9
	ld a, [wBoxDataStart]
	cp 4
	ret c
	coord hl, 4, 0
	ld de, wBoxSpecies + 3
	ld c, 6
	call Func_e994e
	ret

Func_e9907:
	call ClearScreen
	call Func_e99de
	call Func_e99b9
	ld a, [wBoxDataStart]
	cp 10
	ret c
	coord hl, 4, 0
	ld de, wBoxSpecies + 9
	ld c, 6
	call Func_e994e
	ret

Func_e9922:
	call ClearScreen
	call Func_e99de
	call Func_e99b9
	coord hl, 0, 15
	call Func_e99cf
	coord hl, 0, 16
	ld bc, 2 * SCREEN_WIDTH
	ld a, " "
	call FillMemory
	ld a, [wBoxDataStart]
	cp 16
	ret c
	coord hl, 4, 0
	ld de, wBoxSpecies + 15
	ld c, 5
	call Func_e994e
	ret

Func_e994e:
.asm_e994e
	ld a, c
	and a
	jr z, .asm_e99a6
	dec c
	ld a, [de]
	cp $ff
	jr z, .asm_e99a6
	ld [wd11e], a
	push bc
	push hl
	push de
	push hl
	ld bc, 12
	ld a, " "
	call FillMemory
	pop hl
	push hl
	ld de, SCREEN_WIDTH
	add hl, de
	ld bc, 12
	ld a, " "
	call FillMemory
	pop hl
	push hl
	call GetMonName
	pop hl
	call PlaceString
	push hl
	ld hl, wBoxMonNicks
	ld bc, NAME_LENGTH
	ld a, [wBoxNumString]
	call AddNTimes
	ld e, l
	ld d, h
	pop hl
	ld bc, SCREEN_WIDTH + 1
	add hl, bc
	ld [hl], " "
	inc hl
	call PlaceString
	ld hl, wBoxNumString
	inc [hl]
	pop de
	pop hl
	ld bc, 3 * SCREEN_WIDTH
	add hl, bc
	pop bc
	inc de
	jr .asm_e994e

.asm_e99a6
	ret

Func_e99a7:
	coord hl, 0, 0
	ld a, $79
	ld [hli], a
	ld a, $7a
	ld c, SCREEN_WIDTH - 2
.asm_e99b1
	ld [hli], a
	dec c
	jr nz, .asm_e99b1
	ld a, $7b
	ld [hl], a
	ret

Func_e99b9:
	coord hl, 0, 0
	ld de, SCREEN_WIDTH - 1
	ld c, SCREEN_HEIGHT
.asm_e99c1
	ld a, $7c
	ld [hl], a
	add hl, de
	ld a, $7c
	ld [hli], a
	dec c
	jr nz, .asm_e99c1
	ret

Func_e99cc:
	coord hl, 0, 17
Func_e99cf:
	ld a, $7d
	ld [hli], a
	ld a, $7a
	ld c, SCREEN_WIDTH - 2
.asm_e99b1
	ld [hli], a
	dec c
	jr nz, .asm_e99b1
	ld a, $7e
	ld [hl], a
	ret

Func_e99de:
	coord hl, 4, 0
	ld c, 6
	call Func_e99eb
	coord hl, 6, 1
	ld c, 6
Func_e99eb:
.asm_e99eb
	push bc
	push hl
	ld de, String_e99fd
	call PlaceString
	pop hl
	ld bc, 3 * SCREEN_WIDTH
	add hl, bc
	pop bc
	dec c
	jr nz, .asm_e99eb
	ret

String_e99fd:
	db "----------@"
