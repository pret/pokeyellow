Printer_GetMonStats:
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
	ldh [hAutoBGTransferEnabled], a
	xor a
	ld [wWhichTradeMonSelectionMenu], a
	call LoadMonData

	ld hl, wTileMap
	lb bc, 16, 18
	call TextBoxBorder

	hlcoord 0, 12
	lb bc, 4, 18
	call TextBoxBorder

	hlcoord 3, 10
	call PrintLevelFull

	hlcoord 2, 10
	ld a, $6e
	ld [hli], a
	ld [hl], ' '

	hlcoord 2, 11
	ld [hl], '’'

	hlcoord 4, 11
	ld de, wLoadedMonMaxHP
	lb bc, 2, 3
	call PrintNumber

	ld a, [wMonHIndex]
	ld [wPokedexNum], a
	ld [wCurSpecies], a
	ld hl, wPartyMonNicks
	call .GetNamePointer
	hlcoord 8, 2
	call PlaceString

	call GetMonName
	hlcoord 9, 3
	call PlaceString

	predef IndexToPokedex
	hlcoord 2, 8
	ld [hl], '№'
	inc hl
	ld [hl], $f2
	inc hl
	ld de, wPokedexNum
	lb bc, $80 | 1, 3
	call PrintNumber

	hlcoord 8, 4
	ld de, .OT
	call PlaceString

	ld hl, wPartyMonOT
	call .GetNamePointer
	hlcoord 9, 5
	call PlaceString

	hlcoord 9, 6
	ld de, .IDNo
	call PlaceString

	hlcoord 13, 6
	ld de, wLoadedMonOTID
	lb bc, $80 | 2, 5
	call PrintNumber

	hlcoord 9, 8
	ld de, .Stats
	ldh a, [hUILayoutFlags]
	set BIT_SINGLE_SPACED_LINES, a
	ldh [hUILayoutFlags], a
	call PlaceString
	ldh a, [hUILayoutFlags]
	res BIT_SINGLE_SPACED_LINES, a
	ldh [hUILayoutFlags], a

	hlcoord 16, 8
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

	hlcoord 1, 13
	ld a, [wLoadedMonMoves]
	call .PlaceMoveName

	hlcoord 1, 14
	ld a, [wLoadedMonMoves + 1]
	call .PlaceMoveName

	hlcoord 1, 15
	ld a, [wLoadedMonMoves + 2]
	call .PlaceMoveName

	hlcoord 1, 16
	ld a, [wLoadedMonMoves + 3]
	call .PlaceMoveName

	ld b, SET_PAL_POKEDEX
	call RunPaletteCommand

	ld a, $1
	ldh [hAutoBGTransferEnabled], a
	call Delay3
	call GBPalNormal
	hlcoord 1, 1
	call LoadFlippedFrontSpriteByMonIndex
	ret

.GetNamePointer:
	ld bc, NAME_LENGTH
	ld a, [wWhichPokemon]
	call AddNTimes
	ld e, l
	ld d, h
	ret

.PlaceMoveName:
	and a
	jr z, .no_move
	ld [wNamedObjectIndex], a
	call GetMoveName
	jr .place_string

.no_move
	ld de, .Blank
.place_string
	call PlaceString
	ret

.OT:
	db "OT/@"

.IDNo:
	db "<ID>№/@"

.Stats:
	db   "ATTACK"
	next "DEFENSE"
	next "SPEED"
	next "SPECIAL@"

.Blank:
	db "--------------@"

GFX_ea563:
INCBIN "gfx/printer/hp.1bpp"
GFX_ea563End:

GFX_ea56b:
INCBIN "gfx/printer/lv.1bpp"
GFX_ea56bEnd:

PrinterDebug_LoadGFX:
	ld hl, vChars1 + $7e0
	ld de, GFX_ea597
	lb bc, BANK(GFX_ea597), (GFX_ea597End - GFX_ea597) / 16
	call CopyVideoData

	ld hl, wShadowOAMSprite32
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

GFX_ea597:
INCBIN "gfx/printer/01.2bpp"
GFX_ea597End:

PrinterDebug_ConvertStatusFlagsToTiles:
	ld hl, wShadowOAMSprite32TileID
	ld de, 4
	ld a, [wPrinterStatusFlags]
	ld c, 8
.loop
	sla a
	jr c, .place_1
	ld [hl], $fe
	jr .okay

.place_1
	ld [hl], $ff
.okay
	add hl, de
	dec c
	jr nz, .loop
	ret

PrinterDebug_DoFunction:
	ld a, [wPrinterSendState]
	ld e, a
	ld d, 0
	ld hl, .Jumptable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.Jumptable:
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

Func_ea606:
	ld hl, wPrinterSendState
	inc [hl]
	ret

Func_ea60b:
	ld hl, wPrinterSendState
	dec [hl]
	ret

Func_ea610:
	xor a
	ld [wPrinterStatusFlags], a
	ld hl, wPrinterSendState
	set 7, [hl]
	ret

Func_ea61a:
	call Func_ea606
	ret

Func_ea61e:
	xor a
	ld [wPrinterSendState], a
	ret

Func_ea623:
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

Func_ea645:
	call Func_ea784
	ld hl, wPrinterRowIndex
	ld a, [hl]
	and a
	jr z, Func_ea671
	ld hl, Data_ea9ea
	call Func_ea76b
	call PrinterDebug_PrepOAMForPrinting
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

Func_ea671:
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

Func_ea68a:
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

Func_ea6af:
	ld hl, wPrinterSerialFrameDelay
	inc [hl]
	ld a, [hl]
	cp $6
	ret c
	xor a
	ld [hl], a
	call Func_ea606
	ret

Func_ea6bd:
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

Func_ea6d2:
	call Func_ea742
	ret c
	ld a, [wPrinterHandshake]
	cp $ff
	jr nz, .asm_ea6e4
	ld a, [wPrinterStatusFlags]
	cp $ff
	jr z, .asm_ea6fb
.asm_ea6e4
	ld a, [wPrinterHandshake]
	cp $81
	jr nz, .asm_ea6fb
	ld a, [wPrinterStatusFlags]
	cp $0
	jr nz, .asm_ea6fb
	ld hl, wPrinterConnectionOpen
	set 1, [hl]
	call Func_ea606
	ret

.asm_ea6fb
	ld a, $e
	ld [wPrinterSendState], a
	ret

Func_ea701:
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

Func_ea721:
	call Func_ea742
	ret c
	ld a, [wPrinterStatusFlags]
	and $f3
	ret nz
	call Func_ea606
	ret

Func_ea72f:
	call Func_ea606
Func_ea732:
	ld a, [wPrinterOpcode]
	and a
	ret nz
	ld a, [wPrinterStatusFlags]
	and $f0
	ret nz
	xor a
	ld [wPrinterSendState], a
	ret

Func_ea742:
	ld a, [wPrinterOpcode]
	and a
	jr nz, .asm_ea74a
	and a
	ret

.asm_ea74a
	scf
	ret

Func_ea74c:
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
	ldh [rSB], a
	ld a, $1
	ldh [rSC], a
	ld a, $81
	ldh [rSC], a
	ret

Func_ea76b:
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

Func_ea784:
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
	ld hl, wPrinterSendDataSource1
	ld bc, $280
	call FillMemory
	ret

Func_ea7a2:
	ld hl, $0
	ld bc, $4
	ld de, wPrinterDataHeader
	call Func_ea7c5
	ld a, [wPrinterDataSize]
	ld c, a
	ld a, [wPrinterDataSize + 1]
	ld b, a
	ld de, wPrinterSendDataSource1
	call Func_ea7c5
	ld a, l
	ld [wPrinterDataHeader + 4], a
	ld a, h
	ld [wPrinterDataHeader + 5], a
	ret

Func_ea7c5:
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

Func_ea7d2:
	ld a, $1
	ld [wPrinterSendDataSource1], a
	ld a, [wcae2]
	ld [wPrinterStatusReceived], a
	ld a, $e4
	ld [wc6f2], a
	ld a, [wPrinterSettingsTempCopy]
	ld [wc6f3], a
	ret

PrinterDebug_PrepOAMForPrinting:
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
	ld hl, wPrinterSendDataSource1
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
	lb bc, BANK(PrinterDebug_PrepOAMForPrinting), $1
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

.UnnecessaryCall:
	ld hl, wcbdc
	ld bc, $20
	xor a
	call FillMemory
	ld hl, wShadowOAM
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

.AreWePrintingThisSegment:
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

.GetVRAMAddress:
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

.GetOAMFlags:
	push hl
	inc hl
	inc hl
	inc hl
	ld a, [hl]
	call .DoBitOperation
	pop hl
	ret

.DoBitOperation:
	and $60
	swap a
	ld e, a
	ld d, 0
	ld hl, .Jumptable
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.Jumptable:
	dw .nop
	dw .xflip
	dw .yflip
	dw .both

.nop:
	ret

.xflip:
	call .XFlip
	ret

.yflip:
	call .YFlip
	ret

.both:
	call .XFlip
	call .YFlip
	ret

.XFlip:
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

.YFlip:
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

.ApplyObjectPalettes:
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

.ExpandPalettesToBC:
	call .GetPaletteFunction
	call .ApplyPaletteFunction
	ret

.GetPaletteFunction:
	ld e, a
	ld d, 0
	ld hl, .PalJumptable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.PalJumptable:
	dw .Pal0
	dw .Pal1
	dw .Pal2
	dw .Pal3

.Pal0:
	ldh a, [rOBP0]
	and $3
	ret

.Pal2:
	ldh a, [rOBP0]
	and $c
	srl a
	srl a
	ret

.Pal1:
	ldh a, [rOBP0]
	and $30
	swap a
	ret

.Pal3:
	ldh a, [rOBP0]
	and $c0
	rlca
	rlca
	ret

.ApplyPaletteFunction:
	ld e, a
	ld d, 0
	ld hl, .PalFunJumptable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.PalFunJumptable:
	dw .zero_zero
	dw .xflip_zero
	dw .zero_xflip
	dw .xflip_xflip

.zero_zero:
	sla b
	sla c
	ret

.xflip_zero:
	scf
	rl b
	sla c
	ret

.zero_xflip:
	sla b
	scf
	rl c
	ret

.xflip_xflip:
	scf
	rl b
	scf
	rl c
	ret

.PlaceObject:
	push hl
	ld a, [hli]
	ld c, [hl]
	and $8
	jr nz, .use_source_2
	ld hl, wPrinterSendDataSource1
	jr .got_data_source

.use_source_2
	ld hl, wPrinterSendDataSource2
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

.GetBitMask:
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

Data_ea9de:
	db  1, 0, $00, 0
	dw 1
Data_ea9e4:
	db  2, 0, $04, 0
	dw 0
Data_ea9ea:
	db  4, 0, $80, 2
	dw 0
Data_ea9f0:
	db  4, 0, $00, 0
	dw 4
Data_ea9f6:
	db  8, 0, $00, 0
	dw 8
Data_ea9fc:
	db 15, 0, $00, 0
	dw 15
