CeladonMansion3F_Script:
	call EnableAutoTextBoxDrawing
	ret

CeladonMansion3_PokedexCount:
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	ret

CeladonMansion3F_TextPointers:
	dw ProgrammerText
	dw GraphicArtistText
	dw WriterText
	dw DirectorText
	dw GameFreakPCText1
	dw GameFreakPCText2
	dw GameFreakPCText3
	dw GameFreakSignText

ProgrammerText:
	text_asm
	call CeladonMansion3_PokedexCount
	cp NUM_POKEMON - 1 ; discount Mew
	ld hl, CeladonMansion3Text_486f5
	jr nc, .print
	ld hl, CeladonMansion3Text_486f0
.print
	call PrintText
	jp TextScriptEnd

CeladonMansion3Text_486f0:
	text_far _ProgrammerText
	text_end

CeladonMansion3Text_486f5:
	text_far _ProgrammerText2
	text_end

GraphicArtistText:
	text_asm
	call CeladonMansion3_PokedexCount
	cp NUM_POKEMON - 1 ; discount Mew
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
	callfar PrintDiploma
	ld hl, wd730
	res 6, [hl]
	call GBPalWhiteOutWithDelay3
	call ReloadTilesetTilePatterns
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadScreenTilesFromBuffer2
	call Delay3
	call GBPalNormal
	ld hl, CeladonMansion3Text_4876b
	ldh a, [hCanceledPrinting]
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
	text_far _GraphicArtistText
	text_end

CeladonMansion3Text_4875c:
	text_far _GraphicArtistText2
	text_end

CeladonMansion3Text_48761:
	text_far _GraphicArtistText3
	text_end

CeladonMansion3Text_48766:
	text_far _GraphicArtistText4
	text_end

CeladonMansion3Text_4876b:
	text_far _GraphicArtistText5
	text_end

WriterText:
	text_asm
	call CeladonMansion3_PokedexCount
	cp NUM_POKEMON - 1 ; discount Mew
	ld hl, CeladonMansion3Text_48789
	jr nc, .print
	ld hl, CeladonMansion3Text_48784
.print
	call PrintText
	jp TextScriptEnd

CeladonMansion3Text_48784:
	text_far _WriterText
	text_end

CeladonMansion3Text_48789:
	text_far _WriterText2
	text_end

DirectorText:
	text_asm
	call CeladonMansion3_PokedexCount
	cp NUM_POKEMON - 1 ; discount Mew
	jr nc, .completed_dex
	ld hl, .GameDesignerText
	jr .done
.completed_dex
	ld hl, .CompletedDexText
	call PrintText
	call Delay3
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, .UnlockedDiplomaPrinting
.done
	call PrintText
	jp TextScriptEnd

.GameDesignerText:
	text_far _GameDesignerText
	text_end

.CompletedDexText:
	text_far _CompletedDexText
	text_promptbutton
	text_asm
	callfar DisplayDiploma
	ld a, TRUE
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	jp TextScriptEnd

.UnlockedDiplomaPrinting
	text_far _CompletedDexText2
	text_end

GameFreakPCText1:
	text_asm
	farcall Func_f1ef3
	jp TextScriptEnd

GameFreakPCText2:
	text_asm
	farcall Func_f1eff
	jp TextScriptEnd

GameFreakPCText3:
	text_asm
	farcall Func_f1f0b
	jp TextScriptEnd

GameFreakSignText:
	text_asm
	farcall Func_f1f17
	jp TextScriptEnd
