Func_f1b27::
	CheckEvent EVENT_BEAT_ROUTE22_RIVAL_1ST_BATTLE
	jr z, .asm_5118b
	ld hl, Route22RivalAfterBattleText1
	call PrintText
	jr .asm_51191

.asm_5118b
	ld hl, Route22RivalBeforeBattleText1
	call PrintText
.asm_51191
	ret

Route22RivalBeforeBattleText1:
	text_far _Route22RivalBeforeBattleText1
	text_end

Route22RivalAfterBattleText1:
	text_far _Route22RivalAfterBattleText1
	text_end

Func_f1b47::
	CheckEvent EVENT_BEAT_ROUTE22_RIVAL_2ND_BATTLE
	jr z, .asm_511a4
	ld hl, Route22RivalAfterBattleText2
	call PrintText
	jr .asm_511aa

.asm_511a4
	ld hl, Route22RivalBeforeBattleText2
	call PrintText
.asm_511aa
	ret

Route22RivalBeforeBattleText2:
	text_far _Route22RivalBeforeBattleText2
	text_end

Route22RivalAfterBattleText2:
	text_far _Route22RivalAfterBattleText2
	text_end

Func_f1b67::
	ld hl, Route22FrontGateText_3c
	call PrintText
	ret

Route22FrontGateText_3c:
	text_far _Route22FrontGateText
	text_end
