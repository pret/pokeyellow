_RunPaletteCommand:
	call GetPredefRegisters
	ld a, b
	cp SET_PAL_DEFAULT
	jr nz, .not_default
	ld a, [wDefaultPaletteCommand]
.not_default
	cp SET_PAL_PARTY_MENU_HP_BARS
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

SetPal_BattleBlack:
	ld hl, PalPacket_Black
	ld de, BlkPacket_Battle
	ret

; uses PalPacket_Empty to build a packet based on mon IDs and health color
SetPal_Battle:
	ld hl, PalPacket_Empty
	ld de, wPalPacket
	ld bc, $10
	call CopyData
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
	ld a, [wCurPartySpecies]
	cp NUM_POKEMON_INDEXES + 1
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
	ld a, [wCurPartySpecies]
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

SetPal_TitleScreen:
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
	cp FIRST_INDOOR_MAP
	jr c, .townOrRoute
	cp CERULEAN_CAVE_2F
	jr c, .normalDungeonOrBuilding
	cp CERULEAN_CAVE_1F + 1
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
	cp NUM_CITY_MAPS
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
	ld a, PAL_GRAYMON - 1
	jr .town
.caveOrBruno
	ld a, PAL_CAVE - 1
	jr .town
.Lorelei
	xor a
	jr .town
.trade_center_colosseum
	ld a, PAL_GRAYMON - 1
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
	ld c, NUM_BADGES
.badgeLoop
	srl a
	push af
	jr c, .haveBadge
; The player doesn't have the badge, so zero the badge's blk data.
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

SetPal_PikachusBeach::
	ld hl, PalPacket_PikachusBeach
	ld de, BlkPacket_WholeScreen
	ret

SetPal_PikachusBeachTitle::
	ld hl, PalPacket_PikachusBeachTitle
	ld de, UnknownPacket_72751
	ret

SetPalFunctions:
; entries correspond to SET_PAL_* constants
	dw SetPal_BattleBlack
	dw SetPal_Battle
	dw SetPal_TownMap
	dw SetPal_StatusScreen
	dw SetPal_Pokedex
	dw SetPal_Slots
	dw SetPal_TitleScreen
	dw SetPal_NidorinoIntro
	dw SetPal_Generic
	dw SetPal_Overworld
	dw SetPal_PartyMenu
	dw SetPal_PokemonWholeScreen
	dw SetPal_GameFreakIntro
	dw SetPal_TrainerCard
	dw SetPal_PikachusBeach
	dw SetPal_PikachusBeachTitle

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
	ld [wPokedexNum], a
	and a ; is the mon index 0?
	jr z, .skipDexNumConversion
	push bc
	predef IndexToPokedex
	pop bc
	ld a, [wPokedexNum]
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
	ldh a, [hOnCGB]
	and a
	jp z, SendSGBPacket
	jp InitCGBPalettes

.asm_720bd
	ld hl, PalPacket_PikachusBeach
	ldh a, [hOnCGB]
	and a
	jp z, SendSGBPacket
	call InitCGBPalettes
	ld hl, PalPacket_Generic
	inc hl
	ld a, [hli]
	call GetCGBBasePalAddress
	ld a, e
	ld [wCGBBasePalPointers + 2], a
	ld a, d
	ld [wCGBBasePalPointers + 2 + 1], a
	xor a ; CONVERT_BGP
	call DMGPalToCGBPal
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
	ld a, PAL_PIKACHU_PORTRAIT
	ld [hl], a
	ld hl, wPalPacket
	ldh a, [hOnCGB]
	and a
	jr nz, .cgb_1
	call SendSGBPacket
	jr .okay_1

.cgb_1
	call InitCGBPalettes
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
	ldh a, [hOnCGB]
	and a
	jr nz, .cgb_2
	call SendSGBPacket
	jr .okay_2

.cgb_2
	call InitCGBPalettes
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
	cp CERULEAN_CAVE_2F
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
	ld a, PAL_GRAYMON - 1
	jr .town

.caveOrBruno
	ld a, PAL_CAVE - 1
	jr .town

.Lorelei
	xor a ; PAL_PALLET - 1
	jr .town

.battleOrTradeCenter
	ld a, PAL_GRAYMON - 1
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
	ldh [hDisableJoypadPolling], a ; don't poll joypad while sending packet
	call _SendSGBPacket
	xor a
	ldh [hDisableJoypadPolling], a
	ret

_SendSGBPacket:
;check number of packets
	ld a, [hl]
	and $07
	ret z
; store number of packets in B
	ld b, a
.loop2
; save B for later use
	push bc
; send RESET signal (P14=LOW, P15=LOW)
	xor a ; JOYP_SGB_START
	ldh [rJOYP], a
; set P14=HIGH, P15=HIGH
	ld a, JOYP_SGB_FINISH
	ldh [rJOYP], a
;load length of packets (16 bytes)
	ld b, 16
.nextByte
;set bit counter (8 bits per byte)
	ld e, 8
; get next byte in the packet
	ld a, [hli]
	ld d, a
.nextBit0
	bit 0, d
; if 0th bit is not zero set P14=HIGH, P15=LOW (send bit 1)
	ld a, JOYP_SGB_ONE
	jr nz, .next0
; else (if 0th bit is zero) set P14=LOW, P15=HIGH (send bit 0)
	ld a, JOYP_SGB_ZERO
.next0
	ldh [rJOYP], a
; must set P14=HIGH,P15=HIGH between each "pulse"
	ld a, JOYP_SGB_FINISH
	ldh [rJOYP], a
; rotation will put next bit in 0th position (so  we can always use command
; "bit 0, d" to fetch the bit that has to be sent)
	rr d
; decrease bit counter so we know when we have sent all 8 bits of current byte
	dec e
	jr nz, .nextBit0
	dec b
	jr nz, .nextByte
; send bit 0 as a "stop bit" (end of parameter data)
	ld a, JOYP_SGB_ZERO
	ldh [rJOYP], a
; set P14=HIGH,P15=HIGH
	ld a, JOYP_SGB_FINISH
	ldh [rJOYP], a
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
	ldh a, [hOnCGB]
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
	dw DataSndPacket1
	dw DataSndPacket2
	dw DataSndPacket3
	dw DataSndPacket4
	dw DataSndPacket5
	dw DataSndPacket6
	dw DataSndPacket7
	dw DataSndPacket8

CheckSGB:
; Returns whether the game is running on an SGB in carry.
	ld hl, MltReq2Packet
	call SendSGBPacket
	call Wait7000
	ldh a, [rJOYP]
	and JOYP_SGB_MLT_REQ
	cp JOYP_SGB_MLT_REQ
	jr nz, .isSGB
	ld a, JOYP_SGB_ZERO
	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	call Wait7000
	call Wait7000
	ld a, JOYP_SGB_FINISH
	ldh [rJOYP], a
	call Wait7000
	call Wait7000
	ld a, JOYP_SGB_ONE
	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	call Wait7000
	call Wait7000
	ld a, JOYP_SGB_FINISH
	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	call Wait7000
	call Wait7000
	ldh a, [rJOYP]
	and JOYP_SGB_MLT_REQ
	cp JOYP_SGB_MLT_REQ
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
	vc_hook Unknown_network_reset
	jp Wait7000

CopyGfxToSuperNintendoVRAM:
	di
	push de
	call DisableLCD
	ld a, $e4
	ldh [rBGP], a
	call _UpdateCGBPal_BGP_CheckDMG
	ld de, vChars1
	ld a, [wCopyingSGBTileData]
	and a
	jr z, .notCopyingTileData
	call CopySGBBorderTiles
	jr .next
.notCopyingTileData
	ld bc, 256 tiles
	call CopyData
.next
	ld hl, vBGMap0
	ld de, TILEMAP_WIDTH - SCREEN_WIDTH
	ld a, $80
	ld c, (256 + SCREEN_WIDTH - 1) / SCREEN_WIDTH ; enough rows to fit 256 tiles
.loop
	ld b, SCREEN_WIDTH
.innerLoop
	ld [hli], a
	inc a
	dec b
	jr nz, .innerLoop
	add hl, de
	dec c
	jr nz, .loop
	ld a, LCDC_DEFAULT
	ldh [rLCDC], a
	pop hl
	call SendSGBPacket
	xor a
	ldh [rBGP], a
	call _UpdateCGBPal_BGP_CheckDMG
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
	ldh a, [hOnCGB]
	and a
	jr z, .notCGB
	push de
	call InitCGBPalettes
	pop hl
	call InitCGBPalettes
	ldh a, [rLCDC]
	and LCDC_ON
	ret z
	call Delay3
	ret
.notCGB
	push de
	call SendSGBPacket
	pop hl
	jp SendSGBPacket

InitCGBPalettes:
	ld a, [hl]
	and $f8
	cp $20
	jp z, TranslatePalPacketToBGMapAttributes

	inc hl

	FOR index, NUM_ACTIVE_PALS
		IF index > 0
			pop hl
		ENDC

		ld a, [hli]
		inc hl

		IF index < NUM_ACTIVE_PALS - 1
			push hl
		ENDC

		call GetCGBBasePalAddress
		ld a, e
		ld [wCGBBasePalPointers + index * 2], a
		ld a, d
		ld [wCGBBasePalPointers + index * 2 + 1], a

		xor a ; CONVERT_BGP
		call DMGPalToCGBPal
		ld a, index
		call TransferCurBGPData

		ld a, CONVERT_OBP0
		call DMGPalToCGBPal
		ld a, index
		call TransferCurOBPData

		ld a, CONVERT_OBP1
		call DMGPalToCGBPal
		ld a, index + 4
		call TransferCurOBPData
	ENDR

	ret

GetCGBBasePalAddress::
; Input: a = palette ID
; Output: de = palette address
	push hl
	ld l, a
	xor a
	ld h, a
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, CGBBasePalettes
	add hl, de
	ld a, l
	ld e, a
	ld a, h
	ld d, a
	pop hl
	ret

DMGPalToCGBPal::
; Populate wCGBPal with colors from a base palette, selected using one of the
; DMG palette registers.
; Input:
; a = which DMG palette register
; de = address of CGB base palette
	and a
	jr nz, .notBGP
	ldh a, [rBGP]
	ld [wLastBGP], a
	jr .convert
.notBGP
	dec a
	jr nz, .notOBP0
	ldh a, [rOBP0]
	ld [wLastOBP0], a
	jr .convert
.notOBP0
	ldh a, [rOBP1]
	ld [wLastOBP1], a
.convert
	FOR color_index, PAL_COLORS
		ld b, a
		and %11
		call .GetColorAddress
		ld a, [hli]
		ld [wCGBPal + color_index * 2], a
		ld a, [hl]
		ld [wCGBPal + color_index * 2 + 1], a

		IF color_index < PAL_COLORS - 1
			ld a, b
			rrca
			rrca
		ENDC
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
	ldh [rBGPI], a
	ld de, rBGPD
	ld hl, wCGBPal
	ld b, %10 ; mask for non-V-blank/non-H-blank STAT mode
	ldh a, [rLCDC]
	and LCDC_ON
	jr nz, .lcdEnabled
	REPT PAL_COLORS
		call TransferPalColorLCDDisabled
	ENDR
	jr .done
.lcdEnabled
	REPT PAL_COLORS
		call TransferPalColorLCDEnabled
	ENDR
.done
	pop de
	ret

BufferBGPPal::
; Copy wCGBPal to palette a in wBGPPalsBuffer.
	push de
	add a
	add a
	add a
	ld l, a
	xor a
	ld h, a
	ld de, wBGPPalsBuffer
	add hl, de
	ld de, wCGBPal
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
	ldh a, [rLCDC]
	and LCDC_ON
	jr z, .lcdDisabled
	di
.waitLoop
	ldh a, [rLY]
	cp 144
	jr c, .waitLoop
.lcdDisabled
	call .DoTransfer
	ei
	ret

.DoTransfer:
	xor a
	or $80 ; auto-increment
	ldh [rBGPI], a
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
	ldh [rOBPI], a
	ld de, rOBPD
	ld hl, wCGBPal
	ld b, %10 ; mask for non-V-blank/non-H-blank STAT mode
	ldh a, [rLCDC]
	and LCDC_ON
	jr nz, .lcdEnabled
	REPT PAL_COLORS
		call TransferPalColorLCDDisabled
	ENDR
	jr .done
.lcdEnabled
	REPT PAL_COLORS
		call TransferPalColorLCDEnabled
	ENDR
.done
	pop de
	ret

TransferPalColorLCDEnabled:
; Transfer a palette color while the LCD is enabled.

; In case we're already in H-blank or V-blank, wait for it to end. This is a
; precaution so that the transfer doesn't extend past the blanking period.
	ldh a, [rSTAT]
	and b
	jr z, TransferPalColorLCDEnabled

; Wait for H-blank or V-blank to begin.
.notInBlankingPeriod
	ldh a, [rSTAT]
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

_UpdateCGBPal_BGP_CheckDMG::
	ldh a, [hOnCGB]
	and a
	ret z
; fall through

_UpdateCGBPal_BGP::
	FOR index, NUM_ACTIVE_PALS
		ld a, [wCGBBasePalPointers + index * 2]
		ld e, a
		ld a, [wCGBBasePalPointers + index * 2 + 1]
		ld d, a
		xor a ; CONVERT_BGP
		call DMGPalToCGBPal
		ld a, index
		call BufferBGPPal
	ENDR

	call TransferBGPPals
	ret

_UpdateCGBPal_OBP::
	FOR index, NUM_ACTIVE_PALS
		ld a, [wCGBBasePalPointers + index * 2]
		ld e, a
		ld a, [wCGBBasePalPointers + index * 2 + 1]
		ld d, a
		ld a, c
		call DMGPalToCGBPal
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
	ENDR

	ret

TranslatePalPacketToBGMapAttributes::
; translate the SGB pal packets into something usable for the CGB
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
	farcall LoadBGMapAttributes
	ret

PalPacketPointers::
	db (palPacketPointersEnd - palPacketPointers) / 2
palPacketPointers:
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
palPacketPointersEnd:

CopySGBBorderTiles:
; SGB tile data is stored in a 4BPP planar format.
; Each tile is 32 bytes. The first 16 bytes contain bit planes 1 and 2, while
; the second 16 bytes contain bit planes 3 and 4.
; This function converts 2BPP planar data into this format by mapping
; 2BPP colors 0-3 to 4BPP colors 0-3. 4BPP colors 4-15 are not used.
	ld b, 128
.tileLoop
; Copy bit planes 1 and 2 of the tile data.
	ld c, TILE_SIZE
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

INCLUDE "data/sgb/sgb_packets.asm"

INCLUDE "data/pokemon/palettes.asm"

INCLUDE "data/sgb/sgb_palettes.asm"

INCLUDE "data/sgb/sgb_border.asm"
