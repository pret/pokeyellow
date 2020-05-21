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
	ld hl, JigglypuffFacingDirections
	ld de, wJigglypuffFacingDirections
	ld bc, JigglypuffFacingDirectionsEnd - JigglypuffFacingDirections
	call CopyData

	ld a, [wSprite03StateData1ImageIndex]
	ld hl, wJigglypuffFacingDirections
.findMatchingFacingDirectionLoop
	cp [hl]
	inc hl
	jr nz, .findMatchingFacingDirectionLoop
	dec hl
	push hl
	ld c, BANK(Music_JigglypuffSong)
	ld a, MUSIC_JIGGLYPUFF_SONG
	call PlayMusic
	pop hl
.loop
	ld a, [hl]
	ld [wSprite03StateData1ImageIndex], a

; rotate the array
	push hl
	ld hl, wJigglypuffFacingDirections
	ld de, wJigglypuffFacingDirections - 1
	ld bc, JigglypuffFacingDirectionsEnd - JigglypuffFacingDirections
	call CopyData
	ld a, [wJigglypuffFacingDirections - 1]
	ld [wJigglypuffFacingDirections + 3], a
	pop hl

	ld c, 24
	call DelayFrames

	ld a, [wChannelSoundIDs]
	ld b, a
	ld a, [wChannelSoundIDs + Ch2]
	or b
	jr nz, .loop

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

JigglypuffFacingDirections:
	db $40 | SPRITE_FACING_DOWN
	db $40 | SPRITE_FACING_LEFT
	db $40 | SPRITE_FACING_UP
	db $40 | SPRITE_FACING_RIGHT
JigglypuffFacingDirectionsEnd:
