_DayCareMText_5640f::
	text "I run a DAYCARE."
	line "Would you like me"
	cont "to raise one of"
	cont "your #MON?"
	done

_DayCareMText_56414::
	text "Which #MON"
	line "should I raise?"
	prompt

_DayCareMText_56419::
	text "Fine, I'll look"
	line "after @"
	TX_RAM wcd6d
	db $0
	cont "for a while."
	prompt

_DayCareMText_5641e::
	text "Come see me in"
	line "a while."
	done

_DayCareMText_56423::
	text "Your @"
	TX_RAM wcd6d
	db $0
	line "has grown a lot!"

	para "By level, it's"
	line "grown by @"

DayCareMText_8ac67::
	TX_NUM wTrainerEngageDistance,$1,$3
	text "!"

	para "Aren't I great?"
	prompt

_DayCareMText_56428::
	text "You owe me ¥@"
	TX_BCD wcd3f, $c2
	db $0
	line "for the return"
	cont "of this #MON."
	done

_DayCareMText_5642d::
	text $52, " got"
	line "@"
	TX_RAM W_DAYCAREMONNAME
	text " back!"
	done

_DayCareMText_56432::
	text "Back already?"
	line "Your @"
	TX_RAM wcd6d
	db $0
	cont "needs some more"
	cont "time with me."
	prompt

_DayCareMText_56437::
	text "All right then,"
	line "@@"

_DayCareMText_5643b::
	text "Come again."
	done

_DayCareMText_56440::
	text "You have no room"
	line "for this #MON!"
	done

_DayCareMText_56445::
	text "You only have one"
	line "#MON with you."
	done

_DayCareMText_5644a::
	text "I can't accept a"
	line "#MON that"
	cont "knows an HM move."
	done

_DayCareMText_5644f::
	text "Thank you! Here's"
	line "your #MON!"
	prompt

_DayCareMText_56454::
	text "Hey, you don't"
	line "have enough ¥!"
	done

