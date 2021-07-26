#!/bin/bash

A script that I used once to add .zip game entry's to all gamelists from @DTEAM

wget -nv -O /tmp/gdrivedl.py https://raw.githubusercontent.com/matthuisman/gdrivedl/master/gdrivedl.py
python /tmp/gdrivedl.py https://drive.google.com/drive/folders/1f_jXMG0XMBdyOOBpz8CHM6AFj9vC1R6m -P /home/pi/Desktop/RetroPie-Share-main/00-gamelists-00
rm /tmp/gdrivedl.py
cd /home/pi/Desktop/RetroPie-Share-main/00-gamelists-00
find -name gamelist.xml | while read line
do 
#some only have .zip, some have only .7z, now we make them all equal with .7z
sed -i 's/\.zip/\.7z/g' $line
mv $line $line.bak
#remove the last line
cat $line.bak | head -n -1 >> $line
rm $line.bak
#add all zip entry's and don't add lines with ?xml and gameList
cat $line | grep -v ?xml | grep -v gameList | sed 's/\.7z/\.zip/' >> $line
#inster the last line again
echo "</gameList>" >> $line
done

