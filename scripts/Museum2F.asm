Museum2F_Script:
	call EnableAutoTextBoxDrawing
	ret

Museum2F_TextPointers:
	def_text_pointers
	dw_const Museum2FYoungsterText,        TEXT_MUSEUM2F_YOUNGSTER
	dw_const Museum2FGrampsText,           TEXT_MUSEUM2F_GRAMPS
	dw_const Museum2FScientistText,        TEXT_MUSEUM2F_SCIENTIST
	dw_const Museum2FBrunetteGirlText,     TEXT_MUSEUM2F_BRUNETTE_GIRL
	dw_const Museum2FHikerText,            TEXT_MUSEUM2F_HIKER
	dw_const Museum2FSpaceShuttleSignText, TEXT_MUSEUM2F_SPACE_SHUTTLE_SIGN
	dw_const Museum2FMoonStoneSignText,    TEXT_MUSEUM2F_MOON_STONE_SIGN

Museum2FYoungsterText:
	text_far _Museum2FYoungsterText
	text_end

Museum2FGrampsText:
	text_far _Museum2FGrampsText
	text_end

Museum2FScientistText:
	text_far _Museum2FScientistText
	text_end

Museum2FBrunetteGirlText:
	text_far _Museum2FBrunetteGirlText
	text_end

Museum2FHikerText:
	text_asm
	ld a, [wd471]
	bit 7, a
	jr nz, .asm_5c1f6
	ld hl, Museum2FText_5c20e
	call PrintText
	jr .asm_5c20b

.asm_5c1f6
	ld a, [wPikachuHappiness]
	cp 101
	jr c, .asm_5c205
	ld hl, Museum2FText_5c218
	call PrintText
	jr .asm_5c20b

.asm_5c205
	ld hl, Museum2FText_5c213
	call PrintText
.asm_5c20b
	jp TextScriptEnd

Museum2FText_5c20e:
	text_far _Museum2FHikerText
	text_end

Museum2FText_5c213:
	text_far _Museum2FPikachuText1
	text_end

Museum2FText_5c218:
	text_far _Museum2FPikachuText2
	text_end

Museum2FSpaceShuttleSignText:
	text_far _Museum2FSpaceShuttleSignText
	text_end

Museum2FMoonStoneSignText:
	text_far _Museum2FMoonStoneSignText
	text_end
