IsPlayerOnDungeonWarp:
	xor a
	ld [wWhichDungeonWarp], a
	ld a, [wd72d]
	bit 4, a
	ret nz
	call ArePlayerCoordsInArray
	ret nc
	ld a, [wCoordIndex]
	ld [wWhichDungeonWarp], a
	ld hl, wd72d
	set 4, [hl]
	ld hl, wd732
	set 4, [hl]
	ret
