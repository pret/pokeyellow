DisplayPokemonCenterDialogue_: ; 6d97 (1:6d97)
	ld a, [wCurMap]
	cp PEWTER_POKECENTER
	jr nz, .regularCenter
	call Func_154a
	jr z, .regularCenter
	ld hl, LooksContentText ; if pikachu is sleeping, don't heal
	call PrintText
	ret
.regularCenter
	call SaveScreenTilesToBuffer1 ; save screen
	ld hl, PokemonCenterWelcomeText
	call PrintText
	ld hl, wd72e
	bit 2, [hl]
	set 1, [hl]
	set 2, [hl]
	jr nz, .skipShallWeHealYourPokemon
	ld hl, ShallWeHealYourPokemonText
	call PrintText
.skipShallWeHealYourPokemon
	call YesNoChoicePokeCenter ; yes/no menu
	call UpdateSprites
	ld a, [wCurrentMenuItem]
	and a
	jp nz, .declinedHealing ; if the player chose No
	call SetLastBlackoutMap
	callab IsPikachuInOurParty
	jr nc, .notHealingPlayerPikachu
	call Func_154a
	jr nz, .notHealingPlayerPikachu
	call LoadCurrentMapView
	call Delay3
	call UpdateSprites
	callab Func_fd252 ; todo
.notHealingPlayerPikachu
	ld hl, NeedYourPokemonText
	call PrintText
	ld c, 64
	call DelayFrames
	call Func_154a
	jr nz, .playerPikachuNotOnScreen
	call Func_152d
	callab IsPikachuInOurParty
	call c, Func_6eaa
.playerPikachuNotOnScreen
	lb bc, 1, 8
	call Func_6ebb
	ld c, 30
	call DelayFrames
	callba AnimateHealingMachine ; do the healing machine animation
	predef HealParty
	xor a
	ld [wAudioFadeOutControl], a
	ld a, [wAudioSavedROMBank]
	ld [wAudioROMBank], a
	ld a, [wMapMusicSoundID]
	ld [wLastMusicSoundID], a
	ld [wNewSoundID], a
	call PlaySound
	call Func_154a
	jr nz, .doNotReturnPikachu
	callab IsPikachuInOurParty
	call c, Func_6eaa
	ld a, $5
	ld [wd431], a
	call Func_1525
.doNotReturnPikachu
	lb bc, 1, 0
	call Func_6ebb
	ld hl, PokemonFightingFitText
	call PrintText
	callab IsPikachuInOurParty
	jr nc, .notInParty
	lb bc, 15, 0
	call Func_6ebb
.notInParty
	call LoadCurrentMapView
	call Delay3
	call UpdateSprites
	callab ReloadWalkingTilePatterns
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, $1
	ld [hSpriteImageIndex], a
	call SpriteFunc_34a1
	ld c, 40
	call DelayFrames
	call UpdateSprites
	call LoadFontTilePatterns
	jr .done
.declinedHealing
	call LoadScreenTilesFromBuffer1 ; restore screen
.done
	ld hl, PokemonCenterFarewellText
	call PrintText
	call UpdateSprites
	ret

Func_6eaa: ; 6eaa (1:6eaa)
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, $4
	ld [hSpriteImageIndex], a
	call SpriteFunc_34a1
	ld c, 64
	call DelayFrames
	ret
	
Func_6ebb: ; 6ebb (1:6ebb)
	ld a, b
	ld [H_SPRITEINDEX], a
	ld a, c
	ld [hSpriteImageIndex], a
	push bc
	call SetSpriteFacingDirectionAndDelay
	pop bc
	ld a, b
	ld [H_SPRITEINDEX], a
	ld a, c
	ld [hSpriteImageIndex], a
	call SpriteFunc_34a1
	ret
	
PokemonCenterWelcomeText: ; 6de0 (1:6de0)
	TX_FAR _PokemonCenterWelcomeText
	db "@"

ShallWeHealYourPokemonText: ; 6de5 (1:6de5)
	db $a
	TX_FAR _ShallWeHealYourPokemonText
	db "@"

NeedYourPokemonText: ; 6deb (1:6deb)
	TX_FAR _NeedYourPokemonText
	db "@"

PokemonFightingFitText: ; 6ee0 (1:6ee0)
	TX_FAR _PokemonFightingFitText
	db "@"

PokemonCenterFarewellText: ; 6ee5 (1:6ee5)
	db $a
	TX_FAR _PokemonCenterFarewellText
	db "@"
	
LooksContentText: ; 6eeb (1:6eeb)
	TX_FAR _LooksContentText
	db "@"