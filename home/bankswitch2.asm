BankswitchCommon::
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	ret

Bankswitch::
; self-contained bankswitch, use this when not in the home bank
; switches to the bank in b
	ldh a, [hLoadedROMBank]
	push af
	ld a, b
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	call JumpToAddress
	pop bc
	ld a, b
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	ret
JumpToAddress::
	jp hl

OpenSRAM::
	push af
	ld a, BMODE_ADVANCED
	ld [rBMODE], a
	ld a, RAMG_SRAM_ENABLE
	ld [rRAMG], a
	pop af
	ld [rRAMB], a
	ret

CloseSRAM::
	push af
	ld a, 0
	ld [rBMODE], a
	ld [rRAMG], a
	pop af
	ret
