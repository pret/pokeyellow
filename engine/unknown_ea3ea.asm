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
	lb bc, 16, 18
	call TextBoxBorder

	coord hl, 0, 12
	lb bc, 4, 18
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
	call .GetNamePointer
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
	ld de, .OT
	call PlaceString

	ld hl, wPartyMonOT
	call .GetNamePointer
	coord hl, 9, 5
	call PlaceString

	coord hl, 9, 6
	ld de, .IDNo
	call PlaceString

	coord hl, 13, 6
	ld de, wLoadedMonOTID
	lb bc, $80 | 2, 5
	call PrintNumber

	coord hl, 9, 8
	ld de, .Stats
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
	call .PlaceMoveName

	coord hl, 1, 14
	ld a, [wLoadedMonMoves + 1]
	call .PlaceMoveName

	coord hl, 1, 15
	ld a, [wLoadedMonMoves + 2]
	call .PlaceMoveName

	coord hl, 1, 16
	ld a, [wLoadedMonMoves + 3]
	call .PlaceMoveName

	ld b, $4 ; SET_PAL_STATUS_SCREEN
	call RunPaletteCommand

	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	call Delay3
	call GBPalNormal
	coord hl, 1, 1
	call LoadFlippedFrontSpriteByMonIndex
	ret

.GetNamePointer: ; ea511 (3a:6511)
	ld bc, NAME_LENGTH
	ld a, [wWhichPokemon]
	call AddNTimes
	ld e, l
	ld d, h
	ret

.PlaceMoveName: ; ea51d (3a:651d)
	and a
	jr z, .no_move
	ld [wPokeBallAnimData], a
	call GetMoveName
	jr .place_string

.no_move
	ld de, .Blank
.place_string
	call PlaceString
	ret
; ea52f

.OT:
	db "OT/@"
; ea533

.IDNo:
	db $73, "№/@"
; ea537

.Stats:
	db   "ATTACK"
	next "DEFENSE"
	next "SPEED"
	next "SPECIAL@"
; ea554

.Blank: ; ea554 (3a:6554)
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
	ld a, $8
	ld c, $8
.loop
	ld [hl], $10
	inc hl
	ld [hl], a
	inc hl
	ld [hl], $fe
	inc hl
	ld [hl], $0
	inc hl
	add $8
	dec c
	jr nz, .loop
	ret

GFX_ea597: ; ea597 (3a:6597)
INCBIN "gfx/zero_one_ea597.2bpp"
GFX_ea597End:

Func_ea5b7: ; ea5b7 (3a:65b7)
	ld hl, wOAMBuffer + 32 * 4 + 2
	ld de, 4
	ld a, [wPrinterStatusFlags]
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

Func_ea5d1: ; ea5d1 (3a:65d1)
	ld a, [wPrinterSendState]
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
	dw Func_ea623
	dw Func_ea6d2
	dw Func_ea6af
	dw Func_ea645
	dw Func_ea701
	dw Func_ea6bd
	dw Func_ea671
	dw Func_ea701
	dw Func_ea6af
	dw Func_ea68a
	dw Func_ea701
	dw Func_ea6af
	dw Func_ea721
	dw Func_ea610
	dw Func_ea61a
	dw Func_ea6af
	dw Func_ea61e
	dw Func_ea72f
	dw Func_ea732


Func_ea606: ; ea606 (3a:6606)
	ld hl, wPrinterSendState
	inc [hl]
	ret

Func_ea60b: ; ea60b (3a:660b)
	ld hl, wPrinterSendState
	dec [hl]
	ret

Func_ea610: ; ea610 (3a:6610)
	xor a
	ld [wPrinterStatusFlags], a
	ld hl, wPrinterSendState
	set 7, [hl]
	ret

Func_ea61a: ; ea61a (3a:661a)
	call Func_ea606
	ret

Func_ea61e: ; ea61e (3a:661e)
	xor a
	ld [wPrinterSendState], a
	ret

Func_ea623: ; ea623 (3a:6623)
	call Func_ea784
	ld hl, Data_ea9de
	call Func_ea76b
	xor a
	ld [wPrinterDataSize], a
	ld [wPrinterDataSize + 1], a
	ld a, [wPrinterQueueLength]
	ld [wPrinterRowIndex], a
	call Func_ea606
	call Func_ea74c
	ld a, $1
	ld [wPrinterStatusIndicator], a
	ret

Func_ea645: ; ea645 (3a:6645)
	call Func_ea784
	ld hl, wPrinterRowIndex
	ld a, [hl]
	and a
	jr z, Func_ea671
	ld hl, Data_ea9ea
	call Func_ea76b
	call Func_ea7e9
	ld a, $80
	ld [wPrinterDataSize], a
	ld a, $2
	ld [wPrinterDataSize + 1], a
	call Func_ea7a2
	call Func_ea606
	call Func_ea74c
	ld a, $2
	ld [wPrinterStatusIndicator], a
	ret

Func_ea671: ; ea671 (3a:6671)
	ld a, $6
	ld [wPrinterSendState], a
	ld hl, Data_ea9f0
	call Func_ea76b
	xor a
	ld [wPrinterDataSize], a
	ld [wPrinterDataSize + 1], a
	call Func_ea606
	call Func_ea74c
	ret

Func_ea68a: ; ea68a (3a:668a)
	call Func_ea784
	ld hl, Data_ea9e4
	call Func_ea76b
	call Func_ea7d2
	ld a, $4
	ld [wPrinterDataSize], a
	ld a, $0
	ld [wPrinterDataSize + 1], a
	call Func_ea7a2
	call Func_ea606
	call Func_ea74c
	ld a, $3
	ld [wPrinterStatusIndicator], a
	ret

Func_ea6af: ; ea6af (3a:66af)
	ld hl, wPrinterSerialFrameDelay
	inc [hl]
	ld a, [hl]
	cp a, $6
	ret c
	xor a
	ld [hl], a
	call Func_ea606
	ret

Func_ea6bd: ; ea6bd (3a:66bd)
	ld hl, wPrinterSerialFrameDelay
	inc [hl]
	ld a, [hl]
	cp 6
	ret c
	xor a
	ld [hl], a
	ld hl, wPrinterRowIndex
	dec [hl]
	call Func_ea60b
	call Func_ea60b
	ret

Func_ea6d2: ; ea6d2 (3a:66d2)
	call Func_ea742
	ret c
	ld a, [wPrinterHandshake]
	cp a, $ff
	jr nz, .asm_ea6e4
	ld a, [wPrinterStatusFlags]
	cp a, $ff
	jr z, .asm_ea6fb
.asm_ea6e4
	ld a, [wPrinterHandshake]
	cp a, $81
	jr nz, .asm_ea6fb
	ld a, [wPrinterStatusFlags]
	cp a, $0
	jr nz, .asm_ea6fb
	ld hl, wPrinterConnectionOpen
	set 1, [hl]
	call Func_ea606
	ret

.asm_ea6fb
	ld a, $e
	ld [wPrinterSendState], a
	ret

Func_ea701: ; ea701 (3a:6701)
	call Func_ea742
	ret c
	ld a, [wPrinterStatusFlags]
	and $f0
	jr nz, .asm_ea71b
	ld a, [wPrinterStatusFlags]
	and $1
	jr nz, .asm_ea717
	call Func_ea606
	ret

.asm_ea717
	call Func_ea60b
	ret

.asm_ea71b
	ld a, $11
	ld [wPrinterSendState], a
	ret

Func_ea721: ; ea721 (3a:6721)
	call Func_ea742
	ret c
	ld a, [wPrinterStatusFlags]
	and $f3
	ret nz
	call Func_ea606
	ret

Func_ea72f: ; ea72f (3a:672f)
	call Func_ea606
Func_ea732: ; ea732 (3a:6732)
	ld a, [wPrinterOpcode]
	and a
	ret nz
	ld a, [wPrinterStatusFlags]
	and $f0
	ret nz
	xor a
	ld [wPrinterSendState], a
	ret

Func_ea742: ; ea742 (3a:6742)
	ld a, [wPrinterOpcode]
	and a
	jr nz, .asm_ea74a
	and a
	ret

.asm_ea74a
	scf
	ret

Func_ea74c: ; ea74c (3a:674c)
.asm_ea74c
	ld a, [wPrinterOpcode]
	and a
	jr nz, .asm_ea74c
	ld a, $1
	ld [wPrinterOpcode], a
	xor a
	ld [wPrinterSendByteOffset], a
	ld [wPrinterSendByteOffset + 1], a
	ld a, $88
	ld [rSB], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	ret

Func_ea76b: ; ea76b (3a:676b)
	ld a, [hli]
	ld [wPrinterDataHeader], a
	ld a, [hli]
	ld [wPrinterDataHeader + 1], a
	ld a, [hli]
	ld [wPrinterDataHeader + 2], a
	ld a, [hli]
	ld [wPrinterDataHeader + 3], a
	ld a, [hli]
	ld [wPrinterDataHeader + 4], a
	ld a, [hl]
	ld [wPrinterDataHeader + 5], a
	ret

Func_ea784: ; ea784 (3a:6784)
	xor a
	ld hl, wPrinterDataHeader
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wPrinterDataHeader + 4
	ld [hli], a
	ld [hl], a
	xor a
	ld [wPrinterDataSize], a
	ld [wPrinterDataSize + 1], a
	ld hl, wPrinterSendDataSource
	ld bc, $280
	call FillMemory
	ret

Func_ea7a2: ; ea7a2 (3a:67a2)
	ld hl, $0
	ld bc, $4
	ld de, wPrinterDataHeader
	call Func_ea7c5
	ld a, [wPrinterDataSize]
	ld c, a
	ld a, [wPrinterDataSize + 1]
	ld b, a
	ld de, wPrinterSendDataSource
	call Func_ea7c5
	ld a, l
	ld [wPrinterDataHeader + 4], a
	ld a, h
	ld [wPrinterDataHeader + 5], a
	ret

Func_ea7c5: ; ea7c5 (3a:67c5)
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

Func_ea7d2: ; ea7d2 (3a:67d2)
	ld a, $1
	ld [wPrinterSendDataSource], a
	ld a, [wcae2]
	ld [wPrinterStatusReceived], a
	ld a, $e4
	ld [wc6f2], a
	ld a, [wPrinterSettingsTempCopy]
	ld [wc6f3], a
	ret

Func_ea7e9: ; ea7e9 (3a:67e9)
	ld a, [wPrinterRowIndex]
	ld b, a
	ld a, [wPrinterQueueLength]
	sub b
	ld hl, wPrinterTileBuffer
	ld de, $28
.get_start_addr
	and a
	jr z, .start_working
	add hl, de
	dec a
	jr .get_start_addr

.start_working
	ld e, l
	ld d, h
	ld hl, wPrinterSendDataSource
	ld c, $28
.prep_loop
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
	and $f
	ld d, a
	and $8
	ld a, d
	jr nz, .vtiles1
	or $90
	jr .got_vram_address

.vtiles1
	or $80
.got_vram_address
	ld d, a
	lb bc, BANK(Func_ea7e9), $1
	call CopyVideoData
	pop hl
	ld de, $10
	add hl, de
	pop de
	pop bc
	dec c
	jr nz, .prep_loop
	call .UnnecessaryCall
	ret

.UnnecessaryCall: ; ea834 (3a:6834)
	ld hl, wcbdc
	ld bc, $20
	xor a
	call FillMemory
	ld hl, wOAMBuffer
	ld c, $28
.master_loop
	push bc
	push hl
	call .AreWePrintingThisSegment
	jr nc, .skip_segment
	call .GetVRAMAddress
	call .GetOAMFlags
	call .ApplyObjectPalettes
	call .PlaceObject
.skip_segment
	pop hl
	inc hl
	inc hl
	inc hl
	inc hl
	pop bc
	dec c
	jr nz, .master_loop
	ret

.AreWePrintingThisSegment: ; ea860 (3a:6860)
	ld a, [wPrinterRowIndex]
	ld b, a
	ld a, [wPrinterQueueLength]
	sub b
	ld c, a
	ld b, $10
.add_n_times
	ld a, c
	and a
	jr z, .check
	ld a, b
	add $10
	ld b, a
	dec c
	jr .add_n_times

.check
	ld a, b
	ld e, a
	add $10
	ld d, a
	ld a, [hl]
	cp e
	jr c, .not_printing
	cp d
	jr nc, .not_printing
	scf
	ret

.not_printing
	and a
	ret

.GetVRAMAddress: ; ea886 (3a:6886)
	push hl
	inc hl
	inc hl
	ld a, [hl]
	swap a
	ld d, a
	and $f0
	ld e, a
	ld a, d
	and $f
	or $80
	ld d, a
	ld hl, wcbdc
	lb bc, BANK(.GetVRAMAddress), $1
	call CopyVideoData
	pop hl
	ret

.GetOAMFlags: ; ea8a1 (3a:68a1)
	push hl
	inc hl
	inc hl
	inc hl
	ld a, [hl]
	call .DoBitOperation
	pop hl
	ret

.DoBitOperation: ; ea8ab (3a:68ab)
	and $60
	swap a
	ld e, a
	ld d, 0
	ld hl, .Jumptable
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

.Jumptable: ; ea8ba (3a:68ba)
	dw .nop
	dw .one
	dw .two
	dw .both

.nop: ; ea8c2 (3a:68c2)
	ret

.one: ; ea8c3 (3a:68c3)
	call .Invert
	ret

.two: ; ea8c7 (3a:68c7)
	call .Swap
	ret

.both: ; ea8cb (3a:68cb)
	call .Invert
	call .Swap
	ret

.Invert: ; ea8d2 (3a:68d2)
	ld hl, wcbdc
	ld c, 16
.byte_loop
	ld d, [hl]
	ld a, 0
	ld b, 8
.bit_loop
	sla d
	rr a
	dec b
	jr nz, .bit_loop
	ld [hli], a
	dec c
	jr nz, .byte_loop
	ret

.Swap: ; ea8e8 (3a:68e8)
	ld hl, wcbdc
	ld de, wcbea
	ld c, $4
.swap_loop
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
	jr nz, .swap_loop
	ret

.ApplyObjectPalettes: ; ea902 (3a:6902)
	push hl
	ld hl, wcbdc
	ld de, wcbec
	ld a, 8
.loop1
	push af
	ld bc, $0
	ld a, 8
.loop2
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
	call .ExpandPalettesToBC
	pop de
	pop hl
	pop af
	dec a
	jr nz, .loop2
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
	jr nz, .loop1
	pop hl
	ret

.ExpandPalettesToBC: ; ea936 (3a:6936)
	call .GetPaletteFunction
	call .ApplyPaletteFunction
	ret

.GetPaletteFunction: ; ea93d (3a:693d)
	ld e, a
	ld d, 0
	ld hl, .PalJumptable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

.PalJumptable: ; ea949 (3a:6949)
	dw .Pal0
	dw .Pal1
	dw .Pal2
	dw .Pal3

.Pal0: ; ea951 (3a:6951)
	ld a, [rOBP0]
	and $3
	ret

.Pal2: ; ea956 (3a:6956)
	ld a, [rOBP0]
	and $c
	srl a
	srl a
	ret

.Pal1: ; ea95f (3a:695f)
	ld a, [rOBP0]
	and $30
	swap a
	ret

.Pal3: ; ea966 (3a:6966)
	ld a, [rOBP0]
	and $c0
	rlca
	rlca
	ret

.ApplyPaletteFunction: ; ea96d (3a:696d)
	ld e, a
	ld d, 0
	ld hl, .PalFunJumptable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

.PalFunJumptable: ; ea979 (3a:6979)
	dw .zero_zero
	dw .one_zero
	dw .zero_one
	dw .one_one

.zero_zero: ; ea981 (3a:6981)
	sla b
	sla c
	ret

.one_zero: ; ea986 (3a:6986)
	scf
	rl b
	sla c
	ret

.zero_one: ; ea98c (3a:698c)
	sla b
	scf
	rl c
	ret

.one_one: ; ea992 (3a:6992)
	scf
	rl b
	scf
	rl c
	ret

.PlaceObject: ; ea999 (3a:6999)
	push hl
	ld a, [hli]
	ld c, [hl]
	and $8
	jr nz, .use_wc830
	ld hl, wPrinterSendDataSource
	jr .got_data_source

.use_wc830
	ld hl, wc830
.got_data_source
	ld b, $0
	ld a, c
	and %11111000
	sub $8
	ld c, a
	sla c
	rl b
	add hl, bc
	ld e, l
	ld d, h
	ld hl, wcbec
	ld c, $8
.coord_copy_loop
	call .GetBitMask
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
	jr nz, .coord_copy_loop
	pop hl
	ret

.GetBitMask: ; ea9d0 (3a:69d0)
	push hl
	push de
	ld de, -$10
	add hl, de
	ld a, [hli]
	or [hl]
	xor $ff
	ld b, a
	pop de
	pop hl
	ret

Data_ea9de: ; ea9de
	db  1, 0, $00, 0
	dw 1
Data_ea9e4: ; ea9e4
	db  2, 0, $04, 0
	dw 0
Data_ea9ea: ; ea9ea
	db  4, 0, $80, 2
	dw 0
Data_ea9f0: ; ea9f0
	db  4, 0, $00, 0
	dw 4
Data_ea9f6: ; ea9f6
	db  8, 0, $00, 0
	dw 8
Data_ea9fc: ; ea9fc
	db 15, 0, $00, 0
	dw 15
