InitBattle: ; f5ff2 (3d:5ff2)
	ld a, [W_CUROPPONENT]
	and a
	jr z, asm_f6003

InitOpponent: ; f5ff8 (3d:5ff8)
	ld a, [W_CUROPPONENT]
	ld [wcf91], a
	ld [wEnemyMonSpecies2], a
	jr asm_f601d
asm_f6003: ; f6003 (3d:6003)
	ld a, [wd732]
	bit 1, a
	jr z, .asm_f600f
	ld a, [hJoyHeld]
	bit 1, a ; B button pressed?
	ret nz
.asm_f600f
	ld a, [wNumberOfNoRandomBattleStepsLeft]
	and a
	ret nz
	callab TryDoWildEncounter
	ret nz
asm_f601d: ; f601d (f:601d)
	ld a, [wMapPalOffset]
	push af
	ld hl, wd358
	ld a, [hl]
	push af
	res 1, [hl]
	call InitBattleVariables ; 3d:6236
	ld a, [wEnemyMonSpecies2]
	sub $c8
	jp c, InitWildBattle
	ld [W_TRAINERCLASS], a
	call GetTrainerInformation
	callab ReadTrainer
	callab DoBattleTransitionAndInitBattleVariables
	call _LoadTrainerPic ; 3d:615a
	xor a
	ld [wEnemyMonSpecies2], a
	ld [$ffe1], a
	dec a
	ld [wAICount], a
	hlCoord 12, 0
	predef Func_3f0c6
	ld a, $ff
	ld [wEnemyMonPartyPos], a
	ld a, $2
	ld [W_ISINBATTLE], a
	ld a,[W_LONEATTACKNO]
	and a
	jp z,InitBattle_Common
	ld hl,Func_f430a
	ld b,BANK(Func_f430a)
	ld d,$4
	call Bankswitch ; useless since already in bank3d
	jp InitBattle_Common

InitWildBattle: ; f607c (3d:607c)
	ld a, $1
	ld [W_ISINBATTLE], a
	callab LoadEnemyMonData
	callab DoBattleTransitionAndInitBattleVariables
	ld a, [W_CUROPPONENT]
	cp MAROWAK
	jr z, .isGhost
	callab IsGhostBattle
	jr nz, .isNoGhost
.isGhost
	ld hl, W_MONHSPRITEDIM
	ld a, $66
	ld [hli], a   ; write sprite dimensions
	ld bc, GhostPic
	ld a, c
	ld [hli], a   ; write front sprite pointer
	ld [hl], b
	ld hl, wEnemyMonNick  ; set name to "GHOST"
	ld a, "G"
	ld [hli], a
	ld a, "H"
	ld [hli], a
	ld a, "O"
	ld [hli], a
	ld a, "S"
	ld [hli], a
	ld a, "T"
	ld [hli], a
	ld [hl], "@"
	ld a, [wcf91]
	push af
	ld a, MON_GHOST
	ld [wcf91], a
	ld de, vFrontPic
	call LoadMonFrontSprite ; load ghost sprite
	pop af
	ld [wcf91], a
	jr .spriteLoaded
.isNoGhost
	ld de, vFrontPic
	call LoadMonFrontSprite ; load mon sprite
.spriteLoaded
	xor a
	ld [W_TRAINERCLASS], a
	ld [$ffe1], a
	hlCoord 12, 0
	predef Func_3f0c6

; common code that executes after init battle code specific to trainer or wild battles
InitBattle_Common: ; f60eb (3d:60eb)
	ld b, $0
	call GoPAL_SET
	callab SlidePlayerAndEnemySilhouettesOnScreen
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld hl, .emptyString
	call PrintText
	call SaveScreenTilesToBuffer1
	call ClearScreen
	ld a, $98
	ld [$ffbd], a
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	call Delay3
	ld a, $9c
	ld [$ffbd], a
	call LoadScreenTilesFromBuffer1
	hlCoord 9, 7
	ld bc, $50a
	call ClearScreenArea
	hlCoord 1, 0
	ld bc, $40a
	call ClearScreenArea
	call ClearSprites
	ld a, [W_ISINBATTLE]
	dec a ; is it a wild battle?
	ld hl, DrawEnemyHUDAndHPBar
	ld b,BANK(DrawEnemyHUDAndHPBar)
	call z, Bankswitch ; draw enemy HUD and HP bar if it's a wild battle
	callab StartBattle
	callab EndOfBattle
	pop af
	ld [wd358], a
	pop af
	ld [wMapPalOffset], a
	ld a, [wd0d4]
	ld [hTilesetType], a
	scf
	ret
.emptyString
	db "@"

_LoadTrainerPic: ; f615a (3d:615a)
; wd033-wd034 contain pointer to pic
	ld a, [wTrainerPicPointer] ; wd033
	ld e, a
	ld a, [wTrainerPicPointer + 1] ; wd034
	ld d, a ; de contains pointer to trainer pic
	ld a, [wLinkState]
	and a
	ld a, Bank(TrainerPics) ; this is where all the trainer pics are (not counting Red's)
	jr z, .loadSprite
	ld a, Bank(RedPicFront)
.loadSprite
	call UncompressSpriteFromDE
	ld de, vFrontPic
	ld a, $77
	ld c, a
	jp LoadUncompressedSpriteData
	
LoadMonBackPic: ; f6178 (3d:6178)
; Assumes the monster's attributes have
; been loaded with GetMonHeader.
	ld a, [wBattleMonSpecies2]
	ld [wcf91], a
	hlCoord 1, 5
	ld bc,$708
	call ClearScreenArea
	ld hl,  W_MONHBACKSPRITE - W_MONHEADER
	call UncompressMonSprite
	predef ScaleSpriteByTwo
	ld de, vBackPic
	call InterlaceMergeSpriteBuffers ; combine the two buffers to a single 2bpp sprite
	ld hl, vSprites
	ld de, vBackPic
	ld c, (2*SPRITEBUFFERSIZE)/16 ; count of 16-byte chunks to be copied
	ld a, [H_LOADEDROMBANK]
	ld b, a
	jp CopyVideoData
	
Func_f61a6: ; f61a6 (3d:f61a6)
	ld a, [wPredefRegisters]
	ld h, a
	ld a, [wPredefRegisters + 1]
	ld l, a
	ld a, [$ffe1]
	ld [H_DOWNARROWBLINKCNT1], a
	ld b, $4c
	ld a, [W_ISINBATTLE]
	and a
	jr z, .asm_f61ef
	add b
	ld [hl], a
	call Delay3
	ld bc, -41
	add hl, bc
	ld a, $1
	ld [wcd6c], a
	ld bc, $303
	predef Func_79aba
	ld c, $4
	call DelayFrames
	ld bc, -41
	add hl, bc
	xor a
	ld [wcd6c], a
	ld bc, $505
	predef Func_79aba
	ld c, $5
	call DelayFrames
	ld bc, -41
	jr .asm_f61f2
.asm_f61ef
	ld bc, -123
.asm_f61f2
	add hl, bc
	ld a, [H_DOWNARROWBLINKCNT1]
	add $31
	jr asm_f6203

Func_f61f9: ; 3f0c6 (f:70c6)
	ld a, [wPredefRegisters]
	ld h, a
	ld a, [wPredefRegisters + 1]
	ld l, a
	ld a, [$ffe1]
asm_f6203: ; f6203 (3d:6203)
	ld bc, $707
	ld de, $14
	push af
	ld a, [W_SPRITEFLIPPED]
	and a
	jr nz, .asm_f6220
	pop af
.asm_f6211
	push bc
	push hl
.asm_f6213
	ld [hl], a
	add hl, de
	inc a
	dec c
	jr nz, .asm_f6213
	pop hl
	inc hl
	pop bc
	dec b
	jr nz, .asm_f6211
	ret
	
.asm_f6220
	push bc
	ld b, $0
	dec c
	add hl, bc
	pop bc
	pop af
.asm_f6227
	push bc
	push hl
.asm_f6229
	ld [hl], a
	add hl, de
	inc a
	dec c
	jr nz, .asm_f6229
	pop hl
	dec hl
	pop bc
	dec b
	jr nz, .asm_f6227
	ret
	
INCLUDE "engine/battle/init_battle_variables.asm"
INCLUDE "engine/battle/moveEffects/focus_energy_effect.asm"
INCLUDE "engine/battle/moveEffects/heal_effect.asm"
INCLUDE "engine/battle/moveEffects/transform_effect.asm"
INCLUDE "engine/battle/moveEffects/reflect_light_screen_effect.asm"
INCLUDE "engine/battle/moveEffects/mist_effect.asm"
INCLUDE "engine/battle/moveEffects/one_hit_ko_effect.asm"
INCLUDE "engine/battle/moveEffects/pay_day_effect.asm"
INCLUDE "engine/battle/moveEffects/paralyze_effect.asm"