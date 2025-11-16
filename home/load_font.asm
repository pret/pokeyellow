LoadFontTilePatterns::
	ldh a, [rLCDC]
	bit B_LCDC_ENABLE, a
	jr nz, .on
.off
	ld hl, FontGraphics
	ld de, vFont
	ld bc, FontGraphicsEnd - FontGraphics
	ld a, BANK(FontGraphics)
	jp FarCopyDataDouble ; if LCD is off, transfer all at once
.on
	ld de, FontGraphics
	ld hl, vFont ; in ram_Folder -> vram.asm file which set the address $8000 == $80 tiles???
	lb bc, BANK(FontGraphics), (FontGraphicsEnd - FontGraphics) / $8 ; why hexavalue or address location $8? look above line
	; lb bc, BANK(FontGraphics), (FontGraphicsEnd - FontGraphics) / $1
	jp CopyVideoDataDouble ; if LCD is on, transfer during V-blank

; this get load it first and follow the "tile" keyword
LoadTextBoxTilePatterns::
	ldh a, [rLCDC]
	bit B_LCDC_ENABLE, a
	jr nz, .on
.off
	ld hl, TextBoxGraphics
	ld de, vChars2 tile $60 ; address location in VRAM? data_folder -> tilemaps.asm 
	ld bc, TextBoxGraphicsEnd - TextBoxGraphics
	ld a, BANK(TextBoxGraphics)
	jp FarCopyData ; if LCD is off, transfer all at once
.on
	ld de, TextBoxGraphics
	ld hl, vChars2 tile $60 ; address location in VRAM? 
	lb bc, BANK(TextBoxGraphics), (TextBoxGraphicsEnd - TextBoxGraphics) / $10
	jp CopyVideoData ; if LCD is on, transfer during V-blank

LoadHpBarAndStatusTilePatterns::
	ldh a, [rLCDC]
	bit B_LCDC_ENABLE, a
	jr nz, .on
.off
	ld hl, HpBarAndStatusGraphics ; INCBIN "gfx/font/font_battle_extra.2bpp"
	ld de, vChars2 tile $62 
	ld bc, HpBarAndStatusGraphicsEnd - HpBarAndStatusGraphics
	ld a, BANK(HpBarAndStatusGraphics)
	jp FarCopyData ; if LCD is off, transfer all at once
.on
	ld de, HpBarAndStatusGraphics
	ld hl, vChars2 tile $62
	lb bc, BANK(HpBarAndStatusGraphics), (HpBarAndStatusGraphicsEnd - HpBarAndStatusGraphics) / $10
	jp CopyVideoData ; if LCD is on, transfer during V-blank
