MACRO bench_guy_text
	db \1, \2
	db_tx_pre \3
ENDM

BenchGuyTextPointers:
	; map id, player facing direction, predef text
	bench_guy_text VIRIDIAN_POKECENTER,          SPRITE_FACING_LEFT, ViridianCityPokecenterBenchGuyText
	bench_guy_text PEWTER_POKECENTER,            SPRITE_FACING_LEFT, PewterCityPokecenterBenchGuyText
	bench_guy_text CERULEAN_POKECENTER,          SPRITE_FACING_LEFT, CeruleanCityPokecenterBenchGuyText
	bench_guy_text LAVENDER_POKECENTER,          SPRITE_FACING_LEFT, LavenderCityPokecenterBenchGuyText
	bench_guy_text VERMILION_POKECENTER,         SPRITE_FACING_LEFT, VermilionCityPokecenterBenchGuyText
	bench_guy_text CELADON_POKECENTER,           SPRITE_FACING_LEFT, CeladonCityPokecenterBenchGuyText
	bench_guy_text CELADON_HOTEL,                SPRITE_FACING_LEFT, CeladonCityHotelText
	bench_guy_text FUCHSIA_POKECENTER,           SPRITE_FACING_LEFT, FuchsiaCityPokecenterBenchGuyText
	bench_guy_text CINNABAR_POKECENTER,          SPRITE_FACING_LEFT, CinnabarIslandPokecenterBenchGuyText
	bench_guy_text SAFFRON_POKECENTER,           SPRITE_FACING_LEFT, SaffronCityPokecenterBenchGuyText
	bench_guy_text MT_MOON_POKECENTER,           SPRITE_FACING_LEFT, MtMoonPokecenterBenchGuyText
	bench_guy_text ROCK_TUNNEL_POKECENTER,       SPRITE_FACING_LEFT, RockTunnelPokecenterBenchGuyText
	bench_guy_text SAFARI_ZONE_WEST_REST_HOUSE,  SPRITE_FACING_LEFT, UnusedBenchGuyText1
	bench_guy_text SAFARI_ZONE_EAST_REST_HOUSE,  SPRITE_FACING_LEFT, UnusedBenchGuyText2
	bench_guy_text SAFARI_ZONE_NORTH_REST_HOUSE, SPRITE_FACING_LEFT, UnusedBenchGuyText3
	db -1 ; end
