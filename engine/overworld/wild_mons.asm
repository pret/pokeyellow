LoadWildData::
	ld hl, WildDataPointers
	ld a, [wCurMap]

	; get wild data for current map
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a       ; hl now points to wild data for current map
	; check ALL151 flag — redirect to alternate data if this map has a patch
	ld a, [wUnusedObtainedBadges]
	bit BIT_NUZLOPTIONS_ALL_151_POKEMON, a
	jr z, .loadFromHL
	ld a, [wCurMap]
	ld b, a
	ld de, WildDataPatchTable_All151
.patchSearch
	ld a, [de]
	cp $ff
	jr z, .loadFromHL   ; not in table, use standard data
	cp b
	jr nz, .nextPatch
	inc de              ; found — read lo byte then hi byte of pointer
	ld a, [de]          ; a = lo byte
	ld b, a             ; save lo byte (b no longer needed for map compare)
	inc de
	ld a, [de]          ; a = hi byte
	ld h, a
	ld l, b             ; hl = alternate wild data pointer
	jr .loadFromHL
.nextPatch
	inc de
	inc de
	inc de
	jr .patchSearch
.loadFromHL
	ld a, [hli]
	ld [wGrassRate], a
	and a
	jr z, .NoGrassData ; if no grass data, skip to surfing data
	push hl
	ld de, wGrassMons ; otherwise, load grass data
	ld bc, WILDDATA_LENGTH - 1
	call CopyData
	pop hl
	ld bc, WILDDATA_LENGTH - 1
	add hl, bc
.NoGrassData
	ld a, [hli]
	ld [wWaterRate], a
	and a
	ret z        ; if no water data, we're done
	ld de, wWaterMons  ; otherwise, load surfing data
	ld bc, WILDDATA_LENGTH - 1
	jp CopyData

INCLUDE "data/wild/grass_water.asm"
