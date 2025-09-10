RespawnOverworldPikachu:
	callfar IsThisPartyMonStarterPikachu
	ret nc
	ld a, $3
	ld [wPikachuSpawnState], a
	ret
