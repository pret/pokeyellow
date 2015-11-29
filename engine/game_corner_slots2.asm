AbleToPlaySlotsCheck: ; 2fdfd (b:7dfd)
	ld a, [wSpriteStateData1 + 2]
	and $8
	jr z, .done ; not able
	ld b, COIN_CASE
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	ld b, GameCornerCoinCaseText_id ; - TextPredefs) / 2 + 1
	jr z, .printCoinCaseRequired
	ld hl, wPlayerCoins
	ld a, [hli]
	or [hl]
	jr nz, .done ; able to play
	ld b, GameCornerNoCoinsText_id ; - TextPredefs) / 2 + 1
.printCoinCaseRequired
	call EnableAutoTextBoxDrawing
	ld a, b
	call PrintPredefTextID
	xor a
.done
	ld [wCanPlaySlots], a
	ret

GameCornerCoinCaseText: ; 2fe26 (b:7e26)
	TX_FAR _GameCornerCoinCaseText
	db "@"

GameCornerNoCoinsText: ; 2fe2b (b:7e2b)
	TX_FAR _GameCornerNoCoinsText
	db "@"
