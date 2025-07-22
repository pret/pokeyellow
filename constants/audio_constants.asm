; pitch
; Audio[1|2|3]_Pitches indexes (see audio/notes.asm)
	const_def
	const C_ ; 0
	const C# ; 1
	const D_ ; 2
	const D# ; 3
	const E_ ; 4
	const F_ ; 5
	const F# ; 6
	const G_ ; 7
	const G# ; 8
	const A_ ; 9
	const A# ; A
	const B_ ; B
DEF NUM_NOTES EQU const_value

; channel
; Audio[1|2|3]_HWChannelBaseAddresses, Audio[1|2|3]_HWChannelDisableMasks,
; and Audio[1|2|3]_HWChannelEnableMasks indexes (see audio/engine_[1|2|3].asm)
	const_def
	const CHAN1 ; 0
	const CHAN2 ; 1
	const CHAN3 ; 2
	const CHAN4 ; 3
DEF NUM_MUSIC_CHANS EQU const_value
	const CHAN5 ; 4
	const CHAN6 ; 5
	const CHAN7 ; 6
	const CHAN8 ; 7
DEF NUM_NOISE_CHANS EQU const_value - NUM_MUSIC_CHANS
DEF NUM_CHANNELS EQU const_value

	const_def 1
	const REG_DUTY_SOUND_LEN  ; 1
	const REG_VOLUME_ENVELOPE ; 2
	const REG_FREQUENCY_LO    ; 3

; wChannelFlags1 constants
	const_def
	const BIT_PERFECT_PITCH          ; 0 ; controlled by toggle_perfect_pitch command
	const BIT_SOUND_CALL             ; 1 ; if in sound call
	const BIT_NOISE_OR_SFX           ; 2 ; if channel is the music noise channel or an SFX channel
	const BIT_VIBRATO_DIRECTION      ; 3 ; if the pitch is above or below normal (cycles)
	const BIT_PITCH_SLIDE_ON         ; 4 ; if pitch slide is active
	const BIT_PITCH_SLIDE_DECREASING ; 5 ; if the pitch slide frequency is decreasing (instead of increasing)
	const BIT_ROTATE_DUTY_CYCLE      ; 6 ; if rotating duty cycle

; wChannelFlags2 constant (only has one flag)
DEF BIT_EXECUTE_MUSIC EQU 0 ; if in execute music

; wMuteAudioAndPauseMusic
DEF BIT_MUTE_AUDIO EQU 7

; wLowHealthAlarm
DEF BIT_LOW_HEALTH_ALARM EQU 7
DEF LOW_HEALTH_TIMER_MASK EQU %01111111
DEF DISABLE_LOW_HEALTH_ALARM EQU $ff
