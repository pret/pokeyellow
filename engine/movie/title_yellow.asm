LoadYellowTitleScreenGFX:
	ld hl, PokemonLogoGraphics
	ld de, vChars2
	ld bc, PokemonLogoGraphicsEnd - PokemonLogoGraphics
	ld a, BANK(PokemonLogoGraphics)
	call FarCopyData
	ld hl, PokemonLogoCornerGraphics
	ld de, vChars1 tile $7d
	ld bc, PokemonLogoCornerGraphicsEnd - PokemonLogoCornerGraphics
	ld a, BANK(PokemonLogoCornerGraphics)
	call FarCopyData
	ld hl, TitlePikachuBGGraphics
	ld de, vChars1
	ld bc, TitlePikachuBGGraphicsEnd - TitlePikachuBGGraphics
	ld a, BANK(TitlePikachuBGGraphics)
	call FarCopyData
	ld hl, TitlePikachuOBGraphics
	ld de, vChars1 tile $70
	ld bc, TitlePikachuOBGraphicsEnd - TitlePikachuOBGraphics
	ld a, BANK(TitlePikachuOBGraphics)
	call FarCopyData
	ret

TitleScreen_PlacePokemonLogo:
	hlcoord 2, 1
	ld de, TitleScreenPokemonLogoTilemap
	lb bc, 7, 16
	call Bank3D_CopyBox
	ret

TitleScreen_PlacePikaSpeechBubble:
	hlcoord 6, 4
	ld de, TitleScreenPikaBubbleTilemap
	lb bc, 4, 7
	call Bank3D_CopyBox
	hlcoord 9, 8
	ld [hl], $64
	inc hl
	ld [hl], $65
	ret

TitleScreen_PlacePikachu:
	hlcoord 4, 8
	ld de, TitleScreenPikachuTilemap
	lb bc, 9, 12
	call Bank3D_CopyBox
	hlcoord 16, 10
	ld [hl], $96
	hlcoord 16, 11
	ld [hl], $9d
	hlcoord 16, 12
	ld [hl], $a7
	hlcoord 16, 13
	ld [hl], $b1
	ld hl, TitleScreenPikachuEyesOAMData
	ld de, wShadowOAM
	ld bc, $20
	call CopyData
	ret

TitleScreenPikachuEyesOAMData:
	db $60, $40, $f1, $22
	db $60, $48, $f0, $22
	db $68, $40, $f3, $22
	db $68, $48, $f2, $22
	db $60, $60, $f0, $02
	db $60, $68, $f1, $02
	db $68, $60, $f2, $02
	db $68, $68, $f3, $02

Bank3D_CopyBox:
; copy cxb (xy) screen area from de to hl
.row
	push bc
	push hl
.col
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	ret

TitleScreenPokemonLogoTilemap: ; 16x7
	INCBIN "gfx/title/pokemon_logo.tilemap"

Pointer_f4669: ; unreferenced
	db $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f, $5f

TitleScreenPikaBubbleTilemap: ; 7x4
	INCBIN "gfx/title/pika_bubble.tilemap"

TitleScreenPikachuTilemap: ; 12x9
	INCBIN "gfx/title/pikachu.tilemap"

PokemonLogoGraphics: INCBIN "gfx/title/pokemon_logo.2bpp"
PokemonLogoGraphicsEnd:
PokemonLogoCornerGraphics: INCBIN "gfx/title/pokemon_logo_corner.2bpp"
PokemonLogoCornerGraphicsEnd:
TitlePikachuBGGraphics: INCBIN "gfx/title/pikachu_bg.2bpp"
TitlePikachuBGGraphicsEnd:
TitlePikachuOBGraphics: INCBIN "gfx/title/pikachu_ob.2bpp"
TitlePikachuOBGraphicsEnd:
