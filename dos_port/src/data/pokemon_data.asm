; pokemon_data.asm — Pokémon static data tables (Pokémon data/stats plan).
;
; Holds the generated/translated read-only Pokémon data so the engine routines
; (GetMonHeader, CalcStat, CalcExperience, …) can `extern` them. Per the linker
; rule in docs/assembly.md, embedded data lives in .data (not .rodata).
;
; BaseStats / IndexToPokedex : tools/gen_base_stats.py (from data/pokemon/).
; GrowthRateTable            : hand-translated from data/growth_rates.asm.
;
; Build: nasm -f coff -I include/ -I . -o pokemon_data.o pokemon_data.asm

bits 32

global BaseStats
global IndexToPokedex
global GrowthRateTable

section .data
align 4

%include "assets/base_stats.inc"
%include "assets/growth_rates.inc"
