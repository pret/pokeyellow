# Source: https://glitchcity.wiki/wiki/Dry_underflow

Dry underflow glitch is a glitch (/wiki/Glitch) in Pokémon Red, Blue (/wiki/Pok%C3%A9mon_Red_and_Blue), and Yellow (/wiki/Pok%C3%A9mon_Yellow) and a major sub-glitch of having a x255 item stack. Similar to the item underflow glitch (event method) (/wiki/Item_underflow_glitch_(event_method)), it allows the player to get an expanded item pack (/wiki/Expanded_item_pack) by decreasing the item count while it is already 0, making it underflow to 255. It relies on an implementation quirk in an in-game mechanic which allows the player to merge two item stacks (e.g. Ultra Ball x1, Ultra Ball x20) of the same kind into one stack, by swapping them.

It was documented by luckytyphlosion (thread (https://archives.glitchcity.info/forums/board-107/thread-7175/page-0.html)). It is called "dry underflow" because, unlike the most common implementation of the event method (/wiki/Item_underflow_glitch_(event_method)), no fresh water is involved.

Since this method doesn't require the Saffron guards to be thirsty or a Fossil, it can be done either very early in the game (e.g. in the "Catch 'em All" speedrun), or very late (e.g. on a completed game). Also, it can be done with the PC items, allowing one to edit more RAM addresses that could otherwise only be manipulated with arbitrary code execution (/wiki/Arbitrary_code_execution) or map FE (/wiki/Map_254_(Yellow)).

## Contents
## 

- 1 Requirements (#Requirements)

- 2 Method (#Method)

- 3 Explanation (#Explanation)

- 4 Methods to obtain x255 stack (#Methods_to_obtain_x255_stack)

- 4.1 Using MissingNo. (#Using_MissingNo.)

- 4.2 Other methods (#Other_methods)

## Requirements
## 
You will need 2 different tossable items, and a stack of 255 items.

Refer to below (#Methods_to_obtain_x255_stack) for methods of obtaining a x255 item quantity slot for this glitch.

## Method
## 

- Order your items so that your 2 tossable items are in slots 1 and 2 and the item x255 is in slot 3.

- Toss everything below the item x255. (Item count = 3)

- Toss the top two items so you have three items x255. (Item count = 1)

- Toss 253 of the first item x255.

- Swap item 1 with item 2. (Item count = 0)

- Swap item 1 with item 2, again. (Item count = 255)
You can also do this with items below the third (and initial) 255 stack. You need to count how many items you have, then after step 3 toss the top item x255 the number of items you initially had -2.

## Explanation
## 
This method uses a few quirks of item swapping when the item count is desynchronized with the terminator of the item list (i.e. "the Cancel button") (/wiki/Item_stack_duplication_glitch).

When the item count is 1, the second item usually "acts like the Cancel button". However, while the A button checks the cursor position against the item count, the Select button checks whether the item under the cursor is actually the Cancel button (0xFF). Therefore it is allowed to switch an item that "acts like the cancel button" with another item.

The game also has a "max menu item" internal variable to help handle bounds and scrolling. For the item list, its value is usually 2 (the third item on screen); moving past the third item causes the menu to scroll instead. When the item count is 1 or 0, then the "max menu item" should change to 1 or 0 respectively, to make sure that the player cannot scroll past the Cancel button.

When using the swap function to combine two item stacks into one, and thus decreasing the item count, the game checks whether the new item count is 1, and if so changes the "max menu item" to 1. However, since it is normally not possible to decrease the item count to 0 by combining stacks, the game doesn't check for an item count of 0 and doesn't change the "max menu item", allowing the cursor to access the second slot.

Now, when the item count is 0, both slots "act as the Cancel button". However, as long as neither is actually the Cancel button, there is still nothing stopping the player from swapping the two stack and combining them. This decreases the item count once more, and achieves underflow.

## Methods to obtain x255 stack
## 

## Using MissingNo.
## 
1) Encounter a MissingNo. (/wiki/MissingNo.) (e.g. with old man glitch (/wiki/Old_man_glitch), Trainer escape glitch (/wiki/Trainer_escape_glitch), CoolTrainer♀ glitch (/wiki/-_(Generation_I_move))) to add 128 to the sixth item quantity (if less than 127).

For Pokémon Yellow:

Unstable MissingNo. will not freeze the game if encountered for the first time after a wiped save file with Up+Select+B and if no other glitch Pokémon sprite was viewed. More reliably, the double Trainer escape glitch with Level 80 Starmie can be used (video (https://www.youtube.com/watch?v=73fAlzIbi9k&amp;t)) to encounter a Fossil/Ghost MissingNo., which will not freeze the game. Alternatively though more difficult, the player may perform the Ditto glitch sub-glitch of the Trainer escape glitch by having Ditto Transform into a Pokémon with 182, 183, 184 Special.

2) Either encounter MissingNo. again or catch it with the sixth item quantity as x127 to get the x255 stack. Note this will not work when catching the MissingNo. if the item used to catch it was the sixth and a Poké Ball x127, therefore items like X Special are more desirable (also in this case, because X Special can be used for Celadon looping map glitch (/wiki/Celadon_looping_map_glitch))

## Other methods
## 

- See expanded items pack (/wiki/Expanded_items_pack)

- Item underflow glitch (event method) (/wiki/Item_underflow_glitch_(event_method))

Retrieved from "https://glitchcity.wiki/wiki/Dry_underflow_glitch?oldid=48293 (https://glitchcity.wiki/wiki/Dry_underflow_glitch?oldid=48293)"