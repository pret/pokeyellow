INCLUDE "engine/battle/common_text.asm"
INCLUDE "engine/battle/link_battle_versus_text.asm"
INCLUDE "engine/battle/unused_stats_functions.asm"
INCLUDE "engine/battle/scroll_draw_trainer_pic.asm"

Func_f429f:: ; f429f (3d:429f)
	coord hl, 0,5
	ld c,$0
.asm_f42a4
	inc c
	ld a,c
	cp $9
	ret z
	ld d,$5b
	push bc
	push hl
.asm_f42ad
	call Func_f42c2
	dec hl
	ld a,d
	sub $7
	ld d,a
	dec c
	jr nz,.asm_f42ad
	ld c,$2
	call DelayFrames
	pop hl
	pop bc
	inc hl
	jr .asm_f42a4
	
Func_f42c2:: ; f42c2 (3d:f42c2)
	push hl
	push de
	push bc
	ld e,$7
.loop
	ld a,d
	cp $31
	jr nc,.asm_f42ce
	ld a,$7f
.asm_f42ce
	ld [hl],a
	ld bc,$14
	add hl,bc
	inc d
	dec e
	jr nz,.loop
	pop bc
	pop de
	pop hl
	ret
	
INCLUDE "engine/battle/decrement_pp.asm"

ModifyPikachuHappiness:: ; f430a (3d:430a)
	ld a, d
	cp PIKAHAPPY_GYMLEADER
	jr z, .checkanywhereinparty
	cp PIKAHAPPY_WALKING
	jr z, .checkanywhereinparty
	push de
	callab IsThisPartymonOurPikachu
	pop de
	ret nc
	jr .proceed

.checkanywhereinparty
	push de
	callab IsPikachuInOurParty
	pop de
	ret nc

.proceed
	push de
	; Divide [wPikachuHappiness] by 100.  Hold the integer part in e.
	ld e, $0
	ld a, [wPikachuHappiness]
	cp 100
	jr c, .wPikachuHappiness_div_100
	inc e
	cp 200
	jr c, .wPikachuHappiness_div_100
	inc e
.wPikachuHappiness_div_100
	; Get the (d, e) entry from .HappinessChangeTable.
	ld c, d
	dec c
	ld b, $0
	ld hl, .HappinessChangeTable
	add hl, bc
	add hl, bc
	add hl, bc
	ld d, $0
	add hl, de
	ld a, [hl]
	; If [hl] is positive, take min(0xff, [hl] + [wPikachuHappiness]).
	; If [hl] is negative, take max(0x00, [hl] + [wPikachuHappiness]).
	; Inexplicably, we're using 100 as the threshold for comparison.
	cp 100
	ld a, [wPikachuHappiness]
	jr nc, .negative
	add [hl]
	jr nc, .okay
	ld a, -1
	jr .okay

.negative
	add [hl]
	jr c, .okay
	xor a
.okay
	ld [wPikachuHappiness], a
	
	; Restore d and get the d'th entry in .Moods.
	pop de
	dec d
	ld hl, .Moods
	ld e, d
	ld d, $0
	add hl, de
	ld a, [hl]
	ld b, a
	; Modify Pikachu's mood
	cp $80
	jr z, .done
	ld a, [wPikachuMood]
	jr c, .decreased
	cp b
	jr nc, .done
	ld a, [wd49c]
	and a
	jr nz, .done
	jr .update_mood

.decreased
	cp b
	jr c, .done
.update_mood
	ld a, b
	ld [wPikachuMood], a
.done
	ret
	
.HappinessChangeTable: ; f4385 (3d:4385)
	; Increase
	db   5,   3,   2 ; Gained a level
	db   5,   3,   2 ; HP restore
	db   1,   1,   0 ; Unknown (d = 3)
	db   3,   2,   1 ; Challenged Gym Leader
	db   1,   1,   0 ; Teach TM/HM
	db   2,   1,   1 ; Walking around
	; Decrease
	db  -3,  -3,  -5 ; Deposited
	db  -1,  -1,  -1 ; Fainted in battle
	db  -5,  -5, -10 ; Fainted due to Poison outside of battle
	db  -5,  -5, -10 ; Unknown (d = 10)
	db -10, -10, -20 ; Unknown (d = 11)

.Moods: ; f43a6 (3d:43a6)
	; Increase
	db $8a           ; Gained a level
	db $83           ; HP restore
	db $80           ; Teach TM/HM
	db $80           ; Challenged Gym Leader
	db $94           ; Unknown (d = 5)
	db $80           ; Unknown (d = 6)
	; Decrease
	db $62           ; Deposited
	db $6c           ; Fainted
	db $62           ; Unknown (d = 9)
	db $6c           ; Unknown (d = 10)
	db $00           ; Unknown (d = 11)

; f43b1 (3d:43b1)
RedPicBack::	   INCBIN "pic/trainer/redb.pic"
OldManPic::	    INCBIN "pic/trainer/oldman.pic"
OakPicBack::	   INCBIN "pic/ytrainer/prof.oakb.pic"
 
;SECTION "bank3d Yellow Intro",ROMX[$453f],BANK[$3D]

Func_f453f:: ; f453f (3d:453f)
	ld hl,PokemonLogoGraphics
	ld de,vChars2
	ld bc,$730
	ld a,BANK(PokemonLogoGraphics) ; redundant because this function is in bank3d
	call FarCopyData
	ld hl,YellowLogoGraphics+$230
	ld de,vChars0+$fd0
	ld bc,$30
	ld a,BANK(YellowLogoGraphics)
	call FarCopyData
	ld hl,YellowLogoGraphics+$260
	ld de,vChars1
	ld bc,$400
	ld a,BANK(YellowLogoGraphics)
	call FarCopyData
	ld hl,YellowLogoGraphics+$660
	ld de,vChars0+$f00
	ld bc,$c0
	ld a,BANK(YellowLogoGraphics)
	call FarCopyData
	ret
	
Func_f4578:: ; f4578 (3d:4578)
	coord hl, 2,1
	ld de,Pointer_f45f9
	ld bc,7 << 8 | 16 ; 16x7 (xy)
	call CopyScreenArea
	ret
	
Func_f4585:: ; f4585 (3d:4585)
	coord hl, 6,4
	ld de,Pointer_f4673
	ld bc,4 << 8 | 7 ; 7x4 (xy)
	call CopyScreenArea
	coord hl, 9,8
	ld [hl],$64
	inc hl
	ld [hl],$65
	ret
	
Func_f459a:: ; f459a (3d:459a)
	coord hl, 4,8
	ld de,Pointer_f468f
	ld bc,9 << 8 | 12 ; 12x9 (xy)
	call CopyScreenArea
	coord hl, 16,10
	ld [hl],$96
	coord hl, 16,11
	ld [hl],$9d
	coord hl, 16,12
	ld [hl],$a7
	coord hl, 16,13
	ld [hl],$b1
	ld hl,Pointer_f45c7
	ld de,wOAMBuffer
	ld bc,$20
	call CopyData
	ret
	
Pointer_f45c7: ; f45c7 (3d:45c7)
	db $60,$40,$f1,$22
	db $60,$48,$f0,$22
	db $68,$40,$f3,$22
	db $68,$48,$f2,$22
	db $60,$60,$f0,$02
	db $60,$68,$f1,$02
	db $68,$60,$f2,$02
	db $68,$68,$f3,$02
	
CopyScreenArea:: ; f45e7 (3d:45e7)
; copy cxb (xy) screen area from de to hl
	push bc
	push hl
.loop
	ld a,[de]
	inc de
	ld [hli],a
	dec c
	jr nz,.loop
	pop hl
	ld bc,$14
	add hl,bc
	pop bc
	dec b
	jr nz,CopyScreenArea
	ret
	
Pointer_f45f9: ; f45f9 (3d:45f9)
; 16x7 (xy)
	db $f4,$f4,$f4,$f4,$f4,$f4,$49,$f4,$72,$30,$f4,$f4,$f4,$f4,$f4,$f4
	db $fd,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$f4,$0d,$0e,$0f
	db $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f
	db $20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f
	db $f4,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f
	db $f4,$41,$42,$43,$44,$45,$46,$47,$48,$f4,$4a,$4b,$4c,$4d,$4e,$4f
	db $f4,$6a,$6b,$6c,$6d,$f4,$f4,$f4,$f4,$f4,$f4,$6e,$6f,$70,$71,$f4

Pointer_f4669:: ; f4669 (3d:4669)
	db $47,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$5f
	
Pointer_f4673:: ; f4673 (3d:4673)
; 7x4 (xy)
	db $24,$25,$66,$67,$68,$69,$2a
	db $50,$51,$52,$53,$54,$55,$56
	db $57,$58,$59,$5a,$5b,$5c,$5d
	db $6d,$5e,$5f,$60,$61,$62,$63
	
Pointer_f468f:: ; f468f (3d:468f)
; 12x9 (xy)
	db $80,$81,$82,$83,$00,$00,$00,$00,$84,$85,$86,$87
	db $88,$89,$8a,$8b,$8c,$8d,$8d,$8e,$8f,$8a,$90,$91
	db $00,$92,$93,$8a,$8a,$8a,$8a,$8a,$8a,$94,$95,$00
	db $00,$00,$97,$8a,$8a,$98,$99,$8a,$8a,$9a,$9b,$9c
	db $00,$00,$9e,$9f,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$8a
	db $00,$a8,$a9,$aa,$8a,$ab,$ac,$8a,$ad,$ae,$af,$b0
	db $00,$b2,$b3,$b4,$8a,$8a,$8a,$8a,$b5,$b6,$b7,$b8
	db $00,$b9,$ba,$8a,$8a,$8a,$8a,$8a,$8a,$bb,$bc,$00
	db $00,$00,$bd,$8a,$8a,$8a,$8a,$8a,$8a,$be,$bf,$00
	
; f46f9 (3d:46f9)
PokemonLogoGraphics:	     INCBIN "gfx/pokemon_logo.2bpp"
YellowLogoGraphics:	      INCBIN "gfx/yellow_titlescreen.2bpp"

INCLUDE "engine/bank3d/link_menu.asm"

HandleMenuInputDouble:: ; f5a40 (3d:5a40)
	xor a
	ld [wPartyMenuAnimMonEnabled],a

HandleMenuInputPokemonSelectionDouble:: ; f5a44 (3d:5a44)
	ld a,[H_DOWNARROWBLINKCNT1]
	push af
	ld a,[H_DOWNARROWBLINKCNT2]
	push af ; save existing values on stack
	xor a
	ld [H_DOWNARROWBLINKCNT1],a ; blinking down arrow timing value 1
	ld a,$06
	ld [H_DOWNARROWBLINKCNT2],a ; blinking down arrow timing value 2
.loop1
	xor a
	ld [wAnimCounter],a ; counter for pokemon shaking animation
	call Func_f5ab0
	call JoypadLowSensitivity
	ld a,[hJoy5]
	and a ; was a key pressed?
	jr nz,.keyPressed
	pop af
	ld [H_DOWNARROWBLINKCNT2],a
	pop af
	ld [H_DOWNARROWBLINKCNT1],a ; restore previous values
	xor a
	ld [wMenuWrappingEnabled],a ; disable menu wrapping
	ret
.keyPressed
	xor a
	ld [wCheckFor180DegreeTurn],a
	ld a,[hJoy5]
	ld b,a
	bit 6,a ; pressed Up key?
	jr z,.checkIfDownPressed
.upPressed
	ld a,[wCurrentMenuItem] ; selected menu item
	and a ; already at the top of the menu?
	jr z,.checkOtherKeys
.notAtTop
	dec a
	ld [wCurrentMenuItem],a ; move selected menu item up one space
	jr .checkOtherKeys
.checkIfDownPressed
	bit 7,a
	jr z,.checkOtherKeys
.downPressed
	ld a,[wCurrentMenuItem]
	inc a
	ld c,a
	ld a,[wMaxMenuItem]
	cp c
	jr c,.checkOtherKeys
	ld a,c
	ld [wCurrentMenuItem],a
.checkOtherKeys
	ld a,[wMenuWatchedKeys]
	and b ; does the menu care about any of the pressed keys?
	jp z,.loop1
.checkIfAButtonOrBButtonPressed
	ld a,[hJoy5]
	and A_BUTTON | B_BUTTON
	jr z,.skipPlayingSound
.AButtonOrBButtonPressed
	ld a, $90 ; (SFX_02_40 - SFX_Headers_02) / 3
	call PlaySound ; play sound
.skipPlayingSound
	pop af
	ld [H_DOWNARROWBLINKCNT2],a
	pop af
	ld [H_DOWNARROWBLINKCNT1],a ; restore previous values
	ld a,[hJoy5]
	ret
	
Func_f5ab0:: ; f5ab0 (3d:5ab0)
	ld a,[wTopMenuItemY]
	and a
	jr z,.asm_f5ac0
	coord hl, 0,0
	ld bc,$14
.loop
	add hl,bc
	dec a
	jr nz,.loop
.asm_f5ac0
	ld a,[wTopMenuItemX]
	ld b,$0
	ld c,a
	add hl,bc
	push hl
	ld a,[wLastMenuItem]
	and a
	jr z,.asm_f5ad5
	ld bc,$28
.loop2
	add hl,bc
	dec a
	jr nz,.loop2
.asm_f5ad5
	ld a,[hl]
	cp "▶"
	jr nz,.asm_f5ade
	ld a,[wTileBehindCursor]
	ld [hl],a
.asm_f5ade
	pop hl
	ld a,[wCurrentMenuItem]
	and a
	jr z,.asm_f5aec
	ld bc,$28
.loop3
	add hl,bc
	dec a
	jr nz,.loop3
.asm_f5aec
	ld a,[hl]
	cp "▶"
	jr z,.asm_f5af4
	ld [wTileBehindCursor],a
.asm_f5af4
	ld a,"▶"
	ld [hl],a
	ld a,l
	ld [wMenuCursorLocation],a
	ld a,h
	ld [wMenuCursorLocation+1],a
	ld a,[wCurrentMenuItem]
	ld [wLastMenuItem],a
	ret
	
Func_f5b06:: ; f5b06 (3d:5b06)
	ld hl,wd728
	set 0,[hl]
	ld hl,Text_f5b17
	call PrintText
	ld hl,Text_f5b28
	jp PrintText
	
Text_f5b17:: ; f5b17 (3d:5b17)
	TX_FAR _UsedStrengthText ; 2d:417e
	db $08 ; asm
	ld a,[wcf91]
	call PlayCry
	call Delay3
	jp TextScriptEnd
	
Text_f5b28:: ; f5b28 (3d:5b28)
	TX_FAR _CanMoveBouldersText ; 2d:4193
	db "@"
	
Func_f5b2d:: ; f5b2d (3d:5b2d)
	ld hl,wd728
	set 1,[hl]
	ld a,[wd732]
	bit 5,a
	jr nz,.asm_f5b59
	ld a,[W_CURMAP]
	cp SEAFOAM_ISLANDS_5
	ret nz
	ld a,[wd881]
	and $3
	cp $3
	ret z
	ld hl,CoordsData_f5b64
	call ArePlayerCoordsInArray
	ret nc
	ld hl,wd728
	res 1,[hl]
	ld hl,Text_f5b67
	jp PrintText
.asm_f5b59
	ld hl,wd728
	res 1,[hl]
	ld hl,Text_f5b6c
	jp PrintText
	
CoordsData_f5b64:: ; f5b64 (3d:5b64)
	db 11,07
	db $ff
	
Text_f5b67:: ; f5b67 (3d:5b67)
	TX_FAR _CurrentTooFastText ; 2d:41ab
	db "@"
	
Text_f5b6c:: ; f5b6c (3d:5b6c)
	TX_FAR _CyclingIsFunText ; 2d:41ca
	db "@"
	
AddItemToInventory_:: ; f5b70 (3d:5b70)
	ld a,[wItemQuantity] ; a = item quantity
	push af
	push bc
	push de
	push hl
	push hl
	ld d,50 ; PC box can hold 50 items
	ld a,wNumBagItems & $FF
	cp l
	jr nz,.checkIfInventoryFull
	ld a,wNumBagItems >> 8
	cp h
	jr nz,.checkIfInventoryFull
; if the destination is the bag
	ld d,20 ; bag can hold 20 items
.checkIfInventoryFull
	ld a,[hl]
	sub d
	ld d,a
	ld a,[hli]
	and a
	jr z,.addNewItem
.notAtEndOfInventory
	ld a,[hli]
	ld b,a ; b = ID of current item in table
	ld a,[wcf91] ; a = ID of item being added
	cp b ; does the current item in the table match the item being added?
	jp z,.increaseItemQuantity ; if so, increase the item's quantity
	inc hl
.loop
	ld a,[hl]
	cp a,$ff ; is it the end of the table?
	jr nz, .notAtEndOfInventory
.addNewItem ; add an item not yet in the inventory
	pop hl
	ld a,d
	and a ; is there room for a new item slot?
	jr z,.done
; if there is room
	inc [hl] ; increment the number of items in the inventory
	ld a,[hl] ; the number of items will be the index of the new item
	add a
	dec a
	ld c,a
	ld b,0
	add hl,bc ; hl = address to store the item
	ld a,[wcf91]
	ld [hli],a ; store item ID
	ld a,[wItemQuantity]
	ld [hli],a ; store item quantity
	ld [hl],$ff ; store terminator
	jp .success
.increaseItemQuantity ; increase the quantity of an item already in the inventory
	ld a,[wItemQuantity]
	ld b,a ; b = quantity to add
	ld a,[hl] ; a = existing item quantity
	add b ; a = new item quantity
	cp a,100
	jp c,.storeNewQuantity ; if the new quantity is less than 100, store it
; if the new quantity is greater than or equal to 100,
; try to max out the current slot and add the rest in a new slot
	sub a,99
	ld [wItemQuantity],a ; a = amount left over (to put in the new slot)
	ld a,d
	and a ; is there room for a new item slot?
	jr z,.increaseItemQuantityFailed
; if so, store 99 in the current slot and store the rest in a new slot
	ld a,99
	ld [hli],a
	jp .loop
.increaseItemQuantityFailed
	pop hl
	and a
	jr .done
.storeNewQuantity
	ld [hl],a
	pop hl
.success
	scf
.done
	pop hl
	pop de
	pop bc
	pop bc
	ld a,b
	ld [wItemQuantity],a ; restore the initial value from when the function was called
	ret

; function to remove an item (in varying quantities) from the player's bag or PC box
; INPUT:
; hl = address of inventory (either wNumBagItems or wNumBoxItems)
; [wWhichPokemon] = index (within the inventory) of the item to remove
; [wItemQuantity] = quantity to remove
RemoveItemFromInventory_: ; f5be1 (3d:5be1)
	push hl
	inc hl
	ld a,[wWhichPokemon] ; index (within the inventory) of the item being removed
	add a
	add l
	ld l,a
	jr nc,.noCarry
	inc h
.noCarry
	inc hl
	ld a,[wItemQuantity] ; quantity being removed
	ld e,a
	ld a,[hl] ; a = current quantity
	sub e
	ld [hld],a ; store new quantity
	ld [wMaxItemQuantity],a
	and a
	jr nz,.skipMovingUpSlots
; if the remaining quantity is 0,
; remove the emptied item slot and move up all the following item slots
.moveSlotsUp
	ld e,l
	ld d,h
	inc de
	inc de ; de = address of the slot following the emptied one
.loop ; loop to move up the following slots
	ld a,[de]
	inc de
	ld [hli],a
	cp a,$ff
	jr nz,.loop
; update menu info
	xor a
	ld [wListScrollOffset],a
	ld [wCurrentMenuItem],a
	ld [wBagSavedMenuItem],a
	ld [wSavedListScrollOffset],a
	pop hl
	ld a,[hl] ; a = number of items in inventory
	dec a ; decrement the number of items
	ld [hl],a ; store new number of items
	ld [wListCount],a
	cp a,2
	jr c,.done
	ld [wMaxMenuItem],a
	jr .done
.skipMovingUpSlots
	pop hl
.done
	ret

TrainerInfoTextBoxTileGraphics:	INCBIN "gfx/trainer_info.2bpp"
BlankLeaderNames:				INCBIN "gfx/blank_leader_names.2bpp"
CircleTile:						INCBIN "gfx/circle_tile.2bpp"
BadgeNumbersTileGraphics:		INCBIN "gfx/badge_numbers.2bpp"

ReadSuperRodData:: ; f5ea4 (3d:5ea4)
	ld a,[W_CURMAP]
	ld c,a
	ld hl,FishingSlots
.loop
	ld a,[hli]
	cp $ff
	jr z,.notfound
	cp c
	jr z,.found
	ld de,$8
	add hl,de
	jr .loop
.found
	call GenerateRandomFishingEncounter
	ret
.notfound
	ld de,$0
	ret
	
GenerateRandomFishingEncounter: ; f5ec1 (3d:5ec1)
	call Random
	cp $66
	jr c,.asm_f5ed6
	inc hl
	inc hl
	cp $b2
	jr c,.asm_f5ed6
	inc hl
	inc hl
	cp $e5
	jr c,.asm_f5ed6
	inc hl
	inc hl
.asm_f5ed6
	ld e,[hl]
	inc hl
	ld d,[hl]
	ret
	
INCLUDE "data/super_rod.asm"
INCLUDE "engine/bank3d/bank3d_battle.asm"
INCLUDE "engine/items/tm_prices.asm"
INCLUDE "engine/multiply_divide.asm"
INCLUDE "engine/give_pokemon.asm"
INCLUDE "engine/battle/get_trainer_name.asm"
INCLUDE "engine/bank3d/random.asm"
INCLUDE "engine/predefs.asm"