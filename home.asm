INCLUDE "constants.asm"


SECTION "NULL", ROM0
NULL::

INCLUDE "home/header.asm"


SECTION "High Home", ROM0

INCLUDE "home/lcd.asm"
INCLUDE "home/clear_sprites.asm"
INCLUDE "home/copy.asm"


SECTION "Home", ROM0

PlayPikachuPCM::
	ldh a, [hLoadedROMBank]
	push af
	ld a, b
	call BankswitchCommon
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
.loop
	ld a, [hli]
	ld d, a
	ld a, $3
.playSingleSample
	dec a
	jr nz, .playSingleSample

	rept 7
	call LoadNextSoundClipSample
	call PlaySoundClipSample
	endr

	call LoadNextSoundClipSample
	dec bc
	ld a, c
	or b
	jr nz, .loop
	pop af
	call BankswitchCommon
	ret

LoadNextSoundClipSample::
	ld a, d
	and $80
	srl a
	srl a
	ldh [rNR32], a
	sla d
	ret

PlaySoundClipSample::
	ld a, $3
.loop
	dec a
	jr nz, .loop
	ret

INCLUDE "home/start.asm"
INCLUDE "home/joypad.asm"

INCLUDE "home/overworld.asm"
INCLUDE "home/pokemon.asm"
INCLUDE "home/print_bcd.asm"
INCLUDE "home/pics.asm"

INCLUDE "home/pikachu.asm"

INCLUDE "home/lcdc.asm"

IsTilePassable::
; sets carry if tile is passable, resets carry otherwise
	homecall_sf _IsTilePassable
	ret

INCLUDE "home/copy2.asm"
INCLUDE "home/text.asm"
INCLUDE "home/vcopy.asm"
INCLUDE "home/init.asm"
INCLUDE "home/vblank.asm"
INCLUDE "home/fade.asm"
INCLUDE "home/play_time.asm"
INCLUDE "home/serial.asm"
INCLUDE "home/timer.asm"
INCLUDE "home/audio.asm"
INCLUDE "home/update_sprites.asm"

INCLUDE "data/items/marts.asm"

INCLUDE "home/overworld_text.asm"
INCLUDE "home/uncompress.asm"
INCLUDE "home/reset_player_sprite.asm"
INCLUDE "home/fade_audio.asm"

UnknownText_2812::
	text_far _PokemonText
	text_end

INCLUDE "home/text_script.asm"
INCLUDE "home/start_menu.asm"
INCLUDE "home/count_set_bits.asm"
INCLUDE "home/inventory.asm"
INCLUDE "home/list_menu.asm"
INCLUDE "home/names.asm"
INCLUDE "home/reload_tiles.asm"
INCLUDE "home/item.asm"
INCLUDE "home/textbox.asm"

UpdateGBCPal_BGP::
	push af
	ldh a, [hGBC]
	and a
	jr z, .notGBC
	push bc
	push de
	push hl
	ldh a, [rBGP]
	ld b, a
	ld a, [wLastBGP]
	cp b
	jr z, .noChangeInBGP
	farcall _UpdateGBCPal_BGP
.noChangeInBGP
	pop hl
	pop de
	pop bc
.notGBC
	pop af
	ret

UpdateGBCPal_OBP0::
	push af
	ldh a, [hGBC]
	and a
	jr z, .notGBC
	push bc
	push de
	push hl
	ldh a, [rOBP0]
	ld b, a
	ld a, [wLastOBP0]
	cp b
	jr z, .noChangeInOBP0
	ld b, BANK(_UpdateGBCPal_OBP)
	ld hl, _UpdateGBCPal_OBP
	ld c, CONVERT_OBP0
	call Bankswitch
.noChangeInOBP0
	pop hl
	pop de
	pop bc
.notGBC
	pop af
	ret

UpdateGBCPal_OBP1::
	push af
	ldh a, [hGBC]
	and a
	jr z, .notGBC
	push bc
	push de
	push hl
	ldh a, [rOBP1]
	ld b, a
	ld a, [wLastOBP1]
	cp b
	jr z, .noChangeInOBP1
	ld b, BANK(_UpdateGBCPal_OBP)
	ld hl, _UpdateGBCPal_OBP
	ld c, CONVERT_OBP1
	call Bankswitch
.noChangeInOBP1
	pop hl
	pop de
	pop bc
.notGBC
	pop af
	ret

Func_3082::
	ldh a, [hLoadedROMBank]
	push af
	call FadeOutAudio
	callbs Music_DoLowHealthAlarm
	callbs Audio1_UpdateMusic
	pop af
	call BankswitchCommon
	ret

INCLUDE "home/npc_movement.asm"
INCLUDE "home/trainers.asm"
INCLUDE "home/map_objects.asm"
INCLUDE "home/trainers2.asm"
INCLUDE "home/money.asm"
INCLUDE "home/bankswitch.asm"
INCLUDE "home/yes_no.asm"
INCLUDE "home/pathfinding.asm"
INCLUDE "home/load_font.asm"
INCLUDE "home/tilemap.asm"
INCLUDE "home/delay.asm"
INCLUDE "home/names2.asm"
INCLUDE "home/item_price.asm"
INCLUDE "home/copy_string.asm"
INCLUDE "home/joypad2.asm"
INCLUDE "home/math.asm"
INCLUDE "home/print_text.asm"
INCLUDE "home/move_mon.asm"
INCLUDE "home/array.asm"
INCLUDE "home/compare.asm"
INCLUDE "home/oam.asm"
INCLUDE "home/window.asm"

FarPrintText::
; print text b:hl at (1, 14)
	ldh a, [hLoadedROMBank]
	push af
	ld a, b
	call BankswitchCommon
	call PrintText
	pop af
	call BankswitchCommon
	ret

INCLUDE "home/print_num.asm"
INCLUDE "home/array2.asm"

InitMapSprites::
	jpfar _InitMapSprites

INCLUDE "home/palettes.asm"
INCLUDE "home/reload_sprites.asm"
INCLUDE "home/give.asm"
INCLUDE "home/random.asm"

BankswitchCommon::
	ldh [hLoadedROMBank], a
	ld [MBC1RomBank], a
	ret

Bankswitch::
; self-contained bankswitch, use this when not in the home bank
; switches to the bank in b
	ldh a, [hLoadedROMBank]
	push af
	ld a, b
	ldh [hLoadedROMBank], a
	ld [MBC1RomBank], a
	call JumpToAddress
	pop bc
	ld a, b
	ldh [hLoadedROMBank], a
	ld [MBC1RomBank], a
	ret
JumpToAddress::
	jp hl

SwitchSRAMBankAndLatchClockData::
	push af
	ld a, $1
	ld [MBC1SRamBankingMode], a
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	pop af
	ld [MBC1SRamBank], a
	ret

PrepareRTCDataAndDisableSRAM::
	push af
	ld a, $0
	ld [MBC1SRamBankingMode], a
	ld [MBC1SRamEnable], a
	pop af
	ret

INCLUDE "home/predef.asm"
INCLUDE "home/hidden_objects.asm"
INCLUDE "home/predef_text.asm"
