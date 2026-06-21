SurfingPikachuOAMData:
	dbw $00, .SingleTile ; referenced but unused
	dbw $00, .SurfingPikachu
	dbw $36, .SurfingPikachu
	dbw $03, .SurfingPikachu
	dbw $39, .SurfingPikachu
	dbw $06, .SurfingPikachu
	dbw $3c, .SurfingPikachu
	dbw $09, .SurfingPikachu
	dbw $60, .SurfingPikachu
	dbw $0c, .SurfingPikachu
	dbw $63, .SurfingPikachu
	dbw $30, .SurfingPikachu
	dbw $66, .SurfingPikachu
	dbw $33, .SurfingPikachu
	dbw $69, .SurfingPikachu
	dbw $6c, .UnusedFrontPikachu
	dbw $9c, .UnusedBackPikachu
	dbw $a0, .ResultsPikachu
	dbw $a3, .ResultsPikachu
	dbw $a7, .SmallSplash
	dbw $a8, .LargeSplash
	dbw $98, .EmptySurfboard ; when Pikachu has fallen off
	dbw $e0, .StartText
	dbw $e6, .GoalText ; referenced but unused
	dbw $ca, .OhNoText
	dbw $a7, .WaterSpray
	dbw $00, .Plus50Pts
	dbw $00, .Plus150Pts
	dbw $00, .Plus350Pts
	dbw $00, .Plus750Pts
	dbw $00, .Plus180Pts
	dbw $00, .Plus500Pts
	dbw $80, .IntroPikachu
	dbw $84, .IntroPikachu
	dbw $88, .IntroPikachu
	dbw $8c, .IntroPikachu

.SingleTile:
	db 1
	db  -4,  -4, $00, 0

.SurfingPikachu:
.UnusedFrontPikachu:
.UnusedBackPikachu:
.ResultsPikachu:
	db 9
	db -12, -12, $00, 0
	db -12,  -4, $01, 0
	db -12,   4, $02, 0
	db  -4, -12, $10, 0
	db  -4,  -4, $11, 0
	db  -4,   4, $12, 0
	db   4, -12, $20, 0
	db   4,  -4, $21, 0
	db   4,   4, $22, 0

.StartText:
.GoalText:
.OhNoText:
	db 12
	db  -8, -24, $00, 0
	db  -8, -16, $01, 0
	db  -8,  -8, $02, 0
	db  -8,   0, $03, 0
	db  -8,   8, $04, 0
	db  -8,  16, $05, 0
	db   0, -24, $10, 0
	db   0, -16, $11, 0
	db   0,  -8, $12, 0
	db   0,   0, $13, 0
	db   0,   8, $14, 0
	db   0,  16, $15, 0

.WaterSpray:
	db 3
	db  -4,  11, $00, OAM_PAL1
	db   4,   3, $0f, OAM_PAL1
	db   4,  11, $10, OAM_PAL1

.SmallSplash:
	db 6
	db  -4, -16, $00, OAM_PAL1 | OAM_XFLIP
	db  -4,   8, $00, OAM_PAL1
	db   4, -16, $10, OAM_PAL1 | OAM_XFLIP
	db   4,  -8, $0f, OAM_PAL1 | OAM_XFLIP
	db   4,   0, $0f, OAM_PAL1
	db   4,   8, $10, OAM_PAL1

.LargeSplash:
	db 12
	db -12, -16, $00, OAM_PAL1
	db -12,  -8, $01, OAM_PAL1
	db -12,   0, $01, OAM_PAL1 | OAM_XFLIP
	db -12,   8, $00, OAM_PAL1 | OAM_XFLIP
	db  -4, -16, $10, OAM_PAL1
	db  -4,  -8, $11, OAM_PAL1
	db  -4,   0, $11, OAM_PAL1 | OAM_XFLIP
	db  -4,   8, $10, OAM_PAL1 | OAM_XFLIP
	db   4, -16, $20, OAM_PAL1
	db   4,  -8, $21, OAM_PAL1
	db   4,   0, $21, OAM_PAL1 | OAM_XFLIP
	db   4,   8, $20, OAM_PAL1 | OAM_XFLIP

.EmptySurfboard:
	db 3
	db   4, -12, $00, 0
	db   4,  -4, $01, 0
	db   4,   4, $02, 0

.Plus50Pts:
	db 3
	db  -4, -12, $bf, 0
	db  -4,  -4, $d5, 0
	db  -4,   4, $d0, 0

.Plus150Pts:
	db 4
	db  -4, -16, $bf, 0
	db  -4,  -8, $d1, 0
	db  -4,   0, $d5, 0
	db  -4,   8, $d0, 0

.Plus350Pts:
	db 4
	db  -4, -16, $bf, 0
	db  -4,  -8, $d3, 0
	db  -4,   0, $d5, 0
	db  -4,   8, $d0, 0

.Plus750Pts:
	db 4
	db  -4, -16, $bf, 0
	db  -4,  -8, $d7, 0
	db  -4,   0, $d5, 0
	db  -4,   8, $d0, 0

.Plus180Pts:
	db 4
	db  -4, -16, $bf, 0
	db  -4,  -8, $d1, 0
	db  -4,   0, $d8, 0
	db  -4,   8, $d0, 0

.Plus500Pts:
	db 4
	db  -4, -16, $bf, 0
	db  -4,  -8, $d5, 0
	db  -4,   0, $d0, 0
	db  -4,   8, $d0, 0

.IntroPikachu:
	db 12
	db -12, -16, $03, OAM_XFLIP
	db -12,  -8, $02, OAM_XFLIP
	db -12,   0, $01, OAM_XFLIP
	db -12,   8, $00, OAM_XFLIP
	db  -4, -16, $13, OAM_XFLIP
	db  -4,  -8, $12, OAM_XFLIP
	db  -4,   0, $11, OAM_XFLIP
	db  -4,   8, $10, OAM_XFLIP
	db   4, -16, $23, OAM_XFLIP
	db   4,  -8, $22, OAM_XFLIP
	db   4,   0, $21, OAM_XFLIP
	db   4,   8, $20, OAM_XFLIP
