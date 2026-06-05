# Instructions

## Purpose
The purpose of this project is for anyone to be able to view their own Sega Master System drawings running on real hardware. It's also a glimpse at all of the compenents needed in order to get simple background graphics running on the SMS. Think of this as your Z80 assembly "Hello World" for the SMS. 

## Prequisite Downloads

### Hard Requirements

#### WLA DX
This is the only hard requirement for this project, and since I'm not the one who developed it, I will leave you with a link to WLA DX instead:

https://github.com/vhelin/wla-dx

This is the assembler for our Hello World project. You'll need this in order to turn your code into a ROM. I've supplied Tasks for VS Code, so if you use VS Code, then you'll be able to use those tasks to get WLA DX running and exporting properly as long as your folder pathing is consistent with the tasks and scripts I wrote. Make sure that you are using the proper version of WLA DX for your operating system (Windows or Linux).


### Strongly Recommended

#### Emulicious
This is far and away the best Emulator for debugging the SMS, at least in my opinion. I won't stop you from using other emulators, but you'll have to adjust the scripts if you wish to use something else, at least if you want the game to auto-launch when you assemble the code.

https://emulicious.net/

All you need to do in order to make this work with the current VS Code tasks is to add the emulicious.jar file into the Emulicious folder.

### Recommended for experimentation
If you just want to compile the code as-is, then you don't NEED these, but if you want to be able to display your own graphics, then I highly recommend these downloads as well. There are alternative methods for creating graphics, but this is what I recommend.

#### Aseprite
This is the best pixel art software for a number of reasons, but I understand that if you don't have it already, the $20 asking price might be a bit of a turn off. Unfortunately, since I don't have much experience with other pixel art software, I can't whole-heartidly recommend any alternatives, though I'll provide a free alternative method for exporting graphics below.

https://www.aseprite.org/

#### SMS/GG Graphics Exporter
This is the script I wrote for Aseprite in order to turn Aseprite drawings into code for the SMS or Game Gear. For the remainder of this tutorial, I will be referring to Aseprite and my Graphics Exporter script.

https://steelfinger-studios.itch.io/master-system-game-gear-graphics-exporter-for-aseprite

Just place the script into Aseprite's script folder and you can start exporting your own graphics into a format the SMS can read!

### Free Alternative Graphics Export method

#### GIMP & BMP2Tile
While GIMP can get the job done, I can't really recommend it. It'll work in a pinch. BMP2Tile on the other hand is a great piece of software by Maxim over at SMS Power! I used BMPT2Tile exclusively when developing Space Tonbow, and it works great, but (at least at the time of publishing this) doesn't support setting individual background tiles to use the sprite palette, have priority over sprites, or any of the software bits. But I was able to make an entire game using it, so it's a great alternative!

https://github.com/maxim-zhao/bmp2tile

## The Initial Assembley

### Step 1
Get the necessary WLA DX (You OS appropriate versions of wla-z80 and wlalink) files into the "Assembler" folder of this repository. I've made the folder for you, just make sure to put them into the folder. They should be correct already, but it may be worth double checking the scripts in the "Scripts" folder to make sure that the names match the WLA DX files that you have. 

### Step 2
The task won't run completely without Emulicious, so either change the task to call the emulator of your choice, or place your download of emulicious.jar in the "Emulicious" folder. You'll want to make sure you have Java installed as well, as Emulicious requires it. 

### Step 3
Open the project in VS Code. From here you'll be able to see all of the folders that contain all of the files for this project. Everything should be good to go from here.

### Step 4
In VS Code, pressing CRTL + SHIFT + B will cause the task to run. For this project that should cause WLA DX to assemble your project, and then open up the newly assembled ROM in Emulicious!

## Creating your own backgrounds

### Experimenting with different background
Included in this repository is a second set of unused Maps, Palettes and Tiles. Before making your own graphics, you might want to try and see if you can replace the Steelfinger Studios screen with the unused "helloWorld" set. This can be done by replacing the file references of the .INCLUDE lines of exampleScreen.asm (133, 139 & 145)with the file reference of the unused graphics data. If you can get that working, then you should be able to get your own graphics working too!

### Design your graphics
The SMS can handle up to 16 colors for background tiles, and has a resolution of 256x192 pixels. However, graphics are made up 448 tiles that can be flipped vertically and/or horizontally. Mathematically, that is fewer tiles than there are background map tiles, so some tiles will need to be reused in order to get a full screen's worth of graphics. 

The rest of this guide assumes the user to be using Aseprite with the SMS/GG Graphics Exporter, but the previously mentioned free versions should work if using uncompressed .inc files.

### Exporting your graphics
More detailed instructions on creating graphics can be found in the SMS/GG Graphics Exporter repository, but the basic idea is that you need your image to be using indexed color, and use only 16 colors in total. Tiles will automatically be set to the vertical, horizontal or diagonal mirror of themselves when exported. If you follow the exporter's prompts for generating the background map, you should be given 3 files: __Map.inc, __Pal.inc and __Tiles.inc.

As we did earlier, replace the file references of the .INCLUDE lines of exampleScreen.asm with the file reference of your new graphics data. Note that the file references are in reference to the current folder by default, so you may need to lead them with ../

### Viewing your graphics
Now you just need to reassemble your project and load up the ROM to see if it worked!

## Where to go from here?

From here, I highly recommend reading through the rest of the code in this repository. The overall structure is my own personal style, so if you think the organization of files and folders is weird, change it! Experiment! See if you can build something beyond this simple "Hello World" style program. This repository doesn't equip you with any sprite capability, but SMSPower.org has a lot resources, so if you aren't afraid of some reading, you should be able to figure it out! Good luck and happy learning!





