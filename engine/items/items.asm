UseItem_: ; d2ed (3:52ed)
	ld a,1
	ld [wActionResultOrTookBattleTurn],a ; initialise to success value
	ld a,[wcf91]	;contains item_ID
	cp a,HM_01
	jp nc,ItemUseTMHM
	ld hl,ItemUsePtrTable
	dec a
	add a
	ld c,a
	ld b,0
	add hl,bc
	ld a,[hli]
	ld h,[hl]
	ld l,a
	jp [hl]

ItemUsePtrTable: ; d307 (3:5307)
	dw ItemUseBall       ; MASTER_BALL
	dw ItemUseBall       ; ULTRA_BALL
	dw ItemUseBall       ; GREAT_BALL
	dw ItemUseBall       ; POKE_BALL
	dw ItemUseTownMap    ; TOWN_MAP
	dw ItemUseBicycle    ; BICYCLE
	dw ItemUseSurfboard  ; out-of-battle Surf effect
	dw ItemUseBall       ; SAFARI_BALL
	dw ItemUsePokedex    ; POKEDEX
	dw ItemUseEvoStone   ; MOON_STONE
	dw ItemUseMedicine   ; ANTIDOTE
	dw ItemUseMedicine   ; BURN_HEAL
	dw ItemUseMedicine   ; ICE_HEAL
	dw ItemUseMedicine   ; AWAKENING
	dw ItemUseMedicine   ; PARLYZ_HEAL
	dw ItemUseMedicine   ; FULL_RESTORE
	dw ItemUseMedicine   ; MAX_POTION
	dw ItemUseMedicine   ; HYPER_POTION
	dw ItemUseMedicine   ; SUPER_POTION
	dw ItemUseMedicine   ; POTION
	dw ItemUseBait       ; BOULDERBADGE
	dw ItemUseRock       ; CASCADEBADGE
	dw UnusableItem      ; THUNDERBADGE
	dw UnusableItem      ; RAINBOWBADGE
	dw UnusableItem      ; SOULBADGE
	dw UnusableItem      ; MARSHBADGE
	dw UnusableItem      ; VOLCANOBADGE
	dw UnusableItem      ; EARTHBADGE
	dw ItemUseEscapeRope ; ESCAPE_ROPE
	dw ItemUseRepel      ; REPEL
	dw UnusableItem      ; OLD_AMBER
	dw ItemUseEvoStone   ; FIRE_STONE
	dw ItemUseEvoStone   ; THUNDER_STONE
	dw ItemUseEvoStone   ; WATER_STONE
	dw ItemUseVitamin    ; HP_UP
	dw ItemUseVitamin    ; PROTEIN
	dw ItemUseVitamin    ; IRON
	dw ItemUseVitamin    ; CARBOS
	dw ItemUseVitamin    ; CALCIUM
	dw ItemUseVitamin    ; RARE_CANDY
	dw UnusableItem      ; DOME_FOSSIL
	dw UnusableItem      ; HELIX_FOSSIL
	dw UnusableItem      ; SECRET_KEY
	dw UnusableItem
	dw UnusableItem      ; BIKE_VOUCHER
	dw ItemUseXAccuracy  ; X_ACCURACY
	dw ItemUseEvoStone   ; LEAF_STONE
	dw ItemUseCardKey    ; CARD_KEY
	dw UnusableItem      ; NUGGET
	dw UnusableItem      ; ??? PP_UP
	dw ItemUsePokedoll   ; POKE_DOLL
	dw ItemUseMedicine   ; FULL_HEAL
	dw ItemUseMedicine   ; REVIVE
	dw ItemUseMedicine   ; MAX_REVIVE
	dw ItemUseGuardSpec  ; GUARD_SPEC
	dw ItemUseSuperRepel ; SUPER_REPL
	dw ItemUseMaxRepel   ; MAX_REPEL
	dw ItemUseDireHit    ; DIRE_HIT
	dw UnusableItem      ; COIN
	dw ItemUseMedicine   ; FRESH_WATER
	dw ItemUseMedicine   ; SODA_POP
	dw ItemUseMedicine   ; LEMONADE
	dw UnusableItem      ; S_S_TICKET
	dw UnusableItem      ; GOLD_TEETH
	dw ItemUseXStat      ; X_ATTACK
	dw ItemUseXStat      ; X_DEFEND
	dw ItemUseXStat      ; X_SPEED
	dw ItemUseXStat      ; X_SPECIAL
	dw ItemUseCoinCase   ; COIN_CASE
	dw ItemUseOaksParcel ; OAKS_PARCEL
	dw ItemUseItemfinder ; ITEMFINDER
	dw UnusableItem      ; SILPH_SCOPE
	dw ItemUsePokeflute  ; POKE_FLUTE
	dw UnusableItem      ; LIFT_KEY
	dw UnusableItem      ; EXP_ALL
	dw ItemUseOldRod     ; OLD_ROD
	dw ItemUseGoodRod    ; GOOD_ROD
	dw ItemUseSuperRod   ; SUPER_ROD
	dw ItemUsePPUp       ; PP_UP (real one)
	dw ItemUsePPRestore  ; ETHER
	dw ItemUsePPRestore  ; MAX_ETHER
	dw ItemUsePPRestore  ; ELIXER
	dw ItemUsePPRestore  ; MAX_ELIXER

ItemUseBall: ; d3ad (3:53ad)
	ld a,[wIsInBattle]
	and a
	jp z,ItemUseNotTime ; not in battle
	dec a
	jp nz,ThrowBallAtTrainerMon
	ld a,[wBattleType]
	cp $1
	jr z,.UseBall
	cp $4 ; pikachu battle?
	jr z,.UseBall
	ld a,[wPartyCount]	;is Party full?
	cp a,PARTY_LENGTH
	jr nz,.UseBall
	ld a,[wNumInBox]	;is Box full?
	cp a,MONS_PER_BOX
	jp z,BoxFullCannotThrowBall
.UseBall
;ok, you can use a ball
	xor a
	ld [wCapturedMonSpecies],a
	ld a,[wBattleType]
	cp a,2		;SafariBattle
	jr nz,.skipSafariZoneCode
.safariZone
	; remove a Safari Ball from inventory
	ld hl,wNumSafariBalls
	dec [hl]
.skipSafariZoneCode
	call RunDefaultPaletteCommand
	ld a,$43
	ld [wd11e],a
	call LoadScreenTilesFromBuffer1	;restore screenBuffer from Backup
	ld hl,ItemUseText00
	call PrintText
	callab IsGhostBattle
	ld b,$10
	jp z,.next12
	ld a,[wBattleType]
	cp $1
	jr z,.oldManBattle
	cp $4
	jr z,.oldManBattle ; pikachu battle technically old man battle
	jr .notOldManBattle
.oldManBattle
	ld hl,wGrassRate
	ld de,wPlayerName
	ld bc,NAME_LENGTH
	call CopyData ; save the player's name in the Wild Monster data
	ld a, [wBattleType]
	cp $1
	jp nz,.BallSuccess
	ld a,$1
	ld [wCapturedMonSpecies], a
	ld a, [wd74c]
	bit 7, a
	ld b, $63
	jp nz,.next12
	jp .BallSuccess
.notOldManBattle
	ld a,[wCurMap]
	cp a,POKEMONTOWER_6
	jr nz,.loop
	ld a,[wEnemyMonSpecies2]
	cp a,MAROWAK
	ld b,$10
	jp z,.next12
; if not fighting ghost Marowak, loop until a random number in the current
; pokeball's allowed range is found
.loop
	call Random
	ld b,a
	ld hl,wcf91
.asm_d54a
	ld a,[hl]
	cp a,MASTER_BALL
	jp z,.BallSuccess
	cp a,POKE_BALL
	jr z,.checkForAilments
	ld a,200
	cp b
	jr c,.loop	;get only numbers <= 200 for Great Ball
	ld a,[hl]
	cp a,GREAT_BALL
	jr z,.checkForAilments
	ld a,150	;get only numbers <= 150 for Ultra Ball
	cp b
	jr c,.loop
.checkForAilments
; pokemon can be caught more easily with any (primary) status ailment
; Frozen/Asleep pokemon are relatively even easier to catch
; for Frozen/Asleep pokemon, any random number from 0-24 ensures a catch.
; for the others, a random number from 0-11 ensures a catch.
	ld a,[wEnemyMonStatus]	;status ailments
	and a
	jr z,.noAilments
	and a, 1 << FRZ | SLP	;is frozen and/or asleep?
	ld c,12
	jr z,.notFrozenOrAsleep
	ld c,25
.notFrozenOrAsleep
	ld a,b
	sub c
	jp c,.BallSuccess
	ld b,a
.noAilments
	push bc		;save RANDOM number
	xor a
	ld [H_MULTIPLICAND],a
	ld hl,wEnemyMonMaxHP
	ld a,[hli]
	ld [H_MULTIPLICAND + 1],a
	ld a,[hl]
	ld [H_MULTIPLICAND + 2],a
	ld a,255
	ld [H_MULTIPLIER],a
	call Multiply	; MaxHP * 255
	ld a,[wcf91]
	cp GREAT_BALL
	ld a,12		;any other BallFactor
	jr nz,.next7
	ld a,8
.next7
	ld [H_DIVISOR],a
	ld b,4		; number of bytes in dividend
	call Divide
	ld hl,wEnemyMonHP
	ld a,[hli]
	ld b,a
	ld a,[hl]

; explanation: we have a 16-bit value equal to [b << 8 | a].
; This number is divided by 4. The result is 8 bit (reg. a).
; Always bigger than zero.
	srl b
	rr a
	srl b
	rr a ; a = current HP / 4
	and a
	jr nz,.next8
	inc a
.next8
	ld [H_DIVISOR],a
	ld b,4
	call Divide	; ((MaxHP * 255) / BallFactor) / (CurHP / 4)
	ld a,[H_QUOTIENT + 2]
	and a
	jr z,.next9
	ld a,255
	ld [H_QUOTIENT + 3],a
.next9
	pop bc
	ld a,[wEnemyMonCatchRate]	;enemy: Catch Rate
	cp b
	jr c,.next10
	ld a,[H_QUOTIENT + 2]
	and a
	jr nz,.BallSuccess ; if ((MaxHP * 255) / BallFactor) / (CurHP / 4) > 0x255, automatic success
	call Random
	ld b,a
	ld a,[H_QUOTIENT + 3]
	cp b
	jr c,.next10
.BallSuccess
	jr .BallSuccess2
.next10
	ld a,[H_QUOTIENT + 3]
	ld [wd11e],a
	xor a
	ld [H_MULTIPLICAND],a
	ld [H_MULTIPLICAND + 1],a
	ld a,[wEnemyMonCatchRate]	;enemy: Catch Rate
	ld [H_MULTIPLICAND + 2],a
	ld a,100
	ld [H_MULTIPLIER],a
	call Multiply	; CatchRate * 100
	ld a,[wcf91]
	ld b,255
	cp POKE_BALL
	jr z,.next11
	ld b,200
	cp GREAT_BALL
	jr z,.next11
	ld b,150
	cp ULTRA_BALL
	jr z,.next11
.next11
	ld a,b
	ld [H_DIVISOR],a
	ld b,4
	call Divide
	ld a,[H_QUOTIENT + 2]
	and a
	ld b,$63
	jr nz,.next12
	ld a,[wd11e]
	ld [H_MULTIPLIER],a
	call Multiply
	ld a,255
	ld [H_DIVISOR],a
	ld b,4
	call Divide
	ld a,[wEnemyMonStatus]	;status ailments
	and a
	jr z,.next13
	and 1 << FRZ | SLP
	ld b,5
	jr z,.next14
	ld b,10
.next14
	ld a,[H_QUOTIENT + 3]
	add b
	ld [H_QUOTIENT + 3],a
.next13
	ld a,[H_QUOTIENT + 3]
	cp a,10
	ld b,$20
	jr c,.next12
	cp a,30
	ld b,$61
	jr c,.next12
	cp a,70
	ld b,$62
	jr c,.next12
	ld b,$63
.next12
	ld a,b
	ld [wPokeBallAnimData],a
.BallSuccess2
	ld c,20
	call DelayFrames
	ld a,TOSS_ANIM
	ld [wAnimationID],a
	xor a
	ld [H_WHOSETURN],a
	ld [wAnimationType],a
	ld [wDamageMultipliers],a
	ld a,[wWhichPokemon]
	push af
	ld a,[wcf91]
	push af
	predef MoveAnimation
	pop af
	ld [wcf91],a
	pop af
	ld [wWhichPokemon],a
	ld a,[wPokeBallAnimData]
	cp a,$10
	ld hl,ItemUseBallText00
	jp z,.printText0
	cp a,$20
	ld hl,ItemUseBallText01
	jp z,.printText0
	cp a,$61
	ld hl,ItemUseBallText02
	jp z,.printText0
	cp a,$62
	ld hl,ItemUseBallText03
	jp z,.printText0
	cp a,$63
	ld hl,ItemUseBallText04
	jp z,.printText0
	ld hl,wEnemyMonHP	;current HP
	ld a,[hli]
	push af
	ld a,[hli]
	push af		;backup currentHP...
	inc hl
	ld a,[hl]
	push af		;...and status ailments
	push hl
	ld hl,wEnemyBattleStatus3
	bit Transformed,[hl]
	jr z,.next15
	ld a,$4c
	ld [wEnemyMonSpecies2],a
	jr .next16
.next15
	set Transformed,[hl]
	ld hl,wTransformedEnemyMonOriginalDVs
	ld a,[wEnemyMonDVs]
	ld [hli],a
	ld a,[wEnemyMonDVs + 1]
	ld [hl],a
.next16
	ld a,[wcf91]
	push af
	ld a,[wEnemyMonSpecies2]
	ld [wcf91],a
	ld a,[wEnemyMonLevel]
	ld [wCurEnemyLVL],a
	callab LoadEnemyMonData
	pop af
	ld [wcf91],a
	pop hl
	pop af
	ld [hld],a
	dec hl
	pop af
	ld [hld],a
	pop af
	ld [hl],a
	ld a,[wEnemyMonSpecies]	;enemy
	ld [wCapturedMonSpecies],a
	ld [wcf91],a
	ld [wd11e],a
	ld a,[wBattleType]
	cp $1
	jp z,.printText1 ; just barely out of reach for a relative jump
	cp $4
	jr z,.printText1
	ld hl,ItemUseBallText05
	call PrintText
	predef IndexToPokedex
	ld a,[wd11e]
	dec a
	ld c,a
	ld b,FLAG_TEST
	ld hl,wPokedexOwned
	predef FlagActionPredef
	ld a,c
	push af
	ld a,[wd11e]
	dec a
	ld c,a
	ld b,FLAG_SET
	predef FlagActionPredef
	pop af
	and a
	jr nz,.checkParty
	ld hl,ItemUseBallText06
	call PrintText
	call ClearSprites
	ld a,[wEnemyMonSpecies]	;caught mon_ID
	ld [wd11e],a
	predef ShowPokedexData
.checkParty
	ld a, $1
	ld [wd49c], a
	ld a, $85
	ld [wPikachuMood], a
	ld a,[wPartyCount]
	cp PARTY_LENGTH		;is party full?
	jr z,.sendToBox
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation],a
	call ClearSprites
	ld hl, .emptyString
	call PrintText
	call AddPartyMon	;add mon to Party
	jr .End
.sendToBox
	call ClearSprites
	call SendNewMonToBox
	ld hl,ItemUseBallText07
	ld a, [wd7f1]
	bit 0, a
	jr nz,.sendToBox2
	ld hl,ItemUseBallText08
.sendToBox2
	call PrintText
	jr .End
.printText1
	ld hl,ItemUseBallText05
.printText0
	call PrintText
	call ClearSprites
.End
	ld a,[wBattleType]
	and a
	ret nz
	ld hl,wNumBagItems
	inc a
	ld [wItemQuantity],a
	jp RemoveItemFromInventory
.emptyString
	db "@"
	
ItemUseBallText00: ; d697 (3:5697)
;"It dodged the thrown ball!"
;"This pokemon can't be caught"
	TX_FAR _ItemUseBallText00
	db "@"
ItemUseBallText01: ; d69c (3:569c)
;"You missed the pokemon!"
	TX_FAR _ItemUseBallText01
	db "@"
ItemUseBallText02: ; d6a1 (3:56a1)
;"Darn! The pokemon broke free!"
	TX_FAR _ItemUseBallText02
	db "@"
ItemUseBallText03: ; d6a6 (3:56a6)
;"Aww! It appeared to be caught!"
	TX_FAR _ItemUseBallText03
	db "@"
ItemUseBallText04: ; d6ab (3:56ab)
;"Shoot! It was so close too!"
	TX_FAR _ItemUseBallText04
	db "@"
ItemUseBallText05: ; d6b0 (3:56b0)
;"All right! {MonName} was caught!"
;play sound
	TX_FAR _ItemUseBallText05
	db $12,$06
	db "@"
ItemUseBallText07: ; d6b7 (3:59b7)
;"X was transferred to Bill's PC"
	TX_FAR _ItemUseBallText07
	db "@"
ItemUseBallText08: ; d6bc (3:56bc)
;"X was transferred to someone's PC"
	TX_FAR _ItemUseBallText08
	db "@"

ItemUseBallText06: ; d6c1 (3:56c1)
;"New DEX data will be added..."
;play sound
	TX_FAR _ItemUseBallText06
	db $13,$06
	db "@"

ItemUseTownMap: ; d6c8 (3:56c8)
	ld a,[wIsInBattle]
	and a
	jp nz,ItemUseNotTime
	jpba DisplayTownMap

ItemUseBicycle: ; d6d7 (3:56d7)
	ld a,[wIsInBattle]
	and a
	jp nz,ItemUseNotTime
	ld a,[wWalkBikeSurfState]
	ld [wWalkBikeSurfStateCopy],a
	cp a,2 ; is the player surfing?
	jp z,ItemUseNotTime
	dec a ; is player already bicycling?
	jr nz,.tryToGetOnBike
.getOffBike
	call ItemUseReloadOverworldData
	xor a
	ld [wWalkBikeSurfState],a ; change player state to walking
	ld a, $00
	ld [wd431], a
	call PlayDefaultMusic ; play walking music
	ld hl,GotOffBicycleText
	jp PrintText
.tryToGetOnBike
	call IsBikeRidingAllowed
	jp nc,NoCyclingAllowedHere
	call ItemUseReloadOverworldData
	xor a ; no keys pressed
	ld [hJoyHeld],a ; current joypad state
	ld a, $1
	ld [wWalkBikeSurfState],a ; change player state to bicycling
	call PlayDefaultMusic ; play bike riding music
	xor a
	ld [wWalkBikeSurfState],a
	ld hl,GotOnBicycleText
	call PrintText
	ld a, $1
	ld [wWalkBikeSurfState], a
	ret

; used for Surf out-of-battle effect
ItemUseSurfboard: ; d725 (3:5725)
	ld a,[wWalkBikeSurfState]
	ld [wWalkBikeSurfStateCopy],a
	cp a,2 ; is the player already surfing?
	jr z,.tryToStopSurfing
.tryToSurf
	call IsNextTileShoreOrWater
	jp nc,SurfingAttemptFailed
	ld hl,TilePairCollisionsWater
	call CheckForTilePairCollisions
	jp c,SurfingAttemptFailed
.surf
	call .makePlayerMoveForward
	ld hl,wd730
	set 7,[hl]
	ld a,2
	ld [wWalkBikeSurfState],a ; change player state to surfing
	call PlayDefaultMusic ; play surfing music
	ld hl,SurfingGotOnText
	jp PrintText
.tryToStopSurfing
	xor a
	ld [hSpriteIndexOrTextID],a
	ld d,16 ; talking range in pixels (normal range)
	call IsSpriteInFrontOfPlayer2
	res 7,[hl]
	ld a,[hSpriteIndexOrTextID]
	and a ; is there a sprite in the way?
	jr nz,.cannotStopSurfing
	ld hl,TilePairCollisionsWater
	call CheckForTilePairCollisions
	jr c,.cannotStopSurfing
	ld a,[wTileInFrontOfPlayer]
	ld c,a
	call IsTilePassable
	jr nc,.stopSurfing
.cannotStopSurfing
	ld hl,SurfingNoPlaceToGetOffText
	jp PrintText
.stopSurfing
	call .makePlayerMoveForward
	ld a,$3
	ld [wd431], a
	ld hl,wd430
	set 5,[hl]
	ld hl,wd730
	set 7,[hl]
	xor a
	ld [wWalkBikeSurfState],a ; change player state to walking
	dec a
	ld [wJoyIgnore],a
	call PlayDefaultMusic ; play walking music
	call GBPalWhiteOutWithDelay3
	jp LoadWalkingPlayerSpriteGraphics
; uses a simulated button press to make the player move forward
.makePlayerMoveForward
	ld a,[wPlayerDirection] ; direction the player is going
	bit PLAYER_DIR_BIT_UP,a
	ld b,D_UP
	jr nz,.storeSimulatedButtonPress
	bit PLAYER_DIR_BIT_DOWN,a
	ld b,D_DOWN
	jr nz,.storeSimulatedButtonPress
	bit PLAYER_DIR_BIT_LEFT,a
	ld b,D_LEFT
	jr nz,.storeSimulatedButtonPress
	ld b,D_RIGHT
.storeSimulatedButtonPress
	ld a,b
	ld [wSimulatedJoypadStatesEnd],a
	xor a
	ld [wWastedByteCD39],a
	inc a
	ld [wSimulatedJoypadStatesIndex],a
	ret

SurfingGotOnText: ; d7c1 (3:57c1)
	TX_FAR _SurfingGotOnText
	db "@"

SurfingNoPlaceToGetOffText: ; d7c6 (3:57c6)
	TX_FAR _SurfingNoPlaceToGetOffText
	db "@"

ItemUsePokedex: ; d7cb (3:57cb)
	predef_jump ShowPokedexMenu

ItemUseEvoStone: ; d7d0 (3:57d0)
	ld a,[wIsInBattle]
	and a
	jp nz,ItemUseNotTime
	ld a,[wWhichPokemon]
	push af
	ld a,[wcf91]
	ld [wEvoStoneItemID],a
	push af
	ld a,EVO_STONE_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID],a
	ld a,$ff
	ld [wUpdateSpritesEnabled],a
	call DisplayPartyMenu
	ld a, [wcf91]
	ld [wLoadedMon], a
	pop bc
	jr c,.canceledItemUse
	ld a,b
	ld [wcf91],a
	call Func_d85d
	jr nc, .noEffect
	callab IsThisPartymonStarterPikachu_Party
	jr nc, .notPlayerPikachu
	ld e, $1b
	callab PlayPikachuSoundClip
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	ld hl, RefusingText
	call PrintText
	ld a, $4
	ld [wd49c], a
	ld a, $82
	ld [wPikachuMood], a
	jr .canceledItemUse
.notPlayerPikachu
	ld a,SFX_HEAL_AILMENT
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	ld a,$01
	ld [wForceEvolution],a
	callab TryEvolvingMon ; try to evolve pokemon
	pop af
	ld [wWhichPokemon],a
	ld hl,wNumBagItems
	ld a,1 ; remove 1 stone
	ld [wItemQuantity],a
	jp RemoveItemFromInventory
.noEffect
	call ItemUseNoEffect
.canceledItemUse
	xor a
	ld [wActionResultOrTookBattleTurn],a ; item not used
	pop af
	ret

Func_d85d: ; d85d (3:585d)
	ld hl, EvosMovesPointerTable
	ld a, [wLoadedMon]
	dec a
	ld c, a
	ld b, $0
	add hl, bc
	add hl, bc
	ld de, wcd6d
	ld a, BANK(TryEvolvingMon)
	ld bc, $2
	call FarCopyData
	ld hl, wcd6d
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wcd6d
	ld a, BANK(TryEvolvingMon)
	ld bc, 13
	call FarCopyData
	ld hl, wcd6d
.loop
	ld a, [hli]
	and a 
	jr z, .cannotEvolveWithUsedStone
	inc hl
	inc hl
	cp EV_ITEM
	jr nz, .loop
	dec hl
	dec hl
	ld b, [hl]
	ld a, [wcf91]
	inc hl
	inc hl
	inc hl
	cp b
	jr nz, .loop
	scf
	ret
.cannotEvolveWithUsedStone
	and a
	ret

RefusingText: ; d8a2 (3:58a2)
	TX_FAR _RefusingText
	db "@"

ItemUseVitamin: ; d8a7 (3:58a7)
	ld a,[wIsInBattle]
	and a
	jp nz,ItemUseNotTime

ItemUseMedicine: ; d8ae (3:58ae)
	ld a,[wPartyCount]
	and a
	jp z,Func_e4bf
	ld a,[wWhichPokemon]
	push af
	ld a,[wcf91]
	push af
	ld a,USE_ITEM_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID],a
	ld a,$ff
	ld [wUpdateSpritesEnabled],a
	ld a,[wPseudoItemID]
	and a ; using Softboiled?
	jr z,.notUsingSoftboiled
; if using softboiled
	call GoBackToPartyMenu
	jr .getPartyMonDataAddress
.notUsingSoftboiled
	call DisplayPartyMenu
.getPartyMonDataAddress
	jp c,.canceledItemUse
	ld hl,wPartyMons
	ld bc,wPartyMon2 - wPartyMon1
	ld a,[wWhichPokemon]
	call AddNTimes
	ld a,[wWhichPokemon]
	ld [wUsedItemOnWhichPokemon],a
	ld d,a
	ld a,[wcf91]
	ld e,a
	ld [wd0b5],a
	pop af
	push af
	cp $28
	jr nc, .asm_d906
	push hl
	push de
	callabd_ModifyPikachuHappiness PIKAHAPPY_USEDITEM
	pop de
	pop hl
.asm_d906
	pop af
	ld [wcf91],a
	pop af
	ld [wWhichPokemon],a
	ld a,[wPseudoItemID]
	and a ; using Softboiled?
	jr z,.checkItemType
; if using softboiled
	ld a,[wWhichPokemon]
	cp d ; is the pokemon trying to use softboiled on itself?
	jr z,ItemUseMedicine ; if so, force another choice
.checkItemType
	ld a,[wcf91]
	cp a,REVIVE
	jr nc,.healHP ; if it's a Revive or Max Revive
	cp a,FULL_HEAL
	jr z,.cureStatusAilment ; if it's a Full Heal
	cp a,HP_UP
	jp nc,.useVitamin ; if it's a vitamin or Rare Candy
	cp a,FULL_RESTORE
	jr nc,.healHP ; if it's a Full Restore or one of the potions
; fall through if it's one of the status-specifc healing items
.cureStatusAilment
	ld bc,4
	add hl,bc ; hl now points to status
	ld a,[wcf91]
	lb bc, ANTIDOTE_MSG, 1 << PSN
	cp a,ANTIDOTE
	jr z,.checkMonStatus
	lb bc, BURN_HEAL_MSG, 1 << BRN
	cp a,BURN_HEAL
	jr z,.checkMonStatus
	lb bc, ICE_HEAL_MSG, 1 << FRZ
	cp a,ICE_HEAL
	jr z,.checkMonStatus
	lb bc, AWAKENING_MSG, SLP
	cp a,AWAKENING
	jr z,.checkMonStatus
	lb bc, PARALYZ_HEAL_MSG, 1 << PAR
	cp a,PARLYZ_HEAL
	jr z,.checkMonStatus
	lb bc, FULL_HEAL_MSG, $ff ; Full Heal
.checkMonStatus
	ld a,[hl] ; pokemon's status
	and c ; does the pokemon have a status ailment the item can cure?
	jp z,.healingItemNoEffect
; if the pokemon has a status the item can heal
	xor a
	ld [hl],a ; remove the status ailment in the party data
	ld a,b
	ld [wPartyMenuTypeOrMessageID],a ; the message to display for the item used
	ld a,[wPlayerMonNumber]
	cp d ; is pokemon the item was used on active in battle?
	jp nz,.doneHealing
; if it is active in battle
	xor a
	ld [wBattleMonStatus],a ; remove the status ailment in the in-battle pokemon data
	push hl
	ld hl,wPlayerBattleStatus3
	res BadlyPoisoned,[hl] ; heal Toxic status
	pop hl
	ld bc,30
	add hl,bc ; hl now points to party stats
	ld de,wBattleMonMaxHP
	ld bc,10
	call CopyData ; copy party stats to in-battle stat data
	predef DoubleOrHalveSelectedStats
	jp .doneHealing
.healHP
	inc hl ; hl = address of current HP
	ld a,[hli]
	ld b,a
	ld [wHPBarOldHP+1],a
	ld a,[hl]
	ld c,a
	ld [wHPBarOldHP],a ; current HP stored at wHPBarOldHP (2 bytes, big-endian)
	or b
	jr nz,.notFainted
.fainted
	ld a,[wcf91]
	cp a,REVIVE
	jr z,.updateInBattleFaintedData
	cp a,MAX_REVIVE
	jr z,.updateInBattleFaintedData
	jp .healingItemNoEffect
.updateInBattleFaintedData
	ld a, [wWhichPokemon]
	push af
	ld a, [wUsedItemOnWhichPokemon]
	ld [wWhichPokemon], a
	push hl
	push de
	push bc
	callab Func_2fd6a
	pop bc
	pop de
	pop hl
	pop af
	ld [wWhichPokemon], a
	
	ld a,[wIsInBattle]
	and a
	jr z,.compareCurrentHPToMaxHP
	push hl
	push de
	push bc
	ld a,[wUsedItemOnWhichPokemon]
	ld c,a
	ld hl,wPartyFoughtCurrentEnemyFlags
	ld b,FLAG_TEST
	predef FlagActionPredef
	ld a,c
	and a
	jr z,.next
	ld a,[wUsedItemOnWhichPokemon]
	ld c,a
	ld hl,wPartyGainExpFlags
	ld b,FLAG_SET
	predef FlagActionPredef
.next
	pop bc
	pop de
	pop hl
	jr .compareCurrentHPToMaxHP
.notFainted
	ld a,[wcf91]
	cp a,REVIVE
	jp z,.healingItemNoEffect
	cp a,MAX_REVIVE
	jp z,.healingItemNoEffect
.compareCurrentHPToMaxHP
	push hl
	push bc
	ld bc,32
	add hl,bc ; hl now points to max HP
	pop bc
	ld a,[hli]
	cp b
	jr nz,.skipComparingLSB ; no need to compare the LSB's if the MSB's don't match
	ld a,[hl]
	cp c
.skipComparingLSB
	pop hl
	jr nz,.notFullHP
.fullHP ; if the pokemon's current HP equals its max HP
	ld a,[wcf91]
	cp a,FULL_RESTORE
	jp nz,.healingItemNoEffect
	inc hl
	inc hl
	ld a,[hld] ; status ailment
	and a ; does the pokemon have a status ailment?
	jp z,.healingItemNoEffect
	ld a,FULL_HEAL
	ld [wcf91],a
	dec hl
	dec hl
	dec hl
	jp .cureStatusAilment
.notFullHP ; if the pokemon's current HP doesn't equal its max HP
	xor a
	ld [wLowHealthAlarm],a ;disable low health alarm
	ld [wChannelSoundIDs + CH4],a
	push hl
	push de
	ld bc,32
	add hl,bc ; hl now points to max HP
	ld a,[hli]
	ld [wHPBarMaxHP+1],a
	ld a,[hl]
	ld [wHPBarMaxHP],a ; max HP stored at wHPBarMaxHP (2 bytes, big-endian)
	ld a,[wPseudoItemID]
	and a ; using Softboiled?
	jp z,.notUsingSoftboiled2
; if using softboiled
	ld hl,wHPBarMaxHP
	ld a,[hli]
	push af
	ld a,[hli]
	push af
	ld a,[hli]
	push af
	ld a,[hl]
	push af
	ld hl,wPartyMon1MaxHP
	ld a,[wWhichPokemon]
	ld bc,wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a,[hli]
	ld [wHPBarMaxHP + 1],a
	ld [H_DIVIDEND],a
	ld a,[hl]
	ld [wHPBarMaxHP],a
	ld [H_DIVIDEND + 1],a
	ld a,5
	ld [H_DIVISOR],a
	ld b,2 ; number of bytes
	call Divide ; get 1/5 of max HP of pokemon that used Softboiled
	ld bc,wPartyMon1HP - wPartyMon1MaxHP
	add hl,bc ; hl now points to LSB of current HP of pokemon that used Softboiled
; subtract 1/5 of max HP from current HP of pokemon that used Softboiled
	ld a,[H_QUOTIENT + 3]
	push af
	ld b,a
	ld a,[hl]
	ld [wHPBarOldHP],a
	sub b
	ld [hld],a
	ld [wHPBarNewHP],a
	ld a,[H_QUOTIENT + 2]
	ld b,a
	ld a,[hl]
	ld [wHPBarOldHP+1],a
	sbc b
	ld [hl],a
	ld [wHPBarNewHP+1],a
	coord hl, 4, 1
	ld a,[wWhichPokemon]
	ld bc,2 * SCREEN_WIDTH
	call AddNTimes ; calculate coordinates of HP bar of pokemon that used Softboiled
	ld a,SFX_HEAL_HP
	call PlaySoundWaitForCurrent
	ld a,[hFlags_0xFFFA]
	set 0,a
	ld [hFlags_0xFFFA],a
	ld a,$02
	ld [wHPBarType],a
	predef UpdateHPBar2 ; animate HP bar decrease of pokemon that used Softboiled
	ld a,[hFlags_0xFFFA]
	res 0,a
	ld [hFlags_0xFFFA],a
	pop af
	ld b,a ; store heal amount (1/5 of max HP)
	ld hl,wHPBarOldHP + 1
	pop af
	ld [hld],a
	pop af
	ld [hld],a
	pop af
	ld [hld],a
	pop af
	ld [hl],a
	jr .addHealAmount
.notUsingSoftboiled2
	ld a,[wcf91]
	cp a,SODA_POP
	ld b,60 ; Soda Pop heal amount
	jr z,.addHealAmount
	ld b,80 ; Lemonade heal amount
	jr nc,.addHealAmount
	cp a,FRESH_WATER
	ld b,50 ; Fresh Water heal amount
	jr z,.addHealAmount
	cp a,SUPER_POTION
	ld b,200 ; Hyper Potion heal amount
	jr c,.addHealAmount
	ld b,50 ; Super Potion heal amount
	jr z,.addHealAmount
	ld b,20 ; Potion heal amount
.addHealAmount
	pop de
	pop hl
	ld a,[hl]
	add b
	ld [hld],a
	ld [wHPBarNewHP],a
	ld a,[hl]
	ld [wHPBarNewHP+1],a
	jr nc,.noCarry
	inc [hl]
	ld a,[hl]
	ld [wHPBarNewHP + 1],a
.noCarry
	push de
	inc hl
	ld d,h
	ld e,l ; de now points to current HP
	ld hl,33
	add hl,de ; hl now points to max HP
	ld a,[wcf91]
	cp a,REVIVE
	jr z,.setCurrentHPToHalfMaxHP
	ld a,[hld]
	ld b,a
	ld a,[de]
	sub b
	dec de
	ld b,[hl]
	ld a,[de]
	sbc b
	jr nc,.setCurrentHPToMaxHp ; if current HP exceeds max HP after healing
	ld a,[wcf91]
	cp a,HYPER_POTION
	jr c,.setCurrentHPToMaxHp ; if using a Full Restore or Max Potion
	cp a,MAX_REVIVE
	jr z,.setCurrentHPToMaxHp ; if using a Max Revive
	jr .updateInBattleData
.setCurrentHPToHalfMaxHP
	dec hl
	dec de
	ld a,[hli]
	srl a
	ld [de],a
	ld [wHPBarNewHP+1],a
	ld a,[hl]
	rr a
	inc de
	ld [de],a
	ld [wHPBarNewHP],a
	dec de
	jr .doneHealingPartyHP
.setCurrentHPToMaxHp
	ld a,[hli]
	ld [de],a
	ld [wHPBarNewHP+1],a
	inc de
	ld a,[hl]
	ld [de],a
	ld [wHPBarNewHP],a
	dec de
.doneHealingPartyHP ; done updating the pokemon's current HP in the party data structure
	ld a,[wcf91]
	cp a,FULL_RESTORE
	jr nz,.updateInBattleData
	ld bc,-31
	add hl,bc
	xor a
	ld [hl],a ; remove the status ailment in the party data
.updateInBattleData
	ld h,d
	ld l,e
	pop de
	ld a,[wPlayerMonNumber]
	cp d ; is pokemon the item was used on active in battle?
	jr nz,.calculateHPBarCoords
; copy party HP to in-battle HP
	ld a,[hli]
	ld [wBattleMonHP],a
	ld a,[hld]
	ld [wBattleMonHP + 1],a
	ld a,[wcf91]
	cp a,FULL_RESTORE
	jr nz,.calculateHPBarCoords
	xor a
	ld [wBattleMonStatus],a ; remove the status ailment in the in-battle pokemon data
.calculateHPBarCoords
	ld hl,wOAMBuffer + $90
	ld bc,2 * 20
	inc d
.calculateHPBarCoordsLoop
	add hl,bc
	dec d
	jr nz,.calculateHPBarCoordsLoop
	jr .doneHealing
.healingItemNoEffect
	call ItemUseNoEffect
	jp .done
.doneHealing
	ld a,[wPseudoItemID]
	and a ; using Softboiled?
	jr nz,.skipRemovingItem ; no item to remove if using Softboiled
	push hl
	call RemoveUsedItem
	pop hl
.skipRemovingItem
	ld a,[wcf91]
	cp a,FULL_RESTORE
	jr c,.playStatusAilmentCuringSound
	cp a,FULL_HEAL
	jr z,.playStatusAilmentCuringSound
	ld a,SFX_HEAL_HP
	call PlaySoundWaitForCurrent
	ld a,[hFlags_0xFFFA]
	set 0,a
	ld [hFlags_0xFFFA],a
	ld a,$02
	ld [wHPBarType],a
	predef UpdateHPBar2 ; animate the HP bar lengthening
	ld a,[hFlags_0xFFFA]
	res 0,a
	ld [hFlags_0xFFFA],a
	ld a,REVIVE_MSG
	ld [wPartyMenuTypeOrMessageID],a
	ld a,[wcf91]
	cp a,REVIVE
	jr z,.showHealingItemMessage
	cp a,MAX_REVIVE
	jr z,.showHealingItemMessage
	ld a,POTION_MSG
	ld [wPartyMenuTypeOrMessageID],a
	jr .showHealingItemMessage
.playStatusAilmentCuringSound
	ld a,SFX_HEAL_AILMENT
	call PlaySoundWaitForCurrent
.showHealingItemMessage
	xor a
	ld [H_AUTOBGTRANSFERENABLED],a
	call ClearScreen
	dec a
	ld [wUpdateSpritesEnabled],a
	call RedrawPartyMenu ; redraws the party menu and displays the message
	ld a,1
	ld [H_AUTOBGTRANSFERENABLED],a
	ld c,50
	call DelayFrames
	call WaitForTextScrollButtonPress
	jr .done
.canceledItemUse
	xor a
	ld [wActionResultOrTookBattleTurn],a ; item use failed
	pop af
	pop af
.done
	ld a,[wPseudoItemID]
	and a ; using Softboiled?
	ret nz ; if so, return
	call GBPalWhiteOut
	call z,RunDefaultPaletteCommand
	ld a,[wIsInBattle]
	and a
	ret nz
	jp ReloadMapData
.useVitamin
	push hl
	ld a,[hl]
	ld [wd0b5],a
	ld [wd11e],a
	ld bc,33
	add hl,bc ; hl now points to level
	ld a,[hl] ; a = level
	ld [wCurEnemyLVL],a ; store level
	call GetMonHeader
	push de
	ld a,d
	ld hl,wPartyMonNicks
	call GetPartyMonName
	pop de
	pop hl
	ld a,[wcf91]
	cp a,RARE_CANDY
	jp z,.useRareCandy
	push hl
	sub a,HP_UP
	add a
	ld bc,17
	add hl,bc
	add l
	ld l,a
	jr nc,.noCarry2
	inc h
.noCarry2
	ld a,10
	ld b,a
	ld a,[hl] ; a = MSB of stat experience of the appropriate stat
	cp a,100 ; is there already at least 25600 (256 * 100) stat experience?
	jr nc,.vitaminNoEffect ; if so, vitamins can't add any more
	add b ; add 2560 (256 * 10) stat experience
	jr nc,.noCarry3 ; a carry should be impossible here, so this will always jump
	ld a,255
.noCarry3
	ld [hl],a
	pop hl
	call .recalculateStats
	ld hl,VitaminText
	ld a,[wcf91]
	sub a,HP_UP - 1
	ld c,a
.statNameLoop ; loop to get the address of the name of the stat the vitamin increases
	dec c
	jr z,.gotStatName
.statNameInnerLoop
	ld a,[hli]
	ld b,a
	ld a,$50
	cp b
	jr nz,.statNameInnerLoop
	jr .statNameLoop
.gotStatName
	ld de,wcf4b
	ld bc,10
	call CopyData ; copy the stat's name to wcf4b
	ld a,SFX_HEAL_AILMENT
	call PlaySound
	ld hl,VitaminStatRoseText
	call PrintText
	jp RemoveUsedItem
.vitaminNoEffect
	pop hl
	ld hl,VitaminNoEffectText
	call PrintText
	jp GBPalWhiteOut
.recalculateStats
	ld bc,34
	add hl,bc
	ld d,h
	ld e,l ; de now points to stats
	ld bc,-18
	add hl,bc ; hl now points to byte 3 of experience
	ld b,1
	jp CalcStats ; recalculate stats
.useRareCandy
	push hl
	ld bc,33
	add hl,bc ; hl now points to level
	ld a,[hl] ; a = level
	cp a, MAX_LEVEL
	jr z,.vitaminNoEffect ; can't raise level above 100
	inc a
	ld [hl],a ; store incremented level
	ld [wCurEnemyLVL],a
	push hl
	push de
	ld d,a
	callab CalcExperience ; calculate experience for next level and store it at $ff96
	pop de
	pop hl
	ld bc,-19
	add hl,bc ; hl now points to experience
; update experience to minimum for new level
	ld a,[hExperience]
	ld [hli],a
	ld a,[hExperience + 1]
	ld [hli],a
	ld a,[hExperience + 2]
	ld [hl],a
	pop hl
	ld a,[wWhichPokemon]
	push af
	ld a,[wcf91]
	push af
	push de
	push hl
	ld bc,34
	add hl,bc ; hl now points to MSB of max HP
	ld a,[hli]
	ld b,a
	ld c,[hl]
	pop hl
	push bc
	push hl
	call .recalculateStats
	pop hl
	ld bc,35 ; hl now points to LSB of max HP
	add hl,bc
	pop bc
	ld a,[hld]
	sub c
	ld c,a
	ld a,[hl]
	sbc b
	ld b,a ; bc = the amount of max HP gained from leveling up
; add the amount gained to the current HP
	ld de,-32
	add hl,de ; hl now points to MSB of current HP
	ld a,[hl]
	add c
	ld [hld],a
	ld a,[hl]
	adc b
	ld [hl],a
	ld a,RARE_CANDY_MSG
	ld [wPartyMenuTypeOrMessageID],a
	call RedrawPartyMenu
	pop de
	ld a,d
	ld [wWhichPokemon],a
	ld a,e
	ld [wd11e],a
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation],a
	call LoadMonData
	ld d,$01
	callab PrintStatsBox ; display new stats text box
	call WaitForTextScrollButtonPress ; wait for button press
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation],a
	predef LearnMoveFromLevelUp ; learn level up move, if any
	
	xor a
	ld [wForceEvolution],a
	callabd_ModifyPikachuHappiness PIKAHAPPY_LEVELUP
	ld a, [wWhichPokemon]
	push af
	ld a, [wUsedItemOnWhichPokemon]
	ld [wWhichPokemon], a
	callab Func_2fd6a ; evolve pokemon, if appropriate
	pop af
	ld [wWhichPokemon],a
	
	callab TryEvolvingMon
	ld a,$01
	ld [wUpdateSpritesEnabled],a
	pop af
	ld [wcf91],a
	pop af
	ld [wWhichPokemon],a
	jp RemoveUsedItem

VitaminStatRoseText: ; dd44 (3:5d44)
	TX_FAR _VitaminStatRoseText
	db "@"

VitaminNoEffectText: ; dd49 (3:5d49)
	TX_FAR _VitaminNoEffectText
	db "@"

VitaminText: ; dd4e (3:5d4e)
	db "HEALTH@"
	db "ATTACK@"
	db "DEFENSE@"
	db "SPEED@"
	db "SPECIAL@"

ItemUseBait: ; dd72 (3:5d72)
	ld hl,ThrewBaitText
	call PrintText
	ld hl,wEnemyMonCatchRate ; catch rate
	srl [hl] ; halve catch rate
	ld a,BAIT_ANIM
	ld hl,wSafariBaitFactor ; bait factor
	ld de,wSafariEscapeFactor ; escape factor
	jr BaitRockCommon

ItemUseRock: ; dd87 (3:5d87)
	ld hl,ThrewRockText
	call PrintText
	ld hl,wEnemyMonCatchRate ; catch rate
	ld a,[hl]
	add a ; double catch rate
	jr nc,.noCarry
	ld a,$ff
.noCarry
	ld [hl],a
	ld a,ROCK_ANIM
	ld hl,wSafariEscapeFactor ; escape factor
	ld de,wSafariBaitFactor ; bait factor

BaitRockCommon: ; dd9f (3:5d9f)
	ld [wAnimationID],a
	xor a
	ld [wAnimationType],a
	ld [H_WHOSETURN],a
	ld [de],a ; zero escape factor (for bait), zero bait factor (for rock)
.randomLoop ; loop until a random number less than 5 is generated
	call Random
	and a,7
	cp a,5
	jr nc,.randomLoop
	inc a ; increment the random number, giving a range from 1 to 5 inclusive
	ld b,a
	ld a,[hl]
	add b ; increase bait factor (for bait), increase escape factor (for rock)
	jr nc,.noCarry
	ld a,$ff
.noCarry
	ld [hl],a
	predef MoveAnimation ; do animation
	ld c,70
	jp DelayFrames

ThrewBaitText: ; ddc6 (3:5dc6)
	TX_FAR _ThrewBaitText
	db "@"

ThrewRockText: ; ddca (3:5dca)
	TX_FAR _ThrewRockText
	db "@"

; also used for Dig out-of-battle effect
ItemUseEscapeRope: ; ddcf (3:5dcf)
	ld a,[wIsInBattle]
	and a
	jr nz,.notUsable
	ld a,[wCurMap]
	cp a,AGATHAS_ROOM
	jr z,.notUsable
	cp a,BILLS_HOUSE
	jr z,.notUsable
	cp a,POKEMON_FAN_CLUB
	jr z,.notUsable
	ld a,[wCurMapTileset]
	ld b,a
	ld hl,EscapeRopeTilesets
.loop
	ld a,[hli]
	cp a,$ff
	jr z,.notUsable
	cp b
	jr nz,.loop
	ld hl,wd732
	set 3,[hl]
	set 6,[hl]
	call Func_1510
	ld hl,wd72e
	res 4,[hl]
	ld hl,wd790
	res 7,[hl]
	xor a
	ld [wNumSafariBalls],a
	ld [W_SAFARIZONEENTRANCECURSCRIPT],a
	inc a
	ld [wEscapedFromBattle],a
	ld [wActionResultOrTookBattleTurn],a ; item used
	ld a,[wPseudoItemID]
	and a ; using Dig?
	ret nz ; if so, return
	call ItemUseReloadOverworldData
	ld c,30
	call DelayFrames
	jp RemoveUsedItem
.notUsable
	jp ItemUseNotTime

EscapeRopeTilesets: ; de28 (3:5e28)
	db FOREST, CEMETERY, CAVERN, FACILITY, INTERIOR
	db $ff ; terminator

ItemUseRepel: ; de2e (3:5e2e)
	ld b,100

ItemUseRepelCommon: ; e005 (3:6005)
	ld a,[wIsInBattle]
	and a
	jp nz,ItemUseNotTime
	ld a,b
	ld [wRepelRemainingSteps],a
	jp PrintItemUseTextAndRemoveItem

; handles X Accuracy item
ItemUseXAccuracy: ; de3e (3:5e3e)
	ld a,[wIsInBattle]
	and a
	jp z,ItemUseNotTime
	ld hl,wPlayerBattleStatus2
	set UsingXAccuracy,[hl] ; X Accuracy bit
	callabd_ModifyPikachuHappiness PIKAHAPPY_USEDXITEM
	jp PrintItemUseTextAndRemoveItem

; This function is bugged and never works. It always jumps to ItemUseNotTime.
; The Card Key is handled in a different way.
ItemUseCardKey: ; de57 (3:de57)
	xor a
	ld [wUnusedD71F],a
	call GetTileAndCoordsInFrontOfPlayer
	ld a,[GetTileAndCoordsInFrontOfPlayer] ; $4586
	cp a,$18
	jr nz,.next0
	ld hl,CardKeyTable1
	jr .next1
.next0
	cp a,$24
	jr nz,.next2
	ld hl,CardKeyTable2
	jr .next1
.next2
	cp a,$5e
	jp nz,ItemUseNotTime
	ld hl,CardKeyTable3
.next1
	ld a,[wCurMap]
	ld b,a
.loop
	ld a,[hli]
	cp a,$ff
	jp z,ItemUseNotTime
	cp b
	jr nz,.nextEntry1
	ld a,[hli]
	cp d
	jr nz,.nextEntry2
	ld a,[hli]
	cp e
	jr nz,.nextEntry3
	ld a,[hl]
	ld [wUnusedD71F],a
	jr .done
.nextEntry1
	inc hl
.nextEntry2
	inc hl
.nextEntry3
	inc hl
	jr .loop
.done
	ld hl,ItemUseText00
	call PrintText
	ld hl,wd728
	set 7,[hl]
	ret

; These tables are probably supposed to be door locations in Silph Co.,
; but they are unused.
; The reason there are 3 tables is unknown.

; Format:
; 00: Map ID
; 01: Y
; 02: X
; 03: ID?

CardKeyTable1: ; dea7 (3:5ea7)
	db  SILPH_CO_2F,$04,$04,$00
	db  SILPH_CO_2F,$04,$05,$01
	db  SILPH_CO_4F,$0C,$04,$02
	db  SILPH_CO_4F,$0C,$05,$03
	db  SILPH_CO_7F,$06,$0A,$04
	db  SILPH_CO_7F,$06,$0B,$05
	db  SILPH_CO_9F,$04,$12,$06
	db  SILPH_CO_9F,$04,$13,$07
	db SILPH_CO_10F,$08,$0A,$08
	db SILPH_CO_10F,$08,$0B,$09
	db $ff

CardKeyTable2: ; ded0 (3:5ed0)
	db SILPH_CO_3F,$08,$09,$0A
	db SILPH_CO_3F,$09,$09,$0B
	db SILPH_CO_5F,$04,$07,$0C
	db SILPH_CO_5F,$05,$07,$0D
	db SILPH_CO_6F,$0C,$05,$0E
	db SILPH_CO_6F,$0D,$05,$0F
	db SILPH_CO_8F,$08,$07,$10
	db SILPH_CO_8F,$09,$07,$11
	db SILPH_CO_9F,$08,$03,$12
	db SILPH_CO_9F,$09,$03,$13
	db $ff

CardKeyTable3: ; def9 (3:5ef9)
	db SILPH_CO_11F,$08,$09,$14
	db SILPH_CO_11F,$09,$09,$15
	db $ff

ItemUsePokedoll: ; df02 (3:5f02)
	ld a,[wIsInBattle]
	dec a
	jp nz,ItemUseNotTime
	ld a,$01
	ld [wEscapedFromBattle],a
	jp PrintItemUseTextAndRemoveItem

ItemUseGuardSpec: ; df11 (3:5f11)
	ld a,[wIsInBattle]
	and a
	jp z,ItemUseNotTime
	
	ld a, [wWhichPokemon]
	push af
	ld a, [wPlayerMonNumber]
	ld [wWhichPokemon], a
	callabd_ModifyPikachuHappiness PIKAHAPPY_USEDXITEM
	pop af
	ld [wWhichPokemon], a
	
	ld hl,wPlayerBattleStatus2
	set ProtectedByMist,[hl] ; Mist bit
	jp PrintItemUseTextAndRemoveItem

ItemUseSuperRepel: ; df38 (3:5f38)
	ld b,200
	jp ItemUseRepelCommon

ItemUseMaxRepel: ; df3d (3:5f3d)
	ld b,250
	jp ItemUseRepelCommon

ItemUseDireHit: ; df42 (3:5f42)
	ld a,[wIsInBattle]
	and a
	jp z,ItemUseNotTime
	
	ld a, [wWhichPokemon]
	push af
	ld a, [wPlayerMonNumber]
	ld [wWhichPokemon], a
	callabd_ModifyPikachuHappiness PIKAHAPPY_USEDXITEM
	pop af
	ld [wWhichPokemon], a
	
	ld hl,wPlayerBattleStatus2
	set GettingPumped,[hl] ; Focus Energy bit
	jp PrintItemUseTextAndRemoveItem

ItemUseXStat: ; df69 (3:df69)
	ld a,[wIsInBattle]
	and a
	jr nz,.inBattle
	call ItemUseNotTime
	ld a,2
	ld [wActionResultOrTookBattleTurn],a ; item not used
	ret
.inBattle
	ld hl,W_PLAYERMOVENUM
	ld a,[hli]
	push af ; save [W_PLAYERMOVENUM]
	ld a,[hl]
	push af ; save [wPlayerMoveEffect]
	push hl
	ld a,[wcf91]
	sub a,X_ATTACK - ATTACK_UP1_EFFECT
	ld [hl],a ; store player move effect
	call PrintItemUseTextAndRemoveItem
	ld a,XSTATITEM_ANIM ; X stat item animation ID
	ld [W_PLAYERMOVENUM],a
	call LoadScreenTilesFromBuffer1 ; restore saved screen
	call Delay3
	xor a
	ld [H_WHOSETURN],a ; set turn to player's turn
	callba StatModifierUpEffect ; do stat increase move
	
	ld a, [wWhichPokemon]
	push af
	ld a, [wPlayerMonNumber]
	ld [wWhichPokemon], a
	callabd_ModifyPikachuHappiness PIKAHAPPY_USEDXITEM
	pop af
	ld [wWhichPokemon], a
	
	pop hl
	pop af
	ld [hld],a ; restore [wPlayerMoveEffect]
	pop af
	ld [hl],a ; restore [W_PLAYERMOVENUM]
	ret

ItemUsePokeflute: ; dfbd (3:5fbd)
	ld a,[wIsInBattle]
	and a
	jr nz,.inBattle
; if not in battle
	call ItemUseReloadOverworldData
	ld a,[wCurMap]
	cp a,ROUTE_12
	jr nz,.notRoute12
	ld a, [wd7d8]
	bit 7, a
	jr nz,.noSnorlaxOrPikachuToWakeUp
; if the player hasn't beaten Route 12 Snorlax
	ld hl,Route12SnorlaxFluteCoords
	call ArePlayerCoordsInArray
	jr nc,.noSnorlaxOrPikachuToWakeUp
	ld hl,PlayedFluteHadEffectText
	call PrintText
	ld hl, wd7d8
	set 6, [hl]
	ret
.notRoute12
	cp a,ROUTE_16
	jr nz,.notRoute16
	ld a, [wd7e0]
	bit 1, a
	jr nz,.noSnorlaxOrPikachuToWakeUp
; if the player hasn't beaten Route 16 Snorlax
	ld hl,Route16SnorlaxFluteCoords
	call ArePlayerCoordsInArray
	jr nc,.noSnorlaxOrPikachuToWakeUp
	ld hl,PlayedFluteHadEffectText
	call PrintText
	ld hl, wd7e0
	set 0, [hl]
	ret
.notRoute16
	cp a,PEWTER_POKECENTER
	jr nz,.noSnorlaxOrPikachuToWakeUp
	call Func_154a
	jr z,.noSnorlaxOrPikachuToWakeUp
	callab Func_fcb01
	jr nc,.noSnorlaxOrPikachuToWakeUp
	ld hl, PlayedFluteHadEffectText
	call PrintText
	call ItemUseReloadOverworldData
	ld e, $1a
	callab Func_fd001
	ret
.noSnorlaxOrPikachuToWakeUp
	ld hl,PlayedFluteNoEffectText
	jp PrintText
.inBattle
	xor a
	ld [wWereAnyMonsAsleep],a
	ld b,~SLP & $ff
	ld hl,wPartyMon1Status
	call WakeUpEntireParty
	ld a,[wIsInBattle]
	dec a ; is it a trainer battle?
	jr z,.skipWakingUpEnemyParty
; if it's a trainer battle
	ld hl,wEnemyMon1Status
	call WakeUpEntireParty
.skipWakingUpEnemyParty
	ld hl,wBattleMonStatus
	ld a,[hl]
	and b ; remove Sleep status
	ld [hl],a
	ld hl,wEnemyMonStatus
	ld a,[hl]
	ld c,a
	and b ; remove Sleep status
	ld [hl],a
	ld a,c
	and a,SLP
	jr z,.asm_e063
	ld a,$1
	ld [wWereAnyMonsAsleep],a
.asm_e063
	call LoadScreenTilesFromBuffer2 ; restore saved screen
	ld a,[wWereAnyMonsAsleep]
	and a ; were any pokemon asleep before playing the flute?
	ld hl,PlayedFluteNoEffectText
	jp z,PrintText ; if no pokemon were asleep
; if some pokemon were asleep
	ld hl,PlayedFluteHadEffectText
	call PrintText
	ld a,[wLowHealthAlarm]
	and a,$80
	jr nz,.skipMusic
	call WaitForSoundToFinish ; wait for sound to end
	callba Music_PokeFluteInBattle ; play in-battle pokeflute music
.musicWaitLoop ; wait for music to finish playing
	ld a,[wChannelSoundIDs + CH6]
	and a ; music off?
	jr nz,.musicWaitLoop
.skipMusic
	ld hl,FluteWokeUpText
	jp PrintText

; wakes up all party pokemon
; INPUT:
; hl must point to status of first pokemon in party (player's or enemy's)
; b must equal ~SLP
; [wWereAnyMonsAsleep] should be initialized to 0
; OUTPUT:
; [wWereAnyMonsAsleep]: set to 1 if any pokemon were asleep
WakeUpEntireParty: ; e094 (3:6094)
	ld de,44
	ld c,6
.loop
	ld a,[hl]
	push af
	and a,SLP ; is pokemon asleep?
	jr z,.notAsleep
	ld a,1
	ld [wWereAnyMonsAsleep],a ; indicate that a pokemon had to be woken up
.notAsleep
	pop af
	and b ; remove Sleep status
	ld [hl],a
	add hl,de
	dec c
	jr nz,.loop
	ret

; Format:
; 00: Y
; 01: X
Route12SnorlaxFluteCoords: ; e0ac (3:60ac)
	db 62,9  ; one space West of Snorlax
	db 61,10 ; one space North of Snorlax
	db 63,10 ; one space South of Snorlax
	db 62,11 ; one space East of Snorlax
	db $ff ; terminator

; Format:
; 00: Y
; 01: X
Route16SnorlaxFluteCoords: ; e0b5 (3:60b5)
	db 10,27 ; one space East of Snorlax
	db 10,25 ; one space West of Snorlax
	db $ff ; terminator

PlayedFluteNoEffectText: ; e0ba (3:60ba)
	TX_FAR _PlayedFluteNoEffectText
	db "@"

FluteWokeUpText: ; e0bf (3:60bf)
	TX_FAR _FluteWokeUpText
	db "@"

PlayedFluteHadEffectText: ; e0c4 (3:60c4)
	TX_FAR _PlayedFluteHadEffectText
	db $06
	TX_ASM
	ld a,[wIsInBattle]
	and a
	jr nz,.done
; play out-of-battle pokeflute music
	call StopAllMusic ; turn off music
	ld a, SFX_POKEFLUTE
	ld c, BANK(SFX_Pokeflute)
	call PlayMusic
.musicWaitLoop ; wait for music to finish playing
	ld a,[wChannelSoundIDs + CH2]
	cp a, SFX_POKEFLUTE
	jr z,.musicWaitLoop
	call PlayDefaultMusic ; start playing normal music again
.done
	jp TextScriptEnd ; end text

ItemUseCoinCase: ; e0e7 (3:60e7)
	ld a,[wIsInBattle]
	and a
	jp nz,ItemUseNotTime
	ld hl,CoinCaseNumCoinsText
	jp PrintText

CoinCaseNumCoinsText: ; e0f1 (3:60f1)
	TX_FAR _CoinCaseNumCoinsText
	db "@"

ItemUseOldRod: ; e0f9 (3:60f9)
	call FishingInit
	jp c, ItemUseNotTime
	lb bc, 5, MAGIKARP
	ld a, $1 ; set bite
	jr RodResponse

ItemUseGoodRod: ; e106 (3:6106)
	call FishingInit
	jp c,ItemUseNotTime
.RandomLoop
	call Random
	srl a
	jr c, .SetBite
	and %11
	cp 2
	jr nc, .RandomLoop
	; choose which monster appears
	ld hl,GoodRodMons
	add a
	ld c,a
	ld b,0
	add hl,bc
	ld b,[hl]
	inc hl
	ld c,[hl]
	and a
.SetBite
	ld a,0
	rla
	xor 1
	jr RodResponse

INCLUDE "data/good_rod.asm"

ItemUseSuperRod: ; e130 (3:6130)
	call FishingInit
	jp c, ItemUseNotTime
	callab ReadSuperRodData
	ld c, e
	ld b, d
	ld a, $2
	ld [wRodResponse], a
	ld a, c
	and a ; are there fish in the map?
	jr z, DoNotGenerateFishingEncounter ; if not, do not generate an encounter
	ld a, $1
	ld [wRodResponse], a
	call Random
	and $1
	jr nz, RodResponse
	xor a
	ld [wRodResponse], a
	jr DoNotGenerateFishingEncounter
	
RodResponse: ; e15b (3:615b)
	ld [wRodResponse], a
	
	dec a ; is there a bite?
	jr nz, DoNotGenerateFishingEncounter
	; if yes, store level and species data
	ld a, 1
	ld [wMoveMissed], a
	ld a, b ; level
	ld [wCurEnemyLVL], a
	ld a, c ; species
	ld [wCurOpponent], a

DoNotGenerateFishingEncounter: ; e16e (3:616e)
	ld hl, wWalkBikeSurfState
	ld a, [hl] ; store the value in a
	push af
	push hl
	ld [hl], 0
	callba FishingAnim
	pop hl
	pop af
	ld [hl], a
	ret

; checks if fishing is possible and if so, runs initialization code common to all rods
; unsets carry if fishing is possible, sets carry if not
FishingInit: ; e182 (3:6182)
	ld a,[wIsInBattle]
	and a
	jr z,.notInBattle
	scf ; can't fish during battle
	ret
.notInBattle
	call IsNextTileShoreOrWater
	jr nc,.cannotFish
	ld a,[wWalkBikeSurfState]
	cp a,2 ; Surfing?
	jr z,.cannotFish
	call ItemUseReloadOverworldData
	ld hl,ItemUseText00
	call PrintText
	ld a,SFX_HEAL_AILMENT
	call PlaySound
	ld a, $2
	ld [wd49c], a
	ld a, $81
	ld [wPikachuMood], a
	ld c,80
	call DelayFrames
	and a
	ret
.cannotFish
	scf ; can't fish when surfing
	ret

ItemUseOaksParcel: ; e1b7 (3:61b7)
	jp ItemUseNotYoursToUse

ItemUseItemfinder: ; e1ba (3:61ba)
	ld a,[wIsInBattle]
	and a
	jp nz,ItemUseNotTime
	call ItemUseReloadOverworldData
	callba HiddenItemNear ; check for hidden items
	ld hl,ItemfinderFoundNothingText
	jr nc,.printText ; if no hidden items
	ld c,4
.loop
	ld a,SFX_HEALING_MACHINE
	call PlaySoundWaitForCurrent
	ld a,SFX_PURCHASE
	call PlaySoundWaitForCurrent
	dec c
	jr nz,.loop
	ld hl,ItemfinderFoundItemText
.printText
	jp PrintText

ItemfinderFoundItemText: ; e1e6 (3:61e6)
	TX_FAR _ItemfinderFoundItemText
	db "@"

ItemfinderFoundNothingText: ; e1eb (3:61eb)
	TX_FAR _ItemfinderFoundNothingText
	db "@"

ItemUsePPUp: ; e1f0 (3:61f0)
	ld a,[wIsInBattle]
	and a
	jp nz,ItemUseNotTime

ItemUsePPRestore: ; e1f7 (3:61f7)
	ld a,[wWhichPokemon]
	push af
	ld a,[wcf91]
	ld [wPPRestoreItem],a
.chooseMon
	xor a
	ld [wUpdateSpritesEnabled],a
	ld a,USE_ITEM_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID],a
	call DisplayPartyMenu
	jr nc,.chooseMove
	jp .itemNotUsed
.chooseMove
	ld a, [wIsInBattle]
	and a
	jr z, .usePPItem
	ld a, [wWhichPokemon]
	ld b, a
	ld a, [wPlayerMonNumber]
	cp b
	jr nz, .usePPItem
	ld a, [wPlayerBattleStatus3]
	bit Transformed, a
	jr z, .usePPItem
	call ItemUseNotTime
	jp .itemNotUsed
.usePPItem
	ld a,[wPPRestoreItem]
	cp a,ELIXER
	jp nc,.useElixir ; if Elixir or Max Elixir
	ld a,$02
	ld [wMoveMenuType],a
	ld hl,RaisePPWhichTechniqueText
	ld a,[wPPRestoreItem]
	cp a,ETHER ; is it a PP Up?
	jr c,.printWhichTechniqueMessage ; if so, print the raise PP message
	ld hl,RestorePPWhichTechniqueText ; otherwise, print the restore PP message
.printWhichTechniqueMessage
	call PrintText
	xor a
	ld [wPlayerMoveListIndex],a
	callab MoveSelectionMenu ; move selection menu
	ld a,0
	ld [wPlayerMoveListIndex],a
	jr nz,.chooseMon
	ld hl,wPartyMon1Moves
	ld bc, wPartyMon2 - wPartyMon1
	call GetSelectedMoveOffset
	push hl
	ld a,[hl]
	ld [wd11e],a
	call GetMoveName
	call CopyStringToCF4B ; copy name to wcf4b
	pop hl
	ld a,[wPPRestoreItem]
	cp a,ETHER
	jr nc,.useEther ; if Ether or Max Ether
.usePPUp
	ld bc,21
	add hl,bc
	ld a,[hl] ; move PP
	cp a,3 << 6 ; have 3 PP Ups already been used?
	jr c,.PPNotMaxedOut
	ld hl,PPMaxedOutText
	call PrintText
	jr .chooseMove
.PPNotMaxedOut
	ld a,[hl]
	add a,1 << 6 ; increase PP Up count by 1
	ld [hl],a
	ld a,1 ; 1 PP Up used
	ld [wd11e],a
	call RestoreBonusPP ; add the bonus PP to current PP
	ld a, SFX_HEAL_AILMENT
	call PlaySound
	ld hl,PPIncreasedText
	call PrintText
.done
	pop af
	ld [wWhichPokemon],a
	call GBPalWhiteOut
	call RunDefaultPaletteCommand
	jp RemoveUsedItem
.afterRestoringPP ; after using a (Max) Ether/Elixir
	ld a,[wWhichPokemon]
	ld b,a
	ld a,[wPlayerMonNumber]
	cp b ; is the pokemon whose PP was restored active in battle?
	jr nz,.skipUpdatingInBattleData
	ld hl,wPartyMon1PP
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld de,wBattleMonPP
	ld bc,4
	call CopyData ; copy party data to in-battle data
.skipUpdatingInBattleData
	ld a,SFX_HEAL_AILMENT
	call PlaySound
	ld hl,PPRestoredText
	call PrintText
	jr .done
.useEther
	call .restorePP
	jr nz,.afterRestoringPP
	jp .noEffect
; unsets zero flag if PP was restored, sets zero flag if not
; however, this is bugged for Max Ethers and Max Elixirs (see below)
.restorePP
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation],a
	call GetMaxPP
	ld hl,wPartyMon1Moves
	ld bc, wPartyMon2 - wPartyMon1
	call GetSelectedMoveOffset
	ld bc, wPartyMon1PP - wPartyMon1Moves
	add hl,bc ; hl now points to move's PP
	ld a,[wMaxPP]
	ld b,a
	ld a,[wPPRestoreItem]
	cp a,MAX_ETHER
	jr z,.fullyRestorePP
	ld a,[hl] ; move PP
	and a,%00111111 ; lower 6 bit bits store current PP
	cp b ; does current PP equal max PP?
	ret z ; if so, return
	add a,10 ; increase current PP by 10
; b holds the max PP amount and b will hold the new PP amount.
; So, if the new amount meets or exceeds the max amount,
; cap the amount to the max amount by leaving b unchanged.
; Otherwise, store the new amount in b.
	cp b ; does the new amount meet or exceed the maximum?
	jr nc,.storeNewAmount
	ld b,a
.storeNewAmount
	ld a,[hl] ; move PP
	and a,%11000000 ; PP Up counter bits
	add b
	ld [hl],a
	ret
.fullyRestorePP
	ld a,[hl] ; move PP
; Note that this code has a bug. It doesn't mask out the upper two bits, which
; are used to count how many PP Ups have been used on the move. So, Max Ethers
; and Max Elixirs will not be detected as having no effect on a move with full
; PP if the move has had any PP Ups used on it.
	cp b ; does current PP equal max PP?
	ret z
	jr .storeNewAmount
.useElixir
; decrement the item ID so that ELIXER becomes ETHER and MAX_ELIXER becomes MAX_ETHER
	ld hl,wPPRestoreItem
	dec [hl]
	dec [hl]
	xor a
	ld hl,wCurrentMenuItem
	ld [hli],a
	ld [hl],a ; zero the counter for number of moves that had their PP restored
	ld b,4
; loop through each move and restore PP
.elixirLoop
	push bc
	ld hl,wPartyMon1Moves
	ld bc, wPartyMon2 - wPartyMon1
	call GetSelectedMoveOffset
	ld a,[hl]
	and a ; does the current slot have a move?
	jr z,.nextMove
	call .restorePP
	jr z,.nextMove
; if some PP was restored
	ld hl,wTileBehindCursor ; counter for number of moves that had their PP restored
	inc [hl]
.nextMove
	ld hl,wCurrentMenuItem
	inc [hl]
	pop bc
	dec b
	jr nz,.elixirLoop
	ld a,[wTileBehindCursor]
	and a ; did any moves have their PP restored?
	jp nz,.afterRestoringPP
.noEffect
	call ItemUseNoEffect
.itemNotUsed
	call GBPalWhiteOut
	call RunDefaultPaletteCommand
	pop af
	xor a
	ld [wActionResultOrTookBattleTurn],a ; item use failed
	ret

RaisePPWhichTechniqueText: ; e358 (3:6358)
	TX_FAR _RaisePPWhichTechniqueText
	db "@"

RestorePPWhichTechniqueText: ; e35d (3:635d)
	TX_FAR _RestorePPWhichTechniqueText
	db "@"

PPMaxedOutText: ; e362 (3:6362)
	TX_FAR _PPMaxedOutText
	db "@"

PPIncreasedText: ; e367 (3:6367)
	TX_FAR _PPIncreasedText
	db "@"

PPRestoredText: ; e36c (3:636c)
	TX_FAR _PPRestoredText
	db "@"

; for items that can't be used from the Item menu
UnusableItem: ; e371 (3:6371)
	jp ItemUseNotTime

ItemUseTMHM: ; e374 (3:6374)
	ld a,[wIsInBattle]
	and a
	jp nz,ItemUseNotTime
	ld a,[wcf91]
	sub a,TM_01
	push af
	jr nc,.skipAdding
	add a,55 ; if item is an HM, add 55
.skipAdding
	inc a
	ld [wd11e],a
	predef TMToMove ; get move ID from TM/HM ID
	ld a,[wd11e]
	ld [wMoveNum],a
	call GetMoveName
	call CopyStringToCF4B ; copy name to wcf4b
	pop af
	ld hl,BootedUpTMText
	jr nc,.printBootedUpMachineText
	ld hl,BootedUpHMText
.printBootedUpMachineText
	call PrintText
	ld hl,TeachMachineMoveText
	call PrintText
	coord hl, 14, 7
	lb bc, 8, 15
	ld a,TWO_OPTION_MENU
	ld [wTextBoxID],a
	call DisplayTextBoxID ; yes/no menu
	ld a,[wCurrentMenuItem]
	and a
	jr z,.useMachine
	ld a,2
	ld [wActionResultOrTookBattleTurn],a ; item not used
	ret
.useMachine
	ld a,[wWhichPokemon]
	push af
	ld a,[wcf91]
	push af
.chooseMon
	ld hl,wcf4b
	ld de,wTempMoveNameBuffer
	ld bc,14
	call CopyData ; save the move name because DisplayPartyMenu will overwrite it
	ld a,$ff
	ld [wUpdateSpritesEnabled],a
	ld a,TMHM_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID],a
	call DisplayPartyMenu
	push af
	ld hl,wTempMoveNameBuffer
	ld de,wcf4b
	ld bc,14
	call CopyData
	pop af
	jr nc,.checkIfAbleToLearnMove
; if the player canceled teaching the move
	pop af
	pop af
	call GBPalWhiteOutWithDelay3
	call ClearSprites
	call RunDefaultPaletteCommand
	jp LoadScreenTilesFromBuffer1 ; restore saved screen
.checkIfAbleToLearnMove
	predef CanLearnTM ; check if the pokemon can learn the move
	push bc
	ld a,[wWhichPokemon]
	ld hl,wPartyMonNicks
	call GetPartyMonName
	pop bc
	ld a,c
	and a ; can the pokemon learn the move?
	jr nz,.checkIfAlreadyLearnedMove
; if the pokemon can't learn the move
	ld a,SFX_DENIED
	call PlaySoundWaitForCurrent
	ld hl,MonCannotLearnMachineMoveText
	call PrintText
	jr .chooseMon
.checkIfAlreadyLearnedMove
	callab CheckIfMoveIsKnown ; check if the pokemon already knows the move
	jr c,.chooseMon
	predef LearnMove ; teach move
	ld a, [wWhichPokemon]
	ld d, a
	pop af
	ld [wcf91],a
	pop af
	ld [wWhichPokemon],a
	ld a,b
	and a
	ret z
	
	ld a,[wWhichPokemon]
	push af
	ld a,d
	ld [wWhichPokemon],a
	callabd_ModifyPikachuHappiness PIKAHAPPY_USEDTMHM
	callab IsThisPartymonStarterPikachu_Party
	jr nc,.notTeachingThunderboltOrThunderToPikachu
	ld a,[wcf91]
	cp a,TM_24 ; are we teaching thunderbolt to the player pikachu?
	jr z,.teachingThunderboltOrThunderToPlayerPikachu
	cp a,TM_25 ; are we teaching thunder then?
	jr nz,.notTeachingThunderboltOrThunderToPikachu
.teachingThunderboltOrThunderToPlayerPikachu
	ld a, $5
	ld [wd49c], a
	ld a, $85
	ld [wPikachuMood], a
.notTeachingThunderboltOrThunderToPikachu
	pop af
	ld [wWhichPokemon], a

	ld a,[wcf91]
	call IsItemHM
	ret c
	jp RemoveUsedItem

BootedUpTMText: ; e483 (3:6483)
	TX_FAR _BootedUpTMText
	db "@"

BootedUpHMText: ; e488 (3:6488)
	TX_FAR _BootedUpHMText
	db "@"

TeachMachineMoveText: ; e48d (3:648d)
	TX_FAR _TeachMachineMoveText
	db "@"

MonCannotLearnMachineMoveText: ; e492 (3:6492)
	TX_FAR _MonCannotLearnMachineMoveText
	db "@"

PrintItemUseTextAndRemoveItem: ; e497 (3:6497)
	ld hl,ItemUseText00
	call PrintText
	ld a,SFX_HEAL_AILMENT
	call PlaySound
	call WaitForTextScrollButtonPress ; wait for button press

RemoveUsedItem: ; e4a5 (3:64a5)
	ld hl,wNumBagItems
	ld a,1 ; one item
	ld [wItemQuantity],a
	jp RemoveItemFromInventory

ItemUseNoEffect: ; e4b0 (3:64b0)
	ld hl,ItemUseNoEffectText
	jr ItemUseFailed

ItemUseNotTime: ; e4b5 (3:64b5)
	ld hl,ItemUseNotTimeText
	jr ItemUseFailed

ItemUseNotYoursToUse: ; e4ba (3:64ba)
	ld hl,ItemUseNotYoursToUseText
	jr ItemUseFailed

Func_e4bf: ; e4bf (3:64bf)
	ld a, $2
	ld [wActionResultOrTookBattleTurn], a
	ld hl, DontHavePokemonText
	jp PrintText
	
ThrowBallAtTrainerMon: ; e4ca (3:64ca)
	call RunDefaultPaletteCommand
	call LoadScreenTilesFromBuffer1 ; restore saved screen
	call Delay3
	ld a,TOSS_ANIM
	ld [wAnimationID],a
	predef MoveAnimation ; do animation
	ld hl,ThrowBallAtTrainerMonText1
	call PrintText
	ld hl,ThrowBallAtTrainerMonText2
	call PrintText
	jr RemoveUsedItem

NoCyclingAllowedHere: ; e4eb (3:64eb)
	ld hl,NoCyclingAllowedHereText
	jr ItemUseFailed

BoxFullCannotThrowBall: ; e4f0 (3:64f0)
	ld hl,BoxFullCannotThrowBallText
	jr ItemUseFailed

SurfingAttemptFailed: ; e4f5 (3:64f5)
	ld hl,NoSurfingHereText

ItemUseFailed: ; e4f8 (3:64f8)
	xor a
	ld [wActionResultOrTookBattleTurn],a ; item use failed
	jp PrintText

ItemUseNotTimeText: ; e4ff (3:64ff)
	TX_FAR _ItemUseNotTimeText
	db "@"

ItemUseNotYoursToUseText: ; e504 (3:6504)
	TX_FAR _ItemUseNotYoursToUseText
	db "@"

ItemUseNoEffectText: ; e509 (3:6509)
	TX_FAR _ItemUseNoEffectText
	db "@"

ThrowBallAtTrainerMonText1: ; e50e (3:650e)
	TX_FAR _ThrowBallAtTrainerMonText1
	db "@"

ThrowBallAtTrainerMonText2: ; e513 (3:6513)
	TX_FAR _ThrowBallAtTrainerMonText2
	db "@"

NoCyclingAllowedHereText: ; e518 (3:6518)
	TX_FAR _NoCyclingAllowedHereText
	db "@"

NoSurfingHereText: ; e51d (3:651d)
	TX_FAR _NoSurfingHereText
	db "@"

BoxFullCannotThrowBallText: ; e522 (3:6522)
	TX_FAR _BoxFullCannotThrowBallText
	db "@"

DontHavePokemonText: ; e527 (3:6527)
	TX_FAR _DontHavePokemonText
	db "@"
	
ItemUseText00: ; e52c (3:652c)
	TX_FAR _ItemUseText001
	db $05
	TX_FAR _ItemUseText002
	db "@"

GotOnBicycleText: ; e536 (3:6536)
	TX_FAR _GotOnBicycleText1
	db $05
	TX_FAR _GotOnBicycleText2
	db "@"

GotOffBicycleText: ; e540 (3:6540)
	TX_FAR _GotOffBicycleText1
	db $05
	TX_FAR _GotOffBicycleText2
	db "@"

; restores bonus PP (from PP Ups) when healing at a pokemon center
; also, when a PP Up is used, it increases the current PP by one PP Up bonus
; INPUT:
; [wWhichPokemon] = index of pokemon in party
; [wCurrentMenuItem] = index of move (when using a PP Up)
RestoreBonusPP: ; e54a (3:654a)
	ld hl,wPartyMon1Moves
	ld bc, wPartyMon2 - wPartyMon1
	ld a,[wWhichPokemon]
	call AddNTimes
	push hl
	ld de,wNormalMaxPPList - 1
	predef LoadMovePPs ; loads the normal max PP of each of the pokemon's moves to wNormalMaxPPList
	pop hl
	ld c, wPartyMon1PP - wPartyMon1Moves
	ld b,0
	add hl,bc ; hl now points to move 1 PP
	ld de,wNormalMaxPPList
	ld b,0 ; initialize move counter to zero
; loop through the pokemon's moves
.loop
	inc b
	ld a,b
	cp a,5 ; reached the end of the pokemon's moves?
	ret z ; if so, return
	ld a,[wUsingPPUp]
	dec a ; using a PP Up?
	jr nz,.skipMenuItemIDCheck
; if using a PP Up, check if this is the move it's being used on
	ld a,[wCurrentMenuItem]
	inc a
	cp b
	jr nz,.nextMove
.skipMenuItemIDCheck
	ld a,[hl]
	and a,%11000000 ; have any PP Ups been used?
	call nz,AddBonusPP ; if so, add bonus PP
.nextMove
	inc hl
	inc de
	jr .loop

; adds bonus PP from PP Ups to current PP
; 1/5 of normal max PP (capped at 7) is added for each PP Up
; INPUT:
; [de] = normal max PP
; [hl] = move PP
AddBonusPP: ; e586 (3:6586)
	push bc
	ld a,[de] ; normal max PP of move
	ld [H_DIVIDEND + 3],a
	xor a
	ld [H_DIVIDEND],a
	ld [H_DIVIDEND + 1],a
	ld [H_DIVIDEND + 2],a
	ld a,5
	ld [H_DIVISOR],a
	ld b,4
	call Divide
	ld a,[hl] ; move PP
	ld b,a
	swap a
	and a,%1111
	srl a
	srl a
	ld c,a ; c = number of PP Ups used
.loop
	ld a,[H_QUOTIENT + 3]
	cp a,8 ; is the amount greater than or equal to 8?
	jr c,.addAmount
	ld a,7 ; cap the amount at 7
.addAmount
	add b
	ld b,a
	ld a,[wUsingPPUp]
	dec a ; is the player using a PP Up right now?
	jr z,.done ; if so, only add the bonus once
	dec c
	jr nz,.loop
.done
	ld [hl],b
	pop bc
	ret

; gets max PP of a pokemon's move (including PP from PP Ups)
; INPUT:
; [wWhichPokemon] = index of pokemon within party/box
; [wMonDataLocation] = pokemon source
; 00: player's party
; 01: enemy's party
; 02: current box
; 03: daycare
; 04: player's in-battle pokemon
; [wCurrentMenuItem] = move index
; OUTPUT:
; [wMaxPP] = max PP
GetMaxPP: ; e5bb (3:65bb)
	ld a,[wMonDataLocation]
	and a
	ld hl,wPartyMon1Moves
	ld bc,wPartyMon2 - wPartyMon1
	jr z,.sourceWithMultipleMon
	ld hl,wEnemyMon1Moves
	dec a
	jr z,.sourceWithMultipleMon
	ld hl,wBoxMon1Moves
	ld bc,wBoxMon2 - wBoxMon1
	dec a
	jr z,.sourceWithMultipleMon
	ld hl,wDayCareMonMoves
	dec a
	jr z,.sourceWithOneMon
	ld hl,wBattleMonMoves ; player's in-battle pokemon
.sourceWithOneMon
	call GetSelectedMoveOffset2
	jr .next
.sourceWithMultipleMon
	call GetSelectedMoveOffset
.next
	ld a,[hl]
	dec a
	push hl
	ld hl,Moves
	ld bc,MoveEnd - Moves
	call AddNTimes
	ld de,wcd6d
	ld a,BANK(Moves)
	call FarCopyData
	ld de,wcd6d + 5 ; PP is byte 5 of move data
	ld a,[de]
	ld b,a ; b = normal max PP
	pop hl
	push bc
	ld bc,wPartyMon1PP - wPartyMon1Moves ; PP offset if not player's in-battle pokemon data
	ld a,[wMonDataLocation]
	cp a,4 ; player's in-battle pokemon?
	jr nz,.addPPOffset
	ld bc,wBattleMonPP - wBattleMonMoves ; PP offset if player's in-battle pokemon data
.addPPOffset
	add hl,bc
	ld a,[hl] ; a = current PP
	and a,%11000000 ; get PP Up count
	pop bc
	or b ; place normal max PP in 6 lower bits of a
	ld h,d
	ld l,e
	inc hl ; hl = wcd73
	ld [hl],a
	xor a ; add the bonus for the existing PP Up count
	ld [wUsingPPUp],a
	call AddBonusPP ; add bonus PP from PP Ups
	ld a,[hl]
	and a,%00111111 ; mask out the PP Up count
	ld [wMaxPP],a ; store max PP
	ret

GetSelectedMoveOffset: ; e627 (3:6627)
	ld a,[wWhichPokemon]
	call AddNTimes

GetSelectedMoveOffset2: ; e62d (3:662d)
	ld a,[wCurrentMenuItem]
	ld c,a
	ld b,0
	add hl,bc
	ret

; confirms the item toss and then tosses the item
; INPUT:
; hl = address of inventory (either wNumBagItems or wNumBoxItems)
; [wcf91] = item ID
; [wWhichPokemon] = index of item within inventory
; [wItemQuantity] = quantity to toss
; OUTPUT:
; clears carry flag if the item is tossed, sets carry flag if not
TossItem_: ; e635 (3:6635)
	push hl
	ld a,[wcf91]
	call IsItemHM
	pop hl
	jr c,.tooImportantToToss
	push hl
	call IsKeyItem_
	ld a,[wIsKeyItem]
	pop hl
	and a
	jr nz,.tooImportantToToss
	push hl
	ld a,[wcf91]
	ld [wd11e],a
	call GetItemName
	call CopyStringToCF4B ; copy name to wcf4b
	ld hl,IsItOKToTossItemText
	call PrintText
	coord hl, 14, 7
	lb bc, 8, 15
	ld a,TWO_OPTION_MENU
	ld [wTextBoxID],a
	call DisplayTextBoxID ; yes/no menu
	ld a,[wMenuExitMethod]
	cp a,CHOSE_SECOND_ITEM
	pop hl
	scf
	ret z ; return if the player chose No
; if the player chose Yes
	push hl
	ld a,[wWhichPokemon]
	call RemoveItemFromInventory
	ld a,[wcf91]
	ld [wd11e],a
	call GetItemName
	call CopyStringToCF4B ; copy name to wcf4b
	ld hl,ThrewAwayItemText
	call PrintText
	pop hl
	and a
	ret
.tooImportantToToss
	push hl
	ld hl,TooImportantToTossText
	call PrintText
	pop hl
	scf
	ret

ThrewAwayItemText: ; e699 (3:6699)
	TX_FAR _ThrewAwayItemText
	db "@"

IsItOKToTossItemText: ; e69e (3:669e)
	TX_FAR _IsItOKToTossItemText
	db "@"

TooImportantToTossText: ; e6a3 (3:66a3)
	TX_FAR _TooImportantToTossText
	db "@"

; checks if an item is a key item
; INPUT:
; [wcf91] = item ID
; OUTPUT:
; [wIsKeyItem] = result
; 00: item is not key item
; 01: item is key item
IsKeyItem_: ; e6a8 (3:66a8)
	ld a,$01
	ld [wIsKeyItem],a
	ld a,[wcf91]
	cp a,HM_01 ; is the item an HM or TM?
	jr nc,.checkIfItemIsHM
; if the item is not an HM or TM
	push af
	ld hl,KeyItemBitfield
	ld de,wBuffer
	ld bc,15 ; only 11 bytes are actually used
	call CopyData
	pop af
	dec a
	ld c,a
	ld hl,wBuffer
	ld b,FLAG_TEST
	predef FlagActionPredef
	ld a,c
	and a
	ret nz
.checkIfItemIsHM
	ld a,[wcf91]
	call IsItemHM
	ret c
	xor a
	ld [wIsKeyItem],a
	ret

INCLUDE "data/key_items.asm"

SendNewMonToBox: ; e6e8 (3:66e8)
	ld de, wNumInBox
	ld a, [de]
	inc a
	ld [de], a
	ld a, [wcf91]
	ld [wd0b5], a
	ld c, a
.asm_e6f5
	inc de
	ld a, [de]
	ld b, a
	ld a, c
	ld c, b
	ld [de], a
	cp $ff
	jr nz, .asm_e6f5
	call GetMonHeader
	ld hl, wBoxMonOT
	ld bc, NAME_LENGTH
	ld a, [wNumInBox]
	dec a
	jr z, .asm_e732
	dec a
	call AddNTimes
	push hl
	ld bc, NAME_LENGTH
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld a, [wNumInBox]
	dec a
	ld b, a
.asm_e71f
	push bc
	push hl
	ld bc, NAME_LENGTH
	call CopyData
	pop hl
	ld d, h
	ld e, l
	ld bc, -NAME_LENGTH
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_e71f
.asm_e732
	ld hl, wPlayerName
	ld de, wBoxMonOT
	ld bc, NAME_LENGTH
	call CopyData
	ld a, [wNumInBox]
	dec a
	jr z, .asm_e76e
	ld hl, wBoxMonNicks
	ld bc, NAME_LENGTH
	dec a
	call AddNTimes
	push hl
	ld bc, NAME_LENGTH
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld a, [wNumInBox]
	dec a
	ld b, a
.asm_e75b
	push bc
	push hl
	ld bc, NAME_LENGTH
	call CopyData
	pop hl
	ld d, h
	ld e, l
	ld bc, -NAME_LENGTH
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_e75b
.asm_e76e
	ld hl, wBoxMonNicks
	ld a, NAME_MON_SCREEN
	ld [wNamingScreenType], a
	predef AskName
	ld a, [wNumInBox]
	dec a
	jr z, .asm_e7ab
	ld hl, wBoxMons
	ld bc, wBoxMon2 - wBoxMon1
	dec a
	call AddNTimes
	push hl
	ld bc, wBoxMon2 - wBoxMon1
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld a, [wNumInBox]
	dec a
	ld b, a
.asm_e798
	push bc
	push hl
	ld bc, wBoxMon2 - wBoxMon1
	call CopyData
	pop hl
	ld d, h
	ld e, l
	ld bc, wBoxMon1 - wBoxMon2
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_e798
.asm_e7ab
	ld a, [wEnemyMonLevel]
	ld [wEnemyMonBoxLevel], a
	ld hl, wEnemyMon
	ld de, wBoxMon1
	ld bc, wEnemyMonDVs - wEnemyMon
	call CopyData
	ld hl, wPlayerID
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	push de
	ld a, [wCurEnemyLVL]
	ld d, a
	callab CalcExperience
	pop de
	ld a, [hExperience]
	ld [de], a
	inc de
	ld a, [hExperience + 1]
	ld [de], a
	inc de
	ld a, [hExperience + 2]
	ld [de], a
	inc de
	xor a
	ld b, NUM_STATS * 2
.asm_e7e3
	ld [de], a
	inc de
	dec b
	jr nz, .asm_e7e3
	ld hl, wEnemyMonDVs
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld hl, wEnemyMonPP
	ld b, NUM_MOVES
.asm_e7f5
	ld a, [hli]
	inc de
	ld [de], a
	dec b
	jr nz, .asm_e7f5
	ld a, [wcf91]
	cp KADABRA
	jr nz, .notKadabra
	ld a, $60 ; twistedspoon in gsc
	ld [wBoxMon1CatchRate], a
.notKadabra
	ret

; checks if the tile in front of the player is a shore or water tile
; used for surfing and fishing
; unsets carry if it is, sets carry if not
IsNextTileShoreOrWater: ; e808 (3:6808)
	ld a, [wCurMapTileset]
	ld hl, WaterTilesets
	ld de,1
	call IsInArray ; does the current map allow surfing?
	ret nc ; if not, return
	ld hl,WaterTile
	ld a, [wCurMapTileset]
	cp SHIP_PORT ; Vermilion Dock tileset
	jr z, .skipShoreTiles ; if it's the Vermilion Dock tileset
	cp GYM ; eastern shore tile in Safari Zone
	jr z, .skipShoreTiles
	cp DOJO ; usual eastern shore tile
	jr z, .skipShoreTiles
	ld hl,ShoreTiles
.skipShoreTiles
	ld a,[wTileInFrontOfPlayer]
	ld de,$1
	call IsInArray
	ret

; tilesets with water
WaterTilesets: ; e834 (3:6834)
	db OVERWORLD, FOREST, DOJO, GYM, SHIP, SHIP_PORT, CAVERN, FACILITY, PLATEAU
	db $ff ; terminator

; shore tiles
ShoreTiles: ; e83e (3:683e)
	db $48, $32
WaterTile: ; e840 (3:6840)
	db $14
	db $ff ; terminator

; reloads map view and processes sprite data
; for items that cause the overworld to be displayed
ItemUseReloadOverworldData: ; e842 (3:6842)
	call LoadCurrentMapView
	jp UpdateSprites

; creates a list at wBuffer of maps where the mon in [wd11e] can be found.
; this is used by the pokedex to display locations the mon can be found on the map.
FindWildLocationsOfMon: ; e848 (3:6848)
	ld hl, WildDataPointers
	ld de, wBuffer
	ld c, $0
.loop
	inc hl
	ld a, [hld]
	inc a
	jr z, .done
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	and a
	call nz, CheckMapForMon ; land
	ld a, [hli]
	and a
	call nz, CheckMapForMon ; water
	pop hl
	inc hl
	inc hl
	inc c
	jr .loop
.done
	ld a, $ff ; list terminator
	ld [de], a
	ret

CheckMapForMon: ; e86d (3:686d)
	inc hl
	ld b, $a
.loop
	ld a, [wd11e]
	cp [hl]
	jr nz, .nextEntry
	ld a, c
	ld [de], a
	inc de
.nextEntry
	inc hl
	inc hl
	dec b
	jr nz, .loop
	dec hl
	ret
