SECTION "VRAM", VRAM ; https://gbdev.io/pandocs/Tile_Data.html#data-format

; LCD(Liquid-crystal display) 8x8 pixels == each tile(.png file) contains 128 bits or 16 bytes per one
: location  https://gbdev.io/pandocs/Memory_Map.html
; VRAM has two banks, 8 KiB per bank
; tile data is stored in the memory range from $8000 to $97FF
; calculation: bank = 384 tiles (768 tiles for both in CGB? mode)
; 3 blocks per 128 tiles =
;                          block 0: $8000-$87FF (128 tiles)
;                          block 1: $8800-$8FFF (128 tiles)
;                          block 2: $9000-$97FF (128 tiles)
; https://gbdev.io/pandocs/CGB_Registers.html 
; tiles keyword store 'new' tiles somewhere in random address location???
; tile map screen and tile map addresses up to 768
; https://www.youtube.com/watch?v=zQE1K074v3s

UNION
; generic
vChars0:: ds $80 tiles
vChars1:: ds $80 tiles
vChars2:: ds $80 tiles
vBGMap0:: ds TILEMAP_AREA
vBGMap1:: ds TILEMAP_AREA

NEXTU
; battle/menu
vSprites::  ds $80 tiles
vFont::     ds $80 tiles ; store [destination]VRAM address space $80 [source]tiles out of 
vFrontPic:: ds 7 * 7 tiles
vBackPic::  ds 7 * 7 tiles

NEXTU
; overworld
vNPCSprites::  ds $80 tiles
vNPCSprites2:: ds $80 tiles
vTileset::     ds $80 tiles

NEXTU
; title
	ds $80 tiles
vTitleLogo::  ds $80 tiles
	ds 7 * 7 tiles
vTitleLogo2:: ds 30 tiles

ENDU

ENDSECTION
