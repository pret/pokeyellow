SurfingPikachuOAMData:
; entries correspond to SURFPIKA_OAMSET_* constants (see constants/sprite_anim_constants.asm)
	table_width 3
	dbw $00, .OAMData_1x1            ; SURFPIKA_OAMSET_00
	dbw $00, .OAMData_SurfingPikachu ; SURFPIKA_OAMSET_SURFING_ANGLE_1_1
	dbw $36, .OAMData_SurfingPikachu ; SURFPIKA_OAMSET_SURFING_ANGLE_1_2
	dbw $03, .OAMData_SurfingPikachu ; SURFPIKA_OAMSET_SURFING_ANGLE_2_1
	dbw $39, .OAMData_SurfingPikachu ; SURFPIKA_OAMSET_SURFING_ANGLE_2_2
	dbw $06, .OAMData_SurfingPikachu ; SURFPIKA_OAMSET_SURFING_ANGLE_3_1
	dbw $3c, .OAMData_SurfingPikachu ; SURFPIKA_OAMSET_SURFING_ANGLE_3_2
	dbw $09, .OAMData_SurfingPikachu ; SURFPIKA_OAMSET_SURFING_ANGLE_4_1
	dbw $60, .OAMData_SurfingPikachu ; SURFPIKA_OAMSET_SURFING_ANGLE_4_2
	dbw $0c, .OAMData_SurfingPikachu ; SURFPIKA_OAMSET_SURFING_ANGLE_5_1
	dbw $63, .OAMData_SurfingPikachu ; SURFPIKA_OAMSET_SURFING_ANGLE_5_2
	dbw $30, .OAMData_SurfingPikachu ; SURFPIKA_OAMSET_SURFING_ANGLE_6_1
	dbw $66, .OAMData_SurfingPikachu ; SURFPIKA_OAMSET_SURFING_ANGLE_6_2
	dbw $33, .OAMData_SurfingPikachu ; SURFPIKA_OAMSET_SURFING_ANGLE_7_1
	dbw $69, .OAMData_SurfingPikachu ; SURFPIKA_OAMSET_SURFING_ANGLE_7_2
	dbw $6c, .OAMData_SurfingPikachu ; SURFPIKA_OAMSET_SURFING_FRONT_UNUSED
	dbw $9c, .OAMData_SurfingPikachu ; SURFPIKA_OAMSET_SURFING_BACK_UNUSED
	dbw $a0, .OAMData_SurfingPikachu ; SURFPIKA_OAMSET_SMALL_SPLASH_1
	dbw $a3, .OAMData_SurfingPikachu ; SURFPIKA_OAMSET_SMALL_SPLASH_2
	dbw $a7, .OAMData_SmallSplash    ; SURFPIKA_OAMSET_BIG_SPLASH_1
	dbw $a8, .OAMData_LargeSplash    ; SURFPIKA_OAMSET_BIG_SPLASH_2
	dbw $98, .OAMData_EmptySurfboard ; SURFPIKA_OAMSET_BIG_SPLASH_3
	dbw $e0, .OAMData_AnnouncedText  ; SURFPIKA_OAMSET_START_TEXT
	dbw $e6, .OAMData_AnnouncedText  ; SURFPIKA_OAMSET_GOAL_TEXT
	dbw $ca, .OAMData_AnnouncedText  ; SURFPIKA_OAMSET_OH_NO_TEXT
	dbw $a7, .OAMData_WaterSpray     ; SURFPIKA_OAMSET_WATER_SPRAY
	dbw $00, .OAMData_Plus50Pts      ; SURFPIKA_OAMSET_PLUS_50_POINTS
	dbw $00, .OAMData_Plus150Pts     ; SURFPIKA_OAMSET_PLUS_150_POINTS
	dbw $00, .OAMData_Plus350Pts     ; SURFPIKA_OAMSET_PLUS_350_POINTS
	dbw $00, .OAMData_Plus750Pts     ; SURFPIKA_OAMSET_PLUS_750_POINTS
	dbw $00, .OAMData_Plus180Pts     ; SURFPIKA_OAMSET_PLUS_180_POINTS
	dbw $00, .OAMData_Plus500Pts     ; SURFPIKA_OAMSET_PLUS_500_POINTS
	dbw $80, .OAMData_IntroPikachu   ; SURFPIKA_OAMSET_INTRO_PIKACHU_1
	dbw $84, .OAMData_IntroPikachu   ; SURFPIKA_OAMSET_INTRO_PIKACHU_2
	dbw $88, .OAMData_IntroPikachu   ; SURFPIKA_OAMSET_INTRO_PIKACHU_3
	dbw $8c, .OAMData_IntroPikachu   ; SURFPIKA_OAMSET_INTRO_PIKACHU_4
	assert_table_length NUM_SURFPIKA_OAMSETS

.OAMData_1x1:
	db 1
	db  -4,  -4, $00, 0

.OAMData_SurfingPikachu:
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

.OAMData_AnnouncedText:
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

.OAMData_WaterSpray:
	db 3
	db  -4,  11, $00, OAM_PAL1
	db   4,   3, $0f, OAM_PAL1
	db   4,  11, $10, OAM_PAL1

.OAMData_SmallSplash:
	db 6
	db  -4, -16, $00, OAM_PAL1 | OAM_XFLIP
	db  -4,   8, $00, OAM_PAL1
	db   4, -16, $10, OAM_PAL1 | OAM_XFLIP
	db   4,  -8, $0f, OAM_PAL1 | OAM_XFLIP
	db   4,   0, $0f, OAM_PAL1
	db   4,   8, $10, OAM_PAL1

.OAMData_LargeSplash:
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

.OAMData_EmptySurfboard:
	db 3
	db   4, -12, $00, 0
	db   4,  -4, $01, 0
	db   4,   4, $02, 0

.OAMData_Plus50Pts:
	db 3
	db  -4, -12, $bf, 0
	db  -4,  -4, $d5, 0
	db  -4,   4, $d0, 0

.OAMData_Plus150Pts:
	db 4
	db  -4, -16, $bf, 0
	db  -4,  -8, $d1, 0
	db  -4,   0, $d5, 0
	db  -4,   8, $d0, 0

.OAMData_Plus350Pts:
	db 4
	db  -4, -16, $bf, 0
	db  -4,  -8, $d3, 0
	db  -4,   0, $d5, 0
	db  -4,   8, $d0, 0

.OAMData_Plus750Pts:
	db 4
	db  -4, -16, $bf, 0
	db  -4,  -8, $d7, 0
	db  -4,   0, $d5, 0
	db  -4,   8, $d0, 0

.OAMData_Plus180Pts:
	db 4
	db  -4, -16, $bf, 0
	db  -4,  -8, $d1, 0
	db  -4,   0, $d8, 0
	db  -4,   8, $d0, 0

.OAMData_Plus500Pts:
	db 4
	db  -4, -16, $bf, 0
	db  -4,  -8, $d5, 0
	db  -4,   0, $d0, 0
	db  -4,   8, $d0, 0

.OAMData_IntroPikachu:
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
