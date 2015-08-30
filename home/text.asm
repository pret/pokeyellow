TextBoxBorder:: ; 16f0 (0:16f0)
; Draw a cxb text box at hl.

	; top row
	push hl
	ld a, "┌"
	ld [hli], a
	inc a ; ─
	call NPlaceChar
	inc a ; ┐
	ld [hl], a
	pop hl

	ld de, 20
	add hl, de

	; middle rows
.next
	push hl
	ld a, "│"
	ld [hli],a
	ld a, " "
	call NPlaceChar
	ld [hl], "│"
	pop hl

	ld de, 20
	add hl, de
	dec b
	jr nz, .next

	; bottom row
	ld a, "└"
	ld [hli], a
	ld a, "─"
	call NPlaceChar
	ld [hl], "┘"
	ret

NPlaceChar:: ; 171d (0:171d)
; Place char a c times.
	ld d, c
.loop
	ld [hli], a
	dec d
	jr nz, .loop
	ret

PlaceString:: ; 1723 (0:1723)
	push hl
PlaceNextChar:: ; 1724 (0:1724)
	ld a,[de]

	cp "@"
	jr nz,Char4ETest
	ld b,h
	ld c,l
	pop hl
	ret

Char4ETest:: ; 172d (0:172d) 
	cp $4E
	jr nz,.next
	ld bc,$0028
	ld a,[hFlags_0xFFFA]
	bit 2,a
	jr z,.next2
	ld bc,SCREEN_WIDTH
.next2
	pop hl
	add hl,bc
	push hl
	jp PlaceNextChar_inc ; 17b6

.next
	cp $4F
	jr nz,.next3
	pop hl
	coord hl, 1, 16
	push hl
	jp PlaceNextChar_inc

.next3 ; Check against a dictionary
	and a
	jp z,Char00
	cp $4C
	jp z,Char4C
	cp $4B
	jp z,Char4B
	cp $51
	jp z,Char51
	cp $49
	jp z,Char49
	cp $52
	jp z,Char52
	cp $53
	jp z,Char53
	cp $54
	jp z,Char54
	cp $5B
	jp z,Char5B
	cp $5E
	jp z,Char5E
	cp $5C
	jp z,Char5C
	cp $5D
	jp z,Char5D
	cp $55
	jp z,Char55
	cp $56
	jp z,Char56
	cp $57
	jp z,Char57
	cp $58
	jp z,Char58
	cp $4A
	jp z,Char4A
	cp $5F
	jp z,Char5F
	cp $59
	jp z,Char59
	cp $5A
	jp z,Char5A
	ld [hli],a
	call PrintLetterDelay
PlaceNextChar_inc:: ; 17b6 (0:17b6)
	inc de
	jp PlaceNextChar

Char00:: ; 17ba (0:17ba)
	ld b,h
	ld c,l
	pop hl
	ld de,Char00Text
	dec de
	ret

Char00Text:: ; 17c2 (0:17c2) ; “%d ERROR.”
	TX_FAR _Char00Text ; a0c66 (28:4c66)
	db "@"

Char52:: ; 17c7 (0:17c7) ; player’s name
	push de
	ld de,wPlayerName
	jr FinishDTE

Char53:: ; 17cd (0:17cd) ; rival’s name
	push de
	ld de,W_RIVALNAME
	jr FinishDTE

Char5D:: ; 17d3 (0:17d3) ; TRAINER
	push de
	ld de,Char5DText
	jr FinishDTE

Char5C:: ; 17d9 (0:17d9) ; TM
	push de
	ld de,Char5CText
	jr FinishDTE

Char5B:: ; 17df (0:17df) ; PC
	push de
	ld de,Char5BText
	jr FinishDTE

Char5E:: ; 17e5 (0:17e5) ; ROCKET
	push de
	ld de,Char5EText
	jr FinishDTE

Char54:: ; 17eb (0:17eb) ; POKé
	push de
	ld de,Char54Text
	jr FinishDTE

Char56:: ; 17f1 (0:17f1) ; ……
	push de
	ld de,Char56Text
	jr FinishDTE

Char4A:: ; 17f7 (0:17f7) ; PKMN
	push de
	ld de,Char4AText
	jr FinishDTE

Char59:: ; 17fb (0:17fb)
; depending on whose turn it is, print
; enemy active monster’s name, prefixed with “Enemy ”
; or
; player active monster’s name
; (like Char5A but flipped)
	ld a,[H_WHOSETURN]
	xor 1
	jr MonsterNameCharsCommon

Char5A:: ; 1803 (0:1803)
; depending on whose turn it is, print
; player active monster’s name
; or
; enemy active monster’s name, prefixed with “Enemy ”
	ld a,[H_WHOSETURN]
MonsterNameCharsCommon:: ; 1a37 (0:1a37)
	push de
	and a
	jr nz,.Enemy
	ld de,wBattleMonNick ; player active monster name
	jr FinishDTE

.Enemy
	; print “Enemy ”
	ld de,Char5AText
	call PlaceString
	ld h,b
	ld l,c
	ld de,wEnemyMonNick ; enemy active monster name

FinishDTE:: ; 1819 (0:1819)
	call PlaceString
	ld h,b
	ld l,c
	pop de
	inc de
	jp PlaceNextChar

Char5CText:: ; 1823 (0:1823)
	db "TM@"
Char5DText:: ; 1826 (0:1826)
	db "TRAINER@"
Char5BText:: ; 182e (0:182e)
	db "PC@"
Char5EText:: ; 1831 (0:1830)
	db "ROCKET@"
Char54Text:: ; 1838 (0:1838)
	db "POKé@"
Char56Text:: ; 183d (0:183d)
	db "……@"
Char5AText:: ; 1840 (0:1840)
	db "Enemy @"
Char4AText:: ; 1847 (0:1847)
	db $E1,$E2,"@" ; PKMN

Char55:: ; 184a (0:184a)
	push de
	ld b,h
	ld c,l
	ld hl,Char55Text
	call TextCommandProcessor ; 1919
	ld h,b
	ld l,c
	pop de
	inc de
	jp PlaceNextChar

Char55Text:: ; 185a (0:185a)
; equivalent to Char4B
	TX_FAR _Char55Text ; a0c73 (28:4c73)
	db "@"

Char5F:: ; 185f (0:185f)
; ends a Pokédex entry
	ld [hl],"."
	pop hl
	ret

Char58:: ; 1863 (0:1863)
	ld a,[wLinkState]
	cp LINK_STATE_BATTLING
	jp z,Next1870
	ld a,$EE
	Coorda 18, 16
Next1870:: ; 1870 (0:1870)
	call ProtectedDelay3 ; 1913
	call ManualTextScroll ; 388e
	ld a, " " ; space
	Coorda 18, 16
Char57:: ; 1aad (0:1aad)
	pop hl
	ld de,Char58Text
	dec de
	ret

Char58Text:: ; 1881 (0:1881)
	db "@"

Char51:: ; 1882 (0:1882)
	push de
	ld a,$EE
	Coorda 18, 16
	call ProtectedDelay3
	call ManualTextScroll
	coord hl, 1, 13
	lb bc, 4, 18
	call ClearScreenArea
	ld c,20
	call DelayFrames
	pop de
	coord hl, 1, 14
	jp PlaceNextChar_inc

Char49:: ; 18a3 (0:18a3)
	ld a,[hFlags_0xFFFA]
	bit 3,a
	jr z,.Char49
	ld a,$4e
	jp Char4ETest
	
.Char49
	push de
	ld a,$EE
	Coorda 18, 16
	call ProtectedDelay3
	call ManualTextScroll
	coord hl, 1, 10
	lb bc, 7, 18
	call ClearScreenArea
	ld c,20
	call DelayFrames
	pop de
	pop hl
	coord hl, 1, 11
	push hl
	jp PlaceNextChar_inc

Char4B:: ; 18d1 (0:18d1)
	ld a,$EE
	Coorda 18, 16
	call ProtectedDelay3
	push de
	call ManualTextScroll
	pop de
	ld a, " "
	Coorda 18, 16
	;fall through
Char4C:: ; 18e3 (0:18e3)
	push de
	call Next18F1 ; 18f1
	call Next18F1
	coord hl, 1, 16
	pop de
	jp PlaceNextChar_inc

Next18F1:: ; 18f1 (0:18f1)
	coord hl, 0, 14
	coord de, 0, 13
	ld b, 60
.next
	ld a,[hli]
	ld [de],a
	inc de
	dec b
	jr nz,.next
	coord hl, 1, 16
	ld a, " "
	ld b,SCREEN_WIDTH - 2
.next2
	ld [hli],a
	dec b
	jr nz,.next2

	; wait five frames
	ld b,5
.WaitFrame
	call DelayFrame
	dec b
	jr nz,.WaitFrame

	ret

ProtectedDelay3:: ; 1913 (0:1913)
	push bc
	call Delay3
	pop bc
	ret

TextCommandProcessor:: ; 1919 (0:1919)
	ld a,[wLetterPrintingDelayFlags]
	push af
	set 1,a
	ld e,a
	ld a,[$fff9]
	xor e
	ld [wLetterPrintingDelayFlags],a
	ld a,c
	ld [wUnusedCC3A],a
	ld a,b
	ld [wUnusedCC3B],a

NextTextCommand:: ; 192e (0:192e)
	ld a,[hli]
	cp a, "@" ; terminator
	jr nz,.doTextCommand
	pop af
	ld [wLetterPrintingDelayFlags],a
	ret
.doTextCommand
	push hl
	cp a,$17
	jp z,TextCommand17
	cp a,$0e
	jp nc,TextCommand0B ; if a != 0x17 and a >= 0xE, go to command 0xB
; if a < 0xE, use a jump table
	ld hl,TextCommandJumpTable
	push bc
	add a
	ld b,$00
	ld c,a
	add hl,bc
	pop bc
	ld a,[hli]
	ld h,[hl]
	ld l,a
	jp [hl]

; draw box
; 04AAAABBCC
; AAAA = address of upper left corner
; BB = height
; CC = width
TextCommand04:: ; 1951 (0:1951)
	pop hl
	ld a,[hli]
	ld e,a
	ld a,[hli]
	ld d,a
	ld a,[hli]
	ld b,a
	ld a,[hli]
	ld c,a
	push hl
	ld h,d
	ld l,e
	call TextBoxBorder
	pop hl
	jr NextTextCommand

; place string inline
; 00{string}
TextCommand00:: ; 1963 (0:1963)
	pop hl
	ld d,h
	ld e,l
	ld h,b
	ld l,c
	call PlaceString
	ld h,d
	ld l,e
	inc hl
	jr NextTextCommand

; place string from RAM
; 01AAAA
; AAAA = address of string
TextCommand01:: ; 1970 (0:1970)
	pop hl
	ld a,[hli]
	ld e,a
	ld a,[hli]
	ld d,a
	push hl
	ld h,b
	ld l,c
	call PlaceString
	pop hl
	jr NextTextCommand

; print BCD number
; 02AAAABB
; AAAA = address of BCD number
; BB
; bits 0-4 = length in bytes
; bits 5-7 = unknown flags
TextCommand02:: ; 197e (0:197e)
	pop hl
	ld a,[hli]
	ld e,a
	ld a,[hli]
	ld d,a
	ld a,[hli]
	push hl
	ld h,b
	ld l,c
	ld c,a
	call PrintBCDNumber
	ld b,h
	ld c,l
	pop hl
	jr NextTextCommand

; repoint destination address
; 03AAAA
; AAAA = new destination address
TextCommand03:: ; 1990 (0:1990)
	pop hl
	ld a,[hli]
	ld [wUnusedCC3A],a
	ld c,a
	ld a,[hli]
	ld [wUnusedCC3B],a
	ld b,a
	jp NextTextCommand

; repoint destination to second line of dialogue text box
; 05
; (no arguments)
TextCommand05:: ; 199e (0:199e)
	pop hl
	coord bc, 1, 16 ; address of second line of dialogue text box
	jp NextTextCommand

; blink arrow and wait for A or B to be pressed
; 06
; (no arguments)
TextCommand06:: ; 19a5 (0:19a5)
	ld a,[wLinkState]
	cp a,LINK_STATE_BATTLING
	jp z,TextCommand0D
	ld a,$ee ; down arrow
	Coorda 18, 16 ; place down arrow in lower right corner of dialogue text box
	push bc
	call ManualTextScroll ; blink arrow and wait for A or B to be pressed
	pop bc
	ld a," "
	Coorda 18, 16 ; overwrite down arrow with blank space
	pop hl
	jp NextTextCommand

; scroll text up one line
; 07
; (no arguments)
TextCommand07:: ; 19c0 (0:19c0)
	ld a," "
	Coorda 18, 16 ; place blank space in lower right corner of dialogue text box
	call Next18F1 ; scroll up text
	call Next18F1
	pop hl
	coord bc, 1, 16 ; address of second line of dialogue text box
	jp NextTextCommand

; execute asm inline
; 08{code}
TextCommand08:: ; 19d2 (0:19d2)
	pop hl
	ld de,NextTextCommand
	push de ; return address
	jp [hl]

; print decimal number (converted from binary number)
; 09AAAABB
; AAAA = address of number
; BB
; bits 0-3 = how many digits to display
; bits 4-7 = how long the number is in bytes
TextCommand09:: ; 19d8 (0:19d8)
	pop hl
	ld a,[hli]
	ld e,a
	ld a,[hli]
	ld d,a
	ld a,[hli]
	push hl
	ld h,b
	ld l,c
	ld b,a
	and a,$0f
	ld c,a
	ld a,b
	and a,$f0
	swap a
	set BIT_LEFT_ALIGN,a
	ld b,a
	call PrintNumber
	ld b,h
	ld c,l
	pop hl
	jp NextTextCommand

; wait half a second if the user doesn't hold A or B
; 0A
; (no arguments)
TextCommand0A:: ; 19f6 (0:19f6)
	push bc
	call Joypad
	ld a,[hJoyHeld]
	and a,A_BUTTON | B_BUTTON
	jr nz,.skipDelay
	ld c,30
	call DelayFrames
.skipDelay
	pop bc
	pop hl
	jp NextTextCommand

; plays sounds
; this actually handles various command ID's, not just 0B
; (no arguments)
TextCommand0B:: ; 1a0a (0:1a0a)
	pop hl
	push bc
	dec hl
	ld a,[hli]
	ld b,a ; b = command number that got us here
	push hl
	ld hl,TextCommandSounds
.loop
	ld a,[hli]
	cp b
	jr z,.matchFound
	inc hl
	jr .loop
.matchFound
	cp a,$14
	jr z,.pokemonCry
	cp a,$15
	jr z,.pokemonCry
	cp a,$16
	jr z,.pokemonCry
	ld a,[hl]
	call PlaySound
	call WaitForSoundToFinish
	pop hl
	pop bc
	jp NextTextCommand
.pokemonCry
	push de
	ld a,[hl]
	call PlayCry
	pop de
	pop hl
	pop bc
	jp NextTextCommand

; format: text command ID, sound ID or cry ID
TextCommandSounds:: ; 1a3d (0:1a3d)
	db $0B,$86 ; (SFX_02_3a - SFX_Headers_02) / 3
	db $12,$9A ; (SFX_08_46 - SFX_Headers_08) / 3
	db $0E,$91 ; (SFX_02_41 - SFX_Headers_02) / 3
	db $0F,$86 ; (SFX_02_3a - SFX_Headers_02) / 3
	db $10,$89 ; (SFX_02_3b - SFX_Headers_02) / 3
	db $11,$94 ; (SFX_02_42 - SFX_Headers_02) / 3
	db $13,$98 ; (SFX_08_45 - SFX_Headers_08) / 3
	db $14,PIKACHU ; used in OakSpeech
	db $15,PIDGEOT  ; used in SaffronCityText12
	db $16,DEWGONG  ; unused?

; draw ellipses
; 0CAA
; AA = number of ellipses to draw
TextCommand0C:: ; 1a51 (0:1a51)
	pop hl
	ld a,[hli]
	ld d,a
	push hl
	ld h,b
	ld l,c
.loop
	ld a,$75 ; ellipsis
	ld [hli],a
	push de
	call Joypad
	pop de
	ld a,[hJoyHeld] ; joypad state
	and a,A_BUTTON | B_BUTTON
	jr nz,.skipDelay ; if so, skip the delay
	ld c,10
	call DelayFrames
.skipDelay
	dec d
	jr nz,.loop
	ld b,h
	ld c,l
	pop hl
	jp NextTextCommand

; wait for A or B to be pressed
; 0D
; (no arguments)
TextCommand0D:: ; 1a73 (0:1a73)
	push bc
	call ManualTextScroll ; wait for A or B to be pressed
	pop bc
	pop hl
	jp NextTextCommand

; process text commands in another ROM bank
; 17AAAABB
; AAAA = address of text commands
; BB = bank
TextCommand17:: ; 1a7c (0:1a7c)
	pop hl
	ld a,[H_LOADEDROMBANK]
	push af
	ld a,[hli]
	ld e,a
	ld a,[hli]
	ld d,a
	ld a,[hli]
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	push hl
	ld l,e
	ld h,d
	call TextCommandProcessor
	pop hl
	pop af
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a
	jp NextTextCommand

TextCommandJumpTable:: ; 1a9a (0:1a9a)
	dw TextCommand00
	dw TextCommand01
	dw TextCommand02
	dw TextCommand03
	dw TextCommand04
	dw TextCommand05
	dw TextCommand06
	dw TextCommand07
	dw TextCommand08
	dw TextCommand09
	dw TextCommand0A
	dw TextCommand0B
	dw TextCommand0C
	dw TextCommand0D
