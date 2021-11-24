UpdateCinnabarGymGateTileBlocks::
	farcall UpdateCinnabarGymGateTileBlocks_
	ret

CheckForHiddenObjectOrBookshelfOrCardKeyDoor::
	ldh a, [hLoadedROMBank]
	push af
	ldh a, [hJoyHeld]
	bit BIT_A_BUTTON, a
	jr z, .nothingFound
; A button is pressed
	ld a, BANK(CheckForHiddenObject)
	call BankswitchCommon
	call CheckForHiddenObject
	ldh a, [hDidntFindAnyHiddenObject]
	and a
	jr nz, .hiddenObjectNotFound
	xor a
	ldh [hItemAlreadyFound], a
	ld a, [wHiddenObjectFunctionRomBank]
	call BankswitchCommon
	call JumpToAddress
	ldh a, [hItemAlreadyFound]
	jr .done
.hiddenObjectNotFound
	predef GetTileAndCoordsInFrontOfPlayer
	farcall PrintBookshelfText
	ldh a, [hFFDB]
	and a
	jr z, .done
.nothingFound
	ld a, $ff
.done
	ldh [hItemAlreadyFound], a
	pop af
	call BankswitchCommon
	ret
