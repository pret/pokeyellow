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

INCLUDE "engine/titlescreen.asm"
INCLUDE "engine/load_mon_data.asm"

INCLUDE "data/item_prices.asm"
INCLUDE "text/item_names.asm"
INCLUDE "text/unused_names.asm"

INCLUDE "engine/overworld/oam.asm"

INCLUDE "engine/print_waiting_text.asm"

INCLUDE "engine/overworld/map_sprite_functions1.asm"	
INCLUDE "engine/overworld/item.asm"
INCLUDE "engine/overworld/movement.asm"
INCLUDE "engine/cable_club.asm"
INCLUDE "engine/menu/main_menu.asm"
INCLUDE "engine/oak_speech.asm"
INCLUDE "engine/overworld/special_warps.asm"

INCLUDE "data/special_warps.asm"

INCLUDE "engine/debug1.asm"

INCLUDE "engine/menu/naming_screen.asm"

INCLUDE "engine/oak_speech2.asm"

INCLUDE "engine/subtract_paid_money.asm"

INCLUDE "engine/menu/swap_items.asm"

INCLUDE "engine/overworld/pokemart.asm"
INCLUDE "engine/learn_move.asm"
INCLUDE "engine/overworld/pokecenter.asm"
INCLUDE "engine/overworld/set_blackout_map.asm"

INCLUDE "engine/menu/text_ids1.asm"
INCLUDE "engine/overworld/cable_club_npc.asm"
INCLUDE "engine/menu/text_ids2.asm"

INCLUDE "engine/battle/moveEffects/drain_hp_effect.asm"
INCLUDE "engine/menu/players_pc.asm"
INCLUDE "engine/remove_pokemon.asm"
INCLUDE "engine/display_pokedex.asm"

SECTION "bank03",ROMX,BANK[$03]

INCLUDE "engine/joypad.asm"

INCLUDE "engine/overworld/clear_loadmapdata_vars.asm"
INCLUDE "engine/overworld/check_player_state.asm"
INCLUDE "engine/overworld/print_safari_steps.asm"
INCLUDE "engine/overworld/get_coords_tile_in_front_of_player.asm"
INCLUDE "engine/overworld/boulders.asm"
INCLUDE "engine/overworld/step_functions.asm"
INCLUDE "engine/overworld/load_tileset_header.asm"
INCLUDE "engine/overworld/daycare_exp.asm"

INCLUDE "data/hide_show_data.asm"

INCLUDE "engine/overworld/load_wild_data.asm"

INCLUDE "engine/items/items.asm"

INCLUDE "engine/draw_badges.asm"

INCLUDE "engine/overworld/replace_tile_block.asm"
INCLUDE "engine/overworld/cut.asm"
INCLUDE "engine/overworld/missable_objects.asm"
INCLUDE "engine/overworld/try_pushing_boulder.asm"

INCLUDE "engine/add_party_mon.asm"
INCLUDE "engine/move_mon.asm"
INCLUDE "engine/flag_action_predef.asm"
INCLUDE "engine/heal_party.asm"
INCLUDE "engine/bcd.asm"

INCLUDE "engine/init_player_data.asm"

INCLUDE "engine/get_bag_item_quantity.asm"

INCLUDE "engine/overworld/npc_pathfinding.asm"

INCLUDE "engine/hp_bar.asm"
INCLUDE "engine/hidden_object_functions3.asm"

SECTION "Graphics", ROMX, BANK[GFX]

PokemonLogoJapanGraphics:       INCBIN "gfx/pokemon_logo_japan.2bpp"
FontGraphics:                   INCBIN "gfx/font.1bpp"
FontGraphicsEnd:
ABTiles:                        INCBIN "gfx/AB.2bpp"
HpBarAndStatusGraphics:         INCBIN "gfx/hp_bar_and_status.2bpp"
HpBarAndStatusGraphicsEnd:
BattleHudTiles1:                INCBIN "gfx/battle_hud1.1bpp"
BattleHudTiles1End:
BattleHudTiles2:                INCBIN "gfx/battle_hud2.1bpp"
BattleHudTiles3:                INCBIN "gfx/battle_hud3.1bpp"
BattleHudTiles3End:
NintendoCopyrightLogoGraphics:  INCBIN "gfx/copyright.2bpp"
GamefreakLogoGraphics:          INCBIN "gfx/gamefreak.2bpp"
GamefreakLogoGraphicsEnd:
NineTile:                       INCBIN "gfx/9_tile.2bpp"
TextBoxGraphics:                INCBIN "gfx/text_box.2bpp"
TextBoxGraphicsEnd:
PokedexTileGraphics:            INCBIN "gfx/pokedex.2bpp"
PokedexTileGraphicsEnd:
WorldMapTileGraphics:           INCBIN "gfx/town_map.2bpp"
WorldMapTileGraphicsEnd:
PlayerCharacterTitleGraphics:   INCBIN "gfx/player_title.2bpp"

INCLUDE "engine/menu/status_screen.asm"
INCLUDE "engine/menu/party_menu.asm"

RedPicFront: INCBIN "pic/ytrainer/red.pic"
ShrinkPic1:  INCBIN "pic/trainer/shrink1.pic"
ShrinkPic2:  INCBIN "pic/trainer/shrink2.pic"

INCLUDE "engine/menu/start_sub_menus.asm"
INCLUDE "engine/items/tms.asm"

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

INCLUDE "engine/battle/end_of_battle.asm"
INCLUDE "engine/battle/wild_encounters.asm"
INCLUDE "engine/battle/moveEffects/recoil_effect.asm"
INCLUDE "engine/battle/moveEffects/conversion_effect.asm"
INCLUDE "engine/battle/moveEffects/haze_effect.asm"


SECTION "NPC Sprites 2", ROMX, BANK[NPC_SPRITES_2]

INCLUDE "engine/load_pokedex_tiles.asm"
INCLUDE "engine/overworld/map_sprites.asm"

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

INCLUDE "engine/battle/moveEffects/substitute_effect.asm"
INCLUDE "engine/menu/pc.asm"

SECTION "bank06",ROMX,BANK[$06]

INCLUDE "data/mapHeaders/celadoncity.asm"
INCLUDE "data/mapObjects/celadoncity.asm"
CeladonCityBlocks: INCBIN "maps/celadoncity.blk"

INCLUDE "data/mapHeaders/pallettown.asm"
INCLUDE "data/mapObjects/pallettown.asm"
PalletTownBlocks: INCBIN "maps/pallettown.blk"

INCLUDE "data/mapHeaders/viridiancity.asm"
INCLUDE "data/mapObjects/viridiancity.asm"
ViridianCityBlocks: INCBIN "maps/viridiancity.blk"

INCLUDE "data/mapHeaders/pewtercity.asm"
INCLUDE "data/mapObjects/pewtercity.asm"
PewterCityBlocks: INCBIN "maps/pewtercity.blk"

INCLUDE "data/mapHeaders/ceruleancity.asm"
INCLUDE "data/mapObjects/ceruleancity.asm"
CeruleanCityBlocks: INCBIN "maps/ceruleancity.blk" ; 18836

INCLUDE "data/mapHeaders/vermilioncity.asm"
INCLUDE "data/mapObjects/vermilioncity.asm"
VermilionCityBlocks: INCBIN "maps/vermilioncity.blk"
INCLUDE "data/mapHeaders/fuchsiacity.asm"
INCLUDE "data/mapObjects/fuchsiacity.asm"
FuchsiaCityBlocks: INCBIN "maps/fuchsiacity.blk"


INCLUDE "scripts/pallettown.asm"
INCLUDE "scripts/viridiancity.asm"
INCLUDE "scripts/pewtercity.asm"
INCLUDE "scripts/ceruleancity.asm"
INCLUDE "scripts/vermilioncity.asm"
INCLUDE "scripts/celadoncity.asm"
INCLUDE "scripts/fuchsiacity.asm"
	dr $19c2f,$1a4ea

INCLUDE "engine/overworld/npc_movement.asm"
INCLUDE "engine/overworld/doors.asm"
INCLUDE "engine/overworld/ledges.asm"

SECTION "bank07",ROMX,BANK[$07]
INCLUDE "data/mapHeaders/cinnabarisland.asm"
INCLUDE "data/mapObjects/cinnabarisland.asm"
CinnabarIslandBlocks:
INCBIN "maps/cinnabarisland.blk"

INCLUDE "data/mapHeaders/route1.asm"
INCLUDE "data/mapObjects/route1.asm"
Route1Blocks: ; 1c0fc
INCBIN "maps/route1.blk"
	dr $1c1b0,$1c21e ; headers, objects, blocks

INCLUDE "engine/clear_save.asm"
INCLUDE "engine/predefs7.asm"

INCLUDE "scripts/cinnabarisland.asm"
	; dr $1c2c2,$1c358 ; map scripts
INCLUDE "scripts/route1.asm"
	dr $1c386,$1e2ae ; map scripts

INCLUDE "engine/menu/oaks_pc.asm"

INCLUDE "engine/hidden_object_functions7.asm"

SECTION "Pics 1", ROMX, BANK[PICS_1]

RhydonPicFront:      INCBIN "pic/ymon/rhydon.pic"
RhydonPicBack:       INCBIN "pic/monback/rhydonb.pic"
KangaskhanPicFront:  INCBIN "pic/ymon/kangaskhan.pic"
KangaskhanPicBack:   INCBIN "pic/monback/kangaskhanb.pic"
NidoranMPicFront:    INCBIN "pic/ymon/nidoranm.pic"
NidoranMPicBack:     INCBIN "pic/monback/nidoranmb.pic"
ClefairyPicFront:    INCBIN "pic/ymon/clefairy.pic"
ClefairyPicBack:     INCBIN "pic/monback/clefairyb.pic"
SpearowPicFront:     INCBIN "pic/ymon/spearow.pic"
SpearowPicBack:      INCBIN "pic/monback/spearowb.pic"
VoltorbPicFront:     INCBIN "pic/ymon/voltorb.pic"
VoltorbPicBack:      INCBIN "pic/monback/voltorbb.pic"
NidokingPicFront:    INCBIN "pic/ymon/nidoking.pic"
NidokingPicBack:     INCBIN "pic/monback/nidokingb.pic"
SlowbroPicFront:     INCBIN "pic/ymon/slowbro.pic"
SlowbroPicBack:      INCBIN "pic/monback/slowbrob.pic"
IvysaurPicFront:     INCBIN "pic/ymon/ivysaur.pic"
IvysaurPicBack:      INCBIN "pic/monback/ivysaurb.pic"
ExeggutorPicFront:   INCBIN "pic/ymon/exeggutor.pic"
ExeggutorPicBack:    INCBIN "pic/monback/exeggutorb.pic"
LickitungPicFront:   INCBIN "pic/ymon/lickitung.pic"
LickitungPicBack:    INCBIN "pic/monback/lickitungb.pic"
ExeggcutePicFront:   INCBIN "pic/ymon/exeggcute.pic"
ExeggcutePicBack:    INCBIN "pic/monback/exeggcuteb.pic"
GrimerPicFront:      INCBIN "pic/ymon/grimer.pic"
GrimerPicBack:       INCBIN "pic/monback/grimerb.pic"
GengarPicFront:      INCBIN "pic/ymon/gengar.pic"
GengarPicBack:       INCBIN "pic/monback/gengarb.pic"
NidoranFPicFront:    INCBIN "pic/ymon/nidoranf.pic"
NidoranFPicBack:     INCBIN "pic/monback/nidoranfb.pic"
NidoqueenPicFront:   INCBIN "pic/ymon/nidoqueen.pic"
NidoqueenPicBack:    INCBIN "pic/monback/nidoqueenb.pic"
CubonePicFront:      INCBIN "pic/ymon/cubone.pic"
CubonePicBack:       INCBIN "pic/monback/cuboneb.pic"
RhyhornPicFront:     INCBIN "pic/ymon/rhyhorn.pic"
RhyhornPicBack:      INCBIN "pic/monback/rhyhornb.pic"
LaprasPicFront:      INCBIN "pic/ymon/lapras.pic"
LaprasPicBack:       INCBIN "pic/monback/laprasb.pic"
ArcaninePicFront:    INCBIN "pic/ymon/arcanine.pic"
ArcaninePicBack:     INCBIN "pic/monback/arcanineb.pic"
MewPicFront:         INCBIN "pic/ymon/mew.pic"
MewPicBack:          INCBIN "pic/monback/mewb.pic"
GyaradosPicFront:    INCBIN "pic/ymon/gyarados.pic"
GyaradosPicBack:     INCBIN "pic/monback/gyaradosb.pic"
ShellderPicFront:    INCBIN "pic/ymon/shellder.pic"
ShellderPicBack:     INCBIN "pic/monback/shellderb.pic"
TentacoolPicFront:   INCBIN "pic/ymon/tentacool.pic"
TentacoolPicBack:    INCBIN "pic/monback/tentacoolb.pic"
GastlyPicFront:      INCBIN "pic/ymon/gastly.pic"
GastlyPicBack:       INCBIN "pic/monback/gastlyb.pic"
ScytherPicFront:     INCBIN "pic/ymon/scyther.pic"
ScytherPicBack:      INCBIN "pic/monback/scytherb.pic"
StaryuPicFront:      INCBIN "pic/ymon/staryu.pic"
StaryuPicBack:       INCBIN "pic/monback/staryub.pic"
BlastoisePicFront:   INCBIN "pic/ymon/blastoise.pic"
BlastoisePicBack:    INCBIN "pic/monback/blastoiseb.pic"
PinsirPicFront:      INCBIN "pic/ymon/pinsir.pic"
PinsirPicBack:       INCBIN "pic/monback/pinsirb.pic"
TangelaPicFront:     INCBIN "pic/ymon/tangela.pic"
TangelaPicBack:      INCBIN "pic/monback/tangelab.pic"

INCLUDE "engine/battle/print_type.asm"
INCLUDE "engine/battle/save_trainer_name.asm"

SECTION "Pics 2", ROMX, BANK[PICS_2]

GrowlithePicFront:   INCBIN "pic/ymon/growlithe.pic"
GrowlithePicBack:    INCBIN "pic/monback/growlitheb.pic"
OnixPicFront:        INCBIN "pic/ymon/onix.pic"
OnixPicBack:         INCBIN "pic/monback/onixb.pic"
FearowPicFront:      INCBIN "pic/ymon/fearow.pic"
FearowPicBack:       INCBIN "pic/monback/fearowb.pic"
PidgeyPicFront:      INCBIN "pic/ymon/pidgey.pic"
PidgeyPicBack:       INCBIN "pic/monback/pidgeyb.pic"
SlowpokePicFront:    INCBIN "pic/ymon/slowpoke.pic"
SlowpokePicBack:     INCBIN "pic/monback/slowpokeb.pic"
KadabraPicFront:     INCBIN "pic/ymon/kadabra.pic"
KadabraPicBack:      INCBIN "pic/monback/kadabrab.pic"
GravelerPicFront:    INCBIN "pic/ymon/graveler.pic"
GravelerPicBack:     INCBIN "pic/monback/gravelerb.pic"
ChanseyPicFront:     INCBIN "pic/ymon/chansey.pic"
ChanseyPicBack:      INCBIN "pic/monback/chanseyb.pic"
MachokePicFront:     INCBIN "pic/ymon/machoke.pic"
MachokePicBack:      INCBIN "pic/monback/machokeb.pic"
MrMimePicFront:      INCBIN "pic/ymon/mr.mime.pic"
MrMimePicBack:       INCBIN "pic/monback/mr.mimeb.pic"
HitmonleePicFront:   INCBIN "pic/ymon/hitmonlee.pic"
HitmonleePicBack:    INCBIN "pic/monback/hitmonleeb.pic"
HitmonchanPicFront:  INCBIN "pic/ymon/hitmonchan.pic"
HitmonchanPicBack:   INCBIN "pic/monback/hitmonchanb.pic"
ArbokPicFront:       INCBIN "pic/ymon/arbok.pic"
ArbokPicBack:        INCBIN "pic/monback/arbokb.pic"
ParasectPicFront:    INCBIN "pic/ymon/parasect.pic"
ParasectPicBack:     INCBIN "pic/monback/parasectb.pic"
PsyduckPicFront:     INCBIN "pic/ymon/psyduck.pic"
PsyduckPicBack:      INCBIN "pic/monback/psyduckb.pic"
DrowzeePicFront:     INCBIN "pic/ymon/drowzee.pic"
DrowzeePicBack:      INCBIN "pic/monback/drowzeeb.pic"
GolemPicFront:       INCBIN "pic/ymon/golem.pic"
GolemPicBack:        INCBIN "pic/monback/golemb.pic"
MagmarPicFront:      INCBIN "pic/ymon/magmar.pic"
MagmarPicBack:       INCBIN "pic/monback/magmarb.pic"
ElectabuzzPicFront:  INCBIN "pic/ymon/electabuzz.pic"
ElectabuzzPicBack:   INCBIN "pic/monback/electabuzzb.pic"
MagnetonPicFront:    INCBIN "pic/ymon/magneton.pic"
MagnetonPicBack:     INCBIN "pic/monback/magnetonb.pic"
KoffingPicFront:     INCBIN "pic/ymon/koffing.pic"
KoffingPicBack:      INCBIN "pic/monback/koffingb.pic"
MankeyPicFront:      INCBIN "pic/ymon/mankey.pic"
MankeyPicBack:       INCBIN "pic/monback/mankeyb.pic"
SeelPicFront:        INCBIN "pic/ymon/seel.pic"
SeelPicBack:         INCBIN "pic/monback/seelb.pic"
DiglettPicFront:     INCBIN "pic/ymon/diglett.pic"
DiglettPicBack:      INCBIN "pic/monback/diglettb.pic"
TaurosPicFront:      INCBIN "pic/ymon/tauros.pic"
TaurosPicBack:       INCBIN "pic/monback/taurosb.pic"
FarfetchdPicFront:   INCBIN "pic/ymon/farfetchd.pic"
FarfetchdPicBack:    INCBIN "pic/monback/farfetchdb.pic"
VenonatPicFront:     INCBIN "pic/ymon/venonat.pic"
VenonatPicBack:      INCBIN "pic/monback/venonatb.pic"
DragonitePicFront:   INCBIN "pic/ymon/dragonite.pic"
DragonitePicBack:    INCBIN "pic/monback/dragoniteb.pic"
DoduoPicFront:       INCBIN "pic/ymon/doduo.pic"
DoduoPicBack:        INCBIN "pic/monback/doduob.pic"
PoliwagPicFront:     INCBIN "pic/ymon/poliwag.pic"
PoliwagPicBack:      INCBIN "pic/monback/poliwagb.pic"
JynxPicFront:        INCBIN "pic/ymon/jynx.pic"
JynxPicBack:         INCBIN "pic/monback/jynxb.pic"
MoltresPicFront:     INCBIN "pic/ymon/moltres.pic"
MoltresPicBack:      INCBIN "pic/monback/moltresb.pic"

INCLUDE "engine/predefsA.asm"
INCLUDE "engine/battle/moveEffects/leech_seed_effect.asm"

SECTION "Pics 3", ROMX, BANK[PICS_3]

ArticunoPicFront:    INCBIN "pic/ymon/articuno.pic"
ArticunoPicBack:     INCBIN "pic/monback/articunob.pic"
ZapdosPicFront:      INCBIN "pic/ymon/zapdos.pic"
ZapdosPicBack:       INCBIN "pic/monback/zapdosb.pic"
DittoPicFront:       INCBIN "pic/ymon/ditto.pic"
DittoPicBack:        INCBIN "pic/monback/dittob.pic"
MeowthPicFront:      INCBIN "pic/ymon/meowth.pic"
MeowthPicBack:       INCBIN "pic/monback/meowthb.pic"
KrabbyPicFront:      INCBIN "pic/ymon/krabby.pic"
KrabbyPicBack:       INCBIN "pic/monback/krabbyb.pic"
VulpixPicFront:      INCBIN "pic/ymon/vulpix.pic"
VulpixPicBack:       INCBIN "pic/monback/vulpixb.pic"
NinetalesPicFront:   INCBIN "pic/ymon/ninetales.pic"
NinetalesPicBack:    INCBIN "pic/monback/ninetalesb.pic"
PikachuPicFront:     INCBIN "pic/ymon/pikachu.pic"
PikachuPicBack:      INCBIN "pic/monback/pikachub.pic"
RaichuPicFront:      INCBIN "pic/ymon/raichu.pic"
RaichuPicBack:       INCBIN "pic/monback/raichub.pic"
DratiniPicFront:     INCBIN "pic/ymon/dratini.pic"
DratiniPicBack:      INCBIN "pic/monback/dratinib.pic"
DragonairPicFront:   INCBIN "pic/ymon/dragonair.pic"
DragonairPicBack:    INCBIN "pic/monback/dragonairb.pic"
KabutoPicFront:      INCBIN "pic/ymon/kabuto.pic"
KabutoPicBack:       INCBIN "pic/monback/kabutob.pic"
KabutopsPicFront:    INCBIN "pic/ymon/kabutops.pic"
KabutopsPicBack:     INCBIN "pic/monback/kabutopsb.pic"
HorseaPicFront:      INCBIN "pic/ymon/horsea.pic"
HorseaPicBack:       INCBIN "pic/monback/horseab.pic"
SeadraPicFront:      INCBIN "pic/ymon/seadra.pic"
SeadraPicBack:       INCBIN "pic/monback/seadrab.pic"
SandshrewPicFront:   INCBIN "pic/ymon/sandshrew.pic"
SandshrewPicBack:    INCBIN "pic/monback/sandshrewb.pic"
SandslashPicFront:   INCBIN "pic/ymon/sandslash.pic"
SandslashPicBack:    INCBIN "pic/monback/sandslashb.pic"
OmanytePicFront:     INCBIN "pic/ymon/omanyte.pic"
OmanytePicBack:      INCBIN "pic/monback/omanyteb.pic"
OmastarPicFront:     INCBIN "pic/ymon/omastar.pic"
OmastarPicBack:      INCBIN "pic/monback/omastarb.pic"
JigglypuffPicFront:  INCBIN "pic/ymon/jigglypuff.pic"
JigglypuffPicBack:   INCBIN "pic/monback/jigglypuffb.pic"
WigglytuffPicFront:  INCBIN "pic/ymon/wigglytuff.pic"
WigglytuffPicBack:   INCBIN "pic/monback/wigglytuffb.pic"
EeveePicFront:       INCBIN "pic/ymon/eevee.pic"
EeveePicBack:        INCBIN "pic/monback/eeveeb.pic"
FlareonPicFront:     INCBIN "pic/ymon/flareon.pic"
FlareonPicBack:      INCBIN "pic/monback/flareonb.pic"
JolteonPicFront:     INCBIN "pic/ymon/jolteon.pic"
JolteonPicBack:      INCBIN "pic/monback/jolteonb.pic"
VaporeonPicFront:    INCBIN "pic/ymon/vaporeon.pic"
VaporeonPicBack:     INCBIN "pic/monback/vaporeonb.pic"
MachopPicFront:      INCBIN "pic/ymon/machop.pic"
MachopPicBack:       INCBIN "pic/monback/machopb.pic"
ZubatPicFront:       INCBIN "pic/ymon/zubat.pic"
ZubatPicBack:        INCBIN "pic/monback/zubatb.pic"
EkansPicFront:       INCBIN "pic/ymon/ekans.pic"
EkansPicBack:        INCBIN "pic/monback/ekansb.pic"
ParasPicFront:       INCBIN "pic/ymon/paras.pic"
ParasPicBack:        INCBIN "pic/monback/parasb.pic"
PoliwhirlPicFront:   INCBIN "pic/ymon/poliwhirl.pic"
PoliwhirlPicBack:    INCBIN "pic/monback/poliwhirlb.pic"
PoliwrathPicFront:   INCBIN "pic/ymon/poliwrath.pic"
PoliwrathPicBack:    INCBIN "pic/monback/poliwrathb.pic"
WeedlePicFront:      INCBIN "pic/ymon/weedle.pic"
WeedlePicBack:       INCBIN "pic/monback/weedleb.pic"
KakunaPicFront:      INCBIN "pic/ymon/kakuna.pic"
KakunaPicBack:       INCBIN "pic/monback/kakunab.pic"
BeedrillPicFront:    INCBIN "pic/ymon/beedrill.pic"
BeedrillPicBack:     INCBIN "pic/monback/beedrillb.pic"

FossilKabutopsPic:   INCBIN "pic/ymon/fossilkabutops.pic"

INCLUDE "engine/battle/display_effectiveness.asm"
INCLUDE "engine/items/tmhm.asm"

Func_2fd6a: ; 2fd6a (b:7d6a)
	callab IsThisPartymonStarterPikachu_Party
	ret nc
	ld a, $3
	ld [wd431], a
	ret

INCLUDE "engine/battle/scale_sprites.asm"
INCLUDE "engine/game_corner_slots2.asm"

SECTION "Pics 4", ROMX, BANK[PICS_4]

DodrioPicFront:       INCBIN "pic/ymon/dodrio.pic"
DodrioPicBack:        INCBIN "pic/monback/dodriob.pic"
PrimeapePicFront:     INCBIN "pic/ymon/primeape.pic"
PrimeapePicBack:      INCBIN "pic/monback/primeapeb.pic"
DugtrioPicFront:      INCBIN "pic/ymon/dugtrio.pic"
DugtrioPicBack:       INCBIN "pic/monback/dugtriob.pic"
VenomothPicFront:     INCBIN "pic/ymon/venomoth.pic"
VenomothPicBack:      INCBIN "pic/monback/venomothb.pic"
DewgongPicFront:      INCBIN "pic/ymon/dewgong.pic"
DewgongPicBack:       INCBIN "pic/monback/dewgongb.pic"
CaterpiePicFront:     INCBIN "pic/ymon/caterpie.pic"
CaterpiePicBack:      INCBIN "pic/monback/caterpieb.pic"
MetapodPicFront:      INCBIN "pic/ymon/metapod.pic"
MetapodPicBack:       INCBIN "pic/monback/metapodb.pic"
ButterfreePicFront:   INCBIN "pic/ymon/butterfree.pic"
ButterfreePicBack:    INCBIN "pic/monback/butterfreeb.pic"
MachampPicFront:      INCBIN "pic/ymon/machamp.pic"
MachampPicBack:       INCBIN "pic/monback/machampb.pic"
GolduckPicFront:      INCBIN "pic/ymon/golduck.pic"
GolduckPicBack:       INCBIN "pic/monback/golduckb.pic"
HypnoPicFront:        INCBIN "pic/ymon/hypno.pic"
HypnoPicBack:         INCBIN "pic/monback/hypnob.pic"
GolbatPicFront:       INCBIN "pic/ymon/golbat.pic"
GolbatPicBack:        INCBIN "pic/monback/golbatb.pic"
MewtwoPicFront:       INCBIN "pic/ymon/mewtwo.pic"
MewtwoPicBack:        INCBIN "pic/monback/mewtwob.pic"
SnorlaxPicFront:      INCBIN "pic/ymon/snorlax.pic"
SnorlaxPicBack:       INCBIN "pic/monback/snorlaxb.pic"
MagikarpPicFront:     INCBIN "pic/ymon/magikarp.pic"
MagikarpPicBack:      INCBIN "pic/monback/magikarpb.pic"
MukPicFront:          INCBIN "pic/ymon/muk.pic"
MukPicBack:           INCBIN "pic/monback/mukb.pic"
KinglerPicFront:      INCBIN "pic/ymon/kingler.pic"
KinglerPicBack:       INCBIN "pic/monback/kinglerb.pic"
CloysterPicFront:     INCBIN "pic/ymon/cloyster.pic"
CloysterPicBack:      INCBIN "pic/monback/cloysterb.pic"
ElectrodePicFront:    INCBIN "pic/ymon/electrode.pic"
ElectrodePicBack:     INCBIN "pic/monback/electrodeb.pic"
ClefablePicFront:     INCBIN "pic/ymon/clefable.pic"
ClefablePicBack:      INCBIN "pic/monback/clefableb.pic"
WeezingPicFront:      INCBIN "pic/ymon/weezing.pic"
WeezingPicBack:       INCBIN "pic/monback/weezingb.pic"
PersianPicFront:      INCBIN "pic/ymon/persian.pic"
PersianPicBack:       INCBIN "pic/monback/persianb.pic"
MarowakPicFront:      INCBIN "pic/ymon/marowak.pic"
MarowakPicBack:       INCBIN "pic/monback/marowakb.pic"
HaunterPicFront:      INCBIN "pic/ymon/haunter.pic"
HaunterPicBack:       INCBIN "pic/monback/haunterb.pic"
AbraPicFront:         INCBIN "pic/ymon/abra.pic"
AbraPicBack:          INCBIN "pic/monback/abrab.pic"
AlakazamPicFront:     INCBIN "pic/ymon/alakazam.pic"
AlakazamPicBack:      INCBIN "pic/monback/alakazamb.pic"
PidgeottoPicFront:    INCBIN "pic/ymon/pidgeotto.pic"
PidgeottoPicBack:     INCBIN "pic/monback/pidgeottob.pic"
PidgeotPicFront:      INCBIN "pic/ymon/pidgeot.pic"
PidgeotPicBack:       INCBIN "pic/monback/pidgeotb.pic"
StarmiePicFront:      INCBIN "pic/ymon/starmie.pic"
StarmiePicBack:       INCBIN "pic/monback/starmieb.pic"


SECTION "Pics 5", ROMX, BANK[PICS_5]

BulbasaurPicFront:    INCBIN "pic/ymon/bulbasaur.pic"
BulbasaurPicBack:     INCBIN "pic/monback/bulbasaurb.pic"
VenusaurPicFront:     INCBIN "pic/ymon/venusaur.pic"
VenusaurPicBack:      INCBIN "pic/monback/venusaurb.pic"
TentacruelPicFront:   INCBIN "pic/ymon/tentacruel.pic"
TentacruelPicBack:    INCBIN "pic/monback/tentacruelb.pic"
GoldeenPicFront:      INCBIN "pic/ymon/goldeen.pic"
GoldeenPicBack:       INCBIN "pic/monback/goldeenb.pic"
SeakingPicFront:      INCBIN "pic/ymon/seaking.pic"
SeakingPicBack:       INCBIN "pic/monback/seakingb.pic"
PonytaPicFront:       INCBIN "pic/ymon/ponyta.pic"
RapidashPicFront:     INCBIN "pic/ymon/rapidash.pic"
PonytaPicBack:        INCBIN "pic/monback/ponytab.pic"
RapidashPicBack:      INCBIN "pic/monback/rapidashb.pic"
RattataPicFront:      INCBIN "pic/ymon/rattata.pic"
RattataPicBack:       INCBIN "pic/monback/rattatab.pic"
RaticatePicFront:     INCBIN "pic/ymon/raticate.pic"
RaticatePicBack:      INCBIN "pic/monback/raticateb.pic"
NidorinoPicFront:     INCBIN "pic/ymon/nidorino.pic"
NidorinoPicBack:      INCBIN "pic/monback/nidorinob.pic"
NidorinaPicFront:     INCBIN "pic/ymon/nidorina.pic"
NidorinaPicBack:      INCBIN "pic/monback/nidorinab.pic"
GeodudePicFront:      INCBIN "pic/ymon/geodude.pic"
GeodudePicBack:       INCBIN "pic/monback/geodudeb.pic"
PorygonPicFront:      INCBIN "pic/ymon/porygon.pic"
PorygonPicBack:       INCBIN "pic/monback/porygonb.pic"
AerodactylPicFront:   INCBIN "pic/ymon/aerodactyl.pic"
AerodactylPicBack:    INCBIN "pic/monback/aerodactylb.pic"
MagnemitePicFront:    INCBIN "pic/ymon/magnemite.pic"
MagnemitePicBack:     INCBIN "pic/monback/magnemiteb.pic"
CharmanderPicFront:   INCBIN "pic/ymon/charmander.pic"
CharmanderPicBack:    INCBIN "pic/monback/charmanderb.pic"
SquirtlePicFront:     INCBIN "pic/ymon/squirtle.pic"
SquirtlePicBack:      INCBIN "pic/monback/squirtleb.pic"
CharmeleonPicFront:   INCBIN "pic/ymon/charmeleon.pic"
CharmeleonPicBack:    INCBIN "pic/monback/charmeleonb.pic"
WartortlePicFront:    INCBIN "pic/ymon/wartortle.pic"
WartortlePicBack:     INCBIN "pic/monback/wartortleb.pic"
CharizardPicFront:    INCBIN "pic/ymon/charizard.pic"
CharizardPicBack:     INCBIN "pic/monback/charizardb.pic"
FossilAerodactylPic:  INCBIN "pic/ymon/fossilaerodactyl.pic"
GhostPic:             INCBIN "pic/other/ghost.pic"
OddishPicFront:       INCBIN "pic/ymon/oddish.pic"
OddishPicBack:        INCBIN "pic/monback/oddishb.pic"
GloomPicFront:        INCBIN "pic/ymon/gloom.pic"
GloomPicBack:         INCBIN "pic/monback/gloomb.pic"
VileplumePicFront:    INCBIN "pic/ymon/vileplume.pic"
VileplumePicBack:     INCBIN "pic/monback/vileplumeb.pic"
BellsproutPicFront:   INCBIN "pic/ymon/bellsprout.pic"
BellsproutPicBack:    INCBIN "pic/monback/bellsproutb.pic"
WeepinbellPicFront:   INCBIN "pic/ymon/weepinbell.pic"
WeepinbellPicBack:    INCBIN "pic/monback/weepinbellb.pic"
VictreebelPicFront:   INCBIN "pic/ymon/victreebel.pic"
VictreebelPicBack:    INCBIN "pic/monback/victreebelb.pic"

INCLUDE "engine/titlescreen2.asm"
INCLUDE "engine/slot_machine.asm"
INCLUDE "engine/game_corner_slots.asm"

SECTION "bank0E",ROMX,BANK[$0E]

INCLUDE "data/moves.asm"
BaseStats: INCLUDE "data/base_stats.asm"
INCLUDE "data/cries.asm"
INCLUDE "engine/battle/trainer_ai.asm"
INCLUDE "engine/battle/draw_hud_pokeball_gfx.asm"

TradingAnimationGraphics:
	INCBIN "gfx/game_boy.norepeat.2bpp"
	INCBIN "gfx/link_cable.2bpp"
TradingAnimationGraphicsEnd:

TradingAnimationGraphics2:
; Pokeball traveling through the link cable.
	INCBIN "gfx/trade2.2bpp"
TradingAnimationGraphics2End:

INCLUDE "engine/evos_moves.asm"


SECTION "bank0F",ROMX,BANK[$0F]

INCLUDE "engine/battle/core.asm"

SECTION "bank10",ROMX,BANK[$10]

INCLUDE "engine/menu/pokedex.asm"
INCLUDE "engine/overworld/emotion_bubbles.asm"
INCLUDE "engine/trade.asm"
INCLUDE "engine/intro.asm"
INCLUDE "engine/trade2.asm"
INCLUDE "engine/menu/options.asm"


SECTION "bank11",ROMX,BANK[$11]

INCLUDE "data/mapHeaders/lavendertown.asm"
INCLUDE "data/mapObjects/lavendertown.asm"
LavenderTownBlocks:
INCBIN "maps/lavendertown.blk"
	dr $440df,$4410b

INCLUDE "scripts/lavendertown.asm"
	; dr $440df,$44169

INCLUDE "engine/pokedex_rating.asm"

	dr $44251,$443b7
Mansion1Script_Switches:
	dr $443b7,$45077
LoadSpinnerArrowTiles: ; 45077 (11:5077)
	dr $45077,$46bf3

INCLUDE "engine/overworld/dungeon_warps.asm"

SECTION "bank12",ROMX,BANK[$12]
INCLUDE "data/mapHeaders/route7.asm"
INCLUDE "data/mapObjects/route7.asm"
Route7Blocks: ; 48051
INCBIN "maps/route7.blk"
	dr $480ab,$480eb
INCLUDE "scripts/route7.asm"
; INCLUDE "data/mapHeaders/redshouse1f.asm"
; INCLUDE "data/mapObjects/redshouse1f.asm"
	dr $480f6,$4a540


SECTION "bank13",ROMX,BANK[$13]

TrainerPics:
YoungsterPic:     INCBIN "pic/trainer/youngster.pic"
BugCatcherPic:    INCBIN "pic/trainer/bugcatcher.pic"
LassPic:          INCBIN "pic/trainer/lass.pic"
SailorPic:        INCBIN "pic/trainer/sailor.pic"
JrTrainerMPic:    INCBIN "pic/trainer/jr.trainerm.pic"
JrTrainerFPic:    INCBIN "pic/trainer/jr.trainerf.pic"
PokemaniacPic:    INCBIN "pic/trainer/pokemaniac.pic"
SuperNerdPic:     INCBIN "pic/trainer/supernerd.pic"
HikerPic:         INCBIN "pic/trainer/hiker.pic"
BikerPic:         INCBIN "pic/trainer/biker.pic"
BurglarPic:       INCBIN "pic/trainer/burglar.pic"
EngineerPic:      INCBIN "pic/trainer/engineer.pic"
FisherPic:        INCBIN "pic/trainer/fisher.pic"
SwimmerPic:       INCBIN "pic/trainer/swimmer.pic"
CueBallPic:       INCBIN "pic/trainer/cueball.pic"
GamblerPic:       INCBIN "pic/trainer/gambler.pic"
BeautyPic:        INCBIN "pic/trainer/beauty.pic"
PsychicPic:       INCBIN "pic/trainer/psychic.pic"
RockerPic:        INCBIN "pic/trainer/rocker.pic"
JugglerPic:       INCBIN "pic/trainer/juggler.pic"
TamerPic:         INCBIN "pic/trainer/tamer.pic"
BirdKeeperPic:    INCBIN "pic/trainer/birdkeeper.pic"
BlackbeltPic:     INCBIN "pic/trainer/blackbelt.pic"
Rival1Pic:        INCBIN "pic/ytrainer/rival1.pic"
ProfOakPic:       INCBIN "pic/trainer/prof.oak.pic"
ChiefPic:
ScientistPic:     INCBIN "pic/trainer/scientist.pic"
GiovanniPic:      INCBIN "pic/trainer/giovanni.pic"
RocketPic:        INCBIN "pic/trainer/rocket.pic"
CooltrainerMPic:  INCBIN "pic/trainer/cooltrainerm.pic"
CooltrainerFPic:  INCBIN "pic/trainer/cooltrainerf.pic"
BrunoPic:         INCBIN "pic/trainer/bruno.pic"
BrockPic:         INCBIN "pic/ytrainer/brock.pic"
MistyPic:         INCBIN "pic/ytrainer/misty.pic"
LtSurgePic:       INCBIN "pic/trainer/lt.surge.pic"
ErikaPic:         INCBIN "pic/ytrainer/erika.pic"
KogaPic:          INCBIN "pic/trainer/koga.pic"
BlainePic:        INCBIN "pic/trainer/blaine.pic"
SabrinaPic:       INCBIN "pic/trainer/sabrina.pic"
GentlemanPic:     INCBIN "pic/trainer/gentleman.pic"
Rival2Pic:        INCBIN "pic/ytrainer/rival2.pic"
Rival3Pic:        INCBIN "pic/ytrainer/rival3.pic"
LoreleiPic:       INCBIN "pic/trainer/lorelei.pic"
ChannelerPic:     INCBIN "pic/trainer/channeler.pic"
AgathaPic:        INCBIN "pic/trainer/agatha.pic"
LancePic:         INCBIN "pic/trainer/lance.pic"
JessieJamesPic:   INCBIN "pic/ytrainer/jessiejames.pic"

; 4fe79 (13:7e79)

INCLUDE "data/mapHeaders/tradecenter.asm"
INCLUDE "scripts/tradecenter.asm"
INCLUDE "data/mapObjects/tradecenter.asm"
TradeCenterBlocks:
INCBIN "maps/tradecenter.blk"

; 4fee6 (13:7ee6)

INCLUDE "data/mapHeaders/colosseum.asm"
INCLUDE "scripts/colosseum.asm"
INCLUDE "data/mapObjects/colosseum.asm"
ColosseumBlocks:
INCBIN "maps/colosseum.blk"


SECTION "bank14",ROMX,BANK[$14]

INCLUDE "data/mapHeaders/route22.asm"
INCLUDE "data/mapObjects/route22.asm"
Route22Blocks:
INCBIN "maps/route22.blk"
INCLUDE "data/mapHeaders/route20.asm"
INCLUDE "data/mapObjects/route20.asm"
Route20Blocks:
INCBIN "maps/route20.blk"

INCLUDE "data/mapHeaders/route23.asm"
INCLUDE "data/mapObjects/route23.asm"
Route23Blocks:
INCBIN "maps/route23.blk"

INCLUDE "data/mapHeaders/route24.asm"
INCLUDE "data/mapObjects/route24.asm"
Route24Blocks: ; 506ed (14:46ed)
INCBIN "maps/route24.blk"

INCLUDE "data/mapHeaders/route25.asm"
INCLUDE "data/mapObjects/route25.asm"
Route25Blocks: ; 50816 (14:4816)
INCBIN "maps/route25.blk"

; indigoplateau
INCLUDE "data/mapHeaders/indigoplateau.asm"
INCLUDE "scripts/indigoplateau.asm"
INCLUDE "data/mapObjects/indigoplateau.asm"
IndigoPlateauBlocks: ; 50950 (14:4950)
INCBIN "maps/indigoplateau.blk"

INCLUDE "data/mapHeaders/saffroncity.asm"
INCLUDE "data/mapObjects/saffroncity.asm"
SaffronCityBlocks: ; 50a98 (14:4a98)
INCBIN "maps/saffroncity.blk"
INCLUDE "scripts/saffroncity.asm"
INCLUDE "scripts/route20.asm"
INCLUDE "scripts/route22.asm"
INCLUDE "scripts/route23.asm"
INCLUDE "scripts/route24.asm"
INCLUDE "scripts/route25.asm"

; victoryroad2
	dr $517cc,$52060
Mansion2Script_Switches:
	dr $52060,$522a3
Mansion3Script_Switches:
	dr $522a3,$52449
Mansion4Script_Switches:
	dr $52449,$525d8
INCLUDE "engine/overworld/card_key.asm"

INCLUDE "engine/menu/prize_menu.asm"

INCLUDE "engine/hidden_object_functions14.asm"

SECTION "bank15",ROMX,BANK[$15]
INCLUDE "data/mapHeaders/route2.asm"
INCLUDE "data/mapObjects/route2.asm"
Route2Blocks: ; 54086
INCBIN "maps/route2.blk"

INCLUDE "data/mapHeaders/route3.asm"
INCLUDE "data/mapObjects/route3.asm"
Route3Blocks: ; 5425d
INCBIN "maps/route3.blk"

INCLUDE "data/mapHeaders/route4.asm"
INCLUDE "data/mapObjects/route4.asm"
Route4Blocks: ; 543f4
INCBIN "maps/route4.blk"

INCLUDE "data/mapHeaders/route5.asm"
INCLUDE "data/mapObjects/route5.asm"
Route5Blocks: ; 545da
INCBIN "maps/route5.blk"

	dr $5468e,$54706
Route9Blocks: ; 54706
INCBIN "maps/route9.blk"

INCLUDE "data/mapHeaders/route13.asm"
INCLUDE "data/mapObjects/route13.asm"
Route13Blocks:
INCBIN "maps/route13.blk"

INCLUDE "data/mapHeaders/route14.asm"
INCLUDE "data/mapObjects/route14.asm"
Route14Blocks:
INCBIN "maps/route14.blk"

INCLUDE "data/mapHeaders/route17.asm"
INCLUDE "data/mapObjects/route17.asm"
Route17Blocks:
INCBIN "maps/route17.blk"

INCLUDE "data/mapHeaders/route19.asm"
INCLUDE "data/mapObjects/route19.asm"
Route19Blocks:
INCBIN "maps/route19.blk"
INCLUDE "data/mapHeaders/route21.asm"
INCLUDE "data/mapObjects/route21.asm"
Route21Blocks: ; 5507d
INCBIN "maps/route21.blk"
	dr $5523f,$5525f

INCLUDE "engine/battle/experience.asm"

INCLUDE "scripts/route2.asm"
INCLUDE "scripts/route3.asm"
INCLUDE "scripts/route4.asm"
INCLUDE "scripts/route5.asm"
	dr $556d0,$55832
INCLUDE "scripts/route13.asm"
INCLUDE "scripts/route14.asm"
INCLUDE "scripts/route17.asm"
INCLUDE "scripts/route19.asm"
INCLUDE "scripts/route21.asm"
	dr $56054,$56714

INCLUDE "engine/menu/diploma_1.asm"

INCLUDE "engine/overworld/trainers.asm"


SECTION "bank16",ROMX,BANK[$16]

INCLUDE "data/mapHeaders/route6.asm"
INCLUDE "data/mapObjects/route6.asm"
Route6Blocks: ; 58079
INCBIN "maps/route6.blk"

	dr $5812d,$581c6
Route8Blocks: ; 581c6
INCBIN "maps/route8.blk"

INCLUDE "data/mapHeaders/route10.asm"
INCLUDE "data/mapObjects/route10.asm"
Route10Blocks:
INCBIN "maps/route10.blk"

INCLUDE "data/mapHeaders/route11.asm"
INCLUDE "data/mapObjects/route11.asm"
Route11Blocks: ; 5855f
INCBIN "maps/route11.blk"

INCLUDE "data/mapHeaders/route12.asm"
INCLUDE "data/mapObjects/route12.asm"
Route12Blocks:
INCBIN "maps/route12.blk"

INCLUDE "data/mapHeaders/route15.asm"
INCLUDE "data/mapObjects/route15.asm"
Route15Blocks:
INCBIN "maps/route15.blk"

INCLUDE "data/mapHeaders/route16.asm"
INCLUDE "data/mapObjects/route16.asm"
Route16Blocks: ; 58b84
INCBIN "maps/route16.blk"

INCLUDE "data/mapHeaders/route18.asm"
INCLUDE "data/mapObjects/route18.asm"
Route18Blocks:
INCBIN "maps/route18.blk"
	dr $58d7d,$58d99

INCLUDE "engine/experience.asm"

INCLUDE "engine/status_ailments.asm"

INCLUDE "engine/overworld/oaks_aide.asm"

INCLUDE "scripts/route6.asm"
	dr $59052,$591d2
INCLUDE "scripts/route10.asm"
INCLUDE "scripts/route11.asm"
INCLUDE "scripts/route12.asm"
INCLUDE "scripts/route15.asm"
INCLUDE "scripts/route16.asm"
INCLUDE "scripts/route18.asm"
	dr $59a00,$5a53a
	
INCLUDE "engine/overworld/saffron_guards.asm"


SECTION "bank17",ROMX,BANK[$17]

	dr $5c000,$5da70

INCLUDE "engine/evolution.asm"

	dr $5db93,$5dbae

INCLUDE "engine/hidden_object_functions17.asm"

SECTION "bank18",ROMX,BANK[$18]

	dr $60000,$625e8
INCLUDE "engine/hidden_object_functions18.asm"

SECTION "bank19",ROMX,BANK[$19]
Overworld_GFX:
	dr $64000,$68000


SECTION "bank1A",ROMX,BANK[$1A]

	dr $68000,$6bff1


SECTION "bank1B",ROMX,BANK[$1B]
Cemetery_GFX:      INCBIN "gfx/tilesets/cemetery.t4.2bpp"
Cemetery_Block:    INCBIN "gfx/blocksets/cemetery.bst"
Cavern_GFX:        INCBIN "gfx/tilesets/cavern.t14.2bpp"
Cavern_Block:      INCBIN "gfx/blocksets/cavern.bst"
Lobby_GFX:         INCBIN "gfx/tilesets/lobby.t2.2bpp"
Lobby_Block:       INCBIN "gfx/blocksets/lobby.bst"
Ship_GFX:          INCBIN "gfx/tilesets/ship.t6.2bpp"
Ship_Block:        INCBIN "gfx/blocksets/ship.bst"
Lab_GFX:           INCBIN "gfx/tilesets/lab.t4.2bpp"
Lab_Block:         INCBIN "gfx/blocksets/lab.bst"
Club_GFX:          INCBIN "gfx/tilesets/club.t5.2bpp"
Club_Block:        INCBIN "gfx/blocksets/club.bst"
Underground_GFX:   INCBIN "gfx/tilesets/underground.t7.2bpp"
Underground_Block: INCBIN "gfx/blocksets/underground.bst"


SECTION "bank1C",ROMX,BANK[$1C]

INCLUDE "engine/gamefreak.asm"
INCLUDE "engine/hall_of_fame.asm"
INCLUDE "engine/overworld/healing_machine.asm"
INCLUDE "engine/overworld/player_animations.asm"
INCLUDE "engine/battle/ghost_marowak_anim.asm"
INCLUDE "engine/battle/battle_transitions.asm"
INCLUDE "engine/town_map.asm"
INCLUDE "engine/mon_party_sprites.asm"
INCLUDE "engine/in_game_trades.asm"
INCLUDE "engine/palettes.asm"
INCLUDE "engine/save.asm"


SECTION "bank1D",ROMX,BANK[$1D]

	dr $74000,$7405c

INCLUDE "engine/items/itemfinder.asm"
INCLUDE "scripts/ceruleancity2.asm"
	dr $740d4,$74726
VendingMachineMenu: ; 74726 (1d:4726)
	dr $74726,$75dfe
PKMNLeaguePC: ; 75dfe (1d:5dfe)
	dr $75dfe,$75f74

INCLUDE "engine/overworld/hidden_items.asm"

SECTION "bank1E",ROMX,BANK[$1E]

INCLUDE "engine/battle/animations.asm"

INCLUDE "engine/overworld/cut2.asm"

INCLUDE "engine/overworld/ssanne.asm"

RedFishingTilesFront: INCBIN "gfx/red_fishing_tile_front.2bpp"
RedFishingTilesBack:  INCBIN "gfx/red_fishing_tile_back.2bpp"
RedFishingTilesSide:  INCBIN "gfx/red_fishing_tile_side.2bpp"
RedFishingRodTiles:   INCBIN "gfx/red_fishingrod_tiles.2bpp"

INCLUDE "data/animations.asm"

SECTION "bank2f",ROMX[$5000],BANK[$2F]

INCLUDE "engine/bg_map_attributes.asm"

SECTION "bank30",ROMX,BANK[$30]

	dr $c0000,$c4000

SECTION "bank39",ROMX,BANK[$39]
Pic_e4000: ; e4000
	dr $e4000, $e40cc
GFX_e40cc: ; e40cc
	dr $e40cc, $e411c
Pic_e411c: ; e411c
	dr $e411c, $e41d2
GFX_e41d2: ; e41d2
	dr $e41d2, $e4272
Pic_e4272: ; e4272
	dr $e4272, $e4323
GFX_e4323: ; e4323
	dr $e4323, $e4383
Pic_e4383: ; e4383
	dr $e4383, $e444b
GFX_e444b: ; e444b
	dr $e444b, $e458b
Pic_e458b: ; e458b
	dr $e458b, $e463b
GFX_e463b: ; e463b
	dr $e463b, $e467b
Pic_e467b: ; e467b
	dr $e467b, $e472e
GFX_e472e: ; e472e
	dr $e472e, $e476e
Pic_e476e: ; e476e
	dr $e476e, $e4841
GFX_e4841: ; e4841
	dr $e4841, $e49d1
Pic_e49d1: ; e49d1
	dr $e49d1, $e4a99
GFX_e4a99: ; e4a99
	dr $e4a99, $e4b39
Pic_e4b39: ; e4b39
	dr $e4b39, $e4bde
GFX_e4bde: ; e4bde
	dr $e4bde, $e4c3e
Pic_e4c3e: ; e4c3e
	dr $e4c3e, $e4ce0
GFX_e4ce0: ; e4ce0
	dr $e4ce0, $e4e70
GFX_e4e70: ; e4e70
	dr $e4e70, $e5000
Pic_e5000: ; e5000
	dr $e5000, $e50af
GFX_e50af: ; e50af
	dr $e50af, $e523f
Pic_e523f: ; e523f
	dr $e523f, $e52fe
GFX_e52fe: ; e52fe
	dr $e52fe, $e548e
Pic_e548e: ; e548e
	dr $e548e, $e5541
GFX_e5541: ; e5541
	dr $e5541, $e56d1
Pic_e56d1: ; e56d1
	dr $e56d1, $e5794
GFX_e5794: ; e5794
	dr $e5794, $e5924
Pic_e5924: ; e5924
	dr $e5924, $e59ed
GFX_e59ed: ; e59ed
	dr $e59ed, $e5b7d
Pic_e5b7d: ; e5b7d
	dr $e5b7d, $e5c4d
GFX_e5c4d: ; e5c4d
	dr $e5c4d, $e5ddd
Pic_e5ddd: ; e5ddd
	dr $e5ddd, $e5e90
GFX_e5e90: ; e5e90
	dr $e5e90, $e6020
GFX_e6020: ; e6020
	dr $e6020, $e61b0
GFX_e61b0: ; e61b0
	dr $e61b0, $e6340
Pic_e6340: ; e6340
	dr $e6340, $e63f7
GFX_e63f7: ; e63f7
	dr $e63f7, $e6587
Pic_e6587: ; e6587
	dr $e6587, $e6646
GFX_e6646: ; e6646
	dr $e6646, $e67d6
Pic_e67d6: ; e67d6
	dr $e67d6, $e682f
GFX_e682f: ; e682f
	dr $e682f, $e69bf
GFX_e69bf: ; e69bf
	dr $e69bf, $e6b4f
GFX_e6b4f: ; e6b4f
	dr $e6b4f, $e6cdf
GFX_e6cdf: ; e6cdf
	dr $e6cdf, $e6e6f
GFX_e6e6f: ; e6e6f
	dr $e6e6f, $e6fff
GFX_e6fff: ; e6fff
	dr $e6fff, $e718f
GFX_e718f: ; e718f
	dr $e718f, $e731f
GFX_e731f: ; e731f
	dr $e731f, $e74af
GFX_e74af: ; e74af
	dr $e74af, $e763f
GFX_e763f: ; e763f
	dr $e763f, $e77cf
Pic_e77cf: ; e77cf
	dr $e77cf, $e7863
GFX_e7863: ; e7863
	dr $e7863, $e79f3
GFX_e79f3: ; e79f3
	dr $e79f3, $e7b83
GFX_e7b83: ; e7b83
	dr $e7b83, $e7d13
GFX_e7d13: ; e7d13
	dr $e7d13, $e7ea3

SECTION "bank3A",ROMX,BANK[$3A]
INCLUDE "text/monster_names.asm"
IsPlayerJustOutsideMap: ; e876c (3a:476c)
	ld a, [wYCoord]
	ld b, a
	ld a, [wCurMapHeight]
	call Func_e877e
	ret z
	ld a, [wXCoord]
	ld b, a
	ld a, [wCurMapWidth]
Func_e877e:
	add a
	cp b
	ret z
	inc b
	ret

INCLUDE "engine/printer.asm"
INCLUDE "engine/diploma_3a.asm"

SurfingPikachu3Graphics:  INCBIN "gfx/surfing_pikachu_3.t1.2bpp"
SurfingPikachu3GraphicsEnd:

INCLUDE "engine/unknown_ea3ea.asm"

FreezeEnemyTrainerSprite: ; eaa02 (3a:6a02)
	ld a, [wCurMap]
	cp POKEMONTOWER_7
	ret z ; the Rockets on Pokemon Tower 7F leave after battling, so don't freeze them
	ld hl, RivalIDs
	ld a, [wEngagedTrainerClass]
	ld b, a
.loop
	ld a, [hli]
	cp $ff
	jr z, .notRival
	cp b
	ret z ; the rival leaves after battling, so don't freeze him
	jr .loop
.notRival
	ld a, [wSpriteIndex]
	ld [H_SPRITEINDEX], a
	jp SetSpriteMovementBytesToFF

RivalIDs: ; eaa20 (3a:6a20)
	db OPP_SONY1
	db OPP_SONY2
	db OPP_SONY3
	db $ff

SECTION "bank3C",ROMX,BANK[$3C]

INCLUDE "engine/bank3c.asm"

SECTION "bank3D",ROMX,BANK[$3D]

INCLUDE "engine/bank3d.asm"

SECTION "bank3E",ROMX,BANK[$3E]
Func_f8000: ; f8000
	dr $f8000,$f8bcb

Func_f8bcb: ; f8bcb
	push de
	callab IsSurfingPikachuInThePlayersParty
	pop de
	ret nc
	callab PlayPikachuSoundClip
	ret

Func_f8bdf: ; f8bdf
	dr $f8bdf,$f982d
PlayIntroScene: ; f982d (3e:582d)
	dr $f982d,$fa35a

YellowIntroGraphics:  INCBIN "gfx/yellow_intro.2bpp"

Func_fbb5a:
	ld hl, wTileMapBackup
	ld bc, 10 * SCREEN_WIDTH
	xor a
	call FillMemory
	ret

Func_fbb65:
	dr $fbb65,$fbd76

SECTION "bank3F",ROMX,BANK[$3F]

INCLUDE "engine/bank3f.asm"
