CeladonPrizeMenu: ; 5267d (14:667d)
	ld b,COIN_CASE
	call IsItemInBag
	jr nz,.havingCoinCase
	ld hl,RequireCoinCaseTextPtr
	jp PrintText
.havingCoinCase
	ld hl,wd730
	set 6,[hl] ; disable letter-printing delay
	ld hl,ExchangeCoinsForPrizesTextPtr
	call PrintText
; the following are the menu settings
	xor a
	ld [wCurrentMenuItem],a
	ld [wLastMenuItem],a
	ld a,A_BUTTON | B_BUTTON
	ld [wMenuWatchedKeys],a
	ld a,$03
	ld [wMaxMenuItem],a
	ld a,$04
	ld [wTopMenuItemY],a
	ld a,$01
	ld [wTopMenuItemX],a
	call PrintPrizePrice
	coord hl, 0, 2
	lb bc, 8, 16
	call TextBoxBorder
	call GetPrizeMenuId
	call UpdateSprites
	ld hl,WhichPrizeTextPtr
	call PrintText
	call HandleMenuInput ; menu choice handler
	bit 1,a ; keypress = B (Cancel)
	jr nz, .noChoice
	ld a,[wCurrentMenuItem]
	cp $03 ; "NO,THANKS" choice
	jr z, .noChoice
	call HandlePrizeChoice
.noChoice
	ld hl, wd730
	res 6, [hl]
	ret

RequireCoinCaseTextPtr: ; 526df (14:66df)
	TX_FAR _RequireCoinCaseText
	db $0D
	db "@"

ExchangeCoinsForPrizesTextPtr: ; 526e5 (14:66e5)
	TX_FAR _ExchangeCoinsForPrizesText
	db "@"

WhichPrizeTextPtr: ; 526ea (14:66ea)
	TX_FAR _WhichPrizeText
	db "@"

GetPrizeMenuId: ; 526ef (14:66ef)
; determine which one among the three
; prize-texts has been selected
; using the text ID (stored in [hSpriteIndexOrTextID])
; load the three prizes at wd13d-wd13f
; load the three prices at wd141-wd146
; display the three prizes' names
; (distinguishing between Pokemon names
; and Items (specifically TMs) names)
	ld a, [hSpriteIndexOrTextID]
	sub 3       ; prize-texts' id are 3, 4 and 5
	ld [wWhichPrizeWindow], a    ; prize-texts' id (relative, i.e. 0, 1 or 2)
	add a
	add a
	ld d, $0
	ld e, a
	ld hl, PrizeDifferentMenuPtrs
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	inc hl
	push hl
	ld hl, wPrize1
	call CopyString
	pop hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wPrize1Price
	ld bc, $6
	call CopyData
	ld a, [wWhichPrizeWindow]
	cp $02        ;is TM_menu?
	jr nz, .putMonName
	ld a, [wPrize1]
	ld [wd11e], a
	call GetItemName
	coord hl, 2, 4
	call PlaceString
	ld a, [wPrize2]
	ld [wd11e], a
	call GetItemName
	coord hl, 2, 6
	call PlaceString
	ld a, [wPrize3]
	ld [wd11e], a
	call GetItemName
	coord hl, 2, 8
	call PlaceString
	jr .putNoThanksText
.putMonName
	ld a, [wPrize1]
	ld [wd11e], a
	call GetMonName
	coord hl, 2, 4
	call PlaceString
	ld a, [wPrize2]
	ld [wd11e], a
	call GetMonName
	coord hl, 2, 6
	call PlaceString
	ld a, [wPrize3]
	ld [wd11e], a
	call GetMonName
	coord hl, 2, 8
	call PlaceString
.putNoThanksText
	coord hl, 2, 10
	ld de, NoThanksText
	call PlaceString
; put prices on the right side of the textbox
	ld de, wPrize1Price
	coord hl, 13, 5
; reg. c:
; [low nybble] number of bytes
; [bit 765 = %100] space-padding (not zero-padding)
	ld c,(1 << 7 | 2)
; Function $15CD displays BCD value (same routine
; used by text-command $02)
	call PrintBCDNumber
	ld de,wPrize2Price
	coord hl, 13, 7
	ld c, (1 << 7 | 2)
	call PrintBCDNumber
	ld de, wPrize3Price
	coord hl, 13, 9
	ld c, (1 << 7 | 2)
	jp PrintBCDNumber

NoThanksText: ; 527a4 (14:67a4)
	db "NO THANKS@"

INCLUDE "data/prizes.asm"

PrintPrizePrice: ; 527db (14:67db)
	coord hl, 11, 0
	lb bc, 1, 7
	call TextBoxBorder
	call UpdateSprites
	coord hl, 12, 0
	ld de, CoinString
	call PlaceString
	coord hl, 13, 1
	ld de, SixSpacesString
	call PlaceString
	coord hl, 13, 1
	ld de,wPlayerCoins
	ld c, (1 << 7 | 2)
	call PrintBCDNumber
	ret

CoinString: ; 52805 (14:6805)
	db "COIN@"

SixSpacesString: ; 5280a (14:680a)
	db "      @"

LoadCoinsToSubtract: ; 52811 (14:6811)
	ld a,[wWhichPrize]
	add a
	ld d, $0
	ld e, a
	ld hl, wPrize1Price
	add hl, de ; get selected prize's price
	xor a
	ld [hUnusedCoinsByte], a
	ld a, [hli]
	ld [hCoins], a
	ld a, [hl]
	ld [hCoins + 1], a
	ret

HandlePrizeChoice: ; 52826 (14:6826)
	ld a, [wCurrentMenuItem]
	ld [wWhichPrize], a
	ld d, $0
	ld e, a
	ld hl, wPrize1
	add hl, de
	ld a, [hl]
	ld [wd11e], a
	ld a, [wWhichPrizeWindow]
	cp $02 ; is prize a TM?
	jr nz, .getMonName
	call GetItemName
	jr .givePrize
.getMonName
	call GetMonName
.givePrize
	ld hl,SoYouWantPrizeTextPtr
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem] ; yes/no answer (Y=0, N=1)
	and a
	jr nz, .printOhFineThen
	call LoadCoinsToSubtract
	call HasEnoughCoins
	jr c, .notEnoughCoins
	ld a, [wWhichPrizeWindow]
	cp $02
	jr nz, .giveMon
	ld a,[wd11e]
	ld b, a
	ld a, 1
	ld c, a
	call GiveItem
	jr nc, .bagFull
	jr .subtractCoins
.giveMon
	ld a,[wd11e]
	ld [wcf91],a
	push af
	call GetPrizeMonLevel
	ld c,a
	pop af
	ld b,a
	call GivePokemon

; If either the party or box was full, wait after displaying message.
	push af
	ld a,[wAddedToParty]
	and a
	call z,WaitForTextScrollButtonPress
	pop af

; If the mon couldn't be given to the player (because both the party and box
; were full), return without subtracting coins.
	ret nc

.subtractCoins
	call LoadCoinsToSubtract
	ld hl,hCoins + 1
	ld de,wPlayerCoins + 1
	ld c,$02 ; how many bytes
	predef SubBCDPredef
	jp PrintPrizePrice
.bagFull
	ld hl,PrizeRoomBagIsFullTextPtr
	jp PrintText
.notEnoughCoins
	ld hl,SorryNeedMoreCoinsText
	jp PrintText
.printOhFineThen
	ld hl,OhFineThenTextPtr
	jp PrintText

UnknownData528b1: ; 528b1 (14:68b1)
; XXX what's this?
	db $00,$01,$00,$01,$00,$01,$00,$00,$01

HereYouGoTextPtr: ; 528ca (14:68ba)
	TX_FAR _HereYouGoText
	db $0D
	db "@"

SoYouWantPrizeTextPtr: ; 528c0 (14:68c0)
	TX_FAR _SoYouWantPrizeText
	db "@"

SorryNeedMoreCoinsText: ; 528c5 (14:68c5)
	TX_FAR _SorryNeedMoreCoinsText
	db $0D
	db "@"

PrizeRoomBagIsFullTextPtr: ; 528cb (14:68cb)
	TX_FAR _OopsYouDontHaveEnoughRoomText
	db $0D
	db "@"

OhFineThenTextPtr: ; 528d1 (14:68d1)
	TX_FAR _OhFineThenText
	db $0D ; wait keypress (A/B) without blink
	db "@"

GetPrizeMonLevel: ; 528d7 (14:68d7)
	ld a, [wcf91]
	ld b, a
	ld hl, PrizeMonLevelDictionary
.loop
	ld a, [hli]
	cp b
	jr z, .matchFound
	inc hl
	jr .loop
.matchFound
	ld a, [hl]
	ld [wCurEnemyLVL], a
	ret

INCLUDE "data/prize_mon_levels.asm"
