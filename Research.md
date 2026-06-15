# Memory Model Optimization Research

## Proposed Plan Change: Static Offset Simulation

Instead of using `EBP` as a dynamic base pointer for the emulated Game Boy memory map, we can declare the entire 72 KB Game Boy address space as a single contiguous array directly in the native `.bss` section (e.g., `gb_memory: resb 72 * 1024`), and use **absolute 32-bit addressing** (e.g., `[gb_memory + 0xC000]`).

### Why this is faster:

1. **Frees `EBP` (Massive Win):** The x86 architecture is famously register-starved. Freeing `EBP` from its base-pointer duties gives you a 7th general-purpose register. This perfectly aligns with `docs/386_optimization_strategy.md`, which states: *"Cache intermediate values in registers (like EAX, ECX, EDX, EBX, ESI, EDI) during complex calculations."* Now we can add `EBP` to that list.
2. **Smaller Instruction Sizes:** Accessing memory via `[EBP + disp32]` takes 6 bytes to encode (opcode + ModR/M + 32-bit displacement). Using absolute addressing `[gb_memory + 0xC000]` only takes 5 bytes. Smaller machine code means better instruction cache density, which is critical for 386 performance.
3. **Hardware-Accelerated Pointer Math:** If a GB pointer is held in a register (like `EBX`), translating it currently requires `[EBP + EBX]`. With the new model, we can use `[EBX + gb_memory]`, which the 386 ALU handles natively as a standard index+displacement operation with zero extra overhead.

### Why this preserves accuracy (Bug Preservation):

Because we are still allocating a single contiguous 72 KB block in `.bss`, the **relative distances** between all memory structures remain identical to the original hardware. If a critical glitch causes an out-of-bounds write that overruns `wSpriteStateData1` by 150 bytes, it will still land exactly inside `wSpriteStateData2`, just as it would on the original Game Boy. ACE (Arbitrary Code Execution) will also function identically because the raw binary payload will still land at the expected offsets.

---

## Future Implementation Tasks

When the codebase is ready for this refactor, the following documents and systems will need to be updated:

1. **`README.md` (Hard Conventions):**
   * Remove `EBP` from the reserved register list and mark it as a general-purpose register.
   * Update the "Memory Model" section to specify a static `.bss` flat allocation rather than a dynamic DPMI EBP-relative allocation.

2. **`ROADMAP.md` (Phase 1):**
   * Change *"GB memory model live: 72 KB DPMI allocation, EBP-relative access working"* to *"GB memory model live: 72 KB static .bss allocation, absolute 32-bit addressing working"*.

3. **`dos_port/include/gb_memmap.inc`:**
   * Modify the comments and macros so that variables resolve to `gb_memory + offset` rather than relying on `EBP`.

4. **`docs/glitch_safety.md`:**
   * Update the DPMI Protection Details to clarify that glitch safety is enforced by CWSDPMI's flat data selector segment limits over the `.bss` section, rather than bounded `EBP` offsets.
