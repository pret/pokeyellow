CreditsOrder: ; 74243 (1d:4243)
; subsequent credits elements will be displayed on separate lines.
; $FF, $FE, $FD, $FC, $FB, and $FA are commands that are used
; to go to the next set of credits texts.
	db $1c, $00, $ff
	db $1d, $01, $ff
	db $1e, $02, $03, $04, $fd
	db $1e, $05, $2b, $fe
	db $1f, $07, $08, $ff
	db $20, $05, $fd
	db $21, $05, $04, $fe
	db $22, $01, $06, $ff
	db $23, $07, $08, $2f, $ff
	db $24, $01, $fd
	db $24, $30, $fe
	db $25, $06, $ff
	db $26, $01, $06, $31, $ff
	db $27, $32, $31, $fd
	db $27, $33, $34, $fe
	db $28, $3d, $ff
	db $3f, $3e, $ff
	db $29, $36, $fd
	db $29, $0a, $fc
	db $29, $0b, $fe
	db $40, $fd
	db $41, $42, $fd
	db $41, $43, $44, $fc
	db $41, $45, $46, $fc
	db $47, $48, $fd
	db $1e, $4c, $4d, $fd
	db $1f, $51, $fd
	db $28, $52, $4b, $fd
	db $28, $53, $54, $55, $fc
	db $27, $4f, $4e, $fd
	db $2a, $0c, $ff
	db $fb
	db $ff
	db $fa
