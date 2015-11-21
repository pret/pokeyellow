; Loads tile patterns for map's sprites.
; For outside maps, it loads one of several fixed sets of sprites.
; For inside maps, it loads each sprite picture ID used in the map header.
; This is also called after displaying text because loading
; text tile patterns overwrites half of the sprite tile pattern data.
; Note on notation:
; $C1X* and $C2X* are used to denote wSpriteStateData1-wSpriteStateData1 + $ff and wSpriteStateData2 + $00-wSpriteStateData2 + $ff sprite slot
; fields, respectively, within loops. The X is the loop index.
; If there is an inner loop, Y is the inner loop index, i.e. $C1Y* and $C2Y*
; denote fields of the sprite slots interated over in the inner loop.
_InitMapSprites: ; 1401b (5:401b)
	call InitOutsideMapSprites
	ret c ; return if the map is an outside map (already handled by above call)
; if the map is an inside map (i.e. mapID >= $25)
	call Func_14061
	call Func_140b7
	call Func_14150
	ret
	
; Loads sprite set for outside maps (cities and routes) and sets VRAM slots.
; sets carry if the map is a city or route, unsets carry if not
InitOutsideMapSprites: ; 14029 (5:4029)
	ld a,[wCurMap]
	cp a,REDS_HOUSE_1F ; is the map a city or a route (map ID less than $25)?
	ret nc ; if not, return
	call GetSplitMapSpriteSetID
; if so, choose the appropriate one
	ld b,a ; b = spriteSetID
	ld a,[wFontLoaded]
	bit 0,a ; reloading upper half of tile patterns after displaying text?
	jr nz,.loadSpriteSet ; if so, forcibly reload the sprite set
	ld a,[wSpriteSetID]
	cp b ; has the sprite set ID changed?
	jr z,.skipLoadingSpriteSet ; if not, don't load it again
.loadSpriteSet
	ld a,b
	ld [wSpriteSetID],a
	dec a
	ld c,a
	ld b,0
	ld a, (wSpriteSetID - wSpriteSet)
	ld hl,SpriteSets
	call AddNTimes ; get sprite set offset
	ld de, wSpriteSet
	ld bc, (wSpriteSetID - wSpriteSet)
	call CopyData ; copy it to wSpriteSet
	call Func_140b7
.skipLoadingSpriteSet
	call Func_14150
	scf
	ret
	
Func_14061: ; 14061 (5:4061)
; This loop stores the correct VRAM tile pattern slots according the sprite
; data from the map's header. Since the VRAM tile pattern slots are filled in
; the order of the sprite set, in order to find the VRAM tile pattern slot
; for a sprite slot, the picture ID for the sprite is looked up within the
; sprite set. The index of the picture ID within the sprite set plus one
; (since the Red sprite always has the first VRAM tile pattern slot) is the
; VRAM tile pattern slot.
	ld hl, wSpriteSet
	ld bc, (wSpriteSetID - wSpriteSet)
	xor a
	call FillMemory
	ld a, SPRITE_PIKACHU
	ld [wSpriteSet], a
	ld hl,wSpriteStateData1 + $10
	ld a,$0e
.storeVRAMSlotsLoop
	push af
	ld a, [hl] ; $C1X0 (picture ID) (zero if sprite slot is not used)
	and a ; is the sprite slot used?
	jr z,.continue ; if the sprite slot is not used
	ld c, a
	call CheckForNewYellowSprite
	jr nc, .asm_1408a
	ld de, wSpriteSet + 9
	ld b, 2
	call Func_1409b
	jr .continue
.asm_1408a
	ld de, wSpriteSet
	ld b, 9
	call Func_1409b
.continue
	ld de, $10
	add hl, de
	pop af
	dec a
	jr nz, .storeVRAMSlotsLoop
	ret

Func_1409b: ; 1409b (5:409b)
	ld a, [de]
	and a
	jr z, .asm_140a7
	cp c
	ret z
	dec b
	jr z, .asm_140aa
	inc de
	jr Func_1409b
.asm_140a7
	ld a, c
	ld [de], a
	ret
.asm_140aa
	scf
	ret

CheckForNewYellowSprite: ; 140ac (5:40ac)
; Checks for a sprite added in yellow
; Returns z flag if it is SPRITE_PIKACHU
; Else, returns carry if not a yellow sprite and vice versa
	cp SPRITE_PIKACHU ; is this the Pikachu Sprite?
	ret z ; return if yes
	cp SPRITE_BALL ; is this a yellow sprite?
	jr nc, .notYellowSprite
	and a
	ret
.notYellowSprite
	scf
	ret

Func_140b7: ; 140b7 (5:40b7)
	ld a, $0
.loop
	ld [hVRAMSlot], a
	cp 9
	jr nc, .fourTileSprite
	call LoadStillTilePattern
	call LoadWalkingTilePattern
	jr .continue
.fourTileSprite
	call LoadStillTilePattern
.continue
	ld a, [hVRAMSlot]
	inc a
	cp 11
	jr nz, .loop
	ret
	
Func_140d2: ; 140d2 (5:40d2)
	xor a
.loop
	ld [hVRAMSlot], a
	cp 9
	jr nc, .asm_140dc
	call LoadWalkingTilePattern
.asm_140dc
	ld a, [hVRAMSlot]
	inc a
	cp 11
	jr nz, .loop
	ret
	
LoadStillTilePattern: ; 140e4 (5:40e4)
	ld a, [wFontLoaded]
	bit 0, a ; reloading upper half of tile patterns after displaying text?
	ret nz ; if so, skip loading data into the lower half
	call ReadSpriteSheetData
	ret nc
	call GetSpriteVRAMAddress
	call CopyVideoDataAlternate ; new yellow function
	ret
	
LoadWalkingTilePattern: ; 140f5 (5:40f5)
	call ReadSpriteSheetData
	ret nc
	ld hl, $c0
	add hl, de
	ld d, h
	ld e, l
	call GetSpriteVRAMAddress
	set 3, h ; add $800 to hl
	call CopyVideoDataAlternate
	ret
	
GetSpriteVRAMAddress: ; 14018 (5:4108)
	push bc
	ld a, [hVRAMSlot]
	ld c, a
	ld b, 0
	ld hl, SpriteVRAMAddresses
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop bc
	ret
	
SpriteVRAMAddresses: ; 14118 (5:4118)
; Equivalent to multiplying $C0 (number of bytes in 12 tiles) times the VRAM
; slot and adding the result to $8000 (the VRAM base address).
	dw vChars0 + $c0
	dw vChars0 + $180
	dw vChars0 + $240
	dw vChars0 + $300
	dw vChars0 + $3c0
	dw vChars0 + $480
	dw vChars0 + $540
	dw vChars0 + $600
	dw vChars0 + $6c0
	dw vChars0 + $780
	dw vChars0 + $7c0
	
ReadSpriteSheetData: ; 1412e (5:412e)
	ld a, [hVRAMSlot]
	ld e, a
	ld d, 0
	ld hl, wSpriteSet
	add hl, de
	ld a, [hl]
	and a
	ret z

	dec a
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, SpriteSheetPointerTable
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld c, [hl]
	swap c ; get the number of tiles, not the raw byte length
		   ; this is because of the use of CopyVideoDataAlternate
	inc hl
	ld b, [hl]
	inc hl
	scf
	ret
	
Func_14150: ; 14150 (5:4150)
	ld a, $1
	ld [wSpriteStateData2 + $e], a
	ld a, $2
	ld [wSpriteStateData2 + $fe], a
	ld a, $e
	ld hl, wSpriteStateData1 + $10
.loop
	ld [hVRAMSlot], a
	ld a, [hl]
	and a
	jr z, .asm_1416f
	call Func_14179
	push hl
	ld de, $10e
	add hl, de
	ld [hl], a
	pop hl
.asm_1416f
	ld de, $10
	add hl, de
	ld a, [hVRAMSlot]
	dec a
	jr nz, .loop
	ret
	
Func_14179: ; 14179 (5:4179)
	push de
	push bc
	ld c, a
	ld b, 11
	ld de, wSpriteSet
.asm_14181
	ld a, [de]
	cp c
	jr z, .asm_1418d
	inc de
	dec b
	jr nz, .asm_14181
	ld a, $1
	jr .done
.asm_1418d
	ld a, $d
	sub b
.done
	pop bc
	pop de
	ret

GetSplitMapSpriteSetID: ; 14193 (5:4193)
	ld e, a
	ld d, 0
	ld hl,MapSpriteSets
	add hl, de
	ld a,[hl] ; a = spriteSetID
	cp a,$f0 ; does the map have 2 sprite sets?
	ret c
; GetSplitMapSpriteSetID
; Chooses the correct sprite set ID depending on the player's position within
; the map for maps with two sprite sets.
	cp a,$f8
	jr z,.route20
	ld hl,SplitMapSpriteSets
	and a,$0f
	dec a
	add a
	add a
	add l
	ld l,a
	jr nc,.noCarry
	inc h
.noCarry
	ld a,[hli] ; determines whether the map is split East/West or North/South
	cp a,$01
	ld a,[hli] ; position of dividing line
	ld b,a
	jr z,.eastWestDivide
.northSouthDivide
	ld a,[wYCoord]
	jr .compareCoord
.eastWestDivide
	ld a,[wXCoord]
.compareCoord
	cp b
	jr c,.loadSpriteSetID
; if in the East side or South side
	inc hl
.loadSpriteSetID
	ld a,[hl]
	ret
; Uses sprite set $01 for West side and $0A for East side.
; Route 20 is a special case because the two map sections have a more complex
; shape instead of the map simply being split horizontally or vertically.
.route20
	ld hl,wXCoord
	ld a,[hl]
	cp a,$2b
	ld a,$01
	ret c
	ld a,[hl]
	cp a,$3e
	ld a,$0a
	ret nc
	ld a,[hl]
	cp a,$37
	ld b,$08
	jr nc,.next
	ld b,$0d
.next
	ld a,[wYCoord]
	cp b
	ld a,$0a
	ret c
	ld a,$01
	ret

INCLUDE "data/sprite_sets.asm"