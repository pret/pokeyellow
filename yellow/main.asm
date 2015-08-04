INCLUDE "charmap.asm"
INCLUDE "constants.asm"

NPC_SPRITES_1 EQU $4
NPC_SPRITES_2 EQU $5

GFX EQU $4

PICS_1 EQU $9
PICS_2 EQU $A
PICS_3 EQU $B
PICS_4 EQU $C
PICS_5 EQU $D


SECTION "home",ROM0

INCLUDE "home.asm"
SECTION "bank01",ROMX,BANK[$01]

INCLUDE "data/facing.asm"
INCLUDE "engine/battle/safari_zone.asm"
SetDefaultNamesBeforeTitlescreen:: ; 414b (1:414b)
	dr $414b,$442b
LoadMonData_:: ; 442b (1:442b)
	dr $442b,$4494
ItemPrices:: ; 4494 (1:4494)
	dr $4494,$45b7
ItemNames:: ; 45b7 (1:45b7)
	dr $45b7,$491e
UnusedNames:: ; 491e (1:491e)
	dr $491e,$499b
PrepareOAMData:: ; 499b (1:499b)
	dr $499b,$4a92
WriteDMACodeToHRAM:: ; 4a92 (1:4a92)
	dr $4a92,$4aaa
_IsTilePassable:: ; 4aaa (1:4aaa)
	dr $4aaa,$4b89
PrintWaitingText:: ; 4b89 (1:4b89)
	dr $4b89,$4bb7
_UpdateSprites:: ; 4bb7 (1:4bb7)
	dr $4bb7,$5c22
StartMenu_Pokedex:: ; 5c22 (1:5c22)
	dr $5c22,$5c36
StartMenu_Pokemon:: ; 5c36 (1:5c36)
	dr $5c36,$5ce4
SpecialEnterMap:: ; 5ce4 (1:5ce4)
	dr $5ce4,$5ead
StartMenu_Item:: ; 5ead (1:5ead)
	dr $5ead,$600a
StartMenu_TrainerInfo:: ; 600a (1:600a)
	dr $600a,$6042
SpecialWarpIn:: ; 6042 (1:6042)
	dr $6042,$6195
StartMenu_SaveReset:: ; 6195 (1:6195)
	dr $6195,$61a8
StartMenu_Option:: ; 61a8 (1:61a8)
	dr $61a8,$68a6
SubtractAmountPaidFromMoney_:: ; 68a6 (1:68a6)
	dr $68a6,$68c9
HandleItemListSwapping:: ; 68c9 (1:68c9)
	dr $68c9,$69a5
DisplayPokemartDialogue_:: ; 69a5 (1:69a5)
	dr $69a5,$6d97
DisplayPokemonCenterDialogue_:: ; 6d97 (1:6d97)
	dr $6d97,$6f0e
DisplayTextIDInit:: ; 6f0e (1:6f0e)
	dr $6f0e,$6f80
DrawStartMenu:: ; 6f80 (1:6f80)
	dr $6f80,$7035
CableClubNPC:: ; 7035 (1:7035)
	dr $7035,$71ac
CloseLinkConnection: ; 71ac (1:71ac)
	dr $71ac,$71bf
DisplayTextBoxID_:: ; 71bf (1:71bf)
	dr $71bf,$778e
PlayerPC:: ; 778e (1:778e)
	dr $778e,$7a0f
_RemovePokemon:: ; 7a0f (1:7a0f)
	dr $7a0f,$7c18
Func_7c18:: ; 7c18 (1:7c18)
	dr $7c18,$8000

SECTION "bank02",ROMX,BANK[$02]

	dr $8000,$9064
PlayBattleMusic: ; 9064 (2:5064)
	dr $9064,$909d
Music2_UpdateMusic:: ; 909d (2:509d)
	dr $909d,$984e
Func_984e:: ; 984e (2:584e)
	dr $984e,$c000
	
SECTION "bank03",ROMX,BANK[$03]

INCLUDE "engine/joypad.asm"

ClearVariablesAfterLoadingMapData: ; c07c (3:407c)
	ld a, $90
	ld [hWY], a
	ld [rWY], a
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld [wStepCounter], a
	ld [W_LONEATTACKNO], a ; W_GYMLEADERNO
	ld [hJoyPressed], a
	ld [hJoyReleased], a
	ld [hJoyHeld], a
	ld [wcd6a], a
	ld [wd5a3], a
	ld hl, wCardKeyDoorY
	ld [hli], a
	ld [hl], a
	ld hl, wWhichTrade
	ld bc, $1e
	call FillMemory
	ret

; only used for setting bit 2 of wd736 upon entering a new map
IsPlayerStandingOnWarp: ; c0a6 (3:40a6)
	ld a, [wNumberOfWarps]
	and a
	ret z
	ld c, a
	ld hl, wWarpEntries
.loop
	ld a, [W_YCOORD]
	cp [hl]
	jr nz, .nextWarp1
	inc hl
	ld a, [W_XCOORD]
	cp [hl]
	jr nz, .nextWarp2
	inc hl
	ld a, [hli] ; target warp
	ld [wDestinationWarpID], a
	ld a, [hl] ; target map
	ld [$ff8b], a
	ld hl, wd736
	set 2, [hl] ; standing on warp flag
	ret
.nextWarp1
	inc hl
.nextWarp2
	inc hl
	inc hl
	inc hl
	dec c
	jr nz, .loop
	ret

CheckForceBikeOrSurf: ; c0d2 (3:40d2)
	ld hl, wd732
	bit 5, [hl]
	ret nz
	ld hl, ForcedBikeOrSurfMaps
	ld a, [W_YCOORD]
	ld b, a
	ld a, [W_XCOORD]
	ld c, a
	ld a, [W_CURMAP]
	ld d, a
.loop
	ld a, [hli]
	cp $ff
	ret z ;if we reach FF then it's not part of the list
	cp d ;compare to current map
	jr nz, .incorrectMap
	ld a, [hli]
	cp b ;compare y-coord
	jr nz, .incorrectY
	ld a, [hli]
	cp c ;compare x-coord
	jr nz, .loop ; incorrect x-coord, check next item
	ld a, [W_CURMAP]
	cp SEAFOAM_ISLANDS_4
	ld a, $2
	ld [W_SEAFOAMISLANDS4CURSCRIPT], a
	jr z, .forceSurfing
	ld a, [W_CURMAP]
	cp SEAFOAM_ISLANDS_5
	ld a, $2
	ld [W_SEAFOAMISLANDS5CURSCRIPT], a
	jr z, .forceSurfing
	;force bike riding
	ld hl, wd732
	set 5, [hl]
	ld a, $1
	ld [wWalkBikeSurfState], a
	ld [wWalkBikeSurfStateCopy], a
	jp ForceBikeOrSurf
.incorrectMap
	inc hl
.incorrectY
	inc hl
	jr .loop
.forceSurfing
	ld a, $2
	ld [wWalkBikeSurfState], a
	ld [wWalkBikeSurfStateCopy], a
	jp ForceBikeOrSurf

INCLUDE "data/force_bike_surf.asm"

IsPlayerFacingEdgeOfMap: ; c148 (3:4148)
	push hl
	push de
	push bc
	ld a, [wSpriteStateData1 + 9] ; player sprite's facing direction
	srl a
	ld c, a
	ld b, $0
	ld hl, .functionPointerTable
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [W_YCOORD]
	ld b, a
	ld a, [W_XCOORD]
	ld c, a
	ld de, .returnaddress
	push de
	jp [hl]
.returnaddress
	pop bc
	pop de
	pop hl
	ret

.functionPointerTable
	dw .facingDown
	dw .facingUp
	dw .facingLeft
	dw .facingRight

.facingDown
	ld a, [W_CURMAPHEIGHT]
	add a
	dec a
	cp b
	jr z, .setCarry
	jr .resetCarry

.facingUp
	ld a, b
	and a
	jr z, .setCarry
	jr .resetCarry

.facingLeft
	ld a, c
	and a
	jr z, .setCarry
	jr .resetCarry

.facingRight
	ld a, [W_CURMAPWIDTH]
	add a
	dec a
	cp c
	jr z, .setCarry
	jr .resetCarry
.resetCarry
	and a
	ret
.setCarry
	scf
	ret

IsWarpTileInFrontOfPlayer: ; c197 (3:4197)
	push hl
	push de
	push bc
	call _GetTileAndCoordsInFrontOfPlayer
	ld a, [W_CURMAP]
	cp SS_ANNE_5
	jr z, .ssAnne5
	ld a, [wSpriteStateData1 + 9] ; player sprite's facing direction
	srl a
	ld c, a
	ld b, 0
	ld hl, .warpTileListPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wTileInFrontOfPlayer]
	ld de, $1
	call IsInArray
.done
	pop bc
	pop de
	pop hl
	ret

.warpTileListPointers: ; c1c0 (3:41c0)
	dw .facingDownWarpTiles
	dw .facingUpWarpTiles
	dw .facingLeftWarpTiles
	dw .facingRightWarpTiles

.facingDownWarpTiles
	db $01,$12,$17,$3D,$04,$18,$33,$FF

.facingUpWarpTiles
	db $01,$5C,$FF

.facingLeftWarpTiles
	db $1A,$4B,$FF

.facingRightWarpTiles
	db $0F,$4E,$FF

.ssAnne5
	ld a, [wTileInFrontOfPlayer]
	cp $15
	jr nz, .notSSAnne5Warp
	scf
	jr .done
.notSSAnne5Warp
	and a
	jr .done

IsPlayerStandingOnDoorTileOrWarpTile: ; c1e6 (3:41e6)
	push hl
	push de
	push bc
	callba IsPlayerStandingOnDoorTile ; 6:6785
	jr c, .done
	ld a, [W_CURMAPTILESET]
	add a
	ld c, a
	ld b, $0
	ld hl, WarpTileIDPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $1
	aCoord 8, 9
	call IsInArray
	jr nc, .done
	ld hl, wd736
	res 2, [hl]
.done
	pop bc
	pop de
	pop hl
	ret

INCLUDE "data/warp_tile_ids.asm"
PrintSafariZoneSteps:: ; c27b (3:427b)
	dr $c27b,$c2d4
_GetTileAndCoordsInFrontOfPlayer:: ; c2d4 (3:42d4)
	dr $c2d4,$cb62
LoadWildData:: ; cb62 (3:4b62)
	dr $cb62,$d2ed
UseItem_:: ; d2ed (3:52ed)
	dr $d2ed,$e635
TossItem_:: ; e635 (3:6635)
	dr $e635,$e6a8
IsKeyItem_:: ; e6a8 (3:66a8)
	dr $e6a8,$e6e8
SendNewMonToBox: ; e6e8 (3:66e8)
	dr $e6e8,$e808
IsNextTileShoreOrWater:: ; e808 (3:6808)
	dr $e808,$e848
FindWildLocationsOfMon:: ; e848 (3:6848)
	dr $e848,$e91b
	
GymLeaderFaceAndBadgeTileGraphics: ; e91b (3:691b)
	INCBIN "gfx/badges.2bpp"

	dr $ed1b,$ef93
MarkTownVisitedAndLoadMissableObjects:: ; ef93 (3:6f93)
	dr $ef93,$f0a1
TryPushingBoulder:: ; f0a1 (3:70a1)
	dr $f0a1,$f131
DoBoulderDustAnimation:: ; f131 (3:7131)
	dr $f131,$f161
_AddPartyMon:: ; f161 (3:7161)
	dr $f161,$f323
_AddEnemyMonToPlayerParty:: ; f323 (3:7323)
	dr $f323,$f3a4
Func_f3a4:: ; f3a4 (3:73a4)
	dr $f3a4,$f9de
PrintBookshelfText:: ; f9de (3:79de)
	dr $f9de,$fad3
PokemonStuffText:: ; fad3 (3:7ad3)
	dr $fad3,$10000

SECTION "Graphics", ROMX, BANK[GFX]

PokemonLogoJapanGraphics:       INCBIN "gfx/pokemon_logo_japan.2bpp"
FontGraphics:                   INCBIN "gfx/font.1bpp"
ABTiles:                        INCBIN "gfx/AB.2bpp"
HpBarAndStatusGraphics:         INCBIN "gfx/hp_bar_and_status.2bpp"
BattleHudTiles1:                INCBIN "gfx/battle_hud1.1bpp"
BattleHudTiles2:                INCBIN "gfx/battle_hud2.1bpp"
BattleHudTiles3:                INCBIN "gfx/battle_hud3.1bpp"
NintendoCopyrightLogoGraphics:  INCBIN "gfx/copyright.2bpp"
GamefreakLogoGraphics:          INCBIN "gfx/gamefreak.2bpp"
NineTile:                       INCBIN "gfx/9_tile.2bpp"
TextBoxGraphics:                INCBIN "gfx/text_box.2bpp"
PokedexTileGraphics:            INCBIN "gfx/pokedex.2bpp"
WorldMapTileGraphics:           INCBIN "gfx/town_map.2bpp"
PlayerCharacterTitleGraphics:   INCBIN "gfx/player_title.2bpp"

	dr $11468,$11875
DrawPartyMenu_:: ; 11875 (4:5875)
	dr $11875,$11886
RedrawPartyMenu_:: ; 11886 (4:5886)
	dr $11886,$11a97
	
RedPicFront:: INCBIN "pic/ytrainer/red.pic"
ShrinkPic1::  INCBIN "pic/trainer/shrink1.pic"
ShrinkPic2::  INCBIN "pic/trainer/shrink2.pic"

	dr $11c22,$11e98
ErasePartyMenuCursors:: ; 11e98 (4:5e98)
	dr $11e98,$121c5
SwitchPartyMon:: ; 121c5 (4:61c5)
	dr $121c5,$12365


SECTION "NPC Sprites 1", ROMX, BANK[NPC_SPRITES_1]

OakAideSprite:         INCBIN "gfx/sprites/oak_aide.2bpp"
RockerSprite:          INCBIN "gfx/sprites/rocker.2bpp"
SwimmerSprite:         INCBIN "gfx/sprites/swimmer.2bpp"
WhitePlayerSprite:     INCBIN "gfx/sprites/white_player.2bpp"
GymHelperSprite:       INCBIN "gfx/sprites/gym_helper.2bpp"
OldPersonSprite:       INCBIN "gfx/sprites/old_person.2bpp"
MartGuySprite:         INCBIN "gfx/sprites/mart_guy.2bpp"
FisherSprite:          INCBIN "gfx/sprites/fisher.2bpp"
OldMediumWomanSprite:  INCBIN "gfx/sprites/old_medium_woman.2bpp"
NurseSprite:           INCBIN "gfx/sprites/nurse.2bpp"
CableClubWomanSprite:  INCBIN "gfx/sprites/cable_club_woman.2bpp"
MrMasterballSprite:    INCBIN "gfx/sprites/mr_masterball.2bpp"
LaprasGiverSprite:     INCBIN "gfx/sprites/lapras_giver.2bpp"
WardenSprite:          INCBIN "gfx/sprites/warden.2bpp"
SsCaptainSprite:       INCBIN "gfx/sprites/ss_captain.2bpp"
Fisher2Sprite:         INCBIN "gfx/sprites/fisher2.2bpp"
BlackbeltSprite:       INCBIN "gfx/sprites/blackbelt.2bpp"
GuardSprite:           INCBIN "gfx/sprites/guard.2bpp"
BallSprite:            INCBIN "gfx/sprites/ball.2bpp"
OmanyteSprite:         INCBIN "gfx/sprites/omanyte.2bpp"
BoulderSprite:         INCBIN "gfx/sprites/boulder.2bpp"
PaperSheetSprite:      INCBIN "gfx/sprites/paper_sheet.2bpp"
BookMapDexSprite:      INCBIN "gfx/sprites/book_map_dex.2bpp"
ClipboardSprite:       INCBIN "gfx/sprites/clipboard.2bpp"
SnorlaxSprite:         INCBIN "gfx/sprites/snorlax.2bpp"
OldAmberSprite:        INCBIN "gfx/sprites/old_amber.2bpp"
LyingOldManSprite:     INCBIN "gfx/sprites/lying_old_man.2bpp"
QuestionMarkSprite:    INCBIN "gfx/sprites/question_mark.2bpp"

EndOfBattle: ; 13765 (4:7765)
	dr $13765,$1383a
TryDoWildEncounter: ; 1383a (4:783a)
	dr $1383a,$14000


SECTION "NPC Sprites 2", ROMX, BANK[NPC_SPRITES_2]

	dr $14000,$1401b
_InitMapSprites:: ; 1401b (5:401b)
	dr $1401b,$143f1

RedCyclingSprite:     INCBIN "gfx/sprites/cycling.2bpp"
RedSprite:            INCBIN "gfx/sprites/red.2bpp"
BlueSprite:           INCBIN "gfx/sprites/blue.2bpp"
OakSprite:            INCBIN "gfx/sprites/oak.2bpp"
BugCatcherSprite:     INCBIN "gfx/sprites/bug_catcher.2bpp"
SlowbroSprite:        INCBIN "gfx/sprites/slowbro.2bpp"
LassSprite:           INCBIN "gfx/sprites/lass.2bpp"
BlackHairBoy1Sprite:  INCBIN "gfx/sprites/black_hair_boy_1.2bpp"
LittleGirlSprite:     INCBIN "gfx/sprites/little_girl.2bpp"
BirdSprite:           INCBIN "gfx/sprites/bird.2bpp"
FatBaldGuySprite:     INCBIN "gfx/sprites/fat_bald_guy.2bpp"
GamblerSprite:        INCBIN "gfx/sprites/gambler.2bpp"
BlackHairBoy2Sprite:  INCBIN "gfx/sprites/black_hair_boy_2.2bpp"
GirlSprite:           INCBIN "gfx/sprites/girl.2bpp"
HikerSprite:          INCBIN "gfx/sprites/hiker.2bpp"
FoulardWomanSprite:   INCBIN "gfx/sprites/foulard_woman.2bpp"
GentlemanSprite:      INCBIN "gfx/sprites/gentleman.2bpp"
DaisySprite:          INCBIN "gfx/sprites/daisy.2bpp"
BikerSprite:          INCBIN "gfx/sprites/biker.2bpp"
SailorSprite:         INCBIN "gfx/sprites/sailor.2bpp"
CookSprite:           INCBIN "gfx/sprites/cook.2bpp"
BikeShopGuySprite:    INCBIN "gfx/sprites/bike_shop_guy.2bpp"
MrFujiSprite:         INCBIN "gfx/sprites/mr_fuji.2bpp"
GiovanniSprite:       INCBIN "gfx/sprites/giovanni.2bpp"
RocketSprite:         INCBIN "gfx/sprites/rocket.2bpp"
MediumSprite:         INCBIN "gfx/sprites/medium.2bpp"
WaiterSprite:         INCBIN "gfx/sprites/waiter.2bpp"
ErikaSprite:          INCBIN "gfx/sprites/erika.2bpp"
MomGeishaSprite:      INCBIN "gfx/sprites/mom_geisha.2bpp"
BrunetteGirlSprite:   INCBIN "gfx/sprites/brunette_girl.2bpp"
LanceSprite:          INCBIN "gfx/sprites/lance.2bpp"
MomSprite:            INCBIN "gfx/sprites/mom.2bpp"
BaldingGuySprite:     INCBIN "gfx/sprites/balding_guy.2bpp"
YoungBoySprite:       INCBIN "gfx/sprites/young_boy.2bpp"
GameboyKidSprite:     INCBIN "gfx/sprites/gameboy_kid.2bpp"
ClefairySprite:       INCBIN "gfx/sprites/clefairy.2bpp"
AgathaSprite:         INCBIN "gfx/sprites/agatha.2bpp"
BrunoSprite:          INCBIN "gfx/sprites/bruno.2bpp"
LoreleiSprite:        INCBIN "gfx/sprites/lorelei.2bpp"
SeelSprite:           INCBIN "gfx/sprites/seel.2bpp"

	dr $17c31,$17cb0
ActivatePC:: ; 17cb0 (5:7cb0)
	dr $17cb0,$18000

SECTION "bank06",ROMX,BANK[$06]
	dr $18000,$1a4ea
PlayerStepOutFromDoor:: ; 1a4ea (6:64ea)
	dr $1a4ea,$1a527
_EndNPCMovementScript:: ; 1a527 (6:6527)
	dr $1a527,$1a54c
ProfOakMovementScriptPointerTable:: ; 1a54c (6:654c)
	dr $1a54c,$1a622
PewterMuseumGuyMovementScriptPointerTable:: ; 1a622 (6:6622)
	dr $1a622,$1a685
PewterGymGuyMovementScriptPointerTable:: ; 1a685 (6:6685)
	dr $1a685,$1a785
IsPlayerStandingOnDoorTile:: ; 1a785 (6:6785)
	dr $1a785,$1a7f4
HandleLedges:: ; 1a7f4 (6:67f4)
	dr $1a7f4,$1c000

SECTION "bank07",ROMX,BANK[$07]

	dr $1c000,$1e321
SafariZoneCheck:: ; 1e321 (7:6e21)
	dr $1e321,$1e330
SafariZoneCheckSteps:: ; 1e330 (7:6330)
	dr $1e330,$1e385
PrintSafariGameOverText:: ; 1e385 (7:6385)
	dr $1e385,$1e4bf
CinnabarGymQuiz_1eb0a:: ; 1e4bf (7:64bf)
	dr $1e4bf,$20000

SECTION "bank08",ROMX,BANK[$08]

	dr $20000,$2131e
Music_DoLowHealthAlarm:: ; 2131e (8:531e)
	dr $2131e,$2146f
BillsPC_:: ; 2146f (8:546f)
	dr $2146f,$218bb
Func_218bb:: ; 218bb (8:58bb)
	dr $218bb,$219f8
Func_219f8:: ; 219f8 (8:59f8)
	dr $219f8,$21ab7
Func_21ab7:: ; 21ab7 (8:5ab7)
	dr $21ab7,$21b3f
Func_21b3f:: ; 21b3f (8:5b3f)
	dr $21b3f,$24000

SECTION "Pics 1", ROMX, BANK[PICS_1]

RhydonPicFront::      INCBIN "pic/ymon/rhydon.pic"
RhydonPicBack::       INCBIN "pic/monback/rhydonb.pic"
KangaskhanPicFront::  INCBIN "pic/ymon/kangaskhan.pic"
KangaskhanPicBack::   INCBIN "pic/monback/kangaskhanb.pic"
NidoranMPicFront::    INCBIN "pic/ymon/nidoranm.pic"
NidoranMPicBack::     INCBIN "pic/monback/nidoranmb.pic"
ClefairyPicFront::    INCBIN "pic/ymon/clefairy.pic"
ClefairyPicBack::     INCBIN "pic/monback/clefairyb.pic"
SpearowPicFront::     INCBIN "pic/ymon/spearow.pic"
SpearowPicBack::      INCBIN "pic/monback/spearowb.pic"
VoltorbPicFront::     INCBIN "pic/ymon/voltorb.pic"
VoltorbPicBack::      INCBIN "pic/monback/voltorbb.pic"
NidokingPicFront::    INCBIN "pic/ymon/nidoking.pic"
NidokingPicBack::     INCBIN "pic/monback/nidokingb.pic"
SlowbroPicFront::     INCBIN "pic/ymon/slowbro.pic"
SlowbroPicBack::      INCBIN "pic/monback/slowbrob.pic"
IvysaurPicFront::     INCBIN "pic/ymon/ivysaur.pic"
IvysaurPicBack::      INCBIN "pic/monback/ivysaurb.pic"
ExeggutorPicFront::   INCBIN "pic/ymon/exeggutor.pic"
ExeggutorPicBack::    INCBIN "pic/monback/exeggutorb.pic"
LickitungPicFront::   INCBIN "pic/ymon/lickitung.pic"
LickitungPicBack::    INCBIN "pic/monback/lickitungb.pic"
ExeggcutePicFront::   INCBIN "pic/ymon/exeggcute.pic"
ExeggcutePicBack::    INCBIN "pic/monback/exeggcuteb.pic"
GrimerPicFront::      INCBIN "pic/ymon/grimer.pic"
GrimerPicBack::       INCBIN "pic/monback/grimerb.pic"
GengarPicFront::      INCBIN "pic/ymon/gengar.pic"
GengarPicBack::       INCBIN "pic/monback/gengarb.pic"
NidoranFPicFront::    INCBIN "pic/ymon/nidoranf.pic"
NidoranFPicBack::     INCBIN "pic/monback/nidoranfb.pic"
NidoqueenPicFront::   INCBIN "pic/ymon/nidoqueen.pic"
NidoqueenPicBack::    INCBIN "pic/monback/nidoqueenb.pic"
CubonePicFront::      INCBIN "pic/ymon/cubone.pic"
CubonePicBack::       INCBIN "pic/monback/cuboneb.pic"
RhyhornPicFront::     INCBIN "pic/ymon/rhyhorn.pic"
RhyhornPicBack::      INCBIN "pic/monback/rhyhornb.pic"
LaprasPicFront::      INCBIN "pic/ymon/lapras.pic"
LaprasPicBack::       INCBIN "pic/monback/laprasb.pic"
ArcaninePicFront::    INCBIN "pic/ymon/arcanine.pic"
ArcaninePicBack::     INCBIN "pic/monback/arcanineb.pic"
MewPicFront::         INCBIN "pic/ymon/mew.pic"
MewPicBack::          INCBIN "pic/monback/mewb.pic"
GyaradosPicFront::    INCBIN "pic/ymon/gyarados.pic"
GyaradosPicBack::     INCBIN "pic/monback/gyaradosb.pic"
ShellderPicFront::    INCBIN "pic/ymon/shellder.pic"
ShellderPicBack::     INCBIN "pic/monback/shellderb.pic"
TentacoolPicFront::   INCBIN "pic/ymon/tentacool.pic"
TentacoolPicBack::    INCBIN "pic/monback/tentacoolb.pic"
GastlyPicFront::      INCBIN "pic/ymon/gastly.pic"
GastlyPicBack::       INCBIN "pic/monback/gastlyb.pic"
ScytherPicFront::     INCBIN "pic/ymon/scyther.pic"
ScytherPicBack::      INCBIN "pic/monback/scytherb.pic"
StaryuPicFront::      INCBIN "pic/ymon/staryu.pic"
StaryuPicBack::       INCBIN "pic/monback/staryub.pic"
BlastoisePicFront::   INCBIN "pic/ymon/blastoise.pic"
BlastoisePicBack::    INCBIN "pic/monback/blastoiseb.pic"
PinsirPicFront::      INCBIN "pic/ymon/pinsir.pic"
PinsirPicBack::       INCBIN "pic/monback/pinsirb.pic"
TangelaPicFront::     INCBIN "pic/ymon/tangela.pic"
TangelaPicBack::      INCBIN "pic/monback/tangelab.pic"

	dr $27d20,$27dff
SaveTrainerName:: ; 27dff (9:7dff)
	dr $27dff,$28000

SECTION "Pics 2", ROMX, BANK[PICS_2]

GrowlithePicFront::   INCBIN "pic/ymon/growlithe.pic"
GrowlithePicBack::    INCBIN "pic/monback/growlitheb.pic"
OnixPicFront::        INCBIN "pic/ymon/onix.pic"
OnixPicBack::         INCBIN "pic/monback/onixb.pic"
FearowPicFront::      INCBIN "pic/ymon/fearow.pic"
FearowPicBack::       INCBIN "pic/monback/fearowb.pic"
PidgeyPicFront::      INCBIN "pic/ymon/pidgey.pic"
PidgeyPicBack::       INCBIN "pic/monback/pidgeyb.pic"
SlowpokePicFront::    INCBIN "pic/ymon/slowpoke.pic"
SlowpokePicBack::     INCBIN "pic/monback/slowpokeb.pic"
KadabraPicFront::     INCBIN "pic/ymon/kadabra.pic"
KadabraPicBack::      INCBIN "pic/monback/kadabrab.pic"
GravelerPicFront::    INCBIN "pic/ymon/graveler.pic"
GravelerPicBack::     INCBIN "pic/monback/gravelerb.pic"
ChanseyPicFront::     INCBIN "pic/ymon/chansey.pic"
ChanseyPicBack::      INCBIN "pic/monback/chanseyb.pic"
MachokePicFront::     INCBIN "pic/ymon/machoke.pic"
MachokePicBack::      INCBIN "pic/monback/machokeb.pic"
MrMimePicFront::      INCBIN "pic/ymon/mr.mime.pic"
MrMimePicBack::       INCBIN "pic/monback/mr.mimeb.pic"
HitmonleePicFront::   INCBIN "pic/ymon/hitmonlee.pic"
HitmonleePicBack::    INCBIN "pic/monback/hitmonleeb.pic"
HitmonchanPicFront::  INCBIN "pic/ymon/hitmonchan.pic"
HitmonchanPicBack::   INCBIN "pic/monback/hitmonchanb.pic"
ArbokPicFront::       INCBIN "pic/ymon/arbok.pic"
ArbokPicBack::        INCBIN "pic/monback/arbokb.pic"
ParasectPicFront::    INCBIN "pic/ymon/parasect.pic"
ParasectPicBack::     INCBIN "pic/monback/parasectb.pic"
PsyduckPicFront::     INCBIN "pic/ymon/psyduck.pic"
PsyduckPicBack::      INCBIN "pic/monback/psyduckb.pic"
DrowzeePicFront::     INCBIN "pic/ymon/drowzee.pic"
DrowzeePicBack::      INCBIN "pic/monback/drowzeeb.pic"
GolemPicFront::       INCBIN "pic/ymon/golem.pic"
GolemPicBack::        INCBIN "pic/monback/golemb.pic"
MagmarPicFront::      INCBIN "pic/ymon/magmar.pic"
MagmarPicBack::       INCBIN "pic/monback/magmarb.pic"
ElectabuzzPicFront::  INCBIN "pic/ymon/electabuzz.pic"
ElectabuzzPicBack::   INCBIN "pic/monback/electabuzzb.pic"
MagnetonPicFront::    INCBIN "pic/ymon/magneton.pic"
MagnetonPicBack::     INCBIN "pic/monback/magnetonb.pic"
KoffingPicFront::     INCBIN "pic/ymon/koffing.pic"
KoffingPicBack::      INCBIN "pic/monback/koffingb.pic"
MankeyPicFront::      INCBIN "pic/ymon/mankey.pic"
MankeyPicBack::       INCBIN "pic/monback/mankeyb.pic"
SeelPicFront::        INCBIN "pic/ymon/seel.pic"
SeelPicBack::         INCBIN "pic/monback/seelb.pic"
DiglettPicFront::     INCBIN "pic/ymon/diglett.pic"
DiglettPicBack::      INCBIN "pic/monback/diglettb.pic"
TaurosPicFront::      INCBIN "pic/ymon/tauros.pic"
TaurosPicBack::       INCBIN "pic/monback/taurosb.pic"
FarfetchdPicFront::   INCBIN "pic/ymon/farfetchd.pic"
FarfetchdPicBack::    INCBIN "pic/monback/farfetchdb.pic"
VenonatPicFront::     INCBIN "pic/ymon/venonat.pic"
VenonatPicBack::      INCBIN "pic/monback/venonatb.pic"
DragonitePicFront::   INCBIN "pic/ymon/dragonite.pic"
DragonitePicBack::    INCBIN "pic/monback/dragoniteb.pic"
DoduoPicFront::       INCBIN "pic/ymon/doduo.pic"
DoduoPicBack::        INCBIN "pic/monback/doduob.pic"
PoliwagPicFront::     INCBIN "pic/ymon/poliwag.pic"
PoliwagPicBack::      INCBIN "pic/monback/poliwagb.pic"
JynxPicFront::        INCBIN "pic/ymon/jynx.pic"
JynxPicBack::         INCBIN "pic/monback/jynxb.pic"
MoltresPicFront::     INCBIN "pic/ymon/moltres.pic"
MoltresPicBack::      INCBIN "pic/monback/moltresb.pic"

	dr $2bd4c,$2c000


SECTION "Pics 3", ROMX, BANK[PICS_3]

ArticunoPicFront::    INCBIN "pic/ymon/articuno.pic"
ArticunoPicBack::     INCBIN "pic/monback/articunob.pic"
ZapdosPicFront::      INCBIN "pic/ymon/zapdos.pic"
ZapdosPicBack::       INCBIN "pic/monback/zapdosb.pic"
DittoPicFront::       INCBIN "pic/ymon/ditto.pic"
DittoPicBack::        INCBIN "pic/monback/dittob.pic"
MeowthPicFront::      INCBIN "pic/ymon/meowth.pic"
MeowthPicBack::       INCBIN "pic/monback/meowthb.pic"
KrabbyPicFront::      INCBIN "pic/ymon/krabby.pic"
KrabbyPicBack::       INCBIN "pic/monback/krabbyb.pic"
VulpixPicFront::      INCBIN "pic/ymon/vulpix.pic"
VulpixPicBack::       INCBIN "pic/monback/vulpixb.pic"
NinetalesPicFront::   INCBIN "pic/ymon/ninetales.pic"
NinetalesPicBack::    INCBIN "pic/monback/ninetalesb.pic"
PikachuPicFront::     INCBIN "pic/ymon/pikachu.pic"
PikachuPicBack::      INCBIN "pic/monback/pikachub.pic"
RaichuPicFront::      INCBIN "pic/ymon/raichu.pic"
RaichuPicBack::       INCBIN "pic/monback/raichub.pic"
DratiniPicFront::     INCBIN "pic/ymon/dratini.pic"
DratiniPicBack::      INCBIN "pic/monback/dratinib.pic"
DragonairPicFront::   INCBIN "pic/ymon/dragonair.pic"
DragonairPicBack::    INCBIN "pic/monback/dragonairb.pic"
KabutoPicFront::      INCBIN "pic/ymon/kabuto.pic"
KabutoPicBack::       INCBIN "pic/monback/kabutob.pic"
KabutopsPicFront::    INCBIN "pic/ymon/kabutops.pic"
KabutopsPicBack::     INCBIN "pic/monback/kabutopsb.pic"
HorseaPicFront::      INCBIN "pic/ymon/horsea.pic"
HorseaPicBack::       INCBIN "pic/monback/horseab.pic"
SeadraPicFront::      INCBIN "pic/ymon/seadra.pic"
SeadraPicBack::       INCBIN "pic/monback/seadrab.pic"
SandshrewPicFront::   INCBIN "pic/ymon/sandshrew.pic"
SandshrewPicBack::    INCBIN "pic/monback/sandshrewb.pic"
SandslashPicFront::   INCBIN "pic/ymon/sandslash.pic"
SandslashPicBack::    INCBIN "pic/monback/sandslashb.pic"
OmanytePicFront::     INCBIN "pic/ymon/omanyte.pic"
OmanytePicBack::      INCBIN "pic/monback/omanyteb.pic"
OmastarPicFront::     INCBIN "pic/ymon/omastar.pic"
OmastarPicBack::      INCBIN "pic/monback/omastarb.pic"
JigglypuffPicFront::  INCBIN "pic/ymon/jigglypuff.pic"
JigglypuffPicBack::   INCBIN "pic/monback/jigglypuffb.pic"
WigglytuffPicFront::  INCBIN "pic/ymon/wigglytuff.pic"
WigglytuffPicBack::   INCBIN "pic/monback/wigglytuffb.pic"
EeveePicFront::       INCBIN "pic/ymon/eevee.pic"
EeveePicBack::        INCBIN "pic/monback/eeveeb.pic"
FlareonPicFront::     INCBIN "pic/ymon/flareon.pic"
FlareonPicBack::      INCBIN "pic/monback/flareonb.pic"
JolteonPicFront::     INCBIN "pic/ymon/jolteon.pic"
JolteonPicBack::      INCBIN "pic/monback/jolteonb.pic"
VaporeonPicFront::    INCBIN "pic/ymon/vaporeon.pic"
VaporeonPicBack::     INCBIN "pic/monback/vaporeonb.pic"
MachopPicFront::      INCBIN "pic/ymon/machop.pic"
MachopPicBack::       INCBIN "pic/monback/machopb.pic"
ZubatPicFront::       INCBIN "pic/ymon/zubat.pic"
ZubatPicBack::        INCBIN "pic/monback/zubatb.pic"
EkansPicFront::       INCBIN "pic/ymon/ekans.pic"
EkansPicBack::        INCBIN "pic/monback/ekansb.pic"
ParasPicFront::       INCBIN "pic/ymon/paras.pic"
ParasPicBack::        INCBIN "pic/monback/parasb.pic"
PoliwhirlPicFront::   INCBIN "pic/ymon/poliwhirl.pic"
PoliwhirlPicBack::    INCBIN "pic/monback/poliwhirlb.pic"
PoliwrathPicFront::   INCBIN "pic/ymon/poliwrath.pic"
PoliwrathPicBack::    INCBIN "pic/monback/poliwrathb.pic"
WeedlePicFront::      INCBIN "pic/ymon/weedle.pic"
WeedlePicBack::       INCBIN "pic/monback/weedleb.pic"
KakunaPicFront::      INCBIN "pic/ymon/kakuna.pic"
KakunaPicBack::       INCBIN "pic/monback/kakunab.pic"
BeedrillPicFront::    INCBIN "pic/ymon/beedrill.pic"
BeedrillPicBack::     INCBIN "pic/monback/beedrillb.pic"

FossilKabutopsPic::   INCBIN "pic/bmon/fossilkabutops.pic"

	dr $2fd25,$30000


SECTION "Pics 4", ROMX, BANK[PICS_4]

DodrioPicFront::       INCBIN "pic/ymon/dodrio.pic"
DodrioPicBack::        INCBIN "pic/monback/dodriob.pic"
PrimeapePicFront::     INCBIN "pic/ymon/primeape.pic"
PrimeapePicBack::      INCBIN "pic/monback/primeapeb.pic"
DugtrioPicFront::      INCBIN "pic/ymon/dugtrio.pic"
DugtrioPicBack::       INCBIN "pic/monback/dugtriob.pic"
VenomothPicFront::     INCBIN "pic/ymon/venomoth.pic"
VenomothPicBack::      INCBIN "pic/monback/venomothb.pic"
DewgongPicFront::      INCBIN "pic/ymon/dewgong.pic"
DewgongPicBack::       INCBIN "pic/monback/dewgongb.pic"
CaterpiePicFront::     INCBIN "pic/ymon/caterpie.pic"
CaterpiePicBack::      INCBIN "pic/monback/caterpieb.pic"
MetapodPicFront::      INCBIN "pic/ymon/metapod.pic"
MetapodPicBack::       INCBIN "pic/monback/metapodb.pic"
ButterfreePicFront::   INCBIN "pic/ymon/butterfree.pic"
ButterfreePicBack::    INCBIN "pic/monback/butterfreeb.pic"
MachampPicFront::      INCBIN "pic/ymon/machamp.pic"
MachampPicBack::       INCBIN "pic/monback/machampb.pic"
GolduckPicFront::      INCBIN "pic/ymon/golduck.pic"
GolduckPicBack::       INCBIN "pic/monback/golduckb.pic"
HypnoPicFront::        INCBIN "pic/ymon/hypno.pic"
HypnoPicBack::         INCBIN "pic/monback/hypnob.pic"
GolbatPicFront::       INCBIN "pic/ymon/golbat.pic"
GolbatPicBack::        INCBIN "pic/monback/golbatb.pic"
MewtwoPicFront::       INCBIN "pic/ymon/mewtwo.pic"
MewtwoPicBack::        INCBIN "pic/monback/mewtwob.pic"
SnorlaxPicFront::      INCBIN "pic/ymon/snorlax.pic"
SnorlaxPicBack::       INCBIN "pic/monback/snorlaxb.pic"
MagikarpPicFront::     INCBIN "pic/ymon/magikarp.pic"
MagikarpPicBack::      INCBIN "pic/monback/magikarpb.pic"
MukPicFront::          INCBIN "pic/ymon/muk.pic"
MukPicBack::           INCBIN "pic/monback/mukb.pic"
KinglerPicFront::      INCBIN "pic/ymon/kingler.pic"
KinglerPicBack::       INCBIN "pic/monback/kinglerb.pic"
CloysterPicFront::     INCBIN "pic/ymon/cloyster.pic"
CloysterPicBack::      INCBIN "pic/monback/cloysterb.pic"
ElectrodePicFront::    INCBIN "pic/ymon/electrode.pic"
ElectrodePicBack::     INCBIN "pic/monback/electrodeb.pic"
ClefablePicFront::     INCBIN "pic/ymon/clefable.pic"
ClefablePicBack::      INCBIN "pic/monback/clefableb.pic"
WeezingPicFront::      INCBIN "pic/ymon/weezing.pic"
WeezingPicBack::       INCBIN "pic/monback/weezingb.pic"
PersianPicFront::      INCBIN "pic/ymon/persian.pic"
PersianPicBack::       INCBIN "pic/monback/persianb.pic"
MarowakPicFront::      INCBIN "pic/ymon/marowak.pic"
MarowakPicBack::       INCBIN "pic/monback/marowakb.pic"
HaunterPicFront::      INCBIN "pic/ymon/haunter.pic"
HaunterPicBack::       INCBIN "pic/monback/haunterb.pic"
AbraPicFront::         INCBIN "pic/ymon/abra.pic"
AbraPicBack::          INCBIN "pic/monback/abrab.pic"
AlakazamPicFront::     INCBIN "pic/ymon/alakazam.pic"
AlakazamPicBack::      INCBIN "pic/monback/alakazamb.pic"
PidgeottoPicFront::    INCBIN "pic/ymon/pidgeotto.pic"
PidgeottoPicBack::     INCBIN "pic/monback/pidgeottob.pic"
PidgeotPicFront::      INCBIN "pic/ymon/pidgeot.pic"
PidgeotPicBack::       INCBIN "pic/monback/pidgeotb.pic"
StarmiePicFront::      INCBIN "pic/ymon/starmie.pic"
StarmiePicBack::       INCBIN "pic/monback/starmieb.pic"


SECTION "Pics 5", ROMX, BANK[PICS_5]

BulbasaurPicFront::    INCBIN "pic/ymon/bulbasaur.pic"
BulbasaurPicBack::     INCBIN "pic/monback/bulbasaurb.pic"
VenusaurPicFront::     INCBIN "pic/ymon/venusaur.pic"
VenusaurPicBack::      INCBIN "pic/monback/venusaurb.pic"
TentacruelPicFront::   INCBIN "pic/ymon/tentacruel.pic"
TentacruelPicBack::    INCBIN "pic/monback/tentacruelb.pic"
GoldeenPicFront::      INCBIN "pic/ymon/goldeen.pic"
GoldeenPicBack::       INCBIN "pic/monback/goldeenb.pic"
SeakingPicFront::      INCBIN "pic/ymon/seaking.pic"
SeakingPicBack::       INCBIN "pic/monback/seakingb.pic"
PonytaPicFront::       INCBIN "pic/ymon/ponyta.pic"
RapidashPicFront::     INCBIN "pic/ymon/rapidash.pic"
PonytaPicBack::        INCBIN "pic/monback/ponytab.pic"
RapidashPicBack::      INCBIN "pic/monback/rapidashb.pic"
RattataPicFront::      INCBIN "pic/ymon/rattata.pic"
RattataPicBack::       INCBIN "pic/monback/rattatab.pic"
RaticatePicFront::     INCBIN "pic/ymon/raticate.pic"
RaticatePicBack::      INCBIN "pic/monback/raticateb.pic"
NidorinoPicFront::     INCBIN "pic/ymon/nidorino.pic"
NidorinoPicBack::      INCBIN "pic/monback/nidorinob.pic"
NidorinaPicFront::     INCBIN "pic/ymon/nidorina.pic"
NidorinaPicBack::      INCBIN "pic/monback/nidorinab.pic"
GeodudePicFront::      INCBIN "pic/ymon/geodude.pic"
GeodudePicBack::       INCBIN "pic/monback/geodudeb.pic"
PorygonPicFront::      INCBIN "pic/ymon/porygon.pic"
PorygonPicBack::       INCBIN "pic/monback/porygonb.pic"
AerodactylPicFront::   INCBIN "pic/ymon/aerodactyl.pic"
AerodactylPicBack::    INCBIN "pic/monback/aerodactylb.pic"
MagnemitePicFront::    INCBIN "pic/ymon/magnemite.pic"
MagnemitePicBack::     INCBIN "pic/monback/magnemiteb.pic"
CharmanderPicFront::   INCBIN "pic/ymon/charmander.pic"
CharmanderPicBack::    INCBIN "pic/monback/charmanderb.pic"
SquirtlePicFront::     INCBIN "pic/ymon/squirtle.pic"
SquirtlePicBack::      INCBIN "pic/monback/squirtleb.pic"
CharmeleonPicFront::   INCBIN "pic/ymon/charmeleon.pic"
CharmeleonPicBack::    INCBIN "pic/monback/charmeleonb.pic"
WartortlePicFront::    INCBIN "pic/ymon/wartortle.pic"
WartortlePicBack::     INCBIN "pic/monback/wartortleb.pic"
CharizardPicFront::    INCBIN "pic/ymon/charizard.pic"
CharizardPicBack::     INCBIN "pic/monback/charizardb.pic"
FossilAerodactylPic::  INCBIN "pic/bmon/fossilaerodactyl.pic"
GhostPic::             INCBIN "pic/other/ghost.pic"
OddishPicFront::       INCBIN "pic/ymon/oddish.pic"
OddishPicBack::        INCBIN "pic/monback/oddishb.pic"
GloomPicFront::        INCBIN "pic/ymon/gloom.pic"
GloomPicBack::         INCBIN "pic/monback/gloomb.pic"
VileplumePicFront::    INCBIN "pic/ymon/vileplume.pic"
VileplumePicBack::     INCBIN "pic/monback/vileplumeb.pic"
BellsproutPicFront::   INCBIN "pic/ymon/bellsprout.pic"
BellsproutPicBack::    INCBIN "pic/monback/bellsproutb.pic"
WeepinbellPicFront::   INCBIN "pic/ymon/weepinbell.pic"
WeepinbellPicBack::    INCBIN "pic/monback/weepinbellb.pic"
VictreebelPicFront::   INCBIN "pic/ymon/victreebel.pic"
VictreebelPicBack::    INCBIN "pic/monback/victreebelb.pic"

	dr $3749e,$38000

SECTION "bank0E",ROMX,BANK[$0E]

	dr $38000,$383de
BaseStats:: ; 383de (e:43de)
	dr $383de,$39462
CryData:: ; 39462 (e:5462)
	dr $39462,$39893
TrainerPicAndMoneyPointers:: ; 39893 (e:5893)
	dr $39893,$3997e
TrainerNames:: ; 3997e (e:597e)
	dr $3997e,$39bb6
ReadTrainer: ; 39bb6 (e:5bb6)
	dr $39bb6,$3a8df
DrawAllPokeballs: ; 3a8df (e:68df)
	dr $3a8df,$3a9e9
SetupPlayerAndEnemyPokeballs: ; 3a9e9 (e:69e9)
	dr $3a9e9,$3aa68

TradingAnimationGraphics:
	INCBIN "gfx/game_boy.norepeat.2bpp"
	INCBIN "gfx/link_cable.2bpp"

TradingAnimationGraphics2:
; Pokeball traveling through the link cable.
	INCBIN "gfx/trade2.2bpp"

	dr $3adb8,$3b10f
Func_3b10f: ; 3b01f (e:710f)
	dr $3b10f,$3c000


SECTION "bank0F",ROMX,BANK[$0F]

	dr $3c000,$3c04c
SlidePlayerAndEnemySilhouettesOnScreen: ; 3c04c (f:404c)
	dr $3c04c,$3c127
StartBattle: ; 3c127 (f:4127)
	dr $3c127,$3cae8
AnyPartyAlive:: ; 3cae8 (f:4ae8)
	dr $3cae8,$3ce1f
DrawHUDsAndHPBars: ; 3ce1f (f:4e1f)
	dr $3ce1f,$3ceb1
DrawEnemyHUDAndHPBar: ; 3ceb1 (f:4eb1)
	dr $3ceb1,$3d9ac
IsGhostBattle: ; 3d9ac (f:59ac)
	dr $3d9ac,$3ddc3
PrintDoesntAffectText: ; 3ddc3 (f:5dc3)
	dr $3ddc3,$3e6f1
MoveHitTest: ; 3e6f1 (f:66f1)
	dr $3e6f1,$3ec87
LoadEnemyMonData: ; 3ec87 (f:6c87)
	dr $3ec87,$3edb8
DoBattleTransitionAndInitBattleVariables: ; 3edb8 (f:6db8)
	dr $3edb8,$3eeb3
QuarterSpeedDueToParalysis: ; 3eeb3 (f:6eb3)
	dr $3eeb3,$3fb2e
PrintButItFailedText_: ; 3fb2e (f:7b2e)
	dr $3fb2e,$3fb39
PrintDidntAffectText: ; 3fb39 (f:7b39)
	dr $3fb39,$3fb49
PrintMayNotAttackText: ; 3fb49 (f:7b49)
	dr $3fb49,$3fb83
PlayCurrentMoveAnimation: ; 3fb83 (f:7b83)
	dr $3fb83,$40000

SECTION "bank10",ROMX,BANK[$10]

	dr $40000,$4050b
Pointer_4050b: ; 4050b (10:450b)
	dr $4050b,$44000


SECTION "bank11",ROMX,BANK[$11]

	dr $44000,$45077
LoadSpinnerArrowTiles:: ; 45077 (11:5077)
	dr $45077,$48000


SECTION "bank12",ROMX,BANK[$12]

	dr $48000,$4c000


SECTION "bank13",ROMX,BANK[$13]

TrainerPics::
YoungsterPic::     INCBIN "pic/trainer/youngster.pic"
BugCatcherPic::    INCBIN "pic/trainer/bugcatcher.pic"
LassPic::          INCBIN "pic/trainer/lass.pic"
SailorPic::        INCBIN "pic/trainer/sailor.pic"
JrTrainerMPic::    INCBIN "pic/trainer/jr.trainerm.pic"
JrTrainerFPic::    INCBIN "pic/trainer/jr.trainerf.pic"
PokemaniacPic::    INCBIN "pic/trainer/pokemaniac.pic"
SuperNerdPic::     INCBIN "pic/trainer/supernerd.pic"
HikerPic::         INCBIN "pic/trainer/hiker.pic"
BikerPic::         INCBIN "pic/trainer/biker.pic"
BurglarPic::       INCBIN "pic/trainer/burglar.pic"
EngineerPic::      INCBIN "pic/trainer/engineer.pic"
FisherPic::        INCBIN "pic/trainer/fisher.pic"
SwimmerPic::       INCBIN "pic/trainer/swimmer.pic"
CueBallPic::       INCBIN "pic/trainer/cueball.pic"
GamblerPic::       INCBIN "pic/trainer/gambler.pic"
BeautyPic::        INCBIN "pic/trainer/beauty.pic"
PsychicPic::       INCBIN "pic/trainer/psychic.pic"
RockerPic::        INCBIN "pic/trainer/rocker.pic"
JugglerPic::       INCBIN "pic/trainer/juggler.pic"
TamerPic::         INCBIN "pic/trainer/tamer.pic"
BirdKeeperPic::    INCBIN "pic/trainer/birdkeeper.pic"
BlackbeltPic::     INCBIN "pic/trainer/blackbelt.pic"
Rival1Pic::        INCBIN "pic/ytrainer/rival1.pic"
ProfOakPic::       INCBIN "pic/trainer/prof.oak.pic"
ChiefPic::
ScientistPic::     INCBIN "pic/trainer/scientist.pic"
GiovanniPic::      INCBIN "pic/trainer/giovanni.pic"
RocketPic::        INCBIN "pic/trainer/rocket.pic"
CooltrainerMPic::  INCBIN "pic/trainer/cooltrainerm.pic"
CooltrainerFPic::  INCBIN "pic/trainer/cooltrainerf.pic"
BrunoPic::         INCBIN "pic/trainer/bruno.pic"
BrockPic::         INCBIN "pic/ytrainer/brock.pic"
MistyPic::         INCBIN "pic/ytrainer/misty.pic"
LtSurgePic::       INCBIN "pic/trainer/lt.surge.pic"
ErikaPic::         INCBIN "pic/ytrainer/erika.pic"
KogaPic::          INCBIN "pic/trainer/koga.pic"
BlainePic::        INCBIN "pic/trainer/blaine.pic"
SabrinaPic::       INCBIN "pic/trainer/sabrina.pic"
GentlemanPic::     INCBIN "pic/trainer/gentleman.pic"
Rival2Pic::        INCBIN "pic/ytrainer/rival2.pic"
Rival3Pic::        INCBIN "pic/ytrainer/rival3.pic"
LoreleiPic::       INCBIN "pic/trainer/lorelei.pic"
ChannelerPic::     INCBIN "pic/trainer/channeler.pic"
AgathaPic::        INCBIN "pic/trainer/agatha.pic"
LancePic::         INCBIN "pic/trainer/lance.pic"
JessieJamesPic::   INCBIN "pic/ytrainer/jessiejames.pic"

	dr $4fe79,$50000


SECTION "bank14",ROMX,BANK[$14]

	dr $50000,$5267d
CeladonPrizeMenu:: ; 5267d (14:667d)
	dr $5267d,$54000

SECTION "bank15",ROMX,BANK[$15]

	dr $54000,$567cd
TrainerWalkUpToPlayer:: ; 567cd (15:67cd)
	dr $567cd,$57745
_GetSpritePosition1:: ; 57745 (15:7745)
	dr $57745,$57765
_GetSpritePosition2:: ; 57765 (15:7765)
	dr $57765,$57789
_SetSpritePosition1:: ; 57789 (15:7789)
	dr $57789,$577a9
_SetSpritePosition2:: ; 577a9 (15:77a9)
	dr $577a9,$58000

SECTION "bank16",ROMX,BANK[$16]

	dr $58000,$58e8b
PrintStatusAilment:: ; 58e8b (16:4e8b)
	dr $58e8b,$5c000


SECTION "bank17",ROMX,BANK[$17]

	dr $5c000,$60000


SECTION "bank18",ROMX,BANK[$18]

	dr $60000,$64000


SECTION "bank19",ROMX,BANK[$19]

	dr $64000,$68000


SECTION "bank1A",ROMX,BANK[$1A]

	dr $68000,$6c000


SECTION "bank1B",ROMX,BANK[$1B]

	dr $6c000,$70000


SECTION "bank1C",ROMX,BANK[$1C]

INCLUDE "engine/gamefreak.asm"
INCLUDE "engine/hall_of_fame.asm"
INCLUDE "engine/overworld/healing_machine.asm"
INCLUDE "engine/overworld/player_animations.asm"
INCLUDE "engine/battle/ghost_marowak_anim.asm"
INCLUDE "engine/battle/battle_transitions.asm"
INCLUDE "engine/town_map.asm"
AnimatePartyMon_ForceSpeed1:: ; 71784 (1c:5784)
	dr $71784,$7178c
AnimatePartyMon:: ; 7178c (1c:578c)
	dr $7178c,$717fe
LoadAnimSpriteGfx: ; 717fe (1c:57fe)
	dr $717fe,$71eb3
INCLUDE "engine/palettes.asm"

;PokemonYellowGraphics:  INCBIN "gfx/pokemon_yellow.t6.2bpp"

	dr $73959,$73e2e
SaveHallOfFameTeams: ; 73e2e (1c:7e2e)
	dr $73e2e,$74000


SECTION "bank1D",ROMX,BANK[$1D]

	dr $74000,$74726
VendingMachineMenu:: ; 74726 (1d:4726)
	dr $74726,$78000

SECTION "bank1E",ROMX,BANK[$1E]

	dr $78000,$78757
AnimationTileset2: ; 78757 (1e:4857)
	dr $78757,$79816
Func_79816: ; 79816 (1e:5816)
	dr $79816,$798b2
Func_798b2: ; 798b2 (1e:58b2)
	dr $798b2,$798c8
AnimationTransformMon: ; 798c8 (1e:58c8)
	dr $798c8,$798d4
Func_798d4: ; 798d4 (1e:58d4)
	dr $798d4,$7a19a
	
RedFishingTilesFront: INCBIN "gfx/red_fishing_tile_front.2bpp"
RedFishingTilesBack:  INCBIN "gfx/red_fishing_tile_back.2bpp"
RedFishingTilesSide:  INCBIN "gfx/red_fishing_tile_side.2bpp"
RedFishingRodTiles:   INCBIN "gfx/red_fishingrod_tiles.2bpp"

	dr $7a22a,$7c000


SECTION "bank1F",ROMX,BANK[$1F]

	dr $7c000,$7d10d
Func_7d10d:: ; 7d10d (1f:510d)
	dr $7d10d,$80000

SECTION "bank20",ROMX,BANK[$20]

	dr $80000,$80f14

SurfingPikachu1Graphics:  INCBIN "gfx/surfing_pikachu_1.t4.2bpp"
Func_82bd4:: ; 82bd4 (20:6bd4)
	dr $82bd4,$84000


SECTION "bank21",ROMX,BANK[$21]

	dr $84000,$88000


SECTION "bank22",ROMX,BANK[$22]

	dr $88000,$8c000


SECTION "bank23",ROMX,BANK[$23]

	dr $8c000,$90000


SECTION "bank24",ROMX,BANK[$24]

	dr $90000,$94000


SECTION "bank25",ROMX,BANK[$25]

	dr $94000,$98000


SECTION "bank2f",ROMX[$5000],BANK[$2F]

	dr $bd000,$bf450
Func_bf450:: ; bf450 (2f:7450)
	dr $bf450,$c0000
	
SECTION "bank30",ROMX,BANK[$30]

	dr $c0000,$c4000


SECTION "bank31",ROMX,BANK[$31]

	dr $c4000,$c8000


SECTION "bank32",ROMX,BANK[$32]

	dr $c8000,$cc000


SECTION "bank33",ROMX,BANK[$33]

	dr $cc000,$d0000


SECTION "bank34",ROMX,BANK[$34]

	dr $d0000,$d4000


SECTION "bank35",ROMX,BANK[$35]

	dr $d4000,$d8000


SECTION "bank36",ROMX,BANK[$36]

	dr $d8000,$dc000


SECTION "bank37",ROMX,BANK[$37]

	dr $dc000,$e0000


SECTION "bank38",ROMX,BANK[$38]

	dr $e0000,$e4000


SECTION "bank39",ROMX,BANK[$39]

	dr $e4000,$e8000


SECTION "bank3A",ROMX,BANK[$3A]
MonsterNames:: ; e8000 (3a:4000)
	dr $e8000,$e8a5e
Func_e8a5e:: ; e8a5e (3a:4a5e)
	dr $e8a5e,$e928a
SurfingPikachu2Graphics:  INCBIN "gfx/surfing_pikachu_2.2bpp"
	dr $e988a,$e9bfa

SurfingPikachu3Graphics:  INCBIN "gfx/surfing_pikachu_3.t1.2bpp"

	dr $ea3ea,$eaa02
FreezeEnemyTrainerSprite:: ; eaa02 (3a:6a02)
	dr $eaa02,$ec000

SECTION "bank3C",ROMX,BANK[$3C]

INCLUDE "engine/bank3c/main.asm"

SECTION "bank3D",ROMX,BANK[$3D]

INCLUDE "engine/bank3d/main.asm"

SECTION "bank3E",ROMX,BANK[$3E]

	dr $f8000,$fa35a

YellowIntroGraphics:  INCBIN "gfx/yellow_intro.2bpp"

	dr $fbb5a,$fc000

SECTION "bank3F",ROMX,BANK[$3F]

INCLUDE "engine/bank3f/main.asm"


;IF DEF(_OPTION_BEACH_HOUSE)
;SECTION "bank3C",ROMX[$4314],BANK[$3C]
;
;BeachHouse_GFX:
;	INCBIN "gfx/tilesets/beachhouse.2bpp"
;
;BeachHouse_Block:
;	INCBIN "gfx/blocksets/beachhouse.bst"
;ENDC
