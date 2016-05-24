HiddenObjectMaps: ; f268d (3c:668d)
	dbw SILPH_CO_11F,           SilphCo11FHiddenObjects
	dbw SILPH_CO_5F,            SilphCo5FHiddenObjects
	dbw SILPH_CO_9F,            SilphCo9FHiddenObjects
	dbw MANSION_2,              Mansion2HiddenObjects
	dbw MANSION_3,              Mansion3HiddenObjects
	dbw MANSION_4,              Mansion4HiddenObjects
	dbw SAFARI_ZONE_WEST,       SafariZoneWestHiddenObjects
	dbw UNKNOWN_DUNGEON_2,      UnknownDungeon2HiddenObjects
	dbw UNKNOWN_DUNGEON_3,      UnknownDungeon3HiddenObjects
	dbw UNUSED_MAP_6F,          UnusedMap6FHiddenObjects
	dbw SEAFOAM_ISLANDS_3,      SeafoamIslands3HiddenObjects
	dbw SEAFOAM_ISLANDS_4,      SeafoamIslands4HiddenObjects
	dbw SEAFOAM_ISLANDS_5,      SeafoamIslands5HiddenObjects
	dbw VIRIDIAN_FOREST,        ViridianForestHiddenObjects
	dbw MT_MOON_3,              MtMoon3HiddenObjects
	dbw SS_ANNE_10,             SSAnne10HiddenObjects
	dbw SS_ANNE_6,              SSAnne6HiddenObjects
	dbw UNDERGROUND_PATH_NS,    UndergroundPathNsHiddenObjects
	dbw UNDERGROUND_PATH_WE,    UndergroundPathWeHiddenObjects
	dbw ROCKET_HIDEOUT_1,       RocketHideout1HiddenObjects
	dbw ROCKET_HIDEOUT_3,       RocketHideout3HiddenObjects
	dbw ROCKET_HIDEOUT_4,       RocketHideout4HiddenObjects
	dbw ROUTE_10,               Route10HiddenObjects
	dbw ROCK_TUNNEL_POKECENTER, RockTunnelPokecenterHiddenObjects
	dbw POWER_PLANT,            PowerPlantHiddenObjects
	dbw ROUTE_11,               Route11HiddenObjects
	dbw ROUTE_12,               Route12HiddenObjects
	dbw ROUTE_13,               Route13HiddenObjects
	dbw ROUTE_15_GATE_2F,       Route15Gate2FHiddenObjects
	dbw ROUTE_17,               Route17HiddenObjects
	dbw ROUTE_23,               Route23HiddenObjects
	dbw VICTORY_ROAD_2,         VictoryRoad2HiddenObjects
	dbw ROUTE_25,               Route25HiddenObjects
	dbw BILLS_HOUSE,            BillsHouseHiddenObjects
	dbw ROUTE_4,                Route4HiddenObjects
	dbw MT_MOON_POKECENTER,     MtMoonPokecenterHiddenObjects
	dbw ROUTE_9,                Route9HiddenObjects
	dbw TRADE_CENTER,           TradeCenterHiddenObjects
	dbw COLOSSEUM,              ColosseumHiddenObjects
	dbw INDIGO_PLATEAU,         IndigoPlateauHiddenObjects
	dbw INDIGO_PLATEAU_LOBBY,   IndigoPlateauLobbyHiddenObjects
	dbw COPYCATS_HOUSE_2F,      CopycatsHouse2FHiddenObjects
	dbw FIGHTING_DOJO,          FightingDojoHiddenObjects
	dbw SAFFRON_GYM,            SaffronGymHiddenObjects
	dbw SAFFRON_POKECENTER,     SaffronPokecenterHiddenObjects
	dbw REDS_HOUSE_2F,          RedsHouse2FHiddenObjects
	dbw BLUES_HOUSE,            BluesHouseHiddenObjects
	dbw OAKS_LAB,               OaksLabHiddenObjects
	dbw VIRIDIAN_CITY,          ViridianCityHiddenObjects
	dbw VIRIDIAN_POKECENTER,    ViridianPokecenterHiddenObjects
	dbw VIRIDIAN_SCHOOL,        ViridianSchoolHiddenObjects
	dbw VIRIDIAN_GYM,           ViridianGymHiddenObjects
	dbw MUSEUM_1F,              Museum1FHiddenObjects
	dbw PEWTER_GYM,             PewterGymHiddenObjects
	dbw PEWTER_POKECENTER,      PewterPokecenterHiddenObjects
	dbw CERULEAN_CITY,          CeruleanCityHiddenObjects
	dbw CERULEAN_POKECENTER,    CeruleanPokecenterHiddenObjects
	dbw CERULEAN_GYM,           CeruleanGymHiddenObjects
	dbw BIKE_SHOP,              BikeShopHiddenObjects
	dbw UNKNOWN_DUNGEON_1,      UnknownDungeon1HiddenObjects
	dbw LAVENDER_POKECENTER,    LavenderPokecenterHiddenObjects
	dbw POKEMONTOWER_5,         Pokemontower5HiddenObjects
	dbw LAVENDER_HOUSE_1,       LavenderHouse1HiddenObjects
	dbw VERMILION_CITY,         VermilionCityHiddenObjects
	dbw VERMILION_POKECENTER,   VermilionPokecenterHiddenObjects
	dbw POKEMON_FAN_CLUB,       PokemonFanClubHiddenObjects
	dbw VERMILION_GYM,          VermilionGymHiddenObjects
	dbw CELADON_CITY,           CeladonCityHiddenObjects
	dbw CELADON_HOTEL,          CeladonHotelHiddenObjects
	dbw CELADON_MANSION_2,      CeladonMansion2HiddenObjects
	dbw CELADON_MANSION_5,      CeladonMansion5HiddenObjects
	dbw CELADON_POKECENTER,     CeladonPokecenterHiddenObjects
	dbw CELADON_GYM,            CeladonGymHiddenObjects
	dbw GAME_CORNER,            GameCornerHiddenObjects
	dbw FUCHSIA_POKECENTER,     FuchsiaPokecenterHiddenObjects
	dbw SAFARI_ZONE_ENTRANCE,   SafariZoneEntranceHiddenObjects
	dbw FUCHSIA_GYM,            FuchsiaGymHiddenObjects
	dbw MANSION_1,              Mansion1HiddenObjects
	dbw CINNABAR_GYM,           CinnabarGymHiddenObjects
	dbw CINNABAR_LAB_4,         CinnabarLab4HiddenObjects
	dbw CINNABAR_POKECENTER,    CinnabarPokecenterHiddenObjects
	db $FF

; format: y-coord, x-coord, text id/item id, object routine
TradeCenterHiddenObjects: ; 46b40 (11:6b40)
	db $04,$05,$d0
	dba CableClubRightGameboy
	db $04,$04,$d0
	dba CableClubLeftGameboy
	db $FF
ColosseumHiddenObjects: ; 46b4d (11:6b4d)
	db $04,$05,$d0
	dba CableClubRightGameboy
	db $04,$04,$d0
	dba CableClubLeftGameboy
	db $FF
RedsHouse2FHiddenObjects: ; 46b5a (11:6b5a)
	db $01,$00,$04
	dba OpenRedsPC
	db $05,$03,$d0
	dba PrintRedsNESText
	db $FF
BluesHouseHiddenObjects: ; 46b67 (11:6b67)
	db $01,$00,$04
	dba PrintBookcaseText
	db $01,$01,$04
	dba PrintBookcaseText
	db $01,$07,$04
	dba PrintBookcaseText
	db $FF
OaksLabHiddenObjects: ; 46b7a (11:6b7a)
	db $00,$04,$04
	dba DisplayOakLabLeftPoster
	db $00,$05,$04
	dba DisplayOakLabRightPoster
	db $01,$00,$04
	dba DisplayOakLabEmailText
	db $01,$01,$04
	dba DisplayOakLabEmailText
	db $FF
ViridianPokecenterHiddenObjects: ; 46b93 (11:6b93)
	db $04,$00,$08
	dba PrintBenchGuyText
	db $03,$0d,$04
	dba OpenPokemonCenterPC
	db $FF
ViridianMartHiddenObjects: ; 46ba0 (11:6ba0)
	db $FF
ViridianSchoolHiddenObjects: ; 46ba1 (11:6ba1)
	db $04,$03,(ViridianSchoolNotebook_id - TextPredefs) / 2 + 1
	dba PrintNotebookText
	db $00,$03,(ViridianSchoolBlackboard_id - TextPredefs) / 2 + 1
	dba PrintBlackboardLinkCableText
	db $FF
ViridianGymHiddenObjects: ; 46bae (11:6bae)
	db $0f,$0f,$04
	dbw BANK(GymStatues),GymStatues
	db $0f,$12,$04
	dbw BANK(GymStatues),GymStatues
	db $FF
Museum1FHiddenObjects: ; 46bbb (11:6bbb)
	db $03,$02,$04
	dba AerodactylFossil
	db $06,$02,$04
	dba KabutopsFossil
	db $FF
PewterGymHiddenObjects: ; 46bc8 (11:6bc8)
	db $0a,$03,$04
	dbw BANK(GymStatues),GymStatues
	db $0a,$06,$04
	dbw BANK(GymStatues),GymStatues
	db $FF
PewterMartHiddenObjects: ; 46bd5 (11:6bd5)
	db $FF
PewterPokecenterHiddenObjects: ; 46bd6 (11:6bd6)
	db $04,$00,$08
	dba PrintBenchGuyText
	db $03,$0d,$04
	dba OpenPokemonCenterPC
	db $FF
CeruleanPokecenterHiddenObjects: ; 46be3 (11:6be3)
	db $04,$00,$08
	dba PrintBenchGuyText
	db $03,$0d,$04
	dba OpenPokemonCenterPC
	db $FF
CeruleanGymHiddenObjects: ; 46bf0 (11:6bf0)
	db $0b,$03,$04
	dbw BANK(GymStatues),GymStatues
	db $0b,$06,$04
	dbw BANK(GymStatues),GymStatues
	db $FF
CeruleanMartHiddenObjects: ; 46bfd (11:6bfd)
	db $FF
LavenderPokecenterHiddenObjects: ; 46bfe (11:6bfe)
	db $04,$00,$08
	dba PrintBenchGuyText
	db $03,$0d,$04
	dba OpenPokemonCenterPC
	db $FF
VermilionPokecenterHiddenObjects: ; 46c0b (11:6c0b)
	db $03,$0d,$04
	dba OpenPokemonCenterPC
	db $04,$00,$04
	dba PrintBenchGuyText
	db $FF
VermilionGymHiddenObjects: ; 46c18 (11:6c18)
	db $0e,$03,$04
	dba GymStatues
	db $0e,$06,$04
	dba GymStatues
	db $01,$06,$00
	dba PrintTrashText
	db $07,$01,$00
	dba GymTrashScript
	db $09,$01,$01
	dba GymTrashScript
	db $0b,$01,$02
	dba GymTrashScript
	db $07,$03,$03
	dba GymTrashScript
	db $09,$03,$04
	dba GymTrashScript
	db $0b,$03,$05
	dba GymTrashScript
	db $07,$05,$06
	dba GymTrashScript
	db $09,$05,$07
	dba GymTrashScript
	db $0b,$05,$08
	dba GymTrashScript
	db $07,$07,$09
	dba GymTrashScript
	db $09,$07,$0a
	dba GymTrashScript
	db $0b,$07,$0b
	dba GymTrashScript
	db $07,$09,$0c
	dba GymTrashScript
	db $09,$09,$0d
	dba GymTrashScript
	db $0b,$09,$0e
	dba GymTrashScript
	db $FF
CeladonMansion2HiddenObjects: ; 46c85 (11:6c85)
	db $05,$00,$04
	dba OpenPokemonCenterPC
	db $FF
CeladonPokecenterHiddenObjects: ; 46c8c (11:6c8c)
	db $04,$00,$08
	dba PrintBenchGuyText
	db $03,$0d,$04
	dba OpenPokemonCenterPC
	db $FF
CeladonGymHiddenObjects: ; 46c99 (11:6c99)
	db $0f,$03,$04
	dbw BANK(GymStatues),GymStatues
	db $0f,$06,$04
	dbw BANK(GymStatues),GymStatues
	db $FF
GameCornerHiddenObjects: ; 46ca6 (11:6ca6)
	db $0f,$12,$d0
	dba StartSlotMachine
	db $0e,$12,$d0
	dba StartSlotMachine
	db $0d,$12,$d0
	dba StartSlotMachine
	db $0c,$12,$d0
	dba StartSlotMachine
	db $0b,$12,$d0
	dba StartSlotMachine
	db $0a,$12,$ff ; "Someone's Keys"
	dba StartSlotMachine
	db $0a,$0d,$d0
	dba StartSlotMachine
	db $0b,$0d,$d0
	dba StartSlotMachine
	db $0c,$0d,$fe ; "Out To Lunch"
	dba StartSlotMachine
	db $0d,$0d,$d0
	dba StartSlotMachine
	db $0e,$0d,$d0
	dba StartSlotMachine
	db $0f,$0d,$d0
	dba StartSlotMachine
	db $0f,$0c,$d0
	dba StartSlotMachine
	db $0e,$0c,$d0
	dba StartSlotMachine
	db $0d,$0c,$d0
	dba StartSlotMachine
	db $0c,$0c,$d0
	dba StartSlotMachine
	db $0b,$0c,$d0
	dba StartSlotMachine
	db $0a,$0c,$d0
	dba StartSlotMachine
	db $0a,$07,$d0
	dba StartSlotMachine
	db $0b,$07,$d0
	dba StartSlotMachine
	db $0c,$07,$d0
	dba StartSlotMachine
	db $0d,$07,$d0
	dba StartSlotMachine
	db $0e,$07,$d0
	dba StartSlotMachine
	db $0f,$07,$d0
	dba StartSlotMachine
	db $0f,$06,$d0
	dba StartSlotMachine
	db $0e,$06,$d0
	dba StartSlotMachine
	db $0d,$06,$d0
	dba StartSlotMachine
	db $0c,$06,$fd ; "Out Of Order"
	dba StartSlotMachine
	db $0b,$06,$d0
	dba StartSlotMachine
	db $0a,$06,$d0
	dba StartSlotMachine
	db $0a,$01,$d0
	dba StartSlotMachine
	db $0b,$01,$d0
	dba StartSlotMachine
	db $0c,$01,$d0
	dba StartSlotMachine
	db $0d,$01,$d0
	dba StartSlotMachine
	db $0e,$01,$d0
	dba StartSlotMachine
	db $0f,$01,$d0
	dba StartSlotMachine
	db $08,$00,COIN+10
	dbw BANK(HiddenCoins),HiddenCoins
	db $10,$01,COIN+10
	dbw BANK(HiddenCoins),HiddenCoins
	db $0b,$03,COIN+20
	dbw BANK(HiddenCoins),HiddenCoins
	db $0e,$03,COIN+10
	dbw BANK(HiddenCoins),HiddenCoins
	db $0c,$04,COIN+10
	dbw BANK(HiddenCoins),HiddenCoins
	db $0c,$09,COIN+20
	dbw BANK(HiddenCoins),HiddenCoins
	db $0f,$09,COIN+10
	dbw BANK(HiddenCoins),HiddenCoins
	db $0e,$10,COIN+10
	dbw BANK(HiddenCoins),HiddenCoins
	db $10,$0a,COIN+10
	dbw BANK(HiddenCoins),HiddenCoins
	db $07,$0b,COIN+40
	dbw BANK(HiddenCoins),HiddenCoins
	db $08,$0f,COIN+100
	dbw BANK(HiddenCoins),HiddenCoins
	db $0f,$0c,COIN+10
	dbw BANK(HiddenCoins),HiddenCoins
	db $FF
CeladonHotelHiddenObjects: ; 46dc7 (11:6dc7)
	db $03,$0d,$04
	dba OpenPokemonCenterPC
	db $04,$00,$08
	dba PrintBenchGuyText
	db $FF
FuchsiaPokecenterHiddenObjects: ; 46dd4 (11:6dd4)
	db $03,$0d,$04
	dba OpenPokemonCenterPC
	db $04,$00,$04
	dba PrintBenchGuyText
	db $FF
FuchsiaGymHiddenObjects: ; 46de1 (11:6de1)
	db $0f,$03,$04
	dbw BANK(GymStatues),GymStatues
	db $0f,$06,$04
	dbw BANK(GymStatues),GymStatues
	db $FF
CinnabarGymHiddenObjects: ; 46dee (11:6dee)
	db $0d,$11,$04
	dbw BANK(GymStatues),GymStatues
	db $07,$0f,$01
	dba PrintCinnabarQuiz
	db $01,$0a,$12
	dba PrintCinnabarQuiz
	db $07,$09,$13
	dba PrintCinnabarQuiz
	db $0d,$09,$14
	dba PrintCinnabarQuiz
	db $0d,$01,$05
	dba PrintCinnabarQuiz
	db $07,$01,$16
	dba PrintCinnabarQuiz
	db $FF
CinnabarPokecenterHiddenObjects: ; 46e19 (11:6e19)
	db $04,$00,$04
	dba PrintBenchGuyText
	db $03,$0d,$04
	dba OpenPokemonCenterPC
	db $FF
SaffronGymHiddenObjects: ; 46e26 (11:6e26)
	db $0f,$09,$04
	dbw BANK(GymStatues),GymStatues
	db $FF
MtMoonPokecenterHiddenObjects: ; 46e2d (11:6e2d)
	db $04,$00,$08
	dba PrintBenchGuyText
	db $03,$0d,$04
	dba OpenPokemonCenterPC
	db $FF
RockTunnelPokecenterHiddenObjects: ; 46e3a (11:6e3a)
	db $04,$00,$08
	dba PrintBenchGuyText
	db $03,$0d,$04
	dba OpenPokemonCenterPC
	db $FF
ViridianForestHiddenObjects: ; 46e47 (11:6e47)
	db $12,$01,POTION
	dbw BANK(HiddenItems),HiddenItems
	db $2a,$10,ANTIDOTE
	dbw BANK(HiddenItems),HiddenItems
	db $FF
MtMoon3HiddenObjects: ; 46e54 (11:6e54)
	db $0c,$12,MOON_STONE
	dbw BANK(HiddenItems),HiddenItems
	db $09,$21,ETHER
	dbw BANK(HiddenItems),HiddenItems
	db $FF
IndigoPlateauHiddenObjects: ; 46e61 (11:6e61)
	db $0d,$08,$ff
	dba PrintIndigoPlateauHQText
	db $0d,$0b,$00
	dba PrintIndigoPlateauHQText
	db $FF
Route25HiddenObjects: ; 46e6e (11:6e6e)
	db $03,$26,ETHER
	dbw BANK(HiddenItems),HiddenItems
	db $01,$0a,ELIXER
	dbw BANK(HiddenItems),HiddenItems
	db $FF
Route9HiddenObjects: ; 46e7b (11:6e7b)
	db $07,$0e,ETHER
	dbw BANK(HiddenItems),HiddenItems
	db $FF
SSAnne6HiddenObjects: ; 46e82 (11:6e82)
	db $05,$0d,$00
	dba PrintTrashText
	db $07,$0d,$00
	dba PrintTrashText
	db $09,$0d,GREAT_BALL
	dbw BANK(HiddenItems),HiddenItems
	db $FF
SSAnne10HiddenObjects: ; 46e95 (11:6e95)
	db $01,$03,HYPER_POTION
	dbw BANK(HiddenItems),HiddenItems
	db $FF
Route10HiddenObjects: ; 46e9c (11:6e9c)
	db $11,$09,SUPER_POTION
	dbw BANK(HiddenItems),HiddenItems
	db $35,$10,MAX_ETHER
	dbw BANK(HiddenItems),HiddenItems
	db $FF
RocketHideout1HiddenObjects: ; 46ea9 (11:6ea9)
	db $0f,$15,PP_UP
	dbw BANK(HiddenItems),HiddenItems
	db $FF
RocketHideout3HiddenObjects: ; 46eb0 (11:6eb0)
	db $11,$1b,NUGGET
	dbw BANK(HiddenItems),HiddenItems
	db $FF
RocketHideout4HiddenObjects: ; 46eb7 (11:6eb7)
	db $01,$19,SUPER_POTION
	dbw BANK(HiddenItems),HiddenItems
	db $FF
SaffronPokecenterHiddenObjects: ; 46ebe (11:6ebe)
	db $04,$00,$04
	dba PrintBenchGuyText
	db $03,$0d,$04
	dba OpenPokemonCenterPC
	db $FF
PokemonTower5HiddenObjects: ; 46ecb (11:6ecb)
	db $0c,$04,ELIXER
	dbw BANK(HiddenItems),HiddenItems
	db $FF
Route13HiddenObjects: ; 46ed2 (11:6ed2)
	db $0e,$01,PP_UP
	dbw BANK(HiddenItems),HiddenItems
	db $0d,$10,CALCIUM
	dbw BANK(HiddenItems),HiddenItems
	db $FF
SafariZoneEntranceHiddenObjects: ; 46edf (11:6edf)
	db $01,$0a,NUGGET
	dbw BANK(HiddenItems),HiddenItems
	db $FF
SafariZoneWestHiddenObjects: ; 46ee6 (11:6ee6)
	db $05,$06,REVIVE
	dbw BANK(HiddenItems),HiddenItems
	db $FF
SilphCo5FHiddenObjects: ; 46eed (11:6eed)
	db $03,$0c,ELIXER
	dbw BANK(HiddenItems),HiddenItems
	db $FF
SilphCo9FHiddenObjects: ; 46ef4 (11:6ef4)
	db $0f,$02,MAX_POTION
	dbw BANK(HiddenItems),HiddenItems
	db $FF
CopycatsHouse2FHiddenObjects: ; 46efb (11:6efb)
	db $01,$01,NUGGET
	dbw BANK(HiddenItems),HiddenItems
	db $FF
UnknownDungeon1HiddenObjects: ; 46f02 (11:6f02)
	db $0b,$0e,RARE_CANDY
	dbw BANK(HiddenItems),HiddenItems
	db $FF
UnknownDungeon3HiddenObjects: ; 46f09 (11:6f09)
	db $03,$1b,ULTRA_BALL
	dbw BANK(HiddenItems),HiddenItems
	db $FF
PowerPlantHiddenObjects: ; 46f10 (11:6f10)
	db $10,$11,MAX_ELIXER
	dbw BANK(HiddenItems),HiddenItems
	db $01,$0c,PP_UP
	dbw BANK(HiddenItems),HiddenItems
	db $FF
SeafoamIslands3HiddenObjects: ; 46f1d (11:6f1d)
	db $0f,$0f,NUGGET
	dbw BANK(HiddenItems),HiddenItems
	db $FF
SeafoamIslands5HiddenObjects: ; 46f24 (11:6f24)
	db $11,$19,ULTRA_BALL
	dbw BANK(HiddenItems),HiddenItems
	db $FF
Mansion1HiddenObjects: ; 46f2b (11:6f2b)
	db $10,$08,MOON_STONE
	dbw BANK(HiddenItems),HiddenItems
	db $05,$02,$04
	dba Mansion1Script_Switches
	db $FF
Mansion2HiddenObjects: ; 46f38 (11:6f38)
	db $0b,$02,$04
	dba Mansion2Script_Switches
	db $FF
Mansion3HiddenObjects: ; 46f3f (11:6f3f)
	db $09,$01,MAX_REVIVE
	dbw BANK(HiddenItems),HiddenItems
	db $05,$0a,$04
	dba Mansion3Script_Switches
	db $FF
Mansion4HiddenObjects: ; 46f4c (11:6f4c)
	db $09,$01,RARE_CANDY
	dbw BANK(HiddenItems),HiddenItems
	db $03,$14,$04
	dba Mansion4Script_Switches
	db $19,$12,$04
	dba Mansion4Script_Switches
	db $FF
Route23HiddenObjects: ; 46f5f (11:6f5f)
	db $2c,$09,FULL_RESTORE
	dbw BANK(HiddenItems),HiddenItems
	db $46,$13,ULTRA_BALL
	dbw BANK(HiddenItems),HiddenItems
	db $5a,$08,MAX_ETHER
	dbw BANK(HiddenItems),HiddenItems
	db $FF
VictoryRoad2HiddenObjects: ; 46f72 (11:6f72)
	db $02,$05,ULTRA_BALL
	dbw BANK(HiddenItems),HiddenItems
	db $07,$1a,FULL_RESTORE
	dbw BANK(HiddenItems),HiddenItems
	db $FF
Unused6FHiddenObjects: ; 46f7f (11:6f7f)
	db $0b,$0e,MAX_ELIXER
	dbw BANK(HiddenItems),HiddenItems
	db $FF
BillsHouseHiddenObjects: ; 46f86 (11:6f86)
	db $04,$01,$04
	dba BillsHousePC
	db $FF
ViridianCityHiddenObjects: ; 46f8d (11:6f8d)
	db $04,$0e,POTION
	dbw BANK(HiddenItems),HiddenItems
	db $FF
SafariZoneRestHouse2HiddenObjects: ; 46f94 (11:6f94)
	db $04,$00,$08
	dba PrintBenchGuyText
	db $03,$0d,$04
	dba OpenPokemonCenterPC
	db $FF
SafariZoneRestHouse3HiddenObjects: ; 46fa1 (11:6fa1)
	db $04,$00,$08
	dba PrintBenchGuyText
	db $03,$0d,$04
	dba OpenPokemonCenterPC
	db $FF
SafariZoneRestHouse4HiddenObjects: ; 46fae (11:6fae)
	db $04,$00,$08
	dba PrintBenchGuyText
	db $03,$0d,$04
	dba OpenPokemonCenterPC
	db $FF
Route15GateUpstairsHiddenObjects: ; 46fbb (11:6fbb)
	db $02,$01,$04
	dba Route15GateLeftBinoculars
	db $FF
LavenderHouse1HiddenObjects: ; 46fc2 (11:6fc2)
	db $01,$00,$00
	dba PrintMagazinesText
	db $01,$01,$00
	dba PrintMagazinesText
	db $01,$07,$00
	dba PrintMagazinesText
	db $FF
CeladonMansion5HiddenObjects: ; 46fd5 (11:6fd5)
	db $00,$03,(LinkCableHelp_id - TextPredefs) / 2 + 1
	dba PrintBlackboardLinkCableText
	db $00,$04,(LinkCableHelp_id - TextPredefs) / 2 + 1
	dba PrintBlackboardLinkCableText
	db $04,$03,(TMNotebook_id - TextPredefs) / 2 + 1
	dba PrintNotebookText
	db $FF
FightingDojoHiddenObjects: ; 46fe8 (11:6fe8)
	db $09,$03,$04
	dba PrintFightingDojoText
	db $09,$06,$04
	dba PrintFightingDojoText
	db $00,$04,$04
	dba PrintFightingDojoText2
	db $00,$05,$04
	dba PrintFightingDojoText3
	db $FF
IndigoPlateauLobbyHiddenObjects: ; 47001 (11:7001)
	db $07,$0f,$04
	dba OpenPokemonCenterPC
	db $FF
CinnabarLab4HiddenObjects: ; 47008 (11:7008)
	db $04,$00,$04
	dba OpenPokemonCenterPC
	db $04,$02,$04
	dba OpenPokemonCenterPC
	db $FF
BikeShopHiddenObjects: ; 47015 (11:7015)
	db $00,$01,$d0
	dba PrintNewBikeText
	db $01,$02,$d0
	dba PrintNewBikeText
	db $02,$01,$d0
	dba PrintNewBikeText
	db $02,$03,$d0
	dba PrintNewBikeText
	db $04,$00,$d0
	dba PrintNewBikeText
	db $05,$01,$d0
	dba PrintNewBikeText
	db $FF
Route11HiddenObjects: ; 4703a (11:703a)
	db $05,$30,ESCAPE_ROPE
	dbw BANK(HiddenItems),HiddenItems
	db $FF
Route12HiddenObjects: ; 47041 (11:7041)
	db $3f,$02,HYPER_POTION
	dbw BANK(HiddenItems),HiddenItems
	db $FF
SilphCo11FHiddenObjects: ; 47048 (11:7048)
	db $0c,$0a,$04
	dba OpenPokemonCenterPC
	db $FF
Route17HiddenObjects: ; 4704f (11:704f)
	db $0e,$0f,RARE_CANDY
	dbw BANK(HiddenItems),HiddenItems
	db $2d,$08,FULL_RESTORE
	dbw BANK(HiddenItems),HiddenItems
	db $48,$11,PP_UP
	dbw BANK(HiddenItems),HiddenItems
	db $5b,$04,MAX_REVIVE
	dbw BANK(HiddenItems),HiddenItems
	db $79,$08,MAX_ELIXER
	dbw BANK(HiddenItems),HiddenItems
	db $FF
UndergroundPathNsHiddenObjects: ; 4706e (11:706e)
	db $04,$03,FULL_RESTORE
	dbw BANK(HiddenItems),HiddenItems
	db $22,$04,X_SPECIAL
	dbw BANK(HiddenItems),HiddenItems
	db $FF
UndergroundPathWeHiddenObjects: ; 4707b (11:707b)
	db $02,$0c,NUGGET
	dbw BANK(HiddenItems),HiddenItems
	db $05,$15,ELIXER
	dbw BANK(HiddenItems),HiddenItems
	db $FF
CeladonCityHiddenObjects: ; 47088 (11:7088)
	db $0f,$30,PP_UP
	dbw BANK(HiddenItems),HiddenItems
	db $FF
SeafoamIslands4HiddenObjects: ; 4708f (11:708f)
	db $10,$09,MAX_ELIXER
	dbw BANK(HiddenItems),HiddenItems
	db $FF
VermilionCityHiddenObjects: ; 47096 (11:7096)
	db $0b,$0e,MAX_ETHER
	dbw BANK(HiddenItems),HiddenItems
	db $FF
CeruleanCityHiddenObjects: ; 4709d (11:709d)
	db $08,$0f,RARE_CANDY
	dbw BANK(HiddenItems),HiddenItems
	db $FF
Route4HiddenObjects: ; 470a4 (11:70a4)
	db $03,$28,GREAT_BALL
	dbw BANK(HiddenItems),HiddenItems
	db $FF
