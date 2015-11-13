# Build Yellow.
roms := pokeyellow.gbc


.PHONY: all clean yellow compare

all:    $(roms)
yellow: pokeyellow.gbc

versions := yellow


# Header options for rgbfix.
cgb_opt = -cjsv -k 01 -l 0x33 -m 0x1b -p 0 -r 03

yellow_opt = $(cgb_opt) -t "POKEMON YELLOW"


# If your default python is 3, you may want to change this to python27.
PYTHON := python

# md5sum -c is used to compare rom hashes. The options may vary across platforms.
MD5 := md5sum -c --quiet


# The compare target is a shortcut to check that the build matches the original roms exactly.
# This is for contributors to make sure a change didn't affect the contents of the rom.
# More thorough comparison can be made by diffing the output of hexdump -C against both roms.
compare: yellow
	@$(MD5) roms.md5


# Clear the default suffixes.
.SUFFIXES:
.SUFFIXES: .asm .o .gbc .png .2bpp .1bpp .pic .wav .pcm

# Secondary expansion is required for dependency variables in object rules.
.SECONDEXPANSION:

# Suppress annoying intermediate file deletion messages.
.PRECIOUS: %.2bpp

# Filepath shortcuts to avoid overly long recipes.
poketools := extras/pokemontools
gfx       := $(PYTHON) gfx.py
pcm       := $(PYTHON) $(poketools)/pcm.py
pic       := $(PYTHON) $(poketools)/pic.py
includes  := $(PYTHON) $(poketools)/scan_includes.py


# Collect file dependencies for objects in yellow/.
$(foreach ver, $(versions), \
	$(eval $(ver)_asm := $(shell find $(ver) -iname '*.asm')) \
	$(eval $(ver)_obj := $($(ver)_asm:.asm=.o)) \
	$(eval all_obj += $($(ver)_obj)) \
)
$(foreach obj, $(all_obj), \
	$(eval $(obj:.o=)_dep := $(shell $(includes) $(obj:.o=.asm))) \
)


%.png: ;
%.2bpp: %.png  ; @$(gfx) 2bpp $<
%.1bpp: %.png  ; @$(gfx) 1bpp $<
%.pic:  %.2bpp ; @$(pic) compress $<

%.wav: ;
%.pcm: %.wav $(poketools)/pcm.py ; @$(pcm) pcm $<

# Assemble source files into objects.
$(all_obj): $$*.asm $$($$*_dep)
	rgbasm -h -o $@ $*.asm

# Make a symfile for debugging.
link_opt = -n poke$*.sym

# Link objects together to build a rom.
poke%.gbc: $$(%_obj)
	rgblink $(link_opt) -o $@ $^
	rgbfix $($*_opt) $@


clean:
	rm -f $(roms) $(all_obj) poke*.sym
	find . \( -iname '*.1bpp' -o -iname '*.2bpp' -o -iname '*.pic' -o -iname '*.pcm' \) -exec rm {} +
