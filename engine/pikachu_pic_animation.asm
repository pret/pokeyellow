Func_fd004:: ; fd004 (3f:5004)
	call Func_fd05e
	jr c, asm_fd00f
	call GetPikaPicAnimationScriptIndex
	call Func_fcffb
asm_fd00f: ; fd00f (3f:500f)
	ld [wExpressionNumber], a
	ld hl, PikachuEmotionTable
	call DoStarterPikachuEmotions
	ret
	
PikachuEmotionTable: ; fd019 (3f:4019)
	dw PikachuEmotion0_fd115
	dw PikachuEmotion1_fd141
	dw PikachuEmotion2_fd116
	dw PikachuEmotion3_fd160
	dw PikachuEmotion4_fd136
	dw PikachuEmotion5_fd14d
	dw PikachuEmotion6_fd153
	dw PikachuEmotion7_fd128
	dw PikachuEmotion8_fd147
	dw PikachuEmotion9_fd166
	dw PikachuEmotion10_fd11e
	dw PikachuEmotion11_fd173
	dw PikachuEmotion12_fd17a
	dw PikachuEmotion13_fd180
	dw PikachuEmotion14_fd189
	dw PikachuEmotion15_fd191
	dw PikachuEmotion16_fd197
	dw PikachuEmotion17_fd19d
	dw PikachuEmotion18_fd1a3
	dw PikachuEmotion19_fd1a9
	dw PikachuEmotion20_fd1b1
	dw PikachuEmotion21_fd1b9
	dw PikachuEmotion22_fd1c1
	dw PikachuEmotion23_fd1c7
	dw PikachuEmotion24_fd1cf
	dw PikachuEmotion25_fd1d7
	dw PikachuEmotion26_fd1df
	dw PikachuEmotion27_fd1eb
	dw PikachuEmotion28_fd1f1
	dw PikachuEmotion29_fd1f7
	dw PikachuEmotion30_fd1fc
	dw PikachuEmotion31_fd20a
	dw PikachuEmotion32_fd213
	dw PikachuEmotion33_fd05d
	
PikachuEmotion33_fd05d: ; fd05d (3f:505d)
	db $ff
	
Func_fd05e: ; fd05e (3f:505e)
	ld a, [wCurMap]
	cp POKEMON_FAN_CLUB
	jr nz, .notFanClub
	ld hl, wPreventBlackout
	bit 7, [hl]
	ld a, $1d
	jr z, .asm_fd0c9
	call Func_154a
	ld a, $1e
	jr nz, .asm_fd0c9
	jr .asm_fd096
.notFanClub
	ld a, [wCurMap]
	cp PEWTER_POKECENTER
	jr nz, .notPewterPokecenter
	call Func_154a
	ld a, $1a
	jr nz, .asm_fd0c9
	jr .asm_fd096
.notPewterPokecenter
	callab Func_f24ae
	ld a, e
	cp $ff
	jr nz, .asm_fd0c9
	jr .asm_fd096
.asm_fd096
	call IsPlayerPikachuAsleepInParty
	ld a, $b
	jr c, .asm_fd0c9
	callab Func_fce73 ; same bank
	ld a, $1c
	jr c, .asm_fd0c9
	ld a, [wCurMap]
	cp POKEMONTOWER_1
	jr c, .notInLavenderTower
	cp POKEMONTOWER_7 + 1
	ld a, $16
	jr c, .asm_fd0c9
.notInLavenderTower
	ld a, [wd49c]
	and a
	jr z, .asm_fd0c7
	dec a
	ld c, a
	ld b, $0
	ld hl, Pointer_fd0cb
	add hl, bc
	ld a, [hl]
	jr .asm_fd0c9
.asm_fd0c7
	and a
	ret
.asm_fd0c9
	scf
	ret
	
Pointer_fd0cb:
	db $12, $15, $17, $18, $19
	
IsPlayerPikachuAsleepInParty:: ; fd0d0 (3f:50d0)
	xor a
	ld [wWhichPokemon], a
.loop
	ld a, [wWhichPokemon]
	ld c, a
	ld b, $0
	ld hl, wPartySpecies
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, .done
	cp PIKACHU
	jr nz, .curMonNotStarterPikachu
	callab IsThisPartymonStarterPikachu
	jr nc, .curMonNotStarterPikachu
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1Status
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a, [hl]
	and SLP
	jr z, .done
	jr .curMonSleepingPikachu
.curMonNotStarterPikachu
	ld a, [wWhichPokemon]
	cp PARTY_LENGTH - 1
	jr z, .done
	inc a
	ld [wWhichPokemon], a
	jr .loop
.curMonSleepingPikachu
	scf
	ret
.done
	and a
	ret
	
PikachuEmotion0_fd115: ; fd115 (3f:5115)
	db $ff

PikachuEmotion2_fd116: ; fd116 (3f:5116)
	pikaemotion_dummy2
	pikaemotion_emotebubble SMILE_BUBBLE
	pikaemotion_pcm $22
	pikaemotion_5 $2
	db $ff

PikachuEmotion10_fd11e: ; fd11e (3f:511e)
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_emotebubble HEART_BUBBLE
	pikaemotion_pcm $4
	pikaemotion_5 $a
	db $ff

PikachuEmotion7_fd128: ; fd128 (3f:5128)
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_4 Pointer_fd224
	pikaemotion_pcm $0
	pikaemotion_4 Pointer_fd224
	pikaemotion_5 $7
	db $ff

PikachuEmotion4_fd136: ; fd136 (3f:5136)
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_4 Pointer_fd230
	pikaemotion_pcm $1c
	pikaemotion_5 $4
	db $ff

PikachuEmotion1_fd141: ; fd141 (3f:5141)
	pikaemotion_dummy2
	pikaemotion_pcm $ff
	pikaemotion_5 $1
	db $ff

PikachuEmotion8_fd147: ; fd147 (3f:5147)
	pikaemotion_dummy2
	pikaemotion_pcm $26
	pikaemotion_5 $8
	db $ff

PikachuEmotion5_fd14d: ; fd14d (3f:514d)
	pikaemotion_dummy2
	pikaemotion_pcm $1e
	pikaemotion_5 $5
	db $ff

PikachuEmotion6_fd153: ; fd153 (3f:5153)
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_pcm $ff
	pikaemotion_4 Pointer_fd21e
	pikaemotion_emotebubble SKULL_BUBBLE
	pikaemotion_5 $6
	db $ff

PikachuEmotion3_fd160: ; fd160 (3f:5160)
	pikaemotion_dummy2
	pikaemotion_pcm $27
	pikaemotion_5 $3
	db $ff

PikachuEmotion9_fd166: ; fd166 (3f:5166)
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_pcm $5
	pikaemotion_4 Pointer_fd218
	pikaemotion_emotebubble SKULL_BUBBLE
	pikaemotion_5 $9
	db $ff

PikachuEmotion11_fd173: ; fd173 (3f:5173)
	pikaemotion_emotebubble ZZZ_BUBBLE
	pikaemotion_pcm $24
	pikaemotion_5 $b
	db $ff

PikachuEmotion12_fd17a: ; fd17a (3f:517a)
	pikaemotion_dummy2
	pikaemotion_pcm $ff
	pikaemotion_5 $c
	db $ff

PikachuEmotion13_fd180: ; fd180 (3f:5180)
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_4 Pointer_fd21e
	pikaemotion_5 $d
	db $ff

PikachuEmotion14_fd189: ; fd189 (3f:5189)
	pikaemotion_dummy2
	pikaemotion_emotebubble BOLT_BUBBLE
	pikaemotion_pcm $9
	pikaemotion_5 $e
	db $ff

PikachuEmotion15_fd191: ; fd191 (3f:5191)
	pikaemotion_dummy2
	pikaemotion_pcm $21
	pikaemotion_5 $f
	db $ff

PikachuEmotion16_fd197: ; fd197 (3f:5197)
	pikaemotion_dummy2
	pikaemotion_pcm $20
	pikaemotion_5 $10
	db $ff

PikachuEmotion17_fd19d: ; fd19d (3f:519d)
	pikaemotion_dummy2
	pikaemotion_pcm $c
	pikaemotion_5 $11
	db $ff

PikachuEmotion18_fd1a3: ; fd1a3 (3f:51a3)
	pikaemotion_dummy2
	pikaemotion_pcm $ff
	pikaemotion_5 $12
	db $ff

PikachuEmotion19_fd1a9: ; fd1a9 (3f:51a9)
	pikaemotion_dummy2
	pikaemotion_emotebubble HEART_BUBBLE
	pikaemotion_pcm $20
	pikaemotion_5 $13
	db $ff

PikachuEmotion20_fd1b1: ; fd1b1 (3f:51b1)
	pikaemotion_dummy2
	pikaemotion_emotebubble HEART_BUBBLE
	pikaemotion_pcm $4
	pikaemotion_5 $14
	db $ff

PikachuEmotion21_fd1b9: ; fd1b9 (3f:51b9)
	pikaemotion_dummy2
	pikaemotion_emotebubble FISH_BUBBLE
	pikaemotion_pcm $ff
	pikaemotion_5 $15
	db $ff

PikachuEmotion22_fd1c1: ; fd1c1 (3f:51c1)
	pikaemotion_dummy2
	pikaemotion_pcm $3
	pikaemotion_5 $16
	db $ff

PikachuEmotion23_fd1c7: ; fd1c7 (3f:51c7)
	pikaemotion_dummy2
	pikaemotion_pcm $12
	pikaemotion_5 $17
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_SHOWMAPVIEW
	db $ff

PikachuEmotion24_fd1cf: ; fd1cf (3f:51cf)
	pikaemotion_dummy2
	pikaemotion_emotebubble EXCLAMATION_BUBBLE
	pikaemotion_pcm $ff
	pikaemotion_5 $18
	db $ff

PikachuEmotion25_fd1d7: ; fd1d7 (3f:51d7)
	pikaemotion_dummy2
	pikaemotion_emotebubble BOLT_BUBBLE
	pikaemotion_pcm $22
	pikaemotion_5 $19
	db $ff

PikachuEmotion26_fd1df: ; fd1df (3f:51df)
	pikaemotion_dummy2
	pikaemotion_emotebubble ZZZ_BUBBLE
	pikaemotion_pcm $24
	pikaemotion_5 $1a
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_SHOWMAPVIEW
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_CHECKPEWTERCENTER
	db $ff

PikachuEmotion27_fd1eb: ; fd1eb (3f:51eb)
	pikaemotion_dummy2
	pikaemotion_pcm $8
	pikaemotion_5 $1b
	db $ff

PikachuEmotion28_fd1f1: ; fd1f1 (3f:51f1)
	pikaemotion_dummy2
	pikaemotion_pcm $e
	pikaemotion_5 $1c
	db $ff

PikachuEmotion29_fd1f7: ; fd1f7 (3f:51f7)
	pikaemotion_pcm $4
	pikaemotion_5 $a
	db $ff

PikachuEmotion30_fd1fc: ; fd1fc (3f:51fc)
	pikaemotion_9
	pikaemotion_emotebubble HEART_BUBBLE
	pikaemotion_pcm $4
	pikaemotion_5 $14
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_SHOWMAPVIEW
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADFONT
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_CHECKLAVENDERTOWER
	db $ff

PikachuEmotion31_fd20a: ; fd20a (3f:520a)
	pikaemotion_pcm $12
	pikaemotion_5 $17
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_SHOWMAPVIEW
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_CHECKBILLSHOUSE
	db $ff

PikachuEmotion32_fd213: ; fd213 (3f:5213)
	pikaemotion_pcm $19
	pikaemotion_5 $17
	db $ff

Pointer_fd218: ; fd218 (3f:5218)

	db $00
	db $39, $01
	db $3e, $1e
	db $3f

Pointer_fd21e: ; fd21e (3f:521e)
	db $00
	db $39, $00
	db $3e, $1e
	db $3f

Pointer_fd224: ; fd224 (3f:5224)
	db $00
	db $3c, $07, $2f
	db $3c, $07, $2f
	db $3f

Pointer_fd22c: ; fd22c (3f:522c)
	db $3b, $1f, $03
	db $3f

Pointer_fd230: ; fd230 (3f:5230)
	db $00
	db $3c, $0f, $1f
	db $3c, $0f, $1f
	db $3f

Pointer_fd238: ; fd238 (3f:5238)
	db $00
	db $05, $07
	db $39, $00
	db $05, $07
	db $06, $07
	db $39, $00
	db $06, $07
	db $08, $07
	db $39, $00
	db $08, $07
	db $07, $07
	db $39, $00
	db $07, $07
	db $3f

Func_fd252: ; fd252 (3f:5252)
	ld a, $40
	ld [h_0xFFFC], a
	call LoadPikachuSpriteIntoVRAM
	call Func_fd266
	and a
	jr z, .asm_fd262
	call Func_159b
.asm_fd262
	xor a
	ld [h_0xFFFC], a
	ret

Func_fd266:
	ld a, [wSpriteStateData2 + 15 * 16 + 4]
	ld e, a
	ld a, [wSpriteStateData2 + 15 * 16 + 5]
	ld d, a
	ld a, [wYCoord]
	add 4
	cp e
	jr z, .asm_fd280
	jr nc, .asm_fd27e
	ld hl, Data_fd294
	ld a, 1
	ret

.asm_fd27e
	xor a
	ret

.asm_fd280
	ld a, [wXCoord]
	add 4
	cp d
	jr c, .asm_fd28e
	ld hl, Data_fd299
	ld a, 2
	ret

.asm_fd28e
	ld hl, Data_fd29d
	ld a, 3
	ret

Data_fd294:
	db $00
	db $36
	db $2b
	db $34
	db $3f

Data_fd299:
	db $00
	db $36
	db $34
	db $3f

Data_fd29d:
	db $00
	db $36
	db $33
	db $3f

Func_fd2a1:: ; fd2a1 (3f:52a1)
	ld a, b
	ld [wd44a], a
	ld a, l
	ld [wd44b], a
	ld a, h
	ld [wd44b + 1], a
	call PikachuSwapSpriteStateData
.loop
	call Func_fd2f5
	jr nc, .done
	call Func_fd329
	jr .loop

.done
	call PikachuSwapSpriteStateData
	call DelayFrame
	ret

PikachuSwapSpriteStateData:
	ld a, [wUpdateSpritesEnabled]
	push af
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	push hl
	push de
	push bc

	ld hl, wSpriteStateData1
	ld de, wSpriteStateData1 + $f0
	ld c, $10
	call SwapBytes3f

	ld hl, wSpriteStateData2
	ld de, wSpriteStateData2 + $f0
	ld c, $10
	call SwapBytes3f

	pop bc
	pop de
	pop hl
	pop af
	ld [wUpdateSpritesEnabled], a
	ret

SwapBytes3f:
.loop
	ld b, [hl]
	ld a, [de]
	ld [hli], a
	ld a, b
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ret

Func_fd2f5:
	call Func_157c
	cp $3f
	ret z
	ld c, a
	ld b, 0
	ld hl, Data_fd3b0
	add hl, bc
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld [wPikaPicAnimPointer + 1], a
	ld a, [hli]
	cp $80
	jr nz, .asm_fd311
	call Func_157c
.asm_fd311
	ld [wPikaPicAnimPointer], a
	ld a, [hli]
	ld [wPikaPicAnimCurGraphicID], a
	ld a, [hli]
	cp $80
	jr nz, .asm_fd320
	call Func_157c
.asm_fd320
	ld [wPikaPicAnimPointerSetupFinished], a
	xor a
	ld [wPikaPicAnimTimer], a
	scf
	ret

Func_fd329:
	xor a
	ld [$d44c], a
	ld [wd457], a
	ld [wd458], a
	ld a, [wSpriteStateData2 + 7]
	push af
.asm_fd337
	ld bc, wSpriteStateData1
	ld a, [wPikaPicAnimPointer + 1]
	ld hl, Jumptable_fd4ac
	call Func_fd365
	ld a, [wPikaPicAnimCurGraphicID]
	ld hl, Jumptable_fd65c
	call Func_fd365
	call Func_fd36e
	call Func_fd39d
	call DelayFrame
	call DelayFrame
	ld hl, $d44c
	bit 7, [hl]
	jr z, .asm_fd337
	pop af
	ld [wSpriteStateData2 + 7], a
	scf
	ret

Func_fd365:
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

Func_fd36e:
	ld hl, 2
	add hl, bc
	ld a, [wPikaPicAnimTimer + 1]
	ld [hl], a
	ld a, [wPikaSpriteY]
	ld d, a
	ld a, [wd456]
	add d
	ld hl, 4
	add hl, bc
	ld [hl], a
	ld a, [wPikaPicAnimDelay]
	ld d, a
	ld a, [wPikaPicTextboxStartY]
	add d
	ld hl, 6
	add hl, bc
	ld [hl], a
	ld hl, $d44c
	bit 6, [hl]
	ret z
	ld hl, wSpriteStateData2 + 7 - wSpriteStateData1
	add hl, bc
	ld [hl], 0
	ret

Func_fd39d:
	ld hl, $d44c
	bit 6, [hl]
	res 6, [hl]
	ld hl, wd736
	res 6, [hl]
	ret z
	set 6, [hl]
	call Func_fd7f3
	ret

Data_fd3b0:
	db $01, $00, $00, $00 ; $00
	db $03, $80, $01, $00 ; $01
	db $04, $80, $01, $00 ; $02
	db $05, $80, $01, $00 ; $03
	db $06, $80, $01, $00 ; $04
	db $07, $80, $01, $00 ; $05
	db $08, $80, $01, $00 ; $06
	db $09, $80, $01, $00 ; $07
	db $0a, $80, $01, $00 ; $08
	db $03, $80, $06, $00 ; $09
	db $04, $80, $06, $00 ; $0a
	db $05, $80, $06, $00 ; $0b
	db $06, $80, $06, $00 ; $0c
	db $07, $80, $06, $00 ; $0d
	db $08, $80, $06, $00 ; $0e
	db $09, $80, $06, $00 ; $0f
	db $0a, $80, $06, $00 ; $10
	db $03, $80, $03, $80 ; $11
	db $04, $80, $03, $80 ; $12
	db $05, $80, $03, $80 ; $13
	db $06, $80, $03, $80 ; $14
	db $07, $80, $03, $80 ; $15
	db $08, $80, $03, $80 ; $16
	db $09, $80, $03, $80 ; $17
	db $0a, $80, $03, $80 ; $18
	db $03, $80, $07, $80 ; $19
	db $04, $80, $07, $80 ; $1a
	db $05, $80, $07, $80 ; $1b
	db $06, $80, $07, $80 ; $1c
	db $0b, $27, $02, $00 ; $1d
	db $0c, $27, $02, $00 ; $1e
	db $0d, $27, $02, $00 ; $1f
	db $0e, $27, $02, $00 ; $20
	db $0f, $27, $02, $00 ; $21
	db $10, $27, $02, $00 ; $22
	db $11, $27, $02, $00 ; $23
	db $12, $27, $02, $00 ; $24
	db $0b, $0f, $02, $00 ; $25
	db $0c, $0f, $02, $00 ; $26
	db $0d, $0f, $02, $00 ; $27
	db $0e, $0f, $02, $00 ; $28
	db $0f, $0f, $02, $00 ; $29
	db $10, $0f, $02, $00 ; $2a
	db $11, $0f, $02, $00 ; $2b
	db $12, $0f, $02, $00 ; $2c
	db $0b, $0f, $08, $17 ; $2d
	db $0c, $0f, $08, $17 ; $2e
	db $0d, $0f, $08, $17 ; $2f
	db $0e, $0f, $08, $17 ; $30
	db $0f, $0f, $08, $17 ; $31
	db $10, $0f, $08, $17 ; $32
	db $11, $0f, $08, $17 ; $33
	db $12, $0f, $08, $17 ; $34
	db $13, $0f, $06, $00 ; $35
	db $14, $0f, $06, $00 ; $36
	db $15, $0f, $06, $00 ; $37
	db $16, $0f, $06, $00 ; $38
	db $02, $80, $04, $00 ; $39
	db $02, $80, $05, $00 ; $3a
	db $02, $80, $03, $80 ; $3b
	db $02, $80, $07, $80 ; $3c
	db $02, $80, $09, $80 ; $3d
	db $02, $80, $06, $00 ; $3e

Jumptable_fd4ac:
	dw Func_fd4e5
 	dw Func_fd4e9
 	dw Func_fd504
 	dw Func_fd50c
 	dw Func_fd511
 	dw Func_fd518
 	dw Func_fd52c
 	dw Func_fd540
 	dw Func_fd553
 	dw Func_fd566
 	dw Func_fd579
 	dw Func_fd5b1
 	dw Func_fd5b5
 	dw Func_fd5b9
 	dw Func_fd5bd
 	dw Func_fd5c1
 	dw Func_fd5c5
 	dw Func_fd5c9
 	dw Func_fd5cd
 	dw Func_fd5ea
 	dw Func_fd5ee
 	dw Func_fd5f2
 	dw Func_fd5f6
 	dw Func_fd4e5

Func_fd4dc:
	ld a, [$d44c]
	set 7, a
	ld [$d44c], a
	ret

Func_fd4e5:
	call Func_fd4dc
	ret

Func_fd4e9:
	ld hl, 4
	add hl, bc
	ld a, [hl]
	ld [wPikaSpriteY], a
	ld hl, 6
	add hl, bc
	ld a, [hl]
	ld [wPikaPicAnimDelay], a
	xor a
	ld [wd456], a
	ld [wPikaPicTextboxStartY], a
	call Func_fd4dc
	ret

Func_fd504:
	call Func_fd775
	ret nz
	call Func_fd4dc
	ret

Func_fd50c:
	call GetObjectFacing
	jr asm_fd58c

Func_fd511:
	call GetObjectFacing
	xor %100
	jr asm_fd58c

Func_fd518:
	call GetObjectFacing
	ld hl, Data_fd523
	call Func_fd5a0
	jr asm_fd58c

Data_fd523:
	db SPRITE_FACING_DOWN,  SPRITE_FACING_RIGHT
	db SPRITE_FACING_UP,    SPRITE_FACING_LEFT
	db SPRITE_FACING_LEFT,  SPRITE_FACING_DOWN
	db SPRITE_FACING_RIGHT, SPRITE_FACING_UP
	db $ff

Func_fd52c:
	call GetObjectFacing
	ld hl, Data_fd537
	call Func_fd5a0
	jr asm_fd58c

Data_fd537:
	db SPRITE_FACING_DOWN,  SPRITE_FACING_LEFT
	db SPRITE_FACING_UP,    SPRITE_FACING_RIGHT
	db SPRITE_FACING_LEFT,  SPRITE_FACING_UP
	db SPRITE_FACING_RIGHT, SPRITE_FACING_DOWN
	db $ff

Func_fd540:
	call GetObjectFacing
	ld hl, Data_fd54b
	call Func_fd5a0
	jr asm_fd58c

Data_fd54b:
	db SPRITE_FACING_DOWN,  SPRITE_FACING_UP | $10
	db SPRITE_FACING_UP,    SPRITE_FACING_LEFT | $10
	db SPRITE_FACING_LEFT,  SPRITE_FACING_DOWN | $10
	db SPRITE_FACING_RIGHT, SPRITE_FACING_RIGHT | $10

Func_fd553:
	call GetObjectFacing
	ld hl, Data_fd55e
	call Func_fd5a0
	jr asm_fd58c

Data_fd55e:
	db SPRITE_FACING_DOWN,  SPRITE_FACING_DOWN | $10
	db SPRITE_FACING_UP,    SPRITE_FACING_RIGHT | $10
	db SPRITE_FACING_LEFT,  SPRITE_FACING_LEFT | $10
	db SPRITE_FACING_RIGHT, SPRITE_FACING_UP | $10

Func_fd566:
	call GetObjectFacing
	ld hl, Data_fd571
	call Func_fd5a0
	jr asm_fd58c

Data_fd571:
	db SPRITE_FACING_DOWN,  SPRITE_FACING_RIGHT | $10
	db SPRITE_FACING_UP,    SPRITE_FACING_DOWN | $10
	db SPRITE_FACING_LEFT,  SPRITE_FACING_UP | $10
	db SPRITE_FACING_RIGHT, SPRITE_FACING_LEFT | $10

Func_fd579:
	call GetObjectFacing
	ld hl, Data_fd584
	call Func_fd5a0
	jr asm_fd58c

Data_fd584:
	db SPRITE_FACING_DOWN,  SPRITE_FACING_LEFT | $10
	db SPRITE_FACING_UP,    SPRITE_FACING_UP | $10
	db SPRITE_FACING_LEFT,  SPRITE_FACING_RIGHT | $10
	db SPRITE_FACING_RIGHT, SPRITE_FACING_DOWN | $10

asm_fd58c
	rrca
	rrca
	and $7
	ld e, a
	call Func_fd784
	ld d, a
	call UpdatePikachuPosition
	call Func_fd775
	ret nz
	call Func_fd4dc
	ret

Func_fd5a0:
	push de
	ld d, a
.asm_fd5a2
	ld a, [hli]
	cp d
	jr z, .asm_fd5ad
	inc hl
	cp $ff
	jr nz, .asm_fd5a2
	pop de
	ret

.asm_fd5ad
	ld a, [hl]
	pop de
	scf
	ret

Func_fd5b1:
	ld a, SPRITE_FACING_DOWN >> 2
	jr asm_fd5d1

Func_fd5b5:
	ld a, SPRITE_FACING_UP >> 2
	jr asm_fd5d1

Func_fd5b9:
	ld a, SPRITE_FACING_LEFT >> 2
	jr asm_fd5d1

Func_fd5bd:
	ld a, SPRITE_FACING_RIGHT >> 2
	jr asm_fd5d1

Func_fd5c1:
	ld e, 4
	jr asm_fd5d5

Func_fd5c5:
	ld e, 5
	jr asm_fd5d5

Func_fd5c9:
	ld e, 6
	jr asm_fd5d5

Func_fd5cd:
	ld e, 7
	jr asm_fd5d5

asm_fd5d1
	ld e, a
	call SetObjectFacing
asm_fd5d5
	call Func_fd784
	ld d, a
	push de
	call UpdatePikachuPosition
	pop de
	call Func_fd775
	ret nz
	ld a, e
	call Func_fd7cb
	call Func_fd4dc
	ret

Func_fd5ea:
	ld a, SPRITE_FACING_DOWN >> 2
	jr asm_fd5fa

Func_fd5ee:
	ld a, SPRITE_FACING_UP >> 2
	jr asm_fd5fa

Func_fd5f2:
	ld a, SPRITE_FACING_LEFT >> 2
	jr asm_fd5fa

Func_fd5f6:
	ld a, SPRITE_FACING_RIGHT >> 2
	jr asm_fd5fa

asm_fd5fa
	call SetObjectFacing
	call Func_fd4dc
	ret

UpdatePikachuPosition:
	push de
	ld d, 0
	ld hl, Jumptable_fd60f
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
	ld a, d
	jp [hl]

Jumptable_fd60f:
	dw MovePikachuSpriteDown
	dw MovePikachuSpriteUp
	dw MovePikachuSpriteLeft
	dw MovePikachuSpriteRight
	dw MovePikachuSpriteDownLeft
	dw MovePikachuSpriteDownRight
	dw MovePikachuSpriteUpLeft
	dw MovePikachuSpriteUpRight

MovePikachuSpriteDown:
	ld d, 0
	ld e, a
	jr asm_fd64d

MovePikachuSpriteUp:
	ld d, 0
	cpl
	inc a
	ld e, a
	jr asm_fd64d

MovePikachuSpriteLeft:
	cpl
	inc a
	ld d, a
	ld e, 0
	jr asm_fd64d

MovePikachuSpriteRight:
	ld d, a
	ld e, 0
	jr asm_fd64d

MovePikachuSpriteDownLeft:
	ld e, a
	cpl
	inc a
	ld d, a
	jr asm_fd64d

MovePikachuSpriteDownRight:
	ld e, a
	ld d, a
	jr asm_fd64d

MovePikachuSpriteUpLeft:
	cpl
	inc a
	ld e, a
	ld d, a
	jr asm_fd64d

MovePikachuSpriteUpRight:
	ld d, a
	cpl
	inc a
	ld e, a
	jr asm_fd64d

asm_fd64d
	ld a, [wPikaPicAnimDelay]
	add d
	ld [wPikaPicAnimDelay], a
	ld a, [wPikaSpriteY]
	add e
	ld [wPikaSpriteY], a
	ret

Jumptable_fd65c:
	dw Func_fd678
	dw Func_fd6a3
	dw Func_fd698
	dw Func_fd6f4
	dw Func_fd6ff
	dw Func_fd718
	dw Func_fd68c
	dw Func_fd6c6
	dw Func_fd6c0
	dw Func_fd6e2
	dw Func_fd68b

Func_fd672:
	ld hl, $d44c
	set 6, [hl]
	ret

Func_fd678:
	ld hl, 7
	add hl, bc
	xor a
	ld [hli], a
	ld [hl], a
	call Func_fd74a
	ld d, a
	call GetObjectFacing
	or d
	ld [wPikaPicAnimTimer + 1], a
	ret

Func_fd68b:
	ret

Func_fd68c:
	call Func_fd74a
	ld d, a
	call Func_fd755
	or d
	ld [wPikaPicAnimTimer + 1], a
	ret

Func_fd698:
	call Func_fd74a
	ld d, a
	call GetObjectFacing
	or d
	ld d, a
	jr asm_fd6ac

Func_fd6a3:
	call Func_fd74a
	ld d, a
	call Func_fd755
	or d
	ld d, a
asm_fd6ac
	ld hl, 8
	add hl, bc
	call Func_fd78e
	jr nz, .asm_fd6b6
	inc [hl]
.asm_fd6b6
	ld a, [hl]
	rrca
	rrca
	and 3
	or d
	ld [wPikaPicAnimTimer + 1], a
	ret

Func_fd6c0:
	call GetObjectFacing
	ld d, a
	jr asm_fd6ca

Func_fd6c6:
	call Func_fd755
	ld d, a
asm_fd6ca
	call Func_fd74a
	or d
	ld d, a
	call Func_fd736
	or d
	ld [wPikaPicAnimTimer + 1], a
	call Func_fd79d
	ld [wd456], a
	and a
	ret z
	call Func_fd672
	ret

Func_fd6e2:
	call GetObjectFacing
	ld d, a
	call Func_fd74a
	or d
	ld [wPikaPicAnimTimer + 1], a
	call Func_fd79d
	ld [wd456], a
	ret

Func_fd6f4:
	ld a, [wPikaPicAnimPointerSetupFinished]
	and $40
	cp $40
	jr z, Func_fd6ff
	jr Func_fd718

Func_fd6ff:
	call Func_fd755
	ld d, a
	call Func_fd78e
	jr nz, .asm_fd710
	ld hl, Data_fd731
.asm_fd70b
	ld a, [hli]
	cp d
	jr nz, .asm_fd70b
	ld d, [hl]
.asm_fd710
	call Func_fd74a
	or d
	ld [wPikaPicAnimTimer + 1], a
	ret

Func_fd718:
	call Func_fd755
	ld d, a
	call Func_fd78e
	jr nz, .asm_fd529
	ld hl, Data_fd731End
.asm_fd524
	ld a, [hld]
	cp d
	jr nz, .asm_fd524
	ld d, [hl]
.asm_fd529
	call Func_fd74a
	or d
	ld [wPikaPicAnimTimer + 1], a
	ret

Data_fd731:
	db SPRITE_FACING_DOWN
	db SPRITE_FACING_LEFT
	db SPRITE_FACING_UP
	db SPRITE_FACING_RIGHT
	db SPRITE_FACING_DOWN
Data_fd731End:

Func_fd736:
	push hl
	ld hl, 7
	add hl, bc
	ld a, [hl]
	inc a
	and $3
	ld [hli], a
	jr nz, .asm_fd747
	ld a, [hl]
	inc a
	and $3
	ld [hl], a
.asm_fd747
	ld a, [hl]
	pop hl
	ret

Func_fd74a:
	push hl
	ld hl, wSpriteStateData2 - wSpriteStateData1 + 14
	add hl, bc
	ld a, [hl]
	dec a
	swap a
	pop hl
	ret

Func_fd755:
	push hl
	ld hl, 2
	add hl, bc
	ld a, [hl]
	and $c
	pop hl
	ret

GetObjectFacing:
	push hl
	ld hl, 9
	add hl, bc
	ld a, [hl]
	and $c
	pop hl
	ret

SetObjectFacing:
	push hl
	ld hl, 9
	add hl, bc
	add a
	add a
	and $c
	ld [hl], a
	pop hl
	ret

Func_fd775:
	ld hl, wd457
	inc [hl]
	ld a, [wPikaPicAnimPointer]
	and $1f
	inc a
	cp [hl]
	ret nz
	ld [hl], 0
	ret

Func_fd784:
	ld a, [wPikaPicAnimPointer]
	swap a
	rrca
	and $3
	inc a
	ret

Func_fd78e:
	ld hl, wd458
	inc [hl]
	ld a, [wPikaPicAnimPointerSetupFinished]
	and $f
	inc a
	cp [hl]
	ret nz
	ld [hl], 0
	ret

Func_fd79d:
	call Func_fd7b2
	ld a, [wd458]
	add e
	ld [wd458], a
	add $20
	ld e, a
	push hl
	push bc
	call Sine_e
	pop bc
	pop hl
	ret

Func_fd7b2:
	ld a, [wPikaPicAnimPointerSetupFinished]
	and $f
	inc a
	ld d, a
	ld a, [wPikaPicAnimPointerSetupFinished]
	swap a
	and $7
	ld e, a
	ld a, 1
	jr z, .asm_fd7c9
.asm_fd7c5
	add a
	dec e
	jr nz, .asm_fd7c5
.asm_fd7c9
	ld e, a
	ret

Func_fd7cb:
	push bc
	ld c, a
	ld b, 0
	ld hl, Data_fd7e3
	add hl, bc
	add hl, bc
	ld d, [hl]
	inc hl
	ld e, [hl]
	pop bc
	ld hl, wSpriteStateData2 - wSpriteStateData1 + 4
	add hl, bc
	ld a, [hl]
	add e
	ld [hli], a
	ld a, [hl]
	add d
	ld [hl], a
	ret

Data_fd7e3:
	db  0,  1
	db  0, -1
	db -1,  0
	db  1,  0
	db -1,  1
	db  1,  1
	db -1, -1
	db  1, -1

Func_fd7f3:
	push bc
	push de
	push hl
	
	ld bc, wOAMBuffer + 4 * 36
	ld a, [wPikaSpriteY]
	ld e, a
	ld a, [wPikaPicAnimDelay]
	ld d, a
	ld hl, Data_fd80b
	call Func_fd814

	pop hl
	pop de
	pop bc
	ret

Data_fd80b:
	db $02
	db $0c, $00, $ff, 0
	db $0c, $08, $ff, 1 << OAM_X_FLIP

Func_fd814:
	ld a, e
	add $10
	ld e, a
	ld a, d
	add $8
	ld d, a
	ld a, [hli]
.asm_fd81d
	push af
	ld a, [hli]
	add e
	ld [bc], a
	inc bc
	ld a, [hli]
	add d
	ld [bc], a
	inc bc
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hli]
	ld [bc], a
	inc bc
	pop af
	dec a
	jr nz, .asm_fd81d
	ret

LoadPikachuShadowIntoVRAM:
	ld hl, vNPCSprites2 + $7f * $10
	ld de, LedgeHoppingShadowGFX_3F
	lb bc, BANK(LedgeHoppingShadowGFX_3F), (LedgeHoppingShadowGFX_3FEnd - LedgeHoppingShadowGFX_3F) / 8
	jp CopyVideoDataDoubleAlternate

LedgeHoppingShadowGFX_3F:
INCBIN "gfx/ledge_hopping_shadow.1bpp"
LedgeHoppingShadowGFX_3FEnd:

LoadPikachuBallIconIntoVRAM:
	ld hl, vNPCSprites2 + $7e * $10
	ld de, GFX_fd86b
	lb bc, BANK(GFX_fd86b), 1
	jp CopyVideoDataDoubleAlternate

Func_fd851:
	ld hl, vNPCSprites + $c * $10
	ld a, 3
.asm_fd856
	push af
	push hl
	ld de, GFX_fd86b
	lb bc, BANK(GFX_fd86b), 4
	call CopyVideoDataAlternate
	pop hl
	ld de, 4 * $10
	add hl, de
	pop af
	dec a
	jr nz, .asm_fd856
	ret

GFX_fd86b:
INCBIN "gfx/unknown_fd86b.2bpp"

LoadPikachuSpriteIntoVRAM: ; fd8ab (3f:58ab)
	ld de, PikachuSprite
	lb bc, BANK(PikachuSprite), (SandshrewSprite - PikachuSprite) / 32
	ld hl, vNPCSprites + $c * $10
	push bc
	call CopyVideoDataAlternate
	ld de, PikachuSprite + $c * $10
	ld hl, vNPCSprites2 + $c * $10
	ld a, [h_0xFFFC]
	and a
	jr z, .load
	ld de, PikachuSprite + $c * $10
	ld hl, vNPCSprites2 + $4c * $10
.load
	pop bc
	call CopyVideoDataAlternate
	call LoadPikachuShadowIntoVRAM
	call LoadPikachuBallIconIntoVRAM
	ret

PikachuPewterPokecenterCheck: ; fd8d4 (3f:58d4)
	ld a, [wCurMap]
	cp PEWTER_POKECENTER
	ret nz
	call Func_1542
	call Func_fcff2
	ret

PikachuFanClubCheck: ; fd8e1 (3f:58e1)
	ld a, [wCurMap]
	cp POKEMON_FAN_CLUB
	ret nz
	call Func_1542
	call Func_fcff2
	ret

PikachuBillsHouseCheck: ; fd8ee (3f:58ee)
	ld a, [wCurMap]
	cp BILLS_HOUSE
	ret nz
	call Func_1542
	ret

Pikachu_LoadCurrentMapViewUpdateSpritesAndDelay3: ; fd8f8 (3f:58f8)
	call LoadCurrentMapView
	call UpdateSprites
	call Delay3
	ret

Cosine_e: ; cosine?
	ld a, e
	add $10
	jr asm_fd908

Sine_e: ; sine?
	ld a, e
asm_fd908
	and $3f
	cp $20
	jr nc, .asm_fd913
	call GetSine
	ld a, h
	ret

.asm_fd913
	and $1f
	call GetSine
	ld a, h
	cpl
	inc a
	ret

GetSine:
	ld e, a
	ld a, d
	ld d, 0
	ld hl, SineWave_3f
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, 0
.asm_fd92b
	srl a
	jr nc, .asm_fd930
	add hl, de
.asm_fd930
	sla e
	rl d
	and a
	jr nz, .asm_fd92b
	ret

SineWave_3f:
	sine_wave $100

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

StarterPikachuEmotionCommand_5: ; fd9d0 (3f:59d0)
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
	callab Func_720e3
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
	dw PikaPicAnimCommand_setdelay ; 0a, 1 dw param
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

PikaPicAnimCommand_setdelay:
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
	pikapic_loadgfx $1
	pikapic_loadgfx $f
	pikapic_loadgfx $3e
	pikapic_object $1, $80, $0, $0
	pikapic_object $2, $b2, $5, $5
	pikapic_object $3, $b6, $5, $5
	pikapic_waitbgmap
	pikapic_cry
Data_fe286: ; fe286 (3f:6286)
	pikapic_waitbgmap
	pikapic_jump Data_fe286

Data_fe28a: ; fe28a (3f:628a)
	pikapic_setdelay 40
	pikapic_loadgfx $1
	pikapic_loadgfx $2
	pikapic_object $4, $80, $0, $0
	pikapic_object $6, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry3
Data_fe2a0: ; fe2a0 (3f:62a0)
	pikapic_waitbgmap
	pikapic_jump Data_fe2a0

Data_fe2a4: ; fe2a4 (3f:62a4)
	pikapic_setdelay 44
	pikapic_loadgfx $3
	pikapic_loadgfx $4
	pikapic_object $4, $80, $0, $0
	pikapic_object $7, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe2ba: ; fe2ba (3f:62ba)
	pikapic_waitbgmap
	pikapic_jump Data_fe2ba

Data_fe2be: ; fe2be (3f:62be)
	pikapic_setdelay 80
	pikapic_loadgfx $5
	pikapic_loadgfx $6
	pikapic_object $4, $80, $0, $0
	pikapic_object $8, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe2d4: ; fe2d4 (3f:62d4)
	pikapic_waitbgmap
	pikapic_jump Data_fe2d4

Data_fe2d8: ; fe2d8 (3f:62d8)
	pikapic_setdelay 70
	pikapic_loadgfx $7
	pikapic_loadgfx $8
	pikapic_object $4, $80, $0, $0
	pikapic_object $9, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe2ee: ; fe2ee (3f:62ee)
	pikapic_waitbgmap
	pikapic_jump Data_fe2ee

Data_fe2f2: ; fe2f2 (3f:62f2)
	pikapic_setdelay 32
	pikapic_loadgfx $9
	pikapic_loadgfx $a
	pikapic_object $4, $80, $0, $0
	pikapic_object $a, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe308: ; fe308 (3f:6308)
	pikapic_waitbgmap
	pikapic_jump Data_fe308

Data_fe30c: ; fe30c (3f:630c)
	pikapic_setdelay 50
	pikapic_loadgfx $b
	pikapic_loadgfx $c
	pikapic_object $4, $80, $0, $0
	pikapic_object $b, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry38
Data_fe322: ; fe322 (3f:6322)
	pikapic_waitbgmap
	pikapic_jump Data_fe322

Data_fe326: ; fe326 (3f:6326)
	pikapic_setdelay 58
	pikapic_loadgfx $d
	pikapic_loadgfx $e
	pikapic_object $4, $80, $0, $0
	pikapic_object $c, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe33c: ; fe33c (3f:633c)
	pikapic_waitbgmap
	pikapic_jump Data_fe33c

Data_fe340: ; fe340 (3f:6340)
	pikapic_setdelay 44
	pikapic_loadgfx $f
	pikapic_loadgfx $10
	pikapic_object $4, $80, $0, $0
	pikapic_object $d, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe356: ; fe356 (3f:6356)
	pikapic_waitbgmap
	pikapic_jump Data_fe356

Data_fe35a: ; fe35a (3f:635a)
	pikapic_setdelay 56
	pikapic_loadgfx $11
	pikapic_loadgfx $12
	pikapic_object $4, $80, $0, $0
	pikapic_object $e, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe370: ; fe370 (3f:6370)
	pikapic_waitbgmap
	pikapic_jump Data_fe370

Data_fe374: ; fe374 (3f:6374)
	pikapic_setdelay 56
	pikapic_loadgfx $13
	pikapic_loadgfx $14
	pikapic_loadgfx $15
	pikapic_object $4, $80, $0, $0
	pikapic_object $10, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe38c: ; fe38c (3f:638c)
	pikapic_waitbgmap
	pikapic_jump Data_fe38c

Data_fe390: ; fe390 (3f:6390)
	pikapic_setdelay 100
	pikapic_loadgfx $16
	pikapic_loadgfx $17
	pikapic_object $4, $80, $0, $0
	pikapic_object $11, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe3a6: ; fe3a6 (3f:63a6)
	pikapic_waitbgmap
	pikapic_jump Data_fe3a6

Data_fe3aa: ; fe3aa (3f:63aa)
	pikapic_setdelay 50
	pikapic_loadgfx $18
	pikapic_loadgfx $19
	pikapic_object $4, $80, $0, $0
	pikapic_object $12, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry25
Data_fe3c0: ; fe3c0 (3f:63c0)
	pikapic_waitbgmap
	pikapic_jump Data_fe3c0

Data_fe3c4: ; fe3c4 (3f:63c4)
	pikapic_setdelay 50
	pikapic_loadgfx $1a
	pikapic_loadgfx $1b
	pikapic_object $4, $80, $0, $0
	pikapic_object $13, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe3da: ; fe3da (3f:63da)
	pikapic_waitbgmap
	pikapic_jump Data_fe3da

Data_fe3de: ; fe3de (3f:63de)
	pikapic_setdelay 40
	pikapic_loadgfx $1c
	pikapic_loadgfx $1d
	pikapic_object $4, $80, $0, $0
	pikapic_object $14, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe3f4: ; fe3f4 (3f:63f4)
	pikapic_waitbgmap
	pikapic_jump Data_fe3f4

Data_fe3f8: ; fe3f8 (3f:63f8)
	pikapic_setdelay 50
	pikapic_loadgfx $1e
	pikapic_loadgfx $1f
	pikapic_object $4, $80, $0, $0
	pikapic_object $15, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe40e: ; fe40e (3f:640e)
	pikapic_waitbgmap
	pikapic_jump Data_fe40e

Data_fe412: ; fe412 (3f:6412)
	pikapic_setdelay 32
	pikapic_loadgfx $20
	pikapic_loadgfx $21
	pikapic_object $4, $80, $0, $0
	pikapic_object $16, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe428: ; fe428 (3f:6428)
	pikapic_waitbgmap
	pikapic_jump Data_fe428

Data_fe42c: ; fe42c (3f:642c)
	pikapic_setdelay 100
	pikapic_loadgfx $22
	pikapic_loadgfx $23
	pikapic_object $4, $80, $0, $0
	pikapic_object $17, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe442: ; fe442 (3f:6442)
	pikapic_waitbgmap
	pikapic_jump Data_fe442

Data_fe446: ; fe446 (3f:6446)
	pikapic_setdelay 32
	pikapic_loadgfx $24
	pikapic_loadgfx $25
	pikapic_object $5, $80, $0, $0
	pikapic_object $18, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry18
Data_fe45c: ; fe45c (3f:645c)
	pikapic_waitbgmap
	pikapic_jump Data_fe45c

Data_fe460: ; fe460 (3f:6460)
	pikapic_setdelay 44
	pikapic_loadgfx $26
	pikapic_loadgfx $27
	pikapic_object $4, $80, $0, $0
	pikapic_object $19, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe476: ; fe476 (3f:6476)
	pikapic_waitbgmap
	pikapic_jump Data_fe476

Data_fe47a: ; fe47a (3f:647a)
	pikapic_setdelay 50
	pikapic_loadgfx $28
	pikapic_loadgfx $29
	pikapic_object $4, $80, $0, $0
	pikapic_object $1a, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe490: ; fe490 (3f:6490)
	pikapic_waitbgmap
	pikapic_jump Data_fe490

Data_fe494: ; fe494 (3f:6494)
	pikapic_setdelay 40
	pikapic_loadgfx $2a
	pikapic_loadgfx $2b
	pikapic_loadgfx $2c
	pikapic_loadgfx $2d
	pikapic_loadgfx $2e
	pikapic_object $4, $80, $0, $0
	pikapic_object $1b, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry20
Data_fe4b0: ; fe4b0 (3f:64b0)
	pikapic_waitbgmap
	pikapic_jump Data_fe4b0

Data_fe4b4: ; fe4b4 (3f:64b4)
	pikapic_setdelay 40
	pikapic_loadgfx $2f
	pikapic_loadgfx $30
	pikapic_object $5, $80, $0, $0
	pikapic_object $1c, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe4ca: ; fe4ca (3f:64ca)
	pikapic_waitbgmap
	pikapic_jump Data_fe4ca

Data_fe4ce: ; fe4ce (3f:64ce)
	pikapic_setdelay 70
	pikapic_loadgfx $31
	pikapic_loadgfx $32
	pikapic_object $5, $80, $0, $0
	pikapic_object $1d, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe4e4: ; fe4e4 (3f:64e4)
	pikapic_waitbgmap
	pikapic_jump Data_fe4e4

Data_fe4e8: ; fe4e8 (3f:64e8)
	pikapic_setdelay 60
	pikapic_loadgfx $33
	pikapic_loadgfx $34
	pikapic_object $5, $80, $0, $0
	pikapic_object $1e, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe4fe: ; fe4fe (3f:64fe)
	pikapic_waitbgmap
	pikapic_jump Data_fe4fe

Data_fe502: ; fe502 (3f:6502)
	pikapic_setdelay 50
	pikapic_loadgfx $35
	pikapic_loadgfx $36
	pikapic_loadgfx $37
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
	pikapic_setdelay 100
	pikapic_loadgfx $16
	pikapic_loadgfx $17
	pikapic_loadgfx $38
	pikapic_loadgfx $39
	pikapic_object $4, $80, $0, $0
	pikapic_object $20, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe53a: ; fe53a (3f:653a)
	pikapic_waitbgmap
	pikapic_jump Data_fe53a

Data_fe53e: ; fe53e (3f:653e)
	pikapic_setdelay 30
	pikapic_loadgfx $3a
	pikapic_loadgfx $3b
	pikapic_object $4, $80, $0, $0
	pikapic_object $21, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
Data_fe554: ; fe554 (3f:6554)
	pikapic_waitbgmap
	pikapic_jump Data_fe554

Data_fe558: ; fe558 (3f:6558)
	pikapic_setdelay 64
	pikapic_loadgfx $3c
	pikapic_loadgfx $3d
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
	pikapicanimgfx $ff, Pic_e4000
	pikapicanimgfx 5, GFX_e40cc
	dbbw $ff, $39, $411c
	dbbw $0a, $39, $41d2
	dbbw $ff, $39, $4272
	dbbw $06, $39, $4323
	dbbw $ff, $39, $4383
	dbbw $14, $39, $444b
	dbbw $ff, $39, $458b
	dbbw $04, $39, $463b
	dbbw $ff, $39, $467b
	dbbw $04, $39, $472e
	dbbw $ff, $39, $476e
	dbbw $19, $39, $4841
	dbbw $ff, $39, $49d1
	dbbw $0a, $39, $4a99
	dbbw $ff, $39, $4b39
	dbbw $06, $39, $4bde
	dbbw $ff, $39, $4c3e
	dbbw $19, $39, $4ce0
	dbbw $19, $39, $4e70
	dbbw $ff, $39, $5000
	dbbw $19, $39, $50af
	dbbw $ff, $39, $523f
	dbbw $19, $39, $52fe
	dbbw $ff, $39, $548e
	dbbw $19, $39, $5541
	dbbw $ff, $39, $56d1
	dbbw $19, $39, $5794
	dbbw $ff, $39, $5924
	dbbw $19, $39, $59ed
	dbbw $ff, $39, $5b7d
	dbbw $19, $39, $5c4d
	dbbw $ff, $39, $5ddd
	dbbw $19, $39, $5e90
	dbbw $19, $39, $6020
	dbbw $19, $39, $61b0
	dbbw $ff, $39, $6340
	dbbw $19, $39, $63f7
	dbbw $ff, $39, $6587
	dbbw $19, $39, $6646
	dbbw $ff, $39, $67d6
	dbbw $19, $39, $682f
	dbbw $19, $39, $69bf
	dbbw $19, $39, $6b4f
	dbbw $19, $39, $6cdf
	dbbw $19, $39, $6e6f
	dbbw $19, $39, $6fff
	dbbw $19, $39, $718f
	dbbw $19, $39, $731f
	dbbw $19, $39, $74af
	dbbw $19, $39, $763f
	dbbw $ff, $39, $77cf
	dbbw $19, $39, $7863
	dbbw $19, $39, $79f3
	dbbw $19, $39, $7b83
	dbbw $19, $39, $7d13
	dbbw $ff, $3c, $4abf
	dbbw $19, $3c, $4b64
	dbbw $ff, $3c, $4cf4
	dbbw $19, $3c, $4d82
	dbbw $18, BANK(PikachuSprite), PikachuSprite
