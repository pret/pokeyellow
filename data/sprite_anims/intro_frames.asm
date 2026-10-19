YellowIntro_AnimatedObjectFramesData:
; entries correspond to INTRO_FRAMESET_* constants (see constants/sprite_anim_constants.asm)
	table_width 2
	dw .Frameset_00
	dw .Frameset_PikachuFar
	dw .Frameset_PikachuMid
	dw .Frameset_PikachuNear
	dw .Frameset_PikachuUnused
	dw .Frameset_PikachuSurfing
	dw .Frameset_PikachuFlying
	dw .Frameset_PikachuThunder
	dw .Frameset_SpeedBar
	dw .Frameset_PikachuEyes
	dw .Frameset_CheekSparks
	assert_table_length NUM_INTRO_FRAMESETS

.Frameset_00:
	frame INTRO_OAMSET_00, 32
	endanim

.Frameset_PikachuFar:
	frame INTRO_OAMSET_PIKACHU_FAR_1, 4
	frame INTRO_OAMSET_PIKACHU_FAR_2, 4
	frame INTRO_OAMSET_PIKACHU_FAR_3, 4
	dorestart

.Frameset_PikachuMid:
	frame INTRO_OAMSET_PIKACHU_MID_1, 4
	frame INTRO_OAMSET_PIKACHU_MID_2, 4
	frame INTRO_OAMSET_PIKACHU_MID_3, 4
	dorestart

.Frameset_PikachuNear:
	frame INTRO_OAMSET_PIKACHU_NEAR_1, 4
	frame INTRO_OAMSET_PIKACHU_NEAR_2, 4
	frame INTRO_OAMSET_PIKACHU_NEAR_3, 4
	dorestart

.Frameset_PikachuUnused:
	frame INTRO_OAMSET_PIKACHU_UNUSED, 32
	endanim

.Frameset_PikachuSurfing:
	frame INTRO_OAMSET_PIKACHU_SURFING, 32
	endanim

.Frameset_PikachuFlying:
	frame INTRO_OAMSET_PIKACHU_FLYING, 32
	endanim

.Frameset_PikachuThunder:
	frame INTRO_OAMSET_PIKACHU_THUNDER, 32
	endanim

.Frameset_SpeedBar:
	frame INTRO_OAMSET_SPEED_BAR, 32
	endanim

.Frameset_PikachuEyes:
	frame INTRO_OAMSET_PIKACHU_EYES_1, 31
	frame INTRO_OAMSET_PIKACHU_EYES_3, 2
	frame INTRO_OAMSET_PIKACHU_EYES_1, 2
	frame INTRO_OAMSET_PIKACHU_EYES_3, 2
	frame INTRO_OAMSET_PIKACHU_EYES_1, 31
	frame INTRO_OAMSET_PIKACHU_EYES_3, 2
	frame INTRO_OAMSET_PIKACHU_EYES_1, 23
	frame INTRO_OAMSET_PIKACHU_EYES_2, 32
	endanim

.Frameset_CheekSparks:
	frame INTRO_OAMSET_CHEEK_SPARKS_1, 4
	frame INTRO_OAMSET_CHEEK_SPARKS_2, 4
	dorestart
