# Reference Documents

Key references for the Pokémon Yellow DOS port project.
Pan Docs pages are mirrored locally in `pandocs/` (fetched from GitHub raw content).

---

## Game Boy Hardware

- **Pan Docs** (primary GB technical reference):
  https://gbdev.io/pandocs/
  Single-page version: https://gbdev.io/pandocs/single.html (may 403; use local copies below)

### Locally Mirrored Pan Docs Pages

| Topic | File |
|-------|------|
| Memory Map | [pandocs/Memory_Map.md](pandocs/Memory_Map.md) |
| PPU Rendering / Timing | [pandocs/Rendering.md](pandocs/Rendering.md) |
| Tile Data (2bpp format) | [pandocs/Tile_Data.md](pandocs/Tile_Data.md) |
| Tile Maps (BG/Window) | [pandocs/Tile_Maps.md](pandocs/Tile_Maps.md) |
| OAM (Sprite data) | [pandocs/OAM.md](pandocs/OAM.md) |
| OAM DMA Transfer | [pandocs/OAM_DMA_Transfer.md](pandocs/OAM_DMA_Transfer.md) |
| LCD Control (LCDC) | [pandocs/LCDC.md](pandocs/LCDC.md) |
| LCD Status (STAT) | [pandocs/STAT.md](pandocs/STAT.md) |
| Scrolling (SCX/SCY/WX/WY) | [pandocs/Scrolling.md](pandocs/Scrolling.md) |
| Palettes (CGB BGP/OBP) | [pandocs/Palettes.md](pandocs/Palettes.md) |
| Interrupts (VBlank, STAT, Timer, Serial, Joypad) | [pandocs/Interrupts.md](pandocs/Interrupts.md) |
| Interrupt Sources | [pandocs/Interrupt_Sources.md](pandocs/Interrupt_Sources.md) |
| Joypad Input | [pandocs/Joypad_Input.md](pandocs/Joypad_Input.md) |
| Serial / Link Cable | [pandocs/Serial_Data_Transfer_(Link_Cable).md](pandocs/Serial_Data_Transfer_(Link_Cable).md) |
| Timer and Divider Registers | [pandocs/Timer_and_Divider_Registers.md](pandocs/Timer_and_Divider_Registers.md) |
| Audio Registers | [pandocs/Audio_Registers.md](pandocs/Audio_Registers.md) |
| Audio Overview | [pandocs/Audio.md](pandocs/Audio.md) |
| CGB Registers (VRAM bank, HDMA, palettes) | [pandocs/CGB_Registers.md](pandocs/CGB_Registers.md) |
| CPU Registers and Flags | [pandocs/CPU_Registers_and_Flags.md](pandocs/CPU_Registers_and_Flags.md) |

Also in this repo: `constants/hardware.inc` — complete GB hardware register definitions
used as the source of truth for `dos_port/include/gb_memmap.inc`.

---

## DOS / DPMI / VGA / x86

### DPMI

- **DPMI 0.9 Specification** (INT 31h function reference):
  https://www.phatcode.net/res/262/files/dpmi09.html
  Key functions: 0101h (alloc selector), 0501h (alloc memory block),
  0205h (set protected-mode interrupt vector), 0300h (simulate real-mode interrupt),
  0400h (get DPMI version / host ID).

- **DJGPP Documentation Hub**: https://www.delorie.com/djgpp/doc/
  - VGA programming under DJGPP: https://www.delorie.com/djgpp/doc/ug/graphics/vga.html.en
  - Interrupt handlers: https://www.delorie.com/djgpp/doc/ug/interrupts/inthandlers2.html
  - Interrupt callbacks: https://www.delorie.com/djgpp/doc/dpmi/ch4.6.html
  - Hardware interrupt hooking FAQ: https://delorie.com/djgpp/v2faq/faq18_9.html
  - Hardware interrupt subtleties: https://www.delorie.com/djgpp/v2faq/faq18_11.html

### Interrupt Reference

- **Ralf Brown's Interrupt List**:
  https://www.delorie.com/djgpp/doc/rbinter/
  The definitive reference for all DOS interrupts. Key ones for this project:
  - INT 10h: BIOS video (AH=00h set mode, AH=10h palette)
  - INT 21h: DOS services (file I/O, command line, exit)
  - INT 31h: DPMI services
  - INT 08h / IRQ 0: PIT timer (hook via INT 31h fn 0205h)
  - Ports 0x3C8/0x3C9: VGA palette
  - Port 0x3DA: VGA input status (VSync detection)
  - Ports 0x40/0x43: PIT channel 0 data/command

### VGA Mode 13h

- **Mode 13h quick reference:**
  - Physical framebuffer at linear address `0xA0000` (directly addressable via flat DS)
  - 320×200 pixels, 1 byte per pixel, 256-color indexed
  - Set mode: INT 10h, AX=0x0013
  - Palette: 256 entries × 3 channels; write index to port 0x3C8, then R/G/B (each 0–63) to port 0x3C9
  - VSync: read port 0x3DA; bit 3 = 1 during vertical retrace
  - Wait for VSync: spin until bit 3 goes 0, then until bit 3 goes 1 (avoids tearing)

- **GameDev.net Mode 13h tutorial**:
  https://gamedev.net/tutorials/programming/graphics/the-video-mode-13h-r315

- **Programming VGA (fysnet.net)**:
  https://www.fysnet.net/modex.htm

- **Michael Abrash's Graphics Programming Black Book**:
  https://www.phatcode.net/res/224/files/html/
  Chapters 23–47 cover VGA internals, Mode 13h optimizations, and Mode X.

### PIT (Programmable Interval Timer)

Quick reference:
- Port 0x43: Command register. Write 0x36 for: channel 0, lobyte/hibyte, mode 3 (square wave).
- Port 0x40: Channel 0 data. Write divisor low byte then high byte.
- Divisor for 60 Hz: `1,193,182 / 60 ≈ 19,886` (0x4D8E)
- IRQ 0 = INT 0x08. Hook via DPMI INT 31h function 0205h.
- After processing, send End-Of-Interrupt: `out 0x20, 0x20` (master PIC EOI).
- Chain to original handler to keep DOS system clock from drifting (call original
  every 18.2 Hz ≈ once per 3.3 of our 60 Hz ticks).

### Game Programming Encyclopedia

- **PC Game Programmer's Encyclopedia (PCGPE)**:
  http://qzx.com/pc-gpe/ or http://bespin.org/~qz/pc-gpe/
  Covers: VGA, SVGA, PIT, DMA, Sound Blaster, AdLib, Gravis UltraSound,
  keyboard, mouse, joystick, EMS/XMS, file formats.

- **Awesome DOS** (curated resource list):
  https://github.com/balintkissdev/awesome-dos

---

## Sound Card References

### Sound Blaster 16
- CT1341 DSP programmer's guide (search for "Sound Blaster 16 hardware programming guide")
- Key: DSP I/O base (usually 0x220), IRQ, DMA channel; detect via BLASTER env var
- Direct programming: write to DSP port; use DMA for digitized audio

### General MIDI / MPU-401
- MPU-401 UART mode: write commands to port 0x330/0x331 (or detected base)
- GM spec: 128 instruments, percussion on channel 10, note on/off, program change

### Roland MT-32
- LA synthesis; controlled via MIDI SysEx
- MT-32 SysEx address map available in service manual / editor documentation
- Timbre RAM at 0x080000; rhythm part at 0x030110

### AdLib / OPL2 (Yamaha YM3812)
- "Ad Lib Music Synthesizer Card Programming Guide" (search phatcode.net/articles)
- OPL2 FM synthesis: 9 voices, 4 operators per pair; write register index to port 0x388, then data to 0x389

---

## rgbds (Reference ROM Toolchain)

Required version: **rgbds 1.0.1** (see `.rgbds-version` file)

- Releases: https://github.com/gbdev/rgbds/releases/tag/v1.0.1
- Build reference ROM: `make compare` (SHA1-checks against `roms.sha1`)
