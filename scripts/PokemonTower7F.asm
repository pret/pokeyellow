PokemonTower7F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, PokemonTower7F_ScriptPointers
	ld a, [wPokemonTower7FCurScript]
	call CallFunctionInTable
	ret

PokemonTower7FSetDefaultScript:
	xor a
	ld [wJoyIgnore], a
PokemonTower7FSetScript:
	ld [wPokemonTower7FCurScript], a
	ret

PokemonTower7F_ScriptPointers:
	def_script_pointers
	dw_const PokemonTower7FDefaultScript,                 SCRIPT_POKEMONTOWER7F_DEFAULT
	dw_const PokemonTower7FJesseMoveScript,               SCRIPT_POKEMONTOWER7F_JESSE_MOVE
	dw_const PokemonTower7FJesseWaitScript,               SCRIPT_POKEMONTOWER7F_JESSE_WAIT
	dw_const PokemonTower7FJesseSetFacingDirectionScript, SCRIPT_POKEMONTOWER7F_JESSE_FACING
	dw_const PokemonTower7FJamesMoveScript,               SCRIPT_POKEMONTOWER7F_JAMES_MOVE
	dw_const PokemonTower7FJamesWaitScript,               SCRIPT_POKEMONTOWER7F_JAMES_WAIT
	dw_const PokemonTower7FJamesSetFacingDirectionScript, SCRIPT_POKEMONTOWER7F_JAMES_FACING
	dw_const PokemonTower7FJesseJamesStartBattleScript,   SCRIPT_POKEMONTOWER7F_JESSE_JAMES_START_BATTLE
	dw_const PokemonTower7FJesseJamesAfterBattleScript,   SCRIPT_POKEMONTOWER7F_JESSE_JAMES_AFTER_BATTLE
	dw_const PokemonTower7FJesseJamesExitScript,          SCRIPT_POKEMONTOWER7F_JESSE_JAMES_EXIT
	dw_const PokemonTower7FJesseJamesCleanupScript,       SCRIPT_POKEMONTOWER7F_JESSE_JAMES_CLEANUP
	dw_const PokemonTower7FWarpToMrFujiHouseScript,       SCRIPT_POKEMONTOWER7F_WARP_TO_MR_FUJI_HOUSE

PokemonTower7FDefaultScript:
IF DEF(_DEBUG)
	call DebugPressedOrHeldB
	ret nz
ENDC
	CheckEvent EVENT_BEAT_POKEMONTOWER_7_JESSIE_JAMES
	call z, PokemonTower7FJesseJamesScript
	ret

PokemonTower7FJesseJamesScript:
	ld a, [wYCoord]
	cp 12
	ret nz
	ResetEvent EVENT_POKEMONTOWER_7_JESSIE_JAMES_ON_LEFT
	ld a, [wXCoord]
	cp 10
	jr z, .playerOnLeft
	ld a, [wXCoord]
	cp 11
	ret nz
	SetEvent EVENT_POKEMONTOWER_7_JESSIE_JAMES_ON_LEFT
.playerOnLeft
	call StopAllMusic
	ld c, BANK(Music_MeetJessieJames)
	ld a, MUSIC_MEET_JESSIE_JAMES
	call PlayMusic
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, HS_POKEMON_TOWER_7F_JESSIE
	call PokemonTower7FScript_ShowObject
	ld a, HS_POKEMON_TOWER_7F_JAMES
	call PokemonTower7FScript_ShowObject
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, TEXT_POKEMONTOWER7F_JESSE_JAMES_SPOTTED
	ldh [hTextID], a
	call DisplayTextID
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_POKEMONTOWER7F_JESSE_MOVE
	call PokemonTower7FSetScript
	ret

PokemonTower7FJessieJamesLongMove:
	db NPC_MOVEMENT_DOWN_FAST 
PokemonTower7FJessieJamesShortMove:
	db NPC_MOVEMENT_DOWN_FAST 
	db NPC_MOVEMENT_DOWN_FAST 
	db NPC_MOVEMENT_DOWN_FAST 
	db -1

PokemonTower7FJesseMoveScript:
	ld de, PokemonTower7FJessieJamesShortMove
	CheckEvent EVENT_POKEMONTOWER_7_JESSIE_JAMES_ON_LEFT
	jr z, .playerStandingRight
	ld de, PokemonTower7FJessieJamesLongMove
.playerStandingRight
	ld a, POKEMONTOWER7F_JESSIE
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_POKEMONTOWER7F_JESSE_WAIT
	call PokemonTower7FSetScript
	ret

PokemonTower7FJesseWaitScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
PokemonTower7FJesseSetFacingDirectionScript:
	ld a, SPRITE_FACING_DOWN
	ld [wSprite01StateData1FacingDirection], a
	CheckEvent EVENT_POKEMONTOWER_7_JESSIE_JAMES_ON_LEFT
	jr z, .playerStandingRight
	ld a, SPRITE_FACING_RIGHT
	ld [wSprite01StateData1FacingDirection], a
.playerStandingRight
	ld a, 2
	ld [wSprite01StateData1MovementStatus], a
PokemonTower7FJamesMoveScript:
	ld de, PokemonTower7FJessieJamesLongMove
	CheckEvent EVENT_POKEMONTOWER_7_JESSIE_JAMES_ON_LEFT
	jr z, .playerStandingRight
	ld de, PokemonTower7FJessieJamesShortMove
.playerStandingRight
	ld a, POKEMONTOWER7F_JAMES
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_POKEMONTOWER7F_JAMES_WAIT
	call PokemonTower7FSetScript
	ret

PokemonTower7FJamesWaitScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
PokemonTower7FJamesSetFacingDirectionScript:
	ld a, 2
	ld [wSprite02StateData1MovementStatus], a
	ld a, SPRITE_FACING_LEFT
	ld [wSprite02StateData1FacingDirection], a
	CheckEvent EVENT_POKEMONTOWER_7_JESSIE_JAMES_ON_LEFT
	jr z, .playerStandingRight
	ld a, SPRITE_FACING_DOWN
	ld [wSprite02StateData1FacingDirection], a
.playerStandingRight
	call Delay3
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, TEXT_POKEMONTOWER7F_JESSE_JAMES_PREBATTLE
	ldh [hTextID], a
	call DisplayTextID
PokemonTower7FJesseJamesStartBattleScript:
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, PokemonTower7FJessieJamesEndBattleText
	ld de, PokemonTower7FJessieJamesEndBattleText
	call SaveEndBattleTextPointers
	ld a, OPP_ROCKET
	ld [wCurOpponent], a
	ld a, $2c
	ld [wTrainerNo], a
	xor a
	ldh [hJoyHeld], a
	ld [wJoyIgnore], a
	ld a, SCRIPT_POKEMONTOWER7F_JESSE_JAMES_AFTER_BATTLE
	call PokemonTower7FSetScript
	ret

PokemonTower7FJesseJamesAfterBattleScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wIsInBattle]
	cp -1
	jp z, PokemonTower7FSetDefaultScript
	ld a, 2
	ld [wSprite01StateData1MovementStatus], a
	ld [wSprite02StateData1MovementStatus], a
	xor a
	ld [wSprite01StateData1FacingDirection], a
	ld [wSprite02StateData1FacingDirection], a
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, TEXT_POKEMONTOWER7F_JESSE_JAMES_POSTBATTLE
	ldh [hTextID], a
	call DisplayTextID
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call StopAllMusic
	ld c, BANK(Music_MeetJessieJames)
	ld a, MUSIC_MEET_JESSIE_JAMES
	call PlayMusic
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_POKEMONTOWER7F_JESSE_JAMES_EXIT
	call PokemonTower7FSetScript
	ret

PokemonTower7FJesseJamesExitScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	call GBFadeOutToBlack
	ld a, HS_POKEMON_TOWER_7F_JESSIE
	call PokemonTower7FScript_HideObject
	ld a, HS_POKEMON_TOWER_7F_JAMES
	call PokemonTower7FScript_HideObject
	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack
	ld a, SCRIPT_POKEMONTOWER7F_JESSE_JAMES_CLEANUP
	call PokemonTower7FSetScript
	ret

PokemonTower7FJesseJamesCleanupScript:
	call PlayDefaultMusic
	xor a
	ldh [hJoyHeld], a
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_POKEMONTOWER_7_JESSIE_JAMES
	ld a, SCRIPT_POKEMONTOWER7F_DEFAULT
	call PokemonTower7FSetScript
	ret

PokemonTower7FScript_ShowObject:
	ld [wMissableObjectIndex], a
	predef ShowObject
	call UpdateSprites
	call Delay3
	ret

PokemonTower7FScript_HideObject:
	ld [wMissableObjectIndex], a
	predef HideObject
	ret

PokemonTower7FWarpToMrFujiHouseScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, HS_POKEMON_TOWER_7F_MR_FUJI
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, SPRITE_FACING_UP
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, MR_FUJIS_HOUSE
	ldh [hWarpDestinationMap], a
	ld a, 1
	ld [wDestinationWarpID], a
	ld a, LAVENDER_TOWN
	ld [wLastMap], a
	ld hl, wStatusFlags3
	set BIT_WARP_FROM_CUR_SCRIPT, [hl]
	ld a, SCRIPT_POKEMONTOWER7F_DEFAULT
	ld [wPokemonTower7FCurScript], a
	ret

PokemonTower7F_TextPointers:
	def_text_pointers
	dw_const PokemonTower7FJessieJamesText,           TEXT_POKEMONTOWER7F_JESSIE
	dw_const PokemonTower7FJessieJamesText,           TEXT_POKEMONTOWER7F_JAMES
	dw_const PokemonTower7FMrFujiText,                TEXT_POKEMONTOWER7F_MR_FUJI
	dw_const PokemonTower7FJessieJamesSpottedText,    TEXT_POKEMONTOWER7F_JESSE_JAMES_SPOTTED
	dw_const PokemonTower7FJessieJamesPreBattleText,  TEXT_POKEMONTOWER7F_JESSE_JAMES_PREBATTLE
	dw_const PokemonTower7FJessieJamesPostBattleText, TEXT_POKEMONTOWER7F_JESSE_JAMES_POSTBATTLE

PokemonTower7FJessieJamesText:
	text_end

PokemonTower7FJessieJamesSpottedText:
	text_far _PokemonTower7FJessieJamesSpottedText
	text_asm
	ld c, 10
	call DelayFrames
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, 0
	ld [wEmotionBubbleSpriteIndex], a
	ld a, EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	ld c, 20
	call DelayFrames
	jp TextScriptEnd

PokemonTower7FJessieJamesPreBattleText:
	text_far _PokemonTower7FJessieJamesPreBattleText
	text_end

PokemonTower7FJessieJamesEndBattleText:
	text_far _PokemonTower7FJessieJamesEndBattleText
	text_end

PokemonTower7FJessieJamesPostBattleText:
	text_far _PokemonTower7FJessieJamesPostBattleText
	text_asm
	ld c, 64
	call DelayFrames
	jp TextScriptEnd

PokemonTower7FMrFujiText:
	text_asm
	ld hl, .RescueText
	call PrintText
	SetEvent EVENT_RESCUED_MR_FUJI
	SetEvent EVENT_RESCUED_MR_FUJI_2
	ld a, HS_MR_FUJIS_HOUSE_MR_FUJI
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_SAFFRON_CITY_E
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_SAFFRON_CITY_F
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, SCRIPT_POKEMONTOWER7F_WARP_TO_MR_FUJI_HOUSE
	ld [wPokemonTower7FCurScript], a
	jp TextScriptEnd

.RescueText:
	text_far _PokemonTower7FMrFujiRescueText
	text_end
