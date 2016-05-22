DoClearSaveDialogue: ; DoClearSaveDialogue: ; 1c21e (7:421e)
	call ClearScreen
	call RunDefaultPaletteCommand
	call LoadFontTilePatterns
	call LoadTextBoxTilePatterns
	ld hl, ClearSaveDataText
	call PrintText
	ld a, B_BUTTON
	ld [wJoyIgnore], a
	coord hl, 14, 7
	lb bc, 8, 15
	ld a, NO_YES_MENU
	ld [wTwoOptionMenuID], a
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld a, 0
	ld [wJoyIgnore], a
	ld a, [wCurrentMenuItem]
	and a
	jp z, Init
	callba ClearSAV
	jp Init

ClearSaveDataText: ; 1c25f (7:425f)
	TX_FAR _ClearSaveDataText
	db "@"
