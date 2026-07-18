LoadMonData_::
; Load monster [wWhichPokemon] from list [wMonDataLocation]:
;  0: partymon
;  1: enemymon
;  2: boxmon
;  3: daycaremon
; Return monster id at wCurPartySpecies and its data at wLoadedMon.
; Also load base stats at wMonHeader for convenience.

	ld a, [wDayCareMonSpecies]
	ld [wCurPartySpecies], a
	ld a, [wMonDataLocation]
	cp DAYCARE_DATA
	jr z, .GetMonHeader

	ld a, [wWhichPokemon]
	ld e, a
	call GetMonSpecies

.GetMonHeader
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	call GetMonHeader

	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wMonDataLocation]
	cp ENEMY_PARTY_DATA
	jr c, .getMonEntry

	ld hl, wEnemyMons
	jr z, .getMonEntry

	cp BOX_DATA
	ld hl, wBoxMons
	ld bc, BOXMON_STRUCT_LENGTH
	jr z, .getMonEntry

	ld hl, wDayCareMon
	jr .copyMonData

.getMonEntry
	ld a, [wWhichPokemon]
	call AddNTimes

.copyMonData
	ld de, wLoadedMon
	ld bc, PARTYMON_STRUCT_LENGTH
	jp CopyData

; get species of mon e in list [wMonDataLocation] for LoadMonData
GetMonSpecies:
	ld hl, wPartySpecies
	ld a, [wMonDataLocation]
	and a
	jr z, .getSpecies
	dec a
	jr z, .enemyParty
	ld hl, wBoxSpecies
	jr .getSpecies
.enemyParty
	ld hl, wEnemyPartySpecies
.getSpecies
	ld d, 0
	add hl, de
	ld a, [hl]
	ld [wCurPartySpecies], a
	ret
