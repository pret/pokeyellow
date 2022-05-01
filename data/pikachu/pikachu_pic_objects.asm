MACRO pikaanim_def
\1_id:
	dw \1
ENDM

PikaPicAnimBGFramesPointers:
	pikaanim_def PikaPicAnimBGFrames_0 ; 00
	pikaanim_def PikaPicAnimBGFrames_1 ; 01
	pikaanim_def PikaPicAnimBGFrames_2 ; 02
	pikaanim_def PikaPicAnimBGFrames_3 ; 03
	pikaanim_def PikaPicAnimBGFrames_4 ; 04
	pikaanim_def PikaPicAnimBGFrames_5 ; 05
	pikaanim_def PikaPicAnimBGFrames_6 ; 06
	pikaanim_def PikaPicAnimBGFrames_7 ; 07
	pikaanim_def PikaPicAnimBGFrames_8 ; 08
	pikaanim_def PikaPicAnimBGFrames_9 ; 09
	pikaanim_def PikaPicAnimBGFrames_10 ; 0a
	pikaanim_def PikaPicAnimBGFrames_11 ; 0b
	pikaanim_def PikaPicAnimBGFrames_12 ; 0c
	pikaanim_def PikaPicAnimBGFrames_13 ; 0d
	pikaanim_def PikaPicAnimBGFrames_14 ; 0e
	pikaanim_def PikaPicAnimBGFrames_15 ; 0f
	pikaanim_def PikaPicAnimBGFrames_16 ; 10
	pikaanim_def PikaPicAnimBGFrames_17 ; 11
	pikaanim_def PikaPicAnimBGFrames_18 ; 12
	pikaanim_def PikaPicAnimBGFrames_19 ; 13
	pikaanim_def PikaPicAnimBGFrames_20 ; 14
	pikaanim_def PikaPicAnimBGFrames_21 ; 15
	pikaanim_def PikaPicAnimBGFrames_22 ; 16
	pikaanim_def PikaPicAnimBGFrames_23 ; 17
	pikaanim_def PikaPicAnimBGFrames_24 ; 18
	pikaanim_def PikaPicAnimBGFrames_25 ; 19
	pikaanim_def PikaPicAnimBGFrames_26 ; 1a
	pikaanim_def PikaPicAnimBGFrames_27 ; 1b
	pikaanim_def PikaPicAnimBGFrames_28 ; 1c
	pikaanim_def PikaPicAnimBGFrames_29 ; 1d
	pikaanim_def PikaPicAnimBGFrames_30 ; 1e
	pikaanim_def PikaPicAnimBGFrames_31 ; 1f
	pikaanim_def PikaPicAnimBGFrames_32 ; 20
	pikaanim_def PikaPicAnimBGFrames_33 ; 21
	pikaanim_def PikaPicAnimBGFrames_34 ; 22
	pikaanim_def PikaPicAnimBGFrames_35 ; 23

MACRO pikaframe
	db (\1_id - PikaPicTilemapPointers) / 2, \2
ENDM

DEF pikaframedelay EQUS "db 0,"
DEF pikaframeend EQUS "db $e0"

PikaPicAnimBGFrames_0:
PikaPicAnimBGFrames_1:
	; Tilemap idx, duration
	pikaframe PikaAnimTilemap_1,   20
	pikaframe PikaAnimTilemap_7,    2
	pikaframe PikaAnimTilemap_1,    1
	pikaframe PikaAnimTilemap_7,    2
	pikaframe PikaAnimTilemap_1,    1
	pikaframe PikaAnimTilemap_7,    8
	pikaframeend

PikaPicAnimBGFrames_fdc1e: ; unreferenced
	pikaframe PikaAnimTilemap_2,    2
	pikaframe PikaAnimTilemap_1,    1
	pikaframe PikaAnimTilemap_2,    2
	pikaframe PikaAnimTilemap_1,    1
	pikaframe PikaAnimTilemap_2,    8
	pikaframeend

PikaPicAnimBGFrames_2:
	pikaframedelay                  8
	pikaframe PikaAnimTilemap_8,    8
	pikaframedelay                  8
	pikaframe PikaAnimTilemap_8,    8
	pikaframeend

PikaPicAnimBGFrames_3:
	pikaframe PikaAnimTilemap_8,    8
	pikaframedelay                  8
	pikaframe PikaAnimTilemap_8,    8
	pikaframedelay                  8
	pikaframeend

PikaPicAnimBGFrames_4:
PikaPicAnimBGFrames_35:
	pikaframe PikaAnimTilemap_1,    0
	pikaframeend

PikaPicAnimBGFrames_5:
	pikaframe PikaAnimTilemap_9,    0
	pikaframeend

PikaPicAnimBGFrames_6:
	pikaframedelay                  2
	pikaframe PikaAnimTilemap_14,   4
	pikaframedelay                  8
	pikaframe PikaAnimTilemap_14,   4
	pikaframedelay                 64
	pikaframe PikaAnimTilemap_14,   4
	pikaframedelay                 64
	pikaframeend

PikaPicAnimBGFrames_7:
	pikaframedelay                  4
	pikaframe PikaAnimTilemap_15,   4
	pikaframedelay                  4
	pikaframe PikaAnimTilemap_15,   4
	pikaframedelay                  8
	pikaframe PikaAnimTilemap_15,   4
	pikaframedelay                  8
	pikaframe PikaAnimTilemap_15,   4
	pikaframeend

PikaPicAnimBGFrames_8:
	pikaframe PikaAnimTilemap_16,   1
	pikaframedelay                  1
	pikaframe PikaAnimTilemap_16,   1
	pikaframedelay                 64
	pikaframe PikaAnimTilemap_16,   1
	pikaframedelay                 64
	pikaframeend

PikaPicAnimBGFrames_9:
	pikaframedelay                  8
	pikaframe PikaAnimTilemap_17,   8
	pikaframedelay                 20
	pikaframe PikaAnimTilemap_17,   8
	pikaframeend

PikaPicAnimBGFrames_10:
	pikaframedelay                  2
	pikaframe PikaAnimTilemap_18,   2
	pikaframedelay                  2
	pikaframe PikaAnimTilemap_18,  64
	pikaframedelay                  3
	pikaframe PikaAnimTilemap_18,  64
	pikaframeend

PikaPicAnimBGFrames_11:
	pikaframedelay                  8
	pikaframe PikaAnimTilemap_19,  64
	pikaframedelay                  4
	pikaframe PikaAnimTilemap_19,  64
	pikaframeend

PikaPicAnimBGFrames_12:
	pikaframe PikaAnimTilemap_20,   8
	pikaframedelay                  2
	pikaframe PikaAnimTilemap_20,   8
	pikaframedelay                  2
	pikaframe PikaAnimTilemap_20,   8
	pikaframeend

PikaPicAnimBGFrames_13:
	pikaframe PikaAnimTilemap_21,   4
	pikaframedelay                  8
	pikaframe PikaAnimTilemap_21,   4
	pikaframedelay                 64
	pikaframe PikaAnimTilemap_21,   4
	pikaframedelay                 64
	pikaframeend

PikaPicAnimBGFrames_14:
	pikaframedelay                  2
	pikaframe PikaAnimTilemap_22,   2
	pikaframedelay                  2
	pikaframe PikaAnimTilemap_22,   2
	pikaframedelay                 20
	pikaframe PikaAnimTilemap_22,   2
	pikaframeend

PikaPicAnimBGFrames_15:
	pikaframedelay                  8
	pikaframe PikaAnimTilemap_23,   8
	pikaframeend

PikaPicAnimBGFrames_16:
	pikaframedelay                  8
	pikaframe PikaAnimTilemap_23,   3
	pikaframe PikaAnimTilemap_24,   5
	pikaframe PikaAnimTilemap_23,   3
	pikaframedelay                  5
	pikaframeend

PikaPicAnimBGFrames_17:
	pikaframedelay                 20
	pikaframe PikaAnimTilemap_25,   8
	pikaframedelay                 20
	pikaframe PikaAnimTilemap_25,   8
	pikaframeend

PikaPicAnimBGFrames_18:
	pikaframedelay                 13
	pikaframe PikaAnimTilemap_26,  12
	pikaframedelay                100
	pikaframe PikaAnimTilemap_26,   8
	pikaframeend

PikaPicAnimBGFrames_19:
	pikaframedelay                  5
	pikaframe PikaAnimTilemap_27,   5
	pikaframedelay                  5
	pikaframe PikaAnimTilemap_27,   5
	pikaframedelay                100
	pikaframeend

PikaPicAnimBGFrames_20:
	pikaframedelay                  2
	pikaframe PikaAnimTilemap_28,   2
	pikaframedelay                  2
	pikaframe PikaAnimTilemap_28,   2
	pikaframeend

PikaPicAnimBGFrames_21:
	pikaframedelay                  5
	pikaframe PikaAnimTilemap_29,   5
	pikaframedelay                  5
	pikaframe PikaAnimTilemap_29,   5
	pikaframeend

PikaPicAnimBGFrames_22:
	pikaframe PikaAnimTilemap_30,   8
	pikaframedelay                100
	pikaframeend

PikaPicAnimBGFrames_23:
	pikaframedelay                 10
	pikaframe PikaAnimTilemap_31,   3
	pikaframedelay                  3
	pikaframe PikaAnimTilemap_31,   3
	pikaframedelay                100
	pikaframeend

PikaPicAnimBGFrames_24:
	pikaframedelay                  3
	pikaframe PikaAnimTilemap_32, 100
	pikaframedelay                  8
	pikaframe PikaAnimTilemap_32,   8
	pikaframeend

PikaPicAnimBGFrames_25:
	pikaframe PikaAnimTilemap_33,   6
	pikaframedelay                  6
	pikaframe PikaAnimTilemap_33,   6
	pikaframedelay                  6
	pikaframeend

PikaPicAnimBGFrames_26:
	pikaframedelay                  8
	pikaframe PikaAnimTilemap_34,  12
	pikaframedelay                  8
	pikaframe PikaAnimTilemap_34,  12
	pikaframeend

PikaPicAnimBGFrames_27:
	pikaframedelay                  8
	pikaframe PikaAnimTilemap_9,    2
	pikaframe PikaAnimTilemap_10,   1
	pikaframe PikaAnimTilemap_11,   1
	pikaframe PikaAnimTilemap_12, 100
	pikaframeend

PikaPicAnimBGFrames_28:
	pikaframedelay                  8
	pikaframe PikaAnimTilemap_36, 100
	pikaframeend

PikaPicAnimBGFrames_29:
	pikaframedelay                 16
	pikaframe PikaAnimTilemap_37,  16
	pikaframedelay                 16
	pikaframe PikaAnimTilemap_37,  16
	pikaframeend

PikaPicAnimBGFrames_30:
	pikaframedelay                  6
	pikaframe PikaAnimTilemap_38,   6
	pikaframedelay                  6
	pikaframe PikaAnimTilemap_38,   6
	pikaframedelay                100
	pikaframeend

PikaPicAnimBGFrames_31:
	pikaframedelay                  6
	pikaframe PikaAnimTilemap_9,    6
	pikaframe PikaAnimTilemap_10, 100
	pikaframeend

PikaPicAnimBGFrames_32:
	pikaframedelay                 20
	pikaframe PikaAnimTilemap_9,    8
	pikaframedelay                 20
	pikaframe PikaAnimTilemap_9,    8
	pikaframe PikaAnimTilemap_10,   8
	pikaframe PikaAnimTilemap_11, 100
	pikaframeend

PikaPicAnimBGFrames_33:
	pikaframedelay                  4
	pikaframe PikaAnimTilemap_9,  100
	pikaframeend

PikaPicAnimBGFrames_34:
	pikaframedelay                 12
	pikaframe PikaAnimTilemap_9,   12
	pikaframedelay                 12
	pikaframe PikaAnimTilemap_9,  100
	pikaframeend
