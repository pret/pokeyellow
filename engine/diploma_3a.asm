_DisplayDiploma: ; e9a08 (3a:5a08)
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	ld de, SurfingPikachu3Graphics
	ld hl, vChars2
	lb bc, BANK(SurfingPikachu3Graphics), (SurfingPikachu3GraphicsEnd - SurfingPikachu3Graphics) / $10
	call CopyVideoData

	coord hl, 0, 0
	call Func_e9bdf

	coord hl, 0, 0
	call Func_e9beb

	coord hl, 19, 0
	call Func_e9beb

	ld a, $00
	coord hl, 0, 0
	ld [hl], a
	coord hl, 19, 0
	ld [hl], a

	ld de, String_e9a73
	coord hl, 5, 2
	call PlaceString

	ld de, String_e9a7d
	coord hl, 3, 4
	call PlaceString

	ld de, wPlayerName
	coord hl, 10, 4
	call PlaceString

	ld de, String_e9a84
	coord hl, 2, 6
	call PlaceString

	ld de, String_e9ac8
	coord hl, 9, 16
	call PlaceString

	ld b, SET_PAL_GENERIC
	call RunPaletteCommand
	ld a, $01
	ld [$ffba], a
	call Delay3
	call GBPalNormal
	ret

; e9a73
String_e9a73:
	db $10, "Diploma", $10, "@"

String_e9a7d:
	db "Player@"

String_e9a84:
	db   "Congrats! This"
	next "diploma certifies"
	next "that you have"
	next "completed your"
	next "#DEX.@"

String_e9ac8:
	db "GAME FREAK@"

Func_e9ad3:
	call ClearScreen
	coord hl, 0, 17
	call Func_e9bdf
	coord hl, 0, 0
	call Func_e9beb
	coord hl, 19, 0
	call Func_e9beb
	ld a, $00
	coord hl, 0, 17
	ld [hl], a
	coord hl, 19, 17
	ld [hl], a
	ld de, Tilemap_e9b3e
	coord hl, 6, 2
	lb bc, 10, 12
	call $525d ; Func_e925d
	ld de, Tilemap_e9bb6
	coord hl, 5, 13
	lb bc, 1, 11
	call $525d ; Func_e925d
	ld de, String_e9bd5
	coord hl, 2, 15
	call PlaceString
	coord hl, 12, 15
	ld de, wPlayTimeHours + 1
	lb bc, $40 | 1, 3
	call PrintNumber
	ld [hl], $16
	inc hl
	ld de, wPlayTimeMinutes + 1
	lb bc, $80 | 1, 2
	call PrintNumber
	ld a, [wNumSetBits]
	cp 151
	ret nz
	ld de, TileMap_e9bc1
	coord hl, 2, 0
	lb bc, 4, 5
	call $525d ; Func_e925d
	ret

Tilemap_e9b3e: INCBIN "gfx/unknown_e9b3e.tilemap"
Tilemap_e9bb6: INCBIN "gfx/unknown_e9bb6.tilemap"
TileMap_e9bc1: INCBIN "gfx/unknown_e9bc1.tilemap"
String_e9bd5:  db "PLAY TIME@"

Func_e9bdf:
	ld c, 10
.asm_e9be1
	ld [hl], $02
	inc hl
	ld [hl], $01
	inc hl
	dec c
	jr nz, .asm_e9be1
	ret

Func_e9beb:
	ld c, 9
	ld de, SCREEN_WIDTH
.asm_e9bed
	ld [hl], $04
	add hl, de
	ld [hl], $03
	add hl, de
	dec c
	jr nz, .asm_e9bed
	ret
