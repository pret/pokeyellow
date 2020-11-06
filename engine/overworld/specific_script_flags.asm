SetMapSpecificScriptFlagsOnMapReload::
	ld a, [wCurMap]
	cp VERMILION_GYM
	jr z, .vermilion_gym
	ld c, a
	ld hl, Bit5Maps
.search_loop
	ld a, [hli]
	cp c
	jr z, .in_list
	cp $ff
	jr nz, .search_loop
	ret

.vermilion_gym
	ld hl, wCurrentMapScriptFlags
	set 6, [hl]
	ret

.in_list
	ld hl, wCurrentMapScriptFlags
	set 5, [hl]
	ret

INCLUDE "data/maps/bit_5_maps.asm"
