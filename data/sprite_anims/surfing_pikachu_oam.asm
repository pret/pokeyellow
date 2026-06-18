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
	db $fc, $fc, $00, OAM_PAL0

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
	db $f4, $f4, $00, OAM_PAL0
	db $f4, $fc, $01, OAM_PAL0
	db $f4, $04, $02, OAM_PAL0
	db $fc, $f4, $10, OAM_PAL0
	db $fc, $fc, $11, OAM_PAL0
	db $fc, $04, $12, OAM_PAL0
	db $04, $f4, $20, OAM_PAL0
	db $04, $fc, $21, OAM_PAL0
	db $04, $04, $22, OAM_PAL0

.Frame22:
.Frame23:
.Frame24:
	db 12
	db $f8, $e8, $00, OAM_PAL0
	db $f8, $f0, $01, OAM_PAL0
	db $f8, $f8, $02, OAM_PAL0
	db $f8, $00, $03, OAM_PAL0
	db $f8, $08, $04, OAM_PAL0
	db $f8, $10, $05, OAM_PAL0
	db $00, $e8, $10, OAM_PAL0
	db $00, $f0, $11, OAM_PAL0
	db $00, $f8, $12, OAM_PAL0
	db $00, $00, $13, OAM_PAL0
	db $00, $08, $14, OAM_PAL0
	db $00, $10, $15, OAM_PAL0

.Frame25:
	db 3
	db $fc, $0b, $00, OAM_PAL1
	db $04, $03, $0f, OAM_PAL1
	db $04, $0b, $10, OAM_PAL1

.Frame19:
	db 6
	db $fc, $f0, $00, OAM_PAL1 | OAM_XFLIP
	db $fc, $08, $00, OAM_PAL1
	db $04, $f0, $10, OAM_PAL1 | OAM_XFLIP
	db $04, $f8, $0f, OAM_PAL1 | OAM_XFLIP
	db $04, $00, $0f, OAM_PAL1
	db $04, $08, $10, OAM_PAL1

.Frame20:
	db 12
	db $f4, $f0, $00, OAM_PAL1
	db $f4, $f8, $01, OAM_PAL1
	db $f4, $00, $01, OAM_PAL1 | OAM_XFLIP
	db $f4, $08, $00, OAM_PAL1 | OAM_XFLIP
	db $fc, $f0, $10, OAM_PAL1
	db $fc, $f8, $11, OAM_PAL1
	db $fc, $00, $11, OAM_PAL1 | OAM_XFLIP
	db $fc, $08, $10, OAM_PAL1 | OAM_XFLIP
	db $04, $f0, $20, OAM_PAL1
	db $04, $f8, $21, OAM_PAL1
	db $04, $00, $21, OAM_PAL1 | OAM_XFLIP
	db $04, $08, $20, OAM_PAL1 | OAM_XFLIP

.Frame21:
	db 3
	db $04, $f4, $00, OAM_PAL0
	db $04, $fc, $01, OAM_PAL0
	db $04, $04, $02, OAM_PAL0

.Frame26:
	db 3
	db $fc, $f4, $bf, OAM_PAL0
	db $fc, $fc, $d5, OAM_PAL0
	db $fc, $04, $d0, OAM_PAL0

.Frame27:
	db 4
	db $fc, $f0, $bf, OAM_PAL0
	db $fc, $f8, $d1, OAM_PAL0
	db $fc, $00, $d5, OAM_PAL0
	db $fc, $08, $d0, OAM_PAL0

.Frame28:
	db 4
	db $fc, $f0, $bf, OAM_PAL0
	db $fc, $f8, $d3, OAM_PAL0
	db $fc, $00, $d5, OAM_PAL0
	db $fc, $08, $d0, OAM_PAL0

.Frame29:
	db 4
	db $fc, $f0, $bf, OAM_PAL0
	db $fc, $f8, $d7, OAM_PAL0
	db $fc, $00, $d5, OAM_PAL0
	db $fc, $08, $d0, OAM_PAL0

.Frame30:
	db 4
	db $fc, $f0, $bf, OAM_PAL0
	db $fc, $f8, $d1, OAM_PAL0
	db $fc, $00, $d8, OAM_PAL0
	db $fc, $08, $d0, OAM_PAL0

.Frame31:
	db 4
	db $fc, $f0, $bf, OAM_PAL0
	db $fc, $f8, $d5, OAM_PAL0
	db $fc, $00, $d0, OAM_PAL0
	db $fc, $08, $d0, OAM_PAL0

.Frame32:
.Frame33:
.Frame34:
.Frame35:
	db 12
	db $f4, $f0, $03, OAM_XFLIP
	db $f4, $f8, $02, OAM_XFLIP
	db $f4, $00, $01, OAM_XFLIP
	db $f4, $08, $00, OAM_XFLIP
	db $fc, $f0, $13, OAM_XFLIP
	db $fc, $f8, $12, OAM_XFLIP
	db $fc, $00, $11, OAM_XFLIP
	db $fc, $08, $10, OAM_XFLIP
	db $04, $f0, $23, OAM_XFLIP
	db $04, $f8, $22, OAM_XFLIP
	db $04, $00, $21, OAM_XFLIP
	db $04, $08, $20, OAM_XFLIP
