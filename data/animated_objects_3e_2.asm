YellowIntro_AnimatedObjectFramesData:
	dw Unkn_fa100
	dw Unkn_fa103
	dw Unkn_fa10a
	dw Unkn_fa111
	dw Unkn_fa118
	dw Unkn_fa11b
	dw Unkn_fa11e
	dw Unkn_fa121
	dw Unkn_fa124
	dw Unkn_fa127
	dw Unkn_fa138

Unkn_fa100:
	frame $00, 32
	endanim

Unkn_fa103:
	frame $01, 4
	frame $02, 4
	frame $03, 4
	dorestart

Unkn_fa10a:
	frame $04, 4
	frame $05, 4
	frame $06, 4
	dorestart

Unkn_fa111:
	frame $07, 4
	frame $08, 4
	frame $09, 4
	dorestart

Unkn_fa118:
	frame $0a, 32
	endanim

Unkn_fa11b:
	frame $0b, 32
	endanim

Unkn_fa11e:
	frame $0c, 32
	endanim

Unkn_fa121:
	frame $0d, 32
	endanim

Unkn_fa124:
	frame $0e, 32
	endanim

Unkn_fa127:
	frame $0f, 31
	frame $11, 2
	frame $0f, 2
	frame $11, 2
	frame $0f, 31
	frame $11, 2
	frame $0f, 23
	frame $10, 32
	endanim

Unkn_fa138:
	frame $12, 4
	frame $13, 4
	dorestart

YellowIntro_AnimatedObjectOAMData:
	dbw $00, Unkn_fa179
	dbw $96, Unkn_fa17e
	dbw $98, Unkn_fa17e
	dbw $9a, Unkn_fa17e
	dbw $0c, Unkn_fa18f
	dbw $0e, Unkn_fa18f
	dbw $3c, Unkn_fa18f
	dbw $60, Unkn_fa1b0
	dbw $70, Unkn_fa1b0
	dbw $80, Unkn_fa1b0
	dbw $90, Unkn_fa201
	dbw $00, Unkn_fa201
	dbw $06, Unkn_fa201
	dbw $c6, Unkn_fa292
	dbw $6d, Unkn_fa2f7
	dbw $f0, Unkn_fa308
	dbw $f4, Unkn_fa308
	dbw $f8, Unkn_fa308
	dbw $9c, Unkn_fa329
	dbw $ec, Unkn_fa329

Unkn_fa179:
	db 1
	db $fc, $fc, $00, $00
Unkn_fa17e:
	db 4
	db $f8, $f8, $00, $00
	db $f8, $00, $01, $00
	db $00, $f8, $10, $00
	db $00, $00, $11, $00

Unkn_fa18f:
	db 8
	db $f0, $f8, $00, $00
	db $f0, $00, $01, $00
	db $f8, $f8, $10, $00
	db $f8, $00, $11, $00
	db $00, $f8, $20, $00
	db $00, $00, $20, $20
	db $08, $f8, $21, $00
	db $08, $00, $21, $20

Unkn_fa1b0:
	db 20
	db $e8, $f8, $00, $00
	db $e8, $00, $01, $00
	db $f0, $f8, $02, $00
	db $f0, $00, $03, $00
	db $f8, $f0, $04, $00
	db $f8, $f8, $05, $00
	db $f8, $00, $06, $00
	db $f8, $08, $04, $20
	db $00, $f0, $07, $00
	db $00, $f8, $08, $00
	db $00, $00, $08, $20
	db $00, $08, $07, $20
	db $08, $f0, $09, $00
	db $08, $f8, $0a, $00
	db $08, $00, $0a, $20
	db $08, $08, $09, $20
	db $10, $f0, $0b, $00
	db $10, $f8, $0c, $00
	db $10, $00, $0c, $20
	db $10, $08, $0b, $20

Unkn_fa201:
	db 36
	db $e8, $e8, $00, $00
	db $e8, $f0, $01, $00
	db $e8, $f8, $02, $00
	db $e8, $00, $03, $00
	db $e8, $08, $04, $00
	db $e8, $10, $05, $00
	db $f0, $e8, $10, $00
	db $f0, $f0, $11, $00
	db $f0, $f8, $12, $00
	db $f0, $00, $13, $00
	db $f0, $08, $14, $00
	db $f0, $10, $15, $00
	db $f8, $e8, $20, $00
	db $f8, $f0, $21, $00
	db $f8, $f8, $22, $00
	db $f8, $00, $23, $00
	db $f8, $08, $24, $00
	db $f8, $10, $25, $00
	db $00, $e8, $30, $00
	db $00, $f0, $31, $00
	db $00, $f8, $32, $00
	db $00, $00, $33, $00
	db $00, $08, $34, $00
	db $00, $10, $35, $00
	db $08, $e8, $40, $00
	db $08, $f0, $41, $00
	db $08, $f8, $42, $00
	db $08, $00, $43, $00
	db $08, $08, $44, $00
	db $08, $10, $45, $00
	db $10, $e8, $50, $00
	db $10, $f0, $51, $00
	db $10, $f8, $52, $00
	db $10, $00, $53, $00
	db $10, $08, $54, $00
	db $10, $10, $55, $00

Unkn_fa292:
	db 25
	db $ec, $f0, $00, $00
	db $ec, $f8, $01, $00
	db $ec, $00, $02, $00
	db $ec, $08, $03, $00
	db $ec, $10, $04, $00
	db $f4, $f0, $05, $00
	db $f4, $f8, $06, $00
	db $f4, $00, $07, $00
	db $f4, $08, $08, $00
	db $f4, $10, $09, $00
	db $fc, $f0, $10, $00
	db $fc, $f8, $11, $00
	db $fc, $00, $12, $00
	db $fc, $08, $13, $00
	db $fc, $10, $14, $00
	db $04, $f0, $15, $00
	db $04, $f8, $16, $00
	db $04, $00, $17, $00
	db $04, $08, $18, $00
	db $04, $10, $19, $00
	db $0c, $f0, $20, $00
	db $0c, $f8, $21, $00
	db $0c, $00, $22, $00
	db $0c, $08, $23, $00
	db $0c, $10, $24, $00

Unkn_fa2f7:
	db 4
	db $fc, $f0, $00, $00
	db $fc, $f8, $01, $00
	db $fc, $00, $01, $20
	db $fc, $08, $00, $20

Unkn_fa308:
	db 8
	db $f8, $e8, $00, $10
	db $f8, $f0, $01, $10
	db $00, $e8, $02, $10
	db $00, $f0, $03, $10
	db $f8, $08, $01, $30
	db $f8, $10, $00, $30
	db $00, $08, $03, $30
	db $00, $10, $02, $30

Unkn_fa329:
	db 12
	db $f8, $d8, $00, $10
	db $f8, $e0, $01, $10
	db $f8, $e8, $02, $10
	db $00, $d8, $10, $10
	db $00, $e0, $11, $10
	db $00, $e8, $12, $10
	db $f8, $10, $02, $30
	db $f8, $18, $01, $30
	db $f8, $20, $00, $30
	db $00, $10, $12, $30
	db $00, $18, $11, $30
	db $00, $20, $10, $30
