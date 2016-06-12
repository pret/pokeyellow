; only used for setting bit 2 of wd736 upon entering a new map
IsPlayerStandingOnWarp:
	ld a, [wNumberOfWarps]
	and a
	ret z
	ld c, a
	ld hl, wWarpEntries
.loop
	ld a, [wYCoord]
	cp [hl]
	jr nz, .nextWarp1
	inc hl
	ld a, [wXCoord]
	cp [hl]
	jr nz, .nextWarp2
	inc hl
	ld a, [hli] ; target warp
	ld [wDestinationWarpID], a
	ld a, [hl] ; target map
	ld [$ff8b], a
	ld hl, wd736
	set 2, [hl] ; standing on warp flag
	ret
.nextWarp1
	inc hl
.nextWarp2
	inc hl
	inc hl
	inc hl
	dec c
	jr nz, .loop
	ret

CheckForceBikeOrSurf:
	ld hl, wd732
	bit 5, [hl]
	ret nz
	ld hl, ForcedBikeOrSurfMaps
	ld a, [wYCoord]
	ld b, a
	ld a, [wXCoord]
	ld c, a
	ld a, [wCurMap]
	ld d, a
.loop
	ld a, [hli]
	cp $ff
	ret z ;if we reach FF then it's not part of the list
	cp d ;compare to current map
	jr nz, .incorrectMap
	ld a, [hli]
	cp b ;compare y-coord
	jr nz, .incorrectY
	ld a, [hli]
	cp c ;compare x-coord
	jr nz, .loop ; incorrect x-coord, check next item
	ld a, [wCurMap]
	cp SEAFOAM_ISLANDS_4
	ld a, $2
	ld [wSeafoamIslands4CurScript], a
	jr z, .forceSurfing
	ld a, [wCurMap]
	cp SEAFOAM_ISLANDS_5
	ld a, $2
	ld [wSeafoamIslands5CurScript], a
	jr z, .forceSurfing
	;force bike riding
	ld hl, wd732
	set 5, [hl]
	ld a, $1
	ld [wWalkBikeSurfState], a
	ld [wWalkBikeSurfStateCopy], a
	call ForceBikeOrSurf
	ret
.incorrectMap
	inc hl
.incorrectY
	inc hl
	jr .loop
.forceSurfing
	ld a, $2
	ld [wWalkBikeSurfState], a
	ld [wWalkBikeSurfStateCopy], a
	call ForceBikeOrSurf
	ret

INCLUDE "data/force_bike_surf.asm"

IsPlayerFacingEdgeOfMap:
	push hl
	push de
	push bc
	ld a, [wPlayerFacingDirection] ; player sprite's facing direction
	srl a
	ld c, a
	ld b, $0
	ld hl, .functionPointerTable
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wYCoord]
	ld b, a
	ld a, [wXCoord]
	ld c, a
	ld de, .returnaddress
	push de
	jp [hl]
.returnaddress
	pop bc
	pop de
	pop hl
	ret

.functionPointerTable
	dw .facingDown
	dw .facingUp
	dw .facingLeft
	dw .facingRight

.facingDown
	ld a, [wCurMapHeight]
	add a
	dec a
	cp b
	jr z, .setCarry
	jr .resetCarry

.facingUp
	ld a, b
	and a
	jr z, .setCarry
	jr .resetCarry

.facingLeft
	ld a, c
	and a
	jr z, .setCarry
	jr .resetCarry

.facingRight
	ld a, [wCurMapWidth]
	add a
	dec a
	cp c
	jr z, .setCarry
	jr .resetCarry
.resetCarry
	and a
	ret
.setCarry
	scf
	ret

IsWarpTileInFrontOfPlayer:
	push hl
	push de
	push bc
	call _GetTileAndCoordsInFrontOfPlayer
	ld a, [wCurMap]
	cp SS_ANNE_5
	jr z, .ssAnne5
	ld a, [wPlayerFacingDirection] ; player sprite's facing direction
	srl a
	ld c, a
	ld b, 0
	ld hl, .warpTileListPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wTileInFrontOfPlayer]
	ld de, $1
	call IsInArray
.done
	pop bc
	pop de
	pop hl
	ret

.warpTileListPointers:
	dw .facingDownWarpTiles
	dw .facingUpWarpTiles
	dw .facingLeftWarpTiles
	dw .facingRightWarpTiles

.facingDownWarpTiles
	db $01,$12,$17,$3D,$04,$18,$33,$FF

.facingUpWarpTiles
	db $01,$5C,$FF

.facingLeftWarpTiles
	db $1A,$4B,$FF

.facingRightWarpTiles
	db $0F,$4E,$FF

.ssAnne5
	ld a, [wTileInFrontOfPlayer]
	cp $15
	jr nz, .notSSAnne5Warp
	scf
	jr .done
.notSSAnne5Warp
	and a
	jr .done

IsPlayerStandingOnDoorTileOrWarpTile:
	push hl
	push de
	push bc
	callba IsPlayerStandingOnDoorTile
	jr c, .done
	ld a, [wCurMapTileset]
	add a
	ld c, a
	ld b, $0
	ld hl, WarpTileIDPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $1
	aCoord 8, 9
	call IsInArray
	jr nc, .done
	ld hl, wd736
	res 2, [hl]
.done
	pop bc
	pop de
	pop hl
	ret

INCLUDE "data/warp_tile_ids.asm"
