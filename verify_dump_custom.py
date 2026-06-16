#!/usr/bin/env python3
"""Parse DUMP.BIN and verify map header state after LoadMapHeader."""
import sys

def parse_dump(filename):
    with open(filename, 'rb') as f:
        data = f.read()

    print(f"DUMP.BIN size: {len(data)} bytes")

    # Window 7 (offset 0x1C0) = GB 0xD358 (map header vars)
    wram_window = data[0x1C0:0x1C0+64]
    
    # wCurMap at 0xD35D = offset 0x05 in this window
    cur_map = wram_window[0x05]
    print(f"\nwCurMap: 0x{cur_map:02X}", end="")
    if cur_map == 0x00: print(" (PALLET_TOWN)")
    elif cur_map == 0x0C: print(" (ROUTE_1)")
    elif cur_map == 0x20: print(" (ROUTE_21)")
    else: print(f" (unknown)")

    # wCurrentTileBlockMapViewPointer at 0xD35E = offset 0x06
    view_ptr = wram_window[0x06] | (wram_window[0x07] << 8)
    print(f"wCurrentTileBlockMapViewPointer: 0x{view_ptr:04X}")

    # wYCoord/wXCoord at 0xD360/0xD361 = offset 0x08/0x09
    y_coord = wram_window[0x08]
    x_coord = wram_window[0x09]
    print(f"wYCoord: {y_coord}, wXCoord: {x_coord}")

    # wCurMapHeader at 0xD366 = offset 0x0E (10 bytes)
    hdr_offset = 0x0E
    tileset = wram_window[hdr_offset]
    height = wram_window[hdr_offset + 1]
    width = wram_window[hdr_offset + 2]
    data_ptr = wram_window[hdr_offset + 3] | (wram_window[hdr_offset + 4] << 8)
    conn = wram_window[hdr_offset + 9]
    print(f"\nMap Header (wCurMapHeader):")
    print(f"  Tileset: 0x{tileset:02X} (expected 0x00 = OVERWORLD)")
    print(f"  Height:  0x{height:02X} (Pallet=09, Route1=12, Route21=2D)")
    print(f"  Width:   0x{width:02X} (all=0A)")
    print(f"  DataPtr: 0x{data_ptr:04X}")
    print(f"  Connections: 0x{conn:02X} (Pallet=0C, Route1=04, Route21=08)")

    # Connection slots: wNorthConnectedMap at 0xD370 = offset 0x18
    north_map = wram_window[0x18]
    # wSouthConnectedMap at 0xD37B = offset 0x23
    south_map = wram_window[0x23]
    # wWestConnectedMap at 0xD386 = offset 0x2E
    west_map = wram_window[0x2E]
    # wEastConnectedMap at 0xD391 = offset 0x39
    east_map = wram_window[0x39]
    print(f"\nConnection slots:")
    print(f"  North: 0x{north_map:02X} {'(ROUTE_1)' if north_map == 0x0C else '(disabled)' if north_map == 0xFF else '(?)'}")
    print(f"  South: 0x{south_map:02X} {'(ROUTE_21)' if south_map == 0x20 else '(PALLET_TOWN)' if south_map == 0x00 else '(disabled)' if south_map == 0xFF else '(?)'}")
    print(f"  West:  0x{west_map:02X} {'(disabled)' if west_map == 0xFF else '(?)'}")
    print(f"  East:  0x{east_map:02X} {'(disabled)' if east_map == 0xFF else '(?)'}")

    # Window 8 (offset 0x200) = GB 0xD520 (tileset ptrs)
    tset_window = data[0x200:0x200+64]
    tset_bank = tset_window[0x0A]  # W_TILESET_BANK at 0xD52A = offset 0x0A
    blocks_ptr = tset_window[0x0B] | (tset_window[0x0C] << 8)
    gfx_ptr = tset_window[0x0D] | (tset_window[0x0E] << 8)
    coll_ptr = tset_window[0x0F] | (tset_window[0x10] << 8)
    grass_tile = tset_window[0x14]
    print(f"\nTileset Header (wTileset*):")
    print(f"  Bank:     0x{tset_bank:02X}")
    print(f"  BlocksPtr: 0x{blocks_ptr:04X} (expected 0x4600)")
    print(f"  GfxPtr:    0x{gfx_ptr:04X} (expected 0x4000)")
    print(f"  CollPtr:   0x{coll_ptr:04X} (expected 0x4F00)")
    print(f"  GrassTile: 0x{grass_tile:02X} (expected 0x52)")

    # Window 3 (offset 0x080) = GB 0x4E00 (PalletTown.blk)
    blk_window = data[0x080:0x080+64]
    print(f"\nPalletTown.blk first 16 bytes: {' '.join(f'{b:02X}' for b in blk_window[:16])}")

    # Validation
    print(f"\n--- VALIDATION ---")
    errors = 0
    if tileset != 0x00:
        print(f"FAIL: tileset should be 0x00"); errors += 1
    if width != 0x0A:
        print(f"FAIL: width should be 0x0A"); errors += 1
    if west_map != 0xFF:
        print(f"FAIL: west connection should be 0xFF"); errors += 1
    if east_map != 0xFF:
        print(f"FAIL: east connection should be 0xFF"); errors += 1
    if blocks_ptr != 0x4600:
        print(f"FAIL: blocks ptr should be 0x4600"); errors += 1
    if gfx_ptr != 0x4000:
        print(f"FAIL: gfx ptr should be 0x4000"); errors += 1
    if errors == 0:
        print("ALL CHECKS PASSED")
    else:
        print(f"{errors} CHECK(S) FAILED")

if __name__ == '__main__':
    fn = sys.argv[1] if len(sys.argv) > 1 else 'dos_port/DUMP.BIN'
    parse_dump(fn)
