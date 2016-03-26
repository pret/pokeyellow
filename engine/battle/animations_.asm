; Draws a "frame block". Frame blocks are blocks of tiles that are put
; together to form frames in battle animations.
DrawFrameBlock: ; 78000 (1e:4000)
	ld l,c
	ld h,b
	ld a,[hli]
	ld [wNumFBTiles],a
	ld a,[wFBDestAddr + 1]
	ld e,a
	ld a,[wFBDestAddr]
	ld d,a
	xor a
	ld [wFBTileCounter],a ; loop counter
.loop
	ld a,[wFBTileCounter]
	inc a
	ld [wFBTileCounter],a
	ld a, $2
	ld [wdef5], a
	ld a,[wSubAnimTransform]
	dec a
	jr z,.flipHorizontalAndVertical   ; 1
	dec a
	jp z,.flipHorizontalTranslateDown ; 2
	dec a
	jr z,.flipBaseCoords              ; 3
.noTransformation
	ld a,[wBaseCoordY]
	add [hl]
	ld [de],a ; store Y
	inc hl
	inc de
	ld a,[wBaseCoordX]
	jr .finishCopying
.flipBaseCoords
	ld a,[wBaseCoordY]
	ld b,a
	ld a,136
	sub b ; flip Y base coordinate
	add [hl] ; Y offset
	ld [de],a ; store Y
	inc hl
	inc de
	ld a,[wBaseCoordX]
	ld b,a
	ld a,168
	sub b ; flip X base coordinate
.finishCopying ; finish copying values to OAM (when [wSubAnimTransform] not 1 or 2)
	add [hl] ; X offset
	ld [de],a ; store X
	cp 88
	jr c, .asm_78056
	ld a, [wdef5]
	inc a
	ld [wdef5], a
.asm_78056
	inc hl
	inc de
	ld a,[hli]
	add a,$31 ; base tile ID for battle animations
	ld [de],a ; store tile ID
	inc de
	ld a,[hli]
	ld b, a
	ld a, [wdef5]
	or b
	ld [de],a ; store flags
	inc de
	jp .nextTile
.flipHorizontalAndVertical
	ld a,[wBaseCoordY]
	add [hl] ; Y offset
	ld b,a
	ld a,136
	sub b ; flip Y coordinate
	ld [de],a ; store Y
	inc hl
	inc de
	ld a,[wBaseCoordX]
	add [hl] ; X offset
	ld b,a
	ld a,168
	sub b ; flip X coordinate
	ld [de],a ; store X
	cp 88
	jr c, .asm_78087
	ld a, [wdef5]
	inc a
	ld [wdef5], a
.asm_78087
	inc hl
	inc de
	ld a,[hli]
	add a,$31 ; base tile ID for battle animations
	ld [de],a ; store tile ID
	inc de
; toggle horizontal and vertical flip
	ld a,[hli] ; flags
	and a
	ld b,OAM_VFLIP | OAM_HFLIP
	jr z,.storeFlags1
	cp a,OAM_HFLIP
	ld b,OAM_VFLIP
	jr z,.storeFlags1
	cp a,OAM_VFLIP
	ld b,OAM_HFLIP
	jr z,.storeFlags1
	ld b,0
.storeFlags1
	ld a, [wdef5]
	or b
	ld [de],a
	inc de
	jp .nextTile
.flipHorizontalTranslateDown
	ld a,[wBaseCoordY]
	add [hl]
	add a,40 ; translate Y coordinate downwards
	ld [de],a ; store Y
	inc hl
	inc de
	ld a,[wBaseCoordX]
	add [hl]
	ld b,a
	ld a,168
	sub b ; flip X coordinate
	ld [de],a ; store X
	cp 88
	jr c, .asm_780c8
	ld a, [wdef5]
	inc a
	ld [wdef5], a
.asm_780c8
	inc hl
	inc de
	ld a,[hli]
	add a,$31 ; base tile ID for battle animations
	ld [de],a ; store tile ID
	inc de
	ld a,[hli]
	bit 5,a ; is horizontal flip enabled?
	jr nz,.disableHorizontalFlip
.enableHorizontalFlip
	set 5,a
	jr .storeFlags2
.disableHorizontalFlip
	res 5,a
.storeFlags2
	ld b, a
	ld a, [wdef5]
	or b
	ld [de],a
	inc de
.nextTile
	ld a,[wFBTileCounter]
	ld c,a
	ld a,[wNumFBTiles]
	cp c
	jp nz,.loop ; go back up if there are more tiles to draw
.afterDrawingTiles
	ld a,[wFBMode]
	cp a,2
	jr z,.advanceFrameBlockDestAddr; skip delay and don't clean OAM buffer
	ld a,[wSubAnimFrameDelay]
	ld c,a
	call DelayFrames
	ld a,[wFBMode]
	cp a,3
	jr z,.advanceFrameBlockDestAddr ; skip cleaning OAM buffer
	cp a,4
	jr z,.done ; skip cleaning OAM buffer and don't advance the frame block destination address
	ld a,[wAnimationID]
	cp a,GROWL
	jr z,.resetFrameBlockDestAddr
	call AnimationCleanOAM
.resetFrameBlockDestAddr
	ld hl,wOAMBuffer ; OAM buffer
	ld a,l
	ld [wFBDestAddr + 1],a
	ld a,h
	ld [wFBDestAddr],a ; set destination address to beginning of OAM buffer
	ret
.advanceFrameBlockDestAddr
	ld a,e
	ld [wFBDestAddr + 1],a
	ld a,d
	ld [wFBDestAddr],a
.done
	ret

PlayAnimation: ; 78124 (1e:4124)
	xor a
	ld [$FF8B],a ; it looks like nothing reads this
	ld [wSubAnimTransform],a
	ld a,[wAnimationID] ; get animation number
	dec a
	ld l,a
	ld h,0
	add hl,hl
	ld de,AttackAnimationPointers  ; animation command stream pointers
	add hl,de
	ld a,[hli]
	ld h,[hl]
	ld l,a
.animationLoop
	ld a,[hli]
	cp a,$FF
	jr z,.AnimationOver
	cp a,$C0 ; is this subanimation or a special effect?
	jr c,.playSubanimation
.doSpecialEffect
	ld c,a
	ld de,SpecialEffectPointers
.searchSpecialEffectTableLoop
	ld a,[de]
	cp c
	jr z,.foundMatch
	inc de
	inc de
	inc de
	jr .searchSpecialEffectTableLoop
.foundMatch
	ld a,[hli]
	cp a,$FF ; is there a sound to play?
	jr z,.skipPlayingSound
	ld [wAnimSoundID],a ; store sound
	push hl
	push de
	call GetMoveSound
	call PlaySound
	pop de
	pop hl
.skipPlayingSound
	push hl
	inc de
	ld a,[de]
	ld l,a
	inc de
	ld a,[de]
	ld h,a
	ld de,.nextAnimationCommand
	push de
	jp [hl] ; jump to special effect function
.playSubanimation
	ld c,a
	and a,%00111111
	ld [wSubAnimFrameDelay],a
	xor a
	sla c
	rla
	sla c
	rla
	ld [wWhichBattleAnimTileset],a
	ld a,[hli] ; sound
	ld [wAnimSoundID],a ; store sound
	ld a,[hli] ; subanimation ID
	ld c,l
	ld b,h
	ld l,a
	ld h,0
	add hl,hl
	ld de,SubanimationPointers
	add hl,de
	ld a,l
	ld [wSubAnimAddrPtr],a
	ld a,h
	ld [wSubAnimAddrPtr + 1],a
	ld l,c
	ld h,b
	push hl
	ld a,[rOBP0]
	push af
	ld a,[wAnimPalette]
	ld [rOBP0],a
	call UpdateGBCPal_OBP0
	call LoadAnimationTileset
	call LoadSubanimation
	call PlaySubanimation
	pop af
	ld [rOBP0],a
	call UpdateGBCPal_OBP0
.nextAnimationCommand
	pop hl
	jr .animationLoop
.AnimationOver ; 417B
	ret

LoadSubanimation: ; 781b5 (1e:41b5)
	ld a,[wSubAnimAddrPtr + 1]
	ld h,a
	ld a,[wSubAnimAddrPtr]
	ld l,a
	ld a,[hli]
	ld e,a
	ld a,[hl]
	ld d,a ; de = address of subanimation
	ld a,[de]
	ld b,a
	and a,31
	ld [wSubAnimCounter],a ; number of frame blocks
	ld a,b
	and a,%11100000
	cp a,5 << 5 ; is subanimation type 5?
	jr nz,.isNotType5
.isType5
	call GetSubanimationTransform2
	jr .saveTransformation
.isNotType5
	call GetSubanimationTransform1
.saveTransformation
; place the upper 3 bits of a into bits 0-2 of a before storing
	srl a
	swap a
	ld [wSubAnimTransform],a
	cp a,4 ; is the animation reversed?
	ld hl,0
	jr nz,.storeSubentryAddr
; if the animation is reversed, then place the initial subentry address at the end of the list of subentries
	ld a,[wSubAnimCounter]
	dec a
	ld bc,3
.loop
	add hl,bc
	dec a
	jr nz,.loop
.storeSubentryAddr
	inc de
	add hl,de
	ld a,l
	ld [wSubAnimSubEntryAddr],a
	ld a,h
	ld [wSubAnimSubEntryAddr + 1],a
	ret

; called if the subanimation type is not 5
; sets the transform to 0 (i.e. no transform) if it's the player's turn
; sets the transform to the subanimation type if it's the enemy's turn
GetSubanimationTransform1: ; 781fb (1e:41fb)
	ld b,a
	ld a,[H_WHOSETURN]
	and a
	ld a,b
	ret nz
	xor a
	ret

; called if the subanimation type is 5
; sets the transform to 2 (i.e. horizontal and vertical flip) if it's the player's turn
; sets the transform to 0 (i.e. no transform) if it's the enemy's turn
GetSubanimationTransform2: ; 78203 (1e:4203)
	ld a,[H_WHOSETURN]
	and a
	ld a,2 << 5
	ret z
	xor a
	ret

; loads tile patterns for battle animations
LoadAnimationTileset: ; 7820b (1e:420b)
	ld a,[wWhichBattleAnimTileset]
	add a
	add a
	ld hl,AnimationTilesetPointers
	ld e,a
	ld d,0
	add hl,de
	ld a,[hli]
	ld [wTempTilesetNumTiles],a ; number of tiles
	ld a,[hli]
	ld e,a
	ld a,[hl]
	ld d,a ; de = address of tileset
	ld hl,vSprites + $310
	ld b, BANK(AnimationTileset1) ; ROM bank
	ld a,[wTempTilesetNumTiles]
	ld c,a ; number of tiles
	jp CopyVideoData ; load tileset

AnimationTilesetPointers: ; 7822b (1e:422b)
	db 79 ; number of tiles
	dw AnimationTileset1
	db $FF

	db 79 ; number of tiles
	dw AnimationTileset2
	db $FF

	db 64 ; number of tiles
	dw AnimationTileset1
	db $FF

AnimationTileset1: ; 78237 (1e:4237)
	INCBIN "gfx/attack_anim_1.2bpp"

AnimationTileset2: ; 78757 (1e:4757)
	INCBIN "gfx/attack_anim_2.2bpp"

SlotMachineTiles2: ; 78bde (1e:4c17)
	INCBIN "gfx/slotmachine2.2bpp"

MoveAnimation: ; 78d97 (1e:4d97)
	push hl
	push de
	push bc
	push af
	call WaitForSoundToFinish
	call SetAnimationPalette
	ld a,[wAnimationID]
	and a
	jr z, .animationFinished

	; if throwing a Poké Ball, skip the regular animation code
	cp a,TOSS_ANIM
	jr nz, .moveAnimation
	ld de, .animationFinished
	push de
	jp TossBallAnimation

.moveAnimation
	; check if battle animations are disabled in the options
	ld a,[wOptions]
	bit 7,a
	jr nz, .animationsDisabled
	call ShareMoveAnimations
	call PlayAnimation
	jr .next4
.animationsDisabled
	ld c,30
	call DelayFrames
.next4
	call PlayApplyingAttackAnimation ; shake the screen or flash the pic in and out (to show damage)
.animationFinished
	call WaitForSoundToFinish
	xor a
	ld [wSubAnimSubEntryAddr],a
	ld [wUnusedD09B],a
	ld [wSubAnimTransform],a
	dec a
	ld [wAnimSoundID],a
	pop af
	pop bc
	pop de
	pop hl
	ret

ShareMoveAnimations: ; 78ddf (1e:4ddf)
; some moves just reuse animations from status conditions
	ld a,[H_WHOSETURN]
	and a
	ret z

	; opponent’s turn

	ld a,[wAnimationID]

	cp a,AMNESIA
	ld b,CONF_ANIM
	jr z, .replaceAnim

	cp a,REST
	ld b,SLP_ANIM
	ret nz

.replaceAnim
	ld a,b
	ld [wAnimationID],a
	ret

PlayApplyingAttackAnimation: ; 78df6 (1e:4df6)
; Generic animation that shows after the move's individual animation
; Different animation depending on whether the move has an additional effect and on whose turn it is
	ld a,[wAnimationType]
	and a
	ret z
	dec a
	add a
	ld c,a
	ld b,0
	ld hl,AnimationTypePointerTable
	add hl,bc
	ld a,[hli]
	ld h,[hl]
	ld l,a
	jp [hl]

AnimationTypePointerTable: ; 78e08 (1e:4e08)
	dw ShakeScreenVertically ; enemy mon has used a damaging move without a side effect
	dw ShakeScreenHorizontallyHeavy ; enemy mon has used a damaging move with a side effect
	dw ShakeScreenHorizontallySlow ; enemy mon has used a non-damaging move
	dw BlinkEnemyMonSprite ; player mon has used a damaging move without a side effect
	dw ShakeScreenHorizontallyLight ; player mon has used a damaging move with a side effect
	dw ShakeScreenHorizontallySlow2 ; player mon has used a non-damaging move

ShakeScreenVertically: ; 78e14 (1e:4e14)
	call PlayApplyingAttackSound
	ld b, 8
	jp AnimationShakeScreenVertically

ShakeScreenHorizontallyHeavy: ; 78e1c (1e:4e1c)
	call PlayApplyingAttackSound
	ld b, 8
	jp AnimationShakeScreenHorizontallyFast

ShakeScreenHorizontallySlow: ; 78e24 (1e:4e24)
	lb bc, 6, 2
	jr AnimationShakeScreenHorizontallySlow

BlinkEnemyMonSprite: ; 78e29 (1e:4e29)
	call PlayApplyingAttackSound
	jp AnimationBlinkEnemyMon

ShakeScreenHorizontallyLight: ; 78e2f (1e:4e2f)
	call PlayApplyingAttackSound
	ld b, 2
	jp AnimationShakeScreenHorizontallyFast

ShakeScreenHorizontallySlow2: ; 78e37 (1e:4e37)
	lb bc, 3, 2

AnimationShakeScreenHorizontallySlow: ; 78e3a (1e:4e3a)
	push bc
	push bc
.loop1
	ld a, [rWX]
	inc a
	ld [rWX], a
	ld c, 2
	call DelayFrames
	dec b
	jr nz, .loop1
	pop bc
.loop2
	ld a, [rWX]
	dec a
	ld [rWX], a
	ld c, 2
	call DelayFrames
	dec b
	jr nz, .loop2
	pop bc
	dec c
	jr nz, AnimationShakeScreenHorizontallySlow
	ret

SetAnimationPalette: ; 78e5c (1e:4e5c)
	ld a, [wOnSGB]
	and a
	ld a, $e4
	jr z, .notSGB
	ld a, $f0
	ld [wAnimPalette], a
	ld b, $e4
	ld a, [wAnimationID]
	cp TRADE_BALL_DROP_ANIM
	jr c, .next
	cp TRADE_BALL_POOF_ANIM + 1
	jr nc, .next
	ld b, $f0
.next
	ld a, b
	ld [rOBP0], a
	ld a, $6c
	ld [rOBP1], a
	call UpdateGBCPal_OBP0
	call UpdateGBCPal_OBP1
	ret
.notSGB
	ld a, $e4
	ld [wAnimPalette], a
	ld [rOBP0], a
	ld a, $6c
	ld [rOBP1], a
	call UpdateGBCPal_OBP0
	call UpdateGBCPal_OBP1
	ret
	
Func_78e98: ; 78e98 (1e:4e98)
	call SaveScreenTilesToBuffer2
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	call ClearScreen
	ld h, vBGMap0 / $100
	call WriteLowerByteOfBGMapAndEnableBGTransfer
	call Delay3
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	call LoadScreenTilesFromBuffer2
	ld h, vBGMap1 / $100
	
WriteLowerByteOfBGMapAndEnableBGTransfer: ; 78eb1 (1e:4eb1)
	ld l, vBGMap0 & $ff
	call BattleAnimCopyTileMapToVRAM
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	ret
	
PlaySubanimation: ; 78ebb (1e:4ebb)
	ld a,[wAnimSoundID]
	cp a,$FF
	jr z,.skipPlayingSound
	call GetMoveSound
	call PlaySound
.skipPlayingSound
	ld hl,wOAMBuffer ; base address of OAM buffer
	ld a,l
	ld [wFBDestAddr + 1],a
	ld a,h
	ld [wFBDestAddr],a
	ld a,[wSubAnimSubEntryAddr + 1]
	ld h,a
	ld a,[wSubAnimSubEntryAddr]
	ld l,a
.loop
	push hl
	ld c,[hl] ; frame block ID
	ld b,0
	ld hl,FrameBlockPointers
	add hl,bc
	add hl,bc
	ld a,[hli]
	ld c,a
	ld a,[hli]
	ld b,a
	pop hl
	inc hl
	push hl
	ld e,[hl] ; base coordinate ID
	ld d,0
	ld hl,FrameBlockBaseCoords  ; base coordinate table
	add hl,de
	add hl,de
	ld a,[hli]
	ld [wBaseCoordY],a
	ld a,[hl]
	ld [wBaseCoordX],a
	pop hl
	inc hl
	ld a,[hl] ; frame block mode
	ld [wFBMode],a
	call DrawFrameBlock
	call DoSpecialEffectByAnimationId ; run animation-specific function (if there is one)
	ld a,[wSubAnimCounter]
	dec a
	ld [wSubAnimCounter],a
	ret z
	ld a,[wSubAnimSubEntryAddr + 1]
	ld h,a
	ld a,[wSubAnimSubEntryAddr]
	ld l,a
	ld a,[wSubAnimTransform]
	cp a,4 ; is the animation reversed?
	ld bc,3
	jr nz,.nextSubanimationSubentry
	ld bc,-3
.nextSubanimationSubentry
	add hl,bc
	ld a,h
	ld [wSubAnimSubEntryAddr + 1],a
	ld a,l
	ld [wSubAnimSubEntryAddr],a
	jp .loop

AnimationCleanOAM: ; 78f30 (1e:4f30)
	push hl
	push de
	push bc
	push af
	call DelayFrame
	call ClearSprites
	pop af
	pop bc
	pop de
	pop hl
	ret

; this runs after each frame block is drawn in a subanimation
; it runs a particular special effect based on the animation ID
DoSpecialEffectByAnimationId: ; 78f3f (1e:4f3f)
	push hl
	push de
	push bc
	ld a,[wAnimationID]
	ld hl,AnimationIdSpecialEffects
	ld de,3
	call IsInArray
	jr nc,.done
	inc hl
	ld a,[hli]
	ld h,[hl]
	ld l,a
	ld de,.done
	push de
	jp [hl]
.done
	pop bc
	pop de
	pop hl
	ret

; Format: Animation ID (1 byte), Address (2 bytes)
AnimationIdSpecialEffects: ; 78f5d (1e:4f5d)
	db MEGA_PUNCH
	dw AnimationFlashScreen

	db GUILLOTINE
	dw AnimationFlashScreen

	db MEGA_KICK
	dw AnimationFlashScreen

	db HEADBUTT
	dw AnimationFlashScreen

	db TAIL_WHIP
	dw TailWhipAnimationUnused

	db GROWL
	dw DoGrowlSpecialEffects

	db DISABLE
	dw AnimationFlashScreen

	db BLIZZARD
	dw DoBlizzardSpecialEffects

	db BUBBLEBEAM
	dw AnimationFlashScreen

	db HYPER_BEAM
	dw FlashScreenEveryFourFrameBlocks

	db THUNDERBOLT
	dw FlashScreenEveryEightFrameBlocks

	db REFLECT
	dw AnimationFlashScreen

	db SELFDESTRUCT
	dw DoExplodeSpecialEffects

	db SPORE
	dw FlashScreenEveryFourFrameBlocks

	db EXPLOSION
	dw DoExplodeSpecialEffects

	db ROCK_SLIDE
	dw DoRockSlideSpecialEffects

	db TRADE_BALL_DROP_ANIM
	dw TradeHidePokemon

	db TRADE_BALL_SHAKE_ANIM
	dw TradeShakePokeball

	db TRADE_BALL_TILT_ANIM
	dw TradeJumpPokeball

	db TOSS_ANIM
	dw DoBallTossSpecialEffects

	db SHAKE_ANIM
	dw DoBallShakeSpecialEffects

	db POOF_ANIM
	dw DoPoofSpecialEffects

	db GREATTOSS_ANIM
	dw DoBallTossSpecialEffects

	db ULTRATOSS_ANIM
	dw DoBallTossSpecialEffects

	db $FF ; terminator

DoBallTossSpecialEffects: ; 78fa6 (1e:4fa6)
	ld a,[wcf91]
	cp a,3 ; is it a Master Ball or Ultra Ball?
	jr nc,.skipFlashingEffect
.flashingEffect ; do a flashing effect if it's Master Ball or Ultra Ball
	ld a,[rOBP0]
	xor a,%00111100 ; complement colors 1 and 2
	ld [rOBP0],a
	call UpdateGBCPal_OBP0
.skipFlashingEffect
	ld a,[wSubAnimCounter]
	cp a,11 ; is it the beginning of the subanimation?
	jr nz,.skipPlayingSound
; if it is the beginning of the subanimation, play a sound
	ld a,SFX_BALL_TOSS
	call PlaySound
.skipPlayingSound
	ld a,[wIsInBattle]
	cp a,02 ; is it a trainer battle?
	jr z,.isTrainerBattle
	ld a,[wd11e]
	cp a,$10 ; is the enemy pokemon the Ghost Marowak?
	ret nz
; if the enemy pokemon is the Ghost Marowak, make it dodge during the last 3 frames
	ld a,[wSubAnimCounter]
	cp a,3
	jr z,.moveGhostMarowakLeft
	cp a,2
	jr z,.moveGhostMarowakLeft
	cp a,1
	ret nz
.moveGhostMarowakLeft
	coord hl, 17, 0
	ld de,20
	lb bc, 7, 7
.loop
	push hl
	push bc
	call AnimCopyRowRight ; move row of tiles left
	pop bc
	pop hl
	add hl,de
	dec b
	jr nz,.loop
	ld a,%00001000
	ld [rNR10],a ; Channel 1 sweep register
	ret
.isTrainerBattle ; if it's a trainer battle, shorten the animation by one frame
	ld a,[wSubAnimCounter]
	cp a,3
	ret nz
	dec a
	ld [wSubAnimCounter],a
	ret

DoBallShakeSpecialEffects: ; 79001 (1e:5001)
	ld a,[wSubAnimCounter]
	cp a,4 ; is it the beginning of a shake?
	jr nz,.skipPlayingSound
; if it is the beginning of a shake, play a sound and wait 2/3 of a second
	ld a,SFX_TINK
	call PlaySound
	ld c,40
	call DelayFrames
.skipPlayingSound
	ld a,[wSubAnimCounter]
	dec a
	ret nz
; if it's the end of the ball shaking subanimation, check if more shakes are left and restart the subanimation
	ld a,[wNumShakes] ; number of shakes
	dec a ; decrement number of shakes
	ld [wNumShakes],a
	ret z
; if there are shakes left, restart the subanimation
	ld a,[wSubAnimSubEntryAddr]
	ld l,a
	ld a,[wSubAnimSubEntryAddr + 1]
	ld h,a
	ld de,-(4 * 3) ; 4 subentries and 3 bytes per subentry
	add hl,de
	ld a,l
	ld [wSubAnimSubEntryAddr],a
	ld a,h
	ld [wSubAnimSubEntryAddr + 1],a
	ld a,5 ; number of subentries in the ball shaking subanimation plus one
	ld [wSubAnimCounter],a
	ret

; plays a sound after the second frame of the poof animation
DoPoofSpecialEffects: ; 79039 (1e:5039)
	ld a,[wSubAnimCounter]
	cp a,5
	ret nz
	ld a,SFX_BALL_POOF
	jp PlaySound

DoRockSlideSpecialEffects: ; 79044 (1e:5044)
	ld a,[wSubAnimCounter]
	cp a,12
	ret nc
	cp a,8
	jr nc,.shakeScreen
	cp a,1
	jp z,AnimationFlashScreen ; if it's the end of the subanimation, flash the screen
	ret
; if the subaninmation counter is between 8 and 11, shake the screen horizontally and vertically
.shakeScreen
	ld b,1
	predef PredefShakeScreenHorizontally ; shake horizontally
	ld b,1
	predef_jump PredefShakeScreenVertically ; shake vertically

FlashScreenEveryEightFrameBlocks: ; 79062 (1e:5062)
	ld a,[wSubAnimCounter]
	and a,7 ; is the subanimation counter exactly 8?
	call z,AnimationFlashScreen ; if so, flash the screen
	ret

; flashes the screen if the subanimation counter is divisible by 4
FlashScreenEveryFourFrameBlocks: ; 7906b (1e:506b)
	ld a,[wSubAnimCounter]
	and a,3
	call z,AnimationFlashScreen
	ret

; used for Explosion and Selfdestruct
DoExplodeSpecialEffects: ; 79074 (1e:5074)
	ld a,[wSubAnimCounter]
	cp a,1 ; is it the end of the subanimation?
	jr nz,FlashScreenEveryFourFrameBlocks
; if it's the end of the subanimation, make the attacking pokemon disappear
	coord hl, 1, 5
	jp AnimationHideMonPic ; make pokemon disappear

; flashes the screen when subanimation counter is 1 modulo 4
DoBlizzardSpecialEffects: ; 79081 (1e:5081)
	ld a,[wSubAnimCounter]
	cp a,13
	jp z,AnimationFlashScreen
	cp a,9
	jp z,AnimationFlashScreen
	cp a,5
	jp z,AnimationFlashScreen
	cp a,1
	jp z,AnimationFlashScreen
	ret

; flashes the screen at 3 points in the subanimation
; unused
FlashScreenUnused: ; 79099 (1e:5099)
	ld a,[wSubAnimCounter]
	cp a,14
	jp z,AnimationFlashScreen
	cp a,9
	jp z,AnimationFlashScreen
	cp a,2
	jp z,AnimationFlashScreen
	ret

; function to make the pokemon disappear at the beginning of the animation
TradeHidePokemon: ; 790ac (1e:50ac)
	ld a,[wSubAnimCounter]
	cp a,6
	ret nz
	ld a,2 * SCREEN_WIDTH + 7
	jp ClearMonPicFromTileMap ; make pokemon disappear

; function to make a shaking pokeball jump up at the end of the animation
TradeShakePokeball: ; 790b7 (1e:50b7)
	ld a,[wSubAnimCounter]
	cp a,1
	ret nz
; if it's the end of the animation, make the ball jump up
	ld de,BallMoveDistances1
.loop
	ld hl,wOAMBuffer ; OAM buffer
	ld bc,4
.innerLoop
	ld a,[de]
	cp a,$ff
	jr z,.done
	add [hl] ; add to Y value of OAM entry
	ld [hl],a
	add hl,bc
	ld a,l
	cp a,4 * 4 ; there are 4 entries, each 4 bytes
	jr nz,.innerLoop
	inc de
	push bc
	call Delay3
	pop bc
	jr .loop
.done
	call AnimationCleanOAM
	ld a,SFX_TRADE_MACHINE
	jp PlaySound

BallMoveDistances1: ; 790e3 (1e:50e3)
	db -12,-12,-8
	db $ff ; terminator

; function to make the pokeball jump up
TradeJumpPokeball: ; 790e7 (1e:50e7)
	ld de,BallMoveDistances2
.loop
	ld hl,wOAMBuffer ; OAM buffer
	ld bc,4
.innerLoop
	ld a,[de]
	cp a,$ff
	jp z,ClearScreen
	add [hl]
	ld [hl],a
	add hl,bc
	ld a,l
	cp a,4 * 4 ; there are 4 entries, each 4 bytes
	jr nz,.innerLoop
	inc de
	push de
	ld a,[de]
	cp a,12
	jr z,.playSound
	cp a,$ff
	jr nz,.skipPlayingSound
.playSound ; play sound if next move distance is 12 or this is the last one
	ld a,SFX_BATTLE_18
	call PlaySound
.skipPlayingSound
	push bc
	ld c,5
	call DelayFrames
	pop bc
	ld a,[hSCX] ; background scroll X
	sub a,8 ; scroll to the left
	ld [hSCX],a
	pop de
	jr .loop

BallMoveDistances2: ; 7911f (1e:511f)
	db 11,12,-12,-7,7,12,-8,8
	db $ff ; terminator

; this function copies the current musical note graphic
; so that there are two musical notes flying towards the defending pokemon
DoGrowlSpecialEffects: ; 79127 (1e:5127)
	ld hl,wOAMBuffer ; OAM buffer
	ld de,wOAMBuffer + $10
	ld bc,$10
	call CopyData ; copy the musical note graphic
	ld a,[wSubAnimCounter]
	dec a
	call z,AnimationCleanOAM ; clean up at the end of the subanimation
	ret

; this is associated with Tail Whip, but Tail Whip doesn't use any subanimations
TailWhipAnimationUnused: ; 7913b (1e:513b)
	ld a,1
	ld [wSubAnimCounter],a
	ld c,20
	jp DelayFrames

SpecialEffectPointers: ; 79145 (1e:5145)
	dr $79145,$7922c
AnimationFlashScreen: ; 7922c (1e:522c)
	dr $7922c,$79283
AnimationShakeScreenVertically: ; 79283 (1e:5283)
	dr $79283,$7928a
AnimationShakeScreenHorizontallyFast: ; 7928a (1e:528a)
	dr $7928a,$79349
AnimationSlideMonOff: ; 79349 (1e:5349)
	dr $79349,$79353
AnimationSlideEnemyMonOff: ; 79353 (1e:5353)
	dr $79353,$79421
AnimationBlinkEnemyMon: ; 79421 (1e:5421)
	dr $79421,$7966e
AnimationMinimizeMon: ; 7966e (1e:566e)
	dr $7966e,$797af
AnimationSubstitute: ; 797af (1e:57af)
	dr $797af,$79816
HideSubstituteShowMonAnim: ; 79816 (1e:5816)
	dr $79816,$798b2
ReshowSubstituteAnim: ; 798b2 (1e:58b2)
	dr $798b2,$798c8
AnimationTransformMon: ; 798c8 (1e:58c8)
	dr $798c8,$798d4
ChangeMonPic: ; 798d4 (1e:58d4)
	dr $798d4,$79929
Func_79929: ; 79929 (1e:5929)
	dr $79929,$7995d
AnimationHideMonPic: ; 7995d (1e:595d)
	dr $7995d,$79968
ClearMonPicFromTileMap: ; 79968 (1e:5968)
	dr $79968,$799be
AnimCopyRowRight: ; 799be (1e:59be)
	dr $799be,$799cb
GetMoveSound: ; 799cb (1e:59cb)
	dr $799cb,$79fae
BattleAnimCopyTileMapToVRAM: ; 79fae (1e:59ae)
	dr $79fae,$79fb7
TossBallAnimation: ; 79fb7 (1e:5fb7)
	dr $79fb7,$7a00b
PlayApplyingAttackSound: ; 7a00b (1e:600b)
	dr $7a00b,$7a037