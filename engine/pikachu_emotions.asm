IsPlayerTalkingToPikachu:: ; fcf0c (3f:4f0c)
	ld a, [wd436]
	and a
	ret z
	ld a, [hSpriteIndexOrTextID]
	cp $f
	ret nz
	call InitializePikachuTextID
	xor a
	ld [hSpriteIndexOrTextID], a
	ld [wd436], a
	ret
	
InitializePikachuTextID: ; fcf20 (3f:4f20)
	ld a, $d4 ; display 
	ld [hSpriteIndexOrTextID], a
	xor a
	ld [wPlayerMovingDirection], a
	ld a, $1
	ld [wAutoTextBoxDrawingControl], a
	call DisplayTextID
	xor a
	ld [wAutoTextBoxDrawingControl], a
	ret

DoStarterPikachuEmotions: ; fcf35 (3f:4f35)
	ld e, a
	ld d, $0
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
.loop
	ld a, [de]
	inc de
	cp $ff
	jr z, .done
	ld c, a
	ld b, $0
	ld hl, StarterPikachuEmotionsJumptable
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call JumpToAddress
	jr .loop
.done
	ret
	
StarterPikachuEmotionsJumptable: ; fcf54 (3f:4f54)
	dw StarterPikachuEmotionCommand_nop ; 0
	dw StarterPikachuEmotionCommand_text ; 1
	dw StarterPikachuEmotionCommand_pcm ; 2
	dw StarterPikachuEmotionCommand_emote ; 3
	dw StarterPikachuEmotionCommand_movement ; 4
	dw StarterPikachuEmotionCommand_pikapic ; 5
	dw StarterPikachuEmotionCommand_subcmd ; 6
	dw StarterPikachuEmotionCommand_delay ; 7
	dw StarterPikachuEmotionCommand_nop2 ; 8
	dw StarterPikachuEmotionCommand_9 ; 9
	dw StarterPikachuEmotionCommand_nop3 ; a
	
StarterPikachuEmotionCommand_nop: ; fcf6a (3f:4f6a)
StarterPikachuEmotionCommand_nop3: ; fcf6a (3f:4f6a)
	ret

StarterPikachuEmotionCommand_text: ; fcf6b (3f:4f6b)
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	inc de
	push de
	call PrintText
	pop de
	ret
	
StarterPikachuEmotionCommand_pcm: ; fcf77 (3f:4f77)
	ld a, [de]
	inc de
	push de
	ld e, a
	nop
	call PlayPikachuSoundClip_
	pop de
	ret

PlayPikachuSoundClip_: ; fcf81 (3f:4f81)
	cp $ff
	ret z
	callab PlayPikachuSoundClip
	ret
	
StarterPikachuEmotionCommand_emote: ; fcf8d (3f:4f8d)
	ld a, [wUpdateSpritesEnabled]
	push af
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	ld a, [de]
	inc de
	push de
	call ShowPikachuEmoteBubble
	pop de
	pop af
	ld [wUpdateSpritesEnabled], a
	ret
	
ShowPikachuEmoteBubble: ; fcfa2 (3f:4fa2)
	ld [wWhichEmotionBubble], a
	ld a, $f
	ld [wEmotionBubbleSpriteIndex], a
	predef EmotionBubble
	ret
	
StarterPikachuEmotionCommand_movement: ; fcfb0 (3f:4fb0)
	ld a, [de]
	inc de
	ld l, a
	ld a, [de]
	inc de
	ld h, a
	push de
	ld b, BANK(DoStarterPikachuEmotions)
	call ApplyPikachuMovementData_
	pop de
	ret
	
StarterPikachuEmotionCommand_delay: ; fcfbe (3f:4fbe)
	ld a, [de]
	inc de
	push de
	ld c, a
	call DelayFrames
	pop de
	ret
	
StarterPikachuEmotionCommand_subcmd: ; fcfc7 (3f:4fc7)
	ld a, [de]
	inc de
	push de
	ld e, a
	ld d, $0
	ld hl, Jumptable_fcfda
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call JumpToAddress
	pop de
	ret

Jumptable_fcfda:
	dw LoadPikachuSpriteIntoVRAM
	dw LoadFontTilePatterns
	dw Pikachu_LoadCurrentMapViewUpdateSpritesAndDelay3
	dw WaitForTextScrollButtonPress
	dw PikachuPewterPokecenterCheck
	dw PikachuFanClubCheck
	dw PikachuBillsHouseCheck
	
StarterPikachuEmotionCommand_nop2: ; fcfe8 (3f:4fe8)
	ret
	
StarterPikachuEmotionCommand_9: ; fcfe9 (3f:4fe9)
	push de
	call StarterPikachuEmotionCommand_turnawayfromplayer
	call UpdateSprites
	pop de
	ret

StarterPikachuEmotionCommand_turnawayfromplayer: ; fcff2 (3f:4ff2)
	ld a, [wPlayerFacingDirection]
	xor $4
	ld [wPikachuFacingDirection], a
	ret
	
DeletedFunction_fcffb: ; fcffb (3f:4ffb)
; Inexplicably empty.
	rept 5
	nop
	endr
	ret

Func_fd001:: ; fd001 (3f:5001)
	ld a, e
	jr load_expression

Func_fd004:: ; fd004 (3f:5004)
	call MapSpecificPikachuExpression
	jr c, load_expression
	call GetPikaPicAnimationScriptIndex
	call DeletedFunction_fcffb
load_expression: ; fd00f (3f:500f)
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
	dw PikachuEmotion21_fd1b9 ; used a fishing rod
	dw PikachuEmotion22_fd1c1
	dw PikachuEmotion23_fd1c7
	dw PikachuEmotion24_fd1cf
	dw PikachuEmotion25_fd1d7
	dw PikachuEmotion26_fd1df ; wake up pikachu in pewter pokemon center
	dw PikachuEmotion27_fd1eb
	dw PikachuEmotion28_fd1f1
	dw PikachuEmotion29_fd1f7
	dw PikachuEmotion30_fd1fc
	dw PikachuEmotion31_fd20a
	dw PikachuEmotion32_fd213
	dw PikachuEmotion33_fd05d
	
PikachuEmotion33_fd05d: ; fd05d (3f:505d)
	db $ff
	
MapSpecificPikachuExpression: ; fd05e (3f:505e)
	ld a, [wCurMap]
	cp POKEMON_FAN_CLUB
	jr nz, .notFanClub
	ld hl, wd492
	bit 7, [hl]
	ld a, $1d
	jr z, .set_carry
	call CheckPikachuFollowingPlayer
	ld a, $1e
	jr nz, .set_carry
	jr .check_pikachu_status

.notFanClub
	ld a, [wCurMap]
	cp PEWTER_POKECENTER
	jr nz, .notPewterPokecenter
	call CheckPikachuFollowingPlayer
	ld a, $1a
	jr nz, .set_carry
	jr .check_pikachu_status

.notPewterPokecenter
	callab Func_f24ae
	ld a, e
	cp $ff
	jr nz, .set_carry
	jr .check_pikachu_status ; useless

.check_pikachu_status
	call IsPlayerPikachuAsleepInParty
	ld a, $b
	jr c, .set_carry
	callab CheckPikachuFaintedOrStatused ; same bank
	ld a, $1c
	jr c, .set_carry
	ld a, [wCurMap]
	cp POKEMONTOWER_1
	jr c, .notInLavenderTower
	cp POKEMONTOWER_7 + 1
	ld a, $16
	jr c, .set_carry
.notInLavenderTower
	ld a, [wd49c]
	and a
	jr z, .no_carry
	dec a
	ld c, a
	ld b, $0
	ld hl, Pointer_fd0cb
	add hl, bc
	ld a, [hl]
	jr .set_carry

.no_carry
	and a
	ret

.set_carry
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
	pikaemotion_pcm PikachuCry35
	pikaemotion_pikapic $2
	db $ff

PikachuEmotion10_fd11e: ; fd11e (3f:511e)
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_emotebubble HEART_BUBBLE
	pikaemotion_pcm PikachuCry5
	pikaemotion_pikapic $a
	db $ff

PikachuEmotion7_fd128: ; fd128 (3f:5128)
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_movement Pointer_fd224
	pikaemotion_pcm PikachuCry1
	pikaemotion_movement Pointer_fd224
	pikaemotion_pikapic $7
	db $ff

PikachuEmotion4_fd136: ; fd136 (3f:5136)
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_movement Pointer_fd230
	pikaemotion_pcm PikachuCry29
	pikaemotion_pikapic $4
	db $ff

PikachuEmotion1_fd141: ; fd141 (3f:5141)
	pikaemotion_dummy2
	pikaemotion_pcm
	pikaemotion_pikapic $1
	db $ff

PikachuEmotion8_fd147: ; fd147 (3f:5147)
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry39
	pikaemotion_pikapic $8
	db $ff

PikachuEmotion5_fd14d: ; fd14d (3f:514d)
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry31
	pikaemotion_pikapic $5
	db $ff

PikachuEmotion6_fd153: ; fd153 (3f:5153)
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_pcm
	pikaemotion_movement Pointer_fd21e
	pikaemotion_emotebubble SKULL_BUBBLE
	pikaemotion_pikapic $6
	db $ff

PikachuEmotion3_fd160: ; fd160 (3f:5160)
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry40
	pikaemotion_pikapic $3
	db $ff

PikachuEmotion9_fd166: ; fd166 (3f:5166)
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_pcm PikachuCry6
	pikaemotion_movement Pointer_fd218
	pikaemotion_emotebubble SKULL_BUBBLE
	pikaemotion_pikapic $9
	db $ff

PikachuEmotion11_fd173: ; fd173 (3f:5173)
	pikaemotion_emotebubble ZZZ_BUBBLE
	pikaemotion_pcm PikachuCry37
	pikaemotion_pikapic $b
	db $ff

PikachuEmotion12_fd17a: ; fd17a (3f:517a)
	pikaemotion_dummy2
	pikaemotion_pcm
	pikaemotion_pikapic $c
	db $ff

PikachuEmotion13_fd180: ; fd180 (3f:5180)
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_movement Pointer_fd21e
	pikaemotion_pikapic $d
	db $ff

PikachuEmotion14_fd189: ; fd189 (3f:5189)
	pikaemotion_dummy2
	pikaemotion_emotebubble BOLT_BUBBLE
	pikaemotion_pcm PikachuCry10
	pikaemotion_pikapic $e
	db $ff

PikachuEmotion15_fd191: ; fd191 (3f:5191)
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry34
	pikaemotion_pikapic $f
	db $ff

PikachuEmotion16_fd197: ; fd197 (3f:5197)
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry33
	pikaemotion_pikapic $10
	db $ff

PikachuEmotion17_fd19d: ; fd19d (3f:519d)
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry13
	pikaemotion_pikapic $11
	db $ff

PikachuEmotion18_fd1a3: ; fd1a3 (3f:51a3)
	pikaemotion_dummy2
	pikaemotion_pcm
	pikaemotion_pikapic $12
	db $ff

PikachuEmotion19_fd1a9: ; fd1a9 (3f:51a9)
	pikaemotion_dummy2
	pikaemotion_emotebubble HEART_BUBBLE
	pikaemotion_pcm PikachuCry33
	pikaemotion_pikapic $13
	db $ff

PikachuEmotion20_fd1b1: ; fd1b1 (3f:51b1)
	pikaemotion_dummy2
	pikaemotion_emotebubble HEART_BUBBLE
	pikaemotion_pcm PikachuCry5
	pikaemotion_pikapic $14
	db $ff

PikachuEmotion21_fd1b9: ; fd1b9 (3f:51b9)
	pikaemotion_dummy2
	pikaemotion_emotebubble FISH_BUBBLE
	pikaemotion_pcm
	pikaemotion_pikapic $15
	db $ff

PikachuEmotion22_fd1c1: ; fd1c1 (3f:51c1)
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry4
	pikaemotion_pikapic $16
	db $ff

PikachuEmotion23_fd1c7: ; fd1c7 (3f:51c7)
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry19
	pikaemotion_pikapic $17
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_SHOWMAPVIEW
	db $ff

PikachuEmotion24_fd1cf: ; fd1cf (3f:51cf)
	pikaemotion_dummy2
	pikaemotion_emotebubble EXCLAMATION_BUBBLE
	pikaemotion_pcm
	pikaemotion_pikapic $18
	db $ff

PikachuEmotion25_fd1d7: ; fd1d7 (3f:51d7)
	pikaemotion_dummy2
	pikaemotion_emotebubble BOLT_BUBBLE
	pikaemotion_pcm PikachuCry35
	pikaemotion_pikapic $19
	db $ff

PikachuEmotion26_fd1df: ; fd1df (3f:51df)
	pikaemotion_dummy2
	pikaemotion_emotebubble ZZZ_BUBBLE
	pikaemotion_pcm PikachuCry37
	pikaemotion_pikapic $1a
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_SHOWMAPVIEW
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_CHECKPEWTERCENTER
	db $ff

PikachuEmotion27_fd1eb: ; fd1eb (3f:51eb)
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry9
	pikaemotion_pikapic $1b
	db $ff

PikachuEmotion28_fd1f1: ; fd1f1 (3f:51f1)
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry15
	pikaemotion_pikapic $1c
	db $ff

PikachuEmotion29_fd1f7: ; fd1f7 (3f:51f7)
	pikaemotion_pcm PikachuCry5
	pikaemotion_pikapic $a
	db $ff

PikachuEmotion30_fd1fc: ; fd1fc (3f:51fc)
	pikaemotion_9
	pikaemotion_emotebubble HEART_BUBBLE
	pikaemotion_pcm PikachuCry5
	pikaemotion_pikapic $14
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_SHOWMAPVIEW
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADFONT
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_CHECKLAVENDERTOWER
	db $ff

PikachuEmotion31_fd20a: ; fd20a (3f:520a)
	pikaemotion_pcm PikachuCry19
	pikaemotion_pikapic $17
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_SHOWMAPVIEW
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_CHECKBILLSHOUSE
	db $ff

PikachuEmotion32_fd213: ; fd213 (3f:5213)
	pikaemotion_pcm PikachuCry26
	pikaemotion_pikapic $17
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
	call ApplyPikachuMovementData
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
