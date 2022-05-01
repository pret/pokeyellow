MACRO pcm
; All of the pcm data has one trailing byte that is never processed.
	dw .End - .Start - 1
.Start
	\1
.End
ENDM


SECTION "Pikachu Cries 1", ROMX

PikachuCry1::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_1.pcm"

PikachuCry2::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_2.pcm"

PikachuCry3::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_3.pcm"

PikachuCry4::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_4.pcm"


SECTION "Pikachu Cries 2", ROMX

PikachuCry5::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_5.pcm"

PikachuCry6::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_6.pcm"

PikachuCry7::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_7.pcm"


SECTION "Pikachu Cries 3", ROMX

PikachuCry8::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_8.pcm"

PikachuCry9::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_9.pcm"

PikachuCry10::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_10.pcm"


SECTION "Pikachu Cries 4", ROMX

PikachuCry11::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_11.pcm"

PikachuCry12::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_12.pcm"

PikachuCry13::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_13.pcm"


SECTION "Pikachu Cries 5", ROMX

PikachuCry14::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_14.pcm"

PikachuCry15::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_15.pcm"


SECTION "Pikachu Cries 6", ROMX

PikachuCry16::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_16.pcm"

PikachuCry18::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_18.pcm"

PikachuCry22::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_22.pcm"


SECTION "Pikachu Cries 7", ROMX

PikachuCry20::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_20.pcm"

PikachuCry21::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_21.pcm"


SECTION "Pikachu Cries 8", ROMX

PikachuCry19::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_19.pcm"

PikachuCry24::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_24.pcm"

PikachuCry26::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_26.pcm"


SECTION "Pikachu Cries 9", ROMX

PikachuCry17::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_17.pcm"

PikachuCry23::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_23.pcm"

PikachuCry25::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_25.pcm"


SECTION "Pikachu Cries 10", ROMX

PikachuCry27::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_27.pcm"

PikachuCry28::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_28.pcm"

PikachuCry29::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_29.pcm"

PikachuCry30::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_30.pcm"

PikachuCry31::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_31.pcm"


SECTION "Pikachu Cries 11", ROMX

PikachuCry32::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_32.pcm"

PikachuCry33::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_33.pcm"

PikachuCry34::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_34.pcm"

PikachuCry41::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_41.pcm"


SECTION "Pikachu Cries 12", ROMX

PikachuCry35::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_35.pcm"

PikachuCry36::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_36.pcm"

PikachuCry39::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_39.pcm"


SECTION "Pikachu Cries 13", ROMX

PikachuCry37::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_37.pcm"

PikachuCry38::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_38.pcm"

PikachuCry40::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_40.pcm"

PikachuCry42::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_42.pcm"
