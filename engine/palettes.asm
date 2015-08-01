Func_71eb3: ; 71eb3 (1c:5eb3)
	call GetPredefRegisters
	ld a, b
	cp $ff
	jr nz, .asm_71ebe
	ld a, [wcf1c]
.asm_71ebe
	cp $fc
	jp z, Func_7218b
	ld l, a
	ld h, $0
	add hl, hl
	ld de, PointerTable_7206b
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, Func_72328
	push de
	jp [hl]

SendPalPacket_Black: ; 71ed3 (1c:5ed3)
	ld hl, PalPacket_Black
	ld de, BlkPacket_Battle
	ret

; uses PalPacket_Empty to build a packet based on mon IDs and health color
BuildBattlePalPacket: ; 71eda (1c:5eda)
	ld hl, PalPacket_Empty
	ld de, wcf2d
	ld bc, $10
	call CopyData
	;ld a, [W_PLAYERBATTSTATUS3]
	ld hl, wBattleMonSpecies
	ld a, [hl]
	and a
	jr z, .asm_71ef9
	ld hl, wPartyMon1
	ld a, [wPlayerMonNumber]
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
.asm_71ef9
	call DeterminePaletteID
	ld b, a
	;ld a, [W_ENEMYBATTSTATUS3]
	ld hl, wEnemyMonSpecies2
	call DeterminePaletteID
	ld c, a
	ld hl, wcf2e
	ld a, [wcf1d]
	add PAL_GREENBAR
	ld [hli], a
	inc hl
	ld a, [wcf1e]
	add PAL_GREENBAR
	ld [hli], a
	inc hl
	ld a, b
	ld [hli], a
	inc hl
	ld a, c
	ld [hl], a
	ld hl, wcf2d
	ld de, BlkPacket_Battle
	ld a, $1
	ld [wcf1c], a
	ret

SendPalPacket_TownMap: ; 71f26 (1c:5f26)
	ld hl, PalPacket_TownMap
	ld de, BlkPacket_WholeScreen
	ret

; uses PalPacket_Empty to build a packet based the mon ID
BuildStatusScreenPalPacket: ; 71f2d (1c:5f2d)
	ld hl, PalPacket_Empty
	ld de, wcf2d
	ld bc, $10
	call CopyData
	ld a, [wcf91]
	cp VICTREEBEL + 1
	jr c, .pokemon
	ld a, $1 ; not pokemon
.pokemon
	call DeterminePaletteIDOutOfBattle
	push af
	ld hl, wcf2e
	ld a, [wcf25]
	add $1f
	ld [hli], a
	inc hl
	pop af
	ld [hl], a
	ld hl, wcf2d
	ld de, BlkPacket_StatusScreen
	ret

SendPalPacket_PartyMenu: ; 71f59 (1c:5f59)
	ld hl, PalPacket_PartyMenu
	ld de, wcf2e
	ret

SendPalPacket_Pokedex: ; 71f60 (1c:5f60)
	ld hl, PalPacket_Pokedex
	ld de, wcf2d
	ld bc, $10
	call CopyData
	ld a, [wcf91]
	call DeterminePaletteIDOutOfBattle
	ld hl, wcf30
	ld [hl], a
	ld hl, wcf2d
	ld de, BlkPacket_Pokedex
	ret

SendPalPacket_Slots: ; 71f7d (1c:5f7d)
	ld hl, PalPacket_Slots
	ld de, BlkPacket_Slots
	ret

SendPalPacket_Titlescreen: ; 71f84 (1c:5f84)
	ld hl, PalPacket_Titlescreen
	ld de, BlkPacket_Titlescreen
	ret

; used mostly for menus and the Oak intro
SendPalPacket_Generic: ; 71f8b (1c:5f8b)
	ld hl, PalPacket_Generic
	ld de, BlkPacket_WholeScreen
	ret

SendPalPacket_NidorinoIntro: ; 71f92 (1c:5f92)
	ld hl, PalPacket_NidorinoIntro
	ld de, BlkPacket_NidorinoIntro
	ret

SendPalPacket_GameFreakIntro: ; 71f99 (1c:5f99)
	ld hl, PalPacket_GameFreakIntro
	ld de, BlkPacket_GameFreakIntro
	ld a, $8
	ld [wcf1c], a
	ret

; uses PalPacket_Empty to build a packet based on the current map
BuildOverworldPalPacket: ; 71fa5 (1c:5fa5)
	ld hl, PalPacket_Empty
	ld de, wcf2d
	ld bc, $10
	call CopyData
	ld a, [W_CURMAPTILESET]
	cp CEMETERY
	jr z, .PokemonTowerOrAgatha
	cp CAVERN
	jr z, .caveOrBruno
	ld a, [W_CURMAP]
	cp REDS_HOUSE_1F
	jr c, .townOrRoute
	cp UNKNOWN_DUNGEON_2
	jr c, .normalDungeonOrBuilding
	cp NAME_RATERS_HOUSE
	jr c, .caveOrBruno
	cp LORELEIS_ROOM
	jr z, .Lorelei
	cp BRUNOS_ROOM
	jr z, .caveOrBruno
	cp BATTLE_CENTER
	jr z,.asm_71ffd
	cp TRADE_CENTER
	jr z,.asm_71ffd
.normalDungeonOrBuilding
	ld a, [wLastMap] ; town or route that current dungeon or building is located
.townOrRoute
	cp SAFFRON_CITY + 1
	jr c, .town
	ld a, PAL_ROUTE - 1
.town
	inc a ; a town's pallete ID is its map ID + 1
	ld hl, wcf2e
	ld [hld], a
	ld de, BlkPacket_WholeScreen
	ld a, $9
	ld [wcf1c], a
	ret
.PokemonTowerOrAgatha
	ld a, PAL_GREYMON - 1
	jr .town
.caveOrBruno
	ld a, PAL_CAVE - 1
	jr .town
.Lorelei
	xor a
	jr .town
.asm_71ffd
	ld a,$18
	jr .town
	
; used when a Pokemon is the only thing on the screen
; such as evolution, trading and the Hall of Fame
SendPokemonPalette_WholeScreen: ; 72001 (1c:6001)
	push bc
	ld hl, PalPacket_Empty
	ld de, wcf2d
	ld bc, $10
	call CopyData
	pop bc
	ld a, c
	and a
	ld a, $1e
	jr nz, .asm_7201b
	ld a, [wcf1d]
	call DeterminePaletteIDOutOfBattle
.asm_7201b
	ld [wcf2e], a
	ld hl, wcf2d
	ld de, BlkPacket_WholeScreen
	ret

BuildTrainerCardPalPacket: ; 72025 (1c:6025)
	ld hl, BlkPacket_TrainerCard
	ld de, wcc5b
	ld bc, $40
	call CopyData
	ld de, LoopCounts_71f8f
	ld hl, wcc5d
	ld a, [W_OBTAINEDBADGES]
	ld c, $8
.asm_7203c
	srl a
	push af
	jr c, .asm_7204c
	push bc
	ld a, [de]
	ld c, a
	xor a
.asm_72045
	ld [hli], a
	dec c
	jr nz, .asm_72045
	pop bc
	jr .asm_72051
.asm_7204c
	ld a, [de]
.asm_7204d
	inc hl
	dec a
	jr nz, .asm_7204d
.asm_72051
	pop af
	inc de
	dec c
	jr nz, .asm_7203c
	ld hl, PalPacket_TrainerCard
	ld de, wcc5b
	ret

SendUnknownPalPacket_7205d:: ; 7205d (1c:605d)
	ld hl,UnknownPalPacket_72811
	ld de,UnknownPacket_72611
	ret
	
SendUnknownPalPacket_72064:: ; 72064 (1c:6064)
	ld hl,UnknownPalPacket_72821
	ld de,UnknownPacket_72751
	ret

PointerTable_7206b: ; 7206b (1c:606b)
	dw SendPalPacket_Black
	dw BuildBattlePalPacket
	dw SendPalPacket_TownMap
	dw BuildStatusScreenPalPacket
	dw SendPalPacket_Pokedex
	dw SendPalPacket_Slots
	dw SendPalPacket_Titlescreen
	dw SendPalPacket_NidorinoIntro
	dw SendPalPacket_Generic
	dw BuildOverworldPalPacket
	dw SendPalPacket_PartyMenu
	dw SendPokemonPalette_WholeScreen
	dw SendPalPacket_GameFreakIntro
	dw BuildTrainerCardPalPacket
	dw SendUnknownPalPacket_7205d
	dw SendUnknownPalPacket_72064

; each byte is the number of loops to make in .asm_71f5b for each badge
LoopCounts_7208b: ; 7208b (1c:608b)
	db $06,$06,$06,$12,$06,$06,$06,$06

;DeterminePaletteID: ; 71f97 (1c:5f97)
	;bit 3, a                 ; bit 3 of battle status 3, set if ;current Pokemon is transformed
	;ld a, PAL_GREYMON        ; if yes, use Ditto's palette
	;ret nz
DeterminePaletteID: ; 72093 (1c:6093)
	ld a, [hl]
DeterminePaletteIDOutOfBattle: ; 72094 (1c:6094)
	ld [wd11e], a
	and a
	jr z, .idZero
	push bc
	predef IndexToPokedex               ; turn Pokemon ID number into Pokedex number
	pop bc
	ld a, [wd11e]
.idZero
	ld e, a
	ld d, $00
	ld hl, MonsterPalettes   ; not just for Pokemon, Trainers use it too
	add hl, de
	ld a, [hl]
	ret

Func_720ad:: ; 720ad (1c:60ad)
	ld a,e
	and a
	jr nz,Func_720bd
	ld hl,Pointer_727e1
	ld a,[hGBC]
	and a
	jp z,Func_721b4
	jp Func_72346

Func_720bd:: ; 720bd (1c:60bd)
	ld hl,Func_72811
	ld a,[hGBC]
	and a
	jp z,Func_721b4
	call Func_72346
	ld hl,Pointer_727e1
	inc hl
	ld a,[hli]
	call Func_723fe
	ld a,e
	ld [wdee4],a
	ld a,d
	ld [wdee5],a
	xor a
	call Func_7240f
	ld a,$1
	call Func_72470
	ret
	
Func_720e3:: ; 720e3 (1c:60e3)
	ld hl,Pointer_72761
	ld de,wcf2d
	ld bc,$10
	call CopyData
	call Func_7213b
	ld hl,wcf2e
	ld [hl],a
	ld hl,wcf30
	ld a,$26
	ld [hl],a
	ld hl,wcf2d
	ld a,[hGBC]
	and a
	jr nz,.asm_72109
	call Func_721b4
	jr .asm_7210c
.asm_72109
	call Func_72346
.asm_7210c
	ld hl,UnknownPacket_72611
	ld de,wcf2d
	ld bc,$10
	call CopyData
	ld hl,wcf30
	ld a,$5
	ld [hli],a
	ld a,$7
	ld [hli],a
	ld a,$6
	ld [hli],a
	ld a,$b
	ld [hli],a
	ld a,$a
	ld [hl],a
	ld hl,wcf2d
	ld a,[hGBC]
	and a
	jr nz,.asm_72137
	call Func_721b4
	jr .asm_7213a
.asm_72137
	call Func_72346
.asm_7213a
	ret

Func_7213b:: ; 7213b (1c:613b)
; similar to BuildOverworldPalPacket
	ld a, [W_CURMAPTILESET]
	cp CEMETERY
	jr z, .PokemonTowerOrAgatha
	cp CAVERN
	jr z, .caveOrBruno
	ld a, [W_CURMAP]
	cp REDS_HOUSE_1F
	jr c, .townOrRoute
	cp UNKNOWN_DUNGEON_2
	jr c, .normalDungeonOrBuilding
	cp NAME_RATERS_HOUSE
	jr c, .caveOrBruno
	cp LORELEIS_ROOM
	jr z, .Lorelei
	cp BRUNOS_ROOM
	jr z, .caveOrBruno
	cp BATTLE_CENTER
	jr z,.battleOrTradeCenter
	cp TRADE_CENTER
	jr z,.battleOrTradeCenter
.normalDungeonOrBuilding
	ld a, [wLastMap] ; town or route that current dungeon or building is located
.townOrRoute
	cp SAFFRON_CITY + 1
	jr c, .town
	ld a, PAL_ROUTE - 1
.town
	inc a ; a town's pallete ID is its map ID + 1
	ret
.PokemonTowerOrAgatha
	ld a, PAL_GREYMON - 1
	jr .town
.caveOrBruno
	ld a, PAL_CAVE - 1
	jr .town
.Lorelei
	xor a
	jr .town
.battleOrTradeCenter
	ld a,$18
	jr .town

SendBlkPacket_PartyMenu: ; 7217f (1c:617f)
	ld hl, BlkPacket_PartyMenu ; $62f4
	ld de, wcf2e
	ld bc, $30
	jp CopyData

Func_71fc2: ; 7218b (1c:618b)
	ld hl, wcf1f
	ld a, [wcf2d]
	ld e, a
	ld d, $0
	add hl, de
	ld e, l
	ld d, h
	ld a, [de]
	and a
	ld e, $5
	jr z, .asm_721a4
	dec a
	ld e, $a
	jr z, .asm_721a4
	ld e, $f
.asm_721a4
	push de
	ld hl, wcf37
	ld bc, $6
	ld a, [wcf2d]
	call AddNTimes
	pop de
	ld [hl], e
	ret

Func_721b4: ; 721b4 (1c:61b4)
	ld a,$1
; load a non-zero value in $fff9 to disable the routine that checks actual
; joypad input (said routine, located at $15f, does nothing if $fff9 is not
; zero)
	ld [hReadJoypad],a
	call SendSGBPacket
	xor a
	ld [hReadJoypad],a
	ret
	
SendSGBPacket: ; 71feb (1c:5feb)
;check number of packets
	ld a,[hl]
	and a,$07
	ret z
; store number of packets in B
	ld b,a
.loop2
; save B for later use
	push bc
; send RESET signal (P14=LOW, P15=LOW)
	xor a
	ld [$ff00],a
; set P14=HIGH, P15=HIGH
	ld a,$30
	ld [$ff00],a
;load length of packets (16 bytes)
	ld b,$10
.nextByte
;set bit counter (8 bits per byte)
	ld e,$08
; get next byte in the packet
	ld a,[hli]
	ld d,a
.nextBit0
	bit 0,d
; if 0th bit is not zero set P14=HIGH,P15=LOW (send bit 1)
	ld a,$10
	jr nz,.next0
; else (if 0th bit is zero) set P14=LOW,P15=HIGH (send bit 0)
	ld a,$20
.next0
	ld [$ff00],a
; must set P14=HIGH,P15=HIGH between each "pulse"
	ld a,$30
	ld [$ff00],a
; rotation will put next bit in 0th position (so  we can always use command
; "bit 0,d" to fetch the bit that has to be sent)
	rr d
; decrease bit counter so we know when we have sent all 8 bits of current byte
	dec e
	jr nz,.nextBit0
	dec b
	jr nz,.nextByte
; send bit 1 as a "stop bit" (end of parameter data)
	ld a,$20
	ld [$ff00],a
; set P14=HIGH,P15=HIGH
	ld a,$30
	ld [$ff00],a
	call Wait7000	
;	xor a
;	ld [$fff9],a
; wait for about 70000 cycles
;	call Wait7000
; restore (previously pushed) number of packets
	pop bc
	dec b
; return if there are no more packets
	ret z
; else send 16 more bytes
	jr .loop2

LoadSGB: ; 721f8 (1c:61f8)
	xor a
	ld [wOnSGB], a
	call CheckSGB
	jr c, .onSGB
	ld a, [hGBC]
	and a
	jr z, .onDMG
	ld a, $1
	ld [wOnSGB], a
.onDMG
	ret
.onSGB
	di
	call Func_72247
	ei
	ld a, $1
	ld [wcf2d], a
	ld de, ChrTrnPacket
	ld hl, SGBBorderGraphics
	call Func_722d7
	xor a
	ld [wcf2d], a
	ld de, PctTrnPacket
	ld hl, BorderPalettes
	call Func_722d7
	xor a
	ld [wcf2d], a
	ld de, PalTrnPacket
	ld hl, SuperPalettes
	call Func_722d7
	call ClearVram
	ld hl, MaskEnCancelPacket
	jp SendSGBPacket

Func_72247: ; 72247 (1c:6247)
	ld hl, PointerTable_72089
	ld c, $9
.loop
	push bc
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	call SendSGBPacket
	pop hl
	inc hl
	pop bc
	dec c
	jr nz, .loop
	ret

PointerTable_7225b: ; 7225b (1c:625b)
	dw MaskEnFreezePacket
	dw DataSnd_72548
	dw DataSnd_72558
	dw DataSnd_72568
	dw DataSnd_72578
	dw DataSnd_72588
	dw DataSnd_72598
	dw DataSnd_725a8
	dw DataSnd_725b8

CheckSGB: ; 7226d (1c:626d)
	ld hl, MltReq2Packet
	call Func_721b4
	call Wait7000
	ld a, [rJOYP] ; $ff0
	and $3
	cp $3
	jr nz, .asm_722c9
	ld a, $20
	ld [rJOYP], a ; $ff0
	ld a, [rJOYP] ; $ff0
	ld a, [rJOYP] ; $ff0
	call Wait7000
	call Wait7000
	ld a, $30
	ld [rJOYP], a ; $ff0
	call Wait7000
	call Wait7000
	ld a, $10
	ld [rJOYP], a ; $ff0
	ld a, [rJOYP] ; $ff0
	ld a, [rJOYP] ; $ff0
	ld a, [rJOYP] ; $ff0
	ld a, [rJOYP] ; $ff0
	ld a, [rJOYP] ; $ff0
	ld a, [rJOYP] ; $ff0
	call Wait7000
	call Wait7000
	ld a, $30
	ld [rJOYP], a ; $ff0
	ld a, [rJOYP] ; $ff0
	ld a, [rJOYP] ; $ff0
	ld a, [rJOYP] ; $ff0
	call Wait7000
	call Wait7000
	ld a, [rJOYP] ; $ff0
	and $3
	cp $3
	jr nz, .asm_722c9
	call Func_722ce
	and a
	ret
.asm_722c9
	call Func_722ce
	scf
	ret

Func_722ce: ; 722ce (1c:62ce)
	ld hl, MltReq1Packet
	call SendSGBPacket
	jp Wait7000

Func_722d7: ; 722d7 (1c:62d7)
	di
	push de
	call DisableLCD
	ld a, $e4
	ld [rBGP], a ; $ff47
	call Func_72520
	ld de, vChars1
	ld a, [wcf2d]
	and a
	jr z, .asm_722f1
	call Func_725fb
	jr .asm_722f7
.asm_722f1
	ld bc, $1000
	call CopyData
.asm_722f7
	ld hl, vBGMap0
	ld de, $c
	ld a, $80
	ld c, $d
.asm_72301
	ld b, $14
.asm_72303
	ld [hli], a
	inc a
	dec b
	jr nz, .asm_72303
	add hl, de
	dec c
	jr nz, .asm_72301
	ld a, $e3
	ld [rLCDC], a ; $ff40
	pop hl
	call SendSGBPacket
	xor a
	ld [rBGP], a ; $ff47
	call Func_72520
	ei
	ret

Wait7000: ; 7231c (1c:631c)
; Each loop takes 9 cycles so this routine actually waits 63000 cycles.
	ld de, 7000
.loop
	nop
	nop
	nop
	dec de
	ld a, d
	or e
	jr nz, .loop
	ret

Func_72328: ; 72328 (1c:6328)
	ld a, [hGBC]
	and a
	jr z, .asm_7233e
	push de
	call Func_72346
	pop hl
	call Func_72346
	ld a,[rLCDC]
	and rLCDC_ENABLE_MASK
	ret z
	call Delay3
	ret
.asm_7233e
	push de
	call SendSGBPacket
	pop hl
	jp SendSGBPacket

Func_72346: ; 72346 (1c:6346)
	ld a,[hl]
	and $f8
	cp $20
	jp z,Func_7265e
	inc hl
	ld a,[hli]
	inc hl
	push hl
	call Func_723fe
	ld a,e
	ld [wdee2],a
	ld a,d
	ld [wdee3],a
	
	xor a
	call Func_7240f
	ld a,$0
	call Func_72470
	ld a,$1
	call Func_7240f
	ld a,$0
	call Func_724df
	ld a,$2
	call Func_7240f
	ld a,$4
	call Func_724df
	
	pop hl
	ld a,[hli]
	inc hl
	push hl
	call Func_723fe
	ld a,e
	ld [wdee4],a
	ld a,d
	ld [wdee5],a
	
	xor a
	call Func_7240f
	ld a,$1
	call Func_72470
	ld a,$1
	call Func_7240f
	ld a,$1
	call Func_724df
	ld a,$2
	call Func_7240f
	ld a,$5
	call Func_7240f
	
	pop hl
	ld a,[hli]
	inc hl
	push hl
	call Func_723fe
	ld a,e
	ld [wdee6],a
	ld a,d
	ld [wdee7],a
	
	xor a
	call Func_7240f
	ld a,$2
	call Func_72470
	ld a,$1
	call Func_7240f
	ld a,$2
	call Func_724df
	ld a,$2
	call Func_7240f
	ld a,$6
	call Func_724df
	
	pop hl
	ld a,[hli]
	inc hl
	call Func_723fe
	ld a,e
	ld [wdee8],a
	ld a,d
	ld [wdee9],a
	
	xor a
	call Func_7240f
	ld a,$3
	call Func_72470
	ld a,$1
	call Func_7240f
	ld a,$3
	call Func_724df
	ld a,$2
	call Func_7240f
	ld a,$7
	call Func_724df
	
	ret
	
Func_723fe:: ; 723fe (1c:63fe)
	push hl
	ld l,a
	xor a
	ld h,a
	add hl,hl
	add hl,hl
	add hl,hl
	ld de,SuperPalettes ; not exactly sure if actually super palettes
	add hl,de
	ld a,l
	ld e,a
	ld a,h
	ld d,a
	pop hl
	ret
	
Func_7240f:: ; 7240f (1c:640f)
	and a
	jr nz,.asm_72419
	ld a,[rBGP]
	ld [wdef2],a
	jr .asm_72428
.asm_72419
	dec a
	jr nz,.asm_72423
	ld a,[rOBP0]
	ld [wdef3],a
	jr .asm_72428
.asm_72423
	ld a,[rOBP1]
	ld [wdef4],a
.asm_72428
	ld b,a
	and $3
	call Func_7246a
	ld a,[hli]
	ld [wdeea],a
	ld a,[hl]
	ld [wdeeb],a
	ld a,b
	rrca
	rrca
	ld b,a
	and $3
	call Func_7246a
	ld a,[hli]
	ld [wdeec],a
	ld a,[hl]
	ld [wdeed],a
	ld a,b
	rrca
	rrca
	ld b,a
	and $3
	call Func_7246a
	ld a,[hli]
	ld [wdeee],a
	ld a,[hl]
	ld [wdeef],a
	ld a,b
	rrca
	rrca
	ld b,a
	and $3
	call Func_7246a
	ld a,[hli]
	ld [wdef0],a
	ld a,[hl]
	ld [wdef1],a
	ret
	
Func_7246a:: ; 7246a (1c:646a)
	add a
	ld l,a
	xor a
	ld h,a
	add hl,de
	ret
	
Func_72470:: ; 72470 (1c:6470)
	push de
	add a
	add a
	add a
	or $80
	ld [rBGPI],a
	ld de,rBGPD
	ld hl,wdeea
	ld b,$2
	ld a,[rLCDC]
	and rLCDC_ENABLE_MASK
	jr nz,.lcdenabled
	rept 4
	call Func_7251b
	endr
	jr .done
.lcdenabled
	rept 4
	call Func_72511
	endr
.done
	pop de
	ret

Func_724a2:: ; 724a2 (1c:64a2)
	push de
	add a
	add a
	add a
	ld l,a
	xor a
	ld h,a
	ld de,wdef6
	add hl,de
	ld de,wdee9
	ld c,$8
.loop
	ld a,[de]
	ld [hli],a
	inc de
	dec c
	jr nz,.loop
	pop de
	ret

PreparePalDataTransfer:: ; 724ba (1c:64ba)
; wait for vblank period unless LCD is disabled
	ld a,[rLCDC]
	and rLCDC_ENABLE_MASK
	jr z,.lcddisabled
	di
.waitloop
	ld a,[rLY]
	cp 144
	jr c,.waitloop
.lcddisabled
	call TransferPalData
	ei
	ret

TransferPalData: ; 724cc (1c:64cc)
	xor a
	or $80
	ld [rBGPI], a
	ld de,rBGPD
	ld hl,wdef6
	ld c,$20
.loop
	ld a,[hli]
	ld [de],a
	dec c
	jr nz,.loop
	ret
	
Func_724df: ; 724df (1c:64df)
	push de
	add a
	add a
	add a
	or $80
	ld [rOBPI],a
	ld de,rOBPD
	ld hl,wdeea
	ld b,$2 ; searching oam STAT mode
	ld a,[rLCDC]
	and rLCDC_ENABLE_MASK
	jr nz,.lcdenabled
	rept 4
	call Func_7251b
	endr
	jr .done
.lcdenabled
	rept 4
	call Func_72511
	endr
.done
	pop de
	ret
	
Func_72511: ; 72511 (1c:6511)
	ld a,[rSTAT]
	and b
	jr z,Func_72511 ; wait if either in hblank or vblank period
.notinhblank
	ld a,[rSTAT]
	and b
	jr nz,.notinhblank ; wait if transferring oam or data to lcd driver
Func_7251b: ; 7251b (1c:651b)
	ld a,[hli]
	ld [de],a
	ld a,[hli]
	ld [de],a
	ret

Func_72520:: ; 72520 (1c:6520)
	ld a,[hGBC]
	and a
	ret z
; fallthrough
Func_72524:: ; 72524 (1c:6524)
	ld a,[wdee2]
	ld e,a
	ld a,[wdee3]
	ld d,a
	xor a
	call Func_7240f
	ld a,$0
	call Func_724a2
	ld a,[wdee4]
	ld e,a
	ld a,[wdee5]
	ld d,a
	xor a
	call Func_7240f
	ld a,$1
	call Func_724a2
	ld a,[wdee5]
	ld e,a
	ld a,[wdee6]
	ld d,a
	xor a
	call Func_7240f
	ld a,$2
	call Func_724a2
	ld a,[wdee8]
	ld e,a
	ld a,[wdee9]
	ld d,a
	xor a
	call Func_7240f
	ld a,$3
	call Func_724a2
	call PreparePalDataTransfer
	ret
	
Func_7265c:: ; 7265c (1c:656c)
	ld a,[wdee2]
	ld e,a
	ld a,[wdee3]
	ld d,a
	ld a,c
	call Func_7240f
	ld a,c
	dec a
	rlca
	rlca
	call Func_724df
	ld a,[wdee4]
	ld e,a
	ld a,[wdee5]
	ld d,a
	ld a,c
	call Func_7240f
	ld a,c
	dec a
	rlca
	rlca
	inc a
	call Func_724df
	ld a,[wdee6]
	ld e,a
	ld a,[wdee7]
	ld d,a
	ld a,c
	call Func_7240f
	ld a,c
	dec a
	rlca
	rlca
	add $2
	call Func_724df
	ld a,[wdee8]
	ld e,a
	ld a,[wdee9]
	ld d,a
	ld a,c
	call Func_7240f
	ld a,c
	dec a
	rlca
	rlca
	add $3
	call Func_724df
	ret
	
Func_725be:: ; 725be (1c:65be)
	push hl
	pop de
	ld hl,Pointer_725e2
	ld a,[hli]
	ld c,a
.asm_725c5
	ld a,e
.loop
	cp [hl]
	jr z,.asm_725cf
	inc hl
	inc hl
	dec c
	jr nz,.loop
	ret
.asm_725cf
	inc hl
	ld a,d
	cp [hl]
	jr z,.asm_725d9
	inc hl
	dec c
	jr nz,.asm_725c5
	ret
.asm_725d9
	callba Func_bf450 ; 2f:7250
	ret
	
INCBIN "baserom.gbc",$725e2,$734b9 - $725e2
;INCLUDE "data/sgb_packets.asm"

;INCLUDE "data/mon_palettes.asm"

;INCLUDE "data/super_palettes.asm"

;INCLUDE "data/sgb_border.asm"