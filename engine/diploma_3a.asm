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
	call Func_e925d
	ld de, Tilemap_e9bb6
	coord hl, 5, 13
	lb bc, 1, 11
	call Func_e925d
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
	call Func_e925d
	ret

Tilemap_e9b3e:
	db $7f, $7f, $7f, $1a, $1b, $7f, $7f, $7f, $7f, $7f
	db $7f, $7f, $7f, $7f, $7f, $1c, $1d, $1e, $1f, $20
	db $7f, $21, $22, $23, $7f, $24, $25, $26, $27, $28
	db $29, $2a, $2b, $2c, $2d, $2e, $2f, $30, $31, $32
	db $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c
	db $7f, $3d, $3e, $3f, $40, $41, $42, $43, $29, $44
	db $45, $46, $47, $48, $49, $4a, $4b, $29, $29, $4c
	db $4d, $4e, $4f, $50, $51, $52, $53, $54, $55, $56
	db $57, $58, $59, $7f, $7f, $7f, $5a, $5b, $5c, $5d
	db $5e, $5f, $60, $61, $62, $7f, $7f, $7f, $7f, $63
	db $64, $65, $66, $67, $68, $7f, $7f, $7f, $7f, $7f
	db $7f, $69, $6a, $6b, $6c, $6d, $6e, $7f, $7f, $7f

Tilemap_e9bb6:
	db $05
	db $06
	db $07
	db $08
	db $09
	db $0a
	db $0b
	db $0c
	db $0d
	db $0e
	db $0f

TileMap_e9bc1:
	db $70, $71, $7f, $72, $7f
	db $73, $74, $75, $76, $77
	db $7f, $78, $11, $12, $13
	db $7f, $7f, $14, $15, $7f

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
