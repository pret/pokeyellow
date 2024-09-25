Route15GateLeftBinoculars:
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	call EnableAutoTextBoxDrawing
	tx_pre Route15UpstairsBinocularsText
	ld a, ARTICUNO
	ld [wCurPartySpecies], a
	call PlayCry
	call DisplayMonFrontSpriteInBox
	xor a
	ldh [hAutoBGTransferEnabled], a
	ret

Route15UpstairsBinocularsText::
	text_far _Route15UpstairsBinocularsText
	text_end
