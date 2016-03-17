; not IshiharaTeam
SetDebugTeam: ; 623e (1:623e)
	ld de, DebugTeam
.loop
	ld a, [de]
	cp $ff
	ret z
	ld [wcf91], a
	inc de
	ld a, [de]
	ld [wCurEnemyLVL], a
	inc de
	call AddPartyMon
	jr .loop

DebugTeam: ; 6253 (1:6253)
	db SNORLAX,80
	db PERSIAN,80
	db JIGGLYPUFF,15
	db PIKACHU,5
	db $FF

EmptyFunc: ; 64ea (1:64ea)
	ret