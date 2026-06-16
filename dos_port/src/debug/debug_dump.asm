; debug_dump.asm — runtime ground-truth memory dump (debug builds only).
;
; Exfiltrates selected windows of emulated GB memory to a host file ("DUMP.BIN")
; so they can be hexdumped on the host. This bypasses the PPU/palette/blit
; entirely — the values written are the literal bytes in the GB address space,
; with no visual interpretation.
;
; Channel: DOS file I/O via the DPMI "Simulate Real Mode Interrupt" service
; (INT 31h AX=0300h). Under CWSDPMI a protected-mode `int 21h` with a DS:DX
; pointer is NOT auto-translated, so we allocate a conventional (<1 MB) DOS
; buffer (DPMI fn 0100h), stage the filename + data there, and reflect INT 21h
; AH=3Ch/40h/3Eh into real mode with the buffer's real-mode segment in DS.
;
; Wired in only under -D DEBUG_DUMP (see Makefile + overworld.asm EnterMap).
; After dumping, the program exits via INT 21h AH=4Ch — no game loop runs.
;
; Build: nasm -f coff -I include/ -I . -o debug_dump.o src/debug/debug_dump.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

extern ds_base

global DebugDumpMemory
global DumpBackbuffer

; Each window is WIN_SIZE bytes copied from [EBP + window_offset].
; The host-side layout is simply these windows concatenated in table order.
WIN_SIZE     equ 0x40
NUM_WINDOWS  equ 9
DUMP_TOTAL   equ NUM_WINDOWS * WIN_SIZE          ; 9 * 64 = 576 bytes

; DPMI real-mode call structure field offsets (DPMI 0.9 spec)
RMCS_EBX     equ 0x10
RMCS_EDX     equ 0x14
RMCS_ECX     equ 0x18
RMCS_EAX     equ 0x1C
RMCS_FLAGS   equ 0x20
RMCS_DS      equ 0x24
RMCS_SIZE    equ 0x32

; ---------------------------------------------------------------------------
section .data
align 4

fname: db "DUMP.BIN", 0
fbname: db "FRAME.BIN", 0

; GB-address start of each 64-byte dump window. Host hexdump offsets:
;   0x000  0x4600  overworld blockset (block 0..3)         — asset copy check
;   0x040  0x4B20  blockset entry for block 0x52           — DrawTileBlock src
;   0x080  0x4E00  PalletTown.blk (map block IDs)          — map asset copy
;   0x0C0  0x9000  vTileset gfx in VRAM (tile 0,1,...)     — H2: tileset load
;   0x100  0xC718  wOverworldMap around view ptr (0xC71B)  — LoadTileBlockMap
;   0x140  0xC508  wSurroundingTiles                       — DrawTileBlock out
;   0x180  0xC3A0  wTileMap (final 20x18 view)             — H1: tilemap
;   0x1C0  0xD358  map header vars (curmap/dims/dataptr)   — header setup
;   0x200  0xD520  tileset pointers (bank/blocks/gfx)      — pointer setup
windows:
    dd 0x4600
    dd 0x4B20
    dd 0x4E00
    dd 0x9000
    dd 0xC718
    dd 0xC508
    dd 0xC3A0
    dd 0xD358
    dd 0xD520

; ---------------------------------------------------------------------------
section .bss
align 4
rmcs:        resb RMCS_SIZE      ; DPMI real-mode call structure
dos_seg:     resw 1              ; real-mode segment of DOS buffer
dos_sel:     resw 1              ; PM selector of DOS buffer (unused; freed via seg)
dos_flat:    resd 1              ; DS-relative (flat) offset of DOS buffer
file_handle: resw 1
stage:       resb DUMP_TOTAL     ; concatenated window bytes, staged here first

; ---------------------------------------------------------------------------
section .text

; ---------------------------------------------------------------------------
; DebugDumpMemory — gather windows, write DUMP.BIN, exit. Never returns.
; In: EBP = GB memory base.
; ---------------------------------------------------------------------------
DebugDumpMemory:
    ; --- 1. Gather each GB window into the staging buffer ---
    mov esi, windows
    mov edi, stage
    mov edx, NUM_WINDOWS
.gather:
    mov eax, [esi]                 ; GB offset of this window
    add esi, 4
    push esi
    push edx
    lea esi, [ebp + eax]           ; flat source = GB base + offset
    mov ecx, WIN_SIZE
    rep movsb                      ; DS:ESI -> ES:EDI, EDI accumulates
    pop edx
    pop esi
    dec edx
    jnz .gather

    ; --- 2. Allocate a 1 KB conventional DOS buffer (DPMI fn 0100h) ---
    mov ax, 0x0100
    mov bx, 0x40                   ; 64 paragraphs = 1024 bytes
    int 0x31
    jc .exit
    mov [dos_seg], ax
    mov [dos_sel], dx
    movzx eax, ax
    shl eax, 4                     ; linear = seg * 16
    sub eax, [ds_base]             ; flat (wraps under 4 GB limit -> linear)
    mov [dos_flat], eax

    ; --- 3. Stage filename at DOS buffer offset 0 ---
    mov esi, fname
    mov edi, [dos_flat]
    mov ecx, 9                     ; "DUMP.BIN" + NUL
    rep movsb

    ; --- 4. Stage dump data at DOS buffer offset 0x10 ---
    mov esi, stage
    mov edi, [dos_flat]
    add edi, 0x10
    mov ecx, DUMP_TOTAL
    rep movsb

    ; --- 5. Create file: INT 21h AH=3Ch, CX=0, DS:DX -> filename ---
    call zero_rmcs
    mov word [rmcs + RMCS_EAX], 0x3C00
    mov dword [rmcs + RMCS_EDX], 0                 ; filename at offset 0
    mov ax, [dos_seg]
    mov [rmcs + RMCS_DS], ax
    call sim_int21
    test byte [rmcs + RMCS_FLAGS], 1               ; CF set => error
    jnz .free
    mov ax, [rmcs + RMCS_EAX]
    mov [file_handle], ax

    ; --- 6. Write data: INT 21h AH=40h, BX=handle, CX=len, DS:DX -> data ---
    call zero_rmcs
    mov word [rmcs + RMCS_EAX], 0x4000
    movzx eax, word [file_handle]
    mov [rmcs + RMCS_EBX], eax
    mov dword [rmcs + RMCS_ECX], DUMP_TOTAL
    mov dword [rmcs + RMCS_EDX], 0x10              ; data at offset 0x10
    mov ax, [dos_seg]
    mov [rmcs + RMCS_DS], ax
    call sim_int21

    ; --- 7. Close file: INT 21h AH=3Eh, BX=handle ---
    call zero_rmcs
    mov word [rmcs + RMCS_EAX], 0x3E00
    movzx eax, word [file_handle]
    mov [rmcs + RMCS_EBX], eax
    call sim_int21

.free:
    ; Free the DOS buffer (DPMI fn 0101h, DX = selector)
    mov ax, 0x0101
    mov dx, [dos_sel]
    int 0x31

.exit:
    mov ax, 0x4C00
    int 0x21

; ---------------------------------------------------------------------------
; DumpBackbuffer — write the full GB_BACKBUF (RENDER_W*RENDER_H = 64000 raw
; palette-indexed bytes) to FRAME.BIN, then exit. Lets the host render the exact
; pixels the software PPU produced under DOSBox-X (no compositor screenshot).
; Allocates a single 64 KB+ conventional buffer so the data goes out in one write.
; In: EBP = GB memory base. Never returns.
; ---------------------------------------------------------------------------
DumpBackbuffer:
    ; --- Allocate a conventional DOS buffer big enough for 0x10 + 64000 bytes ---
    ; 0x10 + 64000 = 64016 bytes -> 4001 paragraphs; round up to 0x1001 (4097).
    mov ax, 0x0100
    mov bx, 0x1001
    int 0x31
    jc .exit
    mov [dos_seg], ax
    mov [dos_sel], dx
    movzx eax, ax
    shl eax, 4
    sub eax, [ds_base]
    mov [dos_flat], eax

    ; --- Stage filename at offset 0 ---
    mov esi, fbname
    mov edi, [dos_flat]
    mov ecx, 10                    ; "FRAME.BIN" + NUL
    rep movsb

    ; --- Copy backbuffer directly to buffer offset 0x10 ---
    lea esi, [ebp + GB_BACKBUF]
    mov edi, [dos_flat]
    add edi, 0x10
    mov ecx, GB_BACKBUF_SIZE
    rep movsb

    ; --- Create FRAME.BIN ---
    call zero_rmcs
    mov word [rmcs + RMCS_EAX], 0x3C00
    mov dword [rmcs + RMCS_EDX], 0
    mov ax, [dos_seg]
    mov [rmcs + RMCS_DS], ax
    call sim_int21
    test byte [rmcs + RMCS_FLAGS], 1
    jnz .free
    mov ax, [rmcs + RMCS_EAX]
    mov [file_handle], ax

    ; --- Write 64000 bytes ---
    call zero_rmcs
    mov word [rmcs + RMCS_EAX], 0x4000
    movzx eax, word [file_handle]
    mov [rmcs + RMCS_EBX], eax
    mov dword [rmcs + RMCS_ECX], GB_BACKBUF_SIZE
    mov dword [rmcs + RMCS_EDX], 0x10
    mov ax, [dos_seg]
    mov [rmcs + RMCS_DS], ax
    call sim_int21

    ; --- Close ---
    call zero_rmcs
    mov word [rmcs + RMCS_EAX], 0x3E00
    movzx eax, word [file_handle]
    mov [rmcs + RMCS_EBX], eax
    call sim_int21

.free:
    mov ax, 0x0101
    mov dx, [dos_sel]
    int 0x31
.exit:
    mov ax, 0x4C00
    int 0x21

; ---------------------------------------------------------------------------
; sim_int21 — reflect INT 21h to real mode using the prepared rmcs.
; DPMI fn 0300h: BL=int#, BH=0, CX=0 (no stack words), ES:EDI -> rmcs.
; ---------------------------------------------------------------------------
sim_int21:
    push eax
    push ebx
    push ecx
    push edi
    mov ax, 0x0300
    mov bl, 0x21
    mov bh, 0
    xor cx, cx
    mov edi, rmcs                  ; ES already = flat DS selector
    int 0x31
    pop edi
    pop ecx
    pop ebx
    pop eax
    ret

; ---------------------------------------------------------------------------
; zero_rmcs — clear the real-mode call structure.
; ---------------------------------------------------------------------------
zero_rmcs:
    push eax
    push ecx
    push edi
    mov edi, rmcs
    xor al, al
    mov ecx, RMCS_SIZE
    rep stosb
    pop edi
    pop ecx
    pop eax
    ret
