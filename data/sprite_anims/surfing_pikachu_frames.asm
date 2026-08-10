SurfingPikachuFrames:
	dw .SingleTile ; unused
	dw .SurfingAngle00
	dw .SurfingAngle01
	dw .SurfingAngle02
	dw .SurfingAngle03
	dw .SurfingAngle04
	dw .SurfingAngle05
	dw .SurfingAngle06
	dw .SurfingAngle07
	dw .SurfingAngle08
	dw .SurfingAngle09
	dw .SurfingAngle10
	dw .SurfingAngle11
	dw .SurfingAngle12
	dw .SurfingAngle13
	dw .SmallSplash
	dw .LargeSplash
	dw .StartText
	dw .GoalText ; unused
	dw .OhNoText
	dw .WaterSpray
	dw .Plus50Pts
	dw .Plus150Pts
	dw .Plus350Pts
	dw .Plus750Pts ; unused
	dw .Plus180Pts
	dw .Plus500Pts
	dw .IntroPikachu

.SingleTile:
	frame $00, 32
	endanim

.SurfingAngle00:
	frame $01, 8
	frame $02, 8
	dorestart

.SurfingAngle01:
	frame $03, 8
	frame $04, 8
	dorestart

.SurfingAngle02:
	frame $05, 8
	frame $06, 8
	dorestart

.SurfingAngle03:
	frame $07, 8
	frame $08, 8
	dorestart

.SurfingAngle04:
	frame $09, 8
	frame $0a, 8
	dorestart

.SurfingAngle05:
	frame $0b, 8
	frame $0c, 8
	dorestart

.SurfingAngle06:
	frame $0d, 8
	frame $0e, 8
	dorestart

.SurfingAngle07:
	frame $01, 8, OAM_XFLIP, OAM_YFLIP
	frame $02, 8, OAM_XFLIP, OAM_YFLIP
	dorestart

.SurfingAngle08:
	frame $03, 8, OAM_XFLIP, OAM_YFLIP
	frame $04, 8, OAM_XFLIP, OAM_YFLIP
	dorestart

.SurfingAngle09:
	frame $05, 8, OAM_XFLIP, OAM_YFLIP
	frame $06, 8, OAM_XFLIP, OAM_YFLIP
	dorestart

.SurfingAngle10:
	frame $07, 8, OAM_XFLIP, OAM_YFLIP
	frame $08, 8, OAM_XFLIP, OAM_YFLIP
	dorestart

.SurfingAngle11:
	frame $09, 8, OAM_XFLIP, OAM_YFLIP
	frame $0a, 8, OAM_XFLIP, OAM_YFLIP
	dorestart

.SurfingAngle12:
	frame $0b, 8, OAM_XFLIP, OAM_YFLIP
	frame $0c, 8, OAM_XFLIP, OAM_YFLIP
	dorestart

.SurfingAngle13:
	frame $0d, 8, OAM_XFLIP, OAM_YFLIP
	frame $0e, 8, OAM_XFLIP, OAM_YFLIP
	dorestart

.SmallSplash:
	frame $11, 7
	frame $12, 7
	dorestart

.LargeSplash:
	frame $13, 2
	frame $14, 2
	dorepeat 8
	frame $15, 2
	endanim

.StartText:
	frame $16, 32
	frame $16, 32
	delanim

.GoalText:
	frame $17, 32
	frame $17, 32
	delanim

.OhNoText:
	frame $18, 32
	endanim

.Plus50Pts:
	frame $1a, 4
	dorepeat 1
	frame $1a, 3
	dorepeat 1
	frame $1a, 2
	dorepeat 1
	frame $1a, 1
	delanim

.Plus150Pts:
	frame $1b, 4
	dorepeat 1
	frame $1b, 3
	dorepeat 1
	frame $1b, 2
	dorepeat 1
	frame $1b, 1
	delanim

.Plus350Pts:
	frame $1c, 4
	dorepeat 1
	frame $1c, 3
	dorepeat 1
	frame $1c, 2
	dorepeat 1
	frame $1c, 1
	delanim

.Plus750Pts:
	frame $1d, 4
	dorepeat 1
	frame $1d, 3
	dorepeat 1
	frame $1d, 2
	dorepeat 1
	frame $1d, 1
	delanim

.Plus180Pts:
	frame $1e, 4
	dorepeat 1
	frame $1e, 3
	dorepeat 1
	frame $1e, 2
	dorepeat 1
	frame $1e, 1
	delanim

.Plus500Pts:
	frame $1f, 4
	dorepeat 1
	frame $1f, 3
	dorepeat 1
	frame $1f, 2
	dorepeat 1
	frame $1f, 1
	delanim

.WaterSpray:
	frame $19, 1
	delanim

.IntroPikachu:
	frame $20, 7
	frame $21, 7
	frame $22, 7
	frame $23, 7
	dorestart
