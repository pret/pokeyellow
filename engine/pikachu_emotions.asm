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
	
INCLUDE "data/pikachu_emotions.asm"

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
