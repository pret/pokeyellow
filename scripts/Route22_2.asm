Route22PrintRival1Text::
	CheckEvent EVENT_BEAT_ROUTE22_RIVAL_1ST_BATTLE
	jr z, .before_battle
	ld hl, Route22RivalAfterBattleText1
	call PrintText
	jr .text_script_end
.before_battle
	ld hl, Route22RivalBeforeBattleText1
	call PrintText
.text_script_end
	ret

Route22RivalBeforeBattleText1:
	text_far _Route22RivalBeforeBattleText1
	text_end

Route22RivalAfterBattleText1:
	text_far _Route22RivalAfterBattleText1
	text_end

Route22PrintRival2Text::
	CheckEvent EVENT_BEAT_ROUTE22_RIVAL_2ND_BATTLE
	jr z, .before_battle
	ld hl, Route22RivalAfterBattleText2
	call PrintText
	jr .text_script_end
.before_battle
	ld hl, Route22RivalBeforeBattleText2
	call PrintText
.text_script_end
	ret

Route22RivalBeforeBattleText2:
	text_far _Route22RivalBeforeBattleText2
	text_end

Route22RivalAfterBattleText2:
	text_far _Route22RivalAfterBattleText2
	text_end

Route22PrintPokemonLeagueSignText::
	ld hl, .text
	call PrintText
	ret

.text
	text_far _Route22PokemonLeagueSignText
	text_end
