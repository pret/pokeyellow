ClearObjectAnimationBuffers:
	ld hl, wAnimatedObjectsData
	ld bc, wAnimatedObjectsDataEnd - wAnimatedObjectsData
	xor a
	call FillMemory
	ret

RunObjectAnimations:
	ld hl, wAnimatedObjectDataStructs
	ld e, 10
.loop
	ld a, [hl]
	and a
	jr z, .next
	ld c, l
	ld b, h
	push hl
	push de
	call ExecuteCurrentAnimatedObjectCallback
	call UpdateCurrentAnimatedObjectFrame
	pop de
	pop hl
	jr c, .quit
.next
	ld bc, $10
	add hl, bc
	dec e
	jr nz, .loop
	ld a, [wCurrentAnimatedObjectOAMBufferOffset]
	ld l, a
	ld h, wOAMBuffer / $100
.deinit_unused_oam_loop
	ld a, l
	cp wOAMBufferEnd % $100
	jr nc, .quit
	xor a
	ld [hli], a
	jr .deinit_unused_oam_loop

.quit
	ret

SpawnAnimatedObject:
	push de
	push af
	ld hl, wAnimatedObjectDataStructs
	ld e, 10
.loop
	ld a, [hl]
	and a
	jr z, .init
	ld bc, $10
	add hl, bc
	dec e
	jr nz, .loop
	pop af
	pop de
	scf
	ret

.init
	pop af
	ld c, l
	ld b, h
	ld hl, wNumLoadedAnimatedObjects
	inc [hl]
	ld e, a
	ld d, $0
	ld a, [wAnimatedObjectSpawnStateDataPointer]
	ld l, a
	ld a, [wAnimatedObjectSpawnStateDataPointer + 1]
	ld h, a
	add hl, de
	add hl, de
	add hl, de
	ld e, l
	ld d, h
	ld hl, $0
	add hl, bc
	ld a, [wNumLoadedAnimatedObjects]
	ld [hli], a
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	xor a
	ld [hli], a
	pop de
	ld hl, $4
	add hl, bc
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	dec a
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

MaskCurrentAnimatedObjectStruct:
	ld hl, $0
	add hl, bc
	ld [hl], $0
	ret

MaskAllAnimatedObjectStructs:
	ld hl, wAnimatedObjectDataStructs
	ld e, 10
.loop
	ld [hl], $0
	ld bc, $10
	add hl, bc
	dec e
	jr nz, .loop
	ret

UpdateCurrentAnimatedObjectFrame:
	xor a
	ld [wCurAnimatedObjectOAMAttributes], a
	ld hl, $3
	add hl, bc
	ld a, [hli]
	ld [wCurrentAnimatedObjectVTileOffset], a
	ld a, [hli]
	ld [wCurrentAnimatedObjectXCoord], a
	ld a, [hli]
	ld [wCurrentAnimatedObjectYCoord], a
	ld a, [hli]
	ld [wCurrentAnimatedObjectXOffset], a
	ld a, [hl]
	ld [wCurrentAnimatedObjectYOffset], a
	call UpdateDurationTimerAndFrameStateForCurrentAnimatedObject
	cp $fd
	jr z, .finish
	cp $fc
	jr z, .delete_animation
	call GetCurrentAnimatedObjectOAMDataPointer
	ld a, [wCurrentAnimatedObjectVTileOffset]
	add [hl]
	ld [wCurrentAnimatedObjectVTileOffset], a
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push bc
	ld a, [wCurrentAnimatedObjectOAMBufferOffset]
	ld e, a
	ld d, wOAMBuffer / $100
	ld a, [hli]
	ld c, a
.loop
	ld a, [wCurrentAnimatedObjectYCoord]
	ld b, a
	ld a, [wCurrentAnimatedObjectYOffset]
	add b
	ld b, a
	ld a, [wAnimatedObjectGlobalYOffset]
	add b
	ld b, a
	call GetCurrentAnimatedObjectTileYCoordinate
	add b
	ld [de], a
	inc hl
	inc de
	ld a, [wCurrentAnimatedObjectXCoord]
	ld b, a
	ld a, [wCurrentAnimatedObjectXOffset]
	add b
	ld b, a
	ld a, [wAnimatedObjectGlobalXOffset]
	add b
	ld b, a
	call GetCurrentAnimatedObjectTileXCoordinate
	add b
	ld [de], a
	inc hl
	inc de
	ld a, [wCurrentAnimatedObjectVTileOffset]
	add [hl]
	ld [de], a
	inc hl
	inc de
	call SetCurrentAnimatedObjectOAMAttributes
	ld b, a
	ld a, [wc634]
	cp $7
	ld a, b
	jr z, .skip_load
	ld [de], a
.skip_load
	inc hl
	inc de
	ld a, e
	ld [wCurrentAnimatedObjectOAMBufferOffset], a
	cp wOAMBufferEnd % $100
	jr nc, .oam_is_full
	dec c
	jr nz, .loop
	pop bc
	jr .finish

.delete_animation
	call MaskCurrentAnimatedObjectStruct
.finish
	and a
	ret

.oam_is_full
	pop bc
	scf
	ret

GetCurrentAnimatedObjectTileYCoordinate:
	push hl
	ld a, [hl]
	ld hl, wCurAnimatedObjectOAMAttributes
	bit 6, [hl]
	jr z, .no_flip
	add $8
	xor $ff
	inc a
.no_flip
	pop hl
	ret

GetCurrentAnimatedObjectTileXCoordinate:
	push hl
	ld a, [hl]
	ld hl, wCurAnimatedObjectOAMAttributes
	bit 5, [hl]
	jr z, .no_flip
	add $8
	xor $ff
	inc a
.no_flip
	pop hl
	ret

SetCurrentAnimatedObjectOAMAttributes:
	ld a, [wCurAnimatedObjectOAMAttributes]
	ld b, a
	ld a, [hl]
	xor b
	and $e0
	ld b, a
	ld a, [hl]
	and $10
	or b
	bit 4, a
	ret z
	or $4
	ret

GetCurrentAnimatedObjectOAMDataPointer:
	ld e, a
	ld d, $0
	ld a, [wAnimatedObjectOAMDataPointer]
	ld l, a
	ld a, [wAnimatedObjectOAMDataPointer + 1]
	ld h, a
	add hl, de
	add hl, de
	add hl, de
	ret

SetCurrentAnimatedObjectCallbackAndResetFrameStateRegisters:
	ld hl, $1
	add hl, bc
	ld [hl], a
	ld hl, $8
	add hl, bc
	ld [hl], $0
	ld hl, $9
	add hl, bc
	ld [hl], $0
	ld hl, $a
	add hl, bc
	ld [hl], $ff
	ret

UpdateDurationTimerAndFrameStateForCurrentAnimatedObject:
.loop
	ld hl, $8
	add hl, bc
	ld a, [hl]
	and a
	jr z, .next_frame
	dec [hl]
	call GetPointerToCurrentAnimatedObjectFrameScript
	ld a, [hli]
	push af
	jr .finish

.next_frame
	ld hl, $a
	add hl, bc
	inc [hl]
	call GetPointerToCurrentAnimatedObjectFrameScript
	ld a, [hli]
	cp $fe
	jr z, .restart_anim
	cp $ff
	jr z, .hold_last_frame_state
	push af
	ld a, [hl]
	push hl
	and $3f
	ld hl, $9
	add hl, bc
	add [hl]
	ld hl, $8
	add hl, bc
	ld [hl], a
	pop hl
.finish
	ld a, [hl]
	and $c0
	srl a
	ld [wCurAnimatedObjectOAMAttributes], a
	pop af
	ret

.hold_last_frame_state
	xor a
	ld hl, $8
	add hl, bc
	ld [hl], a
	ld hl, $a
	add hl, bc
	dec [hl]
	dec [hl]
	jr .loop

.restart_anim
	xor a
	ld hl, $8
	add hl, bc
	ld [hl], a
	dec a
	ld hl, $a
	add hl, bc
	ld [hl], a
	jr .loop

GetPointerToCurrentAnimatedObjectFrameScript:
	ld hl, $1
	add hl, bc
	ld e, [hl]
	ld d, $0
	ld a, [wAnimatedObjectFramesDataPointer]
	ld l, a
	ld a, [wAnimatedObjectFramesDataPointer + 1]
	ld h, a
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $a
	add hl, bc
	ld l, [hl]
	ld h, $0
	add hl, hl
	add hl, de
	ret

ExecuteCurrentAnimatedObjectCallback:
	ld hl, $2
	add hl, bc
	ld e, [hl]
	ld d, $0
	ld a, [wAnimatedObjectJumptablePointer]
	ld l, a
	ld a, [wAnimatedObjectJumptablePointer + 1]
	ld h, a
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
