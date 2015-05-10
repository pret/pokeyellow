VBlank::

	push af
	push bc
	push de
	push hl

	ld a, [rVBK] ; vram bank
	push af
	xor a
	ld [rVBK], a ; reset vram bank to 0
	
	ld a, [H_LOADEDROMBANK]
	ld [wd122], a

	ld a, [hSCX]
	ld [rSCX], a
	ld a, [hSCY]
	ld [rSCY], a

	ld a, [wd0a0]
	and a
	jr nz, .ok
	ld a, [hWY]
	ld [rWY], a
.ok

	call AutoBgMapTransfer
	call VBlankCopyBgMap
	call RedrawExposedScreenEdge
	call VBlankCopy
	call VBlankCopyDouble
	call UpdateMovingBgTiles
	call $ff80 ; hOAMDMA
	ld a, Bank(PrepareOAMData)
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	call PrepareOAMData

	; VBlank-sensitive operations end.
	call TrackPlayTime ; keep track of time played
	
	call Random
	call ReadJoypad

	ld a, [H_VBLANKOCCURRED]
	and a
	jr z, .vblanked
	xor a
	ld [H_VBLANKOCCURRED], a
.vblanked

	ld a, [H_FRAMECOUNTER]
	and a
	jr z, .decced
	dec a
	ld [H_FRAMECOUNTER], a
.decced

	call Func_28cb
	
	ld a, $8
	call BankswitchCommon
	call Music_DoLowHealthAlarm
	
	ld a, $2
	call BankswitchCommon
	call Music2_UpdateMusic
	
	call SerialFunction ; add this

	ld a, [wd122]
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a

	pop af
	ld [rVBK],a
	
	pop hl
	pop de
	pop bc
	pop af
	reti


DelayFrame::
; Wait for the next vblank interrupt.
; As a bonus, this saves battery.

NOT_VBLANKED EQU 1

	ld a, NOT_VBLANKED
	ld [H_VBLANKOCCURRED], a
.halt
	halt
	ld a, [H_VBLANKOCCURRED]
	and a
	jr nz, .halt
	ret
