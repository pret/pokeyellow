Func_1510::
	push hl
	ld hl, wPikachuOverworldStateFlags
	set 7, [hl]
	ld hl, wPikachuSpriteImageIdx ; pikachu data?
	ld [hl], $ff
	pop hl
	ret

Func_151d::
	push hl
	ld hl, wPikachuOverworldStateFlags
	res 7, [hl]
	pop hl
	ret

EnablePikachuOverworldSpriteDrawing::
	push hl
	ld hl, wPikachuOverworldStateFlags
	res 3, [hl]
	pop hl
	ret

DisablePikachuOverworldSpriteDrawing::
	push hl
	ld hl, wPikachuOverworldStateFlags
	set 3, [hl]
	ld hl, wPikachuSpriteImageIdx ; pikachu data?
	ld [hl], $ff
	pop hl
	ret

DisablePikachuFollowingPlayer::
	push hl
	ld hl, wPikachuOverworldStateFlags
	set 1, [hl]
	pop hl
	ret

EnablePikachuFollowingPlayer::
	push hl
	ld hl, wPikachuOverworldStateFlags
	res 1, [hl]
	pop hl
	ret

CheckPikachuFollowingPlayer::
	push hl
	ld hl, wPikachuOverworldStateFlags
	bit 1, [hl]
	pop hl
	ret

SpawnPikachu::
	ld a, [hl]
	dec a
	swap a
	ld [hTilePlayerStandingOn], a
	homecall SpawnPikachu_ ; 3f:46d5
	ret

Pikachu_IsInArray::
	ld b, $0
	ld c, a
.loop
	inc b
	ld a, [hli]
	cp $ff
	jr z, .not_in_array
	cp c
	jr nz, .loop
	dec b
	dec hl
	scf
	ret

.not_in_array
	dec b
	dec hl
	and a
	ret

GetPikachuMovementScriptByte::
	push hl
	push bc
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, [wPikachuMovementScriptBank]
	call BankswitchCommon
	ld hl, wPikachuMovementScriptAddress
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, [bc]
	inc bc
	ld [hl], b
	dec hl
	ld [hl], c
	ld c, a
	pop af
	call BankswitchCommon
	ld a, c
	pop bc
	pop hl
	ret

ApplyPikachuMovementData::
	ld a, [H_LOADEDROMBANK]
	ld b, a
	push af
	callbs ApplyPikachuMovementData_
	pop af
	call BankswitchCommon
	ret
