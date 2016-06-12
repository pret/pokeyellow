AnimateHealingMachine:
	ld de, PokeCenterFlashingMonitorAndHealBall
	ld hl, vChars0 + $7c0
	lb bc, BANK(PokeCenterFlashingMonitorAndHealBall), $03 ; loads one too many tiles
	call CopyVideoData
	ld hl, wUpdateSpritesEnabled
	ld a, [hl]
	push af
	ld [hl], $ff
	push hl
	ld a, [rOBP1]
	push af
	ld a, $e0
	ld [rOBP1], a
	call UpdateGBCPal_OBP1
	ld hl, wOAMBuffer + $84
	ld de, PokeCenterOAMData
	call CopyHealingMachineOAM
	ld a, 4
	ld [wAudioFadeOutControl], a
	call StopAllMusic
.waitLoop
	ld a, [wAudioFadeOutControl]
	and a
	jr nz, .waitLoop
	ld a, [wPartyCount] ; wPartyCount
	ld b, a
.partyLoop
	call CopyHealingMachineOAM
	ld a, $9e ; (SFX_02_4a - SFX_Headers_02) / 3
	call PlaySound
	ld c, 30
	call DelayFrames
	dec b
	jr nz, .partyLoop
	ld a, [wAudioROMBank]
	cp $1f
	ld [wAudioSavedROMBank], a
	jr nz, .next
	call StopAllMusic
	ld a, $2 ; BANK(Music_PkmnHealed)
	ld [wAudioROMBank], a
.next
	ld a, $e8 ; MUSIC_PKMN_HEALED
	ld [wNewSoundID], a
	call PlaySound
	ld d, $28
	call FlashSprite8Times
.waitLoop2
	ld a, [wChannelSoundIDs]
	cp $e8 ; MUSIC_PKMN_HEALED
	jr z, .waitLoop2
	ld c, 32
	call DelayFrames
	pop af
	ld [rOBP1], a
	call UpdateGBCPal_OBP1
	pop hl
	pop af
	ld [hl], a
	jp UpdateSprites

PokeCenterFlashingMonitorAndHealBall:
	INCBIN "gfx/pokecenter_ball.2bpp"

PokeCenterOAMData:
	db $24,$34,$7C,$14 ; heal machine monitor
	db $2B,$30,$7D,$14 ; pokeballs 1-6
	db $2B,$38,$7D,$34
	db $30,$30,$7D,$14
	db $30,$38,$7D,$34
	db $35,$30,$7D,$14
	db $35,$38,$7D,$34

; d = value to xor with palette
FlashSprite8Times:
	ld b, 8
.loop
	ld a, [rOBP1]
	xor d
	ld [rOBP1], a
	call UpdateGBCPal_OBP1
	ld c, 10
	call DelayFrames
	dec b
	jr nz, .loop
	ret

CopyHealingMachineOAM:
; copy one OAM entry and advance the pointers
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
