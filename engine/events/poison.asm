ApplyOutOfBattlePoisonDamage:
	ld a, [wStatusFlags5]
	ASSERT BIT_SCRIPTED_MOVEMENT_STATE == 7
	add a ; overflows scripted movement state bit into carry flag
	jp c, .noBlackOut ; no black out if joypad states are being simulated
	ld a, [wd492]
	bit 7, a
	jp nz, .noBlackOut
	ld a, [wStatusFlags4]
	bit BIT_LINK_CONNECTED, a
	jp nz, .noBlackOut
	ld a, [wPartyCount]
	and a
	jp z, .noBlackOut
	call IncrementDayCareMonExp
	call UpdatePikachuHappinessAndMood
	ld a, [wStepCounter]
	and $3 ; is the counter a multiple of 4?
	jp nz, .skipPoisonEffectAndSound ; only apply poison damage every fourth step
	ld [wWhichPokemon], a
	ld hl, wPartyMon1Status
	ld de, wPartySpecies
.applyDamageLoop
	ld a, [hl]
	and 1 << PSN
	jr z, .nextMon2 ; not poisoned
	dec hl
	dec hl
	ld a, [hld]
	ld b, a
	ld a, [hli]
	or b
	jr z, .nextMon ; already fainted
; subtract 1 from HP
	ld a, [hl]
	dec a
	ld [hld], a
	inc a
	jr nz, .noBorrow
; borrow 1 from upper byte of HP
	dec [hl]
	inc hl
	jr .nextMon
.noBorrow
	ld a, [hli]
	or [hl]
	jr nz, .nextMon ; didn't faint from damage
; the mon fainted from the damage
	push hl
	inc hl
	inc hl
	ld [hl], a
	ld a, [de]
	ld [wPokedexNum], a
	push de
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	xor a
	ld [wJoyIgnore], a
	call EnableAutoTextBoxDrawing
	ld a, TEXT_MON_FAINTED
	ldh [hTextID], a
	call DisplayTextID
	callfar IsThisPartyMonStarterPikachu
	jr nc, .curMonNotPlayerPikachu
	ldpikacry e, PikachuCry4
	callfar PlayPikachuSoundClip
	callfar_ModifyPikachuHappiness PIKAHAPPY_PSNFNT
.curMonNotPlayerPikachu
	pop de
	pop hl
.nextMon
	inc hl
	inc hl
.nextMon2
	inc de
	ld a, [de]
	inc a
	jr z, .applyDamageLoopDone
	ld bc, PARTYMON_STRUCT_LENGTH
	add hl, bc
	push hl
	ld hl, wWhichPokemon
	inc [hl]
	pop hl
	jr .applyDamageLoop
.applyDamageLoopDone
	ld hl, wPartyMon1Status
	ld a, [wPartyCount]
	ld d, a
	ld e, 0
.countPoisonedLoop
	ld a, [hl]
	and 1 << PSN
	or e
	ld e, a
	ld bc, PARTYMON_STRUCT_LENGTH
	add hl, bc
	dec d
	jr nz, .countPoisonedLoop
	ld a, e
	and a ; are any party members poisoned?
	jr z, .skipPoisonEffectAndSound
	ld b, $2
	predef ChangeBGPalColor0_4Frames ; change BG white to dark gray for 4 frames
	ld a, SFX_POISONED
	call PlaySound
.skipPoisonEffectAndSound
	predef AnyPartyAlive
	ld a, d
	and a
	jr nz, .noBlackOut
	call EnableAutoTextBoxDrawing
	ld a, TEXT_BLACKED_OUT
	ldh [hTextID], a
	call DisplayTextID
	ld hl, wStatusFlags4
	set BIT_BATTLE_OVER_OR_BLACKOUT, [hl]
	ld a, $ff
	jr .done
.noBlackOut
	xor a
.done
	ld [wOutOfBattleBlackout], a
	ret

UpdatePikachuHappinessAndMood:
	ld a, [wStepCounter]
	and a ; is the counter nonzero?
	jr nz, .noWalkingHappinessIncrease ; only increase Pikachu's happiness every 256 steps
	call Random
	and 1 ; 50% chance to increase happiness
	jr z, .noWalkingHappinessIncrease
	callfar_ModifyPikachuHappiness PIKAHAPPY_WALKING
.noWalkingHappinessIncrease
; every step, mood converges by 1 unit towards the central value of 128:
; if it's lower than 128 it increases by 1, if it's higher, it decreases
	ld hl, wPikachuMood
	ld a, [hl]
	cp 128 ; central value
	jr z, .clearEmotionModifier ; mood == 128, don't modify it
	jr c, .increaseMood ; mood < 128, must increase by 1
	; mood > 128, must decrease by 1 (so decrease by 2 and then increase by 1)
	dec a
	dec a
.increaseMood
	inc a
	ld [hl], a
; if the mood has reached its "stable" central value, do not update the emotion modifier
	cp 128
	ret nz
.clearEmotionModifier
	xor a
	ld [wPikachuEmotionModifier], a ; variable used in other mood-related functions, to keep track if the mood was "stable"
	ret
