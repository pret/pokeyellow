MACRO pikacry_def
\1_id::
	dba \1
ENDM

PikachuCriesPointerTable::
	table_width 3

; bank 21
	pikacry_def PikachuCry1
	pikacry_def PikachuCry2
	pikacry_def PikachuCry3
	pikacry_def PikachuCry4

; bank 22
	pikacry_def PikachuCry5
	pikacry_def PikachuCry6
	pikacry_def PikachuCry7

; bank 23
	pikacry_def PikachuCry8
	pikacry_def PikachuCry9
	pikacry_def PikachuCry10

; bank 24
	pikacry_def PikachuCry11
	pikacry_def PikachuCry12
	pikacry_def PikachuCry13

; bank 25
	pikacry_def PikachuCry14
	pikacry_def PikachuCry15

; banks 31-34, in no particular order

	pikacry_def PikachuCry16
	pikacry_def PikachuCry17
	pikacry_def PikachuCry18
	pikacry_def PikachuCry19
	pikacry_def PikachuCry20
	pikacry_def PikachuCry21
	pikacry_def PikachuCry22
	pikacry_def PikachuCry23
	pikacry_def PikachuCry24
	pikacry_def PikachuCry25
	pikacry_def PikachuCry26

; bank 35
	pikacry_def PikachuCry27
	pikacry_def PikachuCry28
	pikacry_def PikachuCry29
	pikacry_def PikachuCry30
	pikacry_def PikachuCry31

; bank 36
	pikacry_def PikachuCry32
	pikacry_def PikachuCry33
	pikacry_def PikachuCry34

; bank 37
	pikacry_def PikachuCry35
	pikacry_def PikachuCry36

; banks 36-38
	pikacry_def PikachuCry37
	pikacry_def PikachuCry38
	pikacry_def PikachuCry39
	pikacry_def PikachuCry40
	pikacry_def PikachuCry41
	pikacry_def PikachuCry42

	assert_table_length NUM_PIKA_CRIES
