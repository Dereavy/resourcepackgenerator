#!/bin/bash
# BatchWatermark
#Shell script that applies a batch of ingredients to their respective random pizza bases.

## Description:
# Creates a resource pack from the blocks folder.


## Instructions:
#  - Drag script in a folder of your choice
#  - Run the script, I use the Windows Subsystem for Linux (WSL) command prompt.
#  - The script should generate 2 files: Memes and Blocks.
#  - Place your memes in Memes
#  - Copy your blocks images into the Blocks folder
#  - Run the script a second time, it should replace your blocks with memes.
  
## Dependencies:
# Requires Imagemagick https://imagemagick.org/script/download.php



# Path of the folder containing the script:
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
	PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

	# Size of the side of the textures
	S=256
	DATE=`date +%d-%m-%Y_%H-%M-%S`
	NEWBLOCKS=$DIR"/Images"
	BLOCKS=$DIR"/Blocks"
	CONVERTEDBLOCKS=$DIR"/resized/Blocks${S}"
	CONVERTEDNEWBLOCKS=$DIR"/resized/Images${S}"
	BACKGROUND=$DIR"/background.png"
	read -t 50 -p "Name of the new pack? (No spaces)" NAME
	NAME="${NAME}"
	PACK=$DIR"/ResourcePacks/${NAME}${S}px${DATE}"
	ASSETS=$PACK"/assets/minecraft/textures/blocks"
	MCMETA=$PACK
	
	INITIALISED=true
	

	
# Create folder to get the Blocks images, used as backgrounds in case of transparency issues.
	if [ ! -d $BLOCKS ]; then
	  mkdir -p $BLOCKS;
	  $INITIALISED = false
	fi
	
# Create folder to place the images you wish to use for the new blocks.
	if [ ! -d $NEWBLOCKS ]; then
	  mkdir -p $NEWBLOCKS;
	  $INITIALISED = false
	fi
	
# Create folder to keep the converted blocks. 
	if [ ! $INITIALISED ]; then
		exit 0
	fi
	
# Create folder to place the new textures.
	if [ ! -d $ASSETS ]; then
	  mkdir -p $ASSETS;
	  $INITIALISED = false
	fi
# Create folder to keep the converted resized blocks. 
		if [ ! -d $CONVERTEDBLOCKS ]; then
	  mkdir -p $CONVERTEDBLOCKS;
	  $INITIALISED = false
	fi
# Create folder to keep the converted resized images. 
		if [ ! -d $CONVERTEDNEWBLOCKS ]; then
	  mkdir -p $CONVERTEDNEWBLOCKS;
	  $INITIALISED = false
	fi
	
# Create folder to keep the converted blocks. 
	if [ ! $INITIALISED ]; then
		exit 0
	fi
	
# Create pack.mcmeta file:
#"pack_format" requires
    #1 in Java Edition 1.6[verify] - Java Edition 1.8,
    #2 in Java Edition 1.9 and Java Edition 1.10,
    #3 in Java Edition 1.11 and Java Edition 1.12,
    #4 in Java Edition 1.13 - Java Edition 1.15.
	
cat >$MCMETA"/pack.mcmeta" << MCMETA
{
   "pack": {
      "pack_format": 3,
      "description": "Created by Lezappens Random Resource Pack Generator"
   }
}
MCMETA
#I need to improve it so it moves used blocks to a used folder, and when there aren't any images left to use it moves the contents of the used folder back to the main one and repeats that way, there will be less duplicate images.
		# find -name "* *" -type f | rename 's/ /_/g'
		BLOCKLIST=$( find $BLOCKS -maxdepth 1 -type f \( -name "*.png" -o -name "*.PNG" -o -name "*.jpg" -o -name "*.JPG" \) )
		
		for BLOCK in $BLOCKLIST; do
		
			RANDOMNEWBLOCK=$( find $NEWBLOCKS -maxdepth 1 -type f \( -name "*.png" -o -name "*.PNG" -o -name "*.jpg" -o -name "*.JPG" \) | shuf -n 1) 
			BLOCKRESIZED=$CONVERTEDBLOCKS"/"$(basename $BLOCK)
			NEWBLOCKRESIZED=$CONVERTEDNEWBLOCKS"/"$(basename $RANDOMNEWBLOCK)
			FINISHEDNEWBLOCKIMAGE=$ASSETS"/"$(basename $BLOCK)
			echo "texture: "$(basename $BLOCK" : "$(basename $RANDOMNEWBLOCK))
			
					convert -resize ${S}x${S} $BLOCK -background none -gravity center -extent ${S}x${S} $BLOCKRESIZED
					convert -resize ${S}x${S} $RANDOMNEWBLOCK -background none -gravity center -extent ${S}x${S} $NEWBLOCKRESIZED
					composite -dissolve 100% -gravity center $NEWBLOCKRESIZED $BLOCKRESIZED $FINISHEDNEWBLOCKIMAGE
		done
		echo "Done!"

exit 0
