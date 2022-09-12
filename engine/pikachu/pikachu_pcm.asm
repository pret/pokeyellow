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
	ldh [rNR52], a
	ld a, $77
	ldh [rNR50], a
	xor a
	ldh [rNR30], a
	ld hl, rWave_0 ; wave data
	ld de, wRedrawRowOrColumnSrcTiles
.saveWaveDataLoop
	ld a, [hl]
	ld [de], a
	inc de
	ld a, $ff
	ld [hli], a
	ld a, l
	cp $40 ; end of wave data
	jr nz, .saveWaveDataLoop
	vc_patch Unknown_PlayPikachuSoundClip_end
IF DEF(_YELLOW_VC)
	ld a, 0
ELSE
	ld a, $80
ENDC
	vc_patch_end
	ldh [rNR30], a
	ldh a, [rNR51]
	or $44
	ldh [rNR51], a
	ld a, $ff
	ldh [rNR31], a
	ld a, $20
	ldh [rNR32], a
	ld a, $ff
	ldh [rNR33], a
	ld a, $87
	ldh [rNR34], a
	pop hl
	pop bc
	call PlayPikachuPCM
	xor a
	ld [wc0f3], a
	ld [wc0f3 + 1], a
	ld a, $80
	ldh [rNR52], a
	xor a
	ldh [rNR30], a
	ld hl, rWave_0
	ld de, wRedrawRowOrColumnSrcTiles
.reloadWaveDataLoop
	ld a, [de]
	inc de
	ld [hli], a
	ld a, l
	cp $40 ; end of wave data
	jr nz, .reloadWaveDataLoop
	ld a, $80
	ldh [rNR30], a
	ldh a, [rNR51]
	and $bb
	ldh [rNR51], a
	xor a
	ld [wChannelSoundIDs + CHAN5], a
	ld [wChannelSoundIDs + CHAN6], a
	ld [wChannelSoundIDs + CHAN7], a
	ld [wChannelSoundIDs + CHAN8], a
	ldh a, [hLoadedROMBank]
	ei
	ret

PikachuCriesPointerTable::
; format:
; db bank
; dw pointer to cry

; bank 21
	pikacry_def PikachuCry1
	pikacry_def PikachuCry2
	pikacry_def PikachuCry3
	pikacry_def PikachuCry4

; bank 22
	pikacry_def PikachuCry5
	pikacry_def PikachuCry6
	pikacry_def PikachuCry7

; bank 23
	pikacry_def PikachuCry8
	pikacry_def PikachuCry9
	pikacry_def PikachuCry10

; bank 24
	pikacry_def PikachuCry11
	pikacry_def PikachuCry12
	pikacry_def PikachuCry13

; bank 25
	pikacry_def PikachuCry14
	pikacry_def PikachuCry15

; banks 31-34, in no particular order

	pikacry_def PikachuCry16
	pikacry_def PikachuCry17
	pikacry_def PikachuCry18
	pikacry_def PikachuCry19
	pikacry_def PikachuCry20
	pikacry_def PikachuCry21
	pikacry_def PikachuCry22
	pikacry_def PikachuCry23
	pikacry_def PikachuCry24
	pikacry_def PikachuCry25
	pikacry_def PikachuCry26

; bank 35
	pikacry_def PikachuCry27
	pikacry_def PikachuCry28
	pikacry_def PikachuCry29
	pikacry_def PikachuCry30
	pikacry_def PikachuCry31

; bank 36
	pikacry_def PikachuCry32
	pikacry_def PikachuCry33
	pikacry_def PikachuCry34

; bank 37
	pikacry_def PikachuCry35
	pikacry_def PikachuCry36

; banks 36-38
	pikacry_def PikachuCry37
	pikacry_def PikachuCry38
	pikacry_def PikachuCry39
	pikacry_def PikachuCry40
	pikacry_def PikachuCry41
	pikacry_def PikachuCry42
