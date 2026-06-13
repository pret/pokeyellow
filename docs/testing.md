# Testing the DOS Port

## Build

```sh
make -C dos_port            # -> dos_port/pokeyellow_dos.exe
make -C dos_port check      # assemble-only syntax check (no linker needed)
make compare                # verify the reference ROM (requires rgbds 1.0.1)
```

## Regenerating the font data

`dos_port/assets/font_1bpp.inc` is committed and regenerated from the source PNG:

```sh
python3 tools/gen_font_inc.py   # requires Pillow: pip install Pillow
```

## Running in DOSBox-X

`pokeyellow_dos.exe` is a DJGPP `coff-go32` executable and needs a DPMI host.
Place `CWSDPMI.EXE` (CWSDPMI r7) in the same directory as the program — not
committed to this repo. HDPMI32 also works.

DOS resolves 8.3 names; use a short copy name:

```sh
cp dos_port/pokeyellow_dos.exe dos_port/PKMN.EXE
dosbox-x -c "mount c dos_port" -c "c:" -c "PKMN.EXE"
```

Controls: arrow keys scroll the background. Esc quits (restores text mode,
PIT divisor, original IRQ0/IRQ1 vectors).

## Headless verification (Xvfb + ImageMagick)

```sh
# Arch: sudo pacman -S dosbox-x xorg-server-xvfb imagemagick
# Ubuntu: sudo apt install dosbox-x xvfb imagemagick

cp dos_port/pokeyellow_dos.exe dos_port/PKMN.EXE  # CWSDPMI.EXE also in dos_port/
cat > /tmp/dbx.conf <<'EOF'
[dosbox]
machine=svga_s3
[cpu]
cputype=386
core=normal
cycles=20000
[autoexec]
mount c /path/to/dos_port
c:
PKMN.EXE
EOF

timeout 40 xvfb-run -a -s "-screen 0 800x600x24" bash -c '
  dosbox-x -conf /tmp/dbx.conf >/tmp/dbx.log 2>&1 &
  sleep 14
  import -window root /tmp/shot.png
  kill %1
'
```

A correct Phase 2 build shows "POKEMON YELLOW" and "DOS PORT" in the game font
on a light-green background. `Load error: no DPMI` means CWSDPMI.EXE is missing.
