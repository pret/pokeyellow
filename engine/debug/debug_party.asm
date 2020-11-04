; not IshiharaTeam
SetDebugTeam:
	ld de, DebugTeam
.loop
	ld a, [de]
	cp -1
	ret z
	ld [wcf91], a
	inc de
	ld a, [de]
	ld [wCurEnemyLVL], a
	inc de
	call AddPartyMon
	jr .loop

DebugTeam:
	db SNORLAX, 80
	db PERSIAN, 80
	db JIGGLYPUFF, 15
	db PIKACHU, 5
	db -1 ; end

DebugStart:
	ret
