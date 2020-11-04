SurfingPikachuOAMData:
	dbw $00, .Frame0
	dbw $00, .Frame1
	dbw $36, .Frame2
	dbw $03, .Frame3
	dbw $39, .Frame4
	dbw $06, .Frame5
	dbw $3c, .Frame6
	dbw $09, .Frame7
	dbw $60, .Frame8
	dbw $0c, .Frame9
	dbw $63, .Frame10
	dbw $30, .Frame11
	dbw $66, .Frame12
	dbw $33, .Frame13
	dbw $69, .Frame14
	dbw $6c, .Frame15
	dbw $9c, .Frame16
	dbw $a0, .Frame17
	dbw $a3, .Frame18
	dbw $a7, .Frame19
	dbw $a8, .Frame20
	dbw $98, .Frame21
	dbw $e0, .Frame22
	dbw $e6, .Frame23
	dbw $ca, .Frame24
	dbw $a7, .Frame25
	dbw $00, .Frame26
	dbw $00, .Frame27
	dbw $00, .Frame28
	dbw $00, .Frame29
	dbw $00, .Frame30
	dbw $00, .Frame31
	dbw $80, .Frame32
	dbw $84, .Frame33
	dbw $88, .Frame34
	dbw $8c, .Frame35

.Frame0:
	db 1
	db $fc, $fc, $00, $00

.Frame1:
.Frame2:
.Frame3:
.Frame4:
.Frame5:
.Frame6:
.Frame7:
.Frame8:
.Frame9:
.Frame10:
.Frame11:
.Frame12:
.Frame13:
.Frame14:
.Frame15:
.Frame16:
.Frame17:
.Frame18:
	db 9
	db $f4, $f4, $00, $00
	db $f4, $fc, $01, $00
	db $f4, $04, $02, $00
	db $fc, $f4, $10, $00
	db $fc, $fc, $11, $00
	db $fc, $04, $12, $00
	db $04, $f4, $20, $00
	db $04, $fc, $21, $00
	db $04, $04, $22, $00

.Frame22:
.Frame23:
.Frame24:
	db 12
	db $f8, $e8, $00, $00
	db $f8, $f0, $01, $00
	db $f8, $f8, $02, $00
	db $f8, $00, $03, $00
	db $f8, $08, $04, $00
	db $f8, $10, $05, $00
	db $00, $e8, $10, $00
	db $00, $f0, $11, $00
	db $00, $f8, $12, $00
	db $00, $00, $13, $00
	db $00, $08, $14, $00
	db $00, $10, $15, $00

.Frame25:
	db 3
	db $fc, $0b, $00, $10
	db $04, $03, $0f, $10
	db $04, $0b, $10, $10

.Frame19:
	db 6
	db $fc, $f0, $00, $30
	db $fc, $08, $00, $10
	db $04, $f0, $10, $30
	db $04, $f8, $0f, $30
	db $04, $00, $0f, $10
	db $04, $08, $10, $10

.Frame20:
	db 12
	db $f4, $f0, $00, $10
	db $f4, $f8, $01, $10
	db $f4, $00, $01, $30
	db $f4, $08, $00, $30
	db $fc, $f0, $10, $10
	db $fc, $f8, $11, $10
	db $fc, $00, $11, $30
	db $fc, $08, $10, $30
	db $04, $f0, $20, $10
	db $04, $f8, $21, $10
	db $04, $00, $21, $30
	db $04, $08, $20, $30

.Frame21:
	db 3
	db $04, $f4, $00, $00
	db $04, $fc, $01, $00
	db $04, $04, $02, $00

.Frame26:
	db 3
	db $fc, $f4, $bf, $00
	db $fc, $fc, $d5, $00
	db $fc, $04, $d0, $00

.Frame27:
	db 4
	db $fc, $f0, $bf, $00
	db $fc, $f8, $d1, $00
	db $fc, $00, $d5, $00
	db $fc, $08, $d0, $00

.Frame28:
	db 4
	db $fc, $f0, $bf, $00
	db $fc, $f8, $d3, $00
	db $fc, $00, $d5, $00
	db $fc, $08, $d0, $00

.Frame29:
	db 4
	db $fc, $f0, $bf, $00
	db $fc, $f8, $d7, $00
	db $fc, $00, $d5, $00
	db $fc, $08, $d0, $00

.Frame30:
	db 4
	db $fc, $f0, $bf, $00
	db $fc, $f8, $d1, $00
	db $fc, $00, $d8, $00
	db $fc, $08, $d0, $00

.Frame31:
	db 4
	db $fc, $f0, $bf, $00
	db $fc, $f8, $d5, $00
	db $fc, $00, $d0, $00
	db $fc, $08, $d0, $00

.Frame32:
.Frame33:
.Frame34:
.Frame35:
	db 12
	db $f4, $f0, $03, $20
	db $f4, $f8, $02, $20
	db $f4, $00, $01, $20
	db $f4, $08, $00, $20
	db $fc, $f0, $13, $20
	db $fc, $f8, $12, $20
	db $fc, $00, $11, $20
	db $fc, $08, $10, $20
	db $04, $f0, $23, $20
	db $04, $f8, $22, $20
	db $04, $00, $21, $20
	db $04, $08, $20, $20
