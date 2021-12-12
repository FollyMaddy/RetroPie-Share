 #!/bin/bash

 #option $1 is versio of mame, for example : 238
 if [[ -z $1 ]]&&[[ -f mame0$1_systems ]];then
 echo -> please and version of mame as option, for example : 238
 echo -> add file mame0xxx_systems, insert version in xxx
 else
 mkdir original-data
 
 progettosnaps_files="pS_category_ pS_CatVer_ pS_renameSET_ pS_version_"
 [[ -z $(ls original-data/) ]] && for file in $progettosnaps_files;do
 wget https://www.progettosnaps.net/renameset/packs/$file$1.zip
 mv $file$1.zip original-data
 done
 
 unzip -p original-data/pS_category_$1.zip folders/Bootlegs.ini >bootlegs.ini
 unzip -p original-data/pS_category_$1.zip folders/cabinets.ini >cabinets.ini
 unzip -p original-data/pS_category_$1.zip "folders/Clones Arcade.ini" >clones.ini
 unzip -p original-data/pS_category_$1.zip "folders/Mechanical Arcade.ini" >mechanical.ini
 unzip -p original-data/pS_category_$1.zip folders/monochrome.ini >monochrome.ini
 unzip -p original-data/pS_category_$1.zip folders/mess.ini >non-arcade.ini
 unzip -p original-data/pS_category_$1.zip folders/screenless.ini >screenless.ini
 unzip -p original-data/pS_category_$1.zip "folders/Working Arcade.ini" >working_arcade.ini
  
 unzip -p original-data/pS_version_$1.zip folders/version_NEW.ini >new0$1.ini
 
 #create more .ini files from category.ini
 #category.ini isn't saved as .ini, because the file is only used for extracting and creating other categories
 echo create more .ini category file from category.ini
 unzip -p original-data/pS_category_$1.zip folders/category.ini >category
 #create first categories
 cat category |sed 's/\r//g;s/[*]//g'|tail -n +9|while read line;do if [[ $line == "["* ]];then category=$(echo $line|sed 's/\[//g;s/\.//g;s/\/.*\]//g;s/\s*$//;s/ /_/g;s/\&/and/g;s/Arcade/Pinball_Arcade/g'|tr '[:upper:]' '[:lower:]');fi;if [[ $line != "["* ]];then echo $line>>$category.ini;fi;done
 #create second categories
 #a few special charachters are filetered out in the beginning with ;s/[)[]*] => didn't work with '(' ) so this one is added later
 cat category |sed 's/\r//g;s/(//g;s/)//g;s/[[]*]//g'|tail -n +9|while read line;do if [[ $line == "["* ]];then category=$(echo $line|sed 's/\.//g;s/.*\///g;s/\s*$//;s/ /_/g;s/_-_/_/g;s/\&/and/g;1s/^.//'|tr '[:upper:]' '[:lower:]');fi;if [[ $line != "["* ]];then echo $line>>$category.ini;fi;done
 
 #create more .ini files from cabinets.ini (first and second parts combined)
 cat cabinets.ini |sed 's/\r//g;s/(//g;s/)//g;s/[,*]//g'|tail -n +9|while read line;do if [[ $line == "["* ]];then cabinets=$(echo $line|sed 's/\[//g;s/\.//g;s/\/.*\]//g;s/\s*$//;s/ /_/g;s/\&/and/g;s/\]//g'|tr '[:upper:]' '[:lower:]');fi;if [[ $line != "["* ]];then echo $line>>$cabinets.ini;fi;done
 
 #remove duplicates
 mv cabinets.ini cabinets;awk '!a[$0]++' cabinets >cabinets.ini;rm cabinets
 
 #add all search patterns from all .ini files to the data file
 #rename mame0xxx_systems to mame0xxx_systems_sorted_info
 mv mame0$1_systems mame0$1_systems_sorted_info
 #add one space behind each driver line (do this only one time !) :
 sed -i 's/)\:/)\: /g' mame0$1_systems_sorted_info
 #add or append more entry's, if there is already a space behing the pattern "): " :
 for file in $(ls -r *.ini);do echo busy with $file;cat $file |sed 's/\r//g'|while read line;do grep -i "Driver $line " mame0$1_systems_sorted_info|sed -i "s/Driver $line .*)\: /&@$(basename $file .ini)/" mame0$1_systems_sorted_info ;done;done

 #NOT NEEDED ANYMORE
 #check for doubles 
 #for file in $(ls -r *.ini);do cat mame0238_systems_sorted_info|grep @$(basename $file .ini)@$(basename $file .ini);done
 #
 #check for triples
 #for file in $(ls -r *.ini);do cat mame0238_systems_sorted_info|grep @$(basename $file .ini)@$(basename $file .ini)@$(basename $file .ini);done
 #
 #remove doubles multiple times (for now a fast and dirty solution only for @cabinets, should be done in the beginning with uniq or splitted up just like with category.ini ! )
 ##echo remove doubles
 ##for file in $(ls -r *.ini);do sed -i "s/@$(basename $file .ini)@$(basename $file .ini)/@$(basename $file .ini)/g" mame0$1_systems_sorted_info;done
 ##for file in $(ls -r *.ini);do sed -i "s/@$(basename $file .ini)@$(basename $file .ini)/@$(basename $file .ini)/g" mame0$1_systems_sorted_info;done
 ##for file in $(ls -r *.ini);do sed -i "s/@$(basename $file .ini)@$(basename $file .ini)/@$(basename $file .ini)/g" mame0$1_systems_sorted_info;done
 
 #add this 0229 manually
 #Driver tbaskb (Electronic Basketball (Tandy)): @classich@electronic_game@handheld@non-arcade
 fi
