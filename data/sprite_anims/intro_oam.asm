YellowIntro_AnimatedObjectOAMData:
; entries correspond to INTRO_OAMSET_* constants (see constants/sprite_anim_constants.asm)
	table_width 3
	dbw $00, .OAMData_1x1            ; INTRO_OAMSET_00
	dbw $96, .OAMData_PikachuFar     ; INTRO_OAMSET_PIKACHU_FAR_1
	dbw $98, .OAMData_PikachuFar     ; INTRO_OAMSET_PIKACHU_FAR_2
	dbw $9a, .OAMData_PikachuFar     ; INTRO_OAMSET_PIKACHU_FAR_3
	dbw $0c, .OAMData_PikachuMid     ; INTRO_OAMSET_PIKACHU_MID_1
	dbw $0e, .OAMData_PikachuMid     ; INTRO_OAMSET_PIKACHU_MID_2
	dbw $3c, .OAMData_PikachuMid     ; INTRO_OAMSET_PIKACHU_MID_3
	dbw $60, .OAMData_PikachuNear    ; INTRO_OAMSET_PIKACHU_NEAR_1
	dbw $70, .OAMData_PikachuNear    ; INTRO_OAMSET_PIKACHU_NEAR_2
	dbw $80, .OAMData_PikachuNear    ; INTRO_OAMSET_PIKACHU_NEAR_3
	dbw $90, .OAMData_PikachuSurfFly ; INTRO_OAMSET_PIKACHU_UNUSED
	dbw $00, .OAMData_PikachuSurfFly ; INTRO_OAMSET_PIKACHU_SURFING
	dbw $06, .OAMData_PikachuSurfFly ; INTRO_OAMSET_PIKACHU_FLYING
	dbw $c6, .OAMData_PikachuThunder ; INTRO_OAMSET_PIKACHU_THUNDER
	dbw $6d, .OAMData_SpeedBar       ; INTRO_OAMSET_SPEED_BAR
	dbw $f0, .OAMData_PikachuEyes    ; INTRO_OAMSET_PIKACHU_EYES_1
	dbw $f4, .OAMData_PikachuEyes    ; INTRO_OAMSET_PIKACHU_EYES_2
	dbw $f8, .OAMData_PikachuEyes    ; INTRO_OAMSET_PIKACHU_EYES_3
	dbw $9c, .OAMData_CheekSparks    ; INTRO_OAMSET_CHEEK_SPARKS_1
	dbw $ec, .OAMData_CheekSparks    ; INTRO_OAMSET_CHEEK_SPARKS_2
	assert_table_length NUM_INTRO_OAMSETS

.OAMData_1x1:
	db 1
	db  -4,  -4, $00, 0

.OAMData_PikachuFar:
	db 4
	db  -8,  -8, $00, 0
	db  -8,   0, $01, 0
	db   0,  -8, $10, 0
	db   0,   0, $11, 0

.OAMData_PikachuMid:
	db 8
	db -16,  -8, $00, 0
	db -16,   0, $01, 0
	db  -8,  -8, $10, 0
	db  -8,   0, $11, 0
	db   0,  -8, $20, 0
	db   0,   0, $20, OAM_XFLIP
	db   8,  -8, $21, 0
	db   8,   0, $21, OAM_XFLIP

.OAMData_PikachuNear:
	db 20
	db -24,  -8, $00, 0
	db -24,   0, $01, 0
	db -16,  -8, $02, 0
	db -16,   0, $03, 0
	db  -8, -16, $04, 0
	db  -8,  -8, $05, 0
	db  -8,   0, $06, 0
	db  -8,   8, $04, OAM_XFLIP
	db   0, -16, $07, 0
	db   0,  -8, $08, 0
	db   0,   0, $08, OAM_XFLIP
	db   0,   8, $07, OAM_XFLIP
	db   8, -16, $09, 0
	db   8,  -8, $0a, 0
	db   8,   0, $0a, OAM_XFLIP
	db   8,   8, $09, OAM_XFLIP
	db  16, -16, $0b, 0
	db  16,  -8, $0c, 0
	db  16,   0, $0c, OAM_XFLIP
	db  16,   8, $0b, OAM_XFLIP

.OAMData_PikachuSurfFly:
	db 36
	db -24, -24, $00, 0
	db -24, -16, $01, 0
	db -24,  -8, $02, 0
	db -24,   0, $03, 0
	db -24,   8, $04, 0
	db -24,  16, $05, 0
	db -16, -24, $10, 0
	db -16, -16, $11, 0
	db -16,  -8, $12, 0
	db -16,   0, $13, 0
	db -16,   8, $14, 0
	db -16,  16, $15, 0
	db  -8, -24, $20, 0
	db  -8, -16, $21, 0
	db  -8,  -8, $22, 0
	db  -8,   0, $23, 0
	db  -8,   8, $24, 0
	db  -8,  16, $25, 0
	db   0, -24, $30, 0
	db   0, -16, $31, 0
	db   0,  -8, $32, 0
	db   0,   0, $33, 0
	db   0,   8, $34, 0
	db   0,  16, $35, 0
	db   8, -24, $40, 0
	db   8, -16, $41, 0
	db   8,  -8, $42, 0
	db   8,   0, $43, 0
	db   8,   8, $44, 0
	db   8,  16, $45, 0
	db  16, -24, $50, 0
	db  16, -16, $51, 0
	db  16,  -8, $52, 0
	db  16,   0, $53, 0
	db  16,   8, $54, 0
	db  16,  16, $55, 0

.OAMData_PikachuThunder:
	db 25
	db -20, -16, $00, 0
	db -20,  -8, $01, 0
	db -20,   0, $02, 0
	db -20,   8, $03, 0
	db -20,  16, $04, 0
	db -12, -16, $05, 0
	db -12,  -8, $06, 0
	db -12,   0, $07, 0
	db -12,   8, $08, 0
	db -12,  16, $09, 0
	db  -4, -16, $10, 0
	db  -4,  -8, $11, 0
	db  -4,   0, $12, 0
	db  -4,   8, $13, 0
	db  -4,  16, $14, 0
	db   4, -16, $15, 0
	db   4,  -8, $16, 0
	db   4,   0, $17, 0
	db   4,   8, $18, 0
	db   4,  16, $19, 0
	db  12, -16, $20, 0
	db  12,  -8, $21, 0
	db  12,   0, $22, 0
	db  12,   8, $23, 0
	db  12,  16, $24, 0

.OAMData_SpeedBar:
	db 4
	db  -4, -16, $00, 0
	db  -4,  -8, $01, 0
	db  -4,   0, $01, OAM_XFLIP
	db  -4,   8, $00, OAM_XFLIP

.OAMData_PikachuEyes:
	db 8
	db  -8, -24, $00, OAM_PAL1
	db  -8, -16, $01, OAM_PAL1
	db   0, -24, $02, OAM_PAL1
	db   0, -16, $03, OAM_PAL1
	db  -8,   8, $01, OAM_PAL1 | OAM_XFLIP
	db  -8,  16, $00, OAM_PAL1 | OAM_XFLIP
	db   0,   8, $03, OAM_PAL1 | OAM_XFLIP
	db   0,  16, $02, OAM_PAL1 | OAM_XFLIP

.OAMData_CheekSparks:
	db 12
	db  -8, -40, $00, OAM_PAL1
	db  -8, -32, $01, OAM_PAL1
	db  -8, -24, $02, OAM_PAL1
	db   0, -40, $10, OAM_PAL1
	db   0, -32, $11, OAM_PAL1
	db   0, -24, $12, OAM_PAL1
	db  -8,  16, $02, OAM_PAL1 | OAM_XFLIP
	db  -8,  24, $01, OAM_PAL1 | OAM_XFLIP
	db  -8,  32, $00, OAM_PAL1 | OAM_XFLIP
	db   0,  16, $12, OAM_PAL1 | OAM_XFLIP
	db   0,  24, $11, OAM_PAL1 | OAM_XFLIP
	db   0,  32, $10, OAM_PAL1 | OAM_XFLIP
