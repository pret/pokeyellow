CeladonMansion3Script:
	call EnableAutoTextBoxDrawing
	ret

CeladonMansion3_PokedexCount:
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	ret

CeladonMansion3TextPointers:
	dw ProgrammerText
	dw GraphicArtistText
	dw WriterText
	dw DirectorText
	dw GameFreakPCText1
	dw GameFreakPCText2
	dw GameFreakPCText3
	dw GameFreakSignText

ProgrammerText:
	TX_ASM
	call CeladonMansion3_PokedexCount
	cp 150
	ld hl, CeladonMansion3Text_486f5
	jr nc, .print
	ld hl, CeladonMansion3Text_486f0
.print
	call PrintText
	jp TextScriptEnd

CeladonMansion3Text_486f0:
	TX_FAR _ProgrammerText
	db "@"

CeladonMansion3Text_486f5:
	TX_FAR _ProgrammerText2
	db "@"

GraphicArtistText:
	TX_ASM
	call CeladonMansion3_PokedexCount
	cp 150
	jr nc, .completed
	ld hl, CeladonMansion3Text_48757
	jr .print

.completed
	ld hl, CeladonMansion3Text_4875c
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .declined_print
	call SaveScreenTilesToBuffer2
	xor a
	ld [wUpdateSpritesEnabled], a
	ld hl, wd730
	set 6, [hl]
	callab PrintDiploma
	ld hl, wd730
	res 6, [hl]
	call GBPalWhiteOutWithDelay3
	call ReloadTilesetTilePatterns
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadScreenTilesFromBuffer2
	call Delay3
	call GBPalNormal
	ld hl, CeladonMansion3Text_4876b
	ld a, [$ffdb]
	and a
	jr nz, .print
	ld hl, CeladonMansion3Text_48766
	jr .print

.declined_print
	ld hl, CeladonMansion3Text_48761
.print
	call PrintText
	jp TextScriptEnd

CeladonMansion3Text_48757:
	TX_FAR _GraphicArtistText
	db "@"

CeladonMansion3Text_4875c:
	TX_FAR _GraphicArtistText2
	db "@"

CeladonMansion3Text_48761:
	TX_FAR _GraphicArtistText3
	db "@"

CeladonMansion3Text_48766:
	TX_FAR _GraphicArtistText4
	db "@"

CeladonMansion3Text_4876b:
	TX_FAR _GraphicArtistText5
	db "@"

WriterText:
	TX_ASM
	call CeladonMansion3_PokedexCount
	cp 150
	ld hl, CeladonMansion3Text_48789
	jr nc, .print
	ld hl, CeladonMansion3Text_48784
.print
	call PrintText
	jp TextScriptEnd

CeladonMansion3Text_48784:
	TX_FAR _WriterText
	db "@"

CeladonMansion3Text_48789:
	TX_FAR _WriterText2
	db "@"

DirectorText:
	TX_ASM
	call CeladonMansion3_PokedexCount
	; check pokédex
	cp 150
	jr nc, .CompletedDex
	ld hl, .GameDesigner
	jr .done
.CompletedDex
	ld hl, .CompletedDexText
	call PrintText
	call Delay3
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, .UnlockedDiplomaPrinting
.done
	call PrintText
	jp TextScriptEnd

.GameDesigner
	TX_FAR _GameDesignerText
	db "@"

.CompletedDexText
	TX_FAR _CompletedDexText
	TX_BUTTON_SOUND
	TX_ASM
	callab DisplayDiploma
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	jp TextScriptEnd

.UnlockedDiplomaPrinting
	TX_FAR _CompletedDexText2
	db "@"

GameFreakPCText1:
	TX_ASM
	callba Func_f1ef3
	jp TextScriptEnd

GameFreakPCText2:
	TX_ASM
	callba Func_f1eff
	jp TextScriptEnd

GameFreakPCText3:
	TX_ASM
	callba Func_f1f0b
	jp TextScriptEnd

GameFreakSignText:
	TX_ASM
	callba Func_f1f17
	jp TextScriptEnd
