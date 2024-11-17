# Changelog

## [0.0.1] - 2024-11-17
### Initial Build
#### Gameplay Changes
- Removed the requirement of trade evolutions for:
  - Alakazam: Evolves at level 36.
  - Golem: Evolves at level 40.
  - Machamp: Evolves at level 38.
  - Gengar: Evolves at level 36.
- Since Pikachu can't evolve, it now has Raichu's base stats.

#### Bug Fixes
- **Generation 1 Fixes**:
  - Fixed a bug where 100% accuracy moves had a small chance to miss.
  - Fixed a bug where 100% critical-hit moves had a small chance to fail to crit.
  - `Focus Energy` now quarters the crit chance instead of quadrupling it.
  - Fixed a bug where `Substitute` could KO the user (it now leaves the user with at least 1 HP).
  - Fixed a bug where move effectiveness was incorrectly displayed for dual-type Pokémon.
  - Fixed a bug where draining moves could hit even when a substitute was set up, including:
    - `Leech Life`
    - `Mega Drain`
    - `Dream Eater`
  - Fixed a bug where PP full restore didn't account for PP UPs when used.
  - Fixed a bug where `Struggle` didn't account for PP UP.
  - Fixed a bug where the `wavy screen` animation for `Psychic`, `Psywave`, and `Night Shade` didn't wiggle the top three lines of the screen.
  - Fixed a bug where invulnerability status was not cleared when a second-stage move failed due to confusion or paralysis.
  - Fixed a bug where healing moves would fail if the user's max HP was 255 or 511 higher than their current HP.
  - Fixed an underflow issue with switch-out messages.
  - Fixed a bug preventing Pokémon from attacking after curing `freeze`.
  - Fixed an issue where some trainers would always switch out Pokémon on low health rather than 25% of the time.
  - Fixed Blaine's AI where he would spam super potions.
  - Fixed a bug where all captured Pokémon with the transformed flag set were marked as `DITTO`.
  - Fixed a bug where Pokémon would be registered as "seen" in the Pokédex when entering a ghost battle.
  - Fixed a bug where stat boosts were removed when using stat-curing items.
  - Fixed an issue where the AI health bar would not correctly update after healing.

#### Notes
This release focuses on creating a clean baseline with foundational fixes and adjustments. Further bug fixes and improvements will follow in upcoming versions.

**MD5SUM**: `a045fe377f83aff15feaa53d75d48f46`
