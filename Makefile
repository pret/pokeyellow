PYTHON := python
MD5 := md5sum -c --quiet

2bpp     := $(PYTHON) gfx.py 2bpp
1bpp     := $(PYTHON) gfx.py 1bpp
pcm      := $(PYTHON) extras/pokemontools/pcm.py pcm
pic      := $(PYTHON) extras/pokemontools/pic.py compress
includes := $(PYTHON) extras/pokemontools/scan_includes.py

objs := \
	audio.o \
	main.o \
	text.o \
	wram.o

$(foreach obj, $(objs:.o=), \
	$(eval $(obj)_dep := $(shell $(includes) $(obj).asm)) \
)

.SUFFIXES:
.SUFFIXES: .asm .o .gbc .png .2bpp .1bpp .pic .wav .pcm
.SECONDEXPANSION:
# Suppress annoying intermediate file deletion messages.
.PRECIOUS: %.2bpp
.PHONY: all clean yellow compare

rom := pokeyellow.gbc

all: $(rom)
yellow: $(rom)

# For contributors to make sure a change didn't affect the contents of the rom.
compare: yellow
	@$(MD5) roms.md5

clean:
	rm -f $(rom) $(objs) $(rom:.gbc=.sym)
	find . \( -iname '*.1bpp' -o -iname '*.2bpp' -o -iname '*.pic' -o -iname '*.pcm' \) -exec rm {} +

%.asm: ;
$(objs): %.o: %.asm $$(%_dep)
	rgbasm -h -o $@ $*.asm

opts = -cjsv -k 01 -l 0x33 -m 0x1b -p 0 -r 03 -t "POKEMON YELLOW"

$(rom): $(objs)
	rgblink -n $*.sym -l pokeyellow.link -o $@ $^
	rgbfix $(opts) $@
	sort $(rom:.gbc=.sym) -o $(rom:.gbc=.sym)

%.png:  ;
%.2bpp: %.png  ; @$(2bpp) $<
%.1bpp: %.png  ; @$(1bpp) $<
%.pic:  %.2bpp ; @$(pic)  $<

%.wav: ;
%.pcm: %.wav   ; @$(pcm)  $<
