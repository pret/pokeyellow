Func_f1b73:
	ld a, [wd72e]
	bit 3, a
	jp nz, MomHealPokemon ; if player has received a Pokémon from Oak, heal team
	ld hl, MomWakeUpText
	call PrintText
	ret

MomWakeUpText: ; 48185 (12:4185)
	TX_FAR _MomWakeUpText
	db "@"

MomHealPokemon: ; 4818a (12:418a)
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

MomHealText1: ; 481bc (12:41bc)
	TX_FAR _MomHealText1
	db "@"
MomHealText2: ; 481c1 (12:41c1)
	TX_FAR _MomHealText2
	db "@"

Func_f1bc4:
	ld hl, TVWrongSideText
	ld a, [wSpriteStateData1 + 9]
	cp SPRITE_FACING_UP
	jp nz, .notUp
	ld hl, StandByMeText
.notUp
	call PrintText
	ret

StandByMeText: ; 481da (12:41da)
	TX_FAR _StandByMeText
	db "@"

TVWrongSideText: ; 481df (12:41df)
	TX_FAR _TVWrongSideText
	db "@"

