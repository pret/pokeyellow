Func_f531b:: ; f531b (3d:531b)
	ld c,$14
	call DelayFrames
	ld a,$1
	ld [wBuffer],a
	xor a
	ld [wUnknownSerialFlag_d49a],a
	hlCoord 0,0
	ld bc,$405
	call TextBoxBorder
	ld de,Text_f5791
	hlCoord 1,1
	call PlaceString
	hlCoord 8,0
	ld bc,$80a
	call TextBoxBorder
	hlCoord 10,2
	ld de,Text_f579c
	call PlaceString
	hlCoord 0,10
	ld bc,$612
	call TextBoxBorder
	call UpdateSprites
	xor a
	ld [wcd37],a
	ld [wd72d],a
	ld [wd11e],a
	ld hl,wTopMenuItemY
	ld a,$2
	ld [hli],a
	ld a,$9
	ld [hli],a
	xor a
	ld [hli],a
	inc hl
	ld a,$3
	ld [hli],a
	ld a,$3
	ld [hli],a
	xor a
	ld [hl],a
.asm_f5377
	call Func_f56bd
	call HandleMenuInput
	and $3
	add a
	add a
	ld b,a
	ld a,[wCurrentMenuItem]
	cp $3
	jr nz,.asm_f5390
	bit 2,b
	jr z,.asm_f5390
	dec a
	ld b,$8
.asm_f5390
	add b
	add $c0
	ld [wLinkMenuSelectionSendBuffer],a
	ld [wLinkMenuSelectionSendBuffer+1],a
.asm_f5399
	ld hl,wLinkMenuSelectionSendBuffer
	ld a,[hl]
	ld [hSerialSendData],a
	call Serial_ExchangeByte
	push af
	ld hl,wLinkMenuSelectionSendBuffer
	ld a,[hl]
	ld [hSerialSendData],a
	call Serial_ExchangeByte
	pop bc
	cp b
	jr nz,.asm_f5399
	and $f0
	cp $c0
	jr nz,.asm_f5399
	ld a,b
	and $c
	jr nz,.asm_f53c4
	ld a,[wLinkMenuSelectionSendBuffer]
	and $c
	jr z,.asm_f5377
	jr .asm_f53df
.asm_f53c4
	ld a,[wLinkMenuSelectionSendBuffer]
	and $c
	jr z,.asm_f53d1
	ld a,[hSerialConnectionStatus]
	cp $2
	jr z,.asm_f53df
.asm_f53d1
	ld a,$1
	ld [wd11e],a
	ld a,b
	ld [wLinkMenuSelectionSendBuffer],a
	and $3
	ld [wCurrentMenuItem],a
.asm_f53df
	call DelayFrame
	call DelayFrame
	ld hl,wLinkMenuSelectionSendBuffer
	ld a,[hl]
	ld [hSerialSendData],a
	call Serial_ExchangeByte
	call Serial_ExchangeByte
	ld b,$14
.loop
	call DelayFrame
	call Serial_SendZeroByte
	dec b
	jr nz,.loop
	ld b,$7f
	ld c,$7f
	ld d,$7f
	ld e,$ec
	ld a,[wLinkMenuSelectionSendBuffer]
	bit 3,a
	jr nz,.asm_f541a
	ld b,e
	ld e,c
	ld a,[wCurrentMenuItem]
	and a
	jr z,.asm_f541a
	ld c,b
	ld b,d
	dec a
	jr z,.asm_f541a
	ld d,c
	ld c,b
.asm_f541a
	ld a,b
	Coorda 9,2
	ld a,c
	Coorda 9,4
	ld a,d
	Coorda 9,6
	ld a,e
	Coorda 9,8
	ld c,40
	call DelayFrames
	ld a,[wLinkMenuSelectionSendBuffer]
	bit 3,a
	jr nz,asm_f547f
	ld a,[wCurrentMenuItem]
	cp $3
	jr z,asm_f547f
	inc a
	ld [wUnknownSerialFlag_d49a],a
	ld a,[wCurrentMenuItem]
	ld hl,PointerTable_f5488
	ld c,a
	ld b,$0
	add hl,bc
	add hl,bc
	ld a,[hli]
	ld h,[hl]
	ld l,a
	ld de,.returnaddress
	push de
	jp hl
.returnaddress
	ld [wLinkMenuSelectionSendBuffer],a
	xor a
	ld [wUnknownSerialCounter],a
	ld [wUnknownSerialCounter+1],a
	call Serial_SyncAndExchangeNybble
	ld a,[wLinkMenuSelectionSendBuffer]
	and a
	jr nz,asm_f547c
	xor a
	ld [wUnknownSerialCounter],a
	ld [wUnknownSerialCounter+1],a
	and a
	ret
	
Func_f5476:: ; f5476 (3d:5476)
	ld hl,Text_f5807
	call PrintText
asm_f547c:: ; f547c (3d:574c)
	jp Func_f531b

asm_f547f:: ; f547f (3d:547f)
	xor a
	ld [wUnknownSerialCounter],a
	ld [wUnknownSerialCounter+1],a
	scf
	ret

PointerTable_f5488:: ; f5488 (3d:5488)
	dw PokeCup
	dw PikaCup
	dw PetitCup

PokeCup:: ; f548e (3d:548e)
	ld hl,wPartyCount
	ld a,[hli]
	cp $3
	jp nz,NotThreeMonsInParty
	ld b,$3
	ld a,[hli]
.loop
	cp MEW
	jp z,MewInParty
	dec b
	jr nz,.loop
	dec hl
	dec hl 
	cp [hl] ; is third mon second mon?
	jp z,DuplicateSpecies
	dec hl ; wPartySpecies
	cp [hl] ; is third mon first mon?
	jp z,DuplicateSpecies
	ld a,[hli]
	cp [hl] ; is first mon second mon?
	jp z,DuplicateSpecies
	ld a,[wPartyMon1Level]
	cp 56
	jp nc,LevelAbove55
	cp 50
	jp c,LevelUnder50
	ld b,a
	ld a,[wPartyMon2Level]
	cp 56
	jp nc,LevelAbove55
	cp 50
	jp c,LevelUnder50
	ld c,a
	ld a,[wPartyMon3Level]
	cp 56
	jp nc,LevelAbove55
	cp 50
	jp c,LevelUnder50
	add b
	add c
	cp 156
	jp nc,CombinedLevelsGreaterThan155
	xor a
	ret

PikaCup:: ; f54e4 (3d:54e4)
	ld hl,wPartyCount
	ld a,[hli]
	cp $3
	jp nz,NotThreeMonsInParty
	ld b,$3
.loop
	ld a,[hli] ; wPartySpecies
	cp MEW
	jp z,MewInParty
	dec b
	jr nz,.loop
	dec hl
	dec hl 
	cp [hl] ; is third mon second mon?
	jp z,DuplicateSpecies
	dec hl ; wPartySpecies
	cp [hl] ; is third mon first mon?
	jp z,DuplicateSpecies
	ld a,[hli]
	cp [hl] ; is first mon second mon?
	jp z,DuplicateSpecies
	ld a,[wPartyMon1Level]
	cp 21
	jp nc,LevelAbove20
	cp 15
	jp c,LevelUnder15
	ld b,a
	ld a,[wPartyMon2Level]
	cp 21
	jp nc,LevelAbove20
	cp 15
	jp c,LevelUnder15
	ld c,a
	ld a,[wPartyMon3Level]
	cp 21
	jp nc,LevelAbove20
	cp 15
	jp c,LevelUnder15
	add b
	add c
	cp 51
	jp nc,CombinedLevelsAbove50
	xor a
	ret
	
PetitCup:: ; f553a (3d:553a)
	ld hl,wPartyCount
	ld a,[hli]
	cp $3
	jp nz,NotThreeMonsInParty
	ld b,$3
.loop
	ld a,[hli]
	cp MEW
	jp z,MewInParty
	dec b
	jr nz,.loop
	dec hl
	dec hl 
	cp [hl] ; is third mon second mon?
	jp z,DuplicateSpecies
	dec hl ; wPartySpecies
	cp [hl] ; is third mon first mon?
	jp z,DuplicateSpecies
	ld a,[hli]
	cp [hl] ; is first mon second mon?
	jp z,DuplicateSpecies
	dec hl
	ld a,[hl]
	ld [wcf91],a
	push hl
	callab Func_3b10f
	pop hl
	jp c,asm_f56ad
	inc hl
	ld a,[hl]
	ld [wcf91],a
	push hl
	callab Func_3b10f
	pop hl
	jp c,asm_f56ad
	inc hl
	ld a,[hl]
	ld [wcf91],a
	push hl
	callab Func_3b10f
	pop hl
	jp c,asm_f56ad
	dec hl
	dec hl
	ld b,$3
.bigloop
	ld a,[hli]
	push hl
	push bc
	push af
	dec a
	ld c,a
	ld b,$0
	ld hl,Pointer_4050b
	add hl,bc
	add hl,bc
	ld de,wcd6d
	ld bc,$2
	ld a,BANK(Pointer_4050b)
	call FarCopyData
	ld hl,wcd6d
	ld a,[hli]
	ld h,[hl]
	ld l,a
	ld de,wcd6d
	ld bc,$14
	ld a,BANK(Pointer_4050b)
	call FarCopyData
	ld hl,wcd6d
.loop
	ld a,[hli]
	cp "@"
	jr nz,.loop
	ld a,[hli]
	cp $7
	jp nc,asm_f5689
	add a
	add a
	ld b,a
	add a
	add b
	ld b,a
	ld a,[hli]
	add b
	cp $51
	jp nc,asm_f5689
	ld a,[hli]
	sub $b9
	ld a,[hl]
	sbc $1
	jp nc,asm_f569b
	pop af
	pop bc
	pop hl
	dec b
	jr nz,.bigloop
	ld a,[wPartyMon1Level]
	cp 31
	jp nc,LevelAbove30
	cp 25
	jp c,LevelUnder25
	ld b,a
	ld a,[wPartyMon2Level]
	cp 31
	jp nc,LevelAbove30
	cp 25
	jp c,LevelUnder25
	ld c,a
	ld a,[wPartyMon3Level]
	cp 31
	jp nc,LevelAbove30
	cp 25
	jp c,LevelUnder25
	add b
	add c
	cp 81
	jp nc,CombinedLevelsAbove80
	xor a
	ret
	
NotThreeMonsInParty:: ; f561d (3d:516d)
	ld hl,Text_f57bc
	call PrintText
	ld a,$1
	ret

MewInParty:: ; f5626 (3d:f5626)
	ld hl,Text_f57c1
	call PrintText
	ld a,$2
	ret
	
DuplicateSpecies:: ; f562f (3d:f562f)
	ld hl,Text_f57c6
	call PrintText
	ld a,$3
	ret
	
LevelAbove55:: ; f5638 (3d:5638)
	ld hl,Text_f57cb
	call PrintText
	ld a,$4
	ret
	
LevelUnder50:: ; f5641 (3d:5641)
	ld hl,Text_f57d0
	call PrintText
	ld a,$5
	ret
	
CombinedLevelsGreaterThan155:: ; f5641 (3d:564a)
	ld hl,Text_f57d5
	call PrintText
	ld a,$6
	ret
	
LevelAbove30:: ; f5653 (3d:5653)
	ld hl,Text_f57da
	call PrintText
	ld a,$7
	ret
	
LevelUnder25:: ; f565c (3d:565c)
	ld hl,Text_f57df
	call PrintText
	ld a,$8
	ret
	
CombinedLevelsAbove80:: ; f5665 (3d:5665)
	ld hl,Text_f5665
	call PrintText
	ld a,$9
	ret
	
LevelAbove20:: ; f566e (3d:566e)
	ld hl,Text_f57e9
	call PrintText
	ld a,$a
	ret
	
LevelUnder15:: ; f5677 (3d:5677)
	ld hl,Text_f57ee
	call PrintText
	ld a,$b
	ret
	
CombinedLevelsAbove50:: ; f5680 (3d:5680)
	ld hl,Text_f57f3
	call PrintText
	ld a,$c
	ret
	
asm_f5689:: ; f5689 (3d:5689)
	pop af
	pop bc
	pop hl
	ld [wd11e],a
	call GetMonName
	ld hl,Text_f57f8
	call PrintText
	ld a,$d
	ret
	
asm_f569b:: ; f569b (3d:569b)
	pop af
	pop bc
	pop hl
	ld [wd11e],a
	call GetMonName
	ld hl,Text_f57fd
	call PrintText
	ld a,$e
	ret
	
asm_f56ad:: ; f56ad (3d:56ad)
	ld a,[hl]
	ld [wd11e],a
	call GetMonName
	ld hl,Text_f5802
	call PrintText
	ld a,$f
	ret
	
Func_f56bd:: ; f56bd (3d:56bd)
	xor a
	ld [H_AUTOBGTRANSFERENABLED],a
	hlCoord 1,11
	ld bc,$612
	call ClearScreenArea
	ld a,[wCurrentMenuItem]
	cp $3
	jr nc,.asm_f56e6
	ld hl,PointerTable_f56ee
	ld a,[wCurrentMenuItem]
	ld c,a
	ld b,$0
	add hl,bc
	add hl,bc
	ld a,[hli]
	ld h,[hl]
	ld l,a
	ld d,h
	ld e,l
	hlCoord 1,12
	call PlaceString
	call Delay3
	ld a,$1
	ld [H_AUTOBGTRANSFERENABLED],a
	ret
	
PointerTable_f56ee:: ; f56ee (3d:56ee)
	dw Text_f56f4
	dw Text_f5728
	dw Text_f575b
	
Text_f56f4:: ; f56f4 (3d:56f4)
	db "LVs of 3<pkmn>:50-55"
	next "Sum of LVs:155 MAX"
	next "MEW can't attend.@"
	
Text_f5728:: ; f5728 (3d:5728)
	db "LVs of 3<pkmn>:15-20"
	next "Sum of LVs:50 MAX"
	next "MEW can't attend.@"
	
Text_f575b:: ; f575b (3d:575b)
	db "3 Basic <pkmn>.LV25-30"
	next "Sum of LVs:80 MAX"
	next "6",$71,"8",$73," and 44lb MAX@" ; 6'8" and 44lb MAX
	
Text_f5791:: ; f5791 (3d:5791)
	db "View"
	next "Rules@"
	
Text_f579c:: ; f579c (3d:579c)
	db "# Cup"
	next "Pika Cup"
	next "Petit Cup"
	next "CANCEL@"

Text_f57bc:: ; f57bc (3d:57bc)
	TX_FAR _Text_f57bc ; a0a2b
	db "@"

Text_f57c1:: ; f57c1 (3d:57c1)
	TX_FAR _Text_f57c1 ; a0a46
	db "@"

Text_f57c6:: ; f57c6 (3d:57c6)
	TX_FAR _Text_f57c6 ; a0a5f
	db "@"

Text_f57cb:: ; f57cb (3d:57cb)
    TX_FAR _Text_f57cb ; a0a81
    db "@"

Text_f57d0:: ; f57d0 (3d:57d0)
	TX_FAR _Text_f57d0 ; a0a9a
	db "@"

Text_f57d5:: ; f57d5 (3d:57d5)
	TX_FAR _Text_f57d5 ; a0aba
	db "@"

Text_f57da:: ; f57da (3d:57da)
	TX_FAR _Text_f57da ; a0ad9
	db "@"

Text_f57df:: ; f57df (3d:57df)
	TX_FAR _Text_f57df ; a0af2
	db "@"

Text_f57e4:: ; f57e4 (3d:57e4)
	TX_FAR _Text_f57e4 ; a0b12
	db "@"

Text_f57e9:: ; f57e9 (3d:57e9)
	TX_FAR _Text_f57e9 ; a0b30
	db "@"

Text_f57ee:: ; f57ee (3d:57ee)
	TX_FAR _Text_f57ee ; a0b49
	db "@"

Text_f57f3:: ; f57f3 (3d:57f3)
	TX_FAR _Text_f57f3 ; a0b69
	db "@"

Text_f57f8:: ; f57f8 (3d:57f8)
	TX_FAR _Text_f57f8 ; a0b87
	db "@"

Text_f57fd:: ; f57fd (3d:57fd)
	TX_FAR _Text_f57fd ; a0b9f
	db "@"
	
Text_f5802:: ; f5802 (3d:5802)
	TX_FAR _Text_f5802 ; a0bbb
	db "@"

Text_f5807:: ; f5807 (3d:5807)
	TX_FAR _Text_f5807 ; a0bd4
	db "@"
	
LinkMenu: ; f580c (3d:580c)
	xor a
	ld [wd358], a
	ld hl, wd72e
	set 6, [hl]
	ld hl, TextTerminator_6b20
	call PrintText
	call SaveScreenTilesToBuffer1
	ld hl, WhereWouldYouLikeText
	call PrintText
	hlCoord 5, 5
	ld bc, $80d
	call TextBoxBorder
	call UpdateSprites
	hlCoord 7, 7
	ld de, TradeCenterText
	call PlaceString
	xor a
	ld [wcd37], a
	ld [wd72d], a
	ld [wd11e], a
	ld hl, wTopMenuItemY
	ld a, $5
	ld [hli], a
	ld a, $6
	ld [hli], a
	xor a
	ld [hli], a
	inc hl
	ld a, $3
	ld [hli], a
	ld [hli], a
	xor a
	ld [hl], a
.waitForInputLoop
	call HandleMenuInput
	and A_BUTTON | B_BUTTON
	add a
	add a
	ld b, a
	ld a, [wCurrentMenuItem]
	cp $3
	jr nz,.asm_f586b
	bit 2,b
	jr z,.asm_f586b
	dec a
	ld b,$8
.asm_f586b
	add b
	add $d0
	ld [wLinkMenuSelectionSendBuffer], a
	ld [wLinkMenuSelectionSendBuffer + 1], a
.exchangeMenuSelectionLoop
	call Serial_ExchangeLinkMenuSelection
	ld a, [wLinkMenuSelectionReceiveBuffer]
	ld b, a
	and $f0
	cp $d0
	jr z, .asm_5c7d
	ld a, [wLinkMenuSelectionReceiveBuffer + 1]
	ld b, a
	and $f0
	cp $d0
	jr nz, .exchangeMenuSelectionLoop
.asm_5c7d
	ld a, b
	and $c ; did the enemy press A or B?
	jr nz, .enemyPressedAOrB
; the enemy didn't press A or B
	ld a, [wLinkMenuSelectionSendBuffer]
	and $c ; did the player press A or B?
	jr z, .waitForInputLoop ; if neither the player nor the enemy pressed A or B, try again
	jr .doneChoosingMenuSelection ; if the player pressed A or B but the enemy didn't, use the player's selection
.enemyPressedAOrB
	ld a, [wLinkMenuSelectionSendBuffer]
	and $c ; did the player press A or B?
	jr z, .useEnemyMenuSelection ; if the enemy pressed A or B but the player didn't, use the enemy's selection
; the enemy and the player both pressed A or B
; The gameboy that is clocking the connection wins.
	ld a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr z, .doneChoosingMenuSelection
.useEnemyMenuSelection
	ld a, $1
	ld [wd11e], a
	ld a, b
	ld [wLinkMenuSelectionSendBuffer], a
	and $3
	ld [wCurrentMenuItem], a ; wCurrentMenuItem
.doneChoosingMenuSelection
	ld a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr nz, .skipStartingTransfer
	call DelayFrame
	call DelayFrame
	ld a, START_TRANSFER_INTERNAL_CLOCK
	ld [rSC], a
.skipStartingTransfer
	ld b, $7f
	ld c, $7f
	ld d, $7f
	ld e, $ec
	ld a, [wLinkMenuSelectionSendBuffer]
	and (B_BUTTON << 2) ; was B button pressed?
	jr nz, .updateCursorPosition
; A button was pressed
	ld a, [wCurrentMenuItem]
	cp $2
	jp z, .asm_f5963
	jr z, .updateCursorPosition
	ld b, e
	ld e, c
	ld a, [wCurrentMenuItem]
	and a
	jr z, .updateCursorPosition
	ld c, b
	ld b, d
	dec a
	jr z, .updateCursorPosition
	ld d, c
	ld c, b
.updateCursorPosition
	call Func_f59ec
	call LoadScreenTilesFromBuffer1
	ld a, [wLinkMenuSelectionSendBuffer]
	and (B_BUTTON << 2) ; was B button pressed?
	jr nz, .choseCancel ; cancel if B pressed
	ld a, [wCurrentMenuItem]
	cp $2
	jr z, .choseCancel
	xor a
	ld [wWalkBikeSurfState], a ; start walking
	ld a, [wCurrentMenuItem]
	and a
	ld a, TRADE_CENTER
	jr nz, .next
	ld a, BATTLE_CENTER
.next
	ld [wd72d], a
	ld hl, PleaseWaitText
	call PrintText
	ld c, $32
	call DelayFrames
	ld hl, wd732
	res 1, [hl]
	ld a, [W_ANIMATIONID]
	ld [wDestinationMap], a
	callab SpecialWarpIn
	ld c, $14
	call DelayFrames
	xor a
	ld [wMenuJoypadPollCount], a
	ld [wSerialExchangeNybbleSendData], a
	inc a ; LINK_STATE_IN_CABLE_CLUB
	ld [wLinkState], a
	ld [wcc47], a
	ld hl,SpecialWarpIn
	ld b,BANK(SpecialWarpIn)
	jp Bankswitch
.choseCancel
	xor a
	ld [wMenuJoypadPollCount], a
	call Delay3
	callab CloseLinkConnection
	ld hl, LinkCanceledText
	call PrintText
	ld hl, wd72e
	res 6, [hl]
	ret

.asm_f5963
	ld a,[wd11e]
	and a
	jr nz,.asm_f5974
	ld b,$7f
	ld c,$7f
	ld d,$ec
	ld e,$7f
	call Func_f59ec
	xor a
	ld [wBuffer], a
	ld a,$ff
	ld [wSerialExchangeNybbleReceiveData],a
	ld b,$78
.loop
	ld a,[hSerialConnectionStatus]
	cp $2
	call z,DelayFrame
	dec b
	jr z,.asm_f59b2
	call SerialExchange_Nybble
	call DelayFrame
	ld a,[wSerialExchangeNybbleReceiveData]
	inc a
	jr z,.loop
.loop2
	ld b,$f
	call DelayFrame
	call SerialExchange_Nybble
	dec b
	jr nz,.loop2
	ld b,$f
.loop3
	call DelayFrame
	call Serial_SendZeroByte
	dec b
	jr nz,.loop3
	jr .asm_f59d6

.asm_f59b2
	xor a
	ld [wUnknownSerialCounter],a
	ld [wUnknownSerialCounter+1],a
	ld a,[wd11e]
	and a
	jr z,.asm_f59cd
	ld b,$7f
	ld c,$7f
	ld d,$7f
	ld e,$ec
	call Func_f59ec
	jp .chooseCancel
	
.asm_f59cd
	ld hl,Text_f5a11
	call PrintText
	jp .chooseCancel

.asm_f59d6
	ld b,$7f
	ld c,$7f
	ld d,$ec
	ld e,$7f
	call Func_f59ec
	call Func_f531b
	jp c,.chooseCancel
	ld a,$f0
	jp .next
	
Func_f59ec:: ; f59ec (3d:59ec)
	ld a, b
	Coorda 6, 7
	ld a, c
	Coorda 6, 9
	ld a, d
	Coorda 6, 11
	ld c, 40
	call DelayFrames
	ret
	
WhereWouldYouLikeText: ; f5a07 (3d:5a07)
	TX_FAR _WhereWouldYouLikeText
	db "@"

PleaseWaitText: ; f5a0c (3d:5a0c)
	TX_FAR _PleaseWaitText
	db "@"

LinkCanceledText: ; f5a11 (3d:5a11)
	TX_FAR _LinkCanceledText
	db "@"

TradeCenterText: ; f5a17 (3d:5a17)
	db "TRADE CENTER"
	next "COLOSSEUM"
	next "COLOSSEUM2"
	next "CANCEL@"