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
	ld [W_ANIMATIONID], a
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

HasMonFainted: ; 3cafc (f:4afc)
	dr $3cafc,$3cb1e
TryRunningFromBattle: ; 3cb1e (f:4b1e)
	dr $3cb1e,$3cc10
LoadBattleMonFromParty: ; 3cc10 (f:4c10)
	dr $3cc10,$3ccfb
SendOutMon: ; 3ccfb (f:4cfb)
	dr $3ccfb,$3ce08
ReadPlayerMonCurHPAndStatus: ; 3ce08 (f:4e08)
	dr $3ce08,$3ce1f
DrawHUDsAndHPBars: ; 3ce1f (f:4e1f)
	dr $3ce1f,$3ce25
DrawPlayerHUDAndHPBar: ; 3ce25 (f:4e25)
	dr $3ce25,$3ceb1
DrawEnemyHUDAndHPBar: ; 3ceb1 (f:4eb1)
	dr $3ceb1,$3cf55
GetBattleHealthBarColor: ; 3cf55 (f:4f55)
	dr $3cf55,$3cf78
DisplayBattleMenu: ; 3cf78 (f:4f78)
	dr $3cf78,$3d2c1
SwitchPlayerMon: ; 3d2c1 (f:52c1)
	dr $3d2c1,$3d2fc
AlreadyOutText: ; 3d2fc (f:52fc)
	dr $3d2fc,$3d320
MoveSelectionMenu: ; 3d320 (f:5320)
	dr $3d320,$3d6d6
SelectEnemyMove: ; 3d6d6 (f:56d6)
	dr $3d6d6,$3d777
LinkBattleExchangeData: ; 3d777 (f:5777)
	dr $3d777,$3d7d0
ExecutePlayerMove: ; 3d7d0 (f:57d0)
	dr $3d7d0,$3d9ac
IsGhostBattle: ; 3d9ac (f:59ac)
	dr $3d9ac,$3ddc3
PrintDoesntAffectText: ; 3ddc3 (f:5dc3)
	dr $3ddc3,$3e5bb

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
	dr $3e6f1,$3e842
ExecuteEnemyMove: ; 3e842 (f:6842)
	dr $3e842,$3ec87
LoadEnemyMonData: ; 3ec87 (f:6c87)
	dr $3ec87,$3edb8
DoBattleTransitionAndInitBattleVariables: ; 3edb8 (f:6db8)
	dr $3edb8,$3ee18
LoadPlayerBackPic: ; 3ee18 (f:6e18)
	dr $3ee18,$3ee9e
ScrollTrainerPicAfterBattle: ; 3ee9e (f:6e9e)
	dr $3ee9e,$3eeb3
QuarterSpeedDueToParalysis: ; 3eeb3 (f:6eb3)
	dr $3eeb3,$3efe4
LoadHudAndHpBarAndStatusTilePatterns: ; 3efe4 (f:6fe4)
	dr $3efe4,$3efe7
LoadHudTilePatterns: ; 3efe7 (f:6fe7)
	dr $3efe7,$3f020
PrintEmptyString: ; 3f020 (f:7020)
	dr $3f020,$3f027
BattleRandom: ; 3f027 (f:7027)
	dr $3f027,$3f093
PlayMoveAnimation: ; 3f093 (f:7093)
	dr $3f093,$3f3de
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