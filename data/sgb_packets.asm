ATTR_BLK: MACRO
; This is a command macro.
; Use ATTR_BLK_DATA for data sets.
	db ($4 << 3) + ((\1 * 6) / 16 + 1)
	db \1
ENDM
ATTR_BLK_DATA: MACRO
	db \1 ; which regions are affected
	db \2 + (\3 << 2) + (\4 << 4) ; palette for each region
	db \5, \6, \7, \8 ; x1, y1, x2, y2
ENDM

PAL_SET: MACRO
	db ($a << 3) + 1
	dw \1, \2, \3, \4
	ds 7
ENDM

PAL_TRN: MACRO
	db ($b<< 3) + 1
	ds 15
ENDM

MLT_REQ: MACRO
	db ($11 << 3) + 1
	db \1 - 1
	ds 14
ENDM

CHR_TRN: MACRO
	db ($13 << 3) + 1
	db \1 + (\2 << 1)
	ds 14
ENDM

PCT_TRN: MACRO
	db ($14 << 3) + 1
	ds 15
ENDM

MASK_EN: MACRO
	db ($17 << 3) + 1
	db \1
	ds 14
ENDM

DATA_SND: MACRO
	db ($f << 3) + 1
	dw \1 ; address
	db \2 ; bank
	db \3 ; length (1-11)
ENDM

BlkPacket_WholeScreen:
	db $21
	db $1,$3,$0,$0,$0,$13,$11,$0
	db $0,$0,$0,$0,$0,$0,$0
BlkPacket_Battle:
	db $22
	db $5,$7,$a,$0,$c,$13,$11,$3,$5,$1
	db $0,$a,$3,$3,$0,$a,$7,$13,$a
	db $3,$a,$0,$4,$8,$b,$3,$f,$b
	db $0,$13,$6
BlkPacket_StatusScreen:
	db $21
	db $1,$7,$5,$1,$0
	db $7,$6,$0,$0,$0,$0,$0,$0,$0
	db $0
BlkPacket_Pokedex:
	db $21
	db $1,$7,$5,$1,$1,$8,$8
	db $0,$0,$0,$0,$0,$0,$0,$0
BlkPacket_Slots:
	db $22
	db $5,$3,$5,$0,$0,$13,$b,$3,$a
	db $0,$4,$13,$9,$2,$f,$0,$6,$13
	db $7,$3,$0,$4,$4,$f,$9,$3,$0
	db $0,$c,$13,$11
BlkPacket_Titlescreen:
	db $22
	db $3,$3,$0,$0
	db $0,$13,$7,$3,$a,$0,$8,$13,$11
	db $2,$0,$9,$8,$a,$8,$0,$0,$0
	db $0,$0,$0,$0,$0,$0,$0,$0,$0
BlkPacket_NidorinoIntro ; 726a1 (1c:66a1)
	db $22
	db $3,$3,$5,$0,$0,$13,$3,$3
	db $0,$0,$4,$13,$d,$3,$5,$0,$e
	db $13,$11,$0,$0,$0,$0,$0,$0,$0
	db $0,$0,$0,$0,$0
BlkPacket_PartyMenu:
	db $23
	db $7,$6,$10
	db $1,$0,$2,$c,$2,$0,$5,$1,$b
	db $1,$2,$0,$5,$3,$b,$3,$2,$0
	db $5,$5,$b,$5,$2,$0,$5,$7,$b
	db $7,$2,$0,$5,$9,$b,$9,$2,$0
	db $5,$b,$b,$b,$0,$0,$0,$0
BlkPacket_TrainerCard:
	db $24
	db $a,$2,$0,$3,$c,$4,$d,$2,$5
	db $7,$c,$8,$d,$2,$f,$b,$c,$c
	db $d,$2,$a,$10,$b,$11,$c,$2,$5
	db $e,$d,$f,$d,$2,$f,$10,$d,$11
	db $d,$2,$a,$3,$f,$4,$10,$2,$f
	db $7,$f,$8,$10,$2,$a,$b,$f,$c
	db $10,$2,$5,$f,$f,$10,$10,$0,$0
BlkPacket_GameFreakIntro:
	db $22
	db $3,$7,$5,$5,$b,$7,$d,$2
	db $a,$8,$b,$9,$d,$3,$f,$c,$b
	db $e,$d,$0,$0,$0,$0,$0,$0,$0
	db $0,$0,$0,$0,$0
UnknownPacket_72751:
	db $21,$1,$7,$5
	db $4,$0,$f,$5,$0,$0,$0,$0,$0
	db $0,$0,$0

PalPacket_Empty:
	PAL_SET 0, 0, 0, 0

PalPacket_PartyMenu:
	PAL_SET PAL_MEWMON, PAL_GREENBAR, PAL_YELLOWBAR, PAL_REDBAR

PalPacket_Black:
	PAL_SET PAL_BLACK, PAL_BLACK, PAL_BLACK, PAL_BLACK

PalPacket_TownMap:
	PAL_SET PAL_TOWNMAP, 0, 0, 0

PalPacket_Pokedex:
	PAL_SET PAL_BROWNMON, 0, 0, 0

PalPacket_Slots:
	PAL_SET PAL_SLOTS1, PAL_SLOTS2, PAL_SLOTS3, PAL_SLOTS4

PalPacket_Titlescreen:
	PAL_SET PAL_LOGO2, PAL_LOGO1, PAL_MEWMON, PAL_PURPLEMON

PalPacket_TrainerCard:
	PAL_SET PAL_MEWMON, PAL_BADGE, PAL_REDMON, PAL_YELLOWMON

PalPacket_Generic:
	PAL_SET PAL_MEWMON, 0, 0, 0

PalPacket_NidorinoIntro:
	PAL_SET PAL_PURPLEMON, PAL_BLACK, 0, 0

PalPacket_GameFreakIntro:
	PAL_SET PAL_GAMEFREAK, PAL_REDMON, PAL_VIRIDIAN, PAL_BLUEMON

UnknownPalPacket_72811:
	db $51,$25,$0,$25,$0,$25,$0,$25,$0,$0,$0,$0,$0,$0,$0,$0

UnknownPalPacket_72821:
	db $51,$25,$0,$27,$0,$25,$0,$25,$0,$0,$0,$0,$0,$0,$0,$0

PalTrnPacket:
	PAL_TRN
MltReq1Packet:
	MLT_REQ 1
MltReq2Packet:
	MLT_REQ 2
ChrTrnPacket:
	CHR_TRN 0, 0
PctTrnPacket:
	PCT_TRN

MaskEnFreezePacket:
	MASK_EN 1
MaskEnCancelPacket:
	MASK_EN 0

; These are DATA_SND packets containing SNES code.
; This set of packets is found in several Japanese SGB-compatible titles.
; It appears to be part of NCL's SGB devkit.

DataSnd_728a1: DATA_SND $85d, $0, 11
	db  $8C                 ; cpx #$8c (2)
	db  $D0, $F4            ; bne -$0c
	db  $60                 ; rts
	ds  7

DataSnd_728b1: DATA_SND $852, $0, 11
	db  $A9, $E7            ; lda #$e7
	db  $9F, $01, $C0, $7E  ; sta $7ec001, x
	db  $E8                 ; inx
	db  $E8                 ; inx
	db  $E8                 ; inx
	db  $E8                 ; inx
	db  $E0                 ; cpx #$8c (1)

DataSnd_728c1: DATA_SND $847, $0, 11 ; 728c1 (1c:68c1)
	db  $C4                 ; cmp #$c4 (2)
	db  $D0, $16            ; bne +$16
	db  $A5                 ; lda dp
	db  $CB                 ; wai
	db  $C9, $05            ; cmp #$05
	db  $D0, $10            ; bne +$10
	db  $A2, $28            ; ldx #$28

DataSnd_728d1: DATA_SND $83c, $0, 11 ; 728d1 (1c:68d1)
	db  $F0, $12            ; beq +$12
	db  $A5                 ; lda dp
	db  $C9, $C9            ; cmp #$c9
	db  $C8                 ; iny
	db  $D0, $1C            ; bne +$1c
	db  $A5                 ; lda dp
	db  $CA                 ; dex
	db  $C9                 ; cmp #$c4 (1)

DataSnd_728e1: DATA_SND $831, $0, 11
	dbw $0C, $CAA5          ; tsb $caa5
	db  $C9, $7E            ; cmp #$7e
	db  $D0, $06            ; bne +$06
	db  $A5                 ; lda dp
	db  $CB                 ; wai
	db  $C9, $7E            ; cmp #$7e

DataSnd_728f1: DATA_SND $826, $0, 11
	db  $39                 ; bne +$39 (2)
	dbw $CD, $C48           ; cmp $c48
	db  $D0, $34            ; bne +$34
	db  $A5                 ; lda dp
	db  $C9, $C9            ; cmp #$c9
	db  $80, $D0            ; bra -$30

DataSnd_72901: DATA_SND $81b, $0, 11
	db  $EA                 ; nop
	db  $EA                 ; nop
	db  $EA                 ; nop
	db  $EA                 ; nop
	db  $EA                 ; nop
	                        ; $820:
	db  $A9,$01             ; lda #01
	dbw $CD,$C4F            ; cmp $c4f
	db  $D0                 ; bne +$39 (1)

DataSnd_72911: DATA_SND $810, $0, 11
	dbw $4C, $820           ; jmp $820
	db  $EA                 ; nop
	db  $EA                 ; nop
	db  $EA                 ; nop
	db  $EA                 ; nop
	db  $EA                 ; nop
	db  $60                 ; rts
	db  $EA                 ; nop
	db  $EA                 ; nop
