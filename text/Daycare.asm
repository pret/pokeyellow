_DayCareIntroText::
	text "I run a DAYCARE."
	line "Would you like me"
	cont "to raise one of"
	cont "your POKéMON?"
	done

_DayCareWhichMonText::
	text "Which POKéMON"
	line "should I raise?"
	prompt

_DayCareWillLookAfterMonText::
	text "Fine, I'll look"
	line "after @"
	text_ram wcd6d
	text_start
	cont "for a while."
	prompt

_DayCareComeSeeMeInAWhileText::
	text "Come see me in"
	line "a while."
	done

_DayCareMonHasGrownText::
	text "Your @"
	text_ram wcd6d
	text_start
	line "has grown a lot!"

	para "By level, it's"
	line "grown by @"
	text_decimal wDayCareNumLevelsGrown, 1, 3
	text "!"

	para "Aren't I great?"
	prompt

_DayCareOweMoneyText::
	text "You owe me ¥@"
	text_bcd wDayCareTotalCost, 2 | LEADING_ZEROES | LEFT_ALIGN
	text_start
	line "for the return"
	cont "of this POKéMON."
	done

_DayCareGotMonBackText::
	text "<PLAYER> got"
	line "@"
	text_ram wDayCareMonName
	text " back!"
	done

_DayCareMonNeedsMoreTimeText::
	text "Back already?"
	line "Your @"
	text_ram wcd6d
	text_start
	cont "needs some more"
	cont "time with me."
	prompt

_DayCareAllRightThenText::
	text "All right then,"
	line "@"
	text_end

_DayCareComeAgainText::
	text "Come again."
	done

_DayCareNoRoomForMonText::
	text "You have no room"
	line "for this POKéMON!"
	done

_DayCareOnlyHaveOneMonText::
	text "You only have one"
	line "POKéMON with you."
	done

_DayCareCantAcceptMonWithHMText::
	text "I can't accept a"
	line "POKéMON that"
	cont "knows an HM move."
	done

_DayCareHeresYourMonText::
	text "Thank you! Here's"
	line "your POKéMON!"
	prompt

_DayCareNotEnoughMoneyText::
	text "Hey, you don't"
	line "have enough ¥!"
	done
