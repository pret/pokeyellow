SurfingPikachuFrames:
; entries correspond to SURFPIKA_FRAMESET_* constants (see constants/sprite_anim_constants.asm)
	table_width 2
	dw .Frameset_00 ; unused
	dw .Frameset_SurfingAngle1
	dw .Frameset_SurfingAngle2
	dw .Frameset_SurfingAngle3
	dw .Frameset_SurfingAngle4
	dw .Frameset_SurfingAngle5
	dw .Frameset_SurfingAngle6
	dw .Frameset_SurfingAngle7
	dw .Frameset_SurfingAngle8
	dw .Frameset_SurfingAngle9
	dw .Frameset_SurfingAngle10
	dw .Frameset_SurfingAngle11
	dw .Frameset_SurfingAngle12
	dw .Frameset_SurfingAngle13
	dw .Frameset_SurfingAngle14
	dw .Frameset_SmallSplash
	dw .Frameset_LargeSplash
	dw .Frameset_StartText
	dw .Frameset_GoalText ; unused
	dw .Frameset_OhNoText
	dw .Frameset_WaterSpray
	dw .Frameset_Plus50Pts
	dw .Frameset_Plus150Pts
	dw .Frameset_Plus350Pts
	dw .Frameset_Plus750Pts ; unused
	dw .Frameset_Plus180Pts
	dw .Frameset_Plus500Pts
	dw .Frameset_IntroPikachu
	assert_table_length NUM_SURFPIKA_FRAMESETS

.Frameset_00:
	frame SURFPIKA_OAMSET_00, 32
	endanim

.Frameset_SurfingAngle1:
	frame SURFPIKA_OAMSET_SURFING_ANGLE_1_1, 8
	frame SURFPIKA_OAMSET_SURFING_ANGLE_1_2, 8
	dorestart

.Frameset_SurfingAngle2:
	frame SURFPIKA_OAMSET_SURFING_ANGLE_2_1, 8
	frame SURFPIKA_OAMSET_SURFING_ANGLE_2_2, 8
	dorestart

.Frameset_SurfingAngle3:
	frame SURFPIKA_OAMSET_SURFING_ANGLE_3_1, 8
	frame SURFPIKA_OAMSET_SURFING_ANGLE_3_2, 8
	dorestart

.Frameset_SurfingAngle4:
	frame SURFPIKA_OAMSET_SURFING_ANGLE_4_1, 8
	frame SURFPIKA_OAMSET_SURFING_ANGLE_4_2, 8
	dorestart

.Frameset_SurfingAngle5:
	frame SURFPIKA_OAMSET_SURFING_ANGLE_5_1, 8
	frame SURFPIKA_OAMSET_SURFING_ANGLE_5_2, 8
	dorestart

.Frameset_SurfingAngle6:
	frame SURFPIKA_OAMSET_SURFING_ANGLE_6_1, 8
	frame SURFPIKA_OAMSET_SURFING_ANGLE_6_2, 8
	dorestart

.Frameset_SurfingAngle7:
	frame SURFPIKA_OAMSET_SURFING_ANGLE_7_1, 8
	frame SURFPIKA_OAMSET_SURFING_ANGLE_7_2, 8
	dorestart

.Frameset_SurfingAngle8:
	frame SURFPIKA_OAMSET_SURFING_ANGLE_1_1, 8, OAM_XFLIP, OAM_YFLIP
	frame SURFPIKA_OAMSET_SURFING_ANGLE_1_2, 8, OAM_XFLIP, OAM_YFLIP
	dorestart

.Frameset_SurfingAngle9:
	frame SURFPIKA_OAMSET_SURFING_ANGLE_2_1, 8, OAM_XFLIP, OAM_YFLIP
	frame SURFPIKA_OAMSET_SURFING_ANGLE_2_2, 8, OAM_XFLIP, OAM_YFLIP
	dorestart

.Frameset_SurfingAngle10:
	frame SURFPIKA_OAMSET_SURFING_ANGLE_3_1, 8, OAM_XFLIP, OAM_YFLIP
	frame SURFPIKA_OAMSET_SURFING_ANGLE_3_2, 8, OAM_XFLIP, OAM_YFLIP
	dorestart

.Frameset_SurfingAngle11:
	frame SURFPIKA_OAMSET_SURFING_ANGLE_4_1, 8, OAM_XFLIP, OAM_YFLIP
	frame SURFPIKA_OAMSET_SURFING_ANGLE_4_2, 8, OAM_XFLIP, OAM_YFLIP
	dorestart

.Frameset_SurfingAngle12:
	frame SURFPIKA_OAMSET_SURFING_ANGLE_5_1, 8, OAM_XFLIP, OAM_YFLIP
	frame SURFPIKA_OAMSET_SURFING_ANGLE_5_2, 8, OAM_XFLIP, OAM_YFLIP
	dorestart

.Frameset_SurfingAngle13:
	frame SURFPIKA_OAMSET_SURFING_ANGLE_6_1, 8, OAM_XFLIP, OAM_YFLIP
	frame SURFPIKA_OAMSET_SURFING_ANGLE_6_2, 8, OAM_XFLIP, OAM_YFLIP
	dorestart

.Frameset_SurfingAngle14:
	frame SURFPIKA_OAMSET_SURFING_ANGLE_7_1, 8, OAM_XFLIP, OAM_YFLIP
	frame SURFPIKA_OAMSET_SURFING_ANGLE_7_2, 8, OAM_XFLIP, OAM_YFLIP
	dorestart

.Frameset_SmallSplash:
	frame SURFPIKA_OAMSET_SMALL_SPLASH_1, 7
	frame SURFPIKA_OAMSET_SMALL_SPLASH_2, 7
	dorestart

.Frameset_LargeSplash:
	frame SURFPIKA_OAMSET_BIG_SPLASH_1, 2
	frame SURFPIKA_OAMSET_BIG_SPLASH_2, 2
	dorepeat 8
	frame SURFPIKA_OAMSET_BIG_SPLASH_3, 2
	endanim

.Frameset_StartText:
	frame SURFPIKA_OAMSET_START_TEXT, 32
	frame SURFPIKA_OAMSET_START_TEXT, 32
	delanim

.Frameset_GoalText:
	frame SURFPIKA_OAMSET_GOAL_TEXT, 32
	frame SURFPIKA_OAMSET_GOAL_TEXT, 32
	delanim

.Frameset_OhNoText:
	frame SURFPIKA_OAMSET_OH_NO_TEXT, 32
	endanim

.Frameset_Plus50Pts:
	frame SURFPIKA_OAMSET_PLUS_50_POINTS, 4
	dorepeat 1
	frame SURFPIKA_OAMSET_PLUS_50_POINTS, 3
	dorepeat 1
	frame SURFPIKA_OAMSET_PLUS_50_POINTS, 2
	dorepeat 1
	frame SURFPIKA_OAMSET_PLUS_50_POINTS, 1
	delanim

.Frameset_Plus150Pts:
	frame SURFPIKA_OAMSET_PLUS_150_POINTS, 4
	dorepeat 1
	frame SURFPIKA_OAMSET_PLUS_150_POINTS, 3
	dorepeat 1
	frame SURFPIKA_OAMSET_PLUS_150_POINTS, 2
	dorepeat 1
	frame SURFPIKA_OAMSET_PLUS_150_POINTS, 1
	delanim

.Frameset_Plus350Pts:
	frame SURFPIKA_OAMSET_PLUS_350_POINTS, 4
	dorepeat 1
	frame SURFPIKA_OAMSET_PLUS_350_POINTS, 3
	dorepeat 1
	frame SURFPIKA_OAMSET_PLUS_350_POINTS, 2
	dorepeat 1
	frame SURFPIKA_OAMSET_PLUS_350_POINTS, 1
	delanim

.Frameset_Plus750Pts:
	frame SURFPIKA_OAMSET_PLUS_750_POINTS, 4
	dorepeat 1
	frame SURFPIKA_OAMSET_PLUS_750_POINTS, 3
	dorepeat 1
	frame SURFPIKA_OAMSET_PLUS_750_POINTS, 2
	dorepeat 1
	frame SURFPIKA_OAMSET_PLUS_750_POINTS, 1
	delanim

.Frameset_Plus180Pts:
	frame SURFPIKA_OAMSET_PLUS_180_POINTS, 4
	dorepeat 1
	frame SURFPIKA_OAMSET_PLUS_180_POINTS, 3
	dorepeat 1
	frame SURFPIKA_OAMSET_PLUS_180_POINTS, 2
	dorepeat 1
	frame SURFPIKA_OAMSET_PLUS_180_POINTS, 1
	delanim

.Frameset_Plus500Pts:
	frame SURFPIKA_OAMSET_PLUS_500_POINTS, 4
	dorepeat 1
	frame SURFPIKA_OAMSET_PLUS_500_POINTS, 3
	dorepeat 1
	frame SURFPIKA_OAMSET_PLUS_500_POINTS, 2
	dorepeat 1
	frame SURFPIKA_OAMSET_PLUS_500_POINTS, 1
	delanim

.Frameset_WaterSpray:
	frame SURFPIKA_OAMSET_WATER_SPRAY, 1
	delanim

.Frameset_IntroPikachu:
	frame SURFPIKA_OAMSET_INTRO_PIKACHU_1, 7
	frame SURFPIKA_OAMSET_INTRO_PIKACHU_2, 7
	frame SURFPIKA_OAMSET_INTRO_PIKACHU_3, 7
	frame SURFPIKA_OAMSET_INTRO_PIKACHU_4, 7
	dorestart
