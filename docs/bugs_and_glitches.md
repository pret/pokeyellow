# Bugs and Glitches

These are sections of the original Pokémon Yellow game code that clearly do not work as intended or only work in limited circumstances.

Many of the [documented fixes for Red](https://github.com/pret/pokered/wiki/%5BARCHIVED%5D-Bugs-and-Glitches#using-the-pok%C3%A9doll-on-the-ghost-marowak-can-allow-you-to-sequence-break) also apply to this codebase, the fixes called out here will attempt to be distinct to Yellow and in some cases Gen 2 where Yellow specific parts were reused.

Fixes are written in the `diff` format. If you've used Git before, this should look familiar:

```diff
 this is some code
-delete red - lines
+add green + lines
```


## Contents

- [Options menu code fails to clear joypad state on initialization](#options-menu-code-fails-to-clear-joypad-state-on-initialization)
- [Battle transitions fail to account for scripted battles](#battle-transitions-fail-to-account-for-scripted-battles)
- [`wPikachuFollowCommandBuffer` can overflow](#wpikachufollowcommandbuffer-can-overflow)


## Options menu code fails to clear joypad state on initialization

This bug (or feature!) results in all options being shifted left or right if the respective direction is pressed on the same frame the options menu is opened.
The bug also exists in pokegold and pokecrystal.

**Fix:** Update [engine/menus/options.asm](/engine/menus/options.asm)

```diff
  DisplayOptionMenu_:
+
+   call JoypadLowSensitivity
    call InitOptionsMenu
```


## Battle transitions fail to account for scripted battles

When Oak Catches Pikachu in the Pallet Town cutscenes you don't yet have any Pokemon in Party.
The Battle Transitions code has no error handling for this and reads wPartyMon1HP from wRivalName+6.
This means you can manipulate this first transition to be faster by choosing a default rival name or writing and deleting 6 characters in a custom rival name.
A similar series of bugs appears to exist in pokecrystal.

**Fix:** Update [engine/battle/battle_transitions.asm#L93](/engine/battle/battle_transitions.asm#L93)

```diff
GetBattleTransitionID_CompareLevels:
+   ld a, [wPartyCount]
+   cp 0
+   jr z, .highLevelEnemy
    ld hl, wPartyMon1HP
```


## `wPikachuFollowCommandBuffer` can overflow

AppendPikachuFollowCommandToBuffer doesn't have any length checking for the buffer of Pikachu commands.
This can be abused to write data into any address past d437, typically by putting pikachu to sleep in the Pewter Center with Jigglypuff.
While in this state, walking down writes 01, up 02, left 03, and right 04.
This bug is generally known as "Pikawalk."
A typical use for this would be to force the in game time to 255:59.

**Fix:** TBD in [engine/pikachu/pikachu_follow.asm#1165](/engine/pikachu/pikachu_follow.asm#1165)
