PrintNotebookText: ; 528f6 (14:68f6)
	call EnableAutoTextBoxDrawing
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, [wHiddenObjectFunctionArgument]
	jp PrintPredefTextID

TMNotebook: ; 52904 (14:6904)
	TX_FAR TMNotebookText
	db $0d
	db "@"

ViridianSchoolNotebook: ; 5290a (14:690a)
	TX_ASM
	ld hl, ViridianSchoolNotebookText1
	call PrintText
	call TurnPageSchoolNotebook
	jr nz, .doneReading
	ld hl, ViridianSchoolNotebookText2
	call PrintText
	call TurnPageSchoolNotebook
	jr nz, .doneReading
	ld hl, ViridianSchoolNotebookText3
	call PrintText
	call TurnPageSchoolNotebook
	jr nz, .doneReading
	ld hl, ViridianSchoolNotebookText4
	call PrintText
	ld hl, ViridianSchoolNotebookText5
	call PrintText
.doneReading
	jp TextScriptEnd

TurnPageSchoolNotebook: ; 529db (14:69db)
	ld hl, TurnPageText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ret

TurnPageText: ; 52949 (14:6949)
	TX_FAR _TurnPageText
	db "@"

ViridianSchoolNotebookText5: ; 5294e (14:694e)
	TX_FAR _ViridianSchoolNotebookText5
	db $0d
	db "@"

ViridianSchoolNotebookText1: ; 52954 (14:6954)
	TX_FAR _ViridianSchoolNotebookText1
	db "@"

ViridianSchoolNotebookText2: ; 52959 (14:6959)
	TX_FAR _ViridianSchoolNotebookText2
	db "@"

ViridianSchoolNotebookText3: ; 5295e (14:695e)
	TX_FAR _ViridianSchoolNotebookText3
	db "@"

ViridianSchoolNotebookText4: ; 52963 (14:6963)
	TX_FAR _ViridianSchoolNotebookText4
	db "@"

PrintFightingDojoText2: ; 52968 (14:6968)
	call EnableAutoTextBoxDrawing
	tx_pre_jump EnemiesOnEverySideText

EnemiesOnEverySideText: ; 52970 (14:6970)
	TX_FAR _EnemiesOnEverySideText
	db "@"

PrintFightingDojoText3: ; 52975 (14:6975)
	call EnableAutoTextBoxDrawing
	tx_pre_jump WhatGoesAroundComesAroundText

WhatGoesAroundComesAroundText: ; 5297d (14:697d)
	TX_FAR _WhatGoesAroundComesAroundText
	db "@"

PrintFightingDojoText: ; 52982 (14:6982)
	call EnableAutoTextBoxDrawing
	tx_pre_jump FightingDojoText

FightingDojoText: ; 5298a (14:698a)
	TX_FAR _FightingDojoText
	db "@"

PrintIndigoPlateauHQText: ; 5298f (14:698f)
	ld a, [wSpriteStateData1 + 9]
	cp SPRITE_FACING_UP
	ret nz
	call EnableAutoTextBoxDrawing
	tx_pre_jump IndigoPlateauHQText

IndigoPlateauHQText: ; 5299d (14:699d)
	TX_FAR _IndigoPlateauHQText
	db "@"
