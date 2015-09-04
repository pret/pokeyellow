DoInGameTradeDialogue: ; 71b86 (1c:5b86)
; trigger the trade offer/action specified by wWhichTrade
	call SaveScreenTilesToBuffer2
	ld hl,TradeMons
	ld a,[wWhichTrade]
	ld bc,$e
	call AddNTimes
	ld a,[hli]
	ld [wInGameTradeGiveMonSpecies],a
	ld a,[hli]
	ld [wInGameTradeReceiveMonSpecies],a
	ld a,[hli]
	push af
	ld de,wInGameTradeMonNick
	ld bc, NAME_LENGTH
	call CopyData
	pop af
	ld l,a
	ld h,0
	ld de,InGameTradeTextPointers
	add hl,hl
	add hl,de
	ld a,[hli]
	ld [wInGameTradeTextPointerTablePointer],a
	ld a,[hl]
	ld [wInGameTradeTextPointerTablePointer + 1],a
	ld a,[wInGameTradeGiveMonSpecies]
	ld de,wInGameTradeGiveMonName
	call InGameTrade_GetMonName
	ld a,[wInGameTradeReceiveMonSpecies]
	ld de,wInGameTradeReceiveMonName
	call InGameTrade_GetMonName
	ld a,$4
	ld [wInGameTradeTextPointerTableIndex],a
	ld b,FLAG_TEST
	call InGameTrade_FlagActionPredef
	ld a,c
	and a
	jr nz,.printText
; if the trade hasn't been done yet
	ld a,$0
	ld [wInGameTradeTextPointerTableIndex],a
	call .printText
	ld a,$1
	ld [wInGameTradeTextPointerTableIndex],a
	call YesNoChoice
	ld a,[wCurrentMenuItem]
	and a
	jr nz,.printText
	call InGameTrade_DoTrade
	jr c,.printText
	ld hl, TradedForText
	call PrintText
.printText
	ld hl,wInGameTradeTextPointerTableIndex
	ld a,[hld] ; wInGameTradeTextPointerTableIndex
	ld e,a
	ld d,0
	ld a,[hld] ; wInGameTradeTextPointerTablePointer + 1
	ld l,[hl] ; wInGameTradeTextPointerTablePointer
	ld h,a
	add hl,de
	add hl,de
	ld a,[hli]
	ld h,[hl]
	ld l,a
	jp PrintText

; copies name of species a to hl
InGameTrade_GetMonName: ; 71c0c (1c:5c0c)
	push de
	ld [wd11e],a
	call GetMonName
	ld hl,wcd6d
	pop de
	ld bc, NAME_LENGTH
	jp CopyData

INCLUDE "data/trades.asm"

InGameTrade_DoTrade: ; 71ca9 (1c:5ca9)
	xor a ; NORMAL_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID],a
	dec a
	ld [wUpdateSpritesEnabled],a
	call DisplayPartyMenu
	push af
	call InGameTrade_RestoreScreen
	pop af
	ld a,$1
	jp c,.tradeFailed ; jump if the player didn't select a pokemon
	ld a,[wInGameTradeGiveMonSpecies]
	ld b,a
	ld a,[wcf91]
	cp b
	ld a,$2
	jr nz,.tradeFailed ; jump if the selected mon's species is not the required one
	ld a,[wWhichPokemon]
	ld hl,wPartyMon1Level
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a,[hl]
	ld [W_CURENEMYLVL],a
	ld b,FLAG_SET
	call InGameTrade_FlagActionPredef
	ld hl, ConnectCableText
	call PrintText
	ld a,[wWhichPokemon]
	push af
	ld a,[W_CURENEMYLVL]
	push af
	call LoadHpBarAndStatusTilePatterns
	call InGameTrade_PrepareTradeData
	predef InternalClockTradeAnim
	pop af
	ld [W_CURENEMYLVL],a
	pop af
	ld [wWhichPokemon],a
	ld a,[wInGameTradeReceiveMonSpecies]
	ld [wcf91],a
	xor a
	ld [wMonDataLocation],a ; not used
	ld [wRemoveMonFromBox],a
	call RemovePokemon
	ld a,$80 ; prevent the player from naming the mon
	ld [wMonDataLocation],a
	call AddPartyMon
	call InGameTrade_CopyDataToReceivedMon
	call InGameTrade_CheckForTradeEvo
	call ClearScreen
	call InGameTrade_RestoreScreen
	callba RedrawMapView
	and a
	ld a,$3
	jr .tradeSucceeded
.tradeFailed ; never jumped to
	scf
.tradeSucceeded
	ld [wInGameTradeTextPointerTableIndex],a
	ret

InGameTrade_RestoreScreen: ; 71d36 (1c:5d36)
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	call ReloadTilesetTilePatterns
	call LoadScreenTilesFromBuffer2
	call Delay3
	call LoadGBPal
	ld c, 10
	call DelayFrames
	jpba LoadWildData

InGameTrade_PrepareTradeData: ; 71d55 (1c:5d55)
	ld hl, wTradedPlayerMonSpecies
	ld a, [wInGameTradeGiveMonSpecies]
	ld [hli], a ; wTradedPlayerMonSpecies
	ld a, [wInGameTradeReceiveMonSpecies]
	ld [hl], a ; wTradedEnemyMonSpecies
	ld hl, wPartyMonOT
	ld bc, NAME_LENGTH
	ld a, [wWhichPokemon]
	call AddNTimes
	ld de, wTradedPlayerMonOT
	ld bc, NAME_LENGTH
	call InGameTrade_CopyData
	ld hl, InGameTrade_TrainerString
	ld de, wTradedEnemyMonOT
	call InGameTrade_CopyData
	ld de, wLinkEnemyTrainerName
	call InGameTrade_CopyData
	ld hl, wPartyMon1OTID
	ld bc, wPartyMon2 - wPartyMon1
	ld a, [wWhichPokemon]
	call AddNTimes
	ld de, wTradedPlayerMonOTID
	ld bc, $2
	call InGameTrade_CopyData
	call Random
	ld hl, hRandomAdd
	ld de, wTradedEnemyMonOTID
	jp CopyData

InGameTrade_CopyData: ; 71da5 (1c:5da5)
	push hl
	push bc
	call CopyData
	pop bc
	pop hl
	ret

InGameTrade_CopyDataToReceivedMon: ; 71dad (1c:5dad)
	ld hl, wPartyMonNicks
	ld bc, NAME_LENGTH
	call InGameTrade_GetReceivedMonPointer
	ld hl, wInGameTradeMonNick
	ld bc, NAME_LENGTH
	call CopyData
	ld hl, wPartyMonOT
	ld bc, NAME_LENGTH
	call InGameTrade_GetReceivedMonPointer
	ld hl, InGameTrade_TrainerString
	ld bc, NAME_LENGTH
	call CopyData
	ld hl, wPartyMon1OTID
	ld bc, wPartyMon2 - wPartyMon1
	call InGameTrade_GetReceivedMonPointer
	ld hl, wTradedEnemyMonOTID
	ld bc, $2
	jp CopyData

; the received mon's index is (partyCount - 1),
; so this adds bc to hl (partyCount - 1) times and moves the result to de
InGameTrade_GetReceivedMonPointer: ; 71de3 (1c:5de3)
	ld a, [wPartyCount]
	dec a
	call AddNTimes
	ld e, l
	ld d, h
	ret

InGameTrade_FlagActionPredef: ; 71ded (1c:5ded)
	ld hl,wCompletedInGameTradeFlags
	ld a,[wWhichTrade]
	ld c,a
	predef_jump FlagActionPredef
	
InGameTrade_CheckForTradeEvo: ; 71df9 (1c:5df9)
	ld a,[wInGameTradeReceiveMonSpecies]
	cp KADABRA
	jr z,.tradeEvo
	cp GRAVELER
	jr z,.tradeEvo
	cp MACHOKE
	jr z,.tradeEvo
	cp HAUNTER
	jr z,.tradeEvo
	ret
	
.tradeEvo
	ld a,[wPartyCount]
	dec a
	ld [wWhichPokemon],a
	ld a,$1
	ld [wForceEvolution],a
	ld a,LINK_STATE_TRADING
	ld [wLinkState],a
	callab EvolveTradeMon
	xor a ; LINK_STATE_NONE
	ld [wLinkState],a
	jp PlayDefaultMusic
	
InGameTrade_TrainerString: ; 71e2d (1c:5e2d)
	; "TRAINER@@@@@@@@@@"
	db $5d, "@@@@@@@@@@"

InGameTradeTextPointers: ; 71e38 (1c:5e38)
	dw TradeTextPointers1
	dw TradeTextPointers2
	dw TradeTextPointers3

TradeTextPointers1: ; 71e3e (1c:5e3e)
	dw WannaTrade1Text
	dw NoTrade1Text
	dw WrongMon1Text
	dw Thanks1Text
	dw AfterTrade1Text

TradeTextPointers2: ; 71e48 (1c:5e48)
	dw WannaTrade2Text
	dw NoTrade2Text
	dw WrongMon2Text
	dw Thanks2Text
	dw AfterTrade2Text

TradeTextPointers3: ; 71e52 (1c:5e52)
	dw WannaTrade3Text
	dw NoTrade3Text
	dw WrongMon3Text
	dw Thanks3Text
	dw AfterTrade3Text

ConnectCableText: ; 71e5c (1c:5e5c)
	TX_FAR _ConnectCableText
	db "@"

TradedForText: ; 71e61 (1c:5e61)
	TX_FAR _TradedForText
	db $11, $a, "@"

WannaTrade1Text: ; 71e66 (1c:5e66)
	TX_FAR _WannaTrade1Text
	db "@"

NoTrade1Text: ; 71e6b (1c:5e6b)
	TX_FAR _NoTrade1Text
	db "@"

WrongMon1Text: ; 71e70 (1c:5e70)
	TX_FAR _WrongMon1Text
	db "@"

Thanks1Text: ; 71e75 (1c:5e75)
	TX_FAR _Thanks1Text
	db "@"

AfterTrade1Text: ; 71e7a (1c:5e7a)
	TX_FAR _AfterTrade1Text
	db "@"

WannaTrade2Text: ; 71e7f (1c:5e7f)
	TX_FAR _WannaTrade2Text
	db "@"

NoTrade2Text: ; 71e84 (1c:5e84)
	TX_FAR _NoTrade2Text
	db "@"

WrongMon2Text: ; 71e89 (1c:5e89)
	TX_FAR _WrongMon2Text
	db "@"

Thanks2Text: ; 71e8e (1c:5e8e)
	TX_FAR _Thanks2Text
	db "@"

AfterTrade2Text: ; 71e93 (1c:5e93)
	TX_FAR _AfterTrade2Text
	db "@"

WannaTrade3Text: ; 71e98 (1c:5e98)
	TX_FAR _WannaTrade3Text
	db "@"

NoTrade3Text: ; 71e9d (1c:5d9d)
	TX_FAR _NoTrade3Text
	db "@"

WrongMon3Text: ; 71ea2 (1c:5ea2)
	TX_FAR _WrongMon3Text
	db "@"

Thanks3Text: ; 71ea7 (1c:5ea7)
	TX_FAR _Thanks3Text
	db "@"

AfterTrade3Text: ; 71eac (1c:5eac)
	TX_FAR _AfterTrade3Text
	db "@"
