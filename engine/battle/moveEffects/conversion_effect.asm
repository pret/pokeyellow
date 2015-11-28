ConversionEffect_: ; 1396d (4:796d)
	ld hl, wEnemyMonType1
	ld de, wBattleMonType1
	ld a, [H_WHOSETURN]
	and a
	ld a, [wEnemyBattleStatus1]
	jr z, .conversionEffect
	push hl
	ld h, d
	ld l, e
	pop de
	ld a, [wPlayerBattleStatus1]
.conversionEffect
	bit Invulnerable, a ; is mon immune to typical attacks (dig/fly)
	jr nz, PrintButItFailedText
; copy target's types to user
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld hl, PlayCurrentMoveAnimation
	call CallBankF
	ld hl, ConvertedTypeText
	jp PrintText

ConvertedTypeText: ; 13997 (4:7997)
	TX_FAR _ConvertedTypeText
	db "@"

PrintButItFailedText: ; 1399c (4:799c)
	ld hl, PrintButItFailedText_
CallBankF: ; 1399f (4:799f)
	ld b, BANK(PrintButItFailedText_)
	jp Bankswitch
