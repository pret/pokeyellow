EmotionBubble:
	ld a, [wWhichEmotionBubble]
	and $f
	swap a
	ld c, a
	ld b, 0
	ld hl, EmotionBubbles
	add hl, bc ; each emotion bubble is 16 bytes, so calculate the offset directly instead of with a pointer table
	add hl, bc
	add hl, bc
	add hl, bc
	ld e, l
	ld d, h
	ld hl, vChars1 tile $78
	lb bc, BANK(EmotionBubbles), 4
	call CopyVideoData
	ld a, [wUpdateSpritesEnabled]
	push af
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	ld a, [wd736]
	bit 6, a ; are the last 4 OAM entries reserved for a shadow or fishing rod?
	ld hl, wShadowOAMSprite35Attributes
	ld de, wShadowOAMSprite39Attributes
	jr z, .next
	ld hl, wShadowOAMSprite31Attributes
	ld de, wShadowOAMSprite35Attributes

; Copy OAM data 16 bytes forward to make room for emotion bubble OAM data at the
; start of the OAM buffer.
.next
	ld bc, $90
.loop
	ld a, [hl]
	ld [de], a
	dec hl
	dec de
	dec bc
	ld a, c
	or b
	jr nz, .loop

; get the screen coordinates of the sprite the bubble is to be displayed above
	ld hl, wSpritePlayerStateData1YPixels
	ld a, [wEmotionBubbleSpriteIndex]
	swap a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld b, a
	inc hl
	ld a, [hl]
	add $8
	ld c, a

	ld de, EmotionBubblesOAM
	xor a
	call WriteOAMBlock
	ld c, 60
	call DelayFrames
	pop af
	ld [wUpdateSpritesEnabled], a
	call DelayFrame
	call UpdateSprites
	ret


EmotionBubblesOAM:
	dbsprite  0, -1,  0,  0, $f9, 0
	dbsprite  0, -1,  0,  2, $fb, 0

EmotionBubbles:
ShockEmote:    INCBIN "gfx/emotes/shock.2bpp"
QuestionEmote: INCBIN "gfx/emotes/question.2bpp"
HappyEmote:    INCBIN "gfx/emotes/happy.2bpp"
SkullEmote:    INCBIN "gfx/emotes/skull.2bpp"
HeartEmote:    INCBIN "gfx/emotes/heart.2bpp"
BoltEmote:     INCBIN "gfx/emotes/bolt.2bpp"
ZzzEmote:      INCBIN "gfx/emotes/zzz.2bpp"
FishEmote:     INCBIN "gfx/emotes/fish.2bpp"
