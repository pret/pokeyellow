_GivePokemon: ; f66fa (3d:66fa)
	call EnableAutoTextBoxDrawing
	xor a
	ld [wccd3], a
	ld a, [wPartyCount] ; wPartyCount
	cp PARTY_LENGTH
	jr c, .partyNotFull
	ld a, [W_NUMINBOX] ; wda80
	cp MONS_PER_BOX
	jr nc, .boxFull
	xor a
	ld [W_ENEMYBATTSTATUS3], a ; W_ENEMYBATTSTATUS3
	ld a, [wcf91]
	ld [wEnemyMonSpecies2], a
	callab LoadEnemyMonData
	call SetPokedexOwnedFlag
	callab SendNewMonToBox
	ld hl, wcf4b
	ld a, [wd5a0]
	and $7f
	cp 9
	jr c, .boxEightOrLesser ; do not adjust box number to a 2 digit number
	sub 9
	ld [hl], "1"
	inc hl
	add "0"
	jr .continue
.boxEightOrLesser
	add "1"
.continue
	ld [hli], a
	ld [hl], "@"
	ld hl, SetToBoxText
	call PrintText
	scf
	ret
.boxFull
	ld hl, BoxIsFullText
	call PrintText
	and a
	ret
.partyNotFull
	call SetPokedexOwnedFlag
	call AddPartyMon
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld [wccd3], a
	scf
	ret

SetPokedexOwnedFlag: ; f676c (3d:676c)
	ld a, [wcf91]
	push af
	ld [wd11e], a
	predef IndexToPokedex
	ld a, [wd11e]
	dec a
	ld c, a
	ld hl, wPokedexOwned ; wPokedexOwned
	ld b, $1
	predef FlagActionPredef
	pop af
	ld [wd11e], a
	call GetMonName
	ld hl, GotMonText
	jp PrintText

UnknownTerminator_f6794: ; f6794 (3d:6794)
	db "@"
	
GotMonText: ; f6795 (3d:6795)
	TX_FAR _GotMonText
	db $0b
	db "@"

SetToBoxText: ; f679b (3d:679b)
	TX_FAR _SetToBoxText
	db "@"

BoxIsFullText: ; f67a0 (3d:67a0)
	TX_FAR _BoxIsFullText
	db "@"
