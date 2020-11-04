MtMoon3Script_4a325: ; pikachu-related function?
	ld a, [wd472]
	bit 7, a
	ret z
	ld a, [wWalkBikeSurfState]
	and a
	ret nz

	push hl
	push bc
	callfar GetPikachuFacingDirectionAndReturnToE
	pop bc
	pop hl
	ld a, b
	cp e
	ret nz

	push hl
	ld a, [wUpdateSpritesEnabled]
	push af
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	callfar LoadPikachuShadowIntoVRAM
	pop af
	ld [wUpdateSpritesEnabled], a
	pop hl
	call ApplyPikachuMovementData
	ret
