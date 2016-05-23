DisplayDexRating: ; 44169 (11:4169)
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

DexCompletionText: ; 441cc (11:41cc)
	TX_FAR _DexCompletionText
	db "@"

DexRatingsTable: ; 441d1 (11:41d1)
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

DexRatingText_Own0To9: ; 44201 (11:4201)
	TX_FAR _DexRatingText_Own0To9
	db "@"

DexRatingText_Own10To19: ; 44206 (11:4206)
	TX_FAR _DexRatingText_Own10To19
	db "@"

DexRatingText_Own20To29: ; 4420b (11:420b)
	TX_FAR _DexRatingText_Own20To29
	db "@"

DexRatingText_Own30To39: ; 44210 (11:4210)
	TX_FAR _DexRatingText_Own30To39
	db "@"

DexRatingText_Own40To49: ; 44215 (11:4215)
	TX_FAR _DexRatingText_Own40To49
	db "@"

DexRatingText_Own50To59: ; 4421a (11:421a)
	TX_FAR _DexRatingText_Own50To59
	db "@"

DexRatingText_Own60To69: ; 4421f (11:421f)
	TX_FAR _DexRatingText_Own60To69
	db "@"

DexRatingText_Own70To79: ; 44224 (11:4224)
	TX_FAR _DexRatingText_Own70To79
	db "@"

DexRatingText_Own80To89: ; 44229 (11:4229)
	TX_FAR _DexRatingText_Own80To89
	db "@"

DexRatingText_Own90To99: ; 4422e (11:422e)
	TX_FAR _DexRatingText_Own90To99
	db "@"

DexRatingText_Own100To109: ; 44233 (11:4233)
	TX_FAR _DexRatingText_Own100To109
	db "@"

DexRatingText_Own110To119: ; 44238 (11:4238)
	TX_FAR _DexRatingText_Own110To119
	db "@"

DexRatingText_Own120To129: ; 4423d (11:423d)
	TX_FAR _DexRatingText_Own120To129
	db "@"

DexRatingText_Own130To139: ; 44242 (11:4242)
	TX_FAR _DexRatingText_Own130To139
	db "@"

DexRatingText_Own140To149: ; 44247 (11:4247)
	TX_FAR _DexRatingText_Own140To149
	db "@"

DexRatingText_Own150To151: ; 4424c (11:424c)
	TX_FAR _DexRatingText_Own150To151
	db "@"
