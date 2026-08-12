# Custom Player Sprite Switcher

**GEN1RECOMP MOD** (not yet tested with Gold)

**Overworld On-the-Fly Sprite Changer**

Change your player sprite in real time.

An easy way to try out custom sprites or to play with different characters.
The GIF shows the effect ingame when pressing a shortcut button.

<p align="center">
  <img src="https://i.imgur.com/Oj1pFyY.gif" alt="OTF Player Switcher in-game demonstration">
</p>

## Features

* Change your overworld player sprite with the press of a button.
* Change your Trainer Card Image.
* Change your Player back sprite.
* Change your Fishing sprite.
* Change your cycling sprite.

  Bonus:
* Play as NPCs.

## Shortcuts

* <kbd>PageUp</kbd> — Switch to the previous sprite
* <kbd>PageDown</kbd> — Switch to the next sprite

Can be toggled in the mod options menu.

---
## Option 1: Use Crystal Clear Sprite Sheets + Converter

<p align="center">
<img src="https://i.imgur.com/muC6M5f.png">
</p>

Take a Crystal Clear Sprite Sheet and generate assets automatically. Yes they have a lot of white space.

> https://inject.sigkill.tech/injector/sprite

Scroll down and click **"USE PUBLIC TEMPLATE"**. There are over 1500 Sprite Sheets to choose from.

After downloading spritesheets you like use CCSS Converter to convert them to gen1recomp assets.

> https://crystal-clear-converter.netlify.app/

## Option 2: Cutting existing Sprite Sheets

Take any sprite sheet and divide it into separate assets to use them ingame (see [Sprite Naming & Dimensions](#sprite-naming--dimensions)).

<p align="center">
  <img src="https://i.imgur.com/aOGaTzs.png">
  <img src="https://i.imgur.com/S5Tz8Wa.png">
  <img src="https://i.imgur.com/ilGNNwE.png">
  <img src="https://i.imgur.com/ZpznmkK.png">
</p>

<p align="center">
<img src="https://i.imgur.com/jtI7nm1.jpeg">
</p>

---

## Option 3: Creating own Sprites

Create assets individually by yourself (see [Sprite Naming & Dimensions](#sprite-naming--dimensions)).

Or use the Sample Template from 

> https://inject.sigkill.tech/injector/sprite

to import your own spritesheet with 

> https://crystal-clear-converter.netlify.app.


## Sprite Naming & Dimensions

### Overworld / Walking (`16x96px`)

Use the name of the character, like `leaf.png`.

This is the character you walk around with.

### Cycling / Bike (`16x96px`)

Add `_bike` to the filename, like `leaf_bike.png`.

This is the player sprite you see when using the bicycle.

### Front / Trainer Card (`40x56px` or `56x56px`)

Add `_front` to the filename, like `leaf_front.png`.

This is the image on the Trainer Card.

### Back / Battle (`48x48px` or `32x32px`)

Add `_back` to the filename, like `leaf_back.png`.

This is the player sprite you see when starting a battle.

### Fishing Sprites (`3 different files: 16x8px each`)

Add `_fish_side, fish_front, fish_back` to the filenames, like `leaf_fish_side.png, leaf_fish_front.png, leaf_fish_back.png`.

This is the player sprite when using a fishing rod.

### Adding Sprites

To add sprites, add them to the `assets` folder in the .zip archive..

* To make the changes visible: close the game, remove the mod and install it again.

For example files, check the `assets` folder.

## Mod Options

* **CHARACTER SPRITE** — Selects the Character sprites used.
* **HIDE.LUA** — Enables/Disables the `hide.lua` file, which contains sprites to hide.
* **PGUP/PGDN SWITCH** — Enables/Disables the shortcut buttons.

<p align="center">
  <img src="https://i.imgur.com/EsO5iWQ.png" alt="OTF Player Switcher in-game options">
</p>

## `hide.lua`

Can be used to hide specific sprites. 

Select the sprites you want to hide and remove the comment.

A sprite which is commented out with  `--` will NOT be hidden and selectable ingame.

For example: if you want to swim on land you add `--` in front of `"seel",` or `"swimmer",`.

### Editing `hide.lua`

1. Extract `hide.lua` from the `.zip` archive.
2. Edit the file to hide or show specific sprites.
3. Overwrite `hide.lua` in the `.zip` archive.

* To make the changes visible: close the game, remove the mod and install it again.

## Available NPC Overworld Sprites

In Version 1.0, all 6 tile sprites extracted from the ROM are used.

The overworld spritesheets contain `6 X 16x16` sprites in a single `.png` image (see [Sprite Naming & Dimensions](#sprite-naming--dimensions)). These files are located in the `sprites` and `battle/trainers` folders of `gen1recomp`.

This means you can play as any NPC which walks around in the overworld.

* agatha
* beauty
* bird
* biker
* blue
* brunette_girl
* bruno
* channeler
* cook
* cooltrainer_f
* cooltrainer_m
* daisy
* fairy
* fisher
* gambler
* gentleman
* giovanni
* girl
* hiker
* koga
* lance
* little_girl
* lorelei
* middle_aged_man
* middle_aged_woman
* monster
* mr_fuji
* oak
* rocket
* rocker
* sailor
* scientist
* seel
* silph_worker_f
* super_nerd
* swimmer
* waiter
* youngster


## Credits

Leaf Sprites by Molly

Rick Sprites by Bani
