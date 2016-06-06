Func_e8783: ; e8783 (3a:4783)
	ld a, 9
Func_e8785:
	push af
	ld hl, wPrinterData
	ld bc, wPrinterDataEnd - wPrinterData
	xor a
	call Printer_FillMemory
	xor a
	ld [rSB], a
	ld [rSC], a
	ld [wPrinterOpcode], a
	ld hl, wPrinterConnectionOpen
	set 0, [hl]
	ld a, [wPrinterSettings]
	ld [wPrinterSettingsTempCopy], a
	pop af
	ld [wcaf4], a
	ret

; e87a8
Func_e87a8: ; e87a8 (3a:47a8)
	ld a, [wPrinterSendState]
	ld e, a
	ld d, 0
	ld hl, .Jumptable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

.Jumptable:
	dw Printer_InitSerial ; 00
	dw Func_e88c9 ; 01
	dw Func_e88a6 ; 02
	dw Func_e881f ; 03
	dw Func_e8906 ; 04
	dw Func_e88b4 ; 05
	dw Func_e884b ; 06
	dw Func_e8906 ; 07
	dw Func_e88a6 ; 08
	dw Func_e8864 ; 09
	dw Func_e8906 ; 0a
	dw Func_e88a6 ; 0b
	dw Func_e8927 ; 0c
	dw Printer_Quit ; 0d
	dw Printer_Next_ ; 0e
	dw Func_e88a6 ; 10
	dw Func_e8889 ; 11
	dw Printer_LoopBack ; 12
	dw Func_e8936 ; 13
	dw Func_e8939 ; 14

Printer_Next:
	ld hl, wPrinterSendState
	inc [hl]
	ret

Printer_Back:
	ld hl, wPrinterSendState
	dec [hl]
	ret

Printer_Quit:
	xor a
	ld [wc971], a
	ld hl, wPrinterSendState
	set 7, [hl]
	ret

Printer_Next_:
	call Printer_Next
	ret

Printer_LoopBack:
	ld a, $1
	ld [wPrinterSendState], a
	ret

Printer_InitSerial:
	call ResetPrinterData
	ld hl, PrinterDataPacket1
	call CopyPrinterDataHeader
	xor a
	ld [wPrinterDataSize], a
	ld [wPrinterDataSize + 1], a
	ld a, [wcaf4]
	ld [wc6e9], a
	call Printer_Next
	call Printer_PrepareToSend
	ld a, PRINTER_STATUS_CHECKING_LINK
	ld [wPrinterStatusIndicator], a
	ret

Func_e881f:
	call ResetPrinterData
	ld hl, wc6e9
	ld a, [hl]
	and a
	jr z, Func_e884b
	ld hl, PrinterDataPacket3
	call CopyPrinterDataHeader
	call Func_e89e6
	ld a, (wPrinterSendDataSourceEnd - wPrinterSendDataSource) % $100
	ld [wPrinterDataSize], a
	ld a, (wPrinterSendDataSourceEnd - wPrinterSendDataSource) / $100
	ld [wPrinterDataSize + 1], a
	call ComputePrinterChecksum
	call Printer_Next
	call Printer_PrepareToSend
	ld a, PRINTER_STATUS_TRANSMITTING
	ld [wPrinterStatusIndicator], a
	ret

Func_e884b:
	ld a, $6
	ld [wPrinterSendState], a
	ld hl, PrinterDataPacket4
	call CopyPrinterDataHeader
	xor a
	ld [wPrinterDataSize], a
	ld [wPrinterDataSize + 1], a
	call Printer_Next
	call Printer_PrepareToSend
	ret

Func_e8864:
	call ResetPrinterData
	ld hl, PrinterDataPacket2
	call CopyPrinterDataHeader
	call Func_e89cf
	ld a, $4
	ld [wPrinterDataSize], a
	ld a, $0
	ld [wPrinterDataSize + 1], a
	call ComputePrinterChecksum
	call Printer_Next
	call Printer_PrepareToSend
	ld a, PRINTER_STATUS_PRINTING
	ld [wPrinterStatusIndicator], a
	ret

Func_e8889:
	call ResetPrinterData
	ld hl, PrinterDataPacket1
	call CopyPrinterDataHeader
	xor a
	ld [wPrinterDataSize], a
	ld [wPrinterDataSize + 1], a
	ld a, [wcaf4]
	ld [wc6e9], a
	call Printer_Next
	call Printer_PrepareToSend
	ret

Func_e88a6:
	ld hl, wc973
	inc [hl]
	ld a, [hl]
	cp a, $6
	ret c
	xor a
	ld [hl], a
	call Printer_Next
	ret

Func_e88b4:
	ld hl, wc973
	inc [hl]
	ld a, [hl]
	cp a, $6
	ret c
	xor a
	ld [hl], a
	ld hl, wc6e9
	dec [hl]
	call Printer_Back
	call Printer_Back
	ret

Func_e88c9:
	ld a, [wPrinterOpcode]
	and a
	ret nz
	ld a, [wc970]
	cp a, $ff
	jr nz, .asm_e88dc
	ld a, [wc971]
	cp a, $ff
	jr z, .asm_e88f8
.asm_e88dc
	ld a, [wc970]
	cp a, $81
	jr nz, .asm_e88f8
	ld a, [wc971]
	cp a, $0
	jr nz, .asm_e88f8
	ld hl, wPrinterConnectionOpen
	set 1, [hl]
	ld a, $5
	ld [wc972], a
	call Printer_Next
	ret

.asm_e88f8
	ld a, $ff
	ld [wc970], a
	ld [wc971], a
	ld a, $e
	ld [wPrinterSendState], a
	ret

Func_e8906:
	ld a, [wPrinterOpcode]
	and a
	ret nz
	ld a, [wc971]
	and a, $f0
	jr nz, .asm_e8921
	ld a, [wc971]
	and a, $1
	jr nz, .asm_e891d
	call Printer_Next
	ret

.asm_e891d
	call Printer_Back
	ret

.asm_e8921
	ld a, $12
	ld [wPrinterSendState], a
	ret

Func_e8927:
	ld a, [wPrinterOpcode]
	and a
	ret nz
	ld a, [wc971]
	and a, $f3
	ret nz
	call Printer_Next
	ret

Func_e8936:
	call Printer_Next
Func_e8939:
	ld a, [wPrinterOpcode]
	and a
	ret nz
	ld a, [wc971]
	and a, $f0
	ret nz
	xor a
	ld [wPrinterSendState], a
	ret

Printer_PrepareToSend:
.wait_printer_operation
	ld a, [wPrinterOpcode]
	and a
	jr nz, .wait_printer_operation
	xor a
	ld [wc974], a
	ld [wc975], a
	ld a, $1
	ld [wPrinterOpcode], a
	ld a, $88
	ld [rSB], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	ret

CopyPrinterDataHeader:
	ld a, [hli]
	ld [wPrinterDataHeader], a
	ld a, [hli]
	ld [wPrinterDataHeader + 1], a
	ld a, [hli]
	ld [wPrinterDataHeader + 2], a
	ld a, [hli]
	ld [wPrinterDataHeader + 3], a
	ld a, [hli]
	ld [wPrinterChecksum], a
	ld a, [hl]
	ld [wPrinterChecksum + 1], a
	ret

ResetPrinterData:
	xor a
	ld hl, wPrinterDataHeader
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wPrinterChecksum
	ld [hli], a
	ld [hl], a
	xor a
	ld [wPrinterDataSize], a
	ld [wPrinterDataSize + 1], a
	ld hl, wPrinterSendDataSource
	ld bc, wPrinterSendDataSourceEnd - wPrinterSendDataSource
	call Printer_FillMemory
	ret

ComputePrinterChecksum:
	ld hl, $0
	ld bc, $4
	ld de, wPrinterDataHeader
	call .AddToChecksum
	ld a, [wPrinterDataSize]
	ld c, a
	ld a, [wPrinterDataSize + 1]
	ld b, a
	ld de, wPrinterSendDataSource
	call .AddToChecksum
	ld a, l
	ld [wPrinterChecksum], a
	ld a, h
	ld [wPrinterChecksum + 1], a
	ret

.AddToChecksum:
.loop
	ld a, [de]
	inc de
	add l
	jr nc, .no_carry
	inc h
.no_carry
	ld l, a
	dec bc
	ld a, c
	or b
	jr nz, .loop
	ret

Func_e89cf:
	ld a, $1
	ld [wPrinterSerialReceived], a
	ld a, [wcae2]
	ld [wPrinterStatusReceived], a
	ld a, $e4
	ld [wc6f2], a
	ld a, [wPrinterSettingsTempCopy]
	ld [wc6f3], a
	ret

Func_e89e6:
	ld a, [wc6e9]
	ld b, a
	ld a, [wcaf4]
	sub b
	ld hl, wPrinterTileBuffer
	ld de, 2 * SCREEN_WIDTH
.get_row
	and a
	jr z, .got_row
	add hl, de
	dec a
	jr .get_row

.got_row
	ld e, l
	ld d, h
	ld hl, wPrinterSendDataSource
	ld c, 2 * SCREEN_WIDTH
.loop
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	swap a
	ld d, a
	and a, $f0
	ld e, a
	ld a, d
	and a, $f
	ld d, a
	and a, $8
	ld a, d
	jr nz, .vchars1
	or a, $90
	jr .got_addr

.vchars1
	or a, $80
.got_addr
	ld d, a
	lb bc, BANK(Func_e89e6), 1
	call CopyVideoData
	pop hl
	ld de, $10
	add hl, de
	pop de
	pop bc
	dec c
	jr nz, .loop
	ret

Printer_FillMemory: ; e8a2e (3a:4a2e)
	push de
	ld e, a
.loop
	ld [hl], e
	inc hl
	dec bc
	ld a, c
	or b
	jr nz, .loop
	ld a, e
	pop de
	ret

PrinterDataPacket1:
	db  1, 0, $00, 0
	dw 1
PrinterDataPacket2:
	db  2, 0, $04, 0
	dw 0
PrinterDataPacket3:
	db  4, 0, $80, 2
	dw 0
PrinterDataPacket4:
	db  4, 0, $00, 0
	dw 4
PrinterDataPacket5: ; unused
	db  8, 0, $00, 0
	dw 8
PrinterDataPacket6: ; unused
	db 15, 0, $00, 0
	dw 15

PrinterSerial_: ; e8a5e (3a:4a5e)
	ld a, [wPrinterOpcode]
	ld e, a
	ld d, 0
	ld hl, .Jumptable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

.Jumptable:
	dw .Nop

	dw .SignalTransmissionStart
	dw .SendHeaderByte1
	dw .SendHeaderByte2
	dw .SendHeaderByte3
	dw .SendHeaderByte4
	dw .DataByte
	dw .SendChecksumLo
	dw .SendChecksumHi
	dw .SignalTransmissionEnd
	dw .Receive1
	dw .Receive2

	dw .SignalTransmissionStart
	dw .Send_0F
	dw .Send_00
	dw .Send_00
	dw .Send_00
	dw .Send_0F
	dw .Send_00
	dw .SignalTransmissionEnd
	dw .Receive1
	dw .Receive2_

	dw .SignalTransmissionStart
	dw .SignalQuit
	dw .Send_00
	dw .Send_00
	dw .Send_00
	dw .SignalQuit
	dw .Send_00
	dw .SignalTransmissionEnd
	dw .Receive1
	dw .Receive2

.NextInstruction:
	ld hl, wPrinterOpcode
	inc [hl]
	ret

.Nop:
	ret

.SignalTransmissionStart:
	ld a, $33
	call .SendByte
	call .NextInstruction
	ret

.SendHeaderByte1:
	ld a, [wPrinterDataHeader]
	call .SendByte
	call .NextInstruction
	ret

.SendHeaderByte2:
	ld a, [wPrinterDataHeader + 1]
	call .SendByte
	call .NextInstruction
	ret

.SendHeaderByte3:
	ld a, [wPrinterDataHeader + 2]
	call .SendByte
	call .NextInstruction
	ret

.SendHeaderByte4:
	ld a, [wPrinterDataHeader + 3]
	call .SendByte
	call .NextInstruction
	ret

.DataByte:
	ld hl, wPrinterDataSize
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, e
	or d
	jr z, .sent_last_byte
	dec de
	ld [hl], d
	dec hl
	ld [hl], e
	ld a, [wc974]
	ld e, a
	ld a, [wc975]
	ld d, a
	ld hl, wPrinterSendDataSource
	add hl, de
	inc de
	ld a, e
	ld [wc974], a
	ld a, d
	ld [wc975], a
	ld a, [hl]
	call .SendByte
	ret

.sent_last_byte
	call .NextInstruction
.SendChecksumLo:
	ld a, [wPrinterChecksum]
	call .SendByte
	call .NextInstruction
	ret

.SendChecksumHi:
	ld a, [wPrinterChecksum + 1]
	call .SendByte
	call .NextInstruction
	ret

.SignalTransmissionEnd:
	ld a, $0
	call .SendByte
	call .NextInstruction
	ret

.Receive1:
	ld a, [rSB]
	ld [wc970], a
	ld a, $0
	call .SendByte
	call .NextInstruction
	ret

.Receive2:
	ld a, [rSB]
	ld [wc971], a
	xor a
	ld [wPrinterOpcode], a
	ret

.Send_0F:
	ld a, $f
	call .SendByte
	call .NextInstruction
	ret

.Send_00:
	ld a, $0
	call .SendByte
	call .NextInstruction
	ret

.SignalQuit:
	ld a, $8
	call .SendByte
	call .NextInstruction
	ret

.SendByte:
	ld [rSB], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	ret

.Receive2_:
	ld a, [rSB]
	ld [wc971], a
	xor a
	ld [wPrinterOpcode], a
	ret
