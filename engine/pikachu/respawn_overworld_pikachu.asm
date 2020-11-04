RespawnOverworldPikachu:
	callfar IsThisPartymonStarterPikachu_Party
	ret nc
	ld a, $3
	ld [wPikachuSpawnState], a
	ret
