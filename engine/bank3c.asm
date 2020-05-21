INCLUDE "engine/pikachu_pcm.asm"
INCLUDE "engine/overworld/advance_player_sprite.asm"

INCLUDE "engine/black_out.asm"

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
	db POKEMON_MANSION_2F
	db POKEMON_MANSION_3F
	db POKEMON_MANSION_B1F
	db POKEMON_MANSION_1F
	db CINNABAR_GYM
	db GAME_CORNER
	db ROCKET_HIDEOUT_B1F
	db ROCKET_HIDEOUT_B4F
	db VICTORY_ROAD_3F
	db VICTORY_ROAD_1F
	db VICTORY_ROAD_2F
	db LANCES_ROOM
	db LORELEIS_ROOM
	db BRUNOS_ROOM
	db AGATHAS_ROOM
	db $ff

BeachHouse_GFX:
	INCBIN "gfx/tilesets/beachhouse.2bpp"
	ds 384

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
INCLUDE "scripts/ViridianCity2.asm"
INCLUDE "scripts/VermilionCity2.asm"
INCLUDE "scripts/CeladonCity2.asm"
INCLUDE "scripts/Route1_2.asm"
INCLUDE "scripts/Route22_2.asm"
INCLUDE "scripts/RedsHouse1F2.asm"
INCLUDE "scripts/OaksLab2.asm"
INCLUDE "scripts/ViridianSchoolHouse2.asm"
INCLUDE "scripts/Museum1F2.asm"
INCLUDE "scripts/PewterPokecenter2.asm"
INCLUDE "scripts/PokemonTower2F_2.asm"
INCLUDE "scripts/CeladonMart3F_2.asm"
INCLUDE "scripts/CeladonMansion1F_2.asm"
INCLUDE "scripts/CeladonMansion3F_2.asm"
INCLUDE "scripts/GameCorner2.asm"
INCLUDE "scripts/CeladonDiner2.asm"
INCLUDE "scripts/SafariZoneGate2.asm"
INCLUDE "scripts/CinnabarGym3.asm"
INCLUDE "scripts/MtMoonPokecenter2.asm"

INCLUDE "data/mapHeaders/BeachHouse.asm"
INCLUDE "scripts/BeachHouse.asm"
BeachHouse_Blocks:
INCBIN "maps/BeachHouse.blk"
INCLUDE "data/mapObjects/BeachHouse.asm"

INCLUDE "scripts/BeachHouse2.asm"
INCLUDE "scripts/BillsHouse2.asm"
INCLUDE "scripts/ViridianForest2.asm"
INCLUDE "scripts/SSAnne2FRooms_2.asm"
INCLUDE "scripts/SilphCo11F_2.asm"

INCLUDE "engine/overworld/hidden_objects.asm"
INCLUDE "engine/vermilion_gym_trash_cans.asm"
