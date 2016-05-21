SFX_801ec_4_Ch7: ; 841ec
	unknownnoise0x20 $0, $c1, $33
	endchannel

SFX_801f0_4_Ch7: ; 841f0
	unknownnoise0x20 $0, $b1, $33
	endchannel

SFX_801f4_4_Ch7:
	unknownnoise0x20 $0, $a1, $33
	endchannel

SFX_801f8_4_Ch7:
	unknownnoise0x20 $0, $81, $33
	endchannel

SFX_801fc_4_Ch7:
	unknownnoise0x20 $7, $84, $37
	unknownnoise0x20 $6, $84, $36
	unknownnoise0x20 $5, $83, $35
	unknownnoise0x20 $4, $83, $34
	unknownnoise0x20 $3, $82, $33
	unknownnoise0x20 $2, $81, $32
	endchannel

SFX_8020f_4_Ch7:
	unknownnoise0x20 $0, $51, $2a
	endchannel

SFX_80213_4_Ch7:
	unknownnoise0x20 $1, $41, $2b
	unknownnoise0x20 $0, $61, $2a
	endchannel

SFX_8021a_4_Ch7:
	unknownnoise0x20 $0, $81, $10
	endchannel

SFX_8021e_4_Ch7:
	unknownnoise0x20 $0, $82, $23
	endchannel

SFX_80222_4_Ch7:
	unknownnoise0x20 $0, $82, $25
	endchannel

SFX_80226_4_Ch7:
	unknownnoise0x20 $0, $82, $26
	endchannel

SFX_8022a_4_Ch7:
	unknownnoise0x20 $0, $a1, $10
	endchannel

SFX_8022e_4_Ch7:
	unknownnoise0x20 $0, $a2, $11
	endchannel

SFX_80232_4_Ch7:
	unknownnoise0x20 $0, $a2, $50
	endchannel

SFX_80236_4_Ch7:
	unknownnoise0x20 $0, $a1, $18
	unknownnoise0x20 $0, $31, $33
	endchannel

SFX_8023d_4_Ch7:
	unknownnoise0x20 $2, $91, $28
	unknownnoise0x20 $0, $71, $18
	endchannel

SFX_80244_4_Ch7:
	unknownnoise0x20 $0, $91, $22
	endchannel

SFX_80248_4_Ch7:
	unknownnoise0x20 $0, $71, $22
	endchannel

SFX_8024c_4_Ch7:
	unknownnoise0x20 $0, $61, $22
	endchannel

SFX_80250_4_Ch4:
	duty $02
	unknownsfx0x20 $0, $91, $c0, $07
	unknownsfx0x20 $0, $81, $d0, $07
	unknownsfx0x20 $0, $91, $c0, $07
	unknownsfx0x20 $c, $a1, $d0, $07
	endchannel

SFX_80263_4_Ch7:
	unknownnoise0x20 $1, $e2, $33
	unknownnoise0x20 $8, $e1, $22
	endchannel

SFX_8026a_4_Ch4:
	duty $02
	unknownsfx0x10 $14
	unknownsfx0x20 $4, $f2, $00, $06
	unknownsfx0x20 $4, $f2, $00, $06
	unknownsfx0x10 $17
	unknownsfx0x20 $f, $f2, $00, $06
	unknownsfx0x10 $08
	endchannel

SFX_8027f_4_Ch4:
	duty $02
	unknownsfx0x10 $17
	unknownsfx0x20 $f, $f0, $f0, $04
	unknownsfx0x20 $f, $f2, $50, $06
	unknownsfx0x10 $08
	endchannel

SFX_8028e_4_Ch4:
	duty $02
	unknownsfx0x10 $3a
	unknownsfx0x20 $4, $f2, $00, $02
	unknownsfx0x10 $22
	unknownsfx0x20 $8, $e2, $00, $02
	unknownsfx0x10 $08
	endchannel

SFX_8029f_4_Ch7:
	unknownnoise0x20 $6, $f1, $11
	unknownnoise0x20 $7, $f2, $22
	unknownnoise0x20 $8, $f3, $33
	unknownnoise0x20 $9, $f4, $42
	unknownnoise0x20 $a, $f5, $33
	unknownnoise0x20 $b, $f6, $22
	unknownnoise0x20 $c, $f7, $11
	endchannel

SFX_802b5_4_Ch4:
	duty $02
	unknownsfx0x20 $3, $c4, $60, $07
	unknownsfx0x20 $0, $a4, $40, $07
	unknownsfx0x20 $2, $c4, $40, $07
	unknownsfx0x20 $0, $a4, $60, $07
	unknownsfx0x20 $f, $c1, $60, $07
	endchannel

SFX_802cc_4_Ch4:
	duty $02
	unknownsfx0x20 $3, $b4, $c0, $07
	unknownsfx0x20 $0, $a1, $80, $07
	endchannel

SFX_802d7_4_Ch7:
	unknownnoise0x20 $2, $f1, $32
	unknownnoise0x20 $2, $00, $00
	unknownnoise0x20 $4, $e6, $21
	endchannel

SFX_802e1_4_Ch7:
	unknownnoise0x20 $3, $f3, $66
	unknownnoise0x20 $3, $33, $53
	unknownnoise0x20 $7, $f5, $51
	endchannel

SFX_802eb_4_Ch4:
	executemusic
	tempo 256
	volume 7, 7
	duty 2
	toggleperfectpitch
	notetype 5, 11, 4
	octave 4
	D_ 4
	C_ 4
	octave 3
	A_ 8
	notetype 5, 11, 2
	octave 4
	D# 2
	D# 2
	D_ 2
	C_ 2
	C_ 2
	octave 3
	A# 2
	notetype 5, 11, 4
	octave 4
	C_ 8
	endchannel

SFX_8030a_4_Ch5:
	executemusic
	vibrato 8, 2, 7
	duty 2
	notetype 5, 12, 5
	octave 4
	A_ 4
	F_ 4
	C_ 8
	notetype 5, 12, 2
	A# 2
	A# 2
	A# 2
	G_ 2
	G_ 2
	A# 2
	notetype 5, 12, 4
	A_ 8
	endchannel

SFX_80322_4_Ch6:
	executemusic
	notetype 5, 1, 0
	octave 5
	F_ 4
	D# 4
	C_ 8
	D# 1
	rest 1
	D# 1
	rest 1
	E_ 1
	rest 1
	F_ 1
	rest 1
	F_ 1
	rest 1
	G_ 1
	rest 1
	A_ 8
	endchannel

SFX_80337_4_Branch:
	dutycycle $f0
	unknownsfx0x20 $f, $e0, $80, $07
	unknownsfx0x20 $f, $f0, $84, $07
	unknownsfx0x20 $f, $c3, $e0, $05
	unknownsfx0x20 $f, $c4, $00, $06
	unknownsfx0x20 $a, $6c, $80, $07
	unknownsfx0x20 $8, $71, $84, $07
	endchannel

SFX_80352_4_Branch:
	dutycycle $05
	unknownsfx0x20 $f, $a0, $41, $07
	unknownsfx0x20 $f, $b0, $43, $07
	unknownsfx0x20 $f, $93, $b1, $05
	unknownsfx0x20 $f, $94, $c1, $05
	unknownsfx0x20 $a, $4c, $41, $07
	unknownsfx0x20 $8, $31, $46, $07
	endchannel

SFX_8036c_4_Branch:
	unknownnoise0x20 $2, $f2, $4c
	unknownnoise0x20 $6, $e0, $3a
	unknownnoise0x20 $f, $d0, $3a
	unknownnoise0x20 $8, $d0, $2c
	unknownnoise0x20 $6, $e6, $4c
	unknownnoise0x20 $c, $7d, $4c
	unknownnoise0x20 $f, $d3, $4c
	endchannel

SFX_80383_4_Ch4:
	dutycycle $f0
	unknownsfx0x20 $f, $f7, $a0, $07
	unknownsfx0x20 $6, $e6, $a3, $07
	unknownsfx0x20 $a, $f4, $a0, $07
	dutycycle $a5
	unknownsfx0x20 $a, $f6, $d8, $07
	unknownsfx0x20 $4, $e3, $d7, $07
	unknownsfx0x20 $f, $f2, $d8, $07
	endchannel

SFX_803a0_4_Ch5:
	dutycycle $05
	unknownsfx0x20 $2, $08, $00, $00
	unknownsfx0x20 $f, $a7, $a1, $06
	unknownsfx0x20 $6, $86, $a2, $06
	unknownsfx0x20 $a, $74, $a1, $06
	dutycycle $5f
	unknownsfx0x20 $a, $76, $d6, $06
	unknownsfx0x20 $4, $83, $d9, $06
	unknownsfx0x20 $f, $a2, $d7, $06
	endchannel

SFX_803c1_4_Ch7:
	unknownnoise0x20 $2, $f2, $3c
	unknownnoise0x20 $8, $e4, $3e
	unknownnoise0x20 $f, $d7, $3c
	unknownnoise0x20 $6, $c5, $3b
	unknownnoise0x20 $6, $e4, $3d
	unknownnoise0x20 $8, $b6, $3c
	unknownnoise0x20 $6, $d4, $3d
	unknownnoise0x20 $8, $c1, $3b
	endchannel

SFX_803da_4_Ch4:
	dutycycle $f0
	unknownsfx0x20 $f, $f7, $c0, $07
	unknownsfx0x20 $6, $e4, $c1, $07
	unknownsfx0x20 $a, $f6, $c0, $07
	unknownsfx0x20 $4, $d3, $c2, $07
	unknownsfx0x20 $8, $c1, $c0, $07
	endchannel

SFX_803f1_4_Ch5:
	dutycycle $5f
	unknownsfx0x20 $f, $97, $81, $07
	unknownsfx0x20 $6, $84, $80, $07
	unknownsfx0x20 $a, $96, $81, $07
	unknownsfx0x20 $f, $83, $81, $07
	endchannel

SFX_80404_4_Ch7:
	unknownnoise0x20 $3, $f2, $3c
	unknownnoise0x20 $d, $e6, $2c
	unknownnoise0x20 $f, $d7, $3c
	unknownnoise0x20 $8, $c1, $2c
	endchannel

SFX_80411_4_Ch4:
	dutycycle $f0
	unknownsfx0x20 $f, $f7, $80, $06
	unknownsfx0x20 $a, $e6, $84, $06
	unknownsfx0x20 $f, $d7, $90, $06
	unknownsfx0x20 $8, $d5, $90, $06
	unknownsfx0x20 $6, $c4, $88, $06
	unknownsfx0x20 $5, $d3, $70, $06
	unknownsfx0x20 $4, $d3, $60, $06
	unknownsfx0x20 $8, $c1, $40, $06
	endchannel

SFX_80434_4_Ch5:
	dutycycle $05
	unknownsfx0x20 $f, $b7, $41, $06
	unknownsfx0x20 $a, $96, $42, $06
	unknownsfx0x20 $f, $a7, $51, $06
	unknownsfx0x20 $8, $a5, $51, $06
	unknownsfx0x20 $6, $94, $47, $06
	unknownsfx0x20 $5, $a3, $31, $06
	unknownsfx0x20 $4, $93, $22, $06
	unknownsfx0x20 $8, $71, $01, $06
	endchannel

SFX_80457_4_Ch7:
	unknownnoise0x20 $f, $e4, $3c
	unknownnoise0x20 $a, $c7, $4c
	unknownnoise0x20 $a, $c7, $3c
	unknownnoise0x20 $c, $b7, $4c
	unknownnoise0x20 $f, $a2, $5c
	endchannel

SFX_80467_4_Ch4:
	dutycycle $f0
	unknownsfx0x20 $6, $f7, $a0, $07
	unknownsfx0x20 $8, $e6, $a4, $07
	unknownsfx0x20 $4, $d6, $a0, $07
	unknownsfx0x20 $f, $d3, $20, $07
	unknownsfx0x20 $8, $c3, $23, $07
	unknownsfx0x20 $2, $c2, $28, $07
	unknownsfx0x20 $8, $b1, $30, $07
	endchannel

SFX_80486_4_Ch5:
	dutycycle $0a
	unknownsfx0x20 $4, $08, $00, $00
	unknownsfx0x20 $6, $a7, $41, $07
	unknownsfx0x20 $8, $86, $43, $07
	unknownsfx0x20 $4, $76, $41, $07
	unknownsfx0x20 $d, $83, $c2, $06
	unknownsfx0x20 $7, $73, $c1, $06
	unknownsfx0x20 $3, $82, $cc, $06
	unknownsfx0x20 $8, $71, $d8, $06
	endchannel

SFX_804a9_4_Ch7:
	unknownnoise0x20 $2, $f2, $4c
	unknownnoise0x20 $6, $e6, $3a
	unknownnoise0x20 $4, $d7, $3a
	unknownnoise0x20 $6, $d6, $2c
	unknownnoise0x20 $8, $e5, $3c
	unknownnoise0x20 $c, $d2, $3d
	unknownnoise0x20 $8, $d1, $2c
	endchannel

SFX_804bf_4_Ch4:
	dutycycle $a5
	unknownsfx0x20 $6, $f4, $40, $07
	unknownsfx0x20 $f, $e3, $30, $07
	unknownsfx0x20 $4, $f4, $40, $07
	unknownsfx0x20 $5, $b3, $48, $07
	unknownsfx0x20 $8, $d1, $50, $07
	endchannel

SFX_804d6_4_Ch5:
	dutycycle $77
	unknownsfx0x20 $6, $c3, $12, $07
	unknownsfx0x20 $f, $b3, $04, $07
	unknownsfx0x20 $3, $c3, $12, $07
	unknownsfx0x20 $4, $c3, $21, $07
	unknownsfx0x20 $8, $b1, $32, $07
	endchannel

SFX_804ed_4_Ch7:
	unknownnoise0x20 $8, $d6, $2c
	unknownnoise0x20 $c, $c6, $3c
	unknownnoise0x20 $a, $b6, $2c
	unknownnoise0x20 $8, $91, $1c
	endchannel

SFX_804fa_4_Ch4:
	dutycycle $f0
	unknownsfx0x20 $4, $f7, $08, $06
	unknownsfx0x20 $6, $e6, $00, $06
	unknownsfx0x20 $6, $d7, $f0, $05
	unknownsfx0x20 $6, $c4, $e0, $05
	unknownsfx0x20 $5, $d3, $c0, $05
	unknownsfx0x20 $4, $d3, $a0, $05
	unknownsfx0x20 $8, $e1, $80, $05
	endchannel

SFX_80519_4_Ch5:
	dutycycle $0a
	unknownsfx0x20 $4, $c7, $04, $05
	unknownsfx0x20 $6, $a6, $02, $05
	unknownsfx0x20 $6, $97, $f1, $04
	unknownsfx0x20 $4, $b4, $e1, $04
	unknownsfx0x20 $5, $a3, $c2, $04
	unknownsfx0x20 $4, $b3, $a3, $04
	unknownsfx0x20 $8, $c1, $82, $04
	endchannel

SFX_80538_4_Ch7:
	unknownnoise0x20 $c, $e4, $4c
	unknownnoise0x20 $a, $c7, $5c
	unknownnoise0x20 $c, $b6, $4c
	unknownnoise0x20 $f, $a2, $5c
	endchannel

SFX_80545_4_Ch4:
	dutycycle $f1
	unknownsfx0x20 $4, $f7, $c0, $07
	unknownsfx0x20 $c, $e6, $c2, $07
	unknownsfx0x20 $6, $b5, $80, $06
	unknownsfx0x20 $4, $c4, $70, $06
	unknownsfx0x20 $4, $b5, $60, $06
	unknownsfx0x20 $8, $c1, $40, $06
	endchannel

SFX_80560_4_Ch5:
	dutycycle $cc
	unknownsfx0x20 $3, $c7, $81, $07
	unknownsfx0x20 $c, $b6, $80, $07
	unknownsfx0x20 $6, $a5, $41, $06
	unknownsfx0x20 $4, $c4, $32, $06
	unknownsfx0x20 $6, $b5, $21, $06
	unknownsfx0x20 $8, $a1, $02, $06
	endchannel

SFX_8057b_4_Ch7:
	unknownnoise0x20 $3, $e4, $3c
	unknownnoise0x20 $c, $d6, $2c
	unknownnoise0x20 $4, $e4, $3c
	unknownnoise0x20 $8, $b7, $5c
	unknownnoise0x20 $f, $c2, $5d
	endchannel

SFX_8058b_4_Ch4:
	dutycycle $c9
	unknownsfx0x20 $8, $f7, $80, $06
	unknownsfx0x20 $2, $f7, $60, $06
	unknownsfx0x20 $1, $e7, $40, $06
	unknownsfx0x20 $1, $e7, $20, $06
	unknownsfx0x20 $f, $d1, $00, $06
	unknownsfx0x20 $4, $c7, $40, $07
	unknownsfx0x20 $4, $a7, $30, $07
	unknownsfx0x20 $f, $91, $20, $07
	endchannel

SFX_805ae_4_Ch5
	dutycycle $79
	unknownsfx0x20 $a, $e7, $82, $06
	unknownsfx0x20 $2, $e7, $62, $06
	unknownsfx0x20 $1, $d7, $42, $06
	unknownsfx0x20 $1, $d7, $22, $06
	unknownsfx0x20 $f, $c1, $02, $06
	unknownsfx0x20 $4, $b7, $42, $07
	unknownsfx0x20 $2, $97, $32, $07
	unknownsfx0x20 $f, $81, $22, $07
	endchannel

SFX_805d1_4_Ch7:
	unknownnoise0x20 $4, $74, $21
	unknownnoise0x20 $4, $74, $10
	unknownnoise0x20 $4, $71, $20
	endchannel

SFX_805db_4_Ch4:
	dutycycle $f5
	unknownsfx0x20 $4, $f3, $18, $07
	unknownsfx0x20 $f, $e5, $98, $07
	unknownsfx0x20 $8, $91, $58, $07
	endchannel

SFX_805ea_4_Ch5:
	dutycycle $a0
	unknownsfx0x20 $5, $b3, $08, $07
	unknownsfx0x20 $f, $c5, $88, $07
	unknownsfx0x20 $8, $71, $48, $07
	endchannel

SFX_805f9_4_Ch7:
	unknownnoise0x20 $3, $a1, $1c
	unknownnoise0x20 $e, $94, $2c
	unknownnoise0x20 $8, $81, $1c
	endchannel

SFX_80603_4_Ch4:
	dutycycle $a5
	unknownsfx0x20 $4, $e1, $00, $07
	unknownsfx0x20 $4, $f2, $80, $07
	unknownsfx0x20 $2, $92, $40, $07
	unknownsfx0x20 $8, $e1, $00, $06
	endchannel

SFX_80616_4_Ch5:
	dutycycle $0a
	unknownsfx0x20 $4, $b1, $e1, $06
	unknownsfx0x20 $3, $c2, $e1, $06
	unknownsfx0x20 $3, $62, $81, $06
	unknownsfx0x20 $8, $b1, $e1, $05
	endchannel

SFX_80629_4_Ch7:
	unknownnoise0x20 $2, $61, $32
	unknownnoise0x20 $2, $61, $21
	unknownnoise0x20 $8, $61, $11
	endchannel

SFX_80633_4_Ch4:
	dutycycle $fa
	unknownsfx0x20 $6, $83, $47, $02
	unknownsfx0x20 $f, $62, $26, $02
	unknownsfx0x20 $4, $52, $45, $02
	unknownsfx0x20 $9, $63, $06, $02
	unknownsfx0x20 $f, $82, $25, $02
	unknownsfx0x20 $f, $42, $07, $02
SFX_8064d_4_Ch5:
	endchannel

SFX_8064e_4_Ch7:
	unknownnoise0x20 $8, $d4, $8c
	unknownnoise0x20 $4, $e2, $9c
	unknownnoise0x20 $f, $c6, $8c
	unknownnoise0x20 $8, $e4, $ac
	unknownnoise0x20 $f, $d7, $9c
	unknownnoise0x20 $f, $f2, $ac
	endchannel

SFX_80661_4_Ch4:
	dutycycle $f0
	unknownsfx0x20 $4, $f3, $e0, $06
	unknownsfx0x20 $f, $e4, $40, $06
	unknownsfx0x20 $8, $c1, $20, $06
	endchannel

SFX_80670_4_Ch5:
	dutycycle $0a
	unknownsfx0x20 $3, $c3, $83, $06
	unknownsfx0x20 $e, $b4, $02, $06
	unknownsfx0x20 $8, $a1, $01, $06
	endchannel

SFX_8067f_4_Ch7:
	unknownnoise0x20 $4, $d3, $5c
	unknownnoise0x20 $f, $e6, $4c
	unknownnoise0x20 $8, $b1, $5c
	endchannel

SFX_80689_4_Ch4:
	dutycycle $0a
	unknownsfx0x20 $6, $e2, $00, $05
	unknownsfx0x20 $6, $e3, $80, $05
	unknownsfx0x20 $6, $d3, $70, $05
	unknownsfx0x20 $8, $a1, $60, $05
	endchannel

SFX_8069c_4_Ch5:
	dutycycle $f5
	unknownsfx0x20 $6, $e2, $82, $04
	unknownsfx0x20 $6, $d3, $01, $05
	unknownsfx0x20 $6, $b2, $e2, $04
	unknownsfx0x20 $8, $81, $c1, $04
SFX_806ae_4_Ch7:
	endchannel

SFX_806af_4_Ch4:
	dutycycle $cc
	unknownsfx0x20 $4, $f1, $00, $07
	unknownsfx0x20 $4, $e1, $80, $07
	unknownsfx0x20 $4, $d1, $40, $07
	unknownsfx0x20 $4, $e1, $40, $07
	unknownsfx0x20 $4, $f1, $80, $07
	unknownsfx0x20 $4, $d1, $00, $07
	unknownsfx0x20 $4, $f1, $01, $07
	unknownsfx0x20 $4, $d1, $82, $07
	unknownsfx0x20 $4, $c1, $42, $07
	unknownsfx0x20 $8, $b1, $41, $07
	endchannel

SFX_806da_4_Ch5:
	dutycycle $44
	unknownsfx0x20 $c, $08, $00, $00
	unknownsfx0x20 $4, $f1, $01, $07
	unknownsfx0x20 $4, $e1, $82, $07
	unknownsfx0x20 $4, $d1, $41, $07
	unknownsfx0x20 $4, $e1, $41, $07
	unknownsfx0x20 $4, $f1, $82, $07
	unknownsfx0x20 $8, $d1, $01, $07
	endchannel

SFX_806f9_4_Ch7:
	unknownnoise0x20 $f, $08, $00
	unknownnoise0x20 $4, $08, $00
	unknownnoise0x20 $4, $d1, $4c
	unknownnoise0x20 $4, $b1, $2c
	unknownnoise0x20 $4, $d1, $3c
	unknownnoise0x20 $4, $b1, $3c
	unknownnoise0x20 $4, $c1, $2c
	unknownnoise0x20 $8, $a1, $4c
	endchannel

SFX_80712_4_Ch4:
	dutycycle $cc
	unknownsfx0x20 $8, $f5, $00, $06
	unknownsfx0x20 $2, $d2, $38, $06
	unknownsfx0x20 $2, $c2, $30, $06
	unknownsfx0x20 $2, $c2, $28, $06
	unknownsfx0x20 $2, $b2, $20, $06
	unknownsfx0x20 $2, $b2, $10, $06
	unknownsfx0x20 $2, $a2, $18, $06
	unknownsfx0x20 $2, $b2, $10, $06
	unknownsfx0x20 $8, $c1, $20, $06
	endchannel

SFX_80739_4_Ch5:
	dutycycle $44
	unknownsfx0x20 $c, $c3, $c0, $05
	unknownsfx0x20 $3, $b1, $f9, $05
	unknownsfx0x20 $2, $a1, $f1, $05
	unknownsfx0x20 $2, $a1, $e9, $05
	unknownsfx0x20 $2, $91, $e1, $05
	unknownsfx0x20 $2, $91, $d9, $05
	unknownsfx0x20 $2, $81, $d1, $05
	unknownsfx0x20 $2, $91, $d9, $05
	unknownsfx0x20 $8, $91, $e1, $05
SFX_8075f_4_Ch7:
	endchannel

SFX_80760_4_Ch4:
	duty $00
	unknownsfx0x20 $8, $f5, $80, $04
	unknownsfx0x20 $2, $e1, $e0, $05
	unknownsfx0x20 $8, $d1, $dc, $05
	endchannel

SFX_8076f_4_Ch5:
	dutycycle $a5
	unknownsfx0x20 $7, $95, $41, $04
	unknownsfx0x20 $2, $81, $21, $05
	unknownsfx0x20 $8, $61, $1a, $05
SFX_8077d_4_Ch7:
	endchannel

SFX_8077e_4_Ch4:
	dutycycle $88
	unknownsfx0x20 $5, $f2, $50, $06
	unknownsfx0x20 $9, $d1, $60, $06
	unknownsfx0x20 $5, $e2, $12, $06
	unknownsfx0x20 $9, $c1, $22, $06
	unknownsfx0x20 $5, $f2, $10, $06
	unknownsfx0x20 $6, $d1, $20, $06
	loopchannel 2, SFX_8077e_4_Ch4
	endchannel

SFX_8079d_4_Ch5:
	dutycycle $40
	unknownsfx0x20 $4, $08, $00, $00
	unknownsfx0x20 $5, $f2, $51, $06
	unknownsfx0x20 $9, $d1, $61, $06
	unknownsfx0x20 $5, $e2, $14, $06
	unknownsfx0x20 $8, $c1, $24, $06
	unknownsfx0x20 $5, $f2, $11, $06
	unknownsfx0x20 $c, $d1, $21, $06
	unknownsfx0x20 $5, $e2, $14, $06
	unknownsfx0x20 $8, $c1, $24, $06
	unknownsfx0x20 $5, $f2, $11, $06
	unknownsfx0x20 $4, $d1, $21, $06
	endchannel

SFX_807cc_4_Ch7:
	unknownnoise0x20 $6, $d2, $1c
	unknownnoise0x20 $9, $b1, $2c
	unknownnoise0x20 $8, $c2, $2c
	unknownnoise0x20 $9, $b1, $3c
	unknownnoise0x20 $6, $c2, $2c
	unknownnoise0x20 $9, $a2, $3c
	unknownnoise0x20 $7, $c2, $2c
	unknownnoise0x20 $5, $a1, $3c
	unknownnoise0x20 $9, $c2, $2c
	unknownnoise0x20 $4, $a1, $3c
	endchannel

SFX_807eb_4_Ch4:
	dutycycle $a0
	unknownsfx0x20 $4, $f3, $00, $06
	unknownsfx0x20 $8, $d5, $60, $07
	unknownsfx0x20 $3, $e2, $20, $07
	unknownsfx0x20 $8, $d1, $10, $07
	endchannel

SFX_807fe_4_Ch5:
	dutycycle $5a
	unknownsfx0x20 $5, $b3, $f1, $06
	unknownsfx0x20 $7, $c5, $52, $07
	unknownsfx0x20 $3, $a2, $11, $07
	unknownsfx0x20 $8, $b1, $01, $06
	endchannel

SFX_80811_4_Ch7:
	unknownnoise0x20 $3, $a2, $3c
	unknownnoise0x20 $c, $94, $2c
	unknownnoise0x20 $3, $82, $1c
	unknownnoise0x20 $8, $71, $2c
	endchannel

SFX_8081e_4_Ch4:
	dutycycle $f0
	unknownsfx0x20 $8, $f7, $e0, $06
	unknownsfx0x20 $6, $e6, $e5, $06
	unknownsfx0x20 $3, $f4, $e0, $06
	unknownsfx0x20 $3, $f6, $d0, $06
	unknownsfx0x20 $3, $e3, $c0, $06
	unknownsfx0x20 $4, $f2, $b0, $06
	unknownsfx0x20 $f, $a2, $c8, $06
	endchannel

SFX_8083d_4_Ch5:
	dutycycle $05
	unknownsfx0x20 $3, $08, $00, $00
	unknownsfx0x20 $8, $a7, $a1, $06
	unknownsfx0x20 $6, $86, $a3, $06
	unknownsfx0x20 $3, $74, $a1, $06
	unknownsfx0x20 $3, $76, $91, $06
	unknownsfx0x20 $3, $83, $82, $06
	unknownsfx0x20 $4, $a2, $71, $06
	unknownsfx0x20 $f, $72, $89, $06
	endchannel

SFX_80860_4_Ch7:
	unknownnoise0x20 $2, $f2, $3c
	unknownnoise0x20 $8, $e4, $3e
	unknownnoise0x20 $8, $d7, $3c
	unknownnoise0x20 $5, $c5, $3b
	unknownnoise0x20 $3, $d4, $2c
	unknownnoise0x20 $2, $b6, $3c
	unknownnoise0x20 $3, $a4, $2c
	unknownnoise0x20 $8, $91, $3c
	endchannel

SFX_80879_4_Ch4:
	dutycycle $f0
	unknownsfx0x20 $f, $f6, $65, $05
	unknownsfx0x20 $a, $e4, $7c, $05
	unknownsfx0x20 $3, $c2, $5c, $05
	unknownsfx0x20 $f, $b2, $3c, $05
	endchannel

SFX_8088c_4_Ch5:
	dutycycle $5a
	unknownsfx0x20 $e, $d6, $03, $05
	unknownsfx0x20 $9, $b4, $1b, $05
	unknownsfx0x20 $4, $92, $fa, $04
	unknownsfx0x20 $f, $a2, $db, $04
	endchannel

SFX_8089f_4_Ch7:
	unknownnoise0x20 $c, $e6, $4c
	unknownnoise0x20 $b, $d7, $5c
	unknownnoise0x20 $f, $c2, $4c
	endchannel

SFX_808a9_4_Ch4:
	dutycycle $f0
	unknownsfx0x20 $4, $f7, $a0, $06
	unknownsfx0x20 $8, $e6, $a4, $06
	unknownsfx0x20 $4, $d6, $a0, $06
	unknownsfx0x20 $c, $d3, $20, $06
	unknownsfx0x20 $8, $c3, $24, $06
	unknownsfx0x20 $4, $c2, $20, $06
	unknownsfx0x20 $8, $b1, $10, $06
	endchannel

SFX_808c8_4_Ch5:
	dutycycle $5a
	unknownsfx0x20 $4, $e7, $01, $06
	unknownsfx0x20 $8, $d6, $03, $06
	unknownsfx0x20 $4, $c6, $01, $06
	unknownsfx0x20 $c, $c3, $81, $05
	unknownsfx0x20 $8, $b3, $83, $05
	unknownsfx0x20 $4, $b2, $82, $05
	unknownsfx0x20 $8, $a1, $71, $05
	endchannel

SFX_808e7_4_Ch7:
	unknownnoise0x20 $7, $d6, $5c
	unknownnoise0x20 $8, $e6, $4c
	unknownnoise0x20 $4, $d4, $5c
	unknownnoise0x20 $4, $d4, $4c
	unknownnoise0x20 $7, $c3, $4c
	unknownnoise0x20 $8, $a1, $5c
	endchannel

SFX_808fa_4_Ch4:
	dutycycle $1b
	unknownsfx0x20 $7, $d2, $40, $07
	unknownsfx0x20 $f, $e5, $60, $07
	unknownsfx0x20 $f, $c1, $30, $07
	endchannel

SFX_80909_4_Ch5:
	dutycycle $81
	unknownsfx0x20 $2, $c2, $01, $07
	unknownsfx0x20 $4, $c2, $08, $07
	unknownsfx0x20 $f, $d7, $41, $07
	unknownsfx0x20 $f, $a2, $01, $07
SFX_8091b_4_Ch7:
	endchannel

SFX_8091c_4_Ch4:
	dutycycle $f0
	unknownsfx0x20 $f, $d7, $80, $07
	unknownsfx0x20 $4, $e6, $a0, $07
	unknownsfx0x20 $f, $d2, $40, $07
	endchannel

SFX_8092b_4_Ch5:
	dutycycle $5a
	unknownsfx0x20 $f, $c7, $53, $07
	unknownsfx0x20 $5, $b6, $72, $07
	unknownsfx0x20 $f, $c2, $11, $07
	endchannel

SFX_8093a_4_Ch7:
	unknownnoise0x20 $d, $f6, $4c
	unknownnoise0x20 $4, $e6, $3c
	unknownnoise0x20 $f, $f2, $4c
	endchannel

SFX_80944_4_Ch4:
	dutycycle $f0
	unknownsfx0x20 $6, $f7, $c0, $06
	unknownsfx0x20 $f, $e7, $00, $07
	unknownsfx0x20 $4, $f4, $f0, $06
	unknownsfx0x20 $4, $e4, $e0, $06
	unknownsfx0x20 $8, $d1, $d0, $06
	endchannel

SFX_8095b_4_Ch5:
	dutycycle $0a
	unknownsfx0x20 $7, $e6, $81, $06
	unknownsfx0x20 $e, $d5, $c1, $06
	unknownsfx0x20 $4, $c4, $b1, $06
	unknownsfx0x20 $4, $d4, $a1, $06
	unknownsfx0x20 $8, $c1, $91, $06
	endchannel

SFX_80972_4_Ch7:
	unknownnoise0x20 $a, $a6, $3c
	unknownnoise0x20 $e, $94, $2c
	unknownnoise0x20 $5, $a3, $3c
	unknownnoise0x20 $8, $91, $2c
	endchannel

SFX_8097f_4_Ch4:
	dutycycle $a5
	unknownsfx0x20 $c, $f2, $40, $04
	unknownsfx0x20 $f, $e3, $a0, $04
	unknownsfx0x20 $4, $d2, $90, $04
	unknownsfx0x20 $8, $d1, $80, $04
	endchannel

SFX_80992_4_Ch5:
	dutycycle $ee
	unknownsfx0x20 $b, $d2, $38, $04
	unknownsfx0x20 $e, $c6, $98, $04
	unknownsfx0x20 $3, $b2, $88, $04
	unknownsfx0x20 $8, $b1, $78, $04
	endchannel

SFX_809a5_4_Ch7:
	unknownnoise0x20 $a, $e6, $6c
	unknownnoise0x20 $f, $d2, $5c
	unknownnoise0x20 $3, $c2, $6c
	unknownnoise0x20 $8, $d1, $5c
	endchannel

SFX_809b2_4_Ch4:
	dutycycle $33
	unknownsfx0x20 $f, $f6, $c0, $05
	unknownsfx0x20 $8, $e3, $bc, $05
	unknownsfx0x20 $6, $d2, $d0, $05
	unknownsfx0x20 $6, $b2, $e0, $05
	unknownsfx0x20 $6, $c2, $f0, $05
	unknownsfx0x20 $8, $b1, $00, $06
	endchannel

SFX_809cd_4_Ch5:
	dutycycle $99
	unknownsfx0x20 $e, $c6, $b1, $04
	unknownsfx0x20 $7, $c3, $ad, $04
	unknownsfx0x20 $5, $b2, $c1, $04
	unknownsfx0x20 $8, $92, $d1, $04
	unknownsfx0x20 $6, $a2, $e1, $04
	unknownsfx0x20 $8, $91, $f1, $04
	endchannel

SFX_809e8_4_Ch7:
	unknownnoise0x20 $a, $e6, $5c
	unknownnoise0x20 $a, $d6, $6c
	unknownnoise0x20 $4, $c2, $4c
	unknownnoise0x20 $6, $d3, $5c
	unknownnoise0x20 $8, $b3, $4c
	unknownnoise0x20 $8, $a1, $5c
	endchannel

SFX_809fb_4_Ch4:
	dutycycle $f0
	unknownsfx0x20 $8, $e4, $90, $07
	unknownsfx0x20 $f, $f5, $c0, $07
	unknownsfx0x20 $8, $d1, $d8, $07
	endchannel

SFX_80a0a_4_Ch5:
	dutycycle $a5
	unknownsfx0x20 $a, $c4, $71, $07
	unknownsfx0x20 $f, $b6, $a2, $07
	unknownsfx0x20 $8, $a1, $b7, $07
	endchannel

SFX_80a19_4_Ch7:
	unknownnoise0x20 $8, $e4, $4c
	unknownnoise0x20 $e, $c4, $3c
	unknownnoise0x20 $8, $d1, $2c
	endchannel

SFX_80a23_4_Ch4:
	dutycycle $f0
	unknownsfx0x20 $6, $f2, $00, $06
	unknownsfx0x20 $6, $e2, $40, $06
	unknownsfx0x20 $6, $d2, $80, $06
	unknownsfx0x20 $6, $e2, $c0, $06
	unknownsfx0x20 $6, $d2, $00, $07
	unknownsfx0x20 $6, $c2, $40, $07
	unknownsfx0x20 $6, $b2, $80, $07
	unknownsfx0x20 $8, $a1, $c0, $07
	endchannel

SFX_80a46_4_Ch5:
	dutycycle $11
	unknownsfx0x20 $3, $08, $01, $00
	unknownsfx0x20 $6, $c2, $c1, $05
	unknownsfx0x20 $6, $b2, $02, $06
	unknownsfx0x20 $6, $a2, $41, $06
	unknownsfx0x20 $6, $b2, $82, $06
	unknownsfx0x20 $6, $a2, $c2, $06
	unknownsfx0x20 $6, $92, $01, $07
	unknownsfx0x20 $6, $a2, $42, $07
	unknownsfx0x20 $8, $81, $81, $07
	endchannel

SFX_80a6d_4_Ch7:
	unknownnoise0x20 $6, $08, $01
	unknownnoise0x20 $5, $e2, $5c
	unknownnoise0x20 $5, $c2, $4c
	unknownnoise0x20 $5, $d2, $3c
	unknownnoise0x20 $5, $b2, $2c
	unknownnoise0x20 $5, $c2, $1c
	unknownnoise0x20 $5, $a2, $1b
	unknownnoise0x20 $5, $92, $1a
	unknownnoise0x20 $8, $81, $18
	endchannel

SFX_80a89_4_Ch4:
	dutycycle $f0
	unknownsfx0x20 $4, $f3, $80, $07
	unknownsfx0x20 $f, $e7, $00, $07
	unknownsfx0x20 $8, $d3, $10, $07
	unknownsfx0x20 $4, $c2, $00, $07
	unknownsfx0x20 $4, $d2, $f0, $06
	unknownsfx0x20 $8, $c1, $e0, $06
	endchannel

SFX_80aa4_4_Ch5:
	dutycycle $5a
	unknownsfx0x20 $6, $c3, $01, $07
	unknownsfx0x20 $e, $b7, $81, $06
	unknownsfx0x20 $7, $b3, $92, $06
	unknownsfx0x20 $3, $a2, $81, $06
	unknownsfx0x20 $4, $b2, $72, $06
	unknownsfx0x20 $8, $a1, $61, $06
	endchannel

SFX_80abf_4_Ch7:
	unknownnoise0x20 $6, $e3, $5c
	unknownnoise0x20 $e, $d6, $4c
	unknownnoise0x20 $6, $c6, $3c
	unknownnoise0x20 $3, $b3, $4c
	unknownnoise0x20 $3, $a2, $5c
	unknownnoise0x20 $8, $b1, $6c
	endchannel

SFX_80ad2_4_Ch4:
	dutycycle $0f
	unknownsfx0x20 $f, $f7, $00, $05
	unknownsfx0x20 $f, $e7, $08, $05
	unknownsfx0x20 $8, $b4, $80, $04
	unknownsfx0x20 $f, $a2, $60, $04
	endchannel

SFX_80ae5_4_Ch5:
	dutycycle $44
	unknownsfx0x20 $e, $d7, $81, $04
	unknownsfx0x20 $e, $c7, $89, $04
	unknownsfx0x20 $a, $b4, $01, $04
	unknownsfx0x20 $f, $c2, $e1, $03
	endchannel

SFX_80af8_4_Ch7:
	unknownnoise0x20 $e, $f7, $7c
	unknownnoise0x20 $c, $f6, $6c
	unknownnoise0x20 $9, $e4, $7c
	unknownnoise0x20 $f, $e2, $6c
	endchannel

SFX_80b05_4_Ch4:
	dutycycle $f5
	unknownsfx0x20 $7, $d6, $e1, $07
	unknownsfx0x20 $6, $c6, $e2, $07
	unknownsfx0x20 $9, $d6, $e1, $07
	unknownsfx0x20 $7, $c6, $e0, $07
	unknownsfx0x20 $5, $b6, $e2, $07
	unknownsfx0x20 $7, $c6, $e1, $07
	unknownsfx0x20 $6, $b6, $e0, $07
	unknownsfx0x20 $8, $a1, $df, $07
	endchannel

SFX_80b28_4_Ch5:
	dutycycle $44
	unknownsfx0x20 $6, $c3, $c9, $07
	unknownsfx0x20 $6, $b3, $c7, $07
	unknownsfx0x20 $a, $c4, $c3, $07
	unknownsfx0x20 $8, $b4, $c7, $07
	unknownsfx0x20 $6, $c3, $c9, $07
	unknownsfx0x20 $f, $a2, $c5, $07
	endchannel

SFX_80b43_4_Ch7:
	unknownnoise0x20 $d, $19, $7c
	unknownnoise0x20 $d, $f7, $8c
	unknownnoise0x20 $c, $d6, $7c
	unknownnoise0x20 $8, $c4, $6c
	unknownnoise0x20 $f, $b3, $5c
	endchannel

SFX_80b53_4_Ch4:
	dutycycle $f0
	unknownsfx0x20 $6, $f7, $40, $07
	unknownsfx0x20 $c, $e6, $44, $07
	unknownsfx0x20 $6, $d5, $50, $07
	unknownsfx0x20 $4, $c3, $60, $07
	unknownsfx0x20 $3, $c3, $80, $07
	unknownsfx0x20 $8, $d1, $a0, $07
	endchannel

SFX_80b6e_4_Ch5:
	dutycycle $0a
	unknownsfx0x20 $6, $c7, $01, $07
	unknownsfx0x20 $b, $b6, $02, $07
	unknownsfx0x20 $6, $a5, $11, $07
	unknownsfx0x20 $4, $93, $21, $07
	unknownsfx0x20 $3, $a3, $41, $07
	unknownsfx0x20 $8, $91, $62, $07
	endchannel

SFX_80b89_4_Ch7:
	unknownnoise0x20 $3, $e2, $3c
	unknownnoise0x20 $8, $d6, $4c
	unknownnoise0x20 $5, $d4, $3c
	unknownnoise0x20 $c, $c7, $4c
	unknownnoise0x20 $2, $e2, $3c
	unknownnoise0x20 $8, $d1, $2c
	endchannel

SFX_80b9c_4_Ch4:
	dutycycle $f4
	unknownsfx0x20 $f, $f0, $05, $07
	unknownsfx0x20 $a, $e0, $00, $07
	unknownsfx0x20 $6, $b4, $10, $07
	unknownsfx0x20 $4, $d3, $00, $07
	unknownsfx0x20 $6, $b2, $20, $06
	unknownsfx0x20 $8, $a1, $24, $06
	endchannel

SFX_80bb7_4_Ch5:
	dutycycle $22
	unknownsfx0x20 $f, $b0, $c3, $06
	unknownsfx0x20 $a, $a0, $c1, $06
	unknownsfx0x20 $6, $84, $d2, $06
	unknownsfx0x20 $4, $93, $c1, $06
	unknownsfx0x20 $6, $82, $e1, $05
	unknownsfx0x20 $8, $61, $e8, $05
	endchannel

SFX_80bd2_4_Ch7:
	unknownnoise0x20 $6, $e6, $4c
	unknownnoise0x20 $f, $d6, $3c
	unknownnoise0x20 $a, $c5, $4a
	unknownnoise0x20 $1, $b2, $5b
	unknownnoise0x20 $f, $c2, $4c
	endchannel

SFX_80be2_4_Ch4:
	dutycycle $50
	unknownsfx0x20 $a, $f5, $80, $06
	unknownsfx0x20 $3, $e2, $a0, $06
	unknownsfx0x20 $3, $f2, $c0, $06
	unknownsfx0x20 $3, $e2, $e0, $06
	unknownsfx0x20 $3, $d2, $00, $07
	unknownsfx0x20 $3, $c2, $e0, $06
	unknownsfx0x20 $3, $d2, $c0, $06
	unknownsfx0x20 $8, $c1, $a0, $06
	endchannel

SFX_80c05_4_Ch5:
	dutycycle $0f
	unknownsfx0x20 $9, $d5, $31, $06
	unknownsfx0x20 $3, $d2, $52, $06
	unknownsfx0x20 $3, $e2, $71, $06
	unknownsfx0x20 $3, $b2, $91, $06
	unknownsfx0x20 $3, $c2, $b2, $06
	unknownsfx0x20 $3, $b2, $91, $06
	unknownsfx0x20 $3, $c2, $71, $06
	unknownsfx0x20 $8, $b1, $51, $06
	endchannel

SFX_80c28_4_Ch7
	unknownnoise0x20 $6, $e3, $4c
	unknownnoise0x20 $4, $c3, $3c
	unknownnoise0x20 $5, $d4, $3c
	unknownnoise0x20 $4, $c4, $2c
	unknownnoise0x20 $6, $b4, $3c
	unknownnoise0x20 $8, $c1, $2c
	endchannel

SFX_80c3b_4_Ch4:
	dutycycle $a5
	unknownsfx0x20 $3, $f4, $41, $06
	unknownsfx0x20 $d, $d6, $21, $07
	unknownsfx0x20 $8, $f4, $19, $07
	unknownsfx0x20 $8, $c1, $1a, $07
	endchannel

SFX_80c4e_4_Ch5:
	dutycycle $cc
	unknownsfx0x20 $4, $f4, $80, $05
	unknownsfx0x20 $e, $e6, $e0, $06
	unknownsfx0x20 $8, $d5, $d8, $06
	unknownsfx0x20 $8, $d1, $dc, $06
	endchannel

SFX_80c61_4_Ch7:
	unknownnoise0x20 $5, $c4, $46
	unknownnoise0x20 $d, $a5, $44
	unknownnoise0x20 $8, $c4, $45
	unknownnoise0x20 $8, $b1, $44
	endchannel

SFX_80c6e_4_Ch4:
	dutycycle $f0
	unknownsfx0x20 $d, $f1, $11, $05
	unknownsfx0x20 $d, $e1, $15, $05
	unknownsfx0x20 $d, $e1, $11, $05
	unknownsfx0x20 $8, $d1, $11, $05
	endchannel

SFX_80c81_4_Ch5:
	dutycycle $15
	unknownsfx0x20 $c, $e1, $0c, $05
	unknownsfx0x20 $c, $d1, $10, $05
	unknownsfx0x20 $e, $c1, $0c, $05
	unknownsfx0x20 $8, $c1, $0a, $05
	endchannel

SFX_80c94_4_Ch7:
	unknownnoise0x20 $e, $f2, $65
	unknownnoise0x20 $d, $e2, $55
	unknownnoise0x20 $e, $d2, $56
	unknownnoise0x20 $8, $d1, $66
	endchannel

SFX_80ca1_4_Ch4:
	dutycycle $1b
	unknownsfx0x20 $3, $f3, $64, $05
	unknownsfx0x20 $2, $e2, $44, $05
	unknownsfx0x20 $5, $d1, $22, $05
	unknownsfx0x20 $2, $b2, $84, $04
	unknownsfx0x20 $8, $d1, $a2, $04
	unknownsfx0x20 $3, $f3, $24, $05
	unknownsfx0x20 $4, $e4, $e4, $04
	unknownsfx0x20 $8, $d1, $02, $05
	endchannel

SFX_80cc4_4_Ch5:
	dutycycle $cc
	unknownsfx0x20 $3, $d3, $60, $05
	unknownsfx0x20 $2, $c2, $40, $05
	unknownsfx0x20 $5, $c1, $20, $05
	unknownsfx0x20 $2, $92, $80, $04
	unknownsfx0x20 $8, $c1, $a0, $04
	unknownsfx0x20 $3, $d3, $20, $05
	unknownsfx0x20 $3, $c4, $e0, $04
	unknownsfx0x20 $8, $c1, $00, $05
SFX_80ce6_4_Ch7:
	endchannel

SFX_80ce7_4_Ch4:
	dutycycle $11
	unknownsfx0x20 $2, $3d, $81, $03
	unknownsfx0x20 $7, $f5, $01, $06
	unknownsfx0x20 $1, $c2, $81, $04
	unknownsfx0x20 $8, $91, $81, $03
	endchannel

SFX_80cfa_4_Ch5:
	dutycycle $ee
	unknownsfx0x20 $2, $3e, $b0, $05
	unknownsfx0x20 $7, $d5, $5d, $07
	unknownsfx0x20 $1, $b2, $b0, $06
	unknownsfx0x20 $8, $61, $b0, $05
	endchannel

SFX_80d0d_4_Ch7:
	unknownnoise0x20 $2, $92, $49
	unknownnoise0x20 $7, $b5, $29
	unknownnoise0x20 $1, $a2, $39
	unknownnoise0x20 $8, $91, $49
	endchannel

INCLUDE "audio/music/printer.asm"

SFX_80e5a_4_Ch4:
	executemusic
	tempo 256
	volume 7, 7
	vibrato 6, 2, 6
	duty 2
	toggleperfectpitch
	notetype 4, 11, 1
	octave 3
	G# 2
	G# 2
	G# 2
	notetype 12, 11, 3
	octave 4
	E_ 4
	endchannel

SFX_80e71_4_Ch5:
	executemusic
	vibrato 8, 2, 7
	duty 2
	notetype 4, 12, 1
	octave 4
	E_ 2
	E_ 2
	E_ 2
	notetype 12, 12, 3
	B_ 4
	endchannel

SFX_80e81_4_Ch6:
	executemusic
	notetype 4, 1, 0
	octave 4
	B_ 1
	rest 1
	B_ 1
	rest 1
	B_ 1
	rest 1
	notetype 12, 1, 0
	octave 4
	B_ 2
	rest 2
	endchannel

SFX_80e91_4_Ch4:
	executemusic
	tempo 256
	volume 7, 7
	vibrato 6, 2, 6
	duty 2
	toggleperfectpitch
	notetype 4, 11, 1
	octave 3
	G# 2
	G# 2
	G# 2
	notetype 12, 11, 3
	octave 4
	E_ 4
	endchannel

SFX_80ea8_4_Ch5:
	executemusic
	vibrato 8, 2, 7
	duty 2
	notetype 4, 12, 1
	octave 4
	E_ 2
	E_ 2
	E_ 2
	notetype 12, 12, 3
	B_ 4
	endchannel

SFX_80eb8_4_Ch6:
	executemusic
	notetype 4, 1, 0
	octave 4
	B_ 1
	rest 1
	B_ 1
	rest 1
	B_ 1
	rest 1
	notetype 12, 1, 0
	octave 4
	B_ 2
	rest 2
	endchannel

SFX_80ec8_4_Ch4:
	executemusic
	tempo 256
	volume 7, 7
	duty 2
	toggleperfectpitch
	notetype 5, 11, 4
	octave 4
	D_ 4
	C_ 4
	octave 3
	A_ 8
	notetype 5, 11, 2
	octave 4
	D# 2
	D# 2
	D_ 2
	C_ 2
	C_ 2
	octave 3
	A# 2
	notetype 5, 11, 4
	octave 4
	C_ 8
	endchannel

SFX_80ee7_4_Ch5:
	executemusic
	vibrato 8, 2, 7
	duty 2
	notetype 5, 12, 5
	octave 4
	A_ 4
	F_ 4
	C_ 8
	notetype 5, 12, 2
	A# 2
	A# 2
	A# 2
	G_ 2
	G_ 2
	A# 2
	notetype 5, 12, 4
	A_ 8
	endchannel

SFX_80eff_4_Ch6:
	executemusic
	notetype 5, 1, 0
	octave 5
	F_ 4
	D# 4
	C_ 8
	D# 1
	rest 1
	D# 1
	rest 1
	E_ 1
	rest 1
	F_ 1
	rest 1
	F_ 1
	rest 1
	G_ 1
	rest 1
	A_ 8
	endchannel
