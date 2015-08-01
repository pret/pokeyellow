INCLUDE "yellow.asm"
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

INCBIN "baserom.gbc",$414b,$8000 - $414b


SECTION "bank02",ROMX,BANK[$02]

INCBIN "baserom.gbc",$8000,$c000 - $8000


SECTION "bank03",ROMX,BANK[$03]

INCBIN "baserom.gbc",$c000,$e91b - $c000

GymLeaderFaceAndBadgeTileGraphics: ; e91b (3:691b)
	INCBIN "gfx/badges.2bpp"

INCBIN "baserom.gbc",$ed1b,$10000 - $ed1b


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

INCBIN "baserom.gbc",$11468,$11a97 - $11468

RedPicFront:: INCBIN "pic/ytrainer/red.pic"
ShrinkPic1::  INCBIN "pic/trainer/shrink1.pic"
ShrinkPic2::  INCBIN "pic/trainer/shrink2.pic"

INCBIN "baserom.gbc",$11c22,$12365 - $11c22


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

INCBIN "baserom.gbc",$13765,$14000 - $13765


SECTION "NPC Sprites 2", ROMX, BANK[NPC_SPRITES_2]

INCBIN "baserom.gbc",$14000,$143f1 - $14000

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

INCBIN "baserom.gbc",$17c31,$18000 - $17c31


SECTION "bank06",ROMX,BANK[$06]

INCBIN "baserom.gbc",$18000,$1c000 - $18000


SECTION "bank07",ROMX,BANK[$07]

INCBIN "baserom.gbc",$1c000,$20000 - $1c000


SECTION "bank08",ROMX,BANK[$08]

INCBIN "baserom.gbc",$20000,$24000 - $20000


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

INCBIN "baserom.gbc",$27d20,$28000 - $27d20


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

INCBIN "baserom.gbc",$2bd4c,$2c000 - $2bd4c


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

INCBIN "baserom.gbc",$2fd25,$30000 - $2fd25


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

INCBIN "baserom.gbc",$3749e,$38000 - $3749e


SECTION "bank0E",ROMX,BANK[$0E]

INCBIN "baserom.gbc",$38000,$3aa68 - $38000

TradingAnimationGraphics:
	INCBIN "gfx/game_boy.norepeat.2bpp"
	INCBIN "gfx/link_cable.2bpp"

TradingAnimationGraphics2:
; Pokeball traveling through the link cable.
	INCBIN "gfx/trade2.2bpp"

INCBIN "baserom.gbc",$3adb8,$3c000 - $3adb8


SECTION "bank0F",ROMX,BANK[$0F]

INCBIN "baserom.gbc",$3c000,$40000 - $3c000


SECTION "bank10",ROMX,BANK[$10]

INCBIN "baserom.gbc",$40000,$44000 - $40000


SECTION "bank11",ROMX,BANK[$11]

INCBIN "baserom.gbc",$44000,$48000 - $44000


SECTION "bank12",ROMX,BANK[$12]

INCBIN "baserom.gbc",$48000,$4c000 - $48000


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

INCBIN "baserom.gbc",$4fe79,$50000 - $4fe79


SECTION "bank14",ROMX,BANK[$14]

INCBIN "baserom.gbc",$50000,$54000 - $50000


SECTION "bank15",ROMX,BANK[$15]

INCBIN "baserom.gbc",$54000,$58000 - $54000


SECTION "bank16",ROMX,BANK[$16]

INCBIN "baserom.gbc",$58000,$5c000 - $58000


SECTION "bank17",ROMX,BANK[$17]

INCBIN "baserom.gbc",$5c000,$60000 - $5c000


SECTION "bank18",ROMX,BANK[$18]

INCBIN "baserom.gbc",$60000,$64000 - $60000


SECTION "bank19",ROMX,BANK[$19]

INCBIN "baserom.gbc",$64000,$68000 - $64000


SECTION "bank1A",ROMX,BANK[$1A]

INCBIN "baserom.gbc",$68000,$6c000 - $68000


SECTION "bank1B",ROMX,BANK[$1B]

INCBIN "baserom.gbc",$6c000,$70000 - $6c000


SECTION "bank1C",ROMX,BANK[$1C]

INCLUDE "engine/gamefreak.asm"
INCLUDE "engine/hall_of_fame.asm"
INCLUDE "engine/overworld/healing_machine.asm"
INCLUDE "engine/overworld/player_animations.asm"
INCLUDE "engine/battle/ghost_marowak_anim.asm"
INCLUDE "engine/battle/battle_transitions.asm"
INCLUDE "engine/town_map.asm"

INCBIN "baserom.gbc",$71784,$71eb3 - $71784

INCLUDE "engine/palettes.asm"

PokemonYellowGraphics:  INCBIN "gfx/pokemon_yellow.t6.2bpp"

INCBIN "baserom.gbc",$73959,$74000 - $73959


SECTION "bank1D",ROMX,BANK[$1D]

INCBIN "baserom.gbc",$74000,$78000 - $74000


SECTION "bank1E",ROMX,BANK[$1E]

INCBIN "baserom.gbc",$78000,$7a19a - $78000

RedFishingTilesFront: INCBIN "gfx/red_fishing_tile_front.2bpp"
RedFishingTilesBack:  INCBIN "gfx/red_fishing_tile_back.2bpp"
RedFishingTilesSide:  INCBIN "gfx/red_fishing_tile_side.2bpp"
RedFishingRodTiles:   INCBIN "gfx/red_fishingrod_tiles.2bpp"

INCBIN "baserom.gbc",$7a22a,$7c000 - $7a22a


SECTION "bank1F",ROMX,BANK[$1F]

INCBIN "baserom.gbc",$7c000,$80000 - $7c000


SECTION "bank20",ROMX,BANK[$20]

INCBIN "baserom.gbc",$80000,$80f14 - $80000

SurfingPikachu1Graphics:  INCBIN "gfx/surfing_pikachu_1.t4.2bpp"

INCBIN "baserom.gbc",$82bd4,$84000 - $82bd4


SECTION "bank21",ROMX,BANK[$21]

INCBIN "baserom.gbc",$84000,$88000 - $84000


SECTION "bank22",ROMX,BANK[$22]

INCBIN "baserom.gbc",$88000,$8c000 - $88000


SECTION "bank23",ROMX,BANK[$23]

INCBIN "baserom.gbc",$8c000,$90000 - $8c000


SECTION "bank24",ROMX,BANK[$24]

INCBIN "baserom.gbc",$90000,$94000 - $90000


SECTION "bank25",ROMX,BANK[$25]

INCBIN "baserom.gbc",$94000,$98000 - $94000


SECTION "bank2f",ROMX[$5000],BANK[$2F]

INCBIN "baserom.gbc",$bd000,$c0000 - $bd000


SECTION "bank30",ROMX,BANK[$30]

INCBIN "baserom.gbc",$c0000,$c4000 - $c0000


SECTION "bank31",ROMX,BANK[$31]

INCBIN "baserom.gbc",$c4000,$c8000 - $c4000


SECTION "bank32",ROMX,BANK[$32]

INCBIN "baserom.gbc",$c8000,$cc000 - $c8000


SECTION "bank33",ROMX,BANK[$33]

INCBIN "baserom.gbc",$cc000,$d0000 - $cc000


SECTION "bank34",ROMX,BANK[$34]

INCBIN "baserom.gbc",$d0000,$d4000 - $d0000


SECTION "bank35",ROMX,BANK[$35]

INCBIN "baserom.gbc",$d4000,$d8000 - $d4000


SECTION "bank36",ROMX,BANK[$36]

INCBIN "baserom.gbc",$d8000,$dc000 - $d8000


SECTION "bank37",ROMX,BANK[$37]

INCBIN "baserom.gbc",$dc000,$e0000 - $dc000


SECTION "bank38",ROMX,BANK[$38]

INCBIN "baserom.gbc",$e0000,$e4000 - $e0000


SECTION "bank39",ROMX,BANK[$39]

INCBIN "baserom.gbc",$e4000,$e8000 - $e4000


SECTION "bank3A",ROMX,BANK[$3A]

INCBIN "baserom.gbc",$e8000,$e928a - $e8000

SurfingPikachu2Graphics:  INCBIN "gfx/surfing_pikachu_2.2bpp"

INCBIN "baserom.gbc",$e988a,$e9bfa - $e988a

SurfingPikachu3Graphics:  INCBIN "gfx/surfing_pikachu_3.t1.2bpp"

INCBIN "baserom.gbc",$ea3ea,$ec000 - $ea3ea

SECTION "bank3C",ROMX,BANK[$3C]

INCLUDE "engine/bank3c/main.asm"

SECTION "bank3D",ROMX,BANK[$3D]

INCLUDE "engine/bank3d/main.asm"

SECTION "bank3E",ROMX,BANK[$3E]

INCBIN "baserom.gbc",$f8000,$fa35a - $f8000

YellowIntroGraphics:  INCBIN "gfx/yellow_intro.2bpp"

INCBIN "baserom.gbc",$fbb5a,$fc000 - $fbb5a


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

