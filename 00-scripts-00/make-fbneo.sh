#!/bin/bash

#install crc32 if not installed
if [[ ! -f /usr/bin/crc32 ]];then
	echo "crc32 is missing installing libarchive-zip-perl"
	sudo apt install libarchive-zip-perl
fi

echo "Do you want to make merged roms (y) / split roms (n) ? (y/n)"
read choice
#make the directory fbneo_zips inside the rom directory
mkdir fbneo_zips 2>&-
#list only the roms you want to convert and use every file to automate things
ls -w1 *.rom|grep -v coleco.rom|grep -v colecoa.rom|grep -v cczz50.rom|grep -v svi.rom|while read romfile
do 
	#get the crc32 of the rom
	crc32=$(crc32 "$romfile")
	#read the fbneo name from the dat using the crc32 if there is a match, with no match the string becomes empty
	#it will list 5 lines back from finding the correct crc32 so the fbneo name can be extracted
	#the fbneo name is used for the name of the created zip file
	fbneo_name=$(cat '/opt/retropie/libretrocores/lr-fbneo/dats/FinalBurn Neo (ClrMame Pro XML, ColecoVision only).dat'|grep -B 5 $crc32|grep "game name"| cut -d '"' -f 2)
	#check if it isn't empty and output all the data and create the zip file
	echo
	if [[ -n "$fbneo_name" ]];then
		echo create fbneo_zips/$fbneo_name.zip with $romfile which has the crc32 $crc32
		#remove zip file if existing and create a new one
		rm "fbneo_zips/$fbneo_name.zip" 2>&-
		if [[ $choice == y ]];then
			#make merged fbneo roms (coleco roms are inside the zip file)
			zip "fbneo_zips/$fbneo_name.zip" "$romfile" coleco.rom colecoa.rom czz50.rom svi603.rom
		else
			#make split fbneo roms (coleco roms are NOT inside the zip file)
			zip "fbneo_zips/$fbneo_name.zip" "$romfile"
		fi
	else
		if [[ $romfile != coleco.rom && $romfile != colecoa.rom && $romfile != czz50.rom && $romfile != svi603.rom ]];then
			echo "$romfile has not been found, no zip file created"
		fi
	fi
#until every file is done
done
 
