DisplayTownMap: ; 70eb7 (1c:4eb7)
	;call LoadTownMap
	ld hl, wUpdateSpritesEnabled
	ld a, [hl]
	push af
	ld [hl], $ff
	push hl
	ld a, $1
	ld [hJoy7], a
	ld a, [W_CURMAP] ; W_CURMAP
	push af
	ld b, $0
	call Func_7124e
	hlCoord 1, 0
	ld de, wcd6d
	call PlaceString
	ld hl, wOAMBuffer
	ld de, wTileMapBackup
	ld bc, $10
	call CopyData
	ld hl, vSprites + $40
	ld de, TownMapCursor ; $4f40
	ld bc, (BANK(TownMapCursor) << 8) + $04
	call CopyVideoDataDouble
	xor a
	ld [wWhichTrade], a ; wWhichTrade
	pop af
	jr Func_70f08

Func_70ef4: ; 70ef4 (1c:4ef4)
	ld hl, wTileMap
	ld bc, $114
	call ClearScreenArea
	ld hl, TownMapOrder ; $4f11
	ld a, [wWhichTrade] ; wWhichTrade
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]

Func_70e92: ; 70f08 (1c:4f08)
	ld de, wHPBarMaxHP
	call Func_712f1
	ld a, [de]
	push hl
	call Func_712e1
	ld a, $4
	ld [wcd5b], a
	ld hl, wOAMBuffer + $10
	call Func_71279
	pop hl
	ld de, wcd6d
.loop
	ld a, [hli]
	ld [de], a
	inc de
	cp "@"
	jr nz, .loop
	hlCoord 1, 0
	ld de, wcd6d
	call PlaceString
	ld hl, wOAMBuffer + $10
	ld de, wTileMapBackup + 16
	ld bc, $10
	call CopyData
.asm_70f3e
	call TownMapSpriteBlinkingAnimation
	call JoypadLowSensitivity
	ld a, [hJoy5]
	ld b, a
	and D_DOWN | D_UP | B_BUTTON | A_BUTTON
	jr z, .asm_70f3e
	ld a, (SFX_02_3c - SFX_Headers_02) / 3
	call PlaySound
	bit 6, b
	jr nz, .asm_70f68
	bit 7, b
	jr nz, .asm_70f77
	xor a
	ld [wTownMapSpriteBlinkingEnabled], a
	ld [hJoy7], a
	ld [wTownMapSpriteBlinkingCounter], a
	call Func_71235
	pop hl
	pop af
	ld [hl], a
	ret
.asm_70f68
	ld a, [wWhichTrade] ; wWhichTrade
	inc a
	cp $2f
	jr nz, .asm_70f71
	xor a
.asm_70f71
	ld [wWhichTrade], a ; wWhichTrade
	jp Func_70ef4
.asm_70f77
	ld a, [wWhichTrade] ; wWhichTrade
	dec a
	cp $ff
	jr nz, .asm_70f81
	ld a, $2e
.asm_70f81
	ld [wWhichTrade], a ; wWhichTrade
	jp Func_70ef4
.asm_70f87
	ld a,[hJoy5]
	and D_DOWN | D_UP | B_BUTTON | A_BUTTON
	ret z
	callab Func_f4000
	ret
	
INCLUDE "data/town_map_order.asm"

TownMapCursor: ; 70fc4 (1c:4fc4)
	INCBIN "gfx/town_map_cursor.1bpp"

LoadTownMap_Nest: ; 70fe4 (1c:4fe4)
	call LoadTownMap
	ld hl, wUpdateSpritesEnabled
	ld a, [hl]
	push af
	ld [hl], $ff
	push hl
	call Func_71279
	call GetMonName
	hlCoord 1, 0
	call PlaceString
	ld h, b
	ld l, c
	ld de, MonsNestText
	call PlaceString
	call WaitForTextScrollButtonPress
	call Func_71235
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
	ld de, TownMapUpArrow ; $5093
	ld hl, vChars1 + $6d0
	ld bc, (BANK(TownMapUpArrow) << 8) + $01
	call CopyVideoDataDouble
	call Func_710fb
	ld hl, wUpdateSpritesEnabled
	ld a, [hl]
	push af
	ld [hl], $ff
	push hl
	ld hl, wTileMap
	ld de, ToText
	call PlaceString
	ld a, [W_CURMAP] ; W_CURMAP
	ld b, $0
	call Func_7124e
	ld hl, wTrainerEngageDistance
	deCoord 18, 0

.townMapFlyLoop
	ld a, $7f
	ld [de], a
	push hl
	push hl
	hlCoord 3, 0
	ld bc, $10f
	call ClearScreenArea
	pop hl
	ld a, [hl]
	ld b, $4
	call Func_7124e
	hlCoord 3, 0
	ld de, wcd6d
	call PlaceString
	ld c, $f
	call DelayFrames
	hlCoord 18, 0
	ld [hl], "▶"
	hlCoord 19, 0
	ld [hl], $ee
	pop hl
.asm_7108d
	push hl
	call DelayFrame
	call JoypadLowSensitivity
	ld a, [hJoy5]
	ld b, a
	pop hl
	and D_DOWN | D_UP | B_BUTTON | A_BUTTON
	jr z, .asm_7108b
	bit 0, b
	jr nz, .asm_710af
	ld a, (SFX_02_3c - SFX_Headers_02) / 3
	call PlaySound
	bit 6, b
	jr nz, .asm_710cd
	bit 7, b
	jr nz, .asm_710e3
	jr .asm_710c0
.asm_710af
	ld a, (SFX_02_3e - SFX_Headers_02) / 3
	call PlaySound
	ld a, [hl]
	ld [wDestinationMap], a
	ld hl, wd732
	set 3, [hl]
	inc hl
	set 7, [hl]
.asm_710c0
	xor a
	ld [wTownMapSpriteBlinkingEnabled], a
	ld [hJoy7], a
	call GBPalWhiteOutWithDelay3
	pop hl
	pop af
	ld [hl], a
	ret
.asm_710cd
	deCoord 18, 0
	inc hl
	ld a, [hl]
	cp $ff
	jr z, .asm_710dd
	cp $fe
	jr z, .asm_710cd
	jp .townMapFlyLoop
.asm_710dd
	ld hl, wTrainerEngageDistance
	jp .townMapFlyLoop
.asm_710e3
	deCoord 19, 0
	dec hl
	ld a, [hl]
	cp $ff
	jr z, .asm_710f3
	cp $fe
	jr z, .asm_710e3
	jp .townMapFlyLoop
.asm_710f3
	ld hl, wcd49
	jr .asm_710e3

ToText: ; 710f8 (1c:50f8)
	db "To@"

Func_710fb: ; 710fb (1c:50fb)
	ld hl, wWhichTrade ; wWhichTrade
	ld [hl], $ff
	inc hl
	ld a, [W_TOWNVISITEDFLAG]
	ld e, a
	ld a, [W_TOWNVISITEDFLAG + 1]
	ld d, a
	ld bc, $b
.asm_7110c
	srl d
	rr e
	ld a, $fe
	jr nc, .asm_71115
	ld a, b
.asm_71115
	ld [hl], a
	inc hl
	inc b
	dec c
	jr nz, .asm_7110c
	ld [hl], $ff
	ret

TownMapUpArrow: ; 7111e (1c:511e)
	INCBIN "gfx/up_arrow.1bpp"

LoadTownMap: ; 71126 (1c:5126)
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	call UpdateSprites
	ld hl, wTileMap
	ld bc, $1212
	call TextBoxBorder
	call DisableLCD
	ld hl, WorldMapTileGraphics ; $65a8
	ld de, vChars2 + $600
	ld bc, $100
	ld a, BANK(WorldMapTileGraphics)
	call FarCopyData2
	ld hl, MonNestIcon ; $574b
	ld de, vSprites + $40
	ld bc, $8
	ld a, BANK(MonNestIcon)
	call FarCopyDataDouble
	ld hl, wTileMap
	ld de, CompressedMap ; $5100
.asm_710d3
	ld a, [de]
	and a
	jr z, .asm_71173
	ld b, a
	and $f
	ld c, a
	ld a, b
	swap a
	and $f
	add $60
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	inc de
	jr .asm_7115d
.asm_71073
	call EnableLCD
	ld b, $2
	call GoPAL_SET
	call Delay3
	call GBPalNormal
	xor a
	ld [wTownMapSpriteBlinkingCounter], a
	inc a
	ld [wTownMapSpriteBlinkingEnabled], a
	ret

CompressedMap: ; 7118a (1c:518a)
; you can decompress this file with the redrle program in the extras/ dir
	INCBIN "gfx/town_map.rle"

Func_71235: ; 71235 (1c:5235)
	xor a
	ld [wTownMapSpriteBlinkingEnabled], a
	call GBPalWhiteOut
	call ClearScreen
	call ClearSprites
	call LoadPlayerSpriteGraphics
	call LoadFontTilePatterns
	call UpdateSprites
	jp GoPAL_SET_CF1C

Func_711c4: ; 7124e (1c:524e)
	push af
	ld a, b
	ld [wcd5b], a
	pop af
	ld de, wHPBarMaxHP
	call Func_712f1
	ld a, [de]
	push hl
	call Func_712e1
	call Func_712f6
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

Func_71279: ; 711ef (1c:51ef)
	callba FindWildLocationsOfMon
	call Func_71362
	ld hl, wOAMBuffer
	ld de, wBuffer
.asm_7128a
	ld a, [de]
	cp $ff
	jr z, .asm_712a7
	and a
	jr z, .asm_712a4
	push hl
	call Func_7137a
	pop hl
	ld a, [de]
	cp $19
	jr z, .asm_712a4
	call Func_712e1
	ld a, $4
	ld [hli], a
	xor a
	ld [hli], a
.asm_712a4
	inc de
	jr .asm_7128a
.asm_712a7
	ld a, l
	and a
	; continue from here
	jr nz, .asm_712bf
	hlCoord 1, 7
	ld bc, $20f
	call TextBoxBorder
	hlCoord 2, 9
	ld de, AreaUnknownText
	call PlaceString
	jr .asm_712c7
.asm_71236
	ld a, [W_CURMAP] ; W_CURMAP
	ld b, $0
	call Func_7124e
.asm_712c7
	ld hl, wOAMBuffer
	ld de, wTileMapBackup
	ld bc, $a0
	jp CopyData

AreaUnknownText: ; 712d3 (1c:52d3)
	db " AREA UNKNOWN@"

Func_712e1: ; 712e1 (1c:52e1)
	push af
	and $f0
	srl a
	add $18
	ld b, a
	ld [hli], a
	pop af
	and $f
	swap a
	srl a
	add $18
	ld c, a
	ld [hli], a
	ret

Func_712f6: ; 712f6 (1c:52f6)
	ld a, [wcd5b]
	and a
	ld hl, wOAMBuffer + $90
	jr z, Func_71302
	ld hl, wOAMBuffer + $80

Func_71302: ; 71302 (1c:5302)
	push hl
	ld hl, $fcfc
	add hl, bc
	ld b, h
	ld c, l
	pop hl

WriteAsymmetricMonPartySpriteOAM: ; 7130a (1c:530a)
; Writes 4 OAM blocks for a helix mon party sprite, since is does not have
; a vertical line of symmetry.
	ld de, $202
.loop
	push de
	push bc
.innerLoop
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, [wcd5b]
	ld [hli], a
	inc a
	ld [wcd5b], a
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
	ld [wcd5c], a
	ld de, $202
.loop
	push de
	push bc
.innerLoop
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, [wcd5b]
	ld [hli], a
	ld a, [wcd5c]
	ld [hli], a
	xor $20
	ld [wcd5c], a
	inc d
	ld a, $8
	add c
	ld c, a
	dec e
	jr nz, .innerLoop
	pop bc
	pop de
	push hl
	ld hl, wcd5b
	inc [hl]
	inc [hl]
	pop hl
	ld a, $8
	add b
	ld b, a
	dec d
	jr nz, .loop
	ret

Func_71362: ; 71362 (1c:5362)
	ld de, wHPBarMaxHP
.asm_71365
	ld a, [de]
	inc de
	cp $ff
	ret z
	ld c, a
	ld l, e
	ld h, d
.asm_7136d
	ld a, [hl]
	cp $ff
	jr z, .asm_71365
	cp c
	jr nz, .asm_71377
	xor a
	ld [hl], a
.asm_71277
	inc hl
	jr .asm_7126d

Func_7137a: ; 7137a (1c:537a)
	cp REDS_HOUSE_1F
	jr c, .asm_7138d
	ld bc, $4
	ld hl, InternalMapEntries ; $5382
.asm_71384
	cp [hl]
	jr c, .asm_7138a
	add hl, bc
	jr .asm_71284
.asm_7138a
	inc hl
	jr .asm_71384
.asm_7138d
	ld hl, ExternalMapEntries ; $5313
	ld c, a
	ld b, $0
	add hl, bc
	add hl, bc
	add hl, bc
.asm_7130d
	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

INCBIN "baserom.gbc",$7139c,$71753 - $7139c

;INCLUDE "data/town_map_entries.asm"

;INCLUDE "text/map_names.asm" ; TODO: relabel addresses

;MonNestIcon: ; 716be (1c:56be) ; relabel this too
;	INCBIN "gfx/mon_nest_icon.1bpp"

TownMapSpriteBlinkingAnimation: ; 71753 (1c:5753)
	ld a, [wTownMapSpriteBlinkingCounter]
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
	ld [wTownMapSpriteBlinkingCounter], a
	jp DelayFrame
