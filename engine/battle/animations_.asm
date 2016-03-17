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

	dr $78d97,$78e98
Func_78e98: ; 78e98 (1e:4e98)
	dr $78e98,$78ebb
PlaySubanimation: ; 78ebb (1e:4ebb)
	dr $78ebb,$78f30
AnimationCleanOAM: ; 78f30 (1e:4f30)
	dr $78f30,$79145
SpecialEffectPointers: ; 79145 (1e:5145)
	dr $79145,$79349
AnimationSlideMonOff: ; 79349 (1e:5349)
	dr $79349,$79353
AnimationSlideEnemyMonOff: ; 79353 (1e:5353)
	dr $79353,$7966e
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
	dr $79929,$799cb
GetMoveSound: ; 799cb (1e:59cb)
	dr $799cb,$7a037