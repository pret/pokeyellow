ReadSuperRodData:
	ld a, [wCurMap]
	ld c, a
	ld hl, SuperRodFishingSlots
.loop
	ld a, [hli]
	cp $ff
	jr z, .notfound
	cp c
	jr z, .found
	ld de, $8
	add hl, de
	jr .loop
.found
	call GenerateRandomFishingEncounter
	ret
.notfound
	ld de, $0
	ret

GenerateRandomFishingEncounter:
	call Random
	cp $66
	jr c, .asm_f5ed6
	inc hl
	inc hl
	cp $b2
	jr c, .asm_f5ed6
	inc hl
	inc hl
	cp $e5
	jr c, .asm_f5ed6
	inc hl
	inc hl
.asm_f5ed6
	ld e, [hl]
	inc hl
	ld d, [hl]
	ret

INCLUDE "data/wild/super_rod.asm"
