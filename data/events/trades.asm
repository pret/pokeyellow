TradeMons:
; entries correspond to TRADE_FOR_* constants
	table_width 3 + NAME_LENGTH, TradeMons
	; give mon, get mon, dialog id, nickname
	; The two instances of TRADE_DIALOGSET_EVOLUTION are a leftover
	; from the Japanese Blue trades, which used species that evolve.
	; Japanese Red and Green used TRADE_DIALOGSET_CASUAL, and had
	; the same species as English Red and Blue.
	db LICKITUNG,  DUGTRIO,  TRADE_DIALOGSET_CASUAL,    "GURIO@@@@@@"
	db CLEFAIRY,   MR_MIME,  TRADE_DIALOGSET_CASUAL,    "MILES@@@@@@"
	db BUTTERFREE, BEEDRILL, TRADE_DIALOGSET_HAPPY,     "STINGER@@@@" ; unused
	db KANGASKHAN, MUK,      TRADE_DIALOGSET_CASUAL,    "STICKY@@@@@"
	db MEW,        MEW,      TRADE_DIALOGSET_HAPPY,     "BART@@@@@@@" ; unused
	db TANGELA,    PARASECT, TRADE_DIALOGSET_CASUAL,    "SPIKE@@@@@@"
	db PIDGEOT,    PIDGEOT,  TRADE_DIALOGSET_EVOLUTION, "MARTY@@@@@@" ; unused
	db GOLDUCK,    RHYDON,   TRADE_DIALOGSET_EVOLUTION, "BUFFY@@@@@@"
	db GROWLITHE,  DEWGONG,  TRADE_DIALOGSET_HAPPY,     "CEZANNE@@@@"
	db CUBONE,     MACHOKE,  TRADE_DIALOGSET_HAPPY,     "RICKY@@@@@@"
	assert_table_length NUM_NPC_TRADES
