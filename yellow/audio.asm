AUDIO_1 EQU $2
AUDIO_2 EQU $8
AUDIO_3 EQU $1f

INCLUDE "constants.asm"

SECTION "Sound Effect Headers 1", ROMX, BANK[AUDIO_1]
INCLUDE "audio/headers/sfxheaders1.asm"

SECTION "Music Headers 1", ROMX, BANK[AUDIO_1]
INCLUDE "audio/headers/musicheaders1.asm"

SECTION "Sound Effects 1", ROMX, BANK[AUDIO_1]

INCLUDE "audio/sfx/snare1_1.asm"
INCLUDE "audio/sfx/snare2_1.asm"
INCLUDE "audio/sfx/snare3_1.asm"
INCLUDE "audio/sfx/snare4_1.asm"
INCLUDE "audio/sfx/snare5_1.asm"
INCLUDE "audio/sfx/triangle1_1.asm"
INCLUDE "audio/sfx/triangle2_1.asm"
INCLUDE "audio/sfx/snare6_1.asm"
INCLUDE "audio/sfx/snare7_1.asm"
INCLUDE "audio/sfx/snare8_1.asm"
INCLUDE "audio/sfx/snare9_1.asm"
INCLUDE "audio/sfx/cymbal1_1.asm"
INCLUDE "audio/sfx/cymbal2_1.asm"
INCLUDE "audio/sfx/cymbal3_1.asm"
INCLUDE "audio/sfx/muted_snare1_1.asm"
INCLUDE "audio/sfx/triangle3_1.asm"
INCLUDE "audio/sfx/muted_snare2_1.asm"
INCLUDE "audio/sfx/muted_snare3_1.asm"
INCLUDE "audio/sfx/muted_snare4_1.asm"

INCLUDE "audio/sfx/start_menu_1.asm"
INCLUDE "audio/sfx/pokeflute.asm"
INCLUDE "audio/sfx/cut_1.asm"
INCLUDE "audio/sfx/go_inside_1.asm"
INCLUDE "audio/sfx/swap_1.asm"
INCLUDE "audio/sfx/tink_1.asm"
INCLUDE "audio/sfx/59_1.asm"
INCLUDE "audio/sfx/purchase_1.asm"
INCLUDE "audio/sfx/collision_1.asm"
INCLUDE "audio/sfx/go_outside_1.asm"
INCLUDE "audio/sfx/press_ab_1.asm"
INCLUDE "audio/sfx/save_1.asm"
INCLUDE "audio/sfx/heal_hp_1.asm"
INCLUDE "audio/sfx/poisoned_1.asm"
INCLUDE "audio/sfx/heal_ailment_1.asm"
INCLUDE "audio/sfx/trade_machine_1.asm"
INCLUDE "audio/sfx/turn_on_pc_1.asm"
INCLUDE "audio/sfx/turn_off_pc_1.asm"
INCLUDE "audio/sfx/enter_pc_1.asm"
INCLUDE "audio/sfx/shrink_1.asm"
INCLUDE "audio/sfx/switch_1.asm"
INCLUDE "audio/sfx/healing_machine_1.asm"
INCLUDE "audio/sfx/teleport_exit1_1.asm"
INCLUDE "audio/sfx/teleport_enter1_1.asm"
INCLUDE "audio/sfx/teleport_exit2_1.asm"
INCLUDE "audio/sfx/ledge_1.asm"
INCLUDE "audio/sfx/teleport_enter2_1.asm"
INCLUDE "audio/sfx/fly_1.asm"
INCLUDE "audio/sfx/denied_1.asm"
INCLUDE "audio/sfx/arrow_tiles_1.asm"
INCLUDE "audio/sfx/push_boulder_1.asm"
INCLUDE "audio/sfx/ss_anne_horn_1.asm"
INCLUDE "audio/sfx/withdraw_deposit_1.asm"
INCLUDE "audio/sfx/safari_zone_pa.asm"
INCLUDE "audio/sfx/unused_1.asm"
INCLUDE "audio/sfx/cry09_1.asm"
INCLUDE "audio/sfx/cry23_1.asm"
INCLUDE "audio/sfx/cry24_1.asm"
INCLUDE "audio/sfx/cry11_1.asm"
INCLUDE "audio/sfx/cry25_1.asm"
INCLUDE "audio/sfx/cry03_1.asm"
INCLUDE "audio/sfx/cry0f_1.asm"
INCLUDE "audio/sfx/cry10_1.asm"
INCLUDE "audio/sfx/cry00_1.asm"
INCLUDE "audio/sfx/cry0e_1.asm"
INCLUDE "audio/sfx/cry06_1.asm"
INCLUDE "audio/sfx/cry07_1.asm"
INCLUDE "audio/sfx/cry05_1.asm"
INCLUDE "audio/sfx/cry0b_1.asm"
INCLUDE "audio/sfx/cry0c_1.asm"
INCLUDE "audio/sfx/cry02_1.asm"
INCLUDE "audio/sfx/cry0d_1.asm"
INCLUDE "audio/sfx/cry01_1.asm"
INCLUDE "audio/sfx/cry0a_1.asm"
INCLUDE "audio/sfx/cry08_1.asm"
INCLUDE "audio/sfx/cry04_1.asm"
INCLUDE "audio/sfx/cry19_1.asm"
INCLUDE "audio/sfx/cry16_1.asm"
INCLUDE "audio/sfx/cry1b_1.asm"
INCLUDE "audio/sfx/cry12_1.asm"
INCLUDE "audio/sfx/cry13_1.asm"
INCLUDE "audio/sfx/cry14_1.asm"
INCLUDE "audio/sfx/cry1e_1.asm"
INCLUDE "audio/sfx/cry15_1.asm"
INCLUDE "audio/sfx/cry17_1.asm"
INCLUDE "audio/sfx/cry1c_1.asm"
INCLUDE "audio/sfx/cry1a_1.asm"
INCLUDE "audio/sfx/cry1d_1.asm"
INCLUDE "audio/sfx/cry18_1.asm"
INCLUDE "audio/sfx/cry1f_1.asm"
INCLUDE "audio/sfx/cry20_1.asm"
INCLUDE "audio/sfx/cry21_1.asm"
INCLUDE "audio/sfx/cry22_1.asm"

SECTION "Audio Engine 1", ROMX, BANK[AUDIO_1]

PlayBattleMusic:: ; 9064 (2:5064)
	xor a
	ld [wAudioFadeOutControl], a
	ld [wLowHealthAlarm], a
	call StopAllMusic
	call DelayFrame
	ld c, $8 ; BANK(Music_GymLeaderBattle)
	ld a, [W_GYMLEADERNO]
	and a
	jr z, .notGymLeaderBattle
	ld a, $ea ; MUSIC_GYM_LEADER_BATTLE
	jr .playSong
.notGymLeaderBattle
	ld a, [W_CUROPPONENT]
	cp 200
	jr c, .wildBattle
	cp OPP_SONY3
	jr z, .finalBattle
	cp OPP_LANCE
	jr nz, .normalTrainerBattle
	ld a, $ea ; MUSIC_GYM_LEADER_BATTLE ; lance also plays gym leader theme
	jr .playSong
.normalTrainerBattle
	ld a, $ed ; MUSIC_TRAINER_BATTLE
	jr .playSong
.finalBattle
	ld a, $f3 ; MUSIC_FINAL_BATTLE
	jr .playSong
.wildBattle
	ld a, $f0 ; MUSIC_WILD_BATTLE
.playSong
	jp PlayMusic


INCLUDE "audio/engine_1.asm"


; an alternate start for MeetRival which has a different first measure
Music_RivalAlternateStart:: ; 99bd (2:59bd)
	ld c, BANK(Music_MeetRival)
	ld a, MUSIC_MEET_RIVAL
	call PlayMusic
	ld hl, wChannelCommandPointers
	ld de, Music_MeetRival_branch_b1a2
	call Audio1_OverwriteChannelPointer
	ld de, Music_MeetRival_branch_b21d
	call Audio1_OverwriteChannelPointer
	ld de, Music_MeetRival_branch_b2b5

Audio1_OverwriteChannelPointer: ; 99d6 (2:59d6)
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ret

; an alternate tempo for MeetRival which is slightly slower
Music_RivalAlternateTempo:: ; 99db (2:59db)
	ld c, BANK(Music_MeetRival)
	ld a, MUSIC_MEET_RIVAL
	call PlayMusic
	ld de, Music_MeetRival_branch_b119
	jr asm_99ed
	
; applies both the alternate start and alternate tempo
Music_RivalAlternateStartAndTempo:: ; 99e7 (2:59e7)
	call Music_RivalAlternateStart
	ld de, Music_MeetRival_branch_b19b
asm_99ed: ; 99ed (2:59ed)
	ld hl, wChannelCommandPointers
	jp Audio1_OverwriteChannelPointer
	ret

; an alternate tempo for Cities1 which is used for the Hall of Fame room
Music_Cities1AlternateTempo:: ; 99f4 (2:59f4)
	ld a, 10
	ld [wAudioFadeOutCounterReloadValue], a
	ld [wAudioFadeOutCounter], a
	ld a, $ff ; stop playing music after the fade-out is finished
	ld [wAudioFadeOutControl], a
	ld c, 100
	call DelayFrames ; wait for the fade-out to finish
	ld c, BANK(Music_Cities1)
	ld a, $c3 ; MUSIC_CITIES1
	call PlayMusic
	ld hl, wChannelCommandPointers
	ld de, Music_Cities1_branch_aa6f
	jp Audio1_OverwriteChannelPointer

SECTION "Music 1", ROMX, BANK[AUDIO_1]

Audio1_WavePointers: INCLUDE "audio/wave_instruments.asm"

INCLUDE "audio/music/pkmnhealed.asm"
INCLUDE "audio/music/routes1.asm"
INCLUDE "audio/music/routes2.asm"
INCLUDE "audio/music/routes3.asm"
INCLUDE "audio/music/routes4.asm"
INCLUDE "audio/music/indigoplateau.asm"
INCLUDE "audio/music/pallettown.asm"
INCLUDE "audio/music/unusedsong.asm"
INCLUDE "audio/music/cities1.asm"
INCLUDE "audio/sfx/get_item1_1.asm"
INCLUDE "audio/music/museumguy.asm"
INCLUDE "audio/music/meetprofoak.asm"
INCLUDE "audio/music/meetrival.asm"
INCLUDE "audio/sfx/pokedex_rating_1.asm"
INCLUDE "audio/sfx/get_item2_1.asm"
INCLUDE "audio/sfx/get_key_item_1.asm"
INCLUDE "audio/music/ssanne.asm"
INCLUDE "audio/music/cities2.asm"
INCLUDE "audio/music/celadon.asm"
INCLUDE "audio/music/cinnabar.asm"
INCLUDE "audio/music/vermilion.asm"
INCLUDE "audio/music/lavender.asm"
INCLUDE "audio/music/safarizone.asm"
INCLUDE "audio/music/gym.asm"
INCLUDE "audio/music/pokecenter.asm"

