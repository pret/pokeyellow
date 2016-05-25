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
SilphCo11FHiddenObjects:
	db $0c, $0a, SPRITE_FACING_UP
	dba OpenPokemonCenterPC
	db $FF
SilphCo5FHiddenObjects:
	db $03, $0c, ELIXER
	dba HiddenItems
	db $FF
SilphCo9FHiddenObjects:
	db $0f, $02, MAX_POTION
	dba HiddenItems
	db $FF
Mansion2HiddenObjects:
	db $0b, $02, SPRITE_FACING_UP
	dba Mansion2Script_Switches
	db $FF
Mansion3HiddenObjects:
	db $09, $01, MAX_REVIVE
	dba HiddenItems
	db $05, $0a, SPRITE_FACING_UP
	dba Mansion3Script_Switches
	db $FF
Mansion4HiddenObjects:
	db $09, $01, RARE_CANDY
	dba HiddenItems
	db $03, $14, SPRITE_FACING_UP
	dba Mansion4Script_Switches
	db $19, $12, SPRITE_FACING_UP
	dba Mansion4Script_Switches
	db $FF
SafariZoneWestHiddenObjects:
	db $05, $06, REVIVE
	dba HiddenItems
	db $FF
UnknownDungeon2HiddenObjects:
	db $0d, $10, PP_UP
	dba HiddenItems
	db $FF
UnknownDungeon3HiddenObjects:
	db $0e, $08, PP_UP
	dba HiddenItems
	db $FF
UnusedMap6FHiddenObjects:
	db $0b, $0e, MAX_ELIXER
	dba HiddenItems
	db $FF
SeafoamIslands3HiddenObjects:
	db $0f, $0f, NUGGET
	dba HiddenItems
	db $FF
SeafoamIslands4HiddenObjects:
	db $10, $09, MAX_ELIXER
	dba HiddenItems
	db $FF
SeafoamIslands5HiddenObjects:
	db $11, $19, ULTRA_BALL
	dba HiddenItems
	db $FF
ViridianForestHiddenObjects:
	db $12, $01, POTION
	dba HiddenItems
	db $2a, $10, ANTIDOTE
	dba HiddenItems
	db $FF
MtMoon3HiddenObjects:
	db $0c, $12, MOON_STONE
	dba HiddenItems
	db $09, $21, ETHER
	dba HiddenItems
	db $FF
SSAnne10HiddenObjects:
	db $01, $03, HYPER_POTION
	dba HiddenItems
	db $FF
SSAnne6HiddenObjects:
	db $05, $0d, SPRITE_FACING_DOWN
	dba PrintTrashText
	db $07, $0d, SPRITE_FACING_DOWN
	dba PrintTrashText
	db $09, $0d, GREAT_BALL
	dba HiddenItems
	db $FF
UndergroundPathNsHiddenObjects:
	db $04, $03, FULL_RESTORE
	dba HiddenItems
	db $22, $04, X_SPECIAL
	dba HiddenItems
	db $FF
UndergroundPathWeHiddenObjects:
	db $02, $0c, NUGGET
	dba HiddenItems
	db $05, $15, ELIXER
	dba HiddenItems
	db $FF
RocketHideout1HiddenObjects:
	db $0f, $15, PP_UP
	dba HiddenItems
	db $FF
RocketHideout3HiddenObjects:
	db $11, $1b, NUGGET
	dba HiddenItems
	db $FF
RocketHideout4HiddenObjects:
	db $01, $19, SUPER_POTION
	dba HiddenItems
	db $FF
Route10HiddenObjects:
	db $11, $09, SUPER_POTION
	dba HiddenItems
	db $35, $10, MAX_ETHER
	dba HiddenItems
	db $FF
RockTunnelPokecenterHiddenObjects:
	db $04, $00, SPRITE_FACING_LEFT
	dba PrintBenchGuyText
	db $03, $0d, SPRITE_FACING_UP
	dba OpenPokemonCenterPC
	db $FF
PowerPlantHiddenObjects:
	db $10, $11, MAX_ELIXER
	dba HiddenItems
	db $01, $0c, PP_UP
	dba HiddenItems
	db $FF
Route11HiddenObjects:
	db $05, $30, ESCAPE_ROPE
	dba HiddenItems
	db $FF
Route12HiddenObjects:
	db $3f, $02, HYPER_POTION
	dba HiddenItems
	db $FF
Route13HiddenObjects:
	db $0e, $01, PP_UP
	dba HiddenItems
	db $0d, $10, CALCIUM
	dba HiddenItems
	db $FF
Route15Gate2FHiddenObjects:
	db $02, $01, SPRITE_FACING_UP
	dba Route15GateLeftBinoculars
	db $FF
Route17HiddenObjects:
	db $0e, $0f, RARE_CANDY
	dba HiddenItems
	db $2d, $08, FULL_RESTORE
	dba HiddenItems
	db $48, $11, PP_UP
	dba HiddenItems
	db $5b, $04, MAX_REVIVE
	dba HiddenItems
	db $79, $08, MAX_ELIXER
	dba HiddenItems
	db $FF
Route23HiddenObjects:
	db $2c, $09, FULL_RESTORE
	dba HiddenItems
	db $46, $13, ULTRA_BALL
	dba HiddenItems
	db $5a, $08, MAX_ETHER
	dba HiddenItems
	db $FF
VictoryRoad2HiddenObjects:
	db $02, $05, ULTRA_BALL
	dba HiddenItems
	db $07, $1a, FULL_RESTORE
	dba HiddenItems
	db $FF
Route25HiddenObjects:
	db $03, $26, ETHER
	dba HiddenItems
	db $01, $0a, ELIXER
	dba HiddenItems
	db $FF
BillsHouseHiddenObjects:
	db $04, $01, SPRITE_FACING_UP
	dba BillsHousePC
	db $FF
Route4HiddenObjects:
	db $03, $28, GREAT_BALL
	dba HiddenItems
	db $FF
MtMoonPokecenterHiddenObjects:
	db $04, $00, SPRITE_FACING_LEFT
	dba PrintBenchGuyText
	db $03, $0d, SPRITE_FACING_UP
	dba OpenPokemonCenterPC
	db $FF
Route9HiddenObjects:
	db $07, $0e, ETHER
	dba HiddenItems
	db $FF
TradeCenterHiddenObjects:
	db $04, $05, $d0
	dba CableClubRightGameboy
	db $04, $04, $d0
	dba CableClubLeftGameboy
	db $FF
ColosseumHiddenObjects:
	db $04, $05, $d0
	dba CableClubRightGameboy
	db $04, $04, $d0
	dba CableClubLeftGameboy
	db $FF
IndigoPlateauHiddenObjects:
	db $0d, $08, $ff
	dba PrintIndigoPlateauHQText
	db $0d, $0b, SPRITE_FACING_DOWN
	dba PrintIndigoPlateauHQText
	db $FF
IndigoPlateauLobbyHiddenObjects:
	db $07, $0f, SPRITE_FACING_UP
	dba OpenPokemonCenterPC
	db $FF
CopycatsHouse2FHiddenObjects:
	db $01, $01, NUGGET
	dba HiddenItems
	db $FF
FightingDojoHiddenObjects:
	db $09, $03, SPRITE_FACING_UP
	dba PrintFightingDojoText
	db $09, $06, SPRITE_FACING_UP
	dba PrintFightingDojoText
	db $00, $04, SPRITE_FACING_UP
	dba PrintFightingDojoText2
	db $00, $05, SPRITE_FACING_UP
	dba PrintFightingDojoText3
	db $FF
SaffronGymHiddenObjects:
	db $0f, $09, SPRITE_FACING_UP
	dba GymStatues
	db $FF
SaffronPokecenterHiddenObjects:
	db $04, $00, SPRITE_FACING_UP
	dba PrintBenchGuyText
	db $03, $0d, SPRITE_FACING_UP
	dba OpenPokemonCenterPC
	db $FF
RedsHouse2FHiddenObjects:
	db $01, $00, SPRITE_FACING_UP
	dba OpenRedsPC
	db $05, $03, $d0
	dba PrintRedsNESText
	db $FF
BluesHouseHiddenObjects:
	db $01, $00, SPRITE_FACING_UP
	dba PrintBookcaseText
	db $01, $01, SPRITE_FACING_UP
	dba PrintBookcaseText
	db $01, $07, SPRITE_FACING_UP
	dba PrintBookcaseText
	db $FF
OaksLabHiddenObjects:
	db $00, $04, SPRITE_FACING_UP
	dba DisplayOakLabLeftPoster
	db $00, $05, SPRITE_FACING_UP
	dba DisplayOakLabRightPoster
	db $01, $00, SPRITE_FACING_UP
	dba DisplayOakLabEmailText
	db $01, $01, SPRITE_FACING_UP
	dba DisplayOakLabEmailText
	db $FF
ViridianCityHiddenObjects:
	db $04, $0e, POTION
	dba HiddenItems
	db $FF
ViridianPokecenterHiddenObjects:
	db $04, $00, SPRITE_FACING_LEFT
	dba PrintBenchGuyText
	db $03, $0d, SPRITE_FACING_UP
	dba OpenPokemonCenterPC
	db $FF
ViridianSchoolHiddenObjects:
	db $04, $03, (ViridianSchoolNotebook_id - TextPredefs) / 2 + 1
	dba PrintNotebookText
	db $00, $03, (ViridianSchoolBlackboard_id - TextPredefs) / 2 + 1
	dba PrintBlackboardLinkCableText
	db $FF
ViridianGymHiddenObjects:
	db $0f, $0f, SPRITE_FACING_UP
	dba GymStatues
	db $0f, $12, SPRITE_FACING_UP
	dba GymStatues
	db $FF
Museum1FHiddenObjects:
	db $03, $02, SPRITE_FACING_UP
	dba AerodactylFossil
	db $06, $02, SPRITE_FACING_UP
	dba KabutopsFossil
	db $FF
PewterGymHiddenObjects:
	db $0a, $03, SPRITE_FACING_UP
	dba GymStatues
	db $0a, $06, SPRITE_FACING_UP
	dba GymStatues
	db $FF
PewterPokecenterHiddenObjects:
	db $04, $00, SPRITE_FACING_LEFT
	dba PrintBenchGuyText
	db $03, $0d, SPRITE_FACING_UP
	dba OpenPokemonCenterPC
	db $FF
CeruleanCityHiddenObjects:
	db $08, $0f, RARE_CANDY
	dba HiddenItems
	db $FF
CeruleanPokecenterHiddenObjects:
	db $04, $00, SPRITE_FACING_LEFT
	dba PrintBenchGuyText
	db $03, $0d, SPRITE_FACING_UP
	dba OpenPokemonCenterPC
	db $FF
CeruleanGymHiddenObjects:
	db $0b, $03, SPRITE_FACING_UP
	dba GymStatues
	db $0b, $06, SPRITE_FACING_UP
	dba GymStatues
	db $FF
BikeShopHiddenObjects:
	db $00, $01, $d0
	dba PrintNewBikeText
	db $01, $02, $d0
	dba PrintNewBikeText
	db $02, $01, $d0
	dba PrintNewBikeText
	db $02, $03, $d0
	dba PrintNewBikeText
	db $04, $00, $d0
	dba PrintNewBikeText
	db $05, $01, $d0
	dba PrintNewBikeText
	db $FF
UnknownDungeon1HiddenObjects:
	db $07, $12, PP_UP
	dba HiddenItems
	db $FF
LavenderPokecenterHiddenObjects:
	db $04, $00, SPRITE_FACING_LEFT
	dba PrintBenchGuyText
	db $03, $0d, SPRITE_FACING_UP
	dba OpenPokemonCenterPC
	db $FF
Pokemontower5HiddenObjects:
	db $0c, $04, ELIXER
	dba HiddenItems
	db $FF
LavenderHouse1HiddenObjects:
	db $01, $00, SPRITE_FACING_DOWN
	dba PrintMagazinesText
	db $01, $01, SPRITE_FACING_DOWN
	dba PrintMagazinesText
	db $01, $07, SPRITE_FACING_DOWN
	dba PrintMagazinesText
	db $FF
VermilionCityHiddenObjects:
	db $0b, $0e, MAX_ETHER
	dba HiddenItems
	db $FF
VermilionPokecenterHiddenObjects:
	db $03, $0d, SPRITE_FACING_UP
	dba OpenPokemonCenterPC
	db $04, $00, SPRITE_FACING_UP
	dba PrintBenchGuyText
	db $FF
PokemonFanClubHiddenObjects:
	db $00, $01, SPRITE_FACING_UP
	dba FanClubPicture1
	db $00, $06, SPRITE_FACING_UP
	dba FanClubPicture2
	db $FF
VermilionGymHiddenObjects:
	db $0e, $03, SPRITE_FACING_UP
	dba GymStatues
	db $0e, $06, SPRITE_FACING_UP
	dba GymStatues
	db $01, $06, SPRITE_FACING_DOWN
	dba PrintTrashText
	db $07, $01, 0
	dba GymTrashScript
	db $09, $01, 1
	dba GymTrashScript
	db $0b, $01, 2
	dba GymTrashScript
	db $07, $03, 3
	dba GymTrashScript
	db $09, $03, 4
	dba GymTrashScript
	db $0b, $03, 5
	dba GymTrashScript
	db $07, $05, 6
	dba GymTrashScript
	db $09, $05, 7
	dba GymTrashScript
	db $0b, $05, 8
	dba GymTrashScript
	db $07, $07, 9
	dba GymTrashScript
	db $09, $07, 10
	dba GymTrashScript
	db $0b, $07, 11
	dba GymTrashScript
	db $07, $09, 12
	dba GymTrashScript
	db $09, $09, 13
	dba GymTrashScript
	db $0b, $09, 14
	dba GymTrashScript
	db $FF
CeladonCityHiddenObjects:
	db $0f, $30, PP_UP
	dba HiddenItems
	db $FF
CeladonHotelHiddenObjects:
	db $04, $00, SPRITE_FACING_LEFT
	dba PrintBenchGuyText
	db $FF
CeladonMansion2HiddenObjects:
	db $05, $00, SPRITE_FACING_UP
	dba OpenPokemonCenterPC
	db $FF
CeladonMansion5HiddenObjects:
	db $00, $03, (LinkCableHelp_id - TextPredefs) / 2 + 1
	dba PrintBlackboardLinkCableText
	db $00, $04, (LinkCableHelp_id - TextPredefs) / 2 + 1
	dba PrintBlackboardLinkCableText
	db $04, $03, (TMNotebook_id - TextPredefs) / 2 + 1
	dba PrintNotebookText
	db $FF
CeladonPokecenterHiddenObjects:
	db $04, $00, SPRITE_FACING_LEFT
	dba PrintBenchGuyText
	db $03, $0d, SPRITE_FACING_UP
	dba OpenPokemonCenterPC
	db $FF
CeladonGymHiddenObjects:
	db $0f, $03, SPRITE_FACING_UP
	dba GymStatues
	db $0f, $06, SPRITE_FACING_UP
	dba GymStatues
	db $FF
GameCornerHiddenObjects:
	db $0f, $12, $d0
	dba StartSlotMachine
	db $0e, $12, $d0
	dba StartSlotMachine
	db $0d, $12, $d0
	dba StartSlotMachine
	db $0c, $12, $d0
	dba StartSlotMachine
	db $0b, $12, $d0
	dba StartSlotMachine
	db $0a, $12, $ff ; "Someone's Keys"
	dba StartSlotMachine
	db $0a, $0d, $d0
	dba StartSlotMachine
	db $0b, $0d, $d0
	dba StartSlotMachine
	db $0c, $0d, $fe ; "Out To Lunch"
	dba StartSlotMachine
	db $0d, $0d, $d0
	dba StartSlotMachine
	db $0e, $0d, $d0
	dba StartSlotMachine
	db $0f, $0d, $d0
	dba StartSlotMachine
	db $0f, $0c, $d0
	dba StartSlotMachine
	db $0e, $0c, $d0
	dba StartSlotMachine
	db $0d, $0c, $d0
	dba StartSlotMachine
	db $0c, $0c, $d0
	dba StartSlotMachine
	db $0b, $0c, $d0
	dba StartSlotMachine
	db $0a, $0c, $d0
	dba StartSlotMachine
	db $0a, $07, $d0
	dba StartSlotMachine
	db $0b, $07, $d0
	dba StartSlotMachine
	db $0c, $07, $d0
	dba StartSlotMachine
	db $0d, $07, $d0
	dba StartSlotMachine
	db $0e, $07, $d0
	dba StartSlotMachine
	db $0f, $07, $d0
	dba StartSlotMachine
	db $0f, $06, $d0
	dba StartSlotMachine
	db $0e, $06, $d0
	dba StartSlotMachine
	db $0d, $06, $d0
	dba StartSlotMachine
	db $0c, $06, $fd ; "Out Of Order"
	dba StartSlotMachine
	db $0b, $06, $d0
	dba StartSlotMachine
	db $0a, $06, $d0
	dba StartSlotMachine
	db $0a, $01, $d0
	dba StartSlotMachine
	db $0b, $01, $d0
	dba StartSlotMachine
	db $0c, $01, $d0
	dba StartSlotMachine
	db $0d, $01, $d0
	dba StartSlotMachine
	db $0e, $01, $d0
	dba StartSlotMachine
	db $0f, $01, $d0
	dba StartSlotMachine
	db $08, $00, COIN + 10
	dba HiddenCoins
	db $10, $01, COIN + 10
	dba HiddenCoins
	db $0b, $03, COIN + 20
	dba HiddenCoins
	db $0e, $03, COIN + 10
	dba HiddenCoins
	db $0c, $04, COIN + 10
	dba HiddenCoins
	db $0c, $09, COIN + 20
	dba HiddenCoins
	db $0f, $09, COIN + 10
	dba HiddenCoins
	db $0e, $10, COIN + 10
	dba HiddenCoins
	db $10, $0a, COIN + 10
	dba HiddenCoins
	db $07, $0b, COIN + 40
	dba HiddenCoins
	db $08, $0f, COIN + 100
	dba HiddenCoins
	db $0f, $0c, COIN + 10
	dba HiddenCoins
	db $FF
FuchsiaPokecenterHiddenObjects:
	db $03, $0d, SPRITE_FACING_UP
	dba OpenPokemonCenterPC
	db $04, $00, SPRITE_FACING_UP
	dba PrintBenchGuyText
	db $FF
SafariZoneEntranceHiddenObjects:
	db $01, $0a, NUGGET
	dba HiddenItems
	db $FF
FuchsiaGymHiddenObjects:
	db $0f, $03, SPRITE_FACING_UP
	dba GymStatues
	db $0f, $06, SPRITE_FACING_UP
	dba GymStatues
	db $FF
Mansion1HiddenObjects:
	db $10, $08, MOON_STONE
	dba HiddenItems
	db $05, $02, SPRITE_FACING_UP
	dba Mansion1Script_Switches
	db $FF
CinnabarGymHiddenObjects:
	db $0d, $11, SPRITE_FACING_UP
	dba GymStatues
	db $07, $0f, (0 << 4) | 1
	dba PrintCinnabarQuiz
	db $01, $0a, (1 << 4) | 2
	dba PrintCinnabarQuiz
	db $07, $09, (1 << 4) | 3
	dba PrintCinnabarQuiz
	db $0d, $09, (1 << 4) | 4
	dba PrintCinnabarQuiz
	db $0d, $01, (0 << 4) | 5
	dba PrintCinnabarQuiz
	db $07, $01, (1 << 4) | 6
	dba PrintCinnabarQuiz
	db $FF
CinnabarLab4HiddenObjects:
	db $04, $00, SPRITE_FACING_UP
	dba OpenPokemonCenterPC
	db $04, $02, SPRITE_FACING_UP
	dba OpenPokemonCenterPC
	db $FF
CinnabarPokecenterHiddenObjects: ; 6cc3
	db $04, $00, SPRITE_FACING_UP
	dba PrintBenchGuyText
	db $03, $0d, SPRITE_FACING_UP
	dba OpenPokemonCenterPC
	db $FF
; 6cd0
