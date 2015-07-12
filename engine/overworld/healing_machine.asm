AnimateHealingMachine: ; 7048b (1c:448b)
	ld de, PokeCenterFlashingMonitorAndHealBall ; $44b7
	ld hl, vChars0 + $7c0
	ld bc, (BANK(PokeCenterFlashingMonitorAndHealBall) << 8) + $03
	call CopyVideoData
	ld hl, wUpdateSpritesEnabled
	ld a, [hl]
	push af
	ld [hl], $ff
	push hl
	ld a, [rOBP1] ; $ff49
	push af
	ld a, $e0
	ld [rOBP1], a ; $ff49
	call Func_3061
	ld hl, wOAMBuffer + $84
	ld de, PokeCenterOAMData ; $44d7
	call Func_7055a
	ld a, $4
	ld [wMusicHeaderPointer], a
	ld a, $ff
	ld [wc0ee], a
	call PlaySound
.asm_704ba
	ld a, [wMusicHeaderPointer]
	and a
	jr nz, .asm_704ba
	ld a, [wPartyCount] ; wPartyCount
	ld b, a
.asm_704c4
	call Func_7055a
	ld a, (SFX_02_4a - SFX_Headers_02) / 3
	call PlaySound
	ld c, $1e
	call DelayFrames
	dec b
	jr nz, .asm_704c4
	ld a, [wc0ef]
	cp $1f
	ld [wc0f0], a
	jr nz, .asm_704e6
	call StopAllMusic
	call PlaySound
	ld a, BANK(Music_PkmnHealed)
	ld [wc0ef], a
.asm_704e6
	ld a, MUSIC_PKMN_HEALED
	ld [wc0ee], a
	call PlaySound
	ld d, $28
	call FlashSprite8Times
.asm_704f3
	ld a, [wc026]
	cp MUSIC_PKMN_HEALED
	jr z, .asm_704f3
	ld c, $20
	call DelayFrames
	pop af
	ld [rOBP1], a ; $ff49
	call Func_3061
	pop hl
	pop af
	ld [hl], a
	jp UpdateSprites

PokeCenterFlashingMonitorAndHealBall: ; 7050b (1c:450b)
	INCBIN "gfx/pokecenter_ball.2bpp"

PokeCenterOAMData: ; 7042b (1c:442b)
	db $24,$34,$7C,$14 ; heal machine monitor
	db $2B,$30,$7D,$14 ; pokeballs 1-6
	db $2B,$38,$7D,$34
	db $30,$30,$7D,$14
	db $30,$38,$7D,$34
	db $35,$30,$7D,$14
	db $35,$38,$7D,$34

; d = value to xor with palette
FlashSprite8Times: ; 70547 (1c:4547)
	ld b, 8
.loop
	ld a, [rOBP1]
	xor d
	ld [rOBP1], a
	call Func_3061
	ld c, 10
	call DelayFrames
	dec b
	jr nz, .loop
	ret

Func_7055a: ; 7055a (1c:455a)
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ret
