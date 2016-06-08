INCLUDE "engine/pikachu_pcm.asm"
INCLUDE "engine/overworld/advance_player_sprite.asm"

ResetStatusAndHalveMoneyOnBlackout: ; f0274 (3c:4274)
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

Func_f02da: ; f02da (3c:42da)
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
	ld hl, wd126
	set 6, [hl]
	ret

.in_list
	ld hl, wd126
	set 5, [hl]
	ret

.MapList ; f02fa (3c:42fa)
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

BeachHouse_GFX: ; f0314 (3c:4314)
	INCBIN "gfx/tilesets/beachhouse.2bpp"

BeachHouse_Block: ; f0914 (3c:4914)
	INCBIN "gfx/blocksets/beachhouse.bst"

Func_f0a54: ; f0a54 (3c:4a54)
	ret

Func_f0a55: ; f0a55 (3c:4a55)
; referenced in an unused function
	ld hl, Pointer_f0a76 ; 3c:4a76
.loop
	ld a, [hli]
	cp a, $ff
	ret z
	ld b, a
	ld a, [wCurMap]
	cp b
	jr z, .asm_f0a68
	inc hl
	inc hl
	inc hl
	jr .loop

.asm_f0a68
	ld a, [hli]
	ld c, a
	ld b, 0
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wMissableObjectList
	call CopyData
	ret

Pointer_f0a76: ; f0a76 (3c:4a76)
	dbbw BLUES_HOUSE, Pointer_f0a7bEnd - Pointer_f0a7b, Pointer_f0a7b
	db $ff

Pointer_f0a7b:
	db 1, HS_DAISY_SITTING_COPY
	db 2, HS_DAISY_WALKING_COPY
	db 3, HS_TOWN_MAP_COPY
	db $ff
Pointer_f0a7bEnd:

TryApplyPikachuMovementData: ; f0a82
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

Pic_f0abf: ; f0abf (3c:4abf)
INCBIN "gfx/pikachu/unknown_f0abf.pic"
GFX_f0b64: ; f0b64 (3c:4b64)
INCBIN "gfx/pikachu/unknown_f0b64.2bpp"
Pic_f0cf4: ; f0cf4 (3c:4cf4)
INCBIN "gfx/pikachu/unknown_f0cf4.pic"
GFX_f0d82: ; f0d82 (3c:4d82)
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

Func_f1e22:
	ld hl, PikachuMovementData_f1e2b
	ld b, SPRITE_FACING_RIGHT
	call TryApplyPikachuMovementData
	ret

PikachuMovementData_f1e2b:
	db $00
	db $1d
	db $1f
	db $38
	db $3f

INCLUDE "scripts/celadonmart3_2.asm"
INCLUDE "scripts/celadonmansion1_2.asm"
INCLUDE "scripts/celadonmansion3_2.asm"

Func_f1f23:
	ld hl, PikachuMovementData_f1f2c
	ld b, SPRITE_FACING_DOWN
	call TryApplyPikachuMovementData
	ret

PikachuMovementData_f1f2c:
	db $00
	db $20
	db $1e
	db $35
	db $3f

INCLUDE "scripts/celadondiner2.asm"
INCLUDE "scripts/safarizoneentrance2.asm"
INCLUDE "scripts/cinnabargym3.asm"

INCLUDE "scripts/mtmoonpokecenter2.asm"

INCLUDE "data/mapHeaders/beach_house.asm"
INCLUDE "scripts/beach_house.asm"
BeachHouseBlockdata: ; f2388 (3c:6388)
INCBIN "maps/beach_house.blk"
INCLUDE "data/mapObjects/beach_house.asm"

INCLUDE "scripts/beach_house2.asm"
INCLUDE "scripts/billshouse2.asm"
INCLUDE "scripts/viridianforest2.asm"
INCLUDE "scripts/ssanne9_2.asm"
INCLUDE "scripts/silphco11_2.asm"

INCLUDE "engine/overworld/hidden_objects.asm"

Func_f2cd0:
	ld d, 0
	ld hl, Jumptable_f2ce1
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call JumpToAddress
	ld e, a
	ld d, 0
	ret

Jumptable_f2ce1:
	dw Func_f2ceb
	dw Func_f2ceb
	dw Func_f2cee
	dw Func_f2cf4
	dw Func_f2d06

Func_f2ceb:
	ld a, 0
	ret

Func_f2cee:
	call Random
	and $1
	ret

Func_f2cf4: ; should return to a, instead returns to b
	call Random
	swap a
	cp 1 * $ff / 3
	ld b, 0
	ret c
	cp 2 * $ff / 3
	ld b, 1
	ret c
	ld b, 2
	ret

Func_f2d06:
	call Random
	and $3
	ret

Func_f2d0c:
	ld hl, GymTrashCans3c
	ld a, [wGymTrashCanIndex]
	ld c, a
	ld b, 0
	ld a, 9
	call AddNTimes
	call AddNTimes ; ????
	ld a, [hli]
	ld [hGymTrashCanRandNumMask], a
	ld e, a
	push hl
	call Func_f2cd0
	pop hl
	add hl, de
	add hl, de
	ld a, [hli]
	ld [wSecondLockTrashCanIndex], a
	ld a, [hl]
	ld [wSecondLockTrashCanIndex + 1], a
	ret

GymTrashCans3c: ; f2d31 (3c:6d31)
; First byte: number of trashcan entries
; Following four byte pairs: indices for the second trash can.
; BUG: Rows that have 3 trashcan entries are sampled incorrectly.
; The sampling occurs by taking a random number and seeing which
; third of the range 0-255 the number falls in.  However, it returns
; that value to the wrong register, so the result is never used.
; Instead of using an offset in [0,1,2], the offset is instead
; in the full range 0-255.  This results in truly random behavior.
	db 4
	db  1,3,   3,1,   1,-1,  3,-1
	db 3
	db  0,2,   2,4,   4,0,  -1,-1
	db 4
	db  1,5,   5,1,   1,-1,  5,-1
	db 3
	db  0,4,   4,6,   6,0,  -1,-1
	db 4
	db  1,3,   3,1,   5,5,   7,7
	db 3
	db  2,4,   4,8,   8,2,  -1,-1
	db 3
	db  3,7,   7,9,   9,3,  -1,-1
	db 4
	db  4,8,   6,10,  8,4,  10,6
	db 3
	db  5,7,   7,11, 11,5,  -1,-1
	db 3
	db  6,10, 10,12, 12,6,  -1,-1
	db 4
	db  7,9,   9,7,  11,13, 13,11
	db 3
	db  8,10, 10,14, 14,8,  -1,-1
	db 4
	db  9,13, 13,9,   9,-1, 13,-1
	db 3
	db 10,12, 12,14, 14,10, -1,-1
	db 4
	db 11,13, 13,11, 11,-1, 13,-1
