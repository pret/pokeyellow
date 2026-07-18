_EnemyAppearedText::
	text_ram wEnemyMonNick
	text_start
	line "appeared!"
	prompt

_TrainerWantsToFightText::
	text_ram wTrainerName
	text " wants"
	line "to fight!"
	prompt

_UnveiledGhostText::
	text "SILPH SCOPE"
	line "unveiled the"
	cont "GHOST's identity!"
	prompt

_GhostCantBeIDdText::
	text "Darn! The GHOST"
	line "can't be ID'd!"
	prompt

_GoText::
	text "Go! @"
	text_end

_DoItText::
	text "Do it! @"
	text_end

_GetmText::
	text "Get'm! @"
	text_end

_EnemysWeakText::
	text "The enemy's weak!"
	line "Get'm! @"
	text_end

_PlayerMon1Text::
	text_ram wBattleMonNick
	text "!"
	done

_PlayerMon2Text::
	text_ram wBattleMonNick
	text " @"
	text_end

_EnoughText::
	text "enough!@"
	text_end

_OKExclamationText::
	text "OK!@"
	text_end

_GoodText::
	text "good!@"
	text_end

_ComeBackText::
	text_start
	line "Come back!"
	done

; money related
_PickUpPayDayMoneyText::
	text "<PLAYER> picked up"
	line "¥@"
	text_bcd wTotalPayDayMoney, 3 | LEADING_ZEROES | LEFT_ALIGN
	text "!"
	prompt

_ClearSaveDataText::
	text "Clear all saved"
	line "data?"
	done

_WhichFloorText::
	text "Which floor do"
	line "you want? "
	done

_SleepingPikachuText1::
	text "There isn't any"
	line "response..."
	prompt

_PartyMenuNormalText::
	text "Choose a #MON."
	done

_PartyMenuItemUseText::
	text "Use item on which"
	line "#MON?"
	done

_PartyMenuBattleText::
	text "Bring out which"
	line "#MON?"
	done

_PartyMenuUseTMText::
	text "Teach to which"
	line "#MON?"
	done

_PartyMenuSwapMonText::
	text "Move #MON"
	line "where?"
	done

_PotionText::
	text_ram wNameBuffer
	text_start
	line "recovered by @"
	text_decimal wHPBarHPDifference, 2, 3
	text "!"
	done

_AntidoteText::
	text_ram wNameBuffer
	text " was"
	line "cured of poison!"
	done

_ParlyzHealText::
	text_ram wNameBuffer
	text "'s"
	line "rid of paralysis!"
	done

_BurnHealText::
	text_ram wNameBuffer
	text "'s"
	line "burn was healed!"
	done

_IceHealText::
	text_ram wNameBuffer
	text " was"
	line "defrosted!"
	done

_AwakeningText::
	text_ram wNameBuffer
	text_start
	line "woke up!"
	done

_FullHealText::
	text_ram wNameBuffer
	text "'s"
	line "health returned!"
	done

_ReviveText::
	text_ram wNameBuffer
	text_start
	line "is revitalized!"
	done

_RareCandyText::
	text_ram wNameBuffer
	text " grew"
	line "to level @"
	text_decimal wCurEnemyLevel, 1, 3
	text "!@"
	text_end

_TurnedOnPC1Text::
	text "<PLAYER> turned on"
	line "the PC."
	prompt

_AccessedBillsPCText::
	text "Accessed BILL's"
	line "PC."

	para "Accessed #MON"
	line "Storage System."
	prompt

_AccessedSomeonesPCText::
	text "Accessed someone's"
	line "PC."

	para "Accessed #MON"
	line "Storage System."
	prompt

_AccessedMyPCText::
	text "Accessed my PC."

	para "Accessed Item"
	line "Storage System."
	prompt

_TurnedOnPC2Text::
	text "<PLAYER> turned on"
	line "the PC."
	prompt

_WhatDoYouWantText::
	text "What do you want"
	line "to do?"
	done

_WhatToDepositText::
	text "What do you want"
	line "to deposit?"
	done

_DepositHowManyText::
	text "How many?"
	done

_ItemWasStoredText::
	text_ram wNameBuffer
	text " was"
	line "stored via PC."
	prompt

_NothingToDepositText::
	text "You have nothing"
	line "to deposit."
	prompt

_NoRoomToStoreText::
	text "No room left to"
	line "store items."
	prompt

_WhatToWithdrawText::
	text "What do you want"
	line "to withdraw?"
	done

_WithdrawHowManyText::
	text "How many?"
	done

_WithdrewItemText::
	text "Withdrew"
	line "@"
	text_ram wNameBuffer
	text "."
	prompt

_NothingStoredText::
	text "There is nothing"
	line "stored."
	prompt

_CantCarryMoreText::
	text "You can't carry"
	line "any more items."
	prompt

_WhatToTossText::
	text "What do you want"
	line "to toss away?"
	done

_TossHowManyText::
	text "How many?"
	done

_AccessedHoFPCText::
	text "Accessed #MON"
	line "LEAGUE's site."

	para "Accessed the HALL"
	line "OF FAME List."
	prompt

_SleepingPikachuText2::
	text "There isn't any"
	line "response..."
	prompt

_SwitchOnText::
	text "Switch on!"
	prompt

_WhatText::
	text "What?"
	done

_DepositWhichMonText::
	text "Deposit which"
	line "#MON?"
	done

_MonWasStoredText::
	text_ram wStringBuffer
	text " was"
	line "stored in Box @"
	text_ram wBoxNumString
	text "."
	prompt

_CantDepositLastMonText::
	text "You can't deposit"
	line "the last #MON!"
	prompt

_BoxFullText::
	text "Oops! This Box is"
	line "full of #MON."
	prompt

_MonIsTakenOutText::
	text_ram wStringBuffer
	text " is"
	line "taken out."
	cont "Got @"
	text_ram wStringBuffer
	text "."
	prompt

_NoMonText::
	text "What? There are"
	line "no #MON here!"
	prompt

_CantTakeMonText::
	text "You can't take"
	line "any more #MON."

	para "Deposit #MON"
	line "first."
	prompt

_PikachuUnhappyText::
	text_ram wNameBuffer
	text " looks"
	line "unhappy about it!"
	prompt

_ReleaseWhichMonText::
	text "Release which"
	line "#MON?"
	done

_OnceReleasedText::
	text "Once released,"
	line "@"
	text_ram wStringBuffer
	text " is"
	cont "gone forever. OK?"
	done

_MonWasReleasedText::
	text_ram wStringBuffer
	text " was"
	line "released outside."
	cont "Bye @"
	text_ram wStringBuffer
	text "!"
	prompt

_RequireCoinCaseText::
	text "A COIN CASE is"
	line "required!@"
	text_end

_ExchangeCoinsForPrizesText::
	text "We exchange your"
	line "coins for prizes."
	prompt

_WhichPrizeText::
	text "Which prize do"
	line "you want?"
	done

_HereYouGoText::
	text "Here you go!@"
	text_end

_SoYouWantPrizeText::
	text "So, you want"
	line "@"
	text_ram wNameBuffer
	text "?"
	done

_SorryNeedMoreCoinsText::
	text "Sorry, you need"
	line "more coins.@"
	text_end

_OopsYouDontHaveEnoughRoomText::
	text "Oops! You don't"
	line "have enough room.@"
	text_end

_OhFineThenText::
	text "Oh, fine then.@"
	text_end

_GetDexRatedText::
	text "Want to get your"
	line "#DEX rated?"
	done

_ClosedOaksPCText::
	text "Closed link to"
	line "PROF.OAK's PC.@"
	text_end

_AccessedOaksPCText::
	text "Accessed PROF."
	line "OAK's PC."

	para "Accessed #DEX"
	line "Rating System."
	prompt

_ExpressionText::
	text "This expression is"
	line "No. @"
	text_decimal wExpressionNumber, 1, 2
	text "."
	prompt

_NotEnoughMemoryText::
	text "Not enough Yellow"
	line "Version memory."
	done

_OakSpeechText1::
	text "Hello there!"
	line "Welcome to the"
	cont "world of #MON!"

	para "My name is OAK!"
	line "People call me"
	cont "the #MON PROF!"
	prompt

_OakSpeechText2A::
	text "This world is"
	line "inhabited by"
	cont "creatures called"
	cont "#MON!@"
	text_end

_OakSpeechText2B::
	text_start

	para "For some people,"
	line "#MON are"
	cont "pets. Others use"
	cont "them for fights."

	para "Myself..."

	para "I study #MON"
	line "as a profession."
	prompt

_IntroducePlayerText::
	text "First, what is"
	line "your name?"
	prompt

_IntroduceRivalText::
	text "This is my grand-"
	line "son. He's been"
	cont "your rival since"
	cont "you were a baby."

	para "...Erm, what is"
	line "his name again?"
	prompt

_OakSpeechText3::
	text "<PLAYER>!"

	para "Your very own"
	line "#MON legend is"
	cont "about to unfold!"

	para "A world of dreams"
	line "and adventures"
	cont "with #MON"
	cont "awaits! Let's go!"
	done

_DoYouWantToNicknameText::
	text "Do you want to"
	line "give a nickname"
	cont "to @"
	text_ram wNameBuffer
	text "?"
	done

_YourNameIsText::
	text "Right! So your"
	line "name is <PLAYER>!"
	prompt

_HisNameIsText::
	text "That's right! I"
	line "remember now! His"
	cont "name is <RIVAL>!"
	prompt

_WillBeTradedText::
	text_ram wNameOfPlayerMonToBeTraded
	text " and"
	line "@"
	text_ram wNameBuffer
	text " will"
	cont "be traded."
	done

_Colosseum3MonsText::
	text "You need 3 #MON"
	line "to fight!"
	prompt

_ColosseumMewText::
	text "Sorry, MEW can't"
	line "attend!"
	prompt

_ColosseumDifferentMonsText::
	text "Your #MON must"
	line "all be different!"
	prompt

_ColosseumMaxL55Text::
	text "No #MON can"
	line "exceed L55!"
	prompt

_ColosseumMinL50Text::
	text "All #MON must"
	line "be at least L50!"
	prompt

_ColosseumTotalL155Text::
	text "Your total levels"
	line "exceed 155!"
	prompt

_ColosseumMaxL30Text::
	text "No #MON can"
	line "exceed L30!"
	prompt

_ColosseumMinL25Text::
	text "All #MON must"
	line "be at least L25!"
	prompt

_ColosseumTotalL80Text::
	text "Your total levels"
	line "exceed 80!"
	prompt

_ColosseumMaxL20Text::
	text "No #MON can"
	line "exceed L20!"
	prompt

_ColosseumMinL15Text::
	text "All #MON must"
	line "be at least L15!"
	prompt

_ColosseumTotalL50Text::
	text "Your total levels"
	line "exceed 50!"
	prompt

_ColosseumHeightText::
	text_ram wNameBuffer
	text " is over"
	line "6’8” tall!"
	prompt

_ColosseumWeightText::
	text_ram wNameBuffer
	text " weighs"
	line "over 44 pounds!"
	prompt

_ColosseumEvolvedText::
	text_ram wNameBuffer
	text " is an"
	line "evolved #MON!"
	prompt

_ColosseumIneligibleText::
	text "Your opponent is"
	line "ineligible."
	prompt

_ColosseumWhereToText::
	text "Where would you"
	line "like to go?"
	done

_ColosseumPleaseWaitText::
	text "OK, please wait"
	line "just a moment."
	done

_ColosseumCanceledText::
	text "The link was"
	line "canceled."
	done

_ColosseumVersionText::
	text "The game versions"
	line "don't match."
	prompt

_TextIDErrorText::
	text_decimal hTextID, 1, 2
	text " error."
	done

_ContCharText::
	text "<_CONT>@"
	text_end

_NoPokemonText::
	text "There are no"
	line "#MON here!"
	prompt
