FanClubPicture1:
	ld a, RAPIDASH
	ld [wCurPartySpecies], a
	call DisplayMonFrontSpriteInBox
	call EnableAutoTextBoxDrawing
	tx_pre FanClubPicture1Text
	ret

FanClubPicture1Text::
	text_far _FanClubPicture1Text
	text_end

FanClubPicture2:
	ld a, FEAROW
	ld [wCurPartySpecies], a
	call DisplayMonFrontSpriteInBox
	call EnableAutoTextBoxDrawing
	tx_pre FanClubPicture2Text
	ret

FanClubPicture2Text::
	text_far _FanClubPicture2Text
	text_end
