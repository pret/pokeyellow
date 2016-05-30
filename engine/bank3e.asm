Func_f8000: ; f8000 (3e:4000)
	dr $f8000,$f8bcb

Func_f8bcb: ; f8bcb (3e:4bcb)
	push de
	callab IsSurfingPikachuInThePlayersParty
	pop de
	ret nc
	callab PlayPikachuSoundClip
	ret

Func_f8bdf: ; f8bdf (3e:4bdf)
	dr $f8bdf,$f982d
PlayIntroScene: ; f982d (3e:582d)
	dr $f982d,$fa35a

YellowIntroGraphics:  INCBIN "gfx/yellow_intro.2bpp"

Func_fbb5a: ; fbb5a (3e:7b5a)
	ld hl, wTileMapBackup
	ld bc, 10 * SCREEN_WIDTH
	xor a
	call FillMemory
	ret

Func_fbb65: ; fbb65 (3e:7b65)
	dr $fbb65,$fbd76