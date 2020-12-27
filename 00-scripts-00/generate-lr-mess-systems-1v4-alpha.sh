#!/bin/bash

#
# Author : @folly
# Date   : 27/12/2020
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
         echo "Version	-->	$0 (testing, WIP)"
         echo "!!! THIS VERSION GENERATES @VALAERINO ALIKE SCRIPTS AND ORIGINAL LR-MESS COMMAND SCRIPTS !!!"
         echo "!!! WHILE DOING THIS, IT TRIES TO USE RETROPIE NAMES IF A MATCH IS FOUND !!!"
         echo "!!! IT ALSO ADDS NEW RETROPIE PLATFORM NAMES, USED BY THE @DTEAM HANDHELD TUTORIAL !!!"
         echo "Creator	-->	@folly"
         echo "Dependancies"
         echo "--> MAME (install in RetroPie-Setup)"
         echo "--> @valerino's fork of RetroPie-Setup (https://github.com/valerino/RetroPie-Setup)"
         echo "======= extra information ======="
         echo "Run"
         echo "- generate for all systems: 		bash $0 "
         echo "- generate only one system: 		bash $0 <system> "
         echo "- batch generate only desired systems: 	bash generate-desired-systems.sh "
         echo "Example"
         echo "- generating only one system: 		$0 fm77av "
         echo "- generating konamih cmd script:	$0 kgradius "
         echo "(creating this can be done with one game)(a cmd script can be used for more konamih games !)"
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
namesfilter="\(brief|------"

#filter on usefull media, otherwise we also get many unusefull scripts
mediafilter="none\)|prin\)|quik\)|\(memc|\(rom1|\(cart|\(flop|\(cass|dump\)|cdrm\)"

#string for adding extra extensions in all generated scripts
addextensions=".zip .7z"

#string for adding extra extensions in all generated command scripts
addextensionscmd=".cmd"

#string for adding mame/mess config options, this doesn't seem to work in the generated command scripts
messcfgoptions="-autoframeskip"

#array data for system names of "handhelds" that cannot be detected or matched with the mame database
#systems that cannot be detected (all_in1, classich, konamih, tigerh) (*h is for handheld)
#systems that can be detected (jakks, tigerrz), these added later in the script for normal matching
#a system that can be detected (gameandwatch), already in RetroPie naming for normal matching
#using @DTEAM naming for compatibitity with possible existing es-themes
#hoping this will be the future RetroPie naming for these handhelds
all_in1=( "ablmini" "ablpinb" "bittboy" "cybar120" "dgun2573" "dnv200fs" "fapocket" "fcpocket" "fordrace" "gprnrs1" "gprnrs16" "ii32in1" "ii8in1" "intact89" "intg5410" "itvg49" "lexiseal" "lexizeus" "lx_jg7415" "m505neo" "m521neo" "majkon" "mc_105te" "mc_110cb" "mc_138cb" "mc_7x6ss" "mc_89in1" "mc_8x6cb" "mc_8x6ss" "mc_9x6ss" "mc_aa2" "mc_cb280" "mc_dcat8" "mc_dg101" "mc_dgear" "mc_hh210" "mc_sam60" "mc_sp69" "mc_tv200" "megapad" "mgt20in1" "miwi2_7" "mysprtch" "mysprtcp" "mysptqvc" "njp60in1" "oplayer" "pdc100" "pdc150t" "pdc200" "pdc40t" "pdc50" "pjoyn50" "pjoys30" "pjoys60" "ppgc200g" "react" "reactmd" "rminitv" "sarc110" "sudopptv" "sy888b" "sy889" "techni4" "timetp36" "tmntpdc" "unk1682" "vgcaplet" "vgpmini" "vgpocket" "vjpp2" "vsplus" "zdog" "zone7in1" "zudugo" "namcons1" "namcons2" "taitons1" "taitons2" "tak_geig" "namcons1" "namcons2" "taitons1" "taitons2" "tak_geig" "tomcpin" )
classich=( "alnattck" "alnchase" "astrocmd" "bambball" "bankshot" "bbtime" "bcclimbr" "bdoramon" "bfriskyt" "bmboxing" "bmsafari" "bmsoccer" "bpengo" "bultrman" "bzaxxon" "cdkong" "cfrogger" "cgalaxn" "cmspacmn" "cmsport" "cnbaskb" "cnfball" "cnfball2" "cpacman" "cqback" "ebaskb2" "ebball" "ebball2" "ebball3" "edracula" "efball" "egalaxn2" "einvader" "einvader2" "epacman2" "esoccer" "estargte" "eturtles" "flash" "funjacks" "galaxy2" "gckong" "gdigdug" "ghalien" "ginv" "ginv1000" "ginv2000" "gjungler" "h2hbaseb" "h2hbaskb" "h2hfootb" "h2hhockey" "h2hsoccerc" "hccbaskb" "invspace" "kingman" "machiman" "mcompgin" "msthawk" "mwcbaseb" "packmon" "pairmtch" "pbqbert" "phpball" "raisedvl" "rockpin" "splasfgt" "splitsec" "ssfball" "tbaskb" "tbreakup" "tcaveman" "tccombat" "tmpacman" "tmscramb" "tmtennis" "tmtron" "trshutvoy" "trsrescue" "ufombs" "us2pfball" "vinvader" )
konamih=( "kbilly" "kblades" "kbucky" "kcontra" "kdribble" "kgarfld" "kgradius" "kloneran" "knfl" "ktmnt" "ktopgun" )
tigerh=( "taddams" "taltbeast" "tapollo13" "tbatfor" "tbatman" "tbatmana" "tbtoads" "tbttf" "tddragon" "tddragon3" "tdennis" "tdummies" "tflash" "tgaiden" "tgaunt" "tgoldeye" "tgoldnaxe" "thalone" "thalone2" "thook" "tinday" "tjdredd" "tjpark" "tkarnov" "tkazaam" "tmchammer" "tmkombat" "tnmarebc" "topaliens" "trobhood" "trobocop2" "trobocop3" "trockteer" "tsddragon" "tsf2010" "tsfight2" "tshadow" "tsharr2" "tsjam" "tskelwarr" "tsonic" "tsonic2" "tspidman" "tstrider" "tswampt" "ttransf2" "tvindictr" "twworld" "txmen" "txmenpx" )

#platform config lines systems that are not in the platform.cfg (no strings, read the same way as info from platform.cfg)
#tigerh_exts=".7z .cue .fba .iso .zip .cdi .chd .gdi .sh"
#tigerh_fullname="Tiger Handheld Electronics"
#
#tigerrz_exts=".7z .cue .fba .iso .zip .cdi .chd .gdi .sh"
#tigerrz_fullname="Tiger R-Zone"
#
#jakks_exts=".7z .cue .fba .iso .zip .cdi .chd .gdi .sh"
#jakks_fullname="JAKKS Pacific TV Games"
#
#konamih_exts=".7z .cue .fba .iso .zip .cdi .chd .gdi .sh"
#konamih_fullname="Konami Handheld"
#
#all_in1_exts=".7z .cue .fba .iso .zip .cdi .chd .gdi .sh"
#all_in1_fullname="All in One Handheld and Plug and Play"
#
#classich_exts=".mgw .7z"
#classich_fullname="Classic Handheld Systems"


[[ -z "$1" ]] && echo "generating all possible files will probably take hours ! (press ctrl+c to stop)"


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
echo  "- detected ${#uniquesystems[@]} unique mess system type(s)"
echo  "- cannot calculate the amound of generating possible scripts now"

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
#(Game and Watch => Game & Watch) , (and => &)
#&
#also some "words" have to be filtered out :
#(ProSystem)
#otherwise we don't have matches for these systems
#
descriptionsrp+=( "$(echo $LINE | sed 's/\"PC\"/\"-PC-\"/g' | sed 's/Atari Jaguar/Jaguar/g' | sed 's/Mega CD/Mega-CD/g' | sed 's/Sega 32X/32X/g' | sed 's/Commodore Amiga/Amiga/g' | sed 's/ and / \& /g' | sed 's/ProSystem//g' | cut -d '"' -f 2)" )
done < <(cat /home/pi/RetroPie-Setup/platforms.cfg | grep fullname)


# add extra possible future RetroPie names
#!!! this name not used by @DTEAM in Handheld tutorial !!! <=> can't extract "konamih" and "tigerh" from mame database, for now
systemsrp+=( "handheld" ) # can be overruled by added @DTEAM name changing
descriptionsrp+=( "handheld" ) # can be overruled by added @DTEAM name changing
#name used by @DTEAM in Handheld tutorial <=> can extract "jakks" from mame database
systemsrp+=( "jakks" )
descriptionsrp+=( "JAKKS" )
#name used by @DTEAM in Handheld tutorial <=> can extract "tigerrz" from mame database
systemsrp+=( "tigerrz" )
descriptionsrp+=( "R-Zone" )
#testlines
#echo ${systemsrp[@]}
#echo ${descriptionsrp[@]}


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


date


#check multiple handheld games to inject naming used by @DTEAM in the Handheld tutorial
#insert unknown newsystems for different handhelds (all_in1)
  for messindex in "${!systems[@]}"; do
    for hhdataindex in "${!all_in1[@]}"; do
      #compare array game names with the mess systems ( * *=globally , " "=exact ) 
      if [[ "${systems[$messindex]}" == "${all_in1[$hhdataindex]}" ]]; then
        # If descriptions are exactly the same then use the system name of retropie as romdirectory
        # for the other arrays we use the mess information
        newsystems[$messindex]=all_in1
        echo "Now using pseudo RetroPie systemname for ${systems[$messindex]} becomes ${newsystems[$messindex]}"
      fi
    done
  done
#insert unknown newsystems for different handhelds (classich)
  for messindex in "${!systems[@]}"; do
    for hhdataindex in "${!classich[@]}"; do
      #compare array game names with the mess systems ( * *=globally , " "=exact ) 
      if [[ "${systems[$messindex]}" == "${classich[$hhdataindex]}" ]]; then
        # If descriptions are exactly the same then use the system name of retropie as romdirectory
        # for the other arrays we use the mess information
        newsystems[$messindex]=classich
        echo "Now using pseudo RetroPie systemname for ${systems[$messindex]} becomes ${newsystems[$messindex]}"
      fi
    done
  done
#insert unknown newsystems for different handhelds (konamih)
  for messindex in "${!systems[@]}"; do
    for hhdataindex in "${!konamih[@]}"; do
      #compare array game names with the mess systems ( * *=globally , " "=exact ) 
      if [[ "${systems[$messindex]}" == "${konamih[$hhdataindex]}" ]]; then
        # If descriptions are exactly the same then use the system name of retropie as romdirectory
        # for the other arrays we use the mess information
        newsystems[$messindex]=konamih
        echo "Now using pseudo RetroPie systemname for ${systems[$messindex]} becomes ${newsystems[$messindex]}"
      fi
    done
  done
#insert unknown newsystems for different handhelds (tigerh)
  for messindex in "${!systems[@]}"; do
    for hhdataindex in "${!tigerh[@]}"; do
      #compare array game names with the mess systems ( * *=globally , " "=exact ) 
      if [[ "${systems[$messindex]}" == "${tigerh[$hhdataindex]}" ]]; then
        # If descriptions are exactly the same then use the system name of retropie as romdirectory
        # for the other arrays we use the mess information
        newsystems[$messindex]=tigerh
        echo "Now using pseudo RetroPie systemname for ${systems[$messindex]} becomes ${newsystems[$messindex]}"
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


# "gen" in front of the filename is used for distinquish the files from others in the directory
# in the script everything else starts with "lr-*" for (future) compatibility with runcommand.sh 
# (perhaps adding the future abitity of loading game specific retroarch configs)
echo "generate and write the gen-lr-mess-<RPname>-<MESSname><-media>.sh script file(s)"
# put everything in a seperate directory
mkdir -p  scriptmodules/libretrocores 2>&-
# !!! .zip is manually added as extension in every generated script !!!
# used quotes in the next line, if there are spaces in the values of the arrays the file can not be generated, kept it in for debugging
for index in "${!systems[@]}"; do sleep 0.001; [[ -n ${allextensions[$index]} ]] && cat > "scriptmodules/libretrocores/gen-lr-mess-${newsystems[$index]}-${systems[$index]}${media[$index]}".sh << _EOF_
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
        iniSet "mame_mouse_enable" "enabled"

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
	addEmulator 1 "\$md_id" "\$_system" "\$_script \$_retroarch_bin \$_mess \$_config \\${systems[$index]} \$biosdir $messcfgoptions ${media[$index]} %ROM%"

	# add system to es_systems.cfg as normal
	addSystem "\$_system" "\$md_name" "\$md_ext"
}

_EOF_

done


# the none media mess system types have no extensions in the mame database
# in order to switch between emulators at retropie rom boot
# we have to add these extensions
# otherwise extensions supported by other emulators will not be shown anymore


# "cmd" (command) in front of the filename is used for distinquish the files from others in the directory
# in the script everything else starts with "lr-*" for compatibility with runcommand.sh 
# (already possible, loading game specific retroarch configs)(for example configs for overlays)
echo "generate and write the cmd-lr-mess-<RPname>.sh command script file(s)"
# put everything in a seperate directory
mkdir -p  scriptmodules/libretrocores 2>&-
# !!! .zip is manually added as extension in every generated script !!!
# used quotes in the next line, if there are spaces in the values of the arrays the file can not be generated, kept it in for debugging
# grep function is used to get all extensions compatible with all possible emulation methods so switching within emulationstation is possible
# grep searches in both platform.cfg and this script ($0) , so also extensions are added that are not in platform.cfg 
# using grep this way can create double extension, but this should not be a problem
for index in "${!newsystems[@]}"; do sleep 0.001; platformextensionsrp=$(grep ${newsystems[$index]}_exts /home/pi/RetroPie-Setup/platforms.cfg $0 | cut -d '"' -f 2); cat > "scriptmodules/libretrocores/cmd-lr-mess-${newsystems[$index]}".sh << _EOF_
#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#


rp_module_id="lr-mess-${newsystems[$index]}-cmd"
rp_module_name="${newsystems[$index]} with command and game-BIOS support"
rp_module_ext="$addextensionscmd $addextensions ${allextensions[$index]}$platformextensionsrp"
rp_module_desc="MESS emulator - MESS Port for libretro"
rp_module_help="ROM Extensions: \$rp_module_ext\n
Above extensions are included for compatibility between different media installs.\n\n
ROM extensions only supported by this install:\n
$addextensionscmd $addextensions ${extensions[$index]}\n\n
Put games or *game-BIOS files in (* for handhelds ...):\n
\$romdir/${newsystems[$index]}\n
Note ! : with this setup, multiple mess system types can be run.\n
So no specific BIOS info can be given.\n
Put BIOS files in \$biosdir\n
When using game-BIOS files, no BIOS is needed in the BIOS directory.\n"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/mame/master/LICENSE.md"
rp_module_section="exp"
rp_module_flags=""

function depends_lr-mess-${newsystems[$index]}-cmd() {
	local _mess=\$(dirname "\$md_inst")/lr-mess/mess_libretro.so
	if [[ ! -f "\$_mess" ]]; then
		printMsgs dialog "cannot find '\$_mess' !\n\nplease install 'lr-mess' package."
		exit 1
	fi
}

function sources_lr-mess-${newsystems[$index]}-cmd() {
	true
}

function build_lr-mess-${newsystems[$index]}-cmd() {
	true
}


function install_lr-mess-${newsystems[$index]}-cmd() {
	true
}


function configure_lr-mess-${newsystems[$index]}-cmd() {
    local _retroarch_bin="\$rootdir/emulators/retroarch/bin/retroarch"
    local _mess=\$(dirname "\$md_inst")/lr-mess/mess_libretro.so
    local _system="${newsystems[$index]}"
    local _config="\$configdir/\$_system/retroarch.cfg"
    mkRomDir "\$_system"
    ensureSystemretroconfig "\$_system"
    addEmulator 1 "\$md_id" "\$_system" "\$_retroarch_bin --config \$_config -v -L \$_mess %ROM%"
    # add system to es_systems.cfg as normal
    addSystem "\$_system" "\$md_name" "\$md_ext"
}

_EOF_

done


date
echo stop

