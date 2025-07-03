ViridianCityPrintYoungster1Text::
	ld hl, .text
	call PrintText
	ret

.text
	text_far _ViridianCityYoungster1Text
	text_end

ViridianCityPrintGambler1Text::
	ld hl, .GymLeaderReturnedText
	ld a, [wObtainedBadges]
	cp ~(1 << BIT_EARTHBADGE)
	jr z, .print_text
	CheckEvent EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
	jr nz, .print_text
	ld hl, .GymAlwaysClosedText
.print_text
	call PrintText
	ret

.GymAlwaysClosedText:
	text_far _ViridianCityGambler1GymAlwaysClosedText
	text_end

.GymLeaderReturnedText:
	text_far _ViridianCityGambler1GymLeaderReturnedText
	text_end

ViridianCityPrintYoungster2Text::
	ld hl, .YouWantToKnowAboutText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ld hl, .OkThenText
	jr nz, .no
	ld hl, .CaterpieAndWeedleDescriptionText
.no
	call PrintText
	ret

.YouWantToKnowAboutText:
	text_far _ViridianCityYoungster2YouWantToKnowAboutText
	text_end

.OkThenText:
	text_far ViridianCityYoungster2OkThenText
	text_end

.CaterpieAndWeedleDescriptionText:
	text_far ViridianCityYoungster2CaterpieAndWeedleDescriptionText
	text_end

ViridianCityPrintGirlText::
	ld hl, .WhenIGoShopText
	CheckEvent EVENT_GOT_POKEDEX
	jr nz, .got_pokedex
	ld hl, .HasntHadHisCoffeeYetText
.got_pokedex
	call PrintText
	ret

.HasntHadHisCoffeeYetText:
	text_far _ViridianCityGirlHasntHadHisCoffeeYetText
	text_end

.WhenIGoShopText:
	text_far _ViridianCityGirlWhenIGoShopText
	text_end

ViridianCityPrintOldManSleepyText::
	ld hl, .PrivatePropertyText
	call PrintText
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	ld a, SCRIPT_VIRIDIANCITY_PLAYER_MOVING_DOWN
	ld [wViridianCityCurScript], a
	ret

.PrivatePropertyText:
	text_far _ViridianCityOldManSleepyPrivatePropertyText
	text_end

ViridianCityPrintFisherText::
	CheckEvent EVENT_GOT_TM42
	jr nz, .got_item
	ld hl, .YouCanHaveThisText
	call PrintText
	lb bc, TM_DREAM_EATER, 1
	call GiveItem
	jr nc, .bag_full
	ld hl, .ReceivedTM42Text
	call PrintText
	SetEvent EVENT_GOT_TM42
	ret
.bag_full
	ld hl, .TM42NoRoomText
	call PrintText
	ret
.got_item
	ld hl, .TM42ExplanationText
	call PrintText
	ret

.YouCanHaveThisText:
	text_far ViridianCityFisherYouCanHaveThisText
	text_end

.ReceivedTM42Text:
	text_far _ViridianCityFisherReceivedTM42Text
	sound_get_item_2
	text_end

.TM42ExplanationText:
	text_far _ViridianCityFisherTM42ExplanationText
	text_end

.TM42NoRoomText:
	text_far _ViridianCityFisherTM42NoRoomText
	text_end

ViridianCityPrintOldManText::
	ld hl, .WantMeToShowYouAgainText
	call PrintText
	ld c, 2
	call DelayFrames
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .refused
	ld hl, .WatchCloselyText
	call PrintText
	ld a, SCRIPT_VIRIDIANCITY_OLD_MAN_START_CATCH_TRAINING
	ld [wViridianCityCurScript], a
	jr .done
.refused
	ld hl, .NotGoodEnoughForYouText
	call PrintText
.done
	ret

.WantMeToShowYouAgainText:
	text_far _ViridianCityOldManWantMeToShowYouAgainText
	text_end

.WatchCloselyText:
	text_far _ViridianCityOldManWatchCloselyText
	text_end

.NotGoodEnoughForYouText:
	text_far _ViridianCityOldManNotGoodEnoughForYouText
	text_end

ViridianCityPrintSignText::
	ld hl, .text
	call PrintText
	ret

.text
	text_far _ViridianCitySignText
	text_end

ViridianCityPrintTrainerTips1Text::
	ld hl, .text
	call PrintText
	ret

.text
	text_far _ViridianCityTrainerTips1Text
	text_end

ViridianCityPrintTrainerTips2Text::
	ld hl, .text
	call PrintText
	ret

.text
	text_far _ViridianCityTrainerTips2Text
	text_end

ViridianCityPrintGymSignText::
	ld hl, .text
	call PrintText
	ret

.text
	text_far _ViridianCityGymSignText
	text_end

ViridianCityPrintGymLockedText::
	ld hl, .text
	call PrintText
	ret

.text
	text_far _ViridianCityGymLockedText
	text_end


ViridianCityMovePikachu::
	ld hl, ViridianCityPikachuMovementData
	ld b, SPRITE_FACING_RIGHT
	call TryApplyPikachuMovementData
	ret

ViridianCityPikachuMovementData:
	db $00
	db $1d
	db $1f
	db $38
	db $3f
