_RunPaletteCommand:
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
	jp hl

SetPal_Black:
	ld hl, PalPacket_Black
	ld de, BlkPacket_Battle
	ret

; uses PalPacket_Empty to build a packet based on mon IDs and health color
SetPal_Battle:
	ld hl, PalPacket_Empty
	ld de, wPalPacket
	ld bc, $10
	call CopyData
	;ld a, [wPlayerBattleStatus3]
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
	;ld a, [wEnemyBattleStatus3]
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

SetPal_TownMap:
	ld hl, PalPacket_TownMap
	ld de, BlkPacket_WholeScreen
	ret

; uses PalPacket_Empty to build a packet based the mon ID
SetPal_StatusScreen:
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

SetPal_PartyMenu:
	ld hl, PalPacket_PartyMenu
	ld de, wPartyMenuBlkPacket
	ret

SetPal_Pokedex:
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

SetPal_Slots:
	ld hl, PalPacket_Slots
	ld de, BlkPacket_Slots
	ret

SetPal_Titlescreen:
	ld hl, PalPacket_Titlescreen
	ld de, BlkPacket_Titlescreen
	ret

; used mostly for menus and the Oak intro
SetPal_Generic:
	ld hl, PalPacket_Generic
	ld de, BlkPacket_WholeScreen
	ret

SetPal_NidorinoIntro:
	ld hl, PalPacket_NidorinoIntro
	ld de, BlkPacket_NidorinoIntro
	ret

SetPal_GameFreakIntro:
	ld hl, PalPacket_GameFreakIntro
	ld de, BlkPacket_GameFreakIntro
	ld a, SET_PAL_GENERIC
	ld [wDefaultPaletteCommand], a
	ret

; uses PalPacket_Empty to build a packet based on the current map
SetPal_Overworld:
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
	jr z, .trade_center_colosseum
	cp COLOSSEUM
	jr z, .trade_center_colosseum
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
.trade_center_colosseum
	ld a, PAL_GREYMON - 1
	jr .town

; used when a Pokemon is the only thing on the screen
; such as evolution, trading and the Hall of Fame
SetPal_PokemonWholeScreen:
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

SetPal_TrainerCard:
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

SendUnknownPalPacket_7205d::
	ld hl, UnknownPalPacket_72811
	ld de, BlkPacket_WholeScreen
	ret

SendUnknownPalPacket_72064::
	ld hl, UnknownPalPacket_72821
	ld de, UnknownPacket_72751
	ret

SetPalFunctions:
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
BadgeBlkDataLengths:
	db 6     ; Boulder Badge
	db 6     ; Cascade Badge
	db 6     ; Thunder Badge
	db 6 * 3 ; Rainbow Badge
	db 6     ; Soul Badge
	db 6     ; Marsh Badge
	db 6     ; Volcano Badge
	db 6     ; Earth Badge

DeterminePaletteID:
	ld a, [hl]
DeterminePaletteIDOutOfBattle:
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

YellowIntroPaletteAction::
	ld a, e
	and a
	jr nz, .asm_720bd
	ld hl, PalPacket_Generic
	ld a, [hGBC]
	and a
	jp z, SendSGBPacket
	jp InitGBCPalettes

.asm_720bd
	ld hl, UnknownPalPacket_72811
	ld a, [hGBC]
	and a
	jp z, SendSGBPacket
	call InitGBCPalettes
	ld hl, PalPacket_Generic
	inc hl
	ld a, [hli]
	call GetGBCBasePalAddress
	ld a, e
	ld [wGBCBasePalPointers + 2], a
	ld a, d
	ld [wGBCBasePalPointers + 2 + 1], a
	xor a ; CONVERT_BGP
	call DMGPalToGBCPal
	ld a, 1
	call TransferCurBGPData
	ret

LoadOverworldPikachuFrontpicPalettes::
	ld hl, PalPacket_Empty
	ld de, wPalPacket
	ld bc, $10
	call CopyData
	call GetPal_Pikachu
	ld hl, wPartyMenuBlkPacket
	ld [hl], a
	ld hl, wPartyMenuBlkPacket + 2
	ld a, $26
	ld [hl], a
	ld hl, wPalPacket
	ld a, [hGBC]
	and a
	jr nz, .cgb_1
	call SendSGBPacket
	jr .okay_1

.cgb_1
	call InitGBCPalettes
.okay_1
	ld hl, BlkPacket_WholeScreen
	ld de, wPalPacket
	ld bc, $10
	call CopyData
	ld hl, wPartyMenuBlkPacket + 2
	ld a, $5
	ld [hli], a
	ld a, $7
	ld [hli], a
	ld a, $6
	ld [hli], a
	ld a, $b
	ld [hli], a
	ld a, $a
	ld [hl], a
	ld hl, wPalPacket
	ld a, [hGBC]
	and a
	jr nz, .cgb_2
	call SendSGBPacket
	jr .okay_2

.cgb_2
	call InitGBCPalettes
.okay_2
	ret

GetPal_Pikachu::
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
	jr z, .battleOrTradeCenter
	cp COLOSSEUM
	jr z, .battleOrTradeCenter
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
	xor a ; PAL_PALLET - 1
	jr .town

.battleOrTradeCenter
	ld a, PAL_GREYMON - 1
	jr .town

InitPartyMenuBlkPacket:
	ld hl, BlkPacket_PartyMenu
	ld de, wPartyMenuBlkPacket
	ld bc, $30
	jp CopyData

UpdatePartyMenuBlkPacket:
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

SendSGBPacket:
	ld a, 1
	ld [hDisableJoypadPolling], a ; don't poll joypad while sending packet
	call _SendSGBPacket
	xor a
	ld [hDisableJoypadPolling], a
	ret

_SendSGBPacket:
;check number of packets
	ld a, [hl]
	and a, $07
	ret z
; store number of packets in B
	ld b, a
.loop2
; save B for later use
	push bc
; send RESET signal (P14=LOW, P15=LOW)
	xor a
	ld [rJOYP], a
; set P14=HIGH, P15=HIGH
	ld a, $30
	ld [rJOYP], a
;load length of packets (16 bytes)
	ld b, $10
.nextByte
;set bit counter (8 bits per byte)
	ld e, $08
; get next byte in the packet
	ld a, [hli]
	ld d, a
.nextBit0
	bit 0, d
; if 0th bit is not zero set P14=HIGH, P15=LOW (send bit 1)
	ld a, $10
	jr nz, .next0
; else (if 0th bit is zero) set P14=LOW, P15=HIGH (send bit 0)
	ld a, $20
.next0
	ld [rJOYP], a
; must set P14=HIGH, P15=HIGH between each "pulse"
	ld a, $30
	ld [rJOYP], a
; rotation will put next bit in 0th position (so  we can always use command
; "bit 0, d" to fetch the bit that has to be sent)
	rr d
; decrease bit counter so we know when we have sent all 8 bits of current byte
	dec e
	jr nz, .nextBit0
	dec b
	jr nz, .nextByte
; send bit 1 as a "stop bit" (end of parameter data)
	ld a, $20
	ld [rJOYP], a
; set P14=HIGH, P15=HIGH
	ld a, $30
	ld [rJOYP], a
; wait for about 70000 cycles
	call Wait7000
; restore (previously pushed) number of packets
	pop bc
	dec b
; return if there are no more packets
	ret z
; else send 16 more bytes
	jr .loop2

LoadSGB:
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
	jp SendSGBPacket

PrepareSuperNintendoVRAMTransfer:
	ld hl, .packetPointers
	ld c, 9
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

.packetPointers
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

CheckSGB:
; Returns whether the game is running on an SGB in carry.
	ld hl, MltReq2Packet
	call SendSGBPacket
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

SendMltReq1Packet:
	ld hl, MltReq1Packet
	call SendSGBPacket
	jp Wait7000

CopyGfxToSuperNintendoVRAM:
	di
	push de
	call DisableLCD
	ld a, $e4
	ld [rBGP], a
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
	call SendSGBPacket
	xor a
	ld [rBGP], a
	call _UpdateGBCPal_BGP_CheckDMG
	ei
	ret

Wait7000:
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

SendSGBPackets:
	ld a, [hGBC]
	and a
	jr z, .notGBC
	push de
	call InitGBCPalettes
	pop hl
	call InitGBCPalettes
	ld a, [rLCDC]
	and rLCDC_ENABLE_MASK
	ret z
	call Delay3
	ret
.notGBC
	push de
	call SendSGBPacket
	pop hl
	jp SendSGBPacket

InitGBCPalettes:
	ld a, [hl]
	and $f8
	cp $20
	jp z, TranslatePalPacketToBGMapAttributes

	inc hl

index = 0

	REPT NUM_ACTIVE_PALS
		IF index > 0
			pop hl
		ENDC

		ld a, [hli]
		inc hl

		IF index < (NUM_ACTIVE_PALS + -1)
			push hl
		ENDC

		call GetGBCBasePalAddress
		ld a, e
		ld [wGBCBasePalPointers + index * 2], a
		ld a, d
		ld [wGBCBasePalPointers + index * 2 + 1], a

		xor a ; CONVERT_BGP
		call DMGPalToGBCPal
		ld a, index
		call TransferCurBGPData

		ld a, CONVERT_OBP0
		call DMGPalToGBCPal
		ld a, index
		call TransferCurOBPData

		ld a, CONVERT_OBP1
		call DMGPalToGBCPal
		ld a, index + 4
		call TransferCurOBPData

index = index + 1
	ENDR

	ret

GetGBCBasePalAddress::
; Input: a = palette ID
; Output: de = palette address
	push hl
	ld l, a
	xor a
	ld h, a
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, GBCBasePalettes
	add hl, de
	ld a, l
	ld e, a
	ld a, h
	ld d, a
	pop hl
	ret

DMGPalToGBCPal::
; Populate wGBCPal with colors from a base palette, selected using one of the
; DMG palette registers.
; Input:
; a = which DMG palette register
; de = address of GBC base palette
	and a
	jr nz, .notBGP
	ld a, [rBGP]
	ld [wLastBGP], a
	jr .convert
.notBGP
	dec a
	jr nz, .notOBP0
	ld a, [rOBP0]
	ld [wLastOBP0], a
	jr .convert
.notOBP0
	ld a, [rOBP1]
	ld [wLastOBP1], a
.convert
color_index = 0
	REPT NUM_COLORS
		ld b, a
		and %11
		call .GetColorAddress
		ld a, [hli]
		ld [wGBCPal + color_index * 2], a
		ld a, [hl]
		ld [wGBCPal + color_index * 2 + 1], a

		IF color_index < (NUM_COLORS + -1)
			ld a, b
			rrca
			rrca
		ENDC

color_index = color_index + 1
	ENDR
	ret

.GetColorAddress:
	add a
	ld l, a
	xor a
	ld h, a
	add hl, de
	ret

TransferCurBGPData::
	push de
	add a
	add a
	add a
	or $80 ; auto-increment
	ld [rBGPI], a
	ld de, rBGPD
	ld hl, wGBCPal
	ld b, %10 ; mask for non-V-blank/non-H-blank STAT mode
	ld a, [rLCDC]
	and rLCDC_ENABLE_MASK
	jr nz, .lcdEnabled
	rept NUM_COLORS
	call TransferPalColorLCDDisabled
	endr
	jr .done
.lcdEnabled
	rept NUM_COLORS
	call TransferPalColorLCDEnabled
	endr
.done
	pop de
	ret

BufferBGPPal::
; Copy wGBCPal to palette a in wBGPPalsBuffer.
	push de
	add a
	add a
	add a
	ld l, a
	xor a
	ld h, a
	ld de, wBGPPalsBuffer
	add hl, de
	ld de, wGBCPal
	ld c, PAL_SIZE
.loop
	ld a, [de]
	ld [hli], a
	inc de
	dec c
	jr nz, .loop
	pop de
	ret

TransferBGPPals::
; Transfer the buffered BG palettes.
	ld a, [rLCDC]
	and rLCDC_ENABLE_MASK
	jr z, .lcdDisabled
	di
.waitLoop
	ld a, [rLY]
	cp 144
	jr c, .waitLoop
.lcdDisabled
	call .DoTransfer
	ei
	ret

.DoTransfer:
	xor a
	or $80 ; auto-increment
	ld [rBGPI], a
	ld de, rBGPD
	ld hl, wBGPPalsBuffer
	ld c, 4 * PAL_SIZE
.loop
	ld a, [hli]
	ld [de], a
	dec c
	jr nz, .loop
	ret

TransferCurOBPData:
	push de
	add a
	add a
	add a
	or $80 ; auto-increment
	ld [rOBPI], a
	ld de, rOBPD
	ld hl, wGBCPal
	ld b, %10 ; mask for non-V-blank/non-H-blank STAT mode
	ld a, [rLCDC]
	and rLCDC_ENABLE_MASK
	jr nz, .lcdEnabled
	rept NUM_COLORS
	call TransferPalColorLCDDisabled
	endr
	jr .done
.lcdEnabled
	rept NUM_COLORS
	call TransferPalColorLCDEnabled
	endr
.done
	pop de
	ret

TransferPalColorLCDEnabled:
; Transfer a palette color while the LCD is enabled.

; In case we're already in H-blank or V-blank, wait for it to end. This is a
; precaution so that the transfer doesn't extend past the blanking period.
	ld a, [rSTAT]
	and b
	jr z, TransferPalColorLCDEnabled

; Wait for H-blank or V-blank to begin.
.notInBlankingPeriod
	ld a, [rSTAT]
	and b
	jr nz, .notInBlankingPeriod
; fall through

TransferPalColorLCDDisabled:
; Transfer a palette color while the LCD is disabled.
	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld [de], a
	ret

_UpdateGBCPal_BGP_CheckDMG::
	ld a, [hGBC]
	and a
	ret z
; fall through

_UpdateGBCPal_BGP::
index = 0

	REPT NUM_ACTIVE_PALS
		ld a, [wGBCBasePalPointers + index * 2]
		ld e, a
		ld a, [wGBCBasePalPointers + index * 2 + 1]
		ld d, a
		xor a ; CONVERT_BGP
		call DMGPalToGBCPal
		ld a, index
		call BufferBGPPal

index = index + 1
	ENDR

	call TransferBGPPals
	ret

_UpdateGBCPal_OBP::
index = 0

	REPT NUM_ACTIVE_PALS
		ld a, [wGBCBasePalPointers + index * 2]
		ld e, a
		ld a, [wGBCBasePalPointers + index * 2 + 1]
		ld d, a
		ld a, c
		call DMGPalToGBCPal
		ld a, c
		dec a
		rlca
		rlca

		IF index > 0
			IF index == 1
				inc a
			ELSE
				add index
			ENDC
		ENDC

		call TransferCurOBPData

index = index + 1
	ENDR

	ret

TranslatePalPacketToBGMapAttributes::
; translate the SGB pal packets into something usable for the GBC
	push hl
	pop de
	ld hl, PalPacketPointers
	ld a, [hli]
	ld c, a
.loop
	ld a, e
.innerLoop
	cp [hl]
	jr z, .checkHighByte
	inc hl
	inc hl
	dec c
	jr nz, .innerLoop
	ret
.checkHighByte
; the low byte of pointer matched, so check the high byte
	inc hl
	ld a, d
	cp [hl]
	jr z, .foundMatchingPointer
	inc hl
	dec c
	jr nz, .loop
	ret
.foundMatchingPointer
	callba LoadBGMapAttributes
	ret

PalPacketPointers::
	db (palPacketPointersEnd - palPacketPointers) / 2
palPacketPointers
	dw BlkPacket_WholeScreen
	dw BlkPacket_Battle
	dw BlkPacket_StatusScreen
	dw BlkPacket_Pokedex
	dw BlkPacket_Slots
	dw BlkPacket_Titlescreen
	dw BlkPacket_NidorinoIntro
	dw wPartyMenuBlkPacket
	dw wTrainerCardBlkPacket
	dw BlkPacket_GameFreakIntro
	dw wPalPacket
	dw UnknownPacket_72751
palPacketPointersEnd

CopySGBBorderTiles:
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

INCLUDE "data/sgb_packets.asm"

INCLUDE "data/mon_palettes.asm"

INCLUDE "data/super_palettes.asm"

INCLUDE "data/sgb_border.asm"
