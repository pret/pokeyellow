# Makefile for the Pokemon Yellow DOS Port
# Toolchain: NASM + binutils-djgpp (i386-pc-msdosdjgpp-ld)
# Output: pokeyellow_dos.exe (DJGPP coff-go32-exe format, CWSDPMI-loadable)
#
# Install toolchain (Debian/Ubuntu):
#   sudo apt install nasm binutils-djgpp
#
# Run in DOSBox:
#   Place pokeyellow_dos.exe in a directory with CWSDPMI.EXE
#   DOSBox config: [cpu] cputype=386, core=normal, cycles=50000

NASM    := nasm
LD      := i386-pc-msdosdjgpp-ld

NASMFLAGS := -f coff -I include/ -I . -O0

# Bug fix level (0=none, 1=critical, 2=all). Override: make BUG_FIX_LEVEL=1
BUG_FIX_LEVEL ?= 0
NASMFLAGS += -D BUG_FIX_LEVEL=$(BUG_FIX_LEVEL)

# Test flag: skip title screen, go straight to overworld. make SKIP_TITLE=1
ifdef SKIP_TITLE
NASMFLAGS += -D SKIP_TITLE
endif

# Default player / rival names for debug / SKIP_TITLE builds (title screen is
# bypassed, so these WRAM fields would otherwise be garbage). The engine's debug
# defaults are NINTEN / SONY. Letters only, <= 7 chars.
# Override: make SKIP_TITLE=1 PLAYER_NAME=ASH RIVAL_NAME=GARY
PLAYER_NAME ?= NINTEN
RIVAL_NAME  ?= SONY
NASMFLAGS += -D PLAYER_NAME="'$(PLAYER_NAME)'"
NASMFLAGS += -D RIVAL_NAME="'$(RIVAL_NAME)'"

# Debug flag: dump GB memory windows to DUMP.BIN then exit. make DEBUG_DUMP=1
# (implies SKIP_TITLE path reaching the overworld). See src/debug/debug_dump.asm.
ifdef DEBUG_DUMP
NASMFLAGS += -D DEBUG_DUMP
endif

# Debug flag: force a north map transition (Pallet Town -> Route 1) at boot so the
# post-crossing render can be screenshotted without keyboard input. make DEBUG_TRANSITION=1
ifdef DEBUG_TRANSITION
NASMFLAGS += -D DEBUG_TRANSITION
endif

# Sub-flag of DEBUG_TRANSITION: skip the CheckMapConnections crossing so the
# DEBUG_TRANSITION reload path dumps a pristine (non-transitioned) current map.
# Use to capture a baseline frame for comparison. make DEBUG_TRANSITION=1 DEBUG_BASELINE=1
ifdef DEBUG_BASELINE
NASMFLAGS += -D DEBUG_BASELINE
endif

# Debug flag: simulate a northward walk to the map edge then dump FRAME.BIN, to
# inspect where the transition triggers relative to the visible edge.
# make DEBUG_WALK_NORTH=1 (optionally DEBUG_WALK_STEPS=N via NASM define).
ifdef DEBUG_WALK_NORTH
NASMFLAGS += -D DEBUG_WALK_NORTH
endif

# Number of north steps for DEBUG_WALK_NORTH (default 8 in overworld.asm).
ifdef DEBUG_WALK_STEPS
NASMFLAGS += -D DEBUG_WALK_STEPS=$(DEBUG_WALK_STEPS)
endif

# Debug noclip: press W in-game to toggle walk-through-walls (disables collision).
# Useful for testing warps, map edges, and OOB behaviour without normal movement.
# Does NOT imply SKIP_TITLE — works at any point in the game.
# make SKIP_TITLE=1 DEBUG_NOCLIP=1
ifdef DEBUG_NOCLIP
NASMFLAGS += -D DEBUG_NOCLIP
endif

LDFLAGS := -T link.ld

TARGET  := PKMN.EXE

# Source files
BOOT_SRCS := \
    boot/entry.asm \
    boot/video.asm \
    boot/timing.asm

HOME_SRCS := \
    src/home/fill_memory.asm \
    src/home/copy_data.asm

HAL_SRCS := \
    src/ppu/ppu.asm \
    src/input/joypad.asm

# Phase 2: game-loop core
GAME_SRCS := \
    src/init/init.asm \
    src/video/lcd_control.asm \
    src/video/frame.asm \
    src/gfx/sprites.asm \
    src/gfx/sprite_oam.asm \
    src/gfx/load_font.asm \
    src/text/text.asm \
    src/movie/title.asm \
    src/engine/overworld/overworld.asm \
    src/engine/overworld/movement.asm \
    src/engine/overworld/map_sprites.asm \
    src/scripts/pallet_town.asm \
    src/engine/math/random.asm

# Pokémon data/stats engine (current_plan_pokemon_engine.md). Grows per stage.
POKEMON_SRCS := \
    src/data/pokemon_data.asm \
    src/home/math.asm \
    src/engine/math/multiply_divide.asm \
    src/home/pokemon.asm \
    src/home/move_mon.asm \
    src/engine/pokemon/experience.asm

# Debug-only sources (linked only when the corresponding flag is set).
# Any debug flag implies SKIP_TITLE — debug harnesses boot straight to the overworld.
ifdef DEBUG_DUMP
NEED_DEBUG_DUMP := 1
NASMFLAGS += -D SKIP_TITLE
endif
ifdef DEBUG_TRANSITION
NEED_DEBUG_DUMP := 1
NASMFLAGS += -D SKIP_TITLE
endif
ifdef DEBUG_WALK_NORTH
NEED_DEBUG_DUMP := 1
NASMFLAGS += -D SKIP_TITLE
endif
ifdef DEBUG_DIALOG
NEED_DEBUG_DUMP := 1
NASMFLAGS += -D DEBUG_DIALOG
NASMFLAGS += -D SKIP_TITLE
endif
# Diagnostic: log every NPC walk-decision (dest tile, true tile, player view
# state) to NPCLOG.BIN while a scripted player walk runs in Pallet Town.
# Used to verify the walking-NPC wall-clipping bug. make DEBUG_NPC_WALK=1
ifdef DEBUG_NPC_WALK
NEED_DEBUG_DUMP := 1
NASMFLAGS += -D DEBUG_NPC_WALK
NASMFLAGS += -D SKIP_TITLE
endif
# CalcStats gate: compute known Bulbasaur stats at boot, dump DUMP.BIN, exit.
# make DEBUG_CALCSTATS=1
ifdef DEBUG_CALCSTATS
NEED_DEBUG_DUMP := 1
NASMFLAGS += -D DEBUG_CALCSTATS
NASMFLAGS += -D SKIP_TITLE
endif
ifdef NEED_DEBUG_DUMP
GAME_SRCS += src/debug/debug_dump.asm
endif

# Test harness for event-gated dialog: force EVENT_GOT_POKEBALLS_FROM_OAK at map
# load so PalletTownOakText shows its "set" branch. make SKIP_TITLE=1 DEBUG_OAK_EVENT=1
ifdef DEBUG_OAK_EVENT
NASMFLAGS += -D DEBUG_OAK_EVENT
endif

ALL_SRCS := $(BOOT_SRCS) $(HOME_SRCS) $(HAL_SRCS) $(GAME_SRCS) $(POKEMON_SRCS)
ALL_OBJS := $(ALL_SRCS:.asm=.o)

# ---------------------------------------------------------------------------
# Targets
# ---------------------------------------------------------------------------

.PHONY: all clean check assets
.DEFAULT_GOAL := all

# Generate all tileset gfx/blocks/coll + map blk inc files.
# Requires gfx/tilesets/*.2bpp, built by 'make' in the repo root.
assets/overworld_gfx.inc assets/overworld_blocks.inc assets/pallet_town_blk.inc:
	python3 tools/gen_all_assets.py

# Generate map headers blob, dispatch tables, and extra_includes.inc.
# Pass DEBUG_WARPS=1 to include IF DEF(_DEBUG) warp entries (e.g. REDS_HOUSE_2F
# debug teleport warps). Changing this flag requires 'make assets' to force-regen.
GEN_MAP_HEADERS_FLAGS :=
ifdef DEBUG_WARPS
GEN_MAP_HEADERS_FLAGS += --debug-warps
endif

assets/map_headers.inc assets/extra_includes.inc:
	python3 tools/gen_map_headers.py $(GEN_MAP_HEADERS_FLAGS)

# Overworld object depends on all generated assets
src/engine/overworld/overworld.o: \
    assets/overworld_gfx.inc \
    assets/overworld_blocks.inc \
    assets/pallet_town_blk.inc \
    assets/map_headers.inc \
    assets/extra_includes.inc

# NPC sprite sheets — all sprites used across all maps (generated by gen_all_assets.py)
assets/npc_sprite_data_table.inc:
	python3 tools/gen_all_assets.py

# NPC dialog streams — all maps (generated by gen_npc_dialogs.py)
assets/npc_dialogs/all_dialogs.inc:
	python3 tools/gen_npc_dialogs.py

# Toggleable-object (event) flag tables — NPC spawn gating (gen_toggleable_objects.py)
assets/toggleable_objects.inc:
	python3 tools/gen_toggleable_objects.py

# Event-flag bit-index constants (EVENT_*) for include/events.inc (gen_event_constants.py)
assets/event_constants.inc:
	python3 tools/gen_event_constants.py

# map_sprites depends on the NPC tile asset table, all-maps dialog table, the
# toggleable-object (event) flag tables, and the event-flag constants (events.inc).
src/engine/overworld/map_sprites.o: \
    assets/npc_sprite_data_table.inc \
    assets/npc_dialogs/all_dialogs.inc \
    assets/toggleable_objects.inc \
    assets/event_constants.inc

# Pallet Town text_asm scripts include events.inc → event_constants.inc.
src/scripts/pallet_town.o: assets/event_constants.inc

# Pokémon base stats + IndexToPokedex (static data, generated from pret source).
assets/base_stats.inc:
	python3 tools/gen_base_stats.py

src/data/pokemon_data.o: assets/base_stats.inc assets/growth_rates.inc

assets: assets/overworld_gfx.inc assets/overworld_blocks.inc assets/pallet_town_blk.inc \
        assets/map_headers.inc assets/extra_includes.inc \
        assets/npc_sprite_data_table.inc assets/npc_dialogs/all_dialogs.inc \
        assets/toggleable_objects.inc assets/event_constants.inc \
        assets/base_stats.inc

all: $(TARGET)

$(TARGET): $(ALL_OBJS) link.ld
	$(LD) $(LDFLAGS) -Map=pkmn.map $(ALL_OBJS) -o $@
	@echo "Built: $@"

%.o: %.asm
	$(NASM) $(NASMFLAGS) -o $@ $<

# Assemble-only check (no link): useful for syntax verification
check:
	@for src in $(ALL_SRCS); do \
	    echo "Checking: $$src"; \
	    $(NASM) $(NASMFLAGS) -o /dev/null $$src || exit 1; \
	done
	@echo "All files assembled successfully."

clean:
	rm -f $(ALL_OBJS) $(TARGET)
