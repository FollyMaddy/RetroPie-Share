if [[ -d "$HOME/RetroPie/roms/arduboy/ArduboyCollection-master" ]];then

if [[ -d "$HOME/RetroPie/roms/arduboy" ]];then
cd ~/RetroPie/roms/arduboy
find -name "* *" -type d|while read;do mv "$REPLY" $(echo $REPLY|sed 's/ /_/g');done
find -name "* *" -type f|while read;do mv "$REPLY" $(echo $REPLY|sed 's/ /_/g');done
fi

extract=("title=" "date=" "description=" "author=")
tag=("<name>" "<releasedate>" "<desc>" "<developer>")
endtag=("</name>" "</releasedate>" "</desc>" "</developer>")

echo '<?xml version="1.0"?>'
echo "<gameList>"

find -name game.ini|while read;do 
 echo "	<game>"
 echo "		<path>$(ls $(echo "$REPLY"|sed 's/game\.ini//g')*.hex 2>&1)</path>"
 [[ $(ls $(echo "$REPLY"|sed 's/game\.ini//g')*.png 2>&1) == *\.png ]] && echo "		<image>$(ls $(echo "$REPLY"|sed 's/game\.ini//g')*.png)</image>"
 [[ $(ls $(echo "$REPLY"|sed 's/game\.ini//g')*.PNG 2>&1) == *\.png ]] && echo "		<image>$(ls $(echo "$REPLY"|sed 's/game\.ini//g')*.PNG)</image>"
 cat $REPLY|while read line;do
  for x in  ${!extract[@]};do
  if [[ $line == ${extract[$x]}* ]];then 
  echo "		$(echo $line|sed "s/${extract[$x]}/${tag[$x]}/g")${endtag[$x]}"
  fi
  done
 done
 echo "		<genre>Handheld LCD</genre>"
 echo "	</game>"
done

echo '</gameList>'

fi
