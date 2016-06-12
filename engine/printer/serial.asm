StartTransmission_Send9Rows:
	ld a, 9
Printer_StartTransmission:
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
	ld [wPrinterQueueLength], a
	ret

PrinterTransmissionJumptable:
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
	dw Printer_CheckConnectionStatus ; 01
	dw Printer_WaitSerial ; 02
	dw Printer_StartTransmittingTilemap ; 03
	dw Printer_TransmissionLoop ; 04
	dw Printer_WaitSerialAndLoopBack2 ; 05
	dw Printer_EndTilemapTransmission ; 06
	dw Printer_TransmissionLoop ; 07
	dw Printer_WaitSerial ; 08

	dw Printer_SignalSendHeader ; 09
	dw Printer_TransmissionLoop ; 0a
	dw Printer_WaitSerial ; 0b
	dw Printer_WaitUntilFinished ; 0c
	dw Printer_Quit ; 0d

	dw Printer_Next_ ; 0e
	dw Printer_WaitSerial ; 0f
	dw Printer_SignalLoopBack ; 10
	dw Printer_LoopBack ; 11
	dw Printer_WaitLoopBack ; 12
	dw Printer_WaitLoopBack_ ; 13

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
	ld [wPrinterStatusFlags], a
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
	ld a, [wPrinterQueueLength]
	ld [wPrinterRowIndex], a
	call Printer_Next
	call Printer_PrepareToSend
	ld a, PRINTER_STATUS_CHECKING_LINK
	ld [wPrinterStatusIndicator], a
	ret

Printer_StartTransmittingTilemap:
	call ResetPrinterData
	ld hl, wPrinterRowIndex
	ld a, [hl]
	and a
	jr z, Printer_EndTilemapTransmission
	ld hl, PrinterDataPacket3
	call CopyPrinterDataHeader
	call Printer_Convert2RowsTo2bpp
	ld a, (wPrinterSendDataSource1End - wPrinterSendDataSource1) % $100
	ld [wPrinterDataSize], a
	ld a, (wPrinterSendDataSource1End - wPrinterSendDataSource1) / $100
	ld [wPrinterDataSize + 1], a
	call ComputePrinterChecksum
	call Printer_Next
	call Printer_PrepareToSend
	ld a, PRINTER_STATUS_TRANSMITTING
	ld [wPrinterStatusIndicator], a
	ret

Printer_EndTilemapTransmission:
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

Printer_SignalSendHeader:
	call ResetPrinterData
	ld hl, PrinterDataPacket2
	call CopyPrinterDataHeader
	call Printer_StageHeaderForSend
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

Printer_SignalLoopBack:
	call ResetPrinterData
	ld hl, PrinterDataPacket1
	call CopyPrinterDataHeader
	xor a
	ld [wPrinterDataSize], a
	ld [wPrinterDataSize + 1], a
	ld a, [wPrinterQueueLength]
	ld [wPrinterRowIndex], a
	call Printer_Next
	call Printer_PrepareToSend
	ret

Printer_WaitSerial:
	ld hl, wPrinterSerialFrameDelay
	inc [hl]
	ld a, [hl]
	cp $6
	ret c
	xor a
	ld [hl], a
	call Printer_Next
	ret

Printer_WaitSerialAndLoopBack2:
	ld hl, wPrinterSerialFrameDelay
	inc [hl]
	ld a, [hl]
	cp $6
	ret c
	xor a
	ld [hl], a
	ld hl, wPrinterRowIndex
	dec [hl]
	call Printer_Back
	call Printer_Back
	ret

Printer_CheckConnectionStatus:
	ld a, [wPrinterOpcode]
	and a
	ret nz
	ld a, [wPrinterHandshake]
	cp $ff
	jr nz, .asm_e88dc
	ld a, [wPrinterStatusFlags]
	cp $ff
	jr z, .asm_e88f8
.asm_e88dc
	ld a, [wPrinterHandshake]
	cp $81
	jr nz, .asm_e88f8
	ld a, [wPrinterStatusFlags]
	cp $0
	jr nz, .asm_e88f8
	ld hl, wPrinterConnectionOpen
	set 1, [hl]
	ld a, $5
	ld [wHandshakeFrameDelay], a
	call Printer_Next
	ret

.asm_e88f8
	ld a, $ff
	ld [wPrinterHandshake], a
	ld [wPrinterStatusFlags], a
	ld a, $e
	ld [wPrinterSendState], a
	ret

Printer_TransmissionLoop:
	ld a, [wPrinterOpcode]
	and a
	ret nz
	ld a, [wPrinterStatusFlags]
	and $f0
	jr nz, .asm_e8921
	ld a, [wPrinterStatusFlags]
	and $1
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

Printer_WaitUntilFinished:
	ld a, [wPrinterOpcode]
	and a
	ret nz
	ld a, [wPrinterStatusFlags]
	and $f3
	ret nz
	call Printer_Next
	ret

Printer_WaitLoopBack:
	call Printer_Next
Printer_WaitLoopBack_:
	ld a, [wPrinterOpcode]
	and a
	ret nz
	ld a, [wPrinterStatusFlags]
	and $f0
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
	ld [wPrinterSendByteOffset], a
	ld [wPrinterSendByteOffset + 1], a
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
	ld hl, wPrinterSendDataSource1
	ld bc, wPrinterSendDataSource1End - wPrinterSendDataSource1
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
	ld de, wPrinterSendDataSource1
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

Printer_StageHeaderForSend:
	ld a, $1
	ld [wPrinterSendDataSource1], a
	ld a, [wcae2]
	ld [wPrinterSendDataSource1 + 1], a
	ld a, %11100100
	ld [wPrinterSendDataSource1 + 2], a
	ld a, [wPrinterSettingsTempCopy]
	ld [wPrinterSendDataSource1 + 3], a
	ret

Printer_Convert2RowsTo2bpp:
	ld a, [wPrinterRowIndex]
	ld b, a
	ld a, [wPrinterQueueLength]
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
	ld hl, wPrinterSendDataSource1
	ld c, 2 * SCREEN_WIDTH
.loop
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	swap a
	ld d, a
	and $f0
	ld e, a
	ld a, d
	and $f
	ld d, a
	and $8
	ld a, d
	jr nz, .vchars1
	or $90
	jr .got_addr

.vchars1
	or $80
.got_addr
	ld d, a
	lb bc, BANK(Printer_Convert2RowsTo2bpp), 1
	call CopyVideoData
	pop hl
	ld de, $10
	add hl, de
	pop de
	pop bc
	dec c
	jr nz, .loop
	ret

Printer_FillMemory:
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

PrinterSerial_:
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
	ld a, [wPrinterSendByteOffset]
	ld e, a
	ld a, [wPrinterSendByteOffset + 1]
	ld d, a
	ld hl, wPrinterSendDataSource1
	add hl, de
	inc de
	ld a, e
	ld [wPrinterSendByteOffset], a
	ld a, d
	ld [wPrinterSendByteOffset + 1], a
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
	ld [wPrinterHandshake], a
	ld a, $0
	call .SendByte
	call .NextInstruction
	ret

.Receive2:
	ld a, [rSB]
	ld [wPrinterStatusFlags], a
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
	ld [wPrinterStatusFlags], a
	xor a
	ld [wPrinterOpcode], a
	ret
