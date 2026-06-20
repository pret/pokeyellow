# Pokémon Yellow — Glitch Classification Reference

Per-glitch catalogue for the DOS port's `BUG`/`GLITCH` tagging system.
See [`docs/glitch_safety.md`](../glitch_safety.md) for DPMI safety analysis and platform
recommendations.

**Sources:** Bulbapedia (Gen I glitch lists, battle glitches, overworld glitches, Mew glitch,
Super Glitch, ACE article). GlitchCity Wiki (`glitchcity.wiki`) returns HTTP 403 to
automated fetches — content there was reached only via search excerpts. If you can download
GlitchCity pages manually, priority targets are:

- `glitchcity.wiki/wiki/Pokémon_Yellow`
- `glitchcity.wiki/wiki/Pokémon_Yellow_predefined_functions_list` ← most useful for ACE guards
- `glitchcity.wiki/wiki/Guides:Inventory_Underflow_ACE_Setups_(EN_Yellow)`
- `glitchcity.wiki/wiki/Pikachu_off-screen_glitch`
- `glitchcity.wiki/wiki/SRAM_glitch`

---

## Tagging Quick Reference

```nasm
; GLITCH: <name> — <one-line description>
; Safety: safe under DPMI (bounded) | unsafe — ACE can escape EBP allocation

; BUG(critical): <description> — pret ref: <file>:<label>
%if BUG_FIX_LEVEL >= 1
    ; fixed implementation
%else
    ; original behavior
%endif

; BUG(general): <description>
%if BUG_FIX_LEVEL >= 2
    ; fixed implementation
%else
    ; original behavior
%endif
```

`BUG_FIX_LEVEL 0` = `/FIXNONE` (default, all bugs active)
`BUG_FIX_LEVEL 1` = `/FIXCRIT` (critical bugs fixed; GLITCH and BUG(general) preserved)
`BUG_FIX_LEVEL 2` = `/FIXALL`  (everything fixed; closest to clean behavior)

---

## Glitch Table by Engine Area

### Battle System

| Name | Category | ACE | Description |
|------|----------|-----|-------------|
| Badge Stat Boost Glitch | BUG(general) | No | Every stat-stage modification re-applies all badge boosts to all boosted stats, stacking to 999. Yellow badges: Boulder/Cascade/Thunder/Rainbow/Soul/Marsh/Volcano/Earth. |
| Critical Hit Ratio Error | BUG(general) | No | Focus Energy and Dire Hits quarter the crit ratio instead of quadrupling it (bit-shift error). |
| 1/256 Miss Glitch | BUG(general) | No | All moves have a 1/256 extra miss chance beyond stated accuracy, including 100% moves. |
| 0 Damage Glitch | BUG(general) | No | Moves dealing exactly 0 damage to a dual-type resist are logged as misses, not 0-damage hits. |
| HP Recovery Failure (mod 255) | BUG(general) | No | Recovery moves fail silently when HP deficit ≡ 255 (mod 256); treated as −1. |
| Bide vs Fly/Dig | BUG(general) | No | Bide hits Pokémon in Fly/Dig invulnerability and prematurely reveals their sprite. |
| Counter Glitch | BUG(general) | No | Counter can reflect non-Normal/Fighting moves or the user's own damage; causes link-battle desync. |
| Substitute + Confusion Self-Hit | BUG(general) | No | Confusion self-hit targets the opponent's Substitute instead of the confused Pokémon. |
| Toxic + Leech Seed Stacking | BUG(general) | No | Leech Seed damage increments Toxic's N counter each turn, compounding the multiplier. |
| Rest + Toxic Counter | BUG(general) | No | Rest does not reset the Toxic damage counter; subsequent poisoning stacks on the prior multiplier. |
| Substitute HP Drain Bug | BUG(general) | No | Absorb/Mega Drain/Dream Eater drain from a Substitute, not the target's HP. Present in Western Yellow; fixed in Japanese. |
| Exp. All Dilution | BUG(general) | No | Multiple Exp. All holders reduce the total experience distributed per share. |
| Level-Up Learnset Skipping | BUG(general) | No | Skipping multiple levels in one battle offers only the highest-level new move; intermediate moves are lost permanently. Yellow-specific (not in Stadium). |
| Mimic Level-Up Glitch | BUG(general) | No | Learning a new move during level-up resets Mimic's copied move to "--". Yellow-specific. |
| Hyper Beam + Sleep | BUG(general) | No | Sleep applied during Hyper Beam recharge bypasses accuracy checks and status immunity on the first turn. |
| Paralysis + Fly/Dig Invulnerability | BUG(general) | No | Full paralysis or confusion self-hit during Fly/Dig makes all opponent moves miss permanently until switch-out. |
| Trapping Sleep Glitch | BUG(general) | No | Sleep applied while a binding move is active permanently traps the Pokémon in binding after sleep cures. |
| Defrost Auto-Move | BUG(general) | No | Frozen Pokémon auto-execute their pre-selected move upon thawing; can cause link desync and PP underflow. |
| Transform Glitches | BUG(general) | Potential | Multiple undefined interactions when Transform copies zeroed or partial data, including species-index issues. |
| Swift Miss Glitch | BUG(general) | No | Japanese Yellow: Swift can miss vs Fly/Dig or raised evasion. Fixed in English Yellow — do NOT emulate. |
| Ghost Marowak (Poké Doll) | BUG(general) | No | A Poké Doll ends the scripted ghost Marowak battle permanently, skipping the encounter. |
| Experience Underflow → Lv 100 | GLITCH | No | Lv-1 Medium-Slow Pokémon forced to gain exp underflows and jumps to Lv 100. Functional speedrun exploit. |
| Division by Zero Freeze | BUG(critical) | No | If attacker Attack > 255 and defender Defense < 4, integer division by zero freezes the game. |
| Psywave Infinite Loop | BUG(critical) | Potential | Lv 0, 1, or 171 Pokémon cause the Psywave damage RNG loop to run indefinitely, hanging the battle engine. |
| Super Glitch | BUG(critical) | Potential | Glitch move indices A6–C3 have no name entry; the name-copy routine overruns the move table until hitting 0x50, corrupting the screen buffer and adjacent RAM. Translating the move-name routine must preserve this under `BUG_FIX_LEVEL 0`. |
| Move 0x00 (CoolTrainer♀ glitch) | BUG(critical) | Potential | Glitch move "--" (index 0x00) generates an unterminated name from ROM garbage, overflowing the buffer and corrupting party data, tiles, and audio. |
| Struggle PP Underflow | BUG(critical) | Potential | Auto-selected moves bypass Struggle; PP of the forced move underflows to 63. |
| Hyper Beam + Freeze | BUG(critical) | No | A Pokémon frozen during Hyper Beam's recharge is permanently unable to act. |
| Index #000 Post-Capture | BUG(critical) | Potential | Capturing index-0 glitch Pokémon leaves an invisible Ditto in battle with undefined state. |

### Overworld / Map

| Name | Category | ACE | Description |
|------|----------|-----|-------------|
| Mew Glitch | GLITCH | No | Extension of Trainer-Fly: the forced encounter's species index equals the Special stat of the last Pokémon fought. Yellow has an exclusive early-Viridian Forest setup route. |
| Trainer Escape / Trainer-Fly | GLITCH | Indirect | Flying/teleporting after a trainer sees you leaves a battle-pending flag; next map entry triggers a special encounter seeded by the last battled Pokémon's Special stat. |
| Glitch City | GLITCH | Indirect | Save in Safari Zone and reload on certain routes to trigger malformed map data. Saving *inside* Glitch City corrupts the save file permanently. Shared with RB. |
| OobLG (Out-of-bounds map loading) | GLITCH | YES | Map index overflow loads out-of-bounds map data, enabling arbitrary map-script execution and ACE. Yellow-compatible route exists. Safety: unsafe — ACE can escape EBP allocation. |
| Fossil / Ghost MissingNo. (Yellow) | GLITCH | No | Regular MissingNo. front sprite in Yellow may freeze; Fossil MissingNo. (index 182–184) bypasses the freeze and still duplicates the 6th item. Yellow-specific behavior differs from RB. |

### Follower / Pikachu Sprite (Yellow-exclusive)

| Name | Category | ACE | Description |
|------|----------|-----|-------------|
| Pikachu Off-Screen ACE | GLITCH | YES | Events leaving Pikachu off-screen corrupt RAM at D438+ (1 byte/step, value = direction). A glitch sign then redirects the PC into RAM. Yellow's most powerful native ACE vector. Safety: unsafe — ACE can escape EBP allocation under DPMI. |
| Pikachu Off-Screen Corruption (non-ACE) | BUG(general) | Partial | Without the ACE setup, off-screen Pikachu corrupts NPC turn-directions, warp data, and Pikachu happiness at D438–D4xx based on step direction. |
| Pikachu Item Happiness Glitch | BUG(general) | No | Using an ineffective item (Potion at full HP, Antidote when healthy, vitamin at max stat exp) raises friendship without consuming the item; repeatable infinitely. |
| Walking Pikachu Happiness Edge Cases | BUG(general) | No | Happiness system has multiple paths that grant unintended increments or fail to decrement. |
| Pikachu vs. Poké Ball (link battle) | BUG(general) | No | Pikachu appears to enter battle via Poké Ball on the opponent's display despite the local walking animation. |
| Pikachu Freeze (cliff + dance) | BUG(general) | No | Jumping off a ledge while Pikachu's dance animation plays freezes the follower sprite for 7–8 seconds. |
| Pikachu Stutter (Pokémon Tower) | BUG(general) | No | Stepping onto the purified zone with Pikachu fainted causes the follower animation to stutter. |

### Item / Inventory

| Name | Category | ACE | Description |
|------|----------|-----|-------------|
| Item Underflow / Dry Underflow | GLITCH | YES | Merging two item stacks to ×256 → ×0, then tossing one, yields ×255; exposes memory beyond the 20-slot bag as readable/writable item slots. Gateway to ws# #m# and full ACE. |
| ws# #m# (Yellow ACE glitch item) | GLITCH | YES | Using this glitch item (obtained via item underflow) jumps the PC to the current PC box Pokémon list in RAM. Yellow's equivalent of RB's 8F. Safety: unsafe — ACE escapes EBP allocation. |
| Expanded Item Pack | GLITCH | YES | Accessing item positions beyond the 20-slot limit (50-slot PC via item-swap select glitch) enables arbitrary memory R/W. |
| Text Pointer Manipulation / Mart Pwner / LWA | GLITCH | YES | Unterminated glitch item name in a mart buy-screen overflows the text buffer and redirects control. Yellow-specific route. |
| LOL Glitch | GLITCH | YES | Unterminated-name glitch item in a mart overflows text pointer; redirects to arbitrary RAM. Yellow-compatible route exists. Same family as Mart Pwner. |
| Item slot $FF | BUG(critical) | Indirect | Reads a pointer from position 255 of the item list (past end of `wItems`); pointer may land in HRAM. Under DPMI writes land in `[EBP + 0xFF00..0xFFFF]` (I/O shadow) — usually harmless but can corrupt emulated HRAM. |

### Save / SRAM

| Name | Category | ACE | Description |
|------|----------|-----|-------------|
| SRAM Glitch / Partial Save | GLITCH | YES | 4-frame window after the Yes/No dialog closes lets you hard-reset with only party data written, merging old party into new save; gives 255-Pokémon party. Yellow's window is ~10 frames later than RB. |
| Pokémon Storage Cloning | GLITCH | No | Deposit/withdraw timing during save duplicates Pokémon via the storage system. |
| Save Data Carryover | GLITCH | No | Two-frame window when starting a new game retains the previous save's party without trading. |
| Hall of Fame Sprite Buffer Overflow | BUG(critical) | No | Decompressing a glitch Pokémon's sprite overflows the three SRAM sprite buffers into the Hall of Fame save region, corrupting it permanently. |
| Save Corruption (power-off timing) | BUG(critical) | Indirect | Precise power-off after Yes/No but before "Saving…" text produces a 255-Pokémon party save; if not exploited cleanly, corrupts the save file irreversibly. |
| Experience PC Withdrawing Softlock | BUG(critical) | No | Withdrawing a level-1 Medium-Slow Pokémon from the PC triggers an exp-underflow calculation that softlocks the game. |

### Text / Menu

| Name | Category | ACE | Description |
|------|----------|-----|-------------|
| Town Map Navigation Oversight | BUG(general) | No | Pressing up from Route 1 re-selects Route 1 instead of advancing; requires a double-press to escape. |
| Trade Evolution Glitch Move | BUG(general) | No | Trading a trade-evolution Pokémon to Gen II at the right level teaches a Gen II move; trading back makes it a glitch move in Gen I. |
| Full Box Glitch | — | No | **Fixed in Yellow.** Japanese RB only: the old-man catching demo with a full box looped infinitely. Corrected in Japanese Yellow and all localizations — do not emulate. |

### Audio

| Name | Category | ACE | Description |
|------|----------|-----|-------------|
| Nidorino Cry Mismatch | BUG(general) | No | Intro battle shows Nidorino's sprite but plays Nidorina's cry. Shared with RB. |
| Battle Draw Victory Fanfare | BUG(general) | No | The victory fanfare plays on a draw via Self-Destruct/Explosion instead of a draw sound. Shared. |
| Silent Indigo Plateau | BUG(general) | No | Music mutes permanently during the rival battle if an evolution occurs just before the last Pokémon is defeated. Shared. |

### Sprite / Graphics

| Name | Category | ACE | Description |
|------|----------|-----|-------------|
| Red's Transparent White Pixels | BUG(general) | No | White pixels in Red's title-screen sprite are transparent, revealing the Pokémon behind him through his body. Shared with RB. |
| NPC Over Grass (Viridian Forest) | BUG(general) | No | The Lass NPC sprite is positioned on a grass tile, breaking visual layering. Yellow-exclusive. |
| Chansey Facing South (Pokémon Zoo) | BUG(general) | No | Despite multi-directional sprites, Chansey at the Zoo always faces south. Yellow-exclusive. |
| Trade Menu Palette Glitch | — | No | **Fixed in Yellow.** RB trade menu colors shifted based on viewed Pokémon's HP/color. Corrected in Yellow — do not emulate. |

---

## ACE Paths Summary

The three primary ACE entry points in English Yellow, in order of ease:

1. **ws# #m# via Item Underflow** — bag item underflow → ws# #m# glitch item → jump to PC box list as code. Most documented; many step-by-step guides exist.
2. **SRAM Glitch** — partial-save merge with a crafted party → controlled execution path via save-data callback hooks. Less common but save-state friendly.
3. **Pikachu Off-Screen** — leave Pikachu off-screen, walk steps to write target bytes at D438+, trigger glitch sign as jump vector. Yellow-exclusive; hardest to set up but requires no item manipulation.

Under DPMI all three can in principle write outside the `[EBP + 0 .. EBP + 0x17FFF]` allocation if the forged address is large enough. See `docs/glitch_safety.md` for platform recommendations and the DPMI protection boundary analysis.

When translating routines that lie on any of these paths (item-list traversal, save-menu callbacks, follower-sprite step handler, map-sign activation, PC box access), add:

```nasm
; GLITCH: <ace-path-name> — ACE path node
; Safety: unsafe — ACE can escape EBP allocation; test only under DOSBox or 86Box
```

---

## Glitch Density by Engine Area

Ranked by number of documented bugs / glitches and DOS-port risk:

1. **Battle engine** (~25 bugs) — stat calc, damage formula, accuracy, status interactions, turn-order, move-specific effects, exp/leveling. Must be replicated faithfully for speedrun and exploit parity. Most are `BUG(general)`; critical ones (Super Glitch, Move 0x00, div-by-zero, Psywave loop) deserve `BUG(critical)` guards.
2. **Follower / Pikachu sprite** (~7 bugs, Yellow-exclusive) — Pikachu off-screen is the most powerful native Yellow ACE vector. Every step of the follower-movement handler is on the ACE path.
3. **Save / SRAM** (~5 bugs) — SRAM glitch, Hall of Fame overflow, PC-withdraw softlock. Save-routine call ordering must be replicated or consciously diverged from; timing matters.
4. **Item / inventory** (~5 bugs) — item underflow and ws# #m# are the primary ACE chain. Item-list traversal code needs `BUG_FIX_LEVEL` guards at the boundary checks.
5. **Text / menu** (~3 bugs) — Super Glitch and Move 0x00 live here; any name-copy routine translation must preserve the overflow behavior under `BUG_FIX_LEVEL 0`.
6. **Overworld / map** (~4 bugs) — OobLG and Glitch City are the main risks; map-index validation is the guard point.
7. **Audio / graphics** (~7 cosmetic bugs) — all `BUG(general)`, no ACE potential; low priority.

---

## Appendix: Yellow Predefined Functions (Predef Call Table)

Source: [glitchcity/predefined_funcs.md](glitchcity/predefined_funcs.md)

The Yellow predef dispatch table (`CallPredef`) is the mechanism ws# #m# and related ACE
glitches use to jump to attacker-controlled code. Knowing which indices are softlocks,
nonfunctional, or functional matters when placing `BUG_FIX_LEVEL` guards in the translated
`CallPredef` handler — a `/FIXCRIT` build could bounds-check the predef index and refuse
any call with an index that is a known garbage-execution path.

Key entries (hex):

| Index | Effect |
|-------|--------|
| 00 | Shows in-battle HUD for 5 frames |
| 07 | Instant Pokémon Center (HP/PP/status restored, no animation) |
| 0F | Initialises player data (party, items, badges only) |
| 18 | Initialises player data (full) |
| 2B | Saves game to SRAM0 |
| 2C | Battle start (functional) |
| 3C | Cut HM (functional) |
| 3F | Working save |
| 50 | Saves to SRAM2 |
| 52 | Force-loads save file (white screen; "data destroyed" if none exists) |
| 53 | Saves to SRAM1 |
| 55 | Enter Hall of Fame + credits (returns to prior state; does not reload graphics) |
| 61 | Elevator menu with invalid floors → glitched map on exit |
| 62 | If 0 Pokémon caught, gives item 0x00 |
| 09,0A,0D–0E,25,46,48,4F,57,63–81,83–8C,8E–8F,91,95–98,9A–9F,A1,A3–A5,A9,AD,B1–B5,B7–FF | **Softlock** |
| 01–03,05–06,08,0B–0C,10–17,19–1A,1C–1E,22–23,26–28,2A,2D,33,35,39–3A,3E,41–45,47,4B,4D,51,58–5A,5C–60,63 (partial),82,90,94,99,A0,A2,A6,A8,AA,AE | **Nonfunctional** |

Indices 63–FF are almost entirely softlocks or nonfunctional; any ACE payload that
calls into these regions hangs the game rather than executing arbitrary code. The
"useful" predef window for ACE purposes is roughly 00–62.
