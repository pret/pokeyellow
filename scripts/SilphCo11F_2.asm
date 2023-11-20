SilphCo11FTeamRocketLeavesScript::
	ld hl, .HideMissableObjectIDs
.hide_loop
	ld a, [hli]
	cp $ff
	jr z, .done_hiding
	push hl
	ld [wMissableObjectIndex], a
	predef HideObject
	pop hl
	jr .hide_loop
.done_hiding
	ld hl, .ShowMissableObjectIDs
.show_loop
	ld a, [hli]
	cp -1
	ret z
	push hl
	ld [wMissableObjectIndex], a
	predef ShowObject
	pop hl
	jr .show_loop

.ShowMissableObjectIDs:
	db HS_SAFFRON_CITY_8
	db HS_SAFFRON_CITY_9
	db HS_SAFFRON_CITY_A
	db HS_SAFFRON_CITY_B
	db HS_SAFFRON_CITY_C
	db HS_SAFFRON_CITY_D
	db -1 ; end

.HideMissableObjectIDs:
	db HS_SAFFRON_CITY_1
	db HS_SAFFRON_CITY_2
	db HS_SAFFRON_CITY_3
	db HS_SAFFRON_CITY_4
	db HS_SAFFRON_CITY_5
	db HS_SAFFRON_CITY_6
	db HS_SAFFRON_CITY_7
	db HS_SAFFRON_CITY_E
	db HS_SAFFRON_CITY_F
	db HS_SILPH_CO_2F_2
	db HS_SILPH_CO_2F_3
	db HS_SILPH_CO_2F_4
	db HS_SILPH_CO_2F_5
	db HS_SILPH_CO_3F_1
	db HS_SILPH_CO_3F_2
	db HS_SILPH_CO_4F_1
	db HS_SILPH_CO_4F_2
	db HS_SILPH_CO_4F_3
	db HS_SILPH_CO_5F_1
	db HS_SILPH_CO_5F_2
	db HS_SILPH_CO_5F_3
	db HS_SILPH_CO_5F_4
	db HS_SILPH_CO_6F_1
	db HS_SILPH_CO_6F_2
	db HS_SILPH_CO_6F_3
	db HS_SILPH_CO_7F_1
	db HS_SILPH_CO_7F_2
	db HS_SILPH_CO_7F_3
	db HS_SILPH_CO_7F_4
	db HS_SILPH_CO_8F_1
	db HS_SILPH_CO_8F_2
	db HS_SILPH_CO_8F_3
	db HS_SILPH_CO_9F_1
	db HS_SILPH_CO_9F_2
	db HS_SILPH_CO_9F_3
	db HS_SILPH_CO_10F_1
	db HS_SILPH_CO_10F_2
	db HS_SILPH_CO_11F_1
	db HS_SILPH_CO_11F_JAMES
	db HS_SILPH_CO_11F_2
	db HS_SILPH_CO_11F_JESSIE
	db -1 ; end
