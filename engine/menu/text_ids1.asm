; function that performs initialization for DisplayTextID
DisplayTextIDInit: ; 6f0e (1:6f0e)
	xor a
	ld [wListMenuID],a
	ld a,[wAutoTextBoxDrawingControl]
	bit 0,a
	jr nz,.skipDrawingTextBoxBorder
	ld a,[hSpriteIndexOrTextID] ; text ID (or sprite ID)
	and a
	jr nz,.notStartMenu
; if text ID is 0 (i.e. the start menu)
; Note that the start menu text border is also drawn in the function directly
; below this, so this seems unnecessary.
	CheckEvent EVENT_GOT_POKEDEX
; start menu with pokedex
	coord hl, 10, 0
	lb bc, 14, 8
	jr nz,.drawTextBoxBorder
; start menu without pokedex
	coord hl, 10, 0
	lb bc, 12, 8
	jr .drawTextBoxBorder
; if text ID is not 0 (i.e. not the start menu) then do a standard dialogue text box
.notStartMenu
	coord hl, 0, 12
	lb bc, 4, 18
.drawTextBoxBorder
	call TextBoxBorder
.skipDrawingTextBoxBorder
	ld hl,wFontLoaded
	set 0,[hl]
	ld hl,wFlags_0xcd60
	bit 4,[hl]
	res 4,[hl]
	jr nz,.skipMovingSprites
	call UpdateSprites
.skipMovingSprites
; loop to copy C1X9 (direction the sprite is facing) to C2X9 for each sprite
; this is done because when you talk to an NPC, they turn to look your way
; the original direction they were facing must be restored after the dialogue is over
	ld hl,wSpriteStateData1 + $19
	ld c,$0f
	ld de,$0010
.spriteFacingDirectionCopyLoop
	ld a,[hl]
	inc h
	ld [hl],a
	dec h
	add hl,de
	dec c
	jr nz,.spriteFacingDirectionCopyLoop
; loop to force all the sprites in the middle of animation to stand still
; (so that they don't like they're frozen mid-step during the dialogue)
	ld hl,wSpriteStateData1 + 2
	ld de,$0010
	ld c,e
.spriteStandStillLoop
	ld a,[hl]
	cp a,$ff ; is the sprite visible?
	jr z,.nextSprite
; if it is visible
	and a,$fc
	ld [hl],a
.nextSprite
	add hl,de
	dec c
	jr nz,.spriteStandStillLoop
	ld b,vBGMap1 / $100 ; window background address
	call CopyScreenTileBufferToVRAM ; transfer background in WRAM to VRAM
	xor a
	ld [hWY],a ; put the window on the screen
	call LoadFontTilePatterns
	ld a,$01
	ld [H_AUTOBGTRANSFERENABLED],a ; enable continuous WRAM to VRAM transfer each V-blank
	ret

; function that displays the start menu
DrawStartMenu: ; 6f80 (1:6f80)
	CheckEvent EVENT_GOT_POKEDEX
; menu with pokedex
	coord hl, 10, 0
	lb bc, 14, 8
	jr nz,.drawTextBoxBorder
; shorter menu if the player doesn't have the pokedex
	coord hl, 10, 0
	lb bc, 12, 8
.drawTextBoxBorder
	call TextBoxBorder
	ld a,D_DOWN | D_UP | START | B_BUTTON | A_BUTTON
	ld [wMenuWatchedKeys],a
	ld a,$02
	ld [wTopMenuItemY],a ; Y position of first menu choice
	ld a,$0b
	ld [wTopMenuItemX],a ; X position of first menu choice
	ld a,[wBattleAndStartSavedMenuItem] ; remembered menu selection from last time
	ld [wCurrentMenuItem],a
	ld [wLastMenuItem],a
	xor a
	ld [wMenuWatchMovingOutOfBounds],a
	ld hl,wd730
	set 6,[hl] ; no pauses between printing each letter
	coord hl, 12, 2
	CheckEvent EVENT_GOT_POKEDEX
; case for not having pokdex
	ld a,$06
	jr z,.storeMenuItemCount
; case for having pokedex
	ld de,StartMenuPokedexText
	call PrintStartMenuItem
	ld a,$07
.storeMenuItemCount
	ld [wMaxMenuItem],a ; number of menu items
	ld de,StartMenuPokemonText
	call PrintStartMenuItem
	ld de,StartMenuItemText
	call PrintStartMenuItem
	ld de,wPlayerName ; player's name
	call PrintStartMenuItem
	ld a,[wd72e]
	bit 6,a ; is the player using the link feature?
; case for not using link feature
	ld de,StartMenuSaveText
	jr z,.printSaveOrResetText
; case for using link feature
	ld de,StartMenuResetText
.printSaveOrResetText
	call PrintStartMenuItem
	ld de,StartMenuOptionText
	call PrintStartMenuItem
	ld de,StartMenuExitText
	call PlaceString
	ld hl,wd730
	res 6,[hl] ; turn pauses between printing letters back on
	ret

StartMenuPokedexText: ; 7002 (1:7002)
	db "POKéDEX@"

StartMenuPokemonText: ; 700a (1:700a)
	db "#MON@"

StartMenuItemText: ; 700f (1:700f)
	db "ITEM@"

StartMenuSaveText: ; 7014 (1:7014)
	db "SAVE@"

StartMenuResetText: ; 7019 (1:7019)
	db "RESET@"

StartMenuExitText: ; 701f (1:701f)
	db "EXIT@"

StartMenuOptionText: ; 7024 (1:7024)
	db "OPTION@"

PrintStartMenuItem: ; 702b (1:702b)
	push hl
	call PlaceString
	pop hl
	ld de,SCREEN_WIDTH * 2
	add hl,de
	ret