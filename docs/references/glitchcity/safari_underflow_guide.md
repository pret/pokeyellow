# Source: https://glitchcity.wiki/wiki/Guides:Safari_Escape_Underflow_ACE_Setups_

This page serves as a repository for a method to quickly set up advanced ACE setups, starting from an existing save file. This method can be used for the French, German, Italian and Spanish releases of Red &amp; Blue. It is part of the TimoVM's Gen 1 ACE setups (/wiki/Guides:TimoVM%27s_gen_1_ACE_setups) set of guides.

The methods described here were heavily inspired by previous setups developed by Evie (Chickasaurus GL), as well as existing setups intended to be used for the Japanese releases. This guide in particular also uses a Glitch City RAM Manipulation setup developed by TheZZAZZGlitch.

 | (/wiki/File:Warning.png)

 | This guide has been deprecated. A faster and improved version of this guide can now be found at Guides:Safari Escape Underflow ACE Setups v2 (/wiki/Guides:Safari_Escape_Underflow_ACE_Setups_v2).

The contents of this guide are demonstrated in the following video, specifically for the Italian version of Red &amp; Blue:

 | 

 
 
 
 COME OTTENERE MEW SHINY COMPATIBILE CON LA BANCA POKéMON 😱✨ Metodo Nickname Writer
 Load video
 
 YouTube
 
 
 
 YouTube might collect personal data. Privacy Policy (https://www.youtube.com/howyoutubeworks/user-settings/privacy/)
 
 Continue
 Dismiss
 
 
 

 

 | YouTube video by Adam (https://www.youtube.com/watch?v=2Q-nKBT9hKI)

## Contents
## 

- 1 Overview (#Overview)

- 2 Preparation (#Preparation)

- 2.1 Step 1: Obtaining an x0 item stack (#Step_1:_Obtaining_an_x0_item_stack)

- 2.1.1 Setting up the Safari Escape Glitch (#Setting_up_the_Safari_Escape_Glitch)

- 2.1.2 Navigating the Glitch City (#Navigating_the_Glitch_City)

- 2.1.3 Using Glitch City Cut Abuse to obtain an x0 item stack (#Using_Glitch_City_Cut_Abuse_to_obtain_an_x0_item_stack)

- 2.2 Step 2: Getting inventory underflow (#Step_2:_Getting_inventory_underflow)

- 2.2.1 A quick note on the do's and don'ts of inventory underflow (#A_quick_note_on_the_do's_and_don'ts_of_inventory_underflow)

- 2.3 Step 3: Collecting items in Celadon City (#Step_3:_Collecting_items_in_Celadon_City)

- 2.3.1 Prerequisites (#Prerequisites)

- 2.3.2 Final preparations (#Final_preparations)

- 2.3.3 What to do if the pokémon was incorrectly nicknamed (#What_to_do_if_the_pokémon_was_incorrectly_nicknamed)

- 3 Nickname Writer Install (#Nickname_Writer_Install)

- 3.1 A note on using ACE (#A_note_on_using_ACE)

- 3.2 A note on unterminated name items in Eevee's room (#A_note_on_unterminated_name_items_in_Eevee's_room)

- 3.3 Step 4: Setting up Infinite Eevee mode (#Step_4:_Setting_up_Infinite_Eevee_mode)

- 3.4 Step 5: Setting up 4F to execute item codes (#Step_5:_Setting_up_4F_to_execute_item_codes)

- 3.5 Step 6: Setting up the Nickname Writer (#Step_6:_Setting_up_the_Nickname_Writer)

- 4 Clean-up (#Clean-up)

- 4.1 Step 7: Using the nickname writer (#Step_7:_Using_the_nickname_writer)

- 4.2 Step 8: Returning the game state to normal (#Step_8:_Returning_the_game_state_to_normal)

- 4.3 Additional applications of the Nickname Writer (#Additional_applications_of_the_Nickname_Writer)

- 5 Addendum: raw text transcripts of nickname codes (#Addendum:_raw_text_transcripts_of_nickname_codes)

- 5.1 Infinite Eevee Mode Nickname (#Infinite_Eevee_Mode_Nickname)

- 5.2 4F Bootstrap Nicknames (#4F_Bootstrap_Nicknames)

- 5.3 Nickname Writer (#Nickname_Writer)

- 6 Addendum: technical explanation of the setup (#Addendum:_technical_explanation_of_the_setup)

- 6.1 Nickname Converter Item Code (#Nickname_Converter_Item_Code)

- 6.1.1 Explanation (#Explanation)

- 6.1.2 Raw Assembly (#Raw_Assembly)

- 6.2 Infinite Eevee Nickname (#Infinite_Eevee_Nickname)

- 6.2.1 Explanation (#Explanation_2)

- 6.2.2 Raw Assembly (#Raw_Assembly_2)

- 6.3 4F Boostrap Nicknames (#4F_Boostrap_Nicknames)

- 6.3.1 Raw Assembly (#Raw_Assembly_3)

- 6.4 Using 4F (#Using_4F)

- 6.4.1 Explanation (#Explanation_3)

- 6.4.2 Raw Assembly (#Raw_Assembly_4)

- 6.5 Nickname Writer (#Nickname_Writer_2)

- 6.5.1 Explanation (#Explanation_4)

- 6.5.1.1 All languages (#All_languages)

- 6.5.2 Raw Assembly (#Raw_Assembly_5)

- 6.5.2.1 French (#French)

- 6.5.2.2 German (#German)

- 6.5.2.3 Italian Red (#Italian_Red)

- 6.5.2.4 Italian Blue (#Italian_Blue)

- 6.5.2.5 Spanish (#Spanish)

- 6.6 Cleanup Code (existing save) (#Cleanup_Code_(existing_save))

- 6.6.1 Explanation (#Explanation_5)

- 6.6.1.1 French (#French_2)

- 6.6.1.2 German (#German_2)

- 6.6.1.3 Italian (#Italian)

- 6.6.1.4 Spanish (#Spanish_2)

- 6.6.2 Raw Assembly (#Raw_Assembly_6)

- 6.6.2.1 French (#French_3)

- 6.6.2.2 German (#German_3)

- 6.6.2.3 Italian (#Italian_2)

- 6.6.2.4 Spanish (#Spanish_3)

## Overview
## 
This page is intended to guide you through the process of installing an Arbitrary Code Execution (ACE) setup on the French, German, Italian and Spanish releases of pokémon Red &amp; Blue. During this, we will be installing a small program that allows you to quickly and easily enter codes to trigger arbitrary effects, such as giving any pokémon or item.

This guide works both for cartridge and Virtual Console versions. In order to follow this guide, you must have progressed the game until you've reached Cinnabar Island. The full install procedure from that point onward should take around 60 minutes, depending on how fast you are at entering text.

In this guide, we will be using this to set up an ACE environment through the following process:

- Preparation, which focuses on setting up the required material for the setup.

- Nickname Writer Install, which focuses on installing a small, versatile program that can be used to trigger arbitrary effects.

- Clean-up, which focuses on using the Nickname Writer to clear away any and all side effects of the setup.
If you encounter any issues when going through this guide or would like to provide feedback, please contact TimoVM on the Glitch City Research Institute Discord (https://discord.gg/EA7jxJ6).

## Preparation
## 
This guide requires the following:

- Have at least 20300¥ to buy the required items.

- Have access to Fuchsia City and Cinnabar Island.

- Able to use Cut, Surf and Fly.
If you do not satisfy these requirements, you can instead choose to follow this link (/wiki/Guides:SRAM_Glitch_ACE_Setups) to an alternative guide that requires starting from a brand new save file.

## Step 1: Obtaining an x0 item stack
## 
Before we begin, we first need to make some preparations.

Set up your item bag as follows:

- At any poké mart, buy two stacks of Antidote x99 (press down to quickly set the quantity to buy to x99).

- Move both stacks of Antidote to item slots 1 and 2.

- Set up your bag as follows, tossing items as needed:

- Item slot 1: Antidote x96

- Item slot 2: Antidote x91

- Other item slots: not relevant for the setup

- (optional) It's recommended to also buy any kind of Repel, to prevent wild encounters at a later point.

- Make sure you have at least 500¥ left, to pay the admission fee for the Safari Zone.
Set up your party as follows:

- Your party must contain pokémon that know Cut, Fly/Teleport and Surf.

- Make sure that your party contains exactly 6 pokémon.
Set up the current active box as follows:

- Make sure the active box is completely empty

- Catch any pokémon, nickname it according to the language-specific images below, then store as the only pokémon within the active box

 | Nickname (FR/IT/SP)
 | Nickname (DE)

 | (/wiki/File:InfiniteEeveeINT.png)
 | (/wiki/File:IntiniteEeveeDE.png)

## Setting up the Safari Escape Glitch
## 
Fly to Fuchsia City and enter the Safari Zone:

- Once inside, go back down inside the entrance building. When the NPC asks if you want to end the Safari game early, answer "NO".

- Save and reset the game. Once loaded back in, go back down inside the entrance building and keep moving down. When the NPC asks if you want to start a new Safari game, answer "NO".

- In the background, the current Safari game is still running and will warp you back after 500 steps have passed. We want to be on route 20, east of Cinnabar Island, when the Safari game ends.

- Fly to Cinnabar Island and waste steps. Once you're close to the 500 step limit, use surf to enter route 20 (optionally, use Repels to avoid wild encounters). Make sure you are on route 20 when you get called back to the Safari Zone entrance building.

- Once the Safari game has ended, exit to the south. This will place you in a glitch city on route 20.

## Navigating the Glitch City
## 
WARNING: While navigating a glitch city won't result in a game crash, it is VERY easy to accidentally get stuck permanently. While you can always escape using Fly/Teleport, it's heavily recommended that you do not save your game until the guide clearly states that it's safe to do so. If you think you made a mistake, reset the game and try again.

We've now arrived in a glitch city, and need to navigate to a specific part.

- Move one step DOWN, then seven steps LEFT.

- Press UP to look upwards.

- Open and close the start menu twice. If everything goes well, you should be seeing nothing but water tiles while the start menu is open.

- Use Surf while you're looking upwards.

- Move two steps UP, then one step LEFT.

- Open and close the start menu twice. If everything goes well, you should see a tree that can be cut right in front of you.

## Using Glitch City Cut Abuse to obtain an x0 item stack
## 
The cut tree in front of us corresponds to item slot 1's quantity. By cutting it, we can alter the quantity from x96 to x110. 

Repeatedly perform the following actions:

- Cut the tile in front of you, which sets item slot 1's quantity to x110.

- Use SELECT to swap item slot 2 to item slot 1.

- Item slot 1 now holds Antidote x99. Toss 3 items from it to reach a quantity of x96, then close/reopen the start screen.
Repeat these steps until swapping both item stacks (during step 2) causes them to merge together into a single x0 stack. Once you've obtained the x0 item stack, Fly/Teleport to any location. You can now safely save the game.

## Step 2: Getting inventory underflow
## 
Now that we have an item stack with a quantity of x0, we can set up inventory underflow.

- Deposit all key items you currently have to the PC.

- Fill up the remainder of the bag with normal items (so that the bag is filled with a total of 20 item slots). All items within the bag will be lost by the end of the setup, but can easily be re-obtained using ACE at the end of the guide. Head to the Celadon Dept. Store if you need additional items to buy.

- Using SELECT, swap the x0 item to the 3rd item slot.

- Toss exactly one from the x0 item to obtain an x255 item stack.

- The first three item slots now look as follows:

- Slot 1: non-key item 1

- Slot 2: non-key item 2

- Slot 3: x255 item

- Toss/Sell all the items in slot 1. This will seemingly duplicate the x255 item stack:

- Slot 1: non-key item 2

- Slot 2: x255 item

- Slot 3: x255 item

- Toss/Sell all the items in slot 1. This will again seemingly duplicate the x255 item stack:

- Slot 1: x255 item

- Slot 2: x255 item

- Slot 3: x255 item

- Toss/Sell the entire item stack in slot one, repeat this a total of 17 times.

- If you've done everything correctly, you shouldn't be able to scroll the cursor past the 2nd item slot anymore.

- Toss/Sell 253 of the item in slot 1 (You can press DOWN to wrap the sell quantity around to 255):

- Slot 1: x2 item

- Slot 2: x255 item

- Slot 3: x255 item

- Using SELECT, swap the first item slot with the second item slot. This will cause the item stacks to merge:

- Slot 1: x1 item

- Slot 2: x255 item

- Using SELECT, swap the first item slot with the second item slot once more. This will cause the item stacks to merge and enable inventory underflow:

- Slot 1: x0 item
You should now be able to scroll past the CANCEL button and access items beyond. If this is the case, you can save the game and continue to the next step.

## A quick note on the do's and don'ts of inventory underflow
## 
Inventory underflow is one of the most powerful and versatile glitched states available in gen 1, allowing you to access memory beyond the normal limits of the item bag and manipulate them as if they're items. Because of that, care should be taken when handling it.

- Buying items will reset the inventory underflow state and turn the item bag back to normal. Because of this, we will not buy items, but instead use inventory underflow to obtain them in another way.

- Never try to swap two item stacks of the same type while inventory underflow is active. Doing this will shift all item stacks (in other words, all memory values the bag has access to), causing a substantial amount of memory corruption.

- Certain glitch items lack a proper string terminator. When you interact with them, either by pressing A or SELECT, these items can crash the game. On the Virtual Console releases, this could potentially of erasing your save. When you see any item with an unusually long glitched name, please make sure to not use either of these buttons to select them.

- In certain maps, such as Celadon City, opening the item bag or scrolling the item bag to display an unterminated name item can cause the game to seemingly freeze. You can get the game to safely resume by tapping B regularly until the bag's cursor becomes visible again.

## Step 3: Collecting items in Celadon City
## 
Now that we have inventory underflow, our main task will be to assemble a specific set of items.

## Prerequisites
## 
Fly to Celadon City, where we'll be collecting the required set of items. It is recommended to save the game at this point.

While standing in front of the Celadon City Pokémon Center, take 3 steps right, 5 steps up, 11 steps left and finally 3 steps up to reach the following spot.

 | Place to stand

 | (/wiki/File:ThunderstoneLocation.png)

While standing on this spot, open your item bag and keep scrolling down until you find a Thunderstone x0 item stack, located at item slot #35 as indicated by the below screenshot. We will use this spot to orient ourselves for the next section. If the item bag seems to freeze, tap B regularly until the item bag's cursor becomes visible again.

 | Slot #35

 | French
 | German

 | (/wiki/File:ThunderstoneMenuFR.png)
 | (/wiki/File:ThunderstoneMenuDE.png)

 | Italian
 | Spanish

 | (/wiki/File:ThunderstoneMenuIT.png)
 | (/wiki/File:ThunderstoneMenuSP.png)

By walking left or right, you can increment or decrement the item ID in slot #35. By walking up and down we can alternate between an item quantity of x0 and x1. We can safely swap the contents of item slot #35 with other item slots, as long as we use Fly afterwards to restore the map back to normal. We can use this to collect all the items we need for the item code. slot #33 will always contain a bicycle while walking in Celadon City, you can safely use this to speed up the process. 

For every item in the following table, head to the Thunderstone x0 spot, follow the instructions to obtain an item stack, then Fly back to Celadon and head back to the same spot to obtain the next item stack. It is heavily recommended to save after every time you fly back to the Celadon City Pokémon Center.

During the entire process, make sure to not swap two item stacks that have the same item. This will cause both item stacks to merge, resulting in glitchy side effects. When this happens, you can reset the game to restore the game back to normal.

 | Item location
 | Item ID
 | Item quantity
 | How to acquire

 | (/wiki/File:MaxPotionLocation.png)
 | Max Potion
 | x111
 | At the Thunderstone spot, walk 16 steps to the left to get Max Potion x0. Toss 99 from the stack, then toss another 46 from the stack, then swap to slot #7.

 | (/wiki/File:TM14Location.png)
 | TM14
 | x213
 | At the Thunderstone spot, swap the Thunderstone with the TM23 x64 stack 4 slots below, then toss 63 TM23s. Walk 1 step up and 9 steps left to get TM14 x0. Toss 43 from the stack, then swap to slot #8.

 | (/wiki/File:ThunderstoneLocation.png)
 | Thunderstone
 | x11
 | Go to the Thunderstone spot to get Thunderstone x0. Toss 245 from the stack, then swap to slot #9.

 | (/wiki/File:TM22Location.png)
 | TM22
 | x42
 | At the Thunderstone spot, swap the Thunderstone with the TM23 x64 stack 4 slots below, then toss 63 TM23s. Walk 1 step up and 1 step left to get TM22 x0. Toss 214 from the stack, then swap to slot #10.

 | (/wiki/File:GreatBallLocation.png)
 | Great Ball
 | x135
 | At the Thunderstone spot, walk 30 steps to the left to get Great Ball x0. Toss 99 from the stack, then toss an additional 22 from the stack to reach x135, then swap to slot #11.

 | (/wiki/File:AntidoteLocation.png)
 | Antidote
 | x48
 | At the Thunderstone spot, walk 22 steps to the left to get Antidote x0. Toss 208 from the stack, then swap to slot #12.

 | (/wiki/File:PokeBallLocation.png)
 | Poké Ball
 | x134
 | At the Thunderstone spot, walk 29 steps to the left to get Poké Ball x0. Toss 99 from the stack, then toss an additional 23 from the stack to reach x134, then swap to slot #13.

 | (/wiki/File:HyperPotionLocation.png)
 | Hyper Potion
 | x44
 | At the Thunderstone spot, walk 15 steps to the left to get Hyper Potion x0. Toss 212 from the stack, then swap to slot #14.

 | (/wiki/File:SuperPotionLocation.png)
 | Super Potion
 | x32
 | At the Thunderstone spot, walk 14 steps to the left to get Super Potion x0. Toss 224 from the stack, then swap to slot #15.

 | (/wiki/File:TM44Location.png)
 | TM44
 | x201
 | At the Thunderstone spot, swap the Thunderstone with the TM23 x64 stack 4 slots below, then toss 63 TM23s. Walk 2 steps down, 12 steps right, 5 steps down and then 9 steps right to get TM44 x0. Toss 55 from the stack, then swap to slot #16.

 | (/wiki/File:LeafStoneLocation.png)
 | Leaf Stone
 | x243
 | At the Thunderstone spot, walk 14 steps to the right to get Leaf Stone x0. Toss 13 from the stack, then swap to slot #17.

After flying back to Celadon city, we will verify if all items have been successfully collected.

## Final preparations
## 

- Before opening the bag, walk 5 steps to the right from the entrance of the pokémon center. This will ensure that we can open the item bag without issues.

- Next, make sure your item bag looks as follows:

 | Item slot
 | Item ID
 | Item Quantity

 | Slot #7
 | Max Potion
 | x111

 | Slot #8
 | TM14
 | x213

 | Slot #9
 | Thunderstone
 | x11

 | Slot #10
 | TM22
 | x42

 | Slot #11
 | Great Ball
 | x135

 | Slot #12
 | Antidote
 | x48

 | Slot #13
 | Poké Ball
 | x134

 | Slot #14
 | Hyper Potion
 | x44

 | Slot #15
 | Super Potion
 | x32

 | Slot #16
 | TM44
 | x201

 | Slot #17
 | Leaf Stone
 | x243

- Verify that the current box only contains one pokémon. This pokémon's nickname must match the language-specific images shown below.

 | Nickname (FR/IT/SP)
 | Nickname (DE)

 | (/wiki/File:InfiniteEeveeINT.png)
 | (/wiki/File:IntiniteEeveeDE.png)

- Make sure that your current party contains 6 pokémon.

- Head to the Celadon Mansion penthouse, which is the room where you can pick up the gift Eevee. Make sure to save before continuing.

## What to do if the pokémon was incorrectly nicknamed
## 
In case the pokémon's nickname is incorrect, you can simply release it and head to route 7 to catch another pokémon. You can use the Great Ball stack in slot 10 for this, as long as you make sure to reaquire the Great Ball stack afterwards so that you can set it to its correct quantity.

## Nickname Writer Install
## 
Now that we have an item code ready, we'll finally be using it to set up an ACE environment. Placing a specific item stack in item slot #41 allows us to activate ACE, which will execute the item code and trigger effects based on the nicknames of the pokémon in the active box.

We will be using this in three stages:

- First we will alter a value in memory so that we can continuously keep picking up Eevee's while we remain on the same map.

- Next we will give ourselves a glitch item that, when used, will execute ACE starting from the sixth item slot. This allows us to execute ACE outside of the limits of Map Script ACE.

- Finally we will set up a short program that uses the nickname screen to quickly and easily write programs of arbitrary size, effectively giving us a flexible ACE environment.
It is recommended to not save the game until the Nickname Writer program is installed. 

## A note on using ACE
## 
The first generation of pokémon games, especially the Virtual console releases, are vulnerable to certain crashes wiping the save file. As a protective measure, make sure to open the trainer card to display Red's sprite on screen right before using ACE of any kind. Loading any sprite switches the current active sram bank, offering a measure of safety against game crashes.

## A note on unterminated name items in Eevee's room
## 
Within this room, no safe spots exist that allow unterminated name items to be safely handled. Please make sure to not press a or select on unterminated items while in this room. If the item bag seems to freeze while scrolling, regularly tap B until the cursor becomes unstuck.

## Step 4: Setting up Infinite Eevee mode
## 
First, we'll use Map Script ACE to make sure that we can pick up as many Eevee as we want. For this purpose, we've already stored a nicknamed pokémon in the current active box.

- Open the item bag. Swap the Leaf Stone x243 with the contents of item slot #41, which is highlighted on the below screenshots. This will activate Map Script ACE

- Close the start menu. Until we next leave the room, Eevee's poké ball will not disappear when it is picked up. If you've already picked up Eevee prior to this, its poké ball will reappear as well.

- Open the item bag. Swap the original contents of item slot #41 with the Leaf Stone x243. This will deactivate Map Script ACE.

 | Slot #41

 | French
 | German

 | (/wiki/File:DireHitMenuFR.png)
 | (/wiki/File:DireHitMenuDE.png)

 | Italian
 | Spanish

 | (/wiki/File:DireHitMenuIT.png)
 | (/wiki/File:DireHitMenuSP.png)

## Step 5: Setting up 4F to execute item codes
## 
Next, we'll be entering a list of three nicknames that gives us the glitch item named "4F" and the necessary bootstrap. This ensures that using 4F will activate the item code.

 | List of nicknames (FR/IT/SP)
 | List of nicknames (DE)

 | (/wiki/File:-gmBootstrapINT.png)
 | (/wiki/File:-gmBootstrapDE.png)

- Pick up Eevees and enter the nicknames in the above screenshot one by one. The nicknames from this list needs to be entered in this exact order from the top to the bottom.

- Open the item bag. Swap the Leaf Stone x243 with the contents of item slot #41, which is highlighted on the below screenshots. This will activate Map Script ACE

- Close the start menu. If everything went all right, the CANCEL buttons in the first three slots have been removed and the first item was replaced with a glitch item named "4F"

- Open the item bag. Swap the original contents of item slot #41 with the Leaf Stone x243. This will deactivate Map Script ACE.

- Finally, verify that 4F works by using it. If the game doesn't crash, 4F was set up correctly.
Note: due to item layouts and translation differences between languages, 4F goes by different item names across multiple languages. 

- French: 3EME ETAGE

- German: S3

- Italian: 3°P

- Spanish: P3

 | Slot #41

 | French
 | German

 | (/wiki/File:DireHitMenuFR.png)
 | (/wiki/File:DireHitMenuDE.png)

 | Italian
 | Spanish

 | (/wiki/File:DireHitMenuIT.png)
 | (/wiki/File:DireHitMenuSP.png)

## Step 6: Setting up the Nickname Writer
## 

- Finally, we'll be entering a list of thirteen nicknames. This will form a small program that, when activated using 4F, will allow us to easily write large amount of arbitrary code using the nickname screen. For the Italian version, please ensure to pick the correct list of codes for your language.

 | French
 | German
 | Italian (Red)
 | Italian (Blue)
 | Spanish

 | (/wiki/File:NicknameWriterFR.png)

 | (/wiki/File:NicknameWriterDE.png)

 | (/wiki/File:NicknameWriterIT.png)

 | (/wiki/File:NicknameWriterITBlue.png)

 | (/wiki/File:NicknameWriterSP.png)

- Pick up Eevees and enter the nicknames in the above screenshot one by one. The nicknames from this list needs to be entered in this exact order from the top to the bottom.

- Once all nicknames have been entered, look at your trainer card, then use 4F. This should open a screen in which you're asked to enter a pokémon's nickname

- For now, press START to end writing the nickname. This should display the main menu, a number should be written on screen.

- Press SELECT to exit the Nickname Writer safely.

- It is now safe to save the game.

## Clean-up
## 
Congratulations! The fact that you've made it this far means you've correctly set up the Nickname Writer. In this section we're going to enter an additional six nicknames to achieve the following effects:

- Alter 4F's bootstrap, so that the item code is no longer required for the Nickname Writer to function.

- Remove the side-effects of the setup, such as removing the inventory underflow effect and clearing out the current active box.
Along the way we'll also show how to use the Nickname Writer.

## Step 7: Using the nickname writer
## 
From this point onward, whenever you use the ACE item, you should be able to open the nickname writer. Please make sure to keep note of the following:

- Since the Nickname Writer works independently of the current active box, you can change the current active box however much you like.

- When writing data, the Nickname Writer will overwrite enemy party data. While this does not have any effect outside of battle, it is recommended to not use the Nickname Writer during trainer battles.
The program works as follows:

- The program opens the nickname screen and asks you to input a nickname.

- This nickname then gets converted to a sequence of five bytes.

- All five bytes are written starting from the starting location

- The program displays a glitched overworld view, along with a checksum (sum of all written byte values) towards the top right of the screen to confirm that you correctly entered the code. If the printed checksum doesn't match the expected checksum, you made a mistake entering a code. The glitched overworld view is temporary and will not affect your game.

- Afterwards, it waits for the user to decide what to do.
During the input phase, the controls are as follows:

- Press A for the program to ask for a new nickname and convert that to the next five bytes to be written.

- Press B to go back one byte at a time. The checksum will automatically be overwritten by the value written at the current selected address, giving you a measure of how far back you're going. If a name is incorrect, press B five times before pressing A, entering the nickname again to overwrite the incorrect nickname.

- Press START to immediately start executing the newly written program. Only do this when you've finished writing everything.

- Press SELECT to safely quit the Nickname Writer, without executing the newly written code.

 | Write mode
 | Input mode

 | (/wiki/File:RB_Name_writer_write_mode.png)

 | (/wiki/File:RB_Name_writer_input_mode.png)

 | Enter nickname, press select to switch between uppercase/lowercase
 | Checksum ("4E", in this case) is displayed as a hex value on the top right quadrant

## Step 8: Returning the game state to normal
## 
At this point, there are certain side effects that have been introduced by the setup:

- By picking up Eevee, we have flagged its poké ball as "obtained"

- The current active box is filled with nicknamed Eevee's

- The item pack currently has 255 items

- The item code is currently still required to run the Nickname Writer
We will be removing all these side effect using the Nickname Writer. The nicknames we need to enter will be generated by the Nickname Converter webtool (https://timovm.github.io/NicknameConverter/). Simply open the link, copy paste one of the two codes below into the converter, then press the "Run" button to display the list of nicknames. Please make sure that you use the Nickname Writer within a poké center, to ensure that the checksums are displayed properly. 

When using the Nickname Writer, the generated nicknames need to be entered from top to bottom.

Please ensure that you pick the code that suits your language.

Codes to be used with the Nickname Converter webtool (https://timovm.github.io/NicknameConverter/)

 | Language
 | Code

 | French

 | 21 B3 D5 CB AE
AF 21 85 DA 22
3D 22 AF EA 22
D3 21 66 DA 36
6F 23 36 D6 01
01 59 C3 4B 3E

 | German

 | 21 B3 D5 CB AE
AF 21 85 DA 22
3D 22 AF EA 22
D3 21 66 DA 36
6F 23 36 D6 01
01 59 C3 48 3E

 | Italian

 | 21 B3 D5 CB AE
AF 21 85 DA 22
3D 22 AF EA 22
D3 21 66 DA 36
6F 23 36 D6 01
01 59 C3 46 3E

 | Spanish

 | 21 B3 D5 CB AE
AF 21 85 DA 22
3D 22 AF EA 22
D3 21 66 DA 36
6F 23 36 D6 01
01 59 C3 4D 3E

Once all nicknames have been entered and verified, you can press START during input mode to execute the code.

This will activate the following effects:

- Reset the state of Eevee's poké ball, allowing it to be picked up again at a later point

- Empty the current active box

- Resets the bag, removing all items aside from 4F and removing the inventory underflow state

- Rewire 4F so that it can activate the Nickname Writer independently of the item code
From this point onward, you can exit the penthouse and continue the story as normal.

## Additional applications of the Nickname Writer
## 
The Nickname Writer allows you to easily write and execute arbitrary payloads. You can either make and execute your own codes, or head to the Nickname Writer codes (/wiki/Guides:Nickname_Writer_Codes) page. This page contains a collection of assembly for nickname codes that can be used for a variety of common purposes such as editing pokémon and items, editing player stats, resetting legendaries etc..

Nickname Writer Codes (/wiki/Guides:Nickname_Writer_Codes)

## Addendum: raw text transcripts of nickname codes
## 
These are provided as an alternative in case images fail to load.

## Infinite Eevee Mode Nickname
## 

 | Nickname (FR/IT/SP)
 | Nickname (DE)

 | C l l U )&nbsp;;&nbsp;:&nbsp;; W&nbsp;;
 | A p o O O x ) ] Y Z

## 4F Bootstrap Nicknames
## 

 | List of nicknames (FR/IT/SP)
 | List of nicknames (DE)

 | g . [ / ] , k Mn * Pk
* (&nbsp;;&nbsp;!&nbsp;? ) [ [ ] ,
a Pk z r R r k Mn Pk X

 | ü u v ü ö k ü m M l
Mn y p ä ä Pk [ [ ] ,
a Pk z r J Ö Ö u u * 

## Nickname Writer
## 

 | French
 | German
 | Italian (Red)
 | Italian (Blue)
 | Spanish

 | a b v v ) l l C d d
j&nbsp;? ) V t v v v l Mn
q p y y ] z y p g F
Mn K j&nbsp;? t K K b c c
R j j m v w w P P p
I * S j j K S *&nbsp;: ♀
P x w v v W M m m w
A B r q x Pk z g g h
i z , [ o w o x w x
( ) ) ) ) , , ] ] .
j&nbsp;! U&nbsp;?&nbsp;? u w v v&nbsp;?
w v V V&nbsp;! X P p p Pk
r p O [ [&nbsp;:&nbsp;:&nbsp;;&nbsp;:&nbsp;;

 | a b v v l L L Ü U Ö
ä s R j t v v v Ü u
q p y y o ) ] Pk ) )
ö ä ä s t K K b c c
R j j m v w w P P p
l l M v V v v l u ü
P x w v v W M m m w
A B Ä S ü ü Ü U u L
T - - Ä Ä S Z Pk z r
Q p ) ) ) , , ] ] .
Ä z y [ ♀ W w v v&nbsp;?
a Pk ä ü Ö - S j ö u
r p O [ [&nbsp;:&nbsp;;&nbsp;:&nbsp;;

 | a b v v ) l l C d d
j&nbsp;? ) V t v v v l Mn
q p y y ] z y p g F
t - j&nbsp;? t K K b c c
R j j m v w w P P p
l l M v V v v l&nbsp;: ♀
P x w v v W M m m w
A B r q x Pk z g g h
i z , [ o w o x w x
( ) ) ) ) , , ] ] .
j&nbsp;! U&nbsp;?&nbsp;? u w v v&nbsp;?
a Pk . ] y ♀ ♂ ♂ k&nbsp;?
r p O [ [&nbsp;:&nbsp;:&nbsp;;&nbsp;:&nbsp;;

 | a b v v ) l l C d d
j&nbsp;? ) V t v v v l Mn
q p y y ] z y p g F
t - j&nbsp;? t K K b c c
R j j m v w w P P p
l l M v V v v l&nbsp;: ♀
P x w v v W M m m w
A B r q x Pk z g g h
i z , [ o w o x w x
( ) ) ) ) , , ] ] .
j&nbsp;! U&nbsp;?&nbsp;? u w v v&nbsp;?
a Pk . [ y ♀ ♂ ♂ k&nbsp;?
r p O [ [&nbsp;:&nbsp;:&nbsp;;&nbsp;:&nbsp;;

 | a b v v ) l l C d d
j&nbsp;? ) V t v v v l Mn
q p y y ] z y p g F
- K j&nbsp;? t K K b c c
R j j m v w w P P p
l l M v V v v l&nbsp;: ♀
P x w v v W M m m w
A B r q x Pk z g g h
i z , [ o w o x w x
( ) ) ) ) , , ] ] .
j&nbsp;! U&nbsp;?&nbsp;? u w v v&nbsp;?
a Pk . ] y ♀ ♂ ♂ n&nbsp;!
r p O [ [&nbsp;:&nbsp;:&nbsp;;&nbsp;:&nbsp;;

## Addendum: technical explanation of the setup
## 

## Nickname Converter Item Code
## 

## Explanation
## 
The item code itself consists of two components. The first 10 items are used to write a program that takes text characters from the nicknames of characters currently within the active box, converts them, then writes the resulting values to unused memory starting from $D66A. 

Pairs of text characters are converted to single values through a [(2a + b)%256] formula, where a is the value of the first character and b the value of the second. text terminators are skipped, the code will stop and execute the newly written code once it either reads a $00 value or if values are being read past $DEFF.

11 6F D6 ld de, UNUSED_MEMORY ; Memory between $D66F and $D6F4 goes unused
D5 push de
21 0B DE ld hl, wBoxNicks
.loop
2A ldi a, (hl)
03 inc bc ; Filler, no effect on flags
87 add a
0B dec bc ; Filler, compensates previous inc bc, no effect on flags
30 04 jp nc, .notChar ; Aside from space (should not be used), "add a" will only give nc if value read is not a text char
86 add a, (hl)
12 ld (de), a
2C inc l ; Affects z flag
13 inc de
.notChar
20 F4 jp nz, .loop ; Loop unless l rolled over to $00 or value read was $00
C9 ret ; Due to previous push de, this ret will cause execution to resume from $D66A onward, immediately running the newly written code

The last item, the Leaf Stone, simply form a pointer to $F32F. Due to echo RAM this address is equivalent to $D32F, which correspond to item #7's item ID, the start of the item code. By replacing the map script pointer with this item, we can redirect the map script routine to execute the item code instead. This routine is executed on every frame, as long as the start menu isn't open.

## Raw Assembly
## 
11 6F Max Potion x111
D6 D5 TM14 x213
21 0B Thunderstone x11
DA 2A TM22 x42
03 87 Great Ball x135
0B 30 Antidote x48
04 86 Poké Ball x134
12 2C Hyper Potion x44
13 20 Super Potion x32
F4 C9 TM44 x201

2F F3 Leaf Stone x243

## Infinite Eevee Nickname
## 

## Explanation
## 
The Infinite Eevee mode nickname writes $00 to the lower byte of wMissableObjectList, causing a misalignment in how the game applies NPC disappearance, causing Eevee's pokéball to stay permanently visible until the game is reset or the player leaves the Celadon Mansion penthouse.

AF xor a ; a = $00
EA D3 D5 ld (wMissableObjectList), a ; Misaligns which objects are made invisible
C9 ret

## Raw Assembly
## 
AF EA D3 D5 C9

## 4F Boostrap Nicknames
## 
This set of nicknames, when converted, will modify item #1's ID to be 4F and writes a bootstrap so that using it will lead to execution of the item code from $D32F onward. It requires the presence of the Infinite Eevee Mode Nickname (see previous section) to properly return.

21 23 D3 ld hl, wBagItems ; item #1's ID
36 59 ld (hl), $59 ; 4F's item ID
7C ld a, h ; a = $D3 
21 67 DA ld hl, 4F_Execution_Pointer +2
32 ldd (hl), a
3E 2F ld a, $2F
22 ldi (hl), a
36 C3 ld (hl), $C3
; The contents of the first nickname (see previous section) are written right after this, ensuring safe return.

## Raw Assembly
## 
21 23 D3 36 59
7C 21 67 DA 32
3E 2F 32 36 C3

## Using 4F
## 

## Explanation
## 
Using 4F, an invalid item, will cause the game to index the item effects table out of bounds, leading to an invalid execution pointer. For 4F, this causes the game to execute code from $FA65 onward. Due to echo RAM, this address is equivalent to $DA65. Thanks to the bootstrap that was applied earlier, this will then cause the game to jump to $D32F, corresponding to the start of the item code.

C3 2F D3 jp ITEM_7_ID

## Raw Assembly
## 
C3 2F D3

## Nickname Writer
## 

## Explanation
## 
The Nickname Writer is a small program that, using nicknames as input, is able to write arbitrary amounts of custom code relatively quickly. It first request a nickname as input, then converts that data to custom code, then displays a checksum of the written data and finally asks the player to provide additional input.

The value of the checksum is calculated by [($80 + the sum of all written values)%256]. Custom code is buffered and executed within enemy party data. Due to how it calls DisplayNameRaterScreen, it will also nickname a party pokémon corresponding to the item slot that 4F currently occupies.

## All languages
## 
SECTION "Main", ROM0
Main:
 LOAD "NickWriter", WRAMX[wRoute18Gate1FCurScript + 0x01]
NickWriter:
 ld de, wEnemyMon1HPExp&nbsp;; location written to
 push de
.newMail
 push de
 ld hl, AskName + 0x39&nbsp;; Prepares data and calls DisplayNamingScreen
 call RemovePokemon + 0x03&nbsp;; sets b to 01, then jumps to Bankswitch, calling b:hl
 ld c, 0x80&nbsp;; Ensure checksum consistency
 ld hl, wStringBuffer&nbsp;; Address where new name gets written to
 pop de&nbsp;; Continue writing from last saved de
.newChar
 ld a, (hli)
 add a
 jp nc, .terminator&nbsp;; If blank space as first character of pair, only terminator $50 will result in a nc result
 add a, (hl)
 ld (de), a
 inc de
 inc hl
 add a, c&nbsp;; Current checksum total is buffered in c
 ld (de), a
 ld c, a
 jp .newChar
.terminator
push de
 ld hl, wTileMap + 0x60&nbsp;; Corresponds to screen tile
 ld c, 0x01&nbsp;; How many bytes printed as numbers?
 call PrintBCDNumber.loop
.numLoop
 dec l
 set 7, (hl)
 jp nz, .numLoop&nbsp;; Repeat until hl == 0xC400
.inputLoop
 call JoypadLowSensitivity&nbsp;; Halt execution until frame has passed, get joypad status and store result in hJoy5
 ld a, (hJoy5)
 and 0x0F&nbsp;; Set z flag if A, B, START, SELECT not pressed
 jp z, .inputLoop
 rra&nbsp;; Is A pressed? If yes, set c flag
 pop de
 jr c, .newMail
 dec de
 rra&nbsp;; Is B pressed? If yes, set c flag
 jr c, .terminator
 rra&nbsp;; Is SELECT pressed? If yes, set c flag
 pop hl&nbsp;; pop starting address to hl
 ret c&nbsp;; If SELECT pressed, simply return to normal operations
 jp hl&nbsp;; If START pressed, jump to hl to execute newly written code
.end

## Raw Assembly
## 

## French
## 
 11 BA D8 D5 D5 
 21 BF 65 CD 3F
 39 0E 80 21 50
 CF D1 2A 87 30
 09 86 12 13 23
 81 12 4F 18 F3
 D5 21 00 C4 0E
 01 CD DC 15 2D
 CB FE 20 FB CD
 4E 38 F0 B5 E6
 0F 28 F7 1F D1
 38 CB 1B 1F 38
 E1 1F E1 D8 E9

## German
## 
 11 BA D8 D5 D5 
 21 4B 65 CD 3C
 39 0E 80 21 50
 CF D1 2A 87 30
 09 86 12 13 23
 81 12 4F 18 F3
 D5 21 00 C4 0E
 01 CD DF 15 2D
 CB FE 20 FB CD
 4B 38 F0 B5 E6
 0F 28 F7 1F D1
 38 CB 1B 1F 38
 E1 1F E1 D8 E9

## Italian Red
## 
 11 BA D8 D5 D5 
 21 83 65 CD 3A
 39 0E 80 21 50
 CF D1 2A 87 30
 09 86 12 13 23
 81 12 4F 18 F3
 D5 21 00 C4 0E
 01 CD DF 15 2D
 CB FE 20 FB CD
 49 38 F0 B5 E6
 0F 28 F7 1F D1
 38 CB 1B 1F 38
 E1 1F E1 D8 E9

## Italian Blue
## 
 11 BA D8 D5 D5 
 21 82 65 CD 3A
 39 0E 80 21 50
 CF D1 2A 87 30
 09 86 12 13 23
 81 12 4F 18 F3
 D5 21 00 C4 0E
 01 CD DF 15 2D
 CB FE 20 FB CD
 49 38 F0 B5 E6
 0F 28 F7 1F D1
 38 CB 1B 1F 38
 E1 1F E1 D8 E9

## Spanish
## 
 11 BA D8 D5 D5 
 21 83 65 CD 41
 39 0E 80 21 50
 CF D1 2A 87 30
 09 86 12 13 23
 81 12 4F 18 F3
 D5 21 00 C4 0E
 01 CD DF 15 2D
 CB FE 20 FB CD
 50 38 F0 B5 E6
 0F 28 F7 1F D1
 38 CB 1B 1F 38
 E1 1F E1 D8 E9

## Cleanup Code (existing save)
## 

## Explanation
## 
This code cleans up every negative side effect brought on by the setup and allows the player to continue the story as intended, with the exception of 4F being added to the item bag, enabling use of the Nickname Writer.

The negative effects targeted are:

- By picking up Eevee, we have flagged its poké ball as "obtained"

- The current active box is filled with nicknamed Eevees

- The item pack currently has 255 items

- The item code is currently still required to run the Nickname Writer
Since existing saves do not have to set up SRAM glitch, there are a lot less side effects that need to be addressed by the cleanup code.

## French
## 
21 B3 D5 ld hl, $D5B3 ; Part of wMissableObjectFlags
CB AE res 5, (hl) ; Reenable Eevee's poké ball
AF xor a ; a = $00
21 85 DA ld hl, wBoxCount
22 ldi (hl), a ; Set amount of pokémon in box to 0
3D dec a ; a = $FF
22 ldi (hl), a ; Add proper terminator to wBoxSpecies
AF xor a ; a = $00
EA 22 D3 ld (wNumBagItems), a ; Set amount of items to 0
21 65 DA ld hl, $DA65 ; Part of 4F bootstrap
36 6F ld (hl), $6F
23 inc hl
36 D6 ld (hl), $D6 ; 4F now redirects directly to Nickname Writer
01 01 59 ld bc, $5901
C3 4B 3E jp GiveItem ; Gives c amount of b item, giving 1 copy of 4F.

## German
## 
21 B3 D5 ld hl, $D5B3 ; Part of wMissableObjectFlags
CB AE res 5, (hl) ; Reenable Eevee's poké ball
AF xor a ; a = $00
21 85 DA ld hl, wBoxCount
22 ldi (hl), a ; Set amount of pokémon in box to 0
3D dec a ; a = $FF
22 ldi (hl), a ; Add proper terminator to wBoxSpecies
AF xor a ; a = $00
EA 22 D3 ld (wNumBagItems), a ; Set amount of items to 0
21 65 DA ld hl, $DA65 ; Part of 4F bootstrap
36 6F ld (hl), $6F
23 inc hl
36 D6 ld (hl), $D6 ; 4F now redirects directly to Nickname Writer
01 01 59 ld bc, $5901
C3 48 3E jp GiveItem ; Gives c amount of b item, giving 1 copy of 4F.

## Italian
## 
21 B3 D5 ld hl, $D5B3 ; Part of wMissableObjectFlags
CB AE res 5, (hl) ; Reenable Eevee's poké ball
AF xor a ; a = $00
21 85 DA ld hl, wBoxCount
22 ldi (hl), a ; Set amount of pokémon in box to 0
3D dec a ; a = $FF
22 ldi (hl), a ; Add proper terminator to wBoxSpecies
AF xor a ; a = $00
EA 22 D3 ld (wNumBagItems), a ; Set amount of items to 0
21 65 DA ld hl, $DA65 ; Part of 4F bootstrap
36 6F ld (hl), $6F
23 inc hl
36 D6 ld (hl), $D6 ; 4F now redirects directly to Nickname Writer
01 01 59 ld bc, $5901
C3 46 3E jp GiveItem ; Gives c amount of b item, giving 1 copy of 4F.

## Spanish
## 
21 B3 D5 ld hl, $D5B3 ; Part of wMissableObjectFlags
CB AE res 5, (hl) ; Reenable Eevee's poké ball
AF xor a ; a = $00
21 85 DA ld hl, wBoxCount
22 ldi (hl), a ; Set amount of pokémon in box to 0
3D dec a ; a = $FF
22 ldi (hl), a ; Add proper terminator to wBoxSpecies
AF xor a ; a = $00
EA 22 D3 ld (wNumBagItems), a ; Set amount of items to 0
21 65 DA ld hl, $DA65 ; Part of 4F bootstrap
36 6F ld (hl), $6F
23 inc hl
36 D6 ld (hl), $D6 ; 4F now redirects directly to Nickname Writer
01 01 59 ld bc, $5901
C3 4D 3E jp GiveItem ; Gives c amount of b item, giving 1 copy of 4F.

## Raw Assembly
## 

## French
## 
21 B3 D5 CB AE
AF 21 85 DA 22
3D 22 AF EA 22
D3 21 66 DA 36
6F 23 36 D6 01
01 59 C3 4B 3E

## German
## 
21 B3 D5 CB AE
AF 21 85 DA 22
3D 22 AF EA 22
D3 21 66 DA 36
6F 23 36 D6 01
01 59 C3 48 3E

## Italian
## 
21 B3 D5 CB AE
AF 21 85 DA 22
3D 22 AF EA 22
D3 21 66 DA 36
6F 23 36 D6 01
01 59 C3 46 3E

## Spanish
## 
21 B3 D5 CB AE
AF 21 85 DA 22
3D 22 AF EA 22
D3 21 66 DA 36
6F 23 36 D6 01
01 59 C3 4D 3E

Retrieved from "https://glitchcity.wiki/wiki/Guides:Safari_Escape_Underflow_ACE_Setups?oldid=47713 (https://glitchcity.wiki/wiki/Guides:Safari_Escape_Underflow_ACE_Setups?oldid=47713)"