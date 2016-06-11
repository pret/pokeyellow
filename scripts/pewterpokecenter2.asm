Func_f1d98:
	ld hl, PewterPokecenterText_f1d9f
	call PrintText
	ret

PewterPokecenterText_f1d9f:
	TX_FAR _PewterPokecenterText3
	db "@"

PewterJigglypuff:
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, .Text
	call PrintText
	call StopAllMusic
	ld c, 32
	call DelayFrames
	ld hl, JigglypuffSpinData
	ld de, wJigglypuffFacingDirections
	ld bc, JigglypuffSpinDataEnd - JigglypuffSpinData
	call CopyData
	ld a, [wSpriteStateData1 + 3 * $10 + 2]
	ld hl, wJigglypuffFacingDirections
.asm_f1dc9
	cp [hl]
	inc hl
	jr nz, .asm_f1dc9
	dec hl
	push hl
	ld c, BANK(Music_JigglypuffSong)
	ld a, MUSIC_JIGGLYPUFF_SONG
	call PlayMusic
	pop hl
.asm_f1dd7
	ld a, [hl]
	ld [wSpriteStateData1 + 3 * $10 + 2], a
	push hl
	ld hl, wJigglypuffFacingDirections
	ld de, wJigglypuffFacingDirections2
	ld bc, JigglypuffSpinDataEnd - JigglypuffSpinData
	call CopyData
	ld a, [wJigglypuffFacingDirections2]
	ld [wcd42], a
	pop hl
	ld c, 24
	call DelayFrames
	ld a, [wChannelSoundIDs]
	ld b, a
	ld a, [wChannelSoundIDs + 1]
	or b
	jr nz, .asm_f1dd7
	ld c, 48
	call DelayFrames
	call PlayDefaultMusic
	ld a, [wd472]
	bit 7, a
	ret z
	callab CheckPikachuFaintedOrStatused
	ret c
	call DisablePikachuFollowingPlayer
	ret

.Text
	TX_FAR _PewterJigglypuffText
	db "@"

JigglypuffSpinData:
	db $40 | SPRITE_FACING_DOWN
	db $40 | SPRITE_FACING_LEFT
	db $40 | SPRITE_FACING_UP
	db $40 | SPRITE_FACING_RIGHT
JigglypuffSpinDataEnd:
