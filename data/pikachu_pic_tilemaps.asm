PikaPicTilemapPointers:
	dw Data_fde0e
	dw Data_fde0f
	dw Data_fde2a
	dw Data_fde60
	dw Data_fde63
	dw Data_fde67
	dw Data_fde6b
	dw Data_fde45
	dw Data_fde6b
	dw Data_fdfaa
	dw Data_fdfc5
	dw Data_fdfe0
	dw Data_fdffb
	dw Data_fe016
	dw Data_fde81
	dw Data_fde9c
	dw Data_fdeb7
	dw Data_fded2
	dw Data_fdeed
	dw Data_fdf08
	dw Data_fdf23
	dw Data_fdf3e
	dw Data_fdf59
	dw Data_fdf74
	dw Data_fdf8f
	dw Data_fdfaa
	dw Data_fdfaa
	dw Data_fdfaa
	dw Data_fdfaa
	dw Data_fdfaa
	dw Data_fdfaa
	dw Data_fdfaa
	dw Data_fdfaa
	dw Data_fdfaa
	dw Data_fdfaa
	dw Data_fdfaa
	dw Data_fdfaa
	dw Data_fdfaa
	dw Data_fdfaa
	dw Data_fdfaa
	dw Data_fdfc5
	dw Data_fdfe0
	dw Data_fde0f

Data_fde0e:
	db $ff ; unused

Data_fde0f: ; fde0f
	db 5, 5
	db $00, $05, $0a, $0f, $14
	db $01, $06, $0b, $10, $15
	db $02, $07, $0c, $11, $16
	db $03, $08, $0d, $12, $17
	db $04, $09, $0e, $13, $18

Data_fde2a: ; fde2a
	db 5, 5
	db $19, $1e, $23, $28, $2d
	db $1a, $1f, $24, $29, $2e
	db $1b, $20, $25, $2a, $2f
	db $1c, $21, $26, $2b, $30
	db $1d, $22, $27, $2c, $31

Data_fde45: ; fde45
	db 5, 5
	db $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff
	db $ff, $20, $25, $ff, $ff
	db $ff, $21, $26, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff

Data_fde60: ; fde60
	db 1, 1
	db $00

Data_fde63: ; fde63
	db 2, 1
	db $00
	db $01

Data_fde67: ; fde67
	db 1, 2
	db $00, $01

Data_fde6b: ; fde6b
	db 2, 2
	db $00, $01
	db $02, $03

Data_fde71: ; fde71
	db 3, 2
	db $00, $01
	db $02, $03
	db $04, $05

Data_fde79: ; fde79
	db 2, 3
	db $00, $01, $02
	db $03, $04, $05

Data_fde81: ; fde81
	db 5, 5
	db $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff
	db $00, $01, $02, $03, $04
	db $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff

Data_fde9c: ; fde9c
	db 5, 5
	db $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff
	db $00, $01, $02, $03, $04
	db $05, $06, $07, $08, $09

Data_fdeb7: ; fdeb7
	db 5, 5
	db $00, $01, $ff, $ff, $ff
	db $02, $03, $ff, $ff, $ff
	db $04, $05, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff

Data_fded2: ; fded2
	db 5, 5
	db $ff, $ff, $ff, $ff, $ff
	db $00, $01, $02, $03, $04
	db $05, $06, $07, $08, $09
	db $0a, $0b, $0c, $0d, $0e
	db $0f, $10, $11, $12, $13

Data_fdeed: ; fdeed
	db 5, 5
	db $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $00, $01
	db $ff, $ff, $ff, $02, $03
	db $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff

Data_fdf08: ; fdf08
	db 5, 5
	db $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff
	db $00, $01, $ff, $ff, $ff
	db $02, $03, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff

Data_fdf23: ; fdf23
	db 5, 5
	db $00, $01, $02, $03, $04
	db $05, $06, $07, $08, $09
	db $0a, $0b, $0c, $0d, $0e
	db $0f, $10, $11, $12, $13
	db $14, $15, $16, $17, $18

Data_fdf3e: ; fdf3e
	db 5, 5
	db $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff
	db $00, $01, $02, $03, $04
	db $05, $06, $07, $08, $09
	db $ff, $ff, $ff, $ff, $ff

Data_fdf59: ; fdf59
	db 5, 5
	db $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff
	db $00, $01, $ff, $ff, $ff
	db $02, $03, $ff, $ff, $ff
	db $04, $05, $ff, $ff, $ff

Data_fdf74: ; fdf74
	db 5, 5
	db $00, $01, $02, $03, $04
	db $05, $06, $07, $08, $09
	db $0a, $0b, $0c, $0d, $0e
	db $0f, $10, $11, $12, $13
	db $14, $15, $16, $17, $18

Data_fdf8f: ; fdf8f
	db 5, 5
	db $19, $1a, $1b, $1c, $1d
	db $1e, $1f, $20, $21, $22
	db $23, $24, $25, $26, $27
	db $28, $29, $2a, $2b, $2c
	db $2d, $2e, $2f, $30, $31

Data_fdfaa: ; fdfaa
	db 5, 5
	db $00, $01, $02, $03, $04
	db $05, $06, $07, $08, $09
	db $0a, $0b, $0c, $0d, $0e
	db $0f, $10, $11, $12, $13
	db $14, $15, $16, $17, $18

Data_fdfc5: ; fdfc5
	db 5, 5
	db $19, $1a, $1b, $1c, $1d
	db $1e, $1f, $20, $21, $22
	db $23, $24, $25, $26, $27
	db $28, $29, $2a, $2b, $2c
	db $2d, $2e, $2f, $30, $31

Data_fdfe0: ; fdfe0
	db 5, 5
	db $32, $33, $34, $35, $36
	db $37, $38, $39, $3a, $3b
	db $3c, $3d, $3e, $3f, $40
	db $41, $42, $43, $44, $45
	db $46, $47, $48, $49, $4a

Data_fdffb: ; fdffb
	db 5, 5
	db $4b, $4c, $4d, $4e, $4f
	db $50, $51, $52, $53, $54
	db $55, $56, $57, $58, $59
	db $5a, $5b, $5c, $5d, $5e
	db $5f, $60, $61, $62, $63

Data_fe016: ; fe016
	db 5, 5
	db $64, $65, $66, $67, $68
	db $69, $6a, $6b, $6c, $6d
	db $6e, $6f, $70, $71, $72
	db $73, $74, $75, $76, $77
	db $78, $79, $7a, $7b, $7c
