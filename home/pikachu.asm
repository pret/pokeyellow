Func_1510:: ; 1510 (0:1510)
	push hl
	ld hl, wPikachuOverworldStateFlags
	set 7, [hl]
	ld hl, wSpriteStateData1 + $f2 ; pikachu data?
	ld [hl], $ff
	pop hl
	ret

Func_151d:: ; 151d (0:151d)
	push hl
	ld hl, wPikachuOverworldStateFlags
	res 7, [hl]
	pop hl
	ret

Func_1525:: ; 1525 (0:1525)
	push hl
	ld hl, wPikachuOverworldStateFlags
	res 3, [hl]
	pop hl
	ret

Func_152d:: ; 152d (0:152d)
	push hl
	ld hl, wPikachuOverworldStateFlags
	set 3, [hl]
	ld hl, wSpriteStateData1 + $f2 ; pikachu data?
	ld [hl], $ff
	pop hl
	ret

DisablePikachuFollowingPlayer:: ; 153a (0:153a)
	push hl
	ld hl, wPikachuOverworldStateFlags
	set 1, [hl]
	pop hl
	ret

EnablePikachuFollowingPlayer:: ; 1542 (0:1542)
	push hl
	ld hl, wPikachuOverworldStateFlags
	res 1, [hl]
	pop hl
	ret

CheckPikachuFollowingPlayer:: ; 154a (0:154a)
	push hl
	ld hl, wPikachuOverworldStateFlags
	bit 1, [hl]
	pop hl
	ret

Func_1552:: ; 1552 (0:1552)
	ld a, [hl]
	dec a
	swap a
	ld [hTilePlayerStandingOn], a
	homecall Func_fc6d5 ; 3f:46d5
	ret

Func_1568:: ; 1568 (0:1568)
	ld b, $0
	ld c, a
.asm_156b
	inc b
	ld a, [hli]
	cp $ff
	jr z, .asm_1578
	cp c
	jr nz, .asm_156b
	dec b
	dec hl
	scf
	ret
.asm_1578
	dec b
	dec hl
	and a
	ret

Func_157c:: ; 157c (0:157c)
	push hl
	push bc
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, [wd44a]
	call BankswitchCommon
	ld hl, wd44b
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

Func_159b:: ; 159b (0:159b)
	ld a, [H_LOADEDROMBANK]
	ld b, a
	push af
	callbs Func_fd2a1
	pop af
	call BankswitchCommon
	ret
