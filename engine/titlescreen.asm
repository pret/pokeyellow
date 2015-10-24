SetDefaultNamesBeforeTitlescreen: ; 414b (1:414b)
	ld hl, NintenText
	ld de, wPlayerName
	call CopyFixedLengthText
	ld hl, SonyText
	ld de, W_RIVALNAME
	call CopyFixedLengthText
	xor a
	ld [hWY], a
	ld [wLetterPrintingDelayFlags], a
	ld hl, wd732
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, BANK(Music_TitleScreen)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a

DisplayTitleScreen: ; 4171 (1:4171)
	call GBPalWhiteOut
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	xor a
	ld [hTilesetType], a
	ld [hSCX], a
	ld a, $40
	ld [hSCY], a
	ld a, $90
	ld [hWY], a
	call ClearScreen
	call DisableLCD
	call LoadFontTilePatterns
; todo: fix hl pointers
	ld hl, NintendoCopyrightLogoGraphics ; 4:4c48
	ld de, vTitleLogo + $600
	ld bc, $50
	ld a, BANK(NintendoCopyrightLogoGraphics)
	call FarCopyData
	ld hl, NineTile ; 4:4e08
	ld de, vTitleLogo + $6e0
	ld bc, $10
	ld a, BANK(NineTile)
	call FarCopyData
	ld hl, GamefreakLogoGraphics  ; 4:4d78
	ld de, vTitleLogo + $650
	ld bc, $90
	ld a, BANK(GamefreakLogoGraphics)
	call FarCopyData
	callab Func_f453f
	ld hl, vBGMap0
	ld bc, (vBGMap1 + $400) - vBGMap0
	ld a, " "
	call FillMemory
	callab Func_f4578
	call Func_4418
	call .WriteCopyrightTiles
	call SaveScreenTilesToBuffer2
	call LoadScreenTilesFromBuffer2
	call EnableLCD
	callab Func_f459a
	ld a, $9b
	call TitleScreenCopyTileMapToVRAM
	call SaveScreenTilesToBuffer1
	ld a, $40
	ld [hWY], a
	call LoadScreenTilesFromBuffer2
	ld a, vBGMap0 / $100
	call TitleScreenCopyTileMapToVRAM
	ld b, SET_PAL_TITLE_SCREEN
	call RunPaletteCommand
	call GBPalNormal
	ld a, %11100000
	ld [rOBP0], a
	call UpdateGBCPal_OBP0

; make pokemon logo bounce up and down
	ld bc, hSCY ; background scroll Y
	ld hl, .TitleScreenPokemonLogoYScrolls
.bouncePokemonLogoLoop
	ld a, [hli]
	and a
	jr z, .finishedBouncingPokemonLogo
	ld d, a
	cp -3
	jr nz, .skipPlayingSound
	ld a, SFX_INTRO_CRASH
	call PlaySound
.skipPlayingSound
	ld a, [hli]
	ld e, a
	call .ScrollTitleScreenPokemonLogo
	jr .bouncePokemonLogoLoop

.TitleScreenPokemonLogoYScrolls ; 4228 (1:4228)
; Controls the bouncing effect of the Pokemon logo on the title screen
	db -4,16  ; y scroll amount, number of times to scroll
	db 3,4
	db -3,4
	db 2,2
	db -2,2
	db 1,2
	db -1,2
	db 0      ; terminate list with 0

.ScrollTitleScreenPokemonLogo ; 4237 (1:4237)
; Scrolls the Pokemon logo on the title screen to create the bouncing effect
; Scrolls d pixels e times
	call DelayFrame
	ld a, [bc] ; background scroll Y
	add d
	ld [bc], a
	dec e
	jr nz, .ScrollTitleScreenPokemonLogo
	ret

; place tiles for title screen copyright
.WriteCopyrightTiles ; 4241 (1:4241)
	coord hl, 2, 17
	ld de, .tileScreenCopyrightTiles
.titleScreenCopyrightTilesLoop
	ld a, [de]
	inc de
	cp $ff
	ret z
	ld [hli], a
	jr .titleScreenCopyrightTilesLoop

.tileScreenCopyrightTiles ; 424f (1:424f)
	db $e0,$e1,$e2,$e3,$e1,$e2,$ee,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ff ; ©1995-1999 GAME FREAK inc.

.finishedBouncingPokemonLogo ; 4260 (1:4260)
	call LoadScreenTilesFromBuffer1
	ld c, 36
	call DelayFrames
	ld a, SFX_INTRO_WHOOSH
	call PlaySound

; scroll game version in from the right
	callab Func_f4585
	ld a, SCREEN_HEIGHT_PIXELS
	ld [hWY], a
	call Delay3
	ld e, 0
	call TitleScreen_PlayPikachuPCM
	call WaitForSoundToFinish
	call StopAllMusic
	ld a, MUSIC_TITLE_SCREEN
	ld [wNewSoundID], a
	call PlaySound
.asm_428f
	xor a
	ld [wUnusedCC5B], a
	ld [wTitleMonSpecies], a
	ld [wTitleMonSpecies+1], a
	ld [wTitleMonSpecies+2], a
	ld [wTitleMonSpecies+3], a
	ld a, $f
	ld [wTitleMonSpecies+4], a
.titleScreenLoop
	call IncrementResetCounter
	jp c, .doTitlescreenReset
	call DelayFrame
	call JoypadLowSensitivity
	ld a, [hJoyHeld]
	cp D_UP | SELECT | B_BUTTON
	jr z, .asm_42bf
	and A_BUTTON | START
	jr nz, .asm_42bf
	call Func_4390
	jr .titleScreenLoop
.asm_42bf
	ld e, $a
	call TitleScreen_PlayPikachuPCM
	call GBPalWhiteOutWithDelay3
	call ClearSprites
	xor a
	ld [hWY], a
	inc a
	ld [H_AUTOBGTRANSFERENABLED], a
	call ClearScreen
	ld a, vBGMap0 / $100
	call TitleScreenCopyTileMapToVRAM
	ld a, vBGMap1 / $100
	call TitleScreenCopyTileMapToVRAM
	call Delay3
	call LoadGBPal
	ld a, [hJoyHeld]
	ld b, a
	and D_UP | SELECT | B_BUTTON
	cp D_UP | SELECT | B_BUTTON
	jp z, .doClearSaveDialogue
	jp MainMenu
.asm_42f0 ; 42f0 (1:42f0)
	callab Func_e8e79
	jp .asm_428f

.asm_42fb ; 42fb (1:42fb)
	ld a, [wTitleMonSpecies+4]
	inc a
	cp $2a
	jr c, .asm_4305
	ld a, $f
.asm_4305
	ld [wTitleMonSpecies+4], a
	ld e, a
	callab PlayPikachuSoundClip
	xor a
	ld [wTitleMonSpecies+2], a
	ld [wTitleMonSpecies+3], a
	jp .titleScreenLoop
.doTitlescreenReset ; 431b (1:431b)
	ld [wAudioFadeOutControl], a
	call StopAllMusic
.audioFadeLoop
	ld a, [wAudioFadeOutControl]
	and a
	jr nz, .audioFadeLoop
	jp Init
	
.doClearSaveDialogue ; 432a (1:432a)
	jpba DoClearSaveDialogue


TitleScreenCopyTileMapToVRAM: ; 4332 (1:4332)
	ld [H_AUTOBGTRANSFERDEST + 1], a
	jp Delay3

LoadCopyrightAndTextBoxTiles: ; 4337 (1:4337)
	xor a
	ld [hWY], a
	call ClearScreen
	call LoadTextBoxTilePatterns

LoadCopyrightTiles: ; 4340 (1:4340)
	ld de, NintendoCopyrightLogoGraphics
	ld hl, vChars2 + $600
	lb bc, BANK(NintendoCopyrightLogoGraphics), (TextBoxGraphics + $10 - NintendoCopyrightLogoGraphics) / $10 ; bug: overflows into text box graphics and copies the "A" tile
	call CopyVideoData
	coord hl, 2, 7
	ld de, CopyrightTextString
	jp PlaceString

CopyrightTextString: ; 4355 (1:4355)
	db   $60,$61,$62,$63,$61,$62,$7c,$7f,$65,$66,$67,$68,$69,$6a			 ; ©1995-1999  Nintendo
	next $60,$61,$62,$63,$61,$62,$7c,$7f,$6b,$6c,$6d,$6e,$6f,$70,$71,$72	 ; ©1995-1999  Creatures inc.
	next $60,$61,$62,$63,$61,$62,$7c,$7f,$73,$74,$75,$76,$77,$78,$79,$7a,$7b ; ©1995-1999  GAME FREAK inc.
	db   "@"

TitleScreen_PlayPikachuPCM: ; 4387 (1:4387)
	callab PlayPikachuSoundClip
	ret
	
Func_4390: ; 4390 (1:4390)
	call Func_43de
	ld a, [wTitleMonSpecies]
	ld e, a
	ld d, 0
	ld hl, PointerTable_43a2
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl
	
PointerTable_43a2: ; 43a2 (1:43a2)
	dw Func_43be
	dw Func_43c3
	dw Func_43d9
	dw Func_43d9
	dw Func_43c7
	dw Func_43d9
	dw Func_43d9
	dw Func_43c3
	dw Func_43d9
	dw Func_43d9
	dw Func_43bf
	dw Func_43ba
	
Func_43ba: ; 43ba (1:43ba)
	xor a
	ld [wTitleMonSpecies], a
Func_43be
	ret
	
Func_43bf: ; 43bf (1:43bf)
	ld e, 0
	jr asm_43c9
Func_43c3: ; 43c3 (1:43c3)
	ld e, 4
	jr asm_43c9
Func_43c7: ; 43c7 (1:43c7)
	ld e, 8
asm_43c9: ; 43c9 (1:43c9)
	ld hl, wOAMBuffer + 2
	ld c, 8
.loop
	ld a, [hl]
	and $f3
	or e
	ld [hli], a
	inc hl
	inc hl
	inc hl
	dec c
	jr nz, .loop
Func_43d9: ; 43d9 (1:43d9)
	ld hl, wTitleMonSpecies
	inc [hl]
	ret
	
Func_43de: ; 43de (1:43de)
	ld hl, wTitleMonSpecies + 1
	ld a, [hl]
	inc [hl]
	and a
	jr z, .asm_43ed
	cp $80
	jr z, .asm_43ed
	cp $90
	ret nz
.asm_43ed
	ld a, $1
	ld [wTitleMonSpecies], a
	ret

; copy text of fixed length NAME_LENGTH (like player name, rival name, mon names, ...)
CopyFixedLengthText: ; 43f3 (1:43f3)
	ld bc, NAME_LENGTH
	jp CopyData
	
NintenText: db "NINTEN@"
SonyText:   db "SONY@"

IncrementResetCounter: ; 4405 (1:4405)
	ld hl, wTitleMonSpecies + 2
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc de
	ld a, d
	cp $c
	jr z, .doReset
	ld [hl], d
	dec hl
	ld [hl], e
	and a
	ret
.doReset
	scf
	ret
	
Func_4418: ; 4418 (1:4418)
	xor a
	call SwitchSRAMBankAndLatchClockData
	ld hl, $a000
	ld bc, $20
	ld a, $aa
	call FillMemory
	call PrepareRTCDataAndDisableSRAM
	ret