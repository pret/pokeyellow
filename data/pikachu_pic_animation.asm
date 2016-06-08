PikaPicAnimThunderboltPals:
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db $ff

Data_fe26b: ; fe26b (3f:626b)
	pikapic_loadgfx Pic_e4000
	pikapic_loadgfx Pic_e49d1
	pikapic_loadgfx PikachuSprite
	pikapic_object $1, $80, $0, $0
	pikapic_object $2, $b2, $5, $5
	pikapic_object $3, $b6, $5, $5
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript0: ; fe28a (3f:628a)
PikaPicAnimScript1: ; fe28a (3f:628a)
PikaPicAnimScript29: ; fe28a (3f:628a)
	pikapic_setduration 40
	pikapic_loadgfx Pic_e4000
	pikapic_loadgfx GFX_e40cc
	pikapic_object $4, $80, $0, $0
	pikapic_object $6, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry3
	pikapic_looptofinish

PikaPicAnimScript2: ; fe2a4 (3f:62a4)
	pikapic_setduration 44
	pikapic_loadgfx Pic_e411c
	pikapic_loadgfx GFX_e41d2
	pikapic_object $4, $80, $0, $0
	pikapic_object $7, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript3: ; fe2be (3f:62be)
	pikapic_setduration 80
	pikapic_loadgfx Pic_e4272
	pikapic_loadgfx GFX_e4323
	pikapic_object $4, $80, $0, $0
	pikapic_object $8, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript4: ; fe2d8 (3f:62d8)
	pikapic_setduration 70
	pikapic_loadgfx Pic_e4383
	pikapic_loadgfx GFX_e444b
	pikapic_object $4, $80, $0, $0
	pikapic_object $9, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript5: ; fe2f2 (3f:62f2)
	pikapic_setduration 32
	pikapic_loadgfx Pic_e458b
	pikapic_loadgfx GFX_e463b
	pikapic_object $4, $80, $0, $0
	pikapic_object $a, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript6: ; fe30c (3f:630c)
	pikapic_setduration 50
	pikapic_loadgfx Pic_e467b
	pikapic_loadgfx GFX_e472e
	pikapic_object $4, $80, $0, $0
	pikapic_object $b, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry38
	pikapic_looptofinish

PikaPicAnimScript7: ; fe326 (3f:6326)
	pikapic_setduration 58
	pikapic_loadgfx Pic_e476e
	pikapic_loadgfx GFX_e4841
	pikapic_object $4, $80, $0, $0
	pikapic_object $c, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript8: ; fe340 (3f:6340)
	pikapic_setduration 44
	pikapic_loadgfx Pic_e49d1
	pikapic_loadgfx GFX_e4a99
	pikapic_object $4, $80, $0, $0
	pikapic_object $d, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript9: ; fe35a (3f:635a)
	pikapic_setduration 56
	pikapic_loadgfx Pic_e4b39
	pikapic_loadgfx GFX_e4bde
	pikapic_object $4, $80, $0, $0
	pikapic_object $e, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript10: ; fe374 (3f:6374)
	pikapic_setduration 56
	pikapic_loadgfx Pic_e4c3e
	pikapic_loadgfx GFX_e4ce0
	pikapic_loadgfx GFX_e4e70
	pikapic_object $4, $80, $0, $0
	pikapic_object $10, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript11: ; fe390 (3f:6390)
	pikapic_setduration 100
	pikapic_loadgfx Pic_e5000
	pikapic_loadgfx GFX_e50af
	pikapic_object $4, $80, $0, $0
	pikapic_object $11, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript12: ; fe3aa (3f:63aa)
	pikapic_setduration 50
	pikapic_loadgfx Pic_e523f
	pikapic_loadgfx GFX_e52fe
	pikapic_object $4, $80, $0, $0
	pikapic_object $12, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry25
	pikapic_looptofinish

PikaPicAnimScript13: ; fe3c4 (3f:63c4)
	pikapic_setduration 50
	pikapic_loadgfx Pic_e548e
	pikapic_loadgfx GFX_e5541
	pikapic_object $4, $80, $0, $0
	pikapic_object $13, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript14: ; fe3de (3f:63de)
	pikapic_setduration 40
	pikapic_loadgfx Pic_e56d1
	pikapic_loadgfx GFX_e5794
	pikapic_object $4, $80, $0, $0
	pikapic_object $14, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript15: ; fe3f8 (3f:63f8)
	pikapic_setduration 50
	pikapic_loadgfx Pic_e5924
	pikapic_loadgfx GFX_e59ed
	pikapic_object $4, $80, $0, $0
	pikapic_object $15, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript16: ; fe412 (3f:6412)
	pikapic_setduration 32
	pikapic_loadgfx Pic_e5b7d
	pikapic_loadgfx GFX_e5c4d
	pikapic_object $4, $80, $0, $0
	pikapic_object $16, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript17: ; fe42c (3f:642c)
	pikapic_setduration 100
	pikapic_loadgfx Pic_e5ddd
	pikapic_loadgfx GFX_e5e90
	pikapic_object $4, $80, $0, $0
	pikapic_object $17, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript18: ; fe446 (3f:6446)
	pikapic_setduration 32
	pikapic_loadgfx GFX_e6020
	pikapic_loadgfx GFX_e61b0
	pikapic_object $5, $80, $0, $0
	pikapic_object $18, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry18
	pikapic_looptofinish

PikaPicAnimScript19: ; fe460 (3f:6460)
	pikapic_setduration 44
	pikapic_loadgfx Pic_e6340
	pikapic_loadgfx GFX_e63f7
	pikapic_object $4, $80, $0, $0
	pikapic_object $19, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript20: ; fe47a (3f:647a)
	pikapic_setduration 50
	pikapic_loadgfx Pic_e6587
	pikapic_loadgfx GFX_e6646
	pikapic_object $4, $80, $0, $0
	pikapic_object $1a, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript21: ; fe494 (3f:6494)
	pikapic_setduration 40
	pikapic_loadgfx Pic_e67d6
	pikapic_loadgfx GFX_e682f
	pikapic_loadgfx GFX_e69bf
	pikapic_loadgfx GFX_e6b4f
	pikapic_loadgfx GFX_e6cdf
	pikapic_object $4, $80, $0, $0
	pikapic_object $1b, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry20
	pikapic_looptofinish

PikaPicAnimScript22: ; fe4b4 (3f:64b4)
	pikapic_setduration 40
	pikapic_loadgfx GFX_e6e6f
	pikapic_loadgfx GFX_e6fff
	pikapic_object $5, $80, $0, $0
	pikapic_object $1c, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript23: ; fe4ce (3f:64ce)
	pikapic_setduration 70
	pikapic_loadgfx GFX_e718f
	pikapic_loadgfx GFX_e731f
	pikapic_object $5, $80, $0, $0
	pikapic_object $1d, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript24: ; fe4e8 (3f:64e8)
	pikapic_setduration 60
	pikapic_loadgfx GFX_e74af
	pikapic_loadgfx GFX_e763f
	pikapic_object $5, $80, $0, $0
	pikapic_object $1e, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript25: ; fe502 (3f:6502)
	pikapic_setduration 50
	pikapic_loadgfx Pic_e77cf
	pikapic_loadgfx GFX_e7863
	pikapic_loadgfx GFX_e79f3
	pikapic_object $4, $80, $0, $0
	pikapic_object $1f, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_writebyte 13
	pikapic_waitbgmap
	pikapic_thunderbolt
	pikapic_ret

Data_fe51f: ; fe51f (3f:651f)
	pikapic_waitbgmap
PikaPicAnimScript26: ; fe520 (3f:6520)
	pikapic_setduration 100
	pikapic_loadgfx Pic_e5000
	pikapic_loadgfx GFX_e50af
	pikapic_loadgfx GFX_e7b83
	pikapic_loadgfx GFX_e7d13
	pikapic_object $4, $80, $0, $0
	pikapic_object $20, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript27: ; fe53e (3f:653e)
	pikapic_setduration 30
	pikapic_loadgfx Pic_f0abf
	pikapic_loadgfx GFX_f0b64
	pikapic_object $4, $80, $0, $0
	pikapic_object $21, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript28: ; fe558 (3f:6558)
	pikapic_setduration 64
	pikapic_loadgfx Pic_f0cf4
	pikapic_loadgfx GFX_f0d82
	pikapic_object $4, $80, $0, $0
	pikapic_object $22, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimGFXHeaders:
pikapicanimgfx: MACRO
\2_id::
	db \1  ; size (-1 if compressed)
	dba \2 ; pointer
	endm

PikaPicAnimGFX_Null_id::
	dbbw            1, $39,$0000     ; 00
	pikapicanimgfx -1, Pic_e4000     ; 01
	pikapicanimgfx  5, GFX_e40cc     ; 02
	pikapicanimgfx -1, Pic_e411c     ; 03
	pikapicanimgfx 10, GFX_e41d2     ; 04
	pikapicanimgfx -1, Pic_e4272     ; 05
	pikapicanimgfx  6, GFX_e4323     ; 06
	pikapicanimgfx -1, Pic_e4383     ; 07
	pikapicanimgfx 20, GFX_e444b     ; 08
	pikapicanimgfx -1, Pic_e458b     ; 09
	pikapicanimgfx  4, GFX_e463b     ; 0a
	pikapicanimgfx -1, Pic_e467b     ; 0b
	pikapicanimgfx  4, GFX_e472e     ; 0c
	pikapicanimgfx -1, Pic_e476e     ; 0d
	pikapicanimgfx 25, GFX_e4841     ; 0e
	pikapicanimgfx -1, Pic_e49d1     ; 0f
	pikapicanimgfx 10, GFX_e4a99     ; 00
	pikapicanimgfx -1, Pic_e4b39     ; 11
	pikapicanimgfx  6, GFX_e4bde     ; 12
	pikapicanimgfx -1, Pic_e4c3e     ; 13
	pikapicanimgfx 25, GFX_e4ce0     ; 14
	pikapicanimgfx 25, GFX_e4e70     ; 15
	pikapicanimgfx -1, Pic_e5000     ; 16
	pikapicanimgfx 25, GFX_e50af     ; 17
	pikapicanimgfx -1, Pic_e523f     ; 18
	pikapicanimgfx 25, GFX_e52fe     ; 19
	pikapicanimgfx -1, Pic_e548e     ; 1a
	pikapicanimgfx 25, GFX_e5541     ; 1b
	pikapicanimgfx -1, Pic_e56d1     ; 1c
	pikapicanimgfx 25, GFX_e5794     ; 1d
	pikapicanimgfx -1, Pic_e5924     ; 1e
	pikapicanimgfx 25, GFX_e59ed     ; 1f
	pikapicanimgfx -1, Pic_e5b7d     ; 20
	pikapicanimgfx 25, GFX_e5c4d     ; 21
	pikapicanimgfx -1, Pic_e5ddd     ; 22
	pikapicanimgfx 25, GFX_e5e90     ; 23
	pikapicanimgfx 25, GFX_e6020     ; 24
	pikapicanimgfx 25, GFX_e61b0     ; 25
	pikapicanimgfx -1, Pic_e6340     ; 26
	pikapicanimgfx 25, GFX_e63f7     ; 27
	pikapicanimgfx -1, Pic_e6587     ; 28
	pikapicanimgfx 25, GFX_e6646     ; 29
	pikapicanimgfx -1, Pic_e67d6     ; 2a
	pikapicanimgfx 25, GFX_e682f     ; 2b
	pikapicanimgfx 25, GFX_e69bf     ; 2c
	pikapicanimgfx 25, GFX_e6b4f     ; 2d
	pikapicanimgfx 25, GFX_e6cdf     ; 2e
	pikapicanimgfx 25, GFX_e6e6f     ; 2f
	pikapicanimgfx 25, GFX_e6fff     ; 30
	pikapicanimgfx 25, GFX_e718f     ; 31
	pikapicanimgfx 25, GFX_e731f     ; 32
	pikapicanimgfx 25, GFX_e74af     ; 33
	pikapicanimgfx 25, GFX_e763f     ; 34
	pikapicanimgfx -1, Pic_e77cf     ; 35
	pikapicanimgfx 25, GFX_e7863     ; 36
	pikapicanimgfx 25, GFX_e79f3     ; 37
	pikapicanimgfx 25, GFX_e7b83     ; 38
	pikapicanimgfx 25, GFX_e7d13     ; 39
	pikapicanimgfx -1, Pic_f0abf     ; 3a
	pikapicanimgfx 25, GFX_f0b64     ; 3b
	pikapicanimgfx -1, Pic_f0cf4     ; 3c
	pikapicanimgfx 25, GFX_f0d82     ; 3d
	pikapicanimgfx 24, PikachuSprite ; 3e
