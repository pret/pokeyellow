_RunPaletteCommand: ; 71ddf (1c:5ddf)
	call GetPredefRegisters
	ld a, b
	cp $ff
	jr nz, .next
	ld a, [wDefaultPaletteCommand] ; use default command if command ID is $ff
.next
	cp UPDATE_PARTY_MENU_BLK_PACKET
	jp z, UpdatePartyMenuBlkPacket
	ld l, a
	ld h, 0
	add hl, hl
	ld de, SetPalFunctions
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, SendSGBPackets
	push de
	jp [hl]

SetPal_Black: ; 71ed3 (1c:5ed3)
	ld hl, PalPacket_Black
	ld de, BlkPacket_Battle
	ret

; uses PalPacket_Empty to build a packet based on mon IDs and health color
SetPal_Battle: ; 71eda (1c:5eda)
	ld hl, PalPacket_Empty
	ld de, wPalPacket
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
	ld hl, wPalPacket + 1
	ld a, [wPlayerHPBarColor]
	add PAL_GREENBAR
	ld [hli], a
	inc hl
	ld a, [wEnemyHPBarColor]
	add PAL_GREENBAR
	ld [hli], a
	inc hl
	ld a, b
	ld [hli], a
	inc hl
	ld a, c
	ld [hl], a
	ld hl, wPalPacket
	ld de, BlkPacket_Battle
	ld a, SET_PAL_BATTLE
	ld [wDefaultPaletteCommand], a
	ret

SetPal_TownMap: ; 71f26 (1c:5f26)
	ld hl, PalPacket_TownMap
	ld de, BlkPacket_WholeScreen
	ret

; uses PalPacket_Empty to build a packet based the mon ID
SetPal_StatusScreen: ; 71f2d (1c:5f2d)
	ld hl, PalPacket_Empty
	ld de, wPalPacket
	ld bc, $10
	call CopyData
	ld a, [wcf91]
	cp VICTREEBEL + 1
	jr c, .pokemon
	ld a, $1 ; not pokemon
.pokemon
	call DeterminePaletteIDOutOfBattle
	push af
	ld hl, wPalPacket + 1
	ld a, [wStatusScreenHPBarColor]
	add PAL_GREENBAR
	ld [hli], a
	inc hl
	pop af
	ld [hl], a
	ld hl, wPalPacket
	ld de, BlkPacket_StatusScreen
	ret

SetPal_PartyMenu: ; 71f59 (1c:5f59)
	ld hl, PalPacket_PartyMenu
	ld de, wPartyMenuBlkPacket
	ret

SetPal_Pokedex: ; 71f60 (1c:5f60)
	ld hl, PalPacket_Pokedex
	ld de, wPalPacket
	ld bc, $10
	call CopyData
	ld a, [wcf91]
	call DeterminePaletteIDOutOfBattle
	ld hl, wPalPacket + 3
	ld [hl], a
	ld hl, wPalPacket
	ld de, BlkPacket_Pokedex
	ret

SetPal_Slots: ; 71f7d (1c:5f7d)
	ld hl, PalPacket_Slots
	ld de, BlkPacket_Slots
	ret

SetPal_Titlescreen: ; 71f84 (1c:5f84)
	ld hl, PalPacket_Titlescreen
	ld de, BlkPacket_Titlescreen
	ret

; used mostly for menus and the Oak intro
SetPal_Generic: ; 71f8b (1c:5f8b)
	ld hl, PalPacket_Generic
	ld de, BlkPacket_WholeScreen
	ret

SetPal_NidorinoIntro: ; 71f92 (1c:5f92)
	ld hl, PalPacket_NidorinoIntro
	ld de, BlkPacket_NidorinoIntro
	ret

SetPal_GameFreakIntro: ; 71f99 (1c:5f99)
	ld hl, PalPacket_GameFreakIntro
	ld de, BlkPacket_GameFreakIntro
	ld a, SET_PAL_GENERIC
	ld [wDefaultPaletteCommand], a
	ret

; uses PalPacket_Empty to build a packet based on the current map
SetPal_Overworld: ; 71fa5 (1c:5fa5)
	ld hl, PalPacket_Empty
	ld de, wPalPacket
	ld bc, $10
	call CopyData
	ld a, [wCurMapTileset]
	cp CEMETERY
	jr z, .PokemonTowerOrAgatha
	cp CAVERN
	jr z, .caveOrBruno
	ld a, [wCurMap]
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
	cp TRADE_CENTER
	jr z,.asm_71ffd
	cp COLOSSEUM
	jr z,.asm_71ffd
.normalDungeonOrBuilding
	ld a, [wLastMap] ; town or route that current dungeon or building is located
.townOrRoute
	cp SAFFRON_CITY + 1
	jr c, .town
	ld a, PAL_ROUTE - 1
.town
	inc a ; a town's palette ID is its map ID + 1
	ld hl, wPalPacket + 1
	ld [hld], a
	ld de, BlkPacket_WholeScreen
	ld a, SET_PAL_OVERWORLD
	ld [wDefaultPaletteCommand], a
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
SetPal_PokemonWholeScreen: ; 72001 (1c:6001)
	push bc
	ld hl, PalPacket_Empty
	ld de, wPalPacket
	ld bc, $10
	call CopyData
	pop bc
	ld a, c
	and a
	ld a, PAL_BLACK
	jr nz, .next
	ld a, [wWholeScreenPaletteMonSpecies]
	call DeterminePaletteIDOutOfBattle
.next
	ld [wPalPacket + 1], a
	ld hl, wPalPacket
	ld de, BlkPacket_WholeScreen
	ret

SetPal_TrainerCard: ; 72025 (1c:6025)
	ld hl, BlkPacket_TrainerCard
	ld de, wTrainerCardBlkPacket
	ld bc, $40
	call CopyData
	ld de, BadgeBlkDataLengths
	ld hl, wTrainerCardBlkPacket + 2
	ld a, [wObtainedBadges]
	ld c, 8
.badgeLoop
	srl a
	push af
	jr c, .haveBadge
; The player doens't have the badge, so zero the badge's blk data.
	push bc
	ld a, [de]
	ld c, a
	xor a
.zeroBadgeDataLoop
	ld [hli], a
	dec c
	jr nz, .zeroBadgeDataLoop
	pop bc
	jr .nextBadge
.haveBadge
; The player does have the badge, so skip past the badge's blk data.
	ld a, [de]
.skipBadgeDataLoop
	inc hl
	dec a
	jr nz, .skipBadgeDataLoop
.nextBadge
	pop af
	inc de
	dec c
	jr nz, .badgeLoop
	ld hl, PalPacket_TrainerCard
	ld de, wTrainerCardBlkPacket
	ret

SendUnknownPalPacket_7205d:: ; 7205d (1c:605d)
	ld hl,UnknownPalPacket_72811
	ld de,BlkPacket_WholeScreen
	ret
	
SendUnknownPalPacket_72064:: ; 72064 (1c:6064)
	ld hl,UnknownPalPacket_72821
	ld de,UnknownPacket_72751
	ret

SetPalFunctions: ; 7206b (1c:606b)
	dw SetPal_Black
	dw SetPal_Battle
	dw SetPal_TownMap
	dw SetPal_StatusScreen
	dw SetPal_Pokedex
	dw SetPal_Slots
	dw SetPal_Titlescreen
	dw SetPal_NidorinoIntro
	dw SetPal_Generic
	dw SetPal_Overworld
	dw SetPal_PartyMenu
	dw SetPal_PokemonWholeScreen
	dw SetPal_GameFreakIntro
	dw SetPal_TrainerCard
	dw SendUnknownPalPacket_7205d
	dw SendUnknownPalPacket_72064

; The length of the blk data of each badge on the Trainer Card.
; The Rainbow Badge has 3 entries because of its many colors.
BadgeBlkDataLengths: ; 7208b (1c:608b)
	db 6     ; Boulder Badge
	db 6     ; Cascade Badge
	db 6     ; Thunder Badge
	db 6 * 3 ; Rainbow Badge
	db 6     ; Soul Badge
	db 6     ; Marsh Badge
	db 6     ; Volcano Badge
	db 6     ; Earth Badge

DeterminePaletteID: ; 72093 (1c:6093)
	ld a, [hl]
DeterminePaletteIDOutOfBattle: ; 72094 (1c:6094)
	ld [wd11e], a
	and a ; is the mon index 0?
	jr z, .skipDexNumConversion
	push bc
	predef IndexToPokedex
	pop bc
	ld a, [wd11e]
.skipDexNumConversion
	ld e, a
	ld d, 0
	ld hl, MonsterPalettes ; not just for Pokemon, Trainers use it too
	add hl, de
	ld a, [hl]
	ret

Func_720ad:: ; 720ad (1c:60ad)
	ld a,e
	and a
	jr nz,Func_720bd
	ld hl,PalPacket_Generic
	ld a,[hGBC]
	and a
	jp z,Func_721b4
	jp InitGBCPalettes

Func_720bd:: ; 720bd (1c:60bd)
	ld hl,UnknownPalPacket_72811
	ld a,[hGBC]
	and a
	jp z,Func_721b4
	call InitGBCPalettes
	ld hl,PalPacket_Generic
	inc hl
	ld a,[hli]
	call Func_723fe
	ld a,e
	ld [wPalDataPointer2],a
	ld a,d
	ld [wPalDataPointer2+1],a
	xor a
	call UpdatePalData
	ld a,$1
	call TransferCurBGPData
	ret
	
Func_720e3:: ; 720e3 (1c:60e3)
	ld hl,PalPacket_Empty
	ld de,wPalPacket
	ld bc,$10
	call CopyData
	call Func_7213b
	ld hl,wPartyMenuBlkPacket
	ld [hl],a
	ld hl,wPartyMenuBlkPacket + 2
	ld a,$26
	ld [hl],a
	ld hl,wPalPacket
	ld a,[hGBC]
	and a
	jr nz,.asm_72109
	call Func_721b4
	jr .asm_7210c
.asm_72109
	call InitGBCPalettes
.asm_7210c
	ld hl,BlkPacket_WholeScreen
	ld de,wPalPacket
	ld bc,$10
	call CopyData
	ld hl,wPartyMenuBlkPacket + 2
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
	ld hl,wPalPacket
	ld a,[hGBC]
	and a
	jr nz,.asm_72137
	call Func_721b4
	jr .asm_7213a
.asm_72137
	call InitGBCPalettes
.asm_7213a
	ret

Func_7213b:: ; 7213b (1c:613b)
; similar to SetPal_Overworld
	ld a, [wCurMapTileset]
	cp CEMETERY
	jr z, .PokemonTowerOrAgatha
	cp CAVERN
	jr z, .caveOrBruno
	ld a, [wCurMap]
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
	cp TRADE_CENTER
	jr z,.battleOrTradeCenter
	cp COLOSSEUM
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

InitPartyMenuBlkPacket: ; 7217f (1c:617f)
	ld hl, BlkPacket_PartyMenu
	ld de, wPartyMenuBlkPacket
	ld bc, $30
	jp CopyData

UpdatePartyMenuBlkPacket: ; 7218b (1c:618b)
; Update the blk packet with the palette of the HP bar that is
; specified in [wWhichPartyMenuHPBar].
	ld hl, wPartyMenuHPBarColors
	ld a, [wWhichPartyMenuHPBar]
	ld e, a
	ld d, 0
	add hl, de
	ld e, l
	ld d, h
	ld a, [de]
	and a
	ld e, (1 << 2) | 1 ; green
	jr z, .next
	dec a
	ld e, (2 << 2) | 2 ; yellow
	jr z, .next
	ld e, (3 << 2) | 3 ; red
.next
	push de
	ld hl, wPartyMenuBlkPacket + 8 + 1
	ld bc, 6
	ld a, [wWhichPartyMenuHPBar]
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
	ld [rJOYP],a
; set P14=HIGH, P15=HIGH
	ld a,$30
	ld [rJOYP],a
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
	ld [rJOYP],a
; must set P14=HIGH,P15=HIGH between each "pulse"
	ld a,$30
	ld [rJOYP],a
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
	ld [rJOYP],a
; set P14=HIGH,P15=HIGH
	ld a,$30
	ld [rJOYP],a
	call Wait7000	
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
	ld a, $1
	ld [wOnSGB], a
	di
	call PrepareSuperNintendoVRAMTransfer
	ei
	ld a, 1
	ld [wCopyingSGBTileData], a
	ld de, ChrTrnPacket
	ld hl, SGBBorderGraphics
	call CopyGfxToSuperNintendoVRAM
	xor a
	ld [wCopyingSGBTileData], a
	ld de, PctTrnPacket
	ld hl, BorderPalettes
	call CopyGfxToSuperNintendoVRAM
	xor a
	ld [wCopyingSGBTileData], a
	ld de, PalTrnPacket
	ld hl, SuperPalettes
	call CopyGfxToSuperNintendoVRAM
	call ClearVram
	ld hl, MaskEnCancelPacket
	jp Func_721b4

PrepareSuperNintendoVRAMTransfer: ; 72247 (1c:6247)
	ld hl, .packetPointers
	ld c, 9
.loop
	push bc
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	call Func_721b4
	pop hl
	inc hl
	pop bc
	dec c
	jr nz, .loop
	ret

.packetPointers ; 7225b (1c:625b)
; Only the first packet is needed.
	dw MaskEnFreezePacket
	dw DataSnd_728a1
	dw DataSnd_728b1
	dw DataSnd_728c1
	dw DataSnd_728d1
	dw DataSnd_728e1
	dw DataSnd_728f1
	dw DataSnd_72901
	dw DataSnd_72911

CheckSGB: ; 7226d (1c:626d)
	ld hl, MltReq2Packet
	call Func_721b4
	call Wait7000
	ld a, [rJOYP]
	and $3
	cp $3
	jr nz, .isSGB
	ld a, $20
	ld [rJOYP], a
	ld a, [rJOYP]
	ld a, [rJOYP]
	call Wait7000
	call Wait7000
	ld a, $30
	ld [rJOYP], a
	call Wait7000
	call Wait7000
	ld a, $10
	ld [rJOYP], a
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	call Wait7000
	call Wait7000
	ld a, $30
	ld [rJOYP], a
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	call Wait7000
	call Wait7000
	ld a, [rJOYP]
	and $3
	cp $3
	jr nz, .isSGB
	call SendMltReq1Packet
	and a
	ret
.isSGB
	call SendMltReq1Packet
	scf
	ret

SendMltReq1Packet: ; 722ce (1c:62ce)
	ld hl, MltReq1Packet
	call Func_721b4
	jp Wait7000

CopyGfxToSuperNintendoVRAM: ; 722d7 (1c:62d7)
	di
	push de
	call DisableLCD
	ld a, $e4
	ld [rBGP], a ; $ff47
	call _UpdateGBCPal_BGP_CheckDMG
	ld de, vChars1
	ld a, [wCopyingSGBTileData]
	and a
	jr z, .notCopyingTileData
	call CopySGBBorderTiles
	jr .next
.notCopyingTileData
	ld bc, $1000
	call CopyData
.next
	ld hl, vBGMap0
	ld de, $c
	ld a, $80
	ld c, $d
.loop
	ld b, $14
.innerLoop
	ld [hli], a
	inc a
	dec b
	jr nz, .innerLoop
	add hl, de
	dec c
	jr nz, .loop
	ld a, $e3
	ld [rLCDC], a
	pop hl
	call Func_721b4
	xor a
	ld [rBGP], a ; $ff47
	call _UpdateGBCPal_BGP_CheckDMG
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

SendSGBPackets: ; 72328 (1c:6328)
	ld a, [hGBC]
	and a
	jr z, .notGBC
	push de
	call InitGBCPalettes
	pop hl
	call InitGBCPalettes
	ld a,[rLCDC]
	and rLCDC_ENABLE_MASK
	ret z
	call Delay3
	ret
.notGBC
	push de
	call Func_721b4
	pop hl
	jp Func_721b4

InitGBCPalettes: ; 72346 (1c:6346)
	ld a,[hl]
	and $f8
	cp $20
	jp z,Func_725be
	inc hl
	ld a,[hli]
	inc hl
	push hl
	call Func_723fe
	ld a,e
	ld [wPalDataPointer1],a
	ld a,d
	ld [wPalDataPointer1+1],a
	
	xor a
	call UpdatePalData
	ld a,$0
	call TransferCurBGPData
	ld a,$1
	call UpdatePalData
	ld a,$0
	call TransferCurOBPData
	ld a,$2
	call UpdatePalData
	ld a,$4
	call TransferCurOBPData
	
	pop hl
	ld a,[hli]
	inc hl
	push hl
	call Func_723fe
	ld a,e
	ld [wPalDataPointer2],a
	ld a,d
	ld [wPalDataPointer2+1],a
	
	xor a
	call UpdatePalData
	ld a,$1
	call TransferCurBGPData
	ld a,$1
	call UpdatePalData
	ld a,$1
	call TransferCurOBPData
	ld a,$2
	call UpdatePalData
	ld a,$5
	call TransferCurOBPData
	
	pop hl
	ld a,[hli]
	inc hl
	push hl
	call Func_723fe
	ld a,e
	ld [wPalDataPointer3],a
	ld a,d
	ld [wPalDataPointer3+1],a
	
	xor a
	call UpdatePalData
	ld a,$2
	call TransferCurBGPData
	ld a,$1
	call UpdatePalData
	ld a,$2
	call TransferCurOBPData
	ld a,$2
	call UpdatePalData
	ld a,$6
	call TransferCurOBPData
	
	pop hl
	ld a,[hli]
	inc hl
	call Func_723fe
	ld a,e
	ld [wPalDataPointer4],a
	ld a,d
	ld [wPalDataPointer4+1],a
	
	xor a
	call UpdatePalData
	ld a,$3
	call TransferCurBGPData
	ld a,$1
	call UpdatePalData
	ld a,$3
	call TransferCurOBPData
	ld a,$2
	call UpdatePalData
	ld a,$7
	call TransferCurOBPData
	
	ret
	
Func_723fe:: ; 723fe (1c:63fe)
	push hl
	ld l,a
	xor a
	ld h,a
	add hl,hl
	add hl,hl
	add hl,hl
	ld de,Pointer_72af9 ; not exactly sure if actually super palettes
	add hl,de
	ld a,l
	ld e,a
	ld a,h
	ld d,a
	pop hl
	ret
	
UpdatePalData:: ; 7240f (1c:640f)
	and a
	jr nz,.notBGP
	ld a,[rBGP]
	ld [wLastBGP],a
	jr .continue
.notBGP
	dec a
	jr nz,.notOBP0
	ld a,[rOBP0]
	ld [wLastOBP0],a
	jr .continue
.notOBP0
	ld a,[rOBP1]
	ld [wLastOBP1],a
.continue
	ld b,a ; save current GBP shade
	and $3 ; get first shade
	call GetPaletteShade
	ld a,[hli] ; store in palette buffer
	ld [wPalDataBuffer1],a
	ld a,[hl]
	ld [wPalDataBuffer1+1],a
	ld a,b ; get second shade
	rrca
	rrca
	ld b,a
	and $3
	call GetPaletteShade
	ld a,[hli] ; store in second buffer
	ld [wPalDataBuffer2],a
	ld a,[hl]
	ld [wPalDataBuffer2+1],a
	ld a,b
	rrca
	rrca
	ld b,a
	and $3
	call GetPaletteShade
	ld a,[hli]
	ld [wPalDataBuffer3],a
	ld a,[hl]
	ld [wPalDataBuffer3+1],a
	ld a,b
	rrca
	rrca
	ld b,a
	and $3
	call GetPaletteShade
	ld a,[hli]
	ld [wPalDataBuffer4],a
	ld a,[hl]
	ld [wPalDataBuffer4+1],a
	ret
	
GetPaletteShade:: ; 7246a (1c:646a)
	add a
	ld l,a
	xor a
	ld h,a
	add hl,de
	ret
	
TransferCurBGPData:: ; 72470 (1c:6470)
	push de
	add a
	add a
	add a
	or $80
	ld [rBGPI],a
	ld de,rBGPD
	ld hl,wPalDataBuffer1
	ld b,%10 ; searching oam STAT mode
	ld a,[rLCDC]
	and rLCDC_ENABLE_MASK
	jr nz,.lcdenabled
	rept 4
	call TransferCurPalDataLCDDisabled
	endr
	jr .done
.lcdenabled
	rept 4
	call TransferCurPalDataLCDEnabled
	endr
.done
	pop de
	ret

WriteCurBGPDataToMainBuffer:: ; 724a2 (1c:64a2)
	push de
	add a
	add a
	add a ; get the ath entry with size of 8 bytes (4 pal entries)
	ld l,a
	xor a
	ld h,a
	ld de,wStoredBGPPalettes
	add hl,de
	ld de,wPalDataBuffer1
	ld c,$8
.loop
	ld a,[de] ; copy to main buffer
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
	ld hl,wStoredBGPPalettes
	ld c,$20
.loop
	ld a,[hli]
	ld [de],a
	dec c
	jr nz,.loop
	ret
	
TransferCurOBPData: ; 724df (1c:64df)
	push de
	add a
	add a
	add a
	or $80
	ld [rOBPI],a
	ld de,rOBPD
	ld hl,wPalDataBuffer1
	ld b,%10 ; searching oam STAT mode
	ld a,[rLCDC]
	and rLCDC_ENABLE_MASK
	jr nz,.lcdenabled
	rept 4
	call TransferCurPalDataLCDDisabled
	endr
	jr .done
.lcdenabled
	rept 4
	call TransferCurPalDataLCDEnabled
	endr
.done
	pop de
	ret
	
TransferCurPalDataLCDEnabled: ; 72511 (1c:6511)
	ld a,[rSTAT]
	and b
	jr z,TransferCurPalDataLCDEnabled ; wait for non-vblank/hblank period
									  ; this is a precaution in-case we're nearing the end of vblank/hblank
.notinhblank
	ld a,[rSTAT]
	and b
	jr nz,.notinhblank ; wait if transferring oam or data to lcd driver
TransferCurPalDataLCDDisabled: ; 7251b (1c:651b)
	ld a,[hli]
	ld [de],a
	ld a,[hli]
	ld [de],a
	ret

_UpdateGBCPal_BGP_CheckDMG:: ; 72520 (1c:6520)
	ld a,[hGBC]
	and a
	ret z
; fallthrough
_UpdateGBCPal_BGP:: ; 72524 (1c:6524)
	ld a,[wPalDataPointer1]
	ld e,a
	ld a,[wPalDataPointer1+1]
	ld d,a
	xor a
	call UpdatePalData
	ld a,$0
	call WriteCurBGPDataToMainBuffer
	ld a,[wPalDataPointer2]
	ld e,a
	ld a,[wPalDataPointer2+1]
	ld d,a
	xor a
	call UpdatePalData
	ld a,$1
	call WriteCurBGPDataToMainBuffer
	ld a,[wPalDataPointer3]
	ld e,a
	ld a,[wPalDataPointer3+1]
	ld d,a
	xor a
	call UpdatePalData
	ld a,$2
	call WriteCurBGPDataToMainBuffer
	ld a,[wPalDataPointer4]
	ld e,a
	ld a,[wPalDataPointer4+1]
	ld d,a
	xor a
	call UpdatePalData
	ld a,$3
	call WriteCurBGPDataToMainBuffer
	call PreparePalDataTransfer
	ret
	
_UpdateGBCPal_OBP:: ; 7256c (1c:656c)
	ld a,[wPalDataPointer1]
	ld e,a
	ld a,[wPalDataPointer1+1]
	ld d,a
	ld a,c
	call UpdatePalData
	ld a,c
	dec a
	rlca
	rlca
	call TransferCurOBPData
	ld a,[wPalDataPointer2]
	ld e,a
	ld a,[wPalDataPointer2+1]
	ld d,a
	ld a,c
	call UpdatePalData
	ld a,c
	dec a
	rlca
	rlca
	inc a
	call TransferCurOBPData
	ld a,[wPalDataPointer3]
	ld e,a
	ld a,[wPalDataPointer3+1]
	ld d,a
	ld a,c
	call UpdatePalData
	ld a,c
	dec a
	rlca
	rlca
	add $2
	call TransferCurOBPData
	ld a,[wPalDataPointer4]
	ld e,a
	ld a,[wPalDataPointer4+1]
	ld d,a
	ld a,c
	call UpdatePalData
	ld a,c
	dec a
	rlca
	rlca
	add $3
	call TransferCurOBPData
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

Pointer_725e2:: ; 725e2 (1c:65e2)	
	db $0c,$11,$66,$21,$66,$41,$66,$51,$66,$61,$66,$81,$66,$a1,$66,$2d
	db $cf,$5b,$cc,$31,$67,$2c,$cf,$51,$67
	
CopySGBBorderTiles: ; 725fb (1c:65fb)
; SGB tile data is stored in a 4BPP planar format.
; Each tile is 32 bytes. The first 16 bytes contain bit planes 1 and 2, while
; the second 16 bytes contain bit planes 3 and 4.
; This function converts 2BPP planar data into this format by mapping
; 2BPP colors 0-3 to 4BPP colors 0-3. 4BPP colors 4-15 are not used.
	ld b, 128
.tileLoop
; Copy bit planes 1 and 2 of the tile data.
	ld c, 16
.copyLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copyLoop

; Zero bit planes 3 and 4.
	ld c, 16
	xor a
.zeroLoop
	ld [de], a
	inc de
	dec c
	jr nz, .zeroLoop

	dec b
	jr nz, .tileLoop
	ret

	;dr $725e2,$734b9
INCLUDE "data/sgb_packets.asm"

INCLUDE "data/mon_palettes.asm"

INCLUDE "data/super_palettes.asm"

INCLUDE "data/sgb_border.asm"