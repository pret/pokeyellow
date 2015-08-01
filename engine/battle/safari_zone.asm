PrintSafariZoneBattleText: ; 4111 (1:4111)
	ld hl, wSafariBaitFactor
	ld a, [hl]
	and a
	jr z, .asm_411e
	dec [hl]
	ld hl, SafariZoneEatingText
	jr .asm_4138
.asm_411e
	dec hl
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ld hl, SafariZoneAngryText
	jr nz, .asm_4138
	push hl
	ld a, [wEnemyMonSpecies]
	ld [wd0b5], a
	call GetMonHeader
	ld a, [W_MONHCATCHRATE]
	ld [wEnemyMonCatchRate], a
	pop hl
.asm_4138
	push hl
	call LoadScreenTilesFromBuffer1
	pop hl
	jp PrintText

SafariZoneEatingText: ; 4141 (1:4141)
	TX_FAR _SafariZoneEatingText
	db "@"

SafariZoneAngryText: ; 4146 (1:4146)
	TX_FAR _SafariZoneAngryText
	db "@"
