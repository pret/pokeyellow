HiddenObjectMaps:
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
	db $ff

; format: y-coord, x-coord, text id/item id, object routine
hidden_object: macro
	db \1, \2, \3
	dba \4
	endm

SilphCo11FHiddenObjects:
	hidden_object  12,  10, SPRITE_FACING_UP, OpenPokemonCenterPC
	db $ff

SilphCo5FHiddenObjects:
	hidden_object   3,  12, ELIXER, HiddenItems
	db $ff

SilphCo9FHiddenObjects:
	hidden_object  15,   2, MAX_POTION, HiddenItems
	db $ff

Mansion2HiddenObjects:
	hidden_object  11,   2, SPRITE_FACING_UP, Mansion2Script_Switches
	db $ff

Mansion3HiddenObjects:
	hidden_object   9,   1, MAX_REVIVE, HiddenItems
	hidden_object   5,  10, SPRITE_FACING_UP, Mansion3Script_Switches
	db $ff

Mansion4HiddenObjects:
	hidden_object   9,   1, RARE_CANDY, HiddenItems
	hidden_object   3,  20, SPRITE_FACING_UP, Mansion4Script_Switches
	hidden_object  25,  18, SPRITE_FACING_UP, Mansion4Script_Switches
	db $ff

SafariZoneWestHiddenObjects:
	hidden_object   5,   6, REVIVE, HiddenItems
	db $ff

UnknownDungeon2HiddenObjects:
	hidden_object  13,  16, PP_UP, HiddenItems
	db $ff

UnknownDungeon3HiddenObjects:
	hidden_object  14,   8, PP_UP, HiddenItems
	db $ff

UnusedMap6FHiddenObjects:
	hidden_object  11,  14, MAX_ELIXER, HiddenItems
	db $ff

SeafoamIslands3HiddenObjects:
	hidden_object  15,  15, NUGGET, HiddenItems
	db $ff

SeafoamIslands4HiddenObjects:
	hidden_object  16,   9, MAX_ELIXER, HiddenItems
	db $ff

SeafoamIslands5HiddenObjects:
	hidden_object  17,  25, ULTRA_BALL, HiddenItems
	db $ff

ViridianForestHiddenObjects:
	hidden_object  18,   1, POTION, HiddenItems
	hidden_object  42,  16, ANTIDOTE, HiddenItems
	db $ff

MtMoon3HiddenObjects:
	hidden_object  12,  18, MOON_STONE, HiddenItems
	hidden_object   9,  33, ETHER, HiddenItems
	db $ff

SSAnne10HiddenObjects:
	hidden_object   1,   3, HYPER_POTION, HiddenItems
	db $ff

SSAnne6HiddenObjects:
	hidden_object   5,  13, SPRITE_FACING_DOWN, PrintTrashText
	hidden_object   7,  13, SPRITE_FACING_DOWN, PrintTrashText
	hidden_object   9,  13, GREAT_BALL, HiddenItems
	db $ff

UndergroundPathNsHiddenObjects:
	hidden_object   4,   3, FULL_RESTORE, HiddenItems
	hidden_object  34,   4, X_SPECIAL, HiddenItems
	db $ff

UndergroundPathWeHiddenObjects:
	hidden_object   2,  12, NUGGET, HiddenItems
	hidden_object   5,  21, ELIXER, HiddenItems
	db $ff

RocketHideout1HiddenObjects:
	hidden_object  15,  21, PP_UP, HiddenItems
	db $ff

RocketHideout3HiddenObjects:
	hidden_object  17,  27, NUGGET, HiddenItems
	db $ff

RocketHideout4HiddenObjects:
	hidden_object   1,  25, SUPER_POTION, HiddenItems
	db $ff

Route10HiddenObjects:
	hidden_object  17,   9, SUPER_POTION, HiddenItems
	hidden_object  53,  16, MAX_ETHER, HiddenItems
	db $ff

RockTunnelPokecenterHiddenObjects:
	hidden_object   4,   0, SPRITE_FACING_LEFT, PrintBenchGuyText
	hidden_object   3,  13, SPRITE_FACING_UP, OpenPokemonCenterPC
	db $ff

PowerPlantHiddenObjects:
	hidden_object  16,  17, MAX_ELIXER, HiddenItems
	hidden_object   1,  12, PP_UP, HiddenItems
	db $ff

Route11HiddenObjects:
	hidden_object   5,  48, ESCAPE_ROPE, HiddenItems
	db $ff

Route12HiddenObjects:
	hidden_object  63,   2, HYPER_POTION, HiddenItems
	db $ff

Route13HiddenObjects:
	hidden_object  14,   1, PP_UP, HiddenItems
	hidden_object  13,  16, CALCIUM, HiddenItems
	db $ff

Route15Gate2FHiddenObjects:
	hidden_object   2,   1, SPRITE_FACING_UP, Route15GateLeftBinoculars
	db $ff

Route17HiddenObjects:
	hidden_object  14,  15, RARE_CANDY, HiddenItems
	hidden_object  45,   8, FULL_RESTORE, HiddenItems
	hidden_object  72,  17, PP_UP, HiddenItems
	hidden_object  91,   4, MAX_REVIVE, HiddenItems
	hidden_object 121,   8, MAX_ELIXER, HiddenItems
	db $ff

Route23HiddenObjects:
	hidden_object  44,   9, FULL_RESTORE, HiddenItems
	hidden_object  70,  19, ULTRA_BALL, HiddenItems
	hidden_object  90,   8, MAX_ETHER, HiddenItems
	db $ff

VictoryRoad2HiddenObjects:
	hidden_object   2,   5, ULTRA_BALL, HiddenItems
	hidden_object   7,  26, FULL_RESTORE, HiddenItems
	db $ff

Route25HiddenObjects:
	hidden_object   3,  38, ETHER, HiddenItems
	hidden_object   1,  10, ELIXER, HiddenItems
	db $ff

BillsHouseHiddenObjects:
	hidden_object   4,   1, SPRITE_FACING_UP, BillsHousePC
	db $ff

Route4HiddenObjects:
	hidden_object   3,  40, GREAT_BALL, HiddenItems
	db $ff

MtMoonPokecenterHiddenObjects:
	hidden_object   4,   0, SPRITE_FACING_LEFT, PrintBenchGuyText
	hidden_object   3,  13, SPRITE_FACING_UP, OpenPokemonCenterPC
	db $ff

Route9HiddenObjects:
	hidden_object   7,  14, ETHER, HiddenItems
	db $ff

TradeCenterHiddenObjects:
	hidden_object   4,   5, $d0, CableClubRightGameboy
	hidden_object   4,   4, $d0, CableClubLeftGameboy
	db $ff

ColosseumHiddenObjects:
	hidden_object   4,   5, $d0, CableClubRightGameboy
	hidden_object   4,   4, $d0, CableClubLeftGameboy
	db $ff

IndigoPlateauHiddenObjects:
	hidden_object  13,   8, $ff, PrintIndigoPlateauHQText
	hidden_object  13,  11, SPRITE_FACING_DOWN, PrintIndigoPlateauHQText
	db $ff

IndigoPlateauLobbyHiddenObjects:
	hidden_object   7,  15, SPRITE_FACING_UP, OpenPokemonCenterPC
	db $ff

CopycatsHouse2FHiddenObjects:
	hidden_object   1,   1, NUGGET, HiddenItems
	db $ff

FightingDojoHiddenObjects:
	hidden_object   9,   3, SPRITE_FACING_UP, PrintFightingDojoText
	hidden_object   9,   6, SPRITE_FACING_UP, PrintFightingDojoText
	hidden_object   0,   4, SPRITE_FACING_UP, PrintFightingDojoText2
	hidden_object   0,   5, SPRITE_FACING_UP, PrintFightingDojoText3
	db $ff

SaffronGymHiddenObjects:
	hidden_object  15,   9, SPRITE_FACING_UP, GymStatues
	db $ff

SaffronPokecenterHiddenObjects:
	hidden_object   4,   0, SPRITE_FACING_UP, PrintBenchGuyText
	hidden_object   3,  13, SPRITE_FACING_UP, OpenPokemonCenterPC
	db $ff

RedsHouse2FHiddenObjects:
	hidden_object   1,   0, SPRITE_FACING_UP, OpenRedsPC
	hidden_object   5,   3, $d0, PrintRedSNESText
	db $ff

BluesHouseHiddenObjects:
	hidden_object   1,   0, SPRITE_FACING_UP, PrintBookcaseText
	hidden_object   1,   1, SPRITE_FACING_UP, PrintBookcaseText
	hidden_object   1,   7, SPRITE_FACING_UP, PrintBookcaseText
	db $ff

OaksLabHiddenObjects:
	hidden_object   0,   4, SPRITE_FACING_UP, DisplayOakLabLeftPoster
	hidden_object   0,   5, SPRITE_FACING_UP, DisplayOakLabRightPoster
	hidden_object   1,   0, SPRITE_FACING_UP, DisplayOakLabEmailText
	hidden_object   1,   1, SPRITE_FACING_UP, DisplayOakLabEmailText
	db $ff

ViridianCityHiddenObjects:
	hidden_object   4,  14, POTION, HiddenItems
	db $ff

ViridianPokecenterHiddenObjects:
	hidden_object   4,   0, SPRITE_FACING_LEFT, PrintBenchGuyText
	hidden_object   3,  13, SPRITE_FACING_UP, OpenPokemonCenterPC
	db $ff

ViridianSchoolHiddenObjects:
	hidden_object   4,   3, (ViridianSchoolNotebook_id - TextPredefs) / 2 + 1, PrintNotebookText
	hidden_object   0,   3, (ViridianSchoolBlackboard_id - TextPredefs) / 2 + 1, PrintBlackboardLinkCableText
	db $ff

ViridianGymHiddenObjects:
	hidden_object  15,  15, SPRITE_FACING_UP, GymStatues
	hidden_object  15,  18, SPRITE_FACING_UP, GymStatues
	db $ff

Museum1FHiddenObjects:
	hidden_object   3,   2, SPRITE_FACING_UP, AerodactylFossil
	hidden_object   6,   2, SPRITE_FACING_UP, KabutopsFossil
	db $ff

PewterGymHiddenObjects:
	hidden_object  10,   3, SPRITE_FACING_UP, GymStatues
	hidden_object  10,   6, SPRITE_FACING_UP, GymStatues
	db $ff

PewterPokecenterHiddenObjects:
	hidden_object   4,   0, SPRITE_FACING_LEFT, PrintBenchGuyText
	hidden_object   3,  13, SPRITE_FACING_UP, OpenPokemonCenterPC
	db $ff

CeruleanCityHiddenObjects:
	hidden_object   8,  15, RARE_CANDY, HiddenItems
	db $ff

CeruleanPokecenterHiddenObjects:
	hidden_object   4,   0, SPRITE_FACING_LEFT, PrintBenchGuyText
	hidden_object   3,  13, SPRITE_FACING_UP, OpenPokemonCenterPC
	db $ff

CeruleanGymHiddenObjects:
	hidden_object  11,   3, SPRITE_FACING_UP, GymStatues
	hidden_object  11,   6, SPRITE_FACING_UP, GymStatues
	db $ff

BikeShopHiddenObjects:
	hidden_object   0,   1, $d0, PrintNewBikeText
	hidden_object   1,   2, $d0, PrintNewBikeText
	hidden_object   2,   1, $d0, PrintNewBikeText
	hidden_object   2,   3, $d0, PrintNewBikeText
	hidden_object   4,   0, $d0, PrintNewBikeText
	hidden_object   5,   1, $d0, PrintNewBikeText
	db $ff

UnknownDungeon1HiddenObjects:
	hidden_object   7,  18, PP_UP, HiddenItems
	db $ff

LavenderPokecenterHiddenObjects:
	hidden_object   4,   0, SPRITE_FACING_LEFT, PrintBenchGuyText
	hidden_object   3,  13, SPRITE_FACING_UP, OpenPokemonCenterPC
	db $ff

Pokemontower5HiddenObjects:
	hidden_object  12,   4, ELIXER, HiddenItems
	db $ff

LavenderHouse1HiddenObjects:
	hidden_object   1,   0, SPRITE_FACING_DOWN, PrintMagazinesText
	hidden_object   1,   1, SPRITE_FACING_DOWN, PrintMagazinesText
	hidden_object   1,   7, SPRITE_FACING_DOWN, PrintMagazinesText
	db $ff

VermilionCityHiddenObjects:
	hidden_object  11,  14, MAX_ETHER, HiddenItems
	db $ff

VermilionPokecenterHiddenObjects:
	hidden_object   3,  13, SPRITE_FACING_UP, OpenPokemonCenterPC
	hidden_object   4,   0, SPRITE_FACING_UP, PrintBenchGuyText
	db $ff

PokemonFanClubHiddenObjects:
	hidden_object   0,   1, SPRITE_FACING_UP, FanClubPicture1
	hidden_object   0,   6, SPRITE_FACING_UP, FanClubPicture2
	db $ff

VermilionGymHiddenObjects:
	hidden_object  14,   3, SPRITE_FACING_UP, GymStatues
	hidden_object  14,   6, SPRITE_FACING_UP, GymStatues
	hidden_object   1,   6, SPRITE_FACING_DOWN, PrintTrashText
	hidden_object   7,   1, 0, GymTrashScript
	hidden_object   9,   1, 1, GymTrashScript
	hidden_object  11,   1, 2, GymTrashScript
	hidden_object   7,   3, 3, GymTrashScript
	hidden_object   9,   3, 4, GymTrashScript
	hidden_object  11,   3, 5, GymTrashScript
	hidden_object   7,   5, 6, GymTrashScript
	hidden_object   9,   5, 7, GymTrashScript
	hidden_object  11,   5, 8, GymTrashScript
	hidden_object   7,   7, 9, GymTrashScript
	hidden_object   9,   7, 10, GymTrashScript
	hidden_object  11,   7, 11, GymTrashScript
	hidden_object   7,   9, 12, GymTrashScript
	hidden_object   9,   9, 13, GymTrashScript
	hidden_object  11,   9, 14, GymTrashScript
	db $ff

CeladonCityHiddenObjects:
	hidden_object  15,  48, PP_UP, HiddenItems
	db $ff

CeladonHotelHiddenObjects:
	hidden_object   4,   0, SPRITE_FACING_LEFT, PrintBenchGuyText
	db $ff

CeladonMansion2HiddenObjects:
	hidden_object   5,   0, SPRITE_FACING_UP, OpenPokemonCenterPC
	db $ff

CeladonMansion5HiddenObjects:
	hidden_object   0,   3, (LinkCableHelp_id - TextPredefs) / 2 + 1, PrintBlackboardLinkCableText
	hidden_object   0,   4, (LinkCableHelp_id - TextPredefs) / 2 + 1, PrintBlackboardLinkCableText
	hidden_object   4,   3, (TMNotebook_id - TextPredefs) / 2 + 1, PrintNotebookText
	db $ff

CeladonPokecenterHiddenObjects:
	hidden_object   4,   0, SPRITE_FACING_LEFT, PrintBenchGuyText
	hidden_object   3,  13, SPRITE_FACING_UP, OpenPokemonCenterPC
	db $ff

CeladonGymHiddenObjects:
	hidden_object  15,   3, SPRITE_FACING_UP, GymStatues
	hidden_object  15,   6, SPRITE_FACING_UP, GymStatues
	db $ff

GameCornerHiddenObjects:
	hidden_object  15,  18, $d0, StartSlotMachine
	hidden_object  14,  18, $d0, StartSlotMachine
	hidden_object  13,  18, $d0, StartSlotMachine
	hidden_object  12,  18, $d0, StartSlotMachine
	hidden_object  11,  18, $d0, StartSlotMachine
	hidden_object  10,  18, $ff, StartSlotMachine ; "Someone's Keys"
	hidden_object  10,  13, $d0, StartSlotMachine
	hidden_object  11,  13, $d0, StartSlotMachine
	hidden_object  12,  13, $fe, StartSlotMachine ; "Out To Lunch"
	hidden_object  13,  13, $d0, StartSlotMachine
	hidden_object  14,  13, $d0, StartSlotMachine
	hidden_object  15,  13, $d0, StartSlotMachine
	hidden_object  15,  12, $d0, StartSlotMachine
	hidden_object  14,  12, $d0, StartSlotMachine
	hidden_object  13,  12, $d0, StartSlotMachine
	hidden_object  12,  12, $d0, StartSlotMachine
	hidden_object  11,  12, $d0, StartSlotMachine
	hidden_object  10,  12, $d0, StartSlotMachine
	hidden_object  10,   7, $d0, StartSlotMachine
	hidden_object  11,   7, $d0, StartSlotMachine
	hidden_object  12,   7, $d0, StartSlotMachine
	hidden_object  13,   7, $d0, StartSlotMachine
	hidden_object  14,   7, $d0, StartSlotMachine
	hidden_object  15,   7, $d0, StartSlotMachine
	hidden_object  15,   6, $d0, StartSlotMachine
	hidden_object  14,   6, $d0, StartSlotMachine
	hidden_object  13,   6, $d0, StartSlotMachine
	hidden_object  12,   6, $fd, StartSlotMachine ; "Out Of Order"
	hidden_object  11,   6, $d0, StartSlotMachine
	hidden_object  10,   6, $d0, StartSlotMachine
	hidden_object  10,   1, $d0, StartSlotMachine
	hidden_object  11,   1, $d0, StartSlotMachine
	hidden_object  12,   1, $d0, StartSlotMachine
	hidden_object  13,   1, $d0, StartSlotMachine
	hidden_object  14,   1, $d0, StartSlotMachine
	hidden_object  15,   1, $d0, StartSlotMachine
	hidden_object   8,   0, COIN + 10, HiddenCoins
	hidden_object  16,   1, COIN + 10, HiddenCoins
	hidden_object  11,   3, COIN + 20, HiddenCoins
	hidden_object  14,   3, COIN + 10, HiddenCoins
	hidden_object  12,   4, COIN + 10, HiddenCoins
	hidden_object  12,   9, COIN + 20, HiddenCoins
	hidden_object  15,   9, COIN + 10, HiddenCoins
	hidden_object  14,  16, COIN + 10, HiddenCoins
	hidden_object  16,  10, COIN + 10, HiddenCoins
	hidden_object   7,  11, COIN + 40, HiddenCoins
	hidden_object   8,  15, COIN + 100, HiddenCoins
	hidden_object  15,  12, COIN + 10, HiddenCoins
	db $ff

FuchsiaPokecenterHiddenObjects:
	hidden_object   3,  13, SPRITE_FACING_UP, OpenPokemonCenterPC
	hidden_object   4,   0, SPRITE_FACING_UP, PrintBenchGuyText
	db $ff

SafariZoneEntranceHiddenObjects:
	hidden_object   1,  10, NUGGET, HiddenItems
	db $ff

FuchsiaGymHiddenObjects:
	hidden_object  15,   3, SPRITE_FACING_UP, GymStatues
	hidden_object  15,   6, SPRITE_FACING_UP, GymStatues
	db $ff

Mansion1HiddenObjects:
	hidden_object  16,   8, MOON_STONE, HiddenItems
	hidden_object   5,   2, SPRITE_FACING_UP, Mansion1Script_Switches
	db $ff

CinnabarGymHiddenObjects:
	hidden_object  13,  17, SPRITE_FACING_UP, GymStatues
	hidden_object   7,  15, (0 << 4) | 1, PrintCinnabarQuiz
	hidden_object   1,  10, (1 << 4) | 2, PrintCinnabarQuiz
	hidden_object   7,   9, (1 << 4) | 3, PrintCinnabarQuiz
	hidden_object  13,   9, (1 << 4) | 4, PrintCinnabarQuiz
	hidden_object  13,   1, (0 << 4) | 5, PrintCinnabarQuiz
	hidden_object   7,   1, (1 << 4) | 6, PrintCinnabarQuiz
	db $ff

CinnabarLab4HiddenObjects:
	hidden_object   4,   0, SPRITE_FACING_UP, OpenPokemonCenterPC
	hidden_object   4,   2, SPRITE_FACING_UP, OpenPokemonCenterPC
	db $ff

CinnabarPokecenterHiddenObjects:
	hidden_object   4,   0, SPRITE_FACING_UP, PrintBenchGuyText
	hidden_object   3,  13, SPRITE_FACING_UP, OpenPokemonCenterPC
	db $ff
