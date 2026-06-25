; pallet_town.asm — hand-translated text_asm scripts for Pallet Town.
;
; Reference port of the event/var-gated dialog in scripts/PalletTown.asm. This is
; the first faithful text_asm translation and the template for the rest: a script
; is a native routine reached from the map's TextTable via a SCRIPT entry
; (`dd <label>, 0xFFFFFFFF`, emitted by gen_npc_dialogs' SCRIPT_OVERRIDES). The
; dialog dispatcher (map_sprites.asm:CheckNPCInteraction) CALLs the routine after
; loading the font; the routine picks a text stream and prints it via ShowTextStream
; (copy flat stream → NPC_DIALOG_BUF, PrintText, wait for A/B), then returns.
;
; In: EBP = GB memory base; font already loaded; player frozen in a standing pose.
; The routine may use AL/flags freely (caller preserves via pushad).

bits 32

%include "gb_memmap.inc"
%include "assets/event_constants.inc"
%include "events.inc"

global PalletTownOakText
extern ShowTextStream            ; (ESI = flat TX stream, ECX = byte count)

; ---------------------------------------------------------------------------
section .data

; pret: PalletTownOakText branches on wOakWalkedToPlayer to pick its line. This
; reference branches on an event flag to demonstrate the event-gated path end to
; end; the full intro variants land with the Oak walk-up cutscene (next milestone).
; "OAK: That was / close!"  (shown once EVENT_GOT_POKEBALLS_FROM_OAK is set)
oak_got_text:
    db 0x00, 0x8E, 0x80, 0x8A, 0x9C, 0x7F, 0x93, 0xA7, 0xA0, 0xB3, 0x7F, 0xB6, 0xA0, 0xB2, 0x4F, 0xA2
    db 0xAB, 0xAE, 0xB2, 0xA4, 0xE7, 0x57, 0x50
oak_got_text_end:

; "OAK: Hey! Wait! / Don't go out!"  (default — event clear)
oak_default_text:
    db 0x00, 0x8E, 0x80, 0x8A, 0x9C, 0x7F, 0x87, 0xA4, 0xB8, 0xE7, 0x7F, 0x96, 0xA0, 0xA8, 0xB3, 0xE7
    db 0x4F, 0x83, 0xAE, 0xAD, 0xBE, 0x7F, 0xA6, 0xAE, 0x7F, 0xAE, 0xB4, 0xB3, 0xE7, 0x57, 0x50
oak_default_text_end:

; ---------------------------------------------------------------------------
section .text

PalletTownOakText:
    CheckEvent EVENT_GOT_POKEBALLS_FROM_OAK   ; ZF=1 ⇒ flag clear
    jz .default
    mov esi, oak_got_text
    mov ecx, oak_got_text_end - oak_got_text
    jmp .show
.default:
    mov esi, oak_default_text
    mov ecx, oak_default_text_end - oak_default_text
.show:
    call ShowTextStream
    ret
