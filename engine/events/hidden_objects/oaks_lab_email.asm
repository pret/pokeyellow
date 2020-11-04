DisplayOakLabEmailText:
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	call EnableAutoTextBoxDrawing
	tx_pre OakLabEmailText
	ret

OakLabEmailText::
	text_far _OakLabEmailText
	text_end
