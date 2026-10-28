RespawnOverworldPikachu:
	callfar IsThisPartyMonStarterPikachu
	ret nc
	ld a, PIKACHU_SPAWN_DELAYED
	ld [wPikachuSpawnState], a
	ret
