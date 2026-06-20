import sys
import os
from PIL import Image

def parse_bytes(filepath):
    bytes_list = []
    with open(filepath, 'r') as f:
        for line in f:
            if ';' in line:
                line = line.split(';')[0]
            if 'db' in line:
                parts = line.split('db')[1]
                for p in parts.split(','):
                    p = p.strip()
                    if not p: continue
                    if p.startswith('0x'):
                        bytes_list.append(int(p, 16))
                    elif p.startswith('$'):
                        bytes_list.append(int(p[1:], 16))
                    else:
                        try:
                            bytes_list.append(int(p))
                        except ValueError:
                            pass
    return bytes_list

def main():
    if len(sys.argv) < 2:
        print("Usage: python simulate_map.py <map_blk.inc>")
        return
        
    map_inc = sys.argv[1]
    
    # Load gfx
    gfx_bytes = parse_bytes("assets/overworld_gfx.inc")
    tiles = []
    for i in range(0, len(gfx_bytes), 16):
        data = gfx_bytes[i:i+16]
        if len(data) < 16: break
        
        tile_img = Image.new("RGBA", (8, 8))
        for y in range(8):
            b1 = data[y*2]
            b2 = data[y*2+1]
            for x in range(8):
                bit1 = (b1 >> (7-x)) & 1
                bit2 = (b2 >> (7-x)) & 1
                color_idx = (bit2 << 1) | bit1
                # Palettes: White, Light Gray, Dark Gray, Black
                c = [(255,255,255,255), (170,170,170,255), (85,85,85,255), (0,0,0,255)][color_idx]
                tile_img.putpixel((x, y), c)
        tiles.append(tile_img)

    # Load blocks
    block_bytes = parse_bytes("assets/overworld_blocks.inc")
    blocks = []
    for i in range(0, len(block_bytes), 16):
        blocks.append(block_bytes[i:i+16])

    # Load collision data
    coll_bytes = parse_bytes("assets/overworld_coll.inc")
    passable_tiles = set(coll_bytes)
    
    # Create red overlay tile (semi-translucent)
    overlay = Image.new("RGBA", (8, 8), (255, 0, 0, 100))

    # Load map blocks
    map_bytes = parse_bytes(map_inc)
    
    # Check width from map headers based on filename
    basename = os.path.basename(map_inc)
    width_blocks = 10
    
    if "pallet_town" in basename:
        width_blocks = 10
    elif "route1" in basename:
        width_blocks = 10
    elif "route21" in basename:
        width_blocks = 10
    # Add more heuristics if needed

    height_blocks = len(map_bytes) // width_blocks
    if len(map_bytes) % width_blocks != 0:
        print("Warning: Map byte count is not a multiple of width.")
    
    out_img = Image.new("RGBA", (width_blocks * 32, height_blocks * 32))
    
    for y in range(height_blocks):
        for x in range(width_blocks):
            block_id = map_bytes[y * width_blocks + x]
            if block_id >= len(blocks):
                print(f"Warning: map has block_id {block_id} which is out of bounds")
                continue
            b = blocks[block_id]
            for ty in range(4):
                for tx in range(4):
                    tile_id = b[ty * 4 + tx]
                    px = (x * 4 + tx) * 8
                    py = (y * 4 + ty) * 8
                    
                    if tile_id < len(tiles):
                        out_img.paste(tiles[tile_id], (px, py))
                    else:
                        print(f"Warning: tile_id {tile_id} out of bounds")
                    
                    if tile_id not in passable_tiles:
                        # Composite the red overlay
                        out_img.alpha_composite(overlay, (px, py))
                        
    out_name = basename.replace('.inc', '.png')
    out_img.save(out_name)
    print(f"Saved to {out_name} ({width_blocks}x{height_blocks} blocks)")

if __name__ == '__main__':
    main()
