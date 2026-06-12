/* link.ld — DJGPP linker script for the Pokemon Yellow DOS port.
 *
 * Output format: coff-go32-exe (DJGPP COFF with built-in real-mode stub)
 * Entry point:   start (defined in boot/entry.asm)
 *
 * The DJGPP linker prepends a ~2 KB real-mode stub (cwsdstub) that:
 *   1. Presents a valid DOS MZ header
 *   2. Detects whether a DPMI host is present; if not, loads CWSDPMI.EXE
 *   3. Switches to 32-bit protected mode
 *   4. Jumps to our 'start' label
 *
 * Text is placed at 0x1000 + SIZEOF_HEADERS (matching DJGPP convention).
 * BSS is zeroed by the stub before 'start' is called.
 */

OUTPUT_FORMAT("coff-go32-exe")
ENTRY(start)

SECTIONS
{
    .text 0x1000 : {
        *(.text)
        *(.text.*)
        . = ALIGN(0x200);
    }

    .data ALIGN(0x200) : {
        *(.data)
        *(.data.*)
        . = ALIGN(0x200);
    }

    .bss ALIGN(0x200) : {
        __bss_start = .;
        *(.bss)
        *(.bss.*)
        *(COMMON)
        __bss_end = .;
        . = ALIGN(0x200);
    }
}
