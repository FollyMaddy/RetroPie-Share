#!/bin/bash

#
# Author : @folly
# Date   : 07/05/2021
#
# Copyright 2021 @folly
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

#about this project :
#i have created this project while i was busy with the RetroPie-setup fork from @valerino
#@valerino made modulescripts for systems running with lr-mess
#some systems were not created by @valerino so i created 2 myself
#while doing that, creating such a script was basically the same everytime
#that is why i made this script to automate this process
#
#it basically creates a virtual excel sheet in arrays from the mame command output, and injects this information in the scripts that are being generated
#
#i started this script for "lr-mess" but it's now also possible to do somewhat the same with "mame"
#because "mame" and "lr-mess" can be compile from the same mamedev source i use now the universal name "mamedev" in this script
#
#because mame is also added as emulator and because mame is using a different BIOS dir : /home/$user/RetroPie/BIOS/mame
#the lr-mess command is changed to use the same BIOS dir, so they can use the same bios files


#part 0 : define strings, arrays and @DTEAM handheld platform information

#we want to be able to paste this script into 'add-mamedev-systems.sh', the front-end module script, as a function 'run_generator_script'
#that way we don't have to update the same parts over and over again
#RetroPie-Setup uses $user to determine the user
#if $user is empty the script runs as standalone so $user has to be created
#if not, $user can be used from the RetroPie-Setup
#now we can also make a string that can activate automatic installation, of module-scripts, if the front-end module script is used
if [[ -z $user ]];then 
user=$(ls /home)
installation_after_generating=off
fi

#uncomment if the scriptmodules have to be created in the `ext` directory, it will use the normal directory if commented
#ext=/ext/RetroPie-Share

#mamedev arrays
systems=(); uniquesystems=(); mediadescriptions=(); media=(); extensions=(); allextensions=(); descriptions=()

#retropie arrays
systemsrp=(); descriptionsrp=()

#create new array while matching
newsystems=()

#filter out column names and <none> media
namesfilter="\(brief|------"

#filter on usefull media, otherwise we also get many unusefull scripts
mediafilter="none\)|prin\)|quik\)|\(memc|\(rom1|\(cart|\(flop|\(cass|dump\)|cdrm\)|\(hard1"

#string for adding extra extensions in all generated scripts
addextensions=".zip .7z"

#string for adding extra extensions in all generated command scripts
addextensionscmd=".cmd"

#array data for "game system names" of "handhelds" that cannot be detected or matched with the mamedev database
#systems that cannot be detected (all_in1, classich, konamih, tigerh) (*h is for handheld)
#systems that can be detected (jakks, tigerrz), these added later in the script for normal matching
#a system that can be detected (gameandwatch), already in RetroPie naming for normal matching
#using @DTEAM naming for compatibitity with possible existing es-themes
#hoping this will be the future RetroPie naming for these handhelds
all_in1=( "ablmini" "ablpinb" "bittboy" "cybar120" "dgun2573" "dnv200fs" "fapocket" "fcpocket" "fordrace" "gprnrs1" "gprnrs16" "ii32in1" "ii8in1" "intact89" "intg5410" "itvg49" "lexiseal" "lexizeus" "lx_jg7415" "m505neo" "m521neo" "majkon" "mc_105te" "mc_110cb" "mc_138cb" "mc_7x6ss" "mc_89in1" "mc_8x6cb" "mc_8x6ss" "mc_9x6ss" "mc_aa2" "mc_cb280" "mc_dcat8" "mc_dg101" "mc_dgear" "mc_hh210" "mc_sam60" "mc_sp69" "mc_tv200" "megapad" "mgt20in1" "miwi2_7" "mysprtch" "mysprtcp" "mysptqvc" "njp60in1" "oplayer" "pdc100" "pdc150t" "pdc200" "pdc40t" "pdc50" "pjoyn50" "pjoys30" "pjoys60" "ppgc200g" "react" "reactmd" "rminitv" "sarc110" "sudopptv" "sy888b" "sy889" "techni4" "timetp36" "tmntpdc" "unk1682" "vgcaplet" "vgpmini" "vgpocket" "vjpp2" "vsplus" "zdog" "zone7in1" "zudugo" "namcons1" "namcons2" "taitons1" "taitons2" "tak_geig" "namcons1" "namcons2" "taitons1" "taitons2" "tak_geig" "tomcpin" )
classich=( "alnattck" "alnchase" "astrocmd" "bambball" "bankshot" "bbtime" "bcclimbr" "bdoramon" "bfriskyt" "bmboxing" "bmsafari" "bmsoccer" "bpengo" "bultrman" "bzaxxon" "cdkong" "cfrogger" "cgalaxn" "cmspacmn" "cmsport" "cnbaskb" "cnfball" "cnfball2" "cpacman" "cqback" "ebaskb2" "ebball" "ebball2" "ebball3" "edracula" "efball" "egalaxn2" "einvader" "einvader2" "epacman2" "esoccer" "estargte" "eturtles" "flash" "funjacks" "galaxy2" "gckong" "gdigdug" "ghalien" "ginv" "ginv1000" "ginv2000" "gjungler" "h2hbaseb" "h2hbaskb" "h2hfootb" "h2hhockey" "h2hsoccerc" "hccbaskb" "invspace" "kingman" "machiman" "mcompgin" "msthawk" "mwcbaseb" "packmon" "pairmtch" "pbqbert" "phpball" "raisedvl" "rockpin" "splasfgt" "splitsec" "ssfball" "tbaskb" "tbreakup" "tcaveman" "tccombat" "tmpacman" "tmscramb" "tmtennis" "tmtron" "trshutvoy" "trsrescue" "ufombs" "us2pfball" "vinvader" "zackman" )
konamih=( "kbilly" "kblades" "kbucky" "kcontra" "kdribble" "kgarfld" "kgradius" "kloneran" "knfl" "ktmnt" "ktopgun" )
tigerh=( "taddams" "taltbeast" "tapollo13" "tbatfor" "tbatman" "tbatmana" "tbtoads" "tbttf" "tddragon" "tddragon3" "tdennis" "tdummies" "tflash" "tgaiden" "tgaunt" "tgoldeye" "tgoldnaxe" "thalone" "thalone2" "thook" "tinday" "tjdredd" "tjpark" "tkarnov" "tkazaam" "tmchammer" "tmkombat" "tnmarebc" "topaliens" "trobhood" "trobocop2" "trobocop3" "trockteer" "tsddragon" "tsf2010" "tsfight2" "tshadow" "tsharr2" "tsjam" "tskelwarr" "tsonic" "tsonic2" "tspidman" "tstrider" "tswampt" "ttransf2" "tvindictr" "twworld" "txmen" "txmenpx" )


#part 1 : prepair some things first
#for making it possible to save /ext/RetroPie-Share/platorms.cfg and the generated module-scripts
mkdir -p  /home/$user/RetroPie-Setup/ext/RetroPie-Share/scriptmodules/libretrocores 2>&-
chown -R $user:$user "/home/$user/RetroPie-Setup/ext/RetroPie-Share"
echo "install @valerino run_mess.sh script (the RusselB version)"
#get the run_mess.sh edited by RusselB
wget -q -nv -O /home/$user/RetroPie-Setup/scriptmodules/run_mess.sh https://raw.githubusercontent.com/FollyMaddy/RetroPie-Share/main/00-scriptmodules-00/run_mess.sh
#change ownership to normal user
chown $user:$user "/home/$user/RetroPie-Setup/scriptmodules/run_mess.sh"


#part 2 : platform config lines systems that are not in the platform.cfg (no strings, read the same way as info from platform.cfg)
cat >"/home/$user/RetroPie-Setup/ext/RetroPie-Share/platforms.cfg" << _EOF_
tigerh_exts=".7z .cue .fba .iso .zip .cdi .chd .gdi .sh"
tigerh_fullname="Tiger Handheld Electronics"

tigerrz_exts=".7z .cue .fba .iso .zip .cdi .chd .gdi .sh"
tigerrz_fullname="Tiger R-Zone"

jakks_exts=".7z .cue .fba .iso .zip .cdi .chd .gdi .sh"
jakks_fullname="JAKKS Pacific TV Games"

konamih_exts=".7z .cue .fba .iso .zip .cdi .chd .gdi .sh"
konamih_fullname="Konami Handheld"

all_in1_exts=".7z .cue .fba .iso .zip .cdi .chd .gdi .sh"
all_in1_fullname="All in One Handheld and Plug and Play"

classich_exts=".mgw .7z"
classich_fullname="Classic Handheld Systems"

bbcmicro_exts=".ssd"
bbcmicro_fullname="BBC Micro"

bbcmicro_exts=".ssd"
bbcmicro_fullname="BBC Master"
_EOF_

#change ownership to normal user
chown $user:$user "/home/$user/RetroPie-Setup/ext/RetroPie-Share/platforms.cfg"


#part 3 : turning off creating all scripts
#if this part is commented and no option is added while running this scripts, it is possible to generate all possible scripts
#because of the time it will consume, it is turned off in this part !
if [[ -z "$1" ]]; then 
echo -ne "\ngenerating all possible files is turned off\n"
exit
fi


#part 4 : extract system data to array
# read system(s) using "mame" to extract the data and add them in the systems array
# some things are filtered with grep
while read LINE; do 
# check for "system" in line
# an example output for the msx system hbf700p is :
#hbf700p          printout         (prin)     .prn  
#                 cassette         (cass)     .wav  .tap  .cas  
#                 cartridge1       (cart1)    .mx1  .bin  .rom  
#                 cartridge2       (cart2)    .mx1  .bin  .rom  
#                 floppydisk       (flop)     .dsk  .dmk  .d77  .d88  .1dd  .dfi  .hfe  .imd  .ipf  .mfi  .mfm  .td0  .cqm  .cqi 
# if no "sytem" in line place add the last value again, in the system array so it can be properly used in our script, we get this data structure :
#(systems)
# hbf700p          printout         (prin)     .prn  
# hbf700p          cassette         (cass)     .wav  .tap  .cas  
# hbf700p          cartridge1       (cart1)    .mx1  .bin  .rom  
# hbf700p          cartridge2       (cart2)    .mx1  .bin  .rom  
# hbf700p          floppydisk       (flop)     .dsk  .dmk  .d77  .d88  .1dd  .dfi  .hfe  .imd  .ipf  .mfi  .mfm  .td0  .cqm  .cqi 
if [[ -z $LINE ]]; then
systems+=( "${systems[-1]}" )
##echo ${systems[-1]} $LINE
else
# use the first column if seperated by a space
systems+=( "$(echo $LINE)" )
fi
done < <(/opt/retropie/emulators/mame/mame -listmedia $1 | grep -v -E "$namesfilter" | grep -E "$mediafilter" | cut -d " " -f 1)


#part 5 : extract all extension data per system to array
# an example output for the msx system hbf700p is :
#hbf700p          printout         (prin)     .prn  
#                 cassette         (cass)     .wav  .tap  .cas  
#                 cartridge1       (cart1)    .mx1  .bin  .rom  
#                 cartridge2       (cart2)    .mx1  .bin  .rom  
#                 floppydisk       (flop)     .dsk  .dmk  .d77  .d88  .1dd  .dfi  .hfe  .imd  .ipf  .mfi  .mfm  .td0  .cqm  .cqi 
# from this example all extensions are added and this information is stored like this in (allextensions) :
#.prn .wav  .tap  .cas .mx1  .bin  .rom .mx1  .bin  .rom .dsk  .dmk  .d77  .d88  .1dd  .dfi  .hfe  .imd  .ipf  .mfi  .mfm  .td0  .cqm  .cqi 
echo "read all available extensions per system"
for index in "${!systems[@]}"; do 
# export all supported media per system on unique base
allextensions+=( "$(/opt/retropie/emulators/mame/mame -listmedia ${systems[$index]} | grep -o "\...." | tr ' ' '\n' | sort -u | tr '\n' ' ')" )
#testline
#echo ${systems[$index]} ${allextensions[$index]}
done
#testline
#echo ${allextensions[@]} ${#allextensions[@]}


#part 6 : extract only extension data per media per system to array
#the collected data stored in the specific arrays using this example structure for the msx system hbf700p, information is stored like this :
#(mediadescriptions)  (media)    (extensions)
# printout            (prin)     .prn  
# cassette            (cass)     .wav  .tap  .cas  
# cartridge1          (cart1)    .mx1  .bin  .rom  
# cartridge2          (cart2)    .mx1  .bin  .rom  
# floppydisk          (flop)     .dsk  .dmk  .d77  .d88  .1dd  .dfi  .hfe  .imd  .ipf  .mfi  .mfm  .td0  .cqm  .cqi 
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


#part 7 : do some filtering and read mamedev system descriptions into (descriptions)
echo "read computer description(s)"
#a manual command example would be :
#/opt/retropie/emulators/mame/mame -listdevices hbf700p | grep Driver | sed s/hbf700p//g | cut -c 10- | sed s/\)\://g
#the output, stored in the (descriptions) would be :
#HB-F700P (MSX2)
#
# keep the good info and delete text in lines ( "Driver"(cut), "system"(sed), "):"(sed) )
for index in "${!systems[@]}"; do descriptions+=( "$(/opt/retropie/emulators/mame/mame -listdevices ${systems[$index]} | grep Driver | sed s/$(echo ${systems[$index]})//g | cut -c 10- | sed s/\)\://g)" ); done


#part 8 : read RetroPie systems and descriptions from the platforms.cfg
echo "read and match RetroPie names with mamedev names"
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
descriptionsrp+=( "$(echo $LINE | \
sed 's/\"PC\"/\"-PC-\"/g' | \
sed 's/Atari Jaguar/Jaguar/g' | \
sed 's/Mega CD/Mega-CD/g' | \
sed 's/Sega 32X/32X/g' | \
sed 's/Commodore Amiga/Amiga/g' | \
sed 's/ and / \& /g' | \
sed 's/ and / \& /g' | \
cut -d '"' -f 2)" )
done < <(cat /home/$user/RetroPie-Setup/platforms.cfg | grep fullname)


#part 9 : add extra possible future/unknown RetroPie names
#added because of the @DTEAM in Handheld tutorial
#!!! this name "handheld" not used by @DTEAM in Handheld tutorial !!! <=> can't extract "konamih" and "tigerh" from mamedev database, for now
systemsrp+=( "handheld" ) # can be overruled by added @DTEAM name changing
descriptionsrp+=( "handheld" ) # can be overruled by added @DTEAM name changing
#this name "jakks" is used by @DTEAM in Handheld tutorial <=> "jakks" can be extracted from mamedev database
#because "jakks" is not in the RetroPie platforms we add this here for later matching
systemsrp+=( "jakks" )
descriptionsrp+=( "JAKKS" )
#this name "tigerrz" is used by @DTEAM in Handheld tutorial <=> "tigerrz" can be extracted from mamedev database
#because "tigerrz" is not in the RetroPie platforms we add this here for later matching
systemsrp+=( "tigerrz" )
descriptionsrp+=( "R-Zone" )
#bbcmicro for BBC Micro is not in the original platforms.cfg
systemsrp+=( "bbcmicro" )
descriptionsrp+=( "BBC Micro" )
#bbcmicro for BBC Master is not in the original platforms.cfg
systemsrp+=( "bbcmicro" )
descriptionsrp+=( "BBC Master" )
#testlines
#echo ${systemsrp[@]}
#echo ${descriptionsrp[@]}


#part 10 : match the RetroPie descriptions to the mamedev descriptions
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

  #here we can change mamedev systems names that normally wouldn't be detected in the next for loop
  #so now they can be detected changed into RetroPie names
  for mamedevindex in "${!descriptions[@]}"; do
    if [[ "${descriptions[$mamedevindex]}" == "Adam" ]]; then
       descriptions[$mamedevindex]="ColecoVision Adam"
       echo "changed in ${descriptions[$mamedevindex]}"
    fi
  done

  #check the mamedev descriptions against the RetroPie descriptions
  for mamedevindex in "${!descriptions[@]}"; do
    for rpindex in "${!descriptionsrp[@]}"; do
      #create an empty array and split the the retropie name descriptions into seperate "words" in an array
      splitdescriptionsrp=()
      IFS=$' ' GLOBIGNORE='*' command eval  'splitdescriptionsrp=($(echo ${descriptionsrp[$rpindex]}))'
      #check if every "word" is in the mess name descriptions * *=globally , " "=exact, 
      #!!! exact matching does not work here, because many times you are matching 1 "word" against multiple "words" !!!
      if [[ "${descriptions[$mamedevindex]}" == *${splitdescriptionsrp[@]}* ]]; then
        # If descriptions are exactly the same then use the system name of retropie as romdirectory
        # for the other arrays we use the mamedev information
        newsystems[$mamedevindex]=${systemsrp[$rpindex]}
        echo "match - mamedev(description) - ${descriptions[$mamedevindex]} -- rp(description) - ${descriptionsrp[$rpindex]}"
        echo "match - mamedev(romdir) - ${systems[$mamedevindex]} -- rp(romdir) - ${newsystems[$mamedevindex]} (RetroPie name is used)"
      fi
    done
  done


#part 11 : match the added @DTEAM/RetroPie descriptions to the mamedev descriptions
#create a subarray "dteam_systems" containing the arrays that have to be used here
#now only two "for loops" can be use for checking multiple arrays against the RetroPie names
#note:some systems are not added because they should be recognised in a normal way
dteam_systems=("all_in1" "classich" "konamih" "tigerh")

#multiple arrays over one for loop:
#https://unix.stackexchange.com/questions/545502/bash-array-of-arrays

for mamedevindex in "${!systems[@]}"; do
  for dteam_system in "${dteam_systems[@]}"; do
    declare -n games="$dteam_system"
    #testline#echo "system name: ${dteam_system} with system members: ${games[@]}"
    for game in "${games[@]}"; do
        #compare array game names with the mess systems ( * *=globally , " "=exact ) 
        #testline#echo "${systems[$mamedevindex]}" == "$game"
        if [[ "${systems[$mamedevindex]}" == "$game" ]]; then
        # If descriptions are exactly the same then use the system name of retropie as romdirectory
        # for the other arrays we use the mess information
        newsystems[$mamedevindex]=$dteam_system
        echo "Now using pseudo RetroPie systemname for ${systems[$mamedevindex]} becomes ${newsystems[$mamedevindex]}"
      fi
    done
  done
done

# test line total output
#for index in "${!systems[@]}"; do echo $index ${systems[$index]} -- ${newsystems[$index]} | more ; echo -ne '\n'; done
#  for index in "${!systems[@]}"; do
#      if [[ "${systems[$index]}" != "${newsystems[$index]}" ]]; then
#        echo "$index ${systems[$index]} => ${newsystems[$index]}"
#      fi
#  done


#part 12 : use all stored data to generate the modulescript containing "lr-mess" and "mame" commands with media option
# "install" in front of the filename is used for distinquish the files from others in the directory
# in the script libretro commands index use "lr-*" for compatibility with runcommand.sh 
# (perhaps adding the future abitity of loading game specific retroarch configs)
# because mame is added and because mame is using this BIOS dir : /home/$user/RetroPie/BIOS/mame
# the lr-mess command is changed to use the same BIOS dir
echo "generate and write the install-<RPname>-from-mamedev-system-<MESSname><-media>.sh script file(s)"
# put everything in a seperate directory
# !!! .zip is manually added as extension in every generated script !!!
# used quotes in the next line, if there are spaces in the values of the arrays the file can not be generated, kept it in for debugging
for index in "${!systems[@]}"; do sleep 0.001; [[ -n ${allextensions[$index]} ]] && cat > "/home/$user/RetroPie-Setup$ext/scriptmodules/libretrocores/install-${newsystems[$index]}-from-mamedev-system-${systems[$index]}${media[$index]}.sh" << _EOF_
#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="install-${newsystems[$index]}-from-mamedev-system-${systems[$index]}${media[$index]}"
rp_module_name="${descriptions[$index]} with ${mediadescriptions[$index]} support"
rp_module_ext="$addextensions ${allextensions[$index]}"
rp_module_desc="Use lr-mess/mame emulator for (\$rp_module_name)"
rp_module_help="ROM Extensions: \$rp_module_ext\n
Above extensions are included for compatibility between different media installs.\n\n
ROM extensions only supported by this install:\n
$addextensions ${extensions[$index]}\n\n
Put games in:\n
\$romdir/${newsystems[$index]}\n\n
Put BIOS files in \$biosdir/mame:\n
${systems[$index]}.zip\n
Note:\n
BIOS info is automatically generated,\n
but some systems don't need a BIOS file!\n\n"

rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/mame/master/LICENSE.md"
rp_module_section="exp"
rp_module_flags=""

function depends_install-${newsystems[$index]}-from-mamedev-system-${systems[$index]}${media[$index]}() {
	local _mess=\$(dirname "\$md_inst")/lr-mess/mess_libretro.so
	if [[ ! -f "\$_mess" ]]; then
		printMsgs dialog "cannot find '\$_mess' !\n\nplease install 'lr-mess' package."
		exit 1
	fi
}

function sources_install-${newsystems[$index]}-from-mamedev-system-${systems[$index]}${media[$index]}() {
	true
}

function build_install-${newsystems[$index]}-from-mamedev-system-${systems[$index]}${media[$index]}() {
	true
}

function install_install-${newsystems[$index]}-from-mamedev-system-${systems[$index]}${media[$index]}() {
	true
}

function configure_install-${newsystems[$index]}-from-mamedev-system-${systems[$index]}${media[$index]}() {
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
	# all option should work with both mame and lr-mess, although -autoframeskip is better with mame
	addEmulator 0 "lr-mess-system-${systems[$index]}${media[$index]}" "\$_system" "\$_script \$_retroarch_bin \$_mess \$_config \\${systems[$index]} \$biosdir/mame -autoframeskip -ui_active ${media[$index]} %ROM%"
	addEmulator 0 "mame-system-${systems[$index]}${media[$index]}" "\$_system" "/opt/retropie/emulators/mame/mame -v -c -ui_active ${systems[$index]} ${media[$index]} %ROM%"
        addEmulator 0 "mame-system-${systems[$index]}${media[$index]}-autoframeskip" "\$_system" "/opt/retropie/emulators/mame/mame -v -c -autoframeskip -ui_active ${systems[$index]} ${media[$index]} %ROM%"

	# add system to es_systems.cfg
	#the line used by @valerino didn't work for the original RetroPie-setup 
	#therefore the information is added in a different way
	addSystem "\$_system" "${descriptions[$index]}" "$addextensions ${allextensions[$index]}"	
}

_EOF_

#change ownership to normal user
chown $user:$user "/home/$user/RetroPie-Setup$ext/scriptmodules/libretrocores/install-${newsystems[$index]}-from-mamedev-system-${systems[$index]}${media[$index]}.sh" 2>&-

#install directly after generation if the script runs as a function within the front-end module script
if [[ $installation_after_generating != off ]];then
#if not empty (-n) : change ownership to normal user and install 
   if [[ -n $(ls /home/$user/RetroPie-Setup$ext/scriptmodules/libretrocores/install-${newsystems[$index]}-from-mamedev-system-${systems[$index]}${media[$index]}.sh 2>&-) ]]; then
   $scriptdir/retropie_packages.sh install-${newsystems[$index]}-from-mamedev-system-${systems[$index]}${media[$index]}
fi


fi


done


#part 13 : use all stored data to generate the modulescript containing "lr-mess" and "mame" commands for loading handmade .cmd files or to run basenames
# the none media mamedev system types have no extensions in the mamedev database
# in order to switch between emulators at retropie rom boot
# we have to add these extensions
# otherwise extensions supported by other emulators will not be shown anymore

# because mame is added and because mame is using this BIOS dir : /home/$user/RetroPie/BIOS/mame
# the lr-mess command is changed to use the same BIOS dir

# "install" in front of the filename is used for distinquish the files from others in the directory
# in the script libretro commands index use "lr-*" for compatibility with runcommand.sh 
# (perhaps adding the future abitity of loading game specific retroarch configs)(for example configs for overlays)
echo "generate and write the install-<RPname>-cmd.sh command script file(s)"
# put everything in a seperate directory
# !!! .zip is manually added as extension in every generated script !!!
# used quotes in the next line, if there are spaces in the values of the arrays the file can not be generated, kept it in for debugging
# grep function is used to get all extensions compatible with all possible emulation methods so switching within emulationstation is possible
# grep searches in both platform.cfg and the ext/RetroPie-Share/platforms.cfg , so also extensions are added that are not in platform.cfg 
# using grep this way can create double extension, but this should not be a problem
for index in "${!newsystems[@]}"; do sleep 0.001; platformextensionsrp=$(grep ${newsystems[$index]}_exts /home/$user/RetroPie-Setup/platforms.cfg /home/$user/RetroPie-Setup/ext/RetroPie-Share/platforms.cfg | cut -d '"' -f 2); cat > "/home/$user/RetroPie-Setup$ext/scriptmodules/libretrocores/install-${newsystems[$index]}-cmd.sh" << _EOF_
#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#


rp_module_id="install-${newsystems[$index]}-cmd"
rp_module_name="${newsystems[$index]} with command and game-BIOS support"
rp_module_ext="$addextensionscmd $addextensions ${allextensions[$index]}$platformextensionsrp"
rp_module_desc="Use lr-mess and mame emulator for ${newsystems[$index]}"
rp_module_help="ROM Extensions: \$rp_module_ext\n
Above extensions are included for compatibility between different media installs.\n\n
ROM extensions only supported by this install:\n
$addextensionscmd $addextensions ${extensions[$index]}\n\n
Put games or *game-BIOS files in (* for handhelds ...):\n
\$romdir/${newsystems[$index]}\n
Note ! : with this setup, multiple lr-mess/mame system types can be run.\n
So no specific BIOS info can be given.\n
Put BIOS files in \$biosdir/mame\n
When using game-BIOS files, no BIOS is needed in the BIOS directory.\n"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/mame/master/LICENSE.md"
rp_module_section="exp"
rp_module_flags=""

function depends_install-${newsystems[$index]}-cmd() {
	local _mess=\$(dirname "\$md_inst")/lr-mess/mess_libretro.so
	if [[ ! -f "\$_mess" ]]; then
		printMsgs dialog "cannot find '\$_mess' !\n\nplease install 'lr-mess' package."
		exit 1
	fi
}

function sources_install-${newsystems[$index]}-cmd() {
	true
}

function build_install-${newsystems[$index]}-cmd() {
	true
}


function install_install-${newsystems[$index]}-cmd() {
	true
}


function configure_install-${newsystems[$index]}-cmd() {
    local _retroarch_bin="\$rootdir/emulators/retroarch/bin/retroarch"
    local _mess=\$(dirname "\$md_inst")/lr-mess/mess_libretro.so
    local _system="${newsystems[$index]}"
    local _config="\$configdir/\$_system/retroarch.cfg"
    
    mkRomDir "\$_system"
    ensureSystemretroconfig "\$_system"
    
    echo "enable cheats for lr-mess in \$configdir/all/retroarch-core-options.cfg"
    iniConfig " = " "\"" "\$configdir/all/retroarch-core-options.cfg"
    iniSet "mame_cheats_enable" "enabled"
    chown \$user:\$user "\$configdir/all/retroarch-core-options.cfg"

    echo "enable cheats for mame in \$romdir/mame/mame.ini"    
    iniConfig " " "" "\$romdir/mame/mame.ini"
    iniSet "cheatpath"  "\$romdir/mame/cheat"
    iniSet "cheat" "1"
    chown \$user:\$user "\$romdir/mame/mame.ini"
        
    addEmulator 0 "lr-mess-cmd" "\$_system" "\$_retroarch_bin --config \$_config -v -L \$_mess %ROM%"
    addEmulator 0 "lr-mess-basename" "\$_system" "\$_retroarch_bin --config \$_config -v -L \$_mess %BASENAME%"
    addEmulator 0 "mame-cmd" "\$_system" "/opt/retropie/emulators/mame/mame -rompath /home/$user/RetroPie/roms/${newsystems[$index]} -v -c %BASENAME%"
    addEmulator 0 "mame-cmd-autoframeskip" "\$_system" "/opt/retropie/emulators/mame/mame -rompath /home/$user/RetroPie/roms/${newsystems[$index]} -v -c -autoframeskip %BASENAME%"
    addEmulator 0 "mame-basename" "\$_system" "/opt/retropie/emulators/mame/mame -v -c ${newsystems[$index]} %BASENAME%"
    addEmulator 0 "mame-basename-autoframeskip" "\$_system" "/opt/retropie/emulators/mame/mame -v -c -autoframeskip ${newsystems[$index]} %BASENAME%"
    #turned these off, seems these commands will not work, but kept for future testing : https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/33
    ##addEmulator 0 "mame-basename-test" "\$_system" "/opt/retropie/emulators/mame/mame -rompath /home/$user/RetroPie/roms/${newsystems[$index]} -v -c %BASENAME%"
    ##addEmulator 0 "mame-basename-autoframeskip-test" "\$_system" "/opt/retropie/emulators/mame/mame -rompath /home/$user/RetroPie/roms/${newsystems[$index]} -v -c -autoframeskip %BASENAME%"

    # add system to es_systems.cfg
    #the line used by @valerino didn't work for the original RetroPie-setup 
    #therefore the information is added in a different way
    #the system name is also used as description because, for example, handhelds are generated with game system names
    addSystem "\$_system" "\$_system" "$addextensionscmd $addextensions ${allextensions[$index]}$platformextensionsrp"
}

_EOF_

#change ownership to normal user
chown $user:$user "/home/$user/RetroPie-Setup$ext/scriptmodules/libretrocores/install-${newsystems[$index]}-cmd.sh" 2>&-

#install directly after generation if the script runs as a function within the front-end module script
if [[ $installation_after_generating != off ]];then
   if [[ -n $(ls /home/$user/RetroPie-Setup$ext/scriptmodules/libretrocores/install-${newsystems[$index]}-cmd.sh 2>&-) ]]; then 
   $scriptdir/retropie_packages.sh install-${newsystems[$index]}-cmd
   fi
fi

done

#update the packages if the script runs as a function within the front-end module script
if [[ $installation_after_generating != off ]];then
   echo refreshing RetroPie packages
   rp_registerAllModules
fi
