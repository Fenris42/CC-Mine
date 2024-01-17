# CC Mine
 A mining turtle script for Minecraft mod [CC: Tweaked](https://www.curseforge.com/minecraft/mc-mods/cc-tweaked)
 
![thumbnail](https://github.com/Fenris42/CC-Mine/assets/133166853/35a4010c-3932-4028-90a2-5e0b83a1faf9)

## Features:
- Mines in a 3x3 block pattern
- Ore blocks on tunnel walls are opportunistically mined
- Places a torch every 10 blocks
- Floor and wall patching when required using cobblestone
- Flooding detection in case you tunnel into a body of water or lava
- Configurable junk filtering from inventory so you only bring back what you want
- Return to start position when inventory is full, out of fuel or tunnel flooding detected

## Use:
- Place mining turtle facing the wall in what would be the bottom center block of tunnel
- Place a stack of fuel in inventory (either coal or charcoal)
- Optional: Place a stack of torches in inventory
- Start program by typing command and hit enter ```mine```
- When turtle is done mining it will return to its starting position with a report
- Recommend placing so there is a 2 block wide wall between tunnels

## Installation:
![Capture](https://github.com/Fenris42/CC-Mine/assets/133166853/37deb01d-e7c1-495b-bc46-0bcc1f18a668)

### Preparation:
- Download mine.lua from [Latest Release](https://github.com/Fenris42/CC-Mine/releases)
- In game, craft the following:
  - [Mining turtle](https://computercraft.info/wiki/Turtle#Recipes)
  - [Computer](https://computercraft.info/wiki/Computer)
  - [Disk drive](https://computercraft.info/wiki/Disk_Drive)
  - [Floppy disk](https://computercraft.info/wiki/Floppy_Disk)
- Place disk drive
- Place computer on top of disk drive
- Place mining turtle directly to the left or right of disk drive
- Right click disk drive and put floppy disk into disk drive slot

### Method 1: Access to World folder (single player or server host)
- Right click computer
- Type command and hit enter ```edit disk/mine.lua```
- Press CTRL key
- Select Save using arrow keys
- Press Enter key
- Press Escape key to exit
- A local directory in world folder has now been created
- Locate your World folder and go to computercraft/disk folder
- Folders numbered 0 and up will be here. These are the ID numbers of all the floppy disks in the world
- Find the folder that contains mine.lua. This is the floppy disk created earlier
- Replace mine.lua file in this folder with downloaded mine.lua file
- Script is now saved to floppy disk

### Method 2: No access to World folder (public server)
- Open downloaded mine.lua file with notepad
- Select all - > Copy
- Go to [Pastebin](https://pastebin.com/)
- Paste script in "New Paste" box
- Scroll down and set "Paste Exposure" to Public
- Scroll down and click "Create New Paste"
- URL will change to something like: "https://pastebin.com/6ypm2hBq"
- Copy the code after "https://pastebin.com/" in this case "6ypm2hBq"
- In game right click computer
- Type command and hit enter ```pastebin get code disk/mine.lua``` (replacing code with the pastebin code)
  - Ex: ```pastebin get 6ypm2hBq disk/mine.lua```
- Script is now saved to floppy disk

### Installing program to mining turtle:
- In game, right click mining turtle
- Type command and hit enter ```copy disk/mine.lua mine```
- Script is now installed to this mining turtle
- Repeat for each mining turtle you wish to use
  - Note: Make sure to place new turtles next to disk drive for copy command to work
