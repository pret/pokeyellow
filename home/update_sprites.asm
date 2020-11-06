UpdateSprites::
	ld a, [wUpdateSpritesEnabled]
	dec a
	ret nz
	ldh a, [hLoadedROMBank]
	push af
	ld a, BANK(_UpdateSprites)
	call BankswitchCommon
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	call _UpdateSprites
	ld a, $1
	ld [wUpdateSpritesEnabled], a
	pop af
	call BankswitchCommon
	ret
