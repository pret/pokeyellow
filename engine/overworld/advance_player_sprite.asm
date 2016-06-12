_AdvancePlayerSprite::
	ld a,[wSpriteStateData1 + 3] ; delta Y
	ld b,a
	ld a,[wSpriteStateData1 + 5] ; delta X
	ld c,a
	ld hl,wWalkCounter ; walking animation counter
	dec [hl]
	jr nz,.afterUpdateMapCoords
; if it's the end of the animation, update the player's map coordinates
	ld hl, wPikachuOverworldStateFlags
	res 5, [hl]
	ld a,[wYCoord]
	add b
	ld [wYCoord],a
	ld a,[wXCoord]
	add c
	ld [wXCoord],a
.afterUpdateMapCoords
	ld a,[wWalkCounter] ; walking animation counter
	cp a,$07
	jp nz,.scrollBackgroundAndSprites
; if this is the first iteration of the animation
	ld a,c
	cp a,$01
	jr nz,.checkIfMovingWest
; moving east
	ld a,[wMapViewVRAMPointer]
	ld e,a
	and $e0
	ld d,a
	ld a,e
	add $02
	and $1f
	or d
	ld [wMapViewVRAMPointer],a
	jr .adjustXCoordWithinBlock
.checkIfMovingWest
	cp a,$ff
	jr nz,.checkIfMovingSouth
; moving west
	ld a,[wMapViewVRAMPointer]
	ld e,a
	and a,$e0
	ld d,a
	ld a,e
	sub $02
	and $1f
	or d
	ld [wMapViewVRAMPointer],a
	jr .adjustXCoordWithinBlock
.checkIfMovingSouth
	ld a,b
	cp a,$01
	jr nz,.checkIfMovingNorth
; moving south
	ld a,[wMapViewVRAMPointer]
	add $40
	ld [wMapViewVRAMPointer],a
	jr nc,.adjustXCoordWithinBlock
	ld a,[wMapViewVRAMPointer + 1]
	inc a
	and $03
	or $98
	ld [wMapViewVRAMPointer + 1],a
	jr .adjustXCoordWithinBlock
.checkIfMovingNorth
	cp a,$ff
	jr nz,.adjustXCoordWithinBlock
; moving north
	ld a,[wMapViewVRAMPointer]
	sub $40
	ld [wMapViewVRAMPointer],a
	jr nc,.adjustXCoordWithinBlock
	ld a,[wMapViewVRAMPointer + 1]
	dec a
	and $03
	or $98
	ld [wMapViewVRAMPointer + 1],a
.adjustXCoordWithinBlock
	ld a,c
	and a
	jr z,.pointlessJump ; mistake?
.pointlessJump
	ld hl,wXBlockCoord
	ld a,[hl]
	add c
	ld [hl],a
	cp $02
	jr nz,.checkForMoveToWestBlock
; moved into the tile block to the east
	xor a
	ld [hl],a
	ld hl,wXOffsetSinceLastSpecialWarp
	inc [hl]
	ld de,wCurrentTileBlockMapViewPointer
	call MoveTileBlockMapPointerEast
	jr .updateMapView
.checkForMoveToWestBlock
	cp a,$ff
	jr nz,.adjustYCoordWithinBlock
; moved into the tile block to the west
	ld a,$1
	ld [hl],a
	ld hl,wXOffsetSinceLastSpecialWarp
	dec [hl]
	ld de,wCurrentTileBlockMapViewPointer
	call MoveTileBlockMapPointerWest
	jr .updateMapView
.adjustYCoordWithinBlock
	ld hl,wYBlockCoord
	ld a,[hl]
	add b
	ld [hl],a
	cp $2
	jr nz,.checkForMoveToNorthBlock
; moved into the tile block to the south
	xor a
	ld [hl],a
	ld hl,wYOffsetSinceLastSpecialWarp
	inc [hl]
	ld de,wCurrentTileBlockMapViewPointer
	ld a,[wCurMapWidth]
	call MoveTileBlockMapPointerSouth
	jr .updateMapView
.checkForMoveToNorthBlock
	cp a,$ff
	jr nz,.updateMapView
; moved into the tile block to the north
	ld a,$1
	ld [hl],a
	ld hl,wYOffsetSinceLastSpecialWarp
	dec [hl]
	ld de,wCurrentTileBlockMapViewPointer
	ld a,[wCurMapWidth]
	call MoveTileBlockMapPointerNorth
.updateMapView
	call LoadCurrentMapView
	ld a,[wSpriteStateData1 + 3] ; delta Y
	cp $1
	jr nz,.checkIfMovingNorth2
; if moving south
	call ScheduleSouthRowRedraw
	jr .scrollBackgroundAndSprites
.checkIfMovingNorth2
	cp $ff
	jr nz,.checkIfMovingEast2
; if moving north
	call ScheduleNorthRowRedraw
	jr .scrollBackgroundAndSprites
.checkIfMovingEast2
	ld a,[wSpriteStateData1 + 5] ; delta X
	cp $1
	jr nz,.checkIfMovingWest2
; if moving east
	call ScheduleEastColumnRedraw
	jr .scrollBackgroundAndSprites
.checkIfMovingWest2
	cp $ff
	jr nz,.scrollBackgroundAndSprites
; if moving west
	call ScheduleWestColumnRedraw
.scrollBackgroundAndSprites
	ld a,[wSpriteStateData1 + 3] ; delta Y
	add a
	ld b,a
	ld a,[wSpriteStateData1 + 5] ; delta X
	add a
	ld c,a
; shift all the sprites in the direction opposite of the player's motion
; so that the player appears to move relative to them
	ld hl,wSpriteStateData1 + $14
	ld e,15
.spriteShiftLoop
	ld a,[hl]
	sub b
	ld [hli],a
	inc l
	ld a,[hl]
	sub c
	ld [hl],a
	ld a,$0e
	add l
	ld l,a
	dec e
	jr nz,.spriteShiftLoop
.done
	ld a,[hSCY]
	add b
	ld [hSCY],a ; update background scroll Y
	ld a,[hSCX]
	add c
	ld [hSCX],a ; update background scroll X
	ret

MoveTileBlockMapPointerEast::
	ld a,[de]
	add $1
	ld [de],a
	ret nc
	inc de
	ld a,[de]
	inc a
	ld [de],a
	ret

MoveTileBlockMapPointerWest::
	ld a,[de]
	sub $1
	ld [de],a
	ret nc
	inc de
	ld a,[de]
	dec a
	ld [de],a
	ret

MoveTileBlockMapPointerSouth::
	add $6
	ld b,a
	ld a,[de]
	add b
	ld [de],a
	ret nc
	inc de
	ld a,[de]
	inc a
	ld [de],a
	ret

MoveTileBlockMapPointerNorth::
	add $6
	ld b,a
	ld a,[de]
	sub b
	ld [de],a
	ret nc
	inc de
	ld a,[de]
	dec a
	ld [de],a
	ret
