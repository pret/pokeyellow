INCLUDE "yellow/bank3c/overworld.asm"

ResetStatusAndHalveMoneyOnBlackout:: ; f0274 (3c:4274)
; Reset player status on blackout.
	xor a
	ld [wd435],a
	xor a ; gamefreak copypasting functions (double xor a)
	ld [wBattleResult], a
	ld [wWalkBikeSurfState], a
	ld [W_ISINBATTLE], a
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
	ld a,[W_CURMAP]
	cp VERMILION_GYM ; ??? new thing about verm gym?
	jr z,.asm_f02ee
	ld c,a
	ld hl,Pointer_f02fa
.asm_f02e5
	ld a,[hli]
	cp c
	jr z,.asm_f02f4
	cp a,$ff
	jr nz,.asm_f02e5
	ret
.asm_f02ee
	ld hl,wd126
	set 6,[hl]
	ret
.asm_f02f4
	ld hl,wd126
	set 5,[hl]
	ret

Pointer_f02fa:: ; f02fa (3c:42fa)
	db $cf,$d0,$d1,$d2,$d3,$d4
	db $d5,$e9,$ea,$eb,$d6,$d7
	; a lot more raw data here that I have no idea what it might mean

SECTION "bank3c",ROMX[$4a55],BANK[$3c]
Func_f0a55:: ; f0a55 (3c:4a55)
	ld hl,Pointer_f0a76 ; 3c:4a76
.loop
	ld a,[hli]
	cp a,$ff
	ret z
	ld b,a
	ld a,[W_CURMAP]
	cp b
	jr z,.asm_f0a68
	inc hl
	inc hl
	inc hl
	jr .loop

.asm_f0a68
	ld a,[hli]
	ld c,a
	ld b,$0
	ld a,[hli]
	ld h,[hl]
	ld l,a
	ld de,W_MISSABLEOBJECTLIST
	call CopyData
	ret

Pointer_f0a76:: ; f0a76 (3c:4a76)
	db $27,$07,$7b,$4a,$ff
	db $01,$ec,$02,$ed,$03,$ee,$ff

