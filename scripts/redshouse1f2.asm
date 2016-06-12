Func_f1b73:
	ld a, [wd72e]
	bit 3, a
	jp nz, MomHealPokemon ; if player has received a Pokémon from Oak, heal team
	ld hl, MomWakeUpText
	call PrintText
	ret

MomWakeUpText:
	TX_FAR _MomWakeUpText
	db "@"

MomHealPokemon:
	ld hl, MomHealText1
	call PrintText
	call GBFadeOutToWhite
	call ReloadMapData
	predef HealParty
	ld a, MUSIC_PKMN_HEALED
	ld [wNewSoundID], a
	call PlaySound
.loop
	ld a, [wChannelSoundIDs]
	cp MUSIC_PKMN_HEALED
	jr z, .loop
	ld a, [wMapMusicSoundID]
	ld [wNewSoundID], a
	call PlaySound
	call GBFadeInFromWhite
	ld hl, MomHealText2
	call PrintText
	ret

MomHealText1:
	TX_FAR _MomHealText1
	db "@"
MomHealText2:
	TX_FAR _MomHealText2
	db "@"

Func_f1bc4:
	ld hl, TVWrongSideText
	ld a, [wPlayerFacingDirection]
	cp SPRITE_FACING_UP
	jp nz, .notUp
	ld hl, StandByMeText
.notUp
	call PrintText
	ret

StandByMeText:
	TX_FAR _StandByMeText
	db "@"

TVWrongSideText:
	TX_FAR _TVWrongSideText
	db "@"

