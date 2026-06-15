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

NASMFLAGS := -f coff -I include/ -I .

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
    src/overworld/movement.asm

# Debug-only sources (linked only when the corresponding flag is set)
ifdef DEBUG_DUMP
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
	$(LD) $(LDFLAGS) $(ALL_OBJS) -o $@
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
