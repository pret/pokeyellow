%include "dos_port/include/gb_memmap.inc"

SECTION .text

global CanLearnTM
global TMToMove

; tests if mon [wCurPartySpecies] can learn move [wMoveNum]
CanLearnTM:
	mov al, [ebp + wCurPartySpecies]
	mov [ebp + wCurSpecies], al
	call GetMonHeader
	mov esi, wMonHLearnset
	push esi
	mov al, [ebp + wMoveNum]
	mov bh, al
	mov cl, 0
	mov esi, TechnicalMachines
.findTMloop:
	mov al, [esi]
	inc esi
	cmp al, 0xFF
	je .done
	cmp al, bh
	je .TMfoundLoop
	inc cl
	jmp .findTMloop
.TMfoundLoop:
	pop esi
	mov bh, FLAG_TEST
	call FlagActionPredef
	ret
.done:
	pop esi
	mov cl, 0
	ret

; converts TM/HM number in [wTempTMHM] into move number
; HMs start at 51
TMToMove:
	mov al, [ebp + wTempTMHM]
	dec al
	mov esi, TechnicalMachines
	movzx ecx, al
	add esi, ecx
	mov al, [esi]
	mov [ebp + wTempTMHM], al
	ret
