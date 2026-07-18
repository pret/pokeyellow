PlayPikachuSoundClip::
	vc_hook Unknown_PlayPikachuSoundClip_start
	ld a, e
	ld e, a
	ld d, $0
	ld hl, PikachuCriesPointerTable
	add hl, de
	add hl, de
	add hl, de
	ld b, [hl] ; bank of pikachu cry data
	inc hl
	ld a, [hli] ; cry data pointer
	ld h, [hl]
	ld l, a
	ld c, $4
.loop
	dec c
	jr z, .done_delay
	call DelayFrame
	jr .loop

.done_delay
	di
	push bc
	push hl
	ld a, $80
	ldh [rAUDENA], a
	ld a, $77
	ldh [rAUDVOL], a
	xor a
	ldh [rAUD3ENA], a
	ld hl, _AUD3WAVERAM
	ld de, wSavedAudioWavePattern
.saveWaveDataLoop
	ld a, [hl]
	ld [de], a
	inc de
	ld a, $ff
	ld [hli], a
	ld a, l
	cp LOW(_AUD3WAVERAM + AUD3WAVE_SIZE) ; end of wave data
	jr nz, .saveWaveDataLoop
	vc_patch Unknown_PlayPikachuSoundClip_end
IF DEF(_YELLOW_VC)
	ld a, 0
ELSE
	ld a, $80
ENDC
	vc_patch_end
	ldh [rAUD3ENA], a
	ldh a, [rAUDTERM]
	or $44
	ldh [rAUDTERM], a
	ld a, $ff
	ldh [rAUD3LEN], a
	ld a, $20
	ldh [rAUD3LEVEL], a
	ld a, $ff
	ldh [rAUD3LOW], a
	ld a, $87
	ldh [rAUD3HIGH], a
	pop hl
	pop bc
	call PlayPikachuPCM
	xor a
	ld [wUnusedAudioCounter], a
	ld [wUnusedAudioCounter + 1], a
	ld a, $80
	ldh [rAUDENA], a
	xor a
	ldh [rAUD3ENA], a
	ld hl, _AUD3WAVERAM
	ld de, wSavedAudioWavePattern
.reloadWaveDataLoop
	ld a, [de]
	inc de
	ld [hli], a
	ld a, l
	cp LOW(_AUD3WAVERAM + AUD3WAVE_SIZE) ; end of wave data
	jr nz, .reloadWaveDataLoop
	ld a, $80
	ldh [rAUD3ENA], a
	ldh a, [rAUDTERM]
	and $bb
	ldh [rAUDTERM], a
	xor a
	ld [wChannelSoundIDs + CHAN5], a
	ld [wChannelSoundIDs + CHAN6], a
	ld [wChannelSoundIDs + CHAN7], a
	ld [wChannelSoundIDs + CHAN8], a
	ldh a, [hLoadedROMBank]
	ei
	ret
