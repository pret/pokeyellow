Func_e8d35:: ; e8d35 (3a:4e79)
	ld a, [wBoxDataStart]
	and a
	jp z, Func_e8df4
	ld a, [wUpdateSpritesEnabled]
	push af
	xor a
	ld [wUpdateSpritesEnabled], a
	ld [hItemCounter], a
	call Func_e8f24
	ld a, [rIE]
	push af
	xor a
	ld [rIF], a
	ld a, $09
	ld [rIE], a
	call SaveScreenTilesToBuffer1
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	call Func_e988a
	call Func_e8783
	ld a, $10
	ld [$cae2], a
	call Func_e8efc
	call LoadScreenTilesFromBuffer1
	call Func_e8dfb
	jr c, .asm_e8ddc
	xor a
	ld [wUnknownSerialFlag_d49a], a
	ld [wUnknownSerialFlag_d49b], a
	ld c, 12
	call DelayFrames
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	call Func_e98ec
	call Func_e8783
	ld a, $00
	ld [$cae2], a
	call Func_e8efc
	call LoadScreenTilesFromBuffer1
	call Func_e8dfb
	jr c, .asm_e8ddc
	xor a
	ld [wUnknownSerialFlag_d49a], a
	ld [wUnknownSerialFlag_d49b], a
	ld c, 12
	call DelayFrames
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	call Func_e9907
	call Func_e8783
	ld a, $00
	ld [$cae2], a
	call Func_e8efc
	call LoadScreenTilesFromBuffer1
	call Func_e8dfb
	jr c, .asm_e8ddc
	xor a
	ld [wUnknownSerialFlag_d49a], a
	ld [wUnknownSerialFlag_d49b], a
	ld c, 12
	call DelayFrames
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	call Func_e9922
	call Func_e8783
	ld a, $03
	ld [$cae2], a
	call Func_e8efc
	call LoadScreenTilesFromBuffer1
	call Func_e8dfb
.asm_e8ddc
	xor a
	ld [wUnknownSerialFlag_d49a], a
	ld [wUnknownSerialFlag_d49b], a
	xor a
	ld [rIF], a
	pop af
	ld [rIE], a
	call Func_0f3d
	call Func_e8f3b
	pop af
	ld [wUpdateSpritesEnabled], a
	ret

Func_e8df4: ; e8df4
	ld hl, String_e8e1f
	call PrintText
	ret

Func_e8dfb: ; e8dfb
	call Func_e8f16
.asm_e8dfe
	call JoypadLowSensitivity
	call Func_e8eca
	jr c, .asm_e8e1d
	ld a, [wOverworldMap]
	bit 7, a
	jr nz, .asm_e8e1b
	call Func_e87a8
	call Func_e8f51
	call Func_e8f82
	call DelayFrame
	jr .asm_e8dfe

.asm_e8e1b
	and a
	ret

.asm_e8e1d
	scf
	ret

String_e8e1f: ; e8e1f
	TX_FAR _NoPokemonText
	db "@"

Func_e8e24: ; e8e24
	xor a
	ld [hItemCounter], a
	call Func_e8f24
	call Func_ea3ea
	ld a, [rIE]
	push af
	xor a
	ld [rIF], a
	ld a, $09
	ld [rIE], a
	call Func_e8783
	ld a, $13
	ld [$cae2], a
	call Func_e8efc
	call Func_e8f16
.asm_e8e45
	call JoypadLowSensitivity
	call Func_e8eca
	jr c, .asm_e8e62
	ld a, [wOverworldMap]
	bit 7, a
	jr nz, .asm_e8e62
	call Func_e87a8
	call Func_e8f51
	call Func_e8f82
	call DelayFrame
	jr .asm_e8e45

.asm_e8e62
	xor a
	ld [wUnknownSerialFlag_d49a], a
	ld [wUnknownSerialFlag_d49b], a
	call Func_e8f09
	xor a
	ld [rIF], a
	pop af
	ld [rIE], a
	call Func_0f3d
	call Func_e8f3b
	ret

