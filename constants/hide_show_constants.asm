; this is a list of the sprites that can be enabled/disabled during the game
; sprites marked with an X are constants that are never used
; because those sprites are not (de)activated in a map's script
; (they are either items or sprites that deactivate after battle
; and are detected in wMissableObjectList)

const_value = 0

	const HS_PIKACHU                      ; 00
	const HS_PALLET_TOWN_OAK              ; 01
	const HS_LYING_OLD_MAN                ; 02
	const HS_OLD_MAN                      ; 03
	const HS_MUSEUM_GUY                   ; 04
	const HS_GYM_GUY                      ; 05
	const HS_CERULEAN_RIVAL               ; 06
	const HS_CERULEAN_ROCKET              ; 07
	const HS_CERULEAN_GUARD_1             ; 08
	const HS_UNKNOWN_DUNGEON_GUY          ; 09
	const HS_CERULEAN_GUARD_2             ; 0A
	const HS_SAFFRON_CITY_1               ; 0B
	const HS_SAFFRON_CITY_2               ; 0C
	const HS_SAFFRON_CITY_3               ; 0D
	const HS_SAFFRON_CITY_4               ; 0E
	const HS_SAFFRON_CITY_5               ; 0F
	const HS_SAFFRON_CITY_6               ; 10
	const HS_SAFFRON_CITY_7               ; 11
	const HS_SAFFRON_CITY_8               ; 12
	const HS_SAFFRON_CITY_9               ; 13
	const HS_SAFFRON_CITY_A               ; 14
	const HS_SAFFRON_CITY_B               ; 15
	const HS_SAFFRON_CITY_C               ; 16
	const HS_SAFFRON_CITY_D               ; 17
	const HS_SAFFRON_CITY_E               ; 18
	const HS_SAFFRON_CITY_F               ; 19 X
	const HS_ROUTE_2_ITEM_1               ; 1A X
	const HS_ROUTE_2_ITEM_2               ; 1B X
	const HS_ROUTE_4_ITEM                 ; 1C X
	const HS_ROUTE_9_ITEM                 ; 1D
	const HS_ROUTE_12_SNORLAX             ; 1E X
	const HS_ROUTE_12_ITEM_1              ; 1F X
	const HS_ROUTE_12_ITEM_2              ; 20 X
	const HS_ROUTE_15_ITEM                ; 21
	const HS_ROUTE_16_SNORLAX             ; 22
	const HS_ROUTE_22_RIVAL_1             ; 23
	const HS_ROUTE_22_RIVAL_2             ; 24
	const HS_NUGGET_BRIDGE_GUY            ; 25 X
	const HS_ROUTE_24_ITEM                ; 26 X
	const HS_ROUTE_25_ITEM                ; 27
	const HS_DAISY_SITTING                ; 28
	const HS_DAISY_WALKING                ; 29
	const HS_TOWN_MAP                     ; 2A
	const HS_OAKS_LAB_RIVAL               ; 2B
	const HS_STARTER_BALL_1               ; 2C
	const HS_STARTER_BALL_2               ; 2D
	const HS_STARTER_BALL_3               ; 2E
	const HS_OAKS_LAB_OAK_1               ; 2F
	const HS_POKEDEX_1                    ; 30
	const HS_POKEDEX_2                    ; 31
	const HS_OAKS_LAB_OAK_2               ; 32
	const HS_VIRIDIAN_GYM_GIOVANNI        ; 33 X
	const HS_VIRIDIAN_GYM_ITEM            ; 34
	const HS_OLD_AMBER                    ; 35 X
	const HS_UNKNOWN_DUNGEON_1_ITEM_1     ; 36 X
	const HS_UNKNOWN_DUNGEON_1_ITEM_2     ; 37 X
	const HS_UNKNOWN_DUNGEON_1_ITEM_3     ; 38
	const HS_POKEMONTOWER_2_RIVAL         ; 39 X
	const HS_POKEMONTOWER_3_ITEM          ; 3A X
	const HS_POKEMONTOWER_4_ITEM_1        ; 3B X
	const HS_POKEMONTOWER_4_ITEM_2        ; 3C X
	const HS_POKEMONTOWER_4_ITEM_3        ; 3D X
	const HS_POKEMONTOWER_5_ITEM          ; 3E X
	const HS_POKEMONTOWER_6_ITEM_1        ; 3F X
	const HS_POKEMONTOWER_6_ITEM_2        ; 40 X
	const HS_POKEMONTOWER_7_ROCKET_1      ; 41 X
	const HS_POKEMONTOWER_7_ROCKET_2      ; 42 X
	const HS_POKEMONTOWER_7_ROCKET_3      ; 43
	const HS_POKEMONTOWER_7_MR_FUJI       ; 44
	const HS_LAVENDER_HOUSE_1_MR_FUJI     ; 45
	const HS_CELADON_MANSION_5_GIFT       ; 46
	const HS_GAME_CORNER_ROCKET           ; 47 X
	const HS_FUCHSIA_HOUSE_2_ITEM         ; 48 X
	const HS_MANSION_1_ITEM_1             ; 49 X
	const HS_MANSION_1_ITEM_2             ; 4A
	const HS_FIGHTING_DOJO_GIFT_1         ; 4B
	const HS_FIGHTING_DOJO_GIFT_2         ; 4C
	const HS_SILPH_CO_1F_RECEPTIONIST     ; 4D X
	const HS_VOLTORB_1                    ; 4E X
	const HS_VOLTORB_2                    ; 4F X
	const HS_VOLTORB_3                    ; 50 X
	const HS_ELECTRODE_1                  ; 51 X
	const HS_VOLTORB_4                    ; 52 X
	const HS_VOLTORB_5                    ; 53 X
	const HS_ELECTRODE_2                  ; 54 X
	const HS_VOLTORB_6                    ; 55 X
	const HS_ZAPDOS                       ; 56 X
	const HS_POWER_PLANT_ITEM_1           ; 57 X
	const HS_POWER_PLANT_ITEM_2           ; 58 X
	const HS_POWER_PLANT_ITEM_3           ; 59 X
	const HS_POWER_PLANT_ITEM_4           ; 5A X
	const HS_POWER_PLANT_ITEM_5           ; 5B X
	const HS_MOLTRES                      ; 5C X
	const HS_VICTORY_ROAD_2_ITEM_1        ; 5D X
	const HS_VICTORY_ROAD_2_ITEM_2        ; 5E X
	const HS_VICTORY_ROAD_2_ITEM_3        ; 5F X
	const HS_VICTORY_ROAD_2_ITEM_4        ; 60
	const HS_VICTORY_ROAD_2_BOULDER       ; 61
	const HS_BILL_POKEMON                 ; 62
	const HS_BILL_1                       ; 63
	const HS_BILL_2                       ; 64 X
	const HS_VIRIDIAN_FOREST_ITEM_1       ; 65 X
	const HS_VIRIDIAN_FOREST_ITEM_2       ; 66 X
	const HS_VIRIDIAN_FOREST_ITEM_3       ; 67 X
	const HS_MT_MOON_1_ITEM_1             ; 68 X
	const HS_MT_MOON_1_ITEM_2             ; 69 X
	const HS_MT_MOON_1_ITEM_3             ; 6A X
	const HS_MT_MOON_1_ITEM_4             ; 6B X
	const HS_MT_MOON_1_ITEM_5             ; 6C X
	const HS_MT_MOON_1_ITEM_6             ; 6D
	const HS_MT_MOON_3_FOSSIL_1           ; 6E
	const HS_MT_MOON_3_FOSSIL_2           ; 6F X
	const HS_MT_MOON_3_ITEM_1             ; 70 X
	const HS_MT_MOON_3_ITEM_2             ; 71
	const HS_SS_ANNE_2_RIVAL              ; 72 X
	const HS_SS_ANNE_8_ITEM               ; 73 X
	const HS_SS_ANNE_9_ITEM_1             ; 74 X
	const HS_SS_ANNE_9_ITEM_2             ; 75 X
	const HS_SS_ANNE_10_ITEM_1            ; 76 X
	const HS_SS_ANNE_10_ITEM_2            ; 77 X
	const HS_SS_ANNE_10_ITEM_3            ; 78 X
	const HS_VICTORY_ROAD_3_ITEM_1        ; 79 X
	const HS_VICTORY_ROAD_3_ITEM_2        ; 7A
	const HS_VICTORY_ROAD_3_BOULDER       ; 7B X
	const HS_ROCKET_HIDEOUT_1_ITEM_1      ; 7C X
	const HS_ROCKET_HIDEOUT_1_ITEM_2      ; 7D X
	const HS_ROCKET_HIDEOUT_2_ITEM_1      ; 7E X
	const HS_ROCKET_HIDEOUT_2_ITEM_2      ; 7F X
	const HS_ROCKET_HIDEOUT_2_ITEM_3      ; 80 X
	const HS_ROCKET_HIDEOUT_2_ITEM_4      ; 81 X
	const HS_ROCKET_HIDEOUT_3_ITEM_1      ; 82 X
	const HS_ROCKET_HIDEOUT_3_ITEM_2      ; 83
	const HS_ROCKET_HIDEOUT_4_GIOVANNI    ; 84 X
	const HS_ROCKET_HIDEOUT_4_ITEM_1      ; 85 X
	const HS_ROCKET_HIDEOUT_4_ITEM_2      ; 86 X
	const HS_ROCKET_HIDEOUT_4_ITEM_3      ; 87
	const HS_ROCKET_HIDEOUT_4_ITEM_4      ; 88
	const HS_ROCKET_HIDEOUT_4_ITEM_5      ; 89 XXX never (de)activated?
	const HS_SILPH_CO_2F_1                ; 8A
	const HS_SILPH_CO_2F_2                ; 8B
	const HS_SILPH_CO_2F_3                ; 8C
	const HS_SILPH_CO_2F_4                ; 8D
	const HS_SILPH_CO_2F_5                ; 8E
	const HS_SILPH_CO_3F_1                ; 8F
	const HS_SILPH_CO_3F_2                ; 90 X
	const HS_SILPH_CO_3F_ITEM             ; 91
	const HS_SILPH_CO_4F_1                ; 92
	const HS_SILPH_CO_4F_2                ; 93
	const HS_SILPH_CO_4F_3                ; 94 X
	const HS_SILPH_CO_4F_ITEM_1           ; 95 X
	const HS_SILPH_CO_4F_ITEM_2           ; 96 X
	const HS_SILPH_CO_4F_ITEM_3           ; 97
	const HS_SILPH_CO_5F_1                ; 98
	const HS_SILPH_CO_5F_2                ; 99
	const HS_SILPH_CO_5F_3                ; 9A
	const HS_SILPH_CO_5F_4                ; 9B X
	const HS_SILPH_CO_5F_ITEM_1           ; 9C X
	const HS_SILPH_CO_5F_ITEM_2           ; 9D X
	const HS_SILPH_CO_5F_ITEM_3           ; 9E
	const HS_SILPH_CO_6F_1                ; 9F
	const HS_SILPH_CO_6F_2                ; A0
	const HS_SILPH_CO_6F_3                ; A1 X
	const HS_SILPH_CO_6F_ITEM_1           ; A2 X
	const HS_SILPH_CO_6F_ITEM_2           ; A3
	const HS_SILPH_CO_7F_1                ; A4
	const HS_SILPH_CO_7F_2                ; A5
	const HS_SILPH_CO_7F_3                ; A6
	const HS_SILPH_CO_7F_4                ; A7
	const HS_SILPH_CO_7F_RIVAL            ; A8 X
	const HS_SILPH_CO_7F_ITEM_1           ; A9 X
	const HS_SILPH_CO_7F_ITEM_2           ; AA XXX sprite doesn't exist
	const HS_SILPH_CO_7F_8                ; AB
	const HS_SILPH_CO_8F_1                ; AC
	const HS_SILPH_CO_8F_2                ; AD
	const HS_SILPH_CO_8F_3                ; AE
	const HS_SILPH_CO_9F_1                ; AF
	const HS_SILPH_CO_9F_2                ; B0
	const HS_SILPH_CO_9F_3                ; B1
	const HS_SILPH_CO_10F_1               ; B2
	const HS_SILPH_CO_10F_2               ; B3 XXX never (de)activated?
	const HS_SILPH_CO_10F_3               ; B4 X
	const HS_SILPH_CO_10F_ITEM_1          ; B5 X
	const HS_SILPH_CO_10F_ITEM_2          ; B6 X
	const HS_SILPH_CO_10F_ITEM_3          ; B7
	const HS_SILPH_CO_11F_1               ; B8
	const HS_SILPH_CO_11F_2               ; B9
	const HS_SILPH_CO_11F_3               ; BA XXX sprite doesn't exist
	const HS_MAP_F4_1                     ; BB X
	const HS_MANSION_2_ITEM               ; BC X
	const HS_MANSION_3_ITEM_1             ; BD X
	const HS_MANSION_3_ITEM_2             ; BE X
	const HS_MANSION_4_ITEM_1             ; BF X
	const HS_MANSION_4_ITEM_2             ; C0 X
	const HS_MANSION_4_ITEM_3             ; C1 X
	const HS_MANSION_4_ITEM_4             ; C2 X
	const HS_MANSION_4_ITEM_5             ; C3 X
	const HS_SAFARI_ZONE_EAST_ITEM_1      ; C4 X
	const HS_SAFARI_ZONE_EAST_ITEM_2      ; C5 X
	const HS_SAFARI_ZONE_EAST_ITEM_3      ; C6 X
	const HS_SAFARI_ZONE_EAST_ITEM_4      ; C7 X
	const HS_SAFARI_ZONE_NORTH_ITEM_1     ; C8 X
	const HS_SAFARI_ZONE_NORTH_ITEM_2     ; C9 X
	const HS_SAFARI_ZONE_WEST_ITEM_1      ; CA X
	const HS_SAFARI_ZONE_WEST_ITEM_2      ; CB X
	const HS_SAFARI_ZONE_WEST_ITEM_3      ; CC X
	const HS_SAFARI_ZONE_WEST_ITEM_4      ; CD X
	const HS_SAFARI_ZONE_CENTER_ITEM      ; CE X
	const HS_UNKNOWN_DUNGEON_2_ITEM_1     ; CF X
	const HS_UNKNOWN_DUNGEON_2_ITEM_2     ; D0 X
	const HS_UNKNOWN_DUNGEON_2_ITEM_3     ; D1 X
	const HS_MEWTWO                       ; D2 X
	const HS_UNKNOWN_DUNGEON_3_ITEM_1     ; D3 X
	const HS_UNKNOWN_DUNGEON_3_ITEM_2     ; D4 X
	const HS_VICTORY_ROAD_1_ITEM_1        ; D5 X
	const HS_VICTORY_ROAD_1_ITEM_2        ; D6
	const HS_CHAMPIONS_ROOM_OAK           ; D7
	const HS_SEAFOAM_ISLANDS_1_BOULDER_1  ; D8
	const HS_SEAFOAM_ISLANDS_1_BOULDER_2  ; D9
	const HS_SEAFOAM_ISLANDS_2_BOULDER_1  ; DA
	const HS_SEAFOAM_ISLANDS_2_BOULDER_2  ; DB
	const HS_SEAFOAM_ISLANDS_3_BOULDER_1  ; DC
	const HS_SEAFOAM_ISLANDS_3_BOULDER_2  ; DD
	const HS_SEAFOAM_ISLANDS_4_BOULDER_1  ; DE
	const HS_SEAFOAM_ISLANDS_4_BOULDER_2  ; DF
	const HS_SEAFOAM_ISLANDS_4_BOULDER_3  ; E0
	const HS_SEAFOAM_ISLANDS_4_BOULDER_4  ; E1
	const HS_SEAFOAM_ISLANDS_5_BOULDER_1  ; E2
	const HS_SEAFOAM_ISLANDS_5_BOULDER_2  ; E3 X
	const HS_ARTICUNO                     ; EF
