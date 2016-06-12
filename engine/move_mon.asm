_MoveMon:
	ld a, [wMoveMonType]
	and a
	jr z, .checkPartyMonSlots
	cp DAYCARE_TO_PARTY
	jr z, .checkPartyMonSlots
	cp PARTY_TO_DAYCARE
	ld hl, wDayCareMon
	jr z, .asm_f3fb
	ld hl, wNumInBox
	ld a, [hl]
	cp MONS_PER_BOX
	jr nz, .partyOrBoxNotFull
	jr .boxFull
.checkPartyMonSlots
	ld hl, wPartyCount
	ld a, [hl]
	cp PARTY_LENGTH
	jr nz, .partyOrBoxNotFull
.boxFull
	scf
	ret
.partyOrBoxNotFull
	inc a
	ld [hl], a           ; increment number of mons in party/box
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wMoveMonType]
	cp DAYCARE_TO_PARTY
	ld a, [wDayCareMon]
	jr z, .asm_f3dc
	ld a, [wcf91]
.asm_f3dc
	ld [hli], a          ; write new mon ID
	ld [hl], $ff         ; write new sentinel
	ld a, [wMoveMonType]
	dec a
	ld hl, wPartyMons
	ld bc, wPartyMon2 - wPartyMon1 ; $2c
	ld a, [wPartyCount]
	jr nz, .skipToNewMonEntry
	ld hl, wBoxMons
	ld bc, wBoxMon2 - wBoxMon1 ; $21
	ld a, [wNumInBox]
.skipToNewMonEntry
	dec a
	call AddNTimes
.asm_f3fb
	push hl
	ld e, l
	ld d, h
	ld a, [wMoveMonType]
	and a
	ld hl, wBoxMons
	ld bc, wBoxMon2 - wBoxMon1 ; $21
	jr z, .asm_f417
	cp DAYCARE_TO_PARTY
	ld hl, wDayCareMon
	jr z, .asm_f41d
	ld hl, wPartyMons
	ld bc, wPartyMon2 - wPartyMon1 ; $2c
.asm_f417
	ld a, [wWhichPokemon]
	call AddNTimes
.asm_f41d
	push hl
	push de
	ld bc, wBoxMon2 - wBoxMon1
	call CopyData
	pop de
	pop hl
	ld a, [wMoveMonType]
	and a
	jr z, .asm_f43a
	cp DAYCARE_TO_PARTY
	jr z, .asm_f43a
	ld bc, wBoxMon2 - wBoxMon1
	add hl, bc
	ld a, [hl]
	inc de
	inc de
	inc de
	ld [de], a
.asm_f43a
	ld a, [wMoveMonType]
	cp PARTY_TO_DAYCARE
	ld de, wDayCareMonOT
	jr z, .asm_f459
	dec a
	ld hl, wPartyMonOT
	ld a, [wPartyCount]
	jr nz, .asm_f453
	ld hl, wBoxMonOT
	ld a, [wNumInBox]
.asm_f453
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
.asm_f459
	ld hl, wBoxMonOT
	ld a, [wMoveMonType]
	and a
	jr z, .asm_f46c
	ld hl, wDayCareMonOT
	cp DAYCARE_TO_PARTY
	jr z, .asm_f472
	ld hl, wPartyMonOT
.asm_f46c
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
.asm_f472
	ld bc, NAME_LENGTH
	call CopyData
	ld a, [wMoveMonType]
	cp PARTY_TO_DAYCARE
	ld de, wDayCareMonName
	jr z, .asm_f497
	dec a
	ld hl, wPartyMonNicks
	ld a, [wPartyCount]
	jr nz, .asm_f491
	ld hl, wBoxMonNicks
	ld a, [wNumInBox]
.asm_f491
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
.asm_f497
	ld hl, wBoxMonNicks
	ld a, [wMoveMonType]
	and a
	jr z, .asm_f4aa
	ld hl, wDayCareMonName
	cp DAYCARE_TO_PARTY
	jr z, .asm_f4b0
	ld hl, wPartyMonNicks
.asm_f4aa
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
.asm_f4b0
	ld bc, NAME_LENGTH
	call CopyData
	pop hl
	ld a, [wMoveMonType]
	cp PARTY_TO_BOX
	jr z, .asm_f4ea
	cp PARTY_TO_DAYCARE
	jr z, .asm_f4ea
	push hl
	srl a
	add $2
	ld [wMonDataLocation], a
	call LoadMonData
	callba CalcLevelFromExperience
	ld a, d
	ld [wCurEnemyLVL], a
	pop hl
	ld bc, wBoxMon2 - wBoxMon1
	add hl, bc
	ld [hli], a
	ld d, h
	ld e, l
	ld bc, -18
	add hl, bc
	ld b, $1
	call CalcStats
.asm_f4ea
	and a
	ret
