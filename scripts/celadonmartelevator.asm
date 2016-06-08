CeladonMartElevatorScript:
	ld hl, wd126
	bit 5, [hl]
	res 5, [hl]
	push hl
	call nz, CeladonMartElevatorScript_4861c
	pop hl
	bit 7, [hl]
	res 7, [hl]
	call nz, CeladonMartElevatorScript_48654
	xor a
	ld [wAutoTextBoxDrawingControl], a
	inc a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ret

CeladonMartElevatorScript_4861c:
	ld hl, wWarpEntries
	ld a, [wWarpedFromWhichWarp]
	ld b, a
	ld a, [wWarpedFromWhichMap]
	ld c, a
	call CeladonMartElevatorScript_4862a

CeladonMartElevatorScript_4862a:
	inc hl
	inc hl
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ret

CeladonMartElevatorScript_48631:
	ld hl, CeladonMartElavatorFloors
	call LoadItemList
	ld hl, CeldaonMartElevatorWarpMaps
	ld de, wElevatorWarpMaps
	ld bc, CeldaonMartElevatorWarpMapsEnd - CeldaonMartElevatorWarpMaps
	jp CopyData

CeladonMartElavatorFloors:
	db $05 ; num elements in list
	db FLOOR_1F
	db FLOOR_2F
	db FLOOR_3F
	db FLOOR_4F
	db FLOOR_5F
	db $FF ; terminator

CeldaonMartElevatorWarpMaps:
; first byte is warp number
; second byte is map number
; These specify where the player goes after getting out of the elevator.
	db $05, CELADON_MART_1
	db $02, CELADON_MART_2
	db $02, CELADON_MART_3
	db $02, CELADON_MART_4
	db $02, CELADON_MART_5
CeldaonMartElevatorWarpMapsEnd:

CeladonMartElevatorScript_48654:
	jpba ShakeElevator

CeladonMartElevatorTextPointers:
	dw CeladonMartElevatorText1

CeladonMartElevatorText1:
	TX_ASM
	call CeladonMartElevatorScript_48631
	ld hl, CeldaonMartElevatorWarpMaps
	predef DisplayElevatorFloorMenu
	jp TextScriptEnd
