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
	ld hl, wPikachuSpawnStateFlags
	set BIT_PIKACHU_SPAWN_FOLLOWING, [hl]
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
	ld hl, PikachuSpawnMapList1
	call Pikachu_IsInArray ; similar to IsInArray, but not the same
	jr c, .map_list_1
	ld a, [wCurMap]
	ld hl, PikachuSpawnMapList2
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

PikachuSpawnMapList1::
	db VICTORY_ROAD_2F
	db ROUTE_7_GATE
	db ROUTE_8_GATE
	db ROUTE_16_GATE_1F
	db ROUTE_18_GATE_1F
	db ROUTE_15_GATE_1F
	db ROUTE_11_GATE_1F
	db $ff

PikachuSpawnMapList2::
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
	ld hl, PikachuSpawnWarpPadMaps
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

PikachuSpawnWarpPadMaps::
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
	jr z, .route_22_gate
	cp ROUTE_2_GATE
	jr z, .route_2_gate
	jr .not_facing_up

.route_22_gate
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	jr z, .facing_up
	jr .not_facing_up

.route_2_gate
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	jr z, .facing_up
	jr .not_facing_up

.facing_up
	ld a, $1
	jr .load_spawn_state

.not_facing_up
	ld a, $3
	jr .load_spawn_state

.load_spawn_state
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
	jp nz, PikachuFaceAwayFromPlayer
	ld a, [wFontLoaded]
	bit BIT_FONT_LOADED, a
	jp nz, PikachuResumeFollowAfterPause
	call CheckPikachuFollowingPlayer
	jp nz, PikachuResumeFollowAfterPause
	ld a, [hl]
	and $7f
	cp $a
	jr c, .valid
	xor a
.valid
	add a
	ld e, a
	ld d, 0
	ld hl, PikachuMovementStateTable
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

PikachuMovementStateTable:
	dw PikachuMovementState_RefreshAndFollow
	dw PikachuMovementState_ProcessCommand
	dw PikachuMovementState_Idle
	dw PikachuMovementState_NormalFollow
	dw PikachuMovementState_DoubleStep
	dw PikachuMovementState_FastFollow
	dw PikachuMovementState_Hop
	dw PikachuMovementState_Twitch
	dw PikachuMovementState_LookSideToSide
	dw PikachuMovementState_Spin
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

PikachuFaceAwayFromPlayer:
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

PikachuResumeFollowAfterPause:
	xor a
	ld hl, wSpritePikachuStateData1IntraAnimFrameCounter - wSpritePikachuStateData1
	add hl, bc
	ld [hli], a
	ld [hl], a
	call UpdatePikachuWalkingSprite
	call CheckWalkAnimationDone
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

PikachuMovementState_RefreshAndFollow:
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

PikachuMovementState_ProcessCommand:
	call GetNextPikachuFollowCommand
	jp c, PikachuMovementState_Idle
	dec a
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	ld de, PikachuMovementCommandData
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
	jp z, PikachuDoubleStep
	call AreThereAtLeastTwoStepsInPikachuFollowCommandBuffer
	jp c, FastPikachuFollow
	jp NormalPikachuFollow

PikachuMovementCommandData:
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

PikachuMovementState_Idle:
	call HidePikachuIfOffScreen
	ret c
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	dec [hl]
	jr nz, .skip
	push hl
	call GetPikachuFollowCommand
	pop hl
	cp $5
	jr nc, SelectRandomPikachuIdleAction
	ld [hl], $20
	call Random
	and $c
	ld hl, wSpritePikachuStateData1FacingDirection - wSpritePikachuStateData1
	add hl, bc
	ld [hl], a
.skip
	xor a
	ld hl, wSpritePikachuStateData1IntraAnimFrameCounter - wSpritePikachuStateData1
	add hl, bc
	ld [hli], a
	ld [hl], a
	call UpdatePikachuWalkingSprite
	ret

CheckWalkAnimationDone:
	ld a, [wWalkCounter]
	and a
	ret z
	scf
	ret

ResetPikachuToProcessCommandState:
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $10
	ld hl, wSpritePikachuStateData1MovementStatus - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $1
	ret

SelectRandomPikachuIdleAction:
	ld hl, $0
	push af
	call Random
	ldh a, [hRandomAdd]
	and %11
	ld e, a
	ld d, $0
	ld hl, PikachuIdleActionTable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	jp hl

PikachuIdleActionTable:
	dw PikachuHop
	dw PikachuTwitch
	dw PikachuLookSideToSide
	dw PikachuSpin

PikachuHop:
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
	ld [wPikachuSpriteStateYPixelOffset], a
	ld [wPikachuSpriteStateXPixelOffset], a
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $11
PikachuMovementState_Hop:
	ld a, [wPikachuSpriteStateYPixelOffset]
	ld e, a
	ld a, [wPikachuSpriteStateXPixelOffset]
	ld d, a
	call CheckWalkAnimationDone
	jr c, AdjustPikachuSpriteStatePixelOffsets
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
	add LOW(PikachuSpriteStatePixelOffsets)
	ld l, a
	ld a, HIGH(PikachuSpriteStatePixelOffsets)
	adc 0
	ld h, a
	ld a, [hli]
	ld [wPikachuSpriteStateYPixelOffset], a
	add e
	ld e, a
	ld a, [hl]
	ld [wPikachuSpriteStateXPixelOffset], a
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
	jp ResetPikachuToProcessCommandState

AdjustPikachuSpriteStatePixelOffsets:
	ld hl, SPRITESTATEDATA1_YPIXELS
	add hl, bc
	ld a, [hl]
	sub e
	ld [hl], a
	ASSERT SPRITESTATEDATA1_YPIXELS + 2 == SPRITESTATEDATA1_XPIXELS
	inc hl
	inc hl
	ld a, [hl]
	sub d
	ld [hl], a
	jp ResetPikachuToProcessCommandState

PikachuSpriteStatePixelOffsets:
	;  dy, dx
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

PikachuTwitch:
	ld hl, wSpritePikachuStateData1MovementStatus - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $7
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $30
PikachuMovementState_Twitch:
	call CheckWalkAnimationDone
	jp c, ResetPikachuToProcessCommandState
	call SetPikachuOverworldStateFlag2
	ld hl, wSpritePikachuStateData1IntraAnimFrameCounter - wSpritePikachuStateData1
	add hl, bc
	ld a, [hl]
	inc a
	cp $8
	ld [hl], a
	jr nz, .skip
	xor a
	ld [hli], a
	ld a, [hl]
	inc a
	and %11
	ld [hl], a
.skip
	call UpdatePikachuWalkingSprite
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	dec [hl]
	ret nz
	jp ResetPikachuToProcessCommandState

PikachuLookSideToSide:
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $20
	ld hl, wSpritePikachuStateData1MovementStatus - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $8
PikachuMovementState_LookSideToSide:
	call CheckWalkAnimationDone
	jp c, ResetPikachuToProcessCommandState
	call SetPikachuOverworldStateFlag2
	ld hl, wSpritePikachuStateData1IntraAnimFrameCounter - wSpritePikachuStateData1
	add hl, bc
	ld a, [hl]
	inc a
	cp $8
	ld [hl], a
	jr nz, .skip
	xor a
	ld [hli], a
	ld a, [hl]
	xor $1
	ld [hl], a
.skip
	call UpdatePikachuWalkingSprite
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	dec [hl]
	ret nz
	jp ResetPikachuToProcessCommandState

PikachuSpin:
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $20
	ld hl, wSpritePikachuStateData1MovementStatus - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $9
PikachuMovementState_Spin:
	call CheckWalkAnimationDone
	jp c, ResetPikachuToProcessCommandState
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
	jp ResetPikachuToProcessCommandState

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
PikachuMovementState_NormalFollow:
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
PikachuMovementState_FastFollow:
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

PikachuDoubleStep:
	ld hl, wSpritePikachuStateData2WalkAnimationCounter - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $8
	ld hl, wSpritePikachuStateData1MovementStatus - wSpritePikachuStateData1
	add hl, bc
	ld [hl], $4
	call AddPikachuStepVector
	call AddPikachuStepVector
PikachuMovementState_DoubleStep:
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
	call HidePikachuIfOffScreen
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

HidePikachuIfOffScreen:
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
	jr z, .same_y
	jr nc, .facing_down
	ld a, SPRITE_FACING_UP
	ret

.facing_down
	ld a, SPRITE_FACING_DOWN
	ret

.same_y
	ld hl, wSpritePlayerStateData2MapX - wSpritePlayerStateData1
	add hl, bc
	ld a, [hl]
	cp d
	jr z, .standing
	jr nc, .facing_right
	ld a, SPRITE_FACING_LEFT
	ret

.facing_right
	ld a, SPRITE_FACING_RIGHT
	ret

.standing
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

QueuePikachuFollowCommand::
	call CheckIfPikachuCanFollow
	ret nc
	ld a, [wMovementFlags]
	bit BIT_LEDGE_OR_FISHING, a
	jr nz, .ledge_or_fishing
	call GetPlayerDirection
	ret c
	call AppendPikachuFollowCommandToBuffer
	ret

.ledge_or_fishing
	call PikachuLedgeOrFishingDirection
	ret c
	call AppendPikachuFollowCommandToBuffer
	ret

CheckIfPikachuCanFollow:
	ld a, [wPikachuOverworldStateFlags]
	bit 5, a
	jr nz, .cannot_follow
	ld a, [wPikachuOverworldStateFlags]
	bit 7, a
	jr nz, .cannot_follow
	ld a, [wPikachuSpawnStateFlags]
	bit BIT_PIKACHU_SPAWN_STARTER, a
	jr z, .cannot_follow
	ld a, [wWalkBikeSurfState]
	and a
	jr nz, .cannot_follow
	scf
	ret

.cannot_follow
	and a
	ret

GetPlayerDirection:
	xor a
	ld a, [wPlayerDirection]
	bit PLAYER_DIR_BIT_UP, a
	jr nz, .up
	bit PLAYER_DIR_BIT_DOWN, a
	jr nz, .down
	bit PLAYER_DIR_BIT_LEFT, a
	jr nz, .left
	bit PLAYER_DIR_BIT_RIGHT, a
	jr nz, .right
	scf
	ret

.up
	ld a, $2
	ret

.down
	ld a, $1
	ret

.left
	ld a, $3
	ret

.right
	ld a, $4
	ret

PikachuLedgeOrFishingDirection:
	ld hl, wPikachuOverworldStateFlags
	bit 6, [hl]
	jr z, .toggle_flag
	res 6, [hl]
	ret

.toggle_flag
	set 6, [hl]
	xor a
	ld a, [wPlayerDirection]
	bit PLAYER_DIR_BIT_UP, a
	jr nz, .up
	bit PLAYER_DIR_BIT_DOWN, a
	jr nz, .down
	bit PLAYER_DIR_BIT_LEFT, a
	jr nz, .left
	bit PLAYER_DIR_BIT_RIGHT, a
	jr nz, .right
	scf
	ret

.up
	ld a, $6
	ret

.down
	ld a, $5
	ret

.left
	ld a, $7
	ret

.right
	ld a, $8
	ret

GetNextPikachuFollowCommand:
	ld hl, wPikachuFollowCommandBufferSize
	ld a, [hl]
	cp $ff
	jr z, .exit
	and a
	jr z, .exit
	dec [hl]
	ld e, a
	ld d, 0
	ld hl, wPikachuFollowCommandBuffer
	add hl, de
	inc e
	ld a, $ff
.loop
	ld d, [hl]
	ld [hld], a
	ld a, d
	dec e
	jr nz, .loop
	and a
	ret

.exit
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
