GetPikaPicAnimationScriptIndex: ; fd978 (3f:5978)
	ld hl, PikachuMoodLookupTable
	ld a, [wPikachuMood]
	ld d, a
.asm_fd97f
	ld a, [hli]
	inc hl
	cp d
	jr c, .asm_fd97f
	dec hl
	ld e, [hl]
	ld hl, PikaPicAnimationScriptPointerLookupTable
	ld a, [wPikachuHappiness]
	ld d, a
	ld bc, 6
.asm_fd990
	ld a, [hl]
	cp d
	jr nc, .asm_fd997
	add hl, bc
	jr .asm_fd990

.asm_fd997
	ld d, 0
	add hl, de
	ld a, [hl]
	ret

PikachuMoodLookupTable:
; First byte: mood threshold
; Second byte: column index in PikaPicAnimationScriptPointerLookupTable
	db $28, 1
	db $7f, 2
	db $80, 3
	db $d2, 4
	db $ff, 5

PikaPicAnimationScriptPointerLookupTable:
; First byte: happiness threshold
; Remaining bytes: loaded based on Pikachu's mood
	db $32, $0e, $0e, $06, $0d, $0d
	db $64, $09, $09, $05, $0c, $0c
	db $82, $03, $03, $01, $08, $08
	db $a0, $03, $03, $04, $0f, $0f
	db $c8, $11, $11, $07, $02, $02
	db $fa, $11, $11, $10, $0a, $0a
	db $ff, $11, $11, $13, $14, $14

StarterPikachuEmotionCommand_pikapic: ; fd9d0 (3f:59d0)
	ld a, [H_AUTOBGTRANSFERENABLED]
	push af
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld a, [de]
	ld [wExpressionNumber2], a
	inc de
	push de
	call Func_fd9e4
	pop de
	pop af
	ld [H_AUTOBGTRANSFERENABLED], a
	ret

Func_fd9e4:
	call Func_fda2c
	callab LoadOverworldPikachuFrontpicPalettes
	call Func_fd9ff
	call LoadCurrentPikaPicAnimScriptPointer
	call Func_fda9a
	call Func_fda2c
	call RunDefaultPaletteCommand
	ret

Func_fd9ff:
	ld hl, wPikaPicAnimPointer
	ld bc, $11
	xor a
	call FillMemory
	ld hl, wPikaPicAnimObjectDataBufferSize
	ld bc, $21
	xor a
	call FillMemory
	call Func_fe15c
	ld hl, $64
	ld a, l
	ld [wPikaPicAnimTimer], a
	ld a, h
	ld [wPikaPicAnimTimer + 1], a
	ld a, $07
	ld [wPikaSpriteY], a
	ld a, $06
	ld [wPikaPicTextboxStartY], a
	ret

Func_fda2c:
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	coord hl, 6, 5
	lb bc, 5, 5
	call TextBoxBorder
	call Delay3
	call UpdateSprites
	ld a, $01
	ld [H_AUTOBGTRANSFERENABLED], a
	call Delay3
	ret

LoadCurrentPikaPicAnimScriptPointer:
	ld a, [wExpressionNumber2]
	cp $1d
	jr c, .valid
	ld a, 0
.valid
	ld e, a
	ld d, 0
	ld hl, Pointers_fda5e
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call UpdatePikaPicAnimPointer
	ret

Pointers_fda5e:
	dw Data_fe28a ; 00
	dw Data_fe28a ; 01
	dw Data_fe2a4 ; 02
	dw Data_fe2be ; 03
	dw Data_fe2d8 ; 04
	dw Data_fe2f2 ; 05
	dw Data_fe30c ; 06
	dw Data_fe326 ; 07
	dw Data_fe340 ; 08
	dw Data_fe35a ; 09
	dw Data_fe374 ; 0a
	dw Data_fe390 ; 0b
	dw Data_fe3aa ; 0c
	dw Data_fe3c4 ; 0d
	dw Data_fe3de ; 0e
	dw Data_fe3f8 ; 0f
	dw Data_fe412 ; 10
	dw Data_fe42c ; 11
	dw Data_fe446 ; 12
	dw Data_fe460 ; 13
	dw Data_fe47a ; 14
	dw Data_fe494 ; 15
	dw Data_fe4b4 ; 16
	dw Data_fe4ce ; 17
	dw Data_fe4e8 ; 18
	dw Data_fe502 ; 19
	dw Data_fe520 ; 1a
	dw Data_fe53e ; 1b
	dw Data_fe558 ; 1c
	dw Data_fe28a ; 1d


Func_fda9a:
.loop
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	call RunPikaPicAnimScript
	call Func_fdad5
	call Func_fdad6
	call Func_fdad5
	ld a, $01
	ld [H_AUTOBGTRANSFERENABLED], a
	call PikaPicAnimTimerAndJoypad
	and a
	jr z, .loop
	ret

PikaPicAnimTimerAndJoypad:
	call Delay3
	call CheckPikaPicAnimTimer
	and a
	ret nz
	call JoypadLowSensitivity
	ld a, [hJoyPressed]
	and A_BUTTON | B_BUTTON
	ret

CheckPikaPicAnimTimer:
	ld hl, wPikaPicAnimTimer
	dec [hl]
	jr nz, .not_done_yet
	inc hl
	ld a, [hl]
	and a
	jr z, .timer_expired
	dec [hl]
.not_done_yet
	xor a
	ret

.timer_expired
	ld a, $01
	ret

Func_fdad5:
	ret

Func_fdad6:
	ld bc, wPikaPicAnimObjectDataBuffer
	ld a, 4
.asm_fdadb
	push af
	push bc
	ld hl, 0
	add hl, bc
	ld a, [hli]
	and a
	jr z, .asm_fdb26
	ld a, [hli]
	ld [wCurPikaPicAnimObject], a
	ld a, [hli]
	ld [wCurPikaPicAnimObject + 1], a
	ld a, [hli]
	ld [wCurPikaPicAnimObject + 2], a
	ld a, [hli]
	ld [wd456], a
	ld a, [hli]
	ld [wd457], a
	ld a, [hli]
	ld [wd458], a
	ld a, [hli]
	ld [wCurPikaPicAnimObject + 3], a
	push bc
	call Func_fdb7e
	pop bc
	ld hl, 1
	add hl, bc
	ld a, [wCurPikaPicAnimObject]
	ld [hli], a
	ld a, [wCurPikaPicAnimObject + 1]
	ld [hli], a
	ld a, [wCurPikaPicAnimObject + 2]
	ld [hli], a
	ld a, [wd456]
	ld [hli], a
	ld a, [wd457]
	ld [hli], a
	ld a, [wd458]
	ld [hli], a
	ld a, [wCurPikaPicAnimObject + 3]
	ld [hl], a
.asm_fdb26
	pop bc
	ld hl, 8
	add hl, bc
	ld b, h
	ld c, l
	pop af
	dec a
	jr nz, .asm_fdadb
	ret

PikaPicAnimCommand_object:
	ld hl, wPikaPicAnimObjectDataBuffer
	ld de, 8
	ld c, 4
.loop
	ld a, [hl]
	and a
	jr z, .found
	add hl, de
	dec c
	jr nz, .loop
	scf
	ret

.found
	ld a, [wPikaPicAnimObjectDataBufferSize]
	inc a
	ld [wPikaPicAnimObjectDataBufferSize], a
	ld [hli], a
	call GetPikaPicAnimByte
	ld [hli], a
	call GetPikaPicAnimByte
	ld [hl], a
	xor a
	ld [hli], a
	ld [hli], a
	call GetPikaPicAnimByte
	ld [hli], a
	call GetPikaPicAnimByte
	ld [hli], a
	call GetPikaPicAnimByte
	ld [hli], a
	and a
	ret

PikaPicAnimCommand_deleteobject:
	call GetPikaPicAnimByte
	ld b, a
	ld hl, wPikaPicAnimObjectDataBuffer
	ld de, 8
	ld c, 4
.search
	ld a, [hl]
	cp b
	jr z, .delete
	add hl, de
	dec c
	jr nz, .search
	scf
	ret

.delete
	xor a
	ld [hl], a
	ret

Func_fdb7e:
.asm_fdb7e
	ld a, [wCurPikaPicAnimObject]
	cp $23
	jr c, .asm_fdb87
	ld a, $04
.asm_fdb87
	ld e, a
	ld d, $00
	ld hl, Pointers_fdbc9
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wCurPikaPicAnimObject + 1]
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	cp $e0
	jr z, .asm_fdba1
	jr .asm_fdbaa

.asm_fdba1
	xor a
	ld [wCurPikaPicAnimObject + 1], a
	ld [wCurPikaPicAnimObject + 2], a
	jr .asm_fdb7e

.asm_fdbaa
	push hl
	call Func_fdd62
	pop hl
	ld a, [hl]
	and a
	jr z, .asm_fdbc8
	ld a, [wCurPikaPicAnimObject + 2]
	inc a
	ld [wCurPikaPicAnimObject + 2], a
	cp [hl]
	jr nz, .asm_fdbc8
	xor a
	ld [wCurPikaPicAnimObject + 2], a
	ld a, [wCurPikaPicAnimObject + 1]
	inc a
	ld [wCurPikaPicAnimObject + 1], a
.asm_fdbc8
	ret

Pointers_fdbc9:
	dw Data_fdc11
	dw Data_fdc11
	dw Data_fdc29
	dw Data_fdc32
	dw Data_fdc3b
	dw Data_fdc3e
	dw Data_fdc41
	dw Data_fdc50
	dw Data_fdc61
	dw Data_fdc6e
	dw Data_fdc77
	dw Data_fdc84
	dw Data_fdc8d
	dw Data_fdc98
	dw Data_fdca5
	dw Data_fdcb2
	dw Data_fdcb7
	dw Data_fdcc2
	dw Data_fdccb
	dw Data_fdcd4
	dw Data_fdcdf
	dw Data_fdce8
	dw Data_fdcf1
	dw Data_fdcf6
	dw Data_fdd01
	dw Data_fdd0a
	dw Data_fdd13
	dw Data_fdd1c
	dw Data_fdd27
	dw Data_fdd2c
	dw Data_fdd35
	dw Data_fdd40
	dw Data_fdd47
	dw Data_fdd54
	dw Data_fdd59
	dw Data_fdc3b

Data_fdc11:
	db $01, $14
	db $07, $02
	db $01, $01
	db $07, $02
	db $01, $01
	db $07, $08
	db $e0
Data_fdc1e:
	db $02, $02
	db $01, $01
	db $02, $02
	db $01, $01
	db $02, $08
	db $e0
Data_fdc29:
	db $00, $08
	db $08, $08
	db $00, $08
	db $08, $08
	db $e0
Data_fdc32:
	db $08, $08
	db $00, $08
	db $08, $08
	db $00, $08
	db $e0
Data_fdc3b:
	db $01, $00
	db $e0
Data_fdc3e:
	db $09, $00
	db $e0
Data_fdc41:
	db $00, $02
	db $0e, $04
	db $00, $08
	db $0e, $04
	db $00, $40
	db $0e, $04
	db $00, $40
	db $e0
Data_fdc50:
	db $00, $04
	db $0f, $04
	db $00, $04
	db $0f, $04
	db $00, $08
	db $0f, $04
	db $00, $08
	db $0f, $04
	db $e0
Data_fdc61:
	db $10, $01
	db $00, $01
	db $10, $01
	db $00, $40
	db $10, $01
	db $00, $40
	db $e0
Data_fdc6e:
	db $00, $08
	db $11, $08
	db $00, $14
	db $11, $08
	db $e0
Data_fdc77:
	db $00, $02
	db $12, $02
	db $00, $02
	db $12, $40
	db $00, $03
	db $12, $40
	db $e0
Data_fdc84:
	db $00, $08
	db $13, $40
	db $00, $04
	db $13, $40
	db $e0
Data_fdc8d:
	db $14, $08
	db $00, $02
	db $14, $08
	db $00, $02
	db $14, $08
	db $e0
Data_fdc98:
	db $15, $04
	db $00, $08
	db $15, $04
	db $00, $40
	db $15, $04
	db $00, $40
	db $e0
Data_fdca5:
	db $00, $02
	db $16, $02
	db $00, $02
	db $16, $02
	db $00, $14
	db $16, $02
	db $e0
Data_fdcb2:
	db $00, $08
	db $17, $08
	db $e0
Data_fdcb7:
	db $00, $08
	db $17, $03
	db $18, $05
	db $17, $03
	db $00, $05
	db $e0
Data_fdcc2:
	db $00, $14
	db $19, $08
	db $00, $14
	db $19, $08
	db $e0
Data_fdccb:
	db $00, $0d
	db $1a, $0c
	db $00, $64
	db $1a, $08
	db $e0
Data_fdcd4:
	db $00, $05
	db $1b, $05
	db $00, $05
	db $1b, $05
	db $00, $64
	db $e0
Data_fdcdf:
	db $00, $02
	db $1c, $02
	db $00, $02
	db $1c, $02
	db $e0
Data_fdce8:
	db $00, $05
	db $1d, $05
	db $00, $05
	db $1d, $05
	db $e0
Data_fdcf1:
	db $1e, $08
	db $00, $64
	db $e0
Data_fdcf6:
	db $00, $0a
	db $1f, $03
	db $00, $03
	db $1f, $03
	db $00, $64
	db $e0
Data_fdd01:
	db $00, $03
	db $20, $64
	db $00, $08
	db $20, $08
	db $e0
Data_fdd0a:
	db $21, $06
	db $00, $06
	db $21, $06
	db $00, $06
	db $e0
Data_fdd13:
	db $00, $08
	db $22, $0c
	db $00, $08
	db $22, $0c
	db $e0
Data_fdd1c:
	db $00, $08
	db $09, $02
	db $0a, $01
	db $0b, $01
	db $0c, $64
	db $e0
Data_fdd27:
	db $00, $08
	db $24, $64
	db $e0
Data_fdd2c:
	db $00, $10
	db $25, $10
	db $00, $10
	db $25, $10
	db $e0
Data_fdd35:
	db $00, $06
	db $26, $06
	db $00, $06
	db $26, $06
	db $00, $64
	db $e0
Data_fdd40:
	db $00, $06
	db $09, $06
	db $0a, $64
	db $e0
Data_fdd47:
	db $00, $14
	db $09, $08
	db $00, $14
	db $09, $08
	db $0a, $08
	db $0b, $64
	db $e0
Data_fdd54:
	db $00, $04
	db $09, $64
	db $e0
Data_fdd59:
    db $00, $0c
	db $09, $0c
	db $00, $0c
	db $09, $64
	db $e0

Func_fdd62:
	and a
	ret z
	ld e, a
	ld d, 0
	ld hl, Pointers_fddb8
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld b, a
	inc de
	push de
	push bc
	call Func_fdd98
	pop bc
	pop de
.asm_fdd7c
	push bc
	push hl
	ld a, [wd456]
	ld c, a
.asm_fdd82
	ld a, [de]
	inc de
	cp $ff
	jr z, .asm_fdd8a
	add c
	ld [hl], a
.asm_fdd8a
	inc hl
	dec b
	jr nz, .asm_fdd82
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec c
	jr nz, .asm_fdd7c
	ret

Func_fdd98:
	push bc
	ld a, [wd458]
	ld b, a
	ld a, [wPikaPicTextboxStartY]
	add b
	coord hl, 0, 0
	ld bc, SCREEN_WIDTH
	call AddNTimes
	ld a, [wd457]
	ld c, a
	ld a, [wPikaSpriteY]
	add c
	ld c, a
	ld b, 0
	add hl, bc
	pop bc
	ret

Pointers_fddb8:
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

LoadPikaPicAnimGFXHeader:
	push hl
	ld e, a
	ld d, 0
	ld hl, PikaPicAnimGFXHeaders
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	pop hl
	ret

RunPikaPicAnimScript:
	call Func_fe066
	ret c
	xor a
	ld [wPikaPicAnimPointerSetupFinished], a
.loop
	call GetPikaPicAnimByte
	ld e, a
	ld d, 0
	ld hl, Jumptable_fe071
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call JumpToAddress
	ld a, [wPikaPicAnimPointerSetupFinished]
	and a
	jr z, .loop
	ret

Func_fe066:
	ld a, [wPikaPicAnimDelay]
	and a
	ret z
	dec a
	ld [wPikaPicAnimDelay], a
	scf
	ret

Jumptable_fe071:
	dw PikaPicAnimCommand_nop ; 00, 0 params
	dw PikaPicAnimCommand_writebyte ; 01, 1 param
	dw PikaPicAnimCommand_loadgfx ; 02, 1 param
	dw PikaPicAnimCommand_object ; 03, 5 params
	dw PikaPicAnimCommand_nop4 ; 04, 0 params
	dw PikaPicAnimCommand_nop5 ; 05, 0 params
	dw PikaPicAnimCommand_deleteobject ; 06, 1 param
	dw PikaPicAnimCommand_nop7 ; 07, 0 params
	dw PikaPicAnimCommand_nop8 ; 08, 0 params
	dw PikaPicAnimCommand_jump ; 09, 1 dw param
	dw PikaPicAnimCommand_setduration ; 0a, 1 dw param
	dw PikaPicAnimCommand_cry ; 0b, 1 param
	dw PikaPicAnimCommand_thunderbolt ; 0c, 0 params
	dw PikaPicAnimCommand_waitbgmap ; 0d, 0 params (ret)
	dw PikaPicAnimCommand_ret ; 0e, 0 params (ret)

PikaPicAnimCommand_nop:
	ret

PikaPicAnimCommand_ret:
	ld a, 1
	ld [wPikaPicAnimTimer], a
	xor a
	ld [wPikaPicAnimTimer + 1], a
	jr PikaPicAnimCommand_waitbgmap

Func_fe09b:
	ret

PikaPicAnimCommand_setduration:
	call GetPikaPicAnimByte
	ld [wPikaPicAnimTimer], a
	call GetPikaPicAnimByte
	ld [wPikaPicAnimTimer + 1], a
	ret

PikaPicAnimCommand_waitbgmap:
	ld a, $ff
	ld [wPikaPicAnimPointerSetupFinished], a
	ret

PikaPicAnimCommand_writebyte:
	call GetPikaPicAnimByte
	ld [wPikaPicAnimDelay], a
	ret

PikaPicAnimCommand_nop4:
PikaPicAnimCommand_nop5:
PikaPicAnimCommand_nop7:
PikaPicAnimCommand_nop8:
	ret

PikaPicAnimCommand_jump:
	call GetPikaPicAnimByte
	ld l, a
	call GetPikaPicAnimByte
	ld h, a
	call UpdatePikaPicAnimPointer
	ret

GetPikaPicAnimByte:
	push hl
	ld hl, wPikaPicAnimPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	call UpdatePikaPicAnimPointer
	pop hl
	ret

UpdatePikaPicAnimPointer:
	push af
	ld a, l
	ld [wPikaPicAnimPointer], a
	ld a, h
	ld [wPikaPicAnimPointer + 1], a
	pop af
	ret

PikaPicAnimCommand_loadgfx:
	ld a, [wUpdateSpritesEnabled]
	push af
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	ld a, [H_AUTOBGTRANSFERENABLED]
	push af
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld a, [hTilesetType]
	push af
	xor a
	ld [hTilesetType], a
	call GetPikaPicAnimByte
	ld [wPikaPicAnimCurGraphicID], a
	ld a, [wPikaPicAnimCurGraphicID]
	call LoadPikaPicAnimGFXHeader
	ld a, c
	cp a, $ff
	jr z, .compressed
	call RequestPikaPicAnimGFX
	jr .asm_fe109

.compressed
	call DecompressRequestPikaPicAnimGFX
.asm_fe109
	pop af
	ld [hTilesetType], a
	pop af
	ld [H_AUTOBGTRANSFERENABLED], a
	pop af
	ld [wUpdateSpritesEnabled], a
	ret

RequestPikaPicAnimGFX: ; fe114
	push de
	ld a, [wPikaPicAnimCurGraphicID]
	ld d, a
	ld e, c
	call CheckIfThereIsRoomForPikaPicAnimGFX
	pop de
	jr c, .failed
	call GetPikaPicVRAMAddressForNewGFX
	call CopyVideoDataAlternate
	and a
.failed
	ret

DecompressRequestPikaPicAnimGFX: ; fe128
	push de
	ld a, [wPikaPicAnimCurGraphicID]
	ld d, a
	ld e, 5 * 5
	call CheckIfThereIsRoomForPikaPicAnimGFX
	pop de
	jr c, .failed
	ld a, b
	call UncompressSpriteFromDE
	ld a, BANK(S_SPRITEBUFFER1)
	call SwitchSRAMBankAndLatchClockData
	ld hl, S_SPRITEBUFFER1
	ld de, S_SPRITEBUFFER0
	ld bc, SPRITEBUFFERSIZE * 2
	call CopyData
	call PrepareRTCDataAndDisableSRAM
	ld a, [wPikaPicAnimCurGraphicID]
	call LookUpTileOffsetForCurrentPikaPicAnimGFX
	call GetPikaPicVRAMAddressForNewGFX
	ld d, h
	ld e, l
	call InterlaceMergeSpriteBuffers
.failed
	ret

Func_fe15c:
	ld hl, wNPCMovementDirections
	ld bc, $11
	xor a
	call FillMemory
	ret

GetPikaPicVRAMAddressForNewGFX:
	ld hl, vNPCSprites
	push bc
	ld b, a
	and $f
	swap a
	ld c, a
	ld a, b
	and $f0
	swap a
	ld b, a
	add hl, bc
	pop bc
	ret

CheckIfThereIsRoomForPikaPicAnimGFX:
	push bc
	push hl
	ld hl, wNPCMovementDirections + 1
	ld c, 8
.loop
	ld a, [hl]
	and a
	jr z, .empty
	cp d
	jr z, .found
	inc hl
	inc hl
	dec c
	jr nz, .loop
	scf
	ret ; execute hl, then bc

.found
	inc hl
	ld a, [hl]
	ret ; execute hl, then bc

.empty
	ld [hl], d
	inc hl
	ld a, [wNPCMovementDirections]
	add $80
	ld [hl], a
	ld a, [wNPCMovementDirections]
	add e
	ld [wNPCMovementDirections], a
	cp $80
	jr z, .asm_fe1a7
	jr nc, .failed
.asm_fe1a7
	ld a, [hl]
	and a
	jr .pop_ret

.failed
	scf
.pop_ret
	pop hl
	pop bc
	ret

LookUpTileOffsetForCurrentPikaPicAnimGFX:
	push bc
	push hl
	ld b, a
	ld hl, wNPCMovementDirections + 1
	ld c, 8
.loop
	ld a, [hli]
	cp b
	jr z, .found
	inc hl
	dec c
	jr nz, .loop
	scf
	jr .pop_ret

.found
	ld a, [hl]
	and a
.pop_ret
	pop hl
	pop bc
	ret

PikaPicAnimCommand_cry:
	call GetPikaPicAnimByte
	cp $ff
	ret z
	ld e, a
	callab PlayPikachuSoundClip
	ret

PikaPicAnimCommand_thunderbolt:
	ld a, $1
	ld [wMuteAudioAndPauseMusic], a
	call DelayFrame
	ld a, [wAudioROMBank]
	push af
	ld a, BANK(SFX_Battle_2F)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	call PikaPicAnimLoadThunderboltAudio
	call PlaySound
	call PikaPicAnimThunderboltFlashScreen
	call WaitForSoundToFinish
	pop af
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	xor a
	ld [wMuteAudioAndPauseMusic], a
	ret

PikaPicAnimLoadThunderboltAudio:
	ld hl, MoveSoundTable
	ld e, THUNDERBOLT
	ld d, 0
	add hl, de
	add hl, de
	add hl, de
	ld a, BANK(MoveSoundTable)
	call GetFarByte
	ld b, a
	inc hl
	ld a, BANK(MoveSoundTable)
	call GetFarByte
	inc hl
	ld [wFrequencyModifier], a
	ld a, BANK(MoveSoundTable)
	call GetFarByte
	ld [wTempoModifier], a
	ld a, b
	ret

PikaPicAnimThunderboltFlashScreen:
	ld hl, Data_fe242
.loop
	ld a, [hli]
	cp $ff
	ret z
	ld c, a
	ld b, [hl]
	inc hl
	push hl
	call GetDMGBGPalForPikaThunderbolt
	pop hl
	jr .loop

GetDMGBGPalForPikaThunderbolt:
	ld a, b
	ld [rBGP], a
	call UpdateGBCPal_BGP
	call DelayFrames
	ret

Data_fe242:
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db $ff

Data_fe26b: ; fe26b (3f:626b)
	pikapic_loadgfx Pic_e4000
	pikapic_loadgfx Pic_e49d1
	pikapic_loadgfx PikachuSprite
	pikapic_object $1, $80, $0, $0
	pikapic_object $2, $b2, $5, $5
	pikapic_object $3, $b6, $5, $5
	pikapic_waitbgmap
	pikapic_cry
Data_fe286: ; fe286 (3f:6286)
	pikapic_waitbgmap
	pikapic_jump Data_fe286

Data_fe28a: ; fe28a (3f:628a)
	pikapic_setduration 40
	pikapic_loadgfx Pic_e4000
	pikapic_loadgfx GFX_e40cc
	pikapic_object $4, $80, $0, $0
	pikapic_object $6, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry3
Data_fe2a0: ; fe2a0 (3f:62a0)
	pikapic_waitbgmap
	pikapic_jump Data_fe2a0

Data_fe2a4: ; fe2a4 (3f:62a4)
	pikapic_setduration 44
	pikapic_loadgfx Pic_e411c
	pikapic_loadgfx GFX_e41d2
	pikapic_object $4, $80, $0, $0
	pikapic_object $7, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe2ba: ; fe2ba (3f:62ba)
	pikapic_waitbgmap
	pikapic_jump Data_fe2ba

Data_fe2be: ; fe2be (3f:62be)
	pikapic_setduration 80
	pikapic_loadgfx Pic_e4272
	pikapic_loadgfx GFX_e4323
	pikapic_object $4, $80, $0, $0
	pikapic_object $8, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe2d4: ; fe2d4 (3f:62d4)
	pikapic_waitbgmap
	pikapic_jump Data_fe2d4

Data_fe2d8: ; fe2d8 (3f:62d8)
	pikapic_setduration 70
	pikapic_loadgfx Pic_e4383
	pikapic_loadgfx GFX_e444b
	pikapic_object $4, $80, $0, $0
	pikapic_object $9, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe2ee: ; fe2ee (3f:62ee)
	pikapic_waitbgmap
	pikapic_jump Data_fe2ee

Data_fe2f2: ; fe2f2 (3f:62f2)
	pikapic_setduration 32
	pikapic_loadgfx Pic_e458b
	pikapic_loadgfx GFX_e463b
	pikapic_object $4, $80, $0, $0
	pikapic_object $a, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe308: ; fe308 (3f:6308)
	pikapic_waitbgmap
	pikapic_jump Data_fe308

Data_fe30c: ; fe30c (3f:630c)
	pikapic_setduration 50
	pikapic_loadgfx Pic_e467b
	pikapic_loadgfx GFX_e472e
	pikapic_object $4, $80, $0, $0
	pikapic_object $b, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry38
Data_fe322: ; fe322 (3f:6322)
	pikapic_waitbgmap
	pikapic_jump Data_fe322

Data_fe326: ; fe326 (3f:6326)
	pikapic_setduration 58
	pikapic_loadgfx Pic_e476e
	pikapic_loadgfx GFX_e4841
	pikapic_object $4, $80, $0, $0
	pikapic_object $c, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe33c: ; fe33c (3f:633c)
	pikapic_waitbgmap
	pikapic_jump Data_fe33c

Data_fe340: ; fe340 (3f:6340)
	pikapic_setduration 44
	pikapic_loadgfx Pic_e49d1
	pikapic_loadgfx GFX_e4a99
	pikapic_object $4, $80, $0, $0
	pikapic_object $d, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe356: ; fe356 (3f:6356)
	pikapic_waitbgmap
	pikapic_jump Data_fe356

Data_fe35a: ; fe35a (3f:635a)
	pikapic_setduration 56
	pikapic_loadgfx Pic_e4b39
	pikapic_loadgfx GFX_e4bde
	pikapic_object $4, $80, $0, $0
	pikapic_object $e, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe370: ; fe370 (3f:6370)
	pikapic_waitbgmap
	pikapic_jump Data_fe370

Data_fe374: ; fe374 (3f:6374)
	pikapic_setduration 56
	pikapic_loadgfx Pic_e4c3e
	pikapic_loadgfx GFX_e4ce0
	pikapic_loadgfx GFX_e4e70
	pikapic_object $4, $80, $0, $0
	pikapic_object $10, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe38c: ; fe38c (3f:638c)
	pikapic_waitbgmap
	pikapic_jump Data_fe38c

Data_fe390: ; fe390 (3f:6390)
	pikapic_setduration 100
	pikapic_loadgfx Pic_e5000
	pikapic_loadgfx GFX_e50af
	pikapic_object $4, $80, $0, $0
	pikapic_object $11, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe3a6: ; fe3a6 (3f:63a6)
	pikapic_waitbgmap
	pikapic_jump Data_fe3a6

Data_fe3aa: ; fe3aa (3f:63aa)
	pikapic_setduration 50
	pikapic_loadgfx Pic_e523f
	pikapic_loadgfx GFX_e52fe
	pikapic_object $4, $80, $0, $0
	pikapic_object $12, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry25
Data_fe3c0: ; fe3c0 (3f:63c0)
	pikapic_waitbgmap
	pikapic_jump Data_fe3c0

Data_fe3c4: ; fe3c4 (3f:63c4)
	pikapic_setduration 50
	pikapic_loadgfx Pic_e548e
	pikapic_loadgfx GFX_e5541
	pikapic_object $4, $80, $0, $0
	pikapic_object $13, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe3da: ; fe3da (3f:63da)
	pikapic_waitbgmap
	pikapic_jump Data_fe3da

Data_fe3de: ; fe3de (3f:63de)
	pikapic_setduration 40
	pikapic_loadgfx Pic_e56d1
	pikapic_loadgfx GFX_e5794
	pikapic_object $4, $80, $0, $0
	pikapic_object $14, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe3f4: ; fe3f4 (3f:63f4)
	pikapic_waitbgmap
	pikapic_jump Data_fe3f4

Data_fe3f8: ; fe3f8 (3f:63f8)
	pikapic_setduration 50
	pikapic_loadgfx Pic_e5924
	pikapic_loadgfx GFX_e59ed
	pikapic_object $4, $80, $0, $0
	pikapic_object $15, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe40e: ; fe40e (3f:640e)
	pikapic_waitbgmap
	pikapic_jump Data_fe40e

Data_fe412: ; fe412 (3f:6412)
	pikapic_setduration 32
	pikapic_loadgfx Pic_e5b7d
	pikapic_loadgfx GFX_e5c4d
	pikapic_object $4, $80, $0, $0
	pikapic_object $16, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe428: ; fe428 (3f:6428)
	pikapic_waitbgmap
	pikapic_jump Data_fe428

Data_fe42c: ; fe42c (3f:642c)
	pikapic_setduration 100
	pikapic_loadgfx Pic_e5ddd
	pikapic_loadgfx GFX_e5e90
	pikapic_object $4, $80, $0, $0
	pikapic_object $17, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe442: ; fe442 (3f:6442)
	pikapic_waitbgmap
	pikapic_jump Data_fe442

Data_fe446: ; fe446 (3f:6446)
	pikapic_setduration 32
	pikapic_loadgfx GFX_e6020
	pikapic_loadgfx GFX_e61b0
	pikapic_object $5, $80, $0, $0
	pikapic_object $18, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry18
Data_fe45c: ; fe45c (3f:645c)
	pikapic_waitbgmap
	pikapic_jump Data_fe45c

Data_fe460: ; fe460 (3f:6460)
	pikapic_setduration 44
	pikapic_loadgfx Pic_e6340
	pikapic_loadgfx GFX_e63f7
	pikapic_object $4, $80, $0, $0
	pikapic_object $19, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe476: ; fe476 (3f:6476)
	pikapic_waitbgmap
	pikapic_jump Data_fe476

Data_fe47a: ; fe47a (3f:647a)
	pikapic_setduration 50
	pikapic_loadgfx Pic_e6587
	pikapic_loadgfx GFX_e6646
	pikapic_object $4, $80, $0, $0
	pikapic_object $1a, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe490: ; fe490 (3f:6490)
	pikapic_waitbgmap
	pikapic_jump Data_fe490

Data_fe494: ; fe494 (3f:6494)
	pikapic_setduration 40
	pikapic_loadgfx Pic_e67d6
	pikapic_loadgfx GFX_e682f
	pikapic_loadgfx GFX_e69bf
	pikapic_loadgfx GFX_e6b4f
	pikapic_loadgfx GFX_e6cdf
	pikapic_object $4, $80, $0, $0
	pikapic_object $1b, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry20
Data_fe4b0: ; fe4b0 (3f:64b0)
	pikapic_waitbgmap
	pikapic_jump Data_fe4b0

Data_fe4b4: ; fe4b4 (3f:64b4)
	pikapic_setduration 40
	pikapic_loadgfx GFX_e6e6f
	pikapic_loadgfx GFX_e6fff
	pikapic_object $5, $80, $0, $0
	pikapic_object $1c, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe4ca: ; fe4ca (3f:64ca)
	pikapic_waitbgmap
	pikapic_jump Data_fe4ca

Data_fe4ce: ; fe4ce (3f:64ce)
	pikapic_setduration 70
	pikapic_loadgfx GFX_e718f
	pikapic_loadgfx GFX_e731f
	pikapic_object $5, $80, $0, $0
	pikapic_object $1d, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe4e4: ; fe4e4 (3f:64e4)
	pikapic_waitbgmap
	pikapic_jump Data_fe4e4

Data_fe4e8: ; fe4e8 (3f:64e8)
	pikapic_setduration 60
	pikapic_loadgfx GFX_e74af
	pikapic_loadgfx GFX_e763f
	pikapic_object $5, $80, $0, $0
	pikapic_object $1e, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe4fe: ; fe4fe (3f:64fe)
	pikapic_waitbgmap
	pikapic_jump Data_fe4fe

Data_fe502: ; fe502 (3f:6502)
	pikapic_setduration 50
	pikapic_loadgfx Pic_e77cf
	pikapic_loadgfx GFX_e7863
	pikapic_loadgfx GFX_e79f3
	pikapic_object $4, $80, $0, $0
	pikapic_object $1f, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_writebyte 13
	pikapic_waitbgmap
	pikapic_thunderbolt
	pikapic_ret

Data_fe51f: ; fe51f (3f:651f)
	pikapic_waitbgmap
Data_fe520: ; fe520 (3f:6520)
	pikapic_setduration 100
	pikapic_loadgfx Pic_e5000
	pikapic_loadgfx GFX_e50af
	pikapic_loadgfx GFX_e7b83
	pikapic_loadgfx GFX_e7d13
	pikapic_object $4, $80, $0, $0
	pikapic_object $20, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe53a: ; fe53a (3f:653a)
	pikapic_waitbgmap
	pikapic_jump Data_fe53a

Data_fe53e: ; fe53e (3f:653e)
	pikapic_setduration 30
	pikapic_loadgfx Pic_f0abf
	pikapic_loadgfx GFX_f0b64
	pikapic_object $4, $80, $0, $0
	pikapic_object $21, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe554: ; fe554 (3f:6554)
	pikapic_waitbgmap
	pikapic_jump Data_fe554

Data_fe558: ; fe558 (3f:6558)
	pikapic_setduration 64
	pikapic_loadgfx Pic_f0cf4
	pikapic_loadgfx GFX_f0d82
	pikapic_object $4, $80, $0, $0
	pikapic_object $22, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe56e: ; fe56e (3f:656e)
	pikapic_waitbgmap
	pikapic_jump Data_fe56e

PikaPicAnimGFXHeaders:
pikapicanimgfx: MACRO
\2_id::
	db \1
	dba \2
	endm

	dbbw $01, $39, $0000
	pikapicanimgfx -1, Pic_e4000     ; 01
	pikapicanimgfx  5, GFX_e40cc     ; 02
	pikapicanimgfx -1, Pic_e411c     ; 03
	pikapicanimgfx 10, GFX_e41d2     ; 04
	pikapicanimgfx -1, Pic_e4272     ; 05
	pikapicanimgfx  6, GFX_e4323     ; 06
	pikapicanimgfx -1, Pic_e4383     ; 07
	pikapicanimgfx 20, GFX_e444b     ; 08
	pikapicanimgfx -1, Pic_e458b     ; 09
	pikapicanimgfx  4, GFX_e463b     ; 0a
	pikapicanimgfx -1, Pic_e467b     ; 0b
	pikapicanimgfx  4, GFX_e472e     ; 0c
	pikapicanimgfx -1, Pic_e476e     ; 0d
	pikapicanimgfx 25, GFX_e4841     ; 0e
	pikapicanimgfx -1, Pic_e49d1     ; 0f
	pikapicanimgfx 10, GFX_e4a99     ; 00
	pikapicanimgfx -1, Pic_e4b39     ; 11
	pikapicanimgfx  6, GFX_e4bde     ; 12
	pikapicanimgfx -1, Pic_e4c3e     ; 13
	pikapicanimgfx 25, GFX_e4ce0     ; 14
	pikapicanimgfx 25, GFX_e4e70     ; 15
	pikapicanimgfx -1, Pic_e5000     ; 16
	pikapicanimgfx 25, GFX_e50af     ; 17
	pikapicanimgfx -1, Pic_e523f     ; 18
	pikapicanimgfx 25, GFX_e52fe     ; 19
	pikapicanimgfx -1, Pic_e548e     ; 1a
	pikapicanimgfx 25, GFX_e5541     ; 1b
	pikapicanimgfx -1, Pic_e56d1     ; 1c
	pikapicanimgfx 25, GFX_e5794     ; 1d
	pikapicanimgfx -1, Pic_e5924     ; 1e
	pikapicanimgfx 25, GFX_e59ed     ; 1f
	pikapicanimgfx -1, Pic_e5b7d     ; 20
	pikapicanimgfx 25, GFX_e5c4d     ; 21
	pikapicanimgfx -1, Pic_e5ddd     ; 22
	pikapicanimgfx 25, GFX_e5e90     ; 23
	pikapicanimgfx 25, GFX_e6020     ; 24
	pikapicanimgfx 25, GFX_e61b0     ; 25
	pikapicanimgfx -1, Pic_e6340     ; 26
	pikapicanimgfx 25, GFX_e63f7     ; 27
	pikapicanimgfx -1, Pic_e6587     ; 28
	pikapicanimgfx 25, GFX_e6646     ; 29
	pikapicanimgfx -1, Pic_e67d6     ; 2a
	pikapicanimgfx 25, GFX_e682f     ; 2b
	pikapicanimgfx 25, GFX_e69bf     ; 2c
	pikapicanimgfx 25, GFX_e6b4f     ; 2d
	pikapicanimgfx 25, GFX_e6cdf     ; 2e
	pikapicanimgfx 25, GFX_e6e6f     ; 2f
	pikapicanimgfx 25, GFX_e6fff     ; 30
	pikapicanimgfx 25, GFX_e718f     ; 31
	pikapicanimgfx 25, GFX_e731f     ; 32
	pikapicanimgfx 25, GFX_e74af     ; 33
	pikapicanimgfx 25, GFX_e763f     ; 34
	pikapicanimgfx -1, Pic_e77cf     ; 35
	pikapicanimgfx 25, GFX_e7863     ; 36
	pikapicanimgfx 25, GFX_e79f3     ; 37
	pikapicanimgfx 25, GFX_e7b83     ; 38
	pikapicanimgfx 25, GFX_e7d13     ; 39
	pikapicanimgfx -1, Pic_f0abf     ; 3a
	pikapicanimgfx 25, GFX_f0b64     ; 3b
	pikapicanimgfx -1, Pic_f0cf4     ; 3c
	pikapicanimgfx 25, GFX_f0d82     ; 3d
	pikapicanimgfx 24, PikachuSprite ; 3e
