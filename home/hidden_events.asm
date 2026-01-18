UpdateCinnabarGymGateTileBlocks::
	farcall UpdateCinnabarGymGateTileBlocks_
	ret

CheckForHiddenEventOrBookshelfOrCardKeyDoor::
	ldh a, [hLoadedROMBank]
	push af
	ldh a, [hJoyHeld]
	bit B_PAD_A, a
	jr z, .nothingFound
; A button is pressed
	ld a, BANK(CheckForHiddenEvent)
	call BankswitchCommon
	call CheckForHiddenEvent
	ldh a, [hDidntFindAnyHiddenEvent]
	and a
	jr nz, .hiddenEventNotFound
	xor a
	ldh [hItemAlreadyFound], a
	ld a, [wHiddenEventFunctionRomBank]
	call BankswitchCommon
	call JumpToAddress
	ldh a, [hItemAlreadyFound]
	jr .done
.hiddenEventNotFound
	predef GetTileAndCoordsInFrontOfPlayer
	farcall PrintBookshelfText
	ldh a, [hInteractedWithBookshelf]
	and a
	jr z, .done
.nothingFound
	ld a, $ff
.done
	ldh [hItemAlreadyFound], a
	pop af
	call BankswitchCommon
	ret
