UpdateGBCPal_BGP::
	push af
	ldh a, [hGBC]
	and a
	jr z, .notGBC
	push bc
	push de
	push hl
	ldh a, [rBGP]
	ld b, a
	ld a, [wLastBGP]
	cp b
	jr z, .noChangeInBGP
	farcall _UpdateGBCPal_BGP
.noChangeInBGP
	pop hl
	pop de
	pop bc
.notGBC
	pop af
	ret

UpdateGBCPal_OBP0::
	push af
	ldh a, [hGBC]
	and a
	jr z, .notGBC
	push bc
	push de
	push hl
	ldh a, [rOBP0]
	ld b, a
	ld a, [wLastOBP0]
	cp b
	jr z, .noChangeInOBP0
	ld b, BANK(_UpdateGBCPal_OBP)
	ld hl, _UpdateGBCPal_OBP
	ld c, CONVERT_OBP0
	call Bankswitch
.noChangeInOBP0
	pop hl
	pop de
	pop bc
.notGBC
	pop af
	ret

UpdateGBCPal_OBP1::
	push af
	ldh a, [hGBC]
	and a
	jr z, .notGBC
	push bc
	push de
	push hl
	ldh a, [rOBP1]
	ld b, a
	ld a, [wLastOBP1]
	cp b
	jr z, .noChangeInOBP1
	ld b, BANK(_UpdateGBCPal_OBP)
	ld hl, _UpdateGBCPal_OBP
	ld c, CONVERT_OBP1
	call Bankswitch
.noChangeInOBP1
	pop hl
	pop de
	pop bc
.notGBC
	pop af
	ret

Func_3082::
	ldh a, [hLoadedROMBank]
	push af
	call FadeOutAudio
	ld a, BANK(Music_DoLowHealthAlarm)
	call BankswitchCommon
	call Music_DoLowHealthAlarm
	ld a, BANK(Audio1_UpdateMusic)
	call BankswitchCommon
	call Audio1_UpdateMusic
	pop af
	call BankswitchCommon
	ret
