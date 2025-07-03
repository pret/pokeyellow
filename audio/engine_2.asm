; The second of four partially duplicated sound engines.
; This copy has a few differences relating to battle sound effects
; and the low health alarm that plays in battle

Audio2_PlaySound::
	ld [wSoundID], a
	ld a, [wSoundID]
	cp SFX_STOP_ALL_MUSIC
	jp z, .stopAllAudio
	cp MAX_SFX_ID_2
	jp z, .playSfx
	jp c, .playSfx
	cp $fe
	jr z, .playMusic
	jp nc, .playSfx

.playMusic
	call InitMusicVariables
	jp .playSoundCommon

.playSfx
	ld l, a
	ld e, a
	ld h, 0
	ld d, h
	add hl, hl
	add hl, de
	ld de, SFX_Headers_2
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
.sfxChannelLoop
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
	ld e, a ; software channel ID
	ld d, 0
	ld hl, wChannelSoundIDs
	add hl, de
	ld a, [hl]
	and a
	jr z, .playChannel
	ld a, e
	cp CHAN8
	jr nz, .notNoiseChannel
	ld a, [wSoundID]
	cp NOISE_INSTRUMENTS_END
	jr nc, .notNoiseInstrument
	ret
.notNoiseInstrument
	ld a, [hl]
	cp NOISE_INSTRUMENTS_END
	jr z, .playChannel
	jr c, .playChannel
.notNoiseChannel
	ld a, [wSoundID]
	cp [hl]
	jr z, .playChannel
	jr c, .playChannel
	ret
.playChannel
	call InitSFXVariables
	ld a, c
	and a
	jp z, .playSoundCommon
	dec c
	jp .sfxChannelLoop

.stopAllAudio
	call StopAllAudio
	ret

.playSoundCommon
	ld a, [wSoundID]
	ld l, a
	ld e, a
	ld h, 0
	ld d, h
	add hl, hl
	add hl, de
	ld de, SFX_Headers_2
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
	ld c, 0
.commandPointerLoop
	cp c
	jr z, .next
	inc c
	inc hl
	inc hl
	jr .commandPointerLoop
.next
	push af
	push hl
	push bc
	ld b, 0
	ld c, a
	cp CHAN4
	jr c, .skipSettingFlag
	ld hl, wChannelFlags1
	add hl, bc
	set BIT_NOISE_OR_SFX, [hl]
.skipSettingFlag
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
	ld b, 0
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
	jr nz, .commandPointerLoop
	ld a, [wSoundID]
	cp CRY_SFX_START
	jr nc, .maybeCry
	jr .done
.maybeCry
	ld a, [wSoundID]
	cp CRY_SFX_END
	jr z, .done
	jr c, .cry
	jr .done
.cry
	ld hl, wChannelSoundIDs + CHAN5
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wChannelCommandPointers + CHAN7 * 2 ; sfx wave channel pointer
	ld de, Audio2_CryRet
	ld [hl], e
	inc hl
	ld [hl], d ; overwrite pointer to point to sound_ret
	ld a, [wSavedVolume]
	and a
	jr nz, .done
	ldh a, [rAUDVOL]
	ld [wSavedVolume], a
	ld a, $77
	ldh [rAUDVOL], a
.done
	ret

Audio2_CryRet:
	sound_ret

INCLUDE "audio/poke_flute.asm"

INCLUDE "audio/sfx/pokeflute_ch5_ch6.asm"

Audio2_InitMusicVariables::
	xor a
	ld [wUnusedMusicByte], a
	ld [wDisableChannelOutputWhenSfxEnds], a
	ld [wMusicTempo + 1], a
	ld [wMusicWaveInstrument], a
	ld [wSfxWaveInstrument], a
	ld d, NUM_CHANNELS
	ld hl, wChannelReturnAddresses
	call Audio2_FillMem
	ld hl, wChannelCommandPointers
	call Audio2_FillMem
	ld d, NUM_MUSIC_CHANS
	ld hl, wChannelSoundIDs
	call Audio2_FillMem
	ld hl, wChannelFlags1
	call Audio2_FillMem
	ld hl, wChannelDutyCycles
	call Audio2_FillMem
	ld hl, wChannelDutyCyclePatterns
	call Audio2_FillMem
	ld hl, wChannelVibratoDelayCounters
	call Audio2_FillMem
	ld hl, wChannelVibratoExtents
	call Audio2_FillMem
	ld hl, wChannelVibratoRates
	call Audio2_FillMem
	ld hl, wChannelFrequencyLowBytes
	call Audio2_FillMem
	ld hl, wChannelVibratoDelayCounterReloadValues
	call Audio2_FillMem
	ld hl, wChannelFlags2
	call Audio2_FillMem
	ld hl, wChannelPitchSlideLengthModifiers
	call Audio2_FillMem
	ld hl, wChannelPitchSlideFrequencySteps
	call Audio2_FillMem
	ld hl, wChannelPitchSlideFrequencyStepsFractionalPart
	call Audio2_FillMem
	ld hl, wChannelPitchSlideCurrentFrequencyFractionalPart
	call Audio2_FillMem
	ld hl, wChannelPitchSlideCurrentFrequencyHighBytes
	call Audio2_FillMem
	ld hl, wChannelPitchSlideCurrentFrequencyLowBytes
	call Audio2_FillMem
	ld hl, wChannelPitchSlideTargetFrequencyHighBytes
	call Audio2_FillMem
	ld hl, wChannelPitchSlideTargetFrequencyLowBytes
	call Audio2_FillMem
	ld a, $1
	ld hl, wChannelLoopCounters
	call Audio2_FillMem
	ld hl, wChannelNoteDelayCounters
	call Audio2_FillMem
	ld hl, wChannelNoteSpeeds
	call Audio2_FillMem
	ld [wMusicTempo], a
	ld a, $ff
	ld [wStereoPanning], a
	xor a
	ldh [rAUDVOL], a
	ld a, AUD1SWEEP_DOWN
	ldh [rAUD1SWEEP], a
	ld a, 0
	ldh [rAUDTERM], a
	xor a
	ldh [rAUD3ENA], a
	ld a, AUD3ENA_ON
	ldh [rAUD3ENA], a
	ld a, $77
	ldh [rAUDVOL], a
	ret

Audio2_InitSFXVariables::
	xor a
	push de
	ld h, d
	ld l, e
	add hl, hl
	ld d, h
	ld e, l
	ld hl, wChannelReturnAddresses
	add hl, de
	ld [hli], a
	ld [hl], a
	ld hl, wChannelCommandPointers
	add hl, de
	ld [hli], a
	ld [hl], a
	pop de
	ld hl, wChannelSoundIDs
	add hl, de
	ld [hl], a
	ld hl, wChannelFlags1
	add hl, de
	ld [hl], a
	ld hl, wChannelDutyCycles
	add hl, de
	ld [hl], a
	ld hl, wChannelDutyCyclePatterns
	add hl, de
	ld [hl], a
	ld hl, wChannelVibratoDelayCounters
	add hl, de
	ld [hl], a
	ld hl, wChannelVibratoExtents
	add hl, de
	ld [hl], a
	ld hl, wChannelVibratoRates
	add hl, de
	ld [hl], a
	ld hl, wChannelFrequencyLowBytes
	add hl, de
	ld [hl], a
	ld hl, wChannelVibratoDelayCounterReloadValues
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchSlideLengthModifiers
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchSlideFrequencySteps
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchSlideFrequencyStepsFractionalPart
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchSlideCurrentFrequencyFractionalPart
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchSlideCurrentFrequencyHighBytes
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchSlideCurrentFrequencyLowBytes
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchSlideTargetFrequencyHighBytes
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchSlideTargetFrequencyLowBytes
	add hl, de
	ld [hl], a
	ld hl, wChannelFlags2
	add hl, de
	ld [hl], a
	ld a, $1
	ld hl, wChannelLoopCounters
	add hl, de
	ld [hl], a
	ld hl, wChannelNoteDelayCounters
	add hl, de
	ld [hl], a
	ld hl, wChannelNoteSpeeds
	add hl, de
	ld [hl], a
	ld a, e
	cp CHAN5
	ret nz
	ld a, AUD1SWEEP_DOWN
	ldh [rAUD1SWEEP], a ; sweep off
	ret

Audio2_StopAllAudio::
	ld a, AUDENA_ON
	ldh [rAUDENA], a ; sound hardware on
	ldh [rAUD3ENA], a ; wave playback on
	xor a
	ldh [rAUDTERM], a ; no sound output
	ldh [rAUD3LEVEL], a ; mute channel 3 (wave channel)
	ld a, AUD1SWEEP_DOWN
	ldh [rAUD1SWEEP], a ; sweep off
	ldh [rAUD1ENV], a ; mute channel 1 (pulse channel 1)
	ldh [rAUD2ENV], a ; mute channel 2 (pulse channel 2)
	ldh [rAUD4ENV], a ; mute channel 4 (noise channel)
	ld a, AUD1HIGH_LENGTH_ON
	ldh [rAUD1HIGH], a ; counter mode
	ldh [rAUD2HIGH], a
	ldh [rAUD4GO], a
	ld a, $77
	ldh [rAUDVOL], a ; full volume
	xor a
	ld [wUnusedMusicByte], a
	ld [wDisableChannelOutputWhenSfxEnds], a
	ld [wMuteAudioAndPauseMusic], a
	ld [wMusicTempo + 1], a
	ld [wSfxTempo + 1], a
	ld [wMusicWaveInstrument], a
	ld [wSfxWaveInstrument], a
	ld d, $b0
	ld hl, wChannelCommandPointers
	call Audio2_FillMem
	ld a, $1
	ld d, $18
	ld hl, wChannelNoteDelayCounters
	call Audio2_FillMem
	ld [wMusicTempo], a
	ld [wSfxTempo], a
	ld a, $ff
	ld [wStereoPanning], a
	ret

; fills d bytes at hl with a
Audio2_FillMem:
	ld b, d
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ret
