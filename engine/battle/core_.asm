BattleCore:

; These are move effects (second value from the Moves table in bank $E).
ResidualEffects1: ; 3c000 (f:4000)
; most non-side effects
	db CONVERSION_EFFECT
	db HAZE_EFFECT
	db SWITCH_AND_TELEPORT_EFFECT
	db MIST_EFFECT
	db FOCUS_ENERGY_EFFECT
	db CONFUSION_EFFECT
	db HEAL_EFFECT
	db TRANSFORM_EFFECT
	db LIGHT_SCREEN_EFFECT
	db REFLECT_EFFECT
	db POISON_EFFECT
	db PARALYZE_EFFECT
	db SUBSTITUTE_EFFECT
	db MIMIC_EFFECT
	db LEECH_SEED_EFFECT
	db SPLASH_EFFECT
	db -1
SetDamageEffects: ; 3c011 (f:4011)
; moves that do damage but not through normal calculations
; e.g., Super Fang, Psywave
	db SUPER_FANG_EFFECT
	db SPECIAL_DAMAGE_EFFECT
	db -1
ResidualEffects2: ; 3c014 (f:4014)
; non-side effects not included in ResidualEffects1
; stat-affecting moves, sleep-inflicting moves, and Bide
; e.g., Meditate, Bide, Hypnosis
	db $01
	db ATTACK_UP1_EFFECT
	db DEFENSE_UP1_EFFECT
	db SPEED_UP1_EFFECT
	db SPECIAL_UP1_EFFECT
	db ACCURACY_UP1_EFFECT
	db EVASION_UP1_EFFECT
	db ATTACK_DOWN1_EFFECT
	db DEFENSE_DOWN1_EFFECT
	db SPEED_DOWN1_EFFECT
	db SPECIAL_DOWN1_EFFECT
	db ACCURACY_DOWN1_EFFECT
	db EVASION_DOWN1_EFFECT
	db BIDE_EFFECT
	db SLEEP_EFFECT
	db ATTACK_UP2_EFFECT
	db DEFENSE_UP2_EFFECT
	db SPEED_UP2_EFFECT
	db SPECIAL_UP2_EFFECT
	db ACCURACY_UP2_EFFECT
	db EVASION_UP2_EFFECT
	db ATTACK_DOWN2_EFFECT
	db DEFENSE_DOWN2_EFFECT
	db SPEED_DOWN2_EFFECT
	db SPECIAL_DOWN2_EFFECT
	db ACCURACY_DOWN2_EFFECT
	db EVASION_DOWN2_EFFECT
	db -1
AlwaysHappenSideEffects: ; 3c030 (f:4030)
; Attacks that aren't finished after they faint the opponent.
	db DRAIN_HP_EFFECT
	db EXPLODE_EFFECT
	db DREAM_EATER_EFFECT
	db PAY_DAY_EFFECT
	db TWO_TO_FIVE_ATTACKS_EFFECT
	db $1E
	db ATTACK_TWICE_EFFECT
	db RECOIL_EFFECT
	db TWINEEDLE_EFFECT
	db RAGE_EFFECT
	db -1
SpecialEffects: ; 3c03b (f:403b)
; Effects from arrays 2, 4, and 5B, minus Twineedle and Rage.
; Includes all effects that do not need to be called at the end of
; ExecutePlayerMove (or ExecuteEnemyMove), because they have already been handled
	db DRAIN_HP_EFFECT
	db EXPLODE_EFFECT
	db DREAM_EATER_EFFECT
	db PAY_DAY_EFFECT
	db SWIFT_EFFECT
	db TWO_TO_FIVE_ATTACKS_EFFECT
	db $1E
	db CHARGE_EFFECT
	db SUPER_FANG_EFFECT
	db SPECIAL_DAMAGE_EFFECT
	db FLY_EFFECT
	db ATTACK_TWICE_EFFECT
	db JUMP_KICK_EFFECT
	db RECOIL_EFFECT
	; fallthrough to Next EffectsArray
SpecialEffectsCont: ; 3c049 (f:4049)
; damaging moves whose effect is executed prior to damage calculation
	db THRASH_PETAL_DANCE_EFFECT
	db TRAPPING_EFFECT
	db -1

SlidePlayerAndEnemySilhouettesOnScreen: ; 3c04c (f:404c)
	call LoadPlayerBackPic
	ld a, MESSAGE_BOX ; the usual text box at the bottom of the screen
	ld [wTextBoxID], a
	call DisplayTextBoxID
	coord hl, 1, 5
	lb bc, 3, 7
	call ClearScreenArea
	call DisableLCD
	call LoadFontTilePatterns
	call LoadHudAndHpBarAndStatusTilePatterns
	ld hl, vBGMap0
	ld bc, $400
.clearBackgroundLoop
	ld a, " "
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .clearBackgroundLoop
; copy the work RAM tile map to VRAM
	coord hl, 0, 0
	ld de, vBGMap0
	ld b, 18 ; number of rows
.copyRowLoop
	ld c, 20 ; number of columns
.copyColumnLoop
	ld a, [hli]
	ld [de], a
	inc e
	dec c
	jr nz, .copyColumnLoop
	ld a, 12 ; number of off screen tiles to the right of screen in VRAM
	add e ; skip the off screen tiles
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
	dec b
	jr nz, .copyRowLoop
	call EnableLCD
	ld a, $90
	ld [hWY], a
	ld [rWY], a
	xor a
	ld [hTilesetType], a
	ld [hSCY], a
	dec a
	ld [wUpdateSpritesEnabled], a
	call Delay3
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld b, $70
	ld c, $90
	ld a, c
	ld [hSCX], a
	call DelayFrame
	ld a, %11100100 ; inverted palette for silhouette effect
	ld [rBGP], a
	ld [rOBP0], a
	ld [rOBP1], a
	call UpdateGBCPal_BGP
	call UpdateGBCPal_OBP0
	call UpdateGBCPal_OBP1
.slideSilhouettesLoop ; slide silhouettes of the player's pic and the enemy's pic onto the screen
	ld h, b
	ld l, $40
	call SetScrollXForSlidingPlayerBodyLeft ; begin background scrolling on line $40
	inc b
	inc b
	ld h, $0
	ld l, $60
	call SetScrollXForSlidingPlayerBodyLeft ; end background scrolling on line $60
	call SlidePlayerHeadLeft
	ld a, c
	ld [hSCX], a
	dec c
	dec c
	jr nz, .slideSilhouettesLoop
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	ld a, $31
	ld [hStartTileID], a
	coord hl, 1, 5
	predef CopyUncompressedPicToTilemap
	xor a
	ld [hWY], a
	ld [rWY], a
	inc a
	ld [H_AUTOBGTRANSFERENABLED], a
	call Delay3
	ld b, SET_PAL_BATTLE
	call RunPaletteCommand
	call HideSprites
	jpab PrintBeginningBattleText

; when a battle is starting, silhouettes of the player's pic and the enemy's pic are slid onto the screen
; the lower of the player's pic (his body) is part of the background, but his head is a sprite
; the reason for this is that it shares Y coordinates with the lower part of the enemy pic, so background scrolling wouldn't work for both pics
; instead, the enemy pic is part of the background and uses the scroll register, while the player's head is a sprite and is slid by changing its X coordinates in a loop
SlidePlayerHeadLeft: ; 3c108 (f:4108)
	push bc
	ld hl, wOAMBuffer + $01
	ld c, $15 ; number of OAM entries
	ld de, $4 ; size of OAM entry
.loop
	dec [hl] ; decrement X
	dec [hl] ; decrement X
	add hl, de ; next OAM entry
	dec c
	jr nz, .loop
	pop bc
	ret

SetScrollXForSlidingPlayerBodyLeft: ; 3c119 (f:4119)
	ld a, [rLY]
	cp l
	jr nz, SetScrollXForSlidingPlayerBodyLeft
	ld a, h
	ld [rSCX], a
.loop
	ld a, [rLY]
	cp h
	jr z, .loop
	ret

StartBattle: ; 3c127 (f:4127)
	xor a
	ld [wPartyGainExpFlags], a
	ld [wPartyFoughtCurrentEnemyFlags], a
	ld [wActionResultOrTookBattleTurn], a
	inc a
	ld [wFirstMonsNotOutYet], a
	ld hl, wEnemyMon1HP
	ld bc, wEnemyMon2 - wEnemyMon1 - 1
	ld d, $3
.findFirstAliveEnemyMonLoop
	inc d
	ld a, [hli]
	or [hl]
	jr nz, .foundFirstAliveEnemyMon
	add hl, bc
	jr .findFirstAliveEnemyMonLoop
.foundFirstAliveEnemyMon
	ld a, d
	ld [wSerialExchangeNybbleReceiveData], a
	ld a, [wIsInBattle]
	dec a ; is it a trainer battle?
	call nz, EnemySendOutFirstMon ; if it is a trainer battle, send out enemy mon
	ld c, 40
	call DelayFrames
	call SaveScreenTilesToBuffer1
.checkAnyPartyAlive
	ld a, [wBattleType]
	cp $3
	jp z, .specialBattle
	cp $4
	jp z, .specialBattle
	call AnyPartyAlive
	ld a, d
	and a
	jp z, HandlePlayerBlackOut ; jump if no mon is alive
.specialBattle
	call LoadScreenTilesFromBuffer1
	ld a, [wBattleType]
	and a ; is it a normal battle?
	jp z, .playerSendOutFirstMon ; if so, send out player mon
; safari zone battle
.displaySafariZoneBattleMenu
	call DisplayBattleMenu
	ret c ; return if the player ran from battle
	ld a, [wActionResultOrTookBattleTurn]
	and a ; was the item used successfully?
	jr z, .displaySafariZoneBattleMenu ; if not, display the menu again; XXX does this ever jump?
	ld a, [wNumSafariBalls]
	and a
	jr nz, .notOutOfSafariBalls
	call LoadScreenTilesFromBuffer1
	ld hl, .outOfSafariBallsText
	jp PrintText
.notOutOfSafariBalls
	callab PrintSafariZoneBattleText
	ld a, [wEnemyMonSpeed + 1]
	add a
	ld b, a ; init b (which is later compared with random value) to (enemy speed % 256) * 2
	jp c, EnemyRan ; if (enemy speed % 256) > 127, the enemy runs
	ld a, [wSafariBaitFactor]
	and a ; is bait factor 0?
	jr z, .checkEscapeFactor
; bait factor is not 0
; divide b by 4 (making the mon less likely to run)
	srl b
	srl b
.checkEscapeFactor
	ld a, [wSafariEscapeFactor]
	and a ; is escape factor 0?
	jr z, .compareWithRandomValue
; escape factor is not 0
; multiply b by 2 (making the mon more likely to run)
	sla b
	jr nc, .compareWithRandomValue
; cap b at 255
	ld b, $ff
.compareWithRandomValue
	call Random
	cp b
	jr nc, .checkAnyPartyAlive
	jr EnemyRan ; if b was greater than the random value, the enemy runs

.outOfSafariBallsText
	TX_FAR _OutOfSafariBallsText
	db "@"

.playerSendOutFirstMon
	xor a
	ld [wWhichPokemon], a
.findFirstAliveMonLoop
	call HasMonFainted
	jr nz, .foundFirstAliveMon
; fainted, go to the next one
	ld hl, wWhichPokemon
	inc [hl]
	jr .findFirstAliveMonLoop
.foundFirstAliveMon
	ld a, [wWhichPokemon]
	ld [wPlayerMonNumber], a
	inc a
	ld hl, wPartySpecies - 1
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl] ; species
	ld [wcf91], a
	ld [wBattleMonSpecies2], a
	call LoadScreenTilesFromBuffer1
	coord hl, 1, 5
	ld a, $9
	call SlideTrainerPicOffScreen
	call SaveScreenTilesToBuffer1
	ld a, [wWhichPokemon]
	ld c, a
	ld b, FLAG_SET
	push bc
	ld hl, wPartyGainExpFlags
	predef FlagActionPredef
	ld hl, wPartyFoughtCurrentEnemyFlags
	pop bc
	predef FlagActionPredef
	call LoadBattleMonFromParty
	call LoadScreenTilesFromBuffer1
	call SendOutMon
	jr MainInBattleLoop

; wild mon or link battle enemy ran from battle
EnemyRan: ; 3c202 (f:4218)
	call LoadScreenTilesFromBuffer1
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ld hl, WildRanText
	jr nz, .printText
; link battle
	xor a
	ld [wBattleResult], a
	ld hl, EnemyRanText
.printText
	call PrintText
	ld a, SFX_RUN
	call PlaySoundWaitForCurrent
	xor a
	ld [H_WHOSETURN], a
	jpab AnimationSlideEnemyMonOff

WildRanText: ; 3c23f (f:423f)
	TX_FAR _WildRanText
	db "@"

EnemyRanText: ; 3c23f (f:423f)
	TX_FAR _EnemyRanText
	db "@"

MainInBattleLoop: ; 3c249 (f:4249)
	call ReadPlayerMonCurHPAndStatus
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl] ; is battle mon HP 0?
	jp z, HandlePlayerMonFainted  ; if battle mon HP is 0, jump
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl] ; is enemy mon HP 0?
	jp z, HandleEnemyMonFainted ; if enemy mon HP is 0, jump
	call SaveScreenTilesToBuffer1
	xor a
	ld [wFirstMonsNotOutYet], a
	ld a, [wPlayerBattleStatus2]
	and (1 << NeedsToRecharge) | (1 << UsingRage) ; check if the player is using Rage or needs to recharge
	jr nz, .selectEnemyMove
; the player is not using Rage and doesn't need to recharge
	ld hl, wEnemyBattleStatus1
	res Flinched, [hl] ; reset flinch bit
	ld hl, wPlayerBattleStatus1
	res Flinched, [hl] ; reset flinch bit
	ld a, [hl]
	and (1 << ThrashingAbout) | (1 << ChargingUp) ; check if the player is thrashing about or charging for an attack
	jr nz, .selectEnemyMove ; if so, jump
; the player is neither thrashing about nor charging for an attack
	call DisplayBattleMenu ; show battle menu
	ret c ; return if player ran from battle
	ld a, [wEscapedFromBattle]
	and a
	ret nz ; return if pokedoll was used to escape from battle
	ld a, [wBattleMonStatus]
	and (1 << FRZ) | SLP ; is mon frozen or asleep?
	jr nz, .selectEnemyMove ; if so, jump
	ld a, [wPlayerBattleStatus1]
	and (1 << StoringEnergy) | (1 << UsingTrappingMove) ; check player is using Bide or using a multi-turn attack like wrap
	jr nz, .selectEnemyMove ; if so, jump
	ld a, [wEnemyBattleStatus1]
	bit UsingTrappingMove, a ; check if enemy is using a multi-turn attack like wrap
	jr z, .selectPlayerMove ; if not, jump
; enemy is using a mult-turn attack like wrap, so player is trapped and cannot execute a move
	ld a, $ff
	ld [wPlayerSelectedMove], a
	jr .selectEnemyMove
.selectPlayerMove
	ld a, [wActionResultOrTookBattleTurn]
	and a ; has the player already used the turn (e.g. by using an item, trying to run or switching pokemon)
	jr nz, .selectEnemyMove
	ld [wMoveMenuType], a
	inc a
	ld [wAnimationID], a
	xor a
	ld [wMenuItemToSwap], a
	call MoveSelectionMenu
	push af
	call LoadScreenTilesFromBuffer1
	call DrawHUDsAndHPBars
	pop af
	jr nz, MainInBattleLoop ; if the player didn't select a move, jump
.selectEnemyMove
	call SelectEnemyMove
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, .noLinkBattle
; link battle
	ld a, [wSerialExchangeNybbleReceiveData]
	cp $f
	jp z, EnemyRan
	cp $e
	jr z, .noLinkBattle
	cp $d
	jr z, .noLinkBattle
	sub $4
	jr c, .noLinkBattle
; the link battle enemy has switched mons
	ld a, [wPlayerBattleStatus1]
	bit UsingTrappingMove, a ; check if using multi-turn move like Wrap
	jr z, .specialMoveNotUsed
	ld a, [wPlayerMoveListIndex]
	ld hl, wBattleMonMoves
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	cp METRONOME ; a MIRROR MOVE check is missing, might lead to a desync in link battles
	             ; when combined with multi-turn moves
	jr nz, .specialMoveNotUsed
	ld [wPlayerSelectedMove], a
.specialMoveNotUsed
	callab SwitchEnemyMon
.noLinkBattle
	ld a, [wPlayerSelectedMove]
	cp QUICK_ATTACK
	jr nz, .playerDidNotUseQuickAttack
	ld a, [wEnemySelectedMove]
	cp QUICK_ATTACK
	jr z, .compareSpeed  ; if both used Quick Attack
	jp .playerMovesFirst ; if player used Quick Attack and enemy didn't
.playerDidNotUseQuickAttack
	ld a, [wEnemySelectedMove]
	cp QUICK_ATTACK
	jr z, .enemyMovesFirst ; if enemy used Quick Attack and player didn't
	ld a, [wPlayerSelectedMove]
	cp COUNTER
	jr nz, .playerDidNotUseCounter
	ld a, [wEnemySelectedMove]
	cp COUNTER
	jr z, .compareSpeed ; if both used Counter
	jr .enemyMovesFirst ; if player used Counter and enemy didn't
.playerDidNotUseCounter
	ld a, [wEnemySelectedMove]
	cp COUNTER
	jr z, .playerMovesFirst ; if enemy used Counter and player didn't
.compareSpeed
	ld de, wBattleMonSpeed ; player speed value
	ld hl, wEnemyMonSpeed ; enemy speed value
	ld c, $2
	call StringCmp ; compare speed values
	jr z, .speedEqual
	jr nc, .playerMovesFirst ; if player is faster
	jr .enemyMovesFirst ; if enemy is faster
.speedEqual ; 50/50 chance for both players
	ld a, [$ffaa]
	cp $2
	jr z, .invertOutcome
	call BattleRandom
	cp $80
	jr c, .playerMovesFirst
	jr .enemyMovesFirst
.invertOutcome
	call BattleRandom
	cp $80
	jr c, .enemyMovesFirst
	jr .playerMovesFirst
.enemyMovesFirst
	ld a, $1
	ld [H_WHOSETURN], a
	callab TrainerAI
	jr c, .AIActionUsedEnemyFirst
	call ExecuteEnemyMove
	ld a, [wEscapedFromBattle]
	and a ; was Teleport, Road, or Whirlwind used to escape from battle?
	ret nz ; if so, return
	ld a, b
	and a
	jp z, HandlePlayerMonFainted
.AIActionUsedEnemyFirst
	call HandlePoisonBurnLeechSeed
	jp z, HandleEnemyMonFainted
	call DrawHUDsAndHPBars
	call ExecutePlayerMove
	ld a, [wEscapedFromBattle]
	and a ; was Teleport, Road, or Whirlwind used to escape from battle?
	ret nz ; if so, return
	ld a, b
	and a
	jp z, HandleEnemyMonFainted
	call HandlePoisonBurnLeechSeed
	jp z, HandlePlayerMonFainted
	call DrawHUDsAndHPBars
	call CheckNumAttacksLeft
	jp MainInBattleLoop
.playerMovesFirst
	call ExecutePlayerMove
	ld a, [wEscapedFromBattle]
	and a ; was Teleport, Road, or Whirlwind used to escape from battle?
	ret nz ; if so, return
	ld a, b
	and a
	jp z, HandleEnemyMonFainted
	call HandlePoisonBurnLeechSeed
	jp z, HandlePlayerMonFainted
	call DrawHUDsAndHPBars
	ld a, $1
	ld [H_WHOSETURN], a
	callab TrainerAI
	jr c, .AIActionUsedPlayerFirst
	call ExecuteEnemyMove
	ld a, [wEscapedFromBattle]
	and a ; was Teleport, Road, or Whirlwind used to escape from battle?
	ret nz ; if so, return
	ld a, b
	and a
	jp z, HandlePlayerMonFainted
.AIActionUsedPlayerFirst
	call HandlePoisonBurnLeechSeed
	jp z, HandleEnemyMonFainted
	call DrawHUDsAndHPBars
	call CheckNumAttacksLeft
	jp MainInBattleLoop
	
HandlePoisonBurnLeechSeed: ; 3c3d3 (f:43d3)
	ld hl, wBattleMonHP
	ld de, wBattleMonStatus
	ld a, [H_WHOSETURN]
	and a
	jr z, .playersTurn
	ld hl, wEnemyMonHP
	ld de, wEnemyMonStatus
.playersTurn
	ld a, [de]
	and (1 << BRN) | (1 << PSN)
	jr z, .notBurnedOrPoisoned
	push hl
	ld hl, HurtByPoisonText
	ld a, [de]
	and 1 << BRN
	jr z, .poisoned
	ld hl, HurtByBurnText
.poisoned
	call PrintText
	xor a
	ld [wAnimationType], a
	ld a,BURN_PSN_ANIM
	call PlayMoveAnimation   ; play burn/poison animation
	pop hl
	call HandlePoisonBurnLeechSeed_DecreaseOwnHP
.notBurnedOrPoisoned
	ld de, wPlayerBattleStatus2
	ld a, [H_WHOSETURN]
	and a
	jr z, .playersTurn2
	ld de, wEnemyBattleStatus2
.playersTurn2
	ld a, [de]
	add a
	jr nc, .notLeechSeeded
	push hl
	ld a, [H_WHOSETURN]
	push af
	xor $1
	ld [H_WHOSETURN], a
	xor a
	ld [wAnimationType], a
	ld a,ABSORB
	call PlayMoveAnimation ; play leech seed animation (from opposing mon)
	pop af
	ld [H_WHOSETURN], a
	pop hl
	call HandlePoisonBurnLeechSeed_DecreaseOwnHP
	call HandlePoisonBurnLeechSeed_IncreaseEnemyHP
	push hl
	ld hl, HurtByLeechSeedText
	call PrintText
	pop hl
.notLeechSeeded
	ld a, [hli]
	or [hl]
	ret nz          ; test if fainted
	call DrawHUDsAndHPBars
	ld c, 20
	call DelayFrames
	xor a
	ret

HurtByPoisonText: ; 3c444 (f:4444)
	TX_FAR _HurtByPoisonText
	db "@"

HurtByBurnText: ; 3c449 (f:4449)
	TX_FAR _HurtByBurnText
	db "@"

HurtByLeechSeedText: ; 3c44e (f:444e)
	TX_FAR _HurtByLeechSeedText
	db "@"

; decreases the mon's current HP by 1/16 of the Max HP (multiplied by number of toxic ticks if active)
; note that the toxic ticks are considered even if the damage is not poison (hence the Leech Seed glitch)
; hl: HP pointer
; bc (out): total damage
HandlePoisonBurnLeechSeed_DecreaseOwnHP: ; 3c43d (f:443d)
	push hl
	push hl
	ld bc, $e      ; skip to max HP
	add hl, bc
	ld a, [hli]    ; load max HP
	ld [wHPBarMaxHP+1], a
	ld b, a
	ld a, [hl]
	ld [wHPBarMaxHP], a
	ld c, a
	srl b
	rr c
	srl b
	rr c
	srl c
	srl c         ; c = max HP/16 (assumption: HP < 1024)
	ld a, c
	and a
	jr nz, .nonZeroDamage
	inc c         ; damage is at least 1
.nonZeroDamage
	ld hl, wPlayerBattleStatus3
	ld de, wPlayerToxicCounter
	ld a, [H_WHOSETURN]
	and a
	jr z, .playersTurn
	ld hl, wEnemyBattleStatus3
	ld de, wEnemyToxicCounter
.playersTurn
	bit BadlyPoisoned, [hl]
	jr z, .noToxic
	ld a, [de]    ; increment toxic counter
	inc a
	ld [de], a
	ld hl, $0000
.toxicTicksLoop
	add hl, bc
	dec a
	jr nz, .toxicTicksLoop
	ld b, h       ; bc = damage * toxic counter
	ld c, l
.noToxic
	pop hl
	inc hl
	ld a, [hl]    ; subtract total damage from current HP
	ld [wHPBarOldHP], a
	sub c
	ld [hld], a
	ld [wHPBarNewHP], a
	ld a, [hl]
	ld [wHPBarOldHP+1], a
	sbc b
	ld [hl], a
	ld [wHPBarNewHP+1], a
	jr nc, .noOverkill
	xor a         ; overkill: zero HP
	ld [hli], a
	ld [hl], a
	ld [wHPBarNewHP], a
	ld [wHPBarNewHP+1], a
.noOverkill
	call UpdateCurMonHPBar
	pop hl
	ret

; adds bc to enemy HP
; bc isn't updated if HP substracted was capped to prevent overkill
HandlePoisonBurnLeechSeed_IncreaseEnemyHP: ; 3c4b9 (f:44b9)
	push hl
	ld hl, wEnemyMonMaxHP
	ld a, [H_WHOSETURN]
	and a
	jr z, .playersTurn
	ld hl, wBattleMonMaxHP
.playersTurn
	ld a, [hli]
	ld [wHPBarMaxHP+1], a
	ld a, [hl]
	ld [wHPBarMaxHP], a
	ld de, wBattleMonHP - wBattleMonMaxHP
	add hl, de           ; skip back from max hp to current hp
	ld a, [hl]
	ld [wHPBarOldHP], a ; add bc to current HP
	add c
	ld [hld], a
	ld [wHPBarNewHP], a
	ld a, [hl]
	ld [wHPBarOldHP+1], a
	adc b
	ld [hli], a
	ld [wHPBarNewHP+1], a
	ld a, [wHPBarMaxHP]
	ld c, a
	ld a, [hld]
	sub c
	ld a, [wHPBarMaxHP+1]
	ld b, a
	ld a, [hl]
	sbc b
	jr c, .noOverfullHeal
	ld a, b                ; overfull heal, set HP to max HP
	ld [hli], a
	ld [wHPBarNewHP+1], a
	ld a, c
	ld [hl], a
	ld [wHPBarNewHP], a
.noOverfullHeal
	ld a, [H_WHOSETURN]
	xor $1
	ld [H_WHOSETURN], a
	call UpdateCurMonHPBar
	ld a, [H_WHOSETURN]
	xor $1
	ld [H_WHOSETURN], a
	pop hl
	ret

UpdateCurMonHPBar: ; 3c50c (f:450c)
	coord hl, 10, 9    ; tile pointer to player HP bar
	ld a, [H_WHOSETURN]
	and a
	ld a, $1
	jr z, .playersTurn
	coord hl, 2, 2    ; tile pointer to enemy HP bar
	xor a
.playersTurn
	push bc
	ld [wHPBarType], a
	predef UpdateHPBar2
	pop bc
	ret

CheckNumAttacksLeft: ; 3c525 (f:4525)
	ld a, [wPlayerNumAttacksLeft]
	and a
	jr nz, .checkEnemy
; player has 0 attacks left
	ld hl, wPlayerBattleStatus1
	res UsingTrappingMove, [hl] ; player not using multi-turn attack like wrap any more
.checkEnemy
	ld a, [wEnemyNumAttacksLeft]
	and a
	ret nz
; enemy has 0 attacks left
	ld hl, wEnemyBattleStatus1
	res UsingTrappingMove, [hl] ; enemy not using multi-turn attack like wrap any more
	ret

HandleEnemyMonFainted: ; 3c53b (f:453b)
	xor a
	ld [wInHandlePlayerMonFainted], a
	call FaintEnemyPokemon
	call AnyPartyAlive
	ld a, d
	and a
	jp z, HandlePlayerBlackOut ; if no party mons are alive, the player blacks out
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl] ; is battle mon HP zero?
	call nz, DrawPlayerHUDAndHPBar ; if battle mon HP is not zero, draw player HD and HP bar
	ld a, [wIsInBattle]
	dec a
	ret z ; return if it's a wild battle
	call AnyEnemyPokemonAliveCheck
	jp z, TrainerBattleVictory
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl] ; does battle mon have 0 HP?
	jr nz, .skipReplacingBattleMon ; if not, skip replacing battle mon
	call DoUseNextMonDialogue ; this call is useless in a trainer battle. it shouldn't be here
	ret c
	call ChooseNextMon
.skipReplacingBattleMon
	ld a, $1
	ld [wActionResultOrTookBattleTurn], a
	call ReplaceFaintedEnemyMon
	jp z, EnemyRan
	xor a
	ld [wActionResultOrTookBattleTurn], a
	jp MainInBattleLoop

FaintEnemyPokemon: ; 3c57d (f:457d)
	call ReadPlayerMonCurHPAndStatus
	ld a, [wIsInBattle]
	dec a
	jr z, .wild
	ld a, [wEnemyMonPartyPos]
	ld hl, wEnemyMon1HP
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	xor a
	ld [hli], a
	ld [hl], a
.wild
	ld hl, wPlayerBattleStatus1
	res AttackingMultipleTimes, [hl]
; Bug. This only zeroes the high byte of the player's accumulated damage,
; setting the accumulated damage to itself mod 256 instead of 0 as was probably
; intended. That alone is problematic, but this mistake has another more severe
; effect. This function's counterpart for when the player mon faints,
; RemoveFaintedPlayerMon, zeroes both the high byte and the low byte. In a link
; battle, the other player's Game Boy will call that function in response to
; the enemy mon (the player mon from the other side's perspective) fainting,
; and the states of the two Game Boys will go out of sync unless the damage
; was congruent to 0 modulo 256.
	xor a
	ld [wPlayerBideAccumulatedDamage], a
	ld hl, wEnemyStatsToDouble ; clear enemy statuses
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [wEnemyDisabledMove], a
	ld [wEnemyDisabledMoveNumber], a
	ld [wEnemyMonMinimized], a
	ld hl, wPlayerUsedMove
	ld [hli], a
	ld [hl], a
	coord hl, 12, 5
	coord de, 12, 6
	call SlideDownFaintedMonPic
	coord hl, 0, 0
	lb bc, 4, 11
	call ClearScreenArea
	ld a, [wIsInBattle]
	dec a
	jr z, .wild_win
	xor a
	ld [wFrequencyModifier], a
	ld [wTempoModifier], a
	ld a, SFX_FAINT_FALL
	call PlaySoundWaitForCurrent
.sfxwait
	ld a, [wChannelSoundIDs + CH4]
	cp SFX_FAINT_FALL
	jr z, .sfxwait
	ld a, SFX_FAINT_THUD
	call PlaySound
	call WaitForSoundToFinish
	jr .sfxplayed
.wild_win
	call EndLowHealthAlarm
	ld a, MUSIC_DEFEATED_WILD_MON
	call PlayBattleVictoryMusic
.sfxplayed
; bug: win sfx is played for wild battles before checking for player mon HP
; this can lead to odd scenarios where both player and enemy faint, as the win sfx plays yet the player never won the battle
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl]
	jr nz, .playermonnotfaint
	ld a, [wInHandlePlayerMonFainted]
	and a ; was this called by HandlePlayerMonFainted?
	jr nz, .playermonnotfaint ; if so, don't call RemoveFaintedPlayerMon twice
	call RemoveFaintedPlayerMon
.playermonnotfaint
	call AnyPartyAlive
	ld a, d
	and a
	ret z
	ld hl, EnemyMonFaintedText
	call PrintText
	call PrintEmptyString
	call SaveScreenTilesToBuffer1
	xor a
	ld [wBattleResult], a
	ld b, EXP_ALL
	call IsItemInBag
	push af
	jr z, .giveExpToMonsThatFought ; if no exp all, then jump

; the player has exp all
; first, we halve the values that determine exp gain
; the enemy mon base stats are added to stat exp, so they are halved
; the base exp (which determines normal exp) is also halved
	ld hl, wEnemyMonBaseStats
	ld b, $7
.halveExpDataLoop
	srl [hl]
	inc hl
	dec b
	jr nz, .halveExpDataLoop

; give exp (divided evenly) to the mons that actually fought in battle against the enemy mon that has fainted
; if exp all is in the bag, this will be only be half of the stat exp and normal exp, due to the above loop
.giveExpToMonsThatFought
	xor a
	ld [wBoostExpByExpAll], a
	callab GainExperience
	pop af
	ret z ; return if no exp all

; the player has exp all
; now, set the gain exp flag for every party member
; half of the total stat exp and normal exp will divided evenly amongst every party member
	ld a, $1
	ld [wBoostExpByExpAll], a
	ld a, [wPartyCount]
	ld b, 0
.gainExpFlagsLoop
	scf
	rl b
	dec a
	jr nz, .gainExpFlagsLoop
	ld a, b
	ld [wPartyGainExpFlags], a
	jpab GainExperience

EnemyMonFaintedText: ; 3c654 (f:4654)
	TX_FAR _EnemyMonFaintedText
	db "@"

EndLowHealthAlarm: ; 3c659 (f:4659)
; This function is called when the player has the won the battle. It turns off
; the low health alarm and prevents it from reactivating until the next battle.
	xor a
	ld [wLowHealthAlarm], a ; turn off low health alarm
	ld [wChannelSoundIDs + CH4], a
	inc a
	ld [wLowHealthAlarmDisabled], a ; prevent it from reactivating
	ret

AnyEnemyPokemonAliveCheck: ; 3c665 (f:4665)
	ld a, [wEnemyPartyCount]
	ld b, a
	xor a
	ld hl, wEnemyMon1HP
	ld de, wEnemyMon2 - wEnemyMon1
.nextPokemon
	or [hl]
	inc hl
	or [hl]
	dec hl
	add hl, de
	dec b
	jr nz, .nextPokemon
	and a
	ret

; stores whether enemy ran in Z flag
ReplaceFaintedEnemyMon: ; 3c67a (f:467a)
	ld hl, wEnemyHPBarColor
	ld e, $30
	call GetBattleHealthBarColor
	setpal SHADE_BLACK, SHADE_DARK, SHADE_LIGHT, SHADE_WHITE
	ld [rOBP0], a
	ld [rOBP1], a
	call UpdateGBCPal_OBP0
	call UpdateGBCPal_OBP1
	callab DrawEnemyPokeballs
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, .notLinkBattle
; link battle
	call LinkBattleExchangeData
	ld a, [wSerialExchangeNybbleReceiveData]
	cp $f
	ret z
	call LoadScreenTilesFromBuffer1
.notLinkBattle
	call EnemySendOut
	xor a
	ld [wEnemyMoveNum], a
	ld [wActionResultOrTookBattleTurn], a
	ld [wAILayer2Encouragement], a
	inc a ; reset Z flag
	ret

TrainerBattleVictory: ; 3c6b8 (f:46b8)
	call EndLowHealthAlarm
	ld b, MUSIC_DEFEATED_GYM_LEADER
	ld a, [wGymLeaderNo]
	and a
	jr nz, .gymleader
	ld b, MUSIC_DEFEATED_TRAINER
.gymleader
	ld a, [wTrainerClass]
	cp SONY3 ; final battle against rival
	jr nz, .notrival
	ld b, MUSIC_DEFEATED_GYM_LEADER
	ld hl, wFlags_D733
	set 1, [hl]
.notrival
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ld a, b
	call nz, PlayBattleVictoryMusic
	ld hl, TrainerDefeatedText
	call PrintText
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ret z
	call ScrollTrainerPicAfterBattle
	ld c, 40
	call DelayFrames
	call PrintEndBattleText
; win money
	ld hl, MoneyForWinningText
	call PrintText
	ld de, wPlayerMoney + 2
	ld hl, wAmountMoneyWon + 2
	ld c, $3
	predef_jump AddBCDPredef

MoneyForWinningText: ; 3c706 (f:4706)
	TX_FAR _MoneyForWinningText
	db "@"

TrainerDefeatedText: ; 3c70b (f:470b)
	TX_FAR _TrainerDefeatedText
	db "@"

PlayBattleVictoryMusic: ; 3c710 (f:4710)
	push af
	call StopAllMusic
	ld c, BANK(Music_DefeatedTrainer)
	pop af
	call PlayMusic
	jp Delay3

HandlePlayerMonFainted: ; 3c71d (f:471d)
	ld a, 1
	ld [wInHandlePlayerMonFainted], a
	call RemoveFaintedPlayerMon
	call AnyPartyAlive     ; test if any more mons are alive
	ld a, d
	and a
	jp z, HandlePlayerBlackOut
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl] ; is enemy mon's HP 0?
	jr nz, .doUseNextMonDialogue ; if not, jump
; the enemy mon has 0 HP
	call FaintEnemyPokemon
	ld a, [wIsInBattle]
	dec a
	ret z            ; if wild encounter, battle is over
	call AnyEnemyPokemonAliveCheck
	jp z, TrainerBattleVictory
.doUseNextMonDialogue
	call DoUseNextMonDialogue
	ret c ; return if the player ran from battle
	call ChooseNextMon
	jp nz, MainInBattleLoop ; if the enemy mon has more than 0 HP, go back to battle loop
; the enemy mon has 0 HP
	ld a, $1
	ld [wActionResultOrTookBattleTurn], a
	call ReplaceFaintedEnemyMon
	jp z, EnemyRan ; if enemy ran from battle rather than sending out another mon, jump
	xor a
	ld [wActionResultOrTookBattleTurn], a
	jp MainInBattleLoop

; resets flags, slides mon's pic down, plays cry, and prints fainted message
RemoveFaintedPlayerMon: ; 3c75e (f:475e)
	ld a, [wPlayerMonNumber]
	ld c, a
	ld hl, wPartyGainExpFlags
	ld b, FLAG_RESET
	predef FlagActionPredef ; clear gain exp flag for fainted mon
	ld hl, wEnemyBattleStatus1
	res 2, [hl]   ; reset "attacking multiple times" flag
	ld a, [wLowHealthAlarm]
	bit 7, a      ; skip sound flag (red bar (?))
	jr z, .skipWaitForSound
	ld a, $ff
	ld [wLowHealthAlarm], a ;disable low health alarm
	call WaitForSoundToFinish
	xor a
.skipWaitForSound
; a is 0, so this zeroes the enemy's accumulated damage.
	ld hl, wEnemyBideAccumulatedDamage
	ld [hli], a
	ld [hl], a
	ld [wBattleMonStatus], a
	call ReadPlayerMonCurHPAndStatus
	coord hl, 9, 7
	lb bc, 5, 11
	call ClearScreenArea
	coord hl, 1, 10
	coord de, 1, 11
	call SlideDownFaintedMonPic
	ld a, $1
	ld [wBattleResult], a

; When the player mon and enemy mon faint at the same time and the fact that the
; enemy mon has fainted is detected first (e.g. when the player mon knocks out
; the enemy mon using a move with recoil and faints due to the recoil), don't
; play the player mon's cry or show the "[player mon] fainted!" message.
	ld a, [wInHandlePlayerMonFainted]
	and a ; was this called by HandleEnemyMonFainted?
	ret z ; if so, return

	ld a, [wPlayerMonNumber]
	ld [wWhichPokemon], a
	callab IsThisPartymonStarterPikachu_Party
	jr nc, .notPlayerPikachu
	ld e, $3
	callab PlayPikachuSoundClip
	jr .printText
.notPlayerPikachu
	ld a, [wBattleMonSpecies]
	call PlayCry
.printText
	ld hl, PlayerMonFaintedText
	call PrintText
	ld a, [wPlayerMonNumber]
	ld [wWhichPokemon], a
	ld a, [wBattleMonLevel]
	ld b, a
	ld a, [wEnemyMonLevel]
	sub b ; enemylevel - playerlevel
	      ; are we stronger than the opposing pokemon?
	jr c, .regularFaint ; if so, deduct happiness regularly
	
	cp 30 ; is the enemy 30 levels greater than us?
	jr nc, .carelessTrainer ; if so, punish the player for being careless, as they shouldn't be fighting a very high leveled trainer with such a level difference
.regularFaint
	callabd_ModifyPikachuHappiness PIKAHAPPY_FAINTED
	ret
.carelessTrainer
	callabd_ModifyPikachuHappiness PIKAHAPPY_CARELESSTRAINER
	ret
	
PlayerMonFaintedText: ; 3c7fa (f:47fa)
	TX_FAR _PlayerMonFaintedText
	db "@"

; asks if you want to use next mon
; stores whether you ran in C flag
DoUseNextMonDialogue: ; 3c7ff (f:47ff)
	call PrintEmptyString
	call SaveScreenTilesToBuffer1
	ld a, [wIsInBattle]
	and a
	dec a
	ret nz ; return if it's a trainer battle
	ld hl, UseNextMonText
	call PrintText
.displayYesNoBox
	coord hl, 13, 9
	lb bc, 10, 14
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld a, [wMenuExitMethod]
	cp CHOSE_SECOND_ITEM ; did the player choose NO?
	jr z, .tryRunning ; if the player chose NO, try running
	and a ; reset carry
	ret
.tryRunning
	ld a, [wCurrentMenuItem]
	and a
	jr z, .displayYesNoBox ; xxx when does this happen?
	ld hl, wPartyMon1Speed
	ld de, wEnemyMonSpeed
	jp TryRunningFromBattle

UseNextMonText: ; 3c837 (f:4837)
	TX_FAR _UseNextMonText
	db "@"

; choose next player mon to send out
; stores whether enemy mon has no HP left in Z flag
ChooseNextMon: ; 3c83c (f:483c)
	ld a, BATTLE_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID], a
	call DisplayPartyMenu
.checkIfMonChosen
	jr nc, .monChosen
.goBackToPartyMenu
	call GoBackToPartyMenu
	jr .checkIfMonChosen
.monChosen
	call HasMonFainted
	jr z, .goBackToPartyMenu ; if mon fainted, you have to choose another
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, .notLinkBattle
	ld a, $1
	ld [wActionResultOrTookBattleTurn], a
	call LinkBattleExchangeData
.notLinkBattle
	xor a
	ld [wActionResultOrTookBattleTurn], a
	call ClearSprites
	ld a, [wWhichPokemon]
	ld [wPlayerMonNumber], a
	ld c, a
	ld hl, wPartyGainExpFlags
	ld b, FLAG_SET
	push bc
	predef FlagActionPredef
	pop bc
	ld hl, wPartyFoughtCurrentEnemyFlags
	predef FlagActionPredef
	call LoadBattleMonFromParty
	call GBPalWhiteOut
	call LoadHudTilePatterns
	call LoadScreenTilesFromBuffer1
	call RunDefaultPaletteCommand
	call GBPalNormal
	call SendOutMon
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl]
	ret

; called when player is out of usable mons.
; prints approriate lose message, sets carry flag if player blacked out (special case for initial rival fight)
HandlePlayerBlackOut: ; 3c89c (f:489c)
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr z, .notSony1Battle
	ld a, [wCurOpponent]
	cp OPP_SONY1
	jr nz, .notSony1Battle
	coord hl, 0, 0  ; sony 1 battle
	lb bc, 8, 21
	call ClearScreenArea
	call ScrollTrainerPicAfterBattle
	ld c, 40
	call DelayFrames
	ld hl, Sony1WinText
	call PrintText
	ld a, [wCurMap]
	cp OAKS_LAB
	ret z            ; starter battle in oak's lab: don't black out
.notSony1Battle
	ld b, SET_PAL_BATTLE_BLACK
	call RunPaletteCommand
	ld hl, PlayerBlackedOutText2
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, .noLinkBattle
	ld hl, LinkBattleLostText
.noLinkBattle
	call PrintText
	ld a, [wd732]
	res 5, a
	ld [wd732], a
	call ClearScreen
	scf
	ret

Sony1WinText: ; 3c8e9 (f:48e9)
	TX_FAR _Sony1WinText
	db "@"

PlayerBlackedOutText2: ; 3c8ee (f:48ee)
	TX_FAR _PlayerBlackedOutText2
	db "@"

LinkBattleLostText: ; 3c8f3 (f:48f3)
	TX_FAR _LinkBattleLostText
	db "@"

; slides pic of fainted mon downwards until it disappears
; bug: when this is called, [H_AUTOBGTRANSFERENABLED] is non-zero, so there is screen tearing
SlideDownFaintedMonPic: ; 3c8f8 (f:48f8)
	ld a, [wd730]
	push af
	set 6, a
	ld [wd730], a
	ld b, 7 ; number of times to slide
.slideStepLoop ; each iteration, the mon is slid down one row
	push bc
	push de
	push hl
	ld b, 6 ; number of rows
.rowLoop
	push bc
	push hl
	push de
	ld bc, $7
	call CopyData
	pop de
	pop hl
	ld bc, -SCREEN_WIDTH
	add hl, bc
	push hl
	ld h, d
	ld l, e
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	pop bc
	dec b
	jr nz, .rowLoop
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld de, SevenSpacesText
	call PlaceString
	ld c, 2
	call DelayFrames
	pop hl
	pop de
	pop bc
	dec b
	jr nz, .slideStepLoop
	pop af
	ld [wd730], a
	ret

SevenSpacesText: ; 3c93c (f:493c)
	db "       @"

; slides the player or enemy trainer off screen
; a is the number of tiles to slide it horizontally (always 9 for the player trainer or 8 for the enemy trainer)
; if a is 8, the slide is to the right, else it is to the left
; bug: when this is called, [H_AUTOBGTRANSFERENABLED] is non-zero, so there is screen tearing
SlideTrainerPicOffScreen: ; 3c944 (f:4944)
	ld [hSlideAmount], a
	ld c, a
.slideStepLoop ; each iteration, the trainer pic is slid one tile left/right
	push bc
	push hl
	ld b, 7 ; number of rows
.rowLoop
	push hl
	ld a, [hSlideAmount]
	ld c, a
.columnLoop
	ld a, [hSlideAmount]
	cp 8
	jr z, .slideRight
.slideLeft ; slide player sprite off screen
	ld a, [hld]
	ld [hli], a
	inc hl
	jr .nextColumn
.slideRight ; slide enemy trainer sprite off screen
	ld a, [hli]
	ld [hld], a
	dec hl
.nextColumn
	dec c
	jr nz, .columnLoop
	pop hl
	ld de, 20
	add hl, de
	dec b
	jr nz, .rowLoop
	ld c, 2
	call DelayFrames
	pop hl
	pop bc
	dec c
	jr nz, .slideStepLoop
	ret

; send out a trainer's mon
EnemySendOut: ; 3c973 (f:4973)
	ld hl,wPartyGainExpFlags
	xor a
	ld [hl],a
	ld a,[wPlayerMonNumber]
	ld c,a
	ld b,FLAG_SET
	push bc
	predef FlagActionPredef
	ld hl,wPartyFoughtCurrentEnemyFlags
	xor a
	ld [hl],a
	pop bc
	predef FlagActionPredef

; don't change wPartyGainExpFlags or wPartyFoughtCurrentEnemyFlags
EnemySendOutFirstMon: ; 3c98f (f:498f)
	xor a
	ld hl,wEnemyStatsToDouble ; clear enemy statuses
	ld [hli],a
	ld [hli],a
	ld [hli],a
	ld [hli],a
	ld [hl],a
	ld [wEnemyDisabledMove],a
	ld [wEnemyDisabledMoveNumber],a
	ld [wEnemyMonMinimized],a
	ld hl,wPlayerUsedMove
	ld [hli],a
	ld [hl],a
	dec a
	ld [wAICount],a
	ld hl,wPlayerBattleStatus1
	res 5,[hl]
	coord hl, 18, 0
	ld a,8
	call SlideTrainerPicOffScreen
	call PrintEmptyString
	call SaveScreenTilesToBuffer1
	ld a,[wLinkState]
	cp LINK_STATE_BATTLING
	jr nz,.next
	ld a,[wSerialExchangeNybbleReceiveData]
	sub 4
	ld [wWhichPokemon],a
	jr .next3
.next
	ld b,$FF
.next2
	inc b
	ld a,[wEnemyMonPartyPos]
	cp b
	jr z,.next2
	ld hl,wEnemyMon1
	ld a,b
	ld [wWhichPokemon],a
	push bc
	ld bc,wEnemyMon2 - wEnemyMon1
	call AddNTimes
	pop bc
	inc hl
	ld a,[hli]
	ld c,a
	ld a,[hl]
	or c
	jr z,.next2
.next3
	ld a,[wWhichPokemon]
	ld hl,wEnemyMon1Level
	ld bc,wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld a,[hl]
	ld [wCurEnemyLVL],a
	ld a,[wWhichPokemon]
	inc a
	ld hl,wEnemyPartyCount
	ld c,a
	ld b,0
	add hl,bc
	ld a,[hl]
	ld [wEnemyMonSpecies2],a
	ld [wcf91],a
	call LoadEnemyMonData
	ld hl,wEnemyMonHP
	ld a,[hli]
	ld [wLastSwitchInEnemyMonHP],a
	ld a,[hl]
	ld [wLastSwitchInEnemyMonHP + 1],a
	ld a,1
	ld [wCurrentMenuItem],a
	ld a,[wFirstMonsNotOutYet]
	dec a
	jr z,.next4
	ld a,[wPartyCount]
	dec a
	jr z,.next4
	ld a,[wLinkState]
	cp LINK_STATE_BATTLING
	jr z,.next4
	ld a,[wOptions]
	bit 6,a
	jr nz,.next4
	ld hl, TrainerAboutToUseText
	call PrintText
	coord hl, 0, 7
	lb bc, 8, 1
	ld a,TWO_OPTION_MENU
	ld [wTextBoxID],a
	call DisplayTextBoxID
	ld a,[wCurrentMenuItem]
	and a
	jr nz,.next4
	ld a,BATTLE_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID],a
	call DisplayPartyMenu
.next9
	ld a,1
	ld [wCurrentMenuItem],a
	jr c,.next7
	ld hl,wPlayerMonNumber
	ld a,[wWhichPokemon]
	cp [hl]
	jr nz,.next6
	ld hl,AlreadyOutText
	call PrintText
.next8
	call GoBackToPartyMenu
	jr .next9
.next6
	call HasMonFainted
	jr z,.next8
	xor a
	ld [wCurrentMenuItem],a
.next7
	call GBPalWhiteOut
	call LoadHudTilePatterns
	call LoadScreenTilesFromBuffer1
.next4
	call ClearSprites
	coord hl, 0, 0
	lb bc, 4, 11
	call ClearScreenArea
	ld b, SET_PAL_BATTLE
	call RunPaletteCommand
	call GBPalNormal
	ld hl,TrainerSentOutText
	call PrintText
	ld a,[wEnemyMonSpecies2]
	ld [wcf91],a
	ld [wd0b5],a
	call GetMonHeader
	ld de,vFrontPic
	call LoadMonFrontSprite
	ld a,-$31
	ld [hStartTileID],a
	coord hl, 15, 6
	predef AnimateSendingOutMon
	ld a,[wEnemyMonSpecies2]
	call PlayCry
	call DrawEnemyHUDAndHPBar
	ld a,[wCurrentMenuItem]
	and a
	ret nz
	xor a
	ld [wPartyGainExpFlags],a
	ld [wPartyFoughtCurrentEnemyFlags],a
	call SaveScreenTilesToBuffer1
	jp SwitchPlayerMon

TrainerAboutToUseText: ; 3cade (f:4ade)
	TX_FAR _TrainerAboutToUseText
	db "@"

TrainerSentOutText: ; 3cae3 (f:4ae3)
	TX_FAR _TrainerSentOutText
	db "@"

; tests if the player has any pokemon that are not fainted
; sets d = 0 if all fainted, d != 0 if some mons are still alive
AnyPartyAlive: ; 3cae8 (f:4ae8)
	ld a, [wPartyCount]
	ld e, a
	xor a
	ld hl, wPartyMon1HP
	ld bc, wPartyMon2 - wPartyMon1 - 1
.partyMonsLoop
	or [hl]
	inc hl
	or [hl]
	add hl, bc
	dec e
	jr nz, .partyMonsLoop
	ld d, a
	ret

; tests if player mon has fainted
; stores whether mon has fainted in Z flag
HasMonFainted: ; 3cafc (f:4afc)
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1HP
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a, [hli]
	or [hl]
	ret nz
	ld a, [wFirstMonsNotOutYet]
	and a
	jr nz, .done
	ld hl, NoWillText
	call PrintText
.done
	xor a
	ret

NoWillText: ; 3cb19 (f:4b19)
	TX_FAR _NoWillText
	db "@"

; try to run from battle (hl = player speed, de = enemy speed)
; stores whether the attempt was successful in carry flag
TryRunningFromBattle: ; 3cb1e (f:4b1e)
	call IsGhostBattle
	jp z, .canEscape ; jump if it's a ghost battle
	ld a, [wBattleType]
	cp $2
	jp z, .canEscape ; jump if it's a safari battle
	cp $3
	jp z, .canEscape ; hurry, get away?
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jp z, .canEscape
	ld a, [wIsInBattle]
	dec a
	jr nz, .trainerBattle ; jump if it's a trainer battle
	ld a, [wNumRunAttempts]
	inc a
	ld [wNumRunAttempts], a
	ld a, [hli]
	ld [H_MULTIPLICAND + 1], a
	ld a, [hl]
	ld [H_MULTIPLICAND + 2], a
	ld a, [de]
	ld [hEnemySpeed], a
	inc de
	ld a, [de]
	ld [hEnemySpeed + 1], a
	call LoadScreenTilesFromBuffer1
	ld de, H_MULTIPLICAND + 1
	ld hl, hEnemySpeed
	ld c, 2
	call StringCmp
	jr nc, .canEscape ; jump if player speed greater than enemy speed
	xor a
	ld [H_MULTIPLICAND], a
	ld a, 32
	ld [H_MULTIPLIER], a
	call Multiply ; multiply player speed by 32
	ld a, [H_PRODUCT + 2]
	ld [H_DIVIDEND], a
	ld a, [H_PRODUCT + 3]
	ld [H_DIVIDEND + 1], a
	ld a, [hEnemySpeed]
	ld b, a
	ld a, [hEnemySpeed + 1]
; divide enemy speed by 4
	srl b
	rr a
	srl b
	rr a
	and a
	jr z, .canEscape ; jump if enemy speed divided by 4, mod 256 is 0
	ld [H_DIVISOR], a ; ((enemy speed / 4) % 256)
	ld b, $2
	call Divide ; divide (player speed * 32) by ((enemy speed / 4) % 256)
	ld a, [H_QUOTIENT + 2]
	and a ; is the quotient greater than 256?
	jr nz, .canEscape ; if so, the player can escape
	ld a, [wNumRunAttempts]
	ld c, a
; add 30 to the quotient for each run attempt
.loop
	dec c
	jr z, .compareWithRandomValue
	ld b, 30
	ld a, [H_QUOTIENT + 3]
	add b
	ld [H_QUOTIENT + 3], a
	jr c, .canEscape
	jr .loop
.compareWithRandomValue
	call BattleRandom
	ld b, a
	ld a, [H_QUOTIENT + 3]
	cp b
	jr nc, .canEscape ; if the random value was less than or equal to the quotient
	                  ; plus 30 times the number of attempts, the player can escape
; can't escape
	ld a, $1
	ld [wActionResultOrTookBattleTurn], a ; you lose your turn when you can't escape
	ld hl, CantEscapeText
	jr .printCantEscapeOrNoRunningText
.trainerBattle
	ld hl, NoRunningText
.printCantEscapeOrNoRunningText
	call PrintText
	ld a, 1
	ld [wForcePlayerToChooseMon], a
	call SaveScreenTilesToBuffer1
	and a ; reset carry
	ret
.canEscape
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ld a, $2
	jr nz, .playSound
; link battle
	call SaveScreenTilesToBuffer1
	xor a
	ld [wActionResultOrTookBattleTurn], a
	ld a, $f
	ld [wPlayerMoveListIndex], a
	call LinkBattleExchangeData
	call LoadScreenTilesFromBuffer1
	ld a, [wSerialExchangeNybbleReceiveData]
	cp $f
	ld a, $2
	jr z, .playSound
	dec a
.playSound
	ld [wBattleResult], a
	ld a, SFX_RUN
	call PlaySoundWaitForCurrent
	ld hl, GotAwayText
	call PrintText
	call WaitForSoundToFinish
	call SaveScreenTilesToBuffer1
	scf ; set carry
	ret

CantEscapeText: ; 3cc01 (f:4c01)
	TX_FAR _CantEscapeText
	db "@"

NoRunningText: ; 3cc06 (f:4c06)
	TX_FAR _NoRunningText
	db "@"

GotAwayText: ; 3cc0b (f:4c0b)
	TX_FAR _GotAwayText
	db "@"

; copies from party data to battle mon data when sending out a new player mon
LoadBattleMonFromParty: ; 3cc10 (f:4c10)
	ld a, [wWhichPokemon]
	ld bc, wPartyMon2 - wPartyMon1
	ld hl, wPartyMon1Species
	call AddNTimes
	ld de, wBattleMonSpecies
	ld bc, wBattleMonDVs - wBattleMonSpecies
	call CopyData
	ld bc, wPartyMon1DVs - wPartyMon1OTID
	add hl, bc
	ld de, wBattleMonDVs
	ld bc, NUM_DVS
	call CopyData
	ld de, wBattleMonPP
	ld bc, NUM_MOVES
	call CopyData
	ld de, wBattleMonLevel
	ld bc, $b
	call CopyData
	ld a, [wBattleMonSpecies2]
	ld [wd0b5], a
	call GetMonHeader
	ld hl, wPartyMonNicks
	ld a, [wPlayerMonNumber]
	call SkipFixedLengthTextEntries
	ld de, wBattleMonNick
	ld bc, NAME_LENGTH
	call CopyData
	ld hl, wBattleMonLevel
	ld de, wPlayerMonUnmodifiedLevel ; block of memory used for unmodified stats
	ld bc, 1 + NUM_STATS * 2
	call CopyData
	call ApplyBurnAndParalysisPenaltiesToPlayer
	call ApplyBadgeStatBoosts
	ld a, $7 ; default stat modifier
	ld b, NUM_STAT_MODS
	ld hl, wPlayerMonAttackMod
.statModLoop
	ld [hli], a
	dec b
	jr nz, .statModLoop
	ret

; copies from enemy party data to current enemy mon data when sending out a new enemy mon
LoadEnemyMonFromParty: ; 3cc7d (f:4c7d)
	ld a, [wWhichPokemon]
	ld bc, wEnemyMon2 - wEnemyMon1
	ld hl, wEnemyMons
	call AddNTimes
	ld de, wEnemyMonSpecies
	ld bc, wEnemyMonDVs - wEnemyMonSpecies
	call CopyData
	ld bc, wEnemyMon1DVs - wEnemyMon1OTID
	add hl, bc
	ld de, wEnemyMonDVs
	ld bc, NUM_DVS
	call CopyData
	ld de, wEnemyMonPP
	ld bc, NUM_MOVES
	call CopyData
	ld de, wEnemyMonLevel
	ld bc, $b
	call CopyData
	ld a, [wEnemyMonSpecies]
	ld [wd0b5], a
	call GetMonHeader
	ld hl, wEnemyMonNicks
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
	ld de, wEnemyMonNick
	ld bc, NAME_LENGTH
	call CopyData
	ld hl, wEnemyMonLevel
	ld de, wEnemyMonUnmodifiedLevel ; block of memory used for unmodified stats
	ld bc, 1 + NUM_STATS * 2
	call CopyData
	call ApplyBurnAndParalysisPenaltiesToEnemy
	ld hl, wMonHBaseStats
	ld de, wEnemyMonBaseStats
	ld b, NUM_STATS
.copyBaseStatsLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .copyBaseStatsLoop
	ld a, $7 ; default stat modifier
	ld b, NUM_STAT_MODS
	ld hl, wEnemyMonStatMods
.statModLoop
	ld [hli], a
	dec b
	jr nz, .statModLoop
	ld a, [wWhichPokemon]
	ld [wEnemyMonPartyPos], a
	ret

SendOutMon: ; 3ccfb (f:4cfb)
	callab PrintSendOutMonMessage
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl] ; is enemy mon HP zero?
	jp z, .skipDrawingEnemyHUDAndHPBar; if HP is zero, skip drawing the HUD and HP bar
	call DrawEnemyHUDAndHPBar
.skipDrawingEnemyHUDAndHPBar
	call DrawPlayerHUDAndHPBar
	predef LoadMonBackPic
	xor a
	ld [hStartTileID], a
	ld hl, wBattleAndStartSavedMenuItem
	ld [hli], a
	ld [hl], a
	ld [wBoostExpByExpAll], a
	ld [wDamageMultipliers], a
	ld [wPlayerMoveNum], a
	ld hl, wPlayerUsedMove
	ld [hli], a
	ld [hl], a
	ld hl, wPlayerStatsToDouble
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [wPlayerDisabledMove], a
	ld [wPlayerDisabledMoveNumber], a
	ld [wPlayerMonMinimized], a
	ld b, SET_PAL_BATTLE
	call RunPaletteCommand
	ld hl, wEnemyBattleStatus1
	res UsingTrappingMove, [hl]
	callab IsThisPartymonStarterPikachu
	jr c, .starterPikachu
	ld a, $1
	ld [H_WHOSETURN], a
	ld a, POOF_ANIM
	call PlayMoveAnimation
	coord hl, 4, 11
	predef AnimateSendingOutMon
	jr .playRegularCry
.starterPikachu
	xor a
	ld [H_WHOSETURN], a
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	callab Func_f429f
	callab Func_fd0d0
	ld e, $24
	jr c, .asm_3cd81
	ld e, $a
.asm_3cd81
	callab PlayPikachuSoundClip
	jr .done
.playRegularCry
	ld a, [wcf91]
	call PlayCry
.done
	call PrintEmptyString
	jp SaveScreenTilesToBuffer1

; show 2 stages of the player mon getting smaller before disappearing
AnimateRetreatingPlayerMon: ; 3cd97 (f:4d97)
	ld a, [wWhichPokemon]
	push af
	ld a, [wPlayerMonNumber]
	ld [wWhichPokemon], a
	callab IsThisPartymonStarterPikachu
	pop bc
	ld a, b
	ld [wWhichPokemon], a
	jr c, .starterPikachu
	coord hl, 1, 5
	lb bc, 7, 7
	call ClearScreenArea
	coord hl, 3, 7
	lb bc, 5, 5
	xor a
	ld [wDownscaledMonSize], a
	ld [hBaseTileID], a
	predef CopyDownscaledMonTiles
	ld c, 4
	call DelayFrames
	call .clearScreenArea
	coord hl, 4, 9
	lb bc, 3, 3
	ld a, 1
	ld [wDownscaledMonSize], a
	xor a
	ld [hBaseTileID], a
	predef CopyDownscaledMonTiles
	call Delay3
	call .clearScreenArea
	ld a, $4c
	Coorda 5, 11
	jr .clearScreenArea
.starterPikachu
	xor a
	ld [H_WHOSETURN], a
	callab AnimationSlideMonOff
	ret
.clearScreenArea
	coord hl, 1, 5
	lb bc, 7, 7
	call ClearScreenArea ; jp
	ret

; reads player's current mon's HP into wBattleMonHP
ReadPlayerMonCurHPAndStatus: ; 3ce08 (f:4e08)
	ld a, [wPlayerMonNumber]
	ld hl, wPartyMon1HP
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, wBattleMonHP
	ld bc, $4               ; 2 bytes HP, 1 byte unknown (unused?), 1 byte status
	jp CopyData

DrawHUDsAndHPBars: ; 3ce1f (f:4e1f)
	call DrawPlayerHUDAndHPBar
	jp DrawEnemyHUDAndHPBar

DrawPlayerHUDAndHPBar: ; 3ce25 (f:4e25)
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	coord hl, 9, 7
	lb bc, 5, 11
	call ClearScreenArea
	callab PlacePlayerHUDTiles
	coord hl, 18, 9
	ld [hl], $73
	ld de, wBattleMonNick
	coord hl, 10, 7
	call CenterMonName
	call PlaceString
	ld hl, wBattleMonSpecies
	ld de, wLoadedMon
	ld bc, $c
	call CopyData
	ld hl, wBattleMonLevel
	ld de, wLoadedMonLevel
	ld bc, $b
	call CopyData
	coord hl, 14, 8
	push hl
	inc hl
	ld de, wLoadedMonStatus
	call PrintStatusConditionNotFainted
	pop hl
	jr nz, .doNotPrintLevel
	call PrintLevel
.doNotPrintLevel
	ld a, [wLoadedMonSpecies]
	ld [wcf91], a
	coord hl, 10, 9
	predef DrawHP
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	ld hl, wPlayerHPBarColor
	call GetBattleHealthBarColor
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl]
	jr z, .fainted
	ld a, [wLowHealthAlarmDisabled]
	and a ; has the alarm been disabled because the player has already won?
	ret nz ; if so, return
	ld a, [wPlayerHPBarColor]
	cp HP_BAR_RED
	jr z, .setLowHealthAlarm
.fainted
	ld hl, wLowHealthAlarm
	bit 7, [hl] ;low health alarm enabled?
	ld [hl], $0
	ret z
	xor a
	ld [wChannelSoundIDs + CH4], a
	ret
.setLowHealthAlarm
	ld hl, wLowHealthAlarm
	set 7, [hl] ;enable low health alarm
	ret

DrawEnemyHUDAndHPBar: ; 3ceb1 (f:4eb1)
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	coord hl, 0, 0
	lb bc, 4, 12
	call ClearScreenArea
	callab PlaceEnemyHUDTiles
	ld de, wEnemyMonNick
	coord hl, 1, 0
	call CenterMonName
	call PlaceString
	coord hl, 4, 1
	push hl
	inc hl
	ld de, wEnemyMonStatus
	call PrintStatusConditionNotFainted
	pop hl
	jr nz, .skipPrintLevel ; if the mon has a status condition, skip printing the level
	ld a, [wEnemyMonLevel]
	ld [wLoadedMonLevel], a
	call PrintLevel
.skipPrintLevel
	ld hl, wEnemyMonHP
	ld a, [hli]
	ld [H_MULTIPLICAND + 1], a
	ld a, [hld]
	ld [H_MULTIPLICAND + 2], a
	or [hl] ; is current HP zero?
	jr nz, .hpNonzero
; current HP is 0
; set variables for DrawHPBar
	ld c, a
	ld e, a
	ld d, $6
	jp .drawHPBar
.hpNonzero
	xor a
	ld [H_MULTIPLICAND], a
	ld a, 48
	ld [H_MULTIPLIER], a
	call Multiply ; multiply current HP by 48
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld [H_DIVISOR], a
	ld a, b
	and a ; is max HP > 255?
	jr z, .doDivide
; if max HP > 255, scale both (current HP * 48) and max HP by dividing by 4 so that max HP fits in one byte
; (it needs to be one byte so it can be used as the divisor for the Divide function)
	ld a, [H_DIVISOR]
	srl b
	rr a
	srl b
	rr a
	ld [H_DIVISOR], a
	ld a, [H_PRODUCT + 2]
	ld b, a
	srl b
	ld a, [H_PRODUCT + 3]
	rr a
	srl b
	rr a
	ld [H_PRODUCT + 3], a
	ld a, b
	ld [H_PRODUCT + 2], a
.doDivide
	ld a, [H_PRODUCT + 2]
	ld [H_DIVIDEND], a
	ld a, [H_PRODUCT + 3]
	ld [H_DIVIDEND + 1], a
	ld a, $2
	ld b, a
	call Divide ; divide (current HP * 48) by max HP
	ld a, [H_QUOTIENT + 3]
; set variables for DrawHPBar
	ld e, a
	ld a, $6
	ld d, a
	ld c, a
.drawHPBar
	xor a
	ld [wHPBarType], a
	coord hl, 2, 2
	call DrawHPBar
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	ld hl, wEnemyHPBarColor

GetBattleHealthBarColor: ; 3cf55 (f:4f55)
	ld b, [hl]
	call GetHealthBarColor
	ld a, [hl]
	cp b
	ret z
	ld b, SET_PAL_BATTLE
	jp RunPaletteCommand

; center's mon's name on the battle screen
; if the name is 1 or 2 letters long, it is printed 2 spaces more to the right than usual
; (i.e. for names longer than 4 letters)
; if the name is 3 or 4 letters long, it is printed 1 space more to the right than usual
; (i.e. for names longer than 4 letters)
CenterMonName: ; 3cf61 (f:4f61)
	push de
	inc hl
	inc hl
	ld b, $2
.loop
	inc de
	ld a, [de]
	cp "@"
	jr z, .done
	inc de
	ld a, [de]
	cp "@"
	jr z, .done
	dec hl
	dec b
	jr nz, .loop
.done
	pop de
	ret

DisplayBattleMenu: ; 3cf78 (f:4f78)
	call LoadScreenTilesFromBuffer1 ; restore saved screen
	ld a, [wBattleType]
	and a
	jr nz, .nonstandardbattle
	call DrawHUDsAndHPBars
	call PrintEmptyString
	call SaveScreenTilesToBuffer1
.nonstandardbattle
	ld a, [wBattleType]
	cp $2 ; safari
	ld a, BATTLE_MENU_TEMPLATE
	jr nz, .menuselected
	ld a, SAFARI_BATTLE_MENU_TEMPLATE
.menuselected
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld a, [wBattleType]
	cp $1
	jr z, .doSimulatedMenuInput ; simulate menu input if it's the old man or prof. oak pikachu battle
	cp $4
	jr z, .doSimulatedMenuInput
	jp .handleBattleMenuInput
; the following happens for the old man tutorial and prof. oak pikachu battle
.doSimulatedMenuInput
	ld hl, wPlayerName
	ld de, wGrassRate
	ld bc, NAME_LENGTH
	call CopyData  ; temporarily save the player name in unused space,
	               ; which is supposed to get overwritten when entering a
	               ; map with wild Pokémon.
				   ; In Red/Blue, due to an oversight, the data
	               ; may not get overwritten (cinnabar) and the infamous
	               ; Missingno. glitch can show up. However,
				   ; this has been fixed in yellow
	ld hl, .oldManName
	ld a, [wBattleType]
	dec a
	jr z, .useOldManName
	ld hl, .profOakName
.useOldManName
	ld de, wPlayerName
	ld bc, NAME_LENGTH
	call CopyData
; the following simulates the keystrokes by drawing menus on screen
	coord hl, 9, 14
	ld [hl], "▶"
	ld c, 20
	call DelayFrames
	ld [hl], " "
	coord hl, 9, 16
	ld [hl], "▶"
	ld c, 20
	call DelayFrames
	ld [hl], $ec
	ld a, $2 ; select the "ITEM" menu
	jp .upperLeftMenuItemWasNotSelected
.oldManName
	db "OLD MAN@"
.profOakName
	db "PROF.OAK@"
.handleBattleMenuInput
	ld a, [wBattleAndStartSavedMenuItem]
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	sub 2 ; check if the cursor is in the left column
	jr c, .leftColumn
; cursor is in the right column
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	jr .rightColumn
.leftColumn ; put cursor in left column of menu
	ld a, [wBattleType]
	cp $2
	ld a, " "
	jr z, .safariLeftColumn
; put cursor in left column for normal battle menu (i.e. when it's not a Safari battle)
	Coorda 15, 14 ; clear upper cursor position in right column
	Coorda 15, 16 ; clear lower cursor position in right column
	ld b, $9 ; top menu item X
	jr .leftColumn_WaitForInput
.safariLeftColumn
	Coorda 13, 14
	Coorda 13, 16
	coord hl, 7, 14
	ld de, wNumSafariBalls
	lb bc, 1, 2
	call PrintNumber
	ld b, $1 ; top menu item X
.leftColumn_WaitForInput
	ld hl, wTopMenuItemY
	ld a, $e
	ld [hli], a ; wTopMenuItemY
	ld a, b
	ld [hli], a ; wTopMenuItemX
	inc hl
	inc hl
	ld a, $1
	ld [hli], a ; wMaxMenuItem
	ld [hl], D_RIGHT | A_BUTTON ; wMenuWatchedKeys
	call HandleMenuInput
	bit 4, a ; check if right was pressed
	jr nz, .rightColumn
	jr .AButtonPressed ; the A button was pressed
.rightColumn ; put cursor in right column of menu
	ld a, [wBattleType]
	cp $2
	ld a, " "
	jr z, .safariRightColumn
; put cursor in right column for normal battle menu (i.e. when it's not a Safari battle)
	Coorda 9, 14 ; clear upper cursor position in left column
	Coorda 9, 16 ; clear lower cursor position in left column
	ld b, $f ; top menu item X
	jr .rightColumn_WaitForInput
.safariRightColumn
	Coorda 1, 14 ; clear upper cursor position in left column
	Coorda 1, 16 ; clear lower cursor position in left column
	coord hl, 7, 14
	ld de, wNumSafariBalls
	lb bc, 1, 2
	call PrintNumber
	ld b, $d ; top menu item X
.rightColumn_WaitForInput
	ld hl, wTopMenuItemY
	ld a, $e
	ld [hli], a ; wTopMenuItemY
	ld a, b
	ld [hli], a ; wTopMenuItemX
	inc hl
	inc hl
	ld a, $1
	ld [hli], a ; wMaxMenuItem
	ld a, D_LEFT | A_BUTTON
	ld [hli], a ; wMenuWatchedKeys
	call HandleMenuInput
	bit 5, a ; check if left was pressed
	jr nz, .leftColumn ; if left was pressed, jump
	ld a, [wCurrentMenuItem]
	add $2 ; if we're in the right column, the actual id is +2
	ld [wCurrentMenuItem], a
.AButtonPressed
	call PlaceUnfilledArrowMenuCursor
	ld a, [wBattleType]
	cp HURRY_RUN_AWAY_BATTLE
	jr z, .handleUnusedBattle
	ld a, [wBattleType]
	cp SAFARI_BATTLE ; is it a Safari battle?
	ld a, [wCurrentMenuItem]
	ld [wBattleAndStartSavedMenuItem], a
	jr z, .handleMenuSelection
; not Safari battle
; swap the IDs of the item menu and party menu (this is probably because they swapped the positions
; of these menu items in first generation English versions)
	cp $1 ; was the item menu selected?
	jr nz, .notItemMenu
; item menu was selected
	inc a ; increment a to 2
	jr .handleMenuSelection
.notItemMenu
	cp $2 ; was the party menu selected?
	jr nz, .handleMenuSelection
; party menu selected
	dec a ; decrement a to 1
.handleMenuSelection
	and a
	jr nz, .upperLeftMenuItemWasNotSelected
; the upper left menu item was selected
	ld a, [wBattleType]
	cp $2
	jr z, .throwSafariBallWasSelected
; the "FIGHT" menu was selected
	xor a
	ld [wNumRunAttempts], a
	jp LoadScreenTilesFromBuffer1 ; restore saved screen and return
.throwSafariBallWasSelected
	ld a, SAFARI_BALL
	ld [wcf91], a
	jp UseBagItem
.handleUnusedBattle
	ld a, [wCurrentMenuItem]
	cp $3
	jp z, BattleMenu_RunWasSelected
	ld hl, .RunAwayText
	call PrintText
	jp DisplayBattleMenu

.RunAwayText ; 3d0df (f:50df)
	TX_FAR _RunAwayText
	db "@"
	
.upperLeftMenuItemWasNotSelected ; a menu item other than the upper left item was selected
	cp $2
	jp nz, PartyMenuOrRockOrRun
	
; either the bag (normal battle) or bait (safari battle) was selected
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, .notLinkBattle

; can't use items in link battles
	ld hl, ItemsCantBeUsedHereText
	call PrintText
	jp DisplayBattleMenu

.notLinkBattle
	call SaveScreenTilesToBuffer2
	ld a, [wBattleType]
	cp $2 ; is it a safari battle?
	jr nz, BagWasSelected

; bait was selected
	ld a, SAFARI_BAIT
	ld [wcf91], a
	jr UseBagItem

BagWasSelected: ; 3d10a (f:510a)
	call LoadScreenTilesFromBuffer1
	ld a, [wBattleType]
	and a ; is it a normal battle?
	jr nz, .next

; normal battle
	call DrawHUDsAndHPBars
.next
	ld a, [wBattleType]
	cp OLD_MAN_BATTLE ; is it the old man tutorial?
	jr z, .simulatedInputBattle
	cp STARTER_PIKACHU_BATTLE ; is it the prof oak battle with pikachu?
	jr z, .simulatedInputBattle
	jr DisplayPlayerBag
.simulatedInputBattle
	ld hl, SimulatedInputBattleItemList
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a
	jr DisplayBagMenu

SimulatedInputBattleItemList: ; 3c130 (f:5130)
	db 1 ; # of items
	db POKE_BALL, 1
	db $ff

DisplayPlayerBag: ; 3c134 (f:5134)
	; get the pointer to player's bag when in a normal battle
	ld hl, wNumBagItems
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a

DisplayBagMenu: ; 3c13f (f:513f)
	xor a
	ld [wPrintItemPrices], a
	ld a, ITEMLISTMENU
	ld [wListMenuID], a
	ld a, [wBagSavedMenuItem]
	ld [wCurrentMenuItem], a
	call DisplayListMenuID
	ld a, [wCurrentMenuItem]
	ld [wBagSavedMenuItem], a
	ld a, $0
	ld [wMenuWatchMovingOutOfBounds], a
	ld [wMenuItemToSwap], a
	jp c, DisplayBattleMenu ; go back to battle menu if an item was not selected

UseBagItem: ; 3c162 (f:5162)
	; either use an item from the bag or use a safari zone item
	ld a, [wcf91]
	ld [wd11e], a
	call GetItemName
	call CopyStringToCF4B ; copy name
	xor a
	ld [wPseudoItemID], a
	call UseItem
	call LoadHudTilePatterns
	call ClearSprites
	xor a
	ld [wCurrentMenuItem], a
	ld a, [wBattleType]
	cp SAFARI_BATTLE ; is it a safari battle?
	jr z, .checkIfMonCaptured

	ld a, [wActionResultOrTookBattleTurn]
	and a ; was the item used successfully?
	jp z, BagWasSelected ; if not, go back to the bag menu

	ld a, [wPlayerBattleStatus1]
	bit UsingTrappingMove, a ; is the player using a multi-turn move like wrap?
	jr z, .checkIfMonCaptured
	ld hl, wPlayerNumAttacksLeft
	dec [hl]
	jr nz, .checkIfMonCaptured
	ld hl, wPlayerBattleStatus1
	res UsingTrappingMove, [hl] ; not using multi-turn move any more

.checkIfMonCaptured
	ld a, [wCapturedMonSpecies]
	and a ; was the enemy mon captured with a ball?
	jr nz, .returnAfterCapturingMon

	ld a, [wBattleType]
	cp SAFARI_BATTLE ; is it a safari battle?
	jr z, .returnAfterUsingItem_NoCapture
; not a safari battle
	call LoadScreenTilesFromBuffer1
	call DrawHUDsAndHPBars
	call Delay3
.returnAfterUsingItem_NoCapture

	call GBPalNormal
	and a ; reset carry
	ret

.returnAfterCapturingMon
	call GBPalNormal
	xor a
	ld [wCapturedMonSpecies], a
	ld a, $2
	ld [wBattleResult], a
	scf ; set carry
	ret

ItemsCantBeUsedHereText: ; 3d1c8 (f:51c8)
	TX_FAR _ItemsCantBeUsedHereText
	db "@"

PartyMenuOrRockOrRun: ; 3d1cd (f:51cd)
	dec a ; was Run selected?
	jp nz, BattleMenu_RunWasSelected
; party menu or rock was selected
	call SaveScreenTilesToBuffer2
	ld a, [wBattleType]
	cp $2 ; is it a safari battle?
	jr nz, .partyMenuWasSelected
; safari battle
	ld a, SAFARI_ROCK
	ld [wcf91], a
	jp UseBagItem
.partyMenuWasSelected
	call LoadScreenTilesFromBuffer1
	xor a ; NORMAL_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID], a
	ld [wMenuItemToSwap], a
	call DisplayPartyMenu
.checkIfPartyMonWasSelected
	jp nc, .partyMonWasSelected ; if a party mon was selected, jump, else we quit the party menu
.quitPartyMenu
	call ClearSprites
	call GBPalWhiteOut
	call LoadHudTilePatterns
	call LoadScreenTilesFromBuffer2
	call RunDefaultPaletteCommand
	call GBPalNormal
	jp DisplayBattleMenu
.partyMonDeselected
	coord hl, 11, 11
	ld bc, 6 * SCREEN_WIDTH + 9
	ld a, " "
	call FillMemory
	xor a ; NORMAL_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID], a
	call GoBackToPartyMenu
	jr .checkIfPartyMonWasSelected
.partyMonWasSelected
	ld a, SWITCH_STATS_CANCEL_MENU_TEMPLATE
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld hl, wTopMenuItemY
	ld a, $c
	ld [hli], a ; wTopMenuItemY
	ld [hli], a ; wTopMenuItemX
	xor a
	ld [hli], a ; wCurrentMenuItem
	inc hl
	ld a, $2
	ld [hli], a ; wMaxMenuItem
	ld a, B_BUTTON | A_BUTTON
	ld [hli], a ; wMenuWatchedKeys
	xor a
	ld [hl], a ; wLastMenuItem
	call HandleMenuInput
	bit 1, a ; was A pressed?
	jr nz, .partyMonDeselected ; if B was pressed, jump
; A was pressed
	call PlaceUnfilledArrowMenuCursor
	ld a, [wCurrentMenuItem]
	cp $2 ; was Cancel selected?
	jr z, .quitPartyMenu ; if so, quit the party menu entirely
	and a ; was Switch selected?
	jr z, .switchMon ; if so, jump
; Stats was selected
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	ld hl, wPartyMon1
	call ClearSprites
; display the two status screens
	predef StatusScreen
	predef StatusScreen2
; now we need to reload the enemy mon pic
	ld a, $1
	ld [H_WHOSETURN], a
	ld a, [wEnemyBattleStatus2]
	bit HasSubstituteUp, a ; does the enemy mon have a substitute?
	ld hl, AnimationSubstitute
	jr nz, .doEnemyMonAnimation
; enemy mon doesn't have substitute
	ld a, [wEnemyMonMinimized]
	and a ; has the enemy mon used Minimise?
	ld hl, AnimationMinimizeMon
	jr nz, .doEnemyMonAnimation
; enemy mon is not minimised
	ld a, [wEnemyMonSpecies]
	ld [wcf91], a
	ld [wd0b5], a
	call GetMonHeader
	ld de, vFrontPic
	call LoadMonFrontSprite
	jr .enemyMonPicReloaded
.doEnemyMonAnimation
	ld b, BANK(AnimationSubstitute) ; BANK(AnimationMinimizeMon)
	call Bankswitch
.enemyMonPicReloaded ; enemy mon pic has been reloaded, so return to the party menu
	jp .partyMenuWasSelected
.switchMon
	ld a, [wPlayerMonNumber]
	ld d, a
	ld a, [wWhichPokemon]
	cp d ; check if the mon to switch to is already out
	jr nz, .notAlreadyOut
; mon is already out
	ld hl, AlreadyOutText
	call PrintText
	jp .partyMonDeselected
.notAlreadyOut
	call HasMonFainted
	jp z, .partyMonDeselected ; can't switch to fainted mon
	ld a, $1
	ld [wActionResultOrTookBattleTurn], a
	call GBPalWhiteOut
	call ClearSprites
	call LoadHudTilePatterns
	call LoadScreenTilesFromBuffer1
	call RunDefaultPaletteCommand
	call GBPalNormal
; fall through to SwitchPlayerMon

SwitchPlayerMon: ; 3d2c1 (f:52c1)
	callab RetreatMon
	ld c, 50
	call DelayFrames
	call AnimateRetreatingPlayerMon
	ld a, [wWhichPokemon]
	ld [wPlayerMonNumber], a
	ld c, a
	ld b, FLAG_SET
	push bc
	ld hl, wPartyGainExpFlags
	predef FlagActionPredef
	pop bc
	ld hl, wPartyFoughtCurrentEnemyFlags
	predef FlagActionPredef
	call LoadBattleMonFromParty
	call SendOutMon
	call SaveScreenTilesToBuffer1
	ld a, $2
	ld [wCurrentMenuItem], a
	and a
	ret

AlreadyOutText: ; 3d2fc (f:52fc)
	TX_FAR _AlreadyOutText
	db "@"

BattleMenu_RunWasSelected: ; 3d301 (f:5301)
	call LoadScreenTilesFromBuffer1
	ld a, $3
	ld [wCurrentMenuItem], a
	ld hl, wBattleMonSpeed
	ld de, wEnemyMonSpeed
	call TryRunningFromBattle
	ld a, 0
	ld [wForcePlayerToChooseMon], a
	ret c
	ld a, [wActionResultOrTookBattleTurn]
	and a
	ret nz ; return if the player couldn't escape
	jp DisplayBattleMenu

MoveSelectionMenu: ; 3d320 (f:5320)
	ld a, [wMoveMenuType]
	dec a
	jr z, .mimicmenu
	dec a
	jr z, .relearnmenu
	jr .regularmenu

.loadmoves
	ld de, wMoves
	ld bc, NUM_MOVES
	call CopyData
	callab FormatMovesString
	ret

.writemoves
	ld de, wMovesString
	ld a, [hFlags_0xFFFA]
	set 2, a
	ld [hFlags_0xFFFA], a
	call PlaceString
	ld a, [hFlags_0xFFFA]
	res 2, a
	ld [hFlags_0xFFFA], a
	ret

.regularmenu
	call AnyMoveToSelect
	ret z
	ld hl, wBattleMonMoves
	call .loadmoves
	coord hl, 4, 12
	lb bc, 4, 14
	di ; out of pure coincidence, it is possible for vblank to occur between the di and ei
	   ; so it is necessary to put the di ei block to not cause tearing
	call TextBoxBorder
	coord hl, 4, 12
	ld [hl], $7a
	coord hl, 10, 12
	ld [hl], $7e
	ei
	coord hl, 6, 13
	call .writemoves
	ld b, $5
	ld a, $c
	jr .menuset
.mimicmenu
	ld hl, wEnemyMonMoves
	call .loadmoves
	coord hl, 0, 7
	lb bc, 4, 14
	call TextBoxBorder
	coord hl, 2, 8
	call .writemoves
	ld b, $1
	ld a, $7
	jr .menuset
.relearnmenu
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1Moves
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	call .loadmoves
	coord hl, 4, 7
	lb bc, 4, 14
	call TextBoxBorder
	coord hl, 6, 8
	call .writemoves
	ld b, $5
	ld a, $7
.menuset
	ld hl, wTopMenuItemY
	ld [hli], a ; wTopMenuItemY
	ld a, b
	ld [hli], a ; wTopMenuItemX
	ld a, [wMoveMenuType]
	cp $1
	jr z, .selectedmoveknown
	ld a, [wPlayerMoveListIndex]
	inc a
.selectedmoveknown
	ld [hli], a ; wCurrentMenuItem
	inc hl ; wTileBehindCursor untouched
	ld a, [wNumMovesMinusOne]
	inc a
	inc a
	ld [hli], a ; wMaxMenuItem
	ld a, [wMoveMenuType]
	dec a
	ld b, D_UP | D_DOWN | A_BUTTON
	jr z, .matchedkeyspicked
	dec a
	ld b, D_UP | D_DOWN | A_BUTTON | B_BUTTON
	jr z, .matchedkeyspicked
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr z, .matchedkeyspicked
	ld a, [wFlags_D733]
	bit BIT_TEST_BATTLE, a
	ld b, D_UP | D_DOWN | A_BUTTON | B_BUTTON | SELECT
	jr z, .matchedkeyspicked
	ld b, $ff
.matchedkeyspicked
	ld a, b
	ld [hli], a ; wMenuWatchedKeys
	ld a, [wMoveMenuType]
	cp $1
	jr z, .movelistindex1
	ld a, [wPlayerMoveListIndex]
	inc a
.movelistindex1
	ld [hl], a
; fallthrough

SelectMenuItem: ; 3d3fe (f:53fe)
	ld a, [wMoveMenuType]
	and a
	jr z, .battleselect
	dec a
	jr nz, .select
	coord hl, 1, 14
	ld de, WhichTechniqueString
	call PlaceString
	jr .select
.battleselect
	ld a, [wFlags_D733]
	bit BIT_TEST_BATTLE, a
	jr nz, .select
	call PrintMenuItem
	ld a, [wMenuItemToSwap]
	and a
	jr z, .select
	coord hl, 5, 13
	dec a
	ld bc, SCREEN_WIDTH
	call AddNTimes
	ld [hl], $ec
.select
	ld hl, hFlags_0xFFFA
	set 1, [hl]
	call HandleMenuInput
	ld hl, hFlags_0xFFFA
	res 1, [hl]
	bit 6, a
	jp nz, SelectMenuItem_CursorUp ; up
	bit 7, a
	jp nz, SelectMenuItem_CursorDown ; down
	bit 2, a
	jp nz, SwapMovesInMenu ; select
	bit 1, a ; B, but was it reset above?
	push af
	xor a
	ld [wMenuItemToSwap], a
	ld a, [wCurrentMenuItem]
	dec a
	ld [wCurrentMenuItem], a
	ld b, a
	ld a, [wMoveMenuType]
	dec a ; if not mimic
	jr nz, .notB
	pop af
	ret
.notB
	dec a
	ld a, b
	ld [wPlayerMoveListIndex], a
	jr nz, .moveselected
	pop af
	ret
.moveselected
	pop af
	ret nz
	ld hl, wBattleMonPP
	ld a, [wCurrentMenuItem]
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	and $3f
	jr z, .noPP
	ld a, [wPlayerDisabledMove]
	swap a
	and $f
	dec a
	cp c
	jr z, .disabled
	ld a, [wPlayerBattleStatus3]
	bit 3, a ; transformed
	jr nz, .dummy ; game freak derp
.dummy
	ld a, [wCurrentMenuItem]
	ld hl, wBattleMonMoves
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	ld [wPlayerSelectedMove], a
	xor a
	ret
.disabled
	ld hl, MoveDisabledText
	jr .print
.noPP
	ld hl, MoveNoPPText
.print
	call PrintText
	call LoadScreenTilesFromBuffer1
	jp MoveSelectionMenu

MoveNoPPText: ; 3d4ae (f:54ae)
	TX_FAR _MoveNoPPText
	db "@"

MoveDisabledText: ; 3d4b3 (f:54b3)
	TX_FAR _MoveDisabledText
	db "@"

WhichTechniqueString: ; 3d4b8 (f:54b8)
	db "WHICH TECHNIQUE?@"

SelectMenuItem_CursorUp: ; 3d4c9 (f:54c9)
	ld a, [wCurrentMenuItem]
	and a
	jp nz, SelectMenuItem
	call EraseMenuCursor
	ld a, [wNumMovesMinusOne]
	inc a
	ld [wCurrentMenuItem], a
	jp SelectMenuItem

SelectMenuItem_CursorDown: ; 3d4dd (f:54dd)
	ld a, [wCurrentMenuItem]
	ld b, a
	ld a, [wNumMovesMinusOne]
	inc a
	inc a
	cp b
	jp nz, SelectMenuItem
	call EraseMenuCursor
	ld a, $1
	ld [wCurrentMenuItem], a
	jp SelectMenuItem

Func_3d4f5: ; 3d4f5 (f:54f5)
	bit 3, a
	ld a, $0
	jr nz, .asm_3d4fd
	ld a, $1
.asm_3d4fd
	ld [H_WHOSETURN], a
	call LoadScreenTilesFromBuffer1
	call Func_3d536
	ld a, [wTestBattlePlayerSelectedMove]
	and a
	jp z, MoveSelectionMenu
	ld [wAnimationID], a
	xor a
	ld [wAnimationType], a
	predef MoveAnimation
	callab Func_78e98
	jp MoveSelectionMenu
	
Func_3d523: ; 3d523 (f:5523)
	ld a, [wTestBattlePlayerSelectedMove]
	dec a
	jr asm_3d52d
Func_3d529: ; 3d529 (f:5529)
	ld a, [wTestBattlePlayerSelectedMove]
	inc a
asm_3d52d: ; 3d52d (f:552d)
	ld [wTestBattlePlayerSelectedMove], a
	call Func_3d536
	jp MoveSelectionMenu

Func_3d536: ; 3d536 (f:5536)
	coord hl, 10, 16
	lb bc, 2, 10
	call ClearScreenArea
	coord hl, 10, 17
	ld de, wTestBattlePlayerSelectedMove
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	ld a, [wTestBattlePlayerSelectedMove]
	and a
	ret z
	cp STRUGGLE
	ret nc
	ld [wd11e], a
	call GetMoveName
	coord hl, 13, 17
	jp PlaceString

AnyMoveToSelect: ; 3d55f (f:555f)
; return z and Struggle as the selected move if all moves have 0 PP and/or are disabled
	ld a, STRUGGLE
	ld [wPlayerSelectedMove], a
	ld a, [wPlayerDisabledMove]
	and a
	ld hl, wBattleMonPP
	jr nz, .handleDisabledMove
	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	inc hl
	or [hl]
	and $3f
	ret nz
	jr .noMovesLeft
.handleDisabledMove
	swap a
	and $f ; get move disabled
	ld b, a
	ld d, NUM_MOVES + 1
	xor a
.handleDisabledMovePPLoop
	dec d
	jr z, .allMovesChecked
	ld c, [hl] ; get move PP
	inc hl
	dec b ; is this the disabled move?
	jr z, .handleDisabledMovePPLoop ; if so, ignore its PP value
	or c
	jr .handleDisabledMovePPLoop
.allMovesChecked
; bugfix: only check PP value and not PP up bits
; in case all other moves have no PP left and a move has a PP up used on it
; and a non-PP up move is disabled 
	and $3f ; any PP left?
	ret nz ; return if a move has PP left
.noMovesLeft
	ld hl, NoMovesLeftText
	call PrintText
	ld c, 60
	call DelayFrames
	xor a
	ret

NoMovesLeftText: ; 3d59b (f:559b)
	TX_FAR _NoMovesLeftText
	db "@"

SwapMovesInMenu: ; 3d5a0 (f:55a0)
	ld a, [wPlayerBattleStatus3]
	bit Transformed, a
	jp nz, MoveSelectionMenu
	ld a, [wMenuItemToSwap]
	and a
	jr z, .noMenuItemSelected
	ld hl, wBattleMonMoves
	call .swapBytes ; swap moves
	ld hl, wBattleMonPP
	call .swapBytes ; swap move PP
; update the index of the disabled move if necessary
	ld hl, wPlayerDisabledMove
	ld a, [hl]
	swap a
	and $f
	ld b, a
	ld a, [wCurrentMenuItem]
	cp b
	jr nz, .next
	ld a, [hl]
	and $f
	ld b, a
	ld a, [wMenuItemToSwap]
	swap a
	add b
	ld [hl], a
	jr .swapMovesInPartyMon
.next
	ld a, [wMenuItemToSwap]
	cp b
	jr nz, .swapMovesInPartyMon
	ld a, [hl]
	and $f
	ld b, a
	ld a, [wCurrentMenuItem]
	swap a
	add b
	ld [hl], a
.swapMovesInPartyMon
	ld hl, wPartyMon1Moves
	ld a, [wPlayerMonNumber]
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	push hl
	call .swapBytes ; swap moves
	pop hl
	ld bc, wPartyMon1PP - wPartyMon1Moves
	add hl, bc
	call .swapBytes ; swap move PP
	xor a
	ld [wMenuItemToSwap], a ; deselect the item
	jp MoveSelectionMenu
.swapBytes
	push hl
	ld a, [wMenuItemToSwap]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld a, [wCurrentMenuItem]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [de]
	ld b, [hl]
	ld [hl], a
	ld a, b
	ld [de], a
	ret
.noMenuItemSelected
	ld a, [wCurrentMenuItem]
	ld [wMenuItemToSwap], a ; select the current menu item for swapping
	jp MoveSelectionMenu

PrintMenuItem: ; 3d629 (f:5629)
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	coord hl, 0, 8
	lb bc, 3, 9
	call TextBoxBorder
	ld a, [wPlayerDisabledMove]
	and a
	jr z, .notDisabled
	swap a
	and $f
	ld b, a
	ld a, [wCurrentMenuItem]
	cp b
	jr nz, .notDisabled
	coord hl, 1, 10
	ld de, DisabledText
	call PlaceString
	jr .moveDisabled
.notDisabled
	ld hl, wCurrentMenuItem
	dec [hl]
	xor a
	ld [H_WHOSETURN], a
	ld hl, wBattleMonMoves
	ld a, [wCurrentMenuItem]
	ld c, a
	ld b, $0 ; which item in the menu is the cursor pointing to? (0-3)
	add hl, bc ; point to the item (move) in memory
	ld a, [hl]
	ld [wPlayerSelectedMove], a ; update wPlayerSelectedMove even if the move
	                            ; isn't actually selected (just pointed to by the cursor)
	ld a, [wPlayerMonNumber]
	ld [wWhichPokemon], a
	ld a, BATTLE_MON_DATA
	ld [wMonDataLocation], a
	callab GetMaxPP
	ld hl, wCurrentMenuItem
	ld c, [hl]
	inc [hl]
	ld b, $0
	ld hl, wBattleMonPP
	add hl, bc
	ld a, [hl]
	and $3f
	ld [wcd6d], a
; print TYPE/<type> and <curPP>/<maxPP>
	coord hl, 1, 9
	ld de, TypeText
	call PlaceString
	coord hl, 7, 11
	ld [hl], "/"
	coord hl, 5, 9
	ld [hl], "/"
	coord hl, 5, 11
	ld de, wcd6d
	lb bc, 1, 2
	call PrintNumber
	coord hl, 8, 11
	ld de, wMaxPP
	lb bc, 1, 2
	call PrintNumber
	call GetCurrentMove
	coord hl, 2, 10
	predef PrintMoveType
.moveDisabled
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	jp Delay3

DisabledText: ; 3d6c7 (f:56c7)
	db "Disabled!@"

TypeText: ; 3d6d1 (f:56d1)
	db "TYPE@"

SelectEnemyMove: ; 3d6d6 (f:56d6)
	ld a, [wLinkState]
	sub LINK_STATE_BATTLING
	jr nz, .noLinkBattle
; link battle
	call SaveScreenTilesToBuffer1
	call LinkBattleExchangeData
	call LoadScreenTilesFromBuffer1
	ld a, [wSerialExchangeNybbleReceiveData]
	cp $e
	jp z, .linkedOpponentUsedStruggle
	cp $d
	jr z, .unableToSelectMove
	cp $4
	ret nc
	ld [wEnemyMoveListIndex], a
	ld c, a
	ld hl, wEnemyMonMoves
	ld b, $0
	add hl, bc
	ld a, [hl]
	jr .done
.noLinkBattle
	ld a, [wEnemyBattleStatus2]
	and (1 << NeedsToRecharge) | (1 << UsingRage) ; need to recharge or using rage
	ret nz
	ld hl, wEnemyBattleStatus1
	ld a, [hl]
	and (1 << ChargingUp) | (1 << ThrashingAbout) ; using a charging move or thrash/petal dance
	ret nz
	ld a, [wEnemyMonStatus]
	and SLP | 1 << FRZ ; sleeping or frozen
	ret nz
	ld a, [wEnemyBattleStatus1]
	and (1 << UsingTrappingMove) | (1 << StoringEnergy) ; using a trapping move like wrap or bide
	ret nz
	ld a, [wPlayerBattleStatus1]
	bit UsingTrappingMove, a ; caught in player's trapping move (e.g. wrap)
	jr z, .canSelectMove
.unableToSelectMove
	ld a, $ff
	jr .done
.canSelectMove
	ld hl, wEnemyMonMoves+1 ; 2nd enemy move
	ld a, [hld]
	and a
	jr nz, .atLeastTwoMovesAvailable
	ld a, [wEnemyDisabledMove]
	and a
	ld a, STRUGGLE ; struggle if the only move is disabled
	jr nz, .done
.atLeastTwoMovesAvailable
	ld a, [wIsInBattle]
	dec a
	jr z, .chooseRandomMove ; wild encounter
	callab AIEnemyTrainerChooseMoves
.chooseRandomMove
	push hl
	call BattleRandom
	ld b, $1
	cp $3f ; select move 1, [0,3e] (63/256 chance)
	jr c, .moveChosen
	inc hl
	inc b
	cp $7f ; select move 2, [3f,7e] (64/256 chance)
	jr c, .moveChosen
	inc hl
	inc b
	cp $be ; select move 3, [7f,bd] (63/256 chance)
	jr c, .moveChosen
	inc hl
	inc b ; select move 4, [be,ff] (66/256 chance)
.moveChosen
	ld a, b
	dec a
	ld [wEnemyMoveListIndex], a
	ld a, [wEnemyDisabledMove]
	swap a
	and $f
	cp b
	ld a, [hl]
	pop hl
	jr z, .chooseRandomMove ; move disabled, try again
	and a
	jr z, .chooseRandomMove ; move non-existant, try again
.done
	ld [wEnemySelectedMove], a
	ret
.linkedOpponentUsedStruggle
	ld a, STRUGGLE
	jr .done

; this appears to exchange data with the other gameboy during link battles
LinkBattleExchangeData: ; 3d777 (f:5777)
	ld a, $ff
	ld [wSerialExchangeNybbleReceiveData], a
	ld a, [wPlayerMoveListIndex]
	cp $f ; is the player running from battle?
	jr z, .doExchange
	ld a, [wActionResultOrTookBattleTurn]
	and a ; is the player switching in another mon?
	jr nz, .switching
; the player used a move
	ld a, [wPlayerSelectedMove]
	cp STRUGGLE
	ld b, $e
	jr z, .next
	dec b
	inc a
	jr z, .next
	ld a, [wPlayerMoveListIndex]
	jr .doExchange
.switching
	ld a, [wWhichPokemon]
	add 4
	ld b, a
.next
	ld a, b
.doExchange
	ld [wSerialExchangeNybbleSendData], a
	callab PrintWaitingText
.syncLoop1
	call Serial_ExchangeNybble
	call DelayFrame
	ld a, [wSerialExchangeNybbleReceiveData]
	inc a
	jr z, .syncLoop1
	ld b, 10
.syncLoop2
	call DelayFrame
	call Serial_ExchangeNybble
	dec b
	jr nz, .syncLoop2
	ld b, 10
.syncLoop3
	call DelayFrame
	call Serial_SendZeroByte
	dec b
	jr nz, .syncLoop3
	ret

ExecutePlayerMove: ; 3d7d0 (f:57d0)
	xor a
	ld [H_WHOSETURN], a ; set player's turn
	ld a, [wPlayerSelectedMove]
	inc a
	jp z, ExecutePlayerMoveDone ; for selected move = FF, skip most of player's turn
	xor a
	ld [wMoveMissed], a
	ld [wMonIsDisobedient], a
	ld [wMoveDidntMiss], a
	ld a, $a
	ld [wDamageMultipliers], a
	ld a, [wActionResultOrTookBattleTurn]
	and a ; has the player already used the turn (e.g. by using an item, trying to run or switching pokemon)
	jp nz, ExecutePlayerMoveDone
	call PrintGhostText
	jp z, ExecutePlayerMoveDone
	call CheckPlayerStatusConditions
	jr nz, .playerHasNoSpecialCondition
	jp [hl]
.playerHasNoSpecialCondition
	call GetCurrentMove
	ld hl, wPlayerBattleStatus1
	bit ChargingUp, [hl] ; charging up for attack
	jr nz, PlayerCanExecuteChargingMove
	call CheckForDisobedience
	jp z, ExecutePlayerMoveDone

CheckIfPlayerNeedsToChargeUp: ; 3d80c (f:580c)
	ld a, [wPlayerMoveEffect]
	cp CHARGE_EFFECT
	jp z, JumpMoveEffect
	cp FLY_EFFECT
	jp z, JumpMoveEffect
	jr PlayerCanExecuteMove

; in-battle stuff
PlayerCanExecuteChargingMove: ; 3d81b (f:581b)
	ld hl,wPlayerBattleStatus1
	res ChargingUp,[hl] ; reset charging up and invulnerability statuses if mon was charging up for an attack
	                    ; being fully paralyzed or hurting oneself in confusion removes charging up status
	                    ; resulting in the Pokemon being invulnerable for the whole battle
	res Invulnerable,[hl]
PlayerCanExecuteMove: ; 3d822 (f:5822)
	call PrintMonName1Text
	ld hl,DecrementPP
	ld de,wPlayerSelectedMove ; pointer to the move just used
	ld b,BANK(DecrementPP)
	call Bankswitch
	ld a,[wPlayerMoveEffect] ; effect of the move just used
	ld hl,ResidualEffects1
	ld de,1
	call IsInArray
	jp c,JumpMoveEffect ; ResidualEffects1 moves skip damage calculation and accuracy tests
	                    ; unless executed as part of their exclusive effect functions
	ld a,[wPlayerMoveEffect]
	ld hl,SpecialEffectsCont
	ld de,1
	call IsInArray
	call c,JumpMoveEffect ; execute the effects of SpecialEffectsCont moves (e.g. Wrap, Thrash) but don't skip anything
PlayerCalcMoveDamage: ; 3d84e (f:584e)
	ld a,[wPlayerMoveEffect]
	ld hl,SetDamageEffects
	ld de,1
	call IsInArray
	jp c,.moveHitTest ; SetDamageEffects moves (e.g. Seismic Toss and Super Fang) skip damage calculation
	call CriticalHitTest
	call HandleCounterMove
	jr z,handleIfPlayerMoveMissed
	call GetDamageVarsForPlayerAttack
	call CalculateDamage
	jp z,playerCheckIfFlyOrChargeEffect ; for moves with 0 BP, skip any further damage calculation and, for now, skip MoveHitTest
	               ; for these moves, accuracy tests will only occur if they are called as part of the effect itself
	call AdjustDamageForMoveType
	call RandomizeDamage
.moveHitTest
	call MoveHitTest
handleIfPlayerMoveMissed: ; 3d877 (f:5877)
	ld a,[wMoveMissed]
	and a
	jr z,getPlayerAnimationType
	ld a,[wPlayerMoveEffect]
	sub a,EXPLODE_EFFECT
	jr z,playPlayerMoveAnimation ; don't play any animation if the move missed, unless it was EXPLODE_EFFECT
	jr playerCheckIfFlyOrChargeEffect
getPlayerAnimationType: ; 3d87b (f:587b)
	ld a,[wPlayerMoveEffect]
	and a
	ld a,4 ; move has no effect other than dealing damage
	jr z,playPlayerMoveAnimation
	ld a,5 ; move has effect
playPlayerMoveAnimation ; 3d890 (f:5890)
	push af
	ld a,[wPlayerBattleStatus2]
	bit HasSubstituteUp,a
	ld hl,HideSubstituteShowMonAnim
	ld b,BANK(HideSubstituteShowMonAnim)
	call nz,Bankswitch
	pop af
	ld [wAnimationType],a
	ld a,[wPlayerMoveNum]
	call PlayMoveAnimation
	call HandleExplodingAnimation
	call DrawPlayerHUDAndHPBar
	ld a,[wPlayerBattleStatus2]
	bit HasSubstituteUp,a
	ld hl,ReshowSubstituteAnim
	ld b,BANK(ReshowSubstituteAnim)
	call nz,Bankswitch
	jr MirrorMoveCheck
playerCheckIfFlyOrChargeEffect ; 3d8bd (f:58bd)
	ld c,30
	call DelayFrames
	ld a,[wPlayerMoveEffect]
	cp a,FLY_EFFECT
	jr z,.playAnim
	cp a,CHARGE_EFFECT
	jr z,.playAnim
	jr MirrorMoveCheck
.playAnim
	xor a
	ld [wAnimationType],a
	ld a,STATUS_AFFECTED_ANIM
	call PlayMoveAnimation
MirrorMoveCheck: ; 3d8d8 (f:58d8)
	ld a,[wPlayerMoveEffect]
	cp a,MIRROR_MOVE_EFFECT
	jr nz,.metronomeCheck
	call MirrorMoveCopyMove
	jp z,ExecutePlayerMoveDone
	xor a
	ld [wMonIsDisobedient],a
	jp CheckIfPlayerNeedsToChargeUp ; if Mirror Move was successful go back to damage calculation for copied move
.metronomeCheck
	cp a,METRONOME_EFFECT
	jr nz,.next
	call MetronomePickMove
	jp CheckIfPlayerNeedsToChargeUp ; Go back to damage calculation for the move picked by Metronome
.next
	ld a,[wPlayerMoveEffect]
	ld hl,ResidualEffects2
	ld de,1
	call IsInArray
	jp c,JumpMoveEffect ; done here after executing effects of ResidualEffects2
	ld a,[wMoveMissed]
	and a
	jr z,.moveDidNotMiss
	call PrintMoveFailureText
	ld a,[wPlayerMoveEffect]
	cp a,EXPLODE_EFFECT ; even if Explosion or Selfdestruct missed, its effect still needs to be activated
	jr z,.notDone
	jp ExecutePlayerMoveDone ; otherwise, we're done if the move missed
.moveDidNotMiss
	call ApplyAttackToEnemyPokemon
	call PrintCriticalOHKOText
	callab DisplayEffectiveness
	ld a,1
	ld [wMoveDidntMiss],a
.notDone
	ld a,[wPlayerMoveEffect]
	ld hl,AlwaysHappenSideEffects
	ld de,1
	call IsInArray
	call c,JumpMoveEffect ; not done after executing effects of AlwaysHappenSideEffects
	ld hl,wEnemyMonHP
	ld a,[hli]
	ld b,[hl]
	or b
	ret z ; don't do anything else if the enemy fainted
	call HandleBuildingRage

	ld hl,wPlayerBattleStatus1
	bit AttackingMultipleTimes,[hl]
	jr z,.executeOtherEffects
	ld a,[wPlayerNumAttacksLeft]
	dec a
	ld [wPlayerNumAttacksLeft],a
	jp nz,getPlayerAnimationType ; for multi-hit moves, apply attack until PlayerNumAttacksLeft hits 0 or the enemy faints.
	                             ; damage calculation and accuracy tests only happen for the first hit
	res AttackingMultipleTimes,[hl] ; clear attacking multiple times status when all attacks are over
	ld hl,MultiHitText
	call PrintText
	xor a
	ld [wPlayerNumHits],a
.executeOtherEffects
	ld a,[wPlayerMoveEffect]
	and a
	jp z,ExecutePlayerMoveDone
	ld hl,SpecialEffects
	ld de,1
	call IsInArray
	call nc,JumpMoveEffect ; move effects not included in SpecialEffects or in either of the ResidualEffect arrays,
	; which are the effects not covered yet. Rage effect will be executed for a second time (though it's irrelevant).
	; Includes side effects that only need to be called if the target didn't faint.
	; Responsible for executing Twineedle's second side effect (poison).
	jp ExecutePlayerMoveDone

MultiHitText: ; 3d977 (f:5977)
	TX_FAR _MultiHitText
	db "@"

ExecutePlayerMoveDone: ; 3d97c (f:597c)
	xor a
	ld [wActionResultOrTookBattleTurn],a
	ld b,1
	ret

PrintGhostText: ; 3d983 (f:5983)
; print the ghost battle messages
	call IsGhostBattle
	ret nz
	ld a,[H_WHOSETURN]
	and a
	jr nz,.Ghost
	ld a,[wBattleMonStatus] ; player’s turn
	and a,SLP | (1 << FRZ)
	ret nz
	ld hl,ScaredText
	call PrintText
	xor a
	ret
.Ghost ; ghost’s turn
	ld hl,GetOutText
	call PrintText
	xor a
	ret

ScaredText: ; 3d9a2 (f:59a2)
	TX_FAR _ScaredText
	db "@"

GetOutText: ; 3d9a7 (f:59a7)
	TX_FAR _GetOutText
	db "@"

IsGhostBattle: ; 3d9ac (f:59ac)
	ld a,[wIsInBattle]
	dec a
	ret nz
	ld a,[wCurMap]
	cp a,POKEMONTOWER_1
	jr c,.next
	cp a,LAVENDER_HOUSE_1
	jr nc,.next
	ld b,SILPH_SCOPE
	call IsItemInBag
	ret z
.next
	ld a,1
	and a
	ret

; checks for various status conditions affecting the player mon
; stores whether the mon cannot use a move this turn in Z flag
CheckPlayerStatusConditions: ; 3d9c6 (f:59c6)
	ld hl,wBattleMonStatus
	ld a,[hl]
	and a,SLP ; sleep mask
	jr z,.FrozenCheck
; sleeping
	dec a
	ld [wBattleMonStatus],a ; decrement number of turns left
	and a
	jr z,.WakeUp ; if the number of turns hit 0, wake up
; fast asleep
	xor a
	ld [wAnimationType],a
	ld a,SLP_ANIM - 1
	call PlayMoveAnimation
	ld hl,FastAsleepText
	call PrintText
	jr .sleepDone
.WakeUp
	ld hl,WokeUpText
	call PrintText
.sleepDone
	xor a
	ld [wPlayerUsedMove],a
	ld hl,ExecutePlayerMoveDone ; player can't move this turn
	jp .returnToHL

.FrozenCheck
	bit FRZ,[hl] ; frozen?
	jr z,.HeldInPlaceCheck
	ld hl,IsFrozenText
	call PrintText
	xor a
	ld [wPlayerUsedMove],a
	ld hl,ExecutePlayerMoveDone ; player can't move this turn
	jp .returnToHL

.HeldInPlaceCheck
	ld a,[wEnemyBattleStatus1]
	bit UsingTrappingMove,a ; is enemy using a mult-turn move like wrap?
	jp z,.FlinchedCheck
	ld hl,CantMoveText
	call PrintText
	ld hl,ExecutePlayerMoveDone ; player can't move this turn
	jp .returnToHL

.FlinchedCheck
	ld hl,wPlayerBattleStatus1
	bit Flinched,[hl]
	jp z,.HyperBeamCheck
	res Flinched,[hl] ; reset player's flinch status
	ld hl,FlinchedText
	call PrintText
	ld hl,ExecutePlayerMoveDone ; player can't move this turn
	jp .returnToHL

.HyperBeamCheck
	ld hl,wPlayerBattleStatus2
	bit NeedsToRecharge,[hl]
	jr z,.AnyMoveDisabledCheck
	res NeedsToRecharge,[hl] ; reset player's recharge status
	ld hl,MustRechargeText
	call PrintText
	ld hl,ExecutePlayerMoveDone ; player can't move this turn
	jp .returnToHL

.AnyMoveDisabledCheck
	ld hl,wPlayerDisabledMove
	ld a,[hl]
	and a
	jr z,.ConfusedCheck
	dec a
	ld [hl],a
	and $f ; did Disable counter hit 0?
	jr nz,.ConfusedCheck
	ld [hl],a
	ld [wPlayerDisabledMoveNumber],a
	ld hl,DisabledNoMoreText
	call PrintText

.ConfusedCheck
	ld a,[wPlayerBattleStatus1]
	add a ; is player confused?
	jr nc,.TriedToUseDisabledMoveCheck
	ld hl,W_PLAYERCONFUSEDCOUNTER
	dec [hl]
	jr nz,.IsConfused
	ld hl,wPlayerBattleStatus1
	res Confused,[hl] ; if confused counter hit 0, reset confusion status
	ld hl,ConfusedNoMoreText
	call PrintText
	jr .TriedToUseDisabledMoveCheck
.IsConfused
	ld hl,IsConfusedText
	call PrintText
	xor a
	ld [wAnimationType],a
	ld a,CONF_ANIM - 1
	call PlayMoveAnimation
	call BattleRandom
	cp a,$80 ; 50% chance to hurt itself
	jr c,.TriedToUseDisabledMoveCheck
	ld hl,wPlayerBattleStatus1
	ld a,[hl]
	and a, 1 << Confused ; if mon hurts itself, clear every other status from wPlayerBattleStatus1
	ld [hl],a
	call HandleSelfConfusionDamage
	jr .MonHurtItselfOrFullyParalysed

.TriedToUseDisabledMoveCheck
; prevents a disabled move that was selected before being disabled from being used
	ld a,[wPlayerDisabledMoveNumber]
	and a
	jr z,.ParalysisCheck
	ld hl,wPlayerSelectedMove
	cp [hl]
	jr nz,.ParalysisCheck
	call PrintMoveIsDisabledText
	ld hl,ExecutePlayerMoveDone ; if a disabled move was somehow selected, player can't move this turn
	jp .returnToHL

.ParalysisCheck
	ld hl,wBattleMonStatus
	bit PAR,[hl]
	jr z,.BideCheck
	call BattleRandom
	cp a,$3F ; 25% to be fully paralyzed
	jr nc,.BideCheck
	ld hl,FullyParalyzedText
	call PrintText

.MonHurtItselfOrFullyParalysed
	ld hl,wPlayerBattleStatus1
	ld a,[hl]
	; clear bide, thrashing, charging up, and trapping moves such as warp (already cleared for confusion damage)
	and $ff ^ ((1 << StoringEnergy) | (1 << ThrashingAbout) | (1 << ChargingUp) | (1 << UsingTrappingMove))
	ld [hl],a
	ld a,[wPlayerMoveEffect]
	cp a,FLY_EFFECT
	jr z,.FlyOrChargeEffect
	cp a,CHARGE_EFFECT
	jr z,.FlyOrChargeEffect
	jr .NotFlyOrChargeEffect

.FlyOrChargeEffect
	xor a
	ld [wAnimationType],a
	ld a,STATUS_AFFECTED_ANIM
	call PlayMoveAnimation
.NotFlyOrChargeEffect
	ld hl,ExecutePlayerMoveDone
	jp .returnToHL ; if using a two-turn move, we need to recharge the first turn

.BideCheck
	ld hl,wPlayerBattleStatus1
	bit StoringEnergy,[hl] ; is mon using bide?
	jr z,.ThrashingAboutCheck
	xor a
	ld [wPlayerMoveNum],a
	ld hl,wDamage
	ld a,[hli]
	ld b,a
	ld c,[hl]
	ld hl,wPlayerBideAccumulatedDamage + 1
	ld a,[hl]
	add c ; acumulate damage taken
	ld [hld],a
	ld a,[hl]
	adc b
	ld [hl],a
	ld hl,wPlayerNumAttacksLeft
	dec [hl] ; did Bide counter hit 0?
	jr z,.UnleashEnergy
	ld hl,ExecutePlayerMoveDone
	jp .returnToHL ; unless mon unleashes energy, can't move this turn
.UnleashEnergy
	ld hl,wPlayerBattleStatus1
	res StoringEnergy,[hl] ; not using bide any more
	ld hl,UnleashedEnergyText
	call PrintText
	ld a,1
	ld [wPlayerMovePower],a
	ld hl,wPlayerBideAccumulatedDamage + 1
	ld a,[hld]
	add a
	ld b,a
	ld [wDamage + 1],a
	ld a,[hl]
	rl a ; double the damage
	ld [wDamage],a
	or b
	jr nz,.next
	ld a,1
	ld [wMoveMissed],a
.next
	xor a
	ld [hli],a
	ld [hl],a
	ld a,BIDE
	ld [wPlayerMoveNum],a
	ld hl,handleIfPlayerMoveMissed ; skip damage calculation, DecrementPP and MoveHitTest
	jp .returnToHL

.ThrashingAboutCheck
	bit ThrashingAbout,[hl] ; is mon using thrash or petal dance?
	jr z,.MultiturnMoveCheck
	ld a,THRASH
	ld [wPlayerMoveNum],a
	ld hl,ThrashingAboutText
	call PrintText
	ld hl,wPlayerNumAttacksLeft
	dec [hl] ; did Thrashing About counter hit 0?
	ld hl,PlayerCalcMoveDamage ; skip DecrementPP
	jp nz,.returnToHL
	push hl
	ld hl,wPlayerBattleStatus1
	res ThrashingAbout,[hl] ; no longer thrashing about
	set Confused,[hl] ; confused
	call BattleRandom
	and a,3
	inc a
	inc a ; confused for 2-5 turns
	ld [W_PLAYERCONFUSEDCOUNTER],a
	pop hl ; skip DecrementPP
	jp .returnToHL

.MultiturnMoveCheck
	bit UsingTrappingMove,[hl] ; is mon using multi-turn move?
	jp z,.RageCheck
	ld hl,AttackContinuesText
	call PrintText
	ld a,[wPlayerNumAttacksLeft]
	dec a ; did multi-turn move end?
	ld [wPlayerNumAttacksLeft],a
	ld hl,getPlayerAnimationType ; if it didn't, skip damage calculation (deal damage equal to last hit),
	                ; DecrementPP and MoveHitTest
	jp nz,.returnToHL
	jp .returnToHL

.RageCheck
	ld a, [wPlayerBattleStatus2]
	bit UsingRage, a ; is mon using rage?
	jp z, .checkPlayerStatusConditionsDone ; if we made it this far, mon can move normally this turn
	ld a, RAGE
	ld [wd11e], a
	call GetMoveName
	call CopyStringToCF4B
	xor a
	ld [wPlayerMoveEffect], a
	ld hl, PlayerCanExecuteMove
	jp .returnToHL

.returnToHL
	xor a
	ret

.checkPlayerStatusConditionsDone
	ld a, $1
	and a
	ret

FastAsleepText: ; 3dbaf (f:5baf)
	TX_FAR _FastAsleepText
	db "@"

WokeUpText: ; 3dbb4 (f:5bb4)
	TX_FAR _WokeUpText
	db "@"

IsFrozenText: ; 3dbb9 (f:5bb9)
	TX_FAR _IsFrozenText
	db "@"

FullyParalyzedText: ; 3dbbe (f:5bbe)
	TX_FAR _FullyParalyzedText
	db "@"

FlinchedText: ; 3dbc3 (f:5bc3)
	TX_FAR _FlinchedText
	db "@"

MustRechargeText: ; 3dbc8 (f:5bc8)
	TX_FAR _MustRechargeText
	db "@"

DisabledNoMoreText: ; 3dbcd (f:5bcd)
	TX_FAR _DisabledNoMoreText
	db "@"

IsConfusedText: ; 3dbd2 (f:5bd2)
	TX_FAR _IsConfusedText
	db "@"

HurtItselfText: ; 3dbd7 (f:5bd7)
	TX_FAR _HurtItselfText
	db "@"

ConfusedNoMoreText: ; 3dbdc (f:5bdc)
	TX_FAR _ConfusedNoMoreText
	db "@"

SavingEnergyText: ; 3dbe1 (f:5be1)
	TX_FAR _SavingEnergyText
	db "@"

UnleashedEnergyText: ; 3dbe6 (f:5be6)
	TX_FAR _UnleashedEnergyText
	db "@"

ThrashingAboutText: ; 3dbeb (f:5beb)
	TX_FAR _ThrashingAboutText
	db "@"

AttackContinuesText: ; 3dbf0 (f:5bf0)
	TX_FAR _AttackContinuesText
	db "@"

CantMoveText: ; 3dbf5 (f:5bf5)
	TX_FAR _CantMoveText
	db "@"

PrintMoveIsDisabledText: ; 3dbfa (f:5bfa)
	ld hl, wPlayerSelectedMove
	ld de, wPlayerBattleStatus1
	ld a, [H_WHOSETURN]
	and a
	jr z, .removeChargingUp
	inc hl
	ld de, wEnemyBattleStatus1
.removeChargingUp
	ld a, [de]
	res ChargingUp, a ; end the pokemon's
	ld [de], a
	ld a, [hl]
	ld [wd11e], a
	call GetMoveName
	ld hl, MoveIsDisabledText
	jp PrintText

MoveIsDisabledText: ; 3dc1a (f:5c1a)
	TX_FAR _MoveIsDisabledText
	db "@"

HandleSelfConfusionDamage: ; 3dc1f (f:5c1f)
	ld hl, HurtItselfText
	call PrintText
	ld hl, wEnemyMonDefense
	ld a, [hli]
	push af
	ld a, [hld]
	push af
	ld a, [wBattleMonDefense]
	ld [hli], a
	ld a, [wBattleMonDefense + 1]
	ld [hl], a
	ld hl, wPlayerMoveEffect
	push hl
	ld a, [hl]
	push af
	xor a
	ld [hli], a
	ld [wCriticalHitOrOHKO], a ; self-inflicted confusion damage can't be a Critical Hit
	ld a, 40 ; 40 base power
	ld [hli], a
	xor a
	ld [hl], a
	call GetDamageVarsForPlayerAttack
	call CalculateDamage ; ignores AdjustDamageForMoveType (type-less damage), RandomizeDamage,
	                     ; and MoveHitTest (always hits)
	pop af
	pop hl
	ld [hl], a
	ld hl, wEnemyMonDefense + 1
	pop af
	ld [hld], a
	pop af
	ld [hl], a
	xor a
	ld [wAnimationType], a
	inc a
	ld [H_WHOSETURN], a
	call PlayMoveAnimation
	call DrawPlayerHUDAndHPBar
	xor a
	ld [H_WHOSETURN], a
	jp ApplyDamageToPlayerPokemon

PrintMonName1Text: ; 3dc67 (f:5c67)
	ld hl, MonName1Text
	jp PrintText

; this function wastes time calling DetermineExclamationPointTextNum
; and choosing between Used1Text and Used2Text, even though
; those text strings are identical and both continue at PrintInsteadText
; this likely had to do with Japanese grammar that got translated,
; but the functionality didn't get removed
MonName1Text: ; 3dc6d (f:5c6d)
	TX_FAR _MonName1Text
	TX_ASM
	ld a, [H_WHOSETURN]
	and a
	ld a, [wPlayerMoveNum]
	ld hl, wPlayerUsedMove
	jr z, .playerTurn
	ld a, [wEnemyMoveNum]
	ld hl, wEnemyUsedMove
.playerTurn
	ld [hl], a
	ld [wd11e], a
	call DetermineExclamationPointTextNum
	ld a, [wMonIsDisobedient]
	and a
	ld hl, Used2Text
	ret nz
	ld a, [wd11e]
	cp 3
	ld hl, Used2Text
	ret c
	ld hl, Used1Text
	ret

Used1Text: ; 3dc9f (f:5c9f)
	TX_FAR _Used1Text
	TX_ASM
	jr PrintInsteadText

Used2Text: ; 3dca6 (f:5ca6)
	TX_FAR _Used2Text
	TX_ASM
	; fall through

PrintInsteadText: ; 3dcab (f:5cab)
	ld a, [wMonIsDisobedient]
	and a
	jr z, PrintMoveName
	ld hl, InsteadText
	ret

InsteadText: ; 3dcb5 (f:5cb5)
	TX_FAR _InsteadText
	TX_ASM
	; fall through

PrintMoveName: ; 3dcba (f:5cba)
	ld hl, _PrintMoveName
	ret

_PrintMoveName: ; 3dcbe (f:5cbe)
	TX_FAR _CF4BText
	TX_ASM
	ld hl, ExclamationPointPointerTable
	ld a, [wd11e] ; exclamation point num
	add a
	push bc
	ld b, $0
	ld c, a
	add hl, bc
	pop bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

ExclamationPointPointerTable: ; 3dcd4 (f:5cd4)
	dw ExclamationPoint1Text
	dw ExclamationPoint2Text
	dw ExclamationPoint3Text
	dw ExclamationPoint4Text
	dw ExclamationPoint5Text

ExclamationPoint1Text: ; 3dcde (f:5cde)
	TX_FAR _ExclamationPoint1Text
	db "@"

ExclamationPoint2Text: ; 3dce3 (f:5ce3)
	TX_FAR _ExclamationPoint2Text
	db "@"

ExclamationPoint3Text: ; 3dce8 (f:5ce8)
	TX_FAR _ExclamationPoint3Text
	db "@"

ExclamationPoint4Text: ; 3dced (f:5ced)
	TX_FAR _ExclamationPoint4Text
	db "@"

ExclamationPoint5Text: ; 3dcf2 (f:5cf2)
	TX_FAR _ExclamationPoint5Text
	db "@"

; this function does nothing useful
; if the move being used is in set [1-4] from ExclamationPointMoveSets,
; use ExclamationPoint[1-4]Text
; otherwise, use ExclamationPoint5Text
; but all five text strings are identical
; this likely had to do with Japanese grammar that got translated,
; but the functionality didn't get removed
DetermineExclamationPointTextNum: ; 3dcf7 (f:5cf7)
	push bc
	ld a, [wd11e] ; move ID
	ld c, a
	ld b, $0
	ld hl, ExclamationPointMoveSets
.loop
	ld a, [hli]
	cp $ff
	jr z, .done
	cp c
	jr z, .done
	and a
	jr nz, .loop
	inc b
	jr .loop
.done
	ld a, b
	ld [wd11e], a ; exclamation point num
	pop bc
	ret

ExclamationPointMoveSets: ; 3dd15 (f:5d15)
; a grammar mistake was fixed (only concerning japanese)
; BIDE is in category 3, moved from category 2
	db SWORDS_DANCE, GROWTH
	db $00
	db RECOVER, SELFDESTRUCT, AMNESIA
	db $00
	db MEDITATE, AGILITY, TELEPORT, MIMIC, DOUBLE_TEAM, BIDE, BARRAGE
	db $00
	db POUND, SCRATCH, VICEGRIP, WING_ATTACK, FLY, BIND, SLAM, HORN_ATTACK, BODY_SLAM
	db WRAP, THRASH, TAIL_WHIP, LEER, BITE, GROWL, ROAR, SING, PECK, COUNTER
	db STRENGTH, ABSORB, STRING_SHOT, EARTHQUAKE, FISSURE, DIG, TOXIC, SCREECH, HARDEN
	db MINIMIZE, WITHDRAW, DEFENSE_CURL, METRONOME, LICK, CLAMP, CONSTRICT, POISON_GAS
	db LEECH_LIFE, BUBBLE, FLASH, SPLASH, ACID_ARMOR, FURY_SWIPES, REST, SHARPEN, SLASH, SUBSTITUTE
	db $00
	db $FF ; terminator

PrintMoveFailureText: ; 3dd54 (f:5d54)
	ld de, wPlayerMoveEffect
	ld a, [H_WHOSETURN]
	and a
	jr z, .playersTurn
	ld de, wEnemyMoveEffect
.playersTurn
	ld hl, DoesntAffectMonText
	ld a, [wDamageMultipliers]
	and $7f
	jr z, .gotTextToPrint
	ld hl, AttackMissedText
	ld a, [wCriticalHitOrOHKO]
	cp $ff
	jr nz, .gotTextToPrint
	ld hl, UnaffectedText
.gotTextToPrint
	push de
	call PrintText
	xor a
	ld [wCriticalHitOrOHKO], a
	pop de
	ld a, [de]
	cp JUMP_KICK_EFFECT
	ret nz

	; if you get here, the mon used jump kick or hi jump kick and missed
	ld hl, wDamage ; since the move missed, W_DAMAGE will always contain 0 at this point.
	                ; Thus, recoil damage will always be equal to 1
	                ; even if it was intended to be potential damage/8.
	ld a, [hli]
	ld b, [hl]
	srl a
	rr b
	srl a
	rr b
	srl a
	rr b
	ld [hl], b
	dec hl
	ld [hli], a
	or b
	jr nz, .applyRecoil
	inc a
	ld [hl], a
.applyRecoil
	ld hl, KeptGoingAndCrashedText
	call PrintText
	ld b, $4
	predef PredefShakeScreenHorizontally
	ld a, [H_WHOSETURN]
	and a
	jr nz, .enemyTurn
	jp ApplyDamageToPlayerPokemon
.enemyTurn
	jp ApplyDamageToEnemyPokemon

AttackMissedText: ; 3ddb4 (f:5db4)
	TX_FAR _AttackMissedText
	db "@"

KeptGoingAndCrashedText: ; 3ddb9 (f:5db9)
	TX_FAR _KeptGoingAndCrashedText
	db "@"

UnaffectedText: ; 3ddbe (f:5dbe)
	TX_FAR _UnaffectedText
	db "@"

PrintDoesntAffectText: ; 3ddc3 (f:5dc3)
	ld hl, DoesntAffectMonText
	jp PrintText
	
DoesntAffectMonText: ; 3ddc9 (f:5dc9)
	TX_FAR _DoesntAffectMonText
	db "@"

; if there was a critical hit or an OHKO was successful, print the corresponding text
PrintCriticalOHKOText: ; 3ddce (f:5dce)
	ld a, [wCriticalHitOrOHKO]
	and a
	jr z, .done ; do nothing if there was no critical hit or successful OHKO
	dec a
	add a
	ld hl, CriticalOHKOTextPointers
	ld b, $0
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintText
	xor a
	ld [wCriticalHitOrOHKO], a
.done
	ld c, 20
	jp DelayFrames

CriticalOHKOTextPointers: ; 3ddec (f:5dec)
	dw CriticalHitText
	dw OHKOText

CriticalHitText: ; 3ddf0 (f:5df0)
	TX_FAR _CriticalHitText
	db "@"

OHKOText: ; 3ddf5 (f:5df5)
	TX_FAR _OHKOText
	db "@"

; checks if a traded mon will disobey due to lack of badges
; stores whether the mon will use a move in Z flag
CheckForDisobedience: ; 3ddfa (f:5dfa)
	xor a
	ld [wMonIsDisobedient], a
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, .checkIfMonIsTraded
	ld a, $1
	and a
	ret
; compare the mon's original trainer ID with the player's ID to see if it was traded
.checkIfMonIsTraded
	ld hl, wPartyMon1OTID
	ld bc, wPartyMon2 - wPartyMon1
	ld a, [wPlayerMonNumber]
	call AddNTimes
	ld a, [wPlayerID]
	cp [hl]
	jr nz, .monIsTraded
	inc hl
	ld a, [wPlayerID + 1]
	cp [hl]
	jp z, .canUseMove
; it was traded
.monIsTraded
; what level might disobey?
	ld hl, wObtainedBadges
	bit 7, [hl]
	ld a, 101
	jr nz, .next
	bit 5, [hl]
	ld a, 70
	jr nz, .next
	bit 3, [hl]
	ld a, 50
	jr nz, .next
	bit 1, [hl]
	ld a, 30
	jr nz, .next
	ld a, 10
.next
	ld b, a
	ld c, a
	ld a, [wBattleMonLevel]
	ld d, a
	add b
	ld b, a
	jr nc, .noCarry
	ld b, $ff ; cap b at $ff
.noCarry
	ld a, c
	cp d
	jp nc, .canUseMove
.loop1
	call BattleRandom
	swap a
	cp b
	jr nc, .loop1
	cp c
	jp c, .canUseMove
.loop2
	call BattleRandom
	cp b
	jr nc, .loop2
	cp c
	jr c, .useRandomMove
	ld a, d
	sub c
	ld b, a
	call BattleRandom
	swap a
	sub b
	jr c, .monNaps
	cp b
	jr nc, .monDoesNothing
	ld hl, WontObeyText
	call PrintText
	call HandleSelfConfusionDamage
	jp .cannotUseMove
.monNaps
	call BattleRandom
	add a
	swap a
	and SLP ; sleep mask
	jr z, .monNaps ; keep trying until we get at least 1 turn of sleep
	ld [wBattleMonStatus], a
	ld hl, BeganToNapText
	jr .printText
.monDoesNothing
	call BattleRandom
	and $3
	ld hl, LoafingAroundText
	and a
	jr z, .printText
	ld hl, WontObeyText
	dec a
	jr z, .printText
	ld hl, TurnedAwayText
	dec a
	jr z, .printText
	ld hl, IgnoredOrdersText
.printText
	call PrintText
	jr .cannotUseMove
.useRandomMove
	ld a, [wBattleMonMoves + 1]
	and a ; is the second move slot empty?
	jr z, .monDoesNothing ; mon will not use move if it only knows one move
	ld a, [wPlayerDisabledMoveNumber]
	and a
	jr nz, .monDoesNothing
	ld a, [wPlayerSelectedMove]
	cp STRUGGLE
	jr z, .monDoesNothing ; mon will not use move if struggling
; check if only one move has remaining PP
	ld hl, wBattleMonPP
	push hl
	ld a, [hli]
	and $3f
	ld b, a
	ld a, [hli]
	and $3f
	add b
	ld b, a
	ld a, [hli]
	and $3f
	add b
	ld b, a
	ld a, [hl]
	and $3f
	add b
	pop hl
	push af
	ld a, [wCurrentMenuItem]
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	and $3f
	ld b, a
	pop af
	cp b
	jr z, .monDoesNothing ; mon will not use move if only one move has remaining PP
	ld a, $1
	ld [wMonIsDisobedient], a
	ld a, [wMaxMenuItem]
	ld b, a
	ld a, [wCurrentMenuItem]
	ld c, a
.chooseMove
	call BattleRandom
	and $3
	cp b
	jr nc, .chooseMove ; if the random number is greater than the move count, choose another
	cp c
	jr z, .chooseMove ; if the random number matches the move the player selected, choose another
	ld [wCurrentMenuItem], a
	ld hl, wBattleMonPP
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	and a ; does the move have any PP left?
	jr z, .chooseMove ; if the move has no PP left, choose another
	ld a, [wCurrentMenuItem]
	ld c, a
	ld b, $0
	ld hl, wBattleMonMoves
	add hl, bc
	ld a, [hl]
	ld [wPlayerSelectedMove], a
	call GetCurrentMove
.canUseMove
	ld a, $1
	and a; clear Z flag
	ret
.cannotUseMove
	xor a ; set Z flag
	ret

LoafingAroundText: ; 3df28 (f:5f28)
	TX_FAR _LoafingAroundText
	db "@"

BeganToNapText: ; 3df2d (f:5f2d)
	TX_FAR _BeganToNapText
	db "@"

WontObeyText: ; 3df32 (f:5f32)
	TX_FAR _WontObeyText
	db "@"

TurnedAwayText: ; 3df37 (f:5f37)
	TX_FAR _TurnedAwayText
	db "@"

IgnoredOrdersText: ; 3df3c (f:5f3c)
	TX_FAR _IgnoredOrdersText
	db "@"

; sets b, c, d, and e for the CalculateDamage routine in the case of an attack by the player mon
GetDamageVarsForPlayerAttack: ; 3df41 (f:5f41)
	xor a
	ld hl, wDamage ; damage to eventually inflict, initialise to zero
	ldi [hl], a
	ld [hl], a
	ld hl, wPlayerMovePower
	ld a, [hli]
	and a
	ld d, a ; d = move power
	ret z ; return if move power is zero
	ld a, [hl] ; a = [wPlayerMoveType]
	cp FIRE ; types >= FIRE are all special
	jr nc, .specialAttack
.physicalAttack
	ld hl, wEnemyMonDefense
	ld a, [hli]
	ld b, a
	ld c, [hl] ; bc = enemy defense
	ld a, [wEnemyBattleStatus3]
	bit HasReflectUp, a ; check for Reflect
	jr z, .physicalAttackCritCheck
; if the enemy has used Reflect, double the enemy's defense
	sla c
	rl b
.physicalAttackCritCheck
	ld hl, wBattleMonAttack
	ld a, [wCriticalHitOrOHKO]
	and a ; check for critical hit
	jr z, .scaleStats
; in the case of a critical hit, reset the player's attack and the enemy's defense to their base values
	ld c, 3 ; defense stat
	call GetEnemyMonStat
	ld a, [H_PRODUCT + 2]
	ld b, a
	ld a, [H_PRODUCT + 3]
	ld c, a
	push bc
	ld hl, wPartyMon1Attack
	ld a, [wPlayerMonNumber]
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	pop bc
	jr .scaleStats
.specialAttack
	ld hl, wEnemyMonSpecial
	ld a, [hli]
	ld b, a
	ld c, [hl] ; bc = enemy special
	ld a, [wEnemyBattleStatus3]
	bit HasLightScreenUp, a ; check for Light Screen
	jr z, .specialAttackCritCheck
; if the enemy has used Light Screen, double the enemy's special
	sla c
	rl b
; reflect and light screen boosts do not cap the stat at 999, so weird things will happen during stats scaling if
; a Pokemon with 512 or more Defense has ued Reflect, or if a Pokemon with 512 or more Special has used Light Screen
.specialAttackCritCheck
	ld hl, wBattleMonSpecial
	ld a, [wCriticalHitOrOHKO]
	and a ; check for critical hit
	jr z, .scaleStats
; in the case of a critical hit, reset the player's and enemy's specials to their base values
	ld c, 5 ; special stat
	call GetEnemyMonStat
	ld a, [H_PRODUCT + 2]
	ld b, a
	ld a, [H_PRODUCT + 3]
	ld c, a
	push bc
	ld hl, wPartyMon1Special
	ld a, [wPlayerMonNumber]
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	pop bc
; if either the offensive or defensive stat is too large to store in a byte, scale both stats by dividing them by 4
; this allows values with up to 10 bits (values up to 1023) to be handled
; anything larger will wrap around
.scaleStats
	ld a, [hli]
	ld l, [hl]
	ld h, a ; hl = player's offensive stat
	or b ; is either high byte nonzero?
	jr z, .next ; if not, we don't need to scale
; bc /= 4 (scale enemy's defensive stat)
	srl b
	rr c
	srl b
	rr c
; defensive stat can actually end up as 0, leading to a division by 0 freeze during damage calculation
; hl /= 4 (scale player's offensive stat)
	srl h
	rr l
	srl h
	rr l
	ld a, l
	or h ; is the player's offensive stat 0?
	jr nz, .next
	inc l ; if the player's offensive stat is 0, bump it up to 1
.next
	ld b, l ; b = player's offensive stat (possibly scaled)
	        ; (c already contains enemy's defensive stat (possibly scaled))
	ld a, [wBattleMonLevel]
	ld e, a ; e = level
	ld a, [wCriticalHitOrOHKO]
	and a ; check for critical hit
	jr z, .done
	sla e ; double level if it was a critical hit
.done
	ld a, 1
	and a
	ret

; sets b, c, d, and e for the CalculateDamage routine in the case of an attack by the enemy mon
GetDamageVarsForEnemyAttack: ; 3dfe7 (f:5fe7)
	ld hl, wDamage ; damage to eventually inflict, initialise to zero
	xor a
	ld [hli], a
	ld [hl], a
	ld hl, wEnemyMovePower
	ld a, [hli]
	ld d, a ; d = move power
	and a
	ret z ; return if move power is zero
	ld a, [hl] ; a = [wEnemyMoveType]
	cp FIRE ; types >= FIRE are all special
	jr nc, .specialAttack
.physicalAttack
	ld hl, wBattleMonDefense
	ld a, [hli]
	ld b, a
	ld c, [hl] ; bc = player defense
	ld a, [wPlayerBattleStatus3]
	bit HasReflectUp, a ; check for Reflect
	jr z, .physicalAttackCritCheck
; if the player has used Reflect, double the player's defense
	sla c
	rl b
.physicalAttackCritCheck
	ld hl, wEnemyMonAttack
	ld a, [wCriticalHitOrOHKO]
	and a ; check for critical hit
	jr z, .scaleStats
; in the case of a critical hit, reset the player's defense and the enemy's attack to their base values
	ld hl, wPartyMon1Defense
	ld a, [wPlayerMonNumber]
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a, [hli]
	ld b, a
	ld c, [hl]
	push bc
	ld c, 2 ; attack stat
	call GetEnemyMonStat
	ld hl, H_PRODUCT + 2
	pop bc
	jr .scaleStats
.specialAttack
	ld hl, wBattleMonSpecial
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld a, [wPlayerBattleStatus3]
	bit HasLightScreenUp, a ; check for Light Screen
	jr z, .specialAttackCritCheck
; if the player has used Light Screen, double the player's special
	sla c
	rl b
; reflect and light screen boosts do not cap the stat at 999, so weird things will happen during stats scaling if
; a Pokemon with 512 or more Defense has ued Reflect, or if a Pokemon with 512 or more Special has used Light Screen
.specialAttackCritCheck
	ld hl, wEnemyMonSpecial
	ld a, [wCriticalHitOrOHKO]
	and a ; check for critical hit
	jr z, .scaleStats
; in the case of a critical hit, reset the player's and enemy's specials to their base values
	ld hl, wPartyMon1Special
	ld a, [wPlayerMonNumber]
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a, [hli]
	ld b, a
	ld c, [hl]
	push bc
	ld c, 5 ; special stat
	call GetEnemyMonStat
	ld hl, H_PRODUCT + 2
	pop bc
; if either the offensive or defensive stat is too large to store in a byte, scale both stats by dividing them by 4
; this allows values with up to 10 bits (values up to 1023) to be handled
; anything larger will wrap around
.scaleStats
	ld a, [hli]
	ld l, [hl]
	ld h, a ; hl = enemy's offensive stat
	or b ; is either high byte nonzero?
	jr z, .next ; if not, we don't need to scale
; bc /= 4 (scale player's defensive stat)
	srl b
	rr c
	srl b
	rr c
; defensive stat can actually end up as 0, leading to a division by 0 freeze during damage calculation
; hl /= 4 (scale enemy's offensive stat)
	srl h
	rr l
	srl h
	rr l
	ld a, l
	or h ; is the enemy's offensive stat 0?
	jr nz, .next
	inc l ; if the enemy's offensive stat is 0, bump it up to 1
.next
	ld b, l ; b = enemy's offensive stat (possibly scaled)
	        ; (c already contains player's defensive stat (possibly scaled))
	ld a, [wEnemyMonLevel]
	ld e, a
	ld a, [wCriticalHitOrOHKO]
	and a ; check for critical hit
	jr z, .done
	sla e ; double level if it was a critical hit
.done
	ld a, $1
	and a
	and a
	ret

; get stat c of enemy mon
; c: stat to get (HP=1,Attack=2,Defense=3,Speed=4,Special=5)
GetEnemyMonStat: ; 3e08e (f:608e)
	push de
	push bc
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, .notLinkBattle
	ld hl, wEnemyMon1Stats
	dec c
	sla c
	ld b, $0
	add hl, bc
	ld a, [wEnemyMonPartyPos]
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld a, [hli]
	ld [H_MULTIPLICAND + 1], a
	ld a, [hl]
	ld [H_MULTIPLICAND + 2], a
	pop bc
	pop de
	ret
.notLinkBattle
	ld a, [wEnemyMonLevel]
	ld [wCurEnemyLVL], a
	ld a, [wEnemyMonSpecies]
	ld [wd0b5], a
	call GetMonHeader
	ld hl, wEnemyMonDVs
	ld de, wLoadedMonSpeedExp
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	pop bc
	ld b, $0
	ld hl, wLoadedMonSpeedExp - $b ; this base address makes CalcStat look in [wLoadedMonSpeedExp] for DVs
	call CalcStat
	pop de
	ret

CalculateDamage: ; 3d0d7 (f:60d7)
; input:
;	b: attack
;	c: opponent defense
;	d: base power
;	e: level

	ld a, [H_WHOSETURN] ; whose turn?
	and a
	ld a, [wPlayerMoveEffect]
	jr z, .effect
	ld a, [wEnemyMoveEffect]
.effect

; EXPLODE_EFFECT halves defense.
	cp a, EXPLODE_EFFECT
	jr nz, .ok
	srl c
	jr nz, .ok
	inc c ; ...with a minimum value of 1 (used as a divisor later on)
.ok

; Multi-hit attacks may or may not have 0 bp.
	cp a, TWO_TO_FIVE_ATTACKS_EFFECT
	jr z, .skipbp
	cp a, $1e
	jr z, .skipbp

; Calculate OHKO damage based on remaining HP.
	cp a, OHKO_EFFECT
	jp z, JumpToOHKOMoveEffect

; Don't calculate damage for moves that don't do any.
	ld a, d ; base power
	and a
	ret z
.skipbp

	xor a
	ld hl, H_DIVIDEND
	ldi [hl], a
	ldi [hl], a
	ld [hl], a

; Multiply level by 2
	ld a, e ; level
	add a
	jr nc, .nc
	push af
	ld a, 1
	ld [hl], a
	pop af
.nc
	inc hl
	ldi [hl], a

; Divide by 5
	ld a, 5
	ldd [hl], a
	push bc
	ld b, 4
	call Divide
	pop bc

; Add 2
	inc [hl]
	inc [hl]

	inc hl ; multiplier

; Multiply by attack base power
	ld [hl], d
	call Multiply

; Multiply by attack stat
	ld [hl], b
	call Multiply

; Divide by defender's defense stat
	ld [hl], c
	ld b, 4
	call Divide

; Divide by 50
	ld [hl], 50
	ld b, 4
	call Divide

	ld hl, wDamage
	ld b, [hl]
	ld a, [H_QUOTIENT + 3]
	add b
	ld [H_QUOTIENT + 3], a
	jr nc, .asm_3e142

	ld a, [H_QUOTIENT + 2]
	inc a
	ld [H_QUOTIENT + 2], a
	and a
	jr z, .asm_3e176

.asm_3e142
	ld a, [H_QUOTIENT]
	ld b, a
	ld a, [H_QUOTIENT + 1]
	or a
	jr nz, .asm_3e176

	ld a, [H_QUOTIENT + 2]
	cp 998 / $100
	jr c, .asm_3e15a
	cp 998 / $100 + 1
	jr nc, .asm_3e176
	ld a, [H_QUOTIENT + 3]
	cp 998 % $100
	jr nc, .asm_3e176

.asm_3e15a
	inc hl
	ld a, [H_QUOTIENT + 3]
	ld b, [hl]
	add b
	ld [hld], a

	ld a, [H_QUOTIENT + 2]
	ld b, [hl]
	adc b
	ld [hl], a
	jr c, .asm_3e176

	ld a, [hl]
	cp 998 / $100
	jr c, .asm_3e17c
	cp 998 / $100 + 1
	jr nc, .asm_3e176
	inc hl
	ld a, [hld]
	cp 998 % $100
	jr c, .asm_3e17c

.asm_3e176
; cap at 997
	ld a, 997 / $100
	ld [hli], a
	ld a, 997 % $100
	ld [hld], a

.asm_3e17c
; add 2
	inc hl
	ld a, [hl]
	add 2
	ld [hld], a
	jr nc, .done
	inc [hl]

.done
; minimum damage is 1
	ld a, 1
	and a
	ret

JumpToOHKOMoveEffect: ; 3e188 (f:6188)
	call JumpMoveEffect
	ld a, [wMoveMissed]
	dec a
	ret


UnusedHighCriticalMoves: ; 3e190 (f:6190)
	db KARATE_CHOP
	db RAZOR_LEAF
	db CRABHAMMER
	db SLASH
	db $FF
; 3e023

; determines if attack is a critical hit
; azure heights claims "the fastest pokémon (who are, not coincidentally,
; among the most popular) tend to CH about 20 to 25% of the time."
CriticalHitTest: ; 3e195 (f:6195)
	xor a
	ld [wCriticalHitOrOHKO], a
	ld a, [H_WHOSETURN]
	and a
	ld a, [wEnemyMonSpecies]
	jr nz, .handleEnemy
	ld a, [wBattleMonSpecies]
.handleEnemy
	ld [wd0b5], a
	call GetMonHeader
	ld a, [wMonHBaseSpeed]
	ld b, a
	srl b                        ; (effective (base speed/2))
	ld a, [H_WHOSETURN]
	and a
	ld hl, wPlayerMovePower
	ld de, wPlayerBattleStatus2
	jr z, .calcCriticalHitProbability
	ld hl, wEnemyMovePower
	ld de, wEnemyBattleStatus2
.calcCriticalHitProbability
	ld a, [hld]                  ; read base power from RAM
	and a
	ret z                        ; do nothing if zero
	dec hl
	ld c, [hl]                   ; read move id
	ld a, [de]
	bit GettingPumped, a         ; test for focus energy
	jr nz, .focusEnergyUsed      ; bug: using focus energy causes a shift to the right instead of left,
	                             ; resulting in 1/4 the usual crit chance
	sla b                        ; (effective (base speed/2)*2)
	jr nc, .noFocusEnergyUsed
	ld b, $ff                    ; cap at 255/256
	jr .noFocusEnergyUsed
.focusEnergyUsed
	srl b
.noFocusEnergyUsed
	ld hl, HighCriticalMoves     ; table of high critical hit moves
.Loop
	ld a, [hli]                  ; read move from move table
	cp c                         ; does it match the move about to be used?
	jr z, .HighCritical          ; if so, the move about to be used is a high critical hit ratio move
	inc a                        ; move on to the next move, FF terminates loop
	jr nz, .Loop                 ; check the next move in HighCriticalMoves
	srl b                        ; /2 for regular move (effective (base speed / 2))
	jr .SkipHighCritical         ; continue as a normal move
.HighCritical
	sla b                        ; *2 for high critical hit moves
	jr nc, .noCarry
	ld b, $ff                    ; cap at 255/256
.noCarry
	sla b                        ; *4 for high critical move (effective (base speed/2)*8))
	jr nc, .SkipHighCritical
	ld b, $ff
.SkipHighCritical
	call BattleRandom            ; generates a random value, in "a"
	rlc a
	rlc a
	rlc a
	cp b                         ; check a against calculated crit rate
	ret nc                       ; no critical hit if no borrow
	ld a, $1
	ld [wCriticalHitOrOHKO], a   ; set critical hit flag
	ret

; high critical hit moves
HighCriticalMoves: ; 3e200 (f:6200)
	db KARATE_CHOP
	db RAZOR_LEAF
	db CRABHAMMER
	db SLASH
	db $FF


; function to determine if Counter hits and if so, how much damage it does
HandleCounterMove: ; 3e205 (f:6205)
; The variables checked by Counter are updated whenever the cursor points to a new move in the battle selection menu.
; This is irrelevant for the opponent's side outside of link battles, since the move selection is controlled by the AI.
; However, in the scenario where the player switches out and the opponent uses Counter,
; the outcome may be affected by the player's actions in the move selection menu prior to switching the Pokemon.
; This might also lead to desync glitches in link battles.

	ld a,[H_WHOSETURN] ; whose turn
	and a
; player's turn
	ld hl,wEnemySelectedMove
	ld de,wEnemyMovePower
	ld a,[wPlayerSelectedMove]
	jr z,.next
; enemy's turn
	ld hl,wPlayerSelectedMove
	ld de,wPlayerMovePower
	ld a,[wEnemySelectedMove]
.next
	cp a,COUNTER
	ret nz ; return if not using Counter
	ld a,$01
	ld [wMoveMissed],a ; initialize the move missed variable to true (it is set to false below if the move hits)
	ld a,[hl]
	cp a,COUNTER
	ret z ; miss if the opponent's last selected move is Counter.
	ld a,[de]
	and a
	ret z ; miss if the opponent's last selected move's Base Power is 0.
; check if the move the target last selected was Normal or Fighting type
	inc de
	ld a,[de]
	and a ; normal type
	jr z,.counterableType
	cp a,FIGHTING
	jr z,.counterableType
; if the move wasn't Normal or Fighting type, miss
	xor a
	ret
.counterableType
	ld hl,wDamage
	ld a,[hli]
	or [hl]
	ret z ; If we made it here, Counter still misses if the last move used in battle did no damage to its target.
	      ; wDamage is shared by both players, so Counter may strike back damage dealt by the Counter user itself
	      ; if the conditions meet, even though 99% of the times damage will come from the target.
; if it did damage, double it
	ld a,[hl]
	add a
	ldd [hl],a
	ld a,[hl]
	adc a
	ld [hl],a
	jr nc,.noCarry
; damage is capped at 0xFFFF
	ld a,$ff
	ld [hli],a
	ld [hl],a
.noCarry
	xor a
	ld [wMoveMissed],a
	call MoveHitTest ; do the normal move hit test in addition to Counter's special rules
	xor a
	ret

ApplyAttackToEnemyPokemon: ; 3e251 (f:6251)
	ld a,[wPlayerMoveEffect]
	cp a,OHKO_EFFECT
	jr z,ApplyDamageToEnemyPokemon
	cp a,SUPER_FANG_EFFECT
	jr z,.superFangEffect
	cp a,SPECIAL_DAMAGE_EFFECT
	jr z,.specialDamage
	ld a,[wPlayerMovePower]
	and a
	jp z,ApplyAttackToEnemyPokemonDone ; no attack to apply if base power is 0
	jr ApplyDamageToEnemyPokemon
.superFangEffect
; set the damage to half the target's HP
	ld hl,wEnemyMonHP
	ld de,wDamage
	ld a,[hli]
	srl a
	ld [de],a
	inc de
	ld b,a
	ld a,[hl]
	rr a
	ld [de],a
	or b
	jr nz,ApplyDamageToEnemyPokemon
; make sure Super Fang's damage is always at least 1
	ld a,$01
	ld [de],a
	jr ApplyDamageToEnemyPokemon
.specialDamage
	ld hl,wBattleMonLevel
	ld a,[hl]
	ld b,a ; Seismic Toss deals damage equal to the user's level
	ld a,[wPlayerMoveNum]
	cp a,SEISMIC_TOSS
	jr z,.storeDamage
	cp a,NIGHT_SHADE
	jr z,.storeDamage
	ld b,SONICBOOM_DAMAGE ; 20
	cp a,SONICBOOM
	jr z,.storeDamage
	ld b,DRAGON_RAGE_DAMAGE ; 40
	cp a,DRAGON_RAGE
	jr z,.storeDamage
; Psywave
	ld a,[hl]
	ld b,a
	srl a
	add b
	ld b,a ; b = level * 1.5
; loop until a random number in the range [1, b) is found
.loop
	call BattleRandom
	and a
	jr z,.loop
	cp b
	jr nc,.loop
	ld b,a
.storeDamage ; store damage value at b
	ld hl,wDamage
	xor a
	ld [hli],a
	ld a,b
	ld [hl],a

ApplyDamageToEnemyPokemon: ; 3e2b4 (f:62b4)
	ld hl,wDamage
	ld a,[hli]
	ld b,a
	ld a,[hl]
	or b
	jr z,ApplyAttackToEnemyPokemonDone ; we're done if damage is 0
	ld a,[wEnemyBattleStatus2]
	bit HasSubstituteUp,a ; does the enemy have a substitute?
	jp nz,AttackSubstitute
; subtract the damage from the pokemon's current HP
; also, save the current HP at wHPBarOldHP
	ld a,[hld]
	ld b,a
	ld a,[wEnemyMonHP + 1]
	ld [wHPBarOldHP],a
	sub b
	ld [wEnemyMonHP + 1],a
	ld a,[hl]
	ld b,a
	ld a,[wEnemyMonHP]
	ld [wHPBarOldHP+1],a
	sbc b
	ld [wEnemyMonHP],a
	jr nc,.animateHpBar
; if more damage was done than the current HP, zero the HP and set the damage (wDamage)
; equal to how much HP the pokemon had before the attack
	ld a,[wHPBarOldHP+1]
	ld [hli],a
	ld a,[wHPBarOldHP]
	ld [hl],a
	xor a
	ld hl,wEnemyMonHP
	ld [hli],a
	ld [hl],a
.animateHpBar
	ld hl,wEnemyMonMaxHP
	ld a,[hli]
	ld [wHPBarMaxHP+1],a
	ld a,[hl]
	ld [wHPBarMaxHP],a
	ld hl,wEnemyMonHP
	ld a,[hli]
	ld [wHPBarNewHP+1],a
	ld a,[hl]
	ld [wHPBarNewHP],a
	coord hl, 2, 2
	xor a
	ld [wHPBarType],a
	predef UpdateHPBar2 ; animate the HP bar shortening
ApplyAttackToEnemyPokemonDone: ; 3e30f (f:630f)
	jp DrawHUDsAndHPBars

ApplyAttackToPlayerPokemon: ; 3e312 (f:6312)
	ld a,[wEnemyMoveEffect]
	cp a,OHKO_EFFECT
	jr z,ApplyDamageToPlayerPokemon
	cp a,SUPER_FANG_EFFECT
	jr z,.superFangEffect
	cp a,SPECIAL_DAMAGE_EFFECT
	jr z,.specialDamage
	ld a,[wEnemyMovePower]
	and a
	jp z,ApplyAttackToPlayerPokemonDone
	jr ApplyDamageToPlayerPokemon
.superFangEffect
; set the damage to half the target's HP
	ld hl,wBattleMonHP
	ld de,wDamage
	ld a,[hli]
	srl a
	ld [de],a
	inc de
	ld b,a
	ld a,[hl]
	rr a
	ld [de],a
	or b
	jr nz,ApplyDamageToPlayerPokemon
; make sure Super Fang's damage is always at least 1
	ld a,$01
	ld [de],a
	jr ApplyDamageToPlayerPokemon
.specialDamage
	ld hl,wEnemyMonLevel
	ld a,[hl]
	ld b,a
	ld a,[wEnemyMoveNum]
	cp a,SEISMIC_TOSS
	jr z,.storeDamage
	cp a,NIGHT_SHADE
	jr z,.storeDamage
	ld b,SONICBOOM_DAMAGE
	cp a,SONICBOOM
	jr z,.storeDamage
	ld b,DRAGON_RAGE_DAMAGE
	cp a,DRAGON_RAGE
	jr z,.storeDamage
; Psywave
	ld a,[hl]
	ld b,a
	srl a
	add b
	ld b,a ; b = attacker's level * 1.5
; loop until a random number in the range [0, b) is found
; this differs from the range when the player attacks, which is [1, b)
; it's possible for the enemy to do 0 damage with Psywave, but the player always does at least 1 damage
.loop
	call BattleRandom
	cp b
	jr nc,.loop
	ld b,a
.storeDamage
	ld hl,wDamage
	xor a
	ld [hli],a
	ld a,b
	ld [hl],a

ApplyDamageToPlayerPokemon: ; 3e372 (f:6372)
	ld hl,wDamage
	ld a,[hli]
	ld b,a
	ld a,[hl]
	or b
	jr z,ApplyAttackToPlayerPokemonDone ; we're done if damage is 0
	ld a,[wPlayerBattleStatus2]
	bit HasSubstituteUp,a ; does the player have a substitute?
	jp nz,AttackSubstitute
; subtract the damage from the pokemon's current HP
; also, save the current HP at wHPBarOldHP and the new HP at wHPBarNewHP
	ld a,[hld]
	ld b,a
	ld a,[wBattleMonHP + 1]
	ld [wHPBarOldHP],a
	sub b
	ld [wBattleMonHP + 1],a
	ld [wHPBarNewHP],a
	ld b,[hl]
	ld a,[wBattleMonHP]
	ld [wHPBarOldHP+1],a
	sbc b
	ld [wBattleMonHP],a
	ld [wHPBarNewHP+1],a
	jr nc,.animateHpBar
; if more damage was done than the current HP, zero the HP and set the damage (wDamage)
; equal to how much HP the pokemon had before the attack
	ld a,[wHPBarOldHP+1]
	ld [hli],a
	ld a,[wHPBarOldHP]
	ld [hl],a
	xor a
	ld hl,wBattleMonHP
	ld [hli],a
	ld [hl],a
	ld hl,wHPBarNewHP
	ld [hli],a
	ld [hl],a
.animateHpBar
	ld hl,wBattleMonMaxHP
	ld a,[hli]
	ld [wHPBarMaxHP+1],a
	ld a,[hl]
	ld [wHPBarMaxHP],a
	coord hl, 10, 9
	ld a,$01
	ld [wHPBarType],a
	predef UpdateHPBar2 ; animate the HP bar shortening
ApplyAttackToPlayerPokemonDone: ; 3e3cd (f:63cd)
	jp DrawHUDsAndHPBars

AttackSubstitute: ; 3e3d0 (f:63d0)
; Unlike the two ApplyAttackToPokemon functions, Attack Substitute is shared by player and enemy.
; Self-confusion damage as well as Hi-Jump Kick and Jump Kick recoil cause a momentary turn swap before being applied.
; If the user has a Substitute up and would take damage because of that,
; damage will be applied to the other player's Substitute.
; Normal recoil such as from Double-Edge isn't affected by this glitch,
; because this function is never called in that case.

	ld hl,SubstituteTookDamageText
	call PrintText
; values for player turn
	ld de,wEnemySubstituteHP
	ld bc,wEnemyBattleStatus2
	ld a,[H_WHOSETURN]
	and a
	jr z,.applyDamageToSubstitute
; values for enemy turn
	ld de,wPlayerSubstituteHP
	ld bc,wPlayerBattleStatus2
.applyDamageToSubstitute
	ld hl,wDamage
	ld a,[hli]
	and a
	jr nz,.substituteBroke ; damage > 0xFF always breaks substitutes
; subtract damage from HP of substitute
	ld a,[de]
	sub [hl]
	ld [de],a
	ret nc
.substituteBroke
; If the target's Substitute breaks, wDamage isn't updated with the amount of HP
; the Substitute had before being attacked.
	ld h,b
	ld l,c
	res HasSubstituteUp,[hl] ; unset the substitute bit
	ld hl,SubstituteBrokeText
	call PrintText
; flip whose turn it is for the next function call
	ld a,[H_WHOSETURN]
	xor a,$01
	ld [H_WHOSETURN],a
	callab Func_79929 ; animate the substitute breaking
; flip the turn back to the way it was
	ld a,[H_WHOSETURN]
	xor a,$01
	ld [H_WHOSETURN],a
	ld hl,wPlayerMoveEffect ; value for player's turn
	and a
	jr z,.nullifyEffect
	ld hl,wEnemyMoveEffect ; value for enemy's turn
.nullifyEffect
	xor a
	ld [hl],a ; zero the effect of the attacker's move
	jp DrawHUDsAndHPBars

SubstituteTookDamageText: ; 3e41e (f:641e)
	TX_FAR _SubstituteTookDamageText
	db "@"

SubstituteBrokeText: ; 3e423 (f:6423)
	TX_FAR _SubstituteBrokeText
	db "@"

; this function raises the attack modifier of a pokemon using Rage when that pokemon is attacked
HandleBuildingRage: ; 3e428 (f:6428)
; values for the player turn
	ld hl,wEnemyBattleStatus2
	ld de,wEnemyMonStatMods
	ld bc,wEnemyMoveNum
	ld a,[H_WHOSETURN]
	and a
	jr z,.next
; values for the enemy turn
	ld hl,wPlayerBattleStatus2
	ld de,wPlayerMonStatMods
	ld bc,wPlayerMoveNum
.next
	bit UsingRage,[hl] ; is the pokemon being attacked under the effect of Rage?
	ret z ; return if not
	ld a,[de]
	cp a,$0d ; maximum stat modifier value
	ret z ; return if attack modifier is already maxed
	ld a,[H_WHOSETURN]
	xor a,$01 ; flip turn for the stat modifier raising function
	ld [H_WHOSETURN],a
; temporarily change the target pokemon's move to $00 and the effect to the one
; that causes the attack modifier to go up one stage
	ld h,b
	ld l,c
	ld [hl],$00 ; null move number
	inc hl
	ld [hl],ATTACK_UP1_EFFECT
	push hl
	ld hl,BuildingRageText
	call PrintText
	call StatModifierUpEffect ; stat modifier raising function
	pop hl
	xor a
	ldd [hl],a ; null move effect
	ld a,RAGE
	ld [hl],a ; restore the target pokemon's move number to Rage
	ld a,[H_WHOSETURN]
	xor a,$01 ; flip turn back to the way it was
	ld [H_WHOSETURN],a
	ret

BuildingRageText: ; 3e46a (f:646a)
	TX_FAR _BuildingRageText
	db "@"

; copy last move for Mirror Move
; sets zero flag on failure and unsets zero flag on success
MirrorMoveCopyMove: ; 3e46f (f:646f)
; Mirror Move makes use of ccf1 (wPlayerUsedMove) and ccf2 (wEnemyUsedMove) addresses,
; which are mainly used to print the "[Pokemon] used [Move]" text.
; Both are set to 0 whenever a new Pokemon is sent out
; ccf1 is also set to 0 whenever the player is fast asleep or frozen solid.
; ccf2 is also set to 0 whenever the enemy is fast asleep or frozen solid.

	ld a,[H_WHOSETURN]
	and a
; values for player turn
	ld a,[wEnemyUsedMove]
	ld hl,wPlayerSelectedMove
	ld de,wPlayerMoveNum
	jr z,.next
; values for enemy turn
	ld a,[wPlayerUsedMove]
	ld de,wEnemyMoveNum
	ld hl,wEnemySelectedMove
.next
	ld [hl],a
	cp a,MIRROR_MOVE ; did the target Pokemon last use Mirror Move, and miss?
	jr z,.mirrorMoveFailed
	and a ; has the target selected any move yet?
	jr nz,ReloadMoveData
.mirrorMoveFailed
	ld hl,MirrorMoveFailedText
	call PrintText
	xor a
	ret

MirrorMoveFailedText: ; 3e496 (f:6496)
	TX_FAR _MirrorMoveFailedText
	db "@"

; function used to reload move data for moves like Mirror Move and Metronome
ReloadMoveData: ; 3e49b (f:649b)
	ld [wd11e],a
	dec a
	ld hl,Moves
	ld bc,MoveEnd - Moves
	call AddNTimes
	ld a,BANK(Moves)
	call FarCopyData ; copy the move's stats
	call IncrementMovePP
; the follow two function calls are used to reload the move name
	call GetMoveName
	call CopyStringToCF4B
	ld a,$01
	and a
	ret

; function that picks a random move for metronome
MetronomePickMove: ; 3e4ba (f:64ba)
	xor a
	ld [wAnimationType],a
	ld a,METRONOME
	call PlayMoveAnimation ; play Metronome's animation
; values for player turn
	ld de,wPlayerMoveNum
	ld hl,wPlayerSelectedMove
	ld a,[H_WHOSETURN]
	and a
	jr z,.pickMoveLoop
; values for enemy turn
	ld de,wEnemyMoveNum
	ld hl,wEnemySelectedMove
; loop to pick a random number in the range [1, $a5) to be the move used by Metronome
.pickMoveLoop
	call BattleRandom
	and a
	jr z,.pickMoveLoop
	cp a,NUM_ATTACKS + 1 ; max normal move number + 1 (this is Struggle's move number)
	jr nc,.pickMoveLoop
	cp a,METRONOME
	jr z,.pickMoveLoop
	ld [hl],a
	jr ReloadMoveData

; this function increments the current move's PP
; it's used to prevent moves that run another move within the same turn
; (like Mirror Move and Metronome) from losing 2 PP
IncrementMovePP: ; 3e4e5 (f:64e5)
	ld a,[H_WHOSETURN]
	and a
; values for player turn
	ld hl,wBattleMonPP
	ld de,wPartyMon1PP
	ld a,[wPlayerMoveListIndex]
	jr z,.next
; values for enemy turn
	ld hl,wEnemyMonPP
	ld de,wEnemyMon1PP
	ld a,[wEnemyMoveListIndex]
.next
	ld b,$00
	ld c,a
	add hl,bc
	inc [hl] ; increment PP in the currently battling pokemon memory location
	ld h,d
	ld l,e
	add hl,bc
	ld a,[H_WHOSETURN]
	and a
	ld a,[wPlayerMonNumber] ; value for player turn
	jr z,.updatePP
	ld a,[wEnemyMonPartyPos] ; value for enemy turn
.updatePP
	ld bc,wEnemyMon2 - wEnemyMon1
	call AddNTimes
	inc [hl] ; increment PP in the party memory location
	ret

; function to adjust the base damage of an attack to account for type effectiveness
AdjustDamageForMoveType: ; 3e517 (f:6517)
; values for player turn
	ld hl,wBattleMonType
	ld a,[hli]
	ld b,a    ; b = type 1 of attacker
	ld c,[hl] ; c = type 2 of attacker
	ld hl,wEnemyMonType
	ld a,[hli]
	ld d,a    ; d = type 1 of defender
	ld e,[hl] ; e = type 2 of defender
	ld a,[wPlayerMoveType]
	ld [wMoveType],a
	ld a,[H_WHOSETURN]
	and a
	jr z,.next
; values for enemy turn
	ld hl,wEnemyMonType
	ld a,[hli]
	ld b,a    ; b = type 1 of attacker
	ld c,[hl] ; c = type 2 of attacker
	ld hl,wBattleMonType
	ld a,[hli]
	ld d,a    ; d = type 1 of defender
	ld e,[hl] ; e = type 2 of defender
	ld a,[wEnemyMoveType]
	ld [wMoveType],a
.next
	ld a,[wMoveType]
	cp b ; does the move type match type 1 of the attacker?
	jr z,.sameTypeAttackBonus
	cp c ; does the move type match type 2 of the attacker?
	jr z,.sameTypeAttackBonus
	jr .skipSameTypeAttackBonus
.sameTypeAttackBonus
; if the move type matches one of the attacker's types
	ld hl,wDamage + 1
	ld a,[hld]
	ld h,[hl]
	ld l,a    ; hl = damage
	ld b,h
	ld c,l    ; bc = damage
	srl b
	rr c      ; bc = floor(0.5 * damage)
	add hl,bc ; hl = floor(1.5 * damage)
; store damage
	ld a,h
	ld [wDamage],a
	ld a,l
	ld [wDamage + 1],a
	ld hl,wDamageMultipliers
	set 7,[hl]
.skipSameTypeAttackBonus
	ld a,[wMoveType]
	ld b,a
	ld hl,TypeEffects
.loop
	ld a,[hli] ; a = "attacking type" of the current type pair
	cp a,$ff
	jr z,.done
	cp b ; does move type match "attacking type"?
	jr nz,.nextTypePair
	ld a,[hl] ; a = "defending type" of the current type pair
	cp d ; does type 1 of defender match "defending type"?
	jr z,.matchingPairFound
	cp e ; does type 2 of defender match "defending type"?
	jr z,.matchingPairFound
	jr .nextTypePair
.matchingPairFound
; if the move type matches the "attacking type" and one of the defender's types matches the "defending type"
	push hl
	push bc
	inc hl
	ld a,[wDamageMultipliers]
	and a,$80
	ld b,a
	ld a,[hl] ; a = damage multiplier
	ld [H_MULTIPLIER],a
	add b
	ld [wDamageMultipliers],a
	xor a
	ld [H_MULTIPLICAND],a
	ld hl,wDamage
	ld a,[hli]
	ld [H_MULTIPLICAND + 1],a
	ld a,[hld]
	ld [H_MULTIPLICAND + 2],a
	call Multiply
	ld a,10
	ld [H_DIVISOR],a
	ld b,$04
	call Divide
	ld a,[H_QUOTIENT + 2]
	ld [hli],a
	ld b,a
	ld a,[H_QUOTIENT + 3]
	ld [hl],a
	or b ; is damage 0?
	jr nz,.skipTypeImmunity
.typeImmunity
; if damage is 0, make the move miss
; this only occurs if a move that would do 2 or 3 damage is 0.25x effective against the target
	inc a
	ld [wMoveMissed],a
.skipTypeImmunity
	pop bc
	pop hl
.nextTypePair
	inc hl
	inc hl
	jp .loop
.done
	ret
	
AIGetTypeEffectiveness: ; 3e5bb (f:65bb)
	ld a,[wEnemyMoveType]
	ld d,a                 ; d = type of enemy move
	ld hl,wBattleMonType
	ld b,[hl]              ; b = type 1 of player's pokemon
	inc hl
	ld c,[hl]              ; c = type 2 of player's pokemon
	ld a,$10
	ld [wd11e],a           ; initialize [wd11e] to neutral effectiveness
	ld hl,TypeEffects
.loop
	ld a,[hli]
	cp a,$ff
	ret z
	cp d                   ; match the type of the move
	jr nz,.nextTypePair1
	ld a,[hli]
	cp b                   ; match with type 1 of pokemon
	jr z,.done
	cp c                   ; or match with type 2 of pokemon
	jr z,.done
	jr .nextTypePair2
.nextTypePair1
	inc hl
.nextTypePair2
	inc hl
	jr .loop

.done
	ld a, [wTrainerClass]
	cp LORELEI
	jr nz, .ok
	ld a, [wEnemyMonSpecies]
	cp DEWGONG
	jr nz, .ok
	call BattleRandom
	cp $66 ; 40 percent
	ret c
.ok

	ld a,[hl]
	ld [wd11e],a           ; store damage multiplier
	ret

INCLUDE "data/type_effects.asm"

MoveHitTest: ; 3e6f1 (f:66f1)
	dr $3e6f1,$3e80d
RandomizeDamage: ; 3e80d (f:680d)
	dr $3e80d,$3e842
ExecuteEnemyMove: ; 3e842 (f:6842)
	dr $3e842,$3ec44
GetCurrentMove: ; 3ec44 (f:6c44)
	dr $3ec44,$3ec87
LoadEnemyMonData: ; 3ec87 (f:6c87)
	dr $3ec87,$3edb8
DoBattleTransitionAndInitBattleVariables: ; 3edb8 (f:6db8)
	dr $3edb8,$3ee18
LoadPlayerBackPic: ; 3ee18 (f:6e18)
	dr $3ee18,$3ee9e
ScrollTrainerPicAfterBattle: ; 3ee9e (f:6e9e)
	dr $3ee9e,$3eea6
ApplyBurnAndParalysisPenaltiesToPlayer: ; 3eea6 (f:6ea6)
	dr $3eea6,$3eeaa
ApplyBurnAndParalysisPenaltiesToEnemy: ; 3eeaa (f:6eaa)
	dr $3eeaa,$3eeb3
QuarterSpeedDueToParalysis: ; 3eeb3 (f:6eb3)
	dr $3eeb3,$3efa5
ApplyBadgeStatBoosts: ; 3efa5 (f:6fa5)
	dr $3efa5,$3efe4
LoadHudAndHpBarAndStatusTilePatterns: ; 3efe4 (f:6fe4)
	dr $3efe4,$3efe7
LoadHudTilePatterns: ; 3efe7 (f:6fe7)
	dr $3efe7,$3f020
PrintEmptyString: ; 3f020 (f:7020)
	dr $3f020,$3f027
BattleRandom: ; 3f027 (f:7027)
	dr $3f027,$3f05f
HandleExplodingAnimation: ; 3f05f (f:705f)
	dr $3f05f,$3f093
PlayMoveAnimation: ; 3f093 (f:7093)
	dr $3f093,$3f0a7
JumpMoveEffect: ; 3f0a7 (f:70a7)
	dr $3f0a7,$3f3de
StatModifierUpEffect: ; 3f3de (f:73de)
	dr $3f3de,$3fb2e
PrintButItFailedText_: ; 3fb2e (f:7b2e)
	dr $3fb2e,$3fb39
PrintDidntAffectText: ; 3fb39 (f:7b39)
	dr $3fb39,$3fb49
PrintMayNotAttackText: ; 3fb49 (f:7b49)
	dr $3fb49,$3fb83
PlayCurrentMoveAnimation: ; 3fb83 (f:7b83)
	dr $3fb83,$40000