ReflectLightScreenEffect_: ; f645d (3d:645d)
	ld hl, W_PLAYERBATTSTATUS3
	ld de, W_PLAYERMOVEEFFECT
	ld a, [H_WHOSETURN]
	and a
	jr z, .reflectLightScreenEffect
	ld hl, W_ENEMYBATTSTATUS3
	ld de, W_ENEMYMOVEEFFECT
.reflectLightScreenEffect
	ld a, [de]
	cp LIGHT_SCREEN_EFFECT
	jr nz, .reflect
	bit HasLightScreenUp, [hl] ; is mon already protected by light screen?
	jr nz, .moveFailed
	set HasLightScreenUp, [hl] ; mon is now protected by light screen
	ld hl, LightScreenProtectedText
	jr .playAnim
.reflect
	bit HasReflectUp, [hl] ; is mon already protected by reflect?
	jr nz, .moveFailed
	set HasReflectUp, [hl] ; mon is now protected by reflect
	ld hl, ReflectGainedArmorText
.playAnim
	push hl
	ld hl, PlayCurrentMoveAnimation
	call Bankswitch3DtoF
	pop hl
	jp PrintText
.moveFailed
	ld c, 50
	call DelayFrames
	ld hl, PrintButItFailedText_
	jp Bankswitch3DtoF

LightScreenProtectedText: ; f649d (3d:649d)
	TX_FAR _LightScreenProtectedText
	db "@"

ReflectGainedArmorText: ; f64a2 (3d:64a2)
	TX_FAR _ReflectGainedArmorText
	db "@"

Bankswitch3DtoF: ; f64a7 (3d:64a7)
	ld b, $f ; BANK(BattleCore)
	jp Bankswitch
