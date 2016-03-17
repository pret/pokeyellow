INCLUDE "charmap.asm"
INCLUDE "constants.asm"

NPC_SPRITES_1 EQU $4
NPC_SPRITES_2 EQU $5

GFX EQU $4

PICS_1 EQU $9
PICS_2 EQU $A
PICS_3 EQU $B
PICS_4 EQU $C
PICS_5 EQU $D


SECTION "home",ROM0

INCLUDE "home.asm"
SECTION "bank01",ROMX,BANK[$01]

INCLUDE "data/facing.asm"

INCLUDE "engine/battle/safari_zone.asm"

INCLUDE "engine/titlescreen.asm"
INCLUDE "engine/load_mon_data.asm"

INCLUDE "data/item_prices.asm"
INCLUDE "text/item_names.asm"
INCLUDE "text/unused_names.asm"

INCLUDE "engine/overworld/oam.asm"

INCLUDE "engine/print_waiting_text.asm"

INCLUDE "engine/overworld/map_sprite_functions1.asm"	
INCLUDE "engine/overworld/item.asm"
INCLUDE "engine/overworld/movement.asm"
INCLUDE "engine/cable_club.asm"
INCLUDE "engine/menu/main_menu.asm"
INCLUDE "engine/oak_speech.asm"
INCLUDE "engine/overworld/special_warps.asm"
	
INCLUDE "data/special_warps.asm"

INCLUDE "engine/debug1.asm"

INCLUDE "engine/menu/naming_screen.asm"

INCLUDE "engine/oak_speech2.asm"

INCLUDE "engine/subtract_paid_money.asm"

INCLUDE "engine/menu/swap_items.asm"

INCLUDE "engine/overworld/pokemart.asm"
INCLUDE "engine/learn_move.asm"
INCLUDE "engine/overworld/pokecenter.asm"
INCLUDE "engine/overworld/set_blackout_map.asm"

INCLUDE "engine/menu/text_ids1.asm"
INCLUDE "engine/overworld/cable_club_npc.asm"
INCLUDE "engine/menu/text_ids2.asm"

INCLUDE "engine/battle/moveEffects/drain_hp_effect.asm"
INCLUDE "engine/menu/players_pc.asm"
INCLUDE "engine/remove_pokemon.asm"
INCLUDE "engine/display_pokedex.asm"
	
SECTION "bank03",ROMX,BANK[$03]

INCLUDE "engine/joypad.asm"

ClearVariablesAfterLoadingMapData: ; c07c (3:407c)
	ld a, $90
	ld [hWY], a
	ld [rWY], a
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld [wStepCounter], a
	ld [wLoneAttackNo], a ; wGymLeaderNo
	ld [hJoyPressed], a
	ld [hJoyReleased], a
	ld [hJoyHeld], a
	ld [wActionResultOrTookBattleTurn], a
	ld [wUnusedD5A3], a
	ld hl, wCardKeyDoorY
	ld [hli], a
	ld [hl], a
	ld hl, wWhichTrade
	ld bc, $1e
	call FillMemory
	ret

; only used for setting bit 2 of wd736 upon entering a new map
IsPlayerStandingOnWarp: ; c0a6 (3:40a6)
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

CheckForceBikeOrSurf: ; c0d2 (3:40d2)
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

IsPlayerFacingEdgeOfMap: ; c148 (3:4148)
	push hl
	push de
	push bc
	ld a, [wSpriteStateData1 + 9] ; player sprite's facing direction
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

IsWarpTileInFrontOfPlayer: ; c197 (3:4197)
	push hl
	push de
	push bc
	call _GetTileAndCoordsInFrontOfPlayer
	ld a, [wCurMap]
	cp SS_ANNE_5
	jr z, .ssAnne5
	ld a, [wSpriteStateData1 + 9] ; player sprite's facing direction
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

.warpTileListPointers: ; c1c0 (3:41c0)
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

IsPlayerStandingOnDoorTileOrWarpTile: ; c1e6 (3:41e6)
	push hl
	push de
	push bc
	callba IsPlayerStandingOnDoorTile ; 6:6785
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

PrintSafariZoneSteps: ; c27b (3:427b)
	ld a, [wCurMap]
	cp SAFARI_ZONE_EAST
	ret c
	cp UNKNOWN_DUNGEON_2
	ret nc
	coord hl, 0, 0
	lb bc, 3, 7
	call TextBoxBorder
	coord hl, 1, 1
	ld de, wSafariSteps
	lb bc, 2, 3
	call PrintNumber
	coord hl, 4, 1
	ld de, SafariSteps
	call PlaceString
	coord hl, 1, 3
	ld de, SafariBallText
	call PlaceString
	ld a, [wNumSafariBalls]
	cp 10
	jr nc, .numSafariBallsTwoDigits
	coord hl, 5, 3
	ld a, " "
	ld [hl], a
.numSafariBallsTwoDigits
	coord hl, 6, 3
	ld de, wNumSafariBalls
	lb bc, 1, 2
	jp PrintNumber

SafariSteps: ; c2c4 (3:42c4)
	db "/500@"

SafariBallText: ; c5c9 (3:42c9)
	db "BALL×× @"

GetTileAndCoordsInFrontOfPlayer: ; c2d4 (3:42d1)
	call GetPredefRegisters
	
_GetTileAndCoordsInFrontOfPlayer: ; c2d4 (3:42d4)
	ld a, [wYCoord]
	ld d, a
	ld a, [wXCoord]
	ld e, a
	ld a, [wSpriteStateData1 + 9] ; player's sprite facing direction
	and a ; cp SPRITE_FACING_DOWN
	jr nz, .notFacingDown
; facing down
	aCoord 8, 11
	inc d
	jr .storeTile
.notFacingDown
	cp SPRITE_FACING_UP
	jr nz, .notFacingUp
; facing up
	aCoord 8, 7
	dec d
	jr .storeTile
.notFacingUp
	cp SPRITE_FACING_LEFT
	jr nz, .notFacingLeft
; facing left
	aCoord 6, 9
	dec e
	jr .storeTile
.notFacingLeft
	cp SPRITE_FACING_RIGHT
	jr nz, .storeTile
; facing right
	aCoord 10, 9
	inc e
.storeTile
	ld c, a
	ld [wTileInFrontOfPlayer], a
	ret
	
GetTileTwoStepsInFrontOfPlayer: ; c309 (3:4309)
	xor a
	ld [$ffdb], a
	ld hl, wYCoord
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ld a, [wSpriteStateData1 + 9] ; player's sprite facing direction
	and a ; cp SPRITE_FACING_DOWN
	jr nz, .notFacingDown
; facing down
	ld hl, $ffdb
	set 0, [hl]
	aCoord 8, 13
	inc d
	jr .storeTile
.notFacingDown
	cp SPRITE_FACING_UP
	jr nz, .notFacingUp
; facing up
	ld hl, $ffdb
	set 1, [hl]
	aCoord 8, 5
	dec d
	jr .storeTile
.notFacingUp
	cp SPRITE_FACING_LEFT
	jr nz, .notFacingLeft
; facing left
	ld hl, $ffdb
	set 2, [hl]
	aCoord 4, 9
	dec e
	jr .storeTile
.notFacingLeft
	cp SPRITE_FACING_RIGHT
	jr nz, .storeTile
; facing right
	ld hl, $ffdb
	set 3, [hl]
	aCoord 12, 9
	inc e
.storeTile
	ld c, a
	ld [wTileInFrontOfBoulderAndBoulderCollisionResult], a
	ld [wTileInFrontOfPlayer], a
	ret

CheckForCollisionWhenPushingBoulder: ; c356 (3:4356)
	call GetTileTwoStepsInFrontOfPlayer
	call IsTilePassable
	jr c, .done
	ld hl, TilePairCollisionsLand
	call CheckForTilePairCollisions2
	ld a, $ff
	jr c, .done ; if there is an elevation difference between the current tile and the one two steps ahead
	ld a, [wTileInFrontOfBoulderAndBoulderCollisionResult]
	cp $15 ; stairs tile
	ld a, $ff
	jr z, .done ; if the tile two steps ahead is stairs
	call CheckForBoulderCollisionWithSprites
.done
	ld [wTileInFrontOfBoulderAndBoulderCollisionResult], a
	ret

; sets a to $ff if there is a collision and $00 if there is no collision
CheckForBoulderCollisionWithSprites: ; c378 (3:4378)
	ld a, [wBoulderSpriteIndex]
	dec a
	swap a
	ld d, 0
	ld e, a
	ld hl, wSpriteStateData2 + $14
	add hl, de
	ld a, [hli] ; map Y position
	ld [$ffdc], a
	ld a, [hl] ; map X position
	ld [$ffdd], a
	ld a, [wNumSprites]
	ld c, a
	ld de, $f
	ld hl, wSpriteStateData2 + $14
	ld a, [$ffdb]
	and $3 ; facing up or down?
	jr z, .pushingHorizontallyLoop
.pushingVerticallyLoop
	inc hl
	ld a, [$ffdd]
	cp [hl]
	jr nz, .nextSprite1 ; if X coordinates don't match
	dec hl
	ld a, [hli]
	ld b, a
	ld a, [$ffdb]
	rrca
	jr c, .pushingDown
; pushing up
	ld a, [$ffdc]
	dec a
	jr .compareYCoords
.pushingDown
	ld a, [$ffdc]
	inc a
.compareYCoords
	cp b
	jr z, .failure
.nextSprite1
	dec c
	jr z, .success
	add hl, de
	jr .pushingVerticallyLoop
.pushingHorizontallyLoop
	ld a, [hli]
	ld b, a
	ld a, [$ffdc]
	cp b
	jr nz, .nextSprite2
	ld b, [hl]
	ld a, [$ffdb]
	bit 2, a
	jr nz, .pushingLeft
; pushing right
	ld a, [$ffdd]
	inc a
	jr .compareXCoords
.pushingLeft
	ld a, [$ffdd]
	dec a
.compareXCoords
	cp b
	jr z, .failure
.nextSprite2
	dec c
	jr z, .success
	add hl, de
	jr .pushingHorizontallyLoop
.failure
	ld a, $ff
	ret
.success
	xor a
	ret

ApplyOutOfBattlePoisonDamage: ; c3de (3:43de)
	ld a, [wd730]
	add a
	jp c, .noBlackOut ; no black out if joypad states are being simulated
	ld a, [wd493]
	bit 7, a
	jp nz, .noBlackOut
	ld a, [wd72e]
	bit 6, a
	jp nz, .noBlackOut
	ld a, [wPartyCount]
	and a
	jp z, .noBlackOut
	call IncrementDayCareMonExp
	call Func_c4c7
	ld a, [wStepCounter]
	and $3 ; is the counter a multiple of 4?
	jp nz, .skipPoisonEffectAndSound ; only apply poison damage every fourth step
	ld [wWhichPokemon], a
	ld hl, wPartyMon1Status
	ld de, wPartySpecies
.applyDamageLoop
	ld a, [hl]
	and (1 << PSN)
	jr z, .nextMon2 ; not poisoned
	dec hl
	dec hl
	ld a, [hld]
	ld b, a
	ld a, [hli]
	or b
	jr z, .nextMon ; already fainted
; subtract 1 from HP
	ld a, [hl]
	dec a
	ld [hld], a
	inc a
	jr nz, .noBorrow
; borrow 1 from upper byte of HP
	dec [hl]
	inc hl
	jr .nextMon
.noBorrow
	ld a, [hli]
	or [hl]
	jr nz, .nextMon ; didn't faint from damage
; the mon fainted from the damage
	push hl
	inc hl
	inc hl
	ld [hl], a
	ld a, [de]
	ld [wd11e], a
	push de
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	xor a
	ld [wJoyIgnore], a
	call EnableAutoTextBoxDrawing
	ld a, $d0
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	callab IsThisPartymonStarterPikachu_Party
	jr nc, .curMonNotPlayerPikachu
	ld e, $3
	callab PlayPikachuSoundClip
	calladb_ModifyPikachuHappiness PIKAHAPPY_PSNFNT
.curMonNotPlayerPikachu
	pop de
	pop hl
.nextMon
	inc hl
	inc hl
.nextMon2
	inc de
	ld a, [de]
	inc a
	jr z, .applyDamageLoopDone
	ld bc, wPartyMon2 - wPartyMon1
	add hl, bc
	push hl
	ld hl, wWhichPokemon
	inc [hl]
	pop hl
	jr .applyDamageLoop
.applyDamageLoopDone
	ld hl, wPartyMon1Status
	ld a, [wPartyCount]
	ld d, a
	ld e, 0
.countPoisonedLoop
	ld a, [hl]
	and (1 << PSN)
	or e
	ld e, a
	ld bc, wPartyMon2 - wPartyMon1
	add hl, bc
	dec d
	jr nz, .countPoisonedLoop
	ld a, e
	and a ; are any party members poisoned?
	jr z, .skipPoisonEffectAndSound
	ld b, $2
	predef InvertBGPal_4Frames ; change BG white to dark grey for 4 frames
	ld a, SFX_POISONED
	call PlaySound
.skipPoisonEffectAndSound
	predef AnyPartyAlive
	ld a, d
	and a
	jr nz, .noBlackOut
	call EnableAutoTextBoxDrawing
	ld a, $d1
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld hl, wd72e
	set 5, [hl]
	ld a, $ff
	jr .done
.noBlackOut
	xor a
.done
	ld [wOutOfBattleBlackout], a
	ret

Func_c4c7: ; c4c7 (3:44c7)
	ld a, [wStepCounter]
	and a
	jr nz, .asm_c4de
	call Random
	and $1
	jr z, .asm_c4de
	calladb_ModifyPikachuHappiness $6
.asm_c4de
	ld hl, wPikachuMood
	ld a, [hl]
	cp $80
	jr z, .asm_c4ef
	jr c, .asm_c4ea
	dec a
	dec a
.asm_c4ea
	inc a
	ld [hl], a
	cp $80
	ret nz
.asm_c4ef
	xor a
	ld [wd49c], a
	ret
	
LoadTilesetHeader: ; c4f4 (3:44f4)
	call GetPredefRegisters
	push hl
	ld d, 0
	ld a, [wCurMapTileset]
	add a
	add a
	ld e, a
	ld hl, Tilesets
	add hl, de
	add hl, de
	add hl, de
	ld de, wTilesetBank
	ld bc, $b
	call CopyData
	ld a, [hl]
	ld [hTilesetType], a
	xor a
	ld [$ffd8], a
	pop hl
	ld a, [wCurMapTileset]
	push hl
	push de
	ld hl, DungeonTilesets
	ld de, $1
	call IsInArray
	pop de
	pop hl
	jr c, .notDungeonTileset
	ld a, [wCurMapTileset]
	ld b, a
	ld a, [hPreviousTileset]
	cp b
	jr z, .done
.notDungeonTileset
	ld a, [wDestinationWarpID]
	cp $ff
	jr z, .done
	call LoadDestinationWarpPosition
	ld a, [wYCoord]
	and $1
	ld [wYBlockCoord], a
	ld a, [wXCoord]
	and $1
	ld [wXBlockCoord], a
.done
	ret

INCLUDE "data/dungeon_tilesets.asm"

INCLUDE "data/tileset_headers.asm"

IncrementDayCareMonExp: ; c684 (3:4684)
	ld a, [wDayCareInUse]
	and a
	ret z
	ld hl, wDayCareMonExp + 2
	inc [hl]
	ret nz
	dec hl
	inc [hl]
	ret nz
	dec hl
	inc [hl]
	ld a, [hl]
	cp $50
	ret c
	ld a, $50
	ld [hl], a
	ret

INCLUDE "data/hide_show_data.asm"

LoadWildData: ; cb62 (3:4b62)
	ld hl,WildDataPointers
	ld a,[wCurMap]

	; get wild data for current map
	ld c,a
	ld b,0
	add hl,bc
	add hl,bc
	ld a,[hli]
	ld h,[hl]
	ld l,a       ; hl now points to wild data for current map
	ld a,[hli]
	ld [wGrassRate],a
	and a
	jr z,.NoGrassData ; if no grass data, skip to surfing data
	push hl
	ld de,wGrassMons ; otherwise, load grass data
	ld bc,$0014
	call CopyData
	pop hl
	ld bc,$0014
	add hl,bc
.NoGrassData
	ld a,[hli]
	ld [wWaterRate],a
	and a
	ret z        ; if no water data, we're done
	ld de,wWaterMons  ; otherwise, load surfing data
	ld bc,$0014
	jp CopyData
	
INCLUDE "data/wild_mons.asm"

INCLUDE "engine/items/items.asm"

DrawBadges: ; e880 (3:6880)
; Draw 4x2 gym leader faces, with the faces replaced by
; badges if they are owned. Used in the player status screen.

; In Japanese versions, names are displayed above faces.
; Instead of removing relevant code, the name graphics were erased.

; Tile ids for face/badge graphics.
	ld de, wBadgeOrFaceTiles
	ld hl, .FaceBadgeTiles
	ld bc, 8
	call CopyData

; Booleans for each badge.
	ld hl, wTempObtainedBadgesBooleans
	ld bc, 8
	xor a
	call FillMemory

; Alter these based on owned badges.
	ld de, wTempObtainedBadgesBooleans
	ld hl, wBadgeOrFaceTiles
	ld a, [wObtainedBadges]
	ld b, a
	ld c, 8
.CheckBadge
	srl b
	jr nc, .NextBadge
	ld a, [hl]
	add 4 ; Badge graphics are after each face
	ld [hl], a
	ld a, 1
	ld [de], a
.NextBadge
	inc hl
	inc de
	dec c
	jr nz, .CheckBadge

; Draw two rows of badges.
	ld hl, wBadgeNumberTile
	ld a, $d8 ; [1]
	ld [hli], a
	ld [hl], $60 ; First name

	coord hl, 2, 11
	ld de, wTempObtainedBadgesBooleans
	call .DrawBadgeRow

	coord hl, 2, 14
	ld de, wTempObtainedBadgesBooleans + 4
;	call .DrawBadgeRow
;	ret

.DrawBadgeRow ; e8c9 (3:68c9)
; Draw 4 badges.

	ld c, 4
.DrawBadge
	push de
	push hl

; Badge no.
	ld a, [wBadgeNumberTile]
	ld [hli], a
	inc a
	ld [wBadgeNumberTile], a

; Names aren't printed if the badge is owned.
	ld a, [de]
	and a
	ld a, [wBadgeNameTile]
	jr nz, .SkipName
	call .PlaceTiles
	jr .PlaceBadge

.SkipName
	inc a
	inc a
	inc hl

.PlaceBadge
	ld [wBadgeNameTile], a
	ld de, SCREEN_WIDTH - 1
	add hl, de
	ld a, [wBadgeOrFaceTiles]
	call .PlaceTiles
	add hl, de
	call .PlaceTiles

; Shift badge array back one byte.
	push bc
	ld hl, wBadgeOrFaceTiles + 1
	ld de, wBadgeOrFaceTiles
	ld bc, 8
	call CopyData
	pop bc

	pop hl
	ld de, 4
	add hl, de

	pop de
	inc de
	dec c
	jr nz, .DrawBadge
	ret

.PlaceTiles
	ld [hli], a
	inc a
	ld [hl], a
	inc a
	ret

.FaceBadgeTiles
	db $20, $28, $30, $38, $40, $48, $50, $58
	
GymLeaderFaceAndBadgeTileGraphics: ; e91b (3:691b)
	INCBIN "gfx/badges.2bpp"

; replaces a tile block with the one specified in [wNewTileBlockID]
; and redraws the map view if necessary
; b = Y
; c = X
ReplaceTileBlock: ; ed1b (3:6d1b)
	call GetPredefRegisters
	ld hl, wOverworldMap
	ld a, [wCurMapWidth]
	add $6
	ld e, a
	ld d, $0
	add hl, de
	add hl, de
	add hl, de
	ld e, $3
	add hl, de
	ld e, a
	ld a, b
	and a
	jr z, .addX
; add width * Y
.addWidthYTimesLoop
	add hl, de
	dec b
	jr nz, .addWidthYTimesLoop
.addX
	add hl, bc ; add X
	ld a, [wNewTileBlockID]
	ld [hl], a
	ld a, [wCurrentTileBlockMapViewPointer]
	ld c, a
	ld a, [wCurrentTileBlockMapViewPointer + 1]
	ld b, a
	call CompareHLWithBC
	ret c ; return if the replaced tile block is below the map view in memory
	push hl
	ld l, e
	ld h, $0
	ld e, $6
	ld d, h
	add hl, hl
	add hl, hl
	add hl, de
	add hl, bc
	pop bc
	call CompareHLWithBC
	ret c ; return if the replaced tile block is above the map view in memory

RedrawMapView: ; ed59 (3:6d59)
	ld a, [wIsInBattle]
	inc a
	ret z
	ld a, [H_AUTOBGTRANSFERENABLED]
	push af
	ld a, [hTilesetType]
	push af
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld [hTilesetType], a ; no flower/water BG tile animations
	call LoadCurrentMapView
	call RunDefaultPaletteCommand
	ld hl, wMapViewVRAMPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, -2 * 32
	add hl, de
	ld a, h
	and $3
	or $98
	ld a, l
	ld [wBuffer], a
	ld a, h
	ld [wBuffer + 1], a ; this copy of the address is not used
	ld a, 2
	ld [$ffbe], a
	ld c, 9 ; number of rows of 2x2 tiles (this covers the whole screen)
.redrawRowLoop
	push bc
	push hl
	push hl
	ld hl, wTileMap - 2 * SCREEN_WIDTH
	ld de, SCREEN_WIDTH
	ld a, [$ffbe]
.calcWRAMAddrLoop
	add hl, de
	dec a
	jr nz, .calcWRAMAddrLoop
	call CopyToRedrawRowOrColumnSrcTiles
	pop hl
	ld de, $20
	ld a, [$ffbe]
	ld c, a
.calcVRAMAddrLoop
	add hl, de
	ld a, h
	and $3
	or $98
	dec c
	jr nz, .calcVRAMAddrLoop
	ld [hRedrawRowOrColumnDest + 1], a
	ld a, l
	ld [hRedrawRowOrColumnDest], a
	ld a, REDRAW_ROW
	ld [hRedrawRowOrColumnMode], a
	call DelayFrame
	ld hl, $ffbe
	inc [hl]
	inc [hl]
	pop hl
	pop bc
	dec c
	jr nz, .redrawRowLoop
	pop af
	ld [hTilesetType], a
	pop af
	ld [H_AUTOBGTRANSFERENABLED], a
	ret

CompareHLWithBC: ; edcb (3:6dcb)
	ld a, h
	sub b
	ret nz
	ld a, l
	sub c
	ret
	
INCLUDE "engine/overworld/cut.asm"
	
MarkTownVisitedAndLoadMissableObjects: ; ef93 (3:6f93)
	ld a, [wCurMap]
	cp ROUTE_1
	jr nc, .notInTown
	ld c, a
	ld b, FLAG_SET
	ld hl, wTownVisitedFlag   ; mark town as visited (for flying)
	predef FlagActionPredef
.notInTown
	ld hl, MapHSPointers
	ld a, [wCurMap]
	ld b, $0
	ld c, a
	add hl, bc
	add hl, bc
	ld a, [hli]                ; load missable objects pointer in hl
	ld h, [hl]
	; fall through

; LoadMissableObjects: ; efb2 (3:6fb2)
; seems to not exist in yellow (predef replaced with something near TryPushingBoulder)
	ld l, a
	push hl
	ld a, l
	sub MapHS00 & $ff ; calculate difference between out pointer and the base pointer
	ld l, a
	ld a, h
	sbc MapHS00 / $100
	ld h, a
	ld a, h
	ld [H_DIVIDEND], a
	ld a, l
	ld [H_DIVIDEND+1], a
	xor a
	ld [H_DIVIDEND+2], a
	ld [H_DIVIDEND+3], a
	ld a, $3
	ld [H_DIVISOR], a
	ld b, $2
	call Divide                ; divide difference by 3, resulting in the global offset (number of missable items before ours)
	ld a, [wCurMap]
	ld b, a
	ld a, [H_DIVIDEND+3]
	ld c, a                    ; store global offset in c
	ld de, wMissableObjectList
	pop hl
.writeMissableObjectsListLoop
	ld a, [hli]
	cp $ff
	jr z, .done     ; end of list
	cp b
	jr nz, .done    ; not for current map anymore
	ld a, [hli]
	inc hl
	ld [de], a                 ; write (map-local) sprite ID
	inc de
	ld a, c
	inc c
	ld [de], a                 ; write (global) missable object index
	inc de
	jr .writeMissableObjectsListLoop
.done
	ld a, $ff
	ld [de], a                 ; write sentinel
	ret

InitializeMissableObjectsFlags: ; eff1 (3:6ff1)
	ld hl, wMissableObjectFlags
	ld bc, wMissableObjectFlagsEnd - wMissableObjectFlags
	xor a
	call FillMemory ; clear missable objects flags
	ld hl, MapHS00
	xor a
	ld [wMissableObjectCounter], a
.missableObjectsLoop
	ld a, [hli]
	cp $ff          ; end of list
	ret z
	push hl
	inc hl
	ld a, [hl]
	cp Hide
	jr nz, .skip
	ld hl, wMissableObjectFlags
	ld a, [wMissableObjectCounter]
	ld c, a
	ld b, FLAG_SET
	call MissableObjectFlagAction ; set flag if Item is hidden
.skip
	ld hl, wMissableObjectCounter
	inc [hl]
	pop hl
	inc hl
	inc hl
	jr .missableObjectsLoop

; tests if current sprite is a missable object that is hidden/has been removed
IsObjectHidden: ; f022 (3:7022)
	ld a, [H_CURRENTSPRITEOFFSET]
	swap a
	ld b, a
	ld hl, wMissableObjectList
.loop
	ld a, [hli]
	cp $ff
	jr z, .notHidden ; not missable -> not hidden
	cp b
	ld a, [hli]
	jr nz, .loop
	ld c, a
	ld b, FLAG_TEST
	ld hl, wMissableObjectFlags
	call MissableObjectFlagAction
	ld a, c
	and a
	jr nz, .hidden
.notHidden
	xor a
.hidden
	ld [$ffe5], a
	ret

; adds missable object (items, leg. pokemon, etc.) to the map
; [wMissableObjectIndex]: index of the missable object to be added (global index)
ShowObject: ; f044 (3:7044)
ShowObject2:
	ld hl, wMissableObjectFlags
	ld a, [wMissableObjectIndex]
	ld c, a
	ld b, FLAG_RESET
	call MissableObjectFlagAction   ; reset "removed" flag
	jp UpdateSprites

; removes missable object (items, leg. pokemon, etc.) from the map
; [wMissableObjectIndex]: index of the missable object to be removed (global index)
HideObject: ; f053 (3:7053)
	ld hl, wMissableObjectFlags
	ld a, [wMissableObjectIndex]
	ld c, a
	ld b, FLAG_SET
	call MissableObjectFlagAction   ; set "removed" flag
	jp UpdateSprites

MissableObjectFlagAction: ; f062 (3:7062)
; identical to FlagAction

	push hl
	push de
	push bc

	; bit
	ld a, c
	ld d, a
	and 7
	ld e, a

	; byte
	ld a, d
	srl a
	srl a
	srl a
	add l
	ld l, a
	jr nc, .ok
	inc h
.ok

	; d = 1 << e (bitmask)
	inc e
	ld d, 1
.shift
	dec e
	jr z, .shifted
	sla d
	jr .shift
.shifted

	ld a, b
	and a
	jr z, .reset
	cp 2
	jr z, .read

.set
	ld a, [hl]
	ld b, a
	ld a, d
	or b
	ld [hl], a
	jr .done

.reset
	ld a, [hl]
	ld b, a
	ld a, d
	xor $ff
	and b
	ld [hl], a
	jr .done

.read
	ld a, [hl]
	ld b, a
	ld a, d
	and b

.done
	pop bc
	pop de
	pop hl
	ld c, a
	ret

TryPushingBoulder: ; f0a1 (3:70a1)
	ld a, [wd728]
	bit 0, a ; using Strength?
	ret z
; where LoadMissableObjects predef points to now
	ld a, [wFlags_0xcd60]
	bit 1, a ; has boulder dust animation from previous push played yet?
	ret nz
	xor a
	ld [hSpriteIndexOrTextID], a
	call IsSpriteInFrontOfPlayer
	ld a, [hSpriteIndexOrTextID]
	ld [wBoulderSpriteIndex], a
	and a
	jp z, ResetBoulderPushFlags
	ld hl, wSpriteStateData1 + 1
	ld d, $0
	ld a, [hSpriteIndexOrTextID]
	swap a
	ld e, a
	add hl, de
	res 7, [hl]
	call GetSpriteMovementByte2Pointer
	ld a, [hl]
	cp BOULDER_MOVEMENT_BYTE_2
	jp nz, ResetBoulderPushFlags
	ld hl, wFlags_0xcd60
	bit 6, [hl]
	set 6, [hl] ; indicate that the player has tried pushing
	ret z ; the player must try pushing twice before the boulder will move
	ld a, [hJoyHeld]
	and D_RIGHT | D_LEFT | D_UP | D_DOWN
	ret z
	predef CheckForCollisionWhenPushingBoulder
	ld a, [wTileInFrontOfBoulderAndBoulderCollisionResult]
	and a ; was there a collision?
	jp nz, ResetBoulderPushFlags
	ld a, [hJoyHeld]
	ld b, a
	ld a, [wSpriteStateData1 + 9] ; player's sprite facing direction
	cp SPRITE_FACING_UP
	jr z, .pushBoulderUp
	cp SPRITE_FACING_LEFT
	jr z, .pushBoulderLeft
	cp SPRITE_FACING_RIGHT
	jr z, .pushBoulderRight
.pushBoulderDown
	bit 7, b
	ret z
	ld de, PushBoulderDownMovementData
	jr .done
.pushBoulderUp
	bit 6, b
	ret z
	ld de, PushBoulderUpMovementData
	jr .done
.pushBoulderLeft
	bit 5, b
	ret z
	ld de, PushBoulderLeftMovementData
	jr .done
.pushBoulderRight
	bit 4, b
	ret z
	ld de, PushBoulderRightMovementData
.done
	call MoveSprite
	ld a, SFX_PUSH_BOULDER
	call PlaySound
	ld hl, wFlags_0xcd60
	set 1, [hl]
	ret

PushBoulderUpMovementData: ; f129 (3:7129)
	db NPC_MOVEMENT_UP,$FF

PushBoulderDownMovementData: ; f12b (3:712b)
	db NPC_MOVEMENT_DOWN,$FF

PushBoulderLeftMovementData: ; f12d (3:712d)
	db NPC_MOVEMENT_LEFT,$FF

PushBoulderRightMovementData: ; f12f (3:712f)
	db NPC_MOVEMENT_RIGHT,$FF

DoBoulderDustAnimation: ; f131 (3:7131)
	ld a, [wd730]
	bit 0, a
	ret nz
	callab AnimateBoulderDust
	call DiscardButtonPresses
	ld [wJoyIgnore], a
	call ResetBoulderPushFlags
	set 7, [hl]
	ld a, [wBoulderSpriteIndex]
	ld [H_SPRITEINDEX], a
	call GetSpriteMovementByte2Pointer
	ld [hl], $10
	ld a, SFX_CUT
	jp PlaySound

ResetBoulderPushFlags: ; f159 (3:7159)
	ld hl, wFlags_0xcd60
	res 1, [hl]
	res 6, [hl]
	ret

_AddPartyMon: ; f161 (3:7161)
; Adds a new mon to the player's or enemy's party.
; [wMonDataLocation] is used in an unusual way in this function.
; If the lower nybble is 0, the mon is added to the player's party, else the enemy's.
; If the entire value is 0, then the player is allowed to name the mon.
	ld de, wPartyCount
	ld a, [wMonDataLocation]
	and $f
	jr z, .next
	ld de, wEnemyPartyCount
.next
	ld a, [de]
	inc a
	cp PARTY_LENGTH + 1
	ret nc ; return if the party is already full
	ld [de], a
	ld a, [de]
	ld [hNewPartyLength], a
	add e
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
	ld a, [wcf91]
	ld [de], a ; write species of new mon in party list
	inc de
	ld a, $ff ; terminator
	ld [de], a
	ld hl, wPartyMonOT
	ld a, [wMonDataLocation]
	and $f
	jr z, .next2
	ld hl, wEnemyMonOT
.next2
	ld a, [hNewPartyLength]
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
	ld hl, wPlayerName
	ld bc, NAME_LENGTH
	call CopyData
	ld a, [wMonDataLocation]
	and a
	jr nz, .skipNaming
	ld hl, wPartyMonNicks
	ld a, [hNewPartyLength]
	dec a
	call SkipFixedLengthTextEntries
	ld a, NAME_MON_SCREEN
	ld [wNamingScreenType], a
	predef AskName
.skipNaming
	ld hl, wPartyMons
	ld a, [wMonDataLocation]
	and $f
	jr z, .next3
	ld hl, wEnemyMons
.next3
	ld a, [hNewPartyLength]
	dec a
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld e, l
	ld d, h
	push hl
	ld a, [wcf91]
	ld [wd0b5], a
	call GetMonHeader
	ld hl, wMonHeader
	ld a, [hli]
	ld [de], a ; species
	inc de
	pop hl
	push hl
	ld a, [wMonDataLocation]
	and $f
	ld a, $98     ; set enemy trainer mon IVs to fixed average values
	ld b, $88
	jr nz, .next4

; If the mon is being added to the player's party, update the pokedex.
	ld a, [wcf91]
	ld [wd11e], a
	push de
	predef IndexToPokedex
	pop de
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, FLAG_TEST
	ld hl, wPokedexOwned
	call FlagAction
	ld a, c ; whether the mon was already flagged as owned
	ld [wUnusedD153], a ; not read
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, FLAG_SET
	push bc
	call FlagAction
	pop bc
	ld hl, wPokedexSeen
	call FlagAction

	pop hl
	push hl

	ld a, [wIsInBattle]
	and a ; is this a wild mon caught in battle?
	jr nz, .copyEnemyMonData

; Not wild.
	call Random ; generate random IVs
	ld b, a
	call Random

.next4
	push bc
	ld bc, wPartyMon1DVs - wPartyMon1
	add hl, bc
	pop bc
	ld [hli], a
	ld [hl], b         ; write IVs
	ld bc, (wPartyMon1HPExp - 1) - (wPartyMon1DVs + 1)
	add hl, bc
	ld a, 1
	ld c, a
	xor a
	ld b, a
	call CalcStat      ; calc HP stat (set cur Hp to max HP)
	ld a, [H_MULTIPLICAND+1]
	ld [de], a
	inc de
	ld a, [H_MULTIPLICAND+2]
	ld [de], a
	inc de
	xor a
	ld [de], a         ; box level
	inc de
	ld [de], a         ; status ailments
	inc de
	jr .copyMonTypesAndMoves
.copyEnemyMonData
	ld bc, wEnemyMon1DVs - wEnemyMon1
	add hl, bc
	ld a, [wEnemyMonDVs] ; copy IVs from cur enemy mon
	ld [hli], a
	ld a, [wEnemyMonDVs + 1]
	ld [hl], a
	ld a, [wEnemyMonHP]    ; copy HP from cur enemy mon
	ld [de], a
	inc de
	ld a, [wEnemyMonHP+1]
	ld [de], a
	inc de
	xor a
	ld [de], a                ; box level
	inc de
	ld a, [wEnemyMonStatus]   ; copy status ailments from cur enemy mon
	ld [de], a
	inc de
.copyMonTypesAndMoves
	ld hl, wMonHTypes
	ld a, [hli]       ; type 1
	ld [de], a
	inc de
	ld a, [hli]       ; type 2
	ld [de], a
	inc de
	ld a, [hli]       ; catch rate (held item in gen 2)
	ld [de], a
	ld a, [wcf91]
	cp KADABRA
	jr nz, .skipGivingTwistedSpoon
	ld a, $60 ; twistedspoon in gen 2
	ld [de], a
.skipGivingTwistedSpoon
	ld hl, wMonHMoves
	ld a, [hli]
	inc de
	push de
	ld [de], a
	ld a, [hli]
	inc de
	ld [de], a
	ld a, [hli]
	inc de
	ld [de], a
	ld a, [hli]
	inc de
	ld [de], a
	push de
	dec de
	dec de
	dec de
	xor a
	ld [wLearningMovesFromDayCare], a
	predef WriteMonMoves
	pop de
	ld a, [wPlayerID]  ; set trainer ID to player ID
	inc de
	ld [de], a
	ld a, [wPlayerID + 1]
	inc de
	ld [de], a
	push de
	ld a, [wCurEnemyLVL]
	ld d, a
	callab CalcExperience
	pop de
	inc de
	ld a, [hExperience] ; write experience
	ld [de], a
	inc de
	ld a, [hExperience + 1]
	ld [de], a
	inc de
	ld a, [hExperience + 2]
	ld [de], a
	xor a
	ld b, NUM_STATS * 2
.writeEVsLoop              ; set all EVs to 0
	inc de
	ld [de], a
	dec b
	jr nz, .writeEVsLoop
	inc de
	inc de
	pop hl
	call AddPartyMon_WriteMovePP
	inc de
	ld a, [wCurEnemyLVL]
	ld [de], a
	inc de
	ld a, [wIsInBattle]
	dec a
	jr nz, .calcFreshStats
	ld hl, wEnemyMonMaxHP
	ld bc, $a
	call CopyData          ; copy stats of cur enemy mon
	pop hl
	jr .done
.calcFreshStats
	pop hl
	ld bc, wPartyMon1HPExp - 1 - wPartyMon1
	add hl, bc
	ld b, $0
	call CalcStats         ; calculate fresh set of stats
.done
	scf
	ret

LoadMovePPs: ; f2f9 (3:72f9)
	call GetPredefRegisters
	; fallthrough
AddPartyMon_WriteMovePP: ; f2fc (3:72fc)
	ld b, NUM_MOVES
.pploop
	ld a, [hli]     ; read move ID
	and a
	jr z, .empty
	dec a
	push hl
	push de
	push bc
	ld hl, Moves
	ld bc, MoveEnd - Moves
	call AddNTimes
	ld de, wcd6d
	ld a, BANK(Moves)
	call FarCopyData
	pop bc
	pop de
	pop hl
	ld a, [wcd6d + 5] ; PP is byte 5 of move data
.empty
	inc de
	ld [de], a
	dec b
	jr nz, .pploop ; there are still moves to read
	ret

; adds enemy mon [wcf91] (at position [wWhichPokemon] in enemy list) to own party
; used in the cable club trade center
_AddEnemyMonToPlayerParty: ; f323 (3:7323)
	ld hl, wPartyCount
	ld a, [hl]
	cp PARTY_LENGTH
	scf
	ret z            ; party full, return failure
	inc a
	ld [hl], a       ; add 1 to party members
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [wcf91]
	ld [hli], a      ; add mon as last list entry
	ld [hl], $ff     ; write new sentinel
	ld hl, wPartyMons
	ld a, [wPartyCount]
	dec a
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld e, l
	ld d, h
	ld hl, wLoadedMon
	call CopyData    ; write new mon's data (from wLoadedMon)
	ld hl, wPartyMonOT
	ld a, [wPartyCount]
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
	ld hl, wEnemyMonOT
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
	ld bc, NAME_LENGTH
	call CopyData    ; write new mon's OT name (from an enemy mon)
	ld hl, wPartyMonNicks
	ld a, [wPartyCount]
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
	ld hl, wEnemyMonNicks
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
	ld bc, NAME_LENGTH
	call CopyData    ; write new mon's nickname (from an enemy mon)
	ld a, [wcf91]
	ld [wd11e], a
	predef IndexToPokedex
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, FLAG_SET
	ld hl, wPokedexOwned
	push bc
	call FlagAction ; add to owned pokemon
	pop bc
	ld hl, wPokedexSeen
	call FlagAction ; add to seen pokemon
	and a
	ret                  ; return success

_MoveMon: ; f3a4 (3:73a4)
	ld a, [wMoveMonType]
	and a
	jr z, .checkPartyMonSlots
	cp DAYCARE_TO_PARTY
	jr z, .checkPartyMonSlots
	cp PARTY_TO_DAYCARE
	ld hl, wDayCareMon
	jr z, .asm_f3fb
	ld hl, wNumInBox
	ld a, [hl]
	cp MONS_PER_BOX
	jr nz, .partyOrBoxNotFull
	jr .boxFull
.checkPartyMonSlots
	ld hl, wPartyCount
	ld a, [hl]
	cp PARTY_LENGTH
	jr nz, .partyOrBoxNotFull
.boxFull
	scf
	ret
.partyOrBoxNotFull
	inc a
	ld [hl], a           ; increment number of mons in party/box
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wMoveMonType]
	cp DAYCARE_TO_PARTY
	ld a, [wDayCareMon]
	jr z, .asm_f3dc
	ld a, [wcf91]
.asm_f3dc
	ld [hli], a          ; write new mon ID
	ld [hl], $ff         ; write new sentinel
	ld a, [wMoveMonType]
	dec a
	ld hl, wPartyMons
	ld bc, wPartyMon2 - wPartyMon1 ; $2c
	ld a, [wPartyCount]
	jr nz, .skipToNewMonEntry
	ld hl, wBoxMons
	ld bc, wBoxMon2 - wBoxMon1 ; $21
	ld a, [wNumInBox]
.skipToNewMonEntry
	dec a
	call AddNTimes
.asm_f3fb
	push hl
	ld e, l
	ld d, h
	ld a, [wMoveMonType]
	and a
	ld hl, wBoxMons
	ld bc, wBoxMon2 - wBoxMon1 ; $21
	jr z, .asm_f417
	cp DAYCARE_TO_PARTY
	ld hl, wDayCareMon
	jr z, .asm_f41d
	ld hl, wPartyMons
	ld bc, wPartyMon2 - wPartyMon1 ; $2c
.asm_f417
	ld a, [wWhichPokemon]
	call AddNTimes
.asm_f41d
	push hl
	push de
	ld bc, wBoxMon2 - wBoxMon1
	call CopyData
	pop de
	pop hl
	ld a, [wMoveMonType]
	and a
	jr z, .asm_f43a
	cp DAYCARE_TO_PARTY
	jr z, .asm_f43a
	ld bc, wBoxMon2 - wBoxMon1
	add hl, bc
	ld a, [hl]
	inc de
	inc de
	inc de
	ld [de], a
.asm_f43a
	ld a, [wMoveMonType]
	cp PARTY_TO_DAYCARE
	ld de, wDayCareMonOT
	jr z, .asm_f459
	dec a
	ld hl, wPartyMonOT
	ld a, [wPartyCount]
	jr nz, .asm_f453
	ld hl, wBoxMonOT
	ld a, [wNumInBox]
.asm_f453
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
.asm_f459
	ld hl, wBoxMonOT
	ld a, [wMoveMonType]
	and a
	jr z, .asm_f46c
	ld hl, wDayCareMonOT
	cp DAYCARE_TO_PARTY
	jr z, .asm_f472
	ld hl, wPartyMonOT
.asm_f46c
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
.asm_f472
	ld bc, NAME_LENGTH
	call CopyData
	ld a, [wMoveMonType]
	cp PARTY_TO_DAYCARE
	ld de, wDayCareMonName
	jr z, .asm_f497
	dec a
	ld hl, wPartyMonNicks
	ld a, [wPartyCount]
	jr nz, .asm_f491
	ld hl, wBoxMonNicks
	ld a, [wNumInBox]
.asm_f491
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
.asm_f497
	ld hl, wBoxMonNicks
	ld a, [wMoveMonType]
	and a
	jr z, .asm_f4aa
	ld hl, wDayCareMonName
	cp DAYCARE_TO_PARTY
	jr z, .asm_f4b0
	ld hl, wPartyMonNicks
.asm_f4aa
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
.asm_f4b0
	ld bc, NAME_LENGTH
	call CopyData
	pop hl
	ld a, [wMoveMonType]
	cp PARTY_TO_BOX
	jr z, .asm_f4ea
	cp PARTY_TO_DAYCARE
	jr z, .asm_f4ea
	push hl
	srl a
	add $2
	ld [wMonDataLocation], a
	call LoadMonData
	callba CalcLevelFromExperience
	ld a, d
	ld [wCurEnemyLVL], a
	pop hl
	ld bc, wBoxMon2 - wBoxMon1
	add hl, bc
	ld [hli], a
	ld d, h
	ld e, l
	ld bc, -18
	add hl, bc
	ld b, $1
	call CalcStats
.asm_f4ea
	and a
	ret


FlagActionPredef: ; f4ec (3:74ec)
	call GetPredefRegisters

FlagAction: ; f4ef (3:74ef)
; Perform action b on bit c
; in the bitfield at hl.
;  0: reset
;  1: set
;  2: read
; Return the result in c.

	push hl
	push de
	push bc

	; bit
	ld a, c
	ld d, a
	and 7
	ld e, a

	; byte
	ld a, d
	srl a
	srl a
	srl a
	add l
	ld l, a
	jr nc, .ok
	inc h
.ok

	; d = 1 << e (bitmask)
	inc e
	ld d, 1
.shift
	dec e
	jr z, .shifted
	sla d
	jr .shift
.shifted

	ld a, b
	and a
	jr z, .reset
	cp 2
	jr z, .read

.set
	ld b, [hl]
	ld a, d
	or b
	ld [hl], a
	jr .done

.reset
	ld b, [hl]
	ld a, d
	xor $ff
	and b
	ld [hl], a
	jr .done

.read
	ld b, [hl]
	ld a, d
	and b
.done
	pop bc
	pop de
	pop hl
	ld c, a
	ret

HealParty: ; f52b (3:752b)
; Restore HP and PP.

	ld hl, wPartySpecies
	ld de, wPartyMon1HP
.healmon
	ld a, [hli]
	cp $ff
	jr z, .done

	push hl
	push de

	ld hl, wPartyMon1Status - wPartyMon1HP
	add hl, de
	xor a
	ld [hl], a

	push de
	ld b, NUM_MOVES ; A Pokémon has 4 moves
.pp
	ld hl, wPartyMon1Moves - wPartyMon1HP
	add hl, de

	ld a, [hl]
	and a
	jr z, .nextmove

	dec a
	ld hl, wPartyMon1PP - wPartyMon1HP
	add hl, de

	push hl
	push de
	push bc

	ld hl, Moves
	ld bc, MoveEnd - Moves
	call AddNTimes
	ld de, wcd6d
	ld a, BANK(Moves)
	call FarCopyData
	ld a, [wcd6d + 5] ; PP is byte 5 of move data

	pop bc
	pop de
	pop hl

	inc de
	push bc
	ld b, a
	ld a, [hl]
	and $c0
	add b
	ld [hl], a
	pop bc

.nextmove
	dec b
	jr nz, .pp
	pop de

	ld hl, wPartyMon1MaxHP - wPartyMon1HP
	add hl, de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a

	pop de
	pop hl

	push hl
	ld bc, wPartyMon2 - wPartyMon1
	ld h, d
	ld l, e
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	jr .healmon

.done
	xor a
	ld [wWhichPokemon], a
	ld [wd11e], a

	ld a, [wPartyCount]
	ld b, a
.ppup
	push bc
	call RestoreBonusPP
	pop bc
	ld hl, wWhichPokemon
	inc [hl]
	dec b
	jr nz, .ppup
	ret

INCLUDE "engine/bcd.asm"

InitPlayerData: ; f6d6 (3:76d6)
InitPlayerData2:

	call Random
	ld a, [hRandomSub]
	ld [wPlayerID], a

	call Random
	ld a, [hRandomAdd]
	ld [wPlayerID + 1], a

	ld a, $ff
	ld [wUnusedD71B], a
	
	ld a, 90 ; initialize happiness to 90
	ld [wPikachuHappiness], a
	ld a, $80
	ld [wPikachuMood], a ; initialize mood
	
	ld hl, wPartyCount
	call InitializeEmptyList
	ld hl, wNumInBox
	call InitializeEmptyList
	ld hl, wNumBagItems
	call InitializeEmptyList
	ld hl, wNumBoxItems
	call InitializeEmptyList

START_MONEY EQU $3000
	ld hl, wPlayerMoney + 1
	ld a, START_MONEY / $100
	ld [hld], a
	xor a
	ld [hli], a
	inc hl
	ld [hl], a

	ld [wMonDataLocation], a

	ld hl, wObtainedBadges
	ld [hli], a

	ld [hl], a

	ld hl, wPlayerCoins
	ld [hli], a
	ld [hl], a

	ld hl, wGameProgressFlags
	ld bc, wGameProgressFlagsEnd - wGameProgressFlags
	call FillMemory ; clear all game progress flags

	jp InitializeMissableObjectsFlags

InitializeEmptyList: ; f730 (3:7730)
	xor a ; count
	ld [hli], a
	dec a ; terminator
	ld [hl], a
	ret

GetQuantityOfItemInBag: ; f735 (3:7735)
; In: b = item ID
; Out: b = how many of that item are in the bag
	call GetPredefRegisters
	ld hl, wNumBagItems
.loop
	inc hl
	ld a, [hli]
	cp $ff
	jr z, .notInBag
	cp b
	jr nz, .loop
	ld a, [hl]
	ld b, a
	ret
.notInBag
	ld b, 0
	ret

FindPathToPlayer: ; f74a (3:774a)
	xor a
	ld hl, hFindPathNumSteps
	ld [hli], a ; hFindPathNumSteps
	ld [hli], a ; hFindPathFlags
	ld [hli], a ; hFindPathYProgress
	ld [hl], a  ; hFindPathXProgress
	ld hl, wNPCMovementDirections2
	ld de, $0
.loop
	ld a, [hFindPathYProgress]
	ld b, a
	ld a, [hNPCPlayerYDistance] ; Y distance in steps
	call CalcDifference
	ld d, a
	and a
	jr nz, .asm_f76a
	ld a, [hFindPathFlags]
	set 0, a ; current end of path matches the player's Y coordinate
	ld [hFindPathFlags], a
.asm_f76a
	ld a, [hFindPathXProgress]
	ld b, a
	ld a, [hNPCPlayerXDistance] ; X distance in steps
	call CalcDifference
	ld e, a
	and a
	jr nz, .asm_f77c
	ld a, [hFindPathFlags]
	set 1, a ; current end of path matches the player's X coordinate
	ld [hFindPathFlags], a
.asm_f77c
	ld a, [hFindPathFlags]
	cp $3 ; has the end of the path reached the player's position?
	jr z, .done
; Compare whether the X distance between the player and the current of the path
; is greater or if the Y distance is. Then, try to reduce whichever is greater.
	ld a, e
	cp d
	jr c, .yDistanceGreater
; x distance is greater
	ld a, [hNPCPlayerRelativePosFlags]
	bit 1, a
	jr nz, .playerIsLeftOfNPC
	ld d, NPC_MOVEMENT_RIGHT
	jr .next1
.playerIsLeftOfNPC
	ld d, NPC_MOVEMENT_LEFT
.next1
	ld a, [hFindPathXProgress]
	add 1
	ld [hFindPathXProgress], a
	jr .storeDirection
.yDistanceGreater
	ld a, [hNPCPlayerRelativePosFlags]
	bit 0, a
	jr nz, .playerIsAboveNPC
	ld d, NPC_MOVEMENT_DOWN
	jr .next2
.playerIsAboveNPC
	ld d, NPC_MOVEMENT_UP
.next2
	ld a, [hFindPathYProgress]
	add 1
	ld [hFindPathYProgress], a
.storeDirection
	ld a, d
	ld [hli], a
	ld a, [hFindPathNumSteps]
	inc a
	ld [hFindPathNumSteps], a
	jp .loop
.done
	ld [hl], $ff
	ret

CalcPositionOfPlayerRelativeToNPC: ; f7b9 (3:77b9)
	xor a
	ld [hNPCPlayerRelativePosFlags], a
	ld a, [wSpriteStateData1 + 4] ; player's sprite screen Y position in pixels
	ld d, a
	ld a, [wSpriteStateData1 + 6] ; player's sprite screen X position in pixels
	ld e, a
	ld hl, wSpriteStateData1
	ld a, [hNPCSpriteOffset]
	add l
	add $4
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	ld a, d
	ld b, a
	ld a, [hli] ; NPC sprite screen Y position in pixels
	call CalcDifference
	jr nc, .NPCSouthOfOrAlignedWithPlayer
.NPCNorthOfPlayer
	push hl
	ld hl, hNPCPlayerRelativePosFlags
	bit 0, [hl]
	set 0, [hl]
	pop hl
	jr .divideYDistance
.NPCSouthOfOrAlignedWithPlayer
	push hl
	ld hl, hNPCPlayerRelativePosFlags
	bit 0, [hl]
	res 0, [hl]
	pop hl
.divideYDistance
	push hl
	ld hl, hDividend2
	ld [hli], a
	ld a, 16
	ld [hli], a
	call DivideBytes ; divide Y absolute distance by 16
	ld a, [hl] ; quotient
	ld [hNPCPlayerYDistance], a
	pop hl
	inc hl
	ld b, e
	ld a, [hl] ; NPC sprite screen X position in pixels
	call CalcDifference
	jr nc, .NPCEastOfOrAlignedWithPlayer
.NPCWestOfPlayer
	push hl
	ld hl, hNPCPlayerRelativePosFlags
	bit 1, [hl]
	set 1, [hl]
	pop hl
	jr .divideXDistance
.NPCEastOfOrAlignedWithPlayer
	push hl
	ld hl, hNPCPlayerRelativePosFlags
	bit 1, [hl]
	res 1, [hl]
	pop hl
.divideXDistance
	ld [hDividend2], a
	ld a, 16
	ld [hDivisor2], a
	call DivideBytes ; divide X absolute distance by 16
	ld a, [hQuotient2]
	ld [hNPCPlayerXDistance], a
	ld a, [hNPCPlayerRelativePosPerspective]
	and a
	ret z
	ld a, [hNPCPlayerRelativePosFlags]
	cpl
	and $3
	ld [hNPCPlayerRelativePosFlags], a
	ret

ConvertNPCMovementDirectionsToJoypadMasks: ; f830 (3:7830)
	ld a, [hNPCMovementDirections2Index]
	ld [wNPCMovementDirections2Index], a
	dec a
	ld de, wSimulatedJoypadStatesEnd
	ld hl, wNPCMovementDirections2
	add l
	ld l, a
	jr nc, .loop
	inc h
.loop
	ld a, [hld]
	call ConvertNPCMovementDirectionToJoypadMask
	ld [de], a
	inc de
	ld a, [hNPCMovementDirections2Index]
	dec a
	ld [hNPCMovementDirections2Index], a
	jr nz, .loop
	ret

ConvertNPCMovementDirectionToJoypadMask: ; f84f (3:784f)
	push hl
	ld b, a
	ld hl, NPCMovementDirectionsToJoypadMasksTable
.loop
	ld a, [hli]
	cp $ff
	jr z, .done
	cp b
	jr z, .loadJoypadMask
	inc hl
	jr .loop
.loadJoypadMask
	ld a, [hl]
.done
	pop hl
	ret

NPCMovementDirectionsToJoypadMasksTable: ; f862 (3:7862)
	db NPC_MOVEMENT_UP, D_UP
	db NPC_MOVEMENT_DOWN, D_DOWN
	db NPC_MOVEMENT_LEFT, D_LEFT
	db NPC_MOVEMENT_RIGHT, D_RIGHT
	db $ff

; unreferenced
	ret

INCLUDE "engine/hp_bar.asm"
INCLUDE "engine/hidden_object_functions3.asm"

SECTION "Graphics", ROMX, BANK[GFX]

PokemonLogoJapanGraphics:       INCBIN "gfx/pokemon_logo_japan.2bpp"
FontGraphics:                   INCBIN "gfx/font.1bpp"
FontGraphicsEnd:
ABTiles:                        INCBIN "gfx/AB.2bpp"
HpBarAndStatusGraphics:         INCBIN "gfx/hp_bar_and_status.2bpp"
HpBarAndStatusGraphicsEnd:
BattleHudTiles1:                INCBIN "gfx/battle_hud1.1bpp"
BattleHudTiles1End:
BattleHudTiles2:                INCBIN "gfx/battle_hud2.1bpp"
BattleHudTiles3:                INCBIN "gfx/battle_hud3.1bpp"
BattleHudTiles3End:
NintendoCopyrightLogoGraphics:  INCBIN "gfx/copyright.2bpp"
GamefreakLogoGraphics:          INCBIN "gfx/gamefreak.2bpp"
GamefreakLogoGraphicsEnd:
NineTile:                       INCBIN "gfx/9_tile.2bpp"
TextBoxGraphics:                INCBIN "gfx/text_box.2bpp"
TextBoxGraphicsEnd:
PokedexTileGraphics:            INCBIN "gfx/pokedex.2bpp"
PokedexTileGraphicsEnd:
WorldMapTileGraphics:           INCBIN "gfx/town_map.2bpp"
WorldMapTileGraphicsEnd:
PlayerCharacterTitleGraphics:   INCBIN "gfx/player_title.2bpp"

INCLUDE "engine/menu/status_screen.asm"
INCLUDE "engine/menu/party_menu.asm"

RedPicFront: INCBIN "pic/ytrainer/red.pic"
ShrinkPic1:  INCBIN "pic/trainer/shrink1.pic"
ShrinkPic2:  INCBIN "pic/trainer/shrink2.pic"

INCLUDE "engine/menu/start_sub_menus.asm"
INCLUDE "engine/items/tms.asm"

SECTION "NPC Sprites 1", ROMX, BANK[NPC_SPRITES_1]

OakAideSprite:         INCBIN "gfx/sprites/oak_aide.2bpp"
RockerSprite:          INCBIN "gfx/sprites/rocker.2bpp"
SwimmerSprite:         INCBIN "gfx/sprites/swimmer.2bpp"
WhitePlayerSprite:     INCBIN "gfx/sprites/white_player.2bpp"
GymHelperSprite:       INCBIN "gfx/sprites/gym_helper.2bpp"
OldPersonSprite:       INCBIN "gfx/sprites/old_person.2bpp"
MartGuySprite:         INCBIN "gfx/sprites/mart_guy.2bpp"
FisherSprite:          INCBIN "gfx/sprites/fisher.2bpp"
OldMediumWomanSprite:  INCBIN "gfx/sprites/old_medium_woman.2bpp"
NurseSprite:           INCBIN "gfx/sprites/nurse.2bpp"
CableClubWomanSprite:  INCBIN "gfx/sprites/cable_club_woman.2bpp"
MrMasterballSprite:    INCBIN "gfx/sprites/mr_masterball.2bpp"
LaprasGiverSprite:     INCBIN "gfx/sprites/lapras_giver.2bpp"
WardenSprite:          INCBIN "gfx/sprites/warden.2bpp"
SsCaptainSprite:       INCBIN "gfx/sprites/ss_captain.2bpp"
Fisher2Sprite:         INCBIN "gfx/sprites/fisher2.2bpp"
BlackbeltSprite:       INCBIN "gfx/sprites/blackbelt.2bpp"
GuardSprite:           INCBIN "gfx/sprites/guard.2bpp"
BallSprite:            INCBIN "gfx/sprites/ball.2bpp"
OmanyteSprite:         INCBIN "gfx/sprites/omanyte.2bpp"
BoulderSprite:         INCBIN "gfx/sprites/boulder.2bpp"
PaperSheetSprite:      INCBIN "gfx/sprites/paper_sheet.2bpp"
BookMapDexSprite:      INCBIN "gfx/sprites/book_map_dex.2bpp"
ClipboardSprite:       INCBIN "gfx/sprites/clipboard.2bpp"
SnorlaxSprite:         INCBIN "gfx/sprites/snorlax.2bpp"
OldAmberSprite:        INCBIN "gfx/sprites/old_amber.2bpp"
LyingOldManSprite:     INCBIN "gfx/sprites/lying_old_man.2bpp"
QuestionMarkSprite:    INCBIN "gfx/sprites/question_mark.2bpp"

INCLUDE "engine/battle/end_of_battle.asm"
INCLUDE "engine/battle/wild_encounters.asm"
INCLUDE "engine/battle/moveEffects/recoil_effect.asm"
INCLUDE "engine/battle/moveEffects/conversion_effect.asm"
INCLUDE "engine/battle/moveEffects/haze_effect.asm"


SECTION "NPC Sprites 2", ROMX, BANK[NPC_SPRITES_2]

INCLUDE "engine/load_pokedex_tiles.asm"
INCLUDE "engine/overworld/map_sprites.asm"

RedCyclingSprite:     INCBIN "gfx/sprites/cycling.2bpp"
RedSprite:            INCBIN "gfx/sprites/red.2bpp"
BlueSprite:           INCBIN "gfx/sprites/blue.2bpp"
OakSprite:            INCBIN "gfx/sprites/oak.2bpp"
BugCatcherSprite:     INCBIN "gfx/sprites/bug_catcher.2bpp"
SlowbroSprite:        INCBIN "gfx/sprites/slowbro.2bpp"
LassSprite:           INCBIN "gfx/sprites/lass.2bpp"
BlackHairBoy1Sprite:  INCBIN "gfx/sprites/black_hair_boy_1.2bpp"
LittleGirlSprite:     INCBIN "gfx/sprites/little_girl.2bpp"
BirdSprite:           INCBIN "gfx/sprites/bird.2bpp"
FatBaldGuySprite:     INCBIN "gfx/sprites/fat_bald_guy.2bpp"
GamblerSprite:        INCBIN "gfx/sprites/gambler.2bpp"
BlackHairBoy2Sprite:  INCBIN "gfx/sprites/black_hair_boy_2.2bpp"
GirlSprite:           INCBIN "gfx/sprites/girl.2bpp"
HikerSprite:          INCBIN "gfx/sprites/hiker.2bpp"
FoulardWomanSprite:   INCBIN "gfx/sprites/foulard_woman.2bpp"
GentlemanSprite:      INCBIN "gfx/sprites/gentleman.2bpp"
DaisySprite:          INCBIN "gfx/sprites/daisy.2bpp"
BikerSprite:          INCBIN "gfx/sprites/biker.2bpp"
SailorSprite:         INCBIN "gfx/sprites/sailor.2bpp"
CookSprite:           INCBIN "gfx/sprites/cook.2bpp"
BikeShopGuySprite:    INCBIN "gfx/sprites/bike_shop_guy.2bpp"
MrFujiSprite:         INCBIN "gfx/sprites/mr_fuji.2bpp"
GiovanniSprite:       INCBIN "gfx/sprites/giovanni.2bpp"
RocketSprite:         INCBIN "gfx/sprites/rocket.2bpp"
MediumSprite:         INCBIN "gfx/sprites/medium.2bpp"
WaiterSprite:         INCBIN "gfx/sprites/waiter.2bpp"
ErikaSprite:          INCBIN "gfx/sprites/erika.2bpp"
MomGeishaSprite:      INCBIN "gfx/sprites/mom_geisha.2bpp"
BrunetteGirlSprite:   INCBIN "gfx/sprites/brunette_girl.2bpp"
LanceSprite:          INCBIN "gfx/sprites/lance.2bpp"
MomSprite:            INCBIN "gfx/sprites/mom.2bpp"
BaldingGuySprite:     INCBIN "gfx/sprites/balding_guy.2bpp"
YoungBoySprite:       INCBIN "gfx/sprites/young_boy.2bpp"
GameboyKidSprite:     INCBIN "gfx/sprites/gameboy_kid.2bpp"
ClefairySprite:       INCBIN "gfx/sprites/clefairy.2bpp"
AgathaSprite:         INCBIN "gfx/sprites/agatha.2bpp"
BrunoSprite:          INCBIN "gfx/sprites/bruno.2bpp"
LoreleiSprite:        INCBIN "gfx/sprites/lorelei.2bpp"
SeelSprite:           INCBIN "gfx/sprites/seel.2bpp"

INCLUDE "engine/battle/moveEffects/substitute_effect.asm"
INCLUDE "engine/menu/pc.asm"

SECTION "bank06",ROMX,BANK[$06]
	dr $18000,$1a4ea
PlayerStepOutFromDoor: ; 1a4ea (6:64ea)
	dr $1a4ea,$1a527
_EndNPCMovementScript: ; 1a527 (6:6527)
	dr $1a527,$1a54c
ProfOakMovementScriptPointerTable: ; 1a54c (6:654c)
	dr $1a54c,$1a622
PewterMuseumGuyMovementScriptPointerTable: ; 1a622 (6:6622)
	dr $1a622,$1a685
PewterGymGuyMovementScriptPointerTable: ; 1a685 (6:6685)
	dr $1a685,$1a785
IsPlayerStandingOnDoorTile: ; 1a785 (6:6785)
	dr $1a785,$1a7f4
HandleLedges: ; 1a7f4 (6:67f4)
	dr $1a7f4,$1c000

SECTION "bank07",ROMX,BANK[$07]

	dr $1c000,$1c21e
DoClearSaveDialogue: ; 1c21e (7:421e)
	dr $1c21e,$1e2ae
OpenOaksPC: ; 1e2ae (7:62ae)
	dr $1e2ae,$1e321
SafariZoneCheck: ; 1e321 (7:6e21)
	dr $1e321,$1e330
SafariZoneCheckSteps: ; 1e330 (7:6330)
	dr $1e330,$1e385
PrintSafariGameOverText: ; 1e385 (7:6385)
	dr $1e385,$1e4bf
CinnabarGymQuiz_1e4bf: ; 1e4bf (7:64bf)
	dr $1e4bf,$20000

SECTION "Pics 1", ROMX, BANK[PICS_1]

RhydonPicFront:      INCBIN "pic/ymon/rhydon.pic"
RhydonPicBack:       INCBIN "pic/monback/rhydonb.pic"
KangaskhanPicFront:  INCBIN "pic/ymon/kangaskhan.pic"
KangaskhanPicBack:   INCBIN "pic/monback/kangaskhanb.pic"
NidoranMPicFront:    INCBIN "pic/ymon/nidoranm.pic"
NidoranMPicBack:     INCBIN "pic/monback/nidoranmb.pic"
ClefairyPicFront:    INCBIN "pic/ymon/clefairy.pic"
ClefairyPicBack:     INCBIN "pic/monback/clefairyb.pic"
SpearowPicFront:     INCBIN "pic/ymon/spearow.pic"
SpearowPicBack:      INCBIN "pic/monback/spearowb.pic"
VoltorbPicFront:     INCBIN "pic/ymon/voltorb.pic"
VoltorbPicBack:      INCBIN "pic/monback/voltorbb.pic"
NidokingPicFront:    INCBIN "pic/ymon/nidoking.pic"
NidokingPicBack:     INCBIN "pic/monback/nidokingb.pic"
SlowbroPicFront:     INCBIN "pic/ymon/slowbro.pic"
SlowbroPicBack:      INCBIN "pic/monback/slowbrob.pic"
IvysaurPicFront:     INCBIN "pic/ymon/ivysaur.pic"
IvysaurPicBack:      INCBIN "pic/monback/ivysaurb.pic"
ExeggutorPicFront:   INCBIN "pic/ymon/exeggutor.pic"
ExeggutorPicBack:    INCBIN "pic/monback/exeggutorb.pic"
LickitungPicFront:   INCBIN "pic/ymon/lickitung.pic"
LickitungPicBack:    INCBIN "pic/monback/lickitungb.pic"
ExeggcutePicFront:   INCBIN "pic/ymon/exeggcute.pic"
ExeggcutePicBack:    INCBIN "pic/monback/exeggcuteb.pic"
GrimerPicFront:      INCBIN "pic/ymon/grimer.pic"
GrimerPicBack:       INCBIN "pic/monback/grimerb.pic"
GengarPicFront:      INCBIN "pic/ymon/gengar.pic"
GengarPicBack:       INCBIN "pic/monback/gengarb.pic"
NidoranFPicFront:    INCBIN "pic/ymon/nidoranf.pic"
NidoranFPicBack:     INCBIN "pic/monback/nidoranfb.pic"
NidoqueenPicFront:   INCBIN "pic/ymon/nidoqueen.pic"
NidoqueenPicBack:    INCBIN "pic/monback/nidoqueenb.pic"
CubonePicFront:      INCBIN "pic/ymon/cubone.pic"
CubonePicBack:       INCBIN "pic/monback/cuboneb.pic"
RhyhornPicFront:     INCBIN "pic/ymon/rhyhorn.pic"
RhyhornPicBack:      INCBIN "pic/monback/rhyhornb.pic"
LaprasPicFront:      INCBIN "pic/ymon/lapras.pic"
LaprasPicBack:       INCBIN "pic/monback/laprasb.pic"
ArcaninePicFront:    INCBIN "pic/ymon/arcanine.pic"
ArcaninePicBack:     INCBIN "pic/monback/arcanineb.pic"
MewPicFront:         INCBIN "pic/ymon/mew.pic"
MewPicBack:          INCBIN "pic/monback/mewb.pic"
GyaradosPicFront:    INCBIN "pic/ymon/gyarados.pic"
GyaradosPicBack:     INCBIN "pic/monback/gyaradosb.pic"
ShellderPicFront:    INCBIN "pic/ymon/shellder.pic"
ShellderPicBack:     INCBIN "pic/monback/shellderb.pic"
TentacoolPicFront:   INCBIN "pic/ymon/tentacool.pic"
TentacoolPicBack:    INCBIN "pic/monback/tentacoolb.pic"
GastlyPicFront:      INCBIN "pic/ymon/gastly.pic"
GastlyPicBack:       INCBIN "pic/monback/gastlyb.pic"
ScytherPicFront:     INCBIN "pic/ymon/scyther.pic"
ScytherPicBack:      INCBIN "pic/monback/scytherb.pic"
StaryuPicFront:      INCBIN "pic/ymon/staryu.pic"
StaryuPicBack:       INCBIN "pic/monback/staryub.pic"
BlastoisePicFront:   INCBIN "pic/ymon/blastoise.pic"
BlastoisePicBack:    INCBIN "pic/monback/blastoiseb.pic"
PinsirPicFront:      INCBIN "pic/ymon/pinsir.pic"
PinsirPicBack:       INCBIN "pic/monback/pinsirb.pic"
TangelaPicFront:     INCBIN "pic/ymon/tangela.pic"
TangelaPicBack:      INCBIN "pic/monback/tangelab.pic"

INCLUDE "engine/battle/print_type.asm"
INCLUDE "engine/battle/save_trainer_name.asm"

SECTION "Pics 2", ROMX, BANK[PICS_2]

GrowlithePicFront:   INCBIN "pic/ymon/growlithe.pic"
GrowlithePicBack:    INCBIN "pic/monback/growlitheb.pic"
OnixPicFront:        INCBIN "pic/ymon/onix.pic"
OnixPicBack:         INCBIN "pic/monback/onixb.pic"
FearowPicFront:      INCBIN "pic/ymon/fearow.pic"
FearowPicBack:       INCBIN "pic/monback/fearowb.pic"
PidgeyPicFront:      INCBIN "pic/ymon/pidgey.pic"
PidgeyPicBack:       INCBIN "pic/monback/pidgeyb.pic"
SlowpokePicFront:    INCBIN "pic/ymon/slowpoke.pic"
SlowpokePicBack:     INCBIN "pic/monback/slowpokeb.pic"
KadabraPicFront:     INCBIN "pic/ymon/kadabra.pic"
KadabraPicBack:      INCBIN "pic/monback/kadabrab.pic"
GravelerPicFront:    INCBIN "pic/ymon/graveler.pic"
GravelerPicBack:     INCBIN "pic/monback/gravelerb.pic"
ChanseyPicFront:     INCBIN "pic/ymon/chansey.pic"
ChanseyPicBack:      INCBIN "pic/monback/chanseyb.pic"
MachokePicFront:     INCBIN "pic/ymon/machoke.pic"
MachokePicBack:      INCBIN "pic/monback/machokeb.pic"
MrMimePicFront:      INCBIN "pic/ymon/mr.mime.pic"
MrMimePicBack:       INCBIN "pic/monback/mr.mimeb.pic"
HitmonleePicFront:   INCBIN "pic/ymon/hitmonlee.pic"
HitmonleePicBack:    INCBIN "pic/monback/hitmonleeb.pic"
HitmonchanPicFront:  INCBIN "pic/ymon/hitmonchan.pic"
HitmonchanPicBack:   INCBIN "pic/monback/hitmonchanb.pic"
ArbokPicFront:       INCBIN "pic/ymon/arbok.pic"
ArbokPicBack:        INCBIN "pic/monback/arbokb.pic"
ParasectPicFront:    INCBIN "pic/ymon/parasect.pic"
ParasectPicBack:     INCBIN "pic/monback/parasectb.pic"
PsyduckPicFront:     INCBIN "pic/ymon/psyduck.pic"
PsyduckPicBack:      INCBIN "pic/monback/psyduckb.pic"
DrowzeePicFront:     INCBIN "pic/ymon/drowzee.pic"
DrowzeePicBack:      INCBIN "pic/monback/drowzeeb.pic"
GolemPicFront:       INCBIN "pic/ymon/golem.pic"
GolemPicBack:        INCBIN "pic/monback/golemb.pic"
MagmarPicFront:      INCBIN "pic/ymon/magmar.pic"
MagmarPicBack:       INCBIN "pic/monback/magmarb.pic"
ElectabuzzPicFront:  INCBIN "pic/ymon/electabuzz.pic"
ElectabuzzPicBack:   INCBIN "pic/monback/electabuzzb.pic"
MagnetonPicFront:    INCBIN "pic/ymon/magneton.pic"
MagnetonPicBack:     INCBIN "pic/monback/magnetonb.pic"
KoffingPicFront:     INCBIN "pic/ymon/koffing.pic"
KoffingPicBack:      INCBIN "pic/monback/koffingb.pic"
MankeyPicFront:      INCBIN "pic/ymon/mankey.pic"
MankeyPicBack:       INCBIN "pic/monback/mankeyb.pic"
SeelPicFront:        INCBIN "pic/ymon/seel.pic"
SeelPicBack:         INCBIN "pic/monback/seelb.pic"
DiglettPicFront:     INCBIN "pic/ymon/diglett.pic"
DiglettPicBack:      INCBIN "pic/monback/diglettb.pic"
TaurosPicFront:      INCBIN "pic/ymon/tauros.pic"
TaurosPicBack:       INCBIN "pic/monback/taurosb.pic"
FarfetchdPicFront:   INCBIN "pic/ymon/farfetchd.pic"
FarfetchdPicBack:    INCBIN "pic/monback/farfetchdb.pic"
VenonatPicFront:     INCBIN "pic/ymon/venonat.pic"
VenonatPicBack:      INCBIN "pic/monback/venonatb.pic"
DragonitePicFront:   INCBIN "pic/ymon/dragonite.pic"
DragonitePicBack:    INCBIN "pic/monback/dragoniteb.pic"
DoduoPicFront:       INCBIN "pic/ymon/doduo.pic"
DoduoPicBack:        INCBIN "pic/monback/doduob.pic"
PoliwagPicFront:     INCBIN "pic/ymon/poliwag.pic"
PoliwagPicBack:      INCBIN "pic/monback/poliwagb.pic"
JynxPicFront:        INCBIN "pic/ymon/jynx.pic"
JynxPicBack:         INCBIN "pic/monback/jynxb.pic"
MoltresPicFront:     INCBIN "pic/ymon/moltres.pic"
MoltresPicBack:      INCBIN "pic/monback/moltresb.pic"

INCLUDE "engine/predefsA.asm"
INCLUDE "engine/battle/moveEffects/leech_seed_effect.asm"

SECTION "Pics 3", ROMX, BANK[PICS_3]

ArticunoPicFront:    INCBIN "pic/ymon/articuno.pic"
ArticunoPicBack:     INCBIN "pic/monback/articunob.pic"
ZapdosPicFront:      INCBIN "pic/ymon/zapdos.pic"
ZapdosPicBack:       INCBIN "pic/monback/zapdosb.pic"
DittoPicFront:       INCBIN "pic/ymon/ditto.pic"
DittoPicBack:        INCBIN "pic/monback/dittob.pic"
MeowthPicFront:      INCBIN "pic/ymon/meowth.pic"
MeowthPicBack:       INCBIN "pic/monback/meowthb.pic"
KrabbyPicFront:      INCBIN "pic/ymon/krabby.pic"
KrabbyPicBack:       INCBIN "pic/monback/krabbyb.pic"
VulpixPicFront:      INCBIN "pic/ymon/vulpix.pic"
VulpixPicBack:       INCBIN "pic/monback/vulpixb.pic"
NinetalesPicFront:   INCBIN "pic/ymon/ninetales.pic"
NinetalesPicBack:    INCBIN "pic/monback/ninetalesb.pic"
PikachuPicFront:     INCBIN "pic/ymon/pikachu.pic"
PikachuPicBack:      INCBIN "pic/monback/pikachub.pic"
RaichuPicFront:      INCBIN "pic/ymon/raichu.pic"
RaichuPicBack:       INCBIN "pic/monback/raichub.pic"
DratiniPicFront:     INCBIN "pic/ymon/dratini.pic"
DratiniPicBack:      INCBIN "pic/monback/dratinib.pic"
DragonairPicFront:   INCBIN "pic/ymon/dragonair.pic"
DragonairPicBack:    INCBIN "pic/monback/dragonairb.pic"
KabutoPicFront:      INCBIN "pic/ymon/kabuto.pic"
KabutoPicBack:       INCBIN "pic/monback/kabutob.pic"
KabutopsPicFront:    INCBIN "pic/ymon/kabutops.pic"
KabutopsPicBack:     INCBIN "pic/monback/kabutopsb.pic"
HorseaPicFront:      INCBIN "pic/ymon/horsea.pic"
HorseaPicBack:       INCBIN "pic/monback/horseab.pic"
SeadraPicFront:      INCBIN "pic/ymon/seadra.pic"
SeadraPicBack:       INCBIN "pic/monback/seadrab.pic"
SandshrewPicFront:   INCBIN "pic/ymon/sandshrew.pic"
SandshrewPicBack:    INCBIN "pic/monback/sandshrewb.pic"
SandslashPicFront:   INCBIN "pic/ymon/sandslash.pic"
SandslashPicBack:    INCBIN "pic/monback/sandslashb.pic"
OmanytePicFront:     INCBIN "pic/ymon/omanyte.pic"
OmanytePicBack:      INCBIN "pic/monback/omanyteb.pic"
OmastarPicFront:     INCBIN "pic/ymon/omastar.pic"
OmastarPicBack:      INCBIN "pic/monback/omastarb.pic"
JigglypuffPicFront:  INCBIN "pic/ymon/jigglypuff.pic"
JigglypuffPicBack:   INCBIN "pic/monback/jigglypuffb.pic"
WigglytuffPicFront:  INCBIN "pic/ymon/wigglytuff.pic"
WigglytuffPicBack:   INCBIN "pic/monback/wigglytuffb.pic"
EeveePicFront:       INCBIN "pic/ymon/eevee.pic"
EeveePicBack:        INCBIN "pic/monback/eeveeb.pic"
FlareonPicFront:     INCBIN "pic/ymon/flareon.pic"
FlareonPicBack:      INCBIN "pic/monback/flareonb.pic"
JolteonPicFront:     INCBIN "pic/ymon/jolteon.pic"
JolteonPicBack:      INCBIN "pic/monback/jolteonb.pic"
VaporeonPicFront:    INCBIN "pic/ymon/vaporeon.pic"
VaporeonPicBack:     INCBIN "pic/monback/vaporeonb.pic"
MachopPicFront:      INCBIN "pic/ymon/machop.pic"
MachopPicBack:       INCBIN "pic/monback/machopb.pic"
ZubatPicFront:       INCBIN "pic/ymon/zubat.pic"
ZubatPicBack:        INCBIN "pic/monback/zubatb.pic"
EkansPicFront:       INCBIN "pic/ymon/ekans.pic"
EkansPicBack:        INCBIN "pic/monback/ekansb.pic"
ParasPicFront:       INCBIN "pic/ymon/paras.pic"
ParasPicBack:        INCBIN "pic/monback/parasb.pic"
PoliwhirlPicFront:   INCBIN "pic/ymon/poliwhirl.pic"
PoliwhirlPicBack:    INCBIN "pic/monback/poliwhirlb.pic"
PoliwrathPicFront:   INCBIN "pic/ymon/poliwrath.pic"
PoliwrathPicBack:    INCBIN "pic/monback/poliwrathb.pic"
WeedlePicFront:      INCBIN "pic/ymon/weedle.pic"
WeedlePicBack:       INCBIN "pic/monback/weedleb.pic"
KakunaPicFront:      INCBIN "pic/ymon/kakuna.pic"
KakunaPicBack:       INCBIN "pic/monback/kakunab.pic"
BeedrillPicFront:    INCBIN "pic/ymon/beedrill.pic"
BeedrillPicBack:     INCBIN "pic/monback/beedrillb.pic"

FossilKabutopsPic:   INCBIN "pic/ymon/fossilkabutops.pic"

INCLUDE "engine/battle/display_effectiveness.asm"
INCLUDE "engine/items/tmhm.asm"

Func_2fd6a: ; 2fd6a (b:7d6a)
	callab IsThisPartymonStarterPikachu_Party
	ret nc
	ld a, $3
	ld [wd431], a
	ret
	
INCLUDE "engine/battle/scale_sprites.asm"
INCLUDE "engine/game_corner_slots2.asm"

SECTION "Pics 4", ROMX, BANK[PICS_4]

DodrioPicFront:       INCBIN "pic/ymon/dodrio.pic"
DodrioPicBack:        INCBIN "pic/monback/dodriob.pic"
PrimeapePicFront:     INCBIN "pic/ymon/primeape.pic"
PrimeapePicBack:      INCBIN "pic/monback/primeapeb.pic"
DugtrioPicFront:      INCBIN "pic/ymon/dugtrio.pic"
DugtrioPicBack:       INCBIN "pic/monback/dugtriob.pic"
VenomothPicFront:     INCBIN "pic/ymon/venomoth.pic"
VenomothPicBack:      INCBIN "pic/monback/venomothb.pic"
DewgongPicFront:      INCBIN "pic/ymon/dewgong.pic"
DewgongPicBack:       INCBIN "pic/monback/dewgongb.pic"
CaterpiePicFront:     INCBIN "pic/ymon/caterpie.pic"
CaterpiePicBack:      INCBIN "pic/monback/caterpieb.pic"
MetapodPicFront:      INCBIN "pic/ymon/metapod.pic"
MetapodPicBack:       INCBIN "pic/monback/metapodb.pic"
ButterfreePicFront:   INCBIN "pic/ymon/butterfree.pic"
ButterfreePicBack:    INCBIN "pic/monback/butterfreeb.pic"
MachampPicFront:      INCBIN "pic/ymon/machamp.pic"
MachampPicBack:       INCBIN "pic/monback/machampb.pic"
GolduckPicFront:      INCBIN "pic/ymon/golduck.pic"
GolduckPicBack:       INCBIN "pic/monback/golduckb.pic"
HypnoPicFront:        INCBIN "pic/ymon/hypno.pic"
HypnoPicBack:         INCBIN "pic/monback/hypnob.pic"
GolbatPicFront:       INCBIN "pic/ymon/golbat.pic"
GolbatPicBack:        INCBIN "pic/monback/golbatb.pic"
MewtwoPicFront:       INCBIN "pic/ymon/mewtwo.pic"
MewtwoPicBack:        INCBIN "pic/monback/mewtwob.pic"
SnorlaxPicFront:      INCBIN "pic/ymon/snorlax.pic"
SnorlaxPicBack:       INCBIN "pic/monback/snorlaxb.pic"
MagikarpPicFront:     INCBIN "pic/ymon/magikarp.pic"
MagikarpPicBack:      INCBIN "pic/monback/magikarpb.pic"
MukPicFront:          INCBIN "pic/ymon/muk.pic"
MukPicBack:           INCBIN "pic/monback/mukb.pic"
KinglerPicFront:      INCBIN "pic/ymon/kingler.pic"
KinglerPicBack:       INCBIN "pic/monback/kinglerb.pic"
CloysterPicFront:     INCBIN "pic/ymon/cloyster.pic"
CloysterPicBack:      INCBIN "pic/monback/cloysterb.pic"
ElectrodePicFront:    INCBIN "pic/ymon/electrode.pic"
ElectrodePicBack:     INCBIN "pic/monback/electrodeb.pic"
ClefablePicFront:     INCBIN "pic/ymon/clefable.pic"
ClefablePicBack:      INCBIN "pic/monback/clefableb.pic"
WeezingPicFront:      INCBIN "pic/ymon/weezing.pic"
WeezingPicBack:       INCBIN "pic/monback/weezingb.pic"
PersianPicFront:      INCBIN "pic/ymon/persian.pic"
PersianPicBack:       INCBIN "pic/monback/persianb.pic"
MarowakPicFront:      INCBIN "pic/ymon/marowak.pic"
MarowakPicBack:       INCBIN "pic/monback/marowakb.pic"
HaunterPicFront:      INCBIN "pic/ymon/haunter.pic"
HaunterPicBack:       INCBIN "pic/monback/haunterb.pic"
AbraPicFront:         INCBIN "pic/ymon/abra.pic"
AbraPicBack:          INCBIN "pic/monback/abrab.pic"
AlakazamPicFront:     INCBIN "pic/ymon/alakazam.pic"
AlakazamPicBack:      INCBIN "pic/monback/alakazamb.pic"
PidgeottoPicFront:    INCBIN "pic/ymon/pidgeotto.pic"
PidgeottoPicBack:     INCBIN "pic/monback/pidgeottob.pic"
PidgeotPicFront:      INCBIN "pic/ymon/pidgeot.pic"
PidgeotPicBack:       INCBIN "pic/monback/pidgeotb.pic"
StarmiePicFront:      INCBIN "pic/ymon/starmie.pic"
StarmiePicBack:       INCBIN "pic/monback/starmieb.pic"


SECTION "Pics 5", ROMX, BANK[PICS_5]

BulbasaurPicFront:    INCBIN "pic/ymon/bulbasaur.pic"
BulbasaurPicBack:     INCBIN "pic/monback/bulbasaurb.pic"
VenusaurPicFront:     INCBIN "pic/ymon/venusaur.pic"
VenusaurPicBack:      INCBIN "pic/monback/venusaurb.pic"
TentacruelPicFront:   INCBIN "pic/ymon/tentacruel.pic"
TentacruelPicBack:    INCBIN "pic/monback/tentacruelb.pic"
GoldeenPicFront:      INCBIN "pic/ymon/goldeen.pic"
GoldeenPicBack:       INCBIN "pic/monback/goldeenb.pic"
SeakingPicFront:      INCBIN "pic/ymon/seaking.pic"
SeakingPicBack:       INCBIN "pic/monback/seakingb.pic"
PonytaPicFront:       INCBIN "pic/ymon/ponyta.pic"
RapidashPicFront:     INCBIN "pic/ymon/rapidash.pic"
PonytaPicBack:        INCBIN "pic/monback/ponytab.pic"
RapidashPicBack:      INCBIN "pic/monback/rapidashb.pic"
RattataPicFront:      INCBIN "pic/ymon/rattata.pic"
RattataPicBack:       INCBIN "pic/monback/rattatab.pic"
RaticatePicFront:     INCBIN "pic/ymon/raticate.pic"
RaticatePicBack:      INCBIN "pic/monback/raticateb.pic"
NidorinoPicFront:     INCBIN "pic/ymon/nidorino.pic"
NidorinoPicBack:      INCBIN "pic/monback/nidorinob.pic"
NidorinaPicFront:     INCBIN "pic/ymon/nidorina.pic"
NidorinaPicBack:      INCBIN "pic/monback/nidorinab.pic"
GeodudePicFront:      INCBIN "pic/ymon/geodude.pic"
GeodudePicBack:       INCBIN "pic/monback/geodudeb.pic"
PorygonPicFront:      INCBIN "pic/ymon/porygon.pic"
PorygonPicBack:       INCBIN "pic/monback/porygonb.pic"
AerodactylPicFront:   INCBIN "pic/ymon/aerodactyl.pic"
AerodactylPicBack:    INCBIN "pic/monback/aerodactylb.pic"
MagnemitePicFront:    INCBIN "pic/ymon/magnemite.pic"
MagnemitePicBack:     INCBIN "pic/monback/magnemiteb.pic"
CharmanderPicFront:   INCBIN "pic/ymon/charmander.pic"
CharmanderPicBack:    INCBIN "pic/monback/charmanderb.pic"
SquirtlePicFront:     INCBIN "pic/ymon/squirtle.pic"
SquirtlePicBack:      INCBIN "pic/monback/squirtleb.pic"
CharmeleonPicFront:   INCBIN "pic/ymon/charmeleon.pic"
CharmeleonPicBack:    INCBIN "pic/monback/charmeleonb.pic"
WartortlePicFront:    INCBIN "pic/ymon/wartortle.pic"
WartortlePicBack:     INCBIN "pic/monback/wartortleb.pic"
CharizardPicFront:    INCBIN "pic/ymon/charizard.pic"
CharizardPicBack:     INCBIN "pic/monback/charizardb.pic"
FossilAerodactylPic:  INCBIN "pic/ymon/fossilaerodactyl.pic"
GhostPic:             INCBIN "pic/other/ghost.pic"
OddishPicFront:       INCBIN "pic/ymon/oddish.pic"
OddishPicBack:        INCBIN "pic/monback/oddishb.pic"
GloomPicFront:        INCBIN "pic/ymon/gloom.pic"
GloomPicBack:         INCBIN "pic/monback/gloomb.pic"
VileplumePicFront:    INCBIN "pic/ymon/vileplume.pic"
VileplumePicBack:     INCBIN "pic/monback/vileplumeb.pic"
BellsproutPicFront:   INCBIN "pic/ymon/bellsprout.pic"
BellsproutPicBack:    INCBIN "pic/monback/bellsproutb.pic"
WeepinbellPicFront:   INCBIN "pic/ymon/weepinbell.pic"
WeepinbellPicBack:    INCBIN "pic/monback/weepinbellb.pic"
VictreebelPicFront:   INCBIN "pic/ymon/victreebel.pic"
VictreebelPicBack:    INCBIN "pic/monback/victreebelb.pic"

INCLUDE "engine/titlescreen2.asm"
INCLUDE "engine/slot_machine.asm"
INCLUDE "engine/game_corner_slots.asm"

SECTION "bank0E",ROMX,BANK[$0E]

INCLUDE "data/moves.asm"
BaseStats: INCLUDE "data/base_stats.asm"
INCLUDE "data/cries.asm"
INCLUDE "engine/battle/trainer_ai.asm"
INCLUDE "engine/battle/draw_hud_pokeball_gfx.asm"

TradingAnimationGraphics:
	INCBIN "gfx/game_boy.norepeat.2bpp"
	INCBIN "gfx/link_cable.2bpp"
TradingAnimationGraphicsEnd:
	
TradingAnimationGraphics2:
; Pokeball traveling through the link cable.
	INCBIN "gfx/trade2.2bpp"
TradingAnimationGraphics2End:

INCLUDE "engine/evos_moves.asm"


SECTION "bank0F",ROMX,BANK[$0F]

INCLUDE "engine/battle/core.asm"

SECTION "bank10",ROMX,BANK[$10]

INCLUDE "engine/menu/pokedex.asm"
INCLUDE "engine/overworld/emotion_bubbles.asm"
INCLUDE "engine/trade.asm"
INCLUDE "engine/intro.asm"
INCLUDE "engine/trade2.asm"
INCLUDE "engine/menu/options.asm"


SECTION "bank11",ROMX,BANK[$11]

	dr $44000,$45077
LoadSpinnerArrowTiles: ; 45077 (11:5077)
	dr $45077,$48000


SECTION "bank12",ROMX,BANK[$12]

	dr $48000,$4c000


SECTION "bank13",ROMX,BANK[$13]

TrainerPics:
YoungsterPic:     INCBIN "pic/trainer/youngster.pic"
BugCatcherPic:    INCBIN "pic/trainer/bugcatcher.pic"
LassPic:          INCBIN "pic/trainer/lass.pic"
SailorPic:        INCBIN "pic/trainer/sailor.pic"
JrTrainerMPic:    INCBIN "pic/trainer/jr.trainerm.pic"
JrTrainerFPic:    INCBIN "pic/trainer/jr.trainerf.pic"
PokemaniacPic:    INCBIN "pic/trainer/pokemaniac.pic"
SuperNerdPic:     INCBIN "pic/trainer/supernerd.pic"
HikerPic:         INCBIN "pic/trainer/hiker.pic"
BikerPic:         INCBIN "pic/trainer/biker.pic"
BurglarPic:       INCBIN "pic/trainer/burglar.pic"
EngineerPic:      INCBIN "pic/trainer/engineer.pic"
FisherPic:        INCBIN "pic/trainer/fisher.pic"
SwimmerPic:       INCBIN "pic/trainer/swimmer.pic"
CueBallPic:       INCBIN "pic/trainer/cueball.pic"
GamblerPic:       INCBIN "pic/trainer/gambler.pic"
BeautyPic:        INCBIN "pic/trainer/beauty.pic"
PsychicPic:       INCBIN "pic/trainer/psychic.pic"
RockerPic:        INCBIN "pic/trainer/rocker.pic"
JugglerPic:       INCBIN "pic/trainer/juggler.pic"
TamerPic:         INCBIN "pic/trainer/tamer.pic"
BirdKeeperPic:    INCBIN "pic/trainer/birdkeeper.pic"
BlackbeltPic:     INCBIN "pic/trainer/blackbelt.pic"
Rival1Pic:        INCBIN "pic/ytrainer/rival1.pic"
ProfOakPic:       INCBIN "pic/trainer/prof.oak.pic"
ChiefPic:
ScientistPic:     INCBIN "pic/trainer/scientist.pic"
GiovanniPic:      INCBIN "pic/trainer/giovanni.pic"
RocketPic:        INCBIN "pic/trainer/rocket.pic"
CooltrainerMPic:  INCBIN "pic/trainer/cooltrainerm.pic"
CooltrainerFPic:  INCBIN "pic/trainer/cooltrainerf.pic"
BrunoPic:         INCBIN "pic/trainer/bruno.pic"
BrockPic:         INCBIN "pic/ytrainer/brock.pic"
MistyPic:         INCBIN "pic/ytrainer/misty.pic"
LtSurgePic:       INCBIN "pic/trainer/lt.surge.pic"
ErikaPic:         INCBIN "pic/ytrainer/erika.pic"
KogaPic:          INCBIN "pic/trainer/koga.pic"
BlainePic:        INCBIN "pic/trainer/blaine.pic"
SabrinaPic:       INCBIN "pic/trainer/sabrina.pic"
GentlemanPic:     INCBIN "pic/trainer/gentleman.pic"
Rival2Pic:        INCBIN "pic/ytrainer/rival2.pic"
Rival3Pic:        INCBIN "pic/ytrainer/rival3.pic"
LoreleiPic:       INCBIN "pic/trainer/lorelei.pic"
ChannelerPic:     INCBIN "pic/trainer/channeler.pic"
AgathaPic:        INCBIN "pic/trainer/agatha.pic"
LancePic:         INCBIN "pic/trainer/lance.pic"
JessieJamesPic:   INCBIN "pic/ytrainer/jessiejames.pic"

	dr $4fe79,$50000


SECTION "bank14",ROMX,BANK[$14]

	dr $50000,$525d8
PrintCardKeyText: ; 525d8 (14:65d8)
	dr $525d8,$5267d
CeladonPrizeMenu: ; 5267d (14:667d)
	dr $5267d,$54000

SECTION "bank15",ROMX,BANK[$15]

	dr $54000,$5525f
GainExperience: ; 5525f (15:525f)
	dr $5525f,$56745
_GetSpritePosition1: ; 56745 (15:6745)
	dr $56745,$56765
_GetSpritePosition2: ; 56765 (15:6765)
	dr $56765,$56789
_SetSpritePosition1: ; 56789 (15:6789)
	dr $56789,$567a9
_SetSpritePosition2: ; 567a9 (15:67a9)
	dr $567a9,$567cd
TrainerWalkUpToPlayer: ; 567cd (15:67cd)
	dr $567cd,$58000
SECTION "bank16",ROMX,BANK[$16]

	dr $58000,$58d99
CalcLevelFromExperience: ; 58d99 (16:4d99)
	dr $58d99,$58dc0
CalcExperience: ; 58dc0 (16:4dc0)
	dr $58dc0,$58e8b
PrintStatusAilment: ; 58e8b (16:4e8b)
	dr $58e8b,$5c000


SECTION "bank17",ROMX,BANK[$17]

	dr $5c000,$5da70
EvolveMon: ; 5da70 (17:5a70)
	dr $5da70,$60000


SECTION "bank18",ROMX,BANK[$18]

	dr $60000,$64000


SECTION "bank19",ROMX,BANK[$19]
Overworld_GFX:
	dr $64000,$68000


SECTION "bank1A",ROMX,BANK[$1A]

	dr $68000,$6c000


SECTION "bank1B",ROMX,BANK[$1B]
Cemetery_GFX:      INCBIN "gfx/tilesets/cemetery.t4.2bpp"
Cemetery_Block:    INCBIN "gfx/blocksets/cemetery.bst"
Cavern_GFX:        INCBIN "gfx/tilesets/cavern.t14.2bpp"
Cavern_Block:      INCBIN "gfx/blocksets/cavern.bst"
Lobby_GFX:         INCBIN "gfx/tilesets/lobby.t2.2bpp"
Lobby_Block:       INCBIN "gfx/blocksets/lobby.bst"
Ship_GFX:          INCBIN "gfx/tilesets/ship.t6.2bpp"
Ship_Block:        INCBIN "gfx/blocksets/ship.bst"
Lab_GFX:           INCBIN "gfx/tilesets/lab.t4.2bpp"
Lab_Block:         INCBIN "gfx/blocksets/lab.bst"
Club_GFX:          INCBIN "gfx/tilesets/club.t5.2bpp"
Club_Block:        INCBIN "gfx/blocksets/club.bst"
Underground_GFX:   INCBIN "gfx/tilesets/underground.t7.2bpp"
Underground_Block: INCBIN "gfx/blocksets/underground.bst"


SECTION "bank1C",ROMX,BANK[$1C]

INCLUDE "engine/gamefreak.asm"
INCLUDE "engine/hall_of_fame.asm"
INCLUDE "engine/overworld/healing_machine.asm"
INCLUDE "engine/overworld/player_animations.asm"
INCLUDE "engine/battle/ghost_marowak_anim.asm"
INCLUDE "engine/battle/battle_transitions.asm"
INCLUDE "engine/town_map.asm"
INCLUDE "engine/mon_party_sprites.asm"
INCLUDE "engine/in_game_trades.asm"
INCLUDE "engine/palettes.asm"
INCLUDE "engine/save.asm"


SECTION "bank1D",ROMX,BANK[$1D]

	dr $74000,$7405c
HiddenItemNear: ; 7405c (1d:405c)
	dr $7405c,$74726
VendingMachineMenu: ; 74726 (1d:4726)
	dr $74726,$75dfe
PKMNLeaguePC: ; 75dfe (1d:5dfe)
	dr $75dfe,$78000

SECTION "bank1E",ROMX,BANK[$1E]

	dr $78000,$78757
AnimationTileset2: ; 78757 (1e:4757)
	dr $78757,$78c17
SlotMachineTiles2: ; 78c17 (1e:4c17)
	dr $78c17,$78e98
Func_78e98: ; 78e98 (1e:4e98)
	dr $78e98,$79349
AnimationSlideMonOff: ; 79349 (1e:5349)
	dr $79349,$79353
AnimationSlideEnemyMonOff: ; 79353 (1e:5353)
	dr $79353,$7966e
AnimationMinimizeMon: ; 7966e (1e:566e)
	dr $7966e,$797af
AnimationSubstitute: ; 797af (1e:57af)
	dr $797af,$79816
HideSubstituteShowMonAnim: ; 79816 (1e:5816)
	dr $79816,$798b2
ReshowSubstituteAnim: ; 798b2 (1e:58b2)
	dr $798b2,$798c8
AnimationTransformMon: ; 798c8 (1e:58c8)
	dr $798c8,$798d4
ChangeMonPic: ; 798d4 (1e:58d4)
	dr $798d4,$79929
Func_79929: ; 79929 (1e:5929)
	dr $79929,$7a037
AnimCut: ; 7a037 (1e:6037)
	dr $7a037,$7a0fb
AnimateBoulderDust: ; 7a0fb (1e:60fb)
	dr $7a0fb,$7a19a
	
RedFishingTilesFront: INCBIN "gfx/red_fishing_tile_front.2bpp"
RedFishingTilesBack:  INCBIN "gfx/red_fishing_tile_back.2bpp"
RedFishingTilesSide:  INCBIN "gfx/red_fishing_tile_side.2bpp"
RedFishingRodTiles:   INCBIN "gfx/red_fishingrod_tiles.2bpp"

	dr $7a22a,$7c000

SECTION "bank20",ROMX,BANK[$20]

	dr $80000,$80f14

SurfingPikachu1Graphics:  INCBIN "gfx/surfing_pikachu_1.t4.2bpp"
Func_82bd4: ; 82bd4 (20:6bd4)
	dr $82bd4,$84000

SECTION "bank2f",ROMX[$5000],BANK[$2F]

INCLUDE "engine/bg_map_attributes.asm"

SECTION "bank30",ROMX,BANK[$30]

	dr $c0000,$c4000

SECTION "bank39",ROMX,BANK[$39]

	dr $e4000,$e8000


SECTION "bank3A",ROMX,BANK[$3A]
MonsterNames: ; e8000 (3a:4000)
	dr $e8000,$e876c
IsPlayerJustOutsideMap: ; e876c (3a:476c)
	dr $e876c,$e8a5e
Func_e8a5e: ; e8a5e (3a:4a5e)
	dr $e8a5e,$e8b74
Func_e8b74: ; e8b74 (3a:4b74)
	dr $e8b74,$e8d35
Func_e8d35:: ; e8d35 (3a:4d35)
	dr $e8d35,$e8e79
Func_e8e79: ; e8e79 (3a:4e79)
	dr $e8e79,$e928a
SurfingPikachu2Graphics:  INCBIN "gfx/surfing_pikachu_2.2bpp"
	dr $e988a,$e9bfa

SurfingPikachu3Graphics:  INCBIN "gfx/surfing_pikachu_3.t1.2bpp"

	dr $ea3ea,$eaa02
FreezeEnemyTrainerSprite: ; eaa02 (3a:6a02)
	dr $eaa02,$ec000

SECTION "bank3C",ROMX,BANK[$3C]

INCLUDE "engine/bank3c.asm"

SECTION "bank3D",ROMX,BANK[$3D]

INCLUDE "engine/bank3d.asm"

SECTION "bank3E",ROMX,BANK[$3E]

	dr $f8000,$f982d
PlayIntroScene: ; f982d (3e:582d)
	dr $f982d,$fa35a

YellowIntroGraphics:  INCBIN "gfx/yellow_intro.2bpp"

	dr $fbb5a,$fc000

SECTION "bank3F",ROMX,BANK[$3F]

INCLUDE "engine/bank3f.asm"
