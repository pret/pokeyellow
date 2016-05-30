; this is a list of the sprites that can be enabled/disabled during the game
; sprites marked with an X are constants that are never used
; because those sprites are not (de)activated in a map's script
; (they are either items or sprites that deactivate after battle
; and are detected in wMissableObjectList)

const_value = 0

	const HS_PALLET_TOWN_OAK              ; 00
	const HS_LYING_OLD_MAN                ; 01
	const HS_OLD_MAN_1                    ; 02
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

const_value SET $2D
	const HS_OAKS_LAB_OAK_1               ; 2D
	const HS_POKEDEX_1                    ; 2E
	const HS_POKEDEX_2                    ; 2F
	const HS_OAKS_LAB_OAK_2               ; 30
	const HS_VIRIDIAN_GYM_GIOVANNI        ; 31
	const HS_VIRIDIAN_GYM_ITEM            ; 32
	const HS_OLD_AMBER                    ; 33 X
	const HS_UNKNOWN_DUNGEON_1_ITEM_1     ; 34
	const HS_UNKNOWN_DUNGEON_1_ITEM_2     ; 35 X
	const HS_UNKNOWN_DUNGEON_1_ITEM_3     ; 36 X
	const HS_POKEMONTOWER_2_RIVAL         ; 37 X
	const HS_POKEMONTOWER_3_ITEM          ; 38
	const HS_POKEMONTOWER_4_ITEM_1        ; 39 X
	const HS_POKEMONTOWER_4_ITEM_2        ; 3A X
	const HS_POKEMONTOWER_4_ITEM_3        ; 3B X
	const HS_POKEMONTOWER_5_ITEM          ; 3C X
	const HS_POKEMONTOWER_6_ITEM_1        ; 3D X
	const HS_POKEMONTOWER_6_ITEM_2        ; 3E X
	const HS_POKEMONTOWER_7_ROCKET_1      ; 3F X
	const HS_POKEMONTOWER_7_ROCKET_2      ; 40 X
	const HS_POKEMONTOWER_7_ROCKET_3      ; 41 X

const_value SET $43 ; replace the tower rockets with jessie/james
	const HS_POKEMONTOWER_7_MR_FUJI       ; 43
	const HS_LAVENDER_HOUSE_1_MR_FUJI     ; 44
	const HS_CELADON_MANSION_5_GIFT       ; 45
	const HS_GAME_CORNER_ROCKET           ; 46
	const HS_FUCHSIA_HOUSE_2_ITEM         ; 47 X
	const HS_MANSION_1_ITEM_1             ; 48 X
	const HS_MANSION_1_ITEM_2             ; 49 X
	const HS_FIGHTING_DOJO_GIFT_1         ; 4A
	const HS_FIGHTING_DOJO_GIFT_2         ; 4B
	const HS_SILPH_CO_1F_RECEPTIONIST     ; 4C
	const HS_VOLTORB_1                    ; 4D X
	const HS_VOLTORB_2                    ; 4E X
	const HS_VOLTORB_3                    ; 4F X
	const HS_ELECTRODE_1                  ; 50 X
	const HS_VOLTORB_4                    ; 51 X
	const HS_VOLTORB_5                    ; 52 X
	const HS_ELECTRODE_2                  ; 53 X
	const HS_VOLTORB_6                    ; 54 X
	const HS_ZAPDOS                       ; 55 X
	const HS_POWER_PLANT_ITEM_1           ; 56 X
	const HS_POWER_PLANT_ITEM_2           ; 57 X
	const HS_POWER_PLANT_ITEM_3           ; 58 X
	const HS_POWER_PLANT_ITEM_4           ; 59 X
	const HS_POWER_PLANT_ITEM_5           ; 5A X
	const HS_MOLTRES                      ; 5B X
	const HS_VICTORY_ROAD_2_ITEM_1        ; 5C X
	const HS_VICTORY_ROAD_2_ITEM_2        ; 5D X
	const HS_VICTORY_ROAD_2_ITEM_3        ; 5E X
	const HS_VICTORY_ROAD_2_ITEM_4        ; 5F X
	const HS_VICTORY_ROAD_2_BOULDER       ; 60
	const HS_BILL_POKEMON                 ; 61
	const HS_BILL_1                       ; 62
	const HS_BILL_2                       ; 63
	const HS_VIRIDIAN_FOREST_ITEM_1       ; 64 X
	const HS_VIRIDIAN_FOREST_ITEM_2       ; 65 X
	const HS_VIRIDIAN_FOREST_ITEM_3       ; 66 X
	const HS_MT_MOON_1_ITEM_1             ; 67
	const HS_MT_MOON_1_ITEM_2             ; 68
	const HS_MT_MOON_1_ITEM_3             ; 69 X
	const HS_MT_MOON_1_ITEM_4             ; 6A X
	const HS_MT_MOON_1_ITEM_5             ; 6B X
	const HS_MT_MOON_1_ITEM_6             ; 6C X
	const HS_MT_MOON_JESSIE               ; 6D
	const HS_MT_MOON_JAMES                ; 6E
	const HS_MT_MOON_3_FOSSIL_1           ; 6F X
	const HS_MT_MOON_3_FOSSIL_2           ; 70 X
	const HS_MT_MOON_3_ITEM_1             ; 71
	const HS_MT_MOON_3_ITEM_2             ; 72 X
	const HS_SS_ANNE_2_RIVAL              ; 73 X
	const HS_SS_ANNE_8_ITEM               ; 74 X
	const HS_SS_ANNE_9_ITEM_1             ; 75 X
	const HS_SS_ANNE_9_ITEM_2             ; 76 X
	const HS_SS_ANNE_10_ITEM_1            ; 77 X
	const HS_SS_ANNE_10_ITEM_2            ; 78 X
	const HS_SS_ANNE_10_ITEM_3            ; 79 X
	const HS_VICTORY_ROAD_3_ITEM_1        ; 7A
	const HS_VICTORY_ROAD_3_ITEM_2        ; 7B
	const HS_VICTORY_ROAD_3_BOULDER       ; 7C X
	const HS_ROCKET_HIDEOUT_1_ITEM_1      ; 7D X
	const HS_ROCKET_HIDEOUT_1_ITEM_2      ; 7E X
	const HS_ROCKET_HIDEOUT_2_ITEM_1      ; 7F X
	const HS_ROCKET_HIDEOUT_2_ITEM_2      ; 80 X
	const HS_ROCKET_HIDEOUT_2_ITEM_3      ; 81 X
	const HS_ROCKET_HIDEOUT_2_ITEM_4      ; 82 X
	const HS_ROCKET_HIDEOUT_3_ITEM_1      ; 83
	const HS_ROCKET_HIDEOUT_3_ITEM_2      ; 84 X
	const HS_ROCKET_HIDEOUT_4_GIOVANNI    ; 85 X
	const HS_ROCKET_HIDEOUT_4_ITEM_1      ; 86 X
	const HS_ROCKET_HIDEOUT_4_ITEM_2      ; 87
	const HS_ROCKET_HIDEOUT_4_ITEM_3      ; 88
	const HS_ROCKET_HIDEOUT_4_ITEM_4      ; 89 XXX never (de)activated?
	const HS_ROCKET_HIDEOUT_4_ITEM_5      ; 8A
	
const_value SET $8d
	const HS_SILPH_CO_2F_1                ; 8D
	const HS_SILPH_CO_2F_2                ; 8E
	const HS_SILPH_CO_2F_3                ; 8F
	const HS_SILPH_CO_2F_4                ; 90 X
	const HS_SILPH_CO_2F_5                ; 91
	const HS_SILPH_CO_3F_1                ; 92
	const HS_SILPH_CO_3F_2                ; 93
	const HS_SILPH_CO_3F_ITEM             ; 94 X
	const HS_SILPH_CO_4F_1                ; 95 X
	const HS_SILPH_CO_4F_2                ; 96 X
	const HS_SILPH_CO_4F_3                ; 97
	const HS_SILPH_CO_4F_ITEM_1           ; 98
	const HS_SILPH_CO_4F_ITEM_2           ; 99
	const HS_SILPH_CO_4F_ITEM_3           ; 9A
	const HS_SILPH_CO_5F_1                ; 9B X
	const HS_SILPH_CO_5F_2                ; 9C X
	const HS_SILPH_CO_5F_3                ; 9D X
	const HS_SILPH_CO_5F_4                ; 9E
	const HS_SILPH_CO_5F_ITEM_1           ; 9F
	const HS_SILPH_CO_5F_ITEM_2           ; A0
	const HS_SILPH_CO_5F_ITEM_3           ; A1 X
	const HS_SILPH_CO_6F_1                ; A2 X
	const HS_SILPH_CO_6F_2                ; A3
	const HS_SILPH_CO_6F_3                ; A4
	const HS_SILPH_CO_6F_ITEM_1           ; A5
	const HS_SILPH_CO_6F_ITEM_2           ; A6
	const HS_SILPH_CO_7F_1                ; A7
	const HS_SILPH_CO_7F_2                ; A8 X
	const HS_SILPH_CO_7F_3                ; A9 X
	const HS_SILPH_CO_7F_4                ; AA XXX sprite doesn't exist
	const HS_SILPH_CO_7F_RIVAL            ; AB
	const HS_SILPH_CO_7F_ITEM_1           ; AC
	const HS_SILPH_CO_7F_ITEM_2           ; AD
	const HS_SILPH_CO_7F_8                ; AE
	const HS_SILPH_CO_8F_1                ; AF
	const HS_SILPH_CO_8F_2                ; B0
	const HS_SILPH_CO_8F_3                ; B1
	const HS_SILPH_CO_9F_1                ; B2
	const HS_SILPH_CO_9F_2                ; B3 XXX never (de)activated?
	const HS_SILPH_CO_9F_3                ; B4 X
	const HS_SILPH_CO_10F_1               ; B5 X
	const HS_SILPH_CO_10F_2               ; B6 X
	const HS_SILPH_CO_10F_3               ; B7
	const HS_SILPH_CO_10F_ITEM_1          ; B8
	const HS_SILPH_CO_10F_ITEM_2          ; B9
	const HS_SILPH_CO_10F_ITEM_3          ; BA XXX sprite doesn't exist
	const HS_SILPH_CO_11F_1               ; BB X
	const HS_SILPH_CO_11F_2               ; BC X
	const HS_SILPH_CO_11F_3               ; BD X
	const HS_MAP_F4_1                     ; BE X
	const HS_MANSION_2_ITEM               ; BF X
	const HS_MANSION_3_ITEM_1             ; C0 X
	const HS_MANSION_3_ITEM_2             ; C1 X
	const HS_MANSION_4_ITEM_1             ; C2 X
	const HS_MANSION_4_ITEM_2             ; C3 X
	const HS_MANSION_4_ITEM_3             ; C4 X
	const HS_MANSION_4_ITEM_4             ; C5 X
	const HS_MANSION_4_ITEM_5             ; C6 X
	const HS_SAFARI_ZONE_EAST_ITEM_1      ; C7 X
	const HS_SAFARI_ZONE_EAST_ITEM_2      ; C8 X
	const HS_SAFARI_ZONE_EAST_ITEM_3      ; C9 X
	const HS_SAFARI_ZONE_EAST_ITEM_4      ; CA X
	const HS_SAFARI_ZONE_NORTH_ITEM_1     ; CB X
	const HS_SAFARI_ZONE_NORTH_ITEM_2     ; CC X
	const HS_SAFARI_ZONE_WEST_ITEM_1      ; CD X
	const HS_SAFARI_ZONE_WEST_ITEM_2      ; CE X
	const HS_SAFARI_ZONE_WEST_ITEM_3      ; CF X
	const HS_SAFARI_ZONE_WEST_ITEM_4      ; D0 X
	const HS_SAFARI_ZONE_CENTER_ITEM      ; D1 X
	const HS_UNKNOWN_DUNGEON_2_ITEM_1     ; D2 X
	const HS_UNKNOWN_DUNGEON_2_ITEM_2     ; D3 X
	const HS_UNKNOWN_DUNGEON_2_ITEM_3     ; D4 X
	const HS_MEWTWO                       ; D5 X
	const HS_UNKNOWN_DUNGEON_3_ITEM_1     ; D6
	const HS_UNKNOWN_DUNGEON_3_ITEM_2     ; D7
	const HS_VICTORY_ROAD_1_ITEM_1        ; D8
	const HS_VICTORY_ROAD_1_ITEM_2        ; D9
	const HS_CHAMPIONS_ROOM_OAK           ; DA

const_value SET $df
	const HS_SEAFOAM_ISLANDS_1_BOULDER_1  ; DF
	const HS_SEAFOAM_ISLANDS_1_BOULDER_2  ; E0
	const HS_SEAFOAM_ISLANDS_2_BOULDER_1  ; E1
	const HS_SEAFOAM_ISLANDS_2_BOULDER_2  ; E2
	const HS_SEAFOAM_ISLANDS_3_BOULDER_1  ; E3
	const HS_SEAFOAM_ISLANDS_3_BOULDER_2  ; E4
	const HS_SEAFOAM_ISLANDS_4_BOULDER_1  ; E5
	const HS_SEAFOAM_ISLANDS_4_BOULDER_2  ; E6
	const HS_SEAFOAM_ISLANDS_4_BOULDER_3  ; E7
	const HS_SEAFOAM_ISLANDS_4_BOULDER_4  ; E8
	const HS_SEAFOAM_ISLANDS_5_BOULDER_1  ; E9
	const HS_SEAFOAM_ISLANDS_5_BOULDER_2  ; EA
	const HS_ARTICUNO                     ; EB
