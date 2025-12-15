CableClubNPC::
	ld hl, CableClubNPCWelcomeText
	call PrintText
	call CheckPikachuFollowingPlayer
	jr nz, .asm_7048
	CheckEvent EVENT_GOT_POKEDEX
	jp nz, .receivedPokedex
; if the player hasn't received the pokedex
.asm_7048
	ld c, 60
	call DelayFrames
	ld hl, CableClubNPCMakingPreparationsText
	call PrintText
	jp .didNotConnect
.receivedPokedex
	ld a, $1
	ld [wMenuJoypadPollCount], a
	ld a, 90
	ld [wLinkTimeoutCounter], a
.establishConnectionLoop
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr z, .establishedConnection
	cp USING_EXTERNAL_CLOCK
	jr z, .establishedConnection
	ld a, CONNECTION_NOT_ESTABLISHED
	ldh [hSerialConnectionStatus], a
	ld a, ESTABLISH_CONNECTION_WITH_EXTERNAL_CLOCK
	ldh [rSB], a
	xor a
	ldh [hSerialReceiveData], a
	ld a, SC_START | SC_EXTERNAL
; This vc_hook causes the Virtual Console to set [hSerialConnectionStatus] to
; USING_INTERNAL_CLOCK, which allows the player to proceed past the link
; receptionist's "Please wait." It assumes that hSerialConnectionStatus is at
; its original address.
	vc_hook Link_fake_connection_status
	vc_assert hSerialConnectionStatus == $ffaa, \
		"hSerialConnectionStatus is no longer located at 00:ffaa"
	vc_assert USING_INTERNAL_CLOCK == $02, \
		"USING_INTERNAL_CLOCK is no longer equal to $02."
	ldh [rSC], a
	ld a, [wLinkTimeoutCounter]
	dec a
	ld [wLinkTimeoutCounter], a
	jr z, .failedToEstablishConnection
	ld a, ESTABLISH_CONNECTION_WITH_INTERNAL_CLOCK
	ldh [rSB], a
	ld a, SC_START | SC_INTERNAL
	ldh [rSC], a
	call DelayFrame
	jr .establishConnectionLoop
.establishedConnection
	call Serial_SendZeroByte
	call DelayFrame
	call Serial_SendZeroByte
	ld c, 50
	call DelayFrames
	ld hl, CableClubNPCPleaseApplyHereHaveToSaveText
	call PrintText
	xor a
	ld [wMenuJoypadPollCount], a
	call YesNoChoice
	ld a, $1
	ld [wMenuJoypadPollCount], a
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .choseNo
	vc_hook Wireless_TryQuickSave_block_input
	callfar SaveGameData
	call WaitForSoundToFinish
	ld a, SFX_SAVE
	call PlaySoundWaitForCurrent
	ld hl, CableClubNPCPleaseWaitText
	call PrintText
	ld hl, wUnknownSerialCounter
	ld a, $3
	ld [hli], a
	xor a
	ld [hl], a
	ldh [hSerialReceivedNewData], a
	ld [wSerialExchangeNybbleSendData], a
	vc_hook Wireless_prompt
	call Serial_SyncAndExchangeNybble
	vc_hook Wireless_net_recheck
	ld hl, wUnknownSerialCounter
	ld a, [hli]
	inc a
	jr nz, .connected
	ld a, [hl]
	inc a
	jr nz, .connected
	ld b, 10
.syncLoop
	call DelayFrame
	call Serial_SendZeroByte
	dec b
	jr nz, .syncLoop
	call CloseLinkConnection
	ld hl, CableClubNPCLinkClosedBecauseOfInactivityText
	call PrintText
	jr .didNotConnect
.failedToEstablishConnection
	ld hl, CableClubNPCAreaReservedFor2FriendsLinkedByCableText
	call PrintText
	jr .didNotConnect
.choseNo
	call CloseLinkConnection
	ld hl, CableClubNPCPleaseComeAgainText
	call PrintText
.didNotConnect
	xor a
	ld hl, wUnknownSerialCounter
	ld [hli], a
	ld [hl], a
	ld hl, wStatusFlags4
	res BIT_LINK_CONNECTED, [hl]
	xor a
	ld [wMenuJoypadPollCount], a
	ret
.connected
	xor a
	ld [hld], a
	ld [hl], a
	ld a, [wLetterPrintingDelayFlags]
	push af
	callfar LinkMenu
	pop af
	ld [wLetterPrintingDelayFlags], a
	ret

; seems to be similar of Serial_SyncAndExchangeNybble
Serial_SyncAndExchangeNybbleDouble:
	ld a, $ff
	ld [wSerialExchangeNybbleReceiveData], a
.loop
	call Serial_ExchangeNybble
	call DelayFrame
	push hl
	ld hl, wUnknownSerialCounter + 1
	dec [hl]
	jr nz, .next
	dec hl
	dec [hl]
	jr nz, .next
	pop hl
	jr .setUnknownSerialCounterToFFFF
.next
	pop hl
	ld a, [wSerialExchangeNybbleReceiveData]
	inc a
	jr z, .loop
	call DelayFrame
	ld a, $ff
	ld [wSerialExchangeNybbleReceiveData], a
	call Serial_ExchangeNybble
	ld a, [wSerialExchangeNybbleReceiveData]
	inc a
	jr z, .loop
	ld b, 10
.syncLoop1
	call DelayFrame
	call Serial_ExchangeNybble
	dec b
	jr nz, .syncLoop1
	ld b, 10
.syncLoop2
	call DelayFrame
	call Serial_SendZeroByte
	dec b
	jr nz, .syncLoop2
	ld a, [wSerialExchangeNybbleReceiveData]
	ld [wSerialSyncAndExchangeNybbleReceiveData], a
	ret
.setUnknownSerialCounterToFFFF
	ld a, $ff
	ld [wUnknownSerialCounter], a
	ld [wUnknownSerialCounter + 1], a
	ret

CableClubNPCAreaReservedFor2FriendsLinkedByCableText:
	text_far _CableClubNPCAreaReservedFor2FriendsLinkedByCableText
	text_end

CableClubNPCWelcomeText:
	text_far _CableClubNPCWelcomeText
	text_end

CableClubNPCPleaseApplyHereHaveToSaveText:
	text_far _CableClubNPCPleaseApplyHereHaveToSaveText
	text_end

CableClubNPCPleaseWaitText:
	text_far _CableClubNPCPleaseWaitText
	text_pause
	text_end

CableClubNPCLinkClosedBecauseOfInactivityText:
	text_far _CableClubNPCLinkClosedBecauseOfInactivityText
	text_end

CableClubNPCPleaseComeAgainText:
	text_far _CableClubNPCPleaseComeAgainText
	text_end

CableClubNPCMakingPreparationsText:
	text_far _CableClubNPCMakingPreparationsText
	text_end

CloseLinkConnection:
	call Delay3
	ld a, CONNECTION_NOT_ESTABLISHED
	ldh [hSerialConnectionStatus], a
	ld a, ESTABLISH_CONNECTION_WITH_EXTERNAL_CLOCK
	ldh [rSB], a
	xor a
	ldh [hSerialReceiveData], a
	ld a, SC_START | SC_EXTERNAL
	ldh [rSC], a
	ret
