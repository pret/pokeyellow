BorderPalettes: ; 72788 (1c:6788)
	INCBIN "gfx/tilemaps/sgbborder.map"

	ds $100

	RGB 30,29,29 ; PAL_SGB1
	RGB 25,22,25
	RGB 25,17,21
	RGB 24,14,12

	ds $18

	RGB 30,29,29 ; PAL_SGB2
	RGB 22,31,16
	RGB 27,20,6
	RGB 15,15,15

	ds $18

	RGB 30,29,29 ; PAL_SGB3
	RGB 31,31,17
	RGB 18,21,29
	RGB 15,15,15

	ds $18

SGBBorderGraphics: ; 72fe8 (1c:6fe8)
	INCBIN "gfx/sgbborder.2bpp"
