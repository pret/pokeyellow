Audio4_PlaySound::
; Duplicate of Audio3_PlaySound
	ld [wSoundID], a
	ld a, [wSoundID]
	cp $ff
	jp z, Audio4_7d18e
	cp $98
	jp z, Audio4_7d12d
	jp c, Audio4_7d12d
	cp $a3
	jr z, .asm_7d127
	jp nc, Audio4_7d12d

.asm_7d127
	call InitMusicVariables
	jp Audio4_7d192

Audio4_7d12d:
	ld l, a
	ld e, a
	ld h, $0
	ld d, h
	add hl, hl
	add hl, de
	ld de, SFX_Headers_4
	add hl, de
	ld a, h
	ld [wSfxHeaderPointer], a
	ld a, l
	ld [wSfxHeaderPointer + 1], a
	ld a, [hl]
	and $c0
	rlca
	rlca
	ld c, a
.asm_7d146
	ld d, c
	ld a, c
	add a
	add c
	ld c, a
	ld b, $0
	ld a, [wSfxHeaderPointer]
	ld h, a
	ld a, [wSfxHeaderPointer + 1]
	ld l, a
	add hl, bc
	ld c, d
	ld a, [hl]
	and $f
	ld e, a
	ld d, $0
	ld hl, wChannelSoundIDs
	add hl, de
	ld a, [hl]
	and a
	jr z, .asm_7d182
	ld a, e
	cp $7
	jr nz, .asm_7d179
	ld a, [wSoundID]
	cp $14
	jr nc, .asm_7d172
	ret

.asm_7d172
	ld a, [hl]
	cp $14
	jr z, .asm_7d182
	jr c, .asm_7d182
.asm_7d179
	ld a, [wSoundID]
	cp [hl]
	jr z, .asm_7d182
	jr c, .asm_7d182
	ret

.asm_7d182
	call InitSFXVariables
	ld a, c
	and a
	jp z, Audio4_7d192
	dec c
	jp .asm_7d146

Audio4_7d18e:
	call StopAllAudio
	ret

Audio4_7d192:
	ld a, [wSoundID]
	ld l, a
	ld e, a
	ld h, $0
	ld d, h
	add hl, hl
	add hl, de
	ld de, SFX_Headers_4
	add hl, de
	ld e, l
	ld d, h
	ld hl, wChannelCommandPointers
	ld a, [de] ; get channel number
	ld b, a
	rlca
	rlca
	and $3
	ld c, a
	ld a, b
	and $f
	ld b, c
	inc b
	inc de
	ld c, $0
.asm_7d1b4
	cp c
	jr z, .asm_7d1bc
	inc c
	inc hl
	inc hl
	jr .asm_7d1b4
.asm_7d1bc
	push af
	push hl
	push bc
	ld b, $0
	ld c, a
	cp $3
	jr c, .asm_7d1cc
	ld hl, wChannelFlags1
	add hl, bc
	set 2, [hl]
.asm_7d1cc
	pop bc
	pop hl
	ld a, [de] ; get channel pointer
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	pop af
	push hl
	push bc
	ld b, $0
	ld c, a
	ld hl, wChannelSoundIDs
	add hl, bc
	ld a, [wSoundID]
	ld [hl], a
	pop bc
	pop hl
	inc c
	dec b
	ld a, b
	and a
	ld a, [de]
	inc de
	jr nz, .asm_7d1b4
	ld a, [wSoundID]
	cp $14
	jr nc, .asm_7d1f5
	jr .asm_7d21f

.asm_7d1f5
	ld a, [wSoundID]
	cp $86
	jr z, .asm_7d21f
	jr c, .asm_7d200
	jr .asm_7d21f
.asm_7d200
	ld hl, wChannelSoundIDs + CH4
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wChannelCommandPointers + CH6 * 2 ; sfx noise channel pointer
	ld de, Noise4_endchannel
	ld [hl], e
	inc hl
	ld [hl], d ; overwrite pointer to point to endchannel
	ld a, [wSavedVolume]
	and a
	jr nz, .asm_7d21f
	ld a, [rNR50]
	ld [wSavedVolume], a
	ld a, $77
	ld [rNR50], a
.asm_7d21f
	ret

Noise4_endchannel:
	endchannel
