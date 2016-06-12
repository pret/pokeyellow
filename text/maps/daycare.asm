_DayCareIntroText::
	text "I run a DAYCARE."
	line "Would you like me"
	cont "to raise one of"
	cont "your #MON?"
	done

_DayCareWhichMonText::
	text "Which #MON"
	line "should I raise?"
	prompt

_DayCareWillLookAfterMonText::
	text "Fine, I'll look"
	line "after @"
	TX_RAM wcd6d
	db $0
	cont "for a while."
	prompt
_DayCareComeSeeMeInAWhileText::
	text "Come see me in"
	line "a while."
	done
_DayCareMonHasGrownText::
	text "Your @"
	TX_RAM wcd6d
	db $0
	line "has grown a lot!"
	para "By level, it's"
	line "grown by @"
	TX_NUM wDayCareNumLevelsGrown,$1,$3
	text "!"

	para "Aren't I great?"
	prompt
_DayCareOweMoneyText::
	text "You owe me ¥@"
	TX_BCD wDayCareTotalCost, $c2
	db $0
	line "for the return"
	cont "of this #MON."
	done

_DayCareGotMonBackText::
	text $52, " got"
	line "@"
	TX_RAM wDayCareMonName
	text " back!"
	done

_DayCareMonNeedsMoreTimeText::
	text "Back already?"
	line "Your @"
	TX_RAM wcd6d
	db $0
	cont "needs some more"
	cont "time with me."
	prompt

_DayCareAllRightThenText::
	text "All right then,"
	line "@@"

_DayCareComeAgainText::
	text "Come again."
	done

_DayCareNoRoomForMonText::
	text "You have no room"
	line "for this #MON!"
	done

_DayCareOnlyHaveOneMonText::
	text "You only have one"
	line "#MON with you."
	done

_DayCareCantAcceptMonWithHMText::
	text "I can't accept a"
	line "#MON that"
	cont "knows an HM move."
	done

_DayCareHeresYourMonText::
	text "Thank you! Here's"
	line "your #MON!"
	prompt

_DayCareNotEnoughMoneyText::
	text "Hey, you don't"
	line "have enough ¥!"
	done
