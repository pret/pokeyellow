PlayDefaultMusic:: ; 216b (0:216b)
	call WaitForSoundToFinish
	xor a
	ld c, a
	ld d, a
	ld [wLastMusicSoundID], a
	jr PlayDefaultMusicCommon

PlayDefaultMusicFadeOutCurrent:: ; 2176 (0:2176)
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
PlayDefaultMusicCommon:: ; 2118 (0:2118)
	ld a, [wWalkBikeSurfState]
	and a
	jr z, .walking
	cp $2
	jr z, .surfing
	call Func_21c8
	jr c, .walking
	ld a, $d2 ; MUSIC_BIKE_RIDING
	jr .next

.surfing
	ld a, $d6 ; MUSIC_SURFING

.next
	ld b, a
	ld a, d
	and a ; should current music be faded out first?
	ld a, $1f ; BANK(Music_BikeRiding)
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

Func_21c8:: ; 21c8 (0:21c8)
; probably used to not change music upon getting on bike
	ld a,[W_CURMAP]
	cp ROUTE_23
	jr z,.asm_21e1
	cp VICTORY_ROAD_1
	jr z,.asm_21e1
	cp VICTORY_ROAD_2
	jr z,.asm_21e1
	cp VICTORY_ROAD_3
	jr z,.asm_21e1
	cp INDIGO_PLATEAU
	jr z,.asm_21e1
	and a
	ret
.asm_21e1
	scf
	ret

Func_21e3:: ; 21e3 (0:21e3)
	ld c,$6
.loop
	push bc
	push hl
	callba Audio1_UpdateMusic ; 2:509d
	pop hl
	pop bc
	dec c
	jr nz, .loop
	ret
	
;Func_235f:: ; 235f (0:235f)
;	ld a, [wAudioROMBank]
;	ld b, a
;	cp BANK(Music2_UpdateMusic)
;	jr nz, .checkForBank08
;.bank02
;	ld hl, Music2_UpdateMusic
;	jr .asm_2378
;.checkForBank08
;	cp BANK(Music8_UpdateMusic)
;	jr nz, .bank1F
;.bank08
;	ld hl, Music8_UpdateMusic
;	jr .asm_2378
;.bank1F
;	ld hl, Music1f_UpdateMusic
;.asm_2378
;	ld c, $6
;.asm_237a
;	push bc
;	push hl
;	call Bankswitch
;	pop hl
;	pop bc
;	dec c
;	jr nz, .asm_237a
;	ret

CompareMapMusicBankWithCurrentBank:: ; 21f5 (0:21f5)
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

PlayMusic:: ; 2211 (0:2211)
	ld b, a
	ld [wNewSoundID], a
	xor a
	ld [wAudioFadeOutControl], a
	ld a, c
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	ld a, b
	jr PlaySound
	
Func_2223:: ; 2223 (0:2223)
	xor a
	ld [wChannelSoundIDs + CH4],a
	ld [wChannelSoundIDs + CH5],a
	ld [wChannelSoundIDs + CH6],a
	ld [wChannelSoundIDs + CH7],a
	ld [rNR10],a
	ret
	
StopAllMusic:: ; 2233 (0:2233)
	ld a,$FF
	ld [wNewSoundID],a
; plays music specified by a. If value is $ff, music is stopped
PlaySound:: ; 2238 (0:2238)
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
	and a
	jr z, .noFadeOut
	ld a, [wNewSoundID]
	and a
	jr z, .done
	xor a
	ld [wNewSoundID], a
	ld a, [wLastMusicSoundID]
	cp $ff
	jr nz, .fadeOut
	xor a
	ld [wAudioFadeOutControl], a
.noFadeOut
	xor a
	ld [wNewSoundID], a
	call Func_22ec
	jr .done
.fadeOut
	ld a,b
	ld [wLastMusicSoundID],a
	ld a,[wAudioFadeOutControl]
	ld [wAudioFadeOutCounterReloadValue],a
	ld [wAudioFadeOutCounter],a
	ld a,b
	ld [wAudioFadeOutControl],a
.done
	pop bc
	pop de
	pop hl
	ret

Func_2288:: ; 2288 (0:2288)
	ld a,[H_LOADEDROMBANK]
	push af
	ld a, [wAudioROMBank]
	call BankswitchCommon
	ld d,$0
	ld a,c
	add a
	ld e,a
	ld hl,wChannelCommandPointers
	add hl,de
	ld a,[hli]
	ld e,a
	ld a,[hld]
	ld d,a
	ld a,[de]
	inc de
	ld [hl],e
	inc hl
	ld [hl],d
	ld e,a
	pop af
	call BankswitchCommon
	ld a,e
	ret

Func_22aa:: ; 22aa (0:22aa)
	push hl
	push de
	push bc
	homecall Audio2_219f8 ; 8:59f8
	pop bc
	pop de
	pop hl
	ret
	
Func_22c0:: ; 22c0 (0:22c0)
	push hl
	push de
	push bc
	homecall Audio2_21ab7 ; 8:5ab7
	pop bc
	pop de
	pop hl
	ret
	
Func_22d6:: ; 22d6 (0:22d6)
	push hl
	push de
	push bc
	homecall Audio2_21b3f
	pop bc
	pop de
	pop hl
	ret
	
Func_22ec:: ; 22ec (0:22ec)
	ld a,[H_LOADEDROMBANK]
	push af
	ld a,[wAudioROMBank]
	call BankswitchCommon
	cp BANK(Audio1_PlaySound)
	jr nz, .checkForBank08
.bank02
	ld a, b
	call Audio1_PlaySound
	jr .done
.checkForBank08
	cp BANK(Audio2_PlaySound)
	jr nz, .checkForBank1F
.bank08
	ld a, b
	call Audio2_PlaySound
	jr .done
.checkForBank1F
	cp BANK(Func_7d10d)
	jr nz, .bank20
	ld a, b
	call Func_7d10d
	jr .done
.bank20
	ld a,b
	call Func_82bd4
.done
	pop af
	call BankswitchCommon
	ret

