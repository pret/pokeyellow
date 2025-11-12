HandleMenuInputDuplicate: ; unreferenced
	xor a
	ld [wPartyMenuAnimMonEnabled], a

HandleMenuInputPokemonSelectionDuplicate: ; unreferenced
	ldh a, [hDownArrowBlinkCount1]
	push af
	ldh a, [hDownArrowBlinkCount2]
	push af ; save existing values on stack
	xor a
	ldh [hDownArrowBlinkCount1], a ; blinking down arrow timing value 1
	ld a, 6
	ldh [hDownArrowBlinkCount2], a ; blinking down arrow timing value 2
.loop1
	xor a
	ld [wAnimCounter], a ; counter for pokemon shaking animation
	call PlaceMenuCursorDuplicate
	call JoypadLowSensitivity
	ldh a, [hJoy5]
	and a ; was a key pressed?
	jr nz, .keyPressed
	pop af
	ldh [hDownArrowBlinkCount2], a
	pop af
	ldh [hDownArrowBlinkCount1], a ; restore previous values
	xor a
	ld [wMenuWrappingEnabled], a ; disable menu wrapping
	ret
.keyPressed
	xor a
	ld [wCheckFor180DegreeTurn], a
	ldh a, [hJoy5]
	ld b, a
	bit B_PAD_UP, a
	jr z, .checkIfDownPressed
.upPressed
	ld a, [wCurrentMenuItem] ; selected menu item
	and a ; already at the top of the menu?
	jr z, .checkOtherKeys
.notAtTop
	dec a
	ld [wCurrentMenuItem], a ; move selected menu item up one space
	jr .checkOtherKeys
.checkIfDownPressed
	bit B_PAD_DOWN, a
	jr z, .checkOtherKeys
.downPressed
	ld a, [wCurrentMenuItem]
	inc a
	ld c, a
	ld a, [wMaxMenuItem]
	cp c
	jr c, .checkOtherKeys
	ld a, c
	ld [wCurrentMenuItem], a
.checkOtherKeys
	ld a, [wMenuWatchedKeys]
	and b ; does the menu care about any of the pressed keys?
	jp z, .loop1
.checkIfAButtonOrBButtonPressed
	ldh a, [hJoy5]
	and PAD_A | PAD_B
	jr z, .skipPlayingSound
.AButtonOrBButtonPressed
	ld a, SFX_PRESS_AB
	call PlaySound ; play sound
.skipPlayingSound
	pop af
	ldh [hDownArrowBlinkCount2], a
	pop af
	ldh [hDownArrowBlinkCount1], a ; restore previous values
	ldh a, [hJoy5]
	ret

PlaceMenuCursorDuplicate:
	ld a, [wTopMenuItemY]
	and a
	jr z, .asm_f5ac0
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH
.loop
	add hl, bc
	dec a
	jr nz, .loop
.asm_f5ac0
	ld a, [wTopMenuItemX]
	ld b, $0
	ld c, a
	add hl, bc
	push hl
	ld a, [wLastMenuItem]
	and a
	jr z, .asm_f5ad5
	ld bc, $28
.loop2
	add hl, bc
	dec a
	jr nz, .loop2
.asm_f5ad5
	ld a, [hl]
	cp '▶'
	jr nz, .asm_f5ade
	ld a, [wTileBehindCursor]
	ld [hl], a
.asm_f5ade
	pop hl
	ld a, [wCurrentMenuItem]
	and a
	jr z, .asm_f5aec
	ld bc, $28
.loop3
	add hl, bc
	dec a
	jr nz, .loop3
.asm_f5aec
	ld a, [hl]
	cp '▶'
	jr z, .asm_f5af4
	ld [wTileBehindCursor], a
.asm_f5af4
	ld a, '▶'
	ld [hl], a
	ld a, l
	ld [wMenuCursorLocation], a
	ld a, h
	ld [wMenuCursorLocation + 1], a
	ld a, [wCurrentMenuItem]
	ld [wLastMenuItem], a
	ret
