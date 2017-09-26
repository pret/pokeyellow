SetDefaultNamesBeforeTitlescreen:
	ld hl, NintenText
	ld de, wPlayerName
	call CopyFixedLengthText
	ld hl, SonyText
	ld de, wRivalName
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

DisplayTitleScreen:
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
	ld hl, NintendoCopyrightLogoGraphics
	ld de, vTitleLogo + $600
	ld bc, $50
	ld a, BANK(NintendoCopyrightLogoGraphics)
	call FarCopyData
	ld hl, NineTile
	ld de, vTitleLogo + $6e0
	ld bc, $10
	ld a, BANK(NineTile)
	call FarCopyData
	ld hl, GamefreakLogoGraphics
	ld de, vTitleLogo + 101 * $10
	ld bc, 9 * $10
	ld a, BANK(GamefreakLogoGraphics)
	call FarCopyData
	callab LoadYellowTitleScreenGFX
	ld hl, vBGMap0
	ld bc, (vBGMap1 + $400) - vBGMap0
	ld a, " "
	call FillMemory
	callab TitleScreen_PlacePokemonLogo
	call FillSpriteBuffer0WithAA
	call .WriteCopyrightTiles
	call SaveScreenTilesToBuffer2
	call LoadScreenTilesFromBuffer2
	call EnableLCD
	callab TitleScreen_PlacePikachu
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

.TitleScreenPokemonLogoYScrolls:
; Controls the bouncing effect of the Pokemon logo on the title screen
	db -4,16  ; y scroll amount, number of times to scroll
	db 3,4
	db -3,4
	db 2,2
	db -2,2
	db 1,2
	db -1,2
	db 0      ; terminate list with 0

.ScrollTitleScreenPokemonLogo:
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
.WriteCopyrightTiles
	coord hl, 2, 17
	ld de, .tileScreenCopyrightTiles
.titleScreenCopyrightTilesLoop
	ld a, [de]
	inc de
	cp $ff
	ret z
	ld [hli], a
	jr .titleScreenCopyrightTilesLoop

.tileScreenCopyrightTiles
	db $e0,$e1,$e2,$e3,$e1,$e2,$ee,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ff ; ©1995-1999 GAME FREAK inc.

.finishedBouncingPokemonLogo
	call LoadScreenTilesFromBuffer1
	ld c, 36
	call DelayFrames
	ld a, SFX_INTRO_WHOOSH
	call PlaySound

; scroll game version in from the right
	callab TitleScreen_PlacePikaSpeechBubble
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
.loop
	xor a
	ld [wUnusedCC5B], a
	ld [wTitleScreenScene], a
	ld [wTitleScreenScene + 1], a
	ld [wTitleScreenScene + 2], a
	ld [wTitleScreenScene + 3], a
	ld a, $f
	ld [wTitleScreenScene + 4], a
.titleScreenLoop
	call IncrementResetCounter
	jp c, .doTitlescreenReset
	call DelayFrame
	call JoypadLowSensitivity
	ld a, [hJoyHeld]
	cp D_UP | SELECT | B_BUTTON
	jr z, .go_to_main_menu
	and A_BUTTON | START
	jr nz, .go_to_main_menu
	call DoTitleScreenFunction
	jr .titleScreenLoop

.go_to_main_menu
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

.asm_42f0
; unreferenced
	callab PrinterDebug
	jp .loop

.asm_42fb
; unreferenced
	ld a, [wTitleScreenScene + 4]
	inc a
	cp $2a
	jr c, .asm_4305
	ld a, $f
.asm_4305
	ld [wTitleScreenScene + 4], a
	ld e, a
	callab PlayPikachuSoundClip
	xor a
	ld [wTitleScreenScene + 2], a
	ld [wTitleScreenScene + 3], a
	jp .titleScreenLoop

.doTitlescreenReset
	ld [wAudioFadeOutControl], a
	call StopAllMusic
.audioFadeLoop
	ld a, [wAudioFadeOutControl]
	and a
	jr nz, .audioFadeLoop
	jp Init

.doClearSaveDialogue
	jpba DoClearSaveDialogue


TitleScreenCopyTileMapToVRAM:
	ld [H_AUTOBGTRANSFERDEST + 1], a
	jp Delay3

LoadCopyrightAndTextBoxTiles:
	xor a
	ld [hWY], a
	call ClearScreen
	call LoadTextBoxTilePatterns

LoadCopyrightTiles:
	ld de, NintendoCopyrightLogoGraphics
	ld hl, vChars2 + $600
	lb bc, BANK(NintendoCopyrightLogoGraphics), (TextBoxGraphics + $10 - NintendoCopyrightLogoGraphics) / $10 ; bug: overflows into text box graphics and copies the "A" tile
	call CopyVideoData
	coord hl, 2, 7
	ld de, CopyrightTextString
	jp PlaceString

CopyrightTextString:
	db   $60,$61,$62,$63,$61,$62,$7c,$7f,$65,$66,$67,$68,$69,$6a			 ; ©1995-1999  Nintendo
	next $60,$61,$62,$63,$61,$62,$7c,$7f,$6b,$6c,$6d,$6e,$6f,$70,$71,$72	 ; ©1995-1999  Creatures inc.
	next $60,$61,$62,$63,$61,$62,$7c,$7f,$73,$74,$75,$76,$77,$78,$79,$7a,$7b ; ©1995-1999  GAME FREAK inc.
	db   "@"

TitleScreen_PlayPikachuPCM:
	callab PlayPikachuSoundClip
	ret
	
DoTitleScreenFunction:
	call .CheckTimer
	ld a, [wTitleScreenScene]
	ld e, a
	ld d, 0
	ld hl, .Jumptable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

	
.Jumptable:
	dw .Nop
	dw .BlinkHalf
	dw .BlinkWait
	dw .BlinkWait
	dw .BlinkClosed
	dw .BlinkWait
	dw .BlinkWait
	dw .BlinkHalf
	dw .BlinkWait
	dw .BlinkWait
	dw .BlinkOpen
	dw .GoBackToStart
	
.GoBackToStart:
	xor a
	ld [wTitleScreenScene], a
.Nop
	ret
	
.BlinkOpen:
	ld e, 0
	jr .LoadBlinkFrame

.BlinkHalf:
	ld e, 4
	jr .LoadBlinkFrame

.BlinkClosed:
	ld e, 8
.LoadBlinkFrame:
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
.BlinkWait:
	ld hl, wTitleScreenScene
	inc [hl]
	ret
	
.CheckTimer:
	ld hl, wTitleScreenTimer
	ld a, [hl]
	inc [hl]
	and a
	jr z, .restart
	cp $80
	jr z, .restart
	cp $90
	ret nz
.restart
	ld a, $1
	ld [wTitleScreenScene], a
	ret

; copy text of fixed length NAME_LENGTH (like player name, rival name, mon names, ...)
CopyFixedLengthText:
	ld bc, NAME_LENGTH
	jp CopyData

NintenText: db "NINTEN@"
SonyText:   db "SONY@"

IncrementResetCounter:
	ld hl, wTitleScreenScene + 2
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

FillSpriteBuffer0WithAA:
	xor a
	call SwitchSRAMBankAndLatchClockData
	ld hl, sSpriteBuffer0
	ld bc, $20
	ld a, $aa
	call FillMemory
	call PrepareRTCDataAndDisableSRAM
	ret
