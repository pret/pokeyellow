; prints text for bookshelves in buildings without sign events
PrintBookshelfText: ; f9de (3:79de)
	ld a, [wSpriteStateData1 + 9] ; player's sprite facing direction
	cp SPRITE_FACING_UP
	jr nz, .noMatch
; facing up
	ld a, [wCurMapTileset]
	ld b, a
	aCoord 8, 7
	ld c, a
	ld hl, BookshelfTileIDs
.loop
	ld a, [hli]
	cp $ff
	jr z, .noMatch
	cp b
	jr nz, .nextBookshelfEntry1
	ld a, [hli]
	cp c
	jr nz, .nextBookshelfEntry2
	ld a, [hl]
	push af
	call EnableAutoTextBoxDrawing
	pop af
	call PrintPredefTextID
	xor a
	ld [$ffdb], a
	ret
.nextBookshelfEntry1
	inc hl
.nextBookshelfEntry2
	inc hl
	jr .loop
.noMatch
	ld a, $ff
	ld [$ffdb], a
	jpba PrintCardKeyText

; format: db tileset id, bookshelf tile id, text id
BookshelfTileIDs: ; fa19 (3:7a19)
	db PLATEAU,      $30
	db_tx_pre IndigoPlateauStatues
	db HOUSE,        $3D
	db_tx_pre TownMapText
	db HOUSE,        $1E
	db_tx_pre BookOrSculptureText
	db MANSION,      $32
	db_tx_pre BookOrSculptureText
	db REDS_HOUSE_1, $32
	db_tx_pre BookOrSculptureText
	db LAB,          $28
	db_tx_pre BookOrSculptureText
	db LOBBY,        $16
	db_tx_pre ElevatorText
	db GYM,          $1D
	db_tx_pre BookOrSculptureText
	db DOJO,         $1D
	db_tx_pre BookOrSculptureText
	db GATE,         $22
	db_tx_pre BookOrSculptureText
	db MART,         $54
	db_tx_pre PokemonStuffText
	db MART,         $55
	db_tx_pre PokemonStuffText
	db POKECENTER,   $54
	db_tx_pre PokemonStuffText
	db POKECENTER,   $55
	db_tx_pre PokemonStuffText
	db LOBBY,        $50
	db_tx_pre PokemonStuffText
	db LOBBY,        $52
	db_tx_pre PokemonStuffText
	db SHIP,         $36
	db_tx_pre BookOrSculptureText
	db $FF

IndigoPlateauStatues: ; fa4d (3:7a4d)
	TX_ASM
	ld hl, IndigoPlateauStatuesText1
	call PrintText
	ld a, [wXCoord]
	bit 0, a
	ld hl, IndigoPlateauStatuesText2
	jr nz, .asm_fa61
	ld hl, IndigoPlateauStatuesText3
.asm_fa61
	call PrintText
	jp TextScriptEnd

IndigoPlateauStatuesText1: ; fa67 (3:7a67)
	TX_FAR _IndigoPlateauStatuesText1
	db "@"

IndigoPlateauStatuesText2: ; fa6c (3:7a6c)
	TX_FAR _IndigoPlateauStatuesText2
	db "@"

IndigoPlateauStatuesText3: ; fa71 (3:7a71)
	TX_FAR _IndigoPlateauStatuesText3
	db "@"

BookOrSculptureText: ; fa76 (3:7a76)
	TX_ASM
	ld hl, PokemonBooksText
	ld a, [wCurMapTileset]
	cp MANSION ; Celadon Mansion tileset
	jr nz, .asm_fa8b
	aCoord 8, 6
	cp $38
	jr nz, .asm_fa8b
	ld hl, DiglettSculptureText
.asm_fa8b
	call PrintText
	jp TextScriptEnd

PokemonBooksText: ; fa91 (3:7a91)
	TX_FAR _PokemonBooksText
	db "@"

DiglettSculptureText: ; fa96 (3:7a96)
	TX_FAR _DiglettSculptureText
	db "@"

ElevatorText: ; fa9b (3:7a9b)
	TX_FAR _ElevatorText
	db "@"

TownMapText: ; faa0 (3:7aa0)
	TX_FAR _TownMapText
	db $06
	TX_ASM
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, wd730
	set 6, [hl]
	call GBPalWhiteOutWithDelay3
	xor a
	ld [hWY], a
	inc a
	ld [H_AUTOBGTRANSFERENABLED], a
	call LoadFontTilePatterns
	callba DisplayTownMap
	ld hl, wd730
	res 6, [hl]
	ld de, TextScriptEnd
	push de
	ld a, [H_LOADEDROMBANK]
	push af
	jp CloseTextDisplay

PokemonStuffText: ; fad3 (3:7ad3)
	TX_FAR _PokemonStuffText
	db "@"
