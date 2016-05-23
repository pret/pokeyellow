GetPredefPointer: ; f67ed (3d:67ed)
; Store the contents of the register
; pairs (hl, de, bc) at wPredefRegisters.
; Then put the bank and address of predef
; wPredefID in [wPredefBank] and hl.

	ld a,h
	ld [wPredefRegisters],a
	ld a,l
	ld [wPredefRegisters + 1],a

	ld hl,wPredefRegisters + 2
	ld a,d
	ld [hli],a
	ld a,e
	ld [hli],a

	ld a,b
	ld [hli],a
	ld [hl],c

	ld hl,PredefPointers
	ld de,0

	ld a,[wPredefID]
	ld e,a
	add a
	add e
	ld e,a
	jr nc,.nocarry
	inc d

.nocarry
	add hl,de
	ld d,h
	ld e,l

	; get bank of predef routine
	ld a,[de]
	ld [wPredefBank],a

	; get pointer
	inc de
	ld a,[de]
	ld l,a
	inc de
	ld a,[de]
	ld h,a

	ret

PredefPointers:: ; f681d (3d:681d)
; these are pointers to ASM routines.
; they appear to be used in overworld map scripts.
	dbw BANK(DrawPlayerHUDAndHPBar), DrawPlayerHUDAndHPBar ; add_predef DrawPlayerHUDAndHPBar
	dbw $3d, $61f9 ; add_predef CopyUncompressedPicToTilemap
	dbw $3d, $61a6 ; add_predef Func_3f073
	dbw $0b, $7d79 ; add_predef ScaleSpriteByTwo
	dbw $3d, $6178 ; add_predef LoadMonBackPic
	dbw $1e, $5c16 ; add_predef CopyDownscaledMonTiles
	dbw $03, $70a7 ; add_predef LoadMissableObjects
	dbw $03, $752b ; add_predef HealParty
	dbw $1e, $4d97 ; add_predef MoveAnimation; 08 play move animation
	dbw $03, $75a4 ; add_predef DivideBCDPredef
	dbw $03, $75a4 ; add_predef DivideBCDPredef2
	dbw $03, $76a3 ; add_predef AddBCDPredef
	dbw $03, $76bc ; add_predef SubBCDPredef
	dbw $03, $75a4 ; add_predef DivideBCDPredef3
	dbw $03, $75a4 ; add_predef DivideBCDPredef4
	dbw $03, $76d6 ; add_predef InitPlayerData
	dbw $03, $74ec ; add_predef FlagActionPredef
	dbw $03, $7053 ; add_predef HideObject
	dbw $03, $7022 ; add_predef IsObjectHidden
	dbw $03, $43de ; add_predef ApplyOutOfBattlePoisonDamage
	dbw $0f, $4ae8 ; add_predef AnyPartyAlive
	dbw $03, $7044 ; add_predef ShowObject
	dbw $03, $7044 ; add_predef ShowObject2
	dbw $03, $6d1b ; add_predef ReplaceTileBlock
	dbw $03, $76d6 ; add_predef InitPlayerData2
	dbw $03, $44f4 ; add_predef LoadTilesetHeader
	dbw $0e, $700c ; add_predef LearnMoveFromLevelUp
	dbw $01, $6bc8 ; add_predef LearnMove
	dbw $03, $7735 ; add_predef IsItemInBag_
	dbw $03, $3ef9 ; dbw $03,CheckForHiddenObjectOrBookshelfOrCardKeyDoor ; for these two, the ba
	dbw $03, $3e3f ; dbw $03,GiveItem
	dbw $0a, $7d4c ; add_predef InvertBGPal_4Frames
	dbw $03, $774a ; add_predef FindPathToPlayer
	dbw $0a, $7d67 ; add_predef Func_480ff
	dbw $03, $77b9 ; add_predef CalcPositionOfPlayerRelativeToNPC
	dbw $03, $7830 ; add_predef ConvertNPCMovementDirectionsToJoypadMasks
	dbw $0a, $7d8d ; add_predef Func_48125
	dbw $03, $78ad ; add_predef UpdateHPBar
	dbw $03, $786c ; add_predef HPBarLength
	dbw $01, $5b64 ; add_predef Diploma_TextBoxBorder
	dbw $0f, $6e8e ; add_predef DoubleOrHalveSelectedStats
	dbw $10, $4000 ; add_predef ShowPokedexMenu
	dbw $0e, $6dc6 ; add_predef EvolutionAfterBattle
	dbw $1c, $7ae5 ; add_predef SaveSAVtoSRAM0
	dbw $3d, $5ff8 ; add_predef InitOpponent
	dbw $01, $5b13 ; add_predef CableClub_Run
	dbw $03, $6880 ; add_predef DrawBadges
	dbw $10, $53f6 ; add_predef ExternalClockTradeAnim
	dbw $1c, $49d7 ; add_predef BattleTransition
	dbw $1e, $5f7b ; add_predef CopyTileIDsFromList
	dbw $10, $5997 ; add_predef PlayIntro
	dbw $1e, $59c5 ; add_predef Func_79869
	dbw $1c, $4bd0 ; add_predef FlashScreen
	dbw $03, $42d1 ; add_predef GetTileAndCoordsInFrontOfPlayer
	dbw $04, $54cc ; add_predef StatusScreen
	dbw $04, $56fb ; add_predef StatusScreen2
	dbw $10, $53e5 ; add_predef InternalClockTradeAnim
	dbw $15, $685b ; add_predef TrainerEngage
	dbw $10, $509d ; add_predef IndexToPokedex
	dbw $01, $600d ; add_predef DisplayPicCenteredOrUpperRight; 3B display pic?
	dbw $03, $6dd1 ; add_predef UsedCut
	dbw $10, $4312 ; add_predef ShowPokedexData
	dbw $0e, $713f ; add_predef WriteMonMoves
	dbw $1c, $7a67 ; add_predef SaveSAV
	dbw $1c, $61f8 ; add_predef LoadSGB
	dbw $03, $6f93 ; add_predef MarkTownVisitedAndLoadMissableObjects
	dbw $17, $5b93 ; add_predef SetPartyMonTypes
	dbw $04, $62f0 ; add_predef CanLearnTM
	dbw $04, $631d ; add_predef TMToMove
	dbw $1c, $5eb3 ; add_predef Func_71ddf
	dbw $17, $40d4 ; add_predef StarterDex ; 46
	dbw $03, $7161 ; add_predef _AddPartyMon
	dbw $03, $78ad ; add_predef UpdateHPBar2
	dbw $0f, $4eb1 ; add_predef DrawEnemyHUDAndHPBar
	dbw $1c, $4fe4 ; add_predef LoadTownMap_Nest
	dbw $09, $7d20 ; add_predef PrintMonType
	dbw $10, $516f ; add_predef EmotionBubble; 4C player exclamation
	dbw $01, $5b63 ; add_predef EmptyFunc3; return immediately
	dbw $01, $625d ; add_predef AskName
	dbw $06, $66e5 ; add_predef PewterGuys
	dbw $1c, $7b56 ; add_predef SaveSAVtoSRAM2
	dbw $1c, $7a24 ; add_predef LoadSAVCheckSum2
	dbw $1c, $7959 ; add_predef LoadSAV
	dbw $1c, $7b32 ; add_predef SaveSAVtoSRAM1
	dbw $1c, $5b86 ; add_predef DoInGameTradeDialogue ; 54 initiate trade
	dbw $3c, $4f26 ; add_predef HallOfFamePC
	dbw $11, $4169 ; add_predef DisplayDexRating
	dbw $1e, $4615 ; dbw $1E, _LeaveMapAnim ; wrong bank
	dbw $1e, $4567 ; dbw $1E, EnterMapAnim ; wrong bank
	dbw $03, $4309 ; add_predef GetTileTwoStepsInFrontOfPlayer
	dbw $03, $4356 ; add_predef CheckForCollisionWhenPushingBoulder
	dbw $3d, $5b06 ; add_predef PrintStrengthTxt
	dbw $01, $4d55 ; add_predef PickupItem
	dbw $09, $7d4d ; add_predef PrintMoveType
	dbw $03, $72f9 ; add_predef LoadMovePPs
	dbw $04, $5468 ; add_predef DrawHP ; 5F
	dbw $04, $546f ; add_predef DrawHP2
	dbw $07, $4264 ; add_predef Func_1c9c6
	dbw $16, $4ecc ; add_predef OaksAideScript
