BorderPalettes: ; 72c39 (1c:6c39)
	dr $72c39,$734b9
	;INCBIN "gfx/tilemaps/sgbborder.map"

	;ds $100

	;RGB 30,29,29 ; PAL_SGB1
	;RGB 25,22,25
	;RGB 25,17,21
	;RGB 24,14,12

	;ds $18

	;RGB 30,29,29 ; PAL_SGB2
	;RGB 22,31,16
	;RGB 27,20,6
	;RGB 15,15,15

	;ds $18

	;RGB 30,29,29 ; PAL_SGB3
	;RGB 31,31,17
	;RGB 18,21,29
	;RGB 15,15,15

	;ds $18

SGBBorderGraphics: ; 734b9 (1c:74b9)
	INCBIN "gfx/pokemon_yellow.t6.2bpp"
