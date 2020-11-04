INCLUDE "constants.asm"


SECTION "bank1", ROMX

INCLUDE "data/sprites/facings.asm"
INCLUDE "engine/battle/safari_zone.asm"
INCLUDE "engine/movie/title.asm"
INCLUDE "engine/pokemon/load_mon_data.asm"
INCLUDE "data/items/prices.asm"
INCLUDE "data/items/names.asm"
INCLUDE "data/text/unused_names.asm"
INCLUDE "engine/gfx/sprite_oam.asm"
INCLUDE "engine/link/print_waiting_text.asm"
INCLUDE "engine/overworld/sprite_collisions.asm"
INCLUDE "engine/events/pick_up_item.asm"
INCLUDE "engine/overworld/movement.asm"
INCLUDE "engine/link/cable_club.asm"
INCLUDE "engine/menus/main_menu.asm"
INCLUDE "engine/movie/oak_speech/oak_speech.asm"
INCLUDE "engine/overworld/special_warps.asm"
INCLUDE "engine/debug/debug_party.asm"
INCLUDE "engine/menus/naming_screen.asm"
INCLUDE "engine/movie/oak_speech/oak_speech2.asm"
INCLUDE "engine/items/subtract_paid_money.asm"
INCLUDE "engine/menus/swap_items.asm"
INCLUDE "engine/events/pokemart.asm"
INCLUDE "engine/pokemon/learn_move.asm"
INCLUDE "engine/events/pokecenter.asm"
INCLUDE "engine/events/set_blackout_map.asm"
INCLUDE "engine/menus/display_text_id_init.asm"
INCLUDE "engine/menus/draw_start_menu.asm"
INCLUDE "engine/link/cable_club_npc.asm"
INCLUDE "engine/menus/text_box.asm"
INCLUDE "engine/battle/move_effects/drain_hp.asm"
INCLUDE "engine/menus/players_pc.asm"
INCLUDE "engine/pokemon/remove_mon.asm"
INCLUDE "engine/events/display_pokedex.asm"


SECTION "bank3", ROMX

INCLUDE "engine/joypad.asm"
INCLUDE "engine/overworld/clear_variables.asm"
INCLUDE "engine/overworld/player_state.asm"
INCLUDE "engine/events/poison.asm"
INCLUDE "engine/overworld/tilesets.asm"
INCLUDE "engine/overworld/daycare_exp.asm"
INCLUDE "data/maps/hide_show_data.asm"
INCLUDE "engine/overworld/wild_mons.asm"
INCLUDE "engine/items/item_effects.asm"
INCLUDE "engine/menus/draw_badges.asm"
INCLUDE "engine/overworld/update_map.asm"
INCLUDE "engine/overworld/cut.asm"
INCLUDE "engine/overworld/missable_objects.asm"
INCLUDE "engine/overworld/push_boulder.asm"
INCLUDE "engine/pokemon/add_mon.asm"
INCLUDE "engine/flag_action.asm"
INCLUDE "engine/events/heal_party.asm"
INCLUDE "engine/math/bcd.asm"
INCLUDE "engine/movie/oak_speech/init_player_data.asm"
INCLUDE "engine/items/get_bag_item_quantity.asm"
INCLUDE "engine/overworld/pathfinding.asm"
INCLUDE "engine/gfx/hp_bar.asm"
INCLUDE "engine/events/hidden_objects/bookshelves.asm"
INCLUDE "engine/events/hidden_objects/indigo_plateau_statues.asm"
INCLUDE "engine/events/hidden_objects/book_or_sculpture.asm"
INCLUDE "engine/events/hidden_objects/elevator.asm"
INCLUDE "engine/events/hidden_objects/town_map.asm"
INCLUDE "engine/events/hidden_objects/pokemon_stuff.asm"


SECTION "Font Graphics", ROMX

INCLUDE "gfx/font.asm"

INCLUDE "engine/pokemon/status_screen.asm"
INCLUDE "engine/menus/party_menu.asm"
INCLUDE "gfx/player.asm"
INCLUDE "engine/menus/start_sub_menus.asm"
INCLUDE "engine/items/tms.asm"


SECTION "Battle Engine 1", ROMX

INCLUDE "engine/battle/end_of_battle.asm"
INCLUDE "engine/battle/wild_encounters.asm"
INCLUDE "engine/battle/move_effects/recoil.asm"
INCLUDE "engine/battle/move_effects/conversion.asm"
INCLUDE "engine/battle/move_effects/haze.asm"


SECTION "bank5", ROMX

INCLUDE "engine/gfx/load_pokedex_tiles.asm"
INCLUDE "engine/overworld/map_sprites.asm"


SECTION "Battle Engine 2", ROMX
INCLUDE "engine/battle/move_effects/substitute.asm"
INCLUDE "engine/menus/pc.asm"


SECTION "Doors and Ledges", ROMX

INCLUDE "engine/overworld/auto_movement.asm"
INCLUDE "engine/overworld/doors.asm"
INCLUDE "engine/overworld/ledges.asm"


SECTION "Pokémon Names", ROMX

INCLUDE "engine/movie/oak_speech/clear_save.asm"
INCLUDE "engine/events/elevator.asm"


SECTION "Hidden Objects 1", ROMX

INCLUDE "engine/menus/oaks_pc.asm"
INCLUDE "engine/events/hidden_objects/new_bike.asm"
INCLUDE "engine/events/hidden_objects/oaks_lab_posters.asm"
INCLUDE "engine/events/hidden_objects/safari_game.asm"
INCLUDE "engine/events/hidden_objects/cinnabar_gym_quiz.asm"
INCLUDE "engine/events/hidden_objects/magazines.asm"
INCLUDE "engine/events/hidden_objects/bills_house_pc.asm"
INCLUDE "engine/events/hidden_objects/oaks_lab_email.asm"


SECTION "Bill's PC", ROMX

INCLUDE "engine/pokemon/bills_pc.asm"


SECTION "Battle Engine 3", ROMX

INCLUDE "engine/battle/print_type.asm"
INCLUDE "engine/battle/save_trainer_name.asm"


SECTION "Battle Engine 4", ROMX

INCLUDE "engine/gfx/screen_effects.asm"
INCLUDE "engine/battle/move_effects/leech_seed.asm"


SECTION "Battle Engine 5", ROMX

INCLUDE "engine/battle/display_effectiveness.asm"
INCLUDE "engine/items/tmhm.asm"

Func_2fd6a:
	callfar IsThisPartymonStarterPikachu_Party
	ret nc
	ld a, $3
	ld [wPikachuSpawnState], a
	ret

INCLUDE "engine/battle/scale_sprites.asm"
INCLUDE "engine/slots/game_corner_slots2.asm"


SECTION "Slot Machines", ROMX

INCLUDE "engine/movie/title2.asm"
INCLUDE "engine/slots/slot_machine.asm"
INCLUDE "engine/slots/game_corner_slots.asm"


SECTION "Battle Engine 7", ROMX

INCLUDE "data/moves/moves.asm"
INCLUDE "data/pokemon/base_stats.asm"
INCLUDE "data/pokemon/cries.asm"
INCLUDE "engine/battle/trainer_ai.asm"
INCLUDE "engine/battle/draw_hud_pokeball_gfx.asm"
INCLUDE "gfx/trade.asm"
INCLUDE "engine/pokemon/evos_moves.asm"


SECTION "Battle Core", ROMX

INCLUDE "engine/battle/core.asm"
INCLUDE "engine/battle/effects.asm"


SECTION "bank10", ROMX

INCLUDE "engine/menus/pokedex.asm"
INCLUDE "engine/overworld/emotion_bubbles.asm"
INCLUDE "engine/movie/trade.asm"
INCLUDE "engine/movie/intro.asm"
INCLUDE "engine/movie/trade2.asm"
INCLUDE "engine/menus/options.asm"


SECTION "Pokédex Rating", ROMX

INCLUDE "engine/events/pokedex_rating.asm"


SECTION "Dungeon Warps", ROMX

INCLUDE "engine/overworld/dungeon_warps.asm"


SECTION "Hidden Objects 2", ROMX

INCLUDE "engine/events/card_key.asm"
INCLUDE "engine/events/prize_menu.asm"
INCLUDE "engine/events/hidden_objects/school_notebooks.asm"
INCLUDE "engine/events/hidden_objects/fighting_dojo.asm"
INCLUDE "engine/events/hidden_objects/indigo_plateau_hq.asm"


SECTION "Battle Engine 9", ROMX

INCLUDE "engine/battle/experience.asm"


SECTION "Diploma", ROMX

INCLUDE "engine/events/diploma.asm"


SECTION "Trainer Sight", ROMX

INCLUDE "engine/overworld/trainer_sight.asm"


SECTION "Battle Engine 10", ROMX

INCLUDE "engine/pokemon/experience.asm"
INCLUDE "engine/pokemon/status_ailments.asm"
INCLUDE "engine/events/oaks_aide.asm"


SECTION "Saffron Guards", ROMX

INCLUDE "engine/events/saffron_guards.asm"


SECTION "Starter Dex", ROMX

INCLUDE "engine/events/starter_dex.asm"


SECTION "Hidden Objects 3", ROMX

INCLUDE "engine/movie/evolution.asm"
INCLUDE "engine/pokemon/set_types.asm"
INCLUDE "engine/events/hidden_objects/reds_room.asm"
INCLUDE "engine/events/hidden_objects/route_15_binoculars.asm"
INCLUDE "engine/events/hidden_objects/museum_fossils.asm"
INCLUDE "engine/events/hidden_objects/fanclub_pictures.asm"
INCLUDE "engine/events/hidden_objects/museum_fossils2.asm"
INCLUDE "engine/events/hidden_objects/school_blackboard.asm"
INCLUDE "engine/events/hidden_objects/vermilion_gym_trash.asm"


SECTION "Cinnabar Lab Fossils", ROMX

INCLUDE "engine/events/cinnabar_lab.asm"


SECTION "Hidden Objects 4", ROMX

INCLUDE "engine/events/hidden_objects/gym_statues.asm"
INCLUDE "engine/events/hidden_objects/bench_guys.asm"
INCLUDE "engine/events/hidden_objects/blues_room.asm"
INCLUDE "engine/events/hidden_objects/pokecenter_pc.asm"


SECTION "Battle Engine 11", ROMX

INCLUDE "gfx/version.asm"


SECTION "bank1C", ROMX

INCLUDE "engine/movie/splash.asm"
INCLUDE "engine/movie/hall_of_fame.asm"
INCLUDE "engine/overworld/healing_machine.asm"
INCLUDE "engine/overworld/player_animations.asm"
INCLUDE "engine/battle/ghost_marowak_anim.asm"
INCLUDE "engine/battle/battle_transitions.asm"
INCLUDE "engine/items/town_map.asm"
INCLUDE "engine/gfx/mon_icons.asm"
INCLUDE "engine/events/in_game_trades.asm"
INCLUDE "engine/gfx/palettes.asm"
INCLUDE "engine/menus/save.asm"


SECTION "Itemfinder 1", ROMX

INCLUDE "engine/items/itemfinder.asm"


SECTION "Vending Machine", ROMX

INCLUDE "engine/events/vending_machine.asm"


SECTION "Itemfinder 2", ROMX

INCLUDE "engine/menus/league_pc.asm"
INCLUDE "engine/overworld/elevator.asm"
INCLUDE "engine/events/hidden_items.asm"


SECTION "bank1E", ROMX

INCLUDE "engine/battle/animations.asm"
INCLUDE "engine/overworld/cut2.asm"
INCLUDE "engine/overworld/dust_smoke.asm"

INCLUDE "gfx/fishing.asm"
INCLUDE "data/moves/animations.asm"
INCLUDE "data/battle_anims/subanimations.asm"
INCLUDE "data/battle_anims/frame_blocks.asm"


SECTION "bank2f", ROMX

INCLUDE "engine/bg_map_attributes.asm"


SECTION "bank30", ROMX

; This whole bank is garbage data.
INCBIN "engine/bank30.bin"


SECTION "bank39", ROMX

Pic_e4000:
INCBIN "gfx/pikachu/unknown_e4000.pic"
GFX_e40cc:
INCBIN "gfx/pikachu/unknown_e40cc.2bpp"
Pic_e411c:
INCBIN "gfx/pikachu/unknown_e411c.pic"
GFX_e41d2:
INCBIN "gfx/pikachu/unknown_e41d2.2bpp"
Pic_e4272:
INCBIN "gfx/pikachu/unknown_e4272.pic"
GFX_e4323:
INCBIN "gfx/pikachu/unknown_e4323.2bpp"
Pic_e4383:
INCBIN "gfx/pikachu/unknown_e4383.pic"
GFX_e444b:
INCBIN "gfx/pikachu/unknown_e444b.2bpp"
Pic_e458b:
INCBIN "gfx/pikachu/unknown_e458b.pic"
GFX_e463b:
INCBIN "gfx/pikachu/unknown_e463b.2bpp"
Pic_e467b:
INCBIN "gfx/pikachu/unknown_e467b.pic"
GFX_e472e:
INCBIN "gfx/pikachu/unknown_e472e.2bpp"
Pic_e476e:
INCBIN "gfx/pikachu/unknown_e476e.pic"
GFX_e4841:
INCBIN "gfx/pikachu/unknown_e4841.2bpp"
Pic_e49d1:
INCBIN "gfx/pikachu/unknown_e49d1.pic"
GFX_e4a99:
INCBIN "gfx/pikachu/unknown_e4a99.2bpp"
Pic_e4b39:
INCBIN "gfx/pikachu/unknown_e4b39.pic"
GFX_e4bde:
INCBIN "gfx/pikachu/unknown_e4bde.2bpp"
Pic_e4c3e:
INCBIN "gfx/pikachu/unknown_e4c3e.pic"
GFX_e4ce0:
INCBIN "gfx/pikachu/unknown_e4ce0.2bpp"
GFX_e4e70:
INCBIN "gfx/pikachu/unknown_e4e70.2bpp"
Pic_e5000:
INCBIN "gfx/pikachu/unknown_e5000.pic"
GFX_e50af:
INCBIN "gfx/pikachu/unknown_e50af.2bpp"
Pic_e523f:
INCBIN "gfx/pikachu/unknown_e523f.pic"
GFX_e52fe:
INCBIN "gfx/pikachu/unknown_e52fe.2bpp"
Pic_e548e:
INCBIN "gfx/pikachu/unknown_e548e.pic"
GFX_e5541:
INCBIN "gfx/pikachu/unknown_e5541.2bpp"
Pic_e56d1:
INCBIN "gfx/pikachu/unknown_e56d1.pic"
GFX_e5794:
INCBIN "gfx/pikachu/unknown_e5794.2bpp"
Pic_e5924:
INCBIN "gfx/pikachu/unknown_e5924.pic"
GFX_e59ed:
INCBIN "gfx/pikachu/unknown_e59ed.2bpp"
Pic_e5b7d:
INCBIN "gfx/pikachu/unknown_e5b7d.pic"
GFX_e5c4d:
INCBIN "gfx/pikachu/unknown_e5c4d.2bpp"
Pic_e5ddd:
INCBIN "gfx/pikachu/unknown_e5ddd.pic"
GFX_e5e90:
INCBIN "gfx/pikachu/unknown_e5e90.2bpp"
GFX_e6020:
INCBIN "gfx/pikachu/unknown_e6020.2bpp"
GFX_e61b0:
INCBIN "gfx/pikachu/unknown_e61b0.2bpp"
Pic_e6340:
INCBIN "gfx/pikachu/unknown_e6340.pic"
GFX_e63f7:
INCBIN "gfx/pikachu/unknown_e63f7.2bpp"
Pic_e6587:
INCBIN "gfx/pikachu/unknown_e6587.pic"
GFX_e6646:
INCBIN "gfx/pikachu/unknown_e6646.2bpp"
Pic_e67d6:
INCBIN "gfx/pikachu/unknown_e67d6.pic"
GFX_e682f:
INCBIN "gfx/pikachu/unknown_e682f.2bpp"
GFX_e69bf:
INCBIN "gfx/pikachu/unknown_e69bf.2bpp"
GFX_e6b4f:
INCBIN "gfx/pikachu/unknown_e6b4f.2bpp"
GFX_e6cdf:
INCBIN "gfx/pikachu/unknown_e6cdf.2bpp"
GFX_e6e6f:
INCBIN "gfx/pikachu/unknown_e6e6f.2bpp"
GFX_e6fff:
INCBIN "gfx/pikachu/unknown_e6fff.2bpp"
GFX_e718f:
INCBIN "gfx/pikachu/unknown_e718f.2bpp"
GFX_e731f:
INCBIN "gfx/pikachu/unknown_e731f.2bpp"
GFX_e74af:
INCBIN "gfx/pikachu/unknown_e74af.2bpp"
GFX_e763f:
INCBIN "gfx/pikachu/unknown_e763f.2bpp"
Pic_e77cf:
INCBIN "gfx/pikachu/unknown_e77cf.pic"
GFX_e7863:
INCBIN "gfx/pikachu/unknown_e7863.2bpp"
GFX_e79f3:
INCBIN "gfx/pikachu/unknown_e79f3.2bpp"
GFX_e7b83:
INCBIN "gfx/pikachu/unknown_e7b83.2bpp"
GFX_e7d13:
INCBIN "gfx/pikachu/unknown_e7d13.2bpp"


SECTION "bank3A", ROMX

INCLUDE "data/pokemon/names.asm"
INCLUDE "engine/overworld/is_player_just_outside_map.asm"
INCLUDE "engine/printer.asm"
INCLUDE "engine/diploma_3a.asm"

SurfingPikachu3Graphics:  INCBIN "gfx/surfing_pikachu_3.2bpp"
SurfingPikachu3GraphicsEnd:

INCLUDE "engine/unknown_ea3ea.asm"
INCLUDE "engine/overworld/npc_movement_2.asm"

; bank $3b is empty

SECTION "bank3C", ROMX

INCLUDE "engine/bank3c.asm"


SECTION "bank3D", ROMX

INCLUDE "engine/bank3d.asm"


SECTION "bank3E", ROMX

INCLUDE "engine/bank3e.asm"


SECTION "bank3F", ROMX

INCLUDE "engine/bank3f.asm"
