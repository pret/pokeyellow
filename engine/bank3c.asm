PlayPikachuSoundClip:: ; f0000 (3c:4000)
	ld a, e
	ld e, a
	ld d, $0
	ld hl, PikachuCriesPointerTable
	add hl, de
	add hl, de
	add hl, de
	ld b, [hl] ; bank of pikachu cry data
	inc hl
	ld a, [hli] ; cry data pointer
	ld h, [hl]
	ld l, a
	ld c, $4
.loop
	dec c
	jr z, .done_delay
	call DelayFrame
	jr .loop

.done_delay
	di
	push bc
	push hl
	ld a, $80
	ld [rNR52], a
	ld a, $77
	ld [rNR50], a
	xor a
	ld [rNR30], a
	ld hl, $ff30 ; wave data
	ld de, wRedrawRowOrColumnSrcTiles
.saveWaveDataLoop
	ld a, [hl]
	ld [de], a
	inc de
	ld a, $ff
	ld [hli], a
	ld a, l
	cp $40 ; end of wave data
	jr nz, .saveWaveDataLoop
	ld a, $80
	ld [rNR30], a
	ld a, [rNR51]
	or $44
	ld [rNR51], a
	ld a, $ff
	ld [rNR31], a
	ld a, $20
	ld [rNR32], a
	ld a, $ff
	ld [rNR33], a
	ld a, $87
	ld [rNR34], a
	pop hl
	pop bc
	call PlayPikachuPCM
	xor a
	ld [wc0f3], a
	ld [wc0f4], a
	ld a, $80
	ld [rNR52], a
	xor a
	ld [rNR30], a
	ld hl, $ff30
	ld de, wRedrawRowOrColumnSrcTiles
.reloadWaveDataLoop
	ld a, [de]
	inc de
	ld [hli], a
	ld a, l
	cp $40 ; end of wave data
	jr nz, .reloadWaveDataLoop
	ld a, $80
	ld [rNR30], a
	ld a, [rNR51]
	and $bb
	ld [rNR51], a
	xor a
	ld [wChannelSoundIDs+CH4], a
	ld [wChannelSoundIDs+CH5], a
	ld [wChannelSoundIDs+CH6], a
	ld [wChannelSoundIDs+CH7], a
	ld a, [H_LOADEDROMBANK]
	ei
	ret

PikachuCriesPointerTable: ; f008e (3c:408e)
; format:
; db bank
; dw pointer to cry

; bank 21
	pikacry_def PikachuCry1 ; 21:4000
	pikacry_def PikachuCry2 ; 21:491a
	pikacry_def PikachuCry3 ; 21:4fdc
	pikacry_def PikachuCry4 ; 21:59ee

; bank 22
	pikacry_def PikachuCry5 ; 22:4000
	pikacry_def PikachuCry6 ; 22:5042
	pikacry_def PikachuCry7 ; 22:6254

; bank 23
	pikacry_def PikachuCry8 ; 23:4000
	pikacry_def PikachuCry9 ; 23:50ca
	pikacry_def PikachuCry10 ; 23:5e0c

; bank 24
	pikacry_def PikachuCry11 ; 24:4000
	pikacry_def PikachuCry12 ; 24:4722
	pikacry_def PikachuCry13 ; 24:54a4

; bank 25
	pikacry_def PikachuCry14 ; 25:4000
	pikacry_def PikachuCry15 ; 25:589a

; banks 31-34, in no particular order

	pikacry_def PikachuCry16 ; 31:4000
	pikacry_def PikachuCry17 ; 34:4000
	pikacry_def PikachuCry18 ; 31:549a
	pikacry_def PikachuCry19 ; 33:4000
	pikacry_def PikachuCry20 ; 32:4000
	pikacry_def PikachuCry21 ; 32:6002
	pikacry_def PikachuCry22 ; 31:63a4
	pikacry_def PikachuCry23 ; 34:4862
	pikacry_def PikachuCry24 ; 33:5632
	pikacry_def PikachuCry25 ; 34:573c
	pikacry_def PikachuCry26 ; 33:725c

; bank 35
	pikacry_def PikachuCry27 ; 35:4000
	pikacry_def PikachuCry28 ; 35:4b5a
	pikacry_def PikachuCry29 ; 35:5da4
	pikacry_def PikachuCry30 ; 35:69ce
	pikacry_def PikachuCry31 ; 35:6e80

; bank 36
	pikacry_def PikachuCry32 ; 36:4000
	pikacry_def PikachuCry33 ; 36:458a
	pikacry_def PikachuCry34 ; 36:523c

; bank 37
	pikacry_def PikachuCry35 ; 37:4000
	pikacry_def PikachuCry36 ; 37:522a

; banks 36-38
	pikacry_def PikachuCry37 ; 38:4000
	pikacry_def PikachuCry38 ; 38:4dfa
	pikacry_def PikachuCry39 ; 37:6e0c
	pikacry_def PikachuCry40 ; 38:5a64
	pikacry_def PikachuCry41 ; 36:6746
	pikacry_def PikachuCry42 ; 38:6976

INCLUDE "engine/overworld/advance_player_sprite.asm"

ResetStatusAndHalveMoneyOnBlackout:: ; f0274 (3c:4274)
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

	ld [$ff9f], a
	ld [$ff9f + 1], a
	ld [$ff9f + 2], a
	call HasEnoughMoney
	jr c, .lostmoney ; never happens

	; Halve the player's money.
	ld a, [wPlayerMoney]
	ld [$ff9f], a
	ld a, [wPlayerMoney + 1]
	ld [$ff9f + 1], a
	ld a, [wPlayerMoney + 2]
	ld [$ff9f + 2], a
	xor a
	ld [$ffa2], a
	ld [$ffa3], a
	ld a, 2
	ld [$ffa4], a
	predef DivideBCDPredef3
	ld a, [$ffa2]
	ld [wPlayerMoney], a
	ld a, [$ffa2 + 1]
	ld [wPlayerMoney + 1], a
	ld a, [$ffa2 + 2]
	ld [wPlayerMoney + 2], a

.lostmoney
	ld hl, wd732
	set 2, [hl]
	res 3, [hl]
	set 6, [hl]
	ld a, %11111111
	ld [wJoyIgnore], a
	predef_jump HealParty

Func_f02da:: ; f02da (3c:42da)
	ld a, [wCurMap]
	cp VERMILION_GYM ; ??? new thing about verm gym?
	jr z, .asm_f02ee
	ld c, a
	ld hl, Pointer_f02fa
.asm_f02e5
	ld a, [hli]
	cp c
	jr z, .asm_f02f4
	cp a, $ff
	jr nz, .asm_f02e5
	ret
.asm_f02ee
	ld hl, wd126
	set 6, [hl]
	ret
.asm_f02f4
	ld hl, wd126
	set 5, [hl]
	ret

Pointer_f02fa:: ; f02fa (3c:42fa)
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

BeachHouse_GFX:: ; f0314 (3c:4314)
	INCBIN "gfx/tilesets/beachhouse.2bpp"

BeachHouse_Block:: ; f0914 (3c:4914)
	INCBIN "gfx/blocksets/beachhouse.bst"

Func_f0a54:: ; f0a54 (3c:4a54)
	ret

Func_f0a55:: ; f0a55 (3c:4a55)
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
	ld b, $0
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wMissableObjectList
	call CopyData
	ret

Pointer_f0a76:: ; f0a76 (3c:4a76)
	db $27, $07, $7b, $4a, $ff
	db $01, $ec, $02, $ed, $03, $ee, $ff

Func_f0a82: ; f0a82
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
	call Func_159b ; homecall Func_fd2a1 - pikachu movement script?
	callab Func_fcba1
	ret

Pic_f0abf: ; f0abf (3c:4abf)
	dr $f0abf, $f0b64
GFX_f0b64: ; f0b64 (3c:4b64)
	dr $f0b64, $f0cf4
Pic_f0cf4: ; f0cf4 (3c:4cf4)
	dr $f0cf4, $f0d82
GFX_f0d82: ; f0d82 (3c:4d82)
	dr $f0d82, $f0f12

Func_f0f12:
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
	dr $f1e22, $f220e

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
	cp $55
	ld b, 0
	ret c
	cp $aa
	ld b, 1
	ret c
	ld b, 2
	ret

Func_f2d06:
	call Random
	and $3
	ret

Func_f2d0c:
	ld hl, GymTrashCans3a
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

GymTrashCans3a: ; f2d31 (3c:6d31)
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
