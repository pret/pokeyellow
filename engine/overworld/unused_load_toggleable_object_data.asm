Func_f0a54: ; unreferenced
	ret

LoadToggleableObjectData::
; farcalled by an unreferenced function
	ld hl, .ToggleableObjectsMaps
.loop
	ld a, [hli]
	cp -1
	ret z
	ld b, a
	ld a, [wCurMap]
	cp b
	jr z, .found
	inc hl
	inc hl
	inc hl
	jr .loop

.found
	ld a, [hli]
	ld c, a
	ld b, 0
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wToggleableObjectList
	call CopyData
	ret

MACRO toggleable_object_map
	db \1
	db \3 - \2
	dw \2
ENDM

.ToggleableObjectsMaps:
	toggleable_object_map BLUES_HOUSE, .BluesHouse, .BluesHouseEnd
	db -1 ; end

.BluesHouse:
	db 1, TOGGLE_DAISY_SITTING_COPY
	db 2, TOGGLE_DAISY_WALKING_COPY
	db 3, TOGGLE_TOWN_MAP_COPY
	db -1 ; end
.BluesHouseEnd:
