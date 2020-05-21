Func_f1b27:
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
	TX_FAR _Route22RivalBeforeBattleText1
	db "@"

Route22RivalAfterBattleText1:
	TX_FAR _Route22RivalAfterBattleText1
	db "@"

Func_f1b47:
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
	TX_FAR _Route22RivalBeforeBattleText2
	db "@"

Route22RivalAfterBattleText2:
	TX_FAR _Route22RivalAfterBattleText2
	db "@"

Func_f1b67:
	ld hl, Route22FrontGateText_3c
	call PrintText
	ret

Route22FrontGateText_3c:
	TX_FAR _Route22FrontGateText
	db "@"
