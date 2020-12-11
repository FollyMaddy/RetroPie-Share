#!/bin/bash

# Version : 1.3 alpha
#
# Author : @folly
# Date   : 08/12/2020
#
# Copyright 2020 @folly
#
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#--------------------------------------

# Get the options
while getopts ":h" option; do
   case $option in
      h) # display Help
         echo "options	:"
         echo "-h		this help "
         echo "<system>	choosen system to generate " 
         echo
         echo "Version	-->	1.3 alpha (testing, WIP)"
         echo "!!! BEWARE : USE TESTING NAME FOR RUNNING THE SCRIPT !!!"
         echo "!!! THIS VERSION TRIES TO USE RETROPIE NAMES IF A MATCH IS FOUND !!!"
         echo "Creator	-->	@folly"
         echo "Use	--> 	Create @valerino's alike lr-mess scripts for RetroPie-Setup" 
         echo "Dependancies"
         echo "--> MAME (install in RetroPie-Setup)"
         echo "--> @valerino's fork of RetroPie-Setup (https://github.com/valerino/RetroPie-Setup)"
         echo "======= extra information ======="
         echo "Run"
         echo "- generate for all systems: 		bash generate-lr-mess-systems.sh "
         echo "- generate only one system: 		bash generate-lr-mess-systems.sh <system> "
         echo "- batch generate only desired systems: 	bash generate-desired-systems.sh "
         echo "Example"
         echo "- generating only one system: 		generate-lr-mess-systems.sh fm77av "
         echo "Advise : create files not directly in the RetroPie-Setup use copy and paste"
         echo "If you want to create the scripts directly in RetroPie-Setup,"
         echo "place and run the script from this directory"
         echo "/home/pi/RetroPie-Setup"
         echo "MAME commands"
         echo "- help"
         echo "/opt/retropie/emulators/mame/mame -h "
         echo "- get system names in a textfile"
         echo "/opt/retropie/emulators/mame/mame -listdevices | grep Driver > possiblesystems.txt "
         echo "- check for compatible media"
         echo "/opt/retropie/emulators/mame/mame -listmedia | grep <system> "
         echo "!!! systems that use no media (<none>) will not or cannot be created !!!"
         exit;;
   esac
done


echo start
date

#mess arrays
systems=(); uniquesystems=(); mediadescriptions=(); media=(); extensions=(); allextensions=(); descriptions=()

#retropie arrays
systemsrp=(); descriptionsrp=()

#create new array while matching
newsystems=()

#filter out column names and <none> media
namesfilter="\(brief|------|\(none"

#filter on usefull media, otherwise we also get many unusefull scripts
mediafilter="prin\)|quik\)|\(memc|\(rom1|\(cart|\(flop|\(cass|dump\)|cdrm\)"

#string for adding extra extensions in all generated scripts
addextensions=".zip .7z"


[[ -z "$1" ]] && echo "generating all possible files can take up to 35 minutes"


# read system(s)
while read LINE; do 
# check for "system" in line
# if "no sytem" in line place add the last value again, in the system array
if [[ -z $LINE ]]; then
systems+=( "${systems[-1]}" )
##echo ${systems[-1]} $LINE
else
# use the first column if seperated by a space
systems+=( "$(echo $LINE)" )
fi
done < <(/opt/retropie/emulators/mame/mame -listmedia $1 | grep -v -E "$namesfilter" | grep -E "$mediafilter" | cut -d " " -f 1)

date

echo "read system(s)"
unique=$(echo ${systems[@]} | tr ' ' '\n' | sort -u | tr '\n' ' ')
IFS=$' ' GLOBIGNORE='*' command eval  'uniquesystems=($(echo $unique))'
echo  "- got information for ${#uniquesystems[@]} unique system(s)"
echo  "- got information for creating ${#systems[@]} script file(s)"

date

echo "read all available extensions per system(s)"
for index in "${!systems[@]}"; do 
# export all supported media per system on unique base
allextensions+=( "$(/opt/retropie/emulators/mame/mame -listmedia ${systems[$index]} | grep -o "\...." | tr ' ' '\n' | sort -u | tr '\n' ' ')" )
#testline
#echo ${systems[$index]} ${allextensions[$index]}
done
#testline
#echo ${allextensions[@]} ${#allextensions[@]}

date

echo "read compatible extension(s) for the individual media"
index=0
while read LINE; do
# if any?, remove earlier detected system(s) from the line
substitudeline=$(echo $LINE | sed "s/${systems[$index]}//g")
# use the first column if seperated by a space
mediadescriptions+=( "$(echo $substitudeline | cut -d " " -f 1)" )
# use the third column if seperated by a space and remove ( ) characters and add - for media
media+=( "$(echo $substitudeline | cut -d " " -f 2 | sed s/\(/-/g | sed s/\)//g)" )
# use the second column if seperated by a ) character and cut off the first space
extensions+=( "$(echo $substitudeline | cut -d ")" -f 2 | cut -c 2-)" )
index=$(( $index + 1 ))
done < <(/opt/retropie/emulators/mame/mame -listmedia $1 | grep -v -E "$namesfilter" | grep -E "$mediafilter")

date

echo "read computer description(s)"
# keep the good info and delete text in lines ( "Driver"(cut), "system"(sed), "):"(sed) )
for index in "${!systems[@]}"; do descriptions+=( "$(/opt/retropie/emulators/mame/mame -listdevices ${systems[$index]} | grep Driver | sed s/$(echo ${systems[$index]})//g | cut -c 10- | sed s/\)\://g)" ); done

date

#read RetroPie system names and descriptions
#check for matches between mess and RetroPie descriptions
#when a match is found use the RetroPie system name instead
echo "read and match RetroPie names with lr-mess names"
while read LINE; do
# read retropie rom directory names 
systemsrp+=( "$(echo $LINE | cut -d '_' -f 1)" )
# read retropie full system names
#
#sed is used to turn off the name (PC => -PC-), 
#otherwise it has also matches with CPC ,PC Engine etc., for PC a solution still has to be found
#and change :
#(Atari Jaguar => Jaguar)
#(Mega CD => Mega-CD)
#(Sega 32X => 32X)
#(Commodore Amiga => Amiga)
#&
#also some "words" have to be filtered out :
#(ProSystem)
#otherwise we don't have matches for these systems
#
descriptionsrp+=( "$(echo $LINE | sed 's/\"PC\"/\"-PC-\"/g' | sed 's/Atari Jaguar/Jaguar/g' | sed 's/Mega CD/Mega-CD/g' | sed 's/Sega 32X/32X/g' | sed 's/Commodore Amiga/Amiga/g' | sed s/ProSystem//g | cut -d '"' -f 2)" )
done < <(cat /home/pi/RetroPie-Setup/platforms.cfg | grep fullname)

date

newsystems+=( "${systems[@]}" )
# use this in if function *${descriptionsrp[$rpindex]}* for match for a global match (containing parts)
# use this in if function "${descriptionsrp[$rpindex]}" for an exact match 

# test array to check the code 
#descriptionsrp=()
#descriptionsrp=("MSX" "Vectrex" "Atari 2600")
# end test array

# how many platforms in platforms.cfg
#echo ${#descriptionsrp[@]}

#platform PC is a bit tricky and should be checked the first time, if there is a second match
#the second match is probably the best match
# ??? have to find a solution for this ??? filter out or put in first index of array


  for messindex in "${!descriptions[@]}"; do
    for rpindex in "${!descriptionsrp[@]}"; do
      #create an empty array and split the the retropie name descriptions into seperate "words" in an array
      splitdescriptionsrp=()
      IFS=$' ' GLOBIGNORE='*' command eval  'splitdescriptionsrp=($(echo ${descriptionsrp[$rpindex]}))'
      #check if every "word" is in the mess name descriptions * *=globally , " "=exact, 
      #!!! exact matching does not work here, because many times you are matching 1 "word" against multiple "words" !!!
      if [[ "${descriptions[$messindex]}" == *${splitdescriptionsrp[@]}* ]]; then
        # If descriptions are exactly the same then use the system name of retropie as romdirectory
        # for the other arrays we use the mess information
        newsystems[$messindex]=${systemsrp[$rpindex]}
        echo "match - mess(description) - ${descriptions[$messindex]} -- rp(description) - ${descriptionsrp[$rpindex]}"
        echo "match - mess(romdir) - ${systems[$messindex]} -- rp(romdir) - ${newsystems[$messindex]} (RetroPie name is used)"
      fi
    done
  done


# test line total output
#for index in "${!systems[@]}"; do echo $index ${systems[$index]} -- ${newsystems[$index]} | more ; echo -ne '\n'; done
#  for index in "${!systems[@]}"; do
#      if [[ "${systems[$index]}" != "${newsystems[$index]}" ]]; then
#        echo "$index ${systems[$index]} => ${newsystems[$index]}"
#      fi
#  done


date


echo "generate and write the gen-lr-mess-<RPname>-<MESSname><-media>.sh script file(s)"
# put everything in a seperate directory
mkdir -p  scriptmodules/libretrocores 2>&-
# !!! .zip is manually added as extension in every generated script !!!
# used quotes in the next line, if there are spaces in the values of the arrays the file can not be generated, kept it in for debugging
for index in "${!systems[@]}"; do sleep 0.001; cat > "scriptmodules/libretrocores/gen-lr-mess-${newsystems[$index]}-${systems[$index]}${media[$index]}".sh << _EOF_
#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-mess-${newsystems[$index]}-${systems[$index]}${media[$index]}"
rp_module_name="${descriptions[$index]} with ${mediadescriptions[$index]} support"
rp_module_ext="$addextensions ${allextensions[$index]}"
rp_module_desc="MESS emulator (\$rp_module_name) - MESS Port for libretro"
rp_module_help="ROM Extensions: \$rp_module_ext\n
Above extensions are included for compatibility between different media installs.\n\n
ROM extensions only supported by this install:\n
$addextensions ${extensions[$index]}\n\n
Put games in:\n
\$romdir/${newsystems[$index]}\n\n
Put BIOS files in \$biosdir:\n
${systems[$index]}.zip\n
Note:\n
BIOS info is automatically generated,\n
but some systems don't need a BIOS file!\n\n"

rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/mame/master/LICENSE.md"
rp_module_section="exp"
rp_module_flags=""

function depends_lr-mess-${newsystems[$index]}-${systems[$index]}${media[$index]}() {
	local _mess=\$(dirname "\$md_inst")/lr-mess/mess_libretro.so
	if [[ ! -f "\$_mess" ]]; then
		printMsgs dialog "cannot find '\$_mess' !\n\nplease install 'lr-mess' package."
		exit 1
	fi
}

function sources_lr-mess-${newsystems[$index]}-${systems[$index]}${media[$index]}() {
	true
}

function build_lr-mess-${newsystems[$index]}-${systems[$index]}${media[$index]}() {
	true
}

function install_lr-mess-${newsystems[$index]}-${systems[$index]}${media[$index]}() {
	true
}

function configure_lr-mess-${newsystems[$index]}-${systems[$index]}${media[$index]}() {
	local _mess=\$(dirname "\$md_inst")/lr-mess/mess_libretro.so
	local _retroarch_bin="\$rootdir/emulators/retroarch/bin/retroarch"
	local _system="${newsystems[$index]}"
	local _config="\$configdir/\$_system/retroarch.cfg"
	local _add_config="\$_config.add"
	local _custom_coreconfig="\$configdir/\$_system/custom-core-options.cfg"
	local _script="\$scriptdir/scriptmodules/run_mess.sh"

	# create retroarch configuration
	ensureSystemretroconfig "\$_system"

	# ensure it works without softlists, using a custom per-fake-core config
    iniConfig " = " "\"" "\$_custom_coreconfig"
    iniSet "mame_softlists_enable" "disabled"
	iniSet "mame_softlists_auto_media" "disabled"
	iniSet "mame_boot_from_cli" "disabled"

	# this will get loaded too via --append_config
	iniConfig " = " "\"" "\$_add_config"
	iniSet "core_options_path" "\$_custom_coreconfig"
	#iniSet "save_on_exit" "false"

	# set permissions for configurations
 	chown \$user:\$user "\$_custom_coreconfig" 
 	chown \$user:\$user "\$_add_config" 

	# setup rom folder # edit newsystem RetroPie name
	mkRomDir "\$_system"

	# ensure run_mess.sh script is executable
	chmod 755 "\$_script"

	# add the emulators.cfg as normal, pointing to the above script # use old mess name for booting
	addEmulator 1 "\$md_id" "\$_system" "\$_script \$_retroarch_bin \$_mess \$_config \\${systems[$index]} \$biosdir ${media[$index]} %ROM%"

	# add system to es_systems.cfg as normal
	addSystem "\$_system" "\$md_name" "\$md_ext"
}

_EOF_

done

date
echo stop

