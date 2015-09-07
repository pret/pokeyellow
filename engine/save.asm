LoadSAV: ; 73959 (1c:7959)
;(if carry -> write
;"the file data is destroyed")
	call ClearScreen
	call LoadFontTilePatterns
	call LoadTextBoxTilePatterns
	call LoadSAV0
	jr c, .badsum
	call LoadSAV1
	jr c, .badsum
	call LoadSAV2
	jr c, .badsum
	ld a, $2 ; good checksum
	jr .goodsum
.badsum
	ld hl, wd730
	push hl
	set 6, [hl]
	ld hl, FileDataDestroyedText
	call PrintText
	ld c, 100
	call DelayFrames
	pop hl
	res 6, [hl]
	ld a, $1 ; bad checksum
.goodsum
	ld [wSaveFileStatus], a
	ret

FileDataDestroyedText: ; 7398f (1c:798f)
	TX_FAR _FileDataDestroyedText
	db "@"

LoadSAV0: ; 73994 (1c:7994)
	call EnableSRAMAndLatchClockData
	ld a, $1
	ld [MBC1SRamBank], a
	ld hl, sPlayerName ; hero name located in SRAM
	ld bc, sMainDataCheckSum - sPlayerName ; but here checks the full SAV
	call SAVCheckSum
	ld c, a
	ld a, [sMainDataCheckSum] ; SAV's checksum
	cp c
	jp z, .checkSumsMatched

; If the computed checksum didn't match the saved on, try again.
	ld hl, sPlayerName
	ld bc, sMainDataCheckSum - sPlayerName
	call SAVCheckSum
	ld c, a
	ld a, [sMainDataCheckSum] ; SAV's checksum
	cp c
	jp nz, SAVBadCheckSum

.checkSumsMatched
	ld hl, sPlayerName
	ld de, wPlayerName
	ld bc, NAME_LENGTH
	call CopyData
	ld hl, sMainData
	ld de, wMainDataStart
	ld bc, wMainDataEnd - wMainDataStart
	call CopyData
	ld hl, W_CURMAPTILESET
	set 7, [hl]
	ld hl, sSpriteData
	ld de, wSpriteDataStart
	ld bc, wSpriteDataEnd - wSpriteDataStart
	call CopyData
	ld a, [sTilesetType]
	ld [hTilesetType], a
	ld hl, sCurBoxData
	ld de, wBoxDataStart
	ld bc, wBoxDataEnd - wBoxDataStart
	call CopyData
	and a
	jp SAVGoodChecksum

LoadSAV1: ; 739fc (1c:79fc)
	call EnableSRAMAndLatchClockData
	ld a, $1
	ld [MBC1SRamBank], a
	ld hl, sPlayerName ; hero name located in SRAM
	ld bc, sMainDataCheckSum - sPlayerName  ; but here checks the full SAV
	call SAVCheckSum
	ld c, a
	ld a, [sMainDataCheckSum] ; SAV's checksum
	cp c
	jr nz, SAVBadCheckSum
	ld hl, sCurBoxData
	ld de, wBoxDataStart
	ld bc, wBoxDataEnd - wBoxDataStart
	call CopyData
	and a
	jp SAVGoodChecksum

LoadSAV2: ; 73a24 (1c:7a24)
	call EnableSRAMAndLatchClockData
	ld a, $1
	ld [MBC1SRamBank], a
	ld hl, sPlayerName ; hero name located in SRAM
	ld bc, sMainDataCheckSum - sPlayerName  ; but here checks the full SAV
	call SAVCheckSum
	ld c, a
	ld a, [sMainDataCheckSum] ; SAV's checksum
	cp c
	jp nz, SAVBadCheckSum
	ld hl, sPartyData
	ld de, wPartyDataStart
	ld bc, wPartyDataEnd - wPartyDataStart
	call CopyData
	ld hl, sMainData
	ld de, wPokedexOwned
	ld bc, wPokedexSeenEnd - wPokedexOwned
	call CopyData
	and a
	jp SAVGoodChecksum

SAVBadCheckSum: ; 73a59 (1c:7a59)
	scf

SAVGoodChecksum: ; 736f8 (1c:76f8)
	call DisableSRAMAndPrepareClockData
	ret

LoadSAVIgnoreBadCheckSum: ; 73a5e (1c:7a5e)
; unused function that loads save data and ignores bad checksums
	call LoadSAV0
	call LoadSAV1
	jp LoadSAV2

SaveSAV: ; 73a67 (1c:7a67)
	callba PrintSaveScreenText
	ld c,10
	call DelayFrames
	ld hl,WouldYouLikeToSaveText
	call SaveSAVConfirm
	and a   ;|0 = Yes|1 = No|
	ret nz
	ld c,10
	call DelayFrames
	ld a,[wSaveFileStatus]
	cp $1
	jr z,.save
	call SAVCheckRandomID
	jr z,.save
	ld hl,OlderFileWillBeErasedText
	call SaveSAVConfirm
	and a
	ret nz
.save
	call SaveSAVtoSRAM
	ld hl,SavingText
	call PrintText
	ld c,128
	call DelayFrames
	ld hl,GameSavedText
	call PrintText
	ld c,10
	call DelayFrames
	ld a, $b6 ; SFX_SAVE
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	ld c,30
	call DelayFrames
	ret

SaveSAVConfirm: ; 73abc (1c:7abc)
	call PrintText
	coord hl, 0, 7
	lb bc, 8, 1
	ld a,TWO_OPTION_MENU
	ld [wTextBoxID],a
	call DisplayTextBoxID ; yes/no menu
	ld a,[wCurrentMenuItem]
	ret

WouldYouLikeToSaveText: ; 73ad1 (1c:7ad1)
	TX_FAR _WouldYouLikeToSaveText
	db "@"

SavingText: ; 73ad6 (1c:7ad6)
	TX_FAR _SavingText
	db "@"
	
GameSavedText: ; 73adb (1c:7adb)
	TX_FAR _GameSavedText
	db "@"

OlderFileWillBeErasedText: ; 73ae0 (1c:7ae0)
	TX_FAR _OlderFileWillBeErasedText
	db "@"
	
SaveSAVtoSRAM0: ; 73ae5 (1c:7ae5)
	call EnableSRAMAndLatchClockData
	ld a, $1
	ld [MBC1SRamBank], a
	ld hl, wPlayerName
	ld de, sPlayerName
	ld bc, NAME_LENGTH
	call CopyData
	ld hl, wMainDataStart
	ld de, sMainData
	ld bc, wMainDataEnd - wMainDataStart
	call CopyData
	ld hl, wSpriteDataStart
	ld de, sSpriteData
	ld bc, wSpriteDataEnd - wSpriteDataStart
	call CopyData
	ld hl, wBoxDataStart
	ld de, sCurBoxData
	ld bc, wBoxDataEnd - wBoxDataStart
	call CopyData
	ld a, [hTilesetType]
	ld [sTilesetType], a
	ld hl, sPlayerName
	ld bc, sMainDataCheckSum - sPlayerName
	call SAVCheckSum
	ld [sMainDataCheckSum], a
	call DisableSRAMAndPrepareClockData
	ret

SaveSAVtoSRAM1: ; 73b32 (1c:7b32)
; stored pokémon
	call EnableSRAMAndLatchClockData
	ld a, $1
	ld [MBC1SRamBank], a
	ld hl, wBoxDataStart
	ld de, sCurBoxData
	ld bc, wBoxDataEnd - wBoxDataStart
	call CopyData
	ld hl, sPlayerName
	ld bc, sMainDataCheckSum - sPlayerName
	call SAVCheckSum
	ld [sMainDataCheckSum], a
	call DisableSRAMAndPrepareClockData
	ret

SaveSAVtoSRAM2: ; 73b56 (1c:7b56)
	call EnableSRAMAndLatchClockData
	ld a, $1
	ld [MBC1SRamBank], a
	ld hl, wPartyDataStart
	ld de, sPartyData
	ld bc, wPartyDataEnd - wPartyDataStart
	call CopyData
	ld hl, wPokedexOwned ; pokédex only
	ld de, sMainData
	ld bc, wPokedexSeenEnd - wPokedexOwned
	call CopyData
	ld hl, wd470
	ld de, sMainData + $179
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld hl, sPlayerName
	ld bc, sMainDataCheckSum - sPlayerName
	call SAVCheckSum	
	ld [sMainDataCheckSum], a
	call DisableSRAMAndPrepareClockData
	ret
;;;
SaveSAVtoSRAM: ; 73b91 (1c:7b91)
	ld a, $2
	ld [wSaveFileStatus], a
	call SaveSAVtoSRAM0
	call SaveSAVtoSRAM1
	jp SaveSAVtoSRAM2

SAVCheckSum: ; 73b9f (1c:7b9f)
;Check Sum (result[1 byte] is complemented)
	ld d, 0
.loop
	ld a, [hli]
	add d
	ld d, a
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ld a, d
	cpl
	ret

CalcIndividualBoxCheckSums: ; 73bac (1c:7bac)
	ld hl, sBox1 ; sBox7
	ld de, sBank2IndividualBoxChecksums ; sBank3IndividualBoxChecksums
	ld b, NUM_BOXES / 2
.loop
	push bc
	push de
	ld bc, wBoxDataEnd - wBoxDataStart
	call SAVCheckSum
	pop de
	ld [de], a
	inc de
	pop bc
	dec b
	jr nz, .loop
	ret

GetBoxSRAMLocation: ; 73bc4 (1c:7bc4)
; in: a = box num
; out: b = box SRAM bank, hl = pointer to start of box
	ld hl, BoxSRAMPointerTable
	ld a, [wCurrentBoxNum]
	and $7f
	cp NUM_BOXES / 2
	ld b, 2
	jr c, .next
	inc b
	sub NUM_BOXES / 2
.next
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

BoxSRAMPointerTable: ; 73bde (1c:7bde)
	dw sBox1 ; sBox7
	dw sBox2 ; sBox8
	dw sBox3 ; sBox9
	dw sBox4 ; sBox10
	dw sBox5 ; sBox11
	dw sBox6 ; sBox12

ChangeBox:: ; 73bed (1c:7bed)
	ld hl, WhenYouChangeBoxText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ret nz ; return if No was chosen
	ld hl, wCurrentBoxNum
	bit 7, [hl] ; is it the first time player is changing the box?
	call z, EmptyAllSRAMBoxes ; if so, empty all boxes in SRAM
	call DisplayChangeBoxMenu
	call UpdateSprites
	ld hl, hFlags_0xFFFA
	set 1, [hl]
	call HandleMenuInput
	ld hl, hFlags_0xFFFA
	res 1, [hl]
	bit 1, a ; pressed b
	ret nz
	ld a, $b6
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	call GetBoxSRAMLocation
	ld e, l
	ld d, h
	ld hl, wBoxDataStart
	call CopyBoxToOrFromSRAM ; copy old box from WRAM to SRAM
	ld a, [wCurrentMenuItem]
	set 7, a
	ld [wCurrentBoxNum], a
	call GetBoxSRAMLocation
	ld de, wBoxDataStart
	call CopyBoxToOrFromSRAM ; copy new box from SRAM to WRAM
	ld hl, W_MAPTEXTPTR
	ld de, wChangeBoxSavedMapTextPointer
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	call RestoreMapTextPointer
	call SaveSAVtoSRAM
	ld hl, wChangeBoxSavedMapTextPointer
	call SetMapTextPointer
	ret

WhenYouChangeBoxText: ; 73c52 (1c:7c52)
	TX_FAR _WhenYouChangeBoxText
	db "@"

CopyBoxToOrFromSRAM: ; 73c57 (1c:7c57)
; copy an entire box from hl to de with b as the SRAM bank
	push hl
	call EnableSRAMAndLatchClockData
	ld a, b
	ld [MBC1SRamBank], a
	ld bc, wBoxDataEnd - wBoxDataStart
	call CopyData
	pop hl

; mark the memory that the box was copied from as am empty box
	xor a
	ld [hli], a
	dec a
	ld [hl], a

	ld hl, sBox1 ; sBox7
	ld bc, sBank2AllBoxesChecksum - sBox1
	call SAVCheckSum
	ld [sBank2AllBoxesChecksum], a ; sBank3AllBoxesChecksum
	call CalcIndividualBoxCheckSums
	call DisableSRAMAndPrepareClockData
	ret

DisplayChangeBoxMenu: ; 73c7d (1c:7c7d)
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld a, A_BUTTON | B_BUTTON
	ld [wMenuWatchedKeys], a
	ld a, 11
	ld [wMaxMenuItem], a
	ld a, 1
	ld [wTopMenuItemY], a
	ld a, 12
	ld [wTopMenuItemX], a
	xor a
	ld [wMenuWatchMovingOutOfBounds], a
	ld a, [wCurrentBoxNum]
	and $7f
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	coord hl, 0, 0
	lb bc, 2, 9
	call TextBoxBorder
	ld hl, ChooseABoxText
	call PrintText
	coord hl, 11, 0
	lb bc, 12, 7
	call TextBoxBorder
	ld hl, hFlags_0xFFFA
	set 2, [hl]
	ld de, BoxNames
	coord hl, 13, 1
	call PlaceString
	ld hl, hFlags_0xFFFA
	res 2, [hl]
	ld a, [wCurrentBoxNum]
	and $7f
	cp 9
	jr c, .singleDigitBoxNum
	sub 9
	coord hl, 8, 2
	ld [hl], "1"
	add "0"
	jr .next
.singleDigitBoxNum
	add "1"
.next
	Coorda 9, 2
	coord hl, 1, 2
	ld de, BoxNoText
	call PlaceString
	call GetMonCountsForAllBoxes
	coord hl, 18, 1
	ld de, wBoxMonCounts
	ld bc, SCREEN_WIDTH
	ld a, $c
.loop
	push af
	ld a, [de]
	and a ; is the box empty?
	jr z, .skipPlacingPokeball
	ld [hl], $78 ; place pokeball tile next to box name if box not empty
.skipPlacingPokeball
	add hl, bc
	inc de
	pop af
	dec a
	jr nz, .loop
	ld a, 1
	ld [H_AUTOBGTRANSFERENABLED], a
	ret

ChooseABoxText: ; 73d10 (1c:7d10)
	TX_FAR _ChooseABoxText
	db "@"

BoxNames: ; 73d15 (1c:7d15)
	db   "BOX 1"
	next "BOX 2"
	next "BOX 3"
	next "BOX 4"
	next "BOX 5"
	next "BOX 6"
	next "BOX 7"
	next "BOX 8"
	next "BOX 9"
	next "BOX10"
	next "BOX11"
	next "BOX12@"

BoxNoText: ; 73d5d (1c:7d5d)
	db "BOX No.@"

EmptyAllSRAMBoxes: ; 73d65 (1c:7d65)
; marks all boxes in SRAM as empty (initialisation for the first time the
; player changes the box)
	call EnableSRAMAndLatchClockData
	ld a, 2
	ld [MBC1SRamBank], a
	call EmptySRAMBoxesInBank
	ld a, 3
	ld [MBC1SRamBank], a
	call EmptySRAMBoxesInBank
	call DisableSRAMAndPrepareClockData
	ret

EmptySRAMBoxesInBank: ; 73d7c (1c:7d7c)
; marks every box in the current SRAM bank as empty
	ld hl, sBox1 ; sBox7
	call EmptySRAMBox
	ld hl, sBox2 ; sBox8
	call EmptySRAMBox
	ld hl, sBox3 ; sBox9
	call EmptySRAMBox
	ld hl, sBox4 ; sBox10
	call EmptySRAMBox
	ld hl, sBox5 ; sBox11
	call EmptySRAMBox
	ld hl, sBox6 ; sBox12
	call EmptySRAMBox
	ld hl, sBox1 ; sBox7
	ld bc, sBank2AllBoxesChecksum - sBox1
	call SAVCheckSum
	ld [sBank2AllBoxesChecksum], a ; sBank3AllBoxesChecksum
	call CalcIndividualBoxCheckSums
	ret

EmptySRAMBox: ; 73db0 (1c:7db0)
	xor a
	ld [hli], a
	dec a
	ld [hl], a
	ret

GetMonCountsForAllBoxes: ; 73a84 (1c:7a84)
	ld hl, wBoxMonCounts
	push hl
	call EnableSRAMAndLatchClockData
	ld a, $2
	ld [MBC1SRamBank], a
	call GetMonCountsForBoxesInBank
	ld a, $3
	ld [MBC1SRamBank], a
	call GetMonCountsForBoxesInBank
	call DisableSRAMAndPrepareClockData
	pop hl

; copy the count for the current box from WRAM
	ld a, [wCurrentBoxNum]
	and $7f
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [W_NUMINBOX]
	ld [hl], a

	ret

GetMonCountsForBoxesInBank: ; 73dde (1c:7dde)
	ld a, [sBox1] ; sBox7
	ld [hli], a
	ld a, [sBox2] ; sBox8
	ld [hli], a
	ld a, [sBox3] ; sBox9
	ld [hli], a
	ld a, [sBox4] ; sBox10
	ld [hli], a
	ld a, [sBox5] ; sBox11
	ld [hli], a
	ld a, [sBox6] ; sBox12
	ld [hli], a
	ret

SAVCheckRandomID: ; 73df7 (1c:7df7)
;checks if Sav file is the same by checking player's name 1st letter ($a598)
; and the two random numbers generated at game beginning
;(which are stored at wPlayerID)s
	call EnableSRAMAndLatchClockData
	ld a, $1
	ld [MBC1SRamBank], a
	ld a, [sPlayerName]
	and a
	jr z, .next
	ld hl, sPlayerName
	ld bc, sMainDataCheckSum - sPlayerName
	call SAVCheckSum
	ld c,a
	ld a,[sMainDataCheckSum]
	cp c
	jr nz,.next
	ld hl,sMainData + 98 ; player ID
	ld a,[hli]
	ld h,[hl]
	ld l,a
	ld a,[wPlayerID]
	cp l
	jr nz,.next
	ld a,[wPlayerID + 1]
	cp h
.next
	ld a,$00
	ld [MBC1SRamBankingMode],a
	ld [MBC1SRamEnable],a
	ret

SaveHallOfFameTeams: ; 73e2e (1c:7e2e)
	ld a, [wNumHoFTeams]
	dec a
	cp HOF_TEAM_CAPACITY
	jr nc, .shiftHOFTeams
	ld hl, sHallOfFame
	ld bc, HOF_TEAM
	call AddNTimes
	ld e, l
	ld d, h
	ld hl, wHallOfFame
	ld bc, HOF_TEAM
	jr HallOfFame_Copy

.shiftHOFTeams
; if the space designated for HOF teams is full, then shift all HOF teams to the next slot, making space for the new HOF team
; this deletes the last HOF team though
	ld hl, sHallOfFame + HOF_TEAM
	ld de, sHallOfFame
	ld bc, HOF_TEAM * (HOF_TEAM_CAPACITY - 1)
	call HallOfFame_Copy
	ld hl, wHallOfFame
	ld de, sHallOfFame + HOF_TEAM * (HOF_TEAM_CAPACITY - 1)
	ld bc, HOF_TEAM
	jr HallOfFame_Copy

LoadHallOfFameTeams: ; 73e60 (1c:7e60)
	ld hl, sHallOfFame
	ld bc, HOF_TEAM
	ld a, [wHoFTeamIndex]
	call AddNTimes
	ld de, wHallOfFame
	ld bc, HOF_TEAM
	; fallthrough

HallOfFame_Copy: ; 73e72 (1c:7e72)
	call EnableSRAMAndLatchClockData
	xor a
	ld [MBC1SRamBank], a
	call CopyData
	call DisableSRAMAndPrepareClockData
	ret

ClearSAV: ; 73e80 (1c:7e80)
	call EnableSRAMAndLatchClockData
	ld a, $4
.loop
	dec a
	push af
	call PadSRAM_FF
	pop af
	jr nz, .loop
	call DisableSRAMAndPrepareClockData
	ret

PadSRAM_FF: ; 73e91 (1c:7e91)
	ld [MBC1SRamBank], a
	ld hl, $a000
	ld bc, $2000
	ld a, $ff
	jp FillMemory

EnableSRAMAndLatchClockData: ; 73e9f (1c:7e9f)
	ld a, $1
	ld [MBC1SRamBankingMode], a
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	ret
	
DisableSRAMAndPrepareClockData: ; 73eaa (1c:7eaa)
	ld a, SRAM_DISABLE
	ld [MBC1SRamBankingMode], a
	ld [MBC1SRamEnable], a
	ret