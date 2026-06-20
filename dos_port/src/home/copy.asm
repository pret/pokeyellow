; dos_port/home/copy.asm
global FarCopyData
global CopyData
global CopyVideoDataAlternate
global CopyVideoDataDoubleAlternate

extern wFarCopyDataSavedROMBank
extern hLoadedROMBank
extern BankswitchCommon
extern CopyVideoData
extern CopyVideoDataDouble
extern FarCopyDataDouble
extern rLCDC

section .text

FarCopyData:
    mov [ebp + wFarCopyDataSavedROMBank], al
    mov al, [ebp + hLoadedROMBank]
    push ax
    mov al, [ebp + wFarCopyDataSavedROMBank]
    call BankswitchCommon
    call CopyData
    pop ax
    call BankswitchCommon
    ret

CopyData:
    movzx ecx, bx
    test ecx, ecx
    jnz .check_size
    mov ecx, 256
.check_size:
    movzx edx, dx
.loop4:
    cmp ecx, 4
    jb .loop1
    mov eax, [ebp + esi]
    mov [ebp + edx], eax
    add esi, 4
    add edx, 4
    sub ecx, 4
    jmp .loop4
.loop1:
    test ecx, ecx
    jz .done
    mov al, [ebp + esi]
    mov [ebp + edx], al
    inc esi
    inc edx
    dec ecx
    jmp .loop1
.done:
    xor bx, bx
    ret

CopyVideoDataAlternate:
    mov al, [ebp + rLCDC]
    test al, 0x80
    jnz CopyVideoData

    push esi
    mov esi, edx
    pop dx
    
    mov al, bh
    push ax
    
    mov al, bl
    ror al, 4
    mov ah, al
    and ah, 0x0F
    mov bh, ah
    and al, 0xF0
    mov bl, al
    
    pop ax
    jmp FarCopyData

CopyVideoDataDoubleAlternate:
    mov al, [ebp + rLCDC]
    test al, 0x80
    jnz CopyVideoDataDouble

    push dx
    mov dx, si
    mov al, bh
    push ax
    
    movzx esi, bl
    shl esi, 3
    mov bx, si
    
    pop ax
    pop si
    jmp FarCopyDataDouble
