HallOfFamePC:
	callfar AnimateHallOfFame
	call ClearScreen
	ld c, 100
	call DelayFrames

	call DisableLCD
	ld a, $a7
	ldh [rWX], a
	xor a
	ldh [rSCX], a
	ldh [rSCY], a
	ldh [hSCX], a
	ldh [hSCY], a
	ldh [hWY], a
	ldh [rWY], a
	call CreditsLoadFont
	hlcoord 0, 0
	call FillFourRowsWithBlack
	hlcoord 0, 14
	call FillFourRowsWithBlack
	ld a, %11000000
	ldh [rBGP], a
	call UpdateGBCPal_BGP
	call EnableLCD
	call StopAllMusic
	ld hl, vBGMap1
	call CreditsCopyTileMapToVRAM
	ld hl, vBGMap0
	call CreditsCopyTileMapToVRAM
	ld c, BANK(Music_Credits)
	ld a, MUSIC_CREDITS
	call PlayMusic
	ld c, 128
	call DelayFrames
	xor a
	ld [wHoFMonSpecies], a
	ld [wNumCreditsMonsDisplayed], a
	jp Credits

FadeInCreditsText:
	ld a, 1
	ldh [hAutoBGTransferEnabled], a
	ld hl, HoFGBPalettes
	ld b, 4
.loop
	ld a, [hli]
	ldh [rBGP], a
	call UpdateGBCPal_BGP
	ld c, 5
	call DelayFrames
	dec b
	jr nz, .loop
	ret

HoFGBPalettes:
	db %11000000
	db %11010000
	db %11100000
	db %11110000

DisplayCreditsMon:
	ld hl, vBGMap1
	call CreditsCopyTileMapToVRAM
	xor a
	ldh [hAutoBGTransferEnabled], a
	ld hl, rLCDC
	set 3, [hl]
	call SaveScreenTilesToBuffer2
	call FillMiddleOfScreenWithWhite
	call GetNextCreditsMon
	ld hl, vBGMap0 + 12
	call CreditsCopyTileMapToVRAM
	xor a
	ldh [hAutoBGTransferEnabled], a
	call LoadScreenTilesFromBuffer2DisableBGTransfer
	ld hl, vBGMap0
	call CreditsCopyTileMapToVRAM
	ld a, %11111100 ; make the mon a black silhouette
	ldh [rBGP], a
	call UpdateGBCPal_BGP
	ld hl, rLCDC
	res 3, [hl]
	ld a, 1
	ldh [hAutoBGTransferEnabled], a
	ld b, 0
	ld c, 10
	call ScrollCreditsMonLeft
	call FillLeftHalfOfScreenWithWhite
	ld c, 10
	call ScrollCreditsMonLeft
	call FillRightHalfOfScreenWithWhite
	ld c, 8
	call ScrollCreditsMonLeft
	ld a, %11000000
	ldh [rBGP], a
	call UpdateGBCPal_BGP
	xor a
	ldh [hSCX], a
	ret

ScrollCreditsMonLeft:
	ld a, b
	ldh [hSCX], a
	add 8
	ld b, a
	call DelayFrame
	dec c
	jr nz, ScrollCreditsMonLeft
	ret

GetNextCreditsMon:
	ld hl, wNumCreditsMonsDisplayed
	ld c, [hl]
	inc [hl]
	ld b, 0
	ld hl, CreditsMons
	add hl, bc
	ld a, [hl]
	ld [wcf91], a
	ld [wd0b5], a
	hlcoord 8, 6
	call GetMonHeader
	call LoadFrontSpriteByMonIndex
	ret

INCLUDE "data/credits/credits_mons.asm"

CreditsCopyTileMapToVRAM:
	ld a, l
	ldh [hAutoBGTransferDest], a
	ld a, h
	ldh [hAutoBGTransferDest + 1], a
	ld a, 1
	ldh [hAutoBGTransferEnabled], a
	jp Delay3

CreditsLoadFont:
	call LoadFontTilePatterns
	ld hl, vChars1
	ld bc,  ($80 tiles) / 2
	call ZeroMemory

	call LoadTextBoxTilePatterns
	ld hl, vChars2 tile $60
	ld bc, ($20 tiles) / 2
	call ZeroMemory

	ld hl, vChars2 tile $7e
	ld bc, 1 tiles
	ld a, $ff ; solid black
	call FillMemory
	ret

ZeroMemory:
; zero bc bytes at hl
	ld [hl], 0
	inc hl
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, ZeroMemory
	ret

FillFourRowsWithBlack:
	ld bc, SCREEN_WIDTH * 4
	ld a, $7e
	jp FillMemory

FillMiddleOfScreenWithWhite:
	hlcoord 0, 4
	ld bc, SCREEN_WIDTH * 10
	ld a, " "
	jp FillMemory

FillLeftHalfOfScreenWithWhite:
	hlcoord 0, 4
	push bc
	call FillHalfOfScreenWithWhite
	pop bc
	ret

FillRightHalfOfScreenWithWhite:
	hlcoord 10, 4
	push bc
	call FillHalfOfScreenWithWhite
	pop bc
	ret

FillHalfOfScreenWithWhite:
	ld b, 10
	ld c, 10
	ld a, " "
.loop
	push bc
	push hl
.innerLoop
	ld [hli], a
	dec c
	jr nz, .innerLoop
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .loop
	ret

Credits: ; Roll credits
	ld de, CreditsOrder
	push de
.nextCreditsScreen
	pop de
	hlcoord 9, 6
	push hl
	call FillMiddleOfScreenWithWhite
	pop hl
.nextCreditsCommand
	ld a, [de]
	inc de
	push de
	cp CRED_TEXT_FADE_MON
	jr z, .fadeInTextAndShowMon
	cp CRED_TEXT_MON
	jr z, .showTextAndShowMon
	cp CRED_TEXT_FADE
	jr z, .fadeInText
	cp CRED_TEXT
	jr z, .showText
	cp CRED_COPYRIGHT
	jr z, .showCopyrightText
	cp CRED_THE_END
	jr z, .showTheEnd
	call PlaceCreditsText
	pop de
	jr .nextCreditsCommand

.showCopyrightText
	farcall LoadCopyrightTiles
	pop de
	jr .nextCreditsCommand


.fadeInTextAndShowMon
	call FadeInCreditsText
	ld c, 102
	jr .next1

.showTextAndShowMon
	ld c, 122
.next1
	call DelayFrames
	call DisplayCreditsMon
	jr .nextCreditsScreen

.fadeInText
	call FadeInCreditsText
	ld c, 132
	jr .next2

.showText
	ld c, 152
.next2
	call DelayFrames
	jr .nextCreditsScreen
.showTheEnd
	call ShowTheEndGFX
	pop de
	ret

ShowTheEndGFX:
	ld c, 24
	call DelayFrames
	call FillMiddleOfScreenWithWhite
	ld de, TheEndGfx
	ld hl, vChars2 tile $60
	lb bc, BANK(TheEndGfx), (TheEndGfxEnd - TheEndGfx) / $10
	call CopyVideoData
	hlcoord 4, 8
	ld de, TheEndTextString
	call PlaceString
	hlcoord 4, 9
	inc de
	call PlaceString
	jp FadeInCreditsText

TheEndTextString:
; "T H E  E N D"
	db $60, " ", $62, " ", $64, "  ", $64, " ", $66, " ", $68, "@"
	db $61, " ", $63, " ", $65, "  ", $65, " ", $67, " ", $69, "@"

PlaceCreditsText:
	push hl
	push hl
	ld hl, CreditsTextPointers
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	ld a, [de]
	inc de
	ld c, a
	ld b, -1
	add hl, bc
	call PlaceString
	pop hl
	ld bc, SCREEN_WIDTH * 2
	add hl, bc
	ret

INCLUDE "data/credits/credits_order.asm"

INCLUDE "data/credits/credits_text.asm"

TheEndGfx:
	INCBIN "gfx/credits/the_end.2bpp"
TheEndGfxEnd:
