FreezeEnemyTrainerSprite:
	ld a, [wCurMap]
	cp POKEMONTOWER_7
	ret z ; the Rockets on Pokemon Tower 7F leave after battling, so don't freeze them
	ld hl, RivalIDs
	ld a, [wEngagedTrainerClass]
	ld b, a
.loop
	ld a, [hli]
	cp $ff
	jr z, .notRival
	cp b
	ret z ; the rival leaves after battling, so don't freeze him
	jr .loop
.notRival
	ld a, [wSpriteIndex]
	ld [H_SPRITEINDEX], a
	jp SetSpriteMovementBytesToFF

RivalIDs:
	db OPP_SONY1
	db OPP_SONY2
	db OPP_SONY3
	db $ff
