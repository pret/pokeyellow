# Source: https://glitchcity.wiki/wiki/Guides:Inventory_Underflow_ACE_Setups_(EN_Yellow)

This page serves as a repository for methods to quickly set up advanced ACE setups, starting from an existing save file. These methods can be used for the English releases of Yellow. It is part of the TimoVM's Gen 1 ACE setups (/wiki/Guides:TimoVM%27s_gen_1_ACE_setups) set of guides.

The methods described here were heavily inspired by previous SRAM glitch setups developed by Evie (Chickasaurus GL), as well existing setups intended to be used for the Japanese releases.

Please make sure to fully read every step of the guide before executing them.

If you encounter any issues when going through this guide or would like to provide feedback, please contact TimoVM on the Glitch City Research Institute Discord (https://discord.gg/EA7jxJ6).

## Contents
## 

- 1 Setting up initial ACE (#Setting_up_initial_ACE)

- 1.1 Requirements (#Requirements)

- 1.2 Step 1: Obtaining a lvl 80 Starmie (#Step_1:_Obtaining_a_lvl_80_Starmie)

- 1.2.1 Setting up Trainer Escape glitch (#Setting_up_Trainer_Escape_glitch)

- 1.3 Step 2: Getting inventory underflow (#Step_2:_Getting_inventory_underflow)

- 1.3.1 Preparations (#Preparations)

- 1.3.2 Setting up the first MISSINGNO. encounter (#Setting_up_the_first_MISSINGNO._encounter)

- 1.4 Step 3: Getting inventory underflow (#Step_3:_Getting_inventory_underflow)

- 1.4.1 A quick note on the do's and don'ts of inventory underflow (#A_quick_note_on_the_do's_and_don'ts_of_inventory_underflow)

- 1.5 Step 4: Collecting items in Celadon City (#Step_4:_Collecting_items_in_Celadon_City)

- 1.5.1 Prerequisites (#Prerequisites)

- 1.5.2 Using the expanded inventory to collect items (#Using_the_expanded_inventory_to_collect_items)

- 1.5.3 Final preparations (#Final_preparations)

- 1.5.4 What to do if the MISSINGNO. was incorrectly nicknamed (#What_to_do_if_the_MISSINGNO._was_incorrectly_nicknamed)

- 1.6 Step 5: Setting up an initial ACE environment using map script ACE (#Step_5:_Setting_up_an_initial_ACE_environment_using_map_script_ACE)

- 1.6.1 A note on using ACE (#A_note_on_using_ACE)

- 1.6.2 A note on unterminated name items in Eevee's room (#A_note_on_unterminated_name_items_in_Eevee's_room)

- 1.6.3 Setting up Infinite Eevee mode (#Setting_up_Infinite_Eevee_mode)

- 1.6.4 Setting up 4F to execute item codes (#Setting_up_4F_to_execute_item_codes)

- 1.6.5 Setting up the Nickname Writer (#Setting_up_the_Nickname_Writer)

- 1.7 Using the nickname writer (#Using_the_nickname_writer)

- 1.8 Step 6: Returning the game state to normal (#Step_6:_Returning_the_game_state_to_normal)

- 1.9 Additional applications of the Nickname Writer (#Additional_applications_of_the_Nickname_Writer)

- 2 Addendum: raw text transcripts of nickname codes (#Addendum:_raw_text_transcripts_of_nickname_codes)

- 2.1 Infinite Eevee Mode Nickname (#Infinite_Eevee_Mode_Nickname)

- 2.2 4F Bootstrap Nicknames (#4F_Bootstrap_Nicknames)

- 2.3 Nickname Writer (#Nickname_Writer)

- 3 Addendum: technical explanation of the setup (#Addendum:_technical_explanation_of_the_setup)

- 3.1 Nickname Converter Item Code (#Nickname_Converter_Item_Code)

- 3.1.1 Explanation (#Explanation)

- 3.1.2 Raw Assembly (#Raw_Assembly)

- 3.2 Infinite Eevee Nickname (#Infinite_Eevee_Nickname)

- 3.2.1 Explanation (#Explanation_2)

- 3.2.2 Raw Assembly (#Raw_Assembly_2)

- 3.3 4F Boostrap Nicknames (#4F_Boostrap_Nicknames)

- 3.3.1 Raw Assembly (#Raw_Assembly_3)

- 3.4 Using 4F (#Using_4F)

- 3.4.1 Explanation (#Explanation_3)

- 3.4.2 Raw Assembly (#Raw_Assembly_4)

- 3.5 Nickname Writer (#Nickname_Writer_2)

- 3.5.1 Explanation (#Explanation_4)

- 3.5.2 Raw Assembly (#Raw_Assembly_5)

- 3.6 Cleanup Code (new save) (#Cleanup_Code_(new_save))

- 3.6.1 Explanation (#Explanation_5)

- 3.6.2 Raw Assembly (#Raw_Assembly_6)

- 3.7 Cleanup Code (existing save) (#Cleanup_Code_(existing_save))

- 3.7.1 Explanation (#Explanation_6)

- 3.7.2 Raw Assembly (#Raw_Assembly_7)

## Setting up initial ACE
## 
In order to set up ACE, our first goal is to set up inventory underflow. This is a state in which the game believes we have 255 items within the bag, which allows us to access memory locations beyond the item bag's intended 20 slots and manipulate them as if they were items. To do that, we'll need an item with a quantity of 255.

When MISSINGNO. or 'M are encountered, the game tries to set the corresponding SEEN flag. This causes the game to add 128 to item #6's quantity, provided its quantity is lower than 128. Unfortunately for us, regular MISSINGNO./'M sprites are unstable in Yellow and highly likely to crash the game. To avoid this, we're going to set up the Trainer Escape glitch with a special stat of 182, 183 or 184. This will allow us to encounter one of the three forms of MISSINGNO. that use a valid sprite (Aerodactyl fossil, Kabutops Fossil and Ghost MISSINGNO.).

In this guide, we will be abusing this to set up an ACE environment through the following process:

- Set up Trainer Escape glitch and use it to obtain a Lv. 80 Starmie with 182, 183 or 184 special.

- Using this Starmie, use the Ditto variant of the Trainer Escape glitch to encounter MISSINGNO. twice, setting item #6's quantity to 255 in the process.

- Use the x255 item stack to set up inventory underflow.

- Using inventory underflow, access Celadon City so that we can assemble an item code that will allow us to write code using boxed pokémon's nicknames.

- Using an exploit known as "Map Script ACE", set up a method to quickly pick up an unlimited amount of Eevees

- Write code by repeatedly picking up and nicknaming Eevees. This will be used to build a program that allows you to more easily write arbitrary code.

## Requirements
## 
At this moment, this guide requires the following:

- There is at least one long-range trainer that you haven't fought yet. A long-range trainer is a trainer whose vision extends all the way to the edge of the screen. You can find a list of available long-distance trainers here (https://www.smogon.com/ingame/guides/rby_tips#long). (TODO: check if we have a list on the wiki and link that instead)

- You must be able to access Cinnabar Island.

- Must have registered Cubone as SEEN in the pokédex. Cubone can be found in the Pokémon Tower (5F, 6F and 7F at 5% odds) or the safari zone (zone 2, zone 3 and zone 4 at 10% odds)
On top of this requirement, it is also heavily recommended that you have one Master Ball. This can be used to easily catch the Starmie.

## Step 1: Obtaining a lvl 80 Starmie
## 
Before we begin, make sure to assemble the following:

- Have a pokémon with Fly in your party.

- Have a pokémon with Strength in your party.

- Have one of the following:

- 1 Master Ball and 10-20 Great Balls

- 30-40 Great Balls

## Setting up Trainer Escape glitch
## 
Go to the route where the long-range trainer of your choice is.

- Stand right beyond the edge of the long-range trainer's vision. The long-range trainer should be offscreen, such that you just need to take a single step to enter the long-range trainer's vision.

- Walk into the long-range trainer's vision. While you're walking, press and hold the START button. The start menu should open immediately after the step's animation finishes.

- Fly to Fuchsia City. If you've done everything right, the exclamation mark will appear over the trainer and the encounter music will start, but will be interrupted by you flying away.
We've now set up Trainer Escape glitch, but we first need to clear some side effects. We're currently unable to open the start menu and returning to the route with the long-range trainer will currently softlock.

- Enter the Fuchsia City pokémon center and go to the PC. Using the PC, change boxes, which causes the game to save.

- Reset the game. Once you've loaded back in you'll be able to open the start menu again.

- Exit the Fuchsia City pokémon center and walk to the right until you see a pair of houses. Enter the leftmost house, which is the house of the Safari Zone warden (who gives you the Strength HM in return for the Gold Teeth).

- Inside the house is a Strength block. Have a party pokémon use Strength and push it in any direction. Doing this prevents the softlock from occurring.
Finally, we're going to catch Starmie.

- Go to route 5. On the lower right of the map, enter the northern building of the Underground Tunnel. This building has an NPC that trades a Nidoran♀ in return for a Nidoran♂. For this guide, it does not matter whether you've done this trade or not.

- Save the game. From now on, do not save again until we've obtained the desired Lv. 80 Starmie.

- Talk to the trade NPC. You do not need to accept the trade.

- Without encountering any other pokémon, Fly back to the route that contains the long-range trainer. Once you arrive there, the start menu will open on its own.

- Once you close the start menu, an encounter with a lv. 80 Starmie will start. At full health, Starmie has a 14% odds to be caught with a Great Ball. Either use a Master Ball or use Great Balls. If you run out of Great Balls, reset and repeat the preceding steps.

- DO NOT SAVE ONCE YOU'VE CAUGHT THE STARMIE. Check its summary and make sure it has the desired special stat.

- If the Starmie has 182 or 184 Special (2/16 odds), you can save and move on to the next step.

- If the Starmie has 173 or 174 Special (2/16 odds), buy and use a Calcium. Afterwards, verify that the Starmie's Special is now at 183 or 184 respectively. If yes, you can save and move on to the next step

- If the Starmie has 168 or 169 Special (2/16 odds), buy and use two Calciums. Afterwards, verify that the Starmie's Special is now at 182 or 184 respectively. If yes, you can save and move on to the next step

- If the Starmie has 165 or 166 Special (2/16 odds), buy and use three Calciums. Afterwards, verify that the Starmie's Special is now at 182 or 184 respectively. If yes, you can save and move on to the next step

- If Starmie has any other Special stat, doesn't end up with a Special stat between 182 and 184 or you don't have sufficient money to buy Calcium, reset the game and repeat the preceding steps.

## Step 2: Getting inventory underflow
## 
We've now obtained a Starmie with a special stat between 182 and 184, which we can use to encounter one of the three special form MISSINGNO.

The pokémon you get from a Trainer Escape encounter is dependent on the last fought enemy pokémon's Special. To encounter the special form MISSINGNO., we need the last fought enemy pokémon's Special stat to be either 182, 183 or 184. Unfortunately, no NPC trainer or wild pokémon encounter ever reaches this high. To circumvent this, we're going to use Ditto instead. When an enemy Ditto uses Transform, it copies the opposing pokémon's stats. By having a Ditto transform into our newly obtained Starmie and running away, the last fought enemy pokémon's Special will match that of Starmie.

## Preparations
## 
Before we initiate MISSINGNO. encounters, make sure to do the following:

- Buy a few Escape Ropes.

- Have an X item (such as an X Special) in the 6th item slot, with a quantity of 1. We will be duplicating this item twice using the MISSINGNO. glitch.

- Have the newly caught Starmie in the first party slot. Doublecheck that it has a Special stat between 182 and 184. This Starmie is not allowed to gain any experience in battle for the duration of the guide.

- Have a full party.

- The current active box must be completely empty.

- (optional) Have a pokémon with Hypnosis in the party. the MISSINGNO. we'll encounter will be at Lv. 7, so any Hypnosis user will do.

## Setting up the first MISSINGNO. encounter
## 
Go to the route where the long-range trainer of your choice is. The trainer escape glitch doesn't set this trainer as fought, so you can just reuse the trainer you used before over and over again.

- Stand right beyond the edge of the long-range trainer's vision. The long-range trainer should be offscreen, such that you just need to take a single step to enter the long-range trainer's vision.

- Walk into the long-range trainer's vision. While you're walking, press and hold the START button. The start menu should open immediately after the step's animation finishes.

- Fly to Fuchsia City. If you've done everything right, the exclamation mark will appear over the trainer and the encounter music will start, but will be interrupted by you flying away.
We've now set up Trainer Escape glitch, but we first need to clear some side effects. We're currently unable to open the start menu and returning to the route with the long-range trainer will currently softlock.

- Enter the Fuchsia City pokémon center and go to the PC. Using the PC, change boxes, which causes the game to save.

- Reset the game. Once you've loaded back in you'll be able to open the start menu again.

- Exit the Fuchsia City pokémon center and walk to the right until you see a pair of houses. Enter the leftmost house, which is the house of the Safari Zone warden (who gives you the Strength HM in return for the Gold Teeth).

- Inside the house is a Strength block. Have a party pokémon use Strength and push it in any direction. Doing this prevents the softlock from occurring.
We're now going to set up the MISSINGNO. encounter.

- Fly to Cinnabar Island and enter the Cinnabar Mansion. Go to Cinnabar Mansion B1F.

- Save the game. From now on, do not save again until we've encountered MISSINGNO.

- Walk around until you get into a battle with Ditto (10% odds). Have the Ditto transform into Starmie, then run away afterwards. (Starmie can stall for a single turn by using Harden)

- Afterwards, use an Escape Rope to exit the Cinnabar Mansion. Make sure you do not get into another battle.

- Without encountering any other pokémon, Fly back to the route that contains the long-range trainer. Once you arrive there, the start menu will open on its own.

- Once you close the start menu, an encounter with a lv. 7 MISSINGNO. will start. The X item in the 6th slot now has a quantity of x129.

- Use the X item twice to reduce its quantity to x127.

- Use Great Balls to catch MISSINGNO.. MISSINGNO.'s catch rate will be the same as Starmie's, so you have about 14% odds of catching it for every Great Ball. These odds increase to 29% if MISSINGNO. is asleep.

- Once you've managed to catch it, nickname it as shown below. MISSINGNO. will be stored in the PC afterwards. Since Cubone is registered as SEEN in the pokédex, MISSINGNO.'s pokédex entry won't be shown.

 | Nickname

 | (/wiki/File:InfiniteEeveeY.png)

Because we caught MISSINGNO., the quantity of slot #6 was increased a second time, to a total of 255. This gives us everyting we need to set up inventory underflow.

Seeing MISSINGNO. in battle causes a side effect where sprites appear to be distorted. This can be fixed by looking at the summary of any non-glitch pokémon.

## Step 3: Getting inventory underflow
## 
Now that we have an item stack with a quantity of 255, we can finally set up inventory underflow by abusing its properties.

- Using SELECT, swap the x255 item to the 1st item slot.

- Deposit all key items you currently have to the PC.

- Fill up the remainder of the bag with normal items (so that the bag is filled with a total of 20 item slots). All items within the bag will be lost by the end of the setup, but can easily be reobtained using ACE at the end of the guide. Head to the Celadon Dept. Store if you need additional items to buy.

- Using SELECT, swap the x255 item to the 3rd item slot. The first three item slots now look as follows:

- Slot 1: non-key item you don't mind selling

- Slot 2: another non-key item you don't mind selling.

- Slot 3: x255 item

- Toss/Sell all the items in slot 1. This will seemingly duplicate the x255 item stack:

- Slot 1: another non-key item you don't mind selling.

- Slot 2: x255 item

- Slot 3: x255 item

- Toss/Sell all the items in slot 1. This will again seemingly duplicate the x255 item stack:

- Slot 1: x255 item

- Slot 2: x255 item

- Slot 3: x255 item

- Toss/Sell all the items in slot one a total of 17 times.

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
Inventory underflow is one of the most powerful and versatile glitched state available in gen 1, allowing you to access memory beyond the normal limits of the item bag and manipulate them as if they're items. Because of that, care should be taken when handling this glitched state.

- Buying items will reset the inventory underflow state and turn the item bag back to normal. Because of this, we will not buy items, but instead use inventory underflow to obtain them in another way.

- Never try to swap two item stacks of the same type while inventory underflow is active. Doing this will shift all item stacks (in other words, all memory values the bag has access to), causing a substantial amount of memory corruption.

- Certain glitch items lack a proper string terminator. When you select them, either by pressing A or select when highlighting them in the bag, these items will crash the game. On the Virtual Console releases, this has a possibility of erasing your save. When you see any item with an unusually long glitched name, please make sure to not use either of these buttons to select them.

- In certain maps, such as Celadon City, opening the item bag or scrolling the item bag to display an unterminated name item can cause the game to seemingly freeze. You can get the game to safely resume by tapping b regularly until the bag's cursor becomes visible again.

## Step 4: Collecting items in Celadon City
## 
Now that we have inventory underflow, our main task will be to assemble a specific set of items.

## Prerequisites
## 

- Fly to Celadon City, where we'll be collecting the required set of items.

- Enter the Celadon City Pokémon Center and ensure that the current active box is completely empty.

- Ensure that a pokémon with Fly is still in your party.

- Exit the Pokémon Center and save the game.

## Using the expanded inventory to collect items
## 
While standing in front of the Celadon City Pokémon Center, take 3 steps right, 5 steps up, 11 steps left and finally 3 steps up to reach the following spot.

 | Place to stand

 | (/wiki/File:ThunderstoneLocationY.png)

While standing on this spot, open your item bag and keep scrolling down until you find a Thunderstone x0 item stack, located at item slot #35 as indicated by the below screenshot. We will use this spot to orient ourselves for the next section.

 | Slot #35

 | (/wiki/File:ThunderstoneMenuENY.png)

By walking left or right, you can increment or decrement the item ID in slot #35. By walking up and down we can alternate between an item quantity of x0 and x1. We can safely swap the contents of item slot #35 with other item slots, as long as we use Fly afterwards to restore the map back to normal. We can use this to collect all the items we need for the item code. slot #33 will always contain a bicycle, you can safely use this to speed up the process. 

For every item in the following table, head to the Thunderstone x0 spot, follow the instructions to obtain an item stack, then Fly back to Celadon and head back to the same spot to obtain the next item stack. It is heavily recommended to save after every time you fly back to the Celadon City Pokémon Center.

During the entire process, make sure to not swap two item stacks that have the same item. This will cause both item stacks to merge, resulting in glitches as side effects. When this happens, you can reset the game to restore the game back to normal.

 | Item location
 | Item ID
 | Item quantity
 | How to acquire

 | (/wiki/File:MaxPotionLocationY.png)
 | Max Potion
 | x105
 | At the Thunderstone spot, walk 16 steps to the left to get Max Potion x0. Toss 99 from the stack, then toss another 52 from the stack, then swap to slot #6.

 | (/wiki/File:TM14LocationY.png)
 | TM14
 | x213
 | At the Thunderstone spot, swap the Thunderstone with the TM23 x64 stack 4 slots below, then toss 63 TM23s. Walk 1 step up and 9 steps left to get TM14 x0. Toss 43 from the stack, then swap to slot #7.

 | (/wiki/File:ThunderstoneLocationY.png)
 | Thunderstone
 | x05
 | Go to the Thunderstone spot to get Thunderstone x0. Toss 251 from the stack, then swap to slot #8.

 | (/wiki/File:TM22LocationY.png)
 | TM22
 | x42
 | At the Thunderstone spot, swap the Thunderstone with the TM23 x64 stack 4 slots below, then toss 63 TM23s. Walk 1 step up and 1 step left to get TM22 x0. Toss 214 from the stack, then swap to slot #9.

 | (/wiki/File:GreatBallLocationY.png)
 | Great Ball
 | x135
 | At the Thunderstone spot, walk 30 steps to the left to get Great Ball x0. Toss 99 from the stack, then toss an additional 22 from the stack to reach x135, then swap to slot #10.

 | (/wiki/File:AntidoteLocationY.png)
 | Antidote
 | x48
 | At the Thunderstone spot, walk 22 steps to the left to get Antidote x0. Toss 208 from the stack, then swap to slot #11.

 | (/wiki/File:PokeBallLocationY.png)
 | Poké Ball
 | x134
 | At the Thunderstone spot, walk 29 steps to the left to get Poké Ball x0. Toss 99 from the stack, then toss an additional 23 from the stack to reach x134, then swap to slot #12.

 | (/wiki/File:HyperPotionLocationY.png)
 | Hyper Potion
 | x44
 | At the Thunderstone spot, walk 15 steps to the left to get Hyper Potion x0. Toss 212 from the stack, then swap to slot #13.

 | (/wiki/File:SuperPotionLocationY.png)
 | Super Potion
 | x32
 | At the Thunderstone spot, walk 14 steps to the left to get Super Potion x0. Toss 224 from the stack, then swap to slot #14.

 | (/wiki/File:TM44LocationY.png)
 | TM44
 | x201
 | At the Thunderstone spot, swap the Thunderstone with the TM23 x64 stack 4 slots below, then toss 63 TM23s. Walk 2 steps down, 12 steps right, 5 steps down and then 9 steps right to get TM44 x0. Toss 55 from the stack, then swap to slot #15.

 | (/wiki/File:CalciumLocationY.png)
 | Calcium
 | x243
 | At the Thunderstone spot, walk 6 steps to the right to get Calcium x0. Toss 13 from the stack, then swap to slot #16.

After flying back to Celadon city, we will verify if all items have been successfully collected.

## Final preparations
## 

- Before opening the bag, walk 5 steps to the right from the entrance of the pokémon center. This will ensure that we can open the item bag without issues.

- Next, make sure your item bag looks as follows:

 | Item slot
 | Item ID
 | Item Quantity

 | Slot #6
 | Max Potion
 | x105

 | Slot #7
 | TM14
 | x213

 | Slot #8
 | Thunderstone
 | x05

 | Slot #9
 | TM22
 | x42

 | Slot #10
 | Great Ball
 | x135

 | Slot #11
 | Antidote
 | x48

 | Slot #12
 | Poké Ball
 | x134

 | Slot #13
 | Hyper Potion
 | x44

 | Slot #14
 | Super Potion
 | x32

 | Slot #15
 | TM44
 | x201

 | Slot #16
 | Calcium
 | x243

- Verify that the MISSINGNO. is correctly nicknamed and placed within the box. It should be the only pokémon present in the current active box, with the nickname shown below.

 | Nickname

 | (/wiki/File:InfiniteEeveeY.png)

- Make sure that your current party contains 6 pokémon.

- Head to the Celadon Mandion penthouse, which is the room where you can pick up the gift Eevee. Make sure to save before continuing.

## What to do if the MISSINGNO. was incorrectly nicknamed
## 
In case the MISSINGNO.'s nickname is incorrect, you can simply release it and head to route 7 to catch another pokémon. You can use the Great Ball stack in slot 10 for this, as long as you make sure to reaquire the Great Ball stack afterwards so that you can set it to its correct quantity.

## Step 5: Setting up an initial ACE environment using map script ACE
## 
Now that we have an item code ready, we'll finally be using it to set up an ACE environment. The item code we just made looks at the nicknames of the pokémon in the currently stored box, then uses pairs of text characters to write a new program. After it finishes, it immediately jumps to execute the newly written program.

We'll be executing ACE by overwriting the contents of item slot #41. This item slot contains the map script pointer. By overwriting it with a pointer aimed for the 6th item slot, the item code we made will be executed on every individual frame the start menu isn't open.

We will be using this in three stages:

- First we will alter a value in memory so that we can continuously keep picking up Eevees while we remain on the same map.

- Next we will give ourselves a glitch item that, when used, will execute ACE starting from the sixth item slot. This allows us to execute ACE outside of the limits of Map Script ACE.

- Finally we will set up a short program that uses the nickname screen to quickly and easily write programs of arbitrary size, effectively giving us a flexible ACE environment.
It is recommended to not save the game until the Nickname Writer program is installed. 

## A note on using ACE
## 
The first generation of pokémon games, especially the Virtual console releases, are vulnerable to certain crashes wiping the save file. As a protective measure, make sure to open the trainer card to display Red's sprite on screen right before using ACE of any kind. Loading any sprite switches the current active sram bank, offering a measure of safety against game crashes.

## A note on unterminated name items in Eevee's room
## 
Within this room, no safe spots exist that allow unterminated name items to be safely handled. Please make sure to not press a or select on unterminated items while in this room.

## Setting up Infinite Eevee mode
## 
First, we'll use Map Script ACE to make sure that we can pick up as many Eevee as we want. For this purpose, we've already stored a nicknamed pokémon in the current active box.

- Open the item bag. Swap the Calcium x243 with the contents of item slot #41, which should contain X Defend x86. This will activate Map Script ACE.

- Close the start menu. If everything went all right, Eevee's poké ball will not disappear when it is picked up. If you've already picked up Eevee prior to this, its poké ball will reappear as well.

- Open the item bag. Swap the X Defend x86 that was previously in item slot #41 with the Calcium x243. This will deactivate Map Script ACE.

 | Slot #41

 | (/wiki/File:MapScriptMenuENY.png)

## Setting up 4F to execute item codes
## 
Next, we'll be entering a list of three nicknames that gives us 4F and the necessary bootstrap. This ensures that using 4F will activate the item code.

 | List of nicknames

 | (/wiki/File:WsmBootstrap.png)

- Pick up Eevees and enter the nicknames in the above screenshot one by one. The nicknames from this list needs to be entered in this exact order from the top to the bottom.

- Open the item bag. Swap the Calcium x243 with the contents of item slot #41, which should contain X Defend x86. This will activate Map Script ACE.

- Close the start menu. If everything went all right, the CANCEL buttons in the first three slots have been removed and the first item was replaced with a glitch item named "4F"

- Open the item bag. Swap the X Defend x86 that was previously in item slot #41 with the Calcium x243. This will deactivate Map Script ACE.

- Finally, verify that 4F works by using it. If the game doesn't crash, 4F was set up correctly.

 | Slot #41

 | (/wiki/File:MapScriptMenuENY.png)

## Setting up the Nickname Writer
## 

- Next, we'll be entering a list of thirteen nicknames. This will form a small program that, when activated using 4F, will allow us to easily write large amount of arbitrary code using the nickname screen.

 | List of nicknames

 | (/wiki/File:NicknameWriterY.png)

- Pick up Eevees and enter the nicknames in the above screenshot one by one. The nicknames from this list needs to be entered in this exact order from the top to the bottom.

- Once all nicknames have been entered, look at your trainer card, then use 4F. This should open a screen in which you're asked to enter a pokémon's nickname

- For now, press START to end writing the nickname. This should display the main menu, a number should be written on screen.

- Press SELECT to exit the Nickname Writer safely.

## Using the nickname writer
## 
From this point onward, whenever you use the ACE item, you should be able to open the nickname writer. Please make sure to keep note of the following:

- Since the Nickname Writer works independently of the current active box, you can change the current active box however much you like.

- When writing data, the Nickname Writer will overwrite enemy party data. While this does not have any effect outside of battle, it is recommended to not use the Nickname Writer in battle.
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

## Step 6: Returning the game state to normal
## 
At this point, there are certain side effects that have been introduced by the setup:

- 
- By picking up Eevee, we have flagged its poké ball as "obtained"

- The current active box is filled with nicknamed Eevees

- The item pack currently has 255 items

- The item code is currently still required to run the Nickname Writer
We will be removing all these side effect using the Nickname Writer. The nicknames we need to enter will be generated by the Nickname Converter webtool (https://timovm.github.io/NicknameConverter/). Simply open the link, copy paste one of the two codes below into the converter, then press the "Run" button to display the list of nicknames. Please make sure that you use the Nickname Writer within a poké center, to ensure that the checksums are displayed properly. 

When using the Nickname Writer, the generated nicknames need to be entered from top to bottom.

Please ensure to pick the code that suits your type of save.

Codes to be used with the Nickname Converter webtool (https://timovm.github.io/NicknameConverter/)

 | Existing saves

 | 21 AD D5 CB AE
AF 21 7F DA 22
3D 22 AF EA 1C
D3 21 65 DA 36
69 23 36 D6 01
01 59 C3 3F 3E

Once all nicknames have been entered and verified, you can press START during input mode to execute the code.

This will activate the following effects:

- 
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

 | Nickname

 | C l l U&nbsp;: V&nbsp;:&nbsp;; W&nbsp;;

## 4F Bootstrap Nicknames
## 

 | List of nicknames

 | g . y x ] , k Mn * Pk
* ( u z z , , . ] ,
w v u v U l k Mn Pk X

## Nickname Writer
## 

 | List of nicknames

 | a b v v ) l l C d d
j&nbsp;? ) V t v v v l Mn
q p y y ] z y p g F
v u j&nbsp;? t K K b c c
R j j m v w w P P p
l l M v V V u l&nbsp;: ♀
P x w v v W M m m w
A B r q x Pk z g g h
i z , [ o w o x w x
( ) ) ) ) , , ] ] .
j&nbsp;! U&nbsp;?&nbsp;? u w v u Mn
a Pk * t * A S j s t
r p P W [&nbsp;:&nbsp;:&nbsp;;&nbsp;:&nbsp;;

## Addendum: technical explanation of the setup
## 

## Nickname Converter Item Code
## 

## Explanation
## 
The item code itself consists of two components. The first 10 items are used to write a program that takes text characters from the nicknames of characters currently within the active box, converts them, then writes the resulting values to unused memory starting from $D66A. 

Pairs of text characters are converted to single values through a [(2a + b)%256] formula, where a is the value of the first character and b the value of the second. text terminators are skipped, the code will stop and execute the newly written code once it either reads a $00 value or if values are being read past $DEFF.

11 69 D6 ld de, UNUSED_MEMORY ; Memory between $D669 and $D6EE goes unused
D5 push de
21 05 DE ld hl, wBoxNicks
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

The last item, the Calcium, simply form a pointer to $F327. Due to echo RAM this address is equivalent to $D327, which correspond to item #6's item ID, the start of the item code. By replacing the map script pointer with this item, we can redirect the map script routine to execute the item code instead. This routine is executed on every frame, as long as the start menu isn't open.

## Raw Assembly
## 
11 69 Max Potion x105
D6 D5 TM14 x213
21 05 Thunderstone x05
DE 2A TM22 x42
03 87 Great Ball x135
0B 30 Antidote x48
04 86 Poké Ball x134
12 2C Hyper Potion x44
13 20 Super Potion x32
F4 C9 TM44 x201

27 F3 Calcium x243

## Infinite Eevee Nickname
## 

## Explanation
## 
The Infinite Eevee mode nickname writes $00 to the lower byte of wMissableObjectList, causing a misalignment in how the game applies NPC disappearance, causing Eevee's pokéball to stay permanently visible until the game is reset or the player leaves the Celadon Mansion penthouse.

AF xor a ; a = $00
EA CD D5 ld (wMissableObjectList), a ; Misaligns which objects are made invisible
C9 ret

## Raw Assembly
## 
AF EA CD D5 C9

## 4F Boostrap Nicknames
## 
This set of nicknames, when converted, will modify item #1's ID to be 4F and writes a bootstrap so that using it will lead to execution of the item code from $D327 onward. It requires the presence of the Infinite Eevee Mode Nickname (see previous section) to properly return.

21 1D D3 ld hl, wBagItems ; item #1's ID
36 59 ld (hl), $59 ; 4F's item ID
7C ld a, h ; a = $D3 
21 66 DA ld hl, 4F_Execution_Pointer +2
32 ldd (hl), a
3E 27 ld a, $27
22 ldi (hl), a
36 C3 ld (hl), $C3
; The contents of the first nickname (see previous section) are written right after this, ensuring safe return.

## Raw Assembly
## 
21 1D D3 36 59
7C 21 66 DA 32
3E 27 32 36 C3

## Using 4F
## 

## Explanation
## 
Using 4F, an invalid item, will cause the game to index the item effects table out of bounds, leading to an invalid execution pointer. For 4F, this causes the game to execute code from $FA64 onward. Due to echo RAM, this address is equivalent to $DA64. Thanks to the bootstrap that was applied earlier, this will then cause the game to jump to $D327, corresponding to the start of the item code.

C3 27 D3 jp ITEM_6_ID

## Raw Assembly
## 
C3 27 D3

## Nickname Writer
## 

## Explanation
## 
The Nickname Writer is a small program that, using nicknames as input, is able to write arbitrary amounts of custom code relatively quickly. It first request a nickname as input, then converts that data to custom code, then displays a checksum of the written data and finally asks the player to provide additional input.

The value of the checksum is calculated by [($80 + the sum of all written values)%256]. Custom code is buffered and executed within enemy party data. Due to how it calls DisplayNameRaterScreen, it will also nickname a party pokémon corresponding to the item slot that 4F currently occupies.

11 B4 D8 ld de, $D8B4 ; location written to
D5 push de
.newMail
D5 push de
21 95 62 ld hl, AskName + 39h ; Prepares data and calls DisplayNamingScreen
CD 17 39 call $3917 ; sets b to 01, then jumps to Bankswitch, calling b:hl
0E 80 ld c, $80 ; Ensure checksum consistency
21 4A CF ld hl, wStringBuffer ; Address where new name gets written to
D1 pop de ; Continue writing from last saved de
.newChar
2A ld a, (hli)
87 add a
30 09 jp nc, .terminator ; If blank space as first character of pair, only terminator $50 will result in a nc result
86 add a, (hl)
12 ld (de), a
13 inc de
23 inc hl
81 add a, c ; Current checksum total is buffered in c
12 ld (de), a
4F ld c, a
18 F3 jp .newChar
.terminator
D5 push de
21 00 C4 ld hl, $C400 ; Corresponds to screen tile
0E 01 ld c, $01 ; How many bytes printed as numbers?
CD BF 13 call PrintBCDNumber.loop
.numLoop
2D dec l
CB FE set 7, (hl)
20 FB jp nz, .numLoop ; Repeat until hl == $C400
75 ld (hl), l ; Nulls out $C400
.inputLoop
CD 1E 38 call JoypadLowSensitivity ; Halt execution until frame has passed, get joypad status and store result in hJoy5
F0 B5 ld a, (hJoy5)
E6 0F and $0F ; Set z flag if A, B, START, SELECT not pressed
28 F7 jp z, .inputLoop
1F rra ; Is A pressed? If yes, set c flag
D1 pop de
38 CB jr c, .newMail
1B dec de
1F rra ; Is B pressed? If yes, set c flag
38 E1 jr c, .terminator
1F rra ; Is SELECT pressed? If yes, set c flag
E1 pop hl ; pop starting address to hl
D8 ret c ; If SELECT pressed, simply return to normal operations
E9 jp hl ; If START pressed, jump to hl to execute newly written code

## Raw Assembly
## 
11 B4 D8 D5 D5
21 95 62 CD 17
39 0E 80 21 4A
CF D1 2A 87 30
09 86 12 13 23
81 12 4F 18 F3
D5 21 00 C4 0E
01 CD BF 13 2D
CB FE 20 FB CD
1E 38 F0 B5 E6
0F 28 F7 1F D1
38 CB 1B 1F 38
E1 1F E1 D8 E9

## Cleanup Code (new save)
## 

## Explanation
## 
This code cleans up every negative side effect brought on by the setup and allows the player to continue the story as intended, with the exception of 4F being added to the item bag, enabling use of the Nickname Writer.

The negative effects targeted are:

- By picking up Eevee, we have flagged its poké ball as "obtained"

- The current active box is filled with nicknamed Eevees

- The item pack currently has 255 items

- The item code is currently still required to run the Nickname Writer

- We currently have two badges set as obtained

- Our pokédex currently has 152 pokémon species caught, preventing the story from continuing

- Setting up SRAM glitch has given us a party of 255 pokémon

- We are currently located in the Celadon Pokémon center, while we need to return to Pallet Town to pick up the starter pokémon
21 AD D5 ld hl, $D5AD ; Part of wMissableObjectFlags
CB AE res 5, (hl) ; Reenable Eevee's poké ball
AF xor a ; a = $00
EA 55 D3 ld (wObtainedBadges), a ; Reset badges
21 7F DA ld hl, wBoxCount
22 ldi (hl), a ; Set amount of pokémon in box to 0
3D dec a ; a = $FF
22 ldi (hl), a ; Add proper terminator to wBoxSpecies
AF xor a ; a = $00
01 26 00 ld bc, 0026
21 F6 D2 ld hl, wPokedexOwned
.loop
22 ldi (hl), a
0D dec c
20 FC jp nz, .loop ; Fully clear all Pokédex flags
2E B0 ld l, $B0 ; hl = $D3B0, within wWarpEntries
22 ldi (hl), a
22 ldi (hl), a
23 inc hl
23 inc hl
22 ldi (hl), a
22 ldi (hl), a ; Changes first two warp tiles to lead to Pallet Town instead
EA 62 D1 ld (wPartyCount), a ; Set amount of pokémon in party to 0
EA 1C D3 ld (wNumBagItems), a ; Set amount of items to 0
01 01 59 ld bc, $5901
CD 3F 3E call GiveItem ; Gives c amount of b item, giving 1 copy of 4F.
21 65 DA ld hl, $DA65 ; Part of 4F bootstrap
36 69 ld (hl), $69
23 inc hl
36 D6 ld (hl), $D6 ; 4F now redirects directly to Nickname Writer
C9 ret

## Raw Assembly
## 
21 AD D5 CB AE
AF EA 55 D3 21
7F DA 22 3D 22
AF 01 26 00 21
F6 D2 22 0D 20
FC 2E B0 22 22
23 23 22 22 EA
62 D1 EA 1C D3
01 01 59 CD 3F
3E 21 65 DA 36
69 23 36 D6 C9

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

21 AD D5 ld hl, $D5AD ; Part of wMissableObjectFlags
CB AE res 5, (hl) ; Reenable Eevee's poké ball
AF xor a ; a = $00
21 7F DA ld hl, wBoxCount
22 ldi (hl), a ; Set amount of pokémon in box to 0
3D dec a ; a = $FF
22 ldi (hl), a ; Add proper terminator to wBoxSpecies
AF xor a ; a = $00
EA 1C D3 ld (wNumBagItems), a ; Set amount of items to 0
21 65 DA ld hl, $DA66 ; Part of 4F bootstrap
36 69 ld (hl), $69
23 inc hl
36 D6 ld (hl), $D6 ; 4F now redirects directly to Nickname Writer
01 01 59 ld bc, $5901
C3 3F 3E jp GiveItem ; Gives c amount of b item, giving 1 copy of 4F.

## Raw Assembly
## 
21 AD D5 CB AE
AF 21 7F DA 22
3D 22 AF EA 1C
D3 21 65 DA 36
69 23 36 D6 01
01 59 C3 3F 3E

Retrieved from "https://glitchcity.wiki/wiki/Guides:Inventory_Underflow_ACE_Setups_(EN_Yellow)?oldid=44922 (https://glitchcity.wiki/wiki/Guides:Inventory_Underflow_ACE_Setups_(EN_Yellow)?oldid=44922)"