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
	jr z, .asm_f0019
	call DelayFrame
	jr .loop
.asm_f0019
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
	dbw BANK(PikachuCry1), PikachuCry1 ; 21:4000
	dbw BANK(PikachuCry2), PikachuCry2 ; 21:491a
	dbw BANK(PikachuCry3), PikachuCry3 ; 21:4fdc
	dbw BANK(PikachuCry4), PikachuCry4 ; 21:59ee
	
; bank 22
	dbw BANK(PikachuCry5), PikachuCry5 ; 22:4000
	dbw BANK(PikachuCry6), PikachuCry6 ; 22:5042
	dbw BANK(PikachuCry7), PikachuCry7 ; 22:6254
	
; bank 23
	dbw BANK(PikachuCry8), PikachuCry8 ; 23:4000
	dbw BANK(PikachuCry9), PikachuCry9 ; 23:50ca
	dbw BANK(PikachuCry10), PikachuCry10 ; 23:5e0c

; bank 24
	dbw BANK(PikachuCry11), PikachuCry11 ; 24:4000
	dbw BANK(PikachuCry12), PikachuCry12 ; 24:4722
	dbw BANK(PikachuCry13), PikachuCry13 ; 24:54a4
	
; bank 25
	dbw BANK(PikachuCry14), PikachuCry14 ; 25:4000
	dbw BANK(PikachuCry15), PikachuCry15 ; 25:589a
	
; banks 31-34, in no particular order

	dbw BANK(PikachuCry16), PikachuCry16 ; 31:4000
	dbw BANK(PikachuCry17), PikachuCry17 ; 34:4000
	dbw BANK(PikachuCry18), PikachuCry18 ; 31:549a
	dbw BANK(PikachuCry19), PikachuCry19 ; 33:4000
	dbw BANK(PikachuCry20), PikachuCry20 ; 32:4000
	dbw BANK(PikachuCry21), PikachuCry21 ; 32:6002
	dbw BANK(PikachuCry22), PikachuCry22 ; 31:63a4
	dbw BANK(PikachuCry23), PikachuCry23 ; 34:4862
	dbw BANK(PikachuCry24), PikachuCry24 ; 33:5632
	dbw BANK(PikachuCry25), PikachuCry25 ; 34:573c
	dbw BANK(PikachuCry26), PikachuCry26 ; 33:725c
	
; bank 35
	dbw BANK(PikachuCry27), PikachuCry27 ; 35:4000
	dbw BANK(PikachuCry28), PikachuCry28 ; 35:4b5a
	dbw BANK(PikachuCry29), PikachuCry29 ; 35:5da4
	dbw BANK(PikachuCry30), PikachuCry30 ; 35:69ce
	dbw BANK(PikachuCry31), PikachuCry31 ; 35:6e80
	
; bank 36
	dbw BANK(PikachuCry32), PikachuCry32 ; 36:4000
	dbw BANK(PikachuCry33), PikachuCry33 ; 36:458a
	dbw BANK(PikachuCry34), PikachuCry34 ; 36:523c
	
; bank 37
	dbw BANK(PikachuCry35), PikachuCry35 ; 37:4000
	dbw BANK(PikachuCry36), PikachuCry36 ; 37:522a

; banks 36-38
	dbw BANK(PikachuCry37), PikachuCry37 ; 38:4000
	dbw BANK(PikachuCry38), PikachuCry38 ; 38:4dfa
	dbw BANK(PikachuCry39), PikachuCry39 ; 37:6e0c
	dbw BANK(PikachuCry40), PikachuCry40 ; 38:5a64
	dbw BANK(PikachuCry41), PikachuCry41 ; 36:6746
	dbw BANK(PikachuCry42), PikachuCry42 ; 38:6976

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
	db $cf, $d0, $d1, $d2, $d3, $d4
	db $d5, $e9, $ea, $eb, $d6, $d7
	db $d8, $a5, $a6, $87, $c7, $ca
	db $c6, $6c, $c2, $71, $f5, $f6
	db $f7, $ff

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

	dr $f0a82, $f220e
BeachHouse_h: ; f220e (3c:620e)
;INCLUDE "data/mapHeaders/beach_house.asm"
	dr $f220e, $f24ae
Func_f24ae: ; f24ae (3c:64ae)
	dr $f24ae, $f25f8

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
