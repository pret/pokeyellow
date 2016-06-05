DisplayTownMap: ; 70eb7 (1c:4eb7)
	call LoadTownMap
	ld hl, wUpdateSpritesEnabled
	ld a, [hl]
	push af
	ld [hl], $ff
	push hl
	ld a, $1
	ld [hJoy7], a
	ld a, [wCurMap]
	push af
	ld b, $0
	call DrawPlayerOrBirdSprite ; player sprite
	coord hl, 1, 0
	ld de, wcd6d
	call PlaceString
	ld hl, wOAMBuffer
	ld de, wTileMapBackup
	ld bc, $10
	call CopyData
	ld hl, vSprites + $40
	ld de, TownMapCursor
	lb bc, BANK(TownMapCursor), (TownMapCursorEnd - TownMapCursor) / $8
	call CopyVideoDataDouble
	xor a
	ld [wWhichTownMapLocation], a
	pop af
	jr .enterLoop

.townMapLoop ; 70ef4 (1c:4ef4)
	coord hl, 0, 0
	lb bc, 1, 20
	call ClearScreenArea
	ld hl, TownMapOrder
	ld a, [wWhichTownMapLocation]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
.enterLoop ; 70f08 (1c:4f08)
	ld de, wTownMapCoords
	call LoadTownMapEntry
	ld a, [de]
	push hl
	call TownMapCoordsToOAMCoords
	ld a, $4
	ld [wOAMBaseTile], a
	ld hl, wOAMBuffer + $10
	call WriteTownMapSpriteOAM ; town map cursor sprite
	pop hl
	ld de, wcd6d
.copyMapName
	ld a, [hli]
	ld [de], a
	inc de
	cp $50
	jr nz, .copyMapName
	coord hl, 1, 0
	ld de, wcd6d
	call PlaceString
	ld hl, wOAMBuffer + $10
	ld de, wTileMapBackup + 16
	ld bc, $10
	call CopyData
.inputLoop
	call TownMapSpriteBlinkingAnimation
	call JoypadLowSensitivity
	ld a, [hJoy5]
	ld b, a
	and A_BUTTON | B_BUTTON | D_UP | D_DOWN
	jr z, .inputLoop
	ld a, $8c
	call PlaySound
	bit 6, b
	jr nz, .pressedUp
	bit 7, b
	jr nz, .pressedDown
	xor a
	ld [wTownMapSpriteBlinkingEnabled], a
	ld [hJoy7], a
	ld [wAnimCounter], a
	call ExitTownMap
	pop hl
	pop af
	ld [hl], a
	ret

.pressedUp
	ld a, [wWhichTownMapLocation]
	inc a
	cp TownMapOrderEnd - TownMapOrder ; number of list items + 1
	jr nz, .noOverflow
	xor a
.noOverflow
	ld [wWhichTownMapLocation], a
	jp .townMapLoop
.pressedDown
	ld a, [wWhichTownMapLocation]
	dec a
	cp -1
	jr nz, .noUnderflow
	ld a, TownMapOrderEnd - TownMapOrder - 1 ; number of list items
.noUnderflow
	ld [wWhichTownMapLocation], a
	jp .townMapLoop

.asm_70f87
	ld a,[hJoy5]
	and D_DOWN | D_UP
	ret z
	callab PlayPikachuSoundClip
	ret

INCLUDE "data/town_map_order.asm"

TownMapCursor: ; 70fc4 (1c:4fc4)
	INCBIN "gfx/town_map_cursor.1bpp"
TownMapCursorEnd:

LoadTownMap_Nest: ; 70fe4 (1c:4fe4)
	call LoadTownMap
	ld hl, wUpdateSpritesEnabled
	ld a, [hl]
	push af
	ld [hl], $ff
	push hl
	call DisplayWildLocations
	call GetMonName
	coord hl, 1, 0
	call PlaceString
	ld h, b
	ld l, c
	ld de, MonsNestText
	call PlaceString
	call WaitForTextScrollButtonPress
	call ExitTownMap
	pop hl
	pop af
	ld [hl], a
	ret

MonsNestText: ; 7100d (1c:500d)
	db "'s NEST@"

LoadTownMap_Fly: ; 71014 (1c:5014)
	call ClearSprites
	call LoadTownMap
	ld a, $1
	ld [hJoy7], a
	call LoadPlayerSpriteGraphics
	call LoadFontTilePatterns
	ld de, BirdSprite ; $4d80
	ld b, BANK(BirdSprite)
	ld c, $c
	ld hl, vSprites + $40
	call CopyVideoData
	ld de, TownMapUpArrow
	ld hl, vChars1 + $6d0
	lb bc, BANK(TownMapUpArrow), (TownMapUpArrowEnd - TownMapUpArrow) / $8
	call CopyVideoDataDouble
	call BuildFlyLocationsList
	ld hl, wUpdateSpritesEnabled
	ld a, [hl]
	push af
	ld [hl], $ff
	push hl
	coord hl, 0, 0
	ld de, ToText
	call PlaceString
	ld a, [wCurMap]
	ld b, $0
	call DrawPlayerOrBirdSprite
	ld hl, wFlyLocationsList
	coord de, 18, 0
.townMapFlyLoop
	ld a, " "
	ld [de], a
	push hl
	push hl
	coord hl, 3, 0
	lb bc, 1, 15
	call ClearScreenArea
	pop hl
	ld a, [hl]
	ld b, $4
	call DrawPlayerOrBirdSprite ; draw bird sprite
	coord hl, 3, 0
	ld de, wcd6d
	call PlaceString
	ld c, 15
	call DelayFrames
	coord hl, 18, 0
	ld [hl], "▶"
	coord hl, 19, 0
	ld [hl], $ee
	pop hl
.inputLoop
	push hl
	call DelayFrame
	call JoypadLowSensitivity
	ld a, [hJoy5]
	ld b, a
	pop hl
	and A_BUTTON | B_BUTTON | D_UP | D_DOWN
	jr z, .inputLoop
	bit 0, b
	jr nz, .pressedA
	ld a, $8c ; SFX_TINK
	call PlaySound
	bit 6, b
	jr nz, .pressedUp
	bit 7, b
	jr nz, .pressedDown
	jr .pressedB
.pressedA
	ld a, $8e ; SFX_HEAL_AILMENT
	call PlaySound
	ld a, [hl]
	ld [wDestinationMap], a
	ld hl, wd732
	set 3, [hl]
	inc hl
	set 7, [hl]
.pressedB
	xor a
	ld [wTownMapSpriteBlinkingEnabled], a
	ld [hJoy7], a
	call GBPalWhiteOutWithDelay3
	pop hl
	pop af
	ld [hl], a
	ret
.pressedUp
	coord de, 18, 0
	inc hl
	ld a, [hl]
	cp $ff
	jr z, .wrapToStartOfList
	cp $fe
	jr z, .pressedUp ; skip past unvisited towns
	jp .townMapFlyLoop
.wrapToStartOfList
	ld hl, wFlyLocationsList
	jp .townMapFlyLoop
.pressedDown
	coord de, 19, 0
	dec hl
	ld a, [hl]
	cp $ff
	jr z, .wrapToEndOfList
	cp $fe
	jr z, .pressedDown ; skip past unvisited towns
	jp .townMapFlyLoop
.wrapToEndOfList
	ld hl, wFlyLocationsList + 11
	jr .pressedDown

ToText: ; 710f8 (1c:50f8)
	db "To@"

BuildFlyLocationsList: ; 710fb (1c:50fb)
	ld hl, wFlyLocationsList - 1
	ld [hl], $ff
	inc hl
	ld a, [wTownVisitedFlag]
	ld e, a
	ld a, [wTownVisitedFlag + 1]
	ld d, a
	ld bc, SAFFRON_CITY + 1
.loop
	srl d
	rr e
	ld a, $fe ; store $fe if the town hasn't been visited
	jr nc, .notVisited
	ld a, b ; store the map number of the town if it has been visited
.notVisited
	ld [hl], a
	inc hl
	inc b
	dec c
	jr nz, .loop
	ld [hl], $ff
	ret

TownMapUpArrow: ; 7111e (1c:511e)
	INCBIN "gfx/up_arrow.1bpp"
TownMapUpArrowEnd:

LoadTownMap: ; 71126 (1c:5126)
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	call UpdateSprites
	coord hl, 0, 0
	lb bc, $12, $12
	call TextBoxBorder
	call DisableLCD
	ld hl, WorldMapTileGraphics
	ld de, vChars2 + $600
	ld bc, WorldMapTileGraphicsEnd - WorldMapTileGraphics
	ld a, BANK(WorldMapTileGraphics)
	call FarCopyData
	ld hl, MonNestIcon ; $574b
	ld de, vSprites + $40
	ld bc, MonNestIconEnd - MonNestIcon
	ld a, BANK(MonNestIcon)
	call FarCopyDataDouble
	coord hl, 0, 0
	ld de, CompressedMap
.nextTile
	ld a, [de]
	and a
	jr z, .done
	ld b, a
	and $f
	ld c, a
	ld a, b
	swap a
	and $f
	add $60
.writeRunLoop
	ld [hli], a
	dec c
	jr nz, .writeRunLoop
	inc de
	jr .nextTile
.done
	call EnableLCD
	ld b, SET_PAL_TOWN_MAP
	call RunPaletteCommand
	call Delay3
	call GBPalNormal
	xor a
	ld [wAnimCounter], a
	inc a
	ld [wTownMapSpriteBlinkingEnabled], a
	ret

CompressedMap: ; 7118a (1c:518a)
; you can decompress this file with the redrle program in the extras/ dir
	INCBIN "gfx/town_map.rle"

ExitTownMap: ; 71235 (1c:5235)
; clear town map graphics data and load usual graphics data
	xor a
	ld [wTownMapSpriteBlinkingEnabled], a
	call GBPalWhiteOut
	call ClearScreen
	call ClearSprites
	call LoadPlayerSpriteGraphics
	call LoadFontTilePatterns
	call UpdateSprites
	jp RunDefaultPaletteCommand

DrawPlayerOrBirdSprite: ; 7124e (1c:524e)
; a = map number
; b = OAM base tile
	push af
	ld a, b
	ld [wOAMBaseTile], a
	pop af
	ld de, wTownMapCoords
	call LoadTownMapEntry
	ld a, [de]
	push hl
	call TownMapCoordsToOAMCoords
	call WritePlayerOrBirdSpriteOAM
	pop hl
	ld de, wcd6d
.asm_71266
	ld a, [hli]
	ld [de], a
	inc de
	cp "@"
	jr nz, .asm_71266
	ld hl, wOAMBuffer
	ld de, wTileMapBackup
	ld bc, $a0
	jp CopyData

DisplayWildLocations: ; 71279 (1c:5279)
	callba FindWildLocationsOfMon
	call ZeroOutDuplicatesInList
	ld hl, wOAMBuffer
	ld de, wTownMapCoords
.loop
	ld a, [de]
	cp $ff
	jr z, .exitLoop
	and a
	jr z, .nextEntry
	push hl
	call LoadTownMapEntry
	pop hl
	ld a, [de]
	cp $19 ; Cerulean Cave's coordinates
	jr z, .nextEntry ; skip Cerulean Cave
	call TownMapCoordsToOAMCoords
	ld a, $4 ; nest icon tile no.
	ld [hli], a
	xor a
	ld [hli], a
.nextEntry
	inc de
	jr .loop
.exitLoop
	ld a, l
	and a ; were any OAM entries written?
	jr nz, .drawPlayerSprite
; if no OAM entries were written, print area unknown text
	coord hl, 1, 7
	lb bc, 2, 15
	call TextBoxBorder
	coord hl, 2, 9
	ld de, AreaUnknownText
	call PlaceString
	jr .done
.drawPlayerSprite
	ld a, [wCurMap]
	ld b, $0
	call DrawPlayerOrBirdSprite
.done
	ld hl, wOAMBuffer
	ld de, wTileMapBackup
	ld bc, $a0
	jp CopyData

AreaUnknownText: ; 712d3 (1c:52d3)
	db " AREA UNKNOWN@"

TownMapCoordsToOAMCoords: ; 712e1 (1c:52e1)
; in: lower nybble of a = x, upper nybble of a = y
; out: b and [hl] = (y * 8) + 24, c and [hl+1] = (x * 8) + 24
	push af
	and $f0
	srl a
	add 24
	ld b, a
	ld [hli], a
	pop af
	and $f
	swap a
	srl a
	add 24
	ld c, a
	ld [hli], a
	ret

WritePlayerOrBirdSpriteOAM: ; 712f6 (1c:52f6)
	ld a, [wOAMBaseTile]
	and a
	ld hl, wOAMBuffer + $90 ; for player sprite
	jr z, WriteTownMapSpriteOAM
	ld hl, wOAMBuffer + $80 ; for bird sprite

WriteTownMapSpriteOAM: ; 71302 (1c:5302)
	push hl
	lb hl, -4, -4
	add hl, bc ; subtract 4 from c (X coord) and 4 from b (Y coord)
	ld b, h
	ld c, l
	pop hl

WriteAsymmetricMonPartySpriteOAM: ; 7130a (1c:530a)
; Writes 4 OAM blocks for a helix mon party sprite, since is does not have
; a vertical line of symmetry.
	lb de, 2, 2
.loop
	push de
	push bc
.innerLoop
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, [wOAMBaseTile]
	ld [hli], a
	inc a
	ld [wOAMBaseTile], a
	xor a
	ld [hli], a
	inc d
	ld a, $8
	add c
	ld c, a
	dec e
	jr nz, .innerLoop
	pop bc
	pop de
	ld a, $8
	add b
	ld b, a
	dec d
	jr nz, .loop
	ret

WriteSymmetricMonPartySpriteOAM: ; 7132f (1c:532f)
; Writes 4 OAM blocks for a mon party sprite other than a helix. All the
; sprites other than the helix one have a vertical line of symmetry which allows
; the X-flip OAM bit to be used so that only 2 rather than 4 tile patterns are
; needed.
	xor a
	ld [wSymmetricSpriteOAMAttributes], a
	lb de, 2, 2
.loop
	push de
	push bc
.innerLoop
	ld a, b
	ld [hli], a ; Y
	ld a, c
	ld [hli], a ; X
	ld a, [wOAMBaseTile]
	ld [hli], a ; tile
	ld a, [wSymmetricSpriteOAMAttributes]
	ld [hli], a ; attributes
	xor (1 << OAM_X_FLIP)
	ld [wSymmetricSpriteOAMAttributes], a
	inc d
	ld a, 8
	add c
	ld c, a
	dec e
	jr nz, .innerLoop
	pop bc
	pop de
	push hl
	ld hl, wOAMBaseTile
	inc [hl]
	inc [hl]
	pop hl
	ld a, 8
	add b
	ld b, a
	dec d
	jr nz, .loop
	ret

ZeroOutDuplicatesInList: ; 71362 (1c:5362)
; replace duplicate bytes in the list of wild pokemon locations with 0
	ld de, wBuffer
.loop
	ld a, [de]
	inc de
	cp $ff
	ret z
	ld c, a
	ld l, e
	ld h, d
.zeroDuplicatesLoop
	ld a, [hl]
	cp $ff
	jr z, .loop
	cp c
	jr nz, .skipZeroing
	xor a
	ld [hl], a
.skipZeroing
	inc hl
	jr .zeroDuplicatesLoop

LoadTownMapEntry: ; 7137a (1c:537a)
; in: a = map number
; out: lower nybble of [de] = x, upper nybble of [de] = y, hl = address of name
	cp REDS_HOUSE_1F
	jr c, .external
	ld bc, 4
	ld hl, InternalMapEntries
.loop
	cp [hl]
	jr c, .foundEntry
	add hl, bc
	jr .loop
.foundEntry
	inc hl
	jr .readEntry
.external
	ld hl, ExternalMapEntries
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	add hl, bc
.readEntry
	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret
	
; ExternalMapEntries: ; 7139c (1c:539c)
	; dr $7139c,$7140b
; InternalMapEntries: ; 7140b (1c:540b)
	; dr $7140b,$7174b
	
INCLUDE "data/town_map_entries.asm"

INCLUDE "text/map_names.asm" ; TODO: relabel addresses

MonNestIcon: ; 7174b (1c:574b)
	INCBIN "gfx/mon_nest_icon.1bpp"
MonNestIconEnd:

TownMapSpriteBlinkingAnimation: ; 71753 (1c:5753)
	ld a, [wAnimCounter]
	inc a
	cp 25
	jr z, .hideSprites
	cp 50
	jr nz, .done
; show sprites when the counter reaches 50
	ld hl, wTileMapBackup
	ld de, wOAMBuffer
	ld bc, $90
	call CopyData
	xor a
	jr .done
.hideSprites
	ld hl, wOAMBuffer
	ld b, $24
	ld de, $4
.hideSpritesLoop
	ld [hl], $a0
	add hl, de
	dec b
	jr nz, .hideSpritesLoop
	ld a, 25
.done
	ld [wAnimCounter], a
	jp DelayFrame
