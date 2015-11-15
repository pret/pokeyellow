; [wPartyMenuTypeOrMessageID] = menu type / message ID
; if less than $F0, it is a menu type
; menu types:
; 00: normal pokemon menu (e.g. Start menu)
; 01: use healing item on pokemon menu
; 02: in-battle switch pokemon menu
; 03: learn TM/HM menu
; 04: swap pokemon positions menu
; 05: use evolution stone on pokemon menu
; otherwise, it is a message ID
; f0: poison healed
; f1: burn healed
; f2: freeze healed
; f3: sleep healed
; f4: paralysis healed
; f5: HP healed
; f6: health returned
; f7: revitalized
; f8: leveled up
DrawPartyMenu_: ; 11875 (4:5875)
	xor a
	ld [H_AUTOBGTRANSFERENABLED],a
	call ClearScreen
	call UpdateSprites
	callba LoadMonPartySpriteGfxWithLCDDisabled ; load pokemon icon graphics

RedrawPartyMenu_: ; 11886 (4:5886)
	ld a,[wPartyMenuTypeOrMessageID]
	cp a,SWAP_MONS_PARTY_MENU
	jp z,.printMessage
	call ErasePartyMenuCursors
	callba InitPartyMenuBlkPacket
	coord hl, 3, 0
	ld de,wPartySpecies
	xor a
	ld c,a
	ld [hPartyMonIndex],a
	ld [wWhichPartyMenuHPBar],a
.loop
	ld a,[de]
	cp a,$FF ; reached the terminator?
	jp z,.afterDrawingMonEntries
	push bc
	push de
	push hl
	ld a,c
	push hl
	ld hl,wPartyMonNicks
	call GetPartyMonName
	pop hl
	call PlaceString ; print the pokemon's name
	ld a,[hPartyMonIndex]
	ld [wWhichPokemon],a
	callab IsThisPartymonOurPikachu
	jr nc, .regularMon
	call Func_154a
	jr z, .regularMon
	ld a, $ff
	ld [hPartyMonIndex], a
.regularMon
	callba WriteMonPartySpriteOAMByPartyIndex ; place the appropriate pokemon icon
	ld a, [wWhichPokemon]
	inc a
	ld [hPartyMonIndex],a
	call LoadMonData
	pop hl
	push hl
	ld a,[wMenuItemToSwap]
	and a ; is the player swapping pokemon positions?
	jr z,.skipUnfilledRightArrow
; if the player is swapping pokemon positions
	dec a
	ld b,a
	ld a,[wWhichPokemon]
	cp b ; is the player swapping the current pokemon in the list?
	jr nz,.skipUnfilledRightArrow
; the player is swapping the current pokemon in the list
	dec hl
	dec hl
	dec hl
	ld a,$EC ; unfilled right arrow menu cursor
	ld [hli],a ; place the cursor
	inc hl
	inc hl
.skipUnfilledRightArrow
	ld a,[wPartyMenuTypeOrMessageID] ; menu type
	cp a,TMHM_PARTY_MENU
	jr z,.teachMoveMenu
	cp a,EVO_STONE_PARTY_MENU
	jr z,.evolutionStoneMenu
	push hl
	ld bc,14 ; 14 columns to the right
	add hl,bc
	ld de,wLoadedMonStatus
	call PrintStatusCondition
	pop hl
	push hl
	ld bc,20 + 1 ; down 1 row and right 1 column
	ld a,[hFlags_0xFFFA]
	set 0,a
	ld [hFlags_0xFFFA],a
	add hl,bc
	predef DrawHP2 ; draw HP bar and prints current / max HP
	ld a,[hFlags_0xFFFA]
	res 0,a
	ld [hFlags_0xFFFA],a
	call SetPartyMenuHPBarColor ; color the HP bar (on SGB)
	pop hl
	jr .printLevel
.teachMoveMenu
	push hl
	predef CanLearnTM ; check if the pokemon can learn the move
	pop hl
	ld de,.ableToLearnMoveText
	ld a,c
	and a
	jr nz,.placeMoveLearnabilityString
	ld de,.notAbleToLearnMoveText
.placeMoveLearnabilityString
	push hl
	ld bc,20 + 9 ; down 1 row and right 9 columns
	add hl,bc
	call PlaceString
	pop hl
.printLevel
	ld bc,10 ; move 10 columns to the right
	add hl,bc
	call PrintLevel
	pop hl
	pop de
	inc de
	ld bc,2 * 20
	add hl,bc
	pop bc
	inc c
	jp .loop
.ableToLearnMoveText
	db "ABLE@"
.notAbleToLearnMoveText
	db "NOT ABLE@"
.evolutionStoneMenu
	push hl
	ld hl,EvosMovesPointerTable
	ld b,0
	ld a,[wLoadedMonSpecies]
	dec a
	add a
	rl b
	ld c,a
	add hl,bc
	ld de,wcd6d
	ld a,BANK(EvosMovesPointerTable)
	ld bc,2
	call FarCopyData
	ld hl,wcd6d
	ld a,[hli]
	ld h,[hl]
	ld l,a
	ld de,wcd6d
	ld a,BANK(EvosMovesPointerTable)
	ld bc, $0d ; Mon133_EvosEnd - Mon133_EvosMoves
	call FarCopyData
	ld hl,wcd6d
	ld de,.notAbleToEvolveText
; loop through the pokemon's evolution entries
.checkEvolutionsLoop
	ld a,[hli]
	and a ; reached terminator?
	jr z,.placeEvolutionStoneString ; if so, place the "NOT ABLE" string
	inc hl
	inc hl
	cp a,EV_ITEM
	jr nz,.checkEvolutionsLoop
; if it's a stone evolution entry
	dec hl
	dec hl
	ld b,[hl]
	ld a,[wEvoStoneItemID] ; the stone the player used
	inc hl
	inc hl
	inc hl
	cp b ; does the player's stone match this evolution entry's stone?
	jr nz,.checkEvolutionsLoop
; if it does match
	ld de,.ableToEvolveText
.placeEvolutionStoneString
	pop hl
	push hl
	ld bc,20 + 9 ; down 1 row and right 9 columns
	add hl,bc
	call PlaceString
	pop hl
	jr .printLevel
.ableToEvolveText
	db "ABLE@"
.notAbleToEvolveText
	db "NOT ABLE@"
.afterDrawingMonEntries
	ld b, SET_PAL_PARTY_MENU
	call RunPaletteCommand
.printMessage
	ld hl,wd730
	ld a,[hl]
	push af
	push hl
	set 6,[hl] ; turn off letter printing delay
	ld a,[wPartyMenuTypeOrMessageID] ; message ID
	cp a,$F0
	jr nc,.printItemUseMessage
	add a
	ld hl,PartyMenuMessagePointers
	ld b,0
	ld c,a
	add hl,bc
	ld a,[hli]
	ld h,[hl]
	ld l,a
	call PrintText
.done
	pop hl
	pop af
	ld [hl],a
	ld a,1
	ld [H_AUTOBGTRANSFERENABLED],a
	call Delay3
	jp GBPalNormal
.printItemUseMessage
	and a,$0F
	ld hl,PartyMenuItemUseMessagePointers
	add a
	ld c,a
	ld b,0
	add hl,bc
	ld a,[hli]
	ld h,[hl]
	ld l,a
	push hl
	ld a,[wUsedItemOnWhichPokemon]
	ld hl,wPartyMonNicks
	call GetPartyMonName
	pop hl
	call PrintText
	jr .done

PartyMenuItemUseMessagePointers: ; 11a1a (4:5a1a)
	dw AntidoteText
	dw BurnHealText
	dw IceHealText
	dw AwakeningText
	dw ParlyzHealText
	dw PotionText
	dw FullHealText
	dw ReviveText
	dw RareCandyText

PartyMenuMessagePointers: ; 11a2c (4:5a2c)
	dw PartyMenuNormalText
	dw PartyMenuItemUseText
	dw PartyMenuBattleText
	dw PartyMenuUseTMText
	dw PartyMenuSwapMonText
	dw PartyMenuItemUseText

PartyMenuNormalText: ; 11a38 (4:5a38)
	TX_FAR _PartyMenuNormalText
	db "@"

PartyMenuItemUseText: ; 11a3d (4:5a3d)
	TX_FAR _PartyMenuItemUseText
	db "@"

PartyMenuBattleText: ; 11a42 (4:5a42)
	TX_FAR _PartyMenuBattleText
	db "@"

PartyMenuUseTMText: ; 11a47 (4:5a47)
	TX_FAR _PartyMenuUseTMText
	db "@"

PartyMenuSwapMonText: ; 11a4c (4:5a4c)
	TX_FAR _PartyMenuSwapMonText
	db "@"

PotionText: ; 11a51 (4:5a51)
	TX_FAR _PotionText
	db "@"

AntidoteText: ; 11a56 (4:5a56)
	TX_FAR _AntidoteText
	db "@"

ParlyzHealText: ; 11a5b (4:5a5b)
	TX_FAR _ParlyzHealText
	db "@"

BurnHealText: ; 11a60 (4:5a60)
	TX_FAR _BurnHealText
	db "@"

IceHealText: ; 11a65 (4:5a65)
	TX_FAR _IceHealText
	db "@"

AwakeningText: ; 11a6a (4:5a6a)
	TX_FAR _AwakeningText
	db "@"

FullHealText: ; 11a6f (4:5a6f)
	TX_FAR _FullHealText
	db "@"

ReviveText: ; 11a74 (4:5a74)
	TX_FAR _ReviveText
	db "@"

RareCandyText: ; 11a79 (4:5a79)
	TX_FAR _RareCandyText
	db $0B
	db $06
	db "@"

SetPartyMenuHPBarColor: ; 11a80 (4:5a80)
	ld hl, wPartyMenuHPBarColors
	ld a, [wWhichPartyMenuHPBar]
	ld c, a
	ld b, 0
	add hl, bc
	call GetHealthBarColor
	ld b, UPDATE_PARTY_MENU_BLK_PACKET
	call RunPaletteCommand
	ld hl, wWhichPartyMenuHPBar
	inc [hl]
	ret
