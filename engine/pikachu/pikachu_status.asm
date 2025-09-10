IsStarterPikachuAliveInOurParty::
	ld hl, wPartySpecies
	ld de, wPartyMon1OTID
	ld bc, wPartyMonOT
	push hl
.loop
	pop hl
	ld a, [hli]
	push hl
	inc a
	jr z, .noPlayerPikachu
	cp STARTER_PIKACHU + 1
	jr nz, .curMonNotPlayerPikachu
	ld h, d
	ld l, e
	ld a, [wPlayerID]
	cp [hl]
	jr nz, .curMonNotPlayerPikachu
	inc hl
	ld a, [wPlayerID+1]
	cp [hl]
	jr nz, .curMonNotPlayerPikachu

	push de
	push bc
	ld hl, wPlayerName
	ld d, NAME_LENGTH_JP
.nameCompareLoop
	dec d
	jr z, .sameOT
	ld a, [bc]
	inc bc
	cp [hl]
	inc hl
	jr z, .nameCompareLoop
	pop bc
	pop de

.curMonNotPlayerPikachu
	ld hl, wPartyMon2 - wPartyMon1
	add hl, de
	ld d, h
	ld e, l
	ld hl, NAME_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	jr .loop

.sameOT
	pop bc
	pop de
	ld h, d
	ld l, e
	ld bc, wPartyMon1HP - wPartyMon1OTID
	add hl, bc
	ld a, [hli]
	or [hl]
	jr z, .noPlayerPikachu ; fainted Starter Pikachu
	pop hl
	scf
	ret

.noPlayerPikachu
	pop hl
	and a
	ret

IsThisBoxMonStarterPikachu::
	ld hl, wBoxMon1
	ld bc, wBoxMon2 - wBoxMon1
	ld de, wBoxMonOT
	jr IsThisMonStarterPikachu

IsThisPartyMonStarterPikachu::
	ld hl, wPartyMon1
	ld bc, wPartyMon2 - wPartyMon1
	ld de, wPartyMonOT
IsThisMonStarterPikachu:
	ld a, [wWhichPokemon]
	call AddNTimes
	ld a, [hl]
	cp STARTER_PIKACHU
	jr nz, .notPlayerPikachu
	ld bc, wPartyMon1OTID - wPartyMon1
	add hl, bc
	ld a, [wPlayerID]
	cp [hl]
	jr nz, .notPlayerPikachu
	inc hl
	ld a, [wPlayerID+1]
	cp [hl]
	jr nz, .notPlayerPikachu
	ld h, d
	ld l, e
	ld a, [wWhichPokemon]
	ld bc, NAME_LENGTH
	call AddNTimes
	ld de, wPlayerName
	ld b, NAME_LENGTH_JP
.loop
	dec b
	jr z, .isPlayerPikachu
	ld a, [de]
	inc de
	cp [hl]
	inc hl
	jr z, .loop
.notPlayerPikachu
	and a
	ret

.isPlayerPikachu
	scf
	ret

UpdatePikachuMoodAfterBattle::
; because d is always $82 at this function, it serves to
; ensure Pikachu's mood is at least 130 after battle
	push de
	call IsStarterPikachuAliveInOurParty
	pop de
	ret nc
	ld a, d
	cp 128
	ld a, [wPikachuMood]
	jr c, .d_less_than_128 ; we never jump
	cp d
	jr c, .load_d_into_mood
	ret

.d_less_than_128
	cp d
	ret c
.load_d_into_mood
	ld a, d
	ld [wPikachuMood], a
	ret

CheckPikachuStatusCondition::
; set carry flag if Starter Pikachu has a status condition
; also return d = 0 if fainted, but no function uses it
	xor a
	ld [wWhichPokemon], a
	ld hl, wPartyCount
.loop
	inc hl
	ld a, [hl]
	cp $ff
	jr z, .noAilment
	push hl
	call IsThisPartyMonStarterPikachu
	pop hl
	jr nc, .next
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1HP
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a, [hli]
	or [hl]
	ld d, a
	inc hl
	inc hl
	ld a, [hl] ; status
	and a
	jr nz, .hasAilment
	jr .noAilment

.next
	ld a, [wWhichPokemon]
	inc a
	ld [wWhichPokemon], a
	jr .loop

.hasAilment
	scf
	ret

.noAilment
	and a
	ret

IsSurfingStarterPikachuInParty::
	ld hl, wPartySpecies
	ld de, wPartyMon1Moves
	ld bc, wPartyMonOT
	push hl
.loop
	pop hl
	ld a, [hli]
	push hl
	inc a
	jr z, .noSurfingPlayerPikachu
	cp STARTER_PIKACHU + 1
	jr nz, .curMonNotSurfingPlayerPikachu
	ld h, d
	ld l, e
	push hl
	push bc
	ld b, NUM_MOVES
.moveSearchLoop
	ld a, [hli]
	cp SURF
	jr z, .foundSurfingPikachu
	dec b
	jr nz, .moveSearchLoop
	pop bc
	pop hl
	jr .curMonNotSurfingPlayerPikachu

.foundSurfingPikachu
	pop bc
	pop hl
	inc hl
	inc hl
	inc hl
	inc hl
	ld a, [wPlayerID]
	cp [hl]
	jr nz, .curMonNotSurfingPlayerPikachu
	inc hl
	ld a, [wPlayerID+1]
	cp [hl]
	jr nz, .curMonNotSurfingPlayerPikachu
	push de
	push bc
	ld hl, wPlayerName
	ld d, NAME_LENGTH_JP
.nameCompareLoop
	dec d
	jr z, .foundSurfingPlayerPikachu
	ld a, [bc]
	inc bc
	cp [hl]
	inc hl
	jr z, .nameCompareLoop
	pop bc
	pop de
.curMonNotSurfingPlayerPikachu
	ld hl, wPartyMon2 - wPartyMon1
	add hl, de
	ld d, h
	ld e, l
	ld hl, NAME_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	jr .loop

.foundSurfingPlayerPikachu
	pop bc
	pop de
	pop hl
	scf
	ret

.noSurfingPlayerPikachu
	pop hl
	and a
	ret
