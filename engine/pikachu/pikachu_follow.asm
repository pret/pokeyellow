ShouldPikachuSpawn::
; possibly to test if pika should be out?
	ld a, [wPikachuOverworldStateFlags]
	bit 5, a
	jr nz, .hide
	ld a, [wPikachuOverworldStateFlags]
	bit 7, a
	jr nz, .hide
	call IsStarterPikachuAliveInOurParty
	jr nc, .hide
	ld a, [wWalkBikeSurfState]
	and a
	jr nz, .hide
	scf
	ret

.hide
	and a
	ret

SchedulePikachuSpawnForAfterText::
	ld hl, wPikachuOverworldStateFlags
	bit 4, [hl]
	res 4, [hl]
	jr nz, .normal_spawn_state
	call EnablePikachuFollowingPlayer
	call ClearPikachuSpriteStateData
	ld a, $ff
	ld [wSpritePikachuStateData1ImageIndex], a
	call ClearPikachuFollowCommandBuffer
	call CalculatePikachuFacingDirection
	ret

.normal_spawn_state
	call CalculatePikachuPlacementCoords
	xor a
	ld [wPikachuSpawnState], a
	ld a, [wSpritePlayerStateData1FacingDirection]
	ld [wSpritePikachuStateData1FacingDirection], a
	ret

ClearPikachuSpriteStateData::
	ld hl, wSpritePikachuStateData1PictureID
	call .clear
	ld hl, wSpritePikachuStateData2
.clear
	ld bc, $10
	xor a
	call FillMemory
	ret

CalculatePikachuSpawnCoordsAndFacing::
	call CalculatePikachuPlacementCoords
	call CalculatePikachuFacingDirection
	xor a
	ld [wPikachuSpawnState], a
	ret

CalculatePikachuPlacementCoords::
	ld bc, wSpritePikachuStateData1PictureID
	ld a, [wYCoord]
	add $4
	ld e, a
	ld a, [wXCoord]
	add $4
	ld d, a
	ld a, [wPikachuSpawnState]
	and a
	jr z, .load_coords
	cp $1
	jr z, .right_of_player
	cp $2
	jr z, .check_player_facing2
	cp $3
	jr z, .load_coords
	cp $4
	jr z, .below_player
	cp $5
	jr z, .above_player
	cp $6
	jr z, .left_of_player
	cp $7
	jr z, .check_player_facing
	jr .right_of_player

.check_player_facing
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a ; SPRITE_FACING_DOWN
	jr z, .below_player
	cp SPRITE_FACING_UP
	jr z, .above_player
	cp SPRITE_FACING_LEFT
	jr z, .left_of_player
	cp SPRITE_FACING_RIGHT
	jr z, .right_of_player
.check_player_facing2
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a
	jr nz, .check_up
	dec e
	jr .load_coords

.check_up
	cp SPRITE_FACING_UP
	jr nz, .check_left
	inc e
	jr .load_coords

.check_left
	cp SPRITE_FACING_LEFT
	jr nz, .left_of_player_2
	inc d
	jr .load_coords

.left_of_player_2
	dec d
	jr .load_coords

.right_of_player
	inc d
	jr .load_coords

.left_of_player
	dec d
	jr .load_coords

.below_player
	inc e
	jr .load_coords

.above_player
	dec e
	jr .load_coords ; useless jr
.load_coords
	ld hl, wSpritePlayerStateData2MapY - wSpritePlayerStateData1
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	ld [hl], $fe
	push hl
	ld hl, wd471
	set 5, [hl]
	pop hl
	ret

CalculatePikachuFacingDirection::
	ld a, $49
	ld [wSpritePikachuStateData1PictureID], a
	ld a, $ff
	ld [wSpritePikachuStateData1ImageIndex], a
	ld a, [wPikachuSpawnState]
	and a
	jr z, .copy_player_facing
	cp $1
	jr z, .copy_player_facing
	cp $3
	jr z, .force_facing_down
	cp $4
	jr z, .copy_player_facing
	cp $6
	jr z, .copy_player_facing
	cp $7
	jr z, .face_the_other_way
	call ComputePikachuFacingDirection
	ret

.copy_player_facing
	ld a, [wSpritePlayerStateData1FacingDirection]
	ld [wSpritePikachuStateData1FacingDirection], a
	ret

.force_facing_down
	ld a, SPRITE_FACING_DOWN
	ld [wSpritePikachuStateData1FacingDirection], a
	ret

.face_the_other_way
	ld a, [wSpritePlayerStateData1FacingDirection]
	xor $4
	ld [wSpritePikachuStateData1FacingDirection], a
	ret

SetPikachuSpawnOutside::
	ld a, [wCurMap]
	cp OAKS_LAB
	jr z, .oaks_lab
	cp ROUTE_22_GATE
	jr z, .route_22_gate
	cp MT_MOON_B1F
	jr z, .mt_moon_2
	cp ROCK_TUNNEL_1F
	jr z, .rock_tunnel_1
	ld a, [wCurMap]
	ld hl, Pointer_fc64b
	call Pikachu_IsInArray ; similar to IsInArray, but not the same
	jr c, .map_list_1
	ld a, [wCurMap]
	ld hl, Pointer_fc653
	call Pikachu_IsInArray
	jr nc, .not_map_list_2
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a
	jr nz, .not_map_list_2
	ld a, $3
	jr .load

.route_22_gate
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a
	jr z, .rock_tunnel_1
	jr .not_map_list_2

.mt_moon_2
	ld a, $3
	jr .load

.map_list_1
	ld a, $4
	jr .load

.oaks_lab
	ld a, $6
	jr .load

.not_map_list_2
	ld a, $1
	jr .load

.rock_tunnel_1
	ld a, $3
.load
	ld [wPikachuSpawnState], a
	ret

Pointer_fc64b::
	db VICTORY_ROAD_2F
	db ROUTE_7_GATE
	db ROUTE_8_GATE
	db ROUTE_16_GATE_1F
	db ROUTE_18_GATE_1F
	db ROUTE_15_GATE_1F
	db ROUTE_11_GATE_1F
	db $ff

Pointer_fc653::
	db VIRIDIAN_FOREST_NORTH_GATE
	db CERULEAN_BADGE_HOUSE
	db CERULEAN_TRASHED_HOUSE
	db VERMILION_DOCK
	db CELADON_MANSION_1F
	db ROUTE_2_GATE
	db FUCHSIA_GOOD_ROD_HOUSE
	db $ff

SetPikachuSpawnWarpPad::
	ld a, [wCurMap]
	cp VIRIDIAN_FOREST_NORTH_GATE
	jr z, .viridian_forest_exit
	cp VIRIDIAN_FOREST_SOUTH_GATE
	jr z, .viridian_forest_entrance
	ld a, [wCurMap]
	ld hl, Pointer_fc68e
	call Pikachu_IsInArray
	jr c, .in_array
	jr .not_in_array

.viridian_forest_exit
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	jr z, .in_array
	jr .not_in_array

.viridian_forest_entrance
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a ; SPRITE_FACING_DOWN
	jr z, .not_in_array
	jr .in_array

.not_in_array
	ld a, $0
	jr .load_spawn_state

.in_array
	ld a, $1
.load_spawn_state
	ld [wPikachuSpawnState], a
	ret

Pointer_fc68e::
	db VIRIDIAN_FOREST
	db SAFARI_ZONE_CENTER_REST_HOUSE
	db SAFARI_ZONE_WEST_REST_HOUSE
	db SAFARI_ZONE_EAST_REST_HOUSE
	db SAFARI_ZONE_NORTH_REST_HOUSE
	db SAFARI_ZONE_SECRET_HOUSE
	db SILPH_CO_ELEVATOR
	db CELADON_MART_ELEVATOR
	db CINNABAR_LAB_TRADE_ROOM
	db CINNABAR_LAB_METRONOME_ROOM
	db CINNABAR_LAB_FOSSIL_ROOM
	db $ff

SetPikachuSpawnBackOutside::
	ld a, [wCurMap]
	cp ROUTE_22_GATE
	jr z, .asm_fc6a7
	cp ROUTE_2_GATE
	jr z, .asm_fc6b0
	jr .asm_fc6bd

.asm_fc6a7
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	jr z, .asm_fc6b9
	jr .asm_fc6bd

.asm_fc6b0
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	jr z, .asm_fc6b9
	jr .asm_fc6bd

.asm_fc6b9
	ld a, $1
	jr .asm_fc6c1

.asm_fc6bd
	ld a, $3
	jr .asm_fc6c1

.asm_fc6c1
	ld [wPikachuSpawnState], a
	ret

SetPikachuOverworldStateFlag2::
	push hl
	ld hl, wPikachuOverworldStateFlags
	set 2, [hl]
	pop hl
	ret

ResetPikachuOverworldStateFlag2::
	push hl
	ld hl, wPikachuOverworldStateFlags
	res 2, [hl]
	pop hl
	ret

SpawnPikachu_::
	call ResetPikachuOverworldStateFlag2
	call TrySpawnPikachu
	ret nc

	push bc
	call WillPikachuSpawnOnTheScreen
	pop bc
	ret c

	ld bc, wSpritePikachuStateData1
	ld hl, wSpritePikachuStateData1MovementStatus - wSpritePikachuStateData1
	add hl, bc
	bit 7, [hl]
	jp nz, Func_fc745
	ld a, [wFontLoaded]
	bit BIT_FONT_LOADED, a
	jp nz, Func_fc76a
	call CheckPikachuFollowingPlayer
	jp nz, Func_fc76a
	ld a, [hl]
	and $7f
	cp $a
	jr c, .valid
	xor a
.valid
	add a
	ld e, a
	ld d, 0
	ld hl, PointerTable_fc710
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

PointerTable_fc710:
	dw Func_fc793
	dw Func_fc7aa
	dw Func_fc803
	dw asm_fc9c3
	dw asm_fca1c
	dw asm_fc9ee
	dw asm_fc87f
	dw asm_fc904
	dw asm_fc937
	dw asm_fc969
	dw .nop

.nop:
	ret

TrySpawnPikachu:
	call ShouldPikachuSpawn
	jr nc, .dont_spawn
	ld a, [wSpritePikachuStateData1MovementStatus]
	and a
	jr nz, .already_spawned
	push bc
	push hl
	call CalculatePikachuSpawnCoordsAndFacing
	pop hl
	pop bc
.already_spawned
	scf
	ret

.dont_spawn
	ld hl, wSpritePikachuStateData1ImageIndex
	ld [hl], $ff
	dec hl
	ld [hl], $0
	xor a
	ret

Func_fc745:
	ld hl, wSpritePikachuStateData1MovementStatus - wSpritePikachuStateData1
	add hl, bc
	res 7, [hl]
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	ld [hl], a
	call CheckPikachuFollowingPlayer
	jr nz, .okay
	; Have Pikachu face in the opposite direction of you
	ld a, [wSpritePlayerStateData1FacingDirection]
	xor $4
	ld hl, wSpritePikachuStateData1FacingDirection - wSpritePikachuStateData1
	add hl, bc
	ld [hl], a
.okay
	xor a
	ld hl, wSpritePikachuStateData1IntraAnimFrameCounter - wSpritePikachuStateData1
	add hl, bc
	ld [hli], a
	ld [hl], a
	call UpdatePikachuWalkingSprite
	ret

Func_fc76a:
	xor a
	ld hl, wSpritePikachuStateData1IntraAnimFrameCounter - wSpritePikachuStateData1
	add hl, bc
	ld [hli], a
	ld [hl], a
	call UpdatePikachuWalkingSprite
	call Func_fc82e
	jr c, .skip
	push bc
	callfar InitializeSpriteScreenPosition
	pop bc
.skip
	ld hl, wSpritePikachuStateData1MovementStatus - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $1
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $0
	call RefreshPikachuFollow
	ret

Func_fc793:
	call RefreshPikachuFollow
	push bc
	callfar InitializeSpriteScreenPosition
	pop bc
	ld hl, wSpritePikachuStateData1ImageIndex - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $ff
	dec hl
	ld [hl], $1
	ret

Func_fc7aa:
	call Func_fcc92
	jp c, Func_fc803
	dec a
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	ld de, Pointer_fc7e3
	add hl, de
	ld d, h
	ld e, l
	ld a, [de]
	inc de
	ld hl, wSpritePikachuStateData1FacingDirection - wSpritePikachuStateData1
	add hl, bc
	ld [hl], a
	ld a, [de]
	inc de
	ld hl, wSpritePikachuStateData1XStepVector - wSpritePikachuStateData1
	add hl, bc
	ld [hl], a
	dec hl
	dec hl
	ld a, [de]
	ld [hl], a
	inc de
	ld a, [de]
	ld hl, wSpritePikachuStateData1MovementStatus - wSpritePikachuStateData1
	add hl, bc
	ld [hl], a
	cp $4
	jp z, Func_fca0a
	call AreThereAtLeastTwoStepsInPikachuFollowCommandBuffer
	jp c, FastPikachuFollow
	jp NormalPikachuFollow

Pointer_fc7e3:
	db  0,  0
	db  1,  3
	db  4,  0
	db -1,  3
	db  8, -1
	db  0,  3
	db 12,  1
	db  0,  3
	db  0,  0
	db  1,  4
	db  4,  0
	db -1,  4
	db  8, -1
	db  0,  4
	db 12,  1
	db  0,  4

Func_fc803:
	call Func_fcae2
	ret c
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	dec [hl]
	jr nz, .asm_fc823
	push hl
	call GetPikachuFollowCommand
	pop hl
	cp $5
	jr nc, Func_fc842
	ld [hl], $20
	call Random
	and $c
	ld hl, wSpritePikachuStateData1FacingDirection - wSpritePikachuStateData1
	add hl, bc
	ld [hl], a
.asm_fc823
	xor a
	ld hl, wSpritePikachuStateData1IntraAnimFrameCounter - wSpritePikachuStateData1
	add hl, bc
	ld [hli], a
	ld [hl], a
	call UpdatePikachuWalkingSprite
	ret

Func_fc82e:
	ld a, [wWalkCounter]
	and a
	ret z
	scf
	ret

Func_fc835:
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $10
	ld hl, wSpritePikachuStateData1MovementStatus - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $1
	ret

Func_fc842:
	ld hl, $0
	push af
	call Random
	ldh a, [hRandomAdd]
	and %11
	ld e, a
	ld d, $0
	ld hl, PointerTable_fc85a
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	jp hl

PointerTable_fc85a:
	dw Func_fc862
	dw Func_fc8f8
	dw Func_fc92b
	dw Func_fc95d

Func_fc862:
	dec a
	add a
	add a
	and $c
	ld hl, wSpritePikachuStateData1FacingDirection - wSpritePikachuStateData1
	add hl, bc
	ld [hl], a
	ld hl, wSpritePikachuStateData1MovementStatus - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $6
	xor a
	ld [wd431], a
	ld [wd432], a
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $11
asm_fc87f:
	ld a, [wd431]
	ld e, a
	ld a, [wd432]
	ld d, a
	call Func_fc82e
	jr c, Func_fc8c7
	call SetPikachuOverworldStateFlag2
	ld hl, wSpritePikachuStateData1YPixels - wSpritePikachuStateData1
	add hl, bc
	ld a, [hl]
	sub e
	ld e, a
	inc hl
	inc hl
	ld a, [hl]
	sub d
	ld d, a
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	ld a, [hl]
	dec a
	add a
	add LOW(Pointer_fc8d6)
	ld l, a
	ld a, HIGH(Pointer_fc8d6)
	adc 0
	ld h, a
	ld a, [hli]
	ld [wd431], a
	add e
	ld e, a
	ld a, [hl]
	ld [wd432], a
	add d
	ld d, a
	ld hl, wSpritePikachuStateData1YPixels - wSpritePikachuStateData1
	add hl, bc
	ld [hl], e
	inc hl
	inc hl
	ld [hl], d
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	dec [hl]
	ret nz
	jp Func_fc835

Func_fc8c7:
	ld hl, wSpritePikachuStateData1YPixels - wSpritePikachuStateData1
	add hl, bc
	ld a, [hl]
	sub e
	ld [hl], a
	inc hl
	inc hl
	ld a, [hl]
	sub d
	ld [hl], a
	jp Func_fc835

Pointer_fc8d6:
	db  0,  0
	db -2,  1
	db -4,  2
	db -2,  3
	db  0,  4
	db -2,  3
	db -4,  2
	db -2,  1
	db  0,  0
	db -2, -1
	db -4, -2
	db -2, -3
	db  0, -4
	db -2, -3
	db -4, -2
	db -2, -1
	db  0,  0

Func_fc8f8:
	ld hl, wSpritePikachuStateData1MovementStatus - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $7
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $30
asm_fc904:
	call Func_fc82e
	jp c, Func_fc835
	call SetPikachuOverworldStateFlag2
	ld hl, wSpritePikachuStateData1IntraAnimFrameCounter - wSpritePikachuStateData1
	add hl, bc
	ld a, [hl]
	inc a
	cp $8
	ld [hl], a
	jr nz, .asm_fc91f
	xor a
	ld [hli], a
	ld a, [hl]
	inc a
	and %11
	ld [hl], a
.asm_fc91f
	call UpdatePikachuWalkingSprite
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	dec [hl]
	ret nz
	jp Func_fc835

Func_fc92b:
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $20
	ld hl, wSpritePikachuStateData1MovementStatus - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $8
asm_fc937:
	call Func_fc82e
	jp c, Func_fc835
	call SetPikachuOverworldStateFlag2
	ld hl, wSpritePikachuStateData1IntraAnimFrameCounter - wSpritePikachuStateData1
	add hl, bc
	ld a, [hl]
	inc a
	cp $8
	ld [hl], a
	jr nz, .asm_fc951
	xor a
	ld [hli], a
	ld a, [hl]
	xor $1
	ld [hl], a
.asm_fc951
	call UpdatePikachuWalkingSprite
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	dec [hl]
	ret nz
	jp Func_fc835

Func_fc95d:
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $20
	ld hl, wSpritePikachuStateData1MovementStatus - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $9
asm_fc969:
	call Func_fc82e
	jp c, Func_fc835
	call SetPikachuOverworldStateFlag2
	ld hl, wSpritePikachuStateData1IntraAnimFrameCounter - wSpritePikachuStateData1
	add hl, bc
	ld a, [hl]
	inc a
	cp $8
	ld [hl], a
	jr nz, .skip
	xor a
	ld [hl], a
	ld hl, wSpritePikachuStateData1FacingDirection - wSpritePikachuStateData1
	add hl, bc
	ld a, [hl]
	call .TurnClockwise
	ld [hl], a
.skip
	call UpdatePikachuWalkingSprite
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	dec [hl]
	ret nz
	jp Func_fc835

.TurnClockwise:
	push hl
	ld hl, .Facings
	ld d, a
.loop
	ld a, [hli]
	cp d
	jr nz, .loop
	ld a, [hl]
	pop hl
	ret

.TurnCounterclockwise:
	push hl
	ld hl, .Facings_End
	ld d, a
.loop_
	ld a, [hld]
	cp d
	jr nz, .loop_
	ld a, [hl]
	pop hl
	ret

.Facings:
	db SPRITE_FACING_DOWN, SPRITE_FACING_LEFT, SPRITE_FACING_UP, SPRITE_FACING_RIGHT
	db SPRITE_FACING_DOWN, SPRITE_FACING_LEFT, SPRITE_FACING_UP, SPRITE_FACING_RIGHT
.Facings_End:

NormalPikachuFollow:
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $8
	ld hl, wSpritePikachuStateData1MovementStatus - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $3
	call AddPikachuStepVector
asm_fc9c3:
	call TryDoubleAddPikachuStepVectorToScreenPixelCoords
	call GetPikachuWalkingAnimationSpeed
	call UpdatePikachuWalkingSprite
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	dec [hl]
	ret nz
	call ResetPikachuStepVector
	call ComputePikachuFacingDirection
	ld hl, wSpritePikachuStateData1MovementStatus - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $1
	ret

FastPikachuFollow:
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $4
	ld hl, wSpritePikachuStateData1MovementStatus - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $5
	call AddPikachuStepVector
asm_fc9ee:
	call DoubleAddPikachuStepVectorToScreenPixelCoords
	call GetPikachuWalkingAnimationSpeed
	call UpdatePikachuWalkingSprite
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	dec [hl]
	ret nz
	call ResetPikachuStepVector
	call ComputePikachuFacingDirection
	ld hl, wSpritePikachuStateData1MovementStatus - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $1
	ret

Func_fca0a:
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $8
	ld hl, wSpritePikachuStateData1MovementStatus - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $4
	call AddPikachuStepVector
	call AddPikachuStepVector
asm_fca1c:
	call DoubleAddPikachuStepVectorToScreenPixelCoords
	call GetPikachuWalkingAnimationSpeed
	call UpdatePikachuWalkingSprite
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	dec [hl]
	ret nz
	call ResetPikachuStepVector
	call ComputePikachuFacingDirection
	ld hl, wSpritePikachuStateData1MovementStatus - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $1
	ret

AddPikachuStepVector:
	ld hl, wSpritePikachuStateData1YStepVector - wSpritePikachuStateData1
	add hl, bc
	ld e, [hl]
	inc hl
	inc hl
	ld d, [hl]
	ld hl, wSpritePikachuStateData2MapY - wSpritePikachuStateData1
	add hl, bc
	ld a, [hl]
	add e
	ld [hli], a
	ld a, [hl]
	add d
	ld [hl], a
	ret

TryDoubleAddPikachuStepVectorToScreenPixelCoords:
	ld a, [wWalkBikeSurfState]
	cp $1 ; biking
	jr nz, AddPikachuStepVectorToScreenPixelCoords
	ld a, [wMovementFlags]
	bit BIT_LEDGE_OR_FISHING, a
	jr nz, AddPikachuStepVectorToScreenPixelCoords
DoubleAddPikachuStepVectorToScreenPixelCoords:
	ld hl, wSpritePikachuStateData1YStepVector - wSpritePikachuStateData1
	add hl, bc
	ld a, [hli]
	add a
	add a
	add [hl]
	ld [hli], a
	ld a, [hli]
	add a
	add a
	add [hl]
	ld [hl], a
	ret

AddPikachuStepVectorToScreenPixelCoords:
	ld hl, wSpritePikachuStateData1YStepVector - wSpritePikachuStateData1
	add hl, bc
	ld a, [hli]
	add a
	add [hl]
	ld [hli], a
	ld a, [hli]
	add a
	add [hl]
	ld [hli], a
	ret

ResetPikachuStepVector:
	ld hl, wSpritePikachuStateData1YStepVector - wSpritePikachuStateData1
	add hl, bc
	xor a
	ld [hli], a
	inc hl
	ld [hl], a
	ret

GetPikachuWalkingAnimationSpeed:
	call ComparePikachuHappinessTo80
	ld d, $2
	jr nc, .happy
	ld d, $5
.happy
	ld hl, wSpritePikachuStateData1IntraAnimFrameCounter - wSpritePikachuStateData1
	add hl, bc
	ld a, [hl]
	inc a
	cp d
	jr nz, .dont_reset
	xor a
.dont_reset
	ld [hli], a
	ret nz
	ld a, [hl]
	inc a
	and $3
	ld [hl], a
	ret

UpdatePikachuWalkingSprite:
	ld a, [wPikachuOverworldStateFlags]
	bit 3, a
	jr nz, .uninitialized
	ld hl, wSpritePikachuStateData2ImageBaseOffset - wSpritePikachuStateData1
	add hl, bc
	ld a, [hl]
	dec a
	swap a
	ld d, a
	ld a, [wMovementFlags]
	bit BIT_SPINNING, a
	jr nz, .copy_player
	ld hl, wSpritePikachuStateData1FacingDirection - wSpritePikachuStateData1
	add hl, bc
	ld a, [hl]
	or d
	ld d, a
	ld a, [wFontLoaded]
	bit BIT_FONT_LOADED, a
	jr z, .normal_get_sprite_index
	call Func_fcae2
	ret c
	jr .load_sprite_index

.normal_get_sprite_index
	ld hl, wSpritePikachuStateData1AnimFrameCounter - wSpritePikachuStateData1
	add hl, bc
	ld a, d
	or [hl]
	ld d, a
.load_sprite_index
	ld hl, wSpritePikachuStateData1ImageIndex - wSpritePikachuStateData1
	add hl, bc
	ld [hl], d
	ret

.uninitialized
	ld hl, wSpritePikachuStateData1ImageIndex - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $ff
	ret

.copy_player
	ld a, [wSpritePlayerStateData1ImageIndex]
	and $f
	or d
	ld [wSpritePikachuStateData1ImageIndex], a
	ret

Func_fcae2:
	ld hl, wSpritePikachuStateData2MapY - wSpritePikachuStateData1
	add hl, bc
	ld a, [wYCoord]
	add $4
	cp [hl]
	jr nz, .on_screen
	inc hl
	ld a, [wXCoord]
	add $4
	cp [hl]
	jr nz, .on_screen
	ld hl, wSpritePikachuStateData1ImageIndex - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $ff
	scf
	ret

.on_screen
	and a
	ret

IsPikachuRightNextToPlayer:
	push bc
	push de
	push hl
	ld bc, wSpritePikachuStateData1PictureID
	ld a, [wXCoord]
	add $4
	ld d, a
	ld a, [wYCoord]
	add $4
	ld e, a
	ld hl, wSpritePlayerStateData2MapY - wSpritePlayerStateData1
	add hl, bc
	ld a, [hl]
	sub e
	and a
	jr z, .equal
	cp $ff
	jr z, .one_away
	cp $1
	jr z, .one_away
	jr .bad

.one_away
	ld hl, wSpritePlayerStateData2MapX - wSpritePlayerStateData1
	add hl, bc
	ld a, [hl]
	sub d
	jr z, .good
	jr .bad

.equal
	ld hl, wSpritePlayerStateData2MapX - wSpritePlayerStateData1
	add hl, bc
	ld a, [hl]
	sub d
	cp $ff
	jr z, .good
	cp $1
	jr z, .good
	and a
	jr z, .good
	jr .bad

.good
	pop hl
	pop de
	pop bc
	scf
	ret

.bad
	pop hl
	pop de
	pop bc
	xor a
	ret

GetPikachuFacingDirectionAndReturnToE::
	call GetPikachuFacingDirection
	ld e, a
	ret

GetPikachuFacingDirection:
	ld bc, wSpritePikachuStateData1PictureID
	ld a, [wXCoord]
	add $4
	ld d, a
	ld a, [wYCoord]
	add $4
	ld e, a
	ld hl, wSpritePlayerStateData2MapY - wSpritePlayerStateData1
	add hl, bc
	ld a, [hl]
	cp e
	jr z, .asm_fcb71
	jr nc, .asm_fcb6e
	ld a, SPRITE_FACING_UP
	ret

.asm_fcb6e
	ld a, SPRITE_FACING_DOWN
	ret

.asm_fcb71
	ld hl, wSpritePlayerStateData2MapX - wSpritePlayerStateData1
	add hl, bc
	ld a, [hl]
	cp d
	jr z, .asm_fcb81
	jr nc, .asm_fcb7e
	ld a, SPRITE_FACING_LEFT
	ret

.asm_fcb7e
	ld a, SPRITE_FACING_RIGHT
	ret

.asm_fcb81
	ld a, $ff ; standing
	ret

ClearPikachuFollowCommandBuffer:
	push bc
	ld hl, wPikachuFollowCommandBufferSize
	ld [hl], $ff
	inc hl
	ld bc, $10
	xor a
	call FillMemory
	pop bc
	ret

AppendPikachuFollowCommandToBuffer:
	ld hl, wPikachuFollowCommandBufferSize
	inc [hl]
	ld e, [hl]
	ld d, 0
	ld hl, wPikachuFollowCommandBuffer
	add hl, de
	ld [hl], a
	ret

RefreshPikachuFollow:
	call ClearPikachuFollowCommandBuffer
	call ComputePikachuFollowCommand
	ret c
	call AppendPikachuFollowCommandToBuffer
	ret

ComputePikachuFollowCommand:
	ld bc, wSpritePikachuStateData1PictureID
	ld hl, wSpritePlayerStateData2MapY - wSpritePlayerStateData1
	add hl, bc
	ld a, [wYCoord]
	add $4
	sub [hl]
	jr z, .checkXCoord
	jr c, .pikaAbovePlayer
	call CheckAbsoluteValueLessThan2
	jr c, .return1
	ld a, $5
	and a
	ret

.return1
	ld a, $1
	and a
	ret

.pikaAbovePlayer
	call CheckAbsoluteValueLessThan2
	jr c, .return2
	ld a, $6
	and a
	ret

.return2
	ld a, $2
	and a
	ret

.checkXCoord
	ld hl, wSpritePlayerStateData2MapX - wSpritePlayerStateData1
	add hl, bc
	ld a, [wXCoord]
	add $4
	sub [hl]
	jr z, .pikachuOnTopOfPlayer
	jr c, .pikaToLeftOfPlayer
	call CheckAbsoluteValueLessThan2
	jr c, .return4
	ld a, $8
	and a
	ret

.return4
	ld a, $4
	and a
	ret

.pikaToLeftOfPlayer
	call CheckAbsoluteValueLessThan2
	jr c, .return3
	ld a, $7
	and a
	ret

.return3
	ld a, $3
	and a
	ret

.pikachuOnTopOfPlayer
	scf
	ret

CheckAbsoluteValueLessThan2:
	jr nc, .positive
	cpl
	inc a
.positive
	cp $2
	ret

Func_fcc08::
	call Func_fcc23
	ret nc
	ld a, [wMovementFlags]
	bit BIT_LEDGE_OR_FISHING, a
	jr nz, .asm_fcc1b
	call Func_fcc42
	ret c
	call AppendPikachuFollowCommandToBuffer
	ret

.asm_fcc1b
	call Func_fcc64
	ret c
	call AppendPikachuFollowCommandToBuffer
	ret

Func_fcc23:
	ld a, [wPikachuOverworldStateFlags]
	bit 5, a
	jr nz, .asm_fcc40
	ld a, [wPikachuOverworldStateFlags]
	bit 7, a
	jr nz, .asm_fcc40
	ld a, [wd471]
	bit 7, a
	jr z, .asm_fcc40
	ld a, [wWalkBikeSurfState]
	and a
	jr nz, .asm_fcc40
	scf
	ret

.asm_fcc40
	and a
	ret

Func_fcc42:
	xor a
	ld a, [wPlayerDirection]
	bit PLAYER_DIR_BIT_UP, a
	jr nz, .asm_fcc58
	bit PLAYER_DIR_BIT_DOWN, a
	jr nz, .asm_fcc5b
	bit PLAYER_DIR_BIT_LEFT, a
	jr nz, .asm_fcc5e
	bit PLAYER_DIR_BIT_RIGHT, a
	jr nz, .asm_fcc61
	scf
	ret

.asm_fcc58
	ld a, $2
	ret

.asm_fcc5b
	ld a, $1
	ret

.asm_fcc5e
	ld a, $3
	ret

.asm_fcc61
	ld a, $4
	ret

Func_fcc64:
	ld hl, wPikachuOverworldStateFlags
	bit 6, [hl]
	jr z, .asm_fcc6e
	res 6, [hl]
	ret

.asm_fcc6e
	set 6, [hl]
	xor a
	ld a, [wPlayerDirection]
	bit PLAYER_DIR_BIT_UP, a
	jr nz, .asm_fcc86
	bit PLAYER_DIR_BIT_DOWN, a
	jr nz, .asm_fcc89
	bit PLAYER_DIR_BIT_LEFT, a
	jr nz, .asm_fcc8c
	bit PLAYER_DIR_BIT_RIGHT, a
	jr nz, .asm_fcc8f
	scf
	ret

.asm_fcc86
	ld a, $6
	ret

.asm_fcc89
	ld a, $5
	ret

.asm_fcc8c
	ld a, $7
	ret

.asm_fcc8f
	ld a, $8
	ret

Func_fcc92:
	ld hl, wPikachuFollowCommandBufferSize
	ld a, [hl]
	cp $ff
	jr z, .asm_fccb0
	and a
	jr z, .asm_fccb0
	dec [hl]
	ld e, a
	ld d, 0
	ld hl, wPikachuFollowCommandBuffer
	add hl, de
	inc e
	ld a, $ff
.asm_fcca8
	ld d, [hl]
	ld [hld], a
	ld a, d
	dec e
	jr nz, .asm_fcca8
	and a
	ret

.asm_fccb0
	scf
	ret

ComputePikachuFacingDirection::
	call GetPikachuFollowCommandIfBufferSizeNonzero
	and a
	jr z, .check_y
	dec a
	and $3
	add a
	add a
	jr .load

.check_y
	ld a, [wYCoord]
	add $4
	ld d, a
	ld a, [wXCoord]
	add $4
	ld e, a
	ld a, [wSpritePikachuStateData2MapY]
	cp d
	jr z, .check_x
	ld a, SPRITE_FACING_DOWN
	jr c, .load
	ld a, SPRITE_FACING_UP
	jr .load

.check_x
	ld a, [wSpritePikachuStateData2MapX]
	cp e
	jr z, .copy_from_player
	ld a, SPRITE_FACING_RIGHT
	jr c, .load
	ld a, SPRITE_FACING_LEFT
	jr .load

.copy_from_player
	ld a, [wSpritePlayerStateData1FacingDirection]
.load
	ld [wSpritePikachuStateData1FacingDirection], a
	ret

GetPikachuFollowCommand:
	ld hl, wPikachuFollowCommandBufferSize
	ld a, [hl]
	cp $ff
	jr z, .asm_fccff
	ld e, a
	ld d, 0
	ld hl, wPikachuFollowCommandBuffer
	add hl, de
	ld a, [hl]
	ret

.asm_fccff
	xor a
	ret

GetPikachuFollowCommandIfBufferSizeNonzero:
	ld hl, wPikachuFollowCommandBufferSize
	ld a, [hl]
	cp $ff
	jr z, .default
	and a
	jr z, .default
	ld e, a
	ld d, 0
	ld hl, wPikachuFollowCommandBuffer
	add hl, de
	ld a, [hl]
	ret

.default
	xor a
	ret

AreThereAtLeastTwoStepsInPikachuFollowCommandBuffer:
	ld a, [wPikachuFollowCommandBufferSize]
	cp $ff
	ret z
	cp $2
	jr nc, .set_carry
	and a
	ret

.set_carry
	scf
	ret

WillPikachuSpawnOnTheScreen:
	ld h, HIGH(wSpriteStateData2)
	ldh a, [hCurrentSpriteOffset] ; If we're here, this can only be $f0
	add wSpritePikachuStateData2MapY - wSpritePikachuStateData2
	ld l, a
	ld b, [hl]
	ld a, [wYCoord]
	cp b
	jr z, .same_y
	jr nc, .not_on_screen
	add (SCREEN_HEIGHT / 2) - 1
	cp b
	jr c, .not_on_screen
.same_y
	inc l
	ld b, [hl]
	ld a, [wXCoord]
	cp b
	jr z, .same_x
	jr nc, .not_on_screen
	add (SCREEN_WIDTH / 2) - 1
	cp b
	jr c, .not_on_screen
.same_x
	call .GetNPCCurrentTile
	ld d, $60
	ld a, [hli]
	ld e, a
	cp d
	jr nc, .not_on_screen
	ld a, [hld]
	cp d
	jr nc, .not_on_screen
	ld bc, -20
	add hl, bc
	ld a, [hli]
	cp d
	jr nc, .not_on_screen
	ld a, [hl]
	cp d
	jr c, .on_screen
.not_on_screen
	ld h, HIGH(wSpriteStateData1)
	ldh a, [hCurrentSpriteOffset]
	add wSpritePikachuStateData1ImageIndex - wSpritePikachuStateData1
	ld l, a
	ld [hl], $ff
	scf
	jr .return

.on_screen
	ld h, HIGH(wSpriteStateData2)
	ldh a, [hCurrentSpriteOffset]
	add wSpritePikachuStateData2GrassPriority - wSpritePikachuStateData2
	ld l, a
	ld a, [wGrassTile]
	cp e
	ld a, $0
	jr nz, .priority
	ld a, $80
.priority
	ld [hl], a
	and a
.return
	ret

.GetNPCCurrentTile:
	ld h, HIGH(wSpriteStateData1)
	ldh a, [hCurrentSpriteOffset]
	add wSpritePikachuStateData1YPixels - wSpritePikachuStateData1
	ld l, a
	ld a, [hli]
	add $4
	and $f0
	srl a
	ld c, a
	ld b, $0
	inc l
	ld a, [hl]
	add $2
	srl a
	srl a
	srl a
	add SCREEN_WIDTH
	ld d, 0
	ld e, a
	ld hl, wTileMap
REPT 5
	add hl, bc
ENDR
	add hl, de
	ret

ComparePikachuHappinessTo80:
; preserves a and bc
	push bc
	push af
	ld a, [wPikachuHappiness]
	cp 80
	pop bc
	ld a, b
	pop bc
	ret
