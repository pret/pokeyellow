; OptionMenuJumpTable indexes
	const_def
	const OPT_TEXT_SPEED   ; 0
	const OPT_BATTLE_ANIMS ; 1
	const OPT_BATTLE_STYLE ; 2
	const OPT_SOUND        ; 3
	const OPT_PRINTER      ; 4
	const_skip 2
	const OPT_CANCEL       ; 7
DEF NUM_OPTIONS EQU const_value ; 8

DisplayOptionMenu_:
	call InitOptionsMenu
.optionMenuLoop
	call JoypadLowSensitivity
	ldh a, [hJoy5]
	and PAD_START | PAD_B
	jr nz, .exitOptionMenu
	call OptionsControl
	jr c, .dpadDelay
	call GetOptionPointer
	jr c, .exitOptionMenu
.dpadDelay
	call OptionsMenu_UpdateCursorPosition
	call DelayFrame
	call DelayFrame
	call DelayFrame
	jr .optionMenuLoop
.exitOptionMenu
	ret

GetOptionPointer:
	ld a, [wOptionsCursorLocation]
	ld e, a
	ld d, 0
	ld hl, OptionMenuJumpTable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl ; jump to the function for the current highlighted option

OptionMenuJumpTable:
	dw OptionsMenu_TextSpeed
	dw OptionsMenu_BattleAnimations
	dw OptionsMenu_BattleStyle
	dw OptionsMenu_SpeakerSettings
	dw OptionsMenu_GBPrinterBrightness
	dw OptionsMenu_Dummy
	dw OptionsMenu_Dummy
	dw OptionsMenu_Cancel

	const_def
	const OPT_TEXT_SPEED_FAST ; 0
	const OPT_TEXT_SPEED_MID  ; 1
	const OPT_TEXT_SPEED_SLOW ; 2
DEF NUM_TEXT_SPEED_OPTS EQU const_value ; 3

OptionsMenu_TextSpeed:
	call GetTextSpeed
	ldh a, [hJoy5]
	bit B_PAD_RIGHT, a
	jr nz, .pressedRight
	bit B_PAD_LEFT, a
	jr nz, .pressedLeft
	jr .nonePressed

.pressedRight
	ld a, c
	cp NUM_TEXT_SPEED_OPTS - 1
	jr c, .increase
	ld c, -1
.increase
	inc c
	ld a, e
	jr .save

.pressedLeft
	ld a, c
	and a
	jr nz, .decrease
	ld c, NUM_TEXT_SPEED_OPTS
.decrease
	dec c
	ld a, d

.save
	ld b, a
	ld a, [wOptions]
	and ~TEXT_DELAY_MASK
	or b
	ld [wOptions], a

.nonePressed
	ld b, 0
	ld hl, .Strings
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 14, 2
	call PlaceString
	and a ; clear carry flag
	ret

.Strings:
; entries correspond to OPT_TEXT_SPEED_* constants
	dw .Fast
	dw .Mid
	dw .Slow

.Fast: db "FAST@"
.Mid:  db "MID @"
.Slow: db "SLOW@"

; Loads the value of the current selection in c
; Loads the text delay value of the options
; to the left in d and to the right in e
GetTextSpeed:
	ld a, [wOptions]
	and TEXT_DELAY_MASK
	cp TEXT_DELAY_SLOW
	jr z, .slowTextOption
	cp TEXT_DELAY_FAST
	jr z, .fastTextOption
	ld c, OPT_TEXT_SPEED_MID
	lb de, TEXT_DELAY_FAST, TEXT_DELAY_SLOW
	ret

.slowTextOption
	ld c, OPT_TEXT_SPEED_SLOW
	lb de, TEXT_DELAY_MEDIUM, TEXT_DELAY_FAST
	ret

.fastTextOption
	ld c, OPT_TEXT_SPEED_FAST
	lb de, TEXT_DELAY_SLOW, TEXT_DELAY_MEDIUM
	ret

OptionsMenu_BattleAnimations:
	ldh a, [hJoy5]
	and PAD_LEFT | PAD_RIGHT
	jr nz, .buttonPressed
	ld a, [wOptions]
	and 1 << BIT_BATTLE_ANIMATION
	jr .nothingPressed

.buttonPressed
	ld a, [wOptions]
	xor 1 << BIT_BATTLE_ANIMATION
	ld [wOptions], a

.nothingPressed
	ld bc, 0
	sla a
	rl c
	ld hl, .Strings
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 14, 4
	call PlaceString
	and a ; clear carry flag
	ret

.Strings:
	dw .On
	dw .Off

.On:  db "ON @"
.Off: db "OFF@"

OptionsMenu_BattleStyle:
	ldh a, [hJoy5]
	and PAD_LEFT | PAD_RIGHT
	jr nz, .buttonPressed
	ld a, [wOptions]
	and 1 << BIT_BATTLE_SHIFT
	jr .nothingPressed

.buttonPressed
	ld a, [wOptions]
	xor 1 << BIT_BATTLE_SHIFT
	ld [wOptions], a

.nothingPressed
	ld bc, 0
	sla a
	sla a
	rl c
	ld hl, .Strings
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 14, 6
	call PlaceString
	and a ; clear carry flag
	ret

.Strings:
	dw .Shift
	dw .Set

.Shift: db "SHIFT@"
.Set:   db "SET  @"

OptionsMenu_SpeakerSettings:
	ld a, [wOptions]
	and SOUND_MASK
	swap a ; move sound option bits (4–5) into bits 0–1
	ld c, a
	ldh a, [hJoy5]
	bit B_PAD_RIGHT, a
	jr nz, .pressedRight
	bit B_PAD_LEFT, a
	jr nz, .pressedLeft
	jr .nothingPressed

.pressedRight
	ld a, c
	inc a
	and SOUND_MASK >> 4
	jr .save

.pressedLeft
	ld a, c
	dec a
	and SOUND_MASK >> 4

.save
	ld c, a
	swap a
	ld b, a
	xor a
	ldh [rAUDTERM], a
	ld a, [wOptions]
	and ~SOUND_MASK
	or b
	ld [wOptions], a

.nothingPressed
	ld b, 0
	ld hl, .Strings
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 8, 8
	call PlaceString
	and a ; clear carry flag
	ret

.Strings:
	dw .Mono
	dw .Earphone1
	dw .Earphone2
	dw .Earphone3

.Mono:      db "MONO     @"
.Earphone1: db "EARPHONE1@"
.Earphone2: db "EARPHONE2@"
.Earphone3: db "EARPHONE3@"

	const_def
	const OPT_PRINTER_LIGHTEST ; 0
	const OPT_PRINTER_LIGHTER  ; 1
	const OPT_PRINTER_NORMAL   ; 2
	const OPT_PRINTER_DARKER   ; 3
	const OPT_PRINTER_DARKEST  ; 4
DEF NUM_PRINTER_OPTS EQU const_value ; 5

OptionsMenu_GBPrinterBrightness:
	call GetGBPrinterBrightness
	ldh a, [hJoy5]
	bit B_PAD_RIGHT, a
	jr nz, .pressedRight
	bit B_PAD_LEFT, a
	jr nz, .pressedLeft
	jr .nothingPressed

.pressedRight
	ld a, c
	cp NUM_PRINTER_OPTS - 1
	jr c, .increase
	ld c, -1
.increase
	inc c
	ld a, e
	jr .save

.pressedLeft
	ld a, c
	and a
	jr nz, .decrease
	ld c, NUM_PRINTER_OPTS
.decrease
	dec c
	ld a, d

.save
	ld b, a
	ld [wPrinterSettings], a

.nothingPressed
	ld b, 0
	ld hl, .Strings
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 8, 10
	call PlaceString
	and a ; clear carry flag
	ret

.Strings:
	dw .Lightest
	dw .Lighter
	dw .Normal
	dw .Darker
	dw .Darkest

.Lightest: db "LIGHTEST@"
.Lighter:  db "LIGHTER @"
.Normal:   db "NORMAL  @"
.Darker:   db "DARKER  @"
.Darkest:  db "DARKEST @"

; Loads the value of the current selection in c
; Loads the brightness value of the options
; to the left in d and to the right in e
GetGBPrinterBrightness:
	ld a, [wPrinterSettings]
	and a ; cp PRINTER_BRIGHTNESS_LIGHTEST
	jr z, .setLightest
	cp PRINTER_BRIGHTNESS_LIGHTER
	jr z, .setLighter
	cp PRINTER_BRIGHTNESS_DARKER
	jr z, .setDarker
	cp PRINTER_BRIGHTNESS_DARKEST
	jr z, .setDarkest
	ld c, OPT_PRINTER_NORMAL
	lb de, PRINTER_BRIGHTNESS_LIGHTER, PRINTER_BRIGHTNESS_DARKER
	ret

.setLightest
	ld c, OPT_PRINTER_LIGHTEST
	lb de, PRINTER_BRIGHTNESS_DARKEST, PRINTER_BRIGHTNESS_LIGHTER
	ret

.setLighter
	ld c, OPT_PRINTER_LIGHTER
	lb de, PRINTER_BRIGHTNESS_LIGHTEST, PRINTER_BRIGHTNESS_NORMAL
	ret

.setDarker
	ld c, OPT_PRINTER_DARKER
	lb de, PRINTER_BRIGHTNESS_NORMAL, PRINTER_BRIGHTNESS_DARKEST
	ret

.setDarkest
	ld c, OPT_PRINTER_DARKEST
	lb de, PRINTER_BRIGHTNESS_DARKER, PRINTER_BRIGHTNESS_LIGHTEST
	ret

OptionsMenu_Dummy:
	and a ; clear carry flag
	ret

OptionsMenu_Cancel:
	ldh a, [hJoy5]
	and PAD_A
	jr nz, .pressedCancel
	and a ; clear carry flag
	ret

.pressedCancel
	scf
	ret

OptionsControl:
	ld hl, wOptionsCursorLocation
	ldh a, [hJoy5]
	cp PAD_DOWN
	jr z, .pressedDown
	cp PAD_UP
	jr z, .pressedUp
	and a ; clear carry flag
	ret

.pressedDown
	ld a, [hl]
	cp NUM_OPTIONS - 1
	jr nz, .doNotWrap
	ld [hl], 0
	scf
	ret
.doNotWrap
	cp OPT_PRINTER ; skip the next two dummy options
	jr c, .increase
	ld [hl], OPT_CANCEL - 1 ; Cancel is after Print
.increase
	inc [hl]
	scf
	ret

.pressedUp
	ld a, [hl]
	cp OPT_CANCEL ; skip the previous two dummy options
	jr nz, .doNotSkip
	ld [hl], OPT_PRINTER ; Print is before Cancel
	scf
	ret
.doNotSkip
	and a
	jr nz, .decrease
	ld [hl], NUM_OPTIONS
.decrease
	dec [hl]
	scf
	ret

OptionsMenu_UpdateCursorPosition:
	hlcoord 1, 1
	ld de, SCREEN_WIDTH
	ld c, 16
.loop
	ld [hl], ' '
	add hl, de
	dec c
	jr nz, .loop
	hlcoord 1, 2
	ld bc, SCREEN_WIDTH * 2
	ld a, [wOptionsCursorLocation]
	call AddNTimes
	ld [hl], '▶'
	ret

InitOptionsMenu:
	hlcoord 0, 0
	lb bc, SCREEN_HEIGHT - 2, SCREEN_WIDTH - 2
	call TextBoxBorder
	hlcoord 2, 2
	ld de, AllOptionsText
	call PlaceString
	hlcoord 2, 16
	ld de, OptionMenuCancelText
	call PlaceString
	xor a
	ld [wOptionsCursorLocation], a
	ld c, 5 ; the number of options to loop through
.loop
	push bc
	call GetOptionPointer ; updates the next option
	pop bc
	ld hl, wOptionsCursorLocation
	inc [hl] ; moves the cursor for the highlighted option
	dec c
	jr nz, .loop
	xor a
	ld [wOptionsCursorLocation], a
	inc a
	ldh [hAutoBGTransferEnabled], a
	call Delay3
	ret

AllOptionsText:
	db   "TEXT SPEED :"
	next "ANIMATION  :"
	next "BATTLESTYLE:"
	next "SOUND:"
	next "PRINT:@"

OptionMenuCancelText:
	db "CANCEL@"
