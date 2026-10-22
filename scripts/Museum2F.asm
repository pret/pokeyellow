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
	ld a, [wPikachuSpawnStateFlags]
	bit BIT_PIKACHU_SPAWN_STARTER, a
	jr nz, .pikachuIsFollowing
	ld hl, Museum2FHikerText1
	call PrintText
	jr .done

.pikachuIsFollowing
	ld a, [wPikachuHappiness]
	cp 101
	jr c, .pikachuIsUnhappy
	ld hl, Museum2FHikerText3
	call PrintText
	jr .done

.pikachuIsUnhappy
	ld hl, Museum2FHikerText2
	call PrintText
.done
	jp TextScriptEnd

Museum2FHikerText1:
	text_far _Museum2FHikerText1
	text_end

Museum2FHikerText2:
	text_far _Museum2FHikerText2
	text_end

Museum2FHikerText3:
	text_far _Museum2FHikerText3
	text_end

Museum2FSpaceShuttleSignText:
	text_far _Museum2FSpaceShuttleSignText
	text_end

Museum2FMoonStoneSignText:
	text_far _Museum2FMoonStoneSignText
	text_end
