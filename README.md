# Custom Player Sprite Switcher (RBY / GSC compatible)

**GEN1RECOMP MOD (for use with https://crystal-clear-converter.netlify.app)**

Changes your player sprite in real time.
Use existing Spritesheets or create your own!

## Features

**This mod makes it possible to change the following sprites:**
* Overworld Walking Sprite
* Trainercard Front Sprite
* Battle Back Sprite
* Fishing Sprites (Gen2 doesnt have fishing animations)

**Experimental:**
* Biking Sprites (the normal animation will be "running")
* Play as NPCs.
  
<p align="center">
   <img width="32.5%" src="https://i.imgur.com/1i9F8WJ.png">
   <img width="32.5%" src="https://i.imgur.com/W4idG7L.png"> 
   <img width="32.5%" src="https://i.imgur.com/P4Pb81r.png">
</p>


<p align="center">
  <img width="32.5%" src="https://i.imgur.com/Z4WyzMz.png">
    <img width="32.5%" src="https://i.imgur.com/y50A4cT.png"> 
   <img width="32.5%" src="https://i.imgur.com/ZKxJ94u.png">
</p>


<p align="center"> 
<img width="32.5%" src="https://i.imgur.com/Dg8dUoQ.png">
  <img width="32.5%" src="https://i.imgur.com/B2r155g.png">
   <img width="32.5%" src="https://i.imgur.com/3t2nSCB.png">
</p>


<p align="center">
  <img width="32.5%" src="https://i.imgur.com/KK0bWFv.png">
<img width="32.5%" src="https://i.imgur.com/1Rq6DLv.png">
   <img width="32.5%" src="https://i.imgur.com/PYrJI3d.png">
</p>


<p align="center">  
   <img width="32.5%" src="https://i.imgur.com/v04wHKS.png">
<img width="32.5%" src="https://i.imgur.com/iMN0Dlx.png">
   <img width="32.5%" src="https://i.imgur.com/eG56MiN.png">
</p>




## Shortcuts

* <kbd>PageUp</kbd> — Switch to the previous sprite
* <kbd>PageDown</kbd> — Switch to the next sprite

**There is also a Custom Menu (press start)**

---
## Option 1: Use Crystal Clear Sprite Sheets + Converter

Download some Crystal Clear Spritesheets and generate assets automatically 

Do not crop them and do not change the dimensions (800x300px)!

> https://crystal-clear-converter.netlify.app/sprites
> 
<p align="center">
<img src="https://i.imgur.com/tX8Z7fm.png">
</p>

There are over 1300 Sprite Sheets to choose from.

After downloading some Spritesheets use **Crystal Clear Spritesheet Converter** to convert them to gen1recomp assets.

> https://crystal-clear-converter.netlify.app/

---

## Option 2: Creating own Spritesheets

Use the Template from:

> [https://crystal-clear-converter.netlify.app/template-gen1recomp.png](https://crystal-clear-converter.netlify.app/template-gen1recomp.png)

Adjust the "Injecting" palette to match your character. 

You should only use Black + White + 2 Custom colors!

The Front- and Backsprites can use all 4 colors.

Walking and Fishing Sprites should only use White for transparency.

Then import your own spritesheet with 

> https://crystal-clear-converter.netlify.app.

---

## Option 3: Using existing Sprites

Take any custom sprites and put them into a folder named like your character. Then use the correct naming schema (see [Sprite Naming & Dimensions](#sprite-naming--dimensions)).

Or put the assets in the correct position of the template from:

> <a target="_blank" href="https://crystal-clear-converter.netlify.app/template-gen1recomp.png">

<p align="center">
  <img width="30%" src="https://i.imgur.com/aOGaTzs.png">
  <img height="20%" src="https://i.imgur.com/ZpznmkK.png">
  <img width="20%" src="https://i.imgur.com/S5Tz8Wa.png">
  <img width="20%" src="https://i.imgur.com/ilGNNwE.png">
 
</p>

<p align="center">
   <img width="50%" src="https://i.imgur.com/jtI7nm1.jpeg">
</p>




## Sprite Naming & Dimensions

### Gen 1 / Gen 2 Distinction ###

Gen 1 sprites will use the suffix `_bw` - Gen 2 sprites will use the suffix `_color`.

### Walk / Overworld (`16x96px`)

This is the character you walk around with in the overworld.

 `walk` =>  `walk_bw.png` & `walk_color.png`

### Front / Trainer Card (`40x56px` or `56x56px`)

This is the image on the Trainer Card.

 `front` =>  `front_bw.png` & `front_color.png`

### Back / Battle (`48x48px` or `32x32px`)

This is the player sprite you see when starting a battle.

`back` =>  `back_bw.png` & `back_color.png`

### Fishing Sprites (`3 different files: 16x8px each`)

This is the player sprite when using a fishing rod (there is no rod in gen1recomp Gen 2).

Only changes the bottom half of your character.

`fish_side` =>  `fish_side_bw.png` & `fish_side_color.png`

`fish_front` =>  `fish_front_bw.png` & `fish_front_color.png`

`fish_back` =>  `fish_back_bw.png` & `fish_back_color.png`


### Cycling / Bike (`16x96px`)

This is the player sprite you see when using the bicycle.

 `bike` =>  `bike_bw.png` & `bike_color.png`

### Folder Structure

* To make the changes visible: close the game, remove the mod and install it again.


```
.
├── custom-player-sprite-switcher
│   ├── assets
│   │   ├── ash
│   │   │   ├── back_bw.png
│   │   │   ├── back_color.png
│   │   │   ├── bike_bw.png
│   │   │   ├── bike_color.png
│   │   │   ├── fish_back_bw.png
│   │   │   ├── fish_back_color.png
│   │   │   ├── fish_front_bw.png
│   │   │   ├── fish_front_color.png
│   │   │   ├── fish_side_bw.png
│   │   │   ├── fish_side_color.png
│   │   │   ├── front_bw.png
│   │   │   ├── front_color.png
│   │   │   ├── walk_bw.png
│   │   │   └── walk_color.png
│   │   ├── leaf
│   │   │   ├── back_bw.png
│   │   │   ├── back_color.png
│   │   │   ├── bike_bw.png
│   │   │   ├── bike_color.png
│   │   │   ├── fish_back_bw.png
│   │   │   ├── fish_back_color.png
│   │   │   ├── fish_front_bw.png
│   │   │   ├── fish_front_color.png
│   │   │   ├── fish_side_bw.png
│   │   │   ├── fish_side_color.png
│   │   │   ├── front_bw.png
│   │   │   ├── front_color.png
│   │   │   ├── walk_bw.png
│   │   │   └── walk_color.png

```
<!---

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

Additionally all 6 tile sprites extracted from the ROM are used.

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
-->
