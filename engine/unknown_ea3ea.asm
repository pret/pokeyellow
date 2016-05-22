Func_ea3ea: ; ea3ea (3a:63ea)
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	call LoadHpBarAndStatusTilePatterns
	ld de, GFX_ea563
	ld hl, vChars2 + $710
	lb bc, BANK(GFX_ea563), (GFX_ea563End - GFX_ea563) / 8
	call CopyVideoDataDouble

	ld de, GFX_ea56b
	ld hl, vChars2 + $6e0
	lb bc, BANK(GFX_ea56b), (GFX_ea56bEnd - GFX_ea56b) / 8
	call CopyVideoDataDouble

	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	xor a
	ld [wWhichTradeMonSelectionMenu], a
	call LoadMonData

	ld hl, wTileMap
	lb bc, $10, $12
	call TextBoxBorder

	coord hl, 0, 12
	lb bc, $04, $12
	call TextBoxBorder

	coord hl, 3, 10
	call PrintLevelFull

	coord hl, 2, 10
	ld a, $6e
	ld [hli], a
	ld [hl], " "

	coord hl, 2, 11
	ld [hl], "′"

	coord hl, 4, 11
	ld de, wLoadedMonMaxHP
	lb bc, 2, 3
	call PrintNumber

	ld a, [wMonHeader]
	ld [wPokeBallAnimData], a
	ld [wd0b5], a
	ld hl, wPartyMonNicks
	call Func_ea511
	coord hl, 8, 2
	call PlaceString

	call GetMonName
	coord hl, 9, 3
	call PlaceString

	predef IndexToPokedex
	coord hl, 2, 8
	ld [hl], "№"
	inc hl
	ld [hl], $f2
	inc hl
	ld de, wPokeBallAnimData
	lb bc, $80 | 1, 3
	call PrintNumber

	coord hl, 8, 4
	ld de, String_ea52f
	call PlaceString

	ld hl, wPartyMonOT
	call Func_ea511
	coord hl, 9, 5
	call PlaceString

	coord hl, 9, 6
	ld de, String_ea533
	call PlaceString

	coord hl, 13, 6
	ld de, wLoadedMonOTID
	lb bc, $80 | 2, 5
	call PrintNumber

	coord hl, 9, 8
	ld de, String_ea537
	ld a, [hFlags_0xFFFA]
	set 2, a
	ld [hFlags_0xFFFA], a
	call PlaceString
	ld a, [hFlags_0xFFFA]
	res 2, a
	ld [hFlags_0xFFFA], a

	coord hl, 16, 8
	ld de, wLoadedMonAttack
	ld a, 4
.loop
	push af
	push de

	push hl
	lb bc, 2, 3
	call PrintNumber
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc

	pop de
	inc de
	inc de
	pop af
	dec a
	jr nz, .loop

	coord hl, 1, 13
	ld a, [wLoadedMonMoves]
	call Func_ea51d

	coord hl, 1, 14
	ld a, [wLoadedMonMoves + 1]
	call Func_ea51d

	coord hl, 1, 15
	ld a, [wLoadedMonMoves + 2]
	call Func_ea51d

	coord hl, 1, 16
	ld a, [wLoadedMonMoves + 3]
	call Func_ea51d

	ld b, $04 ; SET_PAL_STATUS_SCREEN
	call RunPaletteCommand

	ld a, $01
	ld [H_AUTOBGTRANSFERENABLED], a
	call Delay3
	call GBPalNormal
	coord hl, 1, 1
	call LoadFlippedFrontSpriteByMonIndex
	ret

Func_ea511: ; ea511 (3a:6511)
	ld bc, NAME_LENGTH
	ld a, [wWhichPokemon]
	call AddNTimes
	ld e, l
	ld d, h
	ret

Func_ea51d: ; ea51d (3a:651d)
	and a
	jr z, .asm_e6528
	ld [wPokeBallAnimData], a
	call GetMoveName
	jr .asm_ea52b

.asm_e6528
	ld de, String_ea554
.asm_ea52b
	call PlaceString
	ret
; ea52f

String_ea52f:
	db "OT/@"
; ea533

String_ea533:
	db $73, "№/@"
; ea537

String_ea537:
	db   "ATTACK"
	next "DEFENSE"
	next "SPEED"
	next "SPECIAL@"
; ea554

String_ea554: ; ea554 (3a:6554)
	db "--------------@"

GFX_ea563: ; ea563 (3a:6563)
INCBIN "gfx/stats_screen_hp.1bpp"
GFX_ea563End: ; ea56b (3a:656b)

GFX_ea56b:
INCBIN "gfx/stats_screen_lv.1bpp"
GFX_ea56bEnd: ; ea573 (3a:6573)

Func_ea573: ; ea573 (3a:6573)
	ld hl, vChars1 + $7e0
	ld de, GFX_ea597
	lb bc, BANK(GFX_ea597), (GFX_ea597End - GFX_ea597) / 16
	call CopyVideoData

	ld hl, wOAMBuffer + 32 * 4
	ld a, $08
	ld c, $08
.loop
	ld [hl], $10
	inc hl
	ld [hl], a
	inc hl
	ld [hl], $fe
	inc hl
	ld [hl], $00
	inc hl
	add $08
	dec c
	jr nz, .loop
	ret

GFX_ea597: ; ea597 (3a:6597)
INCBIN "gfx/zero_one_ea597.2bpp"
GFX_ea597End:

Func_ea5b7: ; ea5b7 (3a:65b7)
	ld hl, wOAMBuffer + 32 * 4 + 2
	ld de, 4
	ld a, [$c971]
	ld c, 8
.asm_ea5c2
	sla a
	jr c, .asm_ea5ca
	ld [hl], $fe
	jr .asm_ea5cc

.asm_ea5ca
	ld [hl], $ff
.asm_ea5cc
	add hl, de
	dec c
	jr nz, .asm_ea5c2
	ret

Functionea5d1: ; ea5d1 (3a:65d1)
	ld a, [wOverworldMap]
	ld e, a
	ld d, 0
	ld hl, Jumptable_ea5e0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

Jumptable_ea5e0:
	dw Functionea623
	dw Functionea6d2
	dw Functionea6af
	dw Functionea645
	dw Functionea701
	dw Functionea6bd
	dw Functionea671
	dw Functionea701
	dw Functionea6af
	dw Functionea68a
	dw Functionea701
	dw Functionea6af
	dw Functionea721
	dw Functionea610
	dw Functionea61a
	dw Functionea6af
	dw Functionea61e
	dw Functionea72f
	dw Functionea732


Functionea606: ; ea606 (3a:6606)
	ld hl, wOverworldMap
	inc [hl]
	ret

Functionea60b: ; ea60b (3a:660b)
	ld hl, wOverworldMap
	dec [hl]
	ret

Functionea610: ; ea610 (3a:6610)
	xor a
	ld [$c971], a
	ld hl, wOverworldMap
	set 7, [hl]
	ret

Functionea61a: ; ea61a (3a:661a)
	call Functionea606
	ret

Functionea61e: ; ea61e (3a:661e)
	xor a
	ld [wOverworldMap], a
	ret

Functionea623: ; ea623 (3a:6623)
	call Functionea784
	ld hl, Data_ea9de
	call Functionea76b
	xor a
	ld [$c976], a
	ld [$c977], a
	ld a, [$caf4]
	ld [$c6e9], a
	call Functionea606
	call Functionea74c
	ld a, $01
	ld [$cae0], a
	ret

Functionea645: ; ea645 (3a:6645)
	call Functionea784
	ld hl, $c6e9
	ld a, [hl]
	and a
	jr z, Functionea671
	ld hl, Data_ea9ea
	call Functionea76b
	call Functionea7e9
	ld a, $80
	ld [$c976], a
	ld a, $02
	ld [$c977], a
	call Functionea7a2
	call Functionea606
	call Functionea74c
	ld a, $02
	ld [$cae0], a
	ret

Functionea671: ; ea671 (3a:6671)
	ld a, $06
	ld [wOverworldMap], a
	ld hl, Data_ea9f0
	call Functionea76b
	xor a
	ld [$c976], a
	ld [$c977], a
	call Functionea606
	call Functionea74c
	ret

Functionea68a: ; ea68a (3a:668a)
	call Functionea784
	ld hl, Data_ea9e4
	call Functionea76b
	call Functionea7d2
	ld a, $04
	ld [$c976], a
	ld a, $00
	ld [$c977], a
	call Functionea7a2
	call Functionea606
	call Functionea74c
	ld a, $03
	ld [$cae0], a
	ret

Functionea6af: ; ea6af (3a:66af)
	ld hl, $c973
	inc [hl]
	ld a, [hl]
	cp a, $06
	ret c
	xor a
	ld [hl], a
	call Functionea606
	ret

Functionea6bd: ; ea6bd (3a:66bd)
	ld hl, $c973
	inc [hl]
	ld a, [hl]
	cp 6
	ret c
	xor a
	ld [hl], a
	ld hl, $c6e9
	dec [hl]
	call Functionea60b
	call Functionea60b
	ret

Functionea6d2: ; ea6d2 (3a:66d2)
	call Functionea742
	ret c
	ld a, [$c970]
	cp a, $ff
	jr nz, .asm_ea6e4
	ld a, [$c971]
	cp a, $ff
	jr z, .asm_ea6fb
.asm_ea6e4
	ld a, [$c970]
	cp a, $81
	jr nz, .asm_ea6fb
	ld a, [$c971]
	cp a, $00
	jr nz, .asm_ea6fb
	ld hl, wUnknownSerialFlag_d49a
	set 1, [hl]
	call Functionea606
	ret

.asm_ea6fb
	ld a, $0e
	ld [wOverworldMap], a
	ret

Functionea701: ; ea701 (3a:6701)
	call Functionea742
	ret c
	ld a, [$c971]
	and $f0
	jr nz, .asm_ea71b
	ld a, [$c971]
	and $01
	jr nz, .asm_ea717
	call Functionea606
	ret

.asm_ea717
	call Functionea60b
	ret

.asm_ea71b
	ld a, $11
	ld [wOverworldMap], a
	ret

Functionea721: ; ea721 (3a:6721)
	call Functionea742
	ret c
	ld a, [$c971]
	and $f3
	ret nz
	call Functionea606
	ret

Functionea72f: ; ea72f (3a:672f)
	call Functionea606
Functionea732: ; ea732 (3a:6732)
	ld a, [wUnknownSerialFlag_d49b]
	and a
	ret nz
	ld a, [$c971]
	and $f0
	ret nz
	xor a
	ld [wOverworldMap], a
	ret

Functionea742: ; ea742 (3a:6742)
	ld a, [wUnknownSerialFlag_d49b]
	and a
	jr nz, .asm_ea74a
	and a
	ret

.asm_ea74a
	scf
	ret

Functionea74c: ; ea74c (3a:674c)
.asm_ea74c
	ld a, [wUnknownSerialFlag_d49b]
	and a
	jr nz, .asm_ea74c
	ld a, $01
	ld [wUnknownSerialFlag_d49b], a
	xor a
	ld [$c974], a
	ld [$c975], a
	ld a, $88
	ld [rSB], a
	ld a, $01
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	ret

Functionea76b: ; ea76b (3a:676b)
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

Functionea784: ; ea784 (3a:6784)
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
	ld bc, $280
	call FillMemory
	ret

Functionea7a2: ; ea7a2 (3a:67a2)
	ld hl, $0000
	ld bc, $0004
	ld de, $c6ea
	call Functionea7c5
	ld a, [$c976]
	ld c, a
	ld a, [$c977]
	ld b, a
	ld de, $c6f0
	call Functionea7c5
	ld a, l
	ld [$c6ee], a
	ld a, h
	ld [$c6ef], a
	ret

Functionea7c5: ; ea7c5 (3a:67c5)
.asm_ea7c5
	ld a, [de]
	inc de
	add l
	jr nc, .asm_ea7cb
	inc h
.asm_ea7cb
	ld l, a
	dec bc
	ld a, c
	or b
	jr nz, .asm_ea7c5
	ret

Functionea7d2: ; ea7d2 (3a:67d2)
	ld a, $01
	ld [$c6f0], a
	ld a, [$cae2]
	ld [$c6f1], a
	ld a, $e4
	ld [$c6f2], a
	ld a, [$cae3]
	ld [$c6f3], a
	ret

Functionea7e9: ; ea7e9 (3a:67e9)
	ld a, [$c6e9]
	ld b, a
	ld a, [$caf4]
	sub b
	ld hl, $c978
	ld de, $0028
.asm_ea7f7
	and a
	jr z, .asm_ea7fe
	add hl, de
	dec a
	jr .asm_ea7f7

.asm_ea7fe
	ld e, l
	ld d, h
	ld hl, $c6f0
	ld c, $28
.asm_ea805
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	swap a
	ld d, a
	and $f0
	ld e, a
	ld a, d
	and $0f
	ld d, a
	and $08
	ld a, d
	jr nz, .asm_ea81d
	or $90
	jr .asm_ea81f

.asm_ea81d
	or $80
.asm_ea81f
	ld d, a
	lb bc, $3a, $01
	call CopyVideoData
	pop hl
	ld de, $0010
	add hl, de
	pop de
	pop bc
	dec c
	jr nz, .asm_ea805
	call Functionea834
	ret

Functionea834: ; ea834 (3a:6834)
	ld hl, $cbdc
	ld bc, $0020
	xor a
	call FillMemory
	ld hl, $c300
	ld c, $28
.asm_ea843
	push bc
	push hl
	call Functionea860
	jr nc, .asm_ea856
	call Functionea886
	call Functionea8a1
	call Functionea902
	call Functionea999
.asm_ea856
	pop hl
	inc hl
	inc hl
	inc hl
	inc hl
	pop bc
	dec c
	jr nz, .asm_ea843
	ret

Functionea860: ; ea860 (3a:6860)
	ld a, [$c6e9]
	ld b, a
	ld a, [$caf4]
	sub b
	ld c, a
	ld b, $10
.asm_ea86b
	ld a, c
	and a
	jr z, .asm_ea876
	ld a, b
	add $10
	ld b, a
	dec c
	jr .asm_ea86b

.asm_ea876
	ld a, b
	ld e, a
	add $10
	ld d, a
	ld a, [hl]
	cp e
	jr c, .asm_ea884
	cp d
	jr nc, .asm_ea884
	scf
	ret

.asm_ea884
	and a
	ret

Functionea886: ; ea886 (3a:6886)
	push hl
	inc hl
	inc hl
	ld a, [hl]
	swap a
	ld d, a
	and $f0
	ld e, a
	ld a, d
	and $0f
	or $80
	ld d, a
	ld hl, $cbdc
	lb bc, $3a, $01
	call CopyVideoData
	pop hl
	ret

Functionea8a1: ; ea8a1 (3a:68a1)
	push hl
	inc hl
	inc hl
	inc hl
	ld a, [hl]
	call Functionea8ab
	pop hl
	ret

Functionea8ab: ; ea8ab (3a:68ab)
	and $60
	swap a
	ld e, a
	ld d, 0
	ld hl, Jumptable_ea8ba
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

Jumptable_ea8ba: ; ea8ba (3a:68ba)
	dw Functionea8c2
	dw Functionea8c3
	dw Functionea8c7
	dw Functionea8cb

Functionea8c2: ; ea8c2 (3a:68c2)
	ret

Functionea8c3: ; ea8c3 (3a:68c3)
	call Functionea8d2
	ret

Functionea8c7: ; ea8c7 (3a:68c7)
	call Functionea8e8
	ret

Functionea8cb: ; ea8cb (3a:68cb)
	call Functionea8d2
	call Functionea8e8
	ret

Functionea8d2: ; ea8d2 (3a:68d2)
	ld hl, $cbdc
	ld c, 16
.asm_ea8d7
	ld d, [hl]
	ld a, 0
	ld b, 8
.asm_ea8dc
	sla d
	rr a
	dec b
	jr nz, .asm_ea8dc
	ld [hli], a
	dec c
	jr nz, .asm_ea8d7
	ret

Functionea8e8: ; ea8e8 (3a:68e8)
	ld hl, $cbdc
	ld de, $cbea
	ld c, $04
.asm_ea8f0
	ld b, [hl]
	ld a, [de]
	ld [hli], a
	ld a, b
	ld [de], a
	inc de
	ld b, [hl]
	ld a, [de]
	ld [hli], a
	ld a, b
	ld [de], a
	dec de
	dec de
	dec de
	dec c
	jr nz, .asm_ea8f0
	ret

Functionea902: ; ea902 (3a:6902)
	push hl
	ld hl, $cbdc
	ld de, $cbec
	ld a, $08
.asm_ea90b
	push af
	ld bc, $0000
	ld a, $08
.asm_ea911
	push af
	xor a
	rlc [hl]
	rl a
	inc hl
	rlc [hl]
	rl a
	dec hl
	push hl
	push de
	call Functionea936
	pop de
	pop hl
	pop af
	dec a
	jr nz, .asm_ea911
	inc hl
	inc hl
	ld a, b
	ld [de], a
	inc de
	ld a, c
	ld [de], a
	inc de
	pop af
	dec a
	jr nz, .asm_ea90b
	pop hl
	ret

Functionea936 ; ea936 (3a:6936)
	call Functionea93d
	call Functionea96d
	ret

Functionea93d: ; ea93d (3a:693d)
	ld e, a
	ld d, 0
	ld hl, Jumptable_ea949
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

Jumptable_ea949: ; ea949 (3a:6949)
	dw Functionea951
	dw Functionea95f
	dw Functionea956
	dw Functionea966

Functionea951: ; ea951 (3a:6951)
	ld a, [rOBP0]
	and $03
	ret

Functionea956: ; ea956 (3a:6956)
	ld a, [rOBP0]
	and $0c
	srl a
	srl a
	ret

Functionea95f: ; ea95f (3a:695f)
	ld a, [rOBP0]
	and $30
	swap a
	ret

Functionea966: ; ea966 (3a:6966)
	ld a, [rOBP0]
	and $c0
	rlca
	rlca
	ret

Functionea96d: ; ea96d (3a:696d)
	ld e, a
	ld d, 0
	ld hl, Jumptable_ea979
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

Jumptable_ea979: ; ea979 (3a:6979)
	dw Functionea981
	dw Functionea986
	dw Functionea98c
	dw Functionea992

Functionea981: ; ea981 (3a:6981)
	sla b
	sla c
	ret

Functionea986: ; ea986 (3a:6986)
	scf
	rl b
	sla c
	ret

Functionea98c: ; ea98c (3a:698c)
	sla b
	scf
	rl c
	ret

Functionea992: ; ea992 (3a:6992)
	scf
	rl b
	scf
	rl c
	ret

Functionea999: ; ea999 (3a:6999)
	push hl
	ld a, [hli]
	ld c, [hl]
	and $08
	jr nz, .asm_ea9a5
	ld hl, $c6f0
	jr .asm_ea9a8

.asm_ea9a5
	ld hl, $c830
.asm_ea9a8
	ld b, $00
	ld a, c
	and $f8
	sub $08
	ld c, a
	sla c
	rl b
	add hl, bc
	ld e, l
	ld d, h
	ld hl, $cbec
	ld c, $08
.asm_ea9bc
	call Functionea9d0
	ld a, [de]
	and b
	or [hl]
	ld [de], a
	inc hl
	inc de
	ld a, [de]
	and b
	or [hl]
	ld [de], a
	inc hl
	inc de
	dec c
	jr nz, .asm_ea9bc
	pop hl
	ret

Functionea9d0: ; ea9d0 (3a:69d0)
	push hl
	push de
	ld de, $fff0
	add hl, de
	ld a, [hli]
	or [hl]
	xor $ff
	ld b, a
	pop de
	pop hl
	ret

Data_ea9de: ; ea9de
	db $01, $00, $00, $00, $01, $00
Data_ea9e4: ; ea9e4
	db $02, $00, $04, $00, $00, $00
Data_ea9ea: ; ea9ea
	db $04, $00, $80, $02, $00, $00
Data_ea9f0: ; ea9f0
	db $04, $00, $00, $00, $04, $00
Data_ea9f6: ; ea9f6
	db $08, $00, $00, $00, $08, $00
Data_ea9fc: ; ea9fc
	db $0f, $00, $00, $00, $0f, $00
