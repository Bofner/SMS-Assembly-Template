# Instructions

## Purpose
The purpose of this project is for anyone to be able to view their own Sega Master System drawings running on real hardware. It's also a glimpse at all of the compenents needed in order to get simple background graphics running on the SMS. Think of this as your Z80 assembly "Hello World" for the SMS. 

## Prequisite Downloads

### Hard Requirements

#### WLA DX
This is the only hard requirement for this project, and since I'm not the one who developed it, I will leave you with a link to WLA DX instead:

https://github.com/vhelin/wla-dx

This is the assembler for our Hello World project. You'll need this in order to turn your code into a ROM. I've supplied Tasks for VS Code, so if you use VS Code, then you'll be able to use those tasks to get the WLA DX running and exporting properly as long as your folder pathing is consistent with the tasks and scripts I wrote. 


### Strongly Recommended

#### Emulicious
This is far and away the best Emulator for debugging the SMS, at least in my opinion. I won't stop you from using other emulators, but you'll have to adjust the scripts if you wish to use something else, at least if you want the game to auto-launch when you assemble the code.

https://emulicious.net/


### Recommended for experimentation
If you just want to compile the code as-is, then you don't NEED these, but if you want to be able to display your own graphics, then I highly recommend these downloads as well. There are alternative methods for creating graphics, but this is what I recommend.

#### Aseprite
This is the best pixel art software in my opinion for a number of reasons, but I understand that if you don't have it already, the $20 asking price might be a bit of a turn off. Unfortunately, since I don't have much experience with other pixel art software, I can't whole-heartidly recommend any alternatives, though I'll provide a free alternative method for exporting graphics below.

https://www.aseprite.org/

#### SMS/GG Graphics Exporter
This is the script I wrote for Aseprite in order to turn Aseprite drawings into code for the SMS or Game Gear. For the remainder of this tutorial, I will be referring to Aseprite and my Graphics Exporter script.

https://steelfinger-studios.itch.io/master-system-game-gear-graphics-exporter-for-aseprite

### Free Alternative Graphics Export method

#### MS Paint & BMP2Tile
While MS Paint can get the job done, I can't really recommend it. It'll work in a pinch. BMP2Tile on the other hand is a great piece of software by Maxim over at SMS Power! I used exclusively when developing Space Tonbow, and it works great, but (at least at the time of publishing this) doesn't support setting individual background tiles to use the sprite palette, have priority over sprites, or any of the software bits. But I was able to make an entire game using it, so it's a great alternative!

https://github.com/maxim-zhao/bmp2tile

## The Initial Assembley

### Step 1
Get the necessary WLA DX files into the "WLADX" folder of this repo. I've made the folder for you, just make sure to put them int the folder. They should be correct already, but it may be worth double checking the scripts in the "scripts" folder to make sure that the names match the WLA DX files that you have. 

### Step 2
The scripts won't work without Emulicious, so either change the scripts to call the emulator of your choice, or place your download of emulicious in the "Emulicious" folder. You'll want to make sure you have Java installed as well, as Emulicious requires it. 

### Step 3
Open the project in VS Code. From here you'll be able to see all of the folders that contain all of the files for this project. Everything should be good to go from here.

### Step 4
In VS Code, pressing CRTL + SHIFT + B will cause the task to run. For this project that should cause WLA DX to assemble your project, and then open up the newly assembled ROM in Emulicious!

## Creating your own backgrounds
