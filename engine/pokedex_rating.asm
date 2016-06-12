DisplayDexRating:
	ld hl, wPokedexSeen
	ld b, wPokedexSeenEnd - wPokedexSeen
	call CountSetBits
	ld a, [wNumSetBits]
	ld [hDexRatingNumMonsSeen], a
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	ld [hDexRatingNumMonsOwned], a
	ld hl, DexRatingsTable
.findRating
	ld a, [hli]
	ld b, a
	ld a, [hDexRatingNumMonsOwned]
	cp b
	jr c, .foundRating
	inc hl
	inc hl
	jr .findRating
.foundRating
	ld a, [hli]
	ld h, [hl]
	ld l, a ; load text pointer into hl
	CheckAndResetEventA EVENT_HALL_OF_FAME_DEX_RATING
	jr nz, .hallOfFame
	push hl
	ld hl, DexCompletionText
	call PrintText
	pop hl
	call PrintText
	callba PlayPokedexRatingSfx
	jp WaitForTextScrollButtonPress
.hallOfFame
	ld de, wDexRatingNumMonsSeen
	ld a, [hDexRatingNumMonsSeen]
	ld [de], a
	inc de
	ld a, [hDexRatingNumMonsOwned]
	ld [de], a
	inc de
.copyRatingTextLoop
	ld a, [hli]
	cp a, "@"
	jr z, .doneCopying
	ld [de], a
	inc de
	jr .copyRatingTextLoop
.doneCopying
	ld [de], a
	ret

DexCompletionText:
	TX_FAR _DexCompletionText
	db "@"

DexRatingsTable:
	db 10
	dw DexRatingText_Own0To9
	db 20
	dw DexRatingText_Own10To19
	db 30
	dw DexRatingText_Own20To29
	db 40
	dw DexRatingText_Own30To39
	db 50
	dw DexRatingText_Own40To49
	db 60
	dw DexRatingText_Own50To59
	db 70
	dw DexRatingText_Own60To69
	db 80
	dw DexRatingText_Own70To79
	db 90
	dw DexRatingText_Own80To89
	db 100
	dw DexRatingText_Own90To99
	db 110
	dw DexRatingText_Own100To109
	db 120
	dw DexRatingText_Own110To119
	db 130
	dw DexRatingText_Own120To129
	db 140
	dw DexRatingText_Own130To139
	db 150
	dw DexRatingText_Own140To149
	db 152
	dw DexRatingText_Own150To151

DexRatingText_Own0To9:
	TX_FAR _DexRatingText_Own0To9
	db "@"

DexRatingText_Own10To19:
	TX_FAR _DexRatingText_Own10To19
	db "@"

DexRatingText_Own20To29:
	TX_FAR _DexRatingText_Own20To29
	db "@"

DexRatingText_Own30To39:
	TX_FAR _DexRatingText_Own30To39
	db "@"

DexRatingText_Own40To49:
	TX_FAR _DexRatingText_Own40To49
	db "@"

DexRatingText_Own50To59:
	TX_FAR _DexRatingText_Own50To59
	db "@"

DexRatingText_Own60To69:
	TX_FAR _DexRatingText_Own60To69
	db "@"

DexRatingText_Own70To79:
	TX_FAR _DexRatingText_Own70To79
	db "@"

DexRatingText_Own80To89:
	TX_FAR _DexRatingText_Own80To89
	db "@"

DexRatingText_Own90To99:
	TX_FAR _DexRatingText_Own90To99
	db "@"

DexRatingText_Own100To109:
	TX_FAR _DexRatingText_Own100To109
	db "@"

DexRatingText_Own110To119:
	TX_FAR _DexRatingText_Own110To119
	db "@"

DexRatingText_Own120To129:
	TX_FAR _DexRatingText_Own120To129
	db "@"

DexRatingText_Own130To139:
	TX_FAR _DexRatingText_Own130To139
	db "@"

DexRatingText_Own140To149:
	TX_FAR _DexRatingText_Own140To149
	db "@"

DexRatingText_Own150To151:
	TX_FAR _DexRatingText_Own150To151
	db "@"
