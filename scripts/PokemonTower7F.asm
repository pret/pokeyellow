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
	dw_const PokemonTower7FScript0,                 SCRIPT_POKEMONTOWER7F_SCRIPT0
	dw_const PokemonTower7FScript1,                 SCRIPT_POKEMONTOWER7F_SCRIPT1
	dw_const PokemonTower7FScript2,                 SCRIPT_POKEMONTOWER7F_SCRIPT2
	dw_const PokemonTower7FScript3,                 SCRIPT_POKEMONTOWER7F_SCRIPT3
	dw_const PokemonTower7FScript4,                 SCRIPT_POKEMONTOWER7F_SCRIPT4
	dw_const PokemonTower7FScript5,                 SCRIPT_POKEMONTOWER7F_SCRIPT5
	dw_const PokemonTower7FScript6,                 SCRIPT_POKEMONTOWER7F_SCRIPT6
	dw_const PokemonTower7FScript7,                 SCRIPT_POKEMONTOWER7F_SCRIPT7
	dw_const PokemonTower7FScript8,                 SCRIPT_POKEMONTOWER7F_SCRIPT8
	dw_const PokemonTower7FScript9,                 SCRIPT_POKEMONTOWER7F_SCRIPT9
	dw_const PokemonTower7FScript10,                SCRIPT_POKEMONTOWER7F_SCRIPT10
	dw_const PokemonTower7FWarpToMrFujiHouseScript, SCRIPT_POKEMONTOWER7F_WARP_TO_MR_FUJI_HOUSE

PokemonTower7FScript0:
IF DEF(_DEBUG)
	call DebugPressedOrHeldB
	ret nz
ENDC
	CheckEvent EVENT_BEAT_POKEMONTOWER_7_JESSIE_JAMES
	call z, PokemonTower7FScript_60d2a
	ret

PokemonTower7FScript_60d2a:
	ld a, [wYCoord]
	cp $c
	ret nz
	ResetEvent EVENT_POKEMONTOWER_7_JESSIE_JAMES_ON_LEFT
	ld a, [wXCoord]
	cp $a
	jr z, .asm_60d47
	ld a, [wXCoord] ; why?
	cp $b
	ret nz
	SetEvent EVENT_POKEMONTOWER_7_JESSIE_JAMES_ON_LEFT
.asm_60d47
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
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, TEXT_POKEMONTOWER7F_TEXT4
	ldh [hTextID], a
	call DisplayTextID
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_POKEMONTOWER7F_SCRIPT1
	call PokemonTower7FSetScript
	ret

PokemonTower7FMovementData_60d7a:
	db $4
PokemonTower7FMovementData_60d7b:
	db $4
	db $4
	db $4
	db $FF

PokemonTower7FScript1:
	ld de, PokemonTower7FMovementData_60d7b
	CheckEvent EVENT_POKEMONTOWER_7_JESSIE_JAMES_ON_LEFT
	jr z, .asm_60d8c
	ld de, PokemonTower7FMovementData_60d7a
.asm_60d8c
	ld a, POKEMONTOWER7F_JESSIE
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_POKEMONTOWER7F_SCRIPT2
	call PokemonTower7FSetScript
	ret

PokemonTower7FScript2:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
PokemonTower7FScript3:
	ld a, SPRITE_FACING_DOWN
	ld [wSprite01StateData1FacingDirection], a
	CheckEvent EVENT_POKEMONTOWER_7_JESSIE_JAMES_ON_LEFT
	jr z, .asm_60dba
	ld a, SPRITE_FACING_RIGHT
	ld [wSprite01StateData1FacingDirection], a
.asm_60dba
	ld a, $2
	ld [wSprite01StateData1MovementStatus], a
PokemonTower7FScript4:
	ld de, PokemonTower7FMovementData_60d7a
	CheckEvent EVENT_POKEMONTOWER_7_JESSIE_JAMES_ON_LEFT
	jr z, .asm_60dcc
	ld de, PokemonTower7FMovementData_60d7b
.asm_60dcc
	ld a, POKEMONTOWER7F_JAMES
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_POKEMONTOWER7F_SCRIPT5
	call PokemonTower7FSetScript
	ret

PokemonTower7FScript5:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
PokemonTower7FScript6:
	ld a, $2
	ld [wSprite02StateData1MovementStatus], a
	ld a, SPRITE_FACING_LEFT
	ld [wSprite02StateData1FacingDirection], a
	CheckEvent EVENT_POKEMONTOWER_7_JESSIE_JAMES_ON_LEFT
	jr z, .asm_60dff
	ld a, SPRITE_FACING_DOWN
	ld [wSprite02StateData1FacingDirection], a
.asm_60dff
	call Delay3
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, TEXT_POKEMONTOWER7F_TEXT5
	ldh [hTextID], a
	call DisplayTextID
PokemonTower7FScript7:
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
	ld a, SCRIPT_POKEMONTOWER7F_SCRIPT8
	call PokemonTower7FSetScript
	ret

PokemonTower7FScript8:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wIsInBattle]
	cp $ff
	jp z, PokemonTower7FSetDefaultScript
	ld a, $2
	ld [wSprite01StateData1MovementStatus], a
	ld [wSprite02StateData1MovementStatus], a
	xor a
	ld [wSprite01StateData1FacingDirection], a
	ld [wSprite02StateData1FacingDirection], a
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, TEXT_POKEMONTOWER7F_TEXT6
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
	ld a, SCRIPT_POKEMONTOWER7F_SCRIPT9
	call PokemonTower7FSetScript
	ret

PokemonTower7FScript9:
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
	ld a, SCRIPT_POKEMONTOWER7F_SCRIPT10
	call PokemonTower7FSetScript
	ret

PokemonTower7FScript10:
	call PlayDefaultMusic
	xor a
	ldh [hJoyHeld], a
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_POKEMONTOWER_7_JESSIE_JAMES
	ld a, SCRIPT_POKEMONTOWER7F_SCRIPT0
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
	ld a, $1
	ld [wDestinationWarpID], a
	ld a, LAVENDER_TOWN
	ld [wLastMap], a
	ld hl, wStatusFlags3
	set BIT_WARP_FROM_CUR_SCRIPT, [hl]
	ld a, SCRIPT_POKEMONTOWER7F_SCRIPT0
	ld [wPokemonTower7FCurScript], a
	ret

PokemonTower7F_TextPointers:
	def_text_pointers
	dw_const PokemonTower7FJessieJamesText, TEXT_POKEMONTOWER7F_JESSIE
	dw_const PokemonTower7FJessieJamesText, TEXT_POKEMONTOWER7F_JAMES
	dw_const PokemonTower7FMrFujiText,      TEXT_POKEMONTOWER7F_MR_FUJI
	dw_const PokemonTower7FText4,           TEXT_POKEMONTOWER7F_TEXT4
	dw_const PokemonTower7FText5,           TEXT_POKEMONTOWER7F_TEXT5
	dw_const PokemonTower7FText6,           TEXT_POKEMONTOWER7F_TEXT6

PokemonTower7FJessieJamesText:
	text_end

PokemonTower7FText4:
	text_far _PokemonTowerJessieJamesText1
	text_asm
	ld c, 10
	call DelayFrames
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, $0
	ld [wEmotionBubbleSpriteIndex], a
	ld a, EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	ld c, 20
	call DelayFrames
	jp TextScriptEnd

PokemonTower7FText5:
	text_far _PokemonTowerJessieJamesText2
	text_end

PokemonTower7FJessieJamesEndBattleText:
	text_far _PokemonTowerJessieJamesText3
	text_end

PokemonTower7FText6:
	text_far _PokemonTowerJessieJamesText4
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
