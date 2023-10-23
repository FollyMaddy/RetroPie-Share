#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#


#----------------------------------------------------------------------------------------------------------------------------------------------
# INFORMATION ABOUT THE CSV STRUCTURE
# USED FOR GENERATING A GUI/SUB-GUI :
# - the first value isn't used for the menu, that way the menu begins with 1
# - this first value should be empty or contain a description of the specific column
# - make sure every line begins and ends with quotes because of possible spaces
# - just use the first and last column in excel/calc for the quotes and you should be fine
#----------------------------------------------------------------------------------------------------------------------------------------------


rp_module_id="mamedev"
rp_module_desc="Add MAME/lr-mame/lr-mess systems"
rp_module_section="config"

rp_module_build="Default"
rp_module_version="0259.05"
rp_module_version_mame="$(echo $rp_module_version|cut -d"." -f1)"

rp_module_database_versions=()
rp_module_database_versions=( "" $(curl -s https://github.com/FollyMaddy/RetroPie-Share/tree/main/00-databases-00/mame|sed 's/:/\\\n/g'|grep _info\"|grep path|grep -v 023|egrep -o '[0-9.]+'|sort -r) )

local mamedev_csv=()
local mamedev_forum_csv=()
local gamelists_csv=()

local restricted_download_csv=()
local system_read


function depends_mamedev() {
    mamedev_csv=()
    getDepends curl python3 $(if [[ $scriptdir == *RetroPie* ]];then xattr;else echo python-xattr;fi)
    if [[ -z $(xattr -p user.comment $(if [[ -f $scriptdir/ext/RetroPie-Share/scriptmodules/supplementary/mamedev.sh ]];then echo $scriptdir/ext/RetroPie-Share/scriptmodules/supplementary/mamedev.sh;else echo $scriptdir/scriptmodules/supplementary/mamedev.sh;fi) 2>&-) ]];then
    show_message_mamedev "\
                                                 One time update info\n\
259.06 :\n\
- fix showing help for quite some options\n\
- use variables inside paths for preliminary ArchyPie support\n\
- if used on arch linux based OS then install python-xattr, not xattr\n\
259.05 :\n\
- add \"-view %BASENAME%\" to all the mame runcommands\n\
If the viewname is found in the artwork it will load.\n\
If a viewname is not found in the arwork then it will load the default.\n\
If a view is saved somehow, using the menu, then that one will load.\n\
To restore loading automatically again then remove the config or\n\
remove the predefined \"view\" from the config.\n\
259.04 :\n\
- fix error when there is no data removing systems\n\
259.03 :\n\
- fix downloading from github as github changed some stuff\n\
- fix jakks 0 rom-index 0 file creation\n\
259.02 :\n\
- be able to install a cheatfile from a list\n\
- when mamecheats.co.uk adds newer cheatfiles then they should pop up\n\
259.01 :\n\
- fix only writing patched mame cdimono1.cfg when installing cdimodo1\n\
- show the cdimono1 patch messages in a dialog box\n\
259.00 :\n\
- use new database\n\
258.07 :\n\
- show the drive binary list in correct reverse order using 'tac'\n\
- improve message for gdrive and stickfreaks binary installs\n\
- add more binaries to gdrive\n\
258.06 :\n\
- remove some gdrive binary install items and integrate them into a list\n\
- show a mame binary list from gdrive and be able to install one\n\
- mame binaries can now be added to the gdrive without adding new code\n\
- 'split' the stickfreaks mame binary when installing\n\
258.05 :\n\
- show a mame binary list from stickfreaks and be able to install one\n\
258.04 :\n\
- change help for the @DTEAM categories using the summary of @bbilford83\n\
258.03 :\n\
- xattr fix for showing \"one time update info\"\n\
258.02 :\n\
- improve showing version and used database version\n\
258.01 :\n\
- return to RetroPie-Setup after updating the script \n\
- add showing \"one time update info\"\n\
- change the \"EXTRAS\" lists depending on the selected mame database\n\
- add help about the install of the patched runcommand.sh\n\
- add help about the install of the run_mess.sh script\n\
- improve message \"About this script\"\n\
258.00 :\n\
- simple version change so updating will be easier\n\
- be able to use older mame databases\n\
- add some older mame binaries\n\
- be able to install the patched runcommand.sh\n\
- be able to restore to the original runcommand.sh\n\
- runcommands using extra replace tokens with patched runcommand.sh\n\
- add new EXTRA coco lines\n\
- still be able to use the older EXTRA coco2 lines\n\
- be able to remove systems or categories\n\
- re-order some stuff and improve the menu\n\
- turning of default rotation for libretro\n\
- be able to install/remove the run_mess.sh script separately\n\
- run_mess commands are not installed when run_mess.sh is not installed\n\
- do not install lr-mess runcommands when lr-mess is not installed\n\
- do not install lr-mame runcommands when lr-mame is not installed\n\
"
    xattr -w user.comment "x" $(if [[ -f $scriptdir/ext/RetroPie-Share/scriptmodules/supplementary/mamedev.sh ]];then echo $scriptdir/ext/RetroPie-Share/scriptmodules/supplementary/mamedev.sh;else echo $scriptdir/scriptmodules/supplementary/mamedev.sh;fi)
    fi
}


function gui_mamedev() {
    #special charachters ■□▪▫▬▲►▼◄◊○◌●☺☻←↑→↓↔↕⇔
    local csv=()
    csv=(
",menu_item,,to_do,,,,,help_to_do,"
",About this script,,show_message_mamedev \"This project makes use of MAME/lr-mame/lr-mess for emulating.\nThey support a lot of devices to be emulated.\nEmulating many of the desired devices was quite difficult.\nSome people made module-scripts to emulate these devices.\nThe making of such a module-script is a very time consuming.\nThis project makes use of our own enhance data and MAME data.\nThis data is then used to install drivers on the fly.\n---This script combines the work and ideas of many people :---\n- Folly : creating this script\n- Valerino : creating the run_mess.sh script\n- RussellB : improved the run_mess.sh script\n- DTEAM : basic structure for handheld and P&P\n- DTEAM : artwork and gamelists on google-drive\n- Matt Huisman : google-drive downloader\n- Dmmarti : google-sheet with info about systems\n- JimmyFromTheBay : testing\n- Jamrom2 : testing\n- bbilford83 : joystick configs and summaries and gamelists\n- Orionsangel : creating realistic arcade overlays\n- stickfreaks : hosting mame binaries\n- mamecheats : hosting cheatfiles\",,,,,show_message_mamedev \"NO HELP\","
",Update mamedev script and database,,wget -O $(if [[ -f $scriptdir/ext/RetroPie-Share/scriptmodules/supplementary/mamedev.sh ]]; then echo $scriptdir/ext/RetroPie-Share/scriptmodules/supplementary/mamedev.sh;else echo $scriptdir/scriptmodules/supplementary/mamedev.sh;fi) https://raw.githubusercontent.com/FollyMaddy/RetroPie-Share/main/00-scriptmodules-00/supplementary/mamedev.sh;chown $user:$user $(if [[ -f $scriptdir/ext/RetroPie-Share/scriptmodules/supplementary/mamedev.sh ]]; then echo $scriptdir/ext/RetroPie-Share/scriptmodules/supplementary/mamedev.sh;else echo $scriptdir/scriptmodules/supplementary/mamedev.sh;fi);xattr -d user.comment $(if [[ -f $scriptdir/ext/RetroPie-Share/scriptmodules/supplementary/mamedev.sh ]];then echo $scriptdir/ext/RetroPie-Share/scriptmodules/supplementary/mamedev.sh;else echo $scriptdir/scriptmodules/supplementary/mamedev.sh;fi);curl https://raw.githubusercontent.com/FollyMaddy/RetroPie-Share/main/00-databases-00/mame/mame${rp_module_database_versions[1]}_systems_sorted_info -o $emudir/mame/mame${rp_module_database_versions[1]}_systems_sorted_info;rp_registerAllModules;show_message_mamedev \"\n\n\n\n\n\n\n\n----------The script has been updated !-----------\n-----Going back into the RetroPie-Setup menu.-----\";break,,,,,," 
",,,,,,,,,"
",►Install MAME / LR-MESS / LR-MAME,,subgui_installs_mamedev,,,,,,"
",,,,,,,,,"
",►Choose and install systems with DEFAULT settings,,subgui_systems_default_mamedev,,,,,show_message_mamedev \"Go into the submenu and choose from different lists displaying the available systems in different ways\","
",►Choose and install systems with >EXTRA< settings,,subgui_systems_extras_mamedev,,,,,show_message_mamedev \"Go into the submenu and choose from different lists displaying the available systems with extra functions\n\nWARNING:\nSystems with extra hardware can have extra supported file extensions.\nTo keep the supported file extensions always do the extra install after a default install otherwise specific supported file extensions are wiped from the /etc/emulationstation/es_systems.cfg\","
",►Choose and install HANDHELD/PLUG&PLAY/CATEGORIES,,subgui_categories_mamedev,,,,,show_message_mamedev \"Go into the submenu and choose from different lists displaying the available catagories / handheld / plug&play and the required downloads\n\nHandheld systems is a group of portable consoles that are part of MAME Romset.\nThe list of these games can be found in the retropie forum in the tutorial : (Tutorial : Handheld and Plug & Play systems with MAME)\n\nThe 7 systems are :\n - Konami Handheld\n - All in one handheld and Plug & Play\n - Game & Watch (with madrigal and MAME romset)\n - Tiger Handheld\n - Tiger R-Zone\n - Classic Handheld (with madrigal and MAME romset)\n - JAKKS Pacific TV Games -Plug & Play games\","
",,,,,,,,,"
",►Switch to another mame database version,,subgui_databases_mamedev,,,,,show_message_mamedev \"If you are running an older MAME / lr-mame / lr-mess version\nthen you can select an older suitable database over here.\nThat way an install will have the best version match.\n\nOnly the databases that were created and suitable can be selected.\nIf you use a version that does not exist then select the closest one.\","
",►Choose and remove installs,,subgui_remove_installs_mamedev,,,,,show_message_mamedev \"A most likely list of the installs is presented.\nBy selecting a system or a category you can remove one.\nAfter that you will go back into the menu.\nNext time an updated list is presented again.\n\n- only 'mamedev' runcommands are removed from the emulators.cfg\n- then the emulators.cfg is removed if empty\n- the system is removed from es_systems.cfg if no emulators.cfg is found\n- the config directory is not removed !\","
",,,,,,,,,"
",►ARTWORK/CHEATS/GAMELISTS/JOYSTICKS/OVERLAYS/PATCHES,,show_message_mamedev \"The options in the next submenu are for downloading files and they will overwrite files with the same name. So be careful with them.\nThe possible options use these directories :\n- $rootdir/configs/all/emulationstation\n- $rootdir/configs/all/retroarch/overlay\n- $rootdir/configs/all/retroarch-joypads\n- $rootdir/supplementary/runcommand\n- $datadir/BIOS/mame/cheat\n- $datadir/roms/mame/cheat\n- $datadir/roms/mame/artwork\n- $datadir/roms/<system>\n- $scriptdir/scriptmodules\n\nIf you have important files then do a BACKUP first !!!\n\nPress Cancel in the next subgui to go back into the menu.\";subgui_downloads_mamedev ,,,,,show_message_mamedev \"Get online files.\n\n- download retroarch joypad autoconfigs\n- download cheats\n- download ES gamelists + media\n- download artwork\n- browse and download artwork per system\n- create background overlays from artwork\n- create background overlay config files\n- download realistic bezels\n- create bezel overlay files\","
",,,,,,,,,"
",►Browser/downloader ( restricted ),,subgui_archive_downloads_mamedev,,,,,show_message_mamedev \"Browse and get online files.\n(only available with the correct input)\","
    )
    build_menu_mamedev
}


function help_categories_mamedev() {
show_message_mamedev "\
In this subgui you can choose to install catergories.\n\
The first set of categories are created and selected by @DTEAM :\n\
- all_in1\n\
- classich\n\
- gameandwatch\n\
- jakks\n\
- konamih\n\
- tigerh\n\
- tigerrz\n\
All In One Handheld (and Plug & Play) is used for systems with \
multiple games like the concept 100 in 1.\n\
Classic Handheld is used for the non-game & watch from the \
MADrigal romset and all other manufacturers in the MAME romset such as :\n\
- Coleco\n\
- Entex\n\
- etc.\n\
Game & Watch is used for the game & watch from the \
MADrigal romset and the ones in the MAME romset.\n\
JAKKS Pacific TV Games is used for plug & play games from Jakks Pacific.\n\
Konami Handheld is used for the handhelds from Konami.\n\
Tiger Handheld is used for the handhelds from Tiger.\n\
Tiger R-Zone is used for the R-Zone handheld from Tiger.\n\
\n\
Btw. You can use lr-gw for the MADrigal romset.\n\
You can install it from this script for classich and gameandwatch.\n\
\n\
You can find system driver lists on the RetroPie forum :\n\
Tutorial: Handheld and Plug & Play systems with MAME\n\
These lists are at the top of this thread kindly created by @DTEAM\n\
which he seems to be updating every time a new game gets added to mame.\n\
You can use lr-mess but standalone mame would probably be faster.\n\
These roms run like typical mame roms where you can get to the mame menu\n\
(pre-set to tab on a keyboard) to do button mapping, etc.\n\
For most handheld categories they won't display properly unless\n\
you have at least the background art set up.\n\
That is what this (wonderful!) script also can do for you.\n\
You also have the option of copying over the full (~10mb) .zip of art\n\
that you can download in the script into the bios/mame/artwork folder.\n\
For this check out the menu item :\n\
►ARTWORK/CHEATS/GAMELISTS/JOYSTICKS/OVERLAYS/PATCHES\n\
\n\
After installing the artwork/backgrounds the game will load with \
all the art and display the entire handheld with the screen only \
taking up a small part of your actual screen.\n\
In the mame menu you have the ability to change the view to just \
zoom into the screen or various other partially-zoomed in views \
which depends on the rom.\n\
When you change the view and exit the rom then mame will remember.\n\
Next time you load the game it will load it in that view.\n\
\n\
There are also games that work through the lr-gw emulator \
which is designed to run the MADrigal romset.\n\
I won't link to the romset to be safe but it's very easy to find.\n\
Those run very differently from mame.\n\
They automatically load with full artwork showing the handheld itself.\n\
While each game has the option to zoom into the screen \
you can't make it do that by default.\n\
So you always start with the game displayed in the teenier \
handheld screen displayed on your big screen.\n\
When you hit start it will show you what all the \
different buttons do as mapped to a standard controller layout.\n\
Select moves around the cursor to choose non-gameplay buttons\n\
(like start, alarm, game a/b, etc.).\n\
This is different to mame where you have those buttons mapped \
to something on your keyboard or controller.\n\
Confusingly, the lr-gw emulator is NOT limited to gameandwatch roms.\n\
The madrigal set is partially game & watch roms \
and partially handhelds made by other companies \
which is why @DTEAM has them split into \
the gameandwatch set and the classich set.\n\
This is undoubtedly correct but people like you and me who \
used to have the lr-gw set (which pre-dated this script) \
likely had a single gameandwatch system set up with a bunch \
of non-gameandwatch games.\n\
It can take a while to figure this out.\n\
Even more confusing there are some games that are \"tabletop\" \
and made by nintendo.\n\
Some of which (like Mario's Cement Factory) have identical gameplay \
to the traditional gameandwatch handheld.\n\
But they weren't watches and weren't labelled under the game & watch brand.\n\
So they make more sense considered as \"Classic Handheld\".\n\
(Above contains a part of a rewritten summary of @bbilford83)\n\
\n\
The other categories are created from the database by\n\
using the database of progettosnaps\n\
\n\
\Z2Most of these categories are implemented as recognisable category.\n\
So when you install a system driver from the default system install menu\n\
it will install and use the detected category name instead.\n"
}


function read_data_mamedev() {
    clear
    echo "Database version mame${rp_module_version_mame}_systems_sorted_info is used"
    #make sure there is a database
    [[ ! -d $emudir/mame ]] && mkdir -p $emudir/mame
    [[ ! -f $emudir/mame/mame${rp_module_version_mame}_systems_sorted_info ]] && curl -s https://raw.githubusercontent.com/FollyMaddy/RetroPie-Share/main/00-databases-00/mame/mame${rp_module_version_mame}_systems_sorted_info -o $emudir/mame/mame${rp_module_version_mame}_systems_sorted_info
    #here we read the systems and descriptions from mame into an array
    #by using next if function the data can be re-used, without reading it every time
    if [[ -z ${mamedev_csv[@]} ]]; then
        if [[ -f $emudir/mame/mame${rp_module_version_mame}_systems_sorted_info ]]; then 
	echo "Get mame${rp_module_version_mame} data:$emudir/mame/mame${rp_module_version_mame}_systems_sorted_info"
	echo "For speed, data will be re-used within this session if possible"
	echo "Be patient for 20 seconds" 
	#here we use sed to convert the line to csv : the special charachter ) has to be single quoted and backslashed '\)'
	#we need to add 'echo \",,,,\";', because otherwise the first value isn't displayed as it is reserved for the column descriptions
	while read system_read;do mamedev_csv+=("$system_read");done < <(echo \",,,,\";cat $emudir/mame/mame${rp_module_version_mame}_systems_sorted_info|sed 's/,//g;s/Driver /\",/g;s/ ./,/;s/'\)':/,install_system_mamedev,/;s/\r/,,,\"/')
        fi
    fi
}


function subgui_categories_mamedev() {
    local csv=()
    csv=(
",menu_item_handheld_description,SystemType,to_do driver_used_for_installation,,,,,help_to_do,"
",All in One Handheld and Plug and Play,@non-arcade,create_00index_file_mamedev '/@all_in1/' $datadir/roms/all_in1;install_system_mamedev all_in1 all_in1 '' '' 'none' '',,,,,help_categories_mamedev,"
",Classic Handheld Systems,@non-arcade,create_00index_file_mamedev '/@classich/' $datadir/roms/classich;install_system_mamedev classich classich '' '' 'none' '',,,,,help_categories_mamedev,"
",Game & Watch,@non-arcade,create_00index_file_mamedev '/@gameandwatch/' $datadir/roms/gameandwatch;install_system_mamedev gameandwatch gameandwatch '' '' 'none' '',,,,,help_categories_mamedev,"
",JAKKS Pacific TV Games,@non-arcade,create_00index_file_mamedev '/@jakks/' $datadir/roms/jakks;install_system_mamedev jakks jakks '' '' 'none' '',,,,,help_categories_mamedev,"
",Konami Handheld,@non-arcade,create_00index_file_mamedev '/@konamih/' $datadir/roms/konamih;install_system_mamedev konamih konamih '' '' 'none' '',,,,,help_categories_mamedev,"
",Tiger Handheld Electronics,@non-arcade,create_00index_file_mamedev '/@tigerh/' $datadir/roms/tigerh;install_system_mamedev tigerh tigerh '' '' 'none' '',,,,,help_categories_mamedev,"
",Tiger R-Zone,@non-arcade,create_00index_file_mamedev '/@tigerrz/' $datadir/roms/tigerrz;install_system_mamedev tigerrz tigerrz '' '' 'none' '',,,,,help_categories_mamedev,"
",,,,,,,,,"
",DECO cassette Arcade Category => deco_cassette,@arcade,create_00index_file_mamedev '/DECO/' $datadir/roms/deco_cassette;install_system_mamedev deco_cassette deco_cassette '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the deco_cassette category.\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n\nThe created index file contains the list of games.\n\n\Z2This category is implemented as recognisable category when istalling a default system.\","
",NeoGeo Arcade Category => neogeo,@arcade,create_00index_file_mamedev '/@neogeo/' $datadir/roms/neogeo;install_system_mamedev neogeo neogeo '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the neogeo category.\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n\nThe created index file contains the list of games.\n\n\Z2This category is implemented as recognisable category when istalling a default system.\","
",Sega Mega Play Arcade Category => megaplay,@arcade,create_00index_file_mamedev '/\(Mega Play\)/' $datadir/roms/megaplay;install_system_mamedev megaplay megaplay '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the megaplay category.\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n\nThe created index file contains the list of games.\n\n\Z2This category is implemented as recognisable category when istalling a default system.\","
",Nintendo PlayChoice-10 Arcade Category => playchoice10,@arcade,create_00index_file_mamedev '/\(PlayChoice-10\)/' $datadir/roms/playchoice10;install_system_mamedev playchoice10 playchoice10 '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the playchoice10 category.\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n\nThe created index file contains the list of games.\n\n\Z2This category is implemented as recognisable category when istalling a default system.\","
",Nintendo VS Arcade Category => nintendovs,@arcade,create_00index_file_mamedev '/@nintendovs/' $datadir/roms/nintendovs;install_system_mamedev nintendovs nintendovs '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the nintendovs category.\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n\nThe created index file contains the list of games.\n\n\Z2This category is implemented as recognisable category when istalling a default system.\","
",,,,,,,,,"
",Arcade Category => arcade,@arcade,create_00index_file_mamedev '/@working_arcade/' $datadir/roms/arcade;install_system_mamedev arcade arcade '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the arcade category.\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n\nThe created index file contains the list of games.\n\n\Z1This category is NOT implemented as recognisable category when istalling a default system !\","
",Arcade Category => driving,@arcade,create_00index_file_mamedev '/@driving@/&&/@working_arcade/' $datadir/roms/driving;install_system_mamedev driving driving '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the driving category.\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n\nThe created index file contains the list of games.\n\n\Z2This category is implemented as recognisable category when istalling a default system.\","
",Arcade Category => lightgun,@arcade,create_00index_file_mamedev '/@lightgun/&&/@working_arcade/' $datadir/roms/lightgun;install_system_mamedev lightgun lightgun '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the lightgun category.\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n\nThe created index file contains the list of games.\n\n\Z2This category is implemented as recognisable category when istalling a default system.\","
",Arcade Category => maze,@arcade,create_00index_file_mamedev '/@maze/&&/@working_arcade/' $datadir/roms/maze;install_system_mamedev maze maze '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the maze category.\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n\nThe created index file contains the list of games.\n\n\Z2This category is implemented as recognisable category when istalling a default system.\","
",Arcade Category => pinball,@arcade,create_00index_file_mamedev '/@pinball_arcade/&&/@working_arcade/' $datadir/roms/pinball;install_system_mamedev pinball pinball '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the pinball category.\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n\nThe created index file contains the list of games.\n\n\Z2This category is implemented as recognisable category when istalling a default system.\","
",Arcade Category => puzzle,@arcade,create_00index_file_mamedev '/@puzzle/&&/@working_arcade/' $datadir/roms/puzzle;install_system_mamedev puzzle puzzle '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the puzzle category.\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n\nThe created index file contains the list of games.\n\n\Z2This category is implemented as recognisable category when istalling a default system.\","
",Arcade Category => realistic,@arcade,create_00index_file_mamedev '/@oro/' $datadir/roms/realistic;install_system_mamedev realistic realistic '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the realistic category.\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n\nThe created index file contains the list of games.\n\nThe realistic category is meant for using Orionsangels realistic overlays with lr-mame.\nIt contains the selection of games that will work with these overlays.\n\Z1But installing the realistic category from this section will NOT install the overlays !\nIf you want to install and use these overlays then you have to install it from the (JOYSTICKS/CHEATS/GAMELISTS/ARTWORK/OVERLAYS).\n\nThis category is NOT implemented as recognisable category when istalling a default system !\","
",Arcade Category => shooter,@arcade,create_00index_file_mamedev '/@shooter/&&/@working_arcade/' $datadir/roms/shooter;install_system_mamedev shooter shooter '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the shooter category.\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n\nThe created index file contains the list of games.\n\n\Z2This category is implemented as recognisable category when istalling a default system.\","
",Arcade Category => slot_machine,@arcade,create_00index_file_mamedev '/@slot_machine/&&/@working_arcade/' $datadir/roms/slot_machine;install_system_mamedev slot_machine slot_machine '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the slot_machine category.\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n\nThe created index file contains the list of games.\n\n\Z2This category is implemented as recognisable category when istalling a default system.\","
",Arcade Category => sport,@arcade,create_00index_file_mamedev '/@sport/&&/@working_arcade/' $datadir/roms/sport;install_system_mamedev sport sport '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the sport category.\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n\nThe created index file contains the list of games.\n\n\Z2This category is implemented as recognisable category when istalling a default system.\","
",Arcade Category => upright,@arcade,create_00index_file_mamedev '/@upright/&&/@working_arcade/' $datadir/roms/upright;install_system_mamedev upright upright '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the upright category.\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n\nThe created index file contains the list of games.\n\n\Z1This category is NOT implemented as recognisable category when istalling a default system !\","
",,,,,,,,,"
",DECO cassette Arcade Category => deco_cassette90º,@arcade,create_00index_file_mamedev '/DECO/&&/@90º/' $datadir/roms/deco_cassette90º;install_system_mamedev deco_cassette90º deco_cassette90º '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the deco_cassette90º category.\nWhen running roms from this directory it will rotate the game 90ºCW.\nSo use a monitor that you can turn !\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n- add screenrotation in $rootdir/configs/deco_cassette90º/retroarch.cfg.basename\n\nThe created index file contains the list of games.\n\n\Z2This category is implemented as recognisable category when istalling a default system.\","
",Nintendo PlayChoice-10 Arcade Category => playchoice10_90º,@arcade,create_00index_file_mamedev '/\(PlayChoice-10\)/' $datadir/roms/playchoice10_90º;install_system_mamedev playchoice10_90º playchoice10_90º '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the playchoice10_90º category.\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n\nThe created index file contains the list of games.\n\n\Z2This category is implemented as recognisable category when istalling a default system.\","
",,,,,,,,,"
",Arcade Category => arcade90º,@arcade,create_00index_file_mamedev '/@working_arcade/&&/@90º/' $datadir/roms/arcade90º;install_system_mamedev arcade90º arcade90º '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the arcade90º category.\nWhen running roms from this directory it will rotate the game 90ºCW.\nSo use a monitor that you can turn !\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n- add screenrotation in $rootdir/configs/arcade90º/retroarch.cfg.basename\n\nThe created index file contains the list of games.\n\n\Z1This category is NOT implemented as recognisable category when istalling a default system !\","
",Arcade Category => driving90º,@arcade,create_00index_file_mamedev '/@driving@/&&/@90º/&&/@working_arcade/' $datadir/roms/driving90º;install_system_mamedev driving90º driving90º '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the driving90º category.\nWhen running roms from this directory it will rotate the game 90ºCW.\nSo use a monitor that you can turn !\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n- add screenrotation in $rootdir/configs/driving90º/retroarch.cfg.basename\n\nThe created index file contains the list of games.\n\n\Z1This category is NOT implemented as recognisable category when istalling a default system !\","
",Arcade Category => maze90º,@arcade,create_00index_file_mamedev '/@maze/&&/@90º/&&/@working_arcade/' $datadir/roms/maze90º;install_system_mamedev maze90º maze90º '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the maze90º category.\nWhen running roms from this directory it will rotate the game 90ºCW.\nSo use a monitor that you can turn !\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n- add screenrotation in $rootdir/configs/maze90º/retroarch.cfg.basename\n\nThe created index file contains the list of games.\n\n\Z1This category is NOT implemented as recognisable category when istalling a default system !\","
",Arcade Category => pinball90º,@arcade,create_00index_file_mamedev '/@pinball_arcade/&&/@90º/&&/@working_arcade/' $datadir/roms/pinball90º;install_system_mamedev pinball90º pinball90º '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the pinball90º category.\nWhen running roms from this directory it will rotate the game 90ºCW.\nSo use a monitor that you can turn !\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n- add screenrotation in $rootdir/configs/pinball90º/retroarch.cfg.basename\n\nThe created index file contains the list of games.\n\n\Z1This category is NOT implemented as recognisable category when istalling a default system !\","
",Arcade Category => puzzle90º,@arcade,create_00index_file_mamedev '/@puzzle/&&/@90º/&&/@working_arcade/' $datadir/roms/puzzle90º;install_system_mamedev puzzle90º puzzle90º '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the puzzle90º category.\nWhen running roms from this directory it will rotate the game 90ºCW.\nSo use a monitor that you can turn !\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n- add screenrotation in $rootdir/configs/puzzle90º/retroarch.cfg.basename\n\nThe created index file contains the list of games.\n\n\Z1This category is NOT implemented as recognisable category when istalling a default system !\","
",Arcade Category => shooter90º,@arcade,create_00index_file_mamedev '/@shooter/&&/@90º/&&/@working_arcade/' $datadir/roms/shooter90º;install_system_mamedev shooter90º shooter90º '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the shooter90º category.\nWhen running roms from this directory it will rotate the game 90ºCW.\nSo use a monitor that you can turn !\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n- add screenrotation in $rootdir/configs/shooter90º/retroarch.cfg.basename\n\nThe created index file contains the list of games.\n\n\Z1This category is NOT implemented as recognisable category when istalling a default system !\","
",Arcade Category => slot_machine90º,@arcade,create_00index_file_mamedev '/@slot_machine/&&/@90º/&&/@working_arcade/' $datadir/roms/slot_machine90º;install_system_mamedev slot_machine90º slot_machine90º '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the slot_machine90º category.\nWhen running roms from this directory it will rotate the game 90ºCW.\nSo use a monitor that you can turn !\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n- add screenrotation in $rootdir/configs/slot_machine90º/retroarch.cfg.basename\n\nThe created index file contains the list of games.\n\n\Z1This category is NOT implemented as recognisable category when istalling a default system !\","
",Arcade Category => sport90º,@arcade,create_00index_file_mamedev '/@sport/&&/@90º/&&/@working_arcade/' $datadir/roms/sport90º;install_system_mamedev sport90º sport90º '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the sport90º category.\nWhen running roms from this directory it will rotate the game 90ºCW.\nSo use a monitor that you can turn !\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n- add screenrotation in $rootdir/configs/sport90º/retroarch.cfg.basename\n\nThe created index file contains the list of games.\n\n\Z1This category is NOT implemented as recognisable category when istalling a default system !\","
",Arcade Category => upright90º,@arcade,create_00index_file_mamedev '/@upright/&&/@90º/&&/@working_arcade/' $datadir/roms/upright90º;install_system_mamedev upright90º upright90º '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the upright90º category.\nWhen running roms from this directory it will rotate the game 90ºCW.\nSo use a monitor that you can turn !\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n- add screenrotation in $rootdir/configs/upright90º/retroarch.cfg.basename\n\nThe created index file contains the list of games.\n\n\Z1This category is NOT implemented as recognisable category when istalling a default system !\","
    )
    build_menu_mamedev
}
#working line to generate a custom non-arcade category (does NOT skip reading mame data)
#",Forcing Non-Arcade Category => customh,@non-arcade,install_system_mamedev customh customh '' '' 'none' '',"

#working lines to generate a custom arcade/non-arcade categories (adding @skip will skip reading mame data)
#",Forcing Arcade Category => realistic,@arcade @skip,install_system_mamedev realistic realistic '' '' 'none' '',"
#",Forcing Non-Arcade Category => customh,@non-arcade @skip,install_system_mamedev customh customh '' '' 'none' '',"

function subgui_systems_extras_mamedev() {
    local csv=()
    csv=(
",menu_item,,to_do,,,,,help_to_do,"
",►Systems: with extra options,,subgui_systems_extras_add_options_mamedev descriptions,,,,,show_message_mamedev \"Install systems with extra hardware that will working better than default.\n\nWARNING:\nSystems with extra hardware can have extra supported file extensions.\nTo keep the supported file extensions always do the extra install after a default install otherwise specific supported file extensions are wiped from the /etc/emulationstation/es_systems.cfg\","
",,,,,,,,,"
",►Systems: full/semi automatic boot (with/without extra options),,subgui_systems_extras_add_autoboot_mamedev descriptions,,,,,show_message_mamedev \"Experimental : install systems with autoboot function\n\nWARNING:\nSystems with extra hardware can have extra supported file extensions.\nTo keep the supported file extensions always do the extra install after a default install otherwise specific supported file extensions are wiped from the /etc/emulationstation/es_systems.cfg\","
    )
    build_menu_mamedev
}


function subgui_gdrive_binaries_mamedev() {
	show_message_mamedev "\
A list of mame binaries from my gdrive will be presented.\n\
Selecting one will remove your current mame, if installed.\n\
Then it will download the selected mame in /tmp/ and extract it in :\n\
$emudir/mame/\n\
After that it will install dependancies for mame, if not installed.\n\
Last thing to do is the configuring.\n\
\n\
Make sure you pick the correct arch :\n\
- \"armhf\" is for rpi's with armhf, armv7l or aarch64 cpu using 32 bit OS\n\
- \"armv7l\" is for rpi's with armv7l or aarch64 cpu using 32 bit OS\n\
- \"aarch64\" is for aarch64 cpu using 64 bit OS\n\
- \"x86\" is for x86, x86_64 cpu using 32 bit OS\n\
- \"x86_64\" is for x86_64 cpu using 64 bit OS\n\
Make sure you use the correct OS version :\n\
- gcc8 will work on Debian10/Buster & Debian11/Bullseye deratives\n\
- gcc9 should work on Debian10/Buster & Debian11/Bullseye deratives\n\
- gcc10 will work on Debian11/Bullseye deratives\n"
    local csv=()
    #the first value is reserved for the column descriptions
    csv=( ",,,," )
    local gdrive_read
    clear
    echo "reading the available binaries"
    while read gdrive_read;do csv+=("$gdrive_read");done < <(IFS=$'\n'; curl https://drive.google.com/embeddedfolderview?id=$1#list|sed 's/https/\nhttps/g;s/>/\//g;s/</\//g;s/\nhttps:\/\/drive-/https:\/\/drive-/g'|grep file|tac|while read line;do echo "\",$(echo $line|cut -d/ -f48),,install_mame_from_gdrive_mamedev $(echo $line|cut -d/ -f48) $(echo $line|cut -d/ -f6),\"";done)
    build_menu_mamedev
}


function subgui_stickfreaks_binaries_mamedev() {
	show_message_mamedev "\
A list of stickfreak mame binaries will be presented.\n\
Selecting one will remove your current mame, if installed.\n\
Then it will download the selected mame, extract it and strip it in :\n\
$emudir/mame/\n\
After that it will install dependancies for mame, if not installed.\n\
Last thing to do is the configuring.\n\
\n\
Make sure you pick the correct arch :\n\
- \"rpi2b\" is not an arch but is for rpi2b using 32 bit OS\n\
- \"armhf\" is for rpi's with armhf, armv7l or aarch64 cpu using 32 bit OS\n\
- \"aarch64\" is for aarch64 cpu using 64 bit OS\n\
Make sure you use the correct OS version :\n\
- gcc8 will work on Debian10/Buster & Debian11/Bullseye deratives\n\
- gcc9 should work on Debian10/Buster & Debian11/Bullseye deratives\n\
- gcc10 will work on Debian11/Bullseye deratives\n"
    local csv=()
    #the first value is reserved for the column descriptions
    csv=( ",,,," )
    local stickfreaks_read
    clear
    echo "reading the available binaries"
    while read stickfreaks_read;do csv+=("$stickfreaks_read");done < <(IFS=$'\n'; curl https://stickfreaks.com/mame/|cut -d '"' -f8|grep ^mame_|sort -r|while read line;do echo "\",$line,,install_mame_from_stickfreaks_mamedev $line,\"";done)
    while read stickfreaks_read;do csv+=("$stickfreaks_read");done < <(IFS=$'\n'; curl https://stickfreaks.com/mame/old/|cut -d '"' -f8|grep ^mame_|sort -r|while read line;do echo "\",$line,,install_mame_from_stickfreaks_mamedev $line old/,\"";done)
    build_menu_mamedev
}


function subgui_systems_default_mamedev() {
    local csv=()
    csv=(
",menu_item,,to_do,,,,,help_to_do,"
",►System names : SEARCH and display list,,subgui_search_mamedev systems,,,,,show_message_mamedev \"Search and create a list and then install one or more systems with default options\","
",►System names : Display alphabetical,,subgui_alphabetical_order_selection_mamedev systems,,,,,show_message_mamedev \"Select a list and then install one or more systems with default options\","
",►System names : Display all,,create_systems_list_mamedev systems,,,,,show_message_mamedev \"Install one or more systems with default options\","
",,,,,,,,,"
",►System names : Display predefined sorted lists,,subgui_lists_mamedev,,,,,show_message_mamedev \"Select a list and then install one or more systems with default options\","
",,,,,,,,,"
",►System descriptions : SEARCH and display list,,subgui_search_mamedev descriptions,,,,,show_message_mamedev \"Search and create a list and then install one or more systems with default options\","
",►System descriptions : Display alphabetical,,subgui_alphabetical_order_selection_mamedev descriptions,,,,,show_message_mamedev \"Select a list and then install one or more systems with default options\","
    )
    build_menu_mamedev
}
#"$(if [[ $(arch) == arm* ]];then echo -e ,Display all upon descriptions,,create_systems_list_mamedev descriptions,,,,,show_message_mamedev \\\"Install one or more systems with default options\\\",;else echo -e ,\\Z1Displaying all upon descriptions not available on 64bit OS,,,,,,,,;fi)"



function subgui_lists_mamedev() {
#we can add up to 5 options per list to sort on
    local csv=()
    csv=(
",menu_item,,to_do,"
",Forum list upon descriptions,,create_systems_list_mamedev descriptions @forum,"
",Forum list upon system names,,create_systems_list_mamedev systems @forum,"
",,,,"
",Non-arcade upon descriptions,,create_systems_list_mamedev descriptions @non-arcade,"
",Non-arcade upon system names,,create_systems_list_mamedev systems @non-arcade,"
",,,,"
",Game consoles upon descriptions,,create_systems_list_mamedev descriptions @game_console,"
",Game consoles upon system names,,create_systems_list_mamedev systems @game_console,"
",,,,"
",Atari upon descriptions,,create_systems_list_mamedev descriptions @non-arcade Atari,"
",Atari upon system names,,create_systems_list_mamedev systems @non-arcade Atari,"
",,,,"
",Commodore upon descriptions,,create_systems_list_mamedev descriptions @non-arcade Commodore,"
",Commodore upon system names,,create_systems_list_mamedev systems @non-arcade Commodore,"
",,,,"
",Nintendo upon descriptions,,create_systems_list_mamedev descriptions @non-arcade Nintendo,"
",Nintendo upon system names,,create_systems_list_mamedev systems @non-arcade Nintendo,"
",,,,"
",MSX upon descriptions,,create_systems_list_mamedev descriptions @non-arcade MSX,"
",MSX upon system names,,create_systems_list_mamedev systems @non-arcade MSX,"
",,,,"
",Sega upon descriptions,,create_systems_list_mamedev descriptions @non-arcade Sega,"
",Sega upon system names,,create_systems_list_mamedev systems @non-arcade Sega,"
    )
    build_menu_mamedev


}


function subgui_systems_extras_add_options_mamedev() {
#With this csv style we can't use quotes or double quotes 
#so if we want to add more options , slotdevices or extensions we replace spaces with *
#later in the install_system_mamedev they are replaced again with spaces
#we also need commas sometimes, here we use a # as a comma, in the install_system_mamedev they are replaced again with a comma
#the options after install_system_mamedev are $1=system $2=RPsystemName $3=ExtraPredefinedOption(s) $4=mediadescription $5=media $6=extension(s)
#example on how we can create the extensions options : $emudir/mame/mame -listmedia hbf700p|sed 's/  \./*\./g'
#2nd example on how we can create the extensions options, in this case, with added slotdevice : $emudir/mame/mame -listmedia apple2ee -sl7 cffa2|sed 's/  \./*\./g'
    local csv=()
    csv=(
",menu_item_handheld_description,to_do driver_used_for_installation,"
",Acorn Archimedes 305 booting RISC-OS 3.10 + floppy support,@non-arcade,install_system_mamedev aa305 archimedes -bios*310 floppydisk flop .mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.ima*.img*.ufi*.360*.ipf*.adf*.ads*.adm*.adl*.apd*.jfd -bios_310,,,,,show_message_mamedev \"NO HELP\","
",Acorn Archimedes 310 booting RISC-OS 3.10 + floppy support,@non-arcade,install_system_mamedev aa310 archimedes -bios*310 floppydisk flop .mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.ima*.img*.ufi*.360*.ipf*.adf*.ads*.adm*.adl*.apd*.jfd -bios_310,,,,,show_message_mamedev \"NO HELP\","
",Acorn Archimedes 440+4Mb booting RISC-OS 3.10 + floppy support,@non-arcade,install_system_mamedev aa440 archimedes -bios*310*-ram*4M floppydisk flop .mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.ima*.img*.ufi*.360*.ipf*.adf*.ads*.adm*.adl*.apd*.jfd -bios_310-4Mb,,,,,show_message_mamedev \"NO HELP\","
",Acorn Archimedes 440/1+4Mb booting RISC-OS 3.10 + floppy support,@non-arcade,install_system_mamedev aa4401 archimedes -bios*310*-ram*4M floppydisk flop .mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.ima*.img*.ufi*.360*.ipf*.adf*.ads*.adm*.adl*.apd*.jfd -bios_310-4Mb,,,,,show_message_mamedev \"NO HELP\","
",Acorn Archimedes 5000+4Mb + 1st floppy support + 2nd floppydrive,@non-arcade,install_system_mamedev aa5000 archimedes -upc:fdc:1*35hd*-ram*4M floppydisk flop .mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.ima*.img*.ufi*.360*.ipf*.adf*.ads*.adm*.adl*.apd*.jfd*.chd*.cue*.toc*.nrg*.gdi*.iso*.cdr -2nd_floppy_4Mb,,,,,show_message_mamedev \"NO HELP\","
",Acorn Archimedes 5000+4Mb + cdrom support,@non-arcade,install_system_mamedev aa5000 archimedes -upc:ide:1*cdrom*-ram*4M cdrom cdrm .mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.ima*.img*.ufi*.360*.ipf*.adf*.ads*.adm*.adl*.apd*.jfd*.chd*.cue*.toc*.nrg*.gdi*.iso*.cdr -cdrom_4Mb,,,,,show_message_mamedev \"NO HELP\","
",Amstrad CPC6128 + floppy1 35ssdd support,@non-arcade,install_system_mamedev cpc6128 amstradcpc -upd765:0*35ssdd floppydisk1 flop1 .sna*.wav*.cdt*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk -35ssdd,,,,,show_message_mamedev \"NO HELP\","
",Amstrad CPC6128p + ParaDOS + floppy1 35ssdd support,@non-arcade,install_system_mamedev cpc6128p amstradcpc -cart1*$datadir/BIOS/mame/ENGPADOS.CPR*-upd765:0*35ssdd floppydisk1 flop1 .sna*.wav*.cdt*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk -parados-35ssdd,,,,,show_message_mamedev \"NO HELP\","
",Amstrad CPC6128P + cartridge support + use gx4000 roms directory,@non-arcade,install_system_mamedev cpc6128p gx4000 '' cartridge cart .bin*.cpr* -use_gx4000_roms_dir,,,,,show_message_mamedev \"NO HELP\","
",APF Imagination Machine + basic + cassette support,@non-arcade,install_system_mamedev apfimag apfimag_cass basic cassette cass .wav -basic,,,,,show_message_mamedev \"NO HELP\","
",Apple //e(e) + compact flash harddrive support,@non-arcade,install_system_mamedev apple2ee apple2ee -sl7*cffa2 harddisk hard1 .mfi*.dfi*.dsk*.do*.po*.rti*.edd*.woz*.nib*.wav*.chd*.hd*.hdv*.2mg*.hdi -compactflash,,,,,show_message_mamedev \"NO HELP\","
",Apple IIgs(ROM3) + compact flash harddrive support,@non-arcade,install_system_mamedev apple2gs apple2gs -sl7*cffa2 harddisk hard1 .mfi*.dfi*.dsk*.do*.po*.rti*.edd*.woz*.nib*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.ima*.img*.ufi*.360*.ipf*.dc42.woz*.chd*.hd*.hdv*.2mg*.hdi -compactflash,,,,,show_message_mamedev \"NO HELP\","
",Coco + ram + cassette support,@non-arcade,install_system_mamedev coco coco -ext*ram cassette cass .wav*.cas*.ccc*.rom -extra_ram,,,,,show_message_mamedev \"NO HELP\","
",Coco + ram + floppy 525dd support,@non-arcade,install_system_mamedev coco coco -ext*multi*-ext:multi:slot1*ram floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd -extra_ram-525dd,,,,,show_message_mamedev \"NO HELP\","
	)
[[ $(expr $rp_module_version_mame + 0) -lt 255 ]] && \
    csv+=(
",\Zr(<0255)\ZRCoco 2 + ram + cassette support,@non-arcade,install_system_mamedev coco2 coco2 -ext*ram cassette cass .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd -extra_ram,,,,,show_message_mamedev \"NO HELP\","
",\Zr(<0255)\ZRCoco 2 + ram + floppy 525dd support,@non-arcade,install_system_mamedev coco2 coco2 -ext*multi*-ext:multi:slot1*ram floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd -extra_ram-525dd,,,,,show_message_mamedev \"NO HELP\","
    )  
    csv+=(
",Coco 3 + ram + cassette support,@non-arcade,install_system_mamedev coco3 coco3 -ext*ram cassette cass .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd -extra_ram,,,,,show_message_mamedev \"NO HELP\","
",Coco 3 + ram + floppy 525dd support,@non-arcade,install_system_mamedev coco3 coco3 -ext*multi*-ext:multi:slot1*ram floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd -extra_ram-525dd,,,,,show_message_mamedev \"NO HELP\","
",Dragon 32 + ram + cassette support,@non-arcade,install_system_mamedev dragon32 dragon32 -ext*ram cassette cass .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9 -extra_ram,,,,,show_message_mamedev \"NO HELP\","
",Dragon 32 + ram + floppy 525qd support,@non-arcade,install_system_mamedev dragon32 dragon32 -ext*multi*-ext:multi:slot1*ram floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9 -extra_ram-525qd,,,,,show_message_mamedev \"NO HELP\","
",(Tano) Dragon 64 NTSC + ram + cassette support,@non-arcade,install_system_mamedev tanodr64 dragon64 -ext*ram cassette cass .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9 -extra_ram,,,,,show_message_mamedev \"NO HELP\","
",(Tano) Dragon 64 NTSC + ram + dragon_fdc_floppy 525qd support,@non-arcade,install_system_mamedev tanodr64 dragon64 -ext*multi*-ext:multi:slot1*ram*-ext*dragon_fdc floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9 -extra_ram-525qd,,,,,show_message_mamedev \"NO HELP\","
",Electron + plus3  floppy adfs support,@non-arcade,install_system_mamedev electron electron -exp*plus3* floppydisk flop .wav*.csw*.uef*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.ssd*.bbc*.img*.dsd*.adf*.ads*.adm*.adl*.rom*.bin -plus3-adfs,,,,,show_message_mamedev \"NO HELP\","
",Electron + plus3  floppy dfs210 support,@non-arcade,install_system_mamedev electron electron -exp*plus3#bios=dfs210 floppydisk flop .wav*.csw*.uef*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.ssd*.bbc*.img*.dsd*.adf*.ads*.adm*.adl*.rom*.bin -plus3-dfs210,,,,,show_message_mamedev \"NO HELP\","
",Enterprise 64k + basic21 + exdos13 + floppy support,@non-arcade,install_system_mamedev ep64 ep64 basic21*-exp*exdos floppydisk flop .wav*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.img -basic21_exdos,,,,,show_message_mamedev \"NO HELP\","
",Enterprise 128k + basic21 + exdos13 + floppy support,@non-arcade,install_system_mamedev ep128 ep128 basic21*-exp*exdos floppydisk flop .wav*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.img -basic21_exdos,,,,,show_message_mamedev \"NO HELP\","
",Famicom Family BASIC (V3.0) (J) + cassette support,@non-arcade,install_system_mamedev famicom famicom_famibs30 famibs30*-exp*fc_keyboard cassette cass .wav,,,,,show_message_mamedev \"NO HELP\","
",Famicom Playbox BASIC (Prototype V0.0) + cassette support,@non-arcade,install_system_mamedev famicom famicom_pboxbas pboxbas*-exp*fc_keyboard cassette cass .wav,,,,,show_message_mamedev \"NO HELP\","
",Famicom Family BASIC (V2.1a) (J) + cassette support,@non-arcade,install_system_mamedev famicom famicom_famibs21a -cart1*\"$datadir/BIOS/mame/Family*BASIC*(V2.1a)*(J).zip\"*-exp*fc_keyboard cassette cass .wav,,,,,show_message_mamedev \"NO HELP\","
",Famicom Disk System + floppy support,@non-arcade,install_system_mamedev famicom famicom_disksys disksys floppydisk flop .fds,,,,,show_message_mamedev \"NO HELP\","
",FM-Towns + 6M ram + floppy support,@non-arcade,install_system_mamedev fmtowns fmtowns -ram*6M floppydisk1 flop1 .mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.bin*.chd*.cue*.toc*.nrg*.gdi*.iso*.cdr*.icm -6Mb,,,,,show_message_mamedev \"NO HELP\","
",FM-Towns + 6M ram + cdrom support,@non-arcade,install_system_mamedev fmtowns fmtowns -ram*6M cdrom cdrm .mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.bin*.chd*.cue*.toc*.nrg*.gdi*.iso*.cdr*.icm -6Mb,,,,,show_message_mamedev \"NO HELP\","
",FM-Towns Marty + 4Mb ram + floppy support,@non-arcade,install_system_mamedev fmtmarty fmtmarty -ram*4M floppydisk1 flop1 .mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.bin*.chd*.cue*.toc*.nrg*.gdi*.iso*.cdr*.icm -4Mb,,,,,show_message_mamedev \"NO HELP\","
",FM-Towns Marty + 4Mb ram + cdrom support,@non-arcade,install_system_mamedev fmtmarty fmtmarty -ram*4M cdrom cdrm .mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.bin*.chd*.cue*.toc*.nrg*.gdi*.iso*.cdr*.icm -4Mb,,,,,show_message_mamedev \"NO HELP\","
",Nintendo Datach + cartridge2 support,@non-arcade,install_system_mamedev nes nes_datach datach cartridge2 cart2 .prg,,,,,show_message_mamedev \"NO HELP\","
",\Z1Memotech MTX512 + 512K ram + cassette support,@non-arcade,install_system_mamedev mtx512 mtx512 -ram*512K cassette cass .prn*.mtx*.run*.wav*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.mfloppy -512kb,,,,,show_message_mamedev \"NO HELP\","
",Memotech MTX512 + 512K ram + sdxbas floppy support,@non-arcade,install_system_mamedev mtx512 mtx512 -ram*512K*-exp*sdxbas floppydisk1 flop1 .prn*.mtx*.run*.wav*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.mfloppy -512kb-sdxbas,,,,,show_message_mamedev \"NO HELP\","
",Memotech MTX512 + 512K ram + sdxcpm floppy support,@non-arcade,install_system_mamedev mtx512 mtx512 -ram*512K*-exp*sdxcpm floppydisk1 flop1 .prn*.mtx*.run*.wav*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.mfloppy -512kb-sdxcpm,,,,,show_message_mamedev \"NO HELP\","
",MSX2 Philips NMS8250 + fmpac + cartridge2 support,@non-arcade,install_system_mamedev nms8250 msx2 fmpac cartridge2 cart2 .wav*.tap*.cas*.mx1*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dm -fmpac,,,,,show_message_mamedev \"NO HELP\","
",MSX2 Philips NMS8250 + fmpac + floppy support,@non-arcade,install_system_mamedev nms8250 msx2 fmpac floppydisk flop  .wav*.tap*.cas*.mx1*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dm -fmpac,,,,,show_message_mamedev \"NO HELP\","
",MSX2 Philips NMS8250 + SCC_snatcher + floppy support,@non-arcade,install_system_mamedev nms8250 msx2 -cart2*snatcher floppydisk flop  .wav*.tap*.cas*.mx1*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dm -SCC_snatcher,,,,,show_message_mamedev \"NO HELP\","
",MSX2 Philips NMS8250 + SCC_sdsnatch + floppy support,@non-arcade,install_system_mamedev nms8250 msx2 -cart2*sdsnatch floppydisk flop  .wav*.tap*.cas*.mx1*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dm -SCC_sdsnatch,,,,,show_message_mamedev \"NO HELP\","
",MSX2 Sony HB-F700P + fmpac + cartridge2 support,@non-arcade,install_system_mamedev hbf700p msx2 fmpac cartridge2 cart2 .wav*.tap*.cas*.mx1*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dm -fmpac,,,,,show_message_mamedev \"NO HELP\","
",MSX2 Sony HB-F700P + fmpac + floppy support,@non-arcade,install_system_mamedev hbf700p msx2 fmpac floppydisk flop  .wav*.tap*.cas*.mx1*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dm -fmpac,,,,,show_message_mamedev \"NO HELP\","
",MSX2 Sony HB-F700P + SCC_snatcher + floppy support,@non-arcade,install_system_mamedev hbf700p msx2 -cart2*snatcher floppydisk flop  .wav*.tap*.cas*.mx1*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dm -SCC_snatcher,,,,,show_message_mamedev \"NO HELP\","
",MSX2 Sony HB-F700P + SCC_sdsnatch + floppy support,@non-arcade,install_system_mamedev hbf700p msx2 -cart2*sdsnatch floppydisk flop  .wav*.tap*.cas*.mx1*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dm -SCC_sdsnatch,,,,,show_message_mamedev \"NO HELP\","
",PC Engine + Super CD-ROM System support (-> HELP),@non-arcade,install_system_mamedev pce pce-cd scdsys cdrom cdrm .chd*.cue*.toc*.nrg*.gdi*.iso*.cdr -scdsys,,,,,show_message_mamedev \"Good to know :\nMame does not have a separate driver for PC Engine CD.\nPC Engine together with the Super CD-ROM System rom will make a :\nPC Engine CD\n\nThis will install PC Engine CD (pce-cd).\n\nThis BIOS is needed :\nscdsys.zip\nThe file can be found in pce.zip from the mame-sl rompackage.\nThe BIOS file can be placed inside the folder :\n$datadir/BIOS/mame/pce\","
",Tandy MC-10 micro color computer + 16k + cassette support,@non-arcade,install_system_mamedev mc10 mc10 -ext*ram cassette cass .mcc*.rom*.wav*.cas*.c10*.k7 -16k,,,,,show_message_mamedev \"NO HELP\","
",Tandy MC-10 micro color computer + MCX_128k + cassette support,@non-arcade,install_system_mamedev mc10 mc10 -ext*mcx128 cassette cass .mcc*.rom*.wav*.cas*.c10*.k7 -MCX_128k,,,,,show_message_mamedev \"NO HELP\","
",Tandy TRS-80 Model III + DOS in flop1 + flop2 support,@non-arcade,install_system_mamedev trs80m3 trs80m3 -flop1*$datadir/BIOS/mame/trsdos.zip floppydisk2 flop2 .wav*.cas.mfi*.dfi*.imd*.jv3*.dsk*.dmk*.jv1 -DOS_in_flop1,,,,,show_message_mamedev \"NO HELP\","
",TI-99/4A(32Kb) + speech + cartridge support,@non-arcade,install_system_mamedev ti99_4a ti99_4a -ioport*peb*-ioport:peb:slot2*32kmem*-ioport:peb:slot4*speech* cartridge cart .rpk*.wav*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk -32kb-speech-keyb_nat,,,,,show_message_mamedev \"NO HELP\","
",TI-99/4A(32Kb) + speech + superxb + flop1-525dd,@non-arcade,install_system_mamedev ti99_4a ti99_4a superxb*-ioport*peb*-ioport*peb*-ioport:peb:slot2*32kmem*-ioport:peb:slot3*hfdc*-ioport:peb:slot4*speech* floppydisk1 flop1 .rpk*.wav*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk -32kb-speech-superxb-f1-525dd,,,,,show_message_mamedev \"NO HELP\","
",TI-99/4A(32Kb) + speech + superxb + flop1-525qd,@non-arcade,install_system_mamedev ti99_4a ti99_4a superxb*-ioport*peb*-ioport*peb*-ioport:peb:slot2*32kmem*-ioport:peb:slot3*hfdc*-ioport:peb:slot3:hfdc:f1*525qd*-ioport:peb:slot4*speech* floppydisk1 flop1 .rpk*.wav*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk -32kb-speech-superxb-f1-525qd,,,,,show_message_mamedev \"NO HELP\","
",TI-99/4A(32Kb) + speech + superxb + flop1-35dd,@non-arcade,install_system_mamedev ti99_4a ti99_4a superxb*-ioport*peb*-ioport*peb*-ioport:peb:slot2*32kmem*-ioport:peb:slot3*hfdc*-ioport:peb:slot3:hfdc:f1*35dd*-ioport:peb:slot4*speech* floppydisk1 flop1 .rpk*.wav*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk -32kb-speech-superxb-f1-35dd,,,,,show_message_mamedev \"NO HELP\","
",TI-99/4A(32Kb) + speech + superxb + flop1-35hd,@non-arcade,install_system_mamedev ti99_4a ti99_4a superxb*-ioport*peb*-ioport*peb*-ioport:peb:slot2*32kmem*-ioport:peb:slot3*hfdc*-ioport:peb:slot3:hfdc:f1*35hd*-ioport:peb:slot4*speech* floppydisk1 flop1 .rpk*.wav*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk -32kb-speech-superxb-f1-35hd,,,,,show_message_mamedev \"NO HELP\","
",TI-99/4A(32Kb) + speech + editass + flop1-525dd,@non-arcade,install_system_mamedev ti99_4a ti99_4a editass*-ioport*peb*-ioport*peb*-ioport:peb:slot2*32kmem*-ioport:peb:slot3*hfdc*-ioport:peb:slot4*speech* floppydisk1 flop1 .rpk*.wav*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk -32kb-speech-editass-f1-525dd,,,,,show_message_mamedev \"NO HELP\","
",TI-99/4A(32Kb) + speech + editass + flop1-525qd,@non-arcade,install_system_mamedev ti99_4a ti99_4a editass*-ioport*peb*-ioport*peb*-ioport:peb:slot2*32kmem*-ioport:peb:slot3*hfdc*-ioport:peb:slot3:hfdc:f1*525qd*-ioport:peb:slot4*speech* floppydisk1 flop1 .rpk*.wav*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk -32kb-speech-editass-f1-525qd,,,,,show_message_mamedev \"NO HELP\","
",TI-99/4A(32Kb) + speech + editass + flop1-35dd,@non-arcade,install_system_mamedev ti99_4a ti99_4a editass*-ioport*peb*-ioport*peb*-ioport:peb:slot2*32kmem*-ioport:peb:slot3*hfdc*-ioport:peb:slot3:hfdc:f1*35dd*-ioport:peb:slot4*speech* floppydisk1 flop1 .rpk*.wav*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk -32kb-speech-editass-f1-35dd,,,,,show_message_mamedev \"NO HELP\","
",TI-99/4A(32Kb) + speech + editass + flop1-35hd,@non-arcade,install_system_mamedev ti99_4a ti99_4a editass*-ioport*peb*-ioport*peb*-ioport:peb:slot2*32kmem*-ioport:peb:slot3*hfdc*-ioport:peb:slot3:hfdc:f1*35hd*-ioport:peb:slot4*speech* floppydisk1 flop1 .rpk*.wav*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk -32kb-speech-editass-f1-35hd,,,,,show_message_mamedev \"NO HELP\","
",TI-99/4A(32Kb) + speech + rxb2021 + flop1-525dd,@non-arcade,install_system_mamedev ti99_4a ti99_4a -gromport*multi*-cart1*$datadir/roms/ti99_4a/ti99_cart_rpk/rxb2021.rpk*-ioport*peb*-ioport*peb*-ioport:peb:slot2*32kmem*-ioport:peb:slot3*hfdc*-ioport:peb:slot3:hfdc:f1*525dd*-ioport:peb:slot4*speech* floppydisk1 flop1 .rpk*.wav*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk -32kb-speech-rxb2021-f1-525dd,,,,,show_message_mamedev \"NO HELP\","
",TVC 64 + flop1 support,@non-arcade,install_system_mamedev tvc64 tvc64 -exp1*hbf floppydisk1 flop1 .rpk*.wav*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk,,,,,show_message_mamedev \"NO HELP\","
",Odyssey2 + voice (install odyssey2 and patch default loaders),@non-arcade,install_system_mamedev odyssey2;sed -i \"s/ %B/ -cart1 voice -cart2 %B/g;s/\/ '%B/ -cart1 voice -cart2 '%B/g;s/cart %R/cart1 voice -cart2 %R/g\" $rootdir/configs/odyssey2/emulators.cfg,,,,,show_message_mamedev \"NO HELP\","
",Videopac + voice (install videopac and patch default loaders),@non-arcade,install_system_mamedev videopac;sed -i \"s/ %B/ -cart1 voice -cart2 %B/g;s/\/ '%B/ -cart1 voice -cart2 '%B/g;s/cart %R/cart1 voice -cart2 %R/g\" $rootdir/configs/videopac/emulators.cfg,,,,,show_message_mamedev \"NO HELP\","
    )
#preserved-test-lines
#slot-devices are added but not recognised possibly because it boots with version 1 of the basic rom
#",Coco with ram and floppy 525dd support,@non-arcade,install_system_mamedev coco coco -ext*multi*-ext:multi:slot1*ram floppydisk1 flop1 .mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9,"
#replaced exbasic with superxb (super extended basic)
#",TI-99/4A Home Computer (32Kb) + exbasic + flop1,@non-arcade,install_system_mamedev ti99_4a ti99_4a exbasic*-ioport*peb*-ioport*peb*-ioport:peb:slot2*hfdc*-ioport:peb:slot3*32kmem* floppydisk1 flop1 .mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*,"
#test Odyssey2 + voice : no sound 
#",Odyssey2 + voice,@non-arcade,install_system_mamedev odyssey2 odyssey2 -cart1*voice cartslot2 cart2 .bin*.rom -cart1_voice,"
#manual basename line that works but above lines create custom media loaders not basename loaders
#$emudir/mame/mame -cfg_directory $rootdir/configs/odyssey2/mame -rompath $datadir/BIOS/mame\;$datadir/roms/odyssey2 -v -c -ui_active videopac -cart1 voice -cart2 beespl

    build_menu_mamedev
}


function subgui_systems_extras_add_autoboot_mamedev() {
#With this csv style we can't use quotes or double quotes 
#so if we want to add more options , slotdevices or extensions we replace spaces with *
#later in the install_system_mamedev they are replaced again with spaces
#we also need commas sometimes, here we use a # as a comma, in the install_system_mamedev they are replaced again with a comma
#the options after install_system_mamedev are $1=system $2=RPsystemName $3=ExtraPredefinedOption(s) $4=mediadescription $5=media $6=extension(s)
#example on how we can create the extensions options : $emudir/mame/mame -listmedia hbf700p|sed 's/  \./*\./g'
#!!! make sure all available extensions of a system are added because extensions are overwritten when installing a system !!!
# adding a newline can be done in multiple ways => \\'\\\\\n\\' (very good) or => \\\\\\n (works most of the times)
# adding some special characters isn't always possible the normal way, escaping the char with multiple \
# this is because the csv line is quoted with doublequotes and the delimiter  , is used to separate the "cells", also an extra * delimiter is used within "cells" to create a virtual 3D "worksheet"
# adding special characters is possible using ascii hex-code 
# check (https://www.cyberciti.biz/faq/unix-linux-sed-ascii-control-codes-nonprintable/)
# or (https://www.freecodecamp.org/news/ascii-table-hex-to-ascii-value-character-code-chart-2/)
# " => \\'\\\\\x22\\'
# * => \\'\\\\\x2a\\'
# , => \\'\\\\\x2c\\'
# : => \\'\\\\\x3a\\'

    local csv=()
    csv=(
",menu_item_handheld_description,to_do driver_used_for_installation,"
",Coco + ram + cassette + cload (auto) > run (manual),@non-arcade,install_system_mamedev coco coco -ext*ram*-autoboot_delay*2*-autoboot_command*cload\\'\\\\\n\\' cassette cass .wav*.cas*.ccc*.rom -extra_ram-autoboot-cload,"
",Coco + ram + cassette + cloadm:exec (auto),@non-arcade,install_system_mamedev coco coco -ext*ram*-autoboot_delay*2*-autoboot_command*cloadm:exec\\'\\\\\n\\' cassette cass .wav*.cas*.ccc*.rom -extra_ram-autoboot-cloadm:exec,"
	)
[[ $(expr $rp_module_version_mame + 0) -gt 254 ]] && \
    csv+=(
",\Zr(>0254)\ZRCoco + floppy + os9 + dos (auto),@non-arcade,install_system_mamedev coco coco -autoboot_delay*2*-autoboot_command*dos\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-dos-os9,"
",\Zr(>0254)\ZRCoco + floppy + load\"%BASENAME%\" + run (auto),@non-arcade,install_system_mamedev coco coco -autoboot_delay*2*-autoboot_command*load\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\'\\'\\\\\x2c\\'r\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-load_BASENAME_-run,"
",\Zr(>0254)\ZRCoco + floppy + run\"%BASENAME%\" (auto),@non-arcade,install_system_mamedev coco coco -autoboot_delay*2*-autoboot_command*run\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\'\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-run_BASENAME_,"
",\Zr(>0254)\ZRCoco + floppy + loadm\"%BASENAME%\":exec (auto),@non-arcade,install_system_mamedev coco coco -autoboot_delay*2*-autoboot_command*loadm\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\':exec\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-loadm_BASENAME_:exec,"
	)
[[ $(expr $rp_module_version_mame + 0) -lt 255 ]] && \
    csv+=(
",\Zr(<0255)\ZRCoco 2 + ram + cassette + cload (auto) > run (manual),@non-arcade,install_system_mamedev coco2 coco2 -ext*ram*-autoboot_delay*2*-autoboot_command*cload\\'\\\\\n\\' cassette cass .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -extra_ram -extra_ram-autoboot-cload,"
",\Zr(<0255)\ZRCoco 2 + ram + cassette + cloadm:exec (auto),@non-arcade,install_system_mamedev coco2 coco2 -ext*ram*-autoboot_delay*2*-autoboot_command*cloadm:exec\\'\\\\\n\\' cassette cass .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -extra_ram -extra_ram-autoboot-cloadm:exec,"
",\Zr(<0255)\ZRCoco 2 + floppy + os9 + dos (auto),@non-arcade,install_system_mamedev coco2 coco2 -autoboot_delay*2*-autoboot_command*dos\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-dos-os9,"
",\Zr(<0255)\ZRCoco 2 + floppy + load\"%BASENAME%\" + run (auto),@non-arcade,install_system_mamedev coco2 coco2 -autoboot_delay*2*-autoboot_command*load\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\'\\'\\\\\x2c\\'r\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-load_BASENAME_-run,"
",\Zr(<0255)\ZRCoco 2 + floppy + run\"%BASENAME%\" (auto),@non-arcade,install_system_mamedev coco2 coco2 -autoboot_delay*2*-autoboot_command*run\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\'\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-run_BASENAME_,"
",\Zr(<0255)\ZRCoco 2 + floppy + loadm\"%BASENAME%\":exec (auto),@non-arcade,install_system_mamedev coco2 coco2 -autoboot_delay*2*-autoboot_command*loadm\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\':exec\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-loadm_BASENAME_:exec,"
    )
    csv+=(
",Coco 3 + ram + cassette + cload (auto) > run (manual),@non-arcade,install_system_mamedev coco3 coco3 -ext*ram*-autoboot_delay*2*-autoboot_command*cload\\'\\\\\n\\' cassette cass .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -extra_ram-autoboot-cload,"
",Coco 3 + ram + cassette + cloadm:exec (auto),@non-arcade,install_system_mamedev coco3 coco3 -ext*ram*-autoboot_delay*2*-autoboot_command*cloadm:exec\\'\\\\\n\\' cassette cass .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -extra_ram--autoboot-cloadm:exec,"
",Coco 3 + floppy 525dd + os9 + dos (auto),@non-arcade,install_system_mamedev coco3 coco3 -autoboot_delay*2*-autoboot_command*dos\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-dos-os9-525dd,"
",Coco 3 + floppy 525dd + load\"%BASENAME%\" + run (auto),@non-arcade,install_system_mamedev coco3 coco3 -autoboot_delay*2*-autoboot_command*load\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\'\\'\\\\\x2c\\'r\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-load_BASENAME_-run-525dd,"
",Coco 3 + floppy 525dd + run\"%BASENAME%\" (auto),@non-arcade,install_system_mamedev coco3 coco3 -autoboot_delay*2*-autoboot_command*run\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\'\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-run_BASENAME_-525dd,"
",Coco 3 + floppy 525dd + loadm\"%BASENAME%\":exec (auto),@non-arcade,install_system_mamedev coco3 coco3 -autoboot_delay*2*-autoboot_command*loadm\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\':exec\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-loadm_BASENAME_:exec-525dd,"
",Coco 3 + ram + floppy 525dd + os9 + dos (auto),@non-arcade,install_system_mamedev coco3 coco3 -ext*multi*-ext:multi:slot1*ram*-autoboot_delay*2*-autoboot_command*dos\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-dos-extra_ram-os9-525dd,"
",Coco 3 + ram + floppy 525dd + load\"%BASENAME%\" + run (auto),@non-arcade,install_system_mamedev coco3 coco3 -ext*multi*-ext:multi:slot1*ram*-autoboot_delay*2*-autoboot_command*load\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\'\\'\\\\\x2c\\'r\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -extra_ram-autoboot-load_BASENAME_-run-525dd,"
",Coco 3 + ram + floppy 525dd + run\"%BASENAME%\" (auto),@non-arcade,install_system_mamedev coco3 coco3 -ext*multi*-ext:multi:slot1*ram*-autoboot_delay*2*-autoboot_command*run\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\'\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -extra_ram-autoboot-run_BASENAME_-525dd,"
",Coco 3 + ram + floppy 525dd + loadm\"%BASENAME%\":exec (auto),@non-arcade,install_system_mamedev coco3 coco3 -ext*multi*-ext:multi:slot1*ram*-autoboot_delay*2*-autoboot_command*loadm\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\':exec\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -extra_ram-autoboot-loadm_BASENAME_:exec-525dd,"
",Dragon 32 + ram + cassette + cload (auto) > run (manual),@non-arcade,install_system_mamedev dragon32 dragon32 -ext*ram*-autoboot_delay*2*-autoboot_command*cload\\'\\\\\n\\' cassette cass .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -extra_ram-autoboot-cload,"
",Dragon 32 + ram + cassette + cloadm:exec (auto),@non-arcade,install_system_mamedev dragon32 dragon32 -ext*ram*-autoboot_delay*2*-autoboot_command*cloadm:exec\\'\\\\\n\\' cassette cass .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -extra_ram-autoboot-cloadm:exec,"
",Dragon 32 + floppy 525qd + load\"%BASENAME%\" + run (auto),@non-arcade,install_system_mamedev dragon32 dragon32 -autoboot_delay*3*-autoboot_command*load\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\'\\'\\\\\x2c\\'r\\'\\\\\n\\' floppydisk1 flop1 .mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -autoboot-load_BASENAME_-run-525qd,"
",Dragon 32 + floppy 525qd + run\"%BASENAME%\" (auto),@non-arcade,install_system_mamedev dragon32 dragon32 -autoboot_delay*3*-autoboot_command*run\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\'\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -autoboot-run_BASENAME_-525qd,"
",Dragon 32 + floppy 525qd + loadm\"%BASENAME%\":exec (auto),@non-arcade,install_system_mamedev dragon32 dragon32 -autoboot_delay*3*-autoboot_command*loadm\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\':exec\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -extra_ram-autoboot-loadm_BASENAME_:exec-525qd,"
",Dragon 32 + ram + floppy 525qd + load\"%BASENAME%\" + run (auto),@non-arcade,install_system_mamedev dragon32 dragon32 -ext*multi*-ext:multi:slot1*ram*-autoboot_delay*3*-autoboot_command*load\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\'\\'\\\\\x2c\\'r\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -extra_ram-autoboot-load_BASENAME_-run-525qd,"
",Dragon 32 + ram + floppy 525qd + run\"%BASENAME%\" (auto),@non-arcade,install_system_mamedev dragon32 dragon32 -ext*multi*-ext:multi:slot1*ram*-autoboot_delay*3*-autoboot_command*run\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\'\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -extra_ram-autoboot-run_BASENAME_-525qd,"
",Dragon 32 + ram + floppy 525qd + loadm\"%BASENAME%\":exec (auto),@non-arcade,install_system_mamedev dragon32 dragon32 -ext*multi*-ext:multi:slot1*ram*-autoboot_delay*3*-autoboot_command*loadm\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\':exec\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -extra_ram-autoboot-loadm_BASENAME_:exec-525qd,"
",(Tano) Dragon 64 NTSC + ram + cassette + cload (auto) > run (manual),@non-arcade,install_system_mamedev tanodr64 dragon64 -ext*ram*-autoboot_delay*2*-autoboot_command*cload\\'\\\\\n\\' cassette cass .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -extra_ram-autoboot-cload,"
",(Tano) Dragon 64 NTSC + ram + cassette + cloadm:exec (auto),@non-arcade,install_system_mamedev tanodr64 dragon64 -ext*ram*-autoboot_delay*2*-autoboot_command*cloadm:exec\\'\\\\\n\\' cassette cass .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -extra_ram-autoboot-cloadm:exec,"
",(Tano) Dragon 64 NTSC + fdc + floppy 525qd + load\"%BASENAME%\" + run (auto),@non-arcade,install_system_mamedev tanodr64 dragon64 -ext*multi*-ext:multi:slot1*ram*-ext*dragon_fdc*-autoboot_delay*3*-autoboot_command*load\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\'\\'\\\\\x2c\\'r\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -autoboot-load_BASENAME_-run-525qd,"
",(Tano) Dragon 64 NTSC + fdc + floppy 525qd + run\"%BASENAME%\" (auto),@non-arcade,install_system_mamedev tanodr64 dragon64 -ext*dragon_fdc*-autoboot_delay*3*-autoboot_command*run\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\'\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -autoboot-run_BASENAME_-525qd,"
",(Tano) Dragon 64 NTSC + fdc + floppy 525qd + loadm\"%BASENAME%\":exec (auto),@non-arcade,install_system_mamedev tanodr64 dragon64 -ext*dragon_fdc*-autoboot_delay*3*-autoboot_command*loadm\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\':exec\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -autoboot-loadm_BASENAME_:exec-525qd,"
",(Tano) Dragon 64 NTSC + ram + dfc + floppy 525qd + load\"%BASENAME%\" + run (auto),@non-arcade,install_system_mamedev tanodr64 dragon64 -ext*dragon_fdc*-autoboot_delay*3*-autoboot_command*load\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\'\\'\\\\\x2c\\'r\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -extra_ram-autoboot-load_BASENAME_-run-525qd,"
",(Tano) Dragon 64 NTSC + ram + dfc + floppy 525qd + run\"%BASENAME%\" (auto),@non-arcade,install_system_mamedev tanodr64 dragon64 -ext*multi*-ext:multi:slot1*ram*-ext*dragon_fdc*-autoboot_delay*3*-autoboot_command*run\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\'\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -extra_ram-autoboot-run_BASENAME_-525qd,"
",(Tano) Dragon 64 NTSC + ram + dfc + floppy 525qd + loadm\"%BASENAME%\":exec (auto),@non-arcade,install_system_mamedev tanodr64 dragon64 -ext*multi*-ext:multi:slot1*ram*-ext*dragon_fdc*-autoboot_delay*3*-autoboot_command*loadm\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\':exec\\'\\\\\n\\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -extra_ram-autoboot-loadm_BASENAME_:exec-525qd,"
",Electron + cassette + *tape chain\"\"(auto),@non-arcade,install_system_mamedev electron electron -autoboot_delay*2*-autoboot_command*\\'\\\\\x2a\\'TAPE\\'\\\\\n\\'CHAIN\\'\\\\\x22\\'\\'\\\\\x22\\'\\'\\\\\n\\' cassette cass .wav*.csw*.uef*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.ssd*.bbc*.img*.dsd*.adf*.ads*.adm*.adl*.rom*.bin -autoboot-tape-chain,"
",Electron + cassette + *tape *run(auto),@non-arcade,install_system_mamedev electron electron -autoboot_delay*2*-autoboot_command*\\'\\\\\x2a\\'TAPE\\'\\\\\n\\'\\'\\\\\x2a\\'RUN\\'\\\\\n\\' cassette cass .wav*.csw*.uef*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.ssd*.bbc*.img*.dsd*.adf*.ads*.adm*.adl*.rom*.bin -autoboot-tape-tun,"
",MSX1 Philips VG-8020-20 + cassette + run\"cas:\" (auto),@non-arcade,install_system_mamedev vg802020 msx -autoboot_delay*6*-autoboot_command*run\\'\\\\\x22\\'cas\\'\\\\\x3a\\'\\'\\\\\x22\\'\\'\\\\\x2c\\'r\\'\\\\\n\\' cassette cass .wav*.tap*.cas*.mx1*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dm -autoboot-run,"
",MSX1 Philips VG-8020-20 + cassette + bload\"cas:\" + run (auto),@non-arcade,install_system_mamedev vg802020 msx -autoboot_delay*6*-autoboot_command*bload\\'\\\\\x22\\'cas\\'\\\\\x3a\\'\\'\\\\\x22\\'\\'\\\\\x2c\\'r\\'\\\\\n\\' cassette cass .wav*.tap*.cas*.mx1*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dm -autoboot-bload,"
",MSX2 Sony HB-F700P + disk + run\"%BASENAME%\" (auto),@non-arcade,install_system_mamedev hbf700p msx2 -autoboot_delay*5*-autoboot_command*run\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\'\\'\\\\\n\\' floppydisk flop  .wav*.tap*.cas*.mx1*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk -autoboot-run_BASENAME_,"
",MSX2 Sony HB-F700P + disk + bload\"%BASENAME%\" + run (auto),@non-arcade,install_system_mamedev hbf700p msx2 -autoboot_delay*5*-autoboot_command*bload\\'\\\\\x22\\'%BASENAME%\\'\\\\\x22\\'\\'\\\\\x2c\\'r\\'\\\\\n\\' floppydisk flop  .wav*.tap*.cas*.mx1*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk -autoboot-bload_BASENAME_+run,"
",Sam Coupe + floppy + boot (auto),@non-arcade,install_system_mamedev samcoupe samcoupe -autoboot_delay*2*-autoboot_command*\\'\\\\\n\\'boot\\'\\\\\n\\' floppydisk flop1  .wav*.tzx*.tap*.blk*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.mgt -autoboot-boot,"
",Sinclair ZX-81 + cassette + load\"\" (auto) > play tape (+ run) (manual),@non-arcade,install_system_mamedev zx81 zx81 -autoboot_delay*3*-autoboot_command*j\\'\\\\\x22\\'\\'\\\\\x22\\'\\'\\\\\n\\' cassette cass  *.wav*.p*.81*.tzx -autoboot-load-manual_run,"
	)
	
    build_menu_mamedev
}


function subgui_downloads_mamedev () {
    local csv=()
    csv=(
",menu_item,,to_do,,,,,help_to_do,"
",$([[ $(sha1sum $rootdir/supplementary/runcommand/runcommand.sh 2>&-) != 739b6c7e50c6b4e2d048ea85f93ab8c71b1a1d74* ]] && echo Install patched runcommand.sh with extra replace tokens)$([[ $(sha1sum $rootdir/supplementary/runcommand/runcommand.sh 2>&-) == 739b6c7e50c6b4e2d048ea85f93ab8c71b1a1d74* ]] && echo Restore to original runcommand.sh),,install_or_restore_runcommand_script_mamedev,,,,,show_message_mamedev \"This option can do two things.\nIf the original runcommand.sh is detected then install the patched runcommand.sh with extra replace tokens.\nIf the patched runcommand.sh is detected then restore to the original runcommand.sh.\n\nIf the patched runcommand.sh is installed the runcommands that are installed by the script will automatically have the extra replace tokens inside.\nIf the original runcommand.sh is installed the runcommands that are installed by the script will not have the extra replace tokens inside !\n\nThe patched runcommand.sh will have the following extra replace tokens or improvements :\n\n%ROMDIR%\nThe %ROMDIR% token can be used to add the rompath in a runcommand.\nWhen using a runcommand using %BASENAME$ the rom can always be found even in a sub-directory. This also makes it possible to categorise roms in different folders within a roms directory.\n\n%DQUOTE% :\nThe %ROMDIR% token does not have double quoting.\nWhy? Because lr-mame and lr-mess can't cope with it.\nFor this reason the %DQUOTE% token is added.\nThe %DQUOTE% token can be placed in other places to get the runcommand working especially when using subdirectories that have spaces in them.\nFor MAME standalone this will work :\n-rompath $datadir/BIOS/mame;%DQUOTE%%ROMDIR%%DQUOTE%\nFor lr-mame and lr-mess this will work :\n-rompath %DQUOTE%$datadir/BIOS/mame;%ROMDIR%/%DQUOTE%\nAll other attempts to add double quotes to runcommands in a different way failed so using the %DQUOTE% token seems to only way to go.\n\n%CLEANBASENAME% :\nThe %CLEANBASENAME% token is needed for creating a proper per game config directory so mame system configs can be created per game.\nFor MAME standalone this would not be necessary but lr-mame and lr-mess can't cope with spaces and double quotes in the wrong places.\nTherefor the %CLEANBASENAME% token can be used which removes all spaces and special characters and is without any double quotes.\nThe %CLEANBASENAME% token could also be used to make a clean savestate file\n\n%SOFTLIST% :\nThe %SOFTLIST% token is needed to force proper softlist loading\nFor example pacmania is in msx1_cass and in msx2_cart.\nIf one loads a game with a basename loader for example pacmania which comes from msx2_cart then normally the soflist msx1_cass has priority over msx2_cart.\nSo mame thinks it's pacmania from msx1_cass but it is actually pacmania from msx2_cart.\nTo fix this issue we need to force the correct softlist before the %BASENAME% token.\nThe %SOFTLIST% token is the last folder name where the rom is in plus an extra => :.\nFor pacmania we will have to place it in the folder msx2_cart.\nIn the loader you will see it as %SOFTLIST%%BASENAME% eventually for pacmania it will look like this msx2_cart:pacmania.\nIf the rom is in a rompath without => _ then the %SOFTLIST% token will be empty and mame will guess the correct softlist.\nIf %SOFTLIST% token gets a value for some reason because a _ char is in the path then mame will refuse to load the game.\nA check in the runcommand.log will reveal the issue.\nAlthough it's an improvement for example msx1_bee_card softlist will not benefit from it as it needs the beepack to be inserted as a slot. So softlists that need slot options will still not work with the regular basename loaders.\","
",$([[ ! -f $scriptdir/scriptmodules/run_mess.sh ]] && echo Install @valerino run_mess.sh script \(the RusselB version\))$([[ -f $scriptdir/scriptmodules/run_mess.sh ]] && echo Remove the Valerino run_mess.sh script \(the RusselB version\)),,install_or_remove_run_mess_script_mamedev,,,,,show_message_mamedev \"This option can do two things.\nIf run_mess.sh is not detected then install it.\nIf run_mess.sh is detected then remove it.\n\nThis is the history of the run_mess.sh script :\n@Valerino started the topic 'new scriptmodules for proper lr-mess integration'. For that purpose he made the run_mess.sh script. He also made module-scripts for various lr-mess drivers so they could be installed seperately.
The runcommands that were installed by the module-scripts used this run_mess.sh script. Basically collecting the options from the runcommand and then creating a .cmd file which can then be runned by lr-mess. Every time a .cmd file is made and removed afterwards when running a game.\n\nThis script used that same run_mess.sh to be backwards compatible with the work of @Valerino. Later @RusselB improved the script.\nHe said : My improvevement allowed me to specify custom configs including bezels and screen locations etc. per rom.\n\nBasically the run_mess.sh script isn't needed anymore as we now use direct runcommands.\nSo when this run_mess.sh script is not installed the runcommands are not created anymore\nIf however you still want to use the old runcommands using the run_mess.sh script then you can install it and the script will make these older runcommands when installing a driver.\","
",,,,"
",Download a predefined emulationstation es_input.cfg,,download_from_github_mamedev  FollyMaddy/RetroPie-Share/tree/main/00-emulationstation-00 $rootdir/configs/all/emulationstation cfg,,,,,show_message_mamedev \"Annoyingly everytime when you start with a new RetroPie you have to setup your keyboard or joystick again in emulationstation. The es_input.cfg file mentioned in this option can be downloaded to skip the process of configuring the inputs when starting emulationstation for the first time. The es_input.cfg has already several predefined input devices like :\n- keyboard (basic keys : not all keys are added !)\n- Padix Co. Ltd. QZ 501 PREDATOR \n- Nintendo Wiimote\n- PSX controller\n- Usb Gamepad (BigBen_Interactive_Usb_Gamepad)\n- Padix Co. Ltd. 2-axis 8-button gamepad\n- Padix Co. Ltd. 4-axis 4-button joystick w/view finder\n- Padix Co Ltd. 4-axis 4-button joystick\n\nBeware : If your input device isn't in this es_input.cfg then you probably don't want to use this config file.\nHowever more input devices can be committed to the es_input.cfg in the future.\","
",Download retroarch-joypad-autoconfigs (+/-1 min.),,download_from_github_mamedev  libretro/retroarch-joypad-autoconfig/tree/master/udev $rootdir/configs/all/retroarch-joypads cfg;download_from_github_mamedev  FollyMaddy/RetroPie-Share/tree/main/00-retroarch-00/retroarch-joypad-autoconfig $rootdir/configs/all/retroarch-joypads cfg,,,,,show_message_mamedev \"The autoconfig files mentioned in this option are used to recognize input devices and to automatically setup the default mappings between the physical device and the RetroPad virtual controller.\nThe configs come from :\nhttps://github.com/libretro/retroarch-joypad-autoconfig/tree/master/udev\nhttps://github.com/FollyMaddy/RetroPie-Share/tree/main/00-retroarch-00/retroarch-joypad-autoconfig\n\nThe configs are placed in :\n$rootdir/configs/all/retroarch-joypads\","
",Download lr-mess configs for better button mapping (+/-1 min.),,download_from_google_drive_mamedev 1Js34M6b8n97CUp_Bf_x4FfpG68oKL3I5 $rootdir/configs,,,,,show_message_mamedev \"Most handheld games don't use the same joystick layout. To make it more universal @bbilford83 made some custom configs. Basically it means that the shooter button is always the same in these games.\n\nThe added game button configs are for the categories :\n- konamih ($rootdir/configs/konamih/lr-mess)\n- tigerh ($rootdir/configs/tigerh/lr-mess)\n\nKnown compatible joypads are :\n- 8bitdo\n- BigBen\n- PiBoy\n\nFiles are downloaded from the google-drive of @bbilford83 :\n1RTxt9lZpGwtbNsrPRV9_FJChpk_iDiDE\","
",,,,"
",►Download cheatfile from list,,subgui_download_cheat_mamedev,,,,,show_message_mamedev \"When this script installs a system or category the cheat option in the configs will be turned on in lr-mess/lr-mame and MAME. Together with the cheat file you will be able to use cheats on certain games. The cheat file used can be found on http://www.mamecheat.co.uk\","
",,,,"
",Download/update all ES gamelists with media (+/-30 min.),,download_from_google_drive_mamedev 1f_jXMG0XMBdyOOBpz8CHM6AFj9vC1R6m $datadir/roms,,,,,show_message_mamedev \"Here you will find predefined gamelists with videos and pictures. These are created to have a good preview in emulationstation of the games you can select. In contrary to where the gamelists are normally stored these gamelists are stored in :\n~$datadir/roms/<system>\nThis makes it easier to backup the gamelists together with your roms and it prevents from overwriting gamelist files in other locations.\n\nWhen selecting this option all available gamelists with media are downloaded.\","
",►Download/update gamelists with media per system,,subgui_download_gamelists_mamedev 1f_jXMG0XMBdyOOBpz8CHM6AFj9vC1R6m,,,,,show_message_mamedev \"Here you will find predefined gamelists with videos and pictures. These are created to have a good preview in emulationstation of the games you can select. In contrary to where the gamelists are normally stored these gamelists are stored in :\n~$datadir/roms/<system>\nThis makes it easier to backup the gamelists together with your roms and it prevents from overwriting gamelist files in other locations.\n\nWhen selecting this option you can choose to download the gamelists seperately.\","
",►Retroscrape/update gamelists with media per system,,retroscraper_remote_depends_mamedev;subgui_retroscraper_gamelists_mamedev,,,,,show_message_mamedev \"Here you will be able to retroscrape roms creating gamelists with videos and pictures depending on the database of retroscraper.\nThe gamelists are stored in :\n~$datadir/roms/<system>\nThis makes it easier to backup the gamelists together with your roms and it prevents from overwriting gamelist files in other locations.\nExisting gamelist files and media are removed before a new retroscrape !\n\nWhen selecting this option you can choose to retroscrape a system folder seperately.\","
",,,,"
",Download/update mame artwork (+/-30 min.),,download_from_google_drive_mamedev 1sm6gdOcaaQaNUtQ9tZ5Q5WQ6m1OD2QY3 $datadir/roms/mame/artwork,,,,,show_message_mamedev \"Here you will find the artwork files needed for a lot of handheld games and it's basically only working on MAME standalone. Some artwork files are custom made others are from other sources. Though we changed the background and bezel filenames in the archives so the options 'Create RetroArch xxxxxxxxxxx-overlays' can make use of these artwork files by extracting the overlay pictures and use them for lr-mess and lr-mame in retroarch.\","
",Create RetroArch background-overlays from artwork,,create_background_overlays_mamedev,,,,,show_message_mamedev \"This option only works if you have downloaded the artwork files for MAME standalone earlier on. A selection of background filenames are extracted from the MAME artwork files and overlay configs are created for use with lr-mess/lr-mame in retroarch.\","
",Create RetroArch 16:9 bezel-overlays from artwork,,create_bezel_overlays_mamedev -16-9,,,,,show_message_mamedev \"This option only works if you have downloaded the artwork files for MAME standalone earlier on. A selection of bezel filenames are extracted from the MAME artwork files and overlay configs are created for use with lr-mess/lr-mame in retroarch.\","
",Create RetroArch 16:9 bezel-overlays from artwork (+alternatives),,create_bezel_overlays_mamedev -16-9;create_bezel_overlays_mamedev 2-16-9,,,,,show_message_mamedev \"This option only works if you have downloaded the artwork files for MAME standalone earlier on. A selection of bezel filenames are extracted from the MAME artwork files and overlay configs are created for use with lr-mess/lr-mame in retroarch.\n\nIn contrary to the regular option this option will get some alternative looking bezels.\","
",,,,"
",Setup Orionsangels Realistic Arcade Overlays > roms/realistic,@arcade,create_00index_file_mamedev '/@oro/' $datadir/roms/realistic;install_system_mamedev realistic realistic '' '' 'none' '';download_from_google_drive_mamedev 1m_8-LJpaUFxUtwHCyK4BLo6kiFsvMJmM $datadir/downloads;organise_realistic_overlays_mamedev,,,,,show_message_mamedev \"Orionsangels made a lot of realistic bezels for lr-mame in retroarch. Manually installing was a bit difficult as the files were for windows only. On top of that the configs also had fixed resolutions which is problematic when you don't use the same resolution.\n\nSelecting this option will install the category \"realistic\" in your roms directory. The bezels will be downloaded and patched for linux use and the resolutions will be converted to the resolution that is detected. If you change the resolution of your setup you have to select this option again so the configs are recreated again with the proper resolution settings. Selecting this a second time will skip downloading the bezels if they are still on your computer.\","
    )
    build_menu_mamedev
}


function subgui_databases_mamedev() {
    local csv=()
    local database_read
    clear
    echo "reading the available databases"
    #the first value is reserved for the column descriptions and empty in the array rp_module_database_versions
    while read database_read;do csv+=("$database_read");done < <(IFS=$'\n'; echo "${rp_module_database_versions[*]}"|while read line;do echo "\",Set database to $line,,rp_module_version_mame=$line;mamedev_csv=(),\"";done)
    build_menu_mamedev
    #"break" after usage in function build_menu_mamedev
}


function subgui_download_cheat_mamedev() {
	show_message_mamedev "\
A list of cheats from mamecheats.co.uk will be presented.\n\
Selecting one will download the selected cheatfiles in /tmp/\n\
Then it will be extracted and overwritten in :\n\
- $datadir/BIOS/mame/cheat (for lr-mess)\n\
- $datadir/roms/mame/cheat (for mame)"
    local csv=()
    #the first value is reserved for the column descriptions
    csv=( ",,,," )
    local mamecheat_read
    clear
    echo "reading the available binaries"
    while read mamecheat_read;do csv+=("$mamecheat_read");done < <(IFS=$'\n'; curl http://cheat.retrogames.com/mame_downloads.htm|grep ">XML"|sed 's/</"/g;s/>/"/g;s/XML //g;s/Release Date: //g'|while read line;do echo "\",$(echo $line|cut -d\" -f7),,download_cheats_mamedev $(echo $line|cut -d\" -f5),\"";done)
    build_menu_mamedev
}


function subgui_download_gamelists_mamedev() {
    local csv=()
    local gamelists_csv=()
    local gamelists_read
    clear
    echo "reading the individual gamelist data"
    #we need to add 'echo \",,,,\";', because otherwise the first value isn't displayed as it is reserved for the column descriptions
    while read gamelists_read;do gamelists_csv+=("$gamelists_read");done < <(echo \",,,,\";curl https://drive.google.com/embeddedfolderview?id=$1#list|sed 's/https/\nhttps/g'|grep folders|sed 's/folders\//folders\"/g;s/>/"/g;s/</"/g'|while read line;do echo "\",Download/update only for '$(echo $line|cut -d '"' -f50)',,download_from_google_drive_mamedev $(echo $line|cut -d '"' -f2) $datadir/roms/$(echo $line|cut -d '"' -f50),\"";done)
    IFS=$'\n' csv=($(sort -t"," -d -k 2 --ignore-case <<<"${gamelists_csv[*]}"));unset IFS
    build_menu_mamedev
}


function subgui_remove_installs_mamedev() {
    local csv=()
    #the first value is reserved for the column descriptions
    csv=( ",,,," )
    local installed_system_read
    clear
    echo "reading the available databases"
    while read installed_system_read;do csv+=("$installed_system_read");done < <(grep -r ^mame- $rootdir/configs/*/emulators.cfg|cut -d/ -f5|uniq|while read line;do echo "\",Remove $line,,remove_installs_mamedev $line,\"";done)
    if [[ -z ${csv[1]} ]]; then
    show_message_mamedev "No systems installed, use cancel to go back !"
    csv+=( ",,,," )
    fi
    build_menu_mamedev
    #"break" after usage in function build_menu_mamedev
}


function subgui_retroscraper_gamelists_mamedev() {
    local csv=()
    local gamelists_csv=()
    local gamelists_read
    clear
    echo "reading the individual gamelist data"
    #we need to add 'echo \",,,,\";', because otherwise the first value isn't displayed as it is reserved for the column descriptions
    while read gamelists_read;do gamelists_csv+=("$gamelists_read");done < <(echo \",,,,\";ls -w1 $datadir/roms|while read line;do echo "\",Retroscrape/update only for $([[ $line == *º ]]&&echo ' ')$(if [[ -f $datadir/roms/$line/gamelist.xml ]];then printf '%-20s\\\Z2(has gamelist)\n' $line;else printf '%-20s(no  gamelist)\n' $line;fi),,retroscraper_remote_command_mamedev $line,\"";done)
    IFS=$'\n' csv=($(sort -t"," -d -k 2 --ignore-case <<<"${gamelists_csv[*]}"));unset IFS
    build_menu_mamedev
}


function remove_installs_mamedev() {
    cat $rootdir/configs/$1/emulators.cfg|grep -v default|awk '/mame-/||/mess-/'|cut -d= -f1|while read line;do delEmulator $line $1;done
    [[ ! -f $rootdir/configs/$1/emulators.cfg ]] && delSystem $1
    #"break" after usage in function build_menu_mamedev
}


function retroscraper_remote_command_mamedev() {
    rm $datadir/roms/$1/gamelist.xml 2> /dev/null
    rm -r $datadir/roms/$1/media/emulationstation 2> /dev/null
    su $user -c "curl https://raw.githubusercontent.com/zayamatias/retroscraper-remote/main/retroscraper.py|python3 - --systems $1 --recursive --relativepaths --mediadir media/emulationstation --nobackup"
    #"break" after usage in function build_menu_mamedev so a good list of present gamelists can be viewed
}


function subgui_alphabetical_order_selection_mamedev() {
    local csv=()
    local system_or_description=$1
    csv=( ",menu_item,,to_do," )
    for letter in {#,{A..Z}}
    do 
      csv+=( "\",$letter upon $system_or_description,,create_systems_list_mamedev $system_or_description$letter,\"" )
      #echo ${csv[@]}; sleep 10
    done
    build_menu_mamedev
}


function subgui_search_mamedev() {
    local csv=()
    local system_or_description=$1
    local search

    search=$(dialog \
--no-cancel \
--default-item "$default" \
--backtitle "$__backtitle" \
--title "Insert up to 5 search patterns" \
--form "" \
22 76 16 \
"Search pattern(s):" 1 1 "" 1 22 76 100 \
2>&1 >/dev/tty \
)

    csv=(
",menu_item,,to_do,"
",Display your own sorted list,,create_systems_list_mamedev $system_or_description $search,"
    )
    build_menu_mamedev
}


function subgui_archive_downloads_mamedev() {
    #we can add up to 5 options per list to sort on
    #remember : the first search option will be changed by the script to get search options beginning with, if you want a global search  do something like this : '//&&/hdv/'
    #rompack name, file extension and rompack link 
    #local rompack_link_info=( "mame-0.231-merged" ".7z" "mame-0.231-merged" )
    local rompack_link_info=( "mame-merged \Zb\Z2NEWEST" ".zip" "mame-merged/mame-merged/" )
    local csv=()
    csv=(
",menu_item,,to_do,"
",▼\ZrBrowse BIOS files and download to BIOS/mame\ZR,,,"
",BIOS/mame < (OLD-SET)MAME_0.224_ROMs_merged,,subform_archive_single_download_mamedev '//' $datadir/BIOS/mame MAME_0.224_ROMs_merged download,,,,,show_message_mamedev \"NO HELP\","
",BIOS/mame < (NEW-SET)mame-0.240-roms-split_202201,,subform_archive_single_download_mamedev '//' $datadir/BIOS/mame mame-0.240-roms-split_202201/MAME%200.240%20ROMs%20%28split%29/ download,,,,,show_message_mamedev \"NO HELP\","
",BIOS/mame < (NEW-SET)mame-merged  \Zb\Z2NEWEST,,subform_archive_single_download_mamedev '//' $datadir/BIOS/mame mame-merged/mame-merged/ download,,,,,show_message_mamedev \"NO HELP\","
",,,,"
",▼\ZrBrowse BIOS files < NOT FOUND in last runcommand.log,,,"
",BIOS/mame < BIOS(es) NOT FOUND < mame-merged  \Zb\Z2NEWEST,,subform_archive_single_download_mamedev \"$(echo /$(cat /dev/shm/runcommand.log |grep "NOT FOUND"|sed 's/.*in //g;s/)//g;s/ /\n/g'|sort -u)\\\./|sed 's/ /\\\.\/\|\|\//g')\" $datadir/BIOS/mame mame-merged/mame-merged/ download,,,,,show_message_mamedev \"When games don't work they probably miss rom files somewhere. Normally you can find these errors in the /dev/shm/runcommand.log when searching for the lines NOT FOUND. This part will do this automatically for you and it will add the roms in a list when applying the appropriate archive.xxx website information. Remember it will display roms you have and roms you don't have. Select the roms you don't have. These roms will be saved in the BIOS/mame directory. Now try loading the rom again and you will see that it works. ;-)\n\nFor those who run this for solving problems with more games without exiting the script (you can only do this from the X enviroment when you run games and also run the RetroPie-Setup simultaneously). To get fresh results you have to exit the restricted area and restart the line again.\","
",,,,"
",▼\ZrBrowse software files and download to RetroPie/downloads,,,"
",RetroPie/downloads < (OLD-SET)MAME_0.202_Software_List_ROMs_merged,,subform_archive_single_download_mamedev '//' $datadir/downloads/MAME_0.202_Software_List_ROMs_merged MAME_0.202_Software_List_ROMs_merged download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/downloads < (OLD-SET)MAME_0.224_ROMs_merged,,subform_archive_single_download_mamedev '//' $datadir/downloads/MAME_0.224_ROMs_merged MAME_0.224_ROMs_merged download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/downloads < (NEW-SET)mame-0.240-roms-split_202201,,subform_archive_single_download_mamedev '//' $datadir/downloads/mame-0.240-roms-split_202201 mame-0.240-roms-split_202201/MAME%200.240%20ROMs%20%28split%29/ download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/downloads < (NEW-SET)mame-sl  \Zb\Z2NEWEST,,subform_archive_single_download_mamedev '//' $datadir/downloads/mame-sl mame-sl/mame-sl/ download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/downloads < (NEW-SET)mame-merged  \Zb\Z2NEWEST,,subform_archive_single_download_mamedev '//' $datadir/downloads/mame-merged mame-merged/mame-merged/ download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/downloads < UnRenamedFiles-Various,,subform_archive_single_download_mamedev '//' $datadir/downloads/UnRenamedFiles-Various UnRenamedFiles-Various download,,,,,show_message_mamedev \"NO HELP\","
",,,,"
",▼\ZrGet all handheld and plug&play files per category,,,"
",RetroPie/roms/all_in1      < ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@all_in1/' ${rompack_link_info[1]} $datadir/roms/all_in1 ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/classich     < ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@classich/' ${rompack_link_info[1]} $datadir/roms/classich ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/gameandwatch < ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@gameandwatch/' ${rompack_link_info[1]} $datadir/roms/gameandwatch ${rompack_link_info[2]} download;show_message_mamedev \"gnw_egg is a clone of gnw_mmouse\ngnw_dkcirc is a clone of gnw_mmousep\n\nAfter clicking ok these roms are copied from the originals and renamed to the correct romname.\";cp $datadir/roms/gameandwatch/gnw_mmousep.zip $datadir/roms/gameandwatch/gnw_dkcirc.zip;cp $datadir/roms/gameandwatch/gnw_mmouse.zip $datadir/roms/gameandwatch/gnw_egg.zip;chown -R $user:$user $datadir/roms/gameandwatch,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/jakks        < ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@jakks/' ${rompack_link_info[1]} $datadir/roms/jakks ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/konamih      < ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@konamih/' ${rompack_link_info[1]} $datadir/roms/konamih ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/tigerh       < ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@tigerh/' ${rompack_link_info[1]} $datadir/roms/tigerh ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/tigerrz      < ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@tigerrz/' ${rompack_link_info[1]} $datadir/roms/tigerrz ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",,,,"
",▼\ZrGet all files from a specific category,,,"
",RetroPie/roms/deco_cassette < (  60+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/DECO/' ${rompack_link_info[1]} $datadir/roms/deco_cassette ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/megaplay      < (  10+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/\(Mega Play\)/' ${rompack_link_info[1]} $datadir/roms/megaplay ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/neogeo        < ( 270+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@neogeo/' ${rompack_link_info[1]} $datadir/roms/neogeo ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/nintendovs    < (  50+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@nintendovs/' ${rompack_link_info[1]} $datadir/roms/nintendovs ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/playchoice10  < (  70+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/\(PlayChoice-10\)/' ${rompack_link_info[1]} $datadir/roms/playchoice10 ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",,,,"
",▼\ZrGet all files from a specific category,,,"
",RetroPie/roms/driving       < ( 600+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@driving@/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/driving ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/lightgun      < ( 320+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@lightgun/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/lightgun ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/maze          < ( 750+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@maze/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/maze ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/pinball       < (  40+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@pinball_arcade/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/pinball ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/puzzle        < ( 640+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@puzzle/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/puzzle ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/realistic     < ( 280+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@oro/' ${rompack_link_info[1]} $datadir/roms/realistic ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/shooter       < (2800+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@shooter@/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/shooter ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/slot_machine  < (1020+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@slot_machine/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/slot_machine ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/sport         < ( 980+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@sport/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/sport ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/upright       < (2440+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@upright/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/upright ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",,,,"
",▼\ZrGet all 90º orientated files from a specific category,,,"
",RetroPie/roms/deco_cassette90º < (  60+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/DECO/&&/90º/' ${rompack_link_info[1]} $datadir/roms/deco_cassette90º ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/playchoice10_90º < (  70+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/\(PlayChoice-10\)/' ${rompack_link_info[1]} $datadir/roms/playchoice10_90º ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",,,,"
",▼\ZrGet all 90º orientated files from a specific category,,,"
",RetroPie/roms/driving90º    	 < ( 110+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@driving@/&&/@90º/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/driving90º ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/maze90º        	 < ( 410+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@maze/&&/@90º/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/maze90º ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/pinball90º     	 < (  20+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@pinball_arcade/&&/@90º/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/pinball90º ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/puzzle90º      	 < ( 100+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@puzzle/&&/@90º/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/puzzle90º ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/shooter90º     	 < (1030+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@shooter@/&&/@90º/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/shooter90º ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/slot_machine90º	 < (   5+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@slot_machine/&&/@90º/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/slot_machine90º ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/sport90º      	 < ( 170+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@sport/&&/@90º/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/sport90º ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/upright90º    	 < (1450+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@upright/&&/@90º/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/upright90º ${rompack_link_info[2]} download,,,,,show_message_mamedev \"NO HELP\","
",,,,"
",▼\ZrBrowse software files and download to RetroPie/roms/\ZR,,,"
",RetroPie/roms/apple2ee   < TotalReplay,,subform_archive_single_download_mamedev '//&&/hdv/' $datadir/roms/apple2ee TotalReplay download,,,,,show_message_mamedev \"Get TotalReplay harddrive image for Apple //e (e)\n\nTotal Replay (version 4.01 - released 2021-02-18 - 32 MB disk image)\n\n100s of games at your fingertips as long as your fingertips are on an Apple ][\n\nTotal Replay is a frontend for exploring and playing classic arcade games on an 8-bit Apple ][.\nSome notable features:\n- UI for searching and browsing all games\n- Screensaver mode includes hundreds of screenshots and dozens of self-running demos\n- In-game protections removed (manual lookups / code wheels / etc.)\n- Integrated game help\n- Cheat mode available on most games\n- Super hi-res box art (requires IIgs)\n- All games run directly from ProDOS (no swapping floppies!)\n\nSystem requirements:\n- Total Replay runs on any Apple ][ with 64K RAM and Applesoft in ROM\n- Some games require 128K.\n- Some games require a joystick.\n- Total Replay will automatically filter out games that do not work on your machine.\n\nAdditionally:\n- You will need a mass storage device that can mount a 32 MB ProDOS hard drive image.\n- This is supported by all major emulators.\","
",RetroPie/roms/apple2gs   < TotalReplay,,subform_archive_single_download_mamedev '//&&/hdv/' $datadir/roms/apple2gs TotalReplay download,,,,,show_message_mamedev \"Get TotalReplay harddrive image for Apple IIgs(ROM3)\n\nTotal Replay (version 4.01 - released 2021-02-18 - 32 MB disk image)\n\n100s of games at your fingertips as long as your fingertips are on an Apple ][\n\nTotal Replay is a frontend for exploring and playing classic arcade games on an 8-bit Apple ][.\nSome notable features:\n- UI for searching and browsing all games\n- Screensaver mode includes hundreds of screenshots and dozens of self-running demos\n- In-game protections removed (manual lookups / code wheels / etc.)\n- Integrated game help\n- Cheat mode available on most games\n- Super hi-res box art (requires IIgs)\n- All games run directly from ProDOS (no swapping floppies!)\n\nSystem requirements:\n- Total Replay runs on any Apple ][ with 64K RAM and Applesoft in ROM\n- Some games require 128K.\n- Some games require a joystick.\n- Total Replay will automatically filter out games that do not work on your machine.\n\nAdditionally:\n- You will need a mass storage device that can mount a 32 MB ProDOS hard drive image.\n- This is supported by all major emulators.\","
",RetroPie/roms/amstradcpc < R-TYPE 2012 (Easter-Egg),,subform_archive_single_download_mamedev '//&&/dsk/' $datadir/roms/amstradcpc r-type-128k download;chown -R $user:$user "$datadir/roms/amstradcpc",,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/bbcb       < AcornBBCMicroRomCollectionByGhostware,,subform_archive_single_download_mamedev '//&&/zip/' $datadir/roms/bbcb AcornBBCMicroRomCollectionByGhostware download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/electron   < AcornElectronRomCollectionByGhostware,,subform_archive_single_download_mamedev '//&&/zip/' $datadir/roms/electron AcornElectronRomCollectionByGhostware download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/msx        < MSXRomCollectionByGhostware,,subform_archive_single_download_mamedev '//&&/zip/' $datadir/roms/msx MSXRomCollectionByGhostware download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/msx2       < MSX2RomCollectionByGhostware,,subform_archive_single_download_mamedev '//&&/zip/' $datadir/roms/msx2 MSX2RomCollectionByGhostware download,,,,,show_message_mamedev \"NO HELP\","
",RetroPie/roms/ti99_4a    < TOSEC_2012_04_23,,subform_archive_single_download_mamedev '//&&/zip /' $datadir/roms/ti99_4a Texas_Instruments_TI-99_4a_TOSEC_2012_04_23 download;clear;unzip -o $datadir/roms/ti99_4a/Texas_Instruments_TI-99_4a_TOSEC_2012_04_23.zip -d $datadir/roms/ti99_4a/;chown -R $user:$user "$datadir/roms/ti99_4a",,,,,show_message_mamedev \"NO HELP\","
",,,,"
",▼\ZrBrowse files and download to RetroPie/roms/ (not for MAME)\ZR,,,"
",RetroPie/roms/atarist    < AtariSTRomCollectionByGhostware,,subform_archive_single_download_mamedev '//&&/zip/' $datadir/roms/atarist AtariSTRomCollectionByGhostware download,,,,,show_message_mamedev \"NO HELP\","
    )
    build_menu_mamedev
}


function subform_archive_single_download_mamedev() {
    local csv=()
    local download_csv=()
    local download_read
    local website_url="archive.???"
    local website_path="$4"
    local rompack_name="$3"
    local destination_path="$2"
    local search_pattern="$1"
    local manual_input=""

    manual_input=$(\
dialog \
--no-cancel \
--default-item "$default" \
--backtitle "$__backtitle" \
--title "Insert the options" \
--form "" \
22 76 16 \
"Website url >X (https://X/):" 1 1 "$website_url" 1 30 76 100 \
"Website path >X (/X):" 2 1 "$website_path" 2 30 76 100 \
"rompack name:" 3 1 "$rompack_name" 3 30 76 100 \
"destination path:" 4 1 "$destination_path" 4 30 76 100 \
"search pattern:" 5 1 "$search_pattern" 5 30 76 100 \
"" 6 1 "" 6 0 0 0 \
"" 7 1 "" 6 0 0 0 \
"" 8 1 "" 6 0 0 0 \
"" 9 1 "" 6 0 0 0 \
2>&1 >/dev/tty \
)
#maximum charachters that can be displayed in empty line (6-9) " ===================================================================== "

    website_url=$(echo "$manual_input" | sed -n 1p)
    website_path=$(echo "$manual_input" | sed -n 2p)
    rompack_name=$(echo "$manual_input" | sed -n 3p)
    destination_path=$(echo "$manual_input" | sed -n 4p)
#issue with using cmd : search_pattern=$(echo "$manual_input" | sed -n 5p)
#if search_pattern is also in the destination_path then all items of the csv are displayed !!!
#to fix this you had to add a space to get a correct search ( / adam/ that way there isn't a match with /roms/adam !!! )
#in next command we add a space to fix this issue
    search_pattern=$(echo "$manual_input" | sed -n 5p | sed 's/\//\/ /')

    clear
    if [[ $(echo $website_url|sha1sum) == 241013beb0faf19bf5d76d74507eadecdf45348e* ]];then
    echo "reading the website data"
    while read download_read;do download_csv+=("$download_read");done < <(curl https://$website_url/$website_path/$rompack_name|grep "<td><a href="|cut -d '"' -f2|grep -v "/"|grep -v "ia_thumb"|while read line;do echo "\",Get '$line',,download_file_mamedev $line $website_url/$website_path/$rompack_name $destination_path,\"";done)
    IFS=$'\n' csv=($(sort -t"," -k 2 --ignore-case <<<$(awk $search_pattern<<<"${download_csv[*]}")));unset IFS
    #we need to add '",,,,"', because otherwise the first value isn't displayed as it is reserved for the column descriptions
    csv=( ",,,," "${csv[@]}" )
    [[ ${!csv[@]} == 0 ]] && csv=( ",,,," ",no search results found, try again,,," )
	else
	csv=( 
",,,,"
",error : wrong input : try again !,,," 
	)
    fi
    
    build_menu_mamedev
}


function subgui_installs_mamedev() {
#for dialog colours see "man dialog"
	local csv=()
	csv=(
",,,,,,,,,"
",Install MAME    (required install) =>  ARCADE+NON-ARCADE,,package_setup mame,,,,,show_message_mamedev \"Required :\n\nMAME is a standalone emulator and is used to emulate :\n- ARCADE (about 34000)\n- NON-ARCADE (about 4000)\n\nThis script also depends on MAME to extract the media data.\nTherfor MAME must be installed.\n\nTry to install the binary.\nThis is the fastest solution.\n\nWarning : Building from source code can take many many hours.\","
",Install LR-MESS (optional install) =>   NON-ARCADE only,,package_setup lr-mess,,,,,show_message_mamedev \"Should be installed :\n\nLR-MESS is a RetroArch core and is used to emulate :\n- NON-ARCADE (about 4000).\n\nTry to install the binary.\nThis is the fastest solution.\n\nWarning : Building from source code can take many many hours.\","
",Install LR-MAME (optional install) =>     ARCADE only,,package_setup lr-mame,,,,,show_message_mamedev \"Should be installed :\n\nLR-MAME is a RetroArch core and is used to emulate :\n- ARCADE (about 34000).\n\nTry to install the binary.\nThis is the fastest solution.\n\nWarning : Building from source code can take many many hours.\","
",Install LR-GW   (optional install) => MADRIGALS  HANDHELD,,package_setup lr-gw;if [[ -f $rootdir/libretrocores/lr-gw/gw_libretro.so ]];then delEmulator lr-gw gameandwatch;addEmulator 0 lr-gw gameandwatch \"$emudir/retroarch/bin/retroarch -L $rootdir/libretrocores/lr-gw/gw_libretro.so --config $rootdir/configs/gameandwatch/retroarch.cfg %ROM%\";addSystem lr-gw gameandwatch \".cmd .zip .7z .mgw\";mkRomDir classich;addEmulator 0 lr-gw classich \"$emudir/retroarch/bin/retroarch -L $rootdir/libretrocores/lr-gw/gw_libretro.so --config $rootdir/configs/gameandwatch/retroarch.cfg %ROM%\";addSystem lr-gw classich \".cmd .zip .7z .mgw\";download_file_with_wget emulators.cfg raw.githubusercontent.com/FollyMaddy/RetroPie-Share/main/00-filesystem-00$rootdir/configs/all $rootdir/configs/all;else delEmulator lr-gw classich;fi,,,,,show_message_mamedev \"lr-gw is used for running the handheld from the MADrigals romset. (.mgw)\n\nYou can get the ROM list on the RetroPie forum :\nTutorial: Handheld and Plug & Play systems with MAME\n\nAfter installing lr-gw a few patches are applied :\n- lr-gw not being the default runcommand\n- add lr-gw as runcommand to the system category classich\n- add the mame file-extensions\n  (so both mame and lr-gw files can be viewed in emulationstation)\n\nIn order to run MADrigals and mame roms without changing the runcommand on startup we will also add the file $rootdir/all/emulators.cfg. You then will be able to run the mame roms as usual and also play the madigals without changing the runcommand at startup. If somehow you already have this file then be sure you do not overwrite your own config. In that case skip the downloading.\","
",,,,"
",▼\Zr\Z1Usage is for your own risk !,,,"
",\Z3Install rpi1/0 mame0255 binary (only : channelf apfm1000 ...),,\
sed -i 's/ \!armv6//g' $scriptdir/scriptmodules/emulators/mame.sh;\
curl https://raw.githubusercontent.com/matthuisman/gdrivedl/master/gdrivedl.py | python3 - https://drive.google.com/file/d/1enP_Fkpj482JJ9LI7s5Y8bamJunwgOnL -m -P "/tmp";\
rm -d -r $emudir/mame;\
unzip /tmp/mame0255-debian10-_source_patched_for_gcc8.3-rpi1_channelf_apfm1000.zip -d $emudir/;\
$scriptdir/retropie_packages.sh mame depends;\
$scriptdir/retropie_packages.sh mame configure;\
sed -i 's/\!mali/\!mali \!armv6/g' $scriptdir/scriptmodules/emulators/mame.sh;\
,,,,,show_message_mamedev \"\
This menu item does the following :\n\
- patch the mame module-script for using it temporarily on rpi1/0\n\
- get the mame binary from google-drive\n\
- extract it from /tmp to $emudir\n\
- the binary will vanish from /tmp after next reboot\n\
- get depends for mame\n\
- configure mame for retropie\n\
- Restore the mame module-script\n\n\
After this install channelf or apfm1000 from within this script.\n\
Only use the mame standalone runcommands.\n\
(lr-mess can be installed but is too slow on the rpi1/0)\n\
If nessasary use the runcommands with -frameskip 10.\n\n\
This installs a Debian 10 / gcc8.3 / patched source binary.\n\
The binary should work on Debian 10/11 based OSes.\n\
\","
",\Z3Install rpi1/0 mame0255 binary,,\
sed -i 's/ \!armv6//g' $scriptdir/scriptmodules/emulators/mame.sh;\
curl https://raw.githubusercontent.com/matthuisman/gdrivedl/master/gdrivedl.py | python3 - https://drive.google.com/file/d/1aOBPSvQPIbfOjkDeWzf1sbD09Q5EzNE7 -m -P "/tmp";\
rm -d -r $emudir/mame;\
unzip /tmp/mame0255-debian10-_source_patched_for_gcc8.3-rpi1-all.zip -d $emudir/;\
$scriptdir/retropie_packages.sh mame depends;\
$scriptdir/retropie_packages.sh mame configure;\
sed -i 's/\!mali/\!mali \!armv6/g' $scriptdir/scriptmodules/emulators/mame.sh;\
,,,,,show_message_mamedev \"\
This menu item does the following :\n\
- patch the mame module-script for using it temporarily on rpi1/0\n\
- get the mame binary from google-drive\n\
- extract it from /tmp to $emudir\n\
- the binary will vanish from /tmp after next reboot\n\
- get depends for mame\n\
- configure mame for retropie\n\
- Restore the mame module-script\n\n\
After this you are able to install any driver from within this script.\n\
But remember most drivers will run too slow on the rpi1/0.\n\
Only use the mame standalone runcommands.\n\
(lr-mess can be installed but is too slow on the rpi1/0)\n\
If nessasary use the runcommands with -frameskip 10.\n\n\
This installs a Debian 10 / gcc8.3 / patched source binary.\n\
The binary should work on Debian 10/11 based OSes.\n\
\","
",\Z4►Show and install mame from gdrive binary list,,subgui_gdrive_binaries_mamedev 1--8uSe-xs1vFA-yPfw6Ac2XF6zzNzAuP,"
",\Z4►Show and install mame from stickfreaks binary list,,subgui_stickfreaks_binaries_mamedev,"
	)
#",▼\Zr\Z1Usage is for your own risk and very experimental !,,,"
#",\Z1Install lr-mame/lr-mess binary (x86/x86_64) <= libretro buildbot,,install-lr-mame-for-x86-or-x86_64,"
	build_menu_mamedev
}


function subform_archive_multi_downloads_mamedev() {

    local website_url="archive.???"
    local website_path="$5"
    local rompack_name="$4"
    local destination_path="$3"
    local file_extension="$2"
    local search_input="$1"
    local manual_input=""

    manual_input=$(\
dialog \
--no-cancel \
--default-item "$default" \
--backtitle "$__backtitle" \
--title "Insert the options" \
--form "" \
22 76 16 \
"Website url >X (https://X/):" 1 1 "$website_url" 1 30 76 100 \
"Website path >X (/X):" 2 1 "$website_path" 2 30 76 100 \
"rompack name:" 3 1 "$rompack_name" 3 30 76 100 \
"destination path:" 4 1 "$destination_path" 4 30 76 100 \
"file extension:" 5 1 "$file_extension" 5 30 76 100 \
"search input:" 6 1 "$search_input" 6 30 76 100 \
2>&1 >/dev/tty \
)

    website_url=$(echo "$manual_input" | sed -n 1p)
    website_path=$(echo "$manual_input" | sed -n 2p)
    rompack_name=$(echo "$manual_input" | sed -n 3p)
    destination_path=$(echo "$manual_input" | sed -n 4p)
    file_extension=$(echo "$manual_input" | sed -n 5p)
    search_input=$(echo "$manual_input" | sed -n 6p)

    clear
    if [[ $(echo $website_url|sha1sum) == 241013beb0faf19bf5d76d74507eadecdf45348e* ]];then
    mkdir -p $destination_path
    read_data_mamedev
    IFS=$'\n' restricted_download_csv=($(cut -d "," -f 2 <<<$(awk $search_input<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))));unset IFS
    for rd in ${!restricted_download_csv[@]};do 
    #echo ${restricted_download_csv[$rd]}
    #sleep 0.3
    #show a wget progress bar => https://stackoverflow.com/questions/4686464/how-can-i-show-the-wget-progress-bar-only
    echo "busy with ${restricted_download_csv[$rd]}$file_extension"
    #display onle the lines "Nothing to do." "Not Found." and progress "%" using awk or grep command : awk '/do\./||/Found\./||/\%/' : grep -E 'do\.|Found\.|%'
    wget --show-progress --progress=bar:force -T3 -t0 -c -w1 -P $destination_path https://$website_url/$website_path/$rompack_name/${restricted_download_csv[$rd]}$file_extension 2>&1|grep -E 'do\.|Found\.|%'
    done
    chown -R $user:$user "$destination_path"
    else 
    echo "-->> ERROR : WRONG INPUT : TRY AGAIN !"
    echo "Waiting for 5 seconds..."
    echo "If more more commands exist they are executed now."
    echo "Atfer that it will go back to the menu."
    sleep 5
    fi
}


function create_00index_file_mamedev() {

    local destination_path="$2"
    local search_input="$1"
    local index_file="0 rom-index 0"
    clear
    mkdir -p $destination_path
    read_data_mamedev
    IFS=$'\n' restricted_download_csv=($(cut -d "," -f 2 <<<$(awk $search_input<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))));unset IFS
	echo "creating a "$index_file" file for this specific category"
    [[ -f "$destination_path/$index_file" ]] && rm "$destination_path/$index_file" 2>&1
    for rd in ${!restricted_download_csv[@]};do    
    echo ${restricted_download_csv[$rd]} >> "$destination_path/$index_file"
    done
    chown -R $user:$user "$destination_path"
}


function create_systems_list_mamedev() {
    local csv=()
    read_data_mamedev
    #we have to do a global comparison as the alfabetical order contains also a letter in the $1
    if [[ $1 == descriptions* ]];then
    #here we store the sorted mamedev_csv values in the csv array
    #we sort on the third colunm which contain the descriptions of the sytems
    #to get sorted lists from the full array we need to split it in lines withe the sed command and then grep on what we want
    #to keep the first reserved csv line, that was added with (echo \",,,,\") we need to grep that pattern
    #like this (for one or the other ): grep 'pattern1\|pattern2'
    #like this (for one and the other ): grep -P '^(?=.*pattern1)(?=.*pattern2)'
    #because we need a combination of "or" and "and" I found more information in the next link
    #more info https://www.shellhacks.com/grep-or-grep-and-grep-not-match-multiple-patterns/
    #using awk we can combined (and)&& (or)|| and also ignore case sensitive
    #(fast)sorting (and equal to) is possible on patterns up to 5 options ($2 -$6)
    #(slower)sorting (not equal to) is possible on patterns for one option ($2) adding an ! after the pattern 
    #before sorting it passes an awk command for the second time (read from right to left)
    #this command adds another column with the lenght of the item we want to sort on
    #adding this will sort shorter items before longer items
    #https://stackoverflow.com/questions/36896499/bash-sort-by-number-and-word-length-and-alphabetically  
    IFS=$'\n' csv=($(sort -t"," -k5,5nr -k3,3 --ignore-case<<<$(awk '{print $0","length($3)}'<<<$(awk "{IGNORECASE = 1} $([[ $2 == *\! ]] && echo \!)/"$(echo $2|sed 's/\!//')"/ && /$3/ && /$4/ && /$5/ && /$6/ || /\",,,,\"/"<<<$(sed 's/" "/"\n"/g' <<<"${mamedev_csv[*]}")))));unset IFS
    #this is an aternative but much slower
    #while read system_read; do csv+=("$system_read");done < <(IFS=$'\n';echo "${mamedev_csv[*]}"|sort -t"," -d -k 3 --ignore-case;unset IFS)
    else
    #here we store the sorted mamedev_csv values in the csv array
    #we sort on the second colunm which contain the system names
    IFS=$'\n' csv=($(sort -t"," -k5,5nr -k2,2 --ignore-case<<<$(awk '{print $0","length($2)}'<<<$(awk " {IGNORECASE = 1} $([[ $2 == *\! ]] && echo \!)/"$(echo $2|sed 's/\!//')"/ && /$3/ && /$4/ && /$5/ && /$6/ || /\",,,,\"/"<<<$(sed 's/" "/"\n"/g' <<<"${mamedev_csv[*]}")))));unset IFS
    #this is an aternative but much slower
    #while read system_read; do csv+=("$system_read");done < <(IFS=$'\n';echo "${mamedev_csv[*]}"|sort -t"," -d -k 2 --ignore-case;unset IFS)
    fi

    #when the csv array is not filled, if searching patterns are not found, index 1 and above are empty
    #here we add an extra line into index 1, so an empty dialog will appear without any errors  
    [[ -z ${csv[1]} ]] && csv+=( "\",error : search pattern is not found : try again !,,,\"" )

    build_menu_mamedev $1
}


function build_menu_mamedev() {
    local options=()
    local default
    local i
    local run
    local lastdescriptionmatch
    local lastcategorymatch
    IFS=","
    if [[ $1 == descriptions ]]; then
    for i in ${!csv[@]}; do set ${csv[$i]}; options+=("$i" "$3");done
    fi
    for letter in {A..Z}
    do 
      if [[ $1 == descriptions$letter ]]; then
        #not needed here, but ${letter^}* converts letter into uppercase
        #${letter,}* converts letter into lowercase
        #so this function check on both uppercase and lowercase
        for i in ${!csv[@]}; do set ${csv[$i]}; [[ $3 == $letter* ]] || [[ $3 == ${letter,}* ]] && options+=("$i" "$3");done
      fi
    done
    if [[ $1 == descriptions# ]]; then
      for i in ${!csv[@]}; do set ${csv[$i]}; [[ $3 != [A-Z]* ]] && [[ $3 != [a-z]* ]] && options+=("$i" "$3");done
    fi
    for letter in {A..Z}
    do 
      if [[ $1 == systems$letter ]]; then
        #${letter,}* converts letter into lowercase
        for i in ${!csv[@]}; do set ${csv[$i]}; [[ $2 == ${letter,}* ]] && options+=("$i" "$2");done
      fi
    done
    if [[ $1 == systems# ]]; then
      for i in ${!csv[@]}; do set ${csv[$i]}; [[ $2 != [a-z]* ]] && options+=("$i" "$2");done
    fi
    if [[ -z $1 ]] || [[ $1 == systems ]]; then
    for i in ${!csv[@]}; do set ${csv[$i]}; options+=("$i" "$2");done
    fi
    #remove option 0 (value 0 and 1) so the menu begins with 1
    unset 'options[0]'; unset 'options[1]' 
    while true; do
        local cmd=(dialog --colors --no-collapse --help-button --default-item "$default" --backtitle "$__backtitle" --menu "Version ${rp_module_version}                                    (using database ${rp_module_version_mame})" 22 76 16)
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        default="$choice"
        if [[ -n "$choice" ]]; then
            joy2keyStop
            joy2keyStart 0x00 0x00 kich1 kdch1 0x20 0x71
            clear
            #run what's in the fourth "column", but with install_system_mamedev add the selected system
            #this is done because adding the string in the `sed` function will not work
            #and now we can paste the standalone install_system_mamedev within the function
            #so we can work on one install_system_mamedev and paste it in when it is updated
	    if [[ $choice == HELP* ]];then
	        IFS=","
		run="$(set ${csv[$(echo $choice|cut -d ' ' -f2)]};echo $9)"
	    else
		IFS=","
		if [[ "$(set ${csv[$choice]};echo $4)" == install_system_mamedev ]];then 
		run="$(set ${csv[$choice]};echo $4) $(set ${csv[$choice]};echo $2)"
		else
		run="$(set ${csv[$choice]};echo $4)"
		fi
	    fi
            joy2keyStop
            joy2keyStart
            unset IFS
	    eval $run
            #next function is done inside the install_system_mamedev
            #rp_registerAllModules
            #sleep 4
	    [[ $run == *"remove_installs_mamedev "* ]] && break
            [[ $run == *rp_module_version_mame=* ]] && break
	    [[ $run == *retroscraper_remote_command* ]] && break
	    [[ $run == *install_or_remove_run_mess_script_mamedev* ]] && break
	    [[ $run == *install_or_restore_runcommand_script_mamedev* ]] && break
        else
            break
        fi
    done
    unset IFS
}


function install_mame_from_gdrive_mamedev () {
echo "remove current mame"
rm -r $emudir/mame 2>&-
mkdir -p $emudir/mame 2>&-
echo -ne "get mame binary from gdrive and install it"
#$1=mame-binary $2=gdrive_file_id
curl https://raw.githubusercontent.com/matthuisman/gdrivedl/master/gdrivedl.py | python3 - https://drive.google.com/file/d/$2 -m -P "/tmp";\
unzip /tmp/$1 -d $emudir/
$scriptdir/retropie_packages.sh mame depends
$scriptdir/retropie_packages.sh mame configure 
}


function install_mame_from_stickfreaks_mamedev () {
echo "remove current mame"
rm -r $emudir/mame 2>&-
mkdir -p $emudir/mame 2>&-
echo -ne "get mame binary from stickfreaks and install it"
#$1=mame-binary $2=folder (if older binary then "old/" otherwise empty)
wget -c https://stickfreaks.com/mame/$2$1 $emudir/mame -P $emudir/mame
7za x $emudir/mame/*.7z -o$emudir/mame/
strip $emudir/mame/mame
$scriptdir/retropie_packages.sh mame depends
$scriptdir/retropie_packages.sh mame configure 
}


function install_or_remove_run_mess_script_mamedev() {
    if [[ -f $scriptdir/scriptmodules/run_mess.sh ]];then
    rm $scriptdir/scriptmodules/run_mess.sh
    else
    echo "install @valerino run_mess.sh script (the RusselB version)"
    wget -q -nv -O $scriptdir/scriptmodules/run_mess.sh https://raw.githubusercontent.com/FollyMaddy/RetroPie-Share/main/00-scriptmodules-00/run_mess.sh
    #change ownership to normal user
    chown $user:$user "$scriptdir/scriptmodules/run_mess.sh"
    # ensure run_mess.sh script is executable
    chmod 755 "$scriptdir/scriptmodules/run_mess.sh"
    fi
    #"break" after usage in function build_menu_mamedev
}



function install_or_restore_runcommand_script_mamedev() {
	if [[ $scriptdir == *RetroPie* ]];then
		#install and use my patched runcommand.sh with extra replacement tokens or restore to the original without ...
		if [[ -f $rootdir/supplementary/runcommand/runcommand.sh ]];then
			if [[ $(sha1sum $rootdir/supplementary/runcommand/runcommand.sh 2>&-) != 739b6c7e50c6b4e2d048ea85f93ab8c71b1a1d74* ]];then
			echo "install patched runcommand.sh script with extra replace tokens"
			wget -q -nv -O $rootdir/supplementary/runcommand/runcommand.sh https://raw.githubusercontent.com/FollyMaddy/RetroPie-Share/main/00-scriptmodules-00/runcommand.sh
			else
			rm $rootdir/supplementary/runcommand/runcommand.sh
			cp $scriptdir/scriptmodules/supplementary/runcommand/runcommand.sh $rootdir/supplementary/runcommand/runcommand.sh
			fi
		else
		show_message_mamedev "Something went wrong :\nNo runcommand.sh detected\n\nMake sure you install it from the core packages.\nIf this somehow doesn't work then try to remove it first before installing it again."
		fi
	else
	show_message_mamedev "This option is not supported yet for $(echo $scriptdir|cut -d/ -f4|cut -d- -f1)."
	fi
	#"break" after usage in function build_menu_mamedev
}


function install_system_mamedev() {
#part 0 : define strings, arrays and handheld/p&p/category platform information

#mamedev arrays
systems=(); uniquesystems=(); mediadescriptions=(); media=(); extensions=(); allextensions=(); descriptions=()
#added for systems with a extra predefined options, slotdevices and media
ExtraPredefinedLoaderName=();ExtraPredefinedOptions=(); RPsystemNames=()

#retropie arrays
systemsrp=(); descriptionsrp=()

#create new array while matching
newsystems=()

#filter out column names and <none> media
namesfilter="\(brief|------"

#filter on usefull media, otherwise we also get many unusefull scripts
mediafilter="none\)|\(prin|quik\)|\(memc|\(rom1|\(cart|flop\)|flop1\)|flop3\)|\(cass|dump\)|cdrm\)|hard\)|\(hard1|\(min|\(mout"

#string for adding extra extensions 
addextensions=".zip .7z"

#string for adding extra extensions for retroarch cores
addextensionscmd=".cmd"

#check if the system is arcade or non-arcade for switching between lr-mess and lr-mame
if [[ ${csv[$choice]} == *@non-arcad* ]]
then SystemType="non-arcade"
else SystemType="arcade"
fi
#echo ${csv[$choice]}
echo System driver is detected as "$SystemType"

#begin with an empty variable for part 13, preventing remembering it from an other session
creating=

#array data for "game system names" of "handhelds" that cannot be detected or matched with the mamedev database
#systems that cannot be detected (all_in1, classich, konamih, tigerh) (*h is for handheld)
#systems that can be detected (jakks, tigerrz), these added later in the script for normal matching
#a system that can be detected (gameandwatch), already in RetroPie naming for normal matching
#using @DTEAM naming for compatibitity with possible existing es-themes
#hoping this will be the future RetroPie naming for these handhelds
#this is an example command to extract the systems and add them here to the array :
#classich=( "\"$(cat mame_systems_dteam_classich|cut -d " " -f2)\"" );echo ${classich[@]}|sed 's/ /\" \"/g'

if [[ ${csv[$choice]} != *@skip* ]];then
read_data_mamedev
echo "read the mame romset groups, used for RetroPie naming"
 if [[ -z $groups_read ]];then
 groups_read=1
 IFS=$'\n' 
 #add new items in part 11 for matching
 all_in1=($(cut -d "," -f 2 <<<$(awk '/@all_in1/'<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
 classich=($(cut -d "," -f 2 <<<$(awk '/@classich/'<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
 konamih=($(cut -d "," -f 2 <<<$(awk '/@konamih/'<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
 tigerh=($(cut -d "," -f 2 <<<$(awk '/@tigerh/'<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
 #arcade categories
 driving=($(cut -d "," -f 2 <<<$(awk '/@driving@/&&/@working_arcade/'<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
 maze=($(cut -d "," -f 2 <<<$(awk '/@maze/&&/@working_arcade/'<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
 pinball=($(cut -d "," -f 2 <<<$(awk '/@pinball_arcade/&&/@working_arcade/'<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
 puzzle=($(cut -d "," -f 2 <<<$(awk '/@puzzle/&&/@working_arcade/'<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
 shooter=($(cut -d "," -f 2 <<<$(awk '/@shooter@/&&/@working_arcade/'<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
 slot_machine=($(cut -d "," -f 2 <<<$(awk '/@slot_machine/&&/@working_arcade/'<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
 sport=($(cut -d "," -f 2 <<<$(awk '/@sport/&&/@working_arcade/'<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
 #
 deco_cassette=($(cut -d "," -f 2 <<<$(awk '/DECO/'<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
 neogeo=($(cut -d "," -f 2 <<<$(awk '/@neogeo/'<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
 nintendovs=($(cut -d "," -f 2 <<<$(awk '/@nintendovs/'<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
 megaplay=($(cut -d "," -f 2 <<<$(awk '/\(Mega Play\)/'<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
 playchoice10=($(cut -d "," -f 2 <<<$(awk '/\(PlayChoice-10\)/'<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
 #
 unset IFS
fi
else echo "skip reading mame data"
fi

#part 1 : prepair some things first
#for making it possible to save /ext/RetroPie-Share/platorms.cfg
mkdir -p  $scriptdir/ext/RetroPie-Share/scriptmodules/libretrocores 2>&-
chown -R $user:$user "$scriptdir/ext/RetroPie-Share"


#part 2 : platform config lines systems that are not in the platform.cfg (no strings, read the same way as info from platform.cfg)
cat >"$scriptdir/ext/RetroPie-Share/platforms.cfg" << _EOF_
tigerh_exts=""
tigerh_fullname="Tiger Handheld Electronics"

tigerrz_exts=""
tigerrz_fullname="Tiger R-Zone"

jakks_exts=""
jakks_fullname="JAKKS Pacific TV Games"

konamih_exts=""
konamih_fullname="Konami Handheld"

all_in1_exts=""
all_in1_fullname="All in One Handheld and Plug and Play"

classich_exts=".mgw"
classich_fullname="Classic Handheld Systems"

bbcmicro_exts=".ssd"
bbcmicro_fullname="BBC Micro"

bbcmicro_exts=".ssd"
bbcmicro_fullname="BBC Master"

dragon64_exts=".wav .cas .prn .ccc .rom .mfi .dfi .hfe .mfm .td0 .imd .d77 .d88 .1dd .cqm .cqi .dsk .dmk .jvc .vdk .sdf .os9"
dragon64_fullname="Dragon 64"
_EOF_

#change ownership to normal user
chown $user:$user "$scriptdir/ext/RetroPie-Share/platforms.cfg"


#part 3 : turning off installing when no option is add to the function
#if no option is added while running this scripts, it is possible to install all all systems
#because of the time it will consume, it is turned off in this part !
if [[ -z "$1" ]]; then 
echo -ne "\nno option detected, nothing to do\n"
exit
fi


#part 4 : extract system data to array
#first part from the if function is meant for installing systems with extra options or special software cartridges,
#that can't be extracted from mame with -listslots
#if added more than one option then we have added extra information about extra predefined options and it's usable media
#then $1=system $2=RPsystemName $3=ExtraPredefinedOption(s) $4=mediadescription $5=media $6=extension(s)
if [[ -n "$2" ]]; then
echo "read the system driver name from the commandline options"
echo "read the RetroPie system name from commandline options"
echo "read the ExtraPredefinedOption(s) from the commandline options"
systems+=( "$1" )
#by using the systems name as a description we don't have matches in part 10
#therefor we can force our own RetroPie name 
#and therefor we probably have no conflict with the newsystems name
descriptions+=( "$1" )
RPsystemNames+=( "$2" )
#normally we would use this :
#ExtraPredefinedOptions+=( "$3" )
#but with using the front-end quotes can't be used in the csv style used there
#so, in the front-end, we replace the spaces with a * and commas with a # and filter them out here again
ExtraPredefinedOptions+=( "$(echo $3|sed 's/*/ /g;s/#/,/g')" )
ExtraPredefinedLoaderName+=( "$7" )
else
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
done < <($emudir/mame/mame -listmedia $1 | grep -v -E "$namesfilter" | grep -E "$mediafilter" | cut -d " " -f 1)
fi


#part 5 : extract all extension data per system to array
#first part from the if function is meant for installing systems with extra options or special software cartridges,
#that can't be extracted from mame with -listslots
#if added more than one option then we have added extra information about extra predefined options and it's usable media
#then $1=system $2=RPsystemName $3=ExtraPredefinedOption(s) $4=mediadescription $5=media $6=extension(s)
if [[ -n "$2" ]]; then
echo "read the media extension(s) from commandline options"
#will be the same as extensions in part 6
allextensions+=( "$(echo $6|sed 's/*/ /g')" )
else
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
allextensions+=( "$($emudir/mame/mame -listmedia ${systems[$index]} | grep -o "\...." | tr ' ' '\n' | sort -u | tr '\n' ' ')" )
done
fi
#testline
#echo testline ${systems[$index]} ${allextensions[$index]}
#testline
#echo ${allextensions[@]} ${#allextensions[@]}

#part 6 : extract only extension data per media per system to array
#first part from the if function is meant for installing systems with extra options or special software cartridges,
#that can't be extracted from mame with -listslots
#if added more than one option then we have added extra information about extra predefined options and it's usable media
#then $1=system $2=RPsystemName $3=ExtraPredefinedOption(s) $4=mediadescription $5=media $6=extension(s)
if [[ -n "$2" ]]; then
echo "read the media data from commandline options"
index=0
mediadescriptions+=( "$4")
# use the third column if seperated by a space and remove ( ) characters and add - for media
media+=( "-$5" )
# use the second column if seperated by a ) character and cut off the first space
extensions+=( "$(echo $6|sed 's/*/ /g')" )
else
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
done < <($emudir/mame/mame -listmedia $1 | grep -v -E "$namesfilter" | grep -E "$mediafilter")
fi
#testline
#echo testline ${mediadescriptions[@]} ${media[@]} ${extensions[@]} 


#part 7 : do some filtering and read mamedev system descriptions into (descriptions)
#first part from the if function is meant for installing systems with extra options or special software cartridges,
#that can't be extracted from mame with -listslots
#if added more than one option then we have added extra information about extra predefined options and it's usable media
#then $1=system $2=RPsystemName $3=ExtraPredefinedOption(s) $4=mediadescription $5=media $6=extension(s)
if [[ -n "$2" ]]; then
echo "skip reading computer description from mame"
else
echo "read computer description(s)"
#a manual command example would be :
#$emudir/mame/mame -listdevices hbf700p | grep Driver | sed s/hbf700p//g | cut -c 10- | sed s/\)\://g
#the output, stored in the (descriptions) would be :
#HB-F700P (MSX2)
#
# keep the good info and delete text in lines ( "Driver"(cut), "system"(sed), "):"(sed) )
for index in "${!systems[@]}"; do descriptions+=( "$($emudir/mame/mame -listdevices ${systems[$index]} | grep Driver | sed s/$(echo ${systems[$index]})//g | cut -c 10- | sed s/\)\://g)" ); done
fi

#part 8 : read RetroPie systems and descriptions from the platforms.cfg
echo "read and match RetroPie names with mamedev names"
while read LINE; do
# read retropie rom directory names 
systemsrp+=( "$(echo $LINE | cut -d '_' -f 1)" )
# read retropie full system names
#
#sed is used to change descriptions on the fly, 
#otherwise it has also 
#descriptions that are changed to disable matching:
#(PC => -PC-) #to prefent matches with CPC ,PC Engine etc., for PC a solution still has to be found
#(Apple II => -Apple II-) #https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/653
#descriptions that are changed for matching:
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
sed 's/Apple II/-Apple II-/g' | \
sed 's/Atari 7800 ProSystem/Atari 7800/g' | \
sed 's/Atari Jaguar/Jaguar/g' | \
sed 's/Mega CD/Mega-CD/g' | \
sed 's/Sega 32X/32X/g' | \
sed 's/Commodore Amiga/Amiga/g' | \
sed 's/ and / \& /g' | \
sed 's/ and / \& /g' | \
cut -d '"' -f 2)" )
done < <(cat $scriptdir/platforms.cfg | grep fullname)


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
#not in the original platforms.cfg
systemsrp+=( "cd32" )
descriptionsrp+=( "Amiga CD32" )
systemsrp+=( "archimedes" )
descriptionsrp+=( "Archimedes" )
systemsrp+=( "archimedes" )
descriptionsrp+=( "Acorn A" )
systemsrp+=( "archimedes" )
descriptionsrp+=( "BBC A" )
systemsrp+=( "astrocde" )
descriptionsrp+=( "Bally Professional Arcade" )
systemsrp+=( "bbcmicro" )
descriptionsrp+=( "BBC Micro" )
systemsrp+=( "bbcmicro" )
descriptionsrp+=( "BBC Master" )
systemsrp+=( "dragon64" )
descriptionsrp+=( "Dragon 64" )
systemsrp+=( "sega32-cd" )
descriptionsrp+=( "Mega-CD with 32X" )
systemsrp+=( "sega32-cd" )
descriptionsrp+=( "Sega CD with 32X" )
systemsrp+=( "msx2" )
descriptionsrp+=( "MSX2" )
systemsrp+=( "msx2+" )
descriptionsrp+=( "MSX2+" )
systemsrp+=( "msxturbor" )
descriptionsrp+=( "MSX Turbo-R" )
systemsrp+=( "neogeo-cd" )
descriptionsrp+=( "Neo-Geo CD" )
for L in France Germany Italy Netherlands Spain Sweden Switzerland UK USA;do
 systemsrp+=( "atarist" )
 descriptionsrp+=( "ST ($L)" )
 systemsrp+=( "atarist" )
 descriptionsrp+=( "STE ($L)" )
 systemsrp+=( "atarist" )
 descriptionsrp+=( "MEGA STE ($L)" )
done
#adding this doesn't work with this type of system to get the correct description in es_systems.cfg, other solution required or we have to do a look up in the arrays somehow
#systemsrp+=( "konamih" )
#descriptionsrp+=( "Konami Handheld" )

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
  #searching for matching names, when different matches occour then the last name is used !
  for mamedevindex in "${!descriptions[@]}"; do
    for rpindex in "${!descriptionsrp[@]}"; do
      #create an empty array and split the the retropie name descriptions into seperate "words" in an array
      splitdescriptionsrp=()
      IFS=$' ' GLOBIGNORE='*' command eval  'splitdescriptionsrp=($(echo ${descriptionsrp[$rpindex]}))'
      #check if every "word" is in the mamedev descriptions * *=globally , " "=exact, 
      #!!! exact matching does not work here, because many times you are matching 1 "word" against multiple "words" !!!
      if [[ "${descriptions[$mamedevindex]}" == *${splitdescriptionsrp[@]}* ]]; then
        # If descriptions are exactly the same then use the system name of retropie as romdirectory
        # for the other arrays we use the mamedev information
        newsystems[$mamedevindex]=${systemsrp[$rpindex]}
        #echo "match - mamedev(description) - ${descriptions[$mamedevindex]} -- rp(description) - ${descriptionsrp[$rpindex]}"
        #echo "match - mamedev(romdir) - ${systems[$mamedevindex]} -- rp(romdir) - ${newsystems[$mamedevindex]} (RetroPie name is used)"
	lastdescriptionmatch=${descriptionsrp[$rpindex]}
      fi
    done
  done
if [[ -n "$2" ]]; then
echo "MAME information -> (Skipped)"
else
echo "MAME information -> ${systems[$mamedevindex]} (${descriptions[$mamedevindex]})"
fi


#part 11 : match the added @DTEAM/RetroPie descriptions to the mamedev descriptions
#create a subarray "dteam_systems" containing the arrays that have to be used here
#now only two "for loops" can be use for checking multiple arrays against the RetroPie names
#note:some systems are not added because they should be recognised in a normal way
dteam_systems=("all_in1" "classich" "konamih" "tigerh" "driving" "maze" "pinball" "puzzle" "shooter" "slot_machine" "sport" "neogeo" "nintendovs" "megaplay" "playchoice10" "deco_cassette")
lastcategorymatch=false
#multiple arrays over one for loop:
#https://unix.stackexchange.com/questions/545502/bash-array-of-arrays

for mamedevindex in "${!systems[@]}"; do
  for dteam_system in "${dteam_systems[@]}"; do
    declare -n games="$dteam_system"
    #testline#echo "system name: ${dteam_system} with system members: ${games[@]}"
    for game in "${games[@]}"; do
        #compare array game names with the mamedev systems ( * *=globally , " "=exact ) 
        #testline#echo "${systems[$mamedevindex]}" == "$game"
        if [[ "${systems[$mamedevindex]}" == "$game" ]]; then
        # If descriptions are exactly the same then use the system name of retropie as romdirectory
        # for the other arrays we use the mamedev information
        newsystems[$mamedevindex]=$dteam_system
	echo "RetroPie install -> ${newsystems[$mamedevindex]} (Using pseudo system name / category name)"
	lastcategorymatch=true
	fi
    done
  done
done
if [[ -n "$2" ]]; then
echo "RetroPie install -> $2 (Using predefined pseudo system name / category name)"
else
[[ $lastcategorymatch == false ]] && [[ -n $lastdescriptionmatch ]] && echo "RetroPie install -> ${newsystems[$mamedevindex]} ($lastdescriptionmatch)"
[[ $lastcategorymatch == false ]] && [[ -z $lastdescriptionmatch ]] && echo "RetroPie install -> ${newsystems[$mamedevindex]}"
fi
#reset variable
lastdescriptionmatch=

# test line total output
#for index in "${!systems[@]}"; do echo $index ${systems[$index]} -- ${newsystems[$index]} | more ; echo -ne '\n'; done
#  for index in "${!systems[@]}"; do
#      if [[ "${systems[$index]}" != "${newsystems[$index]}" ]]; then
#        echo "$index ${systems[$index]} => ${newsystems[$index]}"
#      fi
#  done


#part 12 : use all stored data to install runcommands for lr-mame, lr-mess and mame with media option
# in the name of the runcommand "lr-*" is used for compatibility with runcommand.sh 
# because mame is added and because mame is using this BIOS dir : $datadir/BIOS/mame
# the lr-mess command is changed to use the same BIOS dir

	local _retroarch_bin="$rootdir/emulators/retroarch/bin/retroarch"
	local _mess_core=$rootdir/libretrocores/lr-mess/mamemess_libretro.so
	local _mame_core=$rootdir/libretrocores/lr-mame/mamearcade_libretro.so
	local _system="$(if [[ -n ${RPsystemNames[$index]} ]];then echo ${RPsystemNames[$index]};else echo ${newsystems[$index]};fi)"
	local _config="$configdir/$_system/retroarch.cfg"
	local _add_config="$_config.add"
	local _custom_coreconfig="$configdir/$_system/custom-core-options.cfg"
	local _script="$scriptdir/scriptmodules/run_mess.sh"
	local _emulatorscfg="$configdir/$_system/emulators.cfg"
	local _mameini="$rootdir/configs/mame/mame.ini"
	local _basename_coreconfig="$configdir/$_system/retroarch-core-options.cfg.basename"
	local _add_config_basename="$_config.basename"

	# create retroarch configuration
	mkRomDir "$_system"

if [[ $SystemType == non-arcade ]] && [[ -f $rootdir/libretrocores/lr-mess/mamemess_libretro.so ]];then
	ensureSystemretroconfig "$_system"
	# ensure using a custom per-fake-core config for media loaders without using softlist
	iniConfig " = " "\"" "$_custom_coreconfig"
	iniSet "mame_boot_from_cli" "enabled"
	iniSet "mame_mouse_enable" "enabled"
	iniSet "mame_rotation_mode" "internal"
	iniSet "mame_softlists_enable" "disabled"
	iniSet "mame_softlists_auto_media" "disabled"
	# ensure using a custom per-fake-core config for basename loaders using softlist
	iniConfig " = " "\"" "$_basename_coreconfig"
	iniSet "mame_boot_from_cli" "enabled"
	iniSet "mame_mouse_enable" "enabled"
	iniSet "mame_rotation_mode" "internal"
	# ensure custom per-fake-core configs get loaded too via --appendconfig
	iniConfig " = " "\"" "$_add_config"
	iniSet "core_options_path" "$_custom_coreconfig"
	#
	iniConfig " = " "\"" "$_add_config_basename"
	iniSet "core_options_path" "$_basename_coreconfig"
	[[ $_system == *90º ]]&&iniSet "screen_orientation" "3"
	#
	echo "enable cheats for lr-mame/lr-mess in $configdir/all/retroarch-core-options.cfg"
	iniConfig " = " "\"" "$configdir/all/retroarch-core-options.cfg"
	iniSet "mame_cheats_enable" "enabled"
	#
	echo "enable translation ai_service for RetroArch in $configdir/all/retroarch.cfg"
	iniConfig " = " "\"" "$configdir/all/retroarch.cfg"
	iniSet "ai_service_enable" "true"
	iniSet "ai_service_mode" "0"
	iniSet "ai_service_pause" "true"
	iniSet "ai_service_source_lang" "0"
	iniSet "ai_service_target_lang" "1"
	iniSet "ai_service_url" "http://ztranslate.net/service?api_key=HEREISMYKEY"
	iniSet "input_ai_service" "t"
	iniSet "#input_ai_service_btn" "11"
fi
if [[ $SystemType == arcade ]] && [[ -f $rootdir/libretrocores/lr-mame/mamearcade_libretro.so ]];then
	ensureSystemretroconfig "$_system"
	# ensure using a custom per-fake-core config for media loaders without using softlist
	iniConfig " = " "\"" "$_custom_coreconfig"
	iniSet "mame_boot_from_cli" "enabled"
	iniSet "mame_mouse_enable" "enabled"
	iniSet "mame_rotation_mode" "internal"
	iniSet "mame_softlists_enable" "disabled"
	iniSet "mame_softlists_auto_media" "disabled"
	# ensure using a custom per-fake-core config for basename loaders using softlist
	iniConfig " = " "\"" "$_basename_coreconfig"
	iniSet "mame_boot_from_cli" "enabled"
	iniSet "mame_mouse_enable" "enabled"
	iniSet "mame_rotation_mode" "internal"
	# ensure custom per-fake-core configs get loaded too via --appendconfig
	iniConfig " = " "\"" "$_add_config"
	iniSet "core_options_path" "$_custom_coreconfig"
	#
	iniConfig " = " "\"" "$_add_config_basename"
	iniSet "core_options_path" "$_basename_coreconfig"
	[[ $_system == *90º ]]&&iniSet "screen_orientation" "3"
	#
	echo "enable cheats for lr-mame/lr-mess in $configdir/all/retroarch-core-options.cfg"
	iniConfig " = " "\"" "$configdir/all/retroarch-core-options.cfg"
	iniSet "mame_cheats_enable" "enabled"
	#
	echo "enable translation ai_service for RetroArch in $configdir/all/retroarch.cfg"
	iniConfig " = " "\"" "$configdir/all/retroarch.cfg"
	iniSet "ai_service_enable" "true"
	iniSet "ai_service_mode" "0"
	iniSet "ai_service_pause" "true"
	iniSet "ai_service_source_lang" "0"
	iniSet "ai_service_target_lang" "1"
	iniSet "ai_service_url" "http://ztranslate.net/service?api_key=HEREISMYKEY"
	iniSet "input_ai_service" "t"
	iniSet "#input_ai_service_btn" "11"
fi
	echo "enable cheats for mame in $rootdir/configs/mame/mame.ini"  
	iniConfig " " "" "$_mameini"
	iniSet "cheatpath"  "$romdir/mame/cheat"
	iniSet "cheat" "1"
	
	# set permissions for all configurations
 	chown $user:$user "$_add_config" 2>&-
	chown $user:$user "$_add_config_basename" 2>&-
 	chown $user:$user "$_custom_coreconfig" 2>&-
 	chown $user:$user "$_basename_coreconfig" 2>&-
	chown $user:$user "$configdir/all/retroarch.cfg" 2>&-
	chown $user:$user "$configdir/all/retroarch-core-options.cfg" 2>&-
	#
	chown $user:$user "$_mameini"

	echo "install runcommands with media option(s) for non-softlist loading, if possible"
	# add system to es_systems.cfg
	#the line used by @valerino didn't work for the original RetroPie-setup 
	#therefore the information is added in a different way
	addSystem "$_system" "${descriptions[$index]}" "$addextensions ${allextensions[$index]}"
	# add system to es_systems.cfg
	#the line used by @valerino didn't work for the original RetroPie-setup 
	#therefore the information is added in a different way
	#the system name is also used as description because, for example, handhelds are generated with game system names
	addSystem "$_system" "$(if [[ ${media[$index]} != "-none" ]];then echo ${descriptions[$index]};else echo ${newsystems[$index]};fi)" "$addextensionscmd $addextensions ${allextensions[$index]}$platformextensionsrp"

for index in "${!systems[@]}"; do 
if [[ -n ${allextensions[$index]} ]];then
	# add the emulators.cfg as normal, pointing to the above script # use old mess name for booting
	# all option should work with both mame and lr-mess, although -autoframeskip is better with mame
	# if using a patched runcommand.sh use these runcommands with extra repace tokens if not use the others without extra repace tokens
	if [[ $(sha1sum $rootdir/supplementary/runcommand/runcommand.sh 2>&-) == 739b6c7e50c6b4e2d048ea85f93ab8c71b1a1d74* ]];then
	    if [[ -f $rootdir/libretrocores/lr-mess/mamemess_libretro.so ]] && [[ -f $scriptdir/scriptmodules/run_mess.sh ]];then
	    addEmulator 0 "lr-run_mess-${systems[$index]}${ExtraPredefinedLoaderName[$index]}${media[$index]}-autoframeskip" "$_system" "$_script $_retroarch_bin $_mess_core $_config \\${systems[$index]} $biosdir/mame\\;%DQUOTE%%ROMDIR%%DQUOTE%  -autoframeskip -cfg_directory $configdir/$_system/lr-mess -ui_active ${ExtraPredefinedOptions[$index]} ${media[$index]} %ROM%"
	    addEmulator 0 "lr-run_mess-${systems[$index]}${ExtraPredefinedLoaderName[$index]}-game-specific${media[$index]}-autoframeskip" "$_system" "$_script $_retroarch_bin $_mess_core $_config \\${systems[$index]} $biosdir/mame\\;%DQUOTE%%ROMDIR%%DQUOTE%  -cfg_directory $configdir/$_system/lr-mess/%CLEANBASENAME% -autoframeskip -ui_active ${ExtraPredefinedOptions[$index]} ${media[$index]} %ROM%"
	    fi
	    if [[ -f $rootdir/libretrocores/lr-mess/mamemess_libretro.so ]];then
	    addEmulator 0 "lr-mess-${systems[$index]}${ExtraPredefinedLoaderName[$index]}${media[$index]}" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config -S %DQUOTE%%ROMDIR%%DQUOTE% -s %DQUOTE%%ROMDIR%%DQUOTE% -v -L $_mess_core '${systems[$index]} ${ExtraPredefinedOptions[$index]} -rompath %DQUOTE%$datadir/BIOS/mame;%ROMDIR%/%DQUOTE% -cfg_directory $configdir/$_system/lr-mess -c -ui_active ${media[$index]} %ROM%'"
	    addEmulator 0 "lr-mess-${systems[$index]}${ExtraPredefinedLoaderName[$index]}${media[$index]}-autoframeskip" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config -S %DQUOTE%%ROMDIR%%DQUOTE% -s %DQUOTE%%ROMDIR%%DQUOTE% -v -L $_mess_core '${systems[$index]} ${ExtraPredefinedOptions[$index]} -rompath %DQUOTE%$datadir/BIOS/mame;%ROMDIR%/%DQUOTE% -cfg_directory $configdir/$_system/lr-mess -c -ui_active -autoframeskip ${media[$index]} %ROM%'"
	    addEmulator 0 "lr-mess-${systems[$index]}${ExtraPredefinedLoaderName[$index]}-game-specific${media[$index]}" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config -S %DQUOTE%%ROMDIR%%DQUOTE% -s %DQUOTE%%ROMDIR%%DQUOTE% -v -L $_mess_core '${systems[$index]} ${ExtraPredefinedOptions[$index]} -rompath %DQUOTE%$datadir/BIOS/mame;%ROMDIR%/%DQUOTE% -cfg_directory $configdir/$_system/lr-mess/%CLEANBASENAME% -c -ui_active ${media[$index]} %ROM%'"
	    addEmulator 0 "lr-mess-${systems[$index]}${ExtraPredefinedLoaderName[$index]}-game-specific${media[$index]}-autoframeskip" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config -S %DQUOTE%%ROMDIR%%DQUOTE% -s %DQUOTE%%ROMDIR%%DQUOTE% -v -L $_mess_core '${systems[$index]} ${ExtraPredefinedOptions[$index]} -rompath %DQUOTE%$datadir/BIOS/mame;%ROMDIR%/%DQUOTE% -cfg_directory $configdir/$_system/lr-mess/%CLEANBASENAME% -c -ui_active -autoframeskip ${media[$index]} %ROM%'"
	    fi
	    addEmulator 0 "mame-${systems[$index]}${ExtraPredefinedLoaderName[$index]}${media[$index]}" "$_system" "$emudir/mame/mame -rompath $datadir/BIOS/mame\\;%DQUOTE%%ROMDIR%%DQUOTE% -v -c -ui_active -state_directory %DQUOTE%%ROMDIR%/mame/sta%DQUOTE% -statename %CLEANBASENAME% -state %CLEANBASENAME% ${systems[$index]} ${ExtraPredefinedOptions[$index]} ${media[$index]} %ROM% -view %BASENAME%"
	    addEmulator 0 "mame-${systems[$index]}${ExtraPredefinedLoaderName[$index]}${media[$index]}-autoframeskip" "$_system" "$emudir/mame/mame -rompath $datadir/BIOS/mame\\;%DQUOTE%%ROMDIR%%DQUOTE% -v -c -autoframeskip -ui_active -state_directory %DQUOTE%%ROMDIR%/mame/sta%DQUOTE% -statename %CLEANBASENAME% -state %CLEANBASENAME% ${systems[$index]} ${ExtraPredefinedOptions[$index]} ${media[$index]} %ROM% -view %BASENAME%"
	    addEmulator 0 "mame-${systems[$index]}${ExtraPredefinedLoaderName[$index]}-game-specific${media[$index]}" "$_system" "$emudir/mame/mame -rompath $datadir/BIOS/mame\\;%DQUOTE%%ROMDIR%%DQUOTE% -cfg_directory $configdir/$_system/mame/%CLEANBASENAME% -v -c -ui_active -state_directory %DQUOTE%%ROMDIR%/mame/sta%DQUOTE% -statename %CLEANBASENAME% -state %CLEANBASENAME% ${systems[$index]} ${ExtraPredefinedOptions[$index]} ${media[$index]} %ROM% -view %BASENAME%"
	    addEmulator 0 "mame-${systems[$index]}${ExtraPredefinedLoaderName[$index]}-game-specific${media[$index]}-autoframeskip" "$_system" "$emudir/mame/mame -rompath $datadir/BIOS/mame\\;%DQUOTE%%ROMDIR%%DQUOTE% -cfg_directory $configdir/$_system/mame/%CLEANBASENAME% -v -c -autoframeskip -ui_active -state_directory %DQUOTE%%ROMDIR%/mame/sta%DQUOTE% -statename %CLEANBASENAME% -state %CLEANBASENAME% ${systems[$index]} ${ExtraPredefinedOptions[$index]} ${media[$index]} %ROM% -view %BASENAME%"
	else
	    if [[ -f $rootdir/libretrocores/lr-mess/mamemess_libretro.so ]] && [[ -f $scriptdir/scriptmodules/run_mess.sh ]];then
	    addEmulator 0 "lr-run_mess-${systems[$index]}${ExtraPredefinedLoaderName[$index]}${media[$index]}-autoframeskip" "$_system" "$_script $_retroarch_bin $_mess_core $_config \\${systems[$index]} $biosdir/mame\\;$datadir/roms/$_system  -autoframeskip -cfg_directory $configdir/$_system/lr-mess -ui_active ${ExtraPredefinedOptions[$index]} ${media[$index]} %ROM%"
	    addEmulator 0 "lr-run_mess-${systems[$index]}${ExtraPredefinedLoaderName[$index]}-game-specific${media[$index]}-autoframeskip" "$_system" "$_script $_retroarch_bin $_mess_core $_config \\${systems[$index]} $biosdir/mame\\;$datadir/roms/$_system  -cfg_directory $configdir/$_system/lr-mess/%BASENAME% -autoframeskip -ui_active ${ExtraPredefinedOptions[$index]} ${media[$index]} %ROM%"
	    fi
	    if [[ -f $rootdir/libretrocores/lr-mess/mamemess_libretro.so ]];then
	    addEmulator 0 "lr-mess-${systems[$index]}${ExtraPredefinedLoaderName[$index]}${media[$index]}" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config -S $datadir/roms/$_system -s $datadir/roms/$_system -v -L $_mess_core '${systems[$index]} ${ExtraPredefinedOptions[$index]} -rompath $datadir/BIOS/mame;$datadir/roms/$_system/ -cfg_directory $configdir/$_system/lr-mess -c -ui_active ${media[$index]} %ROM%'"
	    addEmulator 0 "lr-mess-${systems[$index]}${ExtraPredefinedLoaderName[$index]}${media[$index]}-autoframeskip" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config -S $datadir/roms/$_system -s $datadir/roms/$_system -v -L $_mess_core '${systems[$index]} ${ExtraPredefinedOptions[$index]} -rompath $datadir/BIOS/mame;$datadir/roms/$_system/ -cfg_directory $configdir/$_system/lr-mess -c -ui_active -autoframeskip ${media[$index]} %ROM%'"
	    addEmulator 0 "lr-mess-${systems[$index]}${ExtraPredefinedLoaderName[$index]}-game-specific${media[$index]}" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config -S $datadir/roms/$_system -s $datadir/roms/$_system -v -L $_mess_core '${systems[$index]} ${ExtraPredefinedOptions[$index]} -rompath $datadir/BIOS/mame;$datadir/roms/$_system/ -cfg_directory $configdir/$_system/lr-mess/%BASENAME% -c -ui_active ${media[$index]} %ROM%'"
	    addEmulator 0 "lr-mess-${systems[$index]}${ExtraPredefinedLoaderName[$index]}-game-specific${media[$index]}-autoframeskip" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config -S $datadir/roms/$_system -s $datadir/roms/$_system -v -L $_mess_core '${systems[$index]} ${ExtraPredefinedOptions[$index]} -rompath $datadir/BIOS/mame;$datadir/roms/$_system/ -cfg_directory $configdir/$_system/lr-mess/%BASENAME% -c -ui_active -autoframeskip ${media[$index]} %ROM%'"
	    fi
	    addEmulator 0 "mame-${systems[$index]}${ExtraPredefinedLoaderName[$index]}${media[$index]}" "$_system" "$emudir/mame/mame -rompath $datadir/BIOS/mame\\;$datadir/roms/$_system -v -c -ui_active -statename $_system/%BASENAME% ${systems[$index]} ${ExtraPredefinedOptions[$index]} ${media[$index]} %ROM% -view %BASENAME%"
	    addEmulator 0 "mame-${systems[$index]}${ExtraPredefinedLoaderName[$index]}${media[$index]}-autoframeskip" "$_system" "$emudir/mame/mame -rompath $datadir/BIOS/mame\\;$datadir/roms/$_system -v -c -autoframeskip -ui_active -statename $_system/%BASENAME% ${systems[$index]} ${ExtraPredefinedOptions[$index]} ${media[$index]} %ROM% -view %BASENAME%"
	    addEmulator 0 "mame-${systems[$index]}${ExtraPredefinedLoaderName[$index]}-game-specific${media[$index]}" "$_system" "$emudir/mame/mame -rompath $datadir/BIOS/mame\\;$datadir/roms/$_system -cfg_directory $configdir/$_system/mame/%BASENAME% -v -c -ui_active -statename $_system/%BASENAME% ${systems[$index]} ${ExtraPredefinedOptions[$index]} ${media[$index]} %ROM% -view %BASENAME%"
	    addEmulator 0 "mame-${systems[$index]}${ExtraPredefinedLoaderName[$index]}-game-specific${media[$index]}-autoframeskip" "$_system" "$emudir/mame/mame -rompath $datadir/BIOS/mame\\;$datadir/roms/$_system -cfg_directory $configdir/$_system/mame/%BASENAME% -v -c -autoframeskip -ui_active -statename $_system/%BASENAME% ${systems[$index]} ${ExtraPredefinedOptions[$index]} ${media[$index]} %ROM% -view %BASENAME%"
	fi
fi
done


#part 13 : use all stored data to install runcommands for lr-mame, lr-mess and mame for loading handmade .cmd files or to run with basename
# the none media mamedev system types have no extensions in the mamedev database
# in order to switch between emulators at retropie rom boot
# we have to add these extensions
# otherwise extensions supported by other emulators will not be shown anymore
echo "install basename runcommands for softlist loading"
# grep function is used to get all extensions compatible with all possible emulation methods so switching within emulationstation is possible
# grep searches in both platform.cfg and the ext/RetroPie-Share/platforms.cfg , so also extensions are added that are not in platform.cfg 
# using grep this way can create double extension, but this should not be a problem
##we have to use an if function to be sure this is only generated and installed once per system
##the if function will check if the last created system is not equal to the next system in the array
for index in "${!newsystems[@]}"; do 
local platformextensionsrp=$(grep ${newsystems[$index]}_exts $scriptdir/platforms.cfg $scriptdir/ext/RetroPie-Share/platforms.cfg | cut -d '"' -f 2)
if [[ $SystemType == non-arcade ]];then
	#plain commands
	#lr-xxxx-cmd is used for loading .cmd files, amongst others
	#single-quotes are used for loading lr-mess options
	#adding 2 rompaths if available 
	#option -cfg_directory is not added, it should use the propper directory
	#in order to save files we need to add the savepaths to retroarch as options
	#"-c -ui_active etc" is placed before "-rompath" and a / is added after the last rompath , this way the options are not added in the savestate filename
	#only issue after is that the savestate filename still contains 1 space in the beginning of the filename and double quotes
	#to fix this issue of double quotes the basename can be single quoted to remove them in the filename (we still have 1 space !) 
	# if using a patched runcommand.sh use these runcommands with extra repace tokens if not use the others without extra repace tokens
	if [[ $(sha1sum $rootdir/supplementary/runcommand/runcommand.sh 2>&-) == 739b6c7e50c6b4e2d048ea85f93ab8c71b1a1d74* ]];then
	    if [[ -f $rootdir/libretrocores/lr-mess/mamemess_libretro.so ]];then
	    #addEmulator 0 "lr-mess-cmd" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config -v -L $_mess_core %ROM%"
	    addEmulator 0 "lr-mess$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config_basename -S %DQUOTE%%ROMDIR%%DQUOTE% -s %DQUOTE%%ROMDIR%%DQUOTE% -v -L $_mess_core 'mame $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) -cfg_directory $configdir/$_system/lr-mess -c -ui_active -rompath %DQUOTE%$datadir/BIOS/mame;%ROMDIR%/%DQUOTE% %ADDSLOT% '%SOFTLIST%%BASENAME%''"
	    addEmulator 0 "lr-mess$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename-autoframeskip" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config_basename -S %DQUOTE%%ROMDIR%%DQUOTE% -s %DQUOTE%%ROMDIR%%DQUOTE% -v -L $_mess_core 'mame $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) -cfg_directory $configdir/$_system/lr-mess -c -ui_active -autoframeskip -rompath %DQUOTE%$datadir/BIOS/mame;%ROMDIR%/%DQUOTE% %ADDSLOT% '%SOFTLIST%%BASENAME%''"
	    addEmulator 0 "lr-mess$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename-frameskip_10" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config_basename -S %DQUOTE%%ROMDIR%%DQUOTE% -s %DQUOTE%%ROMDIR%%DQUOTE% -v -L $_mess_core 'mame $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) -cfg_directory $configdir/$_system/lr-mess -c -ui_active -frameskip 10 -rompath %DQUOTE%$datadir/BIOS/mame;%ROMDIR%/%DQUOTE% %ADDSLOT% '%SOFTLIST%%BASENAME%''"
	    fi
	else
	    if [[ -f $rootdir/libretrocores/lr-mess/mamemess_libretro.so ]];then
	    #addEmulator 0 "lr-mess-cmd" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config -v -L $_mess_core %ROM%"
	    addEmulator 0 "lr-mess$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config_basename -S $datadir/roms/$_system -s $datadir/roms/$_system -v -L $_mess_core 'mame $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) -cfg_directory $configdir/$_system/lr-mess -c -ui_active -rompath $datadir/BIOS/mame;$datadir/roms/$_system/ '%BASENAME%''"
	    addEmulator 0 "lr-mess$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename-autoframeskip" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config_basename -S $datadir/roms/$_system -s $datadir/roms/$_system -v -L $_mess_core 'mame $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) -cfg_directory $configdir/$_system/lr-mess -c -ui_active -autoframeskip -rompath $datadir/BIOS/mame;$datadir/roms/$_system/ '%BASENAME%''"
	    addEmulator 0 "lr-mess$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename-frameskip_10" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config_basename -S $datadir/roms/$_system -s $datadir/roms/$_system -v -L $_mess_core 'mame $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) -cfg_directory $configdir/$_system/lr-mess -c -ui_active -frameskip 10 -rompath $datadir/BIOS/mame;$datadir/roms/$_system/ '%BASENAME%''"
	    fi
	fi
else
	# if using a patched runcommand.sh use these runcommands with extra repace tokens if not use the others without extra repace tokens
	if [[ $(sha1sum $rootdir/supplementary/runcommand/runcommand.sh 2>&-) == 739b6c7e50c6b4e2d048ea85f93ab8c71b1a1d74* ]];then
	    if [[ -f $rootdir/libretrocores/lr-mame/mamearcade_libretro.so ]];then
	    addEmulator 0 "lr-mame$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config_basename -S %DQUOTE%%ROMDIR%%DQUOTE% -s %DQUOTE%%ROMDIR%%DQUOTE% -v -L $_mame_core 'mame $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) -cfg_directory $configdir/$_system/lr-mame -c -ui_active -rompath %DQUOTE%$datadir/BIOS/mame;%ROMDIR%/%DQUOTE% '%BASENAME%''"
	    addEmulator 0 "lr-mame$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename-autoframeskip" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config_basename -S %DQUOTE%%ROMDIR%%DQUOTE% -s %DQUOTE%%ROMDIR%%DQUOTE% -v -L $_mame_core 'mame $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) -cfg_directory $configdir/$_system/lr-mame -c -ui_active -autoframeskip -rompath %DQUOTE%$datadir/BIOS/mame;%ROMDIR%/%DQUOTE% '%BASENAME%''"
	    addEmulator 0 "lr-mame$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename-frameskip_10" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config_basename -S %DQUOTE%%ROMDIR%%DQUOTE% -s %DQUOTE%%ROMDIR%%DQUOTE% -v -L $_mame_core 'mame $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) -cfg_directory $configdir/$_system/lr-mame -c -ui_active -frameskip 10 -rompath %DQUOTE%$datadir/BIOS/mame;%ROMDIR%/%DQUOTE% '%BASENAME%''"
	    fi
	else
	    if [[ -f $rootdir/libretrocores/lr-mame/mamearcade_libretro.so ]];then
	    addEmulator 0 "lr-mame$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config_basename -S $datadir/roms/$_system -s $datadir/roms/$_system -v -L $_mame_core 'mame $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) -cfg_directory $configdir/$_system/lr-mame -c -ui_active -rompath $datadir/BIOS/mame;$datadir/roms/$_system/ '%BASENAME%''"
	    addEmulator 0 "lr-mame$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename-autoframeskip" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config_basename -S $datadir/roms/$_system -s $datadir/roms/$_system -v -L $_mame_core 'mame $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) -cfg_directory $configdir/$_system/lr-mame -c -ui_active -autoframeskip -rompath $datadir/BIOS/mame;$datadir/roms/$_system/ '%BASENAME%''"
	    addEmulator 0 "lr-mame$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename-frameskip_10" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config_basename -S $datadir/roms/$_system -s $datadir/roms/$_system -v -L $_mame_core 'mame $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) -cfg_directory $configdir/$_system/lr-mame -c -ui_active -frameskip 10 -rompath $datadir/BIOS/mame;$datadir/roms/$_system/ '%BASENAME%''"
	    fi
	fi
fi
	# if using a patched runcommand.sh use these runcommands with extra repace tokens if not use the others without extra repace tokens
	if [[ $(sha1sum $rootdir/supplementary/runcommand/runcommand.sh 2>&-) == 739b6c7e50c6b4e2d048ea85f93ab8c71b1a1d74* ]];then
	addEmulator 0 "mame$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename" "$_system" "$emudir/mame/mame -rompath $datadir/BIOS/mame\\;%DQUOTE%%ROMDIR%%DQUOTE% -v -c -ui_active -state_directory %DQUOTE%%ROMDIR%/mame/sta%DQUOTE% -statename %CLEANBASENAME% -state %CLEANBASENAME% $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) $([[ $_system == *90º ]]&&echo "-rol") %ADDSLOT% %SOFTLIST%%BASENAME% -view %BASENAME%"
	addEmulator 0 "mame$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename-autoframeskip" "$_system" "$emudir/mame/mame -rompath $datadir/BIOS/mame\\;%DQUOTE%%ROMDIR%%DQUOTE% -v -c -ui_active -state_directory %DQUOTE%%ROMDIR%/mame/sta%DQUOTE% -statename %CLEANBASENAME% -state %CLEANBASENAME% -autoframeskip $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) $([[ $_system == *90º ]]&&echo "-rol") %ADDSLOT% %SOFTLIST%%BASENAME%  -view %BASENAME%"
	addEmulator 0 "mame$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename-frameskip_10" "$_system" "$emudir/mame/mame -rompath $datadir/BIOS/mame\\;%DQUOTE%%ROMDIR%%DQUOTE% -v -c -ui_active -state_directory %DQUOTE%%ROMDIR%/mame/sta%DQUOTE% -statename %CLEANBASENAME% -state %CLEANBASENAME% -frameskip 10 $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) $([[ $_system == *90º ]]&&echo "-rol") %ADDSLOT% %SOFTLIST%%BASENAME%  -view %BASENAME%"
	else
	addEmulator 0 "mame$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename" "$_system" "$emudir/mame/mame -rompath $datadir/BIOS/mame\\;$datadir/roms/$_system -v -c -ui_active -statename $_system/%BASENAME% $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) $([[ $_system == *90º ]]&&echo "-rol") %BASENAME% -view %BASENAME%"
	addEmulator 0 "mame$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename-autoframeskip" "$_system" "$emudir/mame/mame -rompath $datadir/BIOS/mame\\;$datadir/roms/$_system -v -c -ui_active -statename $_system/%BASENAME% -autoframeskip $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) $([[ $_system == *90º ]]&&echo "-rol") %BASENAME% -view %BASENAME%"
	addEmulator 0 "mame$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename-frameskip_10" "$_system" "$emudir/mame/mame -rompath $datadir/BIOS/mame\\;$datadir/roms/$_system -v -c -ui_active -statename $_system/%BASENAME% -frameskip 10 $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) $([[ $_system == *90º ]]&&echo "-rol") %BASENAME% -view %BASENAME%"
	fi
done
	#sort the emulators.cfg file
	sort -o $_emulatorscfg $_emulatorscfg
	#if containing a default line then remember the default line,
	#delete it, remove the empty line and put it back at the end of the file
	cat $_emulatorscfg|while read line
	do if [[ $line == default* ]]; then 
	sed -i "s/$line//g" $_emulatorscfg
	#https://stackoverflow.com/questions/16414410/delete-empty-lines-using-sed
	sed -i -r "/^\s*$/d" $_emulatorscfg
	echo $line >> $_emulatorscfg
	fi
	done
	chown $user:$user "$_emulatorscfg"


#part 14 : add config patches
# PATCH 1 : cdmono1 => enable 4:3 screen, mouse and all mouse buttons using lr-mess
if [[ -f $rootdir/libretrocores/lr-mess/mamemess_libretro.so ]];then
    if [[ $1 == cdimono1 ]];then
    show_message_mamedev "\
After pressing ok a patch will be installed for cdimono1.\n\n\
Patch cdimono1 retroarch.cfg for lr-mess to :\n\
- assign the mouse buttons as joystick buttons to get mouse working !!!\n\
- assign right-alt as grab_mouse_toggle key for matching mouse movements to the host enviroment when running in desktop mode !!!\n\n\
The config is written in :\n\
$rootdir/configs/cdimono1/"
    #using sed here to keep ownership of the retroarch.cfg file correct (solution used with cdimono1.cfg will not work)
    if  [[ "$(cat $rootdir/configs/cdimono1/retroarch.cfg)" != *input_player1_b_mbtn* ]]
    then 
    # adding 'input_player1_b_mbtn = "2"' line  below info line
    sed -i s/line/line\\ninput\_player1\_b\_mbtn\ \=\ \"2\"/g  "$rootdir/configs/cdimono1/retroarch.cfg"
    fi
    if  [[ "$(cat $rootdir/configs/cdimono1/retroarch.cfg)" != *input_player1_a_mbtn* ]]
    then 
    # adding 'input_player1_a_mbtn = "1"' line below info line
    sed -i s/line/line\\ninput\_player1\_a\_mbtn\ \=\ \"1\"/g "$rootdir/configs/cdimono1/retroarch.cfg"
    fi
    if  [[ "$(cat $rootdir/configs/cdimono1/retroarch.cfg)" != *input_grab_mouse_toggle* ]]
    then 
    # adding 'input_grab_mouse_toggle = shift' line  below info line
    sed -i s/line/line\\ninput\_grab\_mouse\_toggle\ \=\ shift/g "$rootdir/configs/cdimono1/retroarch.cfg"
    fi
    show_message_mamedev "\
After pressing ok a patch will be installed for cdimono1.\n\n\
Patch the mame cdimono1.cfg for lr-mess to :\n\
- assign the joystick buttons as mouse buttons to get mouse working !!!\n\
- show standard 4:3 screen !!!\n\n
The config is written in :\n\
$rootdir/configs/cdimono1/lr-mess"
    mv $rootdir/configs/cdimono1/lr-mess/cdimono1.cfg $rootdir/configs/cdimono1/lr-mess/cdimono1.cfg.bak 2>&-
    mkdir $rootdir/configs/cdimono1/lr-mess 2>&-
    cat >$rootdir/configs/cdimono1/lr-mess/cdimono1.cfg << _EOF_
<?xml version="1.0"?>
<!-- This file is autogenerated; comments and unknown tags will be stripped -->
<mameconfig version="10">
    <system name="cdimono1">
        <video>
            <target index="0" view="Screen 0 Standard (4:3)" />
        </video>
        <input>
            <port tag=":slave_hle:MOUSEBTN" type="P1_BUTTON1" mask="1" defvalue="0">
                <newseq type="standard">
                    JOYCODE_1_BUTTON1
                </newseq>
            </port>
            <port tag=":slave_hle:MOUSEBTN" type="P1_BUTTON2" mask="2" defvalue="0">
                <newseq type="standard">
                    JOYCODE_1_BUTTON2
                </newseq>
            </port>
        </input>
        <image_directories>
            <device instance="cdrom" directory="$datadir/roms/cdimono1/" />
        </image_directories>
    </system>
</mameconfig>
_EOF_
    chown -R $user:$user "$rootdir/configs/cdimono1/lr-mess" 2>&-
fi
fi

# PATCH 2 : cdmono1 => enable 4:3 screen using mame
if [[ $1 == cdimono1 ]];then
show_message_mamedev "\
After pressing ok a patch will be installed for cdimono1.\n\n\
Patch mame cdimono1.cfg for standalone mame to :\n\
- show standard 4:3 screen !!!\n\n\
The config is written in :\n\
$datadir/roms/mame/cfg"
mv $datadir/roms/mame/cfg/cdimono1.cfg $datadir/roms/mame/cfg/cdimono1.cfg.bak 2>&-
mkdir $datadir/roms/mame/cfg 2>&-
cat >$datadir/roms/mame/cfg/cdimono1.cfg << _EOF_
<?xml version="1.0"?>
<!-- This file is autogenerated; comments and unknown tags will be stripped -->
<mameconfig version="10">
    <system name="cdimono1">
        <video>
            <target index="0" view="Screen 0 Standard (4:3)" />
        </video>
        <ui_warnings launched="1645368816" warned="1645368815">
            <feature device="cdimono1" type="graphics" status="imperfect" />
            <feature device="cdimono1" type="sound" status="imperfect" />
        </ui_warnings>
        <image_directories>
            <device instance="cdrom" directory="$datadir/roms/cdimono1/" />
        </image_directories>
    </system>
</mameconfig>
_EOF_
chown -R $user:$user "$datadir/roms/mame/cfg" 2>&-
fi
}


function show_message_mamedev() {
dialog --colors --backtitle "$__backtitle" --msgbox "$1" 22 76 2>&1 >/dev/tty
}


function download_cheats_mamedev() {
clear
echo "get the cheat.7z and place it in the correct path"
echo
#see http://www.mamecheat.co.uk/
wget -N -P /tmp http://cheat.retrogames.com/$1
#cheatpath for lr-mess
unzip -o /tmp/$(echo $1|cut -d\/ -f2) cheat.7z -d $datadir/BIOS/mame/cheat
chown -R $user:$user "$datadir/BIOS/mame/cheat" 
#cheatpath for mame
unzip -o /tmp/$(echo $1|cut -d\/ -f2) cheat.7z -d $datadir/roms/mame/cheat
chown -R $user:$user "$datadir/roms/mame/cheat" 
rm /tmp/$(echo $1|cut -d\/ -f2)
}


function organise_realistic_overlays_mamedev() {
rm $datadir/downloads/Orionsangels_Realistic_Overlays_For_RetroPie/Retroarch/config/MAME/* 2>&1
unzip -u $datadir/downloads/Orionsangels_Realistic_Overlays_For_RetroPie.zip -d $datadir/downloads
chown -R $user:$user $datadir/downloads
# we want to convert the viewport values on the fly
# the original files are made for the resolution 1920x1080
# so if we want to re-calculate the values when using, for example 1600x900,
# when the value is extracted, we can do it like this for the width (x) :  $(($value * 1600/1920)) , or for the height (y) : $(($value * 900/1080))
# with "fbset -s" we can extract the resolution in a linux (without or with desktop enviroment)
# with "xrandr" we can extract the correct resolution in a linux when changed with xrandr
# so we check "xrandr" first and if we don't have a value we use "fbset"
if [[ -n $(xrandr) ]];then echo -e "\nusing xrandr for detecting host resolution\n";else echo -e "\nusing xrandr for detecting host resolution\n";fi
value_height_y=$(if [[ -n $(xrandr) ]];then echo $(xrandr 2>&1|grep \*|sed 's/x/ /'|cut -d " " -f5);else echo $(fbset -s|grep geo|cut -d " " -f7);fi)
value_width_x=$(if [[ -n $(xrandr) ]];then echo $(xrandr 2>&1|grep \*|sed 's/x/ /'|cut -d " " -f4);else echo $(fbset -s|grep geo|cut -d " " -f6);fi)

for cfg_file in $datadir/downloads/Orionsangels_Realistic_Overlays_For_RetroPie/Retroarch/config/MAME/*.cfg
do
 if
 [[ "$cfg_file"  != *.zip.cfg ]];then
 echo "patching $(echo $cfg_file|cut -d/ -f10) for "$value_width_x"x"$value_height_y", creating a.zip.cfg and a .7z.cfg"
 sed -i "s|[:]|\/home\/$user\/RetroPie\/downloads\/Orionsangels_Realistic_Overlays_For_RetroPie\/Retroarch|g;s|[\]|\/|g" "$cfg_file"
 echo aspect_ratio_index = \"23\" >> "$cfg_file"
 echo video_shader = \"$rootdir/configs/all/retroarch/shaders/fake-crt-geom.glslp\" >> "$cfg_file"
 value=$(cat "$cfg_file"|grep _height|cut -d '"' -f2);sed -i "s/$value/$(($value * $value_height_y/1080))/g" "$cfg_file"
 value=$(cat "$cfg_file"|grep _width|cut -d '"' -f2);sed -i "s/$value/$(($value * $value_width_x/1920))/g" "$cfg_file"
 value=$(cat "$cfg_file"|grep _x|cut -d '"' -f2);sed -i "s/$value/$(($value * $value_width_x/1920))/g" "$cfg_file"
 value=$(cat "$cfg_file"|grep _y|cut -d '"' -f2);sed -i "s/$value/$(($value * $value_height_y/1080))/g" "$cfg_file"
 mv "$cfg_file" "$(echo $cfg_file|sed 's/\.cfg/\.zip\.cfg/')"
 cp "$(echo $cfg_file|sed 's/\.cfg/\.zip\.cfg/')" "$(echo $cfg_file|sed 's/\.cfg/\.7z\.cfg/')"
 fi
done
echo -e "\nmove all .zip.cfg and .7z.cfg files to $datadir/roms/realistic\n"
sleep 2
mv -f $datadir/downloads/Orionsangels_Realistic_Overlays_For_RetroPie/Retroarch/config/MAME/*.cfg $datadir/roms/realistic
chown -R $user:$user $datadir/roms/realistic
}


function download_from_google_drive_mamedev() {
clear
echo "get all files and put these in the correct path"
echo
curl https://raw.githubusercontent.com/matthuisman/gdrivedl/master/gdrivedl.py | \
python3 - https://drive.google.com/drive/folders/$1 -m -P "$2"
#wget -nv -O /tmp/gdrivedl.py https://raw.githubusercontent.com/matthuisman/gdrivedl/master/gdrivedl.py
#python /tmp/gdrivedl.py https://drive.google.com/drive/folders/1f_jXMG0XMBdyOOBpz8CHM6AFj9vC1R6m -P $rootdir/configs/all/emulationstation/gamelists
chown -R $user:$user "$2"
#rm /tmp/gdrivedl.py
}


function download_from_github_mamedev() {
clear
#$1 = github_directory $2=target_directory $3=extension_of_the_multiple_files
echo "get all files and put these in the correct path"
echo
curl -s https://github.com/$1|sed 's/name/name\n/g'|grep \.$3 | cut -d\" -f 3| while read github_file
do 
echo downloading $github_file to $2
curl https://raw.githubusercontent.com/$(echo $1|sed 's/\/tree//g')/$(echo $github_file|sed 's/ /%20/g') > "$2/$github_file"
chown $user:$user "$2/$github_file"
done
}


function download_file_mamedev() {
clear
echo "getting your desired file"
mkdir -p $3
#show a wget progress bar => https://stackoverflow.com/questions/4686464/how-can-i-show-the-wget-progress-bar-only
#$1=filename $2=from_link $3=to_path
if [ ! -f "$3/$1" ]; then
    wget -q --show-progress --progress=bar:force -T3 -t0 -c -w1 -O $3/$1 $([[ $2 != http* ]] && echo https://)$2/$1 2>&1
    #doesn't work, perhaps the command or redirecting is the problem
    # curl -L -O https://$2/$1 --create-dirs -o $3/$1
    sleep 10
else 
    read -r -p "File exists !, do you want to overwrite it ? [Y/N] " response
       if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]];then 
           wget -q --show-progress --progress=bar:force -T3 -t0 -c -w1 -O $3/$1 $([[ $2 != http* ]] && echo https://)$2/$1 2>&1
       fi
fi

[[ "$3" == "$datadir/downloads"* ]] && chown -R $user:$user "$datadir/downloads"
chown -R $user:$user "$3"
}


function create_background_overlays_mamedev() {
clear
echo "extract background files from mame artwork, if available, and create custom retroarch configs for overlay's"
echo
#added handheld arrays, used for overlays
#this is an example command to extract the systems and add them here to the array :
#classich=( "\"$(cat mame_systems_dteam_classich|cut -d " " -f2)\"" );echo ${classich[@]}|sed 's/ /\" \"/g'
read_data_mamedev
IFS=$'\n' 
classich=($(cut -d "," -f 2 <<<$(awk /@classich/<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
konamih=($(cut -d "," -f 2 <<<$(awk /@konamih/<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
tigerh=($(cut -d "," -f 2 <<<$(awk /@tigerh/<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
gameandwatch=($(cut -d "," -f 2 <<<$(awk /@gameandwatch/<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
unset IFS


#create a subarray of the arrays being used for overlays
#now only two for loops can be use for multiple arrays
systems=("classich" "konamih" "tigerh" "gameandwatch")

#use multiple arrays over one for loop:
#https://unix.stackexchange.com/questions/545502/bash-array-of-arrays
for system in "${systems[@]}"; do
    declare -n games="$system"
    #echo "system name: ${system} with system members: ${games[@]}"
    for game in "${games[@]}"; do
        #echo -en "\tworking on name $game of the $system system\n"
        mkdir -p "$datadir/roms/$system"
        chown $user:$user "$datadir/roms/$system" 
	#extract Background files,if existing in zip, from mame artwork files // issue not all artwork files have Background.png
        unzip $datadir/roms/mame/artwork/$game.zip Background.png -d $datadir/roms/mame/artwork 2>/dev/null
        checkforbackground=$(ls $datadir/roms/mame/artwork/Background.png 2> /dev/null)
        if [[ -n $checkforbackground ]]
        then
        mv $datadir/roms/mame/artwork/Background.png  $rootdir/configs/all/retroarch/overlay/$game.png 2>/dev/null
        chown $user:$user "$rootdir/configs/all/retroarch/overlay/$game.png" 
	#create configs
	cat > "$datadir/roms/$system/$game.zip.cfg" << _EOF_
input_overlay =  $rootdir/configs/all/retroarch/overlay/$game.cfg
input_overlay_enable = true
input_overlay_opacity = 0.500000
input_overlay_scale = 1.000000
_EOF_
        cp "$datadir/roms/$system/$game.zip.cfg" "$datadir/roms/$system/$game.7z.cfg"
        chown $user:$user $datadir/roms/$system/$game.*.cfg
        #
	cat > "$rootdir/configs/all/retroarch/overlay/$game.cfg" << _EOF_
overlays = 1
overlay0_overlay = $game.png
overlay0_full_screen = false
overlay0_descs = 0
_EOF_
        chown $user:$user "$rootdir/configs/all/retroarch/overlay/$game.cfg" 
        fi 
    done
done
}


function create_bezel_overlays_mamedev() {
clear
echo "extract bezel files from mame artwork, if available, and create custom retroarch configs for bezels"
echo
#added handheld arrays, used for overlays
#this is an example command to extract the systems and add them here to the array :
#classich=( "\"$(cat mame_systems_dteam_classich|cut -d " " -f2)\"" );echo ${classich[@]}|sed 's/ /\" \"/g'
read_data_mamedev
IFS=$'\n' 
classich=($(cut -d "," -f 2 <<<$(awk /@classich/<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
konamih=($(cut -d "," -f 2 <<<$(awk /@konamih/<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
tigerh=($(cut -d "," -f 2 <<<$(awk /@tigerh/<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
gameandwatch=($(cut -d "," -f 2 <<<$(awk /@gameandwatch/<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
unset IFS


#create a subarray of the arrays being used for overlays
#now only two for loops can be use for multiple arrays
systems=("classich" "konamih" "tigerh" "gameandwatch")

#use multiple arrays over one for loop:
#https://unix.stackexchange.com/questions/545502/bash-array-of-arrays
for system in "${systems[@]}"; do
    declare -n games="$system"
    #echo "system name: ${system} with system members: ${games[@]}"
    for game in "${games[@]}"; do
        #echo -en "\tworking on name $game of the $system system\n"
        mkdir -p "$datadir/roms/$system"
        chown $user:$user "$datadir/roms/$system" 
	#extract Bezel files,if existing in zip, from mame artwork files // not all artwork files have Bezel-16-9.png or Bezel-4-3.png
        unzip $datadir/roms/mame/artwork/$game.zip Bezel$1.png -d $datadir/roms/mame/artwork 2>/dev/null
        checkforbezel=$(ls $datadir/roms/mame/artwork/Bezel$1.png 2> /dev/null)
        if [[ -n $checkforbezel ]]
        then
        mv $datadir/roms/mame/artwork/Bezel$1.png  $rootdir/configs/all/retroarch/overlay/$game.png 2>/dev/null
        chown $user:$user "$rootdir/configs/all/retroarch/overlay/$game.png" 
	#create configs
	cat > "$datadir/roms/$system/$game.zip.cfg" << _EOF_
input_overlay =  $rootdir/configs/all/retroarch/overlay/$game.cfg
input_overlay_enable = true
input_overlay_opacity = 0.700000
input_overlay_scale = 1.000000
_EOF_
        cp "$datadir/roms/$system/$game.zip.cfg" "$datadir/roms/$system/$game.7z.cfg"
        chown $user:$user $datadir/roms/$system/$game.*.cfg
        #
	cat > "$rootdir/configs/all/retroarch/overlay/$game.cfg" << _EOF_
overlays = 1
overlay0_overlay = $game.png
overlay0_full_screen = true
overlay0_descs = 0
_EOF_
        chown $user:$user "$rootdir/configs/all/retroarch/overlay/$game.cfg" 
        fi 
    done
done
}


function retroscraper_remote_depends_mamedev () {
	#install pip if the pip module is not installed
    if [[ $(su $user -c "python3 -m pip list" 2>&1) == *"No module named pip"* ]]; then
        su $user -c "wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py"
        su $user -c "python3 /tmp/get-pip.py"
    fi

    #update pip if there is a new release (2>&1 is used to redirect stderr to stdout so we can use the if function on the stderr info)
	[[ $(su $user -c "python3 -m pip list" 2>&1) == *"new release of pip"* ]] && su $user -c "python3 -m pip install --user --upgrade pip"

    #install python modules when not detected as installed
    #retroscraper-remote needs httpimport as extra library so some dependancies can be used "online"
    #https://stackoverflow.com/questions/23106621/replace-multiple-consecutive-white-spaces-with-one-comma-in-unix
	local pip_list_output
	local retroscraper_remote_module
	local retroscraper_remote_modules=()
	retroscraper_remote_modules=(
	wheel==0.40.0
	setuptools==67.7.2
	googletrans==4.0.0rc1
	Pillow==9.5.0
	requests==2.30.0
	httpimport==1.3.0
	)
	#this command was the first test and filters out the required modules but has no speed advantage vs the used command
	#pip_list_output=$(su $user -c "python3 -m pip list|sed 's/ \{1,\}/==/g'|awk \"/${retroscraper_remote_modules[0]}/ || /${retroscraper_remote_modules[1]}/ || /${retroscraper_remote_modules[2]}/ || /${retroscraper_remote_modules[3]}/ ||  /${retroscraper_remote_modules[4]}/ || /${retroscraper_remote_modules[5]}/\"")
	pip_list_output=$(su $user -c "python3 -m pip list|sed 's/ \{1,\}/==/g'")
	
	for retroscraper_remote_module in ${retroscraper_remote_modules[@]};do 
	[[ $pip_list_output != *$retroscraper_remote_module* ]] && su $user -c "python3 -m pip install --user $retroscraper_remote_module"
	done
}

