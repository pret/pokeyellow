%include "dos_port/include/gb_memmap.inc"

SECTION .text

global BuildFlyLocationsList
global TownMapCoordsToOAMCoords
global ZeroOutDuplicatesInList
global LoadTownMapEntry

BuildFlyLocationsList:
	mov esi, wFlyAnimUsingCoordList
	mov byte [ebp + esi], 0xFF
	inc esi
	mov al, [ebp + wTownVisitedFlag]
	mov dl, al
	mov al, [ebp + wTownVisitedFlag + 1]
	mov dh, al
	mov bh, 0
	mov cl, NUM_CITY_MAPS
.loop:
	shr dh, 1
	rcr dl, 1
	mov al, NOT_VISITED
	jnc .notVisited
	mov al, bh
.notVisited:
	mov [ebp + esi], al
	inc esi
	inc bh
	dec cl
	jnz .loop
	mov byte [ebp + esi], 0xFF
	ret

TownMapCoordsToOAMCoords:
; in: lower nybble of a = x, upper nybble of a = y
; out: b and [hl] = (y * 8) + 24, c and [hl+1] = (x * 8) + 24
	push eax
	and al, 0xF0
	shr al, 1
	add al, 24
	mov bh, al
	mov [ebp + esi], al
	inc esi
	pop eax
	and al, 0x0F
	shl al, 4
	shr al, 1
	add al, 24
	mov bl, al
	mov [ebp + esi], al
	inc esi
	ret

ZeroOutDuplicatesInList:
; replace duplicate bytes in the list of wild pokemon locations with 0
	mov edx, wBuffer
.loop:
	mov al, [ebp + edx]
	inc edx
	cmp al, 0xFF
	je .done
	mov cl, al
	mov esi, edx
.zeroDuplicatesLoop:
	mov al, [ebp + esi]
	cmp al, 0xFF
	je .loop
	cmp al, cl
	jne .skipZeroing
	xor al, al
	mov [ebp + esi], al
.skipZeroing:
	inc esi
	jmp .zeroDuplicatesLoop
.done:
	ret

LoadTownMapEntry:
; in: a = map number
; out: lower nybble of [de] = x, upper nybble of [de] = y, hl = address of name
	cmp al, FIRST_INDOOR_MAP
	jc .external
	mov cx, 4
	mov esi, InternalMapEntries
.loop:
	cmp al, [esi]
	jc .foundEntry
	movzx ecx, cx
	add esi, ecx
	jmp .loop
.foundEntry:
	inc esi
	jmp .readEntry
.external:
	mov esi, ExternalMapEntries
	movzx ecx, al
	lea esi, [esi + ecx*2]
	add esi, ecx
.readEntry:
	mov al, [esi]
	inc esi
	mov [ebp + edx], al
	mov al, [esi]
	inc esi
	mov ah, [esi]
	movzx esi, ax
	ret

; INCLUDE "data/maps/town_map_entries.asm"
; INCLUDE "data/maps/names.asm"
