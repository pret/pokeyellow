PrepareOAMData::
; Determine OAM data for currently visible
; sprites and write it to wShadowOAM.
; Yellow code has been changed to use registers more efficiently
; as well as tweaking the code to show cgb palettes

	ld a, [wUpdateSpritesEnabled]
	dec a
	jr z, .updateEnabled

	cp -1
	ret nz
	ld [wUpdateSpritesEnabled], a
	jp HideSprites

.updateEnabled
	xor a
	ldh [hOAMBufferOffset], a

.spriteLoop
	ldh [hSpriteOffset2], a

	ld e, a
	ld d, HIGH(wSpriteStateData1)

	ld a, [de] ; [x#SPRITESTATEDATA1_PICTUREID]
	and a
	jp z, .nextSprite

	inc e
	inc e
	ld a, [de] ; [x#SPRITESTATEDATA1_IMAGEINDEX]
	ld [wSavedSpriteImageIndex], a
	cp $ff ; off-screen (don't draw)
	jr nz, .visible

	call GetSpriteScreenXY
	jr .nextSprite

.visible
	cp $a0 ; is the sprite unchanging like an item ball or boulder?
	jr c, .usefacing

; unchanging
	ld a, $0
	jr .next

.usefacing
	and $f

.next
; read the entry from the table
	ld c, a
	ld b, 0
	ld hl, SpriteFacingAndAnimationTable
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
; get sprite priority
	push de
	inc d
	ld a, e
	add $5
	ld e, a
	ld a, [de] ; [x#SPRITESTATEDATA2_GRASSPRIORITY]
	and $80
	ldh [hSpritePriority], a ; temp store sprite priority
	pop de


	call GetSpriteScreenXY

	ldh a, [hOAMBufferOffset]
	add [hl]
	cp $a0
	jr z, .hidden
	jr nc, .asm_4a41
.hidden
	call Func_4a7b
	ld [wSavedSpriteImageIndex], a
	ldh a, [hOAMBufferOffset]

	ld e, a
	ld d, HIGH(wShadowOAM)

.tileLoop
	ld a, [hli]
	ld c, a
.loop
	ldh a, [hSpriteScreenY]   ; temp for sprite Y position
	add $10                  ; Y=16 is top of screen (Y=0 is invisible)
	add [hl]                 ; add Y offset from table
	ld [de], a               ; write new sprite OAM Y position
	inc hl
	inc e
	ldh a, [hSpriteScreenX]   ; temp for sprite X position
	add $8                   ; X=8 is left of screen (X=0 is invisible)
	add [hl]                 ; add X offset from table
	ld [de], a
	inc hl
	inc e
	ld a, [wSavedSpriteImageIndex]
	add [hl]
	cp $80
	jr c, .asm_4a1c
	ld b, a
	ldh a, [hPikachuSpriteVRAMOffset]
	add b
.asm_4a1c
	ld [de], a ; tile id
	inc hl
	inc e
	ld a, [hl]
	bit BIT_SPRITE_UNDER_GRASS, a
	jr z, .skipPriority
	ldh a, [hSpritePriority]
	or [hl]
.skipPriority
	and $f0
	bit B_OAM_PAL1, a
	jr z, .spriteusesOBP0
	or OAM_HIGH_PALS
.spriteusesOBP0
	ld [de], a
	inc hl
	inc e
	dec c
	jr nz, .loop

	ld a, e
	ldh [hOAMBufferOffset], a
.nextSprite
	ldh a, [hSpriteOffset2]
	add $10
	cp LOW($100)
	jp nz, .spriteLoop

	; Clear unused OAM.
.asm_4a41
	ld a, [wMovementFlags]
	bit BIT_LEDGE_OR_FISHING, a
	ld c, LOW(wShadowOAMEnd)
	jr z, .clear

; Don't clear the last 4 entries because they are used for the shadow in the
; jumping down ledge animation and the rod in the fishing animation.
	ld c, LOW(wShadowOAMSprite36)

.clear
	ldh a, [hOAMBufferOffset]
	cp c
	ret nc
	ld l, a
	ld h, HIGH(wShadowOAM)
	ld a, c
	ld de, $4 ; entry size
	ld b, $a0
.clearLoop
	ld [hl], b
	add hl, de
	cp l
	jr nz, .clearLoop
	ret

GetSpriteScreenXY:
	inc e
	inc e
	ld a, [de] ; [x#SPRITESTATEDATA1_YPIXELS]
	ldh [hSpriteScreenY], a
	inc e
	inc e
	ld a, [de] ; [x#SPRITESTATEDATA1_XPIXELS]
	ldh [hSpriteScreenX], a
	ld a, 4
	add e
	ld e, a
	ldh a, [hSpriteScreenY]
	add 4
	and $f0
	ld [de], a ; [x#SPRITESTATEDATA1_YADJUSTED]
	inc e
	ldh a, [hSpriteScreenX]
	and $f0
	ld [de], a  ; [x#SPRITESTATEDATA1_XADJUSTED]
	ret

Func_4a7b:
	push bc
	ld a, [wSavedSpriteImageIndex]
	swap a                   ; high nybble determines sprite used (0 is always player sprite, next are some npcs)
	and $f

	; Sprites $a and $b have one face (and therefore 4 tiles instead of 12).
	; As a result, sprite $b's tile offset is less than normal.
	cp $b
	jr nz, .notFourTileSprite
	ld a, $a * 12 + 4 ; $7c
	jr .done

.notFourTileSprite
	; a *= 12
	add a
	add a
	ld c, a
	add a
	add c
.done
	pop bc
	ret

INCLUDE "engine/gfx/oam_dma.asm"

_IsTilePassable::
	ld hl, wTilesetCollisionPtr ; pointer to list of passable tiles
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl now points to passable tiles
.loop
	ld a, [hli]
	cp $ff
	jr z, .tileNotPassable
	cp c
	jr nz, .loop
	xor a
	ret
.tileNotPassable
	scf
	ret

INCLUDE "data/tilesets/collision_tile_ids.asm"
