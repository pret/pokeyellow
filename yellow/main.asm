INCLUDE "charmap.asm"
INCLUDE "constants.asm"

NPC_SPRITES_1 EQU $4
NPC_SPRITES_2 EQU $5

GFX EQU $4

PICS_1 EQU $9
PICS_2 EQU $A
PICS_3 EQU $B
PICS_4 EQU $C
PICS_5 EQU $D


SECTION "home",ROM0

INCLUDE "home.asm"
SECTION "bank01",ROMX,BANK[$01]

INCLUDE "data/facing.asm"
INCLUDE "engine/battle/safari_zone.asm"
INCLUDE "engine/titlescreen.asm"

LoadMonData_: ; 442b (1:442b)
; Load monster [wWhichPokemon] from list [wMonDataLocation]:
;  0: partymon
;  1: enemymon
;  2: boxmon
;  3: daycaremon
; Return monster id at wcf91 and its data at wLoadedMon.
; Also load base stats at wMonHeader for convenience.

	ld a, [wDayCareMonSpecies]
	ld [wcf91], a
	ld a, [wMonDataLocation]
	cp DAYCARE_DATA
	jr z, .GetMonHeader

	ld a, [wWhichPokemon]
	ld e, a
	call GetMonSpecies
	
.GetMonHeader
	ld a, [wcf91]
	ld [wd0b5], a ; input for GetMonHeader
	call GetMonHeader

	ld hl, wPartyMons
	ld bc, wPartyMon2 - wPartyMon1
	ld a, [wMonDataLocation]
	cp ENEMY_PARTY_DATA
	jr c, .getMonEntry

	ld hl, wEnemyMons
	jr z, .getMonEntry

	cp 2
	ld hl, wBoxMons
	ld bc, wBoxMon2 - wBoxMon1
	jr z, .getMonEntry

	ld hl, wDayCareMon
	jr .copyMonData

.getMonEntry
	ld a, [wWhichPokemon]
	call AddNTimes

.copyMonData
	ld de, wLoadedMon
	ld bc, wPartyMon2 - wPartyMon1
	jp CopyData
	
; get species of mon e in list [wMonDataLocation] for LoadMonData
GetMonSpecies: ; 4478 (1:4478)
	ld hl, wPartySpecies
	ld a, [wMonDataLocation]
	and a
	jr z, .getSpecies
	dec a
	jr z, .enemyParty
	ld hl, wBoxSpecies
	jr .getSpecies
.enemyParty
	ld hl, wEnemyPartyMons
.getSpecies
	ld d, 0
	add hl, de
	ld a, [hl]
	ld [wcf91], a
	ret
	
INCLUDE "data/item_prices.asm"
INCLUDE "text/item_names.asm"

UnusedNames: ; 491e (1:491e)
	db "かみなりバッヂ@"
	db "かいがらバッヂ@"
	db "おじぞうバッヂ@"
	db "はやぶさバッヂ@"
	db "ひんやりバッヂ@"
	db "なかよしバッヂ@"
	db "バラバッヂ@"
	db "ひのたまバッヂ@"
	db "ゴールドバッヂ@"
	db "たまご@"
	db "ひよこ@"
	db "ブロンズ@"
	db "シルバー@"
	db "ゴールド@"
	db "プチキャプテン@"
	db "キャプテン@"
	db "プチマスター@"
	db "マスター@"
	db "エクセレント"

INCLUDE "engine/overworld/oam.asm"

PrintWaitingText: ; 4b89 (1:4b89)
	coord hl, 3, 10
	lb bc, 1, 11
	ld a, [wIsInBattle]
	and a
	jr z, .asm_4b9a
	call TextBoxBorder
	jr .asm_4b9d
.asm_4b9a
	call CableClub_TextBoxBorder
.asm_4b9d
	coord hl, 4, 11
	ld de, WaitingText
	call PlaceString
	ld c, 50
	jp DelayFrames

WaitingText: ; 4bab (1:4bab)
	db "Waiting...!@"
	
_UpdateSprites: ; 4bb7 (1:4bb7)
	ld h, wSpriteStateData1 / $100
	inc h
	ld a, $e    ; (wSpriteStateData2 + $0e) & $ff
.spriteLoop
	ld l, a
	sub $e
	ld c, a
	ld [H_CURRENTSPRITEOFFSET], a
	ld a, [hl]
	and a
	jr z, .skipSprite   ; tests $c2Xe
	push hl
	push de
	push bc
	call .updateCurrentSprite
	pop bc
	pop de
	pop hl
.skipSprite
	ld a, l
	add $10             ; move to next sprite
	cp $e               ; test for overflow (back at $0e)
	jr nz, .spriteLoop
	ret
.updateCurrentSprite ; 4bd7 (1:4bd7)
	ld a, [H_CURRENTSPRITEOFFSET]
	and a
	jp z, UpdatePlayerSprite
	cp $f0 ; pikachu
	jp z, Func_1552
	ld a, [hl]

UpdateNonPlayerSprite: ; 4be3 (1:4be3)
	dec a
	swap a
	ld [$ff93], a  ; $10 * sprite#
	ld a, [wNPCMovementScriptSpriteOffset] ; some sprite offset?
	ld b, a
	ld a, [H_CURRENTSPRITEOFFSET]
	cp b
	jr nz, .unequal
	jp DoScriptedNPCMovement
.unequal
	jp UpdateNPCSprite

; This detects if the current sprite (whose offset is at H_CURRENTSPRITEOFFSET)
; is going to collide with another sprite by looping over the other sprites.
; The current sprite's offset will be labelled with i (e.g. $c1i0).
; The loop sprite's offset will labelled with j (e.g. $c1j0).
;
; Note that the Y coordinate of the sprite (in [$c1k4]) is one of the following
; 9 values when the sprite is aligned with the grid: $fc, $0c, $1c, $2c, ..., $7c.
; The reason that 4 is added below to the coordinate is to make it align with a
; multiple of $10 to make comparisons easier.
DetectCollisionBetweenSprites: ; 4bf7 (1:4bf7)
	; nop
	
	ld h, wSpriteStateData1 / $100
	ld a, [H_CURRENTSPRITEOFFSET]
	ld l, a

	ld a, [hl] ; a = [$c1i0] (picture) (0 if slot is unused)
	and a ; is this sprite slot slot used?
	ret z ; return if not used

	ld a, l
	add 3
	ld l, a

	ld a, [hli] ; a = [$c1i3] (delta Y) (-1, 0, or 1)
	call SetSpriteCollisionValues

	ld a, [hli] ; a = [$C1i4] (Y screen coordinate)
	add 4 ; align with multiple of $10

; The effect of the following 3 lines is to
; add 7 to a if moving south or
; subtract 7 from a if moving north.
	add b
	and $f0
	or c

	ld [$ff90], a ; store Y coordinate adjusted for direction of movement

	ld a, [hli] ; a = [$c1i5] (delta X) (-1, 0, or 1)
	call SetSpriteCollisionValues
	ld a, [hl] ; a = [$C1i6] (X screen coordinate)

; The effect of the following 3 lines is to
; add 7 to a if moving east or
; subtract 7 from a if moving west.
	add b
	and $f0
	or c

	ld [$ff91], a ; store X coordinate adjusted for direction of movement

	ld a, l
	add 7
	ld l, a

	xor a
	ld [hld], a ; zero [$c1id] XXX what's [$c1id] for?
	ld [hld], a ; zero [$c1ic] (directions in which collisions occurred)

	ld a, [$ff91]
	ld [hld], a ; [$c1ib] = adjusted X coordinate
	ld a, [$ff90]
	ld [hl], a ; [$c1ia] = adjusted Y coordinate

	xor a ; zero the loop counter

.loop
	ld [$ff8f], a ; store loop counter
	swap a
	ld e, a
	ld a, [H_CURRENTSPRITEOFFSET]
	cp e ; does the loop sprite match the current sprite?
	jp z, .next ; go to the next sprite if they match

	ld d, h
	ld a, [de] ; a = [$c1j0] (picture) (0 if slot is unused)
	and a ; is this sprite slot slot used?
	jp z, .next ; go the next sprite if not used

	inc e
	inc e
	ld a, [de] ; a = [$c1j2] ($ff means the sprite is offscreen)
	inc a
	jp z, .next ; go the next sprite if offscreen

	ld a, [H_CURRENTSPRITEOFFSET]
	add 10
	ld l, a

	inc e
	ld a, [de] ; a = [$c1j3] (delta Y)
	call SetSpriteCollisionValues

	inc e
	ld a, [de] ; a = [$C1j4] (Y screen coordinate)
	add 4 ; align with multiple of $10

; The effect of the following 3 lines is to
; add 7 to a if moving south or
; subtract 7 from a if moving north.
	add b
	and $f0
	or c

	sub [hl] ; subtract the adjusted Y coordinate of sprite i ([$c1ia]) from that of sprite j

; calculate the absolute value of the difference to get the distance
	jr nc, .noCarry1
	cpl
	inc a
.noCarry1
	ld [$ff90], a ; store the distance between the two sprites' adjusted Y values

; Use the carry flag set by the above subtraction to determine which sprite's
; Y coordinate is larger. This information is used later to set [$c1ic],
; which stores which direction the collision occurred in.
; The following 5 lines set the lowest 2 bits of c, which are later shifted left by 2.
; If sprite i's Y is larger, set lowest 2 bits of c to 10.
; If sprite j's Y is larger or both are equal, set lowest 2 bits of c to 01.
	push af
	rl c
	pop af
	ccf
	rl c

; If sprite i's delta Y is 0, then b = 7, else b = 9.
	ld b, 7
	ld a, [hl] ; a = [$c1ia] (adjusted Y coordinate)
	and $f
	jr z, .next1
	ld b, 9

.next1
	ld a, [$ff90] ; a = distance between adjusted Y coordinates
	sub b
	ld [$ff92], a ; store distance adjusted using sprite i's direction
	ld a, b
	ld [$ff90], a ; store 7 or 9 depending on sprite i's delta Y
	jr c, .checkXDistance

; If sprite j's delta Y is 0, then b = 7, else b = 9.
	ld b, 7
	dec e
	ld a, [de] ; a = [$c1j3] (delta Y)
	inc e
	and a
	jr z, .next2
	ld b, 9

.next2
	ld a, [$ff92] ; a = distance adjusted using sprite i's direction
	sub b ; adjust distance using sprite j's direction
	jr z, .checkXDistance
	jr nc, .next ; go to next sprite if distance is still positive after both adjustments

.checkXDistance
	inc e
	inc l
	ld a, [de] ; a = [$c1j5] (delta X)

	push bc

	call SetSpriteCollisionValues
	inc e
	ld a, [de] ; a = [$c1j6] (X screen coordinate)

; The effect of the following 3 lines is to
; add 7 to a if moving east or
; subtract 7 from a if moving west.
	add b
	and $f0
	or c

	pop bc

	sub [hl] ; subtract the adjusted X coordinate of sprite i ([$c1ib]) from that of sprite j

; calculate the absolute value of the difference to get the distance
	jr nc, .noCarry2
	cpl
	inc a
.noCarry2
	ld [$ff91], a ; store the distance between the two sprites' adjusted X values

; Use the carry flag set by the above subtraction to determine which sprite's
; X coordinate is larger. This information is used later to set [$c1ic],
; which stores which direction the collision occurred in.
; The following 5 lines set the lowest 2 bits of c.
; If sprite i's X is larger, set lowest 2 bits of c to 10.
; If sprite j's X is larger or both are equal, set lowest 2 bits of c to 01.
	push af
	rl c
	pop af
	ccf
	rl c

; If sprite i's delta X is 0, then b = 7, else b = 9.
	ld b, 7
	ld a, [hl] ; a = [$c1ib] (adjusted X coordinate)
	and $f
	jr z, .next3
	ld b, 9

.next3
	ld a, [$ff91] ; a = distance between adjusted X coordinates
	sub b
	ld [$ff92], a ; store distance adjusted using sprite i's direction
	ld a, b
	ld [$ff91], a ; store 7 or 9 depending on sprite i's delta X
	jr c, .collision

; If sprite j's delta X is 0, then b = 7, else b = 9.
	ld b, 7
	dec e
	ld a, [de] ; a = [$c1j5] (delta X)
	inc e
	and a
	jr z, .next4
	ld b, 9

.next4
	ld a, [$ff92] ; a = distance adjusted using sprite i's direction
	sub b ; adjust distance using sprite j's direction
	jr z, .collision
	jr nc, .next ; go to next sprite if distance is still positive after both adjustments

.collision
	ld a, l
	and $f0 ; collision with pikachu?
	jr nz, .asm_4cd9
	xor a
	ld [wd434], a
	ld a, [$ff8f]
	cp $f
	jr nz, .asm_4cd9
	call Func_4d0a
	jr .asm_4cef
.asm_4cd9
	ld a, [$ff91] ; a = 7 or 9 depending on sprite i's delta X
	ld b, a
	ld a, [$ff90] ; a = 7 or 9 depending on sprite i's delta Y
	inc l

; If delta X isn't 0 and delta Y is 0, then b = %0011, else b = %1100.
; (note that normally if delta X isn't 0, then delta Y must be 0 and vice versa)
	cp b
	jr c, .next5
	ld b, %1100
	jr .next6
.next5
	ld b, %0011

.next6
	ld a, c ; c has 2 bits set (one of bits 0-1 is set for the X axis and one of bits 2-3 for the Y axis)
	and b ; we select either the bit in bits 0-1 or bits 2-3 based on the calculation immediately above
	or [hl] ; or with existing collision direction bits in [$c1ic]
	ld [hl], a ; store new value
	ld a, c ; useless code because a is overwritten before being used again

; set bit in [$c1ie] or [$c1if] to indicate which sprite the collision occurred with
	inc l
	inc l
.asm_4cef
	ld a, [$ff8f] ; a = loop counter
	ld de, SpriteCollisionBitTable
	add a
	add e
	ld e, a
	jr nc, .noCarry3
	inc d
.noCarry3
	ld a, [de]
	or [hl]
	ld [hli], a
	inc de
	ld a, [de]
	or [hl]
	ld [hl], a

.next
	ld a, [$ff8f] ; a = loop counter
	inc a
	cp $10
	jp nz, .loop
	ret

; takes delta X or delta Y in a
; b = delta X/Y
; c = 0 if delta X/Y is 0
; c = 7 if delta X/Y is 1
; c = 9 if delta X/Y is -1
Func_4d0a: ; 4d0a (1:4d0a)
	ld a, [$ff91]
	ld b, a
	ld a, [$ff90]
	inc l
	cp b
	jr c, .asm_4d17
	ld b, %1100
	jr .asm_4d19
.asm_4d17
	ld b, %11
.asm_4d19
	ld a, c
	and b
	ld [wd434], a
	ld a, c
	inc l
	inc l
	ret
	
SetSpriteCollisionValues: ; 4d22 (1:4d22)
	and a
	ld b, 0
	ld c, 0
	jr z, .done
	ld c, 9
	cp -1
	jr z, .ok
	ld c, 7
	ld a, 0
.ok
	ld b, a
.done
	ret

SpriteCollisionBitTable: ; 4d35 (1:4d35)
	db %00000000,%00000001
	db %00000000,%00000010
	db %00000000,%00000100
	db %00000000,%00001000
	db %00000000,%00010000
	db %00000000,%00100000
	db %00000000,%01000000
	db %00000000,%10000000
	db %00000001,%00000000
	db %00000010,%00000000
	db %00000100,%00000000
	db %00001000,%00000000
	db %00010000,%00000000
	db %00100000,%00000000
	db %01000000,%00000000
	db %10000000,%00000000
	
INCLUDE "engine/overworld/item.asm"
INCLUDE "engine/overworld/movement.asm"

INCLUDE "engine/cable_club.asm"

LoadTrainerInfoTextBoxTiles: ; 5b9a (1:5b9a)
	ld de, TrainerInfoTextBoxTileGraphics
	ld hl, vChars2 + $760
	lb bc, BANK(TrainerInfoTextBoxTileGraphics), (TrainerInfoTextBoxTileGraphicsEnd - TrainerInfoTextBoxTileGraphics) / $10
	jp CopyVideoData
	
INCLUDE "engine/menu/main_menu.asm"

INCLUDE "engine/oak_speech.asm"

SpecialWarpIn: ; 6042 (1:6042)
	call LoadSpecialWarpData
	predef LoadTilesetHeader
	ld hl,wd732
	bit 2,[hl] ; dungeon warp or fly warp?
	res 2,[hl]
	jr z,.next
; if dungeon warp or fly warp
	ld a,[wDestinationMap]
	jr .next2
.next
	bit 1,[hl]
	jr z,.next3
	call EmptyFunc
.next3
	ld a,0
.next2
	ld b,a
	ld a,[wd72d]
	and a
	jr nz,.next4
	ld a,b
.next4
	ld hl,wd732
	bit 4,[hl] ; dungeon warp?
	ret nz
; if not dungeon warp
	ld [wLastMap],a
	ret

; gets the map ID, tile block map view pointer, tileset, and coordinates
LoadSpecialWarpData: ; 6073 (1:6073)
	ld a, [wd72d]
	cp TRADE_CENTER
	jr nz, .notTradeCenter
	ld hl, TradeCenterSpec1
	ld a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK ; which gameboy is clocking determines who is on the left and who is on the right
	jr z, .copyWarpData
	ld hl, TradeCenterSpec2
	jr .copyWarpData
.notTradeCenter
	cp COLOSSEUM
	jr nz, .notColosseum
	ld hl, ColosseumSpec1
	ld a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr z, .copyWarpData
	ld hl, ColosseumSpec2
	jr .copyWarpData
.notColosseum
	ld a, [wd732]
	bit 1, a
	jr nz, .notFirstMap
	bit 2, a
	jr nz, .notFirstMap
	ld hl, FirstMapSpec
.copyWarpData
	ld de, wCurMap
	ld c, $7
.copyWarpDataLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copyWarpDataLoop
	ld a, [hli]
	ld [wCurMapTileset], a
	xor a
	jr .done
.notFirstMap
	ld a, [wLastMap]
	ld hl, wd732
	bit 4, [hl] ; used dungeon warp (jumped down hole/waterfall)?
	jr nz, .usedDunegonWarp
	bit 6, [hl] ; return to last pokemon center (or player's house)?
	res 6, [hl]
	jr z, .otherDestination
; return to last pokemon center or player's house
	ld a, [wLastBlackoutMap]
	jr .usedFlyWarp
.usedDunegonWarp
	ld hl, wd72d
	res 4, [hl]
	ld a, [wDungeonWarpDestinationMap]
	ld b, a
	ld [wCurMap], a
	ld a, [wWhichDungeonWarp]
	ld c, a
	ld hl, DungeonWarpList
	ld de, 0
	ld a, 6
	ld [wDungeonWarpDataEntrySize], a
.dungeonWarpListLoop
	ld a, [hli]
	cp b
	jr z, .matchedDungeonWarpDestinationMap
	inc hl
	jr .nextDungeonWarp
.matchedDungeonWarpDestinationMap
	ld a, [hli]
	cp c
	jr z, .matchedDungeonWarpID
.nextDungeonWarp
	ld a, [wDungeonWarpDataEntrySize]
	add e
	ld e, a
	jr .dungeonWarpListLoop
.matchedDungeonWarpID
	ld hl, DungeonWarpData
	add hl, de
	jr .copyWarpData2
.otherDestination
	ld a, [wDestinationMap]
.usedFlyWarp
	ld b, a
	ld [wCurMap], a
	ld hl, FlyWarpDataPtr
.flyWarpDataPtrLoop
	ld a, [hli]
	inc hl
	cp b
	jr z, .foundFlyWarpMatch
	inc hl
	inc hl
	jr .flyWarpDataPtrLoop
.foundFlyWarpMatch
	ld a, [hli]
	ld h, [hl]
	ld l, a
.copyWarpData2
	ld de, wCurrentTileBlockMapViewPointer
	ld c, $6
.copyWarpDataLoop2
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copyWarpDataLoop2
	xor a ; OVERWORLD
	ld [wCurMapTileset], a
.done
	ld [wYOffsetSinceLastSpecialWarp], a
	ld [wXOffsetSinceLastSpecialWarp], a
	ld a, $ff ; the player's coordinates have already been updated using a special warp, so don't use any of the normal warps
	ld [wDestinationWarpID], a
	ret
	
INCLUDE "data/special_warps.asm"
; not IshiharaTeam
SetDebugTeam: ; 623e (1:623e)
	ld de, DebugTeam
.loop
	ld a, [de]
	cp $ff
	ret z
	ld [wcf91], a
	inc de
	ld a, [de]
	ld [wCurEnemyLVL], a
	inc de
	call AddPartyMon
	jr .loop

DebugTeam: ; 6253 (1:6253)
	db SNORLAX,80
	db PERSIAN,80
	db JIGGLYPUFF,15
	db PIKACHU,5
	db $FF

EmptyFunc: ; 64ea (1:64ea)
	ret

INCLUDE "engine/menu/naming_screen.asm"

INCLUDE "engine/oak_speech2.asm"

; subtracts the amount the player paid from their money
; sets carry flag if there is enough money and unsets carry flag if not
SubtractAmountPaidFromMoney_: ; 68a6 (1:68a6)
	ld de, wPlayerMoney
	ld hl, hMoney ; total price of items
	ld c, 3 ; length of money in bytes
	call StringCmp
	ret c
	ld de, wPlayerMoney + 2
	ld hl, hMoney + 2 ; total price of items
	ld c, 3 ; length of money in bytes
	predef SubBCDPredef ; subtract total price from money
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID ; redraw money text box
	and a
	ret

HandleItemListSwapping: ; 68c9 (1:68c9)
	ld a,[wListMenuID]
	cp a,ITEMLISTMENU
	jp nz,DisplayListMenuIDLoop ; only rearrange item list menus
	push hl
	ld hl,wListPointer
	ld a,[hli]
	ld h,[hl]
	ld l,a
	inc hl ; hl = beginning of list entries
	ld a,[wCurrentMenuItem]
	ld b,a
	ld a,[wListScrollOffset]
	add b
	add a
	ld c,a
	ld b,0
	add hl,bc ; hl = address of currently selected item entry
	ld a,[hl]
	pop hl
	inc a
	jp z,DisplayListMenuIDLoop ; ignore attempts to swap the Cancel menu item
	ld a,[wMenuItemToSwap] ; ID of item chosen for swapping (counts from 1)
	and a ; has the first item to swap already been chosen?
	jr nz,.swapItems
; if not, set the currently selected item as the first item
	ld a,[wCurrentMenuItem]
	inc a
	ld b,a
	ld a,[wListScrollOffset] ; index of top (visible) menu item within the list
	add b
	ld [wMenuItemToSwap],a ; ID of item chosen for swapping (counts from 1)
	ld c,20
	call DelayFrames
	jp DisplayListMenuIDLoop
.swapItems
	ld a,[wCurrentMenuItem]
	inc a
	ld b,a
	ld a,[wListScrollOffset]
	add b
	ld b,a
	ld a,[wMenuItemToSwap] ; ID of item chosen for swapping (counts from 1)
	cp b ; is the currently selected item the same as the first item to swap?
	jp z,DisplayListMenuIDLoop ; ignore attempts to swap an item with itself
	dec a
	ld [wMenuItemToSwap],a ; ID of item chosen for swapping (counts from 1)
	ld c,20
	call DelayFrames
	push hl
	push de
	ld hl,wListPointer
	ld a,[hli]
	ld h,[hl]
	ld l,a
	inc hl ; hl = beginning of list entries
	ld d,h
	ld e,l ; de = beginning of list entries
	ld a,[wCurrentMenuItem]
	ld b,a
	ld a,[wListScrollOffset]
	add b
	add a
	ld c,a
	ld b,0
	add hl,bc ; hl = address of currently selected item entry
	ld a,[wMenuItemToSwap] ; ID of item chosen for swapping (counts from 1)
	add a
	add e
	ld e,a
	jr nc,.noCarry
	inc d
.noCarry ; de = address of first item to swap
	ld a,[de]
	ld b,a
	ld a,[hli]
	cp b
	jr z,.swapSameItemType
.swapDifferentItems
	ld [$ff95],a ; [$ff95] = second item ID
	ld a,[hld]
	ld [$ff96],a ; [$ff96] = second item quantity
	ld a,[de]
	ld [hli],a ; put first item ID in second item slot
	inc de
	ld a,[de]
	ld [hl],a ; put first item quantity in second item slot
	ld a,[$ff96]
	ld [de],a ; put second item quantity in first item slot
	dec de
	ld a,[$ff95]
	ld [de],a ; put second item ID in first item slot
	xor a
	ld [wMenuItemToSwap],a ; 0 means no item is currently being swapped
	pop de
	pop hl
	jp DisplayListMenuIDLoop
.swapSameItemType
	inc de
	ld a,[hl]
	ld b,a
	ld a,[de]
	add b ; a = sum of both item quantities
	cp a,100 ; is the sum too big for one item slot?
	jr c,.combineItemSlots
; swap enough items from the first slot to max out the second slot if they can't be combined
	sub a,99
	ld [de],a
	ld a,99
	ld [hl],a
	jr .done
.combineItemSlots
	ld [hl],a ; put the sum in the second item slot
	ld hl,wListPointer
	ld a,[hli]
	ld h,[hl]
	ld l,a
	dec [hl] ; decrease the number of items
	ld a,[hl]
	ld [wListCount],a ; update number of items variable
	cp a,1
	jr nz,.skipSettingMaxMenuItemID
	ld [wMaxMenuItem],a ; if the number of items is only one now, update the max menu item ID
.skipSettingMaxMenuItemID
	dec de
	ld h,d
	ld l,e
	inc hl
	inc hl ; hl = address of item after first item to swap
.moveItemsUpLoop ; erase the first item slot and move up all the following item slots to fill the gap
	ld a,[hli]
	ld [de],a
	inc de
	inc a ; reached the $ff terminator?
	jr z,.afterMovingItemsUp
	ld a,[hli]
	ld [de],a
	inc de
	jr .moveItemsUpLoop
.afterMovingItemsUp
	xor a
	ld [wListScrollOffset],a
	ld [wCurrentMenuItem],a
.done
	xor a
	ld [wMenuItemToSwap],a ; 0 means no item is currently being swapped
	pop de
	pop hl
	jp DisplayListMenuIDLoop

INCLUDE "engine/overworld/pokemart.asm"
INCLUDE "engine/learn_move.asm"
INCLUDE "engine/overworld/pokecenter.asm"

SetLastBlackoutMap: ; 6ef0 (1:6ef0)
; Set the map to return to when
; blacking out or using Teleport or Dig.
; Safari rest houses don't count.

	push hl
	ld hl, SafariZoneRestHouses
	ld a, [wCurMap]
	ld b, a
.loop
	ld a, [hli]
	cp -1
	jr z, .notresthouse
	cp b
	jr nz, .loop
	jr .done

.notresthouse
	ld a, [wLastMap]
	ld [wLastBlackoutMap], a
.done
	pop hl
	ret

SafariZoneRestHouses: ; 6f0a (1:6f0a)
	db SAFARI_ZONE_REST_HOUSE_2
	db SAFARI_ZONE_REST_HOUSE_3
	db SAFARI_ZONE_REST_HOUSE_4
	db -1

; function that performs initialization for DisplayTextID
DisplayTextIDInit: ; 6f0e (1:6f0e)
	xor a
	ld [wListMenuID],a
	ld a,[wAutoTextBoxDrawingControl]
	bit 0,a
	jr nz,.skipDrawingTextBoxBorder
	ld a,[hSpriteIndexOrTextID] ; text ID (or sprite ID)
	and a
	jr nz,.notStartMenu
; if text ID is 0 (i.e. the start menu)
; Note that the start menu text border is also drawn in the function directly
; below this, so this seems unnecessary.
	CheckEvent EVENT_GOT_POKEDEX
; start menu with pokedex
	coord hl, 10, 0
	lb bc, 14, 8
	jr nz,.drawTextBoxBorder
; start menu without pokedex
	coord hl, 10, 0
	lb bc, 12, 8
	jr .drawTextBoxBorder
; if text ID is not 0 (i.e. not the start menu) then do a standard dialogue text box
.notStartMenu
	coord hl, 0, 12
	lb bc, 4, 18
.drawTextBoxBorder
	call TextBoxBorder
.skipDrawingTextBoxBorder
	ld hl,wFontLoaded
	set 0,[hl]
	ld hl,wFlags_0xcd60
	bit 4,[hl]
	res 4,[hl]
	jr nz,.skipMovingSprites
	call UpdateSprites
.skipMovingSprites
; loop to copy C1X9 (direction the sprite is facing) to C2X9 for each sprite
; this is done because when you talk to an NPC, they turn to look your way
; the original direction they were facing must be restored after the dialogue is over
	ld hl,wSpriteStateData1 + $19
	ld c,$0f
	ld de,$0010
.spriteFacingDirectionCopyLoop
	ld a,[hl]
	inc h
	ld [hl],a
	dec h
	add hl,de
	dec c
	jr nz,.spriteFacingDirectionCopyLoop
; loop to force all the sprites in the middle of animation to stand still
; (so that they don't like they're frozen mid-step during the dialogue)
	ld hl,wSpriteStateData1 + 2
	ld de,$0010
	ld c,e
.spriteStandStillLoop
	ld a,[hl]
	cp a,$ff ; is the sprite visible?
	jr z,.nextSprite
; if it is visible
	and a,$fc
	ld [hl],a
.nextSprite
	add hl,de
	dec c
	jr nz,.spriteStandStillLoop
	ld b,vBGMap1 / $100 ; window background address
	call CopyScreenTileBufferToVRAM ; transfer background in WRAM to VRAM
	xor a
	ld [hWY],a ; put the window on the screen
	call LoadFontTilePatterns
	ld a,$01
	ld [H_AUTOBGTRANSFERENABLED],a ; enable continuous WRAM to VRAM transfer each V-blank
	ret

; function that displays the start menu
DrawStartMenu: ; 6f80 (1:6f80)
	CheckEvent EVENT_GOT_POKEDEX
; menu with pokedex
	coord hl, 10, 0
	lb bc, 14, 8
	jr nz,.drawTextBoxBorder
; shorter menu if the player doesn't have the pokedex
	coord hl, 10, 0
	lb bc, 12, 8
.drawTextBoxBorder
	call TextBoxBorder
	ld a,D_DOWN | D_UP | START | B_BUTTON | A_BUTTON
	ld [wMenuWatchedKeys],a
	ld a,$02
	ld [wTopMenuItemY],a ; Y position of first menu choice
	ld a,$0b
	ld [wTopMenuItemX],a ; X position of first menu choice
	ld a,[wBattleAndStartSavedMenuItem] ; remembered menu selection from last time
	ld [wCurrentMenuItem],a
	ld [wLastMenuItem],a
	xor a
	ld [wMenuWatchMovingOutOfBounds],a
	ld hl,wd730
	set 6,[hl] ; no pauses between printing each letter
	coord hl, 12, 2
	CheckEvent EVENT_GOT_POKEDEX
; case for not having pokdex
	ld a,$06
	jr z,.storeMenuItemCount
; case for having pokedex
	ld de,StartMenuPokedexText
	call PrintStartMenuItem
	ld a,$07
.storeMenuItemCount
	ld [wMaxMenuItem],a ; number of menu items
	ld de,StartMenuPokemonText
	call PrintStartMenuItem
	ld de,StartMenuItemText
	call PrintStartMenuItem
	ld de,wPlayerName ; player's name
	call PrintStartMenuItem
	ld a,[wd72e]
	bit 6,a ; is the player using the link feature?
; case for not using link feature
	ld de,StartMenuSaveText
	jr z,.printSaveOrResetText
; case for using link feature
	ld de,StartMenuResetText
.printSaveOrResetText
	call PrintStartMenuItem
	ld de,StartMenuOptionText
	call PrintStartMenuItem
	ld de,StartMenuExitText
	call PlaceString
	ld hl,wd730
	res 6,[hl] ; turn pauses between printing letters back on
	ret

StartMenuPokedexText: ; 7002 (1:7002)
	db "POKéDEX@"

StartMenuPokemonText: ; 700a (1:700a)
	db "#MON@"

StartMenuItemText: ; 700f (1:700f)
	db "ITEM@"

StartMenuSaveText: ; 7014 (1:7014)
	db "SAVE@"

StartMenuResetText: ; 7019 (1:7019)
	db "RESET@"

StartMenuExitText: ; 701f (1:701f)
	db "EXIT@"

StartMenuOptionText: ; 7024 (1:7024)
	db "OPTION@"

PrintStartMenuItem: ; 702b (1:702b)
	push hl
	call PlaceString
	pop hl
	ld de,SCREEN_WIDTH * 2
	add hl,de
	ret

INCLUDE "engine/overworld/cable_club_npc.asm"

INCLUDE "engine/text_boxes.asm"
INCLUDE "engine/battle/moveEffects/drain_hp_effect.asm"

INCLUDE "engine/menu/players_pc.asm"

_RemovePokemon: ; 7a0f (1:7a0f)
	ld hl, wPartyCount
	ld a, [wRemoveMonFromBox]
	and a
	jr z, .usePartyCount
	ld hl, wNumInBox
.usePartyCount
	ld a, [hl]
	dec a
	ld [hli], a
	ld a, [wWhichPokemon]
	ld c, a
	ld b, $0
	add hl, bc
	ld e, l
	ld d, h
	inc de
.shiftMonSpeciesLoop
	ld a, [de]
	inc de
	ld [hli], a
	inc a ; reached terminator?
	jr nz, .shiftMonSpeciesLoop ; if not, continue shifting species
	ld hl, wPartyMonOT
	ld d, PARTY_LENGTH - 1 ; max number of pokemon to shift
	ld a, [wRemoveMonFromBox]
	and a
	jr z, .usePartyMonOTs
	ld hl, wBoxMonOT
	ld d, MONS_PER_BOX - 1
.usePartyMonOTs
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
	ld a, [wWhichPokemon]
	cp d ; are we removing the last pokemon?
	jr nz, .notRemovingLastMon ; if not, shift the pokemon below
	ld [hl], $ff ; else, write the terminator and return
	ret
.notRemovingLastMon
	ld d, h
	ld e, l
	ld bc, NAME_LENGTH
	add hl, bc
	ld bc, wPartyMonNicks
	ld a, [wRemoveMonFromBox]
	and a
	jr z, .usePartyMonNicks
	ld bc, wBoxMonNicks
.usePartyMonNicks
	call CopyDataUntil
	ld hl, wPartyMons
	ld bc, wPartyMon2 - wPartyMon1
	ld a, [wRemoveMonFromBox]
	and a
	jr z, .usePartyMonStructs
	ld hl, wBoxMons
	ld bc, wBoxMon2 - wBoxMon1
.usePartyMonStructs
	ld a, [wWhichPokemon]
	call AddNTimes ; get address of the pokemon removed
	ld d, h ; store in de for CopyDataUntil
	ld e, l
	ld a, [wRemoveMonFromBox]
	and a
	jr z, .copyUntilPartyMonOTs
	ld bc, wBoxMon2 - wBoxMon1
	add hl, bc ; get address of pokemon after the pokemon removed
	ld bc, wBoxMonOT ; address of when to stop copying
	jr .continue
.copyUntilPartyMonOTs
	ld bc, wPartyMon2 - wPartyMon1
	add hl, bc ; get address of pokemon after the pokemon removed
	ld bc, wPartyMonOT ; address of when to stop copying
.continue
	call CopyDataUntil ; shift all pokemon data after the removed mon to the removed mon's location
	ld hl, wPartyMonNicks
	ld a, [wRemoveMonFromBox]
	and a
	jr z, .usePartyMonNicks2
	ld hl, wBoxMonNicks
.usePartyMonNicks2
	ld bc, NAME_LENGTH
	ld a, [wWhichPokemon]
	call AddNTimes
	ld d, h
	ld e, l
	ld bc, NAME_LENGTH
	add hl, bc
	ld bc, wPartyMonNicksEnd
	ld a, [wRemoveMonFromBox]
	and a
	jr z, .copyUntilPartyMonNicksEnd
	ld bc, wBoxMonNicksEnd
.copyUntilPartyMonNicksEnd
	jp CopyDataUntil

_DisplayPokedex: ; 7abf (1:7abf)
	ld hl, wd730
	set 6, [hl]
	predef ShowPokedexData
	ld hl, wd730
	res 6, [hl]
	call ReloadMapData
	ld c, 10
	call DelayFrames
	predef IndexToPokedex
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, FLAG_SET
	ld hl, wPokedexSeen
	predef FlagActionPredef
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ret
	
SECTION "bank03",ROMX,BANK[$03]

INCLUDE "engine/joypad.asm"

ClearVariablesAfterLoadingMapData: ; c07c (3:407c)
	ld a, $90
	ld [hWY], a
	ld [rWY], a
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld [wStepCounter], a
	ld [wLoneAttackNo], a ; wGymLeaderNo
	ld [hJoyPressed], a
	ld [hJoyReleased], a
	ld [hJoyHeld], a
	ld [wActionResultOrTookBattleTurn], a
	ld [wUnusedD5A3], a
	ld hl, wCardKeyDoorY
	ld [hli], a
	ld [hl], a
	ld hl, wWhichTrade
	ld bc, $1e
	call FillMemory
	ret

; only used for setting bit 2 of wd736 upon entering a new map
IsPlayerStandingOnWarp: ; c0a6 (3:40a6)
	ld a, [wNumberOfWarps]
	and a
	ret z
	ld c, a
	ld hl, wWarpEntries
.loop
	ld a, [wYCoord]
	cp [hl]
	jr nz, .nextWarp1
	inc hl
	ld a, [wXCoord]
	cp [hl]
	jr nz, .nextWarp2
	inc hl
	ld a, [hli] ; target warp
	ld [wDestinationWarpID], a
	ld a, [hl] ; target map
	ld [$ff8b], a
	ld hl, wd736
	set 2, [hl] ; standing on warp flag
	ret
.nextWarp1
	inc hl
.nextWarp2
	inc hl
	inc hl
	inc hl
	dec c
	jr nz, .loop
	ret

CheckForceBikeOrSurf: ; c0d2 (3:40d2)
	ld hl, wd732
	bit 5, [hl]
	ret nz
	ld hl, ForcedBikeOrSurfMaps
	ld a, [wYCoord]
	ld b, a
	ld a, [wXCoord]
	ld c, a
	ld a, [wCurMap]
	ld d, a
.loop
	ld a, [hli]
	cp $ff
	ret z ;if we reach FF then it's not part of the list
	cp d ;compare to current map
	jr nz, .incorrectMap
	ld a, [hli]
	cp b ;compare y-coord
	jr nz, .incorrectY
	ld a, [hli]
	cp c ;compare x-coord
	jr nz, .loop ; incorrect x-coord, check next item
	ld a, [wCurMap]
	cp SEAFOAM_ISLANDS_4
	ld a, $2
	ld [wSeafoamIslands4CurScript], a
	jr z, .forceSurfing
	ld a, [wCurMap]
	cp SEAFOAM_ISLANDS_5
	ld a, $2
	ld [wSeafoamIslands5CurScript], a
	jr z, .forceSurfing
	;force bike riding
	ld hl, wd732
	set 5, [hl]
	ld a, $1
	ld [wWalkBikeSurfState], a
	ld [wWalkBikeSurfStateCopy], a
	call ForceBikeOrSurf
	ret
.incorrectMap
	inc hl
.incorrectY
	inc hl
	jr .loop
.forceSurfing
	ld a, $2
	ld [wWalkBikeSurfState], a
	ld [wWalkBikeSurfStateCopy], a
	call ForceBikeOrSurf
	ret
	
INCLUDE "data/force_bike_surf.asm"

IsPlayerFacingEdgeOfMap: ; c148 (3:4148)
	push hl
	push de
	push bc
	ld a, [wSpriteStateData1 + 9] ; player sprite's facing direction
	srl a
	ld c, a
	ld b, $0
	ld hl, .functionPointerTable
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wYCoord]
	ld b, a
	ld a, [wXCoord]
	ld c, a
	ld de, .returnaddress
	push de
	jp [hl]
.returnaddress
	pop bc
	pop de
	pop hl
	ret

.functionPointerTable
	dw .facingDown
	dw .facingUp
	dw .facingLeft
	dw .facingRight

.facingDown
	ld a, [wCurMapHeight]
	add a
	dec a
	cp b
	jr z, .setCarry
	jr .resetCarry

.facingUp
	ld a, b
	and a
	jr z, .setCarry
	jr .resetCarry

.facingLeft
	ld a, c
	and a
	jr z, .setCarry
	jr .resetCarry

.facingRight
	ld a, [wCurMapWidth]
	add a
	dec a
	cp c
	jr z, .setCarry
	jr .resetCarry
.resetCarry
	and a
	ret
.setCarry
	scf
	ret

IsWarpTileInFrontOfPlayer: ; c197 (3:4197)
	push hl
	push de
	push bc
	call _GetTileAndCoordsInFrontOfPlayer
	ld a, [wCurMap]
	cp SS_ANNE_5
	jr z, .ssAnne5
	ld a, [wSpriteStateData1 + 9] ; player sprite's facing direction
	srl a
	ld c, a
	ld b, 0
	ld hl, .warpTileListPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wTileInFrontOfPlayer]
	ld de, $1
	call IsInArray
.done
	pop bc
	pop de
	pop hl
	ret

.warpTileListPointers: ; c1c0 (3:41c0)
	dw .facingDownWarpTiles
	dw .facingUpWarpTiles
	dw .facingLeftWarpTiles
	dw .facingRightWarpTiles

.facingDownWarpTiles
	db $01,$12,$17,$3D,$04,$18,$33,$FF

.facingUpWarpTiles
	db $01,$5C,$FF

.facingLeftWarpTiles
	db $1A,$4B,$FF

.facingRightWarpTiles
	db $0F,$4E,$FF

.ssAnne5
	ld a, [wTileInFrontOfPlayer]
	cp $15
	jr nz, .notSSAnne5Warp
	scf
	jr .done
.notSSAnne5Warp
	and a
	jr .done

IsPlayerStandingOnDoorTileOrWarpTile: ; c1e6 (3:41e6)
	push hl
	push de
	push bc
	callba IsPlayerStandingOnDoorTile ; 6:6785
	jr c, .done
	ld a, [wCurMapTileset]
	add a
	ld c, a
	ld b, $0
	ld hl, WarpTileIDPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $1
	aCoord 8, 9
	call IsInArray
	jr nc, .done
	ld hl, wd736
	res 2, [hl]
.done
	pop bc
	pop de
	pop hl
	ret

INCLUDE "data/warp_tile_ids.asm"

PrintSafariZoneSteps: ; c27b (3:427b)
	ld a, [wCurMap]
	cp SAFARI_ZONE_EAST
	ret c
	cp UNKNOWN_DUNGEON_2
	ret nc
	coord hl, 0, 0
	lb bc, 3, 7
	call TextBoxBorder
	coord hl, 1, 1
	ld de, wSafariSteps
	lb bc, 2, 3
	call PrintNumber
	coord hl, 4, 1
	ld de, SafariSteps
	call PlaceString
	coord hl, 1, 3
	ld de, SafariBallText
	call PlaceString
	ld a, [wNumSafariBalls]
	cp 10
	jr nc, .numSafariBallsTwoDigits
	coord hl, 5, 3
	ld a, " "
	ld [hl], a
.numSafariBallsTwoDigits
	coord hl, 6, 3
	ld de, wNumSafariBalls
	lb bc, 1, 2
	jp PrintNumber

SafariSteps: ; c2c4 (3:42c4)
	db "/500@"

SafariBallText: ; c5c9 (3:42c9)
	db "BALL×× @"

GetTileAndCoordsInFrontOfPlayer: ; c2d4 (3:42d1)
	call GetPredefRegisters
	
_GetTileAndCoordsInFrontOfPlayer: ; c2d4 (3:42d4)
	ld a, [wYCoord]
	ld d, a
	ld a, [wXCoord]
	ld e, a
	ld a, [wSpriteStateData1 + 9] ; player's sprite facing direction
	and a ; cp SPRITE_FACING_DOWN
	jr nz, .notFacingDown
; facing down
	aCoord 8, 11
	inc d
	jr .storeTile
.notFacingDown
	cp SPRITE_FACING_UP
	jr nz, .notFacingUp
; facing up
	aCoord 8, 7
	dec d
	jr .storeTile
.notFacingUp
	cp SPRITE_FACING_LEFT
	jr nz, .notFacingLeft
; facing left
	aCoord 6, 9
	dec e
	jr .storeTile
.notFacingLeft
	cp SPRITE_FACING_RIGHT
	jr nz, .storeTile
; facing right
	aCoord 10, 9
	inc e
.storeTile
	ld c, a
	ld [wTileInFrontOfPlayer], a
	ret
	
GetTileTwoStepsInFrontOfPlayer: ; c309 (3:4309)
	xor a
	ld [$ffdb], a
	ld hl, wYCoord
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ld a, [wSpriteStateData1 + 9] ; player's sprite facing direction
	and a ; cp SPRITE_FACING_DOWN
	jr nz, .notFacingDown
; facing down
	ld hl, $ffdb
	set 0, [hl]
	aCoord 8, 13
	inc d
	jr .storeTile
.notFacingDown
	cp SPRITE_FACING_UP
	jr nz, .notFacingUp
; facing up
	ld hl, $ffdb
	set 1, [hl]
	aCoord 8, 5
	dec d
	jr .storeTile
.notFacingUp
	cp SPRITE_FACING_LEFT
	jr nz, .notFacingLeft
; facing left
	ld hl, $ffdb
	set 2, [hl]
	aCoord 4, 9
	dec e
	jr .storeTile
.notFacingLeft
	cp SPRITE_FACING_RIGHT
	jr nz, .storeTile
; facing right
	ld hl, $ffdb
	set 3, [hl]
	aCoord 12, 9
	inc e
.storeTile
	ld c, a
	ld [wTileInFrontOfBoulderAndBoulderCollisionResult], a
	ld [wTileInFrontOfPlayer], a
	ret

CheckForCollisionWhenPushingBoulder: ; c356 (3:4356)
	call GetTileTwoStepsInFrontOfPlayer
	call IsTilePassable
	jr c, .done
	ld hl, TilePairCollisionsLand
	call CheckForTilePairCollisions2
	ld a, $ff
	jr c, .done ; if there is an elevation difference between the current tile and the one two steps ahead
	ld a, [wTileInFrontOfBoulderAndBoulderCollisionResult]
	cp $15 ; stairs tile
	ld a, $ff
	jr z, .done ; if the tile two steps ahead is stairs
	call CheckForBoulderCollisionWithSprites
.done
	ld [wTileInFrontOfBoulderAndBoulderCollisionResult], a
	ret

; sets a to $ff if there is a collision and $00 if there is no collision
CheckForBoulderCollisionWithSprites: ; c378 (3:4378)
	ld a, [wBoulderSpriteIndex]
	dec a
	swap a
	ld d, 0
	ld e, a
	ld hl, wSpriteStateData2 + $14
	add hl, de
	ld a, [hli] ; map Y position
	ld [$ffdc], a
	ld a, [hl] ; map X position
	ld [$ffdd], a
	ld a, [wNumSprites]
	ld c, a
	ld de, $f
	ld hl, wSpriteStateData2 + $14
	ld a, [$ffdb]
	and $3 ; facing up or down?
	jr z, .pushingHorizontallyLoop
.pushingVerticallyLoop
	inc hl
	ld a, [$ffdd]
	cp [hl]
	jr nz, .nextSprite1 ; if X coordinates don't match
	dec hl
	ld a, [hli]
	ld b, a
	ld a, [$ffdb]
	rrca
	jr c, .pushingDown
; pushing up
	ld a, [$ffdc]
	dec a
	jr .compareYCoords
.pushingDown
	ld a, [$ffdc]
	inc a
.compareYCoords
	cp b
	jr z, .failure
.nextSprite1
	dec c
	jr z, .success
	add hl, de
	jr .pushingVerticallyLoop
.pushingHorizontallyLoop
	ld a, [hli]
	ld b, a
	ld a, [$ffdc]
	cp b
	jr nz, .nextSprite2
	ld b, [hl]
	ld a, [$ffdb]
	bit 2, a
	jr nz, .pushingLeft
; pushing right
	ld a, [$ffdd]
	inc a
	jr .compareXCoords
.pushingLeft
	ld a, [$ffdd]
	dec a
.compareXCoords
	cp b
	jr z, .failure
.nextSprite2
	dec c
	jr z, .success
	add hl, de
	jr .pushingHorizontallyLoop
.failure
	ld a, $ff
	ret
.success
	xor a
	ret

ApplyOutOfBattlePoisonDamage: ; c3de (3:43de)
	ld a, [wd730]
	add a
	jp c, .noBlackOut ; no black out if joypad states are being simulated
	ld a, [wd493]
	bit 7, a
	jp nz, .noBlackOut
	ld a, [wd72e]
	bit 6, a
	jp nz, .noBlackOut
	ld a, [wPartyCount]
	and a
	jp z, .noBlackOut
	call IncrementDayCareMonExp
	call Func_c4c7
	ld a, [wStepCounter]
	and $3 ; is the counter a multiple of 4?
	jp nz, .skipPoisonEffectAndSound ; only apply poison damage every fourth step
	ld [wWhichPokemon], a
	ld hl, wPartyMon1Status
	ld de, wPartySpecies
.applyDamageLoop
	ld a, [hl]
	and (1 << PSN)
	jr z, .nextMon2 ; not poisoned
	dec hl
	dec hl
	ld a, [hld]
	ld b, a
	ld a, [hli]
	or b
	jr z, .nextMon ; already fainted
; subtract 1 from HP
	ld a, [hl]
	dec a
	ld [hld], a
	inc a
	jr nz, .noBorrow
; borrow 1 from upper byte of HP
	dec [hl]
	inc hl
	jr .nextMon
.noBorrow
	ld a, [hli]
	or [hl]
	jr nz, .nextMon ; didn't faint from damage
; the mon fainted from the damage
	push hl
	inc hl
	inc hl
	ld [hl], a
	ld a, [de]
	ld [wd11e], a
	push de
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	xor a
	ld [wJoyIgnore], a
	call EnableAutoTextBoxDrawing
	ld a, $d0
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	callab IsThisPartymonOurPikachu
	jr nc, .curMonNotPlayerPikachu
	ld e, $3
	callab PlayPikachuSoundClip
	calladb_ModifyPikachuHappiness PIKAHAPPY_PSNFNT
.curMonNotPlayerPikachu
	pop de
	pop hl
.nextMon
	inc hl
	inc hl
.nextMon2
	inc de
	ld a, [de]
	inc a
	jr z, .applyDamageLoopDone
	ld bc, wPartyMon2 - wPartyMon1
	add hl, bc
	push hl
	ld hl, wWhichPokemon
	inc [hl]
	pop hl
	jr .applyDamageLoop
.applyDamageLoopDone
	ld hl, wPartyMon1Status
	ld a, [wPartyCount]
	ld d, a
	ld e, 0
.countPoisonedLoop
	ld a, [hl]
	and (1 << PSN)
	or e
	ld e, a
	ld bc, wPartyMon2 - wPartyMon1
	add hl, bc
	dec d
	jr nz, .countPoisonedLoop
	ld a, e
	and a ; are any party members poisoned?
	jr z, .skipPoisonEffectAndSound
	ld b, $2
	predef ChangeBGPalColor0_4Frames ; change BG white to dark grey for 4 frames
	ld a, SFX_POISONED
	call PlaySound
.skipPoisonEffectAndSound
	predef AnyPartyAlive
	ld a, d
	and a
	jr nz, .noBlackOut
	call EnableAutoTextBoxDrawing
	ld a, $d1
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld hl, wd72e
	set 5, [hl]
	ld a, $ff
	jr .done
.noBlackOut
	xor a
.done
	ld [wOutOfBattleBlackout], a
	ret

Func_c4c7: ; c4c7 (3:44c7)
	ld a, [wStepCounter]
	and a
	jr nz, .asm_c4de
	call Random
	and $1
	jr z, .asm_c4de
	calladb_ModifyPikachuHappiness $6
.asm_c4de
	ld hl, wPikachuMood
	ld a, [hl]
	cp $80
	jr z, .asm_c4ef
	jr c, .asm_c4ea
	dec a
	dec a
.asm_c4ea
	inc a
	ld [hl], a
	cp $80
	ret nz
.asm_c4ef
	xor a
	ld [wd49c], a
	ret
	
LoadTilesetHeader: ; c4f4 (3:44f4)
	call GetPredefRegisters
	push hl
	ld d, 0
	ld a, [wCurMapTileset]
	add a
	add a
	ld e, a
	ld hl, Tilesets
	add hl, de
	add hl, de
	add hl, de
	ld de, wTilesetBank
	ld bc, $b
	call CopyData
	ld a, [hl]
	ld [hTilesetType], a
	xor a
	ld [$ffd8], a
	pop hl
	ld a, [wCurMapTileset]
	push hl
	push de
	ld hl, DungeonTilesets
	ld de, $1
	call IsInArray
	pop de
	pop hl
	jr c, .notDungeonTileset
	ld a, [wCurMapTileset]
	ld b, a
	ld a, [hPreviousTileset]
	cp b
	jr z, .done
.notDungeonTileset
	ld a, [wDestinationWarpID]
	cp $ff
	jr z, .done
	call LoadDestinationWarpPosition
	ld a, [wYCoord]
	and $1
	ld [wYBlockCoord], a
	ld a, [wXCoord]
	and $1
	ld [wXBlockCoord], a
.done
	ret

INCLUDE "data/dungeon_tilesets.asm"

INCLUDE "data/tileset_headers.asm"

IncrementDayCareMonExp: ; c684 (3:4684)
	ld a, [wDayCareInUse]
	and a
	ret z
	ld hl, wDayCareMonExp + 2
	inc [hl]
	ret nz
	dec hl
	inc [hl]
	ret nz
	dec hl
	inc [hl]
	ld a, [hl]
	cp $50
	ret c
	ld a, $50
	ld [hl], a
	ret

INCLUDE "data/hide_show_data.asm"

LoadWildData: ; cb62 (3:4b62)
	ld hl,WildDataPointers
	ld a,[wCurMap]

	; get wild data for current map
	ld c,a
	ld b,0
	add hl,bc
	add hl,bc
	ld a,[hli]
	ld h,[hl]
	ld l,a       ; hl now points to wild data for current map
	ld a,[hli]
	ld [wGrassRate],a
	and a
	jr z,.NoGrassData ; if no grass data, skip to surfing data
	push hl
	ld de,wGrassMons ; otherwise, load grass data
	ld bc,$0014
	call CopyData
	pop hl
	ld bc,$0014
	add hl,bc
.NoGrassData
	ld a,[hli]
	ld [wWaterRate],a
	and a
	ret z        ; if no water data, we're done
	ld de,wWaterMons  ; otherwise, load surfing data
	ld bc,$0014
	jp CopyData
	
INCLUDE "data/wild_mons.asm"

INCLUDE "engine/items/items.asm"

DrawBadges: ; e880 (3:6880)
; Draw 4x2 gym leader faces, with the faces replaced by
; badges if they are owned. Used in the player status screen.

; In Japanese versions, names are displayed above faces.
; Instead of removing relevant code, the name graphics were erased.

; Tile ids for face/badge graphics.
	ld de, wBadgeOrFaceTiles
	ld hl, .FaceBadgeTiles
	ld bc, 8
	call CopyData

; Booleans for each badge.
	ld hl, wTempObtainedBadgesBooleans
	ld bc, 8
	xor a
	call FillMemory

; Alter these based on owned badges.
	ld de, wTempObtainedBadgesBooleans
	ld hl, wBadgeOrFaceTiles
	ld a, [wObtainedBadges]
	ld b, a
	ld c, 8
.CheckBadge
	srl b
	jr nc, .NextBadge
	ld a, [hl]
	add 4 ; Badge graphics are after each face
	ld [hl], a
	ld a, 1
	ld [de], a
.NextBadge
	inc hl
	inc de
	dec c
	jr nz, .CheckBadge

; Draw two rows of badges.
	ld hl, wBadgeNumberTile
	ld a, $d8 ; [1]
	ld [hli], a
	ld [hl], $60 ; First name

	coord hl, 2, 11
	ld de, wTempObtainedBadgesBooleans
	call .DrawBadgeRow

	coord hl, 2, 14
	ld de, wTempObtainedBadgesBooleans + 4
;	call .DrawBadgeRow
;	ret

.DrawBadgeRow ; e8c9 (3:68c9)
; Draw 4 badges.

	ld c, 4
.DrawBadge
	push de
	push hl

; Badge no.
	ld a, [wBadgeNumberTile]
	ld [hli], a
	inc a
	ld [wBadgeNumberTile], a

; Names aren't printed if the badge is owned.
	ld a, [de]
	and a
	ld a, [wBadgeNameTile]
	jr nz, .SkipName
	call .PlaceTiles
	jr .PlaceBadge

.SkipName
	inc a
	inc a
	inc hl

.PlaceBadge
	ld [wBadgeNameTile], a
	ld de, SCREEN_WIDTH - 1
	add hl, de
	ld a, [wBadgeOrFaceTiles]
	call .PlaceTiles
	add hl, de
	call .PlaceTiles

; Shift badge array back one byte.
	push bc
	ld hl, wBadgeOrFaceTiles + 1
	ld de, wBadgeOrFaceTiles
	ld bc, 8
	call CopyData
	pop bc

	pop hl
	ld de, 4
	add hl, de

	pop de
	inc de
	dec c
	jr nz, .DrawBadge
	ret

.PlaceTiles
	ld [hli], a
	inc a
	ld [hl], a
	inc a
	ret

.FaceBadgeTiles
	db $20, $28, $30, $38, $40, $48, $50, $58
	
GymLeaderFaceAndBadgeTileGraphics: ; e91b (3:691b)
	INCBIN "gfx/badges.2bpp"

; replaces a tile block with the one specified in [wNewTileBlockID]
; and redraws the map view if necessary
; b = Y
; c = X
ReplaceTileBlock: ; ed1b (3:6d1b)
	call GetPredefRegisters
	ld hl, wOverworldMap
	ld a, [wCurMapWidth]
	add $6
	ld e, a
	ld d, $0
	add hl, de
	add hl, de
	add hl, de
	ld e, $3
	add hl, de
	ld e, a
	ld a, b
	and a
	jr z, .addX
; add width * Y
.addWidthYTimesLoop
	add hl, de
	dec b
	jr nz, .addWidthYTimesLoop
.addX
	add hl, bc ; add X
	ld a, [wNewTileBlockID]
	ld [hl], a
	ld a, [wCurrentTileBlockMapViewPointer]
	ld c, a
	ld a, [wCurrentTileBlockMapViewPointer + 1]
	ld b, a
	call CompareHLWithBC
	ret c ; return if the replaced tile block is below the map view in memory
	push hl
	ld l, e
	ld h, $0
	ld e, $6
	ld d, h
	add hl, hl
	add hl, hl
	add hl, de
	add hl, bc
	pop bc
	call CompareHLWithBC
	ret c ; return if the replaced tile block is above the map view in memory

RedrawMapView: ; ed59 (3:6d59)
	ld a, [wIsInBattle]
	inc a
	ret z
	ld a, [H_AUTOBGTRANSFERENABLED]
	push af
	ld a, [hTilesetType]
	push af
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld [hTilesetType], a ; no flower/water BG tile animations
	call LoadCurrentMapView
	call RunDefaultPaletteCommand
	ld hl, wMapViewVRAMPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, -2 * 32
	add hl, de
	ld a, h
	and $3
	or $98
	ld a, l
	ld [wBuffer], a
	ld a, h
	ld [wBuffer + 1], a ; this copy of the address is not used
	ld a, 2
	ld [$ffbe], a
	ld c, 9 ; number of rows of 2x2 tiles (this covers the whole screen)
.redrawRowLoop
	push bc
	push hl
	push hl
	ld hl, wTileMap - 2 * SCREEN_WIDTH
	ld de, SCREEN_WIDTH
	ld a, [$ffbe]
.calcWRAMAddrLoop
	add hl, de
	dec a
	jr nz, .calcWRAMAddrLoop
	call CopyToRedrawRowOrColumnSrcTiles
	pop hl
	ld de, $20
	ld a, [$ffbe]
	ld c, a
.calcVRAMAddrLoop
	add hl, de
	ld a, h
	and $3
	or $98
	dec c
	jr nz, .calcVRAMAddrLoop
	ld [hRedrawRowOrColumnDest + 1], a
	ld a, l
	ld [hRedrawRowOrColumnDest], a
	ld a, REDRAW_ROW
	ld [hRedrawRowOrColumnMode], a
	call DelayFrame
	ld hl, $ffbe
	inc [hl]
	inc [hl]
	pop hl
	pop bc
	dec c
	jr nz, .redrawRowLoop
	pop af
	ld [hTilesetType], a
	pop af
	ld [H_AUTOBGTRANSFERENABLED], a
	ret

CompareHLWithBC: ; edcb (3:6dcb)
	ld a, h
	sub b
	ret nz
	ld a, l
	sub c
	ret
	
INCLUDE "engine/overworld/cut.asm"
	
MarkTownVisitedAndLoadMissableObjects: ; ef93 (3:6f93)
	ld a, [wCurMap]
	cp ROUTE_1
	jr nc, .notInTown
	ld c, a
	ld b, FLAG_SET
	ld hl, wTownVisitedFlag   ; mark town as visited (for flying)
	predef FlagActionPredef
.notInTown
	ld hl, MapHSPointers
	ld a, [wCurMap]
	ld b, $0
	ld c, a
	add hl, bc
	add hl, bc
	ld a, [hli]                ; load missable objects pointer in hl
	ld h, [hl]
	; fall through

; LoadMissableObjects: ; efb2 (3:6fb2)
; seems to not exist in yellow (predef replaced with something near TryPushingBoulder)
	ld l, a
	push hl
	ld a, l
	sub MapHS00 & $ff ; calculate difference between out pointer and the base pointer
	ld l, a
	ld a, h
	sbc MapHS00 / $100
	ld h, a
	ld a, h
	ld [H_DIVIDEND], a
	ld a, l
	ld [H_DIVIDEND+1], a
	xor a
	ld [H_DIVIDEND+2], a
	ld [H_DIVIDEND+3], a
	ld a, $3
	ld [H_DIVISOR], a
	ld b, $2
	call Divide                ; divide difference by 3, resulting in the global offset (number of missable items before ours)
	ld a, [wCurMap]
	ld b, a
	ld a, [H_DIVIDEND+3]
	ld c, a                    ; store global offset in c
	ld de, wMissableObjectList
	pop hl
.writeMissableObjectsListLoop
	ld a, [hli]
	cp $ff
	jr z, .done     ; end of list
	cp b
	jr nz, .done    ; not for current map anymore
	ld a, [hli]
	inc hl
	ld [de], a                 ; write (map-local) sprite ID
	inc de
	ld a, c
	inc c
	ld [de], a                 ; write (global) missable object index
	inc de
	jr .writeMissableObjectsListLoop
.done
	ld a, $ff
	ld [de], a                 ; write sentinel
	ret

InitializeMissableObjectsFlags: ; eff1 (3:6ff1)
	ld hl, wMissableObjectFlags
	ld bc, wMissableObjectFlagsEnd - wMissableObjectFlags
	xor a
	call FillMemory ; clear missable objects flags
	ld hl, MapHS00
	xor a
	ld [wMissableObjectCounter], a
.missableObjectsLoop
	ld a, [hli]
	cp $ff          ; end of list
	ret z
	push hl
	inc hl
	ld a, [hl]
	cp Hide
	jr nz, .skip
	ld hl, wMissableObjectFlags
	ld a, [wMissableObjectCounter]
	ld c, a
	ld b, FLAG_SET
	call MissableObjectFlagAction ; set flag if Item is hidden
.skip
	ld hl, wMissableObjectCounter
	inc [hl]
	pop hl
	inc hl
	inc hl
	jr .missableObjectsLoop

; tests if current sprite is a missable object that is hidden/has been removed
IsObjectHidden: ; f022 (3:7022)
	ld a, [H_CURRENTSPRITEOFFSET]
	swap a
	ld b, a
	ld hl, wMissableObjectList
.loop
	ld a, [hli]
	cp $ff
	jr z, .notHidden ; not missable -> not hidden
	cp b
	ld a, [hli]
	jr nz, .loop
	ld c, a
	ld b, FLAG_TEST
	ld hl, wMissableObjectFlags
	call MissableObjectFlagAction
	ld a, c
	and a
	jr nz, .hidden
.notHidden
	xor a
.hidden
	ld [$ffe5], a
	ret

; adds missable object (items, leg. pokemon, etc.) to the map
; [wMissableObjectIndex]: index of the missable object to be added (global index)
ShowObject: ; f044 (3:7044)
ShowObject2:
	ld hl, wMissableObjectFlags
	ld a, [wMissableObjectIndex]
	ld c, a
	ld b, FLAG_RESET
	call MissableObjectFlagAction   ; reset "removed" flag
	jp UpdateSprites

; removes missable object (items, leg. pokemon, etc.) from the map
; [wMissableObjectIndex]: index of the missable object to be removed (global index)
HideObject: ; f053 (3:7053)
	ld hl, wMissableObjectFlags
	ld a, [wMissableObjectIndex]
	ld c, a
	ld b, FLAG_SET
	call MissableObjectFlagAction   ; set "removed" flag
	jp UpdateSprites

MissableObjectFlagAction: ; f062 (3:7062)
; identical to FlagAction

	push hl
	push de
	push bc

	; bit
	ld a, c
	ld d, a
	and 7
	ld e, a

	; byte
	ld a, d
	srl a
	srl a
	srl a
	add l
	ld l, a
	jr nc, .ok
	inc h
.ok

	; d = 1 << e (bitmask)
	inc e
	ld d, 1
.shift
	dec e
	jr z, .shifted
	sla d
	jr .shift
.shifted

	ld a, b
	and a
	jr z, .reset
	cp 2
	jr z, .read

.set
	ld a, [hl]
	ld b, a
	ld a, d
	or b
	ld [hl], a
	jr .done

.reset
	ld a, [hl]
	ld b, a
	ld a, d
	xor $ff
	and b
	ld [hl], a
	jr .done

.read
	ld a, [hl]
	ld b, a
	ld a, d
	and b

.done
	pop bc
	pop de
	pop hl
	ld c, a
	ret

TryPushingBoulder: ; f0a1 (3:70a1)
	ld a, [wd728]
	bit 0, a ; using Strength?
	ret z
; where LoadMissableObjects predef points to now
	ld a, [wFlags_0xcd60]
	bit 1, a ; has boulder dust animation from previous push played yet?
	ret nz
	xor a
	ld [hSpriteIndexOrTextID], a
	call IsSpriteInFrontOfPlayer
	ld a, [hSpriteIndexOrTextID]
	ld [wBoulderSpriteIndex], a
	and a
	jp z, ResetBoulderPushFlags
	ld hl, wSpriteStateData1 + 1
	ld d, $0
	ld a, [hSpriteIndexOrTextID]
	swap a
	ld e, a
	add hl, de
	res 7, [hl]
	call GetSpriteMovementByte2Pointer
	ld a, [hl]
	cp BOULDER_MOVEMENT_BYTE_2
	jp nz, ResetBoulderPushFlags
	ld hl, wFlags_0xcd60
	bit 6, [hl]
	set 6, [hl] ; indicate that the player has tried pushing
	ret z ; the player must try pushing twice before the boulder will move
	ld a, [hJoyHeld]
	and D_RIGHT | D_LEFT | D_UP | D_DOWN
	ret z
	predef CheckForCollisionWhenPushingBoulder
	ld a, [wTileInFrontOfBoulderAndBoulderCollisionResult]
	and a ; was there a collision?
	jp nz, ResetBoulderPushFlags
	ld a, [hJoyHeld]
	ld b, a
	ld a, [wSpriteStateData1 + 9] ; player's sprite facing direction
	cp SPRITE_FACING_UP
	jr z, .pushBoulderUp
	cp SPRITE_FACING_LEFT
	jr z, .pushBoulderLeft
	cp SPRITE_FACING_RIGHT
	jr z, .pushBoulderRight
.pushBoulderDown
	bit 7, b
	ret z
	ld de, PushBoulderDownMovementData
	jr .done
.pushBoulderUp
	bit 6, b
	ret z
	ld de, PushBoulderUpMovementData
	jr .done
.pushBoulderLeft
	bit 5, b
	ret z
	ld de, PushBoulderLeftMovementData
	jr .done
.pushBoulderRight
	bit 4, b
	ret z
	ld de, PushBoulderRightMovementData
.done
	call MoveSprite
	ld a, SFX_PUSH_BOULDER
	call PlaySound
	ld hl, wFlags_0xcd60
	set 1, [hl]
	ret

PushBoulderUpMovementData: ; f129 (3:7129)
	db NPC_MOVEMENT_UP,$FF

PushBoulderDownMovementData: ; f12b (3:712b)
	db NPC_MOVEMENT_DOWN,$FF

PushBoulderLeftMovementData: ; f12d (3:712d)
	db NPC_MOVEMENT_LEFT,$FF

PushBoulderRightMovementData: ; f12f (3:712f)
	db NPC_MOVEMENT_RIGHT,$FF

DoBoulderDustAnimation: ; f131 (3:7131)
	ld a, [wd730]
	bit 0, a
	ret nz
	callab AnimateBoulderDust
	call DiscardButtonPresses
	ld [wJoyIgnore], a
	call ResetBoulderPushFlags
	set 7, [hl]
	ld a, [wBoulderSpriteIndex]
	ld [H_SPRITEINDEX], a
	call GetSpriteMovementByte2Pointer
	ld [hl], $10
	ld a, SFX_CUT
	jp PlaySound

ResetBoulderPushFlags: ; f159 (3:7159)
	ld hl, wFlags_0xcd60
	res 1, [hl]
	res 6, [hl]
	ret

_AddPartyMon: ; f161 (3:7161)
; Adds a new mon to the player's or enemy's party.
; [wMonDataLocation] is used in an unusual way in this function.
; If the lower nybble is 0, the mon is added to the player's party, else the enemy's.
; If the entire value is 0, then the player is allowed to name the mon.
	ld de, wPartyCount
	ld a, [wMonDataLocation]
	and $f
	jr z, .next
	ld de, wEnemyPartyCount
.next
	ld a, [de]
	inc a
	cp PARTY_LENGTH + 1
	ret nc ; return if the party is already full
	ld [de], a
	ld a, [de]
	ld [hNewPartyLength], a
	add e
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
	ld a, [wcf91]
	ld [de], a ; write species of new mon in party list
	inc de
	ld a, $ff ; terminator
	ld [de], a
	ld hl, wPartyMonOT
	ld a, [wMonDataLocation]
	and $f
	jr z, .next2
	ld hl, wEnemyMonOT
.next2
	ld a, [hNewPartyLength]
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
	ld hl, wPlayerName
	ld bc, NAME_LENGTH
	call CopyData
	ld a, [wMonDataLocation]
	and a
	jr nz, .skipNaming
	ld hl, wPartyMonNicks
	ld a, [hNewPartyLength]
	dec a
	call SkipFixedLengthTextEntries
	ld a, NAME_MON_SCREEN
	ld [wNamingScreenType], a
	predef AskName
.skipNaming
	ld hl, wPartyMons
	ld a, [wMonDataLocation]
	and $f
	jr z, .next3
	ld hl, wEnemyMons
.next3
	ld a, [hNewPartyLength]
	dec a
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld e, l
	ld d, h
	push hl
	ld a, [wcf91]
	ld [wd0b5], a
	call GetMonHeader
	ld hl, wMonHeader
	ld a, [hli]
	ld [de], a ; species
	inc de
	pop hl
	push hl
	ld a, [wMonDataLocation]
	and $f
	ld a, $98     ; set enemy trainer mon IVs to fixed average values
	ld b, $88
	jr nz, .next4

; If the mon is being added to the player's party, update the pokedex.
	ld a, [wcf91]
	ld [wd11e], a
	push de
	predef IndexToPokedex
	pop de
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, FLAG_TEST
	ld hl, wPokedexOwned
	call FlagAction
	ld a, c ; whether the mon was already flagged as owned
	ld [wUnusedD153], a ; not read
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, FLAG_SET
	push bc
	call FlagAction
	pop bc
	ld hl, wPokedexSeen
	call FlagAction

	pop hl
	push hl

	ld a, [wIsInBattle]
	and a ; is this a wild mon caught in battle?
	jr nz, .copyEnemyMonData

; Not wild.
	call Random ; generate random IVs
	ld b, a
	call Random

.next4
	push bc
	ld bc, wPartyMon1DVs - wPartyMon1
	add hl, bc
	pop bc
	ld [hli], a
	ld [hl], b         ; write IVs
	ld bc, (wPartyMon1HPExp - 1) - (wPartyMon1DVs + 1)
	add hl, bc
	ld a, 1
	ld c, a
	xor a
	ld b, a
	call CalcStat      ; calc HP stat (set cur Hp to max HP)
	ld a, [H_MULTIPLICAND+1]
	ld [de], a
	inc de
	ld a, [H_MULTIPLICAND+2]
	ld [de], a
	inc de
	xor a
	ld [de], a         ; box level
	inc de
	ld [de], a         ; status ailments
	inc de
	jr .copyMonTypesAndMoves
.copyEnemyMonData
	ld bc, wEnemyMon1DVs - wEnemyMon1
	add hl, bc
	ld a, [wEnemyMonDVs] ; copy IVs from cur enemy mon
	ld [hli], a
	ld a, [wEnemyMonDVs + 1]
	ld [hl], a
	ld a, [wEnemyMonHP]    ; copy HP from cur enemy mon
	ld [de], a
	inc de
	ld a, [wEnemyMonHP+1]
	ld [de], a
	inc de
	xor a
	ld [de], a                ; box level
	inc de
	ld a, [wEnemyMonStatus]   ; copy status ailments from cur enemy mon
	ld [de], a
	inc de
.copyMonTypesAndMoves
	ld hl, wMonHTypes
	ld a, [hli]       ; type 1
	ld [de], a
	inc de
	ld a, [hli]       ; type 2
	ld [de], a
	inc de
	ld a, [hli]       ; catch rate (held item in gen 2)
	ld [de], a
	ld a, [wcf91]
	cp KADABRA
	jr nz, .skipGivingTwistedSpoon
	ld a, $60 ; twistedspoon in gen 2
	ld [de], a
.skipGivingTwistedSpoon
	ld hl, wMonHMoves
	ld a, [hli]
	inc de
	push de
	ld [de], a
	ld a, [hli]
	inc de
	ld [de], a
	ld a, [hli]
	inc de
	ld [de], a
	ld a, [hli]
	inc de
	ld [de], a
	push de
	dec de
	dec de
	dec de
	xor a
	ld [wLearningMovesFromDayCare], a
	predef WriteMonMoves
	pop de
	ld a, [wPlayerID]  ; set trainer ID to player ID
	inc de
	ld [de], a
	ld a, [wPlayerID + 1]
	inc de
	ld [de], a
	push de
	ld a, [wCurEnemyLVL]
	ld d, a
	callab CalcExperience
	pop de
	inc de
	ld a, [hExperience] ; write experience
	ld [de], a
	inc de
	ld a, [hExperience + 1]
	ld [de], a
	inc de
	ld a, [hExperience + 2]
	ld [de], a
	xor a
	ld b, NUM_STATS * 2
.writeEVsLoop              ; set all EVs to 0
	inc de
	ld [de], a
	dec b
	jr nz, .writeEVsLoop
	inc de
	inc de
	pop hl
	call AddPartyMon_WriteMovePP
	inc de
	ld a, [wCurEnemyLVL]
	ld [de], a
	inc de
	ld a, [wIsInBattle]
	dec a
	jr nz, .calcFreshStats
	ld hl, wEnemyMonMaxHP
	ld bc, $a
	call CopyData          ; copy stats of cur enemy mon
	pop hl
	jr .done
.calcFreshStats
	pop hl
	ld bc, wPartyMon1HPExp - 1 - wPartyMon1
	add hl, bc
	ld b, $0
	call CalcStats         ; calculate fresh set of stats
.done
	scf
	ret

LoadMovePPs: ; f2f9 (3:72f9)
	call GetPredefRegisters
	; fallthrough
AddPartyMon_WriteMovePP: ; f2fc (3:72fc)
	ld b, NUM_MOVES
.pploop
	ld a, [hli]     ; read move ID
	and a
	jr z, .empty
	dec a
	push hl
	push de
	push bc
	ld hl, Moves
	ld bc, MoveEnd - Moves
	call AddNTimes
	ld de, wcd6d
	ld a, BANK(Moves)
	call FarCopyData
	pop bc
	pop de
	pop hl
	ld a, [wcd6d + 5] ; PP is byte 5 of move data
.empty
	inc de
	ld [de], a
	dec b
	jr nz, .pploop ; there are still moves to read
	ret

; adds enemy mon [wcf91] (at position [wWhichPokemon] in enemy list) to own party
; used in the cable club trade center
_AddEnemyMonToPlayerParty: ; f323 (3:7323)
	ld hl, wPartyCount
	ld a, [hl]
	cp PARTY_LENGTH
	scf
	ret z            ; party full, return failure
	inc a
	ld [hl], a       ; add 1 to party members
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [wcf91]
	ld [hli], a      ; add mon as last list entry
	ld [hl], $ff     ; write new sentinel
	ld hl, wPartyMons
	ld a, [wPartyCount]
	dec a
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld e, l
	ld d, h
	ld hl, wLoadedMon
	call CopyData    ; write new mon's data (from wLoadedMon)
	ld hl, wPartyMonOT
	ld a, [wPartyCount]
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
	ld hl, wEnemyMonOT
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
	ld bc, NAME_LENGTH
	call CopyData    ; write new mon's OT name (from an enemy mon)
	ld hl, wPartyMonNicks
	ld a, [wPartyCount]
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
	ld hl, wEnemyMonNicks
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
	ld bc, NAME_LENGTH
	call CopyData    ; write new mon's nickname (from an enemy mon)
	ld a, [wcf91]
	ld [wd11e], a
	predef IndexToPokedex
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, FLAG_SET
	ld hl, wPokedexOwned
	push bc
	call FlagAction ; add to owned pokemon
	pop bc
	ld hl, wPokedexSeen
	call FlagAction ; add to seen pokemon
	and a
	ret                  ; return success

_MoveMon: ; f3a4 (3:73a4)
	ld a, [wMoveMonType]
	and a
	jr z, .checkPartyMonSlots
	cp DAYCARE_TO_PARTY
	jr z, .checkPartyMonSlots
	cp PARTY_TO_DAYCARE
	ld hl, wDayCareMon
	jr z, .asm_f3fb
	ld hl, wNumInBox
	ld a, [hl]
	cp MONS_PER_BOX
	jr nz, .partyOrBoxNotFull
	jr .boxFull
.checkPartyMonSlots
	ld hl, wPartyCount
	ld a, [hl]
	cp PARTY_LENGTH
	jr nz, .partyOrBoxNotFull
.boxFull
	scf
	ret
.partyOrBoxNotFull
	inc a
	ld [hl], a           ; increment number of mons in party/box
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wMoveMonType]
	cp DAYCARE_TO_PARTY
	ld a, [wDayCareMon]
	jr z, .asm_f3dc
	ld a, [wcf91]
.asm_f3dc
	ld [hli], a          ; write new mon ID
	ld [hl], $ff         ; write new sentinel
	ld a, [wMoveMonType]
	dec a
	ld hl, wPartyMons
	ld bc, wPartyMon2 - wPartyMon1 ; $2c
	ld a, [wPartyCount]
	jr nz, .skipToNewMonEntry
	ld hl, wBoxMons
	ld bc, wBoxMon2 - wBoxMon1 ; $21
	ld a, [wNumInBox]
.skipToNewMonEntry
	dec a
	call AddNTimes
.asm_f3fb
	push hl
	ld e, l
	ld d, h
	ld a, [wMoveMonType]
	and a
	ld hl, wBoxMons
	ld bc, wBoxMon2 - wBoxMon1 ; $21
	jr z, .asm_f417
	cp DAYCARE_TO_PARTY
	ld hl, wDayCareMon
	jr z, .asm_f41d
	ld hl, wPartyMons
	ld bc, wPartyMon2 - wPartyMon1 ; $2c
.asm_f417
	ld a, [wWhichPokemon]
	call AddNTimes
.asm_f41d
	push hl
	push de
	ld bc, wBoxMon2 - wBoxMon1
	call CopyData
	pop de
	pop hl
	ld a, [wMoveMonType]
	and a
	jr z, .asm_f43a
	cp DAYCARE_TO_PARTY
	jr z, .asm_f43a
	ld bc, wBoxMon2 - wBoxMon1
	add hl, bc
	ld a, [hl]
	inc de
	inc de
	inc de
	ld [de], a
.asm_f43a
	ld a, [wMoveMonType]
	cp PARTY_TO_DAYCARE
	ld de, wDayCareMonOT
	jr z, .asm_f459
	dec a
	ld hl, wPartyMonOT
	ld a, [wPartyCount]
	jr nz, .asm_f453
	ld hl, wBoxMonOT
	ld a, [wNumInBox]
.asm_f453
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
.asm_f459
	ld hl, wBoxMonOT
	ld a, [wMoveMonType]
	and a
	jr z, .asm_f46c
	ld hl, wDayCareMonOT
	cp DAYCARE_TO_PARTY
	jr z, .asm_f472
	ld hl, wPartyMonOT
.asm_f46c
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
.asm_f472
	ld bc, NAME_LENGTH
	call CopyData
	ld a, [wMoveMonType]
	cp PARTY_TO_DAYCARE
	ld de, wDayCareMonName
	jr z, .asm_f497
	dec a
	ld hl, wPartyMonNicks
	ld a, [wPartyCount]
	jr nz, .asm_f491
	ld hl, wBoxMonNicks
	ld a, [wNumInBox]
.asm_f491
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
.asm_f497
	ld hl, wBoxMonNicks
	ld a, [wMoveMonType]
	and a
	jr z, .asm_f4aa
	ld hl, wDayCareMonName
	cp DAYCARE_TO_PARTY
	jr z, .asm_f4b0
	ld hl, wPartyMonNicks
.asm_f4aa
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
.asm_f4b0
	ld bc, NAME_LENGTH
	call CopyData
	pop hl
	ld a, [wMoveMonType]
	cp PARTY_TO_BOX
	jr z, .asm_f4ea
	cp PARTY_TO_DAYCARE
	jr z, .asm_f4ea
	push hl
	srl a
	add $2
	ld [wMonDataLocation], a
	call LoadMonData
	callba CalcLevelFromExperience
	ld a, d
	ld [wCurEnemyLVL], a
	pop hl
	ld bc, wBoxMon2 - wBoxMon1
	add hl, bc
	ld [hli], a
	ld d, h
	ld e, l
	ld bc, -18
	add hl, bc
	ld b, $1
	call CalcStats
.asm_f4ea
	and a
	ret


FlagActionPredef: ; f4ec (3:74ec)
	call GetPredefRegisters

FlagAction: ; f4ef (3:74ef)
; Perform action b on bit c
; in the bitfield at hl.
;  0: reset
;  1: set
;  2: read
; Return the result in c.

	push hl
	push de
	push bc

	; bit
	ld a, c
	ld d, a
	and 7
	ld e, a

	; byte
	ld a, d
	srl a
	srl a
	srl a
	add l
	ld l, a
	jr nc, .ok
	inc h
.ok

	; d = 1 << e (bitmask)
	inc e
	ld d, 1
.shift
	dec e
	jr z, .shifted
	sla d
	jr .shift
.shifted

	ld a, b
	and a
	jr z, .reset
	cp 2
	jr z, .read

.set
	ld b, [hl]
	ld a, d
	or b
	ld [hl], a
	jr .done

.reset
	ld b, [hl]
	ld a, d
	xor $ff
	and b
	ld [hl], a
	jr .done

.read
	ld b, [hl]
	ld a, d
	and b
.done
	pop bc
	pop de
	pop hl
	ld c, a
	ret

HealParty: ; f52b (3:752b)
; Restore HP and PP.

	ld hl, wPartySpecies
	ld de, wPartyMon1HP
.healmon
	ld a, [hli]
	cp $ff
	jr z, .done

	push hl
	push de

	ld hl, wPartyMon1Status - wPartyMon1HP
	add hl, de
	xor a
	ld [hl], a

	push de
	ld b, NUM_MOVES ; A Pokémon has 4 moves
.pp
	ld hl, wPartyMon1Moves - wPartyMon1HP
	add hl, de

	ld a, [hl]
	and a
	jr z, .nextmove

	dec a
	ld hl, wPartyMon1PP - wPartyMon1HP
	add hl, de

	push hl
	push de
	push bc

	ld hl, Moves
	ld bc, MoveEnd - Moves
	call AddNTimes
	ld de, wcd6d
	ld a, BANK(Moves)
	call FarCopyData
	ld a, [wcd6d + 5] ; PP is byte 5 of move data

	pop bc
	pop de
	pop hl

	inc de
	push bc
	ld b, a
	ld a, [hl]
	and $c0
	add b
	ld [hl], a
	pop bc

.nextmove
	dec b
	jr nz, .pp
	pop de

	ld hl, wPartyMon1MaxHP - wPartyMon1HP
	add hl, de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a

	pop de
	pop hl

	push hl
	ld bc, wPartyMon2 - wPartyMon1
	ld h, d
	ld l, e
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	jr .healmon

.done
	xor a
	ld [wWhichPokemon], a
	ld [wd11e], a

	ld a, [wPartyCount]
	ld b, a
.ppup
	push bc
	call RestoreBonusPP
	pop bc
	ld hl, wWhichPokemon
	inc [hl]
	dec b
	jr nz, .ppup
	ret

INCLUDE "engine/bcd.asm"

InitPlayerData: ; f6d6 (3:76d6)
InitPlayerData2:

	call Random
	ld a, [hRandomSub]
	ld [wPlayerID], a

	call Random
	ld a, [hRandomAdd]
	ld [wPlayerID + 1], a

	ld a, $ff
	ld [wUnusedD71B], a
	
	ld a, 90 ; initialize happiness to 90
	ld [wPikachuHappiness], a
	ld a, $80
	ld [wPikachuMood], a ; initialize mood
	
	ld hl, wPartyCount
	call InitializeEmptyList
	ld hl, wNumInBox
	call InitializeEmptyList
	ld hl, wNumBagItems
	call InitializeEmptyList
	ld hl, wNumBoxItems
	call InitializeEmptyList

START_MONEY EQU $3000
	ld hl, wPlayerMoney + 1
	ld a, START_MONEY / $100
	ld [hld], a
	xor a
	ld [hli], a
	inc hl
	ld [hl], a

	ld [wMonDataLocation], a

	ld hl, wObtainedBadges
	ld [hli], a

	ld [hl], a

	ld hl, wPlayerCoins
	ld [hli], a
	ld [hl], a

	ld hl, wGameProgressFlags
	ld bc, wGameProgressFlagsEnd - wGameProgressFlags
	call FillMemory ; clear all game progress flags

	jp InitializeMissableObjectsFlags

InitializeEmptyList: ; f730 (3:7730)
	xor a ; count
	ld [hli], a
	dec a ; terminator
	ld [hl], a
	ret

GetQuantityOfItemInBag: ; f735 (3:7735)
; In: b = item ID
; Out: b = how many of that item are in the bag
	call GetPredefRegisters
	ld hl, wNumBagItems
.loop
	inc hl
	ld a, [hli]
	cp $ff
	jr z, .notInBag
	cp b
	jr nz, .loop
	ld a, [hl]
	ld b, a
	ret
.notInBag
	ld b, 0
	ret

FindPathToPlayer: ; f74a (3:774a)
	xor a
	ld hl, hFindPathNumSteps
	ld [hli], a ; hFindPathNumSteps
	ld [hli], a ; hFindPathFlags
	ld [hli], a ; hFindPathYProgress
	ld [hl], a  ; hFindPathXProgress
	ld hl, wNPCMovementDirections2
	ld de, $0
.loop
	ld a, [hFindPathYProgress]
	ld b, a
	ld a, [hNPCPlayerYDistance] ; Y distance in steps
	call CalcDifference
	ld d, a
	and a
	jr nz, .asm_f76a
	ld a, [hFindPathFlags]
	set 0, a ; current end of path matches the player's Y coordinate
	ld [hFindPathFlags], a
.asm_f76a
	ld a, [hFindPathXProgress]
	ld b, a
	ld a, [hNPCPlayerXDistance] ; X distance in steps
	call CalcDifference
	ld e, a
	and a
	jr nz, .asm_f77c
	ld a, [hFindPathFlags]
	set 1, a ; current end of path matches the player's X coordinate
	ld [hFindPathFlags], a
.asm_f77c
	ld a, [hFindPathFlags]
	cp $3 ; has the end of the path reached the player's position?
	jr z, .done
; Compare whether the X distance between the player and the current of the path
; is greater or if the Y distance is. Then, try to reduce whichever is greater.
	ld a, e
	cp d
	jr c, .yDistanceGreater
; x distance is greater
	ld a, [hNPCPlayerRelativePosFlags]
	bit 1, a
	jr nz, .playerIsLeftOfNPC
	ld d, NPC_MOVEMENT_RIGHT
	jr .next1
.playerIsLeftOfNPC
	ld d, NPC_MOVEMENT_LEFT
.next1
	ld a, [hFindPathXProgress]
	add 1
	ld [hFindPathXProgress], a
	jr .storeDirection
.yDistanceGreater
	ld a, [hNPCPlayerRelativePosFlags]
	bit 0, a
	jr nz, .playerIsAboveNPC
	ld d, NPC_MOVEMENT_DOWN
	jr .next2
.playerIsAboveNPC
	ld d, NPC_MOVEMENT_UP
.next2
	ld a, [hFindPathYProgress]
	add 1
	ld [hFindPathYProgress], a
.storeDirection
	ld a, d
	ld [hli], a
	ld a, [hFindPathNumSteps]
	inc a
	ld [hFindPathNumSteps], a
	jp .loop
.done
	ld [hl], $ff
	ret

CalcPositionOfPlayerRelativeToNPC: ; f7b9 (3:77b9)
	xor a
	ld [hNPCPlayerRelativePosFlags], a
	ld a, [wSpriteStateData1 + 4] ; player's sprite screen Y position in pixels
	ld d, a
	ld a, [wSpriteStateData1 + 6] ; player's sprite screen X position in pixels
	ld e, a
	ld hl, wSpriteStateData1
	ld a, [hNPCSpriteOffset]
	add l
	add $4
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	ld a, d
	ld b, a
	ld a, [hli] ; NPC sprite screen Y position in pixels
	call CalcDifference
	jr nc, .NPCSouthOfOrAlignedWithPlayer
.NPCNorthOfPlayer
	push hl
	ld hl, hNPCPlayerRelativePosFlags
	bit 0, [hl]
	set 0, [hl]
	pop hl
	jr .divideYDistance
.NPCSouthOfOrAlignedWithPlayer
	push hl
	ld hl, hNPCPlayerRelativePosFlags
	bit 0, [hl]
	res 0, [hl]
	pop hl
.divideYDistance
	push hl
	ld hl, hDividend2
	ld [hli], a
	ld a, 16
	ld [hli], a
	call DivideBytes ; divide Y absolute distance by 16
	ld a, [hl] ; quotient
	ld [hNPCPlayerYDistance], a
	pop hl
	inc hl
	ld b, e
	ld a, [hl] ; NPC sprite screen X position in pixels
	call CalcDifference
	jr nc, .NPCEastOfOrAlignedWithPlayer
.NPCWestOfPlayer
	push hl
	ld hl, hNPCPlayerRelativePosFlags
	bit 1, [hl]
	set 1, [hl]
	pop hl
	jr .divideXDistance
.NPCEastOfOrAlignedWithPlayer
	push hl
	ld hl, hNPCPlayerRelativePosFlags
	bit 1, [hl]
	res 1, [hl]
	pop hl
.divideXDistance
	ld [hDividend2], a
	ld a, 16
	ld [hDivisor2], a
	call DivideBytes ; divide X absolute distance by 16
	ld a, [hQuotient2]
	ld [hNPCPlayerXDistance], a
	ld a, [hNPCPlayerRelativePosPerspective]
	and a
	ret z
	ld a, [hNPCPlayerRelativePosFlags]
	cpl
	and $3
	ld [hNPCPlayerRelativePosFlags], a
	ret

ConvertNPCMovementDirectionsToJoypadMasks: ; f830 (3:7830)
	ld a, [hNPCMovementDirections2Index]
	ld [wNPCMovementDirections2Index], a
	dec a
	ld de, wSimulatedJoypadStatesEnd
	ld hl, wNPCMovementDirections2
	add l
	ld l, a
	jr nc, .loop
	inc h
.loop
	ld a, [hld]
	call ConvertNPCMovementDirectionToJoypadMask
	ld [de], a
	inc de
	ld a, [hNPCMovementDirections2Index]
	dec a
	ld [hNPCMovementDirections2Index], a
	jr nz, .loop
	ret

ConvertNPCMovementDirectionToJoypadMask: ; f84f (3:784f)
	push hl
	ld b, a
	ld hl, NPCMovementDirectionsToJoypadMasksTable
.loop
	ld a, [hli]
	cp $ff
	jr z, .done
	cp b
	jr z, .loadJoypadMask
	inc hl
	jr .loop
.loadJoypadMask
	ld a, [hl]
.done
	pop hl
	ret

NPCMovementDirectionsToJoypadMasksTable: ; f862 (3:7862)
	db NPC_MOVEMENT_UP, D_UP
	db NPC_MOVEMENT_DOWN, D_DOWN
	db NPC_MOVEMENT_LEFT, D_LEFT
	db NPC_MOVEMENT_RIGHT, D_RIGHT
	db $ff

; unreferenced
	ret

INCLUDE "engine/hp_bar.asm"
INCLUDE "engine/hidden_object_functions3.asm"

SECTION "Graphics", ROMX, BANK[GFX]

PokemonLogoJapanGraphics:       INCBIN "gfx/pokemon_logo_japan.2bpp"
FontGraphics:                   INCBIN "gfx/font.1bpp"
FontGraphicsEnd:
ABTiles:                        INCBIN "gfx/AB.2bpp"
HpBarAndStatusGraphics:         INCBIN "gfx/hp_bar_and_status.2bpp"
HpBarAndStatusGraphicsEnd:
BattleHudTiles1:                INCBIN "gfx/battle_hud1.1bpp"
BattleHudTiles2:                INCBIN "gfx/battle_hud2.1bpp"
BattleHudTiles3:                INCBIN "gfx/battle_hud3.1bpp"
NintendoCopyrightLogoGraphics:  INCBIN "gfx/copyright.2bpp"
GamefreakLogoGraphics:          INCBIN "gfx/gamefreak.2bpp"
GamefreakLogoGraphicsEnd:
NineTile:                       INCBIN "gfx/9_tile.2bpp"
TextBoxGraphics:                INCBIN "gfx/text_box.2bpp"
TextBoxGraphicsEnd:
PokedexTileGraphics:            INCBIN "gfx/pokedex.2bpp"
WorldMapTileGraphics:           INCBIN "gfx/town_map.2bpp"
WorldMapTileGraphicsEnd:
PlayerCharacterTitleGraphics:   INCBIN "gfx/player_title.2bpp"

	dr $11468,$1168a
PrintStatsBox: ; 1168a (4:568a)
	dr $1168a, $11875
DrawPartyMenu_: ; 11875 (4:5875)
	dr $11875,$11886
RedrawPartyMenu_: ; 11886 (4:5886)
	dr $11886,$11a97
RedPicFront: INCBIN "pic/ytrainer/red.pic"
ShrinkPic1:  INCBIN "pic/trainer/shrink1.pic"
ShrinkPic2:  INCBIN "pic/trainer/shrink2.pic"

StartMenu_Pokedex: ; 11c22 (4:5c22)
	dr $11c22,$11c36
StartMenu_Pokemon: ; 11c36 (4:5c36)
	dr $11c36,$11e98
ErasePartyMenuCursors: ; 11e98 (4:5e98)
	dr $11e98,$11ead
StartMenu_Item: ; 11ead (4:5ead)
	dr $11ead,$1200a
StartMenu_TrainerInfo: ; 1200a (4:600a)
	dr $1200a,$12195
StartMenu_SaveReset: ; 12195 (4:6195)
	dr $12195,$121a8
StartMenu_Option: ; 121a8 (4:61a8)
	dr $121a8,$121c5
SwitchPartyMon: ; 121c5 (4:61c5)
	dr $121c5,$12365


SECTION "NPC Sprites 1", ROMX, BANK[NPC_SPRITES_1]

OakAideSprite:         INCBIN "gfx/sprites/oak_aide.2bpp"
RockerSprite:          INCBIN "gfx/sprites/rocker.2bpp"
SwimmerSprite:         INCBIN "gfx/sprites/swimmer.2bpp"
WhitePlayerSprite:     INCBIN "gfx/sprites/white_player.2bpp"
GymHelperSprite:       INCBIN "gfx/sprites/gym_helper.2bpp"
OldPersonSprite:       INCBIN "gfx/sprites/old_person.2bpp"
MartGuySprite:         INCBIN "gfx/sprites/mart_guy.2bpp"
FisherSprite:          INCBIN "gfx/sprites/fisher.2bpp"
OldMediumWomanSprite:  INCBIN "gfx/sprites/old_medium_woman.2bpp"
NurseSprite:           INCBIN "gfx/sprites/nurse.2bpp"
CableClubWomanSprite:  INCBIN "gfx/sprites/cable_club_woman.2bpp"
MrMasterballSprite:    INCBIN "gfx/sprites/mr_masterball.2bpp"
LaprasGiverSprite:     INCBIN "gfx/sprites/lapras_giver.2bpp"
WardenSprite:          INCBIN "gfx/sprites/warden.2bpp"
SsCaptainSprite:       INCBIN "gfx/sprites/ss_captain.2bpp"
Fisher2Sprite:         INCBIN "gfx/sprites/fisher2.2bpp"
BlackbeltSprite:       INCBIN "gfx/sprites/blackbelt.2bpp"
GuardSprite:           INCBIN "gfx/sprites/guard.2bpp"
BallSprite:            INCBIN "gfx/sprites/ball.2bpp"
OmanyteSprite:         INCBIN "gfx/sprites/omanyte.2bpp"
BoulderSprite:         INCBIN "gfx/sprites/boulder.2bpp"
PaperSheetSprite:      INCBIN "gfx/sprites/paper_sheet.2bpp"
BookMapDexSprite:      INCBIN "gfx/sprites/book_map_dex.2bpp"
ClipboardSprite:       INCBIN "gfx/sprites/clipboard.2bpp"
SnorlaxSprite:         INCBIN "gfx/sprites/snorlax.2bpp"
OldAmberSprite:        INCBIN "gfx/sprites/old_amber.2bpp"
LyingOldManSprite:     INCBIN "gfx/sprites/lying_old_man.2bpp"
QuestionMarkSprite:    INCBIN "gfx/sprites/question_mark.2bpp"

EndOfBattle: ; 13765 (4:7765)
	dr $13765,$1383a
TryDoWildEncounter: ; 1383a (4:783a)
	dr $1383a,$14000


SECTION "NPC Sprites 2", ROMX, BANK[NPC_SPRITES_2]

	dr $14000,$1401b
_InitMapSprites: ; 1401b (5:401b)
	dr $1401b,$140d2
Func_140d2: ; 140d2 (5:40d2)
	dr $140d2,$143f1

RedCyclingSprite:     INCBIN "gfx/sprites/cycling.2bpp"
RedSprite:            INCBIN "gfx/sprites/red.2bpp"
BlueSprite:           INCBIN "gfx/sprites/blue.2bpp"
OakSprite:            INCBIN "gfx/sprites/oak.2bpp"
BugCatcherSprite:     INCBIN "gfx/sprites/bug_catcher.2bpp"
SlowbroSprite:        INCBIN "gfx/sprites/slowbro.2bpp"
LassSprite:           INCBIN "gfx/sprites/lass.2bpp"
BlackHairBoy1Sprite:  INCBIN "gfx/sprites/black_hair_boy_1.2bpp"
LittleGirlSprite:     INCBIN "gfx/sprites/little_girl.2bpp"
BirdSprite:           INCBIN "gfx/sprites/bird.2bpp"
FatBaldGuySprite:     INCBIN "gfx/sprites/fat_bald_guy.2bpp"
GamblerSprite:        INCBIN "gfx/sprites/gambler.2bpp"
BlackHairBoy2Sprite:  INCBIN "gfx/sprites/black_hair_boy_2.2bpp"
GirlSprite:           INCBIN "gfx/sprites/girl.2bpp"
HikerSprite:          INCBIN "gfx/sprites/hiker.2bpp"
FoulardWomanSprite:   INCBIN "gfx/sprites/foulard_woman.2bpp"
GentlemanSprite:      INCBIN "gfx/sprites/gentleman.2bpp"
DaisySprite:          INCBIN "gfx/sprites/daisy.2bpp"
BikerSprite:          INCBIN "gfx/sprites/biker.2bpp"
SailorSprite:         INCBIN "gfx/sprites/sailor.2bpp"
CookSprite:           INCBIN "gfx/sprites/cook.2bpp"
BikeShopGuySprite:    INCBIN "gfx/sprites/bike_shop_guy.2bpp"
MrFujiSprite:         INCBIN "gfx/sprites/mr_fuji.2bpp"
GiovanniSprite:       INCBIN "gfx/sprites/giovanni.2bpp"
RocketSprite:         INCBIN "gfx/sprites/rocket.2bpp"
MediumSprite:         INCBIN "gfx/sprites/medium.2bpp"
WaiterSprite:         INCBIN "gfx/sprites/waiter.2bpp"
ErikaSprite:          INCBIN "gfx/sprites/erika.2bpp"
MomGeishaSprite:      INCBIN "gfx/sprites/mom_geisha.2bpp"
BrunetteGirlSprite:   INCBIN "gfx/sprites/brunette_girl.2bpp"
LanceSprite:          INCBIN "gfx/sprites/lance.2bpp"
MomSprite:            INCBIN "gfx/sprites/mom.2bpp"
BaldingGuySprite:     INCBIN "gfx/sprites/balding_guy.2bpp"
YoungBoySprite:       INCBIN "gfx/sprites/young_boy.2bpp"
GameboyKidSprite:     INCBIN "gfx/sprites/gameboy_kid.2bpp"
ClefairySprite:       INCBIN "gfx/sprites/clefairy.2bpp"
AgathaSprite:         INCBIN "gfx/sprites/agatha.2bpp"
BrunoSprite:          INCBIN "gfx/sprites/bruno.2bpp"
LoreleiSprite:        INCBIN "gfx/sprites/lorelei.2bpp"
SeelSprite:           INCBIN "gfx/sprites/seel.2bpp"

	dr $17c31,$17cb0
ActivatePC: ; 17cb0 (5:7cb0)
	dr $17cb0,$18000

SECTION "bank06",ROMX,BANK[$06]
	dr $18000,$1a4ea
PlayerStepOutFromDoor: ; 1a4ea (6:64ea)
	dr $1a4ea,$1a527
_EndNPCMovementScript: ; 1a527 (6:6527)
	dr $1a527,$1a54c
ProfOakMovementScriptPointerTable: ; 1a54c (6:654c)
	dr $1a54c,$1a622
PewterMuseumGuyMovementScriptPointerTable: ; 1a622 (6:6622)
	dr $1a622,$1a685
PewterGymGuyMovementScriptPointerTable: ; 1a685 (6:6685)
	dr $1a685,$1a785
IsPlayerStandingOnDoorTile: ; 1a785 (6:6785)
	dr $1a785,$1a7f4
HandleLedges: ; 1a7f4 (6:67f4)
	dr $1a7f4,$1c000

SECTION "bank07",ROMX,BANK[$07]

	dr $1c000,$1c21e
DoClearSaveDialogue: ; 1c21e (7:421e)
	dr $1c21e,$1e321
SafariZoneCheck: ; 1e321 (7:6e21)
	dr $1e321,$1e330
SafariZoneCheckSteps: ; 1e330 (7:6330)
	dr $1e330,$1e385
PrintSafariGameOverText: ; 1e385 (7:6385)
	dr $1e385,$1e4bf
CinnabarGymQuiz_1e4bf: ; 1e4bf (7:64bf)
	dr $1e4bf,$20000

SECTION "Pics 1", ROMX, BANK[PICS_1]

RhydonPicFront:      INCBIN "pic/ymon/rhydon.pic"
RhydonPicBack:       INCBIN "pic/monback/rhydonb.pic"
KangaskhanPicFront:  INCBIN "pic/ymon/kangaskhan.pic"
KangaskhanPicBack:   INCBIN "pic/monback/kangaskhanb.pic"
NidoranMPicFront:    INCBIN "pic/ymon/nidoranm.pic"
NidoranMPicBack:     INCBIN "pic/monback/nidoranmb.pic"
ClefairyPicFront:    INCBIN "pic/ymon/clefairy.pic"
ClefairyPicBack:     INCBIN "pic/monback/clefairyb.pic"
SpearowPicFront:     INCBIN "pic/ymon/spearow.pic"
SpearowPicBack:      INCBIN "pic/monback/spearowb.pic"
VoltorbPicFront:     INCBIN "pic/ymon/voltorb.pic"
VoltorbPicBack:      INCBIN "pic/monback/voltorbb.pic"
NidokingPicFront:    INCBIN "pic/ymon/nidoking.pic"
NidokingPicBack:     INCBIN "pic/monback/nidokingb.pic"
SlowbroPicFront:     INCBIN "pic/ymon/slowbro.pic"
SlowbroPicBack:      INCBIN "pic/monback/slowbrob.pic"
IvysaurPicFront:     INCBIN "pic/ymon/ivysaur.pic"
IvysaurPicBack:      INCBIN "pic/monback/ivysaurb.pic"
ExeggutorPicFront:   INCBIN "pic/ymon/exeggutor.pic"
ExeggutorPicBack:    INCBIN "pic/monback/exeggutorb.pic"
LickitungPicFront:   INCBIN "pic/ymon/lickitung.pic"
LickitungPicBack:    INCBIN "pic/monback/lickitungb.pic"
ExeggcutePicFront:   INCBIN "pic/ymon/exeggcute.pic"
ExeggcutePicBack:    INCBIN "pic/monback/exeggcuteb.pic"
GrimerPicFront:      INCBIN "pic/ymon/grimer.pic"
GrimerPicBack:       INCBIN "pic/monback/grimerb.pic"
GengarPicFront:      INCBIN "pic/ymon/gengar.pic"
GengarPicBack:       INCBIN "pic/monback/gengarb.pic"
NidoranFPicFront:    INCBIN "pic/ymon/nidoranf.pic"
NidoranFPicBack:     INCBIN "pic/monback/nidoranfb.pic"
NidoqueenPicFront:   INCBIN "pic/ymon/nidoqueen.pic"
NidoqueenPicBack:    INCBIN "pic/monback/nidoqueenb.pic"
CubonePicFront:      INCBIN "pic/ymon/cubone.pic"
CubonePicBack:       INCBIN "pic/monback/cuboneb.pic"
RhyhornPicFront:     INCBIN "pic/ymon/rhyhorn.pic"
RhyhornPicBack:      INCBIN "pic/monback/rhyhornb.pic"
LaprasPicFront:      INCBIN "pic/ymon/lapras.pic"
LaprasPicBack:       INCBIN "pic/monback/laprasb.pic"
ArcaninePicFront:    INCBIN "pic/ymon/arcanine.pic"
ArcaninePicBack:     INCBIN "pic/monback/arcanineb.pic"
MewPicFront:         INCBIN "pic/ymon/mew.pic"
MewPicBack:          INCBIN "pic/monback/mewb.pic"
GyaradosPicFront:    INCBIN "pic/ymon/gyarados.pic"
GyaradosPicBack:     INCBIN "pic/monback/gyaradosb.pic"
ShellderPicFront:    INCBIN "pic/ymon/shellder.pic"
ShellderPicBack:     INCBIN "pic/monback/shellderb.pic"
TentacoolPicFront:   INCBIN "pic/ymon/tentacool.pic"
TentacoolPicBack:    INCBIN "pic/monback/tentacoolb.pic"
GastlyPicFront:      INCBIN "pic/ymon/gastly.pic"
GastlyPicBack:       INCBIN "pic/monback/gastlyb.pic"
ScytherPicFront:     INCBIN "pic/ymon/scyther.pic"
ScytherPicBack:      INCBIN "pic/monback/scytherb.pic"
StaryuPicFront:      INCBIN "pic/ymon/staryu.pic"
StaryuPicBack:       INCBIN "pic/monback/staryub.pic"
BlastoisePicFront:   INCBIN "pic/ymon/blastoise.pic"
BlastoisePicBack:    INCBIN "pic/monback/blastoiseb.pic"
PinsirPicFront:      INCBIN "pic/ymon/pinsir.pic"
PinsirPicBack:       INCBIN "pic/monback/pinsirb.pic"
TangelaPicFront:     INCBIN "pic/ymon/tangela.pic"
TangelaPicBack:      INCBIN "pic/monback/tangelab.pic"

	dr $27d20,$27dff
SaveTrainerName: ; 27dff (9:7dff)
	dr $27dff,$28000

SECTION "Pics 2", ROMX, BANK[PICS_2]

GrowlithePicFront:   INCBIN "pic/ymon/growlithe.pic"
GrowlithePicBack:    INCBIN "pic/monback/growlitheb.pic"
OnixPicFront:        INCBIN "pic/ymon/onix.pic"
OnixPicBack:         INCBIN "pic/monback/onixb.pic"
FearowPicFront:      INCBIN "pic/ymon/fearow.pic"
FearowPicBack:       INCBIN "pic/monback/fearowb.pic"
PidgeyPicFront:      INCBIN "pic/ymon/pidgey.pic"
PidgeyPicBack:       INCBIN "pic/monback/pidgeyb.pic"
SlowpokePicFront:    INCBIN "pic/ymon/slowpoke.pic"
SlowpokePicBack:     INCBIN "pic/monback/slowpokeb.pic"
KadabraPicFront:     INCBIN "pic/ymon/kadabra.pic"
KadabraPicBack:      INCBIN "pic/monback/kadabrab.pic"
GravelerPicFront:    INCBIN "pic/ymon/graveler.pic"
GravelerPicBack:     INCBIN "pic/monback/gravelerb.pic"
ChanseyPicFront:     INCBIN "pic/ymon/chansey.pic"
ChanseyPicBack:      INCBIN "pic/monback/chanseyb.pic"
MachokePicFront:     INCBIN "pic/ymon/machoke.pic"
MachokePicBack:      INCBIN "pic/monback/machokeb.pic"
MrMimePicFront:      INCBIN "pic/ymon/mr.mime.pic"
MrMimePicBack:       INCBIN "pic/monback/mr.mimeb.pic"
HitmonleePicFront:   INCBIN "pic/ymon/hitmonlee.pic"
HitmonleePicBack:    INCBIN "pic/monback/hitmonleeb.pic"
HitmonchanPicFront:  INCBIN "pic/ymon/hitmonchan.pic"
HitmonchanPicBack:   INCBIN "pic/monback/hitmonchanb.pic"
ArbokPicFront:       INCBIN "pic/ymon/arbok.pic"
ArbokPicBack:        INCBIN "pic/monback/arbokb.pic"
ParasectPicFront:    INCBIN "pic/ymon/parasect.pic"
ParasectPicBack:     INCBIN "pic/monback/parasectb.pic"
PsyduckPicFront:     INCBIN "pic/ymon/psyduck.pic"
PsyduckPicBack:      INCBIN "pic/monback/psyduckb.pic"
DrowzeePicFront:     INCBIN "pic/ymon/drowzee.pic"
DrowzeePicBack:      INCBIN "pic/monback/drowzeeb.pic"
GolemPicFront:       INCBIN "pic/ymon/golem.pic"
GolemPicBack:        INCBIN "pic/monback/golemb.pic"
MagmarPicFront:      INCBIN "pic/ymon/magmar.pic"
MagmarPicBack:       INCBIN "pic/monback/magmarb.pic"
ElectabuzzPicFront:  INCBIN "pic/ymon/electabuzz.pic"
ElectabuzzPicBack:   INCBIN "pic/monback/electabuzzb.pic"
MagnetonPicFront:    INCBIN "pic/ymon/magneton.pic"
MagnetonPicBack:     INCBIN "pic/monback/magnetonb.pic"
KoffingPicFront:     INCBIN "pic/ymon/koffing.pic"
KoffingPicBack:      INCBIN "pic/monback/koffingb.pic"
MankeyPicFront:      INCBIN "pic/ymon/mankey.pic"
MankeyPicBack:       INCBIN "pic/monback/mankeyb.pic"
SeelPicFront:        INCBIN "pic/ymon/seel.pic"
SeelPicBack:         INCBIN "pic/monback/seelb.pic"
DiglettPicFront:     INCBIN "pic/ymon/diglett.pic"
DiglettPicBack:      INCBIN "pic/monback/diglettb.pic"
TaurosPicFront:      INCBIN "pic/ymon/tauros.pic"
TaurosPicBack:       INCBIN "pic/monback/taurosb.pic"
FarfetchdPicFront:   INCBIN "pic/ymon/farfetchd.pic"
FarfetchdPicBack:    INCBIN "pic/monback/farfetchdb.pic"
VenonatPicFront:     INCBIN "pic/ymon/venonat.pic"
VenonatPicBack:      INCBIN "pic/monback/venonatb.pic"
DragonitePicFront:   INCBIN "pic/ymon/dragonite.pic"
DragonitePicBack:    INCBIN "pic/monback/dragoniteb.pic"
DoduoPicFront:       INCBIN "pic/ymon/doduo.pic"
DoduoPicBack:        INCBIN "pic/monback/doduob.pic"
PoliwagPicFront:     INCBIN "pic/ymon/poliwag.pic"
PoliwagPicBack:      INCBIN "pic/monback/poliwagb.pic"
JynxPicFront:        INCBIN "pic/ymon/jynx.pic"
JynxPicBack:         INCBIN "pic/monback/jynxb.pic"
MoltresPicFront:     INCBIN "pic/ymon/moltres.pic"
MoltresPicBack:      INCBIN "pic/monback/moltresb.pic"

	dr $2bd4c,$2c000


SECTION "Pics 3", ROMX, BANK[PICS_3]

ArticunoPicFront:    INCBIN "pic/ymon/articuno.pic"
ArticunoPicBack:     INCBIN "pic/monback/articunob.pic"
ZapdosPicFront:      INCBIN "pic/ymon/zapdos.pic"
ZapdosPicBack:       INCBIN "pic/monback/zapdosb.pic"
DittoPicFront:       INCBIN "pic/ymon/ditto.pic"
DittoPicBack:        INCBIN "pic/monback/dittob.pic"
MeowthPicFront:      INCBIN "pic/ymon/meowth.pic"
MeowthPicBack:       INCBIN "pic/monback/meowthb.pic"
KrabbyPicFront:      INCBIN "pic/ymon/krabby.pic"
KrabbyPicBack:       INCBIN "pic/monback/krabbyb.pic"
VulpixPicFront:      INCBIN "pic/ymon/vulpix.pic"
VulpixPicBack:       INCBIN "pic/monback/vulpixb.pic"
NinetalesPicFront:   INCBIN "pic/ymon/ninetales.pic"
NinetalesPicBack:    INCBIN "pic/monback/ninetalesb.pic"
PikachuPicFront:     INCBIN "pic/ymon/pikachu.pic"
PikachuPicBack:      INCBIN "pic/monback/pikachub.pic"
RaichuPicFront:      INCBIN "pic/ymon/raichu.pic"
RaichuPicBack:       INCBIN "pic/monback/raichub.pic"
DratiniPicFront:     INCBIN "pic/ymon/dratini.pic"
DratiniPicBack:      INCBIN "pic/monback/dratinib.pic"
DragonairPicFront:   INCBIN "pic/ymon/dragonair.pic"
DragonairPicBack:    INCBIN "pic/monback/dragonairb.pic"
KabutoPicFront:      INCBIN "pic/ymon/kabuto.pic"
KabutoPicBack:       INCBIN "pic/monback/kabutob.pic"
KabutopsPicFront:    INCBIN "pic/ymon/kabutops.pic"
KabutopsPicBack:     INCBIN "pic/monback/kabutopsb.pic"
HorseaPicFront:      INCBIN "pic/ymon/horsea.pic"
HorseaPicBack:       INCBIN "pic/monback/horseab.pic"
SeadraPicFront:      INCBIN "pic/ymon/seadra.pic"
SeadraPicBack:       INCBIN "pic/monback/seadrab.pic"
SandshrewPicFront:   INCBIN "pic/ymon/sandshrew.pic"
SandshrewPicBack:    INCBIN "pic/monback/sandshrewb.pic"
SandslashPicFront:   INCBIN "pic/ymon/sandslash.pic"
SandslashPicBack:    INCBIN "pic/monback/sandslashb.pic"
OmanytePicFront:     INCBIN "pic/ymon/omanyte.pic"
OmanytePicBack:      INCBIN "pic/monback/omanyteb.pic"
OmastarPicFront:     INCBIN "pic/ymon/omastar.pic"
OmastarPicBack:      INCBIN "pic/monback/omastarb.pic"
JigglypuffPicFront:  INCBIN "pic/ymon/jigglypuff.pic"
JigglypuffPicBack:   INCBIN "pic/monback/jigglypuffb.pic"
WigglytuffPicFront:  INCBIN "pic/ymon/wigglytuff.pic"
WigglytuffPicBack:   INCBIN "pic/monback/wigglytuffb.pic"
EeveePicFront:       INCBIN "pic/ymon/eevee.pic"
EeveePicBack:        INCBIN "pic/monback/eeveeb.pic"
FlareonPicFront:     INCBIN "pic/ymon/flareon.pic"
FlareonPicBack:      INCBIN "pic/monback/flareonb.pic"
JolteonPicFront:     INCBIN "pic/ymon/jolteon.pic"
JolteonPicBack:      INCBIN "pic/monback/jolteonb.pic"
VaporeonPicFront:    INCBIN "pic/ymon/vaporeon.pic"
VaporeonPicBack:     INCBIN "pic/monback/vaporeonb.pic"
MachopPicFront:      INCBIN "pic/ymon/machop.pic"
MachopPicBack:       INCBIN "pic/monback/machopb.pic"
ZubatPicFront:       INCBIN "pic/ymon/zubat.pic"
ZubatPicBack:        INCBIN "pic/monback/zubatb.pic"
EkansPicFront:       INCBIN "pic/ymon/ekans.pic"
EkansPicBack:        INCBIN "pic/monback/ekansb.pic"
ParasPicFront:       INCBIN "pic/ymon/paras.pic"
ParasPicBack:        INCBIN "pic/monback/parasb.pic"
PoliwhirlPicFront:   INCBIN "pic/ymon/poliwhirl.pic"
PoliwhirlPicBack:    INCBIN "pic/monback/poliwhirlb.pic"
PoliwrathPicFront:   INCBIN "pic/ymon/poliwrath.pic"
PoliwrathPicBack:    INCBIN "pic/monback/poliwrathb.pic"
WeedlePicFront:      INCBIN "pic/ymon/weedle.pic"
WeedlePicBack:       INCBIN "pic/monback/weedleb.pic"
KakunaPicFront:      INCBIN "pic/ymon/kakuna.pic"
KakunaPicBack:       INCBIN "pic/monback/kakunab.pic"
BeedrillPicFront:    INCBIN "pic/ymon/beedrill.pic"
BeedrillPicBack:     INCBIN "pic/monback/beedrillb.pic"

FossilKabutopsPic:   INCBIN "pic/ymon/fossilkabutops.pic"

	dr $2fd25,$2fd42
CheckIfMoveIsKnown: ; 2fd42 (b:7d42)
	dr $2fd42,$2fd6a
Func_2fd6a: ; 2fd6a (b:7d6a)
	dr $2fd6a,$30000


SECTION "Pics 4", ROMX, BANK[PICS_4]

DodrioPicFront:       INCBIN "pic/ymon/dodrio.pic"
DodrioPicBack:        INCBIN "pic/monback/dodriob.pic"
PrimeapePicFront:     INCBIN "pic/ymon/primeape.pic"
PrimeapePicBack:      INCBIN "pic/monback/primeapeb.pic"
DugtrioPicFront:      INCBIN "pic/ymon/dugtrio.pic"
DugtrioPicBack:       INCBIN "pic/monback/dugtriob.pic"
VenomothPicFront:     INCBIN "pic/ymon/venomoth.pic"
VenomothPicBack:      INCBIN "pic/monback/venomothb.pic"
DewgongPicFront:      INCBIN "pic/ymon/dewgong.pic"
DewgongPicBack:       INCBIN "pic/monback/dewgongb.pic"
CaterpiePicFront:     INCBIN "pic/ymon/caterpie.pic"
CaterpiePicBack:      INCBIN "pic/monback/caterpieb.pic"
MetapodPicFront:      INCBIN "pic/ymon/metapod.pic"
MetapodPicBack:       INCBIN "pic/monback/metapodb.pic"
ButterfreePicFront:   INCBIN "pic/ymon/butterfree.pic"
ButterfreePicBack:    INCBIN "pic/monback/butterfreeb.pic"
MachampPicFront:      INCBIN "pic/ymon/machamp.pic"
MachampPicBack:       INCBIN "pic/monback/machampb.pic"
GolduckPicFront:      INCBIN "pic/ymon/golduck.pic"
GolduckPicBack:       INCBIN "pic/monback/golduckb.pic"
HypnoPicFront:        INCBIN "pic/ymon/hypno.pic"
HypnoPicBack:         INCBIN "pic/monback/hypnob.pic"
GolbatPicFront:       INCBIN "pic/ymon/golbat.pic"
GolbatPicBack:        INCBIN "pic/monback/golbatb.pic"
MewtwoPicFront:       INCBIN "pic/ymon/mewtwo.pic"
MewtwoPicBack:        INCBIN "pic/monback/mewtwob.pic"
SnorlaxPicFront:      INCBIN "pic/ymon/snorlax.pic"
SnorlaxPicBack:       INCBIN "pic/monback/snorlaxb.pic"
MagikarpPicFront:     INCBIN "pic/ymon/magikarp.pic"
MagikarpPicBack:      INCBIN "pic/monback/magikarpb.pic"
MukPicFront:          INCBIN "pic/ymon/muk.pic"
MukPicBack:           INCBIN "pic/monback/mukb.pic"
KinglerPicFront:      INCBIN "pic/ymon/kingler.pic"
KinglerPicBack:       INCBIN "pic/monback/kinglerb.pic"
CloysterPicFront:     INCBIN "pic/ymon/cloyster.pic"
CloysterPicBack:      INCBIN "pic/monback/cloysterb.pic"
ElectrodePicFront:    INCBIN "pic/ymon/electrode.pic"
ElectrodePicBack:     INCBIN "pic/monback/electrodeb.pic"
ClefablePicFront:     INCBIN "pic/ymon/clefable.pic"
ClefablePicBack:      INCBIN "pic/monback/clefableb.pic"
WeezingPicFront:      INCBIN "pic/ymon/weezing.pic"
WeezingPicBack:       INCBIN "pic/monback/weezingb.pic"
PersianPicFront:      INCBIN "pic/ymon/persian.pic"
PersianPicBack:       INCBIN "pic/monback/persianb.pic"
MarowakPicFront:      INCBIN "pic/ymon/marowak.pic"
MarowakPicBack:       INCBIN "pic/monback/marowakb.pic"
HaunterPicFront:      INCBIN "pic/ymon/haunter.pic"
HaunterPicBack:       INCBIN "pic/monback/haunterb.pic"
AbraPicFront:         INCBIN "pic/ymon/abra.pic"
AbraPicBack:          INCBIN "pic/monback/abrab.pic"
AlakazamPicFront:     INCBIN "pic/ymon/alakazam.pic"
AlakazamPicBack:      INCBIN "pic/monback/alakazamb.pic"
PidgeottoPicFront:    INCBIN "pic/ymon/pidgeotto.pic"
PidgeottoPicBack:     INCBIN "pic/monback/pidgeottob.pic"
PidgeotPicFront:      INCBIN "pic/ymon/pidgeot.pic"
PidgeotPicBack:       INCBIN "pic/monback/pidgeotb.pic"
StarmiePicFront:      INCBIN "pic/ymon/starmie.pic"
StarmiePicBack:       INCBIN "pic/monback/starmieb.pic"


SECTION "Pics 5", ROMX, BANK[PICS_5]

BulbasaurPicFront:    INCBIN "pic/ymon/bulbasaur.pic"
BulbasaurPicBack:     INCBIN "pic/monback/bulbasaurb.pic"
VenusaurPicFront:     INCBIN "pic/ymon/venusaur.pic"
VenusaurPicBack:      INCBIN "pic/monback/venusaurb.pic"
TentacruelPicFront:   INCBIN "pic/ymon/tentacruel.pic"
TentacruelPicBack:    INCBIN "pic/monback/tentacruelb.pic"
GoldeenPicFront:      INCBIN "pic/ymon/goldeen.pic"
GoldeenPicBack:       INCBIN "pic/monback/goldeenb.pic"
SeakingPicFront:      INCBIN "pic/ymon/seaking.pic"
SeakingPicBack:       INCBIN "pic/monback/seakingb.pic"
PonytaPicFront:       INCBIN "pic/ymon/ponyta.pic"
RapidashPicFront:     INCBIN "pic/ymon/rapidash.pic"
PonytaPicBack:        INCBIN "pic/monback/ponytab.pic"
RapidashPicBack:      INCBIN "pic/monback/rapidashb.pic"
RattataPicFront:      INCBIN "pic/ymon/rattata.pic"
RattataPicBack:       INCBIN "pic/monback/rattatab.pic"
RaticatePicFront:     INCBIN "pic/ymon/raticate.pic"
RaticatePicBack:      INCBIN "pic/monback/raticateb.pic"
NidorinoPicFront:     INCBIN "pic/ymon/nidorino.pic"
NidorinoPicBack:      INCBIN "pic/monback/nidorinob.pic"
NidorinaPicFront:     INCBIN "pic/ymon/nidorina.pic"
NidorinaPicBack:      INCBIN "pic/monback/nidorinab.pic"
GeodudePicFront:      INCBIN "pic/ymon/geodude.pic"
GeodudePicBack:       INCBIN "pic/monback/geodudeb.pic"
PorygonPicFront:      INCBIN "pic/ymon/porygon.pic"
PorygonPicBack:       INCBIN "pic/monback/porygonb.pic"
AerodactylPicFront:   INCBIN "pic/ymon/aerodactyl.pic"
AerodactylPicBack:    INCBIN "pic/monback/aerodactylb.pic"
MagnemitePicFront:    INCBIN "pic/ymon/magnemite.pic"
MagnemitePicBack:     INCBIN "pic/monback/magnemiteb.pic"
CharmanderPicFront:   INCBIN "pic/ymon/charmander.pic"
CharmanderPicBack:    INCBIN "pic/monback/charmanderb.pic"
SquirtlePicFront:     INCBIN "pic/ymon/squirtle.pic"
SquirtlePicBack:      INCBIN "pic/monback/squirtleb.pic"
CharmeleonPicFront:   INCBIN "pic/ymon/charmeleon.pic"
CharmeleonPicBack:    INCBIN "pic/monback/charmeleonb.pic"
WartortlePicFront:    INCBIN "pic/ymon/wartortle.pic"
WartortlePicBack:     INCBIN "pic/monback/wartortleb.pic"
CharizardPicFront:    INCBIN "pic/ymon/charizard.pic"
CharizardPicBack:     INCBIN "pic/monback/charizardb.pic"
FossilAerodactylPic:  INCBIN "pic/ymon/fossilaerodactyl.pic"
GhostPic:             INCBIN "pic/other/ghost.pic"
OddishPicFront:       INCBIN "pic/ymon/oddish.pic"
OddishPicBack:        INCBIN "pic/monback/oddishb.pic"
GloomPicFront:        INCBIN "pic/ymon/gloom.pic"
GloomPicBack:         INCBIN "pic/monback/gloomb.pic"
VileplumePicFront:    INCBIN "pic/ymon/vileplume.pic"
VileplumePicBack:     INCBIN "pic/monback/vileplumeb.pic"
BellsproutPicFront:   INCBIN "pic/ymon/bellsprout.pic"
BellsproutPicBack:    INCBIN "pic/monback/bellsproutb.pic"
WeepinbellPicFront:   INCBIN "pic/ymon/weepinbell.pic"
WeepinbellPicBack:    INCBIN "pic/monback/weepinbellb.pic"
VictreebelPicFront:   INCBIN "pic/ymon/victreebel.pic"
VictreebelPicBack:    INCBIN "pic/monback/victreebelb.pic"

	dr $3749e,$38000

SECTION "bank0E",ROMX,BANK[$0E]

INCLUDE "data/moves.asm"
BaseStats: INCLUDE "data/base_stats.asm"
INCLUDE "data/cries.asm"	
	dr $3969c,$39893
TrainerPicAndMoneyPointers: ; 39893 (e:5893)
	dr $39893,$3997e
TrainerNames: ; 3997e (e:597e)
	dr $3997e,$39b06
FormatMovesString: ; 39b06 (e:5b06)
	dr $39b06,$39b54
InitList: ; 39b54 (e:5b54)
	dr $39b54,$39bb6
ReadTrainer: ; 39bb6 (e:5bb6)
	dr $39bb6,$3a8df
DrawAllPokeballs: ; 3a8df (e:68df)
	dr $3a8df,$3a9e9
SetupPlayerAndEnemyPokeballs: ; 3a9e9 (e:69e9)
	dr $3a9e9,$3aa28
	
PokeballTileGraphics:: ; 3aa28 (e:6a28)
;	INCBIN "gfx/pokeball.2bpp"
;PokeballTileGraphicsEnd:
	dr $3aa28,$3aa68

TradingAnimationGraphics:
	INCBIN "gfx/game_boy.norepeat.2bpp"
	INCBIN "gfx/link_cable.2bpp"

TradingAnimationGraphics2:
; Pokeball traveling through the link cable.
	INCBIN "gfx/trade2.2bpp"

TryEvolvingMon:
EvolveTradeMon: ; 3adb8 (e:6db8)
	dr $3adb8,$3b10f
Func_3b10f: ; 3b01f (e:710f)
	dr $3b10f,$3b1e5
Pointer_3b1e5: ; 3b1e5 (e:71e5)
	dr $3b1e5,$3c000


SECTION "bank0F",ROMX,BANK[$0F]

	dr $3c000,$3c04c
SlidePlayerAndEnemySilhouettesOnScreen: ; 3c04c (f:404c)
	dr $3c04c,$3c127
StartBattle: ; 3c127 (f:4127)
	dr $3c127,$3cae8
AnyPartyAlive: ; 3cae8 (f:4ae8)
	dr $3cae8,$3ce08
ReadPlayerMonCurHPAndStatus: ; 3ce08 (f:4e08)
	dr $3ce08,$3ce1f
DrawHUDsAndHPBars: ; 3ce1f (f:4e1f)
	dr $3ce1f,$3ceb1
DrawEnemyHUDAndHPBar: ; 3ceb1 (f:4eb1)
	dr $3ceb1,$3d320
MoveSelectionMenu: ; 3d320 (f:5320)
	dr $3d320,$3d9ac
IsGhostBattle: ; 3d9ac (f:59ac)
	dr $3d9ac,$3ddc3
PrintDoesntAffectText: ; 3ddc3 (f:5dc3)
	dr $3ddc3,$3e5bb

AIGetTypeEffectiveness: ; 3e5bb (f:65bb)
	ld a,[W_ENEMYMOVETYPE]
	ld d,a                 ; d = type of enemy move
	ld hl,wBattleMonType
	ld b,[hl]              ; b = type 1 of player's pokemon
	inc hl
	ld c,[hl]              ; c = type 2 of player's pokemon
	ld a,$10
	ld [wd11e],a           ; initialize [wd11e] to neutral effectiveness
	ld hl,TypeEffects
.loop
	ld a,[hli]
	cp a,$ff
	ret z
	cp d                   ; match the type of the move
	jr nz,.nextTypePair1
	ld a,[hli]
	cp b                   ; match with type 1 of pokemon
	jr z,.done
	cp c                   ; or match with type 2 of pokemon
	jr z,.done
	jr .nextTypePair2
.nextTypePair1
	inc hl
.nextTypePair2
	inc hl
	jr .loop

.done
	ld a, [W_TRAINERCLASS]
	cp LORELEI
	jr nz, .ok
	ld a, [wEnemyMonSpecies]
	cp DEWGONG
	jr nz, .ok
	call BattleRandom
	cp $66 ; 40 percent
	ret c
.ok

	ld a,[hl]
	ld [wd11e],a           ; store damage multiplier
	ret

INCLUDE "data/type_effects.asm"

MoveHitTest: ; 3e6f1 (f:66f1)
	dr $3e6f1,$3ec87
LoadEnemyMonData: ; 3ec87 (f:6c87)
	dr $3ec87,$3edb8
DoBattleTransitionAndInitBattleVariables: ; 3edb8 (f:6db8)
	dr $3edb8,$3eeb3
QuarterSpeedDueToParalysis: ; 3eeb3 (f:6eb3)
	dr $3eeb3,$3efe7
LoadHudTilePatterns: ; 3efe7 (f:6fe7)
	dr $3efe7,$3f027
BattleRandom: ; 3f027 (f:7027)
	dr $3f027,$3f3de
StatModifierUpEffect: ; 3f3de (f:73de)
	dr $3f3de,$3fb2e
PrintButItFailedText_: ; 3fb2e (f:7b2e)
	dr $3fb2e,$3fb39
PrintDidntAffectText: ; 3fb39 (f:7b39)
	dr $3fb39,$3fb49
PrintMayNotAttackText: ; 3fb49 (f:7b49)
	dr $3fb49,$3fb83
PlayCurrentMoveAnimation: ; 3fb83 (f:7b83)
	dr $3fb83,$40000

SECTION "bank10",ROMX,BANK[$10]

	dr $40000,$4050b
Pointer_4050b: ; 4050b (10:450b)
	dr $4050b,$41c70
DisplayOptionMenu_: ; 41c70 (10:57c0)
	dr $41c70,$44000


SECTION "bank11",ROMX,BANK[$11]

	dr $44000,$45077
LoadSpinnerArrowTiles: ; 45077 (11:5077)
	dr $45077,$48000


SECTION "bank12",ROMX,BANK[$12]

	dr $48000,$4c000


SECTION "bank13",ROMX,BANK[$13]

TrainerPics:
YoungsterPic:     INCBIN "pic/trainer/youngster.pic"
BugCatcherPic:    INCBIN "pic/trainer/bugcatcher.pic"
LassPic:          INCBIN "pic/trainer/lass.pic"
SailorPic:        INCBIN "pic/trainer/sailor.pic"
JrTrainerMPic:    INCBIN "pic/trainer/jr.trainerm.pic"
JrTrainerFPic:    INCBIN "pic/trainer/jr.trainerf.pic"
PokemaniacPic:    INCBIN "pic/trainer/pokemaniac.pic"
SuperNerdPic:     INCBIN "pic/trainer/supernerd.pic"
HikerPic:         INCBIN "pic/trainer/hiker.pic"
BikerPic:         INCBIN "pic/trainer/biker.pic"
BurglarPic:       INCBIN "pic/trainer/burglar.pic"
EngineerPic:      INCBIN "pic/trainer/engineer.pic"
FisherPic:        INCBIN "pic/trainer/fisher.pic"
SwimmerPic:       INCBIN "pic/trainer/swimmer.pic"
CueBallPic:       INCBIN "pic/trainer/cueball.pic"
GamblerPic:       INCBIN "pic/trainer/gambler.pic"
BeautyPic:        INCBIN "pic/trainer/beauty.pic"
PsychicPic:       INCBIN "pic/trainer/psychic.pic"
RockerPic:        INCBIN "pic/trainer/rocker.pic"
JugglerPic:       INCBIN "pic/trainer/juggler.pic"
TamerPic:         INCBIN "pic/trainer/tamer.pic"
BirdKeeperPic:    INCBIN "pic/trainer/birdkeeper.pic"
BlackbeltPic:     INCBIN "pic/trainer/blackbelt.pic"
Rival1Pic:        INCBIN "pic/ytrainer/rival1.pic"
ProfOakPic:       INCBIN "pic/trainer/prof.oak.pic"
ChiefPic:
ScientistPic:     INCBIN "pic/trainer/scientist.pic"
GiovanniPic:      INCBIN "pic/trainer/giovanni.pic"
RocketPic:        INCBIN "pic/trainer/rocket.pic"
CooltrainerMPic:  INCBIN "pic/trainer/cooltrainerm.pic"
CooltrainerFPic:  INCBIN "pic/trainer/cooltrainerf.pic"
BrunoPic:         INCBIN "pic/trainer/bruno.pic"
BrockPic:         INCBIN "pic/ytrainer/brock.pic"
MistyPic:         INCBIN "pic/ytrainer/misty.pic"
LtSurgePic:       INCBIN "pic/trainer/lt.surge.pic"
ErikaPic:         INCBIN "pic/ytrainer/erika.pic"
KogaPic:          INCBIN "pic/trainer/koga.pic"
BlainePic:        INCBIN "pic/trainer/blaine.pic"
SabrinaPic:       INCBIN "pic/trainer/sabrina.pic"
GentlemanPic:     INCBIN "pic/trainer/gentleman.pic"
Rival2Pic:        INCBIN "pic/ytrainer/rival2.pic"
Rival3Pic:        INCBIN "pic/ytrainer/rival3.pic"
LoreleiPic:       INCBIN "pic/trainer/lorelei.pic"
ChannelerPic:     INCBIN "pic/trainer/channeler.pic"
AgathaPic:        INCBIN "pic/trainer/agatha.pic"
LancePic:         INCBIN "pic/trainer/lance.pic"
JessieJamesPic:   INCBIN "pic/ytrainer/jessiejames.pic"

	dr $4fe79,$50000


SECTION "bank14",ROMX,BANK[$14]

	dr $50000,$525d8
PrintCardKeyText: ; 525d8 (14:65d8)
	dr $525d8,$5267d
CeladonPrizeMenu: ; 5267d (14:667d)
	dr $5267d,$54000

SECTION "bank15",ROMX,BANK[$15]

	dr $54000,$56745
_GetSpritePosition1: ; 56745 (15:6745)
	dr $56745,$56765
_GetSpritePosition2: ; 56765 (15:6765)
	dr $56765,$56789
_SetSpritePosition1: ; 56789 (15:6789)
	dr $56789,$567a9
_SetSpritePosition2: ; 567a9 (15:67a9)
	dr $567a9,$567cd
TrainerWalkUpToPlayer: ; 567cd (15:67cd)
	dr $567cd,$58000
SECTION "bank16",ROMX,BANK[$16]

	dr $58000,$58d99
CalcLevelFromExperience: ; 58d99 (16:4d99)
	dr $58d99,$58dc0
CalcExperience: ; 58dc0 (16:4dc0)
	dr $58dc0,$58e8b
PrintStatusAilment: ; 58e8b (16:4e8b)
	dr $58e8b,$5c000


SECTION "bank17",ROMX,BANK[$17]

	dr $5c000,$60000


SECTION "bank18",ROMX,BANK[$18]

	dr $60000,$64000


SECTION "bank19",ROMX,BANK[$19]
Overworld_GFX:
	dr $64000,$68000


SECTION "bank1A",ROMX,BANK[$1A]

	dr $68000,$6c000


SECTION "bank1B",ROMX,BANK[$1B]
Cemetery_GFX:      INCBIN "gfx/tilesets/cemetery.t4.2bpp"
Cemetery_Block:    INCBIN "gfx/blocksets/cemetery.bst"
Cavern_GFX:        INCBIN "gfx/tilesets/cavern.t14.2bpp"
Cavern_Block:      INCBIN "gfx/blocksets/cavern.bst"
Lobby_GFX:         INCBIN "gfx/tilesets/lobby.t2.2bpp"
Lobby_Block:       INCBIN "gfx/blocksets/lobby.bst"
Ship_GFX:          INCBIN "gfx/tilesets/ship.t6.2bpp"
Ship_Block:        INCBIN "gfx/blocksets/ship.bst"
Lab_GFX:           INCBIN "gfx/tilesets/lab.t4.2bpp"
Lab_Block:         INCBIN "gfx/blocksets/lab.bst"
Club_GFX:          INCBIN "gfx/tilesets/club.t5.2bpp"
Club_Block:        INCBIN "gfx/blocksets/club.bst"
Underground_GFX:   INCBIN "gfx/tilesets/underground.t7.2bpp"
Underground_Block: INCBIN "gfx/blocksets/underground.bst"


SECTION "bank1C",ROMX,BANK[$1C]

INCLUDE "engine/gamefreak.asm"
INCLUDE "engine/hall_of_fame.asm"
INCLUDE "engine/overworld/healing_machine.asm"
INCLUDE "engine/overworld/player_animations.asm"
INCLUDE "engine/battle/ghost_marowak_anim.asm"
INCLUDE "engine/battle/battle_transitions.asm"
INCLUDE "engine/town_map.asm"
INCLUDE "engine/mon_party_sprites.asm"
INCLUDE "engine/in_game_trades.asm"
INCLUDE "engine/palettes.asm"
INCLUDE "engine/save.asm"


SECTION "bank1D",ROMX,BANK[$1D]

	dr $74000,$7405c
HiddenItemNear: ; 7405c (1d:405c)
	dr $7405c,$74726
VendingMachineMenu: ; 74726 (1d:4726)
	dr $74726,$78000

SECTION "bank1E",ROMX,BANK[$1E]

	dr $78000,$78757
AnimationTileset2: ; 78757 (1e:4757)
	dr $78757,$79816
HideSubstituteShowMonAnim: ; 79816 (1e:5816)
	dr $79816,$798b2
ReshowSubstituteAnim: ; 798b2 (1e:58b2)
	dr $798b2,$798c8
AnimationTransformMon: ; 798c8 (1e:58c8)
	dr $798c8,$798d4
ChangeMonPic: ; 798d4 (1e:58d4)
	dr $798d4,$7a037
AnimCut: ; 7a037 (1e:6037)
	dr $7a037,$7a0fb
AnimateBoulderDust: ; 7a0fb (1e:60fb)
	dr $7a0fb,$7a19a
	
RedFishingTilesFront: INCBIN "gfx/red_fishing_tile_front.2bpp"
RedFishingTilesBack:  INCBIN "gfx/red_fishing_tile_back.2bpp"
RedFishingTilesSide:  INCBIN "gfx/red_fishing_tile_side.2bpp"
RedFishingRodTiles:   INCBIN "gfx/red_fishingrod_tiles.2bpp"

	dr $7a22a,$7c000

SECTION "bank20",ROMX,BANK[$20]

	dr $80000,$80f14

SurfingPikachu1Graphics:  INCBIN "gfx/surfing_pikachu_1.t4.2bpp"
Func_82bd4: ; 82bd4 (20:6bd4)
	dr $82bd4,$84000

SECTION "bank2f",ROMX[$5000],BANK[$2F]
	dr $bd000,$bf450
Func_bf450: ; bf450 (2f:7450)
	dr $bf450,$c0000

SECTION "bank30",ROMX,BANK[$30]

	dr $c0000,$c4000

SECTION "bank39",ROMX,BANK[$39]

	dr $e4000,$e8000


SECTION "bank3A",ROMX,BANK[$3A]
MonsterNames: ; e8000 (3a:4000)
	dr $e8000,$e8a5e
Func_e8a5e: ; e8a5e (3a:4a5e)
	dr $e8a5e,$e8d35
Func_e8d35:: ; e8d35 (3a:4d35)
	dr $e8d35,$e8e79
Func_e8e79: ; e8e79 (3a:4e79)
	dr $e8e79,$e928a
SurfingPikachu2Graphics:  INCBIN "gfx/surfing_pikachu_2.2bpp"
	dr $e988a,$e9bfa

SurfingPikachu3Graphics:  INCBIN "gfx/surfing_pikachu_3.t1.2bpp"

	dr $ea3ea,$eaa02
FreezeEnemyTrainerSprite: ; eaa02 (3a:6a02)
	dr $eaa02,$ec000

SECTION "bank3C",ROMX,BANK[$3C]

INCLUDE "engine/bank3c/main.asm"

SECTION "bank3D",ROMX,BANK[$3D]

INCLUDE "engine/bank3d/main.asm"

SECTION "bank3E",ROMX,BANK[$3E]

	dr $f8000,$fa35a

YellowIntroGraphics:  INCBIN "gfx/yellow_intro.2bpp"

	dr $fbb5a,$fc000

SECTION "bank3F",ROMX,BANK[$3F]

INCLUDE "engine/bank3f/main.asm"
