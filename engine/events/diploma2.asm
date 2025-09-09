DEF CIRCLE_TILE_ID EQU $10

DisplayDiplomaTop:
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	ld de, DiplomaGraphics
	ld hl, vChars2
	lb bc, BANK(DiplomaGraphics), (DiplomaGraphicsEnd - DiplomaGraphics) / $10
	call CopyVideoData

	hlcoord 0, 0
	call DiplomaDrawHorizontalBorder
	hlcoord 0, 0
	call DiplomaDrawVerticalBorder
	hlcoord 19, 0
	call DiplomaDrawVerticalBorder
	ld a, $00
	hlcoord 0, 0
	ld [hl], a
	hlcoord 19, 0
	ld [hl], a

	ld de, DiplomaText
	hlcoord 5, 2
	call PlaceString

	ld de, DiplomaPlayer
	hlcoord 3, 4
	call PlaceString

	ld de, wPlayerName
	hlcoord 10, 4
	call PlaceString

	ld de, DiplomaCongrats
	hlcoord 2, 6
	call PlaceString

	ld de, DiplomaGameFreak
	hlcoord 9, 16
	call PlaceString

	ld b, SET_PAL_GENERIC
	call RunPaletteCommand
	ld a, $01
	ldh [hAutoBGTransferEnabled], a
	call Delay3
	call GBPalNormal
	ret

DiplomaText:
	db CIRCLE_TILE_ID, "Diploma", CIRCLE_TILE_ID, "@"

DiplomaPlayer:
	db "Player@"

DiplomaCongrats:
	db   "Congrats! This"
	next "diploma certifies"
	next "that you have"
	next "completed your"
	next "#DEX.@"

DiplomaGameFreak:
	db "GAME FREAK@"

DisplayDiplomaBottom:
	call ClearScreen
	hlcoord 0, 17
	call DiplomaDrawHorizontalBorder
	hlcoord 0, 0
	call DiplomaDrawVerticalBorder
	hlcoord 19, 0
	call DiplomaDrawVerticalBorder
	ld a, $00
	hlcoord 0, 17
	ld [hl], a
	hlcoord 19, 17
	ld [hl], a

	ld de, DiplomaPikachuTiles
	hlcoord 6, 2
	lb bc, 10, 12
	call Diploma_Surfing_CopyBox

	ld de, CongratulationsTiles
	hlcoord 5, 13
	lb bc, 1, 11
	call Diploma_Surfing_CopyBox

	ld de, DiplomaPlayTime
	hlcoord 2, 15
	call PlaceString
	hlcoord 12, 15
	ld de, wPlayTimeHours
	lb bc, LEFT_ALIGN | 1, 3
	call PrintNumber
	ld [hl], $16 ; colon
	inc hl
	ld de, wPlayTimeMinutes
	lb bc, LEADING_ZEROES | 1, 2
	call PrintNumber

	ld a, [wNumSetBits]
	cp NUM_POKEMON
	ret nz
	ld de, DiplomaMewTiles
	hlcoord 2, 0
	lb bc, 4, 5
	call Diploma_Surfing_CopyBox
	ret

DiplomaPikachuTiles:
INCBIN "gfx/diploma/diploma_pikachu.tilemap"

CongratulationsTiles:
	db $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f ; CONGRATULATIONS!

DiplomaMewTiles:
INCBIN "gfx/diploma/diploma_mew.tilemap"

DiplomaPlayTime:
	db "PLAY TIME@"

DiplomaDrawHorizontalBorder:
	ld c, SCREEN_WIDTH / 2
.loop
	ld [hl], $02
	inc hl
	ld [hl], $01
	inc hl
	dec c
	jr nz, .loop
	ret

DiplomaDrawVerticalBorder:
	ld c, SCREEN_HEIGHT / 2
	ld de, SCREEN_WIDTH
.loop
	ld [hl], $04
	add hl, de
	ld [hl], $03
	add hl, de
	dec c
	jr nz, .loop
	ret

DiplomaGraphics: INCBIN "gfx/diploma/diploma.2bpp"
DiplomaGraphicsEnd:
