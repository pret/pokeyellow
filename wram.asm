
INCLUDE "constants.asm"

flag_array: MACRO
	ds ((\1) + 7) / 8
ENDM

box_struct_length EQU 25 + NUM_MOVES * 2
box_struct: MACRO
\1Species::    db
\1HP::         dw
\1BoxLevel::   db
\1Status::     db
\1Type::
\1Type1::      db
\1Type2::      db
\1CatchRate::  db
\1Moves::      ds NUM_MOVES
\1OTID::       dw
\1Exp::        ds 3
\1HPExp::      dw
\1AttackExp::  dw
\1DefenseExp:: dw
\1SpeedExp::   dw
\1SpecialExp:: dw
\1DVs::        ds 2
\1PP::         ds NUM_MOVES
ENDM

party_struct: MACRO
	box_struct \1
\1Level::      db
\1Stats::
\1MaxHP::      dw
\1Attack::     dw
\1Defense::    dw
\1Speed::      dw
\1Special::    dw
ENDM

battle_struct: MACRO
\1Species::    db
\1HP::         dw
\1BoxLevel::   db
\1Status::     db
\1Type::
\1Type1::      db
\1Type2::      db
\1CatchRate::  db
\1Moves::      ds NUM_MOVES
\1DVs::        ds 2
\1Level::      db
\1MaxHP::      dw
\1Attack::     dw
\1Defense::    dw
\1Speed::      dw
\1Special::    dw
\1PP::         ds NUM_MOVES
ENDM


SECTION "WRAM Bank 0", WRAM0

wUnusedC000:: ; c000
	ds 1

wSoundID:: ; c001
	ds 1

wMuteAudioAndPauseMusic:: ; c002
; bit 7: whether sound has been muted
; all bits: whether the effective is active
; Store 1 to activate effect (any value in the range [1, 127] works).
; All audio is muted and music is paused. Sfx continues playing until it
; ends normally.
; Store 0 to resume music.
	ds 1

wDisableChannelOutputWhenSfxEnds:: ; c003
	ds 1

wStereoPanning:: ; c004
	ds 1

wSavedVolume:: ; c005
	ds 1

wChannelCommandPointers:: ; c006
	ds 16

wChannelReturnAddresses:: ; c016
	ds 16

wChannelSoundIDs:: ; c026
	ds 8

wChannelFlags1:: ; c02e
	ds 8

wChannelFlags2:: ; c036
	ds 8

wChannelDuties:: ; c03e
	ds 8

wChannelDutyCycles:: ; c046
	ds 8

wChannelVibratoDelayCounters:: ; c04e
; reloaded at the beginning of a note. counts down until the vibrato begins.
	ds 8

wChannelVibratoExtents:: ; c056
	ds 8

wChannelVibratoRates:: ; c05e
; high nybble is rate (counter reload value) and low nybble is counter.
; time between applications of vibrato.
	ds 8

wChannelFrequencyLowBytes:: ; c066
	ds 8

wChannelVibratoDelayCounterReloadValues:: ; c06e
; delay of the beginning of the vibrato from the start of the note
	ds 8

wChannelPitchBendLengthModifiers:: ; c076
	ds 8

wChannelPitchBendFrequencySteps:: ; c07e
	ds 8

wChannelPitchBendFrequencyStepsFractionalPart:: ; c086
	ds 8

wChannelPitchBendCurrentFrequencyFractionalPart:: ; c08e
	ds 8

wChannelPitchBendCurrentFrequencyHighBytes:: ; c096
	ds 8

wChannelPitchBendCurrentFrequencyLowBytes:: ; c09e
	ds 8

wChannelPitchBendTargetFrequencyHighBytes:: ; c0a6
	ds 8

wChannelPitchBendTargetFrequencyLowBytes:: ; c0ae
	ds 8

wChannelNoteDelayCounters:: ; c0b6
; Note delays are stored as 16-bit fixed-point numbers where the integer part
; is 8 bits and the fractional part is 8 bits.
	ds 8

wChannelLoopCounters:: ; c0be
	ds 8

wChannelNoteSpeeds:: ; c0c6
	ds 8

wChannelNoteDelayCountersFractionalPart:: ; c0ce
	ds 8

wChannelOctaves:: ; c0d6
	ds 8

wChannelVolumes:: ; c0de
; also includes fade for hardware channels that support it
	ds 8

wMusicWaveInstrument::
	ds 1

wSfxWaveInstrument::
	ds 1

wMusicTempo:: ; c0e8
	ds 2

wSfxTempo:: ; c0ea
	ds 2

wSfxHeaderPointer:: ; c0ec
	ds 2

wNewSoundID:: ; c0ee
	ds 1

wAudioROMBank:: ; c0ef
	ds 1

wAudioSavedROMBank:: ; c0f0
	ds 1

wFrequencyModifier:: ; c0f1
	ds 1

wTempoModifier:: ; c0f2
	ds 1

wc0f3:: ds 1
wc0f4:: ds 1
wc0f5:: ds 11

SECTION "Sprite State Data", WRAM0[$c100]

wSpriteDataStart::

wSpriteStateData1:: ; c100
; data for all sprites on the current map
; holds info for 16 sprites with $10 bytes each
; player sprite is always sprite 0
; C1x0: picture ID (fixed, loaded at map init)
; C1x1: movement status (0: uninitialized, 1: ready, 2: delayed, 3: moving)
; C1x2: sprite image index (changed on update, $ff if off screen, includes facing direction, progress in walking animation and a sprite-specific offset)
; C1x3: Y screen position delta (-1,0 or 1; added to c1x4 on each walking animation update)
; C1x4: Y screen position (in pixels, always 4 pixels above grid which makes sprites appear to be in the center of a tile)
; C1x5: X screen position delta (-1,0 or 1; added to c1x6 on each walking animation update)
; C1x6: X screen position (in pixels, snaps to grid if not currently walking)
; C1x7: intra-animation-frame counter (counting upwards to 4 until c1x8 is incremented)
; C1x8: animation frame counter (increased every 4 updates, hold four states (totalling to 16 walking frames)
; C1x9: facing direction (0: down, 4: up, 8: left, $c: right)
; C1xA
; C1xB
; C1xC
; C1xD
; C1xE
; C1xF
spritestatedata1: MACRO
w\1SpriteStateData1::
w\1PictureID:: db ; 0
w\1MovementStatus:: db ; 1
w\1SpriteImageIdx:: db ; 2
w\1YStepVector:: db ; 3
w\1YPixels:: db ; 4
w\1XStepVector:: db ; 5
w\1XPixels:: db ; 6
w\1IntraAnimFrameCounter:: db ; 7
w\1AnimFrameCounter:: db ; 8
w\1FacingDirection:: db ; 9
	ds 6
w\1SpriteStateData1End::
endm

	spritestatedata1 Player
	spritestatedata1 Sprite01
	spritestatedata1 Sprite02
	spritestatedata1 Sprite03
	spritestatedata1 Sprite04
	spritestatedata1 Sprite05
	spritestatedata1 Sprite06
	spritestatedata1 Sprite07
	spritestatedata1 Sprite08
	spritestatedata1 Sprite09
	spritestatedata1 Sprite10
	spritestatedata1 Sprite11
	spritestatedata1 Sprite12
	spritestatedata1 Sprite13
	spritestatedata1 Sprite14
	spritestatedata1 Pikachu
	; ds $10 * $10


;SECTION "Sprite State Data 2", WRAM0[$c200]

wSpriteStateData2:: ; c200
; more data for all sprites on the current map
; holds info for 16 sprites with $10 bytes each
; player sprite is always sprite 0
; C2x0: walk animation counter (counting from $10 backwards when moving)
; C2x1:
; C2x2: Y displacement (initialized at 8, supposed to keep moving sprites from moving too far, but bugged)
; C2x3: X displacement (initialized at 8, supposed to keep moving sprites from moving too far, but bugged)
; C2x4: Y position (in 2x2 tile grid steps, topmost 2x2 tile has value 4)
; C2x5: X position (in 2x2 tile grid steps, leftmost 2x2 tile has value 4)
; C2x6: movement byte 1 (determines whether a sprite can move, $ff:not moving, $fe:random movements, others unknown)
; C2x7: (?) (set to $80 when in grass, else $0; may be used to draw grass above the sprite)
; C2x8: delay until next movement (counted downwards, status (c1x1) is set to ready if reached 0)
; C2x9
; C2xA
; C2xB
; C2xC
; C2xD
; C2xE: sprite image base offset (in video ram, player always has value 1, used to compute c1x2)
; C2xF
spritestatedata2: MACRO
w\1SpriteStateData2::
w\1WalkAnimationCounter:: db ; 0
	ds 1
w\1YDisplacement:: db ; 2
w\1XDisplacement:: db ; 3
w\1MapY:: db ; 4
w\1MapX:: db ; 5
w\1MovementByte1:: db ; 6
w\1GrassPriority:: db ; 7
w\1MovementDelay:: db ; 8
	ds 5
w\1SpriteImageBaseOffset:: db ; e
	ds 1
w\1SpriteStateData2End::
endm

	spritestatedata2 Player
	spritestatedata2 Sprite01
	spritestatedata2 Sprite02
	spritestatedata2 Sprite03
	spritestatedata2 Sprite04
	spritestatedata2 Sprite05
	spritestatedata2 Sprite06
	spritestatedata2 Sprite07
	spritestatedata2 Sprite08
	spritestatedata2 Sprite09
	spritestatedata2 Sprite10
	spritestatedata2 Sprite11
	spritestatedata2 Sprite12
	spritestatedata2 Sprite13
	spritestatedata2 Sprite14
	spritestatedata2 Pikachu
	; ds $10 * $10

wSpriteDataEnd::


SECTION "OAM Buffer", WRAM0[$c300]

wOAMBuffer:: ; c300
; buffer for OAM data. Copied to OAM by DMA
	ds 4 * 40
wOAMBufferEnd::

wTileMap:: ; c3a0
; buffer for tiles that are visible on screen (20 columns by 18 rows)
	ds SCREEN_HEIGHT * SCREEN_WIDTH

wSerialPartyMonsPatchList:: ; c508
; list of indexes to patch with SERIAL_NO_DATA_BYTE after transfer

wTileMapBackup:: ; c508
; buffer for temporarily saving and restoring current screen's tiles
; (e.g. if menus are drawn on top)
;	ds 20 * 18

wAnimatedObjectsData::
; Used by functions in BANK 3E
; This looks similar to the address structure for Gen 2 OAM animations.

wAnimatedObjectStartTileOffsets::
	ds 10 * 2
wAnimatedObjectDataStructs:: ; c51c
animated_object: macro
\1::
\1Index::          db ; 0
\1FramesetID::     db ; 1
\1AnimSeqID::      db ; 2
\1TileID::         db ; 3
\1XCoord::         db ; 4
\1YCoord::         db ; 5
\1XOffset::        db ; 6
\1YOffset::        db ; 7
\1Duration::       db ; 8
\1DurationOffset:: db ; 9
\1FrameIndex::     db ; a
	ds 5
\1End::
	endm

	animated_object AnimatedObject0
	animated_object AnimatedObject1
	animated_object AnimatedObject2
	animated_object AnimatedObject3
	animated_object AnimatedObject4
	animated_object AnimatedObject5
	animated_object AnimatedObject6
	animated_object AnimatedObject7
	animated_object AnimatedObject8
	animated_object AnimatedObject9

wNumLoadedAnimatedObjects:: ; c5bc
	ds 1
wCurrentAnimatedObjectOAMBufferOffset:: ; c5bd
	ds 3
wAnimatedObjectSpawnStateDataPointer:: ; c5c0
	dw
wAnimatedObjectFramesDataPointer:: ; c5c2
	dw
wAnimatedObjectJumptablePointer:: ; c5c4
	dw
wAnimatedObjectOAMDataPointer:: ; c5c6
	dw
wCurAnimatedObjectOAMAttributes:: ; c5c8
	ds 1
wCurrentAnimatedObjectVTileOffset:: ; c5c9
	ds 1
wCurrentAnimatedObjectXCoord:: ; c5ca
	ds 1
wCurrentAnimatedObjectYCoord:: ; c5cb
	ds 1
wCurrentAnimatedObjectXOffset:: ; c5cc
	ds 1
wCurrentAnimatedObjectYOffset:: ; c5cd
	ds 1
wAnimatedObjectGlobalYOffset:: ; c5ce
	ds 1
wAnimatedObjectGlobalXOffset:: ; c5cf
	ds 1
wAnimatedObjectsDataEnd::

wSerialEnemyMonsPatchList:: ; c5d0
; list of indexes to patch with SERIAL_NO_DATA_BYTE after transfer

; Surfing Minigame
wSurfingMinigameData:: ; c5d0
	ds 1
wSurfingMinigameRoutineNumber:: ; c5d1
	ds 1
wc5d2:: ; c5d2
	ds 1
wSurfingMinigameWaveFunctionNumber:: ; c5d3
	ds 2
wc5d5:: ; c5d5
	ds 1
wSurfingMinigamePikachuHP:: ; c5d6
	ds 2 ; little-endian BCD
wc5d8:: ; c5d8 unused?
	ds 1
wSurfingMinigameRadnessMeter:: ; c5d9
; number of consecutive tricks
	ds 1
wSurfingMinigameRadnessScore:: ; c5da
	ds 2 ; little-endian BCD
wSurfingMinigameTotalScore:: ; c5dc
	ds 2 ; little-endian BCD
wc5de:: ; c5de
	ds 1
wc5df:: ; c5df
	ds 1
wc5e0:: ; c5e0
	ds 1
wc5e1:: ; c5e1
	ds 1
wc5e2:: ; c5e2
	ds 1
wc5e3:: ; c5e3
	ds 2 ; little-endian
wc5e5:: ; c5e5
	ds 3 ; big-endian
wSurfingMinigameWaveHeightBuffer:: ; c5e8
	ds 2
wSurfingMinigamePikachuObjectHeight:: ; c5ea
	ds 1
wc5eb:: ; c5eb
	ds 1
wc5ec:: ; c5ec
	ds 1
wc5ed:: ; c5ed
	ds 1
wc5ee:: ; c5ee
	ds 1
wSurfingMinigameBGMapReadBuffer:: ; c5ef
	ds 16

	ds 24
wSurfingMinigameSCX:: ; c617
	ds 3
wSurfingMinigameWaveHeight:: ; c61a
	ds SCREEN_WIDTH
wSurfingMinigameXOffset:: ; c62e
	ds 1
wSurfingMinigameTrickFlags:: ; c62f
	ds 1
wc630:: ; c630
	ds 1
wc631:: ; c631
	ds 1
wSurfingMinigameRoutineDelay:: ; c632
	ds 1
wSurfingMinigameIntroAnimationFinished:: ; c633
	ds 1

wYellowIntroCurrentScene:: ; c634
wc634:: ; c634
	ds 1
wYellowIntroSceneTimer:: ; c635
wc635:: ; c635
	ds 1
wYellowIntroAnimatedObjectStructPointer:: ; c636
	ds 1
wSurfingMinigameDataEnd:: ; c637

	ds 177

wTempPic:: ; c6e8
wPrinterData:: ; c6e8
wOverworldMap:: ; c6e8
	; ds 1300
wPrinterSendState:: ; c6e8
	ds 1
wPrinterRowIndex:: ; c6e9
	ds 1

; Printer data header
wPrinterDataHeader:: ; c6ea
wc6ea:: ; c6ea
	ds 1
wc6eb:: ; c6eb
	ds 1
wc6ec:: ; c6ec
	ds 1
wc6ed:: ; c6ed
	ds 1
wPrinterChecksum:: ; c6ee
	dw

wPrinterSerialReceived:: ; c6f0
	ds 1
wPrinterStatusReceived:: ; c6f1
; bit 7: set if error 1 (battery low)
; bit 6: set if error 4 (too hot or cold)
; bit 5: set if error 3 (paper jammed or empty)
; if this and the previous byte are both $ff: error 2 (connection error)
	ds 1

wc6f2:: ; c6f2
	ds 1
wc6f3:: ; c6f3
	ds 13
wLYOverrides:: ; c700
	ds $100
wLYOverridesEnd::
wLYOverridesBuffer:: ; c800
	ds $100
wLYOverridesBufferEnd:: ; c900
	ds wPrinterSerialReceived - @

wPrinterSendDataSource1:: ; c6f0
; two 20-tile buffers
	ds $140
wPrinterSendDataSource2::
	ds $140
wPrinterSendDataSource1End:: ; c970

wPrinterHandshake:: ; c970
	ds 1
wPrinterStatusFlags:: ; c971
	ds 1
wHandshakeFrameDelay:: ; c972
	ds 1
wPrinterSerialFrameDelay:: ; c973
	ds 1
wPrinterSendByteOffset:: ; c974
	dw
wPrinterDataSize:: ; c976
	dw
wPrinterTileBuffer:: ; c978
	ds SCREEN_HEIGHT * SCREEN_WIDTH
wPrinterStatusIndicator:: ; cae0
	ds 2
wcae2:: ; cae2
	ds 1
wPrinterSettingsTempCopy:: ; cae3
	ds 17
wPrinterQueueLength:: ; caf4
	ds 1
wPrinterDataEnd:: ; caf5

wPrinterPokedexEntryTextPointer:: ; caf5
	dw
	ds 2
wPrinterPokedexMonIsOwned:: ; caf9
	ds 227

wcbdc:: ; cbdc
	ds 14

wcbea:: ; cbea
	ds 2

wcbec:: ; cbec
	ds 16

wRedrawRowOrColumnSrcTiles:: ; cbfc
; the tiles of the row or column to be redrawn by RedrawRowOrColumn
	ds SCREEN_WIDTH * 2

; coordinates of the position of the cursor for the top menu item (id 0)
wTopMenuItemY:: ; cc24
	ds 1
wTopMenuItemX:: ; cc25
	ds 1

wCurrentMenuItem:: ; cc26
; the id of the currently selected menu item
; the top item has id 0, the one below that has id 1, etc.
; note that the "top item" means the top item currently visible on the screen
; add this value to [wListScrollOffset] to get the item's position within the list
	ds 1

wTileBehindCursor:: ; cc27
; the tile that was behind the menu cursor's current location
	ds 1

wMaxMenuItem:: ; cc28
; id of the bottom menu item
	ds 1

wMenuWatchedKeys:: ; cc29
; bit mask of keys that the menu will respond to
	ds 1

wLastMenuItem:: ; cc2a
; id of previously selected menu item
	ds 1

wPartyAndBillsPCSavedMenuItem:: ; cc2b
; It is mainly used by the party menu to remember the cursor position while the
; menu isn't active.
; It is also used to remember the cursor position of mon lists (for the
; withdraw/deposit/release actions) in Bill's PC so that it doesn't get lost
; when you choose a mon from the list and a sub-menu is shown. It's reset when
; you return to the main Bill's PC menu.
	ds 1

wBagSavedMenuItem:: ; cc2c
; It is used by the bag list to remember the cursor position while the menu
; isn't active.
	ds 1

wBattleAndStartSavedMenuItem:: ; cc2d
; It is used by the start menu to remember the cursor position while the menu
; isn't active.
; The battle menu uses it so that the cursor position doesn't get lost when
; a sub-menu is shown. It's reset at the start of each battle.
	ds 1

wPlayerMoveListIndex:: ; cc2e
	ds 1

wPlayerMonNumber:: ; cc2f
; index in party of currently battling mon
	ds 1

wMenuCursorLocation:: ; cc30
; the address of the menu cursor's current location within wTileMap
	ds 2

	ds 2

wMenuJoypadPollCount:: ; cc34
; how many times should HandleMenuInput poll the joypad state before it returns?
	ds 1

wMenuItemToSwap:: ; cc35
; id of menu item selected for swapping (counts from 1) (0 means that no menu item has been selected for swapping)
	ds 1

wListScrollOffset:: ; cc36
; offset of the current top menu item from the beginning of the list
; keeps track of what section of the list is on screen
	ds 1

wMenuWatchMovingOutOfBounds:: ; cc37
; If non-zero, then when wrapping is disabled and the player tries to go past
; the top or bottom of the menu, return from HandleMenuInput. This is useful for
; menus that have too many items to display at once on the screen because it
; allows the caller to scroll the entire menu up or down when this happens.
	ds 1

wTradeCenterPointerTableIndex:: ; cc38
	ds 1

	ds 1

wTextDestinationTileAddrBuffer:: dw ; cc3a

wDoNotWaitForButtonPressAfterDisplayingText:: ; cc3c
; if non-zero, skip waiting for a button press after displaying text in DisplayTextID
	ds 1

wSerialSyncAndExchangeNybbleReceiveData:: ; cc3d
; the final received nybble is stored here by Serial_SyncAndExchangeNybble

wSerialExchangeNybbleTempReceiveData:: ; cc3d
; temporary nybble used by Serial_ExchangeNybble

wLinkMenuSelectionReceiveBuffer:: ; cc3d
; two byte buffer
; the received menu selection is stored twice
	ds 1

wSerialExchangeNybbleReceiveData:: ; cc3e
; the final received nybble is stored here by Serial_ExchangeNybble
	ds 1

	ds 3

wSerialExchangeNybbleSendData:: ; cc42
; this nybble is sent when using Serial_SyncAndExchangeNybble or Serial_ExchangeNybble

wLinkMenuSelectionSendBuffer:: ; cc42
; two byte buffer
; the menu selection byte is stored twice before sending

	ds 5

wLinkTimeoutCounter:: ; cc47
; 1 byte

wUnknownSerialCounter:: ; cc47
; 2 bytes

wEnteringCableClub:: ; cc47
	ds 2

wWhichTradeMonSelectionMenu:: ; cc49
; $00 = player mons
; $01 = enemy mons

wMonDataLocation:: ; cc49
; 0 = player's party
; 1 = enemy party
; 2 = current box
; 3 = daycare
; 4 = in-battle mon
;
; AddPartyMon uses it slightly differently.
; If the lower nybble is 0, the mon is added to the player's party, else the enemy's.
; If the entire value is 0, then the player is allowed to name the mon.
	ds 1

wMenuWrappingEnabled:: ; cc4a
; set to 1 if you can go from the bottom to the top or top to bottom of a menu
; set to 0 if you can't go past the top or bottom of the menu
	ds 1

wCheckFor180DegreeTurn:: ; cc4b
; whether to check for 180-degree turn (0 = don't, 1 = do)
	ds 1

	ds 1

wMissableObjectIndex:: ; cc4d
	ds 1

wPredefID:: ; cc4e
	ds 1
wPredefRegisters:: ; cc4f
	ds 6

wTrainerHeaderFlagBit:: ; cc55
	ds 1

	ds 1

wNPCMovementScriptPointerTableNum:: ; cc57
; which NPC movement script pointer is being used
; 0 if an NPC movement script is not running
	ds 1

wNPCMovementScriptBank:: ; cc58
; ROM bank of current NPC movement script
	ds 1

	ds 2

wUnusedCC5B:: ; cc5b

wVermilionDockTileMapBuffer:: ; cc5b
; 180 bytes

wOaksAideRewardItemName:: ; cc5b

wDexRatingNumMonsSeen:: ; cc5b

wFilteredBagItems:: ; cc5b
; List of bag items that has been filtered to a certain type of items,
; such as drinks or fossils.

wElevatorWarpMaps:: ; cc5b

wMonPartySpritesSavedOAM:: ; cc5b
; Saved copy of OAM for the first frame of the animation to make it easy to
; flip back from the second frame.
; $60 bytes

wTrainerCardBlkPacket:: ; cc5b
; $40 bytes

wSlotMachineSevenAndBarModeChance:: ; cc5b
; If a random number greater than this value is generated, then the player is
; allowed to have three 7 symbols or bar symbols line up.
; So, this value is actually the chance of NOT entering that mode.
; If the slot is lucky, it equals 250, giving a 5/256 (~2%) chance.
; Otherwise, it equals 253, giving a 2/256 (~0.8%) chance.

wHallOfFame:: ; cc5b
wBoostExpByExpAll:: ; cc5b
wAnimationType:: ; cc5b
; values between 0-6. Shake screen horizontally, shake screen vertically, blink Pokemon...

wNPCMovementDirections:: ; cc5b

wPikaPicUsedGFXCount:: ; cc5b
	ds 1

wPikaPicUsedGFX:: ; cc5c
wDexRatingNumMonsOwned:: ; cc5c
	ds 1


wDexRatingText:: ; cc5d
wTrainerCardBadgeAttributes:: ; cc5d
	ds 1

wSlotMachineSavedROMBank:: ; cc5e
; ROM back to return to when the player is done with the slot machine
	ds 1

	ds 13
wPikaPicUsedGFXEnd:: ; cc6c
	ds 13

wAnimPalette:: ; cc79
	ds 1

	ds 29

wNPCMovementDirections2:: ; cc97

wPikaPicAnimObjectDataBufferSize:: ; cc97

wSwitchPartyMonTempBuffer:: ; cc97
; temporary buffer when swapping party mon data
	ds 1

wPikaPicAnimObjectDataBuffer:: ; cc98
; 4 structs each of length 8
; 	0: buffer index
; 	1: script index
;   2: frame index
; 	3: frame timer
; 	4: vtile offset
; 	5: x offset
; 	6: y offset
; 	7: unused

	ds 9

wNumStepsToTake:: ; cca1
; used in Pallet Town scripted movement
	ds 23
wPikaPicAnimObjectDataBufferEnd:: ;ccb8
	ds 26

wRLEByteCount:: ; ccd2
	ds 1

wAddedToParty:: ; ccd3
; 0 = not added
; 1 = added

wSimulatedJoypadStatesEnd:: ; ccd3
; this is the end of the joypad states
; the list starts above this address and extends downwards in memory until here
; overloaded with below labels

wParentMenuItem:: ; ccd3

wCanEvolveFlags:: ; ccd3
; 1 flag for each party member indicating whether it can evolve
; The purpose of these flags is to track which mons levelled up during the
; current battle at the end of the battle when evolution occurs.
; Other methods of evolution simply set it by calling TryEvolvingMon.
	ds 1

wForceEvolution:: ; ccd4
	ds 1

; if [ccd5] != 1, the second AI layer is not applied
wAILayer2Encouragement:: ; ccd5
	ds 1
	ds 1

; current HP of player and enemy substitutes
wPlayerSubstituteHP:: ; ccd7
	ds 1
wEnemySubstituteHP:: ; ccd8
	ds 1

wTestBattlePlayerSelectedMove:: ; ccd9
; The player's selected move during a test battle.
; InitBattleVariables sets it to the move Pound.
	ds 1

	ds 1

wMoveMenuType:: ; ccdb
; 0=regular, 1=mimic, 2=above message box (relearn, heal pp..)
	ds 1

wPlayerSelectedMove:: ; ccdc
	ds 1
wEnemySelectedMove:: ; ccdd
	ds 1

wLinkBattleRandomNumberListIndex:: ; ccde
	ds 1

wAICount:: ; ccdf
; number of times remaining that AI action can occur
	ds 1

	ds 2

wEnemyMoveListIndex:: ; cce2
	ds 1

wLastSwitchInEnemyMonHP:: ; cce3
; The enemy mon's HP when it was switched in or when the current player mon
; was switched in, which was more recent.
; It's used to determine the message to print when switching out the player mon.
	ds 2

wTotalPayDayMoney:: ; cce5
; total amount of money made using Pay Day during the current battle
	ds 3

wSafariEscapeFactor:: ; cce8
	ds 1
wSafariBaitFactor:: ; cce9
	ds 1;

	ds 1

wTransformedEnemyMonOriginalDVs:: ; cceb
	ds 2

wMonIsDisobedient:: ds 1 ; cced

wPlayerDisabledMoveNumber:: ds 1 ; ccee
wEnemyDisabledMoveNumber:: ds 1 ; ccef

wInHandlePlayerMonFainted:: ; ccf0
; When running in the scope of HandlePlayerMonFainted, it equals 1.
; When running in the scope of HandleEnemyMonFainted, it equals 0.
	ds 1

wPlayerUsedMove:: ds 1 ; ccf1
wEnemyUsedMove:: ds 1 ; ccf2

wEnemyMonMinimized:: ds 1 ; ccf3

wMoveDidntMiss:: ds 1 ; ccf4

wPartyFoughtCurrentEnemyFlags:: ; ccf5
; flags that indicate which party members have fought the current enemy mon
	flag_array 6

wLowHealthAlarmDisabled:: ; ccf6
; Whether the low health alarm has been disabled due to the player winning the
; battle.
	ds 1

wPlayerMonMinimized:: ; ccf7
	ds 1

	ds 13

wLuckySlotHiddenObjectIndex:: ; cd05

wEnemyNumHits:: ; cd05
; number of hits by enemy in attacks like Double Slap, etc.

wEnemyBideAccumulatedDamage:: ; cd05
; the amount of damage accumulated by the enemy while biding (2 bytes)

	ds 10

wInGameTradeGiveMonSpecies:: ; cd0f

wPlayerMonUnmodifiedLevel:: ; cd0f
	ds 1

wInGameTradeTextPointerTablePointer:: ; cd10

wPlayerMonUnmodifiedMaxHP:: ; cd10
	ds 2

wInGameTradeTextPointerTableIndex:: ; cd12

wPlayerMonUnmodifiedAttack:: ; cd12
	ds 1
wInGameTradeGiveMonName:: ; cd13
	ds 1
wPlayerMonUnmodifiedDefense:: ; cd14
	ds 2
wPlayerMonUnmodifiedSpeed:: ; cd16
	ds 2
wPlayerMonUnmodifiedSpecial:: ; cd18
	ds 2

; stat modifiers for the player's current pokemon
; value can range from 1 - 13 ($1 to $D)
; 7 is normal

wPlayerMonStatMods::
wPlayerMonAttackMod:: ; cd1a
	ds 1
wPlayerMonDefenseMod:: ; cd1b
	ds 1
wPlayerMonSpeedMod:: ; cd1c
	ds 1
wPlayerMonSpecialMod:: ; cd1d
	ds 1

wInGameTradeReceiveMonName:: ; cd1e

wPlayerMonAccuracyMod:: ; cd1e
	ds 1
wPlayerMonEvasionMod:: ; cd1f
	ds 1

	ds 3

wEnemyMonUnmodifiedLevel:: ; cd23
	ds 1
wEnemyMonUnmodifiedMaxHP:: ; cd24
	ds 2
wEnemyMonUnmodifiedAttack:: ; cd26
	ds 2
wEnemyMonUnmodifiedDefense:: ; cd28
	ds 1

wInGameTradeMonNick:: ; cd29
	ds 1

wEnemyMonUnmodifiedSpeed:: ; cd2a
	ds 2
wEnemyMonUnmodifiedSpecial:: ; cd2c
	ds 1

wEngagedTrainerClass:: ; cd2d
	ds 1
wEngagedTrainerSet:: ; cd2e
;	ds 1

; stat modifiers for the enemy's current pokemon
; value can range from 1 - 13 ($1 to $D)
; 7 is normal

wEnemyMonStatMods::
wEnemyMonAttackMod:: ; cd2e
	ds 1
wEnemyMonDefenseMod:: ; cd2f
	ds 1
wEnemyMonSpeedMod:: ; cd30
	ds 1
wEnemyMonSpecialMod:: ; cd31
	ds 1
wEnemyMonAccuracyMod:: ; cd32
	ds 1
wEnemyMonEvasionMod:: ; cd33
	ds 1

wInGameTradeReceiveMonSpecies:: ; cd34
	ds 1

	ds 2

wNPCMovementDirections2Index:: ; cd37

wUnusedCD37:: ; cd37

wFilteredBagItemsCount:: ; cd37
; number of items in wFilteredBagItems list
	ds 1

wSimulatedJoypadStatesIndex:: ; cd38
; the next simulated joypad state is at wSimulatedJoypadStatesEnd plus this value minus 1
; 0 if the joypad state is not being simulated
	ds 1

wWastedByteCD39:: ; cd39
; written to but nothing ever reads it
	ds 1

wWastedByteCD3A:: ; cd3a
; written to but nothing ever reads it
	ds 1

wOverrideSimulatedJoypadStatesMask:: ; cd3b
; mask indicating which real button presses can override simulated ones
; XXX is it ever not 0?
	ds 1

	ds 1

wFallingObjectsMovementData:: ; cd3d
; up to 20 bytes (one byte for each falling object)

wSavedY:: ; cd3d

wTempSCX:: ; cd3d

wBattleTransitionCircleScreenQuadrantY:: ; cd3d
; 0 = upper half (Y < 9)
; 1 = lower half (Y >= 9)

wBattleTransitionCopyTilesOffset:: ; cd3d
; 2 bytes
; after 1 row/column has been copied, the offset to the next one to copy from

wInwardSpiralUpdateScreenCounter:: ; cd3d
; counts down from 7 so that every time 7 more tiles of the spiral have been
; placed, the tile map buffer is copied to VRAM so that progress is visible

wHoFTeamIndex:: ; cd3d

wSSAnneSmokeDriftAmount:: ; cd3d
; multiplied by 16 to get the number of times to go right by 2 pixels

wRivalStarterTemp:: ; cd3d

wBoxMonCounts:: ; cd3d
; 12 bytes
; array of the number of mons in each box

wDexMaxSeenMon:: ; cd3d

wPPRestoreItem:: ; cd3d

wWereAnyMonsAsleep:: ; cd3d

wCanPlaySlots:: ; cd3d

wNumShakes:: ; cd3d

wDayCareStartLevel:: ; cd3d
; the level of the mon at the time it entered day care

wWhichBadge:: ; cd3d

wPriceTemp:: ; cd3d
; 3-byte BCD number

wTitleScreenScene:: ; cd3d

wPlayerCharacterOAMTile:: ; cd3d

wMoveDownSmallStarsOAMCount:: ; cd3d
; the number of small stars OAM entries to move down

wChargeMoveNum:: ; cd3d

wCoordIndex:: ; cd3d

wOptionsTextSpeedCursorX:: ; cd3d

wOptionsCursorLocation:: ; cd3d

wTrainerInfoTextBoxWidthPlus1:: ; cd3d

wSwappedMenuItem:: ; cd3d

wHoFMonSpecies:: ; cd3d

wFieldMoves:: ; cd3d
; 4 bytes
; the current mon's field moves

wBadgeNumberTile:: ; cd3d
; tile ID of the badge number being drawn

wRodResponse:: ; cd3d
; 0 = no bite
; 1 = bite
; 2 = no fish on map

wWhichTownMapLocation:: ; cd3d

wStoppingWhichSlotMachineWheel:: ; cd3d
; which wheel the player is trying to stop
; 0 = none, 1 = wheel 1, 2 = wheel 2, 3 or greater = wheel 3

wTradedPlayerMonSpecies:: ; cd3d

wTradingWhichPlayerMon:: ; cd3d

wChangeBoxSavedMapTextPointer:: ; cd3d

wFlyAnimUsingCoordList:: ; cd3d

wPlayerSpinInPlaceAnimFrameDelay:: ; cd3d

wPlayerSpinWhileMovingUpOrDownAnimDeltaY:: ; cd3d

wBoxNumString:: ; cd3d

wHiddenObjectFunctionArgument:: ; cd3d

wWhichTrade:: ; cd3d
; which entry from TradeMons to select

wTrainerSpriteOffset:: ; cd3d

wUnusedCD3D:: ; cd3d
	ds 1

wTitleScreenTimer:: ; cd3e

wHUDPokeballGfxOffsetX:: ; cd3e
; difference in X between the next ball and the current one

wBattleTransitionCircleScreenQuadrantX:: ; cd3e
; 0 = left half (X < 10)
; 1 = right half (X >= 10)

wSSAnneSmokeX:: ; cd3e

wRivalStarterBallSpriteIndex:: ; cd3e

wDayCareNumLevelsGrown:: ; cd3e

wOptionsBattleAnimCursorX:: ; cd3e

wTrainerInfoTextBoxWidth:: ; cd3e

wHoFPartyMonIndex:: ; cd3e

wNumCreditsMonsDisplayed:: ; cd3e
; the number of credits mons that have been displayed so far

wBadgeNameTile:: ; cd3e
; first tile ID of the name being drawn

wFlyLocationsList:: ; cd3e
; 11 bytes plus $ff sentinel values at each end

wSlotMachineWheel1Offset:: ; cd3e

wTradedEnemyMonSpecies:: ; cd3e

wTradingWhichEnemyMon:: ; cd3e

wFlyAnimCounter:: ; cd3e

wPlayerSpinInPlaceAnimFrameDelayDelta:: ; cd3e

wPlayerSpinWhileMovingUpOrDownAnimMaxY:: ; cd3e

wHiddenObjectFunctionRomBank:: ; cd3e

wTrainerEngageDistance:: ; cd3e

wJigglypuffFacingDirections2:: ; cd3e
	ds 1

wHUDGraphicsTiles:: ; cd3f
; 3 bytes

wDayCareTotalCost:: ; cd3f
; 2-byte BCD number

wJigglypuffFacingDirections:: ; cd3f

wOptionsBattleStyleCursorX:: ; cd3f

wTrainerInfoTextBoxNextRowOffset:: ; cd3f

wHoFMonLevel:: ; cd3f

wBadgeOrFaceTiles:: ; cd3f
; 8 bytes
; a list of the first tile IDs of each badge or face (depending on whether the
; badge is owned) to be drawn on the trainer screen

wSlotMachineWheel2Offset:: ; cd3f

wNameOfPlayerMonToBeTraded:: ; cd3f

wFlyAnimBirdSpriteImageIndex:: ; cd3f

wPlayerSpinInPlaceAnimFrameDelayEndValue:: ; cd3f

wPlayerSpinWhileMovingUpOrDownAnimFrameDelay:: ; cd3f

wHiddenObjectIndex:: ; cd3f

wTrainerFacingDirection:: ; cd3f

	ds 1

wHoFMonOrPlayer:: ; cd40
; show mon or show player?
; 0 = mon
; 1 = player

wSlotMachineWheel3Offset:: ; cd40

wPlayerSpinInPlaceAnimSoundID:: ; cd40

wHiddenObjectY:: ; cd40

wTrainerScreenY:: ; cd40

wUnusedCD40:: ; cd40
	ds 1

wDayCarePerLevelCost:: ; cd41
; 2-byte BCD number (always set to $0100)

wHoFTeamIndex2:: ; cd41

wHiddenItemOrCoinsIndex:: ; cd41

wTradedPlayerMonOT:: ; cd41

wHiddenObjectX:: ; cd41

wSlotMachineWinningSymbol:: ; cd41
; the OAM tile number of the upper left corner of the winning symbol minus 2

wNumFieldMoves:: ; cd41

wSlotMachineWheel1BottomTile:: ; cd41

wTrainerScreenX:: ; cd41
	ds 1
; a lot of the uses for these values use more than the said address

wHoFTeamNo:: ; cd42

wSlotMachineWheel1MiddleTile:: ; cd42

wFieldMovesLeftmostXCoord:: ; cd42

wcd42:: ; cd42
	ds 1

wLastFieldMoveID:: ; cd43
; unused

wSlotMachineWheel1TopTile:: ; cd43
	ds 1

wSlotMachineWheel2BottomTile:: ; cd44
	ds 1

wSlotMachineWheel2MiddleTile:: ; cd45
	ds 1

wTempCoins1:: ; cd46
; 2 bytes
; temporary variable used to add payout amount to the player's coins

wSlotMachineWheel2TopTile:: ; cd46
	ds 1

wBattleTransitionSpiralDirection:: ; cd47
; 0 = outward, 1 = inward

wSlotMachineWheel3BottomTile:: ; cd47
	ds 1

wSlotMachineWheel3MiddleTile:: ; cd48

wFacingDirectionList:: ; cd48
; 4 bytes (also, the byte before the start of the list (cd47) is used a temp
;          variable when the list is rotated)
; used when spinning the player's sprite
	ds 1

wSlotMachineWheel3TopTile:: ; cd49

wTempObtainedBadgesBooleans::
; 8 bytes
; temporary list created when displaying the badges on the trainer screen
; one byte for each badge; 0 = not obtained, 1 = obtained
	ds 1

wTempCoins2:: ; cd4a
; 2 bytes
; temporary variable used to subtract the bet amount from the player's coins

wPayoutCoins:: ; cd4a
; 2 bytes
	ds 2

wTradedPlayerMonOTID:: ; cd4c

wSlotMachineFlags:: ; cd4c
; These flags are set randomly and control when the wheels stop.
; bit 6: allow the player to win in general
; bit 7: allow the player to win with 7 or bar (plus the effect of bit 6)
	ds 1

wSlotMachineWheel1SlipCounter:: ; cd4d
; wheel 1 can "slip" while this is non-zero

wCutTile:: ; cd4d
; $3d = tree tile
; $52 = grass tile
	ds 1

wSlotMachineWheel2SlipCounter:: ; cd4e
; wheel 2 can "slip" while this is non-zero

wTradedEnemyMonOT:: ; cd4e
	ds 1

wSavedPlayerScreenY:: ; cd4f

wSlotMachineRerollCounter:: ; cd4f
; The remaining number of times wheel 3 will roll down a symbol until a match is
; found, when winning is enabled. It's initialized to 4 each bet.

wEmotionBubbleSpriteIndex:: ; cd4f
; the index of the sprite the emotion bubble is to be displayed above
	ds 1

wWhichEmotionBubble:: ; cd50

wSlotMachineBet:: ; cd50
; how many coins the player bet on the slot machine (1 to 3)

wSavedPlayerFacingDirection:: ; cd50

wWhichAnimationOffsets:: ; cd50
; 0 = cut animation, 1 = boulder dust animation
	ds 9

wTradedEnemyMonOTID:: ; cd59
	ds 2

wStandingOnWarpPadOrHole:: ; cd5b
; 0 = neither
; 1 = warp pad
; 2 = hole

wOAMBaseTile:: ; cd5b

wGymTrashCanIndex:: ; cd5b
	ds 1

wSymmetricSpriteOAMAttributes:: ; cd5c
	ds 1

wMonPartySpriteSpecies:: ; cd5d
	ds 1

wLeftGBMonSpecies:: ; cd5e
; in the trade animation, the mon that leaves the left gameboy
	ds 1

wRightGBMonSpecies:: ; cd5f
; in the trade animation, the mon that leaves the right gameboy
	ds 1

wFlags_0xcd60:: ; cd60
; bit 0: is player engaged by trainer (to avoid being engaged by multiple trainers simultaneously)
; bit 1: boulder dust animation (from using Strength) pending
; bit 3: using generic PC
; bit 5: don't play sound when A or B is pressed in menu
; bit 6: tried pushing against boulder once (you need to push twice before it will move)
	ds 1

	ds 9

wActionResultOrTookBattleTurn:: ; cd6a
; This has overlapping related uses.
; When the player tries to use an item or use certain field moves, 0 is stored
; when the attempt fails and 1 is stored when the attempt succeeds.
; In addition, some items store 2 for certain types of failures, but this
; cannot happen in battle.
; In battle, a non-zero value indicates the player has taken their turn using
; something other than a move (e.g. using an item or switching pokemon).
; So, when an item is successfully used in battle, this value becomes non-zero
; and the player is not allowed to make a move and the two uses are compatible.
	ds 1

wJoyIgnore:: ; cd6b
; Set buttons are ignored.
	ds 1

wDownscaledMonSize:: ; cd6c
; size of downscaled mon pic used in pokeball entering/exiting animation
; $00 = 5×5
; $01 = 3×3

wNumMovesMinusOne:: ; cd6c
; FormatMovesString stores the number of moves minus one here
	ds 1

wcd6d:: ds 4 ; buffer for various data

wStatusScreenCurrentPP:: ; cd71
; temp variable used to print a move's current PP on the status screen
	ds 1

	ds 6

wNormalMaxPPList:: ; cd78
; list of normal max PP (without PP up) values
	ds 9

wSerialOtherGameboyRandomNumberListBlock:: ; cd81
; buffer for transferring the random number list generated by the other gameboy

wTileMapBackup2:: ; cd81
; second buffer for temporarily saving and restoring current screen's tiles (e.g. if menus are drawn on top)
	ds 20 * 18

wNamingScreenNameLength:: ; cee9

wEvoOldSpecies:: ; cee9

wBuffer:: ; cee9
; Temporary storage area of 30 bytes.

wTownMapCoords:: ; cee9
; lower nybble is x, upper nybble is y

wLearningMovesFromDayCare:: ; cee9
; whether WriteMonMoves is being used to make a mon learn moves from day care
; non-zero if so

wChangeMonPicEnemyTurnSpecies:: ; cee9

wHPBarMaxHP:: ; cee9
	ds 1

wNamingScreenSubmitName:: ; ceea
; non-zero when the player has chosen to submit the name

wChangeMonPicPlayerTurnSpecies:: ; ceea

wEvoNewSpecies:: ; ceea
	ds 1

wAlphabetCase:: ; ceeb
; 0 = upper case
; 1 = lower case

wEvoMonTileOffset:: ; ceeb

wHPBarOldHP:: ; ceeb
	ds 1

wEvoCancelled:: ; ceec
	ds 1

wNamingScreenLetter:: ; ceed

wHPBarNewHP:: ; ceed
	ds 2
wHPBarDelta:: ; ceef
	ds 1

wHPBarTempHP:: ; cef0
	ds 2

	ds 11

wHPBarHPDifference:: ; cefd
	ds 1
	ds 7

wAIItem:: ; cf05
; the item that the AI used
	ds 1

wUsedItemOnWhichPokemon:: ; cf06
	ds 1

wAnimSoundID:: ; cf07
; sound ID during battle animations
	ds 1

wBankswitchHomeSavedROMBank:: ; cf08
; used as a storage value for the bank to return to after a BankswitchHome (bankswitch in homebank)
	ds 1

wBankswitchHomeTemp:: ; cf09
; used as a temp storage value for the bank to switch to
	ds 1

wBoughtOrSoldItemInMart:: ; cf0a
; 0 = nothing bought or sold in pokemart
; 1 = bought or sold something in pokemart
; this value is not used for anything
	ds 1

wBattleResult:: ; cf0b
; $00 - win
; $01 - lose
; $02 - draw
	ds 1

wAutoTextBoxDrawingControl:: ; cf0c
; bit 0: if set, DisplayTextID automatically draws a text box
	ds 1

wcf0d:: ds 1 ; used with some overworld scripts (not exactly sure what it's used for)

wTilePlayerStandingOn:: ; cf0e
; used in CheckForTilePairCollisions2 to store the tile the player is on
	ds 1

wNPCNumScriptedSteps:: ds 1 ; cf0f

wNPCMovementScriptFunctionNum:: ; cf10
; which script function within the pointer table indicated by
; wNPCMovementScriptPointerTableNum
	ds 1

wTextPredefFlag:: ; cf11
; bit 0: set when printing a text predef so that DisplayTextID doesn't switch
;        to the current map's bank
	ds 1

wPredefParentBank:: ; cf12
	ds 1

wSpriteIndex:: ds 1 ; cf13

wCurSpriteMovement2:: ; cf14
; movement byte 2 of current sprite
	ds 1

	ds 2

wNPCMovementScriptSpriteOffset:: ; cf17
; sprite offset of sprite being controlled by NPC movement script
	ds 1

wScriptedNPCWalkCounter:: ; cf18
	ds 1

	ds 1

wOnSGB:: ; cf1a
; if running on SGB, it's 1, else it's 0
	ds 1

wDefaultPaletteCommand:: ; cf1b
	ds 1

wPlayerHPBarColor:: ; cf1c

wWholeScreenPaletteMonSpecies:: ; cf1c
; species of the mon whose palette is used for the whole screen
	ds 1

wEnemyHPBarColor:: ; cf1d
	ds 1

; 0: green
; 1: yellow
; 2: red
wPartyMenuHPBarColors:: ; cf1e
	ds 6

wStatusScreenHPBarColor:: ; cf25
	ds 1

	ds 7

wCopyingSGBTileData:: ; c2fd

wWhichPartyMenuHPBar:: ; cf2d

wPalPacket:: ; cf2d
	ds 1

wPartyMenuBlkPacket:: ; cf2e
; $30 bytes
	ds 9
wPartyHPBarAttributes:: ; cf36
	ds 20

wExpAmountGained:: ; cf4a
; 2-byte big-endian number
; the total amount of exp a mon gained

wcf4b:: ds 2 ; storage buffer for various strings

wGainBoostedExp:: ; cf4c
	ds 1

	ds 17

wGymCityName:: ; cf5e
	ds 17

wGymLeaderName:: ; cf6f
	ds NAME_LENGTH

wItemList:: ; cf7a
	ds 16

wListPointer:: ; cf8a
	ds 2

wUnusedCF8D:: ; cf8c
; 2 bytes
; used to store pointers, but never read
	ds 2

wItemPrices:: ; cf8e
	ds 2

wcf91:: ds 1 ; used with a lot of things (too much to list here) ; cf90

wWhichPokemon:: ; cf91
; which pokemon you selected
	ds 1

wPrintItemPrices:: ; cf92
; if non-zero, then print item prices when displaying lists
	ds 1

wHPBarType:: ; cf93
; type of HP bar
; $00 = enemy HUD in battle
; $01 = player HUD in battle / status screen
; $02 = party menu

wListMenuID:: ; cf93
; ID used by DisplayListMenuID
	ds 1

wRemoveMonFromBox:: ; cf94
; if non-zero, RemovePokemon will remove the mon from the current box,
; else it will remove the mon from the party

wMoveMonType:: ; cf94
; 0 = move from box to party
; 1 = move from party to box
; 2 = move from daycare to party
; 3 = move from party to daycare
	ds 1

wItemQuantity:: ; cf95
	ds 1

wMaxItemQuantity:: ; cf96
	ds 1

; LoadMonData copies mon data here
wLoadedMon:: party_struct wLoadedMon ; cf97

wFontLoaded:: ; cfc3
; bit 0: The space in VRAM that is used to store walk animation tile patterns
;        for the player and NPCs is in use for font tile patterns.
;        This means that NPC movement must be disabled.
; The other bits are unused.
	ds 1

wWalkCounter:: ; cfc4
; walk animation counter
	ds 1

wTileInFrontOfPlayer:: ; cfc5
; background tile number in front of the player (either 1 or 2 steps ahead)
	ds 1

wAudioFadeOutControl:: ; cfc6
; The desired fade counter reload value is stored here prior to calling
; PlaySound in order to cause the current music to fade out before the new
; music begins playing. Storing 0 causes no fade out to occur and the new music
; to begin immediately.
; This variable has another use related to fade-out, as well. PlaySound stores
; the sound ID of the music that should be played after the fade-out is finished
; in this variable. FadeOutAudio checks if it's non-zero every V-Blank and
; fades out the current audio if it is. Once it has finished fading out the
; audio, it zeroes this variable and starts playing the sound ID stored in it.
	ds 1

wAudioFadeOutCounterReloadValue:: ; cfc7
	ds 1

wAudioFadeOutCounter:: ; cfc8
	ds 1

wLastMusicSoundID:: ; cfc9
; This is used to determine whether the default music is already playing when
; attempting to play the default music (in order to avoid restarting the same
; music) and whether the music has already been stopped when attempting to
; fade out the current music (so that the new music can be begin immediately
; instead of waiting).
; It sometimes contains the sound ID of the last music played, but it may also
; contain $ff (if the music has been stopped) or 0 (because some routines zero
; it in order to prevent assumptions from being made about the current state of
; the music).
	ds 1

wUpdateSpritesEnabled:: ; cfca
; $00 = causes sprites to be hidden and the value to change to $ff
; $01 = enabled
; $ff = disabled
; other values aren't used
	ds 1

wEnemyMoveNum:: ; cfcb
	ds 1
wEnemyMoveEffect:: ; cfcc
	ds 1
wEnemyMovePower:: ; cfcd
	ds 1
wEnemyMoveType:: ; cfce
	ds 1
wEnemyMoveAccuracy:: ; cfcf
	ds 1
wEnemyMoveMaxPP:: ; cfd0
	ds 1
wPlayerMoveNum:: ; cfd1
	ds 1
wPlayerMoveEffect:: ; cfd2
	ds 1
wPlayerMovePower:: ; cfd3
	ds 1
wPlayerMoveType:: ; cfd4
	ds 1
wPlayerMoveAccuracy:: ; cfd5
	ds 1
wPlayerMoveMaxPP:: ; cfd6
	ds 1


wEnemyMonSpecies2:: ; cfd7
	ds 1
wBattleMonSpecies2:: ; cfd8
	ds 1

wEnemyMonNick:: ds NAME_LENGTH ; cfd9

wEnemyMon:: ; cfe4
; The wEnemyMon struct reaches past 0xcfff,
; the end of wram bank 0 on cgb.
; This has no significance on dmg, where wram
; isn't banked (c000-dfff is contiguous).
; However, recent versions of rgbds have replaced
; dmg-style wram with cgb wram banks.

; Until this is fixed, this struct will have
; to be declared manually.

wEnemyMonSpecies::   db
wEnemyMonHP::        dw
wEnemyMonPartyPos::
wEnemyMonBoxLevel::  db
wEnemyMonStatus::    db
wEnemyMonType::
wEnemyMonType1::     db
wEnemyMonType2::     db
wEnemyMonCatchRate_NotReferenced:: db
wEnemyMonMoves::     ds NUM_MOVES
wEnemyMonDVs::       ds 2
wEnemyMonLevel::     db
wEnemyMonMaxHP::     dw
wEnemyMonAttack::    dw
wEnemyMonDefense::   dw
wEnemyMonSpeed::     dw
wEnemyMonSpecial::   dw
wEnemyMonPP::        ds 3 ; NUM_MOVES - 1
SECTION "WRAM Bank 1", WRAMX, BANK[1]
                     ds 1 ; NUM_MOVES - 3

wEnemyMonBaseStats:: ds 5
wEnemyMonCatchRate:: ds 1
wEnemyMonBaseExp:: ds 1

wBattleMonNick:: ds NAME_LENGTH ; d008
wBattleMon:: battle_struct wBattleMon ; d013


wTrainerClass:: ; d030
	ds 1

	ds 1

wTrainerPicPointer:: ; d032
	ds 2
	ds 1

wTempMoveNameBuffer:: ; d035

wLearnMoveMonName:: ; d035
; The name of the mon that is learning a move.
	ds 16

wTrainerBaseMoney:: ; d045
; 2-byte BCD number
; money received after battle = base money × level of highest-level enemy mon
	ds 2

wMissableObjectCounter:: ; d047
	ds 1

	ds 1

wTrainerName:: ; d049
; 13 bytes for the letters of the opposing trainer
; the name is terminated with $50 with possible
; unused trailing letters
	ds 13

wIsInBattle:: ; d056
; lost battle, this is -1
; no battle, this is 0
; wild battle, this is 1
; trainer battle, this is 2
	ds 1

wPartyGainExpFlags:: ; d057
; flags that indicate which party members should be be given exp when GainExperience is called
	flag_array 6

wCurOpponent:: ; d058
; in a wild battle, this is the species of pokemon
; in a trainer battle, this is the trainer class + 200
	ds 1

wBattleType:: ; d059
; in normal battle, this is 0
; in old man battle, this is 1
; in safari battle, this is 2
	ds 1

wDamageMultipliers:: ; d05a
; bits 0-6: Effectiveness
   ;  $0 = immune
   ;  $5 = not very effective
   ;  $a = neutral
   ; $14 = super-effective
; bit 7: STAB
	ds 1

wLoneAttackNo:: ; d05b
; which entry in LoneAttacks to use
wGymLeaderNo:: ; d05b
; it's actually the same thing as ^
	ds 1
wTrainerNo:: ; d05c
; which instance of [youngster, lass, etc] is this?
	ds 1

wCriticalHitOrOHKO:: ; d05d
; $00 = normal attack
; $01 = critical hit
; $02 = successful OHKO
; $ff = failed OHKO
	ds 1

wMoveMissed:: ; d05e
	ds 1

wPlayerStatsToDouble:: ; d05f
; always 0
	ds 1

wPlayerStatsToHalve:: ; d060
; always 0
	ds 1

wPlayerBattleStatus1:: ; d061
; bit 0 - bide
; bit 1 - thrash / petal dance
; bit 2 - attacking multiple times (e.g. double kick)
; bit 3 - flinch
; bit 4 - charging up for attack
; bit 5 - using multi-turn move (e.g. wrap)
; bit 6 - invulnerable to normal attack (using fly/dig)
; bit 7 - confusion
	ds 1

wPlayerBattleStatus2:: ; d062
; bit 0 - X Accuracy effect
; bit 1 - protected by "mist"
; bit 2 - focus energy effect
; bit 4 - has a substitute
; bit 5 - need to recharge
; bit 6 - rage
; bit 7 - leech seeded
	ds 1

wPlayerBattleStatus3:: ; d063
; bit 0 - toxic
; bit 1 - light screen
; bit 2 - reflect
; bit 3 - tranformed
	ds 1

wEnemyStatsToDouble:: ; d064
; always 0
	ds 1

wEnemyStatsToHalve:: ; d065
; always 0
	ds 1

wEnemyBattleStatus1:: ; d066
	ds 1
wEnemyBattleStatus2:: ; d067
	ds 1
wEnemyBattleStatus3:: ; d068
	ds 1

wPlayerNumAttacksLeft:: ; d069
; when the player is attacking multiple times, the number of attacks left
	ds 1

W_PLAYERCONFUSEDCOUNTER:: ; d06a
	ds 1

wPlayerToxicCounter:: ; d06b
	ds 1
wPlayerDisabledMove:: ; d06c
; high nibble: which move is disabled (1-4)
; low nibble: disable turns left
	ds 1

	ds 1

wEnemyNumAttacksLeft:: ; d06e
; when the enemy is attacking multiple times, the number of attacks left
	ds 1

W_ENEMYCONFUSEDCOUNTER:: ; d06f
	ds 1

wEnemyToxicCounter:: ; d070
	ds 1
wEnemyDisabledMove:: ; d071
; high nibble: which move is disabled (1-4)
; low nibble: disable turns left
	ds 1

	ds 1

wPlayerNumHits:: ; d073
; number of hits by player in attacks like Double Slap, etc.

wPlayerBideAccumulatedDamage:: ; d073
; the amount of damage accumulated by the player while biding (2 bytes)

wUnknownSerialCounter2:: ; d073
; 2 bytes

	ds 4

wEscapedFromBattle:: ; d077
; non-zero when an item or move that allows escape from battle was used
	ds 1

wAmountMoneyWon:: ; d078
; 3-byte BCD number

wObjectToHide:: ; d078
	ds 1

wObjectToShow:: ; d079
	ds 1

	ds 1

wAnimationID:: ; d07b
; ID number of the current battle animation
	ds 1

wNamingScreenType:: ; d07c

wPartyMenuTypeOrMessageID:: ; d07c

wTempTilesetNumTiles:: ; d07c
; temporary storage for the number of tiles in a tileset
	ds 1

wSavedListScrollOffset:: ; d07d
; used by the pokemart code to save the existing value of wListScrollOffset
; so that it can be restored when the player is done with the pokemart NPC
	ds 1

	ds 2

; base coordinates of frame block
wBaseCoordX:: ; d080
	ds 1
wBaseCoordY:: ; d081
	ds 1

; low health alarm counter/enable
; high bit = enable, others = timer to cycle frequencies
wLowHealthAlarm:: ds 1 ; d082

wFBTileCounter:: ; d083
; counts how many tiles of the current frame block have been drawn
	ds 1

wMovingBGTilesCounter2:: ; d084
	ds 1

wSubAnimFrameDelay:: ; d085
; duration of each frame of the current subanimation in terms of screen refreshes
	ds 1
wSubAnimCounter:: ; d086
; counts the number of subentries left in the current subanimation
	ds 1

wSaveFileStatus:: ; d087
; 1 = no save file or save file is corrupted
; 2 = save file exists and no corruption has been detected
	ds 1

wNumFBTiles:: ; d088
; number of tiles in current battle animation frame block
	ds 1

wFlashScreenLongCounter:: ; d089

wSpiralBallsBaseY:: ; d089

wFallingObjectMovementByte:: ; d089
; bits 0-6: index into FallingObjects_DeltaXs array (0 - 8)
; bit 7: direction; 0 = right, 1 = left

wNumShootingBalls:: ; d089

wTradedMonMovingRight:: ; d089
; $01 if mon is moving from left gameboy to right gameboy; $00 if vice versa

wOptionsInitialized:: ; d089

wNewSlotMachineBallTile:: ; d089

wCoordAdjustmentAmount:: ; d089
; how much to add to the X/Y coord

wUnusedD08A:: ; d089
	ds 1

wSpiralBallsBaseX:: ; d08a

wNumFallingObjects:: ; d08a

wSlideMonDelay:: ; d08a

wAnimCounter:: ; d08a
; generic counter variable for various animations

wSubAnimTransform:: ; d08a
; controls what transformations are applied to the subanimation
; 01: flip horizontally and vertically
; 02: flip horizontally and translate downwards 40 pixels
; 03: translate base coordinates of frame blocks, but don't change their internal coordinates or flip their tiles
; 04: reverse the subanimation
	ds 1

wEndBattleWinTextPointer:: ; d08b
	ds 2

wEndBattleLoseTextPointer:: ; d08d
	ds 2

	ds 2

wEndBattleTextRomBank:: ; d091
	ds 1

	ds 1

wSubAnimAddrPtr:: ; d093
; the address _of the address_ of the current subanimation entry
	ds 2

wSlotMachineAllowMatchesCounter:: ; d095
; If non-zero, the allow matches flag is always set.
; There is a 1/256 (~0.4%) chance that this value will be set to 60, which is
; the only way it can increase. Winning certain payout amounts will decrement it
; or zero it.

wSubAnimSubEntryAddr:: ; d095
; the address of the current subentry of the current subanimation
	ds 2

	ds 2

wOutwardSpiralTileMapPointer:: ; d099
	ds 1

wPartyMenuAnimMonEnabled:: ; d09a

wTownMapSpriteBlinkingEnabled:: ; d09a
; non-zero when enabled. causes nest locations to blink on and off.
; the town selection cursor will blink regardless of what this value is

wUnusedD09B:: ; d09a
	ds 1

wFBDestAddr:: ; d09b
; current destination address in OAM for frame blocks (big endian)
	ds 2

wFBMode:: ; d09d
; controls how the frame blocks are put together to form frames
; specifically, after finishing drawing the frame block, the frame block's mode determines what happens
; 00: clean OAM buffer and delay
; 02: move onto the next frame block with no delay and no cleaning OAM buffer
; 03: delay, but don't clean OAM buffer
; 04: delay, without cleaning OAM buffer, and do not advance [wFBDestAddr], so that the next frame block will overwrite this one
	ds 1

wLinkCableAnimBulgeToggle:: ; d09e
; 0 = small
; 1 = big

wIntroNidorinoBaseTile:: ; d09e

wOutwardSpiralCurrentDirection:: ; d09e

wDropletTile:: ; d09e

wNewTileBlockID:: ; d09e

wWhichBattleAnimTileset:: ; d09e

wSquishMonCurrentDirection:: ; d09e
; 0 = left
; 1 = right

wSlideMonUpBottomRowLeftTile:: ; d09e
; the tile ID of the leftmost tile in the bottom row in AnimationSlideMonUp_
	ds 1

wDisableVBlankWYUpdate:: ds 1 ; if non-zero, don't update WY during V-blank ; d09f

W_SPRITECURPOSX:: ; d0a0
	ds 1
W_SPRITECURPOSY:: ; d0a1
	ds 1
W_SPRITEWITDH:: ; d0a2
	ds 1
W_SPRITEHEIGHT:: ; d0a3
	ds 1
W_SPRITEINPUTCURBYTE:: ; d0a4
; current input byte
	ds 1
W_SPRITEINPUTBITCOUNTER:: ; d0a5
; bit offset of last read input bit
	ds 1

W_SPRITEOUTPUTBITOFFSET:: ; d0a6; determines where in the output byte the two bits are placed. Each byte contains four columns (2bpp data)
; 3 -> XX000000   1st column
; 2 -> 00XX0000   2nd column
; 1 -> 0000XX00   3rd column
; 0 -> 000000XX   4th column
	ds 1

W_SPRITELOADFLAGS:: ; d0a7
; bit 0 determines used buffer (0 -> $a188, 1 -> $a310)
; bit 1 loading last sprite chunk? (there are at most 2 chunks per load operation)
	ds 1
W_SPRITEUNPACKMODE:: ; d0a8
	ds 1
wSpriteFlipped:: ; d0a9
	ds 1

W_SPRITEINPUTPTR:: ; d0aa
; pointer to next input byte
	ds 2
W_SPRITEOUTPUTPTR:: ; d0ac
; pointer to current output byte
	ds 2
W_SPRITEOUTPUTPTRCACHED:: ; d0ae
; used to revert pointer for different bit offsets
	ds 2
W_SPRITEDECODETABLE0PTR:: ; d0b0
; pointer to differential decoding table (assuming initial value 0)
	ds 2
W_SPRITEDECODETABLE1PTR:: ; d0b2
; pointer to differential decoding table (assuming initial value 1)
	ds 2

wd0b5:: ds 1 ; used as a temp storage area for Pokemon Species, and other Pokemon/Battle related things ; d0b4

wNameListType:: ; d0b5
	ds 1

wPredefBank:: ; d0b6
	ds 1

wMonHeader:: ; d0b7

wMonHIndex:: ; d0b7
; In the ROM base stats data stucture, this is the dex number, but it is
; overwritten with the internal index number after the header is copied to WRAM.
	ds 1

wMonHBaseStats:: ; d0b8
W_MONHBASEHP:: ; d0b8
	ds 1
wMonHBaseAttack:: ; d0b9
	ds 1
wMonHBaseDefense:: ; d0ba
	ds 1
wMonHBaseSpeed:: ; d0bb
	ds 1
wMonHBaseSpecial:: ; d0bc
	ds 1

wMonHTypes:: ; d0bd
wMonHType1:: ; d0bd
	ds 1
wMonHType2:: ; d0be
	ds 1

wMonHCatchRate:: ; d0bf
	ds 1
wMonHBaseEXP:: ; d0c0
	ds 1
wMonHSpriteDim:: ; d0c1
	ds 1
wMonHFrontSprite:: ; d0c2
	ds 2
wMonHBackSprite:: ; d0c4
	ds 2

wMonHMoves:: ; d0c6
	ds 4

wMonHGrowthRate:: ; d0ca
	ds 1

wMonHLearnset:: ; d0cb
; bit field
	flag_array 50 + 5
	ds 1

wSavedTilesetType:: ; d0d3
; saved at the start of a battle and then written back at the end of the battle
	ds 1

	ds 2

wDamage:: ; d0d6
	ds 2

	ds 2

wRepelRemainingSteps:: ; d0da
	ds 1

wMoves:: ; d0db
; list of moves for FormatMovesString
	ds 4

wMoveNum:: ; d0df
	ds 1

wMovesString:: ; d0e0
	ds 56

wUnusedD119:: ; d118
	ds 1

wWalkBikeSurfStateCopy:: ; d119
; wWalkBikeSurfState is sometimes copied here, but it doesn't seem to be used for anything
	ds 1

wInitListType:: ; d11a
; the type of list for InitList to init
	ds 1

wCapturedMonSpecies:: ; d11b
; 0 if no mon was captured
	ds 1

wFirstMonsNotOutYet:: ; d11c
; Non-zero when the first player mon and enemy mon haven't been sent out yet.
; It prevents the game from asking if the player wants to choose another mon
; when the enemy sends out their first mon and suppresses the "no will to fight"
; message when the game searches for the first non-fainted mon in the party,
; which will be the first mon sent out.
	ds 1

; lower nybble: number of shakes
; upper nybble: number of animations to play
wPokeBallAnimData:: ; d11d

wUsingPPUp:: ; d11d

wMaxPP:: ; d11d

; 0 for player, non-zero for enemy
wCalculateWhoseStats:: ; d11d

wTypeEffectiveness:: ; d11d

wMoveType:: ; d11d

wNumSetBits:: ; d11d

wd11e:: ds 1 ; used as a Pokemon and Item storage value. Also used as an output value for CountSetBits

wForcePlayerToChooseMon:: ; d11e
; When this value is non-zero, the player isn't allowed to exit the party menu
; by pressing B and not choosing a mon.
	ds 1

wNumRunAttempts:: ; d11f
; number of times the player has tried to run from battle
	ds 1

wEvolutionOccurred:: ; d120
	ds 1

wVBlankSavedROMBank:: ; d121
	ds 1

wFarCopyDataSavedROMBank:: ; d122
	ds 1

wIsKeyItem:: ; d123
	ds 1

wTextBoxID:: ; d124
	ds 1

wd126:: ds 1 ; not exactly sure what this is used for, but it seems to be used as a multipurpose temp flag value ; d125

wCurEnemyLVL:: ; d126
	ds 1

wItemListPointer:: ; d127
; pointer to list of items terminated by $FF
	ds 2

wListCount:: ; d129
; number of entries in a list
	ds 1

wLinkState:: ; d12a
	ds 1

wTwoOptionMenuID:: ; d12b
	ds 1

wChosenMenuItem:: ; d12c
; the id of the menu item the player ultimately chose

wOutOfBattleBlackout:: ; d12c
; non-zero when the whole party has fainted due to out-of-battle poison damage
	ds 1

wMenuExitMethod:: ; d12d
; the way the user exited a menu
; for list menus and the buy/sell/quit menu:
; $01 = the user pressed A to choose a menu item
; $02 = the user pressed B to cancel
; for two-option menus:
; $01 = the user pressed A with the first menu item selected
; $02 = the user pressed B or pressed A with the second menu item selected
	ds 1

wDungeonWarpDataEntrySize:: ; d12e
; the size is always 6, so they didn't need a variable in RAM for this

wWhichPewterGuy:: ; d12e
; 0 = museum guy
; 1 = gym guy

wWhichPrizeWindow:: ; d12e
; there are 3 windows, from 0 to 2

wGymGateTileBlock:: ; d12e
; a horizontal or vertical gate block
	ds 1

wSavedSpriteScreenY:: ; d12f
	ds 1

wSavedSpriteScreenX:: ; d130
	ds 1

wSavedSpriteMapY:: ; d131
	ds 1

wSavedSpriteMapX:: ; d132
	ds 1

	ds 5

wWhichPrize:: ; d138
	ds 1

wIgnoreInputCounter:: ; d139
; counts downward each frame
; when it hits 0, bit 5 (ignore input bit) of wd730 is reset
	ds 1

wStepCounter:: ; d13a
; counts down once every step
	ds 1

wNumberOfNoRandomBattleStepsLeft:: ; d13b
; after a battle, you have at least 3 steps before a random battle can occur
	ds 1

wPrize1:: ; d13c
	ds 1
wPrize2:: ; d13d
	ds 1
wPrize3:: ; d13e
	ds 1

	ds 1

wSerialRandomNumberListBlock:: ; d140
; the first 7 bytes are the preamble

wPrize1Price:: ; d140
	ds 2

wPrize2Price:: ; d142
	ds 2

wPrize3Price:: ; d144
	ds 2

	ds 1

wLinkBattleRandomNumberList:: ; d147
; shared list of 9 random numbers, indexed by wLinkBattleRandomNumberListIndex
	ds 10

wSerialPlayerDataBlock:: ; d151
; the first 6 bytes are the preamble

wPseudoItemID:: ; d151
; When a real item is being used, this is 0.
; When a move is acting as an item, this is the ID of the item it's acting as.
; For example, out-of-battle Dig is executed using a fake Escape Rope item. In
; that case, this would be ESCAPE_ROPE.
	ds 1

wUnusedD153:: ; d152
	ds 1

	ds 2

wEvoStoneItemID:: ; d155
	ds 1

wSavedNPCMovementDirections2Index:: ; d156
	ds 1

wPlayerName:: ; d157
	ds NAME_LENGTH


wPartyDataStart::

wPartyCount::   ds 1 ; d162
wPartySpecies:: ds PARTY_LENGTH ; d163
wPartyEnd::     ds 1 ; d169

wPartyMons::
wPartyMon1:: party_struct wPartyMon1 ; d16a
wPartyMon2:: party_struct wPartyMon2 ; d196
wPartyMon3:: party_struct wPartyMon3 ; d1c2
wPartyMon4:: party_struct wPartyMon4 ; d1ee
wPartyMon5:: party_struct wPartyMon5 ; d21a
wPartyMon6:: party_struct wPartyMon6 ; d246

wPartyMonOT::    ds NAME_LENGTH * PARTY_LENGTH ; d272
wPartyMonNicks:: ds NAME_LENGTH * PARTY_LENGTH ; d2b4

wPartyMonNicksEnd::
wPartyDataEnd::


wMainDataStart::

wPokedexOwned:: ; d2f5
	flag_array NUM_POKEMON
wPokedexOwnedEnd::

wPokedexSeen:: ; d309
	flag_array NUM_POKEMON
wPokedexSeenEnd::


wNumBagItems:: ; d31c
	ds 1
wBagItems:: ; d31d
; item, quantity
	ds 20 * 2
	ds 1 ; end

wPlayerMoney:: ; d346
	ds 3 ; BCD

wRivalName:: ; d349
	ds NAME_LENGTH

wOptions:: ; d354
; bit 7 = battle animation
; 0: On
; 1: Off
; bit 6 = battle style
; 0: Shift
; 1: Set
; bits 0-3 = text speed (number of frames to delay after printing a letter)
; 1: Fast
; 3: Medium
; 5: Slow
	ds 1

wObtainedBadges:: ; d355
	ds 1

	ds 1

wLetterPrintingDelayFlags:: ; d357
; bit 0: If 0, limit the delay to 1 frame. Note that this has no effect if
;        the delay has been disabled entirely through bit 1 of this variable
;        or bit 6 of wd730.
; bit 1: If 0, no delay.
	ds 1

wPlayerID:: ; d358
	ds 2

wMapMusicSoundID:: ; d35a
	ds 1

wMapMusicROMBank:: ; d35b
	ds 1

wMapPalOffset:: ; d35c
; offset subtracted from FadePal4 to get the background and object palettes for the current map
; normally, it is 0. it is 6 when Flash is needed, causing FadePal2 to be used instead of FadePal4
	ds 1

wCurMap:: ; d35d
	ds 1

wCurrentTileBlockMapViewPointer:: ; d35e
; pointer to the upper left corner of the current view in the tile block map
	ds 2

wYCoord:: ; d360
; player’s position on the current map
	ds 1

wXCoord:: ; d361
	ds 1

wYBlockCoord:: ; d362
; player's y position (by block)
	ds 1

wXBlockCoord:: ; d363
	ds 1

wLastMap:: ; d364
	ds 1

wUnusedD366:: ; d365
	ds 1

wCurMapTileset:: ; d366
	ds 1

wCurMapHeight:: ; d367
; blocks
	ds 1

wCurMapWidth:: ; d368
; blocks
	ds 1

W_MAPDATAPTR:: ; d369
	ds 2

wMapTextPtr:: ; d36b
	ds 2

W_MAPSCRIPTPTR:: ; d36d
	ds 2

W_MAPCONNECTIONS:: ; d36f
; connection byte
	ds 1

W_MAPCONN1PTR:: ; d370
	ds 1

wNorthConnectionStripSrc:: ; d371
	ds 2

wNorthConnectionStripDest:: ; d373
	ds 2

wNorthConnectionStripWidth:: ; d375
	ds 1

wNorthConnectedMapWidth:: ; d376
	ds 1

wNorthConnectedMapYAlignment:: ; d377
	ds 1

wNorthConnectedMapXAlignment:: ; d378
	ds 1

wNorthConnectedMapViewPointer:: ; d379
	ds 2

W_MAPCONN2PTR:: ; d37b
	ds 1

wSouthConnectionStripSrc:: ; d37c
	ds 2

wSouthConnectionStripDest:: ; d37e
	ds 2

wSouthConnectionStripWidth:: ; d380
	ds 1

wSouthConnectedMapWidth:: ; d381
	ds 1

wSouthConnectedMapYAlignment:: ; d382
	ds 1

wSouthConnectedMapXAlignment:: ; d383
	ds 1

wSouthConnectedMapViewPointer:: ; d384
	ds 2

W_MAPCONN3PTR:: ; d386
	ds 1

wWestConnectionStripSrc:: ; d387
	ds 2

wWestConnectionStripDest:: ; d389
	ds 2

wWestConnectionStripHeight:: ; d38b
	ds 1

wWestConnectedMapWidth:: ; d38c
	ds 1

wWestConnectedMapYAlignment:: ; d38d
	ds 1

wWestConnectedMapXAlignment:: ; d38e
	ds 1

wWestConnectedMapViewPointer:: ; d38f
	ds 2

W_MAPCONN4PTR:: ; d391
	ds 1

wEastConnectionStripSrc:: ; d392
	ds 2

wEastConnectionStripDest:: ; d394
	ds 2

wEastConnectionStripHeight:: ; d396
	ds 1

wEastConnectedMapWidth:: ; d397
	ds 1

wEastConnectedMapYAlignment:: ; d398
	ds 1

wEastConnectedMapXAlignment:: ; d399
	ds 1

wEastConnectedMapViewPointer:: ; d39a
	ds 2

wSpriteSet:: ; d39c
; sprite set for the current map (11 sprite picture ID's)
	ds 11

wSpriteSetID:: ; d3a7
; sprite set ID for the current map
	ds 1

wObjectDataPointerTemp:: ; d3a8
	ds 2

	ds 2

wMapBackgroundTile:: ; d3ac
; the tile shown outside the boundaries of the map
	ds 1

wNumberOfWarps:: ; d3ad
; number of warps in current map
	ds 1

wWarpEntries:: ; d3ae
; current map warp entries
	ds 128

wDestinationWarpID:: ; d42e
; if $ff, the player's coordinates are not updated when entering the map
	ds 1

wPikachuOverworldStateFlags:: ds 1 ; d42f
wPikachuSpawnState:: ds 1 ; d430
wd432:: ds 1 ; d431
wd433:: ds 1 ; d432
wd434:: ds 1 ; d433
wd435:: ds 1 ; d434
wd436:: ds 1 ; d435
wPikachuFollowCommandBufferSize:: ds 1 ; d436
wPikachuFollowCommandBuffer:: ds 16 ; d437

wExpressionNumber:: ; d447
	ds 1
wPikaPicAnimNumber:: ; d448
	ds 1
	
wPikachuMovementScriptBank:: ds 1  ; d449
wPikachuMovementScriptAddress:: dw ; d44a
wPikachuMovementFlags:: ; d44c
; bit 6 - spawn shadow
; bit 7 - signal end of command
	ds 1

wCurPikaMovementData:: ; d44d
wCurPikaMovementParam1:: ds 1 ; d44d
wCurPikaMovementFunc1:: ds 1 ; d44e
wCurPikaMovementParam2:: ds 1 ; d44f
wCurPikaMovementFunc2:: ds 1 ; d450
wd451:: ds 1 ; d451
wCurPikaMovementSpriteImageIdx:: ds 1 ; d452
wPikaSpriteX:: ds 1 ; d453
wPikaSpriteY:: ds 1 ; d454
wPikachuMovementXOffset:: ds 1 ; d455
wPikachuMovementYOffset:: ds 1 ; d456
wPikachuStepTimer:: ds 1 ; d457
wPikachuStepSubtimer:: ds 1 ; d458
	ds 5
wCurPikaMovementDataEnd:: ; d45e
	ds wCurPikaMovementData - @


wPikaPicAnimPointer:: dw ; d44d
wPikaPicAnimPointerSetupFinished:: ds 1 ; d44f
wPikaPicAnimCurGraphicID:: ds 1 ; d450
wPikaPicAnimTimer:: ds 2 ; d451
wPikaPicAnimDelay:: ds 1 ; d453
wPikaPicPikaDrawStartX:: ds 1 ; d454
wPikaPicPikaDrawStartY:: ds 1 ; d455

wCurPikaPicAnimObject:: ; d456
wCurPikaPicAnimObjectVTileOffset:: db ; d456
wCurPikaPicAnimObjectXOffset:: db ; d457
wCurPikaPicAnimObjectYOffset:: db ; d458
wCurPikaPicAnimObjectScriptIdx:: db ; d459
wCurPikaPicAnimObjectFrameIdx:: db ; d45a
wCurPikaPicAnimObjectFrameTimer:: db ; d45b
	ds 1
wCurPikaPicAnimObjectEnd:: ; d45d

	ds 18

wPikachuHappiness:: ds 1 ; d46f
wPikachuMood:: ds 1 ; d470
wd472:: ds 1 ; d471
wd473:: ds 1 ; d472

	ds 1

wd475:: ds 1 ; d474

	ds 4

wd47a:: ds 1 ; d479

	ds 24
	
wd492:: ds 1 ; d492
	
	ds 1
	
wSurfingMinigameHiScore:: ds 2 ; 4-digit BCD little-endian
	ds 1

wPrinterSettings:: ds 1
wUnknownSerialFlag_d499:: ds 1 ; d498
wPrinterConnectionOpen:: ds 1 ; d499
wPrinterOpcode:: ds 1 ; d49a
wd49c:: ds 1 ; d49b

	ds 19

wNumSigns:: ; d4af
; number of signs in the current map (up to 16)
	ds 1

wSignCoords:: ; d4b0
; 2 bytes each
; Y, X
	ds 32

wSignTextIDs:: ; d4d0
	ds 16

wNumSprites:: ; d4e0
; number of sprites on the current map
	ds 1

; these two variables track the X and Y offset in blocks from the last special warp used
; they don't seem to be used for anything
wYOffsetSinceLastSpecialWarp:: ; d4e1
	ds 1
wXOffsetSinceLastSpecialWarp:: ; d4e2
	ds 1

wMapSpriteData:: ; d4e3
; two bytes per sprite (movement byte 2, text ID)
	ds 32

wMapSpriteExtraData:: ; d503
; two bytes per sprite (trainer class/item ID, trainer set ID)
	ds 32

wCurrentMapHeight2:: ; d523
; map height in 2x2 meta-tiles
	ds 1

wCurrentMapWidth2:: ; d524
; map width in 2x2 meta-tiles
	ds 1

wMapViewVRAMPointer:: ; d525
; the address of the upper left corner of the visible portion of the BG tile map in VRAM
	ds 2

; In the comments for the player direction variables below, "moving" refers to
; both walking and changing facing direction without taking a step.

wPlayerMovingDirection:: ; d527
; if the player is moving, the current direction
; if the player is not moving, zero
; map scripts write to this in order to change the player's facing direction
	ds 1

wPlayerLastStopDirection:: ; d528
; the direction in which the player was moving before the player last stopped
	ds 1

wPlayerDirection:: ; d529
; if the player is moving, the current direction
; if the player is not moving, the last the direction in which the player moved
	ds 1

wTilesetBank:: ; d52a
	ds 1

W_TILESETBLOCKSPTR:: ; d52b
; maps blocks (4x4 tiles) to tiles
	ds 2

wTilesetGFXPtr:: ; d52d
	ds 2

wTilesetCollisionPtr:: ; d52f
; list of all walkable tiles
	ds 2

W_TILESETTALKINGOVERTILES:: ; d531
	ds 3

wGrassTile:: ; d534
	ds 1

	ds 4

wNumBoxItems:: ; d539
	ds 1
wBoxItems:: ; d53a
; item, quantity
	ds 50 * 2
	ds 1 ; end

wCurrentBoxNum:: ; d59f
; bits 0-6: box number
; bit 7: whether the player has changed boxes before
	ds 2

wNumHoFTeams:: ; d5a1
; number of HOF teams
	ds 1

wUnusedD5A3:: ; d5a2
	ds 1

wPlayerCoins:: ; d5a3
	ds 2 ; BCD

wMissableObjectFlags:: ; d5a5
; bit array of missable objects. set = removed
	ds 32
wMissableObjectFlagsEnd:: ; d5c5

	ds 7

wd5cd:: ds 1 ; temp copy of c1x2 (sprite facing/anim) ; d5cc

wMissableObjectList:: ; d5cd
; each entry consists of 2 bytes
; * the sprite ID (depending on the current map)
; * the missable object index (global, used for wMissableObjectFlags)
; terminated with $FF
	ds 17 * 2

wGameProgressFlags:: ; d5e9
; $c8 bytes

W_OAKSLABCURSCRIPT:: ; d5e9
	ds 1
W_PALLETTOWNCURSCRIPT:: ; d5f0
	ds 1
	ds 1
W_BLUESHOUSECURSCRIPT:: ; d5f2
	ds 1
W_VIRIDIANCITYCURSCRIPT:: ; d5f3
	ds 1
	ds 2
W_PEWTERCITYCURSCRIPT:: ; d5f6
	ds 1
W_ROUTE3CURSCRIPT:: ; d5f7
	ds 1
W_ROUTE4CURSCRIPT:: ; d5f8
	ds 1
W_FANCLUBCURSCRIPT:: ; d5f9
	ds 1
W_VIRIDIANGYMCURSCRIPT:: ; d5fa
	ds 1
W_PEWTERGYMCURSCRIPT:: ; d5fb
	ds 1
W_CERULEANGYMCURSCRIPT:: ; d5fc
	ds 1
W_VERMILIONGYMCURSCRIPT:: ; d5fd
	ds 1
W_CELADONGYMCURSCRIPT:: ; d5fe
	ds 1
W_ROUTE6CURSCRIPT:: ; d5ff
	ds 1
W_ROUTE8CURSCRIPT:: ; d600
	ds 1
W_ROUTE24CURSCRIPT:: ; d601
	ds 1
W_ROUTE25CURSCRIPT:: ; d602
	ds 1
W_ROUTE9CURSCRIPT:: ; d603
	ds 1
W_ROUTE10CURSCRIPT:: ; d604
	ds 1
W_MTMOON1CURSCRIPT:: ; d605
	ds 1
W_MTMOON3CURSCRIPT:: ; d606
	ds 1
W_SSANNE8CURSCRIPT:: ; d607
	ds 1
W_SSANNE9CURSCRIPT:: ; d608
	ds 1
W_ROUTE22CURSCRIPT:: ; d609
	ds 1
	ds 1
W_REDSHOUSE2CURSCRIPT:: ; d60b
	ds 1
W_VIRIDIANMARKETCURSCRIPT:: ; d60c
	ds 1
W_ROUTE22GATECURSCRIPT:: ; d60d
	ds 1
W_CERULEANCITYCURSCRIPT:: ; d60e
	ds 1
	ds 7
W_SSANNE5CURSCRIPT:: ; d616
	ds 1
W_VIRIDIANFORESTCURSCRIPT:: ; d617
	ds 1
W_MUSEUM1FCURSCRIPT:: ; d618
	ds 1
W_ROUTE13CURSCRIPT:: ; d619
	ds 1
W_ROUTE14CURSCRIPT:: ; d61a
	ds 1
W_ROUTE17CURSCRIPT:: ; d61b
	ds 1
W_ROUTE19CURSCRIPT:: ; d61c
	ds 1
W_ROUTE21CURSCRIPT:: ; d61d
	ds 1
wSafariZoneEntranceCurScript:: ; d61e
	ds 1
W_ROCKTUNNEL2CURSCRIPT:: ; d61f
	ds 1
W_ROCKTUNNEL1CURSCRIPT:: ; d620
	ds 1
	ds 1
W_ROUTE11CURSCRIPT:: ; d622
	ds 1
W_ROUTE12CURSCRIPT:: ; d623
	ds 1
W_ROUTE15CURSCRIPT:: ; d624
	ds 1
W_ROUTE16CURSCRIPT:: ; d625
	ds 1
W_ROUTE18CURSCRIPT:: ; d626
	ds 1
W_ROUTE20CURSCRIPT:: ; d627
	ds 1
W_SSANNE10CURSCRIPT:: ; d628
	ds 1
W_VERMILIONCITYCURSCRIPT:: ; d629
	ds 1
W_POKEMONTOWER2CURSCRIPT:: ; d62a
	ds 1
W_POKEMONTOWER3CURSCRIPT:: ; d62b
	ds 1
W_POKEMONTOWER4CURSCRIPT:: ; d62c
	ds 1
W_POKEMONTOWER5CURSCRIPT:: ; d62d
	ds 1
W_POKEMONTOWER6CURSCRIPT:: ; d62e
	ds 1
W_POKEMONTOWER7CURSCRIPT:: ; d62f
	ds 1
W_ROCKETHIDEOUT1CURSCRIPT:: ; d630
	ds 1
W_ROCKETHIDEOUT2CURSCRIPT:: ; d631
	ds 1
W_ROCKETHIDEOUT3CURSCRIPT:: ; d632
	ds 1
W_ROCKETHIDEOUT4CURSCRIPT:: ; d633
	ds 2
W_ROUTE6GATECURSCRIPT:: ; d635
	ds 1
W_ROUTE8GATECURSCRIPT:: ; d636
	ds 2
W_CINNABARISLANDCURSCRIPT:: ; d638
	ds 1
W_MANSION1CURSCRIPT:: ; d639
	ds 2
W_MANSION2CURSCRIPT:: ; d63b
	ds 1
W_MANSION3CURSCRIPT:: ; d63c
	ds 1
W_MANSION4CURSCRIPT:: ; d63d
	ds 1
W_VICTORYROAD2CURSCRIPT:: ; d63e
	ds 1
W_VICTORYROAD3CURSCRIPT:: ; d63f
	ds 1
W_CELADONCITYCURSCRIPT:: ; d640
	ds 1
W_FIGHTINGDOJOCURSCRIPT:: ; d641
	ds 1
W_SILPHCO2CURSCRIPT:: ; d642
	ds 1
W_SILPHCO3CURSCRIPT:: ; d643
	ds 1
W_SILPHCO4CURSCRIPT:: ; d644
	ds 1
W_SILPHCO5CURSCRIPT:: ; d645
	ds 1
W_SILPHCO6CURSCRIPT:: ; d646
	ds 1
W_SILPHCO7CURSCRIPT:: ; d647
	ds 1
W_SILPHCO8CURSCRIPT:: ; d648
	ds 1
W_SILPHCO9CURSCRIPT:: ; d649
	ds 1
W_HALLOFFAMEROOMCURSCRIPT:: ; d64a
	ds 1
W_GARYCURSCRIPT:: ; d64b
	ds 1
W_LORELEICURSCRIPT:: ; d64c
	ds 1
W_BRUNOCURSCRIPT:: ; d64d
	ds 1
W_AGATHACURSCRIPT:: ; d64e
	ds 1
W_UNKNOWNDUNGEON3CURSCRIPT:: ; d64f
	ds 1
W_VICTORYROAD1CURSCRIPT:: ; d650
	ds 1
	ds 1
W_LANCECURSCRIPT:: ; d652
	ds 1
	ds 4
W_SILPHCO10CURSCRIPT:: ; d657
	ds 1
W_SILPHCO11CURSCRIPT:: ; d658
	ds 1
	ds 1
W_FUCHSIAGYMCURSCRIPT:: ; d65a
	ds 1
W_SAFFRONGYMCURSCRIPT:: ; d65b
	ds 1
	ds 1
W_CINNABARGYMCURSCRIPT:: ; d65d
	ds 1
W_CELADONGAMECORNERCURSCRIPT:: ; d65e
	ds 1
W_ROUTE16GATECURSCRIPT:: ; d65f
	ds 1
W_BILLSHOUSECURSCRIPT:: ; d660
	ds 1
W_ROUTE5GATECURSCRIPT:: ; d661
	ds 1
W_POWERPLANTCURSCRIPT:: ; d662
; overload
	ds 0
W_ROUTE7GATECURSCRIPT:: ; d662
; overload
	ds 1
	ds 1
W_SSANNE2CURSCRIPT:: ; d664
	ds 1
wSeafoamIslands4CurScript:: ; d665
	ds 1
W_ROUTE23CURSCRIPT:: ; d666
	ds 1
wSeafoamIslands5CurScript:: ; d667
	ds 1
W_ROUTE18GATECURSCRIPT:: ; d668
	ds 1

	ds 78
wGameProgressFlagsEnd:: ; d6b7

	ds 56

wObtainedHiddenItemsFlags:: ; d6ef
	ds 14

wObtainedHiddenCoinsFlags:: ; d6fd
	ds 2

wWalkBikeSurfState:: ; d6ff
; $00 = walking
; $01 = biking
; $02 = surfing
	ds 1

	ds 10

wTownVisitedFlag:: ; d70a
	flag_array 13

wSafariSteps:: ; d70c
; starts at 502
	ds 2

W_FOSSILITEM:: ; d70e
; item given to cinnabar lab
	ds 1

W_FOSSILMON:: ; d70f
; mon that will result from the item
	ds 1

	ds 2

W_ENEMYMONORTRAINERCLASS:: ; d712
; trainer classes start at 200
	ds 1

wPlayerJumpingYScreenCoordsIndex:: ; d713
	ds 1

W_RIVALSTARTER:: ; d714
	ds 1

	ds 1

W_PLAYERSTARTER:: ; d716
	ds 1

wBoulderSpriteIndex:: ; d717
; sprite index of the boulder the player is trying to push
	ds 1

wLastBlackoutMap:: ; d718
	ds 1

wDestinationMap:: ; d719
; destination map (for certain types of special warps, not ordinary walking)
	ds 1

wUnusedD71B:: ; d71a
	ds 1

wTileInFrontOfBoulderAndBoulderCollisionResult:: ; d71b
; used to store the tile in front of the boulder when trying to push a boulder
; also used to store the result of the collision check ($ff for a collision and $00 for no collision)
	ds 1

wDungeonWarpDestinationMap:: ; d71c
; destination map for dungeon warps
	ds 1

wWhichDungeonWarp:: ; d71d
; which dungeon warp within the source map was used
	ds 1

wUnusedD71F:: ; d71e
	ds 1

	ds 8

wd728:: ; d727
; bit 0: using Strength outside of battle
	ds 1

	ds 1

wBeatGymFlags:: ; d729
; redundant because it matches wObtainedBadges
; used to determine whether to show name on statue and in two NPC text scripts
	ds 1

	ds 1

wd72c:: ; d72b
; bit 0: if not set, the 3 minimum steps between random battles have passed
	ds 1

wd72d:: ds 1 ; misc temp flags? (in some scripts, bit 6 and 7 set after a special battle (e.g. gym leaders) has been won)
             ; also used as a start menu flag
			 ; d72c

wd72e:: ; d72d
; bit 7: set if scripted NPC movement has been initialised
	ds 2 ; more temp misc flags, used with npc movement, main menu and other stuff

wd730:: ; d72f
; bit 0: NPC sprite being moved by script
; bit 5: ignore joypad input
; bit 6: print text with no delay between each letter
; bit 7: set if joypad states are being simulated in the overworld or an NPC's movement is being scripted
	ds 1

	ds 1

wd732:: ; d731
; bit 0: play time being counted
; bit 1: remnant of debug mode? not set by the game code.
; if it is set
; 1. skips most of Prof. Oak's speech, and uses NINTEN as the player's name and SONY as the rival's name
; 2. does not have the player start in floor two of the playyer's house (instead sending them to [wLastMap])
; 3. allows wild battles to be avoided by holding down B
; bit 2: the target warp is a fly warp (bit 3 set or blacked out) or a dungeon warp (bit 4 set)
; bit 3: used warp pad, escape rope, dig, teleport, or fly, so the target warp is a "fly warp"
; bit 4: jumped into hole (Pokemon Mansion, Seafoam Islands, Victory Road) or went down waterfall (Seafoam Islands), so the target warp is a "dungeon warp"
; bit 5: currently being forced to ride bike (cycling road)
; bit 6: map destination is [wLastBlackoutMap] (usually the last used pokemon center, but could be the player's house)
	ds 1

wFlags_D733:: ; d732
; bit 0: running a test battle
; bit 4: use variable [W_CURMAPSCRIPT] instead of the provided index for next frame's map script (used to start battle when talking to trainers)
; bit 7: used fly out of battle
	ds 1

wBeatLorelei:: ; d733
; bit 1: set when you beat Lorelei and reset in Indigo Plateau lobby
; the game uses this to tell when Elite 4 events need to be reset
	ds 1

wd735:: ; d734
	ds 1

wd736:: ; d735
; bit 0: check if the player is standing on a door and make him walk down a step if so
; bit 1: the player is currently stepping down from a door
; bit 2: standing on a warp
; bit 6: jumping down a ledge / fishing animation
; bit 7: player sprite spinning due to spin tiles (Rocket hidehout / Viridian Gym)
	ds 1

wCompletedInGameTradeFlags:: ; d736
	ds 2

	ds 2

wWarpedFromWhichWarp:: ; d73a
	ds 1

wWarpedFromWhichMap:: ; d73b
	ds 1

	ds 2

wCardKeyDoorY:: ; d73e
	ds 1

wCardKeyDoorX:: ; d73f
	ds 1

	ds 2

wFirstLockTrashCanIndex:: ; d742
	ds 1

wSecondLockTrashCanIndex:: ; d743
	ds 1

	ds 2

wEventFlags:: ; d746
; below here are mostly in game flags

; d74b
; bit 0: Prof. Oak has lead the player to the north end of his lab
; bit 1: Prof. Oak has asked the player to choose a pokemon
; bit 2: the player and the rival have received their pokemon
; bit 3: the player has battled the rival in Oak's lab
; bit 4: Prof. Oak has given the player 5 pokeballs
; bit 5: received pokedex
	flag_array NUM_EVENT_FLAGS

wLinkEnemyTrainerName:: ; d886
; linked game's trainer name

wGrassRate:: ; d886
	ds 1

wGrassMons:: ; d887
;	ds 20

	ds 11
; Overload wGrassMons
wSerialEnemyDataBlock:: ; d892
	ds 9

wEnemyPartyCount:: ds 1     ; d89b
wEnemyPartyMons::  ds PARTY_LENGTH + 1 ; d89c

wWaterRate:: db ; d8a3
wWaterMons:: db ; d8a4

	ds wWaterRate - @

wEnemyMons:: ; d8a3
wEnemyMon1:: party_struct wEnemyMon1
wEnemyMon2:: party_struct wEnemyMon2
wEnemyMon3:: party_struct wEnemyMon3
wEnemyMon4:: party_struct wEnemyMon4
wEnemyMon5:: party_struct wEnemyMon5
wEnemyMon6:: party_struct wEnemyMon6

wEnemyMonOT::    ds NAME_LENGTH * PARTY_LENGTH ; d9ab
wEnemyMonNicks:: ds NAME_LENGTH * PARTY_LENGTH ; d9ed


wTrainerHeaderPtr:: ; da2f
	ds 2

	ds 6

wOpponentAfterWrongAnswer:: ; da37
; the trainer the player must face after getting a wrong answer in the Cinnabar
; gym quiz

wUnusedDA38:: ; da37
	ds 1

W_CURMAPSCRIPT:: ; da38
; index of current map script, mostly used as index for function pointer array
; mostly copied from map-specific map script pointer and wirtten back later
	ds 1

	ds 6

wPlayTimeHours:: ; da3f
	ds 2
wPlayTimeMinutes:: ; da41
	ds 2
wPlayTimeSeconds:: ; da43
	ds 1
wPlayTimeFrames:: ; da44
	ds 1

wSafariZoneGameOver:: ; da45
	ds 1

wNumSafariBalls:: ; da46
	ds 1


wDayCareInUse:: ; da47
; 0 if no pokemon is in the daycare
; 1 if pokemon is in the daycare
	ds 1

wDayCareMonName:: ds NAME_LENGTH ; da48
wDayCareMonOT::   ds NAME_LENGTH ; da53

wDayCareMon:: box_struct wDayCareMon ; da5e

wMainDataEnd::


wBoxDataStart::

wNumInBox::  ds 1 ; da7f
wBoxSpecies:: ds MONS_PER_BOX + 1 ; da80

wBoxMons::
wBoxMon1:: box_struct wBoxMon1 ; da95
wBoxMon2:: ds box_struct_length * (MONS_PER_BOX + -1) ; dab6

wBoxMonOT::    ds NAME_LENGTH * MONS_PER_BOX ; dd29
wBoxMonNicks:: ds NAME_LENGTH * MONS_PER_BOX ; de05
wBoxMonNicksEnd:: ; dee1
wBoxDataEnd::

wGBCBasePalPointers:: ds NUM_ACTIVE_PALS * 2 ; dee1
wGBCPal:: ds PAL_SIZE ; dee9
wLastBGP:: ds 1 ; def1
wLastOBP0:: ds 1 ; def2
wLastOBP1:: ds 1 ; def3
wdef5:: ds 1 ; def4
wBGPPalsBuffer:: ds NUM_ACTIVE_PALS * PAL_SIZE ; def5

SECTION "Stack", WRAMX[$dfff], BANK[1]
wStack:: ; dfff
	ds -$100


INCLUDE "sram.asm"
