IsPlayerTalkingToPikachu::
	ld a, [wd435]
	and a
	ret z
	ldh a, [hSpriteIndex]
	cp PIKACHU_SPRITE_INDEX
	ret nz
	call InitializePikachuTextID
	xor a
	ldh [hSpriteIndex], a
	ld [wd435], a
	ret

InitializePikachuTextID::
	ld a, TEXT_PIKACHU_ANIM ; display
	ldh [hTextID], a
	xor a
	ld [wPlayerMovingDirection], a
	ld a, $1
	ld [wAutoTextBoxDrawingControl], a
	call DisplayTextID
	xor a
	ld [wAutoTextBoxDrawingControl], a
	ret

DoStarterPikachuEmotions:
	ld e, a
	ld d, 0
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
	ld b, 0
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

StarterPikachuEmotionsJumptable:
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

StarterPikachuEmotionCommand_nop:
StarterPikachuEmotionCommand_nop3:
	ret

StarterPikachuEmotionCommand_text:
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

StarterPikachuEmotionCommand_pcm:
	ld a, [de]
	inc de
	push de
	ld e, a
	nop
	call PlayPikachuSoundClip_
	pop de
	ret

PlayPikachuSoundClip_:
	cp $ff
	ret z
	callfar PlayPikachuSoundClip
	ret

StarterPikachuEmotionCommand_emote:
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

ShowPikachuEmoteBubble:
	ld [wWhichEmotionBubble], a
	ld a, PIKACHU_SPRITE_INDEX
	ld [wEmotionBubbleSpriteIndex], a
	predef EmotionBubble
	ret

StarterPikachuEmotionCommand_movement:
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

StarterPikachuEmotionCommand_delay:
	ld a, [de]
	inc de
	push de
	ld c, a
	call DelayFrames
	pop de
	ret

StarterPikachuEmotionCommand_subcmd:
	ld a, [de]
	inc de
	push de
	ld e, a
	ld d, 0
	ld hl, .Subcommands
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call JumpToAddress
	pop de
	ret

.Subcommands:
	dw LoadPikachuSpriteIntoVRAM
	dw LoadFontTilePatterns
	dw Pikachu_LoadCurrentMapViewUpdateSpritesAndDelay3
	dw WaitForTextScrollButtonPress
	dw PikachuPewterPokecenterCheck
	dw PikachuFanClubCheck
	dw PikachuBillsHouseCheck

StarterPikachuEmotionCommand_nop2:
IF DEF(_DEBUG)
	push hl
	ld hl, wStatusFlags6
	bit BIT_DEBUG_MODE, [hl]
	pop hl
	ret z
	push de
	ld d, a
	ld a, [wCurMap]
	cp REDS_HOUSE_2F
	ld a, d
	pop de
	ret nz
	push de
	call Pikachu_LoadCurrentMapViewUpdateSpritesAndDelay3
	call LoadFontTilePatterns
	ld hl, ExpressionText
	call PrintText
	call Pikachu_LoadCurrentMapViewUpdateSpritesAndDelay3
	pop de
	ret

ExpressionText:
	text_far _ExpressionText
	text_end
ELSE
	ret
ENDC

StarterPikachuEmotionCommand_9:
	push de
	call StarterPikachuEmotionCommand_turnawayfromplayer
	call UpdateSprites
	pop de
	ret

StarterPikachuEmotionCommand_turnawayfromplayer:
	ld a, [wSpritePlayerStateData1FacingDirection]
	xor $4
	ld [wSpritePikachuStateData1FacingDirection], a
	ret

DeletedFunction_fcffb:
; Inexplicably empty.
REPT 5
	nop
ENDR
IF DEF(_DEBUG)
	push hl
	ld hl, wStatusFlags6
	bit BIT_DEBUG_MODE, [hl]
	pop hl
	ret z
	push de
	ld d, a
	ld a, [wCurMap]
	cp REDS_HOUSE_2F
	ld a, d
	pop de
	ret nz
	ld a, [wExpressionNumber]
	inc a
	cp (PikachuEmotion33_id - PikachuEmotionTable) / 2
	jr c, .valid
	ldpikaemotion a, PikachuEmotion1
.valid
	ld [wExpressionNumber], a
	ret

HallOfFamePCForever:
	callfar HallOfFamePC
	call WaitForTextScrollButtonPress
	jr HallOfFamePCForever
ELSE
	ret
ENDC

PlaySpecificPikachuEmotion:
	ld a, e
	jr load_expression

TalkToPikachu::
	call MapSpecificPikachuExpression
	jr c, load_expression
	call GetPikaPicAnimationScriptIndex
	call DeletedFunction_fcffb
load_expression:
	ld [wExpressionNumber], a
	ld hl, PikachuEmotionTable
	call DoStarterPikachuEmotions
	ret

MACRO pikaemotion_def
\1_id::
	dw \1
ENDM

PikachuEmotionTable::
	pikaemotion_def PikachuEmotion0
	pikaemotion_def PikachuEmotion1
	pikaemotion_def PikachuEmotion2
	pikaemotion_def PikachuEmotion3
	pikaemotion_def PikachuEmotion4
	pikaemotion_def PikachuEmotion5
	pikaemotion_def PikachuEmotion6
	pikaemotion_def PikachuEmotion7
	pikaemotion_def PikachuEmotion8
	pikaemotion_def PikachuEmotion9
	pikaemotion_def PikachuEmotion10
	pikaemotion_def PikachuEmotion11
	pikaemotion_def PikachuEmotion12
	pikaemotion_def PikachuEmotion13
	pikaemotion_def PikachuEmotion14
	pikaemotion_def PikachuEmotion15
	pikaemotion_def PikachuEmotion16
	pikaemotion_def PikachuEmotion17
	pikaemotion_def PikachuEmotion18
	pikaemotion_def PikachuEmotion19
	pikaemotion_def PikachuEmotion20
	pikaemotion_def PikachuEmotion21 ; used a fishing rod
	pikaemotion_def PikachuEmotion22
	pikaemotion_def PikachuEmotion23
	pikaemotion_def PikachuEmotion24
	pikaemotion_def PikachuEmotion25
	pikaemotion_def PikachuEmotion26 ; wake up pikachu in pewter pokemon center
	pikaemotion_def PikachuEmotion27
	pikaemotion_def PikachuEmotion28
	pikaemotion_def PikachuEmotion29
	pikaemotion_def PikachuEmotion30
	pikaemotion_def PikachuEmotion31
	pikaemotion_def PikachuEmotion32
	pikaemotion_def PikachuEmotion33

PikachuEmotion33:
	db $ff

MapSpecificPikachuExpression:
	ld a, [wCurMap]
	cp POKEMON_FAN_CLUB
	jr nz, .notFanClub
	ld hl, wd492
	bit 7, [hl]
	ldpikaemotion a, PikachuEmotion29
	jr z, .play_emotion
	call CheckPikachuFollowingPlayer
	ldpikaemotion a, PikachuEmotion30
	jr nz, .play_emotion
	jr .check_pikachu_status

.notFanClub
	ld a, [wCurMap]
	cp PEWTER_POKECENTER
	jr nz, .notPewterPokecenter
	call CheckPikachuFollowingPlayer
	ldpikaemotion a, PikachuEmotion26
	jr nz, .play_emotion
	jr .check_pikachu_status

.notPewterPokecenter
	callfar Func_f24ae
	ld a, e
	cp $ff
	jr nz, .play_emotion
	jr .check_pikachu_status ; useless

.check_pikachu_status
	call IsPlayerPikachuAsleepInParty
	ldpikaemotion a, PikachuEmotion11
	jr c, .play_emotion
	callfar CheckPikachuStatusCondition ; same bank
	ldpikaemotion a, PikachuEmotion28
	jr c, .play_emotion
	ld a, [wCurMap]
	cp POKEMON_TOWER_1F
	jr c, .notInLavenderTower
	cp POKEMON_TOWER_7F + 1
	ldpikaemotion a, PikachuEmotion22
	jr c, .play_emotion
.notInLavenderTower
	ld a, [wd49b]
	and a
	jr z, .mood_based_emotion
	dec a
	ld c, a
	ld b, $0
	ld hl, .Emotions
	add hl, bc
	ld a, [hl]
	jr .play_emotion

.mood_based_emotion
	and a
	ret

.play_emotion
	scf
	ret

.Emotions:
	dpikaemotion PikachuEmotion18
	dpikaemotion PikachuEmotion21
	dpikaemotion PikachuEmotion23
	dpikaemotion PikachuEmotion24
	dpikaemotion PikachuEmotion25

IsPlayerPikachuAsleepInParty:
	xor a
	ld [wWhichPokemon], a
.loop
	ld a, [wWhichPokemon]
	ld c, a
	ld b, 0
	ld hl, wPartySpecies
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, .done
	cp STARTER_PIKACHU
	jr nz, .curMonNotStarterPikachu
	callfar IsThisPartyMonStarterPikachu
	jr nc, .curMonNotStarterPikachu
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1Status
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a, [hl]
	and SLP_MASK
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

INCLUDE "data/pikachu/pikachu_emotions.asm"

PikachuWalksToNurseJoy:
	ld a, $40
	ldh [hPikachuSpriteVRAMOffset], a
	call LoadPikachuSpriteIntoVRAM
	call .GetMovementData
	and a
	jr z, .skip
	call ApplyPikachuMovementData
.skip
	xor a
	ldh [hPikachuSpriteVRAMOffset], a
	ret

.GetMovementData:
	ld a, [wSpritePikachuStateData2MapY]
	ld e, a
	ld a, [wSpritePikachuStateData2MapX]
	ld d, a
	ld a, [wYCoord]
	add 4
	cp e
	jr z, .pikachu_at_same_y_as_player
	jr nc, .pikachu_above_player
	ld hl, .PikaMovementData1
	ld a, 1
	ret

.pikachu_above_player
	xor a
	ret

.pikachu_at_same_y_as_player
	ld a, [wXCoord]
	add 4
	cp d
	jr c, .pikachu_to_right_of_player
	ld hl, .PikaMovementData2
	ld a, 2
	ret

.pikachu_to_right_of_player
	ld hl, .PikaMovementData3
	ld a, 3
	ret

.PikaMovementData1:
	db $00 ; init
	db $36 ; look up
	db $2b ; walk up left
	db $34 ; hop up right
	db $3f ; ret

.PikaMovementData2:
	db $00 ; init
	db $36 ; look up
	db $34 ; hop up right
	db $3f ; ret

.PikaMovementData3:
	db $00 ; init
	db $36 ; look up
	db $33 ; hop up left
	db $3f ; ret
