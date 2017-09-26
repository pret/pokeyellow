EnterMap::
; Load a new map.
	ld a, $ff
	ld [wJoyIgnore], a
	call LoadMapData
	callba ClearVariablesAfterLoadingMapData
	ld hl, wd72c
	bit 0, [hl] ; has the player already made 3 steps since the last battle?
	jr z, .skipGivingThreeStepsOfNoRandomBattles
	ld a, 3 ; minimum number of steps between battles
	ld [wNumberOfNoRandomBattleStepsLeft], a
.skipGivingThreeStepsOfNoRandomBattles
	ld hl, wd72e
	bit 5, [hl] ; did a battle happen immediately before this?
	res 5, [hl] ; unset the "battle just happened" flag
	call z, ResetUsingStrengthOutOfBattleBit
	call nz, MapEntryAfterBattle
	ld hl, wd732
	ld a, [hl]
	and 1 << 4 | 1 << 3 ; fly warp or dungeon warp
	jr z, .didNotEnterUsingFlyWarpOrDungeonWarp
	callba EnterMapAnim
	call UpdateSprites
	ld hl, wd732
	res 3, [hl]
	ld hl, wd72e
	res 4, [hl]
.didNotEnterUsingFlyWarpOrDungeonWarp
	call IsSurfingPikachuInParty
	callba CheckForceBikeOrSurf ; handle currents in SF islands and forced bike riding in cycling road
	ld hl, wd732
	bit 4, [hl]
	res 4, [hl]
	ld hl, wd72d
	res 5, [hl]
	call UpdateSprites
	ld hl, wCurrentMapScriptFlags
	set 5, [hl]
	set 6, [hl]
	xor a
	ld [wJoyIgnore], a

OverworldLoop::
	call DelayFrame
OverworldLoopLessDelay::
	call DelayFrame
	call IsSurfingPikachuInParty
	call LoadGBPal
	call HandleMidJump
	ld a, [wWalkCounter]
	and a
	jp nz, .moveAhead ; if the player sprite has not yet completed the walking animation
	call JoypadOverworld ; get joypad state (which is possibly simulated)
	callba SafariZoneCheck
	ld a, [wSafariZoneGameOver]
	and a
	jp nz, WarpFound2
	ld hl, wd72d
	bit 3, [hl]
	res 3, [hl]
	jp nz, WarpFound2
	ld a, [wd732]
	and 1 << 4 | 1 << 3 ; fly warp or dungeon warp
	jp nz, HandleFlyWarpOrDungeonWarp
	ld a, [wCurOpponent]
	and a
	jp nz, .newBattle
	ld a, [wd730]
	bit 7, a ; are we simulating button presses?
	jr z, .notSimulating
	ld a, [hJoyHeld]
	jr .checkIfStartIsPressed
.notSimulating
	ld a, [hJoyPressed]
.checkIfStartIsPressed
	bit 3, a ; start button
	jr z, .startButtonNotPressed
; if START is pressed
	xor a
	ld [hSpriteIndexOrTextID], a ; start menu text ID
	jp .displayDialogue
.startButtonNotPressed
	bit 0, a ; A button
	jp z, .checkIfDownButtonIsPressed
; if A is pressed
	ld a, [wd730]
	bit 2, a
	jp nz, .noDirectionButtonsPressed
	call IsPlayerCharacterBeingControlledByGame
	jr nz, .checkForOpponent
	call CheckForHiddenObjectOrBookshelfOrCardKeyDoor
	ld a, [$ffeb]
	and a
	jp z, OverworldLoop ; jump if a hidden object or bookshelf was found, but not if a card key door was found
	xor a
	ld [wd436], a ; new yellow address
	call IsSpriteOrSignInFrontOfPlayer
	call Func_0ffe
	ld a, [hSpriteIndexOrTextID]
	and a
	jp z, OverworldLoop
.displayDialogue
	predef GetTileAndCoordsInFrontOfPlayer
	call UpdateSprites
	ld a, [wFlags_0xcd60]
	bit 2, a
	jr nz, .checkForOpponent
	bit 0, a
	jr nz, .checkForOpponent
	aCoord 8, 9
	ld [wTilePlayerStandingOn], a ; unused?
	call DisplayTextID ; display either the start menu or the NPC/sign text
	ld a, [wEnteringCableClub]
	and a
	jr z, .checkForOpponent
	xor a
	ld [wLinkTimeoutCounter], a
	jp EnterMap
.checkForOpponent
	ld a, [wCurOpponent]
	and a
	jp nz, .newBattle
	jp OverworldLoop

.noDirectionButtonsPressed
	call UpdateSprites
	ld hl, wFlags_0xcd60
	res 2, [hl]
	xor a
	ld [wd435], a
	ld a, 1
	ld [wCheckFor180DegreeTurn], a
	ld a, [wPlayerMovingDirection] ; the direction that was pressed last time
	and a
	jr z, .overworldloop
; if a direction was pressed last time
	ld [wPlayerLastStopDirection], a ; save the last direction
	xor a
	ld [wPlayerMovingDirection], a ; zero the direction
.overworldloop
	jp OverworldLoop

.checkIfDownButtonIsPressed
	ld a, [hJoyHeld] ; current joypad state
	bit 7, a ; down button
	jr z, .checkIfUpButtonIsPressed
	ld a, 1
	ld [wSpriteStateData1 + 3], a ; delta Y
	ld a, PLAYER_DIR_DOWN
	jr .handleDirectionButtonPress

.checkIfUpButtonIsPressed
	bit 6, a ; up button
	jr z, .checkIfLeftButtonIsPressed
	ld a, -1
	ld [wSpriteStateData1 + 3], a ; delta Y
	ld a, PLAYER_DIR_UP
	jr .handleDirectionButtonPress

.checkIfLeftButtonIsPressed
	bit 5, a ; left button
	jr z, .checkIfRightButtonIsPressed
	ld a, -1
	ld [wSpriteStateData1 + 5], a ; delta X
	ld a, PLAYER_DIR_LEFT
	jr .handleDirectionButtonPress

.checkIfRightButtonIsPressed
	bit 4, a ; right button
	jr z, .noDirectionButtonsPressed
	ld a, 1
	ld [wSpriteStateData1 + 5], a ; delta X
	ld a, 1

.handleDirectionButtonPress
	ld [wPlayerDirection], a ; new direction
	ld a, [wd730]
	bit 7, a ; are we simulating button presses?
	jr nz, .noDirectionChange ; ignore direction changes if we are
	ld a, [wCheckFor180DegreeTurn]
	and a
	jr z, .noDirectionChange
	ld a, [wPlayerDirection] ; new direction
	ld b, a
	ld a, [wPlayerLastStopDirection] ; old direction
	cp b
	jr z, .noDirectionChange
	ld a, $8
	ld [wd435], a
; unlike in red/blue, yellow does not have the 180 degrees odd code
	ld hl, wFlags_0xcd60
	set 2, [hl]
	xor a
	ld [wCheckFor180DegreeTurn], a
	ld a, [wPlayerDirection]
	ld [wPlayerMovingDirection], a
	call NewBattle
	jp c, .battleOccurred
	jp OverworldLoop

.noDirectionChange
	ld a, [wPlayerDirection] ; current direction
	ld [wPlayerMovingDirection], a ; save direction
	call UpdateSprites
	ld a, [wWalkBikeSurfState]
	cp $02 ; surfing
	jr z, .surfing
; not surfing
	call CollisionCheckOnLand
	jr nc, .noCollision
; collision occurred
	push hl
	ld hl, wd736
	bit 2, [hl] ; standing on warp flag
	pop hl
	jp z, OverworldLoop
; collision occurred while standing on a warp
	push hl
	call ExtraWarpCheck ; sets carry if there is a potential to warp
	pop hl
	jp c, CheckWarpsCollision
	jp OverworldLoop

.surfing
	call CollisionCheckOnWater
	jp c, OverworldLoop

.noCollision
	ld a, $08
	ld [wWalkCounter], a
	callab Func_fcc08
	jr .moveAhead2

.moveAhead
	call IsSpinning
	call UpdateSprites

.moveAhead2
	ld hl, wFlags_0xcd60
	res 2, [hl]
	xor a
	ld [wd435], a
	call DoBikeSpeedup
	call AdvancePlayerSprite
	ld a, [wWalkCounter]
	and a
	jp nz, CheckMapConnections ; it seems like this check will never succeed (the other place where CheckMapConnections is run works)
; walking animation finished
	call StepCountCheck
	CheckEvent EVENT_IN_SAFARI_ZONE ; in the safari zone?
	jr z, .notSafariZone
	callba SafariZoneCheckSteps
	ld a, [wSafariZoneGameOver]
	and a
	jp nz, WarpFound2
.notSafariZone
	ld a, [wIsInBattle]
	and a
	jp nz, CheckWarpsNoCollision
	predef ApplyOutOfBattlePoisonDamage ; also increment daycare mon exp
	ld a, [wOutOfBattleBlackout]
	and a
	jp nz, HandleBlackOut ; if all pokemon fainted
.newBattle
	call NewBattle
	ld hl, wd736
	res 2, [hl] ; standing on warp flag
	jp nc, CheckWarpsNoCollision ; check for warps if there was no battle
.battleOccurred
	ld hl, wd72d
	res 6, [hl]
	ld hl, wFlags_D733
	res 3, [hl]
	ld hl, wCurrentMapScriptFlags
	set 5, [hl]
	set 6, [hl]
	xor a
	ld [hJoyHeld], a
	ld a, [wCurMap]
	cp CINNABAR_GYM
	jr nz, .notCinnabarGym
	SetEvent EVENT_2A7
.notCinnabarGym
	ld hl, wd72e
	set 5, [hl]
	ld a, [wCurMap]
	cp OAKS_LAB
	jp z, .noFaintCheck ; no blacking out if the player lost to the rival in Oak's lab
	callab AnyPartyAlive
	ld a, d
	and a
	jr z, AllPokemonFainted
.noFaintCheck
	ld c, 10
	call DelayFrames
	jp EnterMap

StepCountCheck::
	ld a, [wd730]
	bit 7, a
	jr nz, .doneStepCounting ; if button presses are being simulated, don't count steps
; step counting
	ld hl, wStepCounter
	dec [hl]
	ld a, [wd72c]
	bit 0, a
	jr z, .doneStepCounting
	ld hl, wNumberOfNoRandomBattleStepsLeft
	dec [hl]
	jr nz, .doneStepCounting
	ld hl, wd72c
	res 0, [hl] ; indicate that the player has stepped thrice since the last battle
.doneStepCounting
	ret

AllPokemonFainted::
	ld a, $ff
	ld [wIsInBattle], a
	call RunMapScript
	jp HandleBlackOut

; function to determine if there will be a battle and execute it (either a trainer battle or wild battle)
; sets carry if a battle occurred and unsets carry if not
NewBattle::
	ld a, [wd72d]
	bit 4, a
	jr nz, .noBattle
	call IsPlayerCharacterBeingControlledByGame
	jr nz, .noBattle ; no battle if the player character is under the game's control
	ld a, [wd72e]
	bit 4, a
	jr nz, .noBattle
	jpba InitBattle
.noBattle
	and a
	ret

; function to make bikes twice as fast as walking
DoBikeSpeedup::
	ld a, [wWalkBikeSurfState]
	dec a ; riding a bike?
	ret nz
	ld a, [wd736]
	bit 6, a
	ret nz
	ld a, [wNPCMovementScriptPointerTableNum]
	and a
	ret nz
	ld a, [wCurMap]
	cp ROUTE_17 ; Cycling Road
	jr nz, .goFaster
	ld a, [hJoyHeld]
	and D_UP | D_LEFT | D_RIGHT
	ret nz
.goFaster
	call AdvancePlayerSprite
	ret

; check if the player has stepped onto a warp after having not collided
CheckWarpsNoCollision::
	ld a, [wNumberOfWarps]
	and a
	jp z, CheckMapConnections
	ld b, 0
	ld a, [wNumberOfWarps]
	ld c, a
	ld a, [wYCoord]
	ld d, a
	ld a, [wXCoord]
	ld e, a
	ld hl, wWarpEntries
CheckWarpsNoCollisionLoop::
	ld a, [hli] ; check if the warp's Y position matches
	cp d
	jr nz, CheckWarpsNoCollisionRetry1
	ld a, [hli] ; check if the warp's X position matches
	cp e
	jr nz, CheckWarpsNoCollisionRetry2
; if a match was found
	push hl
	push bc
	ld hl, wd736
	set 2, [hl] ; standing on warp flag
	callba IsPlayerStandingOnDoorTileOrWarpTile
	pop bc
	pop hl
	jr c, WarpFound1 ; jump if standing on door or warp
	push hl
	push bc
	call ExtraWarpCheck
	pop bc
	pop hl
	jr nc, CheckWarpsNoCollisionRetry2
; if the extra check passed
	ld a, [wFlags_D733]
	bit 2, a
	jr nz, WarpFound1
	push de
	push bc
	call Joypad
	pop bc
	pop de
	ld a, [hJoyHeld]
	and D_DOWN | D_UP | D_LEFT | D_RIGHT
	jr z, CheckWarpsNoCollisionRetry2 ; if directional buttons aren't being pressed, do not pass through the warp
	jr WarpFound1

CheckWarpsNoCollisionRetry1::
	inc hl
CheckWarpsNoCollisionRetry2::
	inc hl
	inc hl
ContinueCheckWarpsNoCollisionLoop::
	inc b ; increment warp number
	dec c ; decrement number of warps
	jp nz, CheckWarpsNoCollisionLoop
	jp CheckMapConnections

; check if the player has stepped onto a warp after having collided
CheckWarpsCollision::
	ld a, [wNumberOfWarps]
	ld c, a
	ld hl, wWarpEntries
.loop
	ld a, [hli] ; Y coordinate of warp
	ld b, a
	ld a, [wYCoord]
	cp b
	jr nz, .retry1
	ld a, [hli] ; X coordinate of warp
	ld b, a
	ld a, [wXCoord]
	cp b
	jr nz, .retry2
	ld a, [hli]
	ld [wDestinationWarpID], a
	ld a, [hl]
	ld [hWarpDestinationMap], a
	jr WarpFound2
.retry1
	inc hl
.retry2
	inc hl
	inc hl
	dec c
	jr nz, .loop
	jp OverworldLoop

WarpFound1::
	ld a, [hli]
	ld [wDestinationWarpID], a
	ld a, [hli]
	ld [hWarpDestinationMap], a

WarpFound2::
	ld a, [wNumberOfWarps]
	sub c
	ld [wWarpedFromWhichWarp], a ; save ID of used warp
	ld a, [wCurMap]
	ld [wWarpedFromWhichMap], a
	call CheckIfInOutsideMap
	jr nz, .indoorMaps
; this is for handling "outside" maps that can't have the 0xFF destination map
	ld a, [wCurMap]
	ld [wLastMap], a
	ld a, [wCurMapWidth]
	ld [wUnusedD366], a ; not read
	ld a, [hWarpDestinationMap]
	ld [wCurMap], a
	cp ROCK_TUNNEL_1
	jr nz, .notRockTunnel
	ld a, $06
	ld [wMapPalOffset], a
	call GBFadeOutToBlack
.notRockTunnel
	callab CalculatePikachuSpawnState1
	call PlayMapChangeSound
	jr .done

; for maps that can have the 0xFF destination map, which means to return to the outside map
; not all these maps are necessarily indoors, though
.indoorMaps
	ld a, [hWarpDestinationMap] ; destination map
	cp $ff
	jr z, .goBackOutside
; if not going back to the previous map
	ld [wCurMap], a
	callba IsPlayerStandingOnWarpPadOrHole
	ld a, [wStandingOnWarpPadOrHole]
	dec a ; is the player on a warp pad?
	jr nz, .notWarpPad
; if the player is on a warp pad
	call LeaveMapAnim
	ld hl, wd732
	set 3, [hl]
	jr .skipMapChangeSound
.notWarpPad
	call PlayMapChangeSound
.skipMapChangeSound
	ld hl, wd736
	res 0, [hl]
	res 1, [hl]
	callab CalculatePikachuSpawnState2
	jr .done

.goBackOutside
	callab CalculatePikachuSpawnState3
	ld a, [wLastMap]
	ld [wCurMap], a
	call PlayMapChangeSound
	xor a
	ld [wMapPalOffset], a
.done
	ld hl, wd736
	set 0, [hl] ; have the player's sprite step out from the door (if there is one)
	call IgnoreInputForHalfSecond
	jp EnterMap

; if no matching warp was found
CheckMapConnections::
.checkWestMap
	ld a, [wXCoord]
	cp $ff
	jr nz, .checkEastMap
	ld a, [wMapConn3Ptr]
	ld [wCurMap], a
	ld a, [wWestConnectedMapXAlignment] ; new X coordinate upon entering west map
	ld [wXCoord], a
	ld a, [wYCoord]
	ld c, a
	ld a, [wWestConnectedMapYAlignment] ; Y adjustment upon entering west map
	add c
	ld c, a
	ld [wYCoord], a
	ld a, [wWestConnectedMapViewPointer] ; pointer to upper left corner of map without adjustment for Y position
	ld l, a
	ld a, [wWestConnectedMapViewPointer + 1]
	ld h, a
	srl c
	jr z, .savePointer1
.pointerAdjustmentLoop1
	ld a, [wWestConnectedMapWidth] ; width of connected map
	add MAP_BORDER * 2
	ld e, a
	ld d, 0
	ld b, 0
	add hl, de
	dec c
	jr nz, .pointerAdjustmentLoop1
.savePointer1
	ld a, l
	ld [wCurrentTileBlockMapViewPointer], a ; pointer to upper left corner of current tile block map section
	ld a, h
	ld [wCurrentTileBlockMapViewPointer + 1], a
	jp .loadNewMap

.checkEastMap
	ld b, a
	ld a, [wCurrentMapWidth2] ; map width
	cp b
	jr nz, .checkNorthMap
	ld a, [wMapConn4Ptr]
	ld [wCurMap], a
	ld a, [wEastConnectedMapXAlignment] ; new X coordinate upon entering east map
	ld [wXCoord], a
	ld a, [wYCoord]
	ld c, a
	ld a, [wEastConnectedMapYAlignment] ; Y adjustment upon entering east map
	add c
	ld c, a
	ld [wYCoord], a
	ld a, [wEastConnectedMapViewPointer] ; pointer to upper left corner of map without adjustment for Y position
	ld l, a
	ld a, [wEastConnectedMapViewPointer + 1]
	ld h, a
	srl c
	jr z, .savePointer2
.pointerAdjustmentLoop2
	ld a, [wEastConnectedMapWidth]
	add MAP_BORDER * 2
	ld e, a
	ld d, 0
	ld b, 0
	add hl, de
	dec c
	jr nz, .pointerAdjustmentLoop2
.savePointer2
	ld a, l
	ld [wCurrentTileBlockMapViewPointer], a ; pointer to upper left corner of current tile block map section
	ld a, h
	ld [wCurrentTileBlockMapViewPointer + 1], a
	jp .loadNewMap

.checkNorthMap
	ld a, [wYCoord]
	cp $ff
	jr nz, .checkSouthMap
	ld a, [wMapConn1Ptr]
	ld [wCurMap], a
	ld a, [wNorthConnectedMapYAlignment] ; new Y coordinate upon entering north map
	ld [wYCoord], a
	ld a, [wXCoord]
	ld c, a
	ld a, [wNorthConnectedMapXAlignment] ; X adjustment upon entering north map
	add c
	ld c, a
	ld [wXCoord], a
	ld a, [wNorthConnectedMapViewPointer] ; pointer to upper left corner of map without adjustment for X position
	ld l, a
	ld a, [wNorthConnectedMapViewPointer + 1]
	ld h, a
	ld b, 0
	srl c
	add hl, bc
	ld a, l
	ld [wCurrentTileBlockMapViewPointer], a ; pointer to upper left corner of current tile block map section
	ld a, h
	ld [wCurrentTileBlockMapViewPointer + 1], a
	jp .loadNewMap

.checkSouthMap
	ld b, a
	ld a, [wCurrentMapHeight2]
	cp b
	jr nz, .didNotEnterConnectedMap
	ld a, [wMapConn2Ptr]
	ld [wCurMap], a
	ld a, [wSouthConnectedMapYAlignment] ; new Y coordinate upon entering south map
	ld [wYCoord], a
	ld a, [wXCoord]
	ld c, a
	ld a, [wSouthConnectedMapXAlignment] ; X adjustment upon entering south map
	add c
	ld c, a
	ld [wXCoord], a
	ld a, [wSouthConnectedMapViewPointer] ; pointer to upper left corner of map without adjustment for X position
	ld l, a
	ld a, [wSouthConnectedMapViewPointer + 1]
	ld h, a
	ld b, 0
	srl c
	add hl, bc
	ld a, l
	ld [wCurrentTileBlockMapViewPointer], a ; pointer to upper left corner of current tile block map section
	ld a, h
	ld [wCurrentTileBlockMapViewPointer + 1], a
.loadNewMap ; load the connected map that was entered
	ld hl, wPikachuOverworldStateFlags
	set 4, [hl]
	ld a, $2
	ld [wPikachuSpawnState], a
	call LoadMapHeader
	call PlayDefaultMusicFadeOutCurrent
	ld b, SET_PAL_OVERWORLD
	call RunPaletteCommand
; Since the sprite set shouldn't change, this will just update VRAM slots at
; $C2XE without loading any tile patterns.
	call InitMapSprites
	call LoadTileBlockMap
	jp OverworldLoopLessDelay

.didNotEnterConnectedMap
	jp OverworldLoop

; function to play a sound when changing maps
PlayMapChangeSound::
	ld a, [wCurMapTileset]
	cp FACILITY
	jr z, .didNotGoThroughDoor
	cp CEMETERY
	jr z, .didNotGoThroughDoor
	aCoord 8, 8 ; upper left tile of the 4x4 square the player's sprite is standing on
	cp $0b ; door tile in tileset 0
	jr nz, .didNotGoThroughDoor
	ld a, SFX_GO_INSIDE
	jr .playSound
.didNotGoThroughDoor
	ld a, SFX_GO_OUTSIDE
.playSound
	call PlaySound
	ld a, [wMapPalOffset]
	and a
	ret nz
	jp GBFadeOutToBlack

CheckIfInOutsideMap::
; If the player is in an outside map (a town or route), set the z flag
	ld a, [wCurMapTileset]
	and a ; most towns/routes have tileset 0 (OVERWORLD)
	ret z
	cp PLATEAU ; Route 23 / Indigo Plateau
	ret

; this function is an extra check that sometimes has to pass in order to warp, beyond just standing on a warp
; the "sometimes" qualification is necessary because of CheckWarpsNoCollision's behavior
; depending on the map, either "function 1" or "function 2" is used for the check
; "function 1" passes when the player is at the edge of the map and is facing towards the outside of the map
; "function 2" passes when the the tile in front of the player is among a certain set
; sets carry if the check passes, otherwise clears carry
ExtraWarpCheck::
	ld a, [wCurMap]
	cp SS_ANNE_3
	jr z, .useFunction1
	cp ROCKET_HIDEOUT_1
	jr z, .useFunction2
	cp ROCKET_HIDEOUT_2
	jr z, .useFunction2
	cp ROCKET_HIDEOUT_4
	jr z, .useFunction2
	cp ROCK_TUNNEL_1
	jr z, .useFunction2
	ld a, [wCurMapTileset]
	and a ; outside tileset (OVERWORLD)
	jr z, .useFunction2
	cp SHIP ; S.S. Anne tileset
	jr z, .useFunction2
	cp SHIP_PORT ; Vermilion Port tileset
	jr z, .useFunction2
	cp PLATEAU ; Indigo Plateau tileset
	jr z, .useFunction2
.useFunction1
	ld hl, IsPlayerFacingEdgeOfMap
	jr .doBankswitch
.useFunction2
	ld hl, IsWarpTileInFrontOfPlayer
.doBankswitch
	ld b, BANK(IsWarpTileInFrontOfPlayer)
	jp Bankswitch

MapEntryAfterBattle::
	callba IsPlayerStandingOnWarp ; for enabling warp testing after collisions
	ld a, [wMapPalOffset]
	and a
	jp z, GBFadeInFromWhite
	jp LoadGBPal

HandleBlackOut::
; For when all the player's pokemon faint.
; Does not print the "blacked out" message.

	call GBFadeOutToBlack
	ld a, $08
	call StopMusic
	ld hl, wd72e
	res 5, [hl]
	switchbank SpecialWarpIn ; also Bank(SpecialEnterMap)
	callab ResetStatusAndHalveMoneyOnBlackout
	call SpecialWarpIn
	call PlayDefaultMusicFadeOutCurrent
	jp SpecialEnterMap

StopMusic::
	ld [wAudioFadeOutControl], a
	call StopAllMusic
.wait
	ld a, [wAudioFadeOutControl]
	and a
	jr nz, .wait
	jp StopAllSounds

HandleFlyWarpOrDungeonWarp::
	call UpdateSprites
	call Delay3
	xor a
	ld [wBattleResult], a
	ld [wIsInBattle], a
	ld [wMapPalOffset], a
	ld hl, wd732
	set 2, [hl] ; fly warp or dungeon warp
	res 5, [hl] ; forced to ride bike
	call LeaveMapAnim
	call Func_07c4
	callbs SpecialWarpIn
	jp SpecialEnterMap

LeaveMapAnim::
	jpba _LeaveMapAnim

Func_07c4::
	ld a, [wWalkBikeSurfState]
	and a
	ret z
	xor a
	ld [wWalkBikeSurfState], a
	ld hl, wd732
	bit 4, [hl]
	ret z
	call PlayDefaultMusic
	ret

LoadPlayerSpriteGraphics::
; Load sprite graphics based on whether the player is standing, biking, or surfing.

	; 0: standing
	; 1: biking
	; 2: surfing

	ld a, [wWalkBikeSurfState]
	dec a
	jr z, .ridingBike

	ld a, [hTilesetType]
	and a
	jr nz, .determineGraphics
	jr .startWalking

.ridingBike
	; If the bike can't be used,
	; start walking instead.
	call IsBikeRidingAllowed
	jr c, .determineGraphics

.startWalking
	xor a
	ld [wWalkBikeSurfState], a
	ld [wWalkBikeSurfStateCopy], a
	jp LoadWalkingPlayerSpriteGraphics

.determineGraphics
	ld a, [wWalkBikeSurfState]
	and a
	jp z, LoadWalkingPlayerSpriteGraphics
	dec a
	jp z, LoadBikePlayerSpriteGraphics
	dec a
	jp z, LoadSurfingPlayerSpriteGraphics2
	jp LoadWalkingPlayerSpriteGraphics

IsBikeRidingAllowed::
; The bike can be used on Route 23 and Indigo Plateau,
; or maps with tilesets in BikeRidingTilesets.
; Return carry if biking is allowed.

	ld a, [wCurMap]
	cp ROUTE_23
	jr z, .allowed
	cp INDIGO_PLATEAU
	jr z, .allowed

	ld a, [wCurMapTileset]
	ld b, a
	ld hl, BikeRidingTilesets
.loop
	ld a, [hli]
	cp b
	jr z, .allowed
	inc a
	jr nz, .loop
	and a
	ret

.allowed
	scf
	ret

INCLUDE "data/bike_riding_tilesets.asm"

; load the tile pattern data of the current tileset into VRAM
LoadTilesetTilePatternData::
	ld a, [wTilesetGfxPtr]
	ld l, a
	ld a, [wTilesetGfxPtr + 1]
	ld h, a
	ld de, vTileset
	ld bc, $600
	ld a, [wTilesetBank]
	jp FarCopyData

; this loads the current maps complete tile map (which references blocks, not individual tiles) to C6E8
; it can also load partial tile maps of connected maps into a border of length 3 around the current map
LoadTileBlockMap::
; fill C6E8-CBFB with the background tile
	ld hl, wOverworldMap
	ld bc, $0514
	ld a, [wMapBackgroundTile] ; background tile number
	call FillMemory
; load tile map of current map (made of tile block IDs)
; a 3-byte border at the edges of the map is kept so that there is space for map connections
	ld hl, wOverworldMap
	ld a, [wCurMapWidth]
	ld [hMapWidth], a
	add MAP_BORDER * 2 ; east and west
	ld [hMapStride], a ; map width + border
	ld b, 0
	ld c, a
; make space for north border (next 3 lines)
	add hl, bc
	add hl, bc
	add hl, bc
	ld c, MAP_BORDER
	add hl, bc ; this puts us past the (west) border
	ld a, [wMapDataPtr] ; tile map pointer
	ld e, a
	ld a, [wMapDataPtr + 1]
	ld d, a ; de = tile map pointer
	ld a, [wCurMapHeight]
	ld b, a
.rowLoop ; copy one row each iteration
	push hl
	ld a, [hMapWidth] ; map width (without border)
	ld c, a
.rowInnerLoop
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .rowInnerLoop
; add the map width plus the border to the base address of the current row to get the next row's address
	pop hl
	ld a, [hMapStride] ; map width + border
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	dec b
	jr nz, .rowLoop
.northConnection
	ld a, [wMapConn1Ptr]
	cp $ff
	jr z, .southConnection
	call SwitchToMapRomBank
	ld a, [wNorthConnectionStripSrc]
	ld l, a
	ld a, [wNorthConnectionStripSrc + 1]
	ld h, a
	ld a, [wNorthConnectionStripDest]
	ld e, a
	ld a, [wNorthConnectionStripDest + 1]
	ld d, a
	ld a, [wNorthConnectionStripWidth]
	ld [hNorthSouthConnectionStripWidth], a
	ld a, [wNorthConnectedMapWidth]
	ld [hNorthSouthConnectedMapWidth], a
	call LoadNorthSouthConnectionsTileMap
.southConnection
	ld a, [wMapConn2Ptr]
	cp $ff
	jr z, .westConnection
	call SwitchToMapRomBank
	ld a, [wSouthConnectionStripSrc]
	ld l, a
	ld a, [wSouthConnectionStripSrc + 1]
	ld h, a
	ld a, [wSouthConnectionStripDest]
	ld e, a
	ld a, [wSouthConnectionStripDest + 1]
	ld d, a
	ld a, [wSouthConnectionStripWidth]
	ld [hNorthSouthConnectionStripWidth], a
	ld a, [wSouthConnectedMapWidth]
	ld [hNorthSouthConnectedMapWidth], a
	call LoadNorthSouthConnectionsTileMap
.westConnection
	ld a, [wMapConn3Ptr]
	cp $ff
	jr z, .eastConnection
	call SwitchToMapRomBank
	ld a, [wWestConnectionStripSrc]
	ld l, a
	ld a, [wWestConnectionStripSrc + 1]
	ld h, a
	ld a, [wWestConnectionStripDest]
	ld e, a
	ld a, [wWestConnectionStripDest + 1]
	ld d, a
	ld a, [wWestConnectionStripHeight]
	ld b, a
	ld a, [wWestConnectedMapWidth]
	ld [hEastWestConnectedMapWidth], a
	call LoadEastWestConnectionsTileMap
.eastConnection
	ld a, [wMapConn4Ptr]
	cp $ff
	jr z, .done
	call SwitchToMapRomBank
	ld a, [wEastConnectionStripSrc]
	ld l, a
	ld a, [wEastConnectionStripSrc + 1]
	ld h, a
	ld a, [wEastConnectionStripDest]
	ld e, a
	ld a, [wEastConnectionStripDest + 1]
	ld d, a
	ld a, [wEastConnectionStripHeight]
	ld b, a
	ld a, [wEastConnectedMapWidth]
	ld [hEastWestConnectedMapWidth], a
	call LoadEastWestConnectionsTileMap
.done
	ret

LoadNorthSouthConnectionsTileMap::
	ld c, MAP_BORDER
.loop
	push de
	push hl
	ld a, [hNorthSouthConnectionStripWidth]
	ld b, a
.innerLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .innerLoop
	pop hl
	pop de
	ld a, [hNorthSouthConnectedMapWidth]
	add l
	ld l, a
	jr nc, .noCarry1
	inc h
.noCarry1
	ld a, [wCurMapWidth]
	add MAP_BORDER * 2
	add e
	ld e, a
	jr nc, .noCarry2
	inc d
.noCarry2
	dec c
	jr nz, .loop
	ret

LoadEastWestConnectionsTileMap::
	push hl
	push de
	ld c, MAP_BORDER
.innerLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .innerLoop
	pop de
	pop hl
	ld a, [hEastWestConnectedMapWidth]
	add l
	ld l, a
	jr nc, .noCarry1
	inc h
.noCarry1
	ld a, [wCurMapWidth]
	add MAP_BORDER * 2
	add e
	ld e, a
	jr nc, .noCarry2
	inc d
.noCarry2
	dec b
	jr nz, LoadEastWestConnectionsTileMap
	ret

; function to check if there is a sign or sprite in front of the player
; if so, carry is set. otherwise, carry is cleared
IsSpriteOrSignInFrontOfPlayer::
	xor a
	ld [hSpriteIndexOrTextID], a
	ld a, [wNumSigns]
	and a
	jr z, .extendRangeOverCounter
; if there are signs
	predef GetTileAndCoordsInFrontOfPlayer ; get the coordinates in front of the player in de
	call SignLoop
	ret c
.extendRangeOverCounter
; check if the player is front of a counter in a pokemon center, pokemart, etc. and if so, extend the range at which he can talk to the NPC
	predef GetTileAndCoordsInFrontOfPlayer ; get the tile in front of the player in c
	ld hl, wTilesetTalkingOverTiles ; list of tiles that extend talking range (counter tiles)
	ld b, 3
	ld d, $20 ; talking range in pixels (long range)
.counterTilesLoop
	ld a, [hli]
	cp c
	jr z, IsSpriteInFrontOfPlayer2 ; jumps if the tile in front of the player is a counter tile
	dec b
	jr nz, .counterTilesLoop

; sets carry flag if a sprite is in front of the player, resets if not
IsSpriteInFrontOfPlayer::
	ld d, $10 ; talking range in pixels (normal range)
IsSpriteInFrontOfPlayer2::
	lb bc, $3c, $40 ; Y and X position of player sprite
	ld a, [wPlayerFacingDirection] ; direction the player is facing
.checkIfPlayerFacingUp
	cp SPRITE_FACING_UP
	jr nz, .checkIfPlayerFacingDown
; facing up
	ld a, b
	sub d
	ld b, a
	ld a, PLAYER_DIR_UP
	jr .doneCheckingDirection

.checkIfPlayerFacingDown
	cp SPRITE_FACING_DOWN
	jr nz, .checkIfPlayerFacingRight
; facing down
	ld a, b
	add d
	ld b, a
	ld a, PLAYER_DIR_DOWN
	jr .doneCheckingDirection

.checkIfPlayerFacingRight
	cp SPRITE_FACING_RIGHT
	jr nz, .playerFacingLeft
; facing right
	ld a, c
	add d
	ld c, a
	ld a, PLAYER_DIR_RIGHT
	jr .doneCheckingDirection

.playerFacingLeft
; facing left
	ld a, c
	sub d
	ld c, a
	ld a, PLAYER_DIR_LEFT
.doneCheckingDirection
	ld [wPlayerDirection], a
	ld hl, wSpriteStateData1 + $10
; yellow does not have the "if sprites are existant" check
	ld e, $01
	ld d, $f
.spriteLoop
	push hl
	ld a, [hli] ; image (0 if no sprite)
	and a
	jr z, .nextSprite
	inc l
	ld a, [hli] ; sprite visibility
	inc a
	jr z, .nextSprite
	inc l
	ld a, [hli] ; Y location
	cp b
	jr nz, .nextSprite
	inc l
	ld a, [hl] ; X location
	cp c
	jr z, .foundSpriteInFrontOfPlayer
.nextSprite
	pop hl
	ld a, l
	add $10
	ld l, a
	inc e
	dec d
	jr nz, .spriteLoop
	xor a
	ret

.foundSpriteInFrontOfPlayer
	pop hl
	ld a, l
	and $f0
	inc a
	ld l, a ; hl = $c1x1
	set 7, [hl] ; set flag to make the sprite face the player
	ld a, e
	ld [hSpriteIndexOrTextID], a
	ld a, [hSpriteIndexOrTextID] ; possible useless read because a already has the value of the read address
	cp $f
	jr nz, .dontwritetowd436
	ld a, $FF
	ld [wd436], a
.dontwritetowd436
	scf
	ret

SignLoop::
; search if a player is facing a sign
	ld hl, wSignCoords ; start of sign coordinates
	ld a, [wNumSigns] ; number of signs in the map
	ld b, a
	ld c, $00
.signLoop
	inc c
	ld a, [hli] ; sign Y
	cp d
	jr z, .yCoordMatched
	inc hl
	jr .retry

.yCoordMatched
	ld a, [hli] ; sign X
	cp e
	jr nz, .retry
.xCoordMatched
; found sign
	push hl
	push bc
	ld hl, wSignTextIDs ; start of sign text ID's
	ld b, $00
	dec c
	add hl, bc
	ld a, [hl]
	ld [hSpriteIndexOrTextID], a ; store sign text ID
	pop bc
	pop hl
	scf
	ret

.retry
	dec b
	jr nz, .signLoop
	xor a
	ret

; function to check if the player will jump down a ledge and check if the tile ahead is passable (when not surfing)
; sets the carry flag if there is a collision, and unsets it if there isn't a collision
CollisionCheckOnLand::
	ld a, [wd736]
	bit 6, a ; is the player jumping?
	jr nz, .noCollision
; if not jumping a ledge
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	jr nz, .noCollision ; no collisions when the player's movements are being controlled by the game
	ld a, [wPlayerDirection] ; the direction that the player is trying to go in
	ld d, a
	ld a, [wSpriteStateData1 + 12] ; the player sprite's collision data (bit field) (set in the sprite movement code)
	and d ; check if a sprite is in the direction the player is trying to go
	nop ; ??? why is this in the code
	jr nz, .collision
	xor a
	ld [hSpriteIndexOrTextID], a
	call IsSpriteInFrontOfPlayer ; check for sprite collisions again? when does the above check fail to detect a sprite collision?
	jr nc, .asm_0a5c
	res 7, [hl]
	ld a, [hSpriteIndexOrTextID]
	and a ; was there a sprite collision?
	jr z, .asm_0a5c
; if no sprite collision
	cp $f
	jr nz, .collision
	call CheckPikachuFollowingPlayer
	jr nz, .collision
	ld a, [hJoyHeld]
	and $2
	jr nz, .asm_0a5c
	ld hl, wd435
	ld a, [hl]
	and a
	jr z, .asm_0a5c
	dec [hl]
	jr nz, .collision
.asm_0a5c
	ld hl, TilePairCollisionsLand
	call CheckForJumpingAndTilePairCollisions
	jr c, .collision
	call CheckTilePassable
	jr nc, .noCollision
.collision
	ld a, [wChannelSoundIDs + CH4]
	cp SFX_COLLISION ; check if collision sound is already playing
	jr z, .setCarry
	ld a, SFX_COLLISION
	call PlaySound ; play collision sound (if it's not already playing)
.setCarry
	scf
	ret
.noCollision
	and a
	ret

; function that checks if the tile in front of the player is passable
; clears carry if it is, sets carry if not
CheckTilePassable::
	predef GetTileAndCoordsInFrontOfPlayer ; get tile in front of player
	ld a, [wTileInFrontOfPlayer] ; tile in front of player
	ld c, a
	call IsTilePassable
	ret

; check if the player is going to jump down a small ledge
; and check for collisions that only occur between certain pairs of tiles
; Input: hl - address of directional collision data
; sets carry if there is a collision and unsets carry if not
CheckForJumpingAndTilePairCollisions::
	push hl
	predef GetTileAndCoordsInFrontOfPlayer ; get the tile in front of the player
	push de
	push bc
	callba HandleLedges	; check if the player is trying to jump a ledge
	pop bc
	pop de
	pop hl
	and a
	ld a, [wd736]
	bit 6, a ; is the player jumping?
	ret nz
; if not jumping

CheckForTilePairCollisions2::
	aCoord 8, 9 ; tile the player is on
	ld [wTilePlayerStandingOn], a

CheckForTilePairCollisions::
	ld a, [wTileInFrontOfPlayer]
	ld c, a
.tilePairCollisionLoop
	ld a, [wCurMapTileset] ; tileset number
	ld b, a
	ld a, [hli]
	cp $ff
	jr z, .noMatch
	cp b
	jr z, .tilesetMatches
	inc hl
.retry
	inc hl
	jr .tilePairCollisionLoop
.tilesetMatches
	ld a, [wTilePlayerStandingOn] ; tile the player is on
	ld b, a
	ld a, [hl]
	cp b
	jr z, .currentTileMatchesFirstInPair
	inc hl
	ld a, [hl]
	cp b
	jr z, .currentTileMatchesSecondInPair
	jr .retry
.currentTileMatchesFirstInPair
	inc hl
	ld a, [hl]
	cp c
	jr z, .foundMatch
	jr .tilePairCollisionLoop
.currentTileMatchesSecondInPair
	dec hl
	ld a, [hli]
	cp c
	inc hl
	jr nz, .tilePairCollisionLoop
.foundMatch
	scf
	ret
.noMatch
	and a
	ret

; FORMAT: tileset number, tile 1, tile 2
; terminated by 0xFF
; these entries indicate that the player may not cross between tile 1 and tile 2
; it's mainly used to simulate differences in elevation

TilePairCollisionsLand::
	db CAVERN, $20, $05
	db CAVERN, $41, $05
	db FOREST, $30, $2E
	db CAVERN, $2A, $05
	db CAVERN, $05, $21
	db FOREST, $52, $2E
	db FOREST, $55, $2E
	db FOREST, $56, $2E
	db FOREST, $20, $2E
	db FOREST, $5E, $2E
	db FOREST, $5F, $2E
	db $FF

TilePairCollisionsWater::
	db FOREST, $14, $2E
	db FOREST, $48, $2E
	db CAVERN, $14, $05
	db $FF

; this builds a tile map from the tile block map based on the current X/Y coordinates of the player's character
LoadCurrentMapView::
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, [wTilesetBank] ; tile data ROM bank
	call BankswitchCommon ; switch to ROM bank that contains tile data
	ld a, [wCurrentTileBlockMapViewPointer] ; address of upper left corner of current map view
	ld e, a
	ld a, [wCurrentTileBlockMapViewPointer + 1]
	ld d, a
	ld hl, wTileMapBackup
	ld b, $05
.rowLoop ; each loop iteration fills in one row of tile blocks
	push hl
	push de
	ld c, $06
.rowInnerLoop ; loop to draw each tile block of the current row
	push bc
	push de
	push hl
	ld a, [de]
	ld c, a ; tile block number
	call DrawTileBlock
	pop hl
	pop de
	pop bc
	inc hl
	inc hl
	inc hl
	inc hl
	inc de
	dec c
	jr nz, .rowInnerLoop
; update tile block map pointer to next row's address
	pop de
	ld a, [wCurMapWidth]
	add MAP_BORDER * 2
	add e
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
; update tile map pointer to next row's address
	pop hl
	ld a, $60
	add l
	ld l, a
	jr nc, .noCarry2
	inc h
.noCarry2
	dec b
	jr nz, .rowLoop
	ld hl, wTileMapBackup
	ld bc, $0000
.adjustForYCoordWithinTileBlock
	ld a, [wYBlockCoord]
	and a
	jr z, .adjustForXCoordWithinTileBlock
	ld bc, $0030
	add hl, bc
.adjustForXCoordWithinTileBlock
	ld a, [wXBlockCoord]
	and a
	jr z, .copyToVisibleAreaBuffer
	ld bc, $0002
	add hl, bc
.copyToVisibleAreaBuffer
	coord de, 0, 0 ; base address for the tiles that are directly transferred to VRAM during V-blank
	ld b, SCREEN_HEIGHT
.rowLoop2
	ld c, SCREEN_WIDTH
.rowInnerLoop2
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .rowInnerLoop2
	ld a, $04
	add l
	ld l, a
	jr nc, .noCarry3
	inc h
.noCarry3
	dec b
	jr nz, .rowLoop2
	pop af
	call BankswitchCommon ; restore previous ROM bank
	ret

AdvancePlayerSprite::
	ld a, [wUpdateSpritesEnabled]
	push af
	ld a, $FF
	ld [wUpdateSpritesEnabled], a
	ld hl, _AdvancePlayerSprite
	ld b, BANK(_AdvancePlayerSprite)
	call Bankswitch
	pop af
	ld [wUpdateSpritesEnabled], a
	ret

; the following 6 functions are used to tell the V-blank handler to redraw
; the portion of the map that was newly exposed due to the player's movement

ScheduleNorthRowRedraw::
	coord hl, 0, 0
	call CopyToRedrawRowOrColumnSrcTiles
	ld a, [wMapViewVRAMPointer]
	ld [hRedrawRowOrColumnDest], a
	ld a, [wMapViewVRAMPointer + 1]
	ld [hRedrawRowOrColumnDest + 1], a
	ld a, REDRAW_ROW
	ld [hRedrawRowOrColumnMode], a
	ret

CopyToRedrawRowOrColumnSrcTiles::
	ld de, wRedrawRowOrColumnSrcTiles
	ld c, 2 * SCREEN_WIDTH
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ret

ScheduleSouthRowRedraw::
	coord hl, 0, 16
	call CopyToRedrawRowOrColumnSrcTiles
	ld a, [wMapViewVRAMPointer]
	ld l, a
	ld a, [wMapViewVRAMPointer + 1]
	ld h, a
	ld bc, $0200
	add hl, bc
	ld a, h
	and $03
	or $98
	ld [hRedrawRowOrColumnDest + 1], a
	ld a, l
	ld [hRedrawRowOrColumnDest], a
	ld a, REDRAW_ROW
	ld [hRedrawRowOrColumnMode], a
	ret

ScheduleEastColumnRedraw::
	coord hl, 18, 0
	call ScheduleColumnRedrawHelper
	ld a, [wMapViewVRAMPointer]
	ld c, a
	and $e0
	ld b, a
	ld a, c
	add 18
	and $1f
	or b
	ld [hRedrawRowOrColumnDest], a
	ld a, [wMapViewVRAMPointer + 1]
	ld [hRedrawRowOrColumnDest + 1], a
	ld a, REDRAW_COL
	ld [hRedrawRowOrColumnMode], a
	ret

ScheduleColumnRedrawHelper::
	ld de, wRedrawRowOrColumnSrcTiles
	ld c, SCREEN_HEIGHT
.loop
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	ld a, 19
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	dec c
	jr nz, .loop
	ret

ScheduleWestColumnRedraw::
	coord hl, 0, 0
	call ScheduleColumnRedrawHelper
	ld a, [wMapViewVRAMPointer]
	ld [hRedrawRowOrColumnDest], a
	ld a, [wMapViewVRAMPointer + 1]
	ld [hRedrawRowOrColumnDest + 1], a
	ld a, REDRAW_COL
	ld [hRedrawRowOrColumnMode], a
	ret

; function to write the tiles that make up a tile block to memory
; Input: c = tile block ID, hl = destination address
DrawTileBlock::
	push hl
	ld a, [wTilesetBlocksPtr] ; pointer to tiles
	ld l, a
	ld a, [wTilesetBlocksPtr + 1]
	ld h, a
	ld a, c
	swap a
	ld b, a
	and $f0
	ld c, a
	ld a, b
	and $0f
	ld b, a ; bc = tile block ID * 0x10
	add hl, bc
	ld d, h
	ld e, l ; de = address of the tile block's tiles
	pop hl
	ld c, $04 ; 4 loop iterations
.loop ; each loop iteration, write 4 tile numbers
	push bc
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	inc de
	ld bc, $0015
	add hl, bc
	pop bc
	dec c
	jr nz, .loop
	ret

; function to update joypad state and simulate button presses
JoypadOverworld::
	xor a
	ld [wSpriteStateData1 + 3], a
	ld [wSpriteStateData1 + 5], a
	call RunMapScript
	call Joypad
	call ForceBikeDown
	call AreInputsSimulated
	ret

ForceBikeDown::
	ld a, [wFlags_D733]
	bit 3, a ; check if a trainer wants a challenge
	ret nz
	ld a, [wCurMap]
	cp ROUTE_17 ; Cycling Road
	ret nz
	ld a, [hJoyHeld]
	and D_DOWN | D_UP | D_LEFT | D_RIGHT | B_BUTTON | A_BUTTON
	ret nz
	ld a, D_DOWN
	ld [hJoyHeld], a ; on the cycling road, if there isn't a trainer and the player isn't pressing buttons, simulate a down press
	ret

AreInputsSimulated::
	ld a, [wd730]
	bit 7, a
	ret z
; if simulating button presses
	ld a, [hJoyHeld]
	ld b, a
	ld a, [wOverrideSimulatedJoypadStatesMask] ; bit mask for button presses that override simulated ones
	and b
	ret nz ; return if the simulated button presses are overridden
	call GetSimulatedInput
	jr nc, .doneSimulating
	ld [hJoyHeld], a ; store simulated button press in joypad state
	and a
	ret nz
	ld [hJoyPressed], a
	ld [hJoyReleased], a
	ret

; if done simulating button presses
.doneSimulating
	xor a
	ld [wWastedByteCD3A], a
	ld [wSimulatedJoypadStatesIndex], a
	ld [wSimulatedJoypadStatesEnd], a
	ld [wJoyIgnore], a
	ld [hJoyHeld], a
	ld hl, wd736
	ld a, [hl]
	and $f8
	ld [hl], a
	ld hl, wd730
	res 7, [hl]
	ret

GetSimulatedInput::
	ld hl, wSimulatedJoypadStatesIndex
	dec [hl]
	ld a, [hl]
	cp $ff
	jr z, .endofsimulatedinputs ; if the end of the simulated button presses has been reached
	push de
	ld e, a
	ld d, $0
	ld hl, wSimulatedJoypadStatesEnd
	add hl, de
	ld a, [hl]
	pop de
	scf
	ret

.endofsimulatedinputs
	and a
	ret


; function to check the tile ahead to determine if the character should get on land or keep surfing
; sets carry if there is a collision and clears carry otherwise
; This function had a bug in Red/Blue, but it was fixed in Yellow.
CollisionCheckOnWater::
	ld a, [wd730]
	bit 7, a
	jp nz, .noCollision ; return and clear carry if button presses are being simulated
	ld a, [wPlayerDirection] ; the direction that the player is trying to go in
	ld d, a
	ld a, [wSpriteStateData1 + 12] ; the player sprite's collision data (bit field) (set in the sprite movement code)
	and d ; check if a sprite is in the direction the player is trying to go
	jr nz, .collision
	ld hl, TilePairCollisionsWater
	call CheckForJumpingAndTilePairCollisions
	jr c, .collision
	predef GetTileAndCoordsInFrontOfPlayer ; get tile in front of player (puts it in c and [wTileInFrontOfPlayer])
	callab IsNextTileShoreOrWater
	jr c, .noCollision
	ld a, [wTileInFrontOfPlayer] ; tile in front of player
	ld c, a
	call IsTilePassable
	jr nc, .stopSurfing
.collision
	ld a, [wChannelSoundIDs + CH4]
	cp SFX_COLLISION ; check if collision sound is already playing
	jr z, .setCarry
	ld a, SFX_COLLISION
	call PlaySound ; play collision sound (if it's not already playing)
.setCarry
	scf
	jr .done

.checkIfVermilionDockTileset
	ld a, [wCurMapTileset] ; tileset
	cp SHIP_PORT ; Vermilion Dock tileset
	jr nz, .noCollision ; keep surfing if it's not the boarding platform tile
	jr .stopSurfing ; if it is the boarding platform tile, stop surfing
.stopSurfing ; based game freak
	ld a, $3
	ld [wPikachuSpawnState], a
	ld hl, wPikachuOverworldStateFlags
	set 5, [hl]
	xor a
	ld [wWalkBikeSurfState], a
	call LoadPlayerSpriteGraphics
	call PlayDefaultMusic
	jr .noCollision

.noCollision ; ...and they do the same mistake twice
	and a
.done
	ret

; function to run the current map's script
RunMapScript::
	push hl
	push de
	push bc
	callba TryPushingBoulder
	ld a, [wFlags_0xcd60]
	bit 1, a ; play boulder dust animation
	jr z, .afterBoulderEffect
	callba DoBoulderDustAnimation
.afterBoulderEffect
	pop bc
	pop de
	pop hl
	call RunNPCMovementScript
	ld a, [wCurMap] ; current map number
	call SwitchToMapRomBank ; change to the ROM bank the map's data is in
	ld hl, wMapScriptPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, .return
	push de
	jp hl ; jump to script
.return
	ret

LoadWalkingPlayerSpriteGraphics::
; new sprite copy stuff
	xor a
	ld [wd473], a
	ld b, BANK(RedSprite)
	ld de, RedSprite
	jr LoadPlayerSpriteGraphicsCommon

LoadSurfingPlayerSpriteGraphics2::
	ld a, [wd473]
	and a
	jr z, .asm_0d75
	dec a
	jr z, LoadSurfingPlayerSpriteGraphics
	dec a
	jr z, .asm_0d7c
.asm_0d75
	ld a, [wd472]
	bit 6, a
	jr z, LoadSurfingPlayerSpriteGraphics
.asm_0d7c
	ld b, BANK(SurfingPikachuSprite)
	ld de, SurfingPikachuSprite
	jr LoadPlayerSpriteGraphicsCommon

LoadSurfingPlayerSpriteGraphics::
	ld b, BANK(SeelSprite)
	ld de, SeelSprite
	jr LoadPlayerSpriteGraphicsCommon

LoadBikePlayerSpriteGraphics::
	ld b, BANK(RedCyclingSprite)
	ld de, RedCyclingSprite
LoadPlayerSpriteGraphicsCommon::
	ld hl, vNPCSprites
	push de
	push hl
	push bc
	ld c, $c
	call CopyVideoData
	pop bc
	pop hl
	pop de
	ld a, $c0
	add e
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
	set 3, h
	ld c, $c
	jp CopyVideoData

; function to load data from the map header
LoadMapHeader::
	callba MarkTownVisitedAndLoadMissableObjects
	jr asm_0dbd

Func_0db5:: ; XXX
	callba LoadUnusedBluesHouseMissableObjectData
asm_0dbd
	ld a, [wCurMapTileset]
	ld [wUnusedD119], a
	ld a, [wCurMap]
	call SwitchToMapRomBank
	ld a, [wCurMapTileset]
	ld b, a
	res 7, a
	ld [wCurMapTileset], a
	ld [hPreviousTileset], a
	bit 7, b
	ret nz
	call GetMapHeaderPointer
; copy the first 10 bytes (the fixed area) of the map data to D367-D370
	ld de, wCurMapTileset
	ld c, $0a
.copyFixedHeaderLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copyFixedHeaderLoop
; initialize all the connected maps to disabled at first, before loading the actual values
	ld a, $ff
	ld [wMapConn1Ptr], a
	ld [wMapConn2Ptr], a
	ld [wMapConn3Ptr], a
	ld [wMapConn4Ptr], a
; copy connection data (if any) to WRAM
	ld a, [wMapConnections]
	ld b, a
.checkNorth
	bit 3, b
	jr z, .checkSouth
	ld de, wMapConn1Ptr
	call CopyMapConnectionHeader
.checkSouth
	bit 2, b
	jr z, .checkWest
	ld de, wMapConn2Ptr
	call CopyMapConnectionHeader
.checkWest
	bit 1, b
	jr z, .checkEast
	ld de, wMapConn3Ptr
	call CopyMapConnectionHeader
.checkEast
	bit 0, b
	jr z, .getObjectDataPointer
	ld de, wMapConn4Ptr
	call CopyMapConnectionHeader
.getObjectDataPointer
	ld a, [hli]
	ld [wObjectDataPointerTemp], a
	ld a, [hli]
	ld [wObjectDataPointerTemp + 1], a
	push hl
	ld a, [wObjectDataPointerTemp]
	ld l, a
	ld a, [wObjectDataPointerTemp + 1]
	ld h, a ; hl = base of object data
	ld de, wMapBackgroundTile
	ld a, [hli]
	ld [de], a
.loadWarpData
	ld a, [hli]
	ld [wNumberOfWarps], a
	and a
	jr z, .loadSignData
	ld c, a
	ld de, wWarpEntries
.warpLoop ; one warp per loop iteration
	ld b, $04
.warpInnerLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .warpInnerLoop
	dec c
	jr nz, .warpLoop
.loadSignData
	ld a, [hli] ; number of signs
	ld [wNumSigns], a
	and a ; are there any signs?
	jr z, .loadSpriteData ; if not, skip this
	call CopySignData
.loadSpriteData
	ld a, [wd72e]
	bit 5, a ; did a battle happen immediately before this?
	jr nz, .finishUp ; if so, skip this because battles don't destroy this data
	call InitSprites
.finishUp
	predef LoadTilesetHeader
	ld a, [wd72e]
	bit 5, a ; did a battle happen immediately before this?
	jr nz, .skip_pika_spawn
	callab SchedulePikachuSpawnForAfterText
.skip_pika_spawn
	callab LoadWildData
	pop hl ; restore hl from before going to the warp/sign/sprite data (this value was saved for seemingly no purpose)
	ld a, [wCurMapHeight] ; map height in 4x4 tile blocks
	add a ; double it
	ld [wCurrentMapHeight2], a ; store map height in 2x2 tile blocks
	ld a, [wCurMapWidth] ; map width in 4x4 tile blocks
	add a ; double it
	ld [wCurrentMapWidth2], a ; map width in 2x2 tile blocks
	ld a, [wCurMap]
	ld c, a
	ld b, $00
	ld a, [H_LOADEDROMBANK]
	push af
	switchbank MapSongBanks
	ld hl, MapSongBanks
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld [wMapMusicSoundID], a ; music 1
	ld a, [hl]
	ld [wMapMusicROMBank], a ; music 2
	pop af
	call BankswitchCommon
	ret

; function to copy map connection data from ROM to WRAM
; Input: hl = source, de = destination
CopyMapConnectionHeader::
	ld c, $0b
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ret

CopySignData::
	ld de, wSignCoords ; start of sign coords
	ld bc, wSignTextIDs ; start of sign text ids
	ld a, [wNumSigns] ; number of signs
.signcopyloop
	push af
	ld a, [hli]
	ld [de], a ; copy y coord
	inc de
	ld a, [hli]
	ld [de], a ; copy x coord
	inc de
	ld a, [hli]
	ld [bc], a ; copy sign text id
	inc bc
	pop af
	dec a
	jr nz, .signcopyloop
	ret

; function to load map data
LoadMapData::
	ld a, [H_LOADEDROMBANK]
	push af
	call DisableLCD
	call ResetMapVariables
	call LoadTextBoxTilePatterns
	call LoadMapHeader
	call InitMapSprites ; load tile pattern data for sprites
	call LoadScreenRelatedData
	call CopyMapViewToVRAM
	ld a, $01
	ld [wUpdateSpritesEnabled], a
	call EnableLCD
	ld b, $09
	call RunPaletteCommand
	call LoadPlayerSpriteGraphics
	ld a, [wd732]
	and 1 << 4 | 1 << 3 ; fly warp or dungeon warp
	jr nz, .restoreRomBank
	ld a, [wFlags_D733]
	bit 1, a
	jr nz, .restoreRomBank
	call UpdateMusic6Times ; music related
	call PlayDefaultMusicFadeOutCurrent ; music related
.restoreRomBank
	pop af
	call BankswitchCommon
	ret

LoadScreenRelatedData::
	call LoadTileBlockMap
	call LoadTilesetTilePatternData
	call LoadCurrentMapView
	ret

ReloadMapAfterSurfingMinigame::
	ld a, [H_LOADEDROMBANK]
	push af
	call DisableLCD
	call ResetMapVariables
	ld a, [wCurMap]
	call SwitchToMapRomBank
	call LoadScreenRelatedData
	call CopyMapViewToVRAM
	ld de, vBGMap1
	call CopyMapViewToVRAM2
	call EnableLCD
	call ReloadMapSpriteTilePatterns
	pop af
	call BankswitchCommon
	jr asm_0f4d

ReloadMapAfterPrinter::
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, [wCurMap]
	call SwitchToMapRomBank
	call LoadTileBlockMap
	pop af
	call BankswitchCommon
asm_0f4d:
	jpab SetMapSpecificScriptFlagsOnMapReload
	ret ; useless?

ResetMapVariables::
	ld a, $98
	ld [wMapViewVRAMPointer + 1], a
	xor a
	ld [wMapViewVRAMPointer], a
	ld [hSCY], a
	ld [hSCX], a
	ld [wWalkCounter], a
	ld [wUnusedD119], a
	ld [wSpriteSetID], a
	ld [wWalkBikeSurfStateCopy], a
	ret

CopyMapViewToVRAM::
; copy current map view to VRAM
	ld de, vBGMap0
CopyMapViewToVRAM2:
	ld hl, wTileMap
	ld b, 18
.vramCopyLoop
	ld c, 20
.vramCopyInnerLoop
	ld a, [hli]
	ld [de], a
	inc e
	dec c
	jr nz, .vramCopyInnerLoop
	ld a, 32 - 20 ; total vram map width in tiles - screen width in tiles
	add e
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
	dec b
	jr nz, .vramCopyLoop
	ret

; function to switch to the ROM bank that a map is stored in
; Input: a = map number
SwitchToMapRomBank::
	push hl
	push bc
	ld c, a
	ld b, $00
	ld a, BANK(MapHeaderBanks)
	call BankswitchHome ; switch to ROM bank 3F
	ld hl, MapHeaderBanks
	add hl, bc
	ld a, [hl]
	ld [$ffe8], a ; save map ROM bank
	call BankswitchBack
	ld a, [$ffe8]
	call BankswitchCommon
	pop bc
	pop hl
	ret

GetMapHeaderPointer::
	ld a, [H_LOADEDROMBANK]
	push af
	switchbank MapHeaderPointers
	push de
	ld a, [wCurMap]
	ld e, a
	ld d, $0
	ld hl, MapHeaderPointers
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
	pop af
	jp BankswitchCommon

IgnoreInputForHalfSecond:
	ld a, 30
	ld [wIgnoreInputCounter], a
	ld hl, wd730
	ld a, [hl]
	or %00100110
	ld [hl], a ; set ignore input bit
	ret

ResetUsingStrengthOutOfBattleBit:
	ld hl, wd728
	res 0, [hl]
	ret

ForceBikeOrSurf::
	ld b, BANK(RedSprite)
	ld hl, LoadPlayerSpriteGraphics
	call Bankswitch
	jp PlayDefaultMusic ; update map/player state?

; Handle the player jumping down
; a ledge in the overworld.
HandleMidJump::
	ld a, [wd736]
	bit 6, a ; jumping down a ledge?
	ret z
	callba _HandleMidJump
	ret

IsSpinning::
	ld a, [wd736]
	bit 7, a
	ret z ; no spinning
	jpba LoadSpinnerArrowTiles ; spin while moving

Func_0ffe::
	jpab IsPlayerTalkingToPikachu

InitSprites::
	ld a, [hli]
	ld [wNumSprites], a ; save the number of sprites
	push hl
	push de
	push bc
	call ZeroSpriteStateData
	call DisableRegularSprites
	ld hl, wMapSpriteData
	ld bc, $20
	xor a
	call FillMemory
	pop bc
	pop de
	pop hl
	ld a, [wNumSprites]
	and a ; are sprites existant?
	ret z ; don't copy sprite data if not
	ld b, a
	ld c, $0
	ld de, wSpriteStateData1 + $10
; copy sprite stuff?
.loadSpriteLoop
	ld a, [hli]
	ld [de], a ; store picture ID at C1X0
	inc d
	ld a, e
	add $4
	ld e, a
	ld a, [hli]
	ld [de], a ; store Y position at C2X4
	inc e
	ld a, [hli]
	ld [de], a ; store X position at C2X5
	inc e
	ld a, [hli]
	ld [de], a ; store movement byte 1 at C2X6
	ld a, [hli]
	ld [$ff8d], a ; save movement byte 2
	ld a, [hli]
	ld [$ff8e], a ; save text ID and flags byte
	push bc
	call LoadSprite
	pop bc
	dec d
	ld a, e
	add $a
	ld e, a
	inc c
	inc c
	dec b
	jr nz, .loadSpriteLoop
	ret

ZeroSpriteStateData::
; zero C110-C1EF and C210-C2EF
; C1F0-C1FF and C2F0-C2FF is used for Pikachu
	ld hl, wSpriteStateData1 + $10
	ld de, wSpriteStateData2 + $10
	xor a
	ld b, 14 * $10
.loop
	ld [hli], a
	ld [de], a
	inc e
	dec b
	jr nz, .loop
	ret

DisableRegularSprites::
; initialize all C100-C1FF sprite entries to disabled (other than player's and pikachu)
	ld hl, wSpriteStateData1 + 1 * $10 + 2
	ld de, $10
	ld c, $e
.loop
	ld [hl], $ff
	add hl, de
	dec c
	jr nz, .loop
	ret

LoadSprite::
	push hl
	ld b, $0
	ld hl, wMapSpriteData
	add hl, bc
	ld a, [$ff8d]
	ld [hli], a ; store movement byte 2 in byte 0 of sprite entry
	ld a, [$ff8e]
	ld [hl], a ; this appears pointless, since the value is overwritten immediately after
	ld a, [$ff8e]
	ld [$ff8d], a
	and $3f
	ld [hl], a ; store text ID in byte 1 of sprite entry
	pop hl
	ld a, [$ff8d]
	bit 6, a
	jr nz, .trainerSprite
	bit 7, a
	jr nz, .itemBallSprite
; for regular sprites
	push hl
	ld hl, wMapSpriteExtraData
	add hl, bc
; zero both bytes, since regular sprites don't use this extra space
	xor a
	ld [hli], a
	ld [hl], a
	pop hl
	ret

.trainerSprite
	ld a, [hli]
	ld [$ff8d], a ; save trainer class
	ld a, [hli]
	ld [$ff8e], a ; save trainer number (within class)
	push hl
	ld hl, wMapSpriteExtraData
	add hl, bc
	ld a, [$ff8d]
	ld [hli], a ; store trainer class in byte 0 of the entry
	ld a, [$ff8e]
	ld [hl], a ; store trainer number in byte 1 of the entry
	pop hl
	ret

.itemBallSprite
	ld a, [hli]
	ld [$ff8d], a ; save item number
	push hl
	ld hl, wMapSpriteExtraData
	add hl, bc
	ld a, [$ff8d]
	ld [hli], a ; store item number in byte 0 of the entry
	xor a
	ld [hl], a ; zero byte 1, since it is not used
	pop hl
	ret
