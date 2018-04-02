pcm: MACRO
	dw .End - .Start
.Start:
\1
.End:
ENDM

SECTION "Pikachu Cries 1", ROMX

PikachuCry1::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_1.pcm"
	db $77 ; unused
	; All of the pcm data has one trailing byte that is never processed.

PikachuCry2::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_2.pcm"
	db $77 ; unused

PikachuCry3::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_3.pcm"
	db $03 ; unused

PikachuCry4::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_4.pcm"
	db $e0 ; unused


SECTION "Pikachu Cries 2", ROMX

PikachuCry5::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_5.pcm"
	db $77 ; unused

PikachuCry6::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_6.pcm"
	db $77 ; unused

PikachuCry7::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_7.pcm"
	db $ff ; unused


SECTION "Pikachu Cries 3", ROMX

PikachuCry8::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_8.pcm"
	db $f7 ; unused

PikachuCry9::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_9.pcm"
	db $f3 ; unused

PikachuCry10::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_10.pcm"
	db $ff ; unused


SECTION "Pikachu Cries 4", ROMX

PikachuCry11::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_11.pcm"
	db $77 ; unused

PikachuCry12::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_12.pcm"
	db $ff ; unused

PikachuCry13::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_13.pcm"
	db $f0 ; unused


SECTION "Pikachu Cries 5", ROMX

PikachuCry14::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_14.pcm"
	db $fc ; unused

PikachuCry15::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_15.pcm"
	db $77 ; unused

SECTION "Pikachu Cries 6", ROMX

PikachuCry16::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_16.pcm"
	db $e7 ; unused

PikachuCry18::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_18.pcm"
	db $00 ; unused

PikachuCry22::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_22.pcm"
	db $7e ; unused


SECTION "Pikachu Cries 7", ROMX

PikachuCry20::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_20.pcm"
	db $07 ; unused

PikachuCry21::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_21.pcm"
	db $ff ; unused


SECTION "Pikachu Cries 8", ROMX

PikachuCry19::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_19.pcm"
	db $06 ; unused

PikachuCry24::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_24.pcm"
	db $e0 ; unused

PikachuCry26::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_26.pcm"

SECTION "Pikachu Cries 9", ROMX

PikachuCry17::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_17.pcm"
	db $00 ; unused

PikachuCry23::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_23.pcm"
	db $00 ; unused

PikachuCry25::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_25.pcm"
	db $03 ; unused


SECTION "Pikachu Cries 10", ROMX

PikachuCry27::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_27.pcm"
	db $ff ; unused

PikachuCry28::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_28.pcm"
	db $1b ; unused

PikachuCry29::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_29.pcm"
	db $87 ; unused

PikachuCry30::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_30.pcm"
	db $00 ; unused

PikachuCry31::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_31.pcm"

SECTION "Pikachu Cries 11", ROMX

PikachuCry32::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_32.pcm"
	db $ff ; unused

PikachuCry33::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_33.pcm"
	db $1f ; unused

PikachuCry34::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_34.pcm"
	db $01 ; unused

PikachuCry41::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_41.pcm"
	db $9b ; unused


SECTION "Pikachu Cries 12", ROMX

PikachuCry35::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_35.pcm"
	db $00 ; unused

PikachuCry36::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_36.pcm"
	db $01 ; unused

PikachuCry39::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_39.pcm"
	db $0f ; unused


SECTION "Pikachu Cries 13", ROMX

PikachuCry37::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_37.pcm"
	db $3f ; unused

PikachuCry38::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_38.pcm"
	db $ff ; unused

PikachuCry40::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_40.pcm"
	db $ff ; unused

PikachuCry42::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_42.pcm"
	db $00 ; unused
