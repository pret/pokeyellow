roms := pokeyellow.gbc pokeyellow_debug.gbc

rom_obj := \
audio.o \
home.o \
main.o \
maps.o \
text.o \
wram.o \
gfx/pics.o \
gfx/pikachu.o \
gfx/sprites.o \
gfx/tilesets.o

pokeyellow_obj       := $(rom_obj)
pokeyellow_debug_obj := $(rom_obj:.o=_debug.o)


### Build tools

ifeq (,$(shell which sha1sum))
SHA1 := shasum
else
SHA1 := sha1sum
endif

RGBDS ?=
RGBASM  ?= $(RGBDS)rgbasm
RGBFIX  ?= $(RGBDS)rgbfix
RGBGFX  ?= $(RGBDS)rgbgfx
RGBLINK ?= $(RGBDS)rgblink


### Build targets

.SUFFIXES:
.SECONDEXPANSION:
.PRECIOUS:
.SECONDARY:
.PHONY: all yellow yellow_debug clean tidy compare tools

all: $(roms)
yellow:       pokeyellow.gbc
yellow_debug: pokeyellow_debug.gbc

clean: tidy
	find gfx \( -iname '*.1bpp' -o -iname '*.2bpp' -o -iname '*.pic' \) -delete
	find audio/pikachu_cries \( -iname '*.pcm' \) -delete

tidy:
	rm -f $(roms) $(pokeyellow_obj) $(pokeyellow_debug_obj) $(roms:.gbc=.map) $(roms:.gbc=.sym) rgbdscheck.o
	$(MAKE) clean -C tools/

compare: $(roms)
	@$(SHA1) -c roms.sha1

tools:
	$(MAKE) -C tools/


RGBASMFLAGS = -h -L -Weverything -Wnumeric-string=2 -Wtruncation=1
# Create a sym/map for debug purposes if `make` run with `DEBUG=1`
ifeq ($(DEBUG),1)
RGBASMFLAGS += -E
endif

$(pokeyellow_debug_obj): RGBASMFLAGS += -D _DEBUG

rgbdscheck.o: rgbdscheck.asm
	$(RGBASM) -o $@ $<

# The dep rules have to be explicit or else missing files won't be reported.
# As a side effect, they're evaluated immediately instead of when the rule is invoked.
# It doesn't look like $(shell) can be deferred so there might not be a better way.
define DEP
$1: $2 $$(shell tools/scan_includes $2) | rgbdscheck.o
	$$(RGBASM) $$(RGBASMFLAGS) -o $$@ $$<
endef

# Build tools when building the rom.
# This has to happen before the rules are processed, since that's when scan_includes is run.
ifeq (,$(filter clean tidy tools,$(MAKECMDGOALS)))

$(info $(shell $(MAKE) -C tools))

# Dependencies for objects
$(foreach obj, $(pokeyellow_obj), $(eval $(call DEP,$(obj),$(obj:.o=.asm))))
$(foreach obj, $(pokeyellow_debug_obj), $(eval $(call DEP,$(obj),$(obj:_debug.o=.asm))))

endif


%.asm: ;


pokeyellow_pad       = 0x00
pokeyellow_debug_pad = 0xff

opts = -cjsv -k 01 -l 0x33 -m 0x1b -p 0 -r 03 -t "POKEMON YELLOW"

%.gbc: $$(%_obj) layout.link
	$(RGBLINK) -p $($*_pad) -w -m $*.map -n $*.sym -l layout.link -o $@ $(filter %.o,$^)
	$(RGBFIX) -p $($*_pad) $(opts) $@


### Misc file-specific graphics rules

gfx/battle/attack_anim_1.2bpp: tools/gfx += --trim-whitespace
gfx/battle/attack_anim_2.2bpp: tools/gfx += --trim-whitespace

gfx/credits/the_end.2bpp: tools/gfx += --interleave --png=$<

gfx/slots/slots_1.2bpp: tools/gfx += --trim-whitespace

gfx/tilesets/%.2bpp: tools/gfx += --trim-whitespace
gfx/tilesets/reds_house.2bpp: tools/gfx += --preserve=0x48

gfx/title/pokemon_logo.2bpp: tools/gfx += --trim-whitespace

gfx/trade/game_boy.2bpp: tools/gfx += --remove-duplicates

gfx/sgb/border.2bpp: tools/gfx += --trim-whitespace

gfx/surfing_pikachu/surfing_pikachu_1c.2bpp: tools/gfx += --trim-whitespace
gfx/surfing_pikachu/surfing_pikachu_3.2bpp: tools/gfx += --trim-whitespace


### Catch-all graphics rules

%.png: ;

%.2bpp: %.png
	$(RGBGFX) $(rgbgfx) -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -o $@ $@)

%.1bpp: %.png
	$(RGBGFX) $(rgbgfx) -d1 -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -d1 -o $@ $@)

%.pic: %.2bpp
	tools/pkmncompress $< $@


### Catch-all audio rules

%.wav: ;

%.pcm: %.wav
	tools/pcm $< $@
