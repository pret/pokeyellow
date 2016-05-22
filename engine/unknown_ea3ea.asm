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
INCBIN "gfx/unknown_ea563.1bpp"
GFX_ea563End: ; ea56b (3a:656b)

GFX_ea56b:
INCBIN "gfx/unknown_ea56b.1bpp"
GFX_ea56bEnd: ; ea573 (3a:6573)
