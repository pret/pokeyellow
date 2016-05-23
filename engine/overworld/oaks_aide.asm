OaksAideScript: ; 58ecc (16:4ecc)
	ld hl, OaksAideHiText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .choseNo
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	ld [hOaksAideNumMonsOwned], a
	ld b, a
	ld a, [hOaksAideRequirement]
	cp b
	jr z, .giveItem
	jr nc, .notEnoughOwnedMons
.giveItem
	ld hl, OaksAideHereYouGoText
	call PrintText
	ld a, [hOaksAideRewardItem]
	ld b, a
	ld c, 1
	call GiveItem
	jr nc, .bagFull
	ld hl, OaksAideGotItemText
	call PrintText
	ld a, $1
	jr .done
.bagFull
	ld hl, OaksAideNoRoomText
	call PrintText
	xor a
	jr .done
.notEnoughOwnedMons
	ld hl, OaksAideUhOhText
	call PrintText
	ld a, $80
	jr .done
.choseNo
	ld hl, OaksAideComeBackText
	call PrintText
	ld a, $ff
.done
	ld [hOaksAideResult], a
	ret

OaksAideHiText: ; 58f28 (16:4f28)
	TX_FAR _OaksAideHiText
	db "@"

OaksAideUhOhText: ; 58f2d (16:4f2d)
	TX_FAR _OaksAideUhOhText
	db "@"

OaksAideComeBackText: ; 58f32 (16:4f32)
	TX_FAR _OaksAideComeBackText
	db "@"

OaksAideHereYouGoText: ; 58f37 (16:4f37)
	TX_FAR _OaksAideHereYouGoText
	db "@"

OaksAideGotItemText: ; 58f3c (16:4f3c)
	TX_FAR _OaksAideGotItemText
	db $0b
	db "@"

OaksAideNoRoomText: ; 58f41 (16:4f41)
	TX_FAR _OaksAideNoRoomText
	db "@"
