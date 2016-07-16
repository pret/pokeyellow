PlayDefaultMusic::
	call WaitForSoundToFinish
	xor a
	ld c, a
	ld d, a
	ld [wLastMusicSoundID], a
	jr PlayDefaultMusicCommon

PlayDefaultMusicFadeOutCurrent::
; Fade out the current music and then play the default music.
	ld c, 10
	ld d, 0
	ld a, [wd72e]
	bit 5, a ; has a battle just ended?
	jr z, PlayDefaultMusicCommon
	xor a
	ld [wLastMusicSoundID], a
	ld c, 8
	ld d, c

PlayDefaultMusicCommon::
	ld a, [wWalkBikeSurfState]
	and a
	jr z, .walking
	cp $2
	jr z, .surfing
	call CheckForNoBikingMusicMap
	jr c, .walking
	ld a, MUSIC_BIKE_RIDING
	jr .next

.surfing
	ld a, MUSIC_SURFING

.next
	ld b, a
	ld a, d
	and a ; should current music be faded out first?
	ld a, BANK(Music_BikeRiding)
	jr nz, .next2

; Only change the audio ROM bank if the current music isn't going to be faded
; out before the default music begins.
	ld [wAudioROMBank], a

.next2
; [wAudioSavedROMBank] will be copied to [wAudioROMBank] after fading out the
; current music (if the current music is faded out).
	ld [wAudioSavedROMBank], a
	jr .next3

.walking
	ld a, [wMapMusicSoundID]
	ld b, a
	call CompareMapMusicBankWithCurrentBank
	jr c, .next4

.next3
	ld a, [wLastMusicSoundID]
	cp b ; is the default music already playing?
	ret z ; if so, do nothing

.next4
	ld a, c
	ld [wAudioFadeOutControl], a
	ld a, b
	ld [wLastMusicSoundID], a
	ld [wNewSoundID], a
	jp PlaySound

CheckForNoBikingMusicMap::
; probably used to not change music upon getting on bike
	ld a, [wCurMap]
	cp ROUTE_23
	jr z, .found
	cp VICTORY_ROAD_1
	jr z, .found
	cp VICTORY_ROAD_2
	jr z, .found
	cp VICTORY_ROAD_3
	jr z, .found
	cp INDIGO_PLATEAU
	jr z, .found
	and a
	ret
.found
	scf
	ret

UpdateMusic6Times::
	ld c, 6
UpdateMusicCTimes::
.loop
	push bc
	push hl
	callba Audio1_UpdateMusic
	pop hl
	pop bc
	dec c
	jr nz, .loop
	ret

CompareMapMusicBankWithCurrentBank::
; Compares the map music's audio ROM bank with the current audio ROM bank
; and updates the audio ROM bank variables.
; Returns whether the banks are different in carry.
	ld a, [wMapMusicROMBank]
	ld e, a
	ld a, [wAudioROMBank]
	cp e
	jr nz, .differentBanks
	ld [wAudioSavedROMBank], a
	and a
	ret
.differentBanks
	ld a, c ; this is a fade-out counter value and it's always non-zero
	and a
	ld a, e
	jr nz, .next
; If the fade-counter is non-zero, we don't change the audio ROM bank because
; it's needed to keep playing the music as it fades out. The FadeOutAudio
; routine will take care of copying [wAudioSavedROMBank] to [wAudioROMBank]
; when the music has faded out.
	ld [wAudioROMBank], a
.next
	ld [wAudioSavedROMBank], a
	scf
	ret

PlayMusic::
	ld b, a
	ld [wNewSoundID], a
	xor a
	ld [wAudioFadeOutControl], a
	ld a, c
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	ld a, b
	jr PlaySound

Func_2223::
	xor a
	ld [wChannelSoundIDs + CH4], a
	ld [wChannelSoundIDs + CH5], a
	ld [wChannelSoundIDs + CH6], a
	ld [wChannelSoundIDs + CH7], a
	ld [rNR10], a
	ret

StopAllMusic::
	ld a, $FF
	ld [wNewSoundID], a
; plays music specified by a. If value is $ff, music is stopped
PlaySound::
	push hl
	push de
	push bc
	ld b, a
	ld a, [wNewSoundID]
	and a
	jr z, .next
	xor a
	ld [wChannelSoundIDs + CH4], a
	ld [wChannelSoundIDs + CH5], a
	ld [wChannelSoundIDs + CH6], a
	ld [wChannelSoundIDs + CH7], a
.next
	ld a, [wAudioFadeOutControl]
	and a ; has a fade-out length been specified?
	jr z, .noFadeOut
	ld a, [wNewSoundID]
	and a ; is the new sound ID 0?
	jr z, .done ; if so, do nothing
	xor a
	ld [wNewSoundID], a
	ld a, [wLastMusicSoundID]
	cp $ff ; has the music been stopped?
	jr nz, .fadeOut ; if not, fade out the current music
; If it has been stopped, start playing the new music immediately.
	xor a
	ld [wAudioFadeOutControl], a
.noFadeOut
	xor a
	ld [wNewSoundID], a
	call DetermineAudioFunction
	jr .done

.fadeOut
	ld a, b
	ld [wLastMusicSoundID], a
	ld a, [wAudioFadeOutControl]
	ld [wAudioFadeOutCounterReloadValue], a
	ld [wAudioFadeOutCounter], a
	ld a, b
	ld [wAudioFadeOutControl], a
.done
	pop bc
	pop de
	pop hl
	ret

GetNextMusicByte::
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, [wAudioROMBank]
	call BankswitchCommon
	ld d, $0
	ld a, c
	add a
	ld e, a
	ld hl, wChannelCommandPointers
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hld]
	ld d, a
	ld a, [de]
	inc de
	ld [hl], e
	inc hl
	ld [hl], d
	ld e, a
	pop af
	call BankswitchCommon
	ld a, e
	ret

InitMusicVariables::
	push hl
	push de
	push bc
	homecall Audio2_InitMusicVariables
	pop bc
	pop de
	pop hl
	ret

InitSFXVariables::
	push hl
	push de
	push bc
	homecall Audio2_InitSFXVariables
	pop bc
	pop de
	pop hl
	ret

StopAllAudio::
	push hl
	push de
	push bc
	homecall Audio2_StopAllAudio
	pop bc
	pop de
	pop hl
	ret

DetermineAudioFunction::
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, [wAudioROMBank]
	call BankswitchCommon
; determine the audio function, based on the bank
	cp BANK(Audio1_PlaySound)
	jr nz, .checkForBank08
; bank 02 (audio 1)
	ld a, b
	call Audio1_PlaySound
	jr .done

.checkForBank08
	cp BANK(Audio2_PlaySound)
	jr nz, .checkForBank1F
; bank 08 (audio 2)
	ld a, b
	call Audio2_PlaySound
	jr .done

.checkForBank1F
	cp BANK(Audio3_PlaySound)
	jr nz, .bank20
; bank 1f (audio 3)
	ld a, b
	call Audio3_PlaySound
	jr .done

.bank20
; invalid banks will default to XX:6bd4
; this is seen when encountering Missingno, as its sprite dimensions overflow to wAudioROMBank
	ld a, b
	call Audio4_PlaySound
.done
	pop af
	call BankswitchCommon
	ret

