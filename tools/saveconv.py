#!/usr/bin/env python3
"""
saveconv.py — Game Boy .sav ↔ DOS .dsv save file converter.

STATUS: STUB — Not yet implemented. This is a Phase 5 item.
The DOS save format (.dsv) must be stable before this converter is written.
See ROADMAP.md Phase 5 for details.

Planned usage (Phase 5):
    saveconv.py --to-dos  input.sav  output.dsv   # GB SRAM dump → DOS save
    saveconv.py --to-gb   input.dsv  output.sav   # DOS save → GB SRAM dump

File formats (planned):
    .sav  Raw 32 KB SRAM dump (MBC5+RAM+BATTERY, as produced by emulators)
    .dsv  DOSV header + SRAM data:
              Offset  Size  Description
              0x00    4     Magic: b'DOSV'
              0x04    1     Format version (currently 1)
              0x05    2     CRC-16 of the SRAM data (little-endian)
              0x07    1     Reserved (0x00)
              0x08    32768 Raw SRAM data (same as .sav content)
              Total:  32776 bytes

Checksum: CRC-16/CCITT-FALSE over the 32 KB SRAM data only (not the header).
"""

import sys

DOSV_MAGIC = b'DOSV'
DOSV_VERSION = 1
SAV_SIZE = 32768  # 32 KB
DSV_HEADER_SIZE = 8
DSV_TOTAL_SIZE = DSV_HEADER_SIZE + SAV_SIZE


def main():
    print("saveconv.py: NOT YET IMPLEMENTED (Phase 5 item)")
    print("See ROADMAP.md for details.")
    print()
    print("Planned usage:")
    print("  saveconv.py --to-dos  input.sav  output.dsv")
    print("  saveconv.py --to-gb   input.dsv  output.sav")
    sys.exit(1)


if __name__ == '__main__':
    main()
