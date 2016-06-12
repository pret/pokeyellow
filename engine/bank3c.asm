INCLUDE "engine/pikachu_pcm.asm"
INCLUDE "engine/overworld/advance_player_sprite.asm"

ResetStatusAndHalveMoneyOnBlackout:
; Reset player status on blackout.
	xor a
	ld [wd435], a
	xor a ; gamefreak copypasting functions (double xor a)
	ld [wBattleResult], a
	ld [wWalkBikeSurfState], a
	ld [wIsInBattle], a
	ld [wMapPalOffset], a
	ld [wNPCMovementScriptFunctionNum], a
	ld [hJoyHeld], a
	ld [wNPCMovementScriptPointerTableNum], a
	ld [wFlags_0xcd60], a

	ld [hMoney], a
	ld [hMoney + 1], a
	ld [hMoney + 2], a
	call HasEnoughMoney
	jr c, .lostmoney ; never happens

	; Halve the player's money.
	ld a, [wPlayerMoney]
	ld [hMoney], a
	ld a, [wPlayerMoney + 1]
	ld [hMoney + 1], a
	ld a, [wPlayerMoney + 2]
	ld [hMoney + 2], a
	xor a
	ld [hDivideBCDDivisor], a
	ld [hDivideBCDDivisor + 1], a
	ld a, 2
	ld [hDivideBCDDivisor + 2], a
	predef DivideBCDPredef3
	ld a, [hDivideBCDQuotient]
	ld [wPlayerMoney], a
	ld a, [hDivideBCDQuotient + 1]
	ld [wPlayerMoney + 1], a
	ld a, [hDivideBCDQuotient + 2]
	ld [wPlayerMoney + 2], a

.lostmoney
	ld hl, wd732
	set 2, [hl]
	res 3, [hl]
	set 6, [hl]
	ld a, %11111111
	ld [wJoyIgnore], a
	predef_jump HealParty

SetMapSpecificScriptFlagsOnMapReload:
	ld a, [wCurMap]
	cp VERMILION_GYM ; ??? new thing about verm gym?
	jr z, .verm_gym
	ld c, a
	ld hl, .MapList
.search_loop
	ld a, [hli]
	cp c
	jr z, .in_list
	cp a, $ff
	jr nz, .search_loop
	ret

.verm_gym
	ld hl, wCurrentMapScriptFlags
	set 6, [hl]
	ret

.in_list
	ld hl, wCurrentMapScriptFlags
	set 5, [hl]
	ret

.MapList
	db SILPH_CO_2F
	db SILPH_CO_3F
	db SILPH_CO_4F
	db SILPH_CO_5F
	db SILPH_CO_6F
	db SILPH_CO_7F
	db SILPH_CO_8F
	db SILPH_CO_9F
	db SILPH_CO_10F
	db SILPH_CO_11F
	db MANSION_2
	db MANSION_3
	db MANSION_4
	db MANSION_1
	db CINNABAR_GYM
	db GAME_CORNER
	db ROCKET_HIDEOUT_1
	db ROCKET_HIDEOUT_4
	db VICTORY_ROAD_3
	db VICTORY_ROAD_1
	db VICTORY_ROAD_2
	db LANCES_ROOM
	db LORELEIS_ROOM
	db BRUNOS_ROOM
	db AGATHAS_ROOM
	db $ff

BeachHouse_GFX:
	INCBIN "gfx/tilesets/beachhouse.2bpp"

BeachHouse_Block:
	INCBIN "gfx/blocksets/beachhouse.bst"

Func_f0a54:
	ret

LoadUnusedBluesHouseMissableObjectData:
; referenced in an unused function
	ld hl, .MissableObjectsMaps
.loop
	ld a, [hli]
	cp a, $ff
	ret z
	ld b, a
	ld a, [wCurMap]
	cp b
	jr z, .found
	inc hl
	inc hl
	inc hl
	jr .loop

.found
	ld a, [hli]
	ld c, a
	ld b, 0
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wMissableObjectList
	call CopyData
	ret

.MissableObjectsMaps:
	dbbw BLUES_HOUSE, .End - .Start, .Start
	db $ff

.Start:
	db 1, HS_DAISY_SITTING_COPY
	db 2, HS_DAISY_WALKING_COPY
	db 3, HS_TOWN_MAP_COPY
	db $ff
.End:

TryApplyPikachuMovementData:
	ld a, [wd472]
	bit 7, a
	ret z
	ld a, [wWalkBikeSurfState]
	and a
	ret nz
	push hl
	push bc
	callab GetPikachuFacingDirectionAndReturnToE
	pop bc
	pop hl
	ld a, b
	cp e
	ret nz
	push hl
	ld a, [wUpdateSpritesEnabled]
	push af
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	callab LoadPikachuShadowIntoVRAM
	pop af
	ld [wUpdateSpritesEnabled], a
	pop hl
	call ApplyPikachuMovementData
	callab RefreshPikachuFollow
	ret

Pic_f0abf:
INCBIN "gfx/pikachu/unknown_f0abf.pic"
GFX_f0b64:
INCBIN "gfx/pikachu/unknown_f0b64.2bpp"
Pic_f0cf4:
INCBIN "gfx/pikachu/unknown_f0cf4.pic"
GFX_f0d82:
INCBIN "gfx/pikachu/unknown_f0d82.2bpp"

PokecenterChanseyText:
	ld hl, NurseChanseyText
	call PrintText
	ld a, CHANSEY
	call PlayCry
	call WaitForSoundToFinish
	ret

NurseChanseyText:
	TX_FAR _NurseChanseyText
	db "@"

INCLUDE "engine/HoF_room_pc.asm"
INCLUDE "scripts/viridiancity2.asm"
INCLUDE "scripts/vermilioncity2.asm"
INCLUDE "scripts/celadoncity2.asm"
INCLUDE "scripts/route1_2.asm"
INCLUDE "scripts/route22_2.asm"
INCLUDE "scripts/redshouse1f2.asm"
INCLUDE "scripts/oakslab2.asm"
INCLUDE "scripts/school2.asm"
INCLUDE "scripts/museum1f2.asm"
INCLUDE "scripts/pewterpokecenter2.asm"
INCLUDE "scripts/pokemontower2_2.asm"
INCLUDE "scripts/celadonmart3_2.asm"
INCLUDE "scripts/celadonmansion1_2.asm"
INCLUDE "scripts/celadonmansion3_2.asm"
INCLUDE "scripts/celadongamecorner2.asm"
INCLUDE "scripts/celadondiner2.asm"
INCLUDE "scripts/safarizoneentrance2.asm"
INCLUDE "scripts/cinnabargym3.asm"
INCLUDE "scripts/mtmoonpokecenter2.asm"

INCLUDE "data/mapHeaders/beach_house.asm"
INCLUDE "scripts/beach_house.asm"
BeachHouseBlockdata:
INCBIN "maps/beach_house.blk"
INCLUDE "data/mapObjects/beach_house.asm"

INCLUDE "scripts/beach_house2.asm"
INCLUDE "scripts/billshouse2.asm"
INCLUDE "scripts/viridianforest2.asm"
INCLUDE "scripts/ssanne9_2.asm"
INCLUDE "scripts/silphco11_2.asm"

INCLUDE "engine/overworld/hidden_objects.asm"
INCLUDE "engine/vermilion_gym_trash_cans.asm"
