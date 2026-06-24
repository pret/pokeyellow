BillsHousePrintBillPokemonText::
	ld hl, .ImNotAPokemonText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .answered_no
.use_machine
	ld hl, .UseSeparationSystemText
	call PrintText
	ld a, SCRIPT_BILLSHOUSE_SCRIPT2
	ld [wBillsHouseCurScript], a
	ret
.answered_no
	ld hl, .NoYouGottaHelpText
	call PrintText
	jr .use_machine

.ImNotAPokemonText:
	text_far _BillsHouseBillImNotAPokemonText
	text_end

.UseSeparationSystemText:
	text_far _BillsHouseBillUseSeparationSystemText
	text_end

.NoYouGottaHelpText:
	text_far _BillsHouseBillNoYouGottaHelpText
	text_end

BillsHousePrintBillSSTicketText::
	CheckEvent EVENT_GOT_SS_TICKET
	jr nz, .got_ss_ticket
	ld hl, .ThankYouText
	call PrintText
	lb bc, S_S_TICKET, 1
	call GiveItem
	jr nc, .bag_full
	ld hl, .SSTicketReceivedText
	call PrintText
	SetEvent EVENT_GOT_SS_TICKET
	ld a, TOGGLE_CERULEAN_GUARD_1
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ld a, TOGGLE_CERULEAN_GUARD_2
	ld [wToggleableObjectIndex], a
	predef HideObject
.got_ss_ticket
	ld hl, .WhyDontYouGoInsteadOfMeText
	call PrintText
	ret
.bag_full
	ld hl, .SSTicketNoRoomText
	call PrintText
	ret

.ThankYouText:
	text_far _BillsHouseBillThankYouText
	text_end

.SSTicketReceivedText:
	text_far _SSTicketReceivedText
	sound_get_key_item
	text_promptbutton
	text_end

.SSTicketNoRoomText:
	text_far _SSTicketNoRoomText
	text_end

.WhyDontYouGoInsteadOfMeText:
	text_far _BillsHouseBillWhyDontYouGoInsteadOfMeText
	text_end

BillsHousePrintBillCheckOutMyRarePokemonText::
	ld hl, .text
	call PrintText
	ret

.text
	text_far _BillsHouseBillCheckOutMyRarePokemonText
	text_end

BillsHouse_CheckPikachuEmotion::
	ld a, [wCurMap]
	cp BILLS_HOUSE
	jr nz, .noEmotion
	call CheckPikachuFollowingPlayer
	jr z, .noEmotion
	ld a, [wBillsHouseCurScript]
	cp SCRIPT_BILLSHOUSE_SCRIPT5
	ldpikaemotion e, PikachuEmotion27
	ret z
	cp SCRIPT_BILLSHOUSE_SCRIPT0
	ldpikaemotion e, PikachuEmotion23
	ret z
	CheckEventHL EVENT_MET_BILL_2
	ldpikaemotion e, PikachuEmotion32
	ret z
	ldpikaemotion e, PikachuEmotion31
	ret

.noEmotion
	ld e, $ff
	ret

BillsHousePikachuConfused::
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	xor a
	ld [wPlayerMovingDirection], a
	call UpdateSprites
	call UpdateSprites
	ld hl, PikachuMovement_Confused
	call ApplyPikachuMovementData
	ld a, $f ; pikachu
	ld [wEmotionBubbleSpriteIndex], a
	ld a, QUESTION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	call DisablePikachuFollowingPlayer
	callfar InitializePikachuTextID
	ret

PikachuMovement_Confused:
	db PIKAMOVEMENT_DELAY
	db PIKAMOVEMENT_STEP_RIGHT
	db PIKAMOVEMENT_STEP_RIGHT
	db PIKAMOVEMENT_STEP_RIGHT
	db PIKAMOVEMENT_STEP_UP
	db PIKAMOVEMENT_END

BillsHousePikachuWatchPlayer::
	ld hl, PikachuMovement_WatchPlayer1
	ld b, SPRITE_FACING_UP
	call TryApplyPikachuMovementData
	ld hl, PikachuMovement_WatchPlayer2
	ld b, SPRITE_FACING_RIGHT
	call TryApplyPikachuMovementData
	ret

PikachuMovement_WatchPlayer1:
	db PIKAMOVEMENT_DELAY
	db PIKAMOVEMENT_STEP_LEFT
	db PIKAMOVEMENT_STEP_DOWN
	db PIKAMOVEMENT_LOOK_RIGHT
	db PIKAMOVEMENT_END

PikachuMovement_WatchPlayer2:
	db PIKAMOVEMENT_DELAY
	db PIKAMOVEMENT_STEP_UP
	db PIKAMOVEMENT_STEP_LEFT
	db PIKAMOVEMENT_STEP_LEFT
	db PIKAMOVEMENT_STEP_DOWN
	db PIKAMOVEMENT_LOOK_RIGHT
	db PIKAMOVEMENT_END
