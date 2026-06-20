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

LDFLAGS := -T link.ld

TARGET  := PKMN.EXE

# Source files
BOOT_SRCS := \
    boot/entry.asm \
    boot/video.asm \
    boot/timing.asm

UTIL_SRCS := \
    src/util/fill_memory.asm \
    src/util/copy_data.asm

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
    src/overworld/overworld.asm \
    src/overworld/movement.asm \
    src/engine/battle/get_trainer_name.asm \
    src/engine/battle/misc.asm \
    src/engine/battle/move_effects/conversion.asm \
    src/engine/battle/move_effects/drain_hp.asm \
    src/engine/battle/move_effects/focus_energy.asm \
    src/engine/battle/move_effects/haze.asm \
    src/engine/battle/move_effects/heal.asm \
    src/engine/battle/move_effects/leech_seed.asm \
    src/engine/battle/move_effects/mist.asm

# Debug-only sources (linked only when the corresponding flag is set).
# Both DEBUG_DUMP and DEBUG_TRANSITION use debug_dump.asm; add it once if either set.
ifdef DEBUG_DUMP
NEED_DEBUG_DUMP := 1
endif
ifdef DEBUG_TRANSITION
NEED_DEBUG_DUMP := 1
endif
ifdef DEBUG_WALK_NORTH
NEED_DEBUG_DUMP := 1
endif
ifdef NEED_DEBUG_DUMP
GAME_SRCS += src/debug/debug_dump.asm
endif

ALL_SRCS := $(BOOT_SRCS) $(UTIL_SRCS) $(HAL_SRCS) $(GAME_SRCS)
ALL_OBJS := $(ALL_SRCS:.asm=.o)

# ---------------------------------------------------------------------------
# Targets
# ---------------------------------------------------------------------------

.PHONY: all clean check assets
.DEFAULT_GOAL := all

# Generate overworld asset includes from binary sources.
# Requires overworld.2bpp, which is built by 'make' in the repo root.
assets/overworld_gfx.inc assets/overworld_blocks.inc assets/pallet_town_blk.inc:
	python3 ../tools/gen_overworld_assets.py

# Overworld object depends on generated assets
src/overworld/overworld.o: \
    assets/overworld_gfx.inc \
    assets/overworld_blocks.inc \
    assets/pallet_town_blk.inc

assets: assets/overworld_gfx.inc assets/overworld_blocks.inc assets/pallet_town_blk.inc

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
