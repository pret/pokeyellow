; display "[player] VS [enemy]" text box with pokeballs representing their parties next to the names
DisplayLinkBattleVersusTextBox: ; f41cf (3d:41cf)
	call LoadTextBoxTilePatterns
	hlCoord 3, 4
	ld b, $70c
	call TextBoxBorder
	hlCoord 4, 5
	ld de, wPlayerName
	call PlaceString
	hlCoord 4, 10
	ld de, wLinkEnemyTrainerName
	call PlaceString
; place bold "VS" tiles between the names
	hlCoord 9, 8
	ld a, $69
	ld [hli], a
	ld [hl], $6a
	xor a
	ld [wUpdateSpritesEnabled], a
	callab SetupPlayerAndEnemyPokeballs
	ld c, 150
	jp DelayFrames
