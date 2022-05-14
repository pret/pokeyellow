TrainerDataPointers:
	dw YoungsterData
	dw BugCatcherData
	dw LassData
	dw SailorData
	dw JrTrainerMData
	dw JrTrainerFData
	dw PokemaniacData
	dw SuperNerdData
	dw HikerData
	dw BikerData
	dw BurglarData
	dw EngineerData
	dw UnusedJugglerData
	dw FisherData
	dw SwimmerData
	dw CueBallData
	dw GamblerData
	dw BeautyData
	dw PsychicData
	dw RockerData
	dw JugglerData
	dw TamerData
	dw BirdKeeperData
	dw BlackbeltData
	dw Rival1Data
	dw ProfOakData
	dw ChiefData
	dw ScientistData
	dw GiovanniData
	dw RocketData
	dw CooltrainerMData
	dw CooltrainerFData
	dw BrunoData
	dw BrockData
	dw MistyData
	dw LtSurgeData
	dw ErikaData
	dw KogaData
	dw BlaineData
	dw SabrinaData
	dw GentlemanData
	dw Rival2Data
	dw Rival3Data
	dw LoreleiData
	dw ChannelerData
	dw AgathaData
	dw LanceData

; if first byte != $FF, then
	; first byte is level (of all pokemon on this team)
	; all the next bytes are pokemon species
	; null-terminated
; if first byte == $FF, then
	; first byte is $FF (obviously)
	; every next two bytes are a level and species
	; null-terminated

YoungsterData:
; Route 3
	db 13, RATTATA, EKANS, ZUBAT, 0
	db $FF, 15, SPEAROW, 13, DODUO, 0
; Mt. Moon 1F
	db $FF, 22, ZUBAT, 22, KRABBY, 20, GLOOM, 0
; Route 24
	db 20, WEEPINBELL, DITTO, 0
; Route 25
	db $FF, 20, RATICATE, 21, ARBOK, 0
	db 22, ARBOK, DITTO, 0
	db 21, PINSIR, PIDGEOT, 0
; SS Anne 1F Rooms
	db 30, NIDOKING, MAROWAK, 0
; Route 11
	db 28, RATICATE, 0
	db 28, PIDGEOT, TANGELA, 0
	db 27, PINSIR, GRAVELER, 0
	db $FF, 27, VILEPLUME, 28, POLIWRATH, 30, ARBOK, 0
; Unused
	db 17, SPEAROW, RATTATA, RATTATA, SPEAROW, 0
	db 24, SANDSHREW, 0

BugCatcherData:
; Viridian Forest
	db 8, KAKUNA, METAPOD, 0
	db $FF, 9, KAKUNA, 9, METAPOD, 8, VENONAT, 8, PARAS, 0
	db 12, BUTTERFREE, 0
; Route 3
	db $FF, 12, BEEDRILL, 12, BUTTERFREE, 13, VENONAT, 0
	db 14, PARAS, VENONAT, BELLSPROUT, 0
	db 14, BEEDRILL, BUTTERFREE, 0
; Mt. Moon 1F
	db $FF, 15, BEEDRILL, 14, BUTTERFREE, 0
	db $FF, 18, NIDORINO, 20, EKANS, 20, VENONAT, 0
; Route 24
	db 19, SCYTHER, PINSIR, 0
; Route 6
	db 26, FARFETCHD, PARASECT, 0
	db 90, CATERPIE, WEEDLE, 0
; Unused
	db 18, METAPOD, CATERPIE, VENONAT, 0
; Route 9
	db 19, BEEDRILL, BEEDRILL, 0
	db 20, CATERPIE, WEEDLE, VENONAT, 0
	db 8, CATERPIE, METAPOD, 0

LassData:
; Route 3
	db 13, CLEFAIRY, NIDORAN_F, NIDORAN_M, 0
	db $FF, 16, NIDORAN_M, 16, NIDORAN_F, 14, NIDORINA, 0
	db 16, JIGGLYPUFF, CLEFAIRY, 0
; Route 4
	db 21, PARASECT, MAROWAK, 0
; Mt. Moon 1F
	db $FF, 14, POLIWHIRL, 16, CLEFAIRY, 0
	db 17, KABUTO, DIGLETT, PIKACHU, 0
; Route 24
	db 20, GLOOM, NIDORINO, NIDORINA, 0
	db 20, GYARADOS, 0
; Route 25
	db 20, NINETALES, VICTREEBEL, 0
	db 23, IVYSAUR, CHARMELEON, WARTORTLE, 0
; SS Anne 1F Rooms
	db $FF, 30, DEWGONG, 28, CLEFABLE, 0
; SS Anne 2F Rooms
	db 30, PERSIAN, 0
; Route 8
	db 23, NIDORAN_F, NIDORINA, 0
	db 24, MEOWTH, MEOWTH, MEOWTH, 0
	db 19, PIDGEY, RATTATA, NIDORAN_F, MEOWTH, NIDORAN_M, 0
	db 22, CLEFAIRY, CLEFAIRY, 0
; Celadon Gym
	db 23, BELLSPROUT, WEEPINBELL, 0
	db 23, ODDISH, GLOOM, 0
	db 6, NIDORAN_F, NIDORAN_M, 0

SailorData:
; SS Anne Stern
	db 30, MACHOKE, FEAROW, 0
	db $FF, 30, RATICATE, 29, NIDOKING, 0
; SS Anne B1F Rooms
	db 30, RATICATE, MACHOKE, 0
	db 30, FEAROW, PRIMEAPE, 0
	db 30, SEADRA, GYARADOS, 0
	db 30, KINGLER, GOLDUCK, RATICATE, 0
	db 30, SEADRA, PRIMEAPE, 0
; Vermilion Gym
	db $FF, 33, MAGNETON, 32, TENTACRUEL, 0

JrTrainerMData:
; Pewter Gym
	db $FF, 13, GEODUDE, 10, DIGLETT, 10, SANDSHREW, 0
; Route 24/Route 25
	db $FF, 20, PRIMEAPE, 21, MAGNETON, 0
; Route 24
	db 20, KADABRA, FARFETCHD, 0
; Route 6
	db $FF, 25, PERSIAN, 26, ARCANINE, 0
	db $FF, 28, KADABRA, 27, MAGNETON, 27, NIDOKING, 0
; Unused
	db 18, DIGLETT, DIGLETT, SANDSHREW, 0
; Route 9
	db 21, GROWLITHE, CHARMANDER, 0
	db 19, RATTATA, DIGLETT, EKANS, SANDSHREW, 0
; Route 12
	db 29, NIDORAN_M, NIDORINO, 0
	db 16, WEEPINBELL, 0

JrTrainerFData:
; Cerulean Gym
	db 25, SEADRA, SEAKING, 0
; Route 6
	db $FF, 28, WIGGLYTUFF, 25, CLEFABLE, 0
	db $FF, 27, DUGTRIO, 28, PIDGEOT, 27, NIDOQUEEN, 0
; Unused
	db 22, BULBASAUR, 0
; Route 9
	db 18, ODDISH, BELLSPROUT, ODDISH, BELLSPROUT, 0
	db 23, MEOWTH, 0
; Route 10
	db 20, JIGGLYPUFF, CLEFAIRY, 0
	db 21, PIDGEY, PIDGEOTTO, 0
; Rock Tunnel B1F
	db 21, JIGGLYPUFF, PIDGEY, MEOWTH, 0
	db 22, ODDISH, BULBASAUR, 0
; Celadon Gym
	db 24, BULBASAUR, IVYSAUR, 0
; Route 13
	db 24, PIDGEY, MEOWTH, RATTATA, PIDGEY, MEOWTH, 0
	db 30, POLIWAG, POLIWAG, 0
	db 27, PIDGEY, MEOWTH, PIDGEY, PIDGEOTTO, 0
	db 28, GOLDEEN, POLIWAG, HORSEA, 0
; Route 20
	db 31, GOLDEEN, SEAKING, 0
; Rock Tunnel 1F
	db 22, BELLSPROUT, CLEFAIRY, 0
	db 20, MEOWTH, ODDISH, PIDGEY, 0
	db 19, PIDGEY, RATTATA, RATTATA, BELLSPROUT, 0
; Route 15
	db 28, GLOOM, ODDISH, ODDISH, 0
	db 29, PIDGEY, PIDGEOTTO, 0
	db 33, CLEFAIRY, 0
	db 29, BELLSPROUT, ODDISH, TANGELA, 0
; Route 20
	db 30, TENTACOOL, HORSEA, SEEL, 0
	db 20, CUBONE, 0

PokemaniacData:
; Route 10
	db 30, RHYHORN, LICKITUNG, 0
	db 20, CUBONE, SLOWPOKE, 0
; Rock Tunnel B1F
	db 20, SLOWPOKE, SLOWPOKE, SLOWPOKE, 0
	db 22, CHARMANDER, CUBONE, 0
	db 25, SLOWPOKE, 0
; Victory Road 2F
	db 40, CHARMELEON, LAPRAS, LICKITUNG, 0
; Rock Tunnel 1F
	db 23, CUBONE, SLOWPOKE, 0

SuperNerdData:
; Mt. Moon 1F
	db 18, MAGNEMITE, VOLTORB, 0
; Mt. Moon B2F
	db 20, VOLTORB, GEODUDE, SHELLDER, EXEGGCUTE, 0
; Route 8
	db 20, VOLTORB, KOFFING, VOLTORB, MAGNEMITE, 0
	db 22, GRIMER, MUK, GRIMER, 0
	db 26, KOFFING, 0
; Unused
	db 22, KOFFING, MAGNEMITE, WEEZING, 0
	db 20, MAGNEMITE, MAGNEMITE, KOFFING, MAGNEMITE, 0
	db 24, MAGNEMITE, VOLTORB, 0
; Cinnabar Gym
	db 36, VULPIX, VULPIX, NINETALES, 0
	db 34, PONYTA, CHARMANDER, VULPIX, GROWLITHE, 0
	db 41, RAPIDASH, 0
	db 37, GROWLITHE, VULPIX, 0

HikerData:
; Mt. Moon 1F
	db 20, RHYHORN, GASTLY, GOLDUCK, 0
; Route 25
	db 20, WIGGLYTUFF, SEADRA, RHYHORN, 0
	db $FF, 20, MACHOKE, 20, RATICATE, 22, ONIX, 0
	db 20, LICK, WRAP, BODY_SLAM, 0
; Route 9
	db 21, GEODUDE, ONIX, 0
	db 20, GEODUDE, MACHOP, GEODUDE, 0
; Route 10
	db 21, GEODUDE, ONIX, 0
	db 19, ONIX, GRAVELER, 0
; Rock Tunnel B1F
	db 21, GEODUDE, GEODUDE, GRAVELER, 0
	db 25, GEODUDE, 0
; Route 9/Rock Tunnel B1F
	db 20, MACHOP, ONIX, 0
; Rock Tunnel 1F
	db 19, GEODUDE, MACHOP, GEODUDE, GEODUDE, 0
	db 20, ONIX, ONIX, GEODUDE, 0
	db 21, GEODUDE, GRAVELER, 0

BikerData:
; Route 13
	db 28, KOFFING, KOFFING, KOFFING, 0
; Route 14
	db 29, KOFFING, GRIMER, 0
; Route 15
	db 25, KOFFING, KOFFING, WEEZING, KOFFING, GRIMER, 0
	db 28, KOFFING, GRIMER, WEEZING, 0
; Route 16
	db 29, GRIMER, KOFFING, 0
	db 33, WEEZING, 0
	db 26, GRIMER, GRIMER, GRIMER, GRIMER, 0
; Route 17
	db 28, WEEZING, KOFFING, WEEZING, 0
	db 33, MUK, 0
	db 29, VOLTORB, VOLTORB, 0
	db 29, WEEZING, MUK, 0
	db 25, KOFFING, WEEZING, KOFFING, KOFFING, WEEZING, 0
; Route 14
	db 26, KOFFING, KOFFING, GRIMER, KOFFING, 0
	db 28, GRIMER, GRIMER, KOFFING, 0
	db 29, KOFFING, MUK, 0

BurglarData:
; Unused
	db 29, GROWLITHE, VULPIX, 0
	db 33, GROWLITHE, 0
	db 28, VULPIX, CHARMANDER, PONYTA, 0
; Cinnabar Gym
	db 36, GROWLITHE, VULPIX, NINETALES, 0
	db 41, PONYTA, 0
	db 37, VULPIX, GROWLITHE, 0
; Mansion 2F
	db 34, CHARMANDER, CHARMELEON, 0
; Mansion 3F
	db 38, NINETALES, 0
; Mansion B1F
	db 34, GROWLITHE, PONYTA, 0

EngineerData:
; Unused
	db 21, VOLTORB, MAGNEMITE, 0
; Route 11
	db $FF, 33, VOLTORB, 28, MAGNETON, 28, PRIMEAPE, 0
	db $FF, 28, PORYGON, 28, MAGNETON, 30, CHARMELEON, 0

UnusedJugglerData:
; none

FisherData:
; SS Anne 2F Rooms
	db 30, WARTORTLE, DUGTRIO, 0
; SS Anne B1F Rooms
	db $FF, 30, GOLDUCK, STARMIE, 0
; Route 12
	db 22, GOLDEEN, POLIWAG, GOLDEEN, 0
	db 24, TENTACOOL, GOLDEEN, 0
	db 27, GOLDEEN, 0
	db 21, POLIWAG, SHELLDER, GOLDEEN, HORSEA, 0
; Route 21
	db 28, SEAKING, GOLDEEN, SEAKING, SEAKING, 0
	db 31, SHELLDER, CLOYSTER, 0
	db 27, MAGIKARP, MAGIKARP, MAGIKARP, MAGIKARP, MAGIKARP, MAGIKARP, 0
	db 33, SEAKING, GOLDEEN, 0
; Route 12
	db 24, MAGIKARP, MAGIKARP, 0

SwimmerData:
; Cerulean Gym
	db 25, STARYU, POLIWHIRL, 0
; Route 19
	db 30, TENTACOOL, SHELLDER, 0
	db 29, GOLDEEN, HORSEA, STARYU, 0
	db 30, POLIWAG, POLIWHIRL, 0
	db 27, HORSEA, TENTACOOL, TENTACOOL, GOLDEEN, 0
	db 29, GOLDEEN, SHELLDER, SEAKING, 0
	db 30, HORSEA, HORSEA, 0
	db 27, TENTACOOL, TENTACOOL, STARYU, HORSEA, TENTACRUEL, 0
; Route 20
	db 31, SHELLDER, CLOYSTER, 0
	db 35, STARYU, 0
	db 28, HORSEA, HORSEA, SEADRA, HORSEA, 0
; Route 21
	db 33, SEADRA, TENTACRUEL, 0
	db 37, STARMIE, 0
	db 33, STARYU, WARTORTLE, 0
	db 32, POLIWHIRL, TENTACOOL, SEADRA, 0

CueBallData:
; Route 16
	db 28, MACHOP, MANKEY, MACHOP, 0
	db 29, MANKEY, MACHOP, 0
	db 33, MACHOP, 0
; Route 17
	db 29, MANKEY, PRIMEAPE, 0
	db 29, MACHOP, MACHOKE, 0
	db 33, MACHOKE, 0
	db 26, MANKEY, MANKEY, MACHOKE, MACHOP, 0
	db 29, PRIMEAPE, MACHOKE, 0
; Route 21
	db 31, TENTACOOL, TENTACOOL, TENTACRUEL, 0

GamblerData:
; Route 11
	db $FF, 29, KINGLER, 29, SEAKING, 27, PINSIR, 28, RAPIDASH, 0
	db 28, DEWGONG, DUGTRIO, 0
	db 28, DUGTRIO, RAPIDASH, 0
	db 28, ELECTRODE, POLIWRATH, 0
; Route 8
	db 22, POLIWAG, POLIWAG, POLIWHIRL, 0
; Unused
	db 22, ONIX, GEODUDE, GRAVELER, 0
; Route 8
	db 24, GROWLITHE, VULPIX, 0

BeautyData:
; Celadon Gym
	db 21, ODDISH, BELLSPROUT, ODDISH, BELLSPROUT, 0
	db 24, BELLSPROUT, BELLSPROUT, 0
	db 26, EXEGGCUTE, 0
; Route 13
	db 27, RATTATA, VULPIX, RATTATA, 0
	db 29, CLEFAIRY, MEOWTH, 0
; Route 20
	db 35, SEAKING, 0
	db 30, SHELLDER, SHELLDER, CLOYSTER, 0
	db 31, POLIWAG, SEAKING, 0
; Route 15
	db 29, PIDGEOTTO, WIGGLYTUFF, 0
	db 29, BULBASAUR, IVYSAUR, 0
; Unused
	db 33, WEEPINBELL, BELLSPROUT, WEEPINBELL, 0
; Route 19
	db 27, POLIWAG, GOLDEEN, SEAKING, GOLDEEN, POLIWAG, 0
	db 30, GOLDEEN, SEAKING, 0
	db 29, STARYU, STARYU, STARYU, 0
; Route 20
	db 30, SEADRA, HORSEA, SEADRA, 0

PsychicData:
; Saffron Gym
	db 31, KADABRA, SLOWPOKE, MR_MIME, KADABRA, 0
	db 34, MR_MIME, KADABRA, 0
	db 33, SLOWPOKE, SLOWPOKE, SLOWBRO, 0
	db 38, SLOWBRO, 0

RockerData:
; Vermilion Gym
	db $FF, 33, ELECTRODE, 34, GOLBAT, 33, PORYGON, 0
; Route 12
	db 29, VOLTORB, ELECTRODE, 0

JugglerData:
; Silph Co. 5F
	db 29, KADABRA, MR_MIME, 0
; Victory Road 2F
	db 41, DROWZEE, HYPNO, KADABRA, KADABRA, 0
; Fuchsia Gym
	db 31, DROWZEE, DROWZEE, KADABRA, DROWZEE, 0
	db 34, DROWZEE, HYPNO, 0
; Victory Road 2F
	db 48, MR_MIME, 0
; Unused
	db 33, HYPNO, 0
; Fuchsia Gym
	db 38, HYPNO, 0
	db 34, DROWZEE, KADABRA, 0

TamerData:
; Fuchsia Gym
	db 34, SANDSLASH, ARBOK, 0
	db 33, ARBOK, SANDSLASH, ARBOK, 0
; Viridian Gym
	db 43, RHYHORN, 0
	db 39, ARBOK, TAUROS, 0
; Victory Road 2F
	db 44, PERSIAN, GOLDUCK, 0
; Unused
	db 42, RHYHORN, PRIMEAPE, ARBOK, TAUROS, 0

BirdKeeperData:
; Route 13
	db 29, PIDGEY, PIDGEOTTO, 0
	db 25, SPEAROW, PIDGEY, PIDGEY, SPEAROW, SPEAROW, 0
	db 26, PIDGEY, PIDGEOTTO, SPEAROW, FEAROW, 0
; Route 14
	db 33, FARFETCHD, 0
	db 29, SPEAROW, FEAROW, 0
; Route 15
	db 26, PIDGEOTTO, FARFETCHD, DODUO, PIDGEY, 0
	db 28, DODRIO, DODUO, DODUO, 0
; Route 18
	db 29, SPEAROW, FEAROW, 0
	db 34, DODRIO, 0
	db 26, SPEAROW, SPEAROW, FEAROW, SPEAROW, 0
; Route 20
	db 30, FEAROW, FEAROW, PIDGEOTTO, 0
; Unused
	db 39, PIDGEOTTO, PIDGEOTTO, PIDGEY, PIDGEOTTO, 0
	db 42, FARFETCHD, FEAROW, 0
; Route 14
	db 28, PIDGEY, DODUO, PIDGEOTTO, 0
	db 26, PIDGEY, SPEAROW, PIDGEY, FEAROW, 0
	db 29, PIDGEOTTO, FEAROW, 0
	db 28, SPEAROW, DODUO, FEAROW, 0

BlackbeltData:
; Fighting Dojo
	db 37, HITMONLEE, HITMONCHAN, 0
	db 31, MANKEY, MANKEY, PRIMEAPE, 0
	db 32, MACHOP, MACHOKE, 0
	db 36, PRIMEAPE, 0
	db 31, MACHOP, MANKEY, PRIMEAPE, 0
; Viridian Gym
	db 40, MACHOP, MACHOKE, 0
	db 43, MACHOKE, 0
	db 38, MACHOKE, MACHOP, MACHOKE, 0
; Victory Road 2F
	db 43, MACHOKE, MACHOP, MACHOKE, 0

Rival1Data:
	db 3, MEW, 0
; Route 22
	db 7, EEVEE, MEW, 0
; Cerulean City
	db $FF, 20, PIDGEOT, 22, DRATINI, 22, CHARMELEON, 22, DRAGONAIR, 22, MEW, 0

ProfOakData:
; Unused
	db $FF, 66, TAUROS, 67, EXEGGUTOR, 68, ARCANINE, 69, BLASTOISE, 70, GYARADOS, 0
	db $FF, 66, TAUROS, 67, EXEGGUTOR, 68, ARCANINE, 69, VENUSAUR, 70, GYARADOS, 0
	db $FF, 66, TAUROS, 67, EXEGGUTOR, 68, ARCANINE, 69, CHARIZARD, 70, GYARADOS, 0

ChiefData:
; none

ScientistData:
; Unused
	db 34, KOFFING, VOLTORB, 0
; Silph Co. 2F
	db 26, GRIMER, WEEZING, KOFFING, WEEZING, 0
	db 28, MAGNEMITE, VOLTORB, MAGNETON, 0
; Silph Co. 3F/Mansion 1F
	db 29, ELECTRODE, WEEZING, 0
; Silph Co. 4F
	db 33, ELECTRODE, 0
; Silph Co. 5F
	db 26, MAGNETON, KOFFING, WEEZING, MAGNEMITE, 0
; Silph Co. 6F
	db 25, VOLTORB, KOFFING, MAGNETON, MAGNEMITE, KOFFING, 0
; Silph Co. 7F
	db 29, ELECTRODE, MUK, 0
; Silph Co. 8F
	db 29, GRIMER, ELECTRODE, 0
; Silph Co. 9F
	db 28, VOLTORB, KOFFING, MAGNETON, 0
; Silph Co. 10F
	db 29, MAGNEMITE, KOFFING, 0
; Mansion 3F
	db 33, MAGNEMITE, MAGNETON, VOLTORB, 0
; Mansion B1F
	db 34, MAGNEMITE, ELECTRODE, 0

GiovanniData:
; Rocket Hideout B4F
	db $FF, 25, ONIX, 24, RHYHORN, 29, PERSIAN, 0
; Silph Co. 11F
	db $FF, 37, NIDORINO, 35, PERSIAN, 37, RHYHORN, 41, NIDOQUEEN, 0
; Viridian Gym
	db $FF, 50, DUGTRIO, 53, PERSIAN, 53, NIDOQUEEN, 55, NIDOKING, 55, RHYDON, 0

RocketData:
; Mt. Moon B2F
	db $FF, 19, ARBOK, 18, POLIWHIRL, 19, SANDSLASH, 0
	db $FF, 19, DROWZEE, 20, OMANYTE, 19, NIDORINA, 18, GOLBAT, 0
	db 20, RATICATE, KABUTO, 0
; Cerulean City
	db 28, MR_MIME, DUGTRIO, NIDOQUEEN, 0
; Route 24
	db 22, HAUNTER, POLIWRATH, 0
; Game Corner
	db 20, RATICATE, ZUBAT, 0
; Rocket Hideout B1F
	db 21, DROWZEE, MACHOP, 0
	db 21, RATICATE, RATICATE, 0
	db 20, GRIMER, KOFFING, KOFFING, 0
	db 19, RATTATA, RATICATE, RATICATE, RATTATA, 0
	db 22, GRIMER, KOFFING, 0
; Rocket Hideout B2F
	db 17, ZUBAT, KOFFING, GRIMER, ZUBAT, RATICATE, 0
; Rocket Hideout B3F
	db 20, RATTATA, RATICATE, DROWZEE, 0
	db 21, MACHOP, MACHOP, 0
; Rocket Hideout B4F
	db 23, SANDSHREW, EKANS, SANDSLASH, 0
	db 23, EKANS, SANDSHREW, ARBOK, 0
	db 21, KOFFING, ZUBAT, 0
; Pokémon Tower 7F
	db 25, ZUBAT, ZUBAT, GOLBAT, 0
	db 26, KOFFING, DROWZEE, 0
	db 23, ZUBAT, RATTATA, RATICATE, ZUBAT, 0
; Unused
	db 26, DROWZEE, KOFFING, 0
; Silph Co. 2F
	db 29, CUBONE, ZUBAT, 0
	db 25, GOLBAT, ZUBAT, ZUBAT, RATICATE, ZUBAT, 0
; Silph Co. 3F
	db 28, RATICATE, HYPNO, RATICATE, 0
; Silph Co. 4F
	db 29, MACHOP, DROWZEE, 0
	db 28, EKANS, ZUBAT, CUBONE, 0
; Silph Co. 5F
	db 33, ARBOK, 0
	db 33, HYPNO, 0
; Silph Co. 6F
	db 29, MACHOP, MACHOKE, 0
	db 28, ZUBAT, ZUBAT, GOLBAT, 0
; Silph Co. 7F
	db 26, RATICATE, ARBOK, KOFFING, GOLBAT, 0
	db 29, CUBONE, CUBONE, 0
	db 29, SANDSHREW, SANDSLASH, 0
; Silph Co. 8F
	db 26, RATICATE, ZUBAT, GOLBAT, RATTATA, 0
	db 28, WEEZING, GOLBAT, KOFFING, 0
; Silph Co. 9F
	db 28, DROWZEE, GRIMER, MACHOP, 0
	db 28, GOLBAT, DROWZEE, HYPNO, 0
; Silph Co. 10F
	db 33, MACHOKE, 0
; Silph Co. 11F
	db 25, RATTATA, RATTATA, ZUBAT, RATTATA, EKANS, 0
	db 32, CUBONE, DROWZEE, MAROWAK, 0
; Jessie & James
	db $FF, 19, ARBOK, 19, PERSIAN, 22, KOFFING, 0
	db 25, KOFFING, MEOWTH, EKANS, 0
	db 27, MEOWTH, ARBOK, WEEZING, 0
	db 31, WEEZING, ARBOK, MEOWTH, 0
; Unused
	db 16, KOFFING, 0
	db 27, KOFFING, 0
	db 29, WEEZING, 0
	db 33, WEEZING, 0

CooltrainerMData:
; Viridian Gym
	db 39, NIDORINO, NIDOKING, 0
; Victory Road 3F
	db 43, EXEGGUTOR, CLOYSTER, ARCANINE, 0
	db 43, KINGLER, TENTACRUEL, BLASTOISE, 0
; Unused
	db 45, KINGLER, STARMIE, 0
; Victory Road 1F
	db 42, IVYSAUR, WARTORTLE, CHARMELEON, CHARIZARD, 0
; Unused
	db 44, IVYSAUR, WARTORTLE, CHARMELEON, 0
	db 49, NIDOKING, 0
	db 44, KINGLER, CLOYSTER, 0
; Viridian Gym
	db 39, SANDSLASH, DUGTRIO, 0
	db 43, RHYHORN, 0

CooltrainerFData:
; Celadon Gym
	db 24, WEEPINBELL, GLOOM, IVYSAUR, 0
; Victory Road 3F
	db 43, BELLSPROUT, WEEPINBELL, VICTREEBEL, 0
	db 43, PARASECT, DEWGONG, CHANSEY, 0
; Unused
	db 46, VILEPLUME, BUTTERFREE, 0
; Victory Road 1F
	db 44, PERSIAN, NINETALES, 0
; Unused
	db 45, IVYSAUR, VENUSAUR, 0
	db 45, NIDORINA, NIDOQUEEN, 0
	db 43, PERSIAN, NINETALES, RAICHU, 0

BrunoData:
	db $FF, 53, ONIX, 55, HITMONCHAN, 55, HITMONLEE, 56, ONIX, 58, MACHAMP, 0

BrockData:
	db 16, VULPIX, CLEFAIRY, GRAVELER, AERODACTYL, 0

MistyData:
	db 28, VAPOREON, POLIWRATH, GYARADOS, DRAGONAIR, GOLDUCK, STARMIE, 0

LtSurgeData:
	db $FF, 28, RAICHU, 0

ErikaData:
	db $FF, 30, TANGELA, 32, WEEPINBELL, 32, GLOOM, 0

KogaData:
	db $FF, 44, VENONAT, 46, VENONAT, 48, VENONAT, 50, VENOMOTH, 0

BlaineData:
	db $FF, 48, NINETALES, 50, RAPIDASH, 54, ARCANINE, 0

SabrinaData:
	db $FF, 50, ABRA, 50, KADABRA, 50, ALAKAZAM, 0

GentlemanData:
; SS Anne 1F Rooms
	db 30, DRAGONAIR, PORYGON, 0
	db 30, VENOMOTH, WIGGLYTUFF, 0
; SS Anne 2F Rooms
	db 30, DRAGONAIR, DEWGONG, 0
; Vermillion Gym
	db 35, GYARADOS, DITTO, 0
; SS Anne 2F Rooms
	db 30, $FF, 30, MAGNETON, 33, BEEDRILL, 0

Rival2Data:
; SS Anne 2F
	db 33, FLAREON, JOLTEON, VAPOREON, WARTORTLE, MEW, 0
; Pokémon Tower 2F
	db $FF, 25, FEAROW, 23, SHELLDER, 22, VULPIX, 20, SANDSHREW, 25, EEVEE, 0
	db $FF, 25, FEAROW, 23, MAGNEMITE, 22, SHELLDER, 20, SANDSHREW, 25, EEVEE, 0
	db $FF, 25, FEAROW, 23, VULPIX, 22, MAGNEMITE, 20, SANDSHREW, 25, EEVEE, 0
; Silph Co. 7F
	db $FF, 38, SANDSLASH, 35, NINETALES, 37, CLOYSTER, 35, KADABRA, 40, JOLTEON, 0
	db $FF, 38, SANDSLASH, 35, CLOYSTER, 37, MAGNETON, 35, KADABRA, 40, FLAREON, 0
	db $FF, 38, SANDSLASH, 35, MAGNETON, 37, NINETALES, 35, KADABRA, 40, VAPOREON, 0
; Route 22
	db $FF, 47, SANDSLASH, 45, EXEGGCUTE, 45, NINETALES, 47, CLOYSTER, 50, KADABRA, 53, JOLTEON, 0
	db $FF, 47, SANDSLASH, 45, EXEGGCUTE, 45, CLOYSTER, 47, MAGNETON, 50, KADABRA, 53, FLAREON, 0
	db $FF, 47, SANDSLASH, 45, EXEGGCUTE, 45, MAGNETON, 47, NINETALES, 50, KADABRA, 53, VAPOREON, 0

Rival3Data:
	db $FF, 61, SANDSLASH, 59, ALAKAZAM, 61, EXEGGUTOR, 61, CLOYSTER, 63, NINETALES, 65, JOLTEON, 0
	db $FF, 61, SANDSLASH, 59, ALAKAZAM, 61, EXEGGUTOR, 61, MAGNETON, 63, CLOYSTER, 65, FLAREON, 0
	db $FF, 61, SANDSLASH, 59, ALAKAZAM, 61, EXEGGUTOR, 61, NINETALES, 63, MAGNETON, 65, VAPOREON, 0

LoreleiData:
	db $FF, 54, DEWGONG, 53, CLOYSTER, 54, SLOWBRO, 56, JYNX, 56, LAPRAS, 0

ChannelerData:
; Unused
	db 22, GASTLY, 0
	db 24, GASTLY, 0
	db 23, GASTLY, GASTLY, 0
	db 24, GASTLY, 0
; Pokémon Tower 3F
	db 23, GASTLY, 0
	db 24, GASTLY, 0
; Unused
	db 24, HAUNTER, 0
; Pokémon Tower 3F
	db 22, GASTLY, 0
; Pokémon Tower 4F
	db 24, GASTLY, 0
	db 23, GASTLY, GASTLY, 0
; Unused
	db 24, GASTLY, 0
; Pokémon Tower 4F
	db 22, GASTLY, 0
; Unused
	db 24, GASTLY, 0
; Pokémon Tower 5F
	db 23, HAUNTER, 0
; Unused
	db 24, GASTLY, 0
; Pokémon Tower 5F
	db 22, GASTLY, 0
	db 24, GASTLY, 0
	db 22, HAUNTER, 0
; Pokémon Tower 6F
	db 22, GASTLY, GASTLY, GASTLY, 0
	db 24, GASTLY, 0
	db 24, GASTLY, 0
; Saffron Gym
	db 34, GASTLY, HAUNTER, 0
	db 38, HAUNTER, 0
	db 33, GASTLY, GASTLY, HAUNTER, 0

AgathaData:
	db $FF, 56, GENGAR, 56, GOLBAT, 55, HAUNTER, 58, ARBOK, 60, GENGAR, 0

LanceData:
	db $FF, 58, GYARADOS, 56, DRAGONAIR, 56, DRAGONAIR, 60, AERODACTYL, 62, DRAGONITE, 0
