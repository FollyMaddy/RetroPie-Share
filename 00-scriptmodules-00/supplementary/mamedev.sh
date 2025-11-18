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
rp_module_version="0282.11"
rp_module_version_database="${rp_module_version%.*}"
if [[ -f $emudir/mame/mame ]];then
 #works in terminal but not here ?
 #rp_module_version_mame="${"${"${$($emudir/mame/mame -version)}"/./}": 0:4}"
 #extracting the first version number from the output using seperate lines instead (Shell Parameter Expansion)
 rp_module_version_mame="$($emudir/mame/mame -version)"
 rp_module_version_mame="${rp_module_version_mame/./}"
 rp_module_version_mame="${rp_module_version_mame: 0:4}"
 [[ ${rp_module_version_mame} != 0* ]] && rp_module_version_mame="UNKNOWN"
fi
rp_module_database_version=
rp_module_database_excluded_versions=()
rp_module_database_excluded_versions=( 242 244 254 256 257 268 269 270 273)
rp_module_database_versions=()
#reading from internet seems to fail sometimes, perhaps due to a bad connection
#rp_module_database_versions=( "" $(curl -s https://github.com/FollyMaddy/RetroPie-Share/tree/main/00-databases-00/mame|sed 's/:/\\\n/g'|grep _info\"|grep path|grep -v 023|grep -E -o '[0-9.]+'|sort -r) )
#instead using a sequence now with a few exclusions from the array
#used this information on how to use the seq command : https://stackoverflow.com/questions/169511/how-do-i-iterate-over-a-range-of-numbers-defined-by-variables-in-bash
#used this information to construct the command : https://stackoverflow.com/questions/3685970/check-if-a-bash-array-contains-a-value
rp_module_database_versions=( "" $(seq $rp_module_version_database -1 0240|while read rp_module_database_version;do [[ " ${rp_module_database_excluded_versions[*]} " =~ " ${rp_module_database_version} " ]] || echo "0${rp_module_database_version}";done) )

local mamedev_csv=()
local gamelists_csv=()

local restricted_download_csv=()
local system_read


function depends_mamedev() {
    mamedev_csv=()
    getDepends curl python3 wget
    if [[ $scriptdir == *RetroPie* ]];then 
	getDepends xattr python3-venv unar p7zip-full xxd
    else 
	getDepends python-xattr unarchiver tinyxxd
    fi
    
    #install uv python manager as normal user
    if [[ ! -f /home/$user/.local/bin/uv ]];then
    echo "Installing Python manager UV"
    su $user -c "curl -LsSf https://astral.sh/uv/install.sh | sh"
    su $user -c "source /home/$user/.local/bin/env"
	fi
    
    if [[ -z $(xattr -p user.comment $(if [[ -f $scriptdir/ext/RetroPie-Share/scriptmodules/supplementary/mamedev.sh ]];then echo $scriptdir/ext/RetroPie-Share/scriptmodules/supplementary/mamedev.sh;else echo $scriptdir/scriptmodules/supplementary/mamedev.sh;fi) 2>&-) ]];then

    [[ $scriptdir == *ArchyPie* ]] &&  show_message_mamedev "\
You are running ArchyPie.\n\
\n\
Note that ArchyPie is beta and that some things do not work correctly.\n\
There are issues with flags not being passed correctly.\n\
Therefor RetroArch can be compiled with the wrong flags and not work.\n\
At least not working on the RPI4 in Manjaro 23 linux.\n\
\n\
Flags, now filled with :\n\
__platform_flags = ${__platform_flags}\n\
__XDG_SESSION_TYPE = ${__XDG_SESSION_TYPE}\n\
"


    show_message_mamedev "\
                                                 One time update info\n\
282.11 :\n\
- add 'Python manager UV' as dependancy install\n\
- let gdrivedl and retroscrape-remote use Python 3.11 using UV\n\
- mark retroscrape-remote as experimental with issue\n\
282.10 :\n\
- skip form when refreshing automated category install\n\
- changing config options for mame : set to experimental\n\
282.09 :\n\
- improve : detect pressing left-shift\n\
282.08 :\n\
- refresh option for automated category install\n\
282.07 :\n\
- changing config options for mame : add and refine\n\
282.06 :\n\
- changing config options for mame : add, refine and fix help\n\
282.05 :\n\
- finally : add working refresh\n\
282.04 :\n\
- refine changing config options for mame\n\
282.03 :\n\
- remove old breaking commands and add new ones\n\
- combine option mouse/multimouse change\n\
282.02 :\n\
- toggle some mame.ini options : early stage\n\
- new way of breaking functions after run\n\
- rename some menu items\n\
282.01 :\n\
- update audio samples download to 278\n\
282.00 :\n\
- add new simple database without progettosnaps data\n\
281.01 :\n\
- update info for Debian-13/Trixie\n\
281.00 :\n\
- add new simple database without progettosnaps data\n\
- remove @good@ filter when creating categories or linking roms\n\
  - add in message that @good@ can be added if needed\n\
- prioritize linking with clones in menu\n\
280.00 :\n\
- add new simple database without progettosnaps data\n\
279.01 :\n\
- remove experimental stuff\n\
279.00 :\n\
- add new simple database without progettosnaps data\n\
- change filter showing categories\n\
278.02 :\n\
- comment test lines\n\
278.01 :\n\
- fix : create good csv lines from the database\n\
  - last tag needs to end with @\n\
278.00 :\n\
- add new database\n\
- turn off 'upright'\n\
277.03 :\n\
- fix : create good csv lines from the database\n\
277.02 :\n\
- change message\n\
  - debian12 binaries do not work on debian13\n\
277.01 :\n\
- add stickfreaks binaries again\n\
  - curl connection secure again\n\
  - has armhf and aarch64 binaries\n\
  - has binaries for Debian13/Trixie\n\
  - includes programs like tapeconv or chdman\n\
277.00 :\n\
- add new database\n\
276.00 :\n\
- add new database\n\
275.00 :\n\
- add new database\n\
274.03 :\n\
- add extra 4M ram and floppydrive for aa5000\n\
274.02 :\n\
- add subfunction for adding default extra driver options\n\
  - extra media options are detected and used for runcommands\n\
  - add extra ide harddrive for aa5000\n\
274.01 :\n\
- able to link .7z files\n\
274.00 :\n\
- add new database\n\
- be able to download audio samples when using 274 or greater\n\
- tag drivers in database that use arm 'dynarec'\n\
- tag drivers in database that use audio 'samples'\n\
272.00 :\n\
- add new database\n\
271.03 :\n\
- install default astrocd(e)/(l)/(w) with two joysticks\n\
271.02 :\n\
- add predefined list for home systems\n\
271.01 :\n\
- fix not showing working_arcade in non-arcade\n\
271.00 :\n\
- skip versions 268 269 270\n\
- add new database\n\
267.15 :\n\
- improve help creating hardlinks\n\
267.14 :\n\
- turn off restricted downloads as everything is down\n\
267.13 :\n\
- filter out mechanical\n\
267.12 :\n\
- filter fix\n\
- sport becomes sports\n\
267.11 :\n\
- update python modules for retroscraper fixing issues\n\
  - httpimport is still on 1.3.1 as 1.4.0 didn't work\n\
267.10 :\n\
- rework 267.09 fix for jakks only\n\
267.09 :\n\
- add fix for linking jakks roms\n\
  - it should not influence other things, hopefully\n\
267.08 :\n\
- add lines to skip clones when creating links (quicker)\n\
- only create a link when a main file is present\n\
- use hardlinks instead of softlinks\n\
- throughput the filter1 option\n\
- still an issue using the @no_media@ tag as filter (with jakks)\n\
267.07 :\n\
- being able to create links from files in ~/RetroPie/BIOS/mame\n\
  - links are saved in the roms folder you selected\n\
- fix showing correct arcade categories using @arcade@\n\
  - if a database doesn't have @arcade@ then use @working-arcade@\n\
267.06 :\n\
- fix showing and downloading cheats\n\
267.05 :\n\
- mame-merged and mame-sl are locked recently, hopefully temporarily\n\
  - marked both red !\n\
- replace default mame-merged with mame-0.264-roms-non-merged\n\
267.04 :\n\
- add m5 install line to the systems with extras\n\
  - help is added too !\n\
267.03 :\n\
- add sc3000 install line to the systems with extras\n\
  - help is added too !\n\
- re-alphabetize extras list\n\
267.02 :\n\
- add orion128 install lines to the systems with extras\n\
  - help is added too !\n\
267.01 :\n\
- add 'dpak' to the mediafilter to install psionlz drivers\n\
267.00 :\n\
- update to new database\n\
266.03 :\n\
- add 48k to Jupiter Ace (jupace) by default\n\
266.02 :\n\
- when done, skip extra runcommand installs from default\n\
266.01 :\n\
- apple2 : install extra 'autostart+joy' runcommand from default\n\
266.00 :\n\
- update to new database\n\
265.22 :\n\
- remove connection timeout\n\
- when connection fails try only 2 times\n\
265.21 :\n\
- direct and quick driver install\n\
- possibility to add extras when installing a driver from default\n\
  - extras added for ep128\n\
265.20 :\n\
- add philips cd-i line to restricted\n\
265.19 :\n\
- make update 265.18 working on RPI OS\n\
265.18 :\n\
- change showing message and form from automated category lists :\n\
  - change message not being able to alter variables\n\
  - only show them holding 'LeftShift' for a few seconds\n\
    (or tapping if holding doesn't work)
265.17 :\n\
- improve detecting Standalone MAME version\n\
265.16 :\n\
- detect Standalone MAME version and change database accordingly\n\
- show messages about a database VS MAME version mismatch\n\
- show message when Standalone MAME is not installed\n\
265.15 :\n\
- make all mame commands uniform using the emudir variable\n\
- update log notice when system variable is empty\n\
- add message about mismatch in versions : database VS MAME\n\
265.14 :\n\
- changed coleco_sgm into coleco_homebrew just like the softlist\n\
- reduced the code when changing the driver description\n\
265.13 :\n\
- add 'ssd' to the mediafilter to install psion drivers\n\
- add developper notice when system variable is empty\n\
265.12 :\n\
- getting database versions not online anymore :\n\
  - now making use of the range between 240 and the last version\n\
  - exclude a few versions from an array, which don't exist\n\
265.11 :\n\
- be able to install coleco/colecop with and without SGM :\n\
  - only works with database 0265 or higher\n\
  - when installing coleco/colecop a choice will be presented\n\
  - coleco/colecop with SGM is installed in coleco_sgm\n\
  - coleco/colecop without SGM is installed in coleco\n\
265.10 :\n\
- improvements in restricted downloads :\n\
  - improve output when downloading\n\
  - detect clones and save the associated rom as clonename\n\
  - remove the clone hacks from the manual download lines\n\
265.09 :\n\
- fix test mistake\n\
265.08 :\n\
- fix test mistake\n\
265.07 :\n\
- when using a regular pc then use an alternative shader for realistic\n\
265.06 :\n\
- fix permissions when multi download function is in use\n\
265.05 :\n\
- fix permissions issue for tigerrz folder\n\
265.04 :\n\
- add info in message about 'gccXX' as it means gcc version is unknown\n\
265.03 :\n\
- fix function subformgui_categories_automated_mamedev\n\
265.02 :\n\
- fix permissions issue for BIOS folder\n\
- replace html encoding only when needed to speed up normal stuff\n\
265.01 :\n\
- colecop : install sgm module by default (database 0265 or higher)\n\
265.00 :\n\
- update to new database\n\
264.05 :\n\
- being able to get all seperate files from a rompack in 1 go\n\
- being able to get all files from a rompack in 1 zip file\n\
- with above options : skip existing files (no sanity check !)\n\
- possible fix not showing databases when switching betwwen them\n\
- coleco : install sgm module by default (database 0265 or higher)\n\
264.04 :\n\
- fix permissions issue\n\
264.03 :\n\
- show and save single archive downloads without html url encoding\n\
- add more restricted downloads\n\
264.02 :\n\
- add restricted downloads for x68000\n\
264.01 :\n\
- after downloading, copy tgargnf.zip to tsuperman.zip (is a clone of)\n\
264.00 :\n\
- update to new database\n\
263.03 :\n\
- add p2000t to the restricted downloads\n\
- improve filtering out requested extention downloading from gitub\n\
- add wget to the depends for barebone linux OSes\n\
263.02 :\n\
- add maximum ram of 102K to p2000t and p2000m\n\
263.01 :\n\
- armbian : fix depends and add p7zip-full\n\
263.00 :\n\
- update to new database\n\
262.06 :\n\
- add yes/no messages to skip gx4000 things in restricted parts\n\
262.05 :\n\
- add unar to depedancies\n\
262.04 :\n\
- enable for more restricted sources (only with good validation)\n\
- add Converted_GX4000_Software rompack to the restricted sources\n\
262.03 :\n\
- use python virtual environment for retroscraper (newer OSes need it)\n\
262.02 :\n\
- full automatic category install                  ( >/= 0262 database )\n\
- full automatic category restricted roms download ( >/= 0262 database )\n\
262.01 :\n\
- fix adding predefined options installing a driver from DEFAULT\n\
- also fixes the c64gs install adding \"-joy2 joybstr\" from DEFAULT\n\
- add extra ram to FM-Towns drivers when installing from DEFAULT\n\
262.00 :\n\
- update to new database\n\
- remove predefined sorted list : forum category\n\
261.05 :\n\
- add download links of the realistic overlays packs, as comments\n\
- change the extended folder locations for handheld and p&p overlays :\n\
  roms/<system>/media/retroarch/overlays\n\
- download the cheats from the new https location\n\
- change and use posix instead of the cut command in many cases\n\
261.04 :\n\
- fix realistic overlay configs for new RetroArch, when installing\n\
261.03 :\n\
- be able to cancel downloading all gamelists + media, if needed\n\
261.02 :\n\
- fix dependency install for xattr\n\
261.01 :\n\
- redo for ArchyPie : fix permission issues with stickfreaks binaries\n\
261.00 :\n\
- update to new database\n\
260.22 :\n\
- fix permission issues with stickfreaks binaries\n\
260.21 :\n\
- create submenu for downloading gamelists\n\
260.20 :\n\
- remove stickfreaks binaries option\n\
- add re-packed stickfreaks binaries to gdrive\n\
- use new gdrive for all mame binaries\n\
- use the same 7zip structure for all mame binaries\n\
260.19 :\n\
- add yes/no messagebox function\n\
- fix reading from stickfreaks website for binaries\n\
- add message and choice about insecure usage stickfreaks site\n\
260.18 :\n\
- edit initial ArchyPie message with detected flags\n\
- enable updates from 260.17 for ArchyPie\n\
260.17 :\n\
- show a lr-mess binary list from gdrive and be able to install one\n\
- show a lr-mame binary list from gdrive and be able to install one\n\
- re-order items and improve messages\n\
260.16 :\n\
- add ArchyPie beta message as not all is working correctly\n\
- add message, RetroArch is not installed, when installing libretro cores\n\
260.15 :\n\
- ensure a system specific retroarch.cfg is created in ArchyPie\n\
260.14 :\n\
- get mame ui/artwork usable with low resolution drivers in lr-xxxx\n\
260.13 :\n\
- work in progress on autoboot install lines, not advised to use\n\
260.12 :\n\
- remove the update from 260.10 as it sadly doesn't work for lr-mess\n\
260.11 :\n\
- fix updating variables after installing run_mess.sh or runcommand.sh\n\
260.10 :\n\
- turn off first joystick for Zemmix MSX2 types cpc61 and cpg120\n\
260.09 :\n\
- install Zemmix MSX1 types as zemmix\n\
- install Zemmix MSX2 types as zemmix2\n\
260.08 :\n\
- be able to install the patched runcommand.sh for ArchyPie\n\
260.07 :\n\
- implement retroscraper option for ArchyPie\n\
- update python packages used for retroscraper\n\
260.06 :\n\
- turn off retroscraper option for ArchyPie\n\
260.05 :\n\
- change function configuring mame for working correctly\n\
260.04 :\n\
- adding stuff to runcommands that was forgotten in 260.03\n\
260.03 :\n\
- add early possibility to install default drivers with extra options\n\
- install default c64gs with different joystick in port 2\n\
- add configure mame function to get full support for ArchyPie\n\
260.02 :\n\
- install c64gs (game system) in c64gs, not in c64\n\
260.01 :\n\
- install scv_pal in scv\n\
260.00 :\n\
- add new database\n\
259.10 :\n\
- small echo fix\n\
259.09 :\n\
- suppress error when there is no runcommand.log\n\
- fix showing correct paths when using ArchyPie\n\
- fix organising realistic overlays when using on ArchyPie\n\
259.08 :\n\
- egrep is obsolescent, using 'grep -E' now\n\
259.07 :\n\
- on ArchyPie use archypie_packages.sh instead of retropie_packages.sh\n\
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
- return to $(echo $romdir|cut -d/ -f4)-Setup after updating the script \n\
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
    if [[ -f $emudir/mame/mame ]];then
		if [[ ${rp_module_version_database} != ${rp_module_version_mame} ]];then
			if [[ " ${rp_module_database_versions[*]} " =~ " ${rp_module_version_mame} " ]];then
				show_message_mamedev "Your standalone MAME version is different than the used MAME database !\nYour standalone MAME version is ${rp_module_version_mame}.\nDatabase version ${rp_module_version_mame} is available and will be set to that version.\n"
				rp_module_version_database=${rp_module_version_mame}
			else
				show_message_mamedev "Your standalone MAME version is different than the used MAME database !\nStandalone MAME is used by this script when installing a driver.\nA mismatch can mean that a driver cannot be installed, for example.\nMake sure you switch to the correct database.\nYour standalone MAME version is ${rp_module_version_mame}.\nSeems your version doesn't have a compatible database.\nCheck if a close database version is available.\nOr just update Standalone MAME to a newer/correct version, if possible.\n\nA list will now be shown so you can pick the closest database.\n\nIt's possible to manually change the database later with selecting :\n►Switch to another mame database version\n"
				subgui_databases_mamedev
			fi
		fi
	else
		show_message_mamedev "You haven't installed Stanalone MAME yet !\nMake sure you install Standalone MAME.\nThe script will extract data from Standalone MAME to function correctly.\n"
	fi
}


function gui_mamedev() {
    #special charachters ■□▪▫▬▲►▼◄◊○◌●☺☻←↑→↓↔↕⇔
    local csv=()
    csv=(
",menu_item,,to_do,,,,,help_to_do,"
",About this script,,show_message_mamedev \"This project makes use of MAME/lr-mame/lr-mess for emulating.\nThey support a lot of devices to be emulated.\nEmulating many of the desired devices was quite difficult.\nSome people made module-scripts to emulate these devices.\nThe making of such a module-script is a very time consuming.\nThis project makes use of our own enhance data and MAME data.\nThis data is then used to install drivers on the fly.\n---This script combines the work and ideas of many people :---\n- Folly : creating this script\n- Valerino : creating the run_mess.sh script\n- RussellB : improved the run_mess.sh script\n- DTEAM : basic structure for handheld and P&P\n- DTEAM : artwork and gamelists on google-drive\n- Matt Huisman : google-drive downloader\n- Dmmarti : google-sheet with info about systems\n- JimmyFromTheBay : testing\n- Jamrom2 : testing\n- bbilford83 : joystick configs and summaries and gamelists\n- Orionsangel : creating realistic arcade overlays\n- stickfreaks : hosting mame binaries\n- mamecheats : hosting cheatfiles\",,,,,show_message_mamedev \"NO HELP\","
",Update mamedev script and database,,wget -O $(if [[ -f $scriptdir/ext/RetroPie-Share/scriptmodules/supplementary/mamedev.sh ]]; then echo $scriptdir/ext/RetroPie-Share/scriptmodules/supplementary/mamedev.sh;else echo $scriptdir/scriptmodules/supplementary/mamedev.sh;fi) https://raw.githubusercontent.com/FollyMaddy/RetroPie-Share/main/00-scriptmodules-00/supplementary/mamedev.sh;chown $user:$user $(if [[ -f $scriptdir/ext/RetroPie-Share/scriptmodules/supplementary/mamedev.sh ]]; then echo $scriptdir/ext/RetroPie-Share/scriptmodules/supplementary/mamedev.sh;else echo $scriptdir/scriptmodules/supplementary/mamedev.sh;fi);xattr -d user.comment $(if [[ -f $scriptdir/ext/RetroPie-Share/scriptmodules/supplementary/mamedev.sh ]];then echo $scriptdir/ext/RetroPie-Share/scriptmodules/supplementary/mamedev.sh;else echo $scriptdir/scriptmodules/supplementary/mamedev.sh;fi);curl https://raw.githubusercontent.com/FollyMaddy/RetroPie-Share/main/00-databases-00/mame/mame${rp_module_database_versions[1]}_systems_sorted_info -o $emudir/mame/mame${rp_module_database_versions[1]}_systems_sorted_info;rp_registerAllModules;show_message_mamedev \"\n\n\n\n\n\n\n\n----------The script has been updated !-----------\n-----Going back into the $(echo $romdir|cut -d/ -f4)-Setup menu.-----\";break,,,,,," 
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
",►ADDONS / EXTRAS / CONFIGS,,show_message_mamedev \"The options in the next submenu are for downloading files and they will overwrite files with the same name. So be careful with them.\nThe possible options use these directories :\n- $rootdir/configs/all/emulationstation\n- $rootdir/configs/all/retroarch/overlay\n- $rootdir/configs/all/retroarch-joypads\n- $configdir/mame/mame.ini\n- $rootdir/supplementary/runcommand\n- $datadir/BIOS/mame/cheat\n- $datadir/roms/mame/cheat\n- $datadir/roms/mame/artwork\n- $datadir/roms/<system>\n- $scriptdir/scriptmodules\n\nIf you have important files then do a BACKUP first !!!\n\nPress Cancel in the next subgui to go back into the menu.\";subgui_addons_mamedev ,,,,,show_message_mamedev \"Get online files.\n\n- download retroarch joypad autoconfigs\n- download cheats\n- download ES gamelists + media\n- download artwork\n- browse and download artwork per system\n- create background overlays from artwork\n- create background overlay config files\n- download realistic bezels\n- create bezel overlay files\","
",,,,,,,,,"
",►Link roms from folder ~/RetroPie/BIOS/mame,,show_message_mamedev \"Warning : files or links are forced overwritten\";subgui_link_roms_mamedev,,,,,show_message_mamedev \"Show categories and ultimately create hardlinks from files that are in ~/RetroPie/BIOS/mame.\nMake sure you have downloaded the whole set of roms and placed it in ~/RetroPie/BIOS/mame.\nFor example: get the mame-merged set and place all the files in in ~/RetroPie/BIOS/mame\nBy doing this you will also ensure that all the bios roms are in the correct directory so there will be no need to place bios files inside that folder again.\","
   )
sleep 0.1
[[ $(timeout 1 $([[ $scriptdir == *ArchyPie* ]] && echo tiny)xxd -a -c 1 $(ls /dev/input/by-path/*kbd|head -n 1)|grep ": 2a") == *2a* ]] &&\
csv+=(
",►Browser/downloader ( restricted ),,subgui_archive_downloads_mamedev,,,,,show_message_mamedev \"Browse and get online files.\n(only available with the correct input)\","
",►Install UV,,install_uv_mamedev,,,,,show_message_mamedev \"Install UV and use older python versions and get python modules easier and faster\","
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
    [[ $1 == clear ]] && clear
    echo "Database version mame${rp_module_version_database}_systems_sorted_info is used"
    #make sure there is a database
    [[ ! -d $emudir/mame ]] && mkdir -p $emudir/mame
    [[ ! -f $emudir/mame/mame${rp_module_version_database}_systems_sorted_info ]] && curl -s https://raw.githubusercontent.com/FollyMaddy/RetroPie-Share/main/00-databases-00/mame/mame${rp_module_version_database}_systems_sorted_info -o $emudir/mame/mame${rp_module_version_database}_systems_sorted_info
    #here we read the systems and descriptions from mame into an array
    #by using next if function the data can be re-used, without reading it every time
    if [[ -z ${mamedev_csv[@]} ]]; then
        if [[ -f $emudir/mame/mame${rp_module_version_database}_systems_sorted_info ]]; then 
	echo "Get mame${rp_module_version_database} data:$emudir/mame/mame${rp_module_version_database}_systems_sorted_info"
	echo "For speed, data will be re-used within this session if possible"
	echo "Be patient for 20 seconds" 
	#here we use sed to convert the line to csv : the special charachter ) has to be single quoted and backslashed '\)'
	#we need to add 'echo \",,,,\";', because otherwise the first value isn't displayed as it is reserved for the column descriptions
	#at the end it removes the last char, this is the @ char and not the newline as expected so we need to add the @ again
	#/r or /n did not do the job properly so it's replaced by .$ and adding the @ again
	while read system_read;do mamedev_csv+=("$system_read");done < <(echo \",,,,\";cat $emudir/mame/mame${rp_module_version_database}_systems_sorted_info|sed 's/,//g;s/Driver /\",/g;s/ ./,/;s/'\)':/,install_system_mamedev,/;s/.$/@,,,\"/')
        fi
    fi
}


function subgui_categories_mamedev() {
    local csv=()
    csv=(
",menu_item_handheld_description,SystemType,to_do driver_used_for_installation,,,,,help_to_do,"
    )
    [[ $(expr $rp_module_version_database + 0) -gt 261 ]] && \
    csv+=(
",\Zr▼ NEW : Fully automated,,,,,,,,"
",►Show all non-arcade categories from database and install one,,subformgui_categories_automated_mamedev \"show list to install category\" @non-arcade \"/@non-arcade@/ && /@no_media@/\" \"! /90º|bios|computer|good|new0*|media|non-arcade/\" \"no\",,,,,,"
",►Show all arcade     categories from database and install one,,subformgui_categories_automated_mamedev \"show list to install category\" @arcade \"!/@mechanical@/ && /@arcade@/\" \"! /90º|bios|computer|good|new0*|@ma@|media|oro|working_arcade/\" \"no\",,,,,,"
",►Show all arcade 90º categories from database and install one,,subformgui_categories_automated_mamedev \"show list to install category\" @arcade \"!/@mechanical@/ && /@arcade@/ && /@90º@/\" \"! /90º|bios|computer|good|new0*|@ma@|media|oro|working_arcade/\" \"no\",,,,,,"
",\Zr▲,,,,,,,,"
",,,,,,,,,"
    )
    csv+=(
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
",Arcade Category => sports,@arcade,create_00index_file_mamedev '/@sports/&&/@working_arcade/' $datadir/roms/sports;install_system_mamedev sports sports '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the sports category.\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n\nThe created index file contains the list of games.\n\n\Z2This category is implemented as recognisable category when istalling a default system.\","
#",Arcade Category => upright,@arcade,create_00index_file_mamedev '/@upright/&&/@working_arcade/' $datadir/roms/upright;install_system_mamedev upright upright '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the upright category.\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n\nThe created index file contains the list of games.\n\n\Z1This category is NOT implemented as recognisable category when istalling a default system !\","
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
",Arcade Category => sports90º,@arcade,create_00index_file_mamedev '/@sports/&&/@90º/&&/@working_arcade/' $datadir/roms/sports90º;install_system_mamedev sports90º sports90º '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the sports90º category.\nWhen running roms from this directory it will rotate the game 90ºCW.\nSo use a monitor that you can turn !\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n- add screenrotation in $rootdir/configs/sports90º/retroarch.cfg.basename\n\nThe created index file contains the list of games.\n\n\Z1This category is NOT implemented as recognisable category when istalling a default system !\","
#",Arcade Category => upright90º,@arcade,create_00index_file_mamedev '/@upright/&&/@90º/&&/@working_arcade/' $datadir/roms/upright90º;install_system_mamedev upright90º upright90º '' '' 'none' '',,,,,show_message_mamedev \"This help page gives more info on force installing the upright90º category.\nWhen running roms from this directory it will rotate the game 90ºCW.\nSo use a monitor that you can turn !\n\nIt will :\n- create the rom folder\n- associate the mame and lr-mame loaders for this folder or category\n- create a rom index file (0 rom-index 0) inside the specific rom folder\n- add screenrotation in $rootdir/configs/upright90º/retroarch.cfg.basename\n\nThe created index file contains the list of games.\n\n\Z1This category is NOT implemented as recognisable category when istalling a default system !\","
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
	)
sleep 0.1
[[ $(timeout 1 $([[ $scriptdir == *ArchyPie* ]] && echo tiny)xxd -a -c 1 $(ls /dev/input/by-path/*kbd|head -n 1)|grep ": 2a") == *2a* ]] &&\
	csv+=(
",▼\ZrBe warned : not always working correctly and need to be checked !,,,"
",\Z1►Systems   : full/semi automatic boot (with/without extra options),,subgui_systems_extras_add_autoboot_mamedev descriptions,,,,,show_message_mamedev \"Experimental : install systems with autoboot function\n\nWARNING:\nSystems with extra hardware can have extra supported file extensions.\nTo keep the supported file extensions always do the extra install after a default install otherwise specific supported file extensions are wiped from the /etc/emulationstation/es_systems.cfg\","
    )
    build_menu_mamedev
}


function subgui_configs_settings_mamedev() {
    [[ $1 != refresh ]] && local csv=()
    csv=(
",menu_item,,to_do,,,,,help_to_do,"
",▼\ZrChange mame standalone config (mame.ini)\ZR,,,"
",,,,,,,,,"
    )
	if [[ $(grep -i "^cheat " "$configdir/mame/mame.ini") == "cheat 1" ]];then
		csv+=(
",disable cheats			\Z4(custom  : enabled now),,iniConfig \" \" \"\" \"$configdir/mame/mame.ini\";iniDel \"cheatpath\"  \"\";iniSet \"cheat\" \"0\";chown $user:$user \"$configdir/mame/mame.ini\";#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"This will disable cheats and remove the cheatspath setting.\","
		)
	else
		csv+=(
",enable  cheats			\Z2(default : disabled now),,iniConfig \" \" \"\" \"$configdir/mame/mame.ini\";iniSet \"cheatpath\"  \"$romdir/mame/cheat\";iniSet \"cheat\" \"1\";chown $user:$user \"$configdir/mame/mame.ini\";#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"This will enable cheats and add the cheatpath.\n\nCheats need to be in :\n$romdir/mame/cheat\n\nPS.:\nThere is an option in the script to download and enable the cheats.\nWhat you can do here is partly to get an idea of the overal settings and to manually disable it if needed.\","
		)
	fi
	
	if [[ $(grep -i "^keepaspect" "$configdir/mame/mame.ini") == "keepaspect 0" ]];then
		csv+=(
",enable  aspect ratio		\Z5(custom  : disabled now),,iniConfig \" \" \"\" \"$configdir/mame/mame.ini\";iniSet \"keepaspect\" \"1\";chown $user:$user \"$configdir/mame/mame.ini\";#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"This will keep the original aspect ratio.\","
		)
	else
		csv+=(
",disable aspect ratio		\Z2(default : enabled now),,iniConfig \" \" \"\" \"$configdir/mame/mame.ini\";iniSet \"keepaspect\" \"0\";chown $user:$user \"$configdir/mame/mame.ini\";#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"This will not keep the original aspect ratio.\","
		)
	fi
	
	if [[ $(grep -i "^mouse" "$configdir/mame/mame.ini") == "mouse 1" ]];then
		csv+=(
",disable mouse/multimouse		\Z4(custom  : enabled now),,iniConfig \" \" \"\" \"$configdir/mame/mame.ini\";iniSet \"mouse\" \"0\";iniSet \"multimouse\" \"0\";chown $user:$user \"$configdir/mame/mame.ini\";#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"This will disable mouse and multimouse support.\","
		)
	else
		csv+=(
",enable  mouse/multimouse		\Z2(default : disabled now),,iniConfig \" \" \"\" \"$configdir/mame/mame.ini\";iniSet \"mouse\" \"1\";iniSet \"multimouse\" \"1\";chown $user:$user \"$configdir/mame/mame.ini\";#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"This will enable mouse and multimouse support.\","
		)
	fi
	
	if [[ $(grep -i "^syncrefresh" "$configdir/mame/mame.ini") == "syncrefresh 1" ]];then
		csv+=(
",disable syncrefresh			\Z4(custom  : enabled now),,iniConfig \" \" \"\" \"$configdir/mame/mame.ini\";iniSet \"syncrefresh\" \"0\";chown $user:$user \"$configdir/mame/mame.ini\";#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"Use the video refreshrate of your loaded systemdriver.\","
		)
	else
		csv+=(
",enable  syncrefresh			\Z2(default : disabled now),,iniConfig \" \" \"\" \"$configdir/mame/mame.ini\";iniSet \"syncrefresh\" \"1\";chown $user:$user \"$configdir/mame/mame.ini\";#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"Use the video refreshrate of your monitor.\nThis means that the refreshrate of the loaded systemdriver is ignored. However...\nthe sound code still attempts to keep up with the system's original refresh rate. So you may encounter sound problems.\n\nThis option is intended mainly for those who have tweaked their video card's settings to provide carefully matched refresh rate options.\nNote that this option does not work with -video gdi mode.\","
		)
	fi
	
	csv+=(
	",,,,,,,,,"
		)
		
	if [[ $(grep -i "^video accel" "$configdir/mame/mame.ini") == "video accel" ]];then
		csv+=(
",disable default video acceleration	\Z2(default : enabled now),,iniConfig \" \" \"\" \"$configdir/mame/mame.ini\";iniDel \"video\";chown $user:$user \"$configdir/mame/mame.ini\";#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"Disable video rendering using SDL’s 2D acceleration.\","
		)
	else
		csv+=(
",enable  default video acceleration	\Z5(custom  : disabled now),,iniConfig \" \" \"\" \"$configdir/mame/mame.ini\";iniSet \"video\" \"accel\";chown $user:$user \"$configdir/mame/mame.ini\";#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"Enable video rendering using SDL’s 2D acceleration if possible.\","
		)
	fi

	if [[ $(grep -i "^video opengl" "$configdir/mame/mame.ini") == "video opengl" ]];then
		csv+=(
",disable opengl video acceleration	\Z4(custom  : enabled now),,iniConfig \" \" \"\" \"$configdir/mame/mame.ini\";iniDel \"video\";chown $user:$user \"$configdir/mame/mame.ini\";#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"Disable video rendering using OpenGL acceleration.\","
		)
	else
		csv+=(
",enable  opengl video acceleration	\Z5(custom  : disabled now),,iniConfig \" \" \"\" \"$configdir/mame/mame.ini\";iniSet \"video\" \"opengl\";chown $user:$user \"$configdir/mame/mame.ini\";#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"Enable video rendering using OpenGL acceleration.\","
		)
	fi
	
	if [[ $(grep -i "^video bgfx" "$configdir/mame/mame.ini") == "video bgfx" ]];then
		csv+=(
",disable new bgfx video acceleration	\Z4(custom  : enabled now),,iniConfig \" \" \"\" \"$configdir/mame/mame.ini\";iniDel \"video\";chown $user:$user \"$configdir/mame/mame.ini\";#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"Disable the new hardware accelerated renderer.\","
		)
	else
		csv+=(
",enable  new bgfx video acceleration	\Z5(custom  : disabled now),,iniConfig \" \" \"\" \"$configdir/mame/mame.ini\";iniSet \"video\" \"bgfx\";chown $user:$user \"$configdir/mame/mame.ini\";#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"Enable the new hardware accelerated renderer.\","
		)
	fi
	
	csv+=(
	",,,,,,,,,"
		)
		
	if [[ $(grep -i "^samplerate 11025" "$configdir/mame/mame.ini") != "samplerate 11025" ]];then
		csv+=(
",set samplerate to 11025Hz		\Z1(default : disabled now),,iniConfig \" \" \"\" \"$configdir/mame/mame.ini\";iniSet \"samplerate\" \"11025\";chown $user:$user \"$configdir/mame/mame.ini\";#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"Set samplerate to 11025Hz.\","
		)
	else
		csv+=(
",samplerate is set to 11025Hz	\Z4(custom  : enabled now),,#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"Samplerate is set to 11025Hz.\","
		)
	fi

	if [[ $(grep -i "^samplerate 22050" "$configdir/mame/mame.ini") != "samplerate 22050" ]];then
		csv+=(
",set samplerate to 22050Hz		\Z1(default : disabled now),,iniConfig \" \" \"\" \"$configdir/mame/mame.ini\";iniSet \"samplerate\" \"22050\";chown $user:$user \"$configdir/mame/mame.ini\";#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"Set samplerate to 22050Hz.\","
		)
	else
		csv+=(
",samplerate is set to 22050Hz	\Z4(custom  : enabled now),,#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"Samplerate is set to 22050Hz.\","
		)
	fi
	
	if [[ $(grep -i "^samplerate 44100" "$configdir/mame/mame.ini") != "samplerate 44100" ]];then
		csv+=(
",set samplerate to 44100Hz		\Z1(default : disabled now),,iniConfig \" \" \"\" \"$configdir/mame/mame.ini\";iniSet \"samplerate\" \"44100\";chown $user:$user \"$configdir/mame/mame.ini\";#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"Set samplerate to 44100Hz.\","
		)
	else
		csv+=(
",samplerate is set to 44100Hz	\Z4(custom  : enabled now),,#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"Samplerate is set to 44100Hz.\","
		)
	fi
	
	if [[ $(grep -i "^samplerate 48000" "$configdir/mame/mame.ini") != "samplerate 48000" ]];then
		csv+=(
",set samplerate to 48000Hz = default	\Z5(custom  : disabled now),,iniConfig \" \" \"\" \"$configdir/mame/mame.ini\";iniSet \"samplerate\" \"48000\";chown $user:$user \"$configdir/mame/mame.ini\";#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"Set samplerate to 48000Hz.\","
		)
	else
		csv+=(
",samplerate is set to 48000Hz	\Z2(default : enabled now),,#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"Samplerate is set to 48000Hz.\","
		)
	fi

	csv+=(
",🎮,,,,,,,,"
",▼\ZrAlternative test look\ZR,,,,,,,,"
",,,,,,,,,"
		)

	if [[ $(grep -i "^cheat " "$configdir/mame/mame.ini") == "cheat 1" ]];then
		csv+=(
",[O|\ZrI\ZR] cheats			\Z4(custom  : enabled now),,iniConfig \" \" \"\" \"$configdir/mame/mame.ini\";iniDel \"cheatpath\"  \"\";iniSet \"cheat\" \"0\";chown $user:$user \"$configdir/mame/mame.ini\";#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"This will disable cheats and remove the cheatspath setting.\","
		)
	else
		csv+=(
",[\ZrO\ZR|I] cheats			\Z2(default : disabled now),,iniConfig \" \" \"\" \"$configdir/mame/mame.ini\";iniSet \"cheatpath\"  \"$romdir/mame/cheat\";iniSet \"cheat\" \"1\";chown $user:$user \"$configdir/mame/mame.ini\";#refresh,subgui_configs_settings_mamedev,,,,show_message_mamedev \"This will enable cheats and add the cheatpath.\n\nCheats need to be in :\n$romdir/mame/cheat\n\nPS.:\nThere is an option in the script to download and enable the cheats.\nWhat you can do here is partly to get an idea of the overal settings and to manually disable it if needed.\","
		)
	fi
	
    [[ $1 != refresh ]] && build_menu_mamedev
}

function subgui_gamelists_mamedev() {
    local csv=()
    csv=(
",menu_item,,to_do,,,,,help_to_do,"

",▼\ZrGamelists hosted by @DTEAM (Default)\ZR,,,"
",►Download/update gamelists with media per system,,subgui_download_gamelists_mamedev 1f_jXMG0XMBdyOOBpz8CHM6AFj9vC1R6m,,,,,show_message_mamedev \"Here you will find predefined gamelists with videos and pictures. These are created to have a good preview in emulationstation of the games you can select. In contrary to where the gamelists are normally stored these gamelists are stored in :\n~$datadir/roms/<system>\nThis makes it easier to backup the gamelists together with your roms and it prevents from overwriting gamelist files in other locations.\n\nWhen selecting this option you can choose to download the gamelists seperately.\","
",Download/update all ES gamelists with media (+/-30 min.),,show_message_yesno_mamedev \"Would you like to proceed ?\" \"download_from_google_drive_mamedev 1f_jXMG0XMBdyOOBpz8CHM6AFj9vC1R6m $datadir/roms\",,,,,show_message_mamedev \"Here you will find predefined gamelists with videos and pictures. These are created to have a good preview in emulationstation of the games you can select. In contrary to where the gamelists are normally stored these gamelists are stored in :\n~$datadir/roms/<system>\nThis makes it easier to backup the gamelists together with your roms and it prevents from overwriting gamelist files in other locations.\n\nWhen selecting this option all available gamelists with media are downloaded.\","
",,,,,,,,,"
",▼\ZrGamelists hosted by @Folly (old backup + some extras)\ZR,,,"
",►Download/update gamelists with media per system,,subgui_download_gamelists_mamedev 1ij7zF4DE__81EHm7aX2puzTElhRYULkz,,,,,show_message_mamedev \"Here you will find predefined gamelists with videos and pictures. These are created to have a good preview in emulationstation of the games you can select. In contrary to where the gamelists are normally stored these gamelists are stored in :\n~$datadir/roms/<system>\nThis makes it easier to backup the gamelists together with your roms and it prevents from overwriting gamelist files in other locations.\n\nWhen selecting this option you can choose to download the gamelists seperately.\","
",Download/update all ES gamelists with media (+/-30 min.),,show_message_yesno_mamedev \"Would you like to proceed ?\" \"download_from_google_drive_mamedev 1ij7zF4DE__81EHm7aX2puzTElhRYULkz $datadir/roms\",,,,,show_message_mamedev \"Here you will find predefined gamelists with videos and pictures. These are created to have a good preview in emulationstation of the games you can select. In contrary to where the gamelists are normally stored these gamelists are stored in :\n~$datadir/roms/<system>\nThis makes it easier to backup the gamelists together with your roms and it prevents from overwriting gamelist files in other locations.\n\nWhen selecting this option all available gamelists with media are downloaded.\","
",,,,,,,,,"
",▼\ZrGamelists hosted by @bbilford83 (work in progress stuff)\ZR,,,"
",►Download/update gamelists with media per system,,subgui_download_gamelists_mamedev 19h16tSYtksWU1EfC92KxJBi-8zYTYkYr,,,,,show_message_mamedev \"Here you will find predefined gamelists with videos and pictures. These are created to have a good preview in emulationstation of the games you can select. In contrary to where the gamelists are normally stored these gamelists are stored in :\n~$datadir/roms/<system>\nThis makes it easier to backup the gamelists together with your roms and it prevents from overwriting gamelist files in other locations.\n\nWhen selecting this option you can choose to download the gamelists seperately.\","
",Download/update all ES gamelists with media (+/-30 min.),,show_message_yesno_mamedev \"Would you like to proceed ?\" \"download_from_google_drive_mamedev 19h16tSYtksWU1EfC92KxJBi-8zYTYkYr $datadir/roms\",,,,,show_message_mamedev \"Here you will find predefined gamelists with videos and pictures. These are created to have a good preview in emulationstation of the games you can select. In contrary to where the gamelists are normally stored these gamelists are stored in :\n~$datadir/roms/<system>\nThis makes it easier to backup the gamelists together with your roms and it prevents from overwriting gamelist files in other locations.\n\nWhen selecting this option all available gamelists with media are downloaded.\","
",,,,,,,,,"
",▼\ZrExperimental (has issue : no images downloaded)\ZR,,,"
",▼\ZrUse RetroScraper-remote by @kiro\ZR,,,"
",►Retroscrape/update gamelists with media per system,,subgui_retroscraper_gamelists_mamedev,,,,,show_message_mamedev \"Here you will be able to retroscrape roms creating gamelists with videos and pictures depending on the database of retroscraper.\nThe gamelists are stored in :\n~$datadir/roms/<system>\nThis makes it easier to backup the gamelists together with your roms and it prevents from overwriting gamelist files in other locations.\nExisting gamelist files and media are removed before a new retroscrape !\n\nWhen selecting this option you can choose to retroscrape a system folder seperately.\","

    )
    build_menu_mamedev
}



function subgui_gdrive_binaries_mamedev() {
	#$1=mame/lr-mess/lr-mame $2=destination-path $3=gdrive-folder-id
	show_message_mamedev "\
A list of $1 binaries will be presented, selecting one will :\n\
- remove your current $1, if installed\n\
- download the selected $1 in /tmp/\n\
- extract it to $2/$1\n\
- install dependancies for $1\n\
- configure $1\n\
Make sure you pick the correct arch :\n\
- \"armhf\" is for rpi's with armhf, armv7l or aarch64 cpu using 32 bit OS\n\
- \"armv7l\" is for rpi's with armv7l or aarch64 cpu using 32 bit OS\n\
- \"aarch64\" is for aarch64 cpu using 64 bit OS\n\
- \"x86\" is for x86, x86_64 cpu using 32 bit OS\n\
- \"x86_64\" is for x86_64 cpu using 64 bit OS\n\
Make sure you use the correct OS version :\n\
- gcc8 should work on Debian10/Buster & Debian11/Bullseye derivatives\n\
- gcc9 should work on Debian10/Buster & Debian11/Bullseye derivatives\n\
- gcc10 should work on Debian11/Bullseye & Debian12/Bookworm derivatives\n\
- gcc10 should work on latest Arch linux derivatives, for ArchyPie\n\
- gcc12 should work on Debian12/Bookworm derivatives\n\
- gcc14 should work on Debian13/Trixie derivatives\n\
- gcc14 probably works on latest Arch linux derivatives, for ArchyPie\n\
- if gcc14 version is not working then try a gcc12 version\n\
- if gcc12 version is not working then try a gcc10 version\n\
- gccXX means the gcc version is unknown\n\
- gccXX most likely will work on the latest OSes\n\
- gccXX could work on older OSes, just try and see if it works\n\
"
    local csv=()
    #the first value is reserved for the column descriptions
    csv=( ",,,," )
    local gdrive_read
    clear
    echo "reading the available binaries"
    while read gdrive_read;do csv+=("$gdrive_read");done < <(IFS=$'\n'; curl https://drive.google.com/embeddedfolderview?id=$3#list|sed 's/https/\nhttps/g;s/>/\//g;s/</\//g;s/\nhttps:\/\/drive-/https:\/\/drive-/g'|grep file|tac|while read line;do echo "\",$(echo $line|cut -d/ -f48),,install_binary_from_gdrive_mamedev $1 $2 $(echo $line|cut -d/ -f48) $(echo $line|cut -d/ -f6),\"";done)
    build_menu_mamedev
}


function subgui_stickfreaks_binaries_mamedev() {
	show_message_mamedev "\
A list of mame binaries will be presented, selecting one will :\n\
- remove your current mame, if installed\n\
- download the selected mame in $emudir/mame\n\
- extract it to $emudir/mame\n\
- install dependancies for mame\n\
- configure mame\n\
Make sure you pick the correct arch :\n\
- \"rpi2b\" is not an arch but is for rpi2b using 32 bit OS\n\
- \"armhf\" is for rpi's with armhf, armv7l or aarch64 cpu using 32 bit OS\n\
- \"arm64\" is used as a synonym for aarch64 cpu using 64 bit OS\n\
- \"aarch64\" is for aarch64 cpu using 64 bit OS\n\
Make sure you use the correct OS version :\n\
- gcc8 should work on Debian10/Buster & Debian11/Bullseye derivatives\n\
- gcc9 should work on Debian10/Buster & Debian11/Bullseye derivatives\n\
- gcc10 should work on Debian11/Bullseye & Debian12/Bookworm derivatives\n\
- gcc12 should work on Debian12/Bookworm derivatives\n\
- gcc14 should work on Debian13/Trixie derivatives\n\
"
    local csv=()
    #the first value is reserved for the column descriptions
    csv=( ",,,," )
    local stickfreaks_read
    clear
    echo "reading the available binaries"
    while read stickfreaks_read;do csv+=("$stickfreaks_read");done < <(IFS=$'\n'; curl $1 https://stickfreaks.com/mame/|grep \"mame_.*7z|cut -d '"' -f2|sort -r|while read line;do echo "\",$line,,install_mame_from_stickfreaks_mamedev $line,\"";done)
    while read stickfreaks_read;do csv+=("$stickfreaks_read");done < <(IFS=$'\n'; curl $1 https://stickfreaks.com/mame/old/|grep \"mame_.*7z|cut -d '"' -f2|sort -r|while read line;do echo "\",$line,,install_mame_from_stickfreaks_mamedev $line old/,\"";done)
    build_menu_mamedev
}


function subgui_systems_default_mamedev() {
    local csv=()
    csv=(
",menu_item,,to_do,,,,,help_to_do,"
",►System names : SEARCH and display list,,subgui_search_mamedev systems,,,,,show_message_mamedev \"Search and create a list and then install one or more systems with default options\","
",►System name  : DIRECT and quick driver install,,direct_install_mamedev,,,,,show_message_mamedev \"Insert a correct driver name and install that driver directly without showing a list first.\","
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


function subgui_link_roms_mamedev() {
#we can add up to 5 options per list to sort on
    local csv=()
    csv=(
",menu_item,,to_do,"
",\Zr▼Link files : Fully automated with clones (do all but a bit slower),,,,,,,,"
",►Show all non-arcade categories from database and link .zip roms,,subformgui_categories_automated_mamedev \"show list to link category roms\" @non-arcade \"/@non-arcade@/ && /@no_media@/\" \"! /90º|bios|computer|good|new0*|no_media|working_arcade/\" \"yes\" \".zip\",,,,,,"
",►Show all arcade     categories from database and link .zip roms,,subformgui_categories_automated_mamedev \"show list to link category roms\" @arcade \"!/@mechanical@/ && /@arcade@/\" \"! /90º|bios|computer|good|new0*|@ma@|oro|working_arcade/\" \"yes\" \".zip\",,,,,,"
",►Show all arcade 90º categories from database and link .zip roms,,subformgui_categories_automated_mamedev \"show list to link category roms\" @arcade \"!/@mechanical@/ && /@arcade@/ && /@90º@/\" \"! /90º|bios|computer|good|new0*|@ma@|oro|working_arcade/\" \"yes\" \".zip\",,,,,,"
",►Show all non-arcade categories from database and link .7z roms,,subformgui_categories_automated_mamedev \"show list to link category roms\" @non-arcade \"/@non-arcade@/ && /@no_media@/\" \"! /90º|bios|computer|good|new0*|no_media|working_arcade/\" \"yes\" \".7z\",,,,,,"
",►Show all arcade     categories from database and link .7z roms,,subformgui_categories_automated_mamedev \"show list to link category roms\" @arcade \"!/@mechanical@/ && /@arcade@/\" \"! /90º|bios|computer|good|new0*|@ma@|oro|working_arcade/\" \"yes\" \".7z\",,,,,,"
",►Show all arcade 90º categories from database and link .7z roms,,subformgui_categories_automated_mamedev \"show list to link category roms\" @arcade \"!/@mechanical@/ && /@arcade@/ && /@90º@/\" \"! /90º|bios|computer|good|new0*|@ma@|oro|working_arcade/\" \"yes\" \".7z\",,,,,,"
",\Zr▼Link files : Fully automated without clones (quicker),,,,,,,,"
",►Show all non-arcade categories from database and link .zip roms,,subformgui_categories_automated_mamedev \"show list to link category roms\" @non-arcade \"!/@clones@/ && /@non-arcade@/ && /@no_media@/\" \"! /90º|bios|computer|good|new0*|no_media|working_arcade/\" \"no\" \".zip\",,,,,,"
",►Show all arcade     categories from database and link .zip roms,,subformgui_categories_automated_mamedev \"show list to link category roms\" @arcade \"!/@clones@/ && !/@mechanical@/ && /@arcade@/\" \"! /90º|bios|computer|good|new0*|@ma@|oro|working_arcade/\" \"no\" \".zip\",,,,,,"
",►Show all arcade 90º categories from database and link .zip roms,,subformgui_categories_automated_mamedev \"show list to link category roms\" @arcade \"!/@clones@/ && !/@mechanical@/ && /@arcade@/ && /@90º@/\" \"! /90º|bios|computer|good|new0*|@ma@|oro|working_arcade/\" \"no\" \".zip\",,,,,,"
",►Show all non-arcade categories from database and link .7z roms,,subformgui_categories_automated_mamedev \"show list to link category roms\" @non-arcade \"!/@clones@/ && /@non-arcade@/ && /@no_media@/\" \"! /90º|bios|computer|good|new0*|no_media|working_arcade/\" \"no\" \".7z\",,,,,,"
",►Show all arcade     categories from database and link .7z roms,,subformgui_categories_automated_mamedev \"show list to link category roms\" @arcade \"!/@clones@/ && !/@mechanical@/ && /@arcade@/\" \"! /90º|bios|computer|good|new0*|@ma@|oro|working_arcade/\" \"no\" \".7z\",,,,,,"
",►Show all arcade 90º categories from database and link .7z roms,,subformgui_categories_automated_mamedev \"show list to link category roms\" @arcade \"!/@clones@/ && !/@mechanical@/ && /@arcade@/ && /@90º@/\" \"! /90º|bios|computer|good|new0*|@ma@|oro|working_arcade/\" \"no\" \".7z\",,,,,,"
    )
    build_menu_mamedev
}


function subgui_lists_mamedev() {
#we can add up to 5 options per list to sort on
    local csv=()
    csv=(
",menu_item,,to_do,"
",Non-arcade upon descriptions,,create_systems_list_mamedev descriptions @non-arcade,"
",Non-arcade upon system names,,create_systems_list_mamedev systems @non-arcade,"
",,,,"
",Game consoles upon descriptions,,create_systems_list_mamedev descriptions @game_console,"
",Game consoles upon system names,,create_systems_list_mamedev systems @game_console,"
",,,,"
",Home systems upon descriptions,,create_systems_list_mamedev descriptions @home_system,"
",Home systems upon system names,,create_systems_list_mamedev systems @home_system,"
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
[[ $(expr $rp_module_version_database + 0) -lt 255 ]] && \
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
",Nintendo Datach + cartridge2 support,@non-arcade,install_system_mamedev nes nes_datach datach cartridge2 cart2 .prg,,,,,show_message_mamedev \"NO HELP\","
",Odyssey2 + voice (install odyssey2 and patch default loaders),@non-arcade,install_system_mamedev odyssey2;sed -i \"s/ %B/ -cart1 voice -cart2 %B/g;s/\/ '%B/ -cart1 voice -cart2 '%B/g;s/cart %R/cart1 voice -cart2 %R/g\" $rootdir/configs/odyssey2/emulators.cfg,,,,,show_message_mamedev \"NO HELP\","
",Orion 128 + romdisk + cassette support,@non-arcade,install_system_mamedev orion128 orion128 -cart*$romdir/RetroPie/roms/orion128/orion_cart/romdisk.zip cassette cass .wav*.flac*.rko*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.odi*.cpm*.img*.bin -romdisk,,,,,show_message_mamedev \"\
Use 'Scroll Lock' (GAME OFF/ON modus) when needed !\n\n
You will enter the ROMDISK GUI\n
Select CH4# and press ENTER (the LOADER will load)\n
At the BBOA prompt? press A (the cursor should stop flashing)\n
Press F2 to play the tape\n
You will see the name of the game you chose at the beginning appear\n
Press F4 once loading is complete (the LOADER will close)\n
In the next column you will see the name of the game you loaded\n
Go right with the cursor arrows and select it and press ENTER\n\n
romdisk.zip needs to be in :\n
$romdir/RetroPie/roms/orion128/orion_cart/romdisk.zip\","
",Orion 128 + romdisk + game1715 in flop1 + flop2 support,@non-arcade,install_system_mamedev orion128 orion128 -cart*$romdir/RetroPie/roms/orion128/orion_cart/romdisk.zip*-flop1*/home/pi/RetroPie/roms/orion128/orion_flop/game1715.zip floppydisk2 flop2 .wav*.flac*.rko*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.odi*.cpm*.img*.bin -romdisk-game1715-in-flop1,,,,,show_message_mamedev \"\
Use 'Scroll Lock' (GAME OFF/ON modus) when needed !\n\n
You will enter the ROMDISK GUI\n
Select Boot# and press ENTER\n
You will enter directly into the Norton Commander GUI\n
Press D to change drive press B\n
(you should have the floppy you chose at the beginning)\n
The launchable games are the .com ones\n
Select the one you want and press ENTER\n\n
romdisk.zip needs to be in :\n
$romdir/RetroPie/roms/orion128/orion_cart/romdisk.zip\n\n
game1715.zip needs to be in :\n
$romdir/RetroPie/roms/orion128/orion_flop/game1715.zip\","
",PC Engine + Super CD-ROM System support (-> HELP),@non-arcade,install_system_mamedev pce pce-cd scdsys cdrom cdrm .chd*.cue*.toc*.nrg*.gdi*.iso*.cdr -scdsys,,,,,show_message_mamedev \"Good to know :\nMame does not have a separate driver for PC Engine CD.\nPC Engine together with the Super CD-ROM System rom will make a :\nPC Engine CD\n\nThis will install PC Engine CD (pce-cd).\n\nThis BIOS is needed :\nscdsys.zip\nThe file can be found in pce.zip from the mame-sl rompackage.\nThe BIOS file can be placed inside the folder :\n$datadir/BIOS/mame/pce\","
",Sega SC-3000 + basic3 + cassette support,@non-arcade,install_system_mamedev sc3000 sc3000 -cart*basic3 cassette cass .wav*.flac*.bit*.tzx*.bin*.sg*.sc -basic3,,,,,show_message_mamedev \"\
Use 'Scroll Lock' (GAME OFF/ON modus) when needed !\n\n
After boot make sure you enable the SK-1100 keyboard\n
Enable the keyboard in the MAME UI and select :\n
Input settings\n
Keyboard selection\n
Sega SK-1100 keyboard and enable here\n
This setting will be saved for next time\n\n
Type LOAD to start loading the tape\n
Use F2 to start the tape\n
Type RUN to start the program\n\n
basic3.zip needs to be in :\n
$romdir/RetroPie/BIOS/mame/basic3.zip\n
or in :\n
$romdir/RetroPie/roms/sc3000/basic3.zip\","
",Sord M5 + basici + cassette support,@non-arcade,install_system_mamedev m5 m5 -cart1*basici cassette cass .prn*.wav*.flac*.cas*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk.bin*.rom -basici,,,,,show_message_mamedev \"\
Use 'Scroll Lock' (GAME OFF/ON modus) when needed !\n\n
For cassettes that load with CHAIN that cannot auto-start correctly\n\n
Type CHAIN to start loading the tape\n\n
basici.zip needs to be in :\n
$romdir/RetroPie/BIOS/mame/basici.zip\n
or in :\n
$romdir/RetroPie/roms/m5/basici.zip\","
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
# adding a newline can be done like this => \'\\\n\'
# adding some special characters isn't always possible the normal way, escaping the char with multiple \
# this is because the csv line is quoted with doublequotes and the delimiter  , is used to separate the "cells", also an extra * delimiter is used within "cells" to create a virtual 3D "worksheet"
# adding special characters is possible using ascii hex-code 
# check (https://www.cyberciti.biz/faq/unix-linux-sed-ascii-control-codes-nonprintable/)
# or (https://www.freecodecamp.org/news/ascii-table-hex-to-ascii-value-character-code-chart-2/)
# " => \'\\\x22\'
# * => \'\\\x2a\'
# , => \'\\\x2c\'
# : => \'\\\x3a\'

    local csv=()
    csv=(
",menu_item_handheld_description,to_do driver_used_for_installation,"
",Coco + ram + cassette + cload (auto) > run (manual),@non-arcade,install_system_mamedev coco coco -ext*ram*-autoboot_delay*2*-autoboot_command*cload\'\\\n\' cassette cass .wav*.cas*.ccc*.rom -extra_ram-autoboot-cload,"
",Coco + ram + cassette + cloadm:exec (auto),@non-arcade,install_system_mamedev coco coco -ext*ram*-autoboot_delay*2*-autoboot_command*cloadm:exec\'\\\n\' cassette cass .wav*.cas*.ccc*.rom -extra_ram-autoboot-cloadm:exec,"
	)
[[ $(expr $rp_module_version_database + 0) -gt 254 ]] && \
    csv+=(
",\Zr(>0254)\ZRCoco + floppy + os9 + dos (auto),@non-arcade,install_system_mamedev coco coco -autoboot_delay*2*-autoboot_command*dos\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-dos-os9,"
",\Zr(>0254)\ZRCoco + floppy + load\"%BASENAME%\" + run (auto),@non-arcade,install_system_mamedev coco coco -autoboot_delay*2*-autoboot_command*load\'\\\x22\'%BASENAME%\'\\\x22\'\'\\\x2c\'r\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-load_BASENAME_-run,"
",\Zr(>0254)\ZRCoco + floppy + run\"%BASENAME%\" (auto),@non-arcade,install_system_mamedev coco coco -autoboot_delay*2*-autoboot_command*run\'\\\x22\'%BASENAME%\'\\\x22\'\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-run_BASENAME_,"
",\Zr(>0254)\ZRCoco + floppy + loadm\"%BASENAME%\":exec (auto),@non-arcade,install_system_mamedev coco coco -autoboot_delay*2*-autoboot_command*loadm\'\\\x22\'%BASENAME%\'\\\x22\':exec\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-loadm_BASENAME_:exec,"
	)
[[ $(expr $rp_module_version_database + 0) -lt 255 ]] && \
    csv+=(
",\Zr(<0255)\ZRCoco 2 + ram + cassette + cload (auto) > run (manual),@non-arcade,install_system_mamedev coco2 coco2 -ext*ram*-autoboot_delay*2*-autoboot_command*cload\'\\\n\' cassette cass .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -extra_ram -extra_ram-autoboot-cload,"
",\Zr(<0255)\ZRCoco 2 + ram + cassette + cloadm:exec (auto),@non-arcade,install_system_mamedev coco2 coco2 -ext*ram*-autoboot_delay*2*-autoboot_command*cloadm:exec\'\\\n\' cassette cass .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -extra_ram -extra_ram-autoboot-cloadm:exec,"
",\Zr(<0255)\ZRCoco 2 + floppy + os9 + dos (auto),@non-arcade,install_system_mamedev coco2 coco2 -autoboot_delay*2*-autoboot_command*dos\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-dos-os9,"
",\Zr(<0255)\ZRCoco 2 + floppy + load\"%BASENAME%\" + run (auto),@non-arcade,install_system_mamedev coco2 coco2 -autoboot_delay*2*-autoboot_command*load\'\\\x22\'%BASENAME%\'\\\x22\'\'\\\x2c\'r\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-load_BASENAME_-run,"
",\Zr(<0255)\ZRCoco 2 + floppy + run\"%BASENAME%\" (auto),@non-arcade,install_system_mamedev coco2 coco2 -autoboot_delay*2*-autoboot_command*run\'\\\x22\'%BASENAME%\'\\\x22\'\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-run_BASENAME_,"
",\Zr(<0255)\ZRCoco 2 + floppy + loadm\"%BASENAME%\":exec (auto),@non-arcade,install_system_mamedev coco2 coco2 -autoboot_delay*2*-autoboot_command*loadm\'\\\x22\'%BASENAME%\'\\\x22\':exec\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-loadm_BASENAME_:exec,"
    )
    csv+=(
",Coco 3 + ram + cassette + cload (auto) > run (manual),@non-arcade,install_system_mamedev coco3 coco3 -ext*ram*-autoboot_delay*2*-autoboot_command*cload\'\\\n\' cassette cass .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -extra_ram-autoboot-cload,"
",Coco 3 + ram + cassette + cloadm:exec (auto),@non-arcade,install_system_mamedev coco3 coco3 -ext*ram*-autoboot_delay*2*-autoboot_command*cloadm:exec\'\\\n\' cassette cass .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -extra_ram--autoboot-cloadm:exec,"
",Coco 3 + floppy 525dd + os9 + dos (auto),@non-arcade,install_system_mamedev coco3 coco3 -autoboot_delay*2*-autoboot_command*dos\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-dos-os9-525dd,"
",Coco 3 + floppy 525dd + load\"%BASENAME%\" + run (auto),@non-arcade,install_system_mamedev coco3 coco3 -autoboot_delay*2*-autoboot_command*load\'\\\x22\'%BASENAME%\'\\\x22\'\'\\\x2c\'r\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-load_BASENAME_-run-525dd,"
",Coco 3 + floppy 525dd + run\"%BASENAME%\" (auto),@non-arcade,install_system_mamedev coco3 coco3 -autoboot_delay*2*-autoboot_command*run\'\\\x22\'%BASENAME%\'\\\x22\'\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-run_BASENAME_-525dd,"
",Coco 3 + floppy 525dd + loadm\"%BASENAME%\":exec (auto),@non-arcade,install_system_mamedev coco3 coco3 -autoboot_delay*2*-autoboot_command*loadm\'\\\x22\'%BASENAME%\'\\\x22\':exec\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-loadm_BASENAME_:exec-525dd,"
",Coco 3 + ram + floppy 525dd + os9 + dos (auto),@non-arcade,install_system_mamedev coco3 coco3 -ext*multi*-ext:multi:slot1*ram*-autoboot_delay*2*-autoboot_command*dos\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -autoboot-dos-extra_ram-os9-525dd,"
",Coco 3 + ram + floppy 525dd + load\"%BASENAME%\" + run (auto),@non-arcade,install_system_mamedev coco3 coco3 -ext*multi*-ext:multi:slot1*ram*-autoboot_delay*2*-autoboot_command*load\'\\\x22\'%BASENAME%\'\\\x22\'\'\\\x2c\'r\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -extra_ram-autoboot-load_BASENAME_-run-525dd,"
",Coco 3 + ram + floppy 525dd + run\"%BASENAME%\" (auto),@non-arcade,install_system_mamedev coco3 coco3 -ext*multi*-ext:multi:slot1*ram*-autoboot_delay*2*-autoboot_command*run\'\\\x22\'%BASENAME%\'\\\x22\'\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -extra_ram-autoboot-run_BASENAME_-525dd,"
",Coco 3 + ram + floppy 525dd + loadm\"%BASENAME%\":exec (auto),@non-arcade,install_system_mamedev coco3 coco3 -ext*multi*-ext:multi:slot1*ram*-autoboot_delay*2*-autoboot_command*loadm\'\\\x22\'%BASENAME%\'\\\x22\':exec\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.vhd*.bas*.bin -extra_ram-autoboot-loadm_BASENAME_:exec-525dd,"
",Dragon 32 + ram + cassette + cload (auto) > run (manual),@non-arcade,install_system_mamedev dragon32 dragon32 -ext*ram*-autoboot_delay*2*-autoboot_command*cload\'\\\n\' cassette cass .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -extra_ram-autoboot-cload,"
",Dragon 32 + ram + cassette + cloadm:exec (auto),@non-arcade,install_system_mamedev dragon32 dragon32 -ext*ram*-autoboot_delay*2*-autoboot_command*cloadm:exec\'\\\n\' cassette cass .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -extra_ram-autoboot-cloadm:exec,"
",Dragon 32 + floppy 525qd + load\"%BASENAME%\" + run (auto),@non-arcade,install_system_mamedev dragon32 dragon32 -autoboot_delay*3*-autoboot_command*load\'\\\x22\'%BASENAME%\'\\\x22\'\'\\\x2c\'r\'\\\n\' floppydisk1 flop1 .mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -autoboot-load_BASENAME_-run-525qd,"
",Dragon 32 + floppy 525qd + run\"%BASENAME%\" (auto),@non-arcade,install_system_mamedev dragon32 dragon32 -autoboot_delay*3*-autoboot_command*run\'\\\x22\'%BASENAME%\'\\\x22\'\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -autoboot-run_BASENAME_-525qd,"
",Dragon 32 + floppy 525qd + loadm\"%BASENAME%\":exec (auto),@non-arcade,install_system_mamedev dragon32 dragon32 -autoboot_delay*3*-autoboot_command*loadm\'\\\x22\'%BASENAME%\'\\\x22\':exec\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -extra_ram-autoboot-loadm_BASENAME_:exec-525qd,"
",Dragon 32 + ram + floppy 525qd + load\"%BASENAME%\" + run (auto),@non-arcade,install_system_mamedev dragon32 dragon32 -ext*multi*-ext:multi:slot1*ram*-autoboot_delay*3*-autoboot_command*load\'\\\x22\'%BASENAME%\'\\\x22\'\'\\\x2c\'r\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -extra_ram-autoboot-load_BASENAME_-run-525qd,"
",Dragon 32 + ram + floppy 525qd + run\"%BASENAME%\" (auto),@non-arcade,install_system_mamedev dragon32 dragon32 -ext*multi*-ext:multi:slot1*ram*-autoboot_delay*3*-autoboot_command*run\'\\\x22\'%BASENAME%\'\\\x22\'\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -extra_ram-autoboot-run_BASENAME_-525qd,"
",Dragon 32 + ram + floppy 525qd + loadm\"%BASENAME%\":exec (auto),@non-arcade,install_system_mamedev dragon32 dragon32 -ext*multi*-ext:multi:slot1*ram*-autoboot_delay*3*-autoboot_command*loadm\'\\\x22\'%BASENAME%\'\\\x22\':exec\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -extra_ram-autoboot-loadm_BASENAME_:exec-525qd,"
",(Tano) Dragon 64 NTSC + ram + cassette + cload (auto) > run (manual),@non-arcade,install_system_mamedev tanodr64 dragon64 -ext*ram*-autoboot_delay*2*-autoboot_command*cload\'\\\n\' cassette cass .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -extra_ram-autoboot-cload,"
",(Tano) Dragon 64 NTSC + ram + cassette + cloadm:exec (auto),@non-arcade,install_system_mamedev tanodr64 dragon64 -ext*ram*-autoboot_delay*2*-autoboot_command*cloadm:exec\'\\\n\' cassette cass .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -extra_ram-autoboot-cloadm:exec,"
",(Tano) Dragon 64 NTSC + fdc + floppy 525qd + load\"%BASENAME%\" + run (auto),@non-arcade,install_system_mamedev tanodr64 dragon64 -ext*multi*-ext:multi:slot1*ram*-ext*dragon_fdc*-autoboot_delay*3*-autoboot_command*load\'\\\x22\'%BASENAME%\'\\\x22\'\'\\\x2c\'r\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -autoboot-load_BASENAME_-run-525qd,"
",(Tano) Dragon 64 NTSC + fdc + floppy 525qd + run\"%BASENAME%\" (auto),@non-arcade,install_system_mamedev tanodr64 dragon64 -ext*dragon_fdc*-autoboot_delay*3*-autoboot_command*run\'\\\x22\'%BASENAME%\'\\\x22\'\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -autoboot-run_BASENAME_-525qd,"
",(Tano) Dragon 64 NTSC + fdc + floppy 525qd + loadm\"%BASENAME%\":exec (auto),@non-arcade,install_system_mamedev tanodr64 dragon64 -ext*dragon_fdc*-autoboot_delay*3*-autoboot_command*loadm\'\\\x22\'%BASENAME%\'\\\x22\':exec\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -autoboot-loadm_BASENAME_:exec-525qd,"
",(Tano) Dragon 64 NTSC + ram + dfc + floppy 525qd + load\"%BASENAME%\" + run (auto),@non-arcade,install_system_mamedev tanodr64 dragon64 -ext*dragon_fdc*-autoboot_delay*3*-autoboot_command*load\'\\\x22\'%BASENAME%\'\\\x22\'\'\\\x2c\'r\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -extra_ram-autoboot-load_BASENAME_-run-525qd,"
",(Tano) Dragon 64 NTSC + ram + dfc + floppy 525qd + run\"%BASENAME%\" (auto),@non-arcade,install_system_mamedev tanodr64 dragon64 -ext*multi*-ext:multi:slot1*ram*-ext*dragon_fdc*-autoboot_delay*3*-autoboot_command*run\'\\\x22\'%BASENAME%\'\\\x22\'\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -extra_ram-autoboot-run_BASENAME_-525qd,"
",(Tano) Dragon 64 NTSC + ram + dfc + floppy 525qd + loadm\"%BASENAME%\":exec (auto),@non-arcade,install_system_mamedev tanodr64 dragon64 -ext*multi*-ext:multi:slot1*ram*-ext*dragon_fdc*-autoboot_delay*3*-autoboot_command*loadm\'\\\x22\'%BASENAME%\'\\\x22\':exec\'\\\n\' floppydisk1 flop1 .wav*.cas*.ccc*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk*.jvc*.vdk*.sdf*.os9*.bas*.bin -extra_ram-autoboot-loadm_BASENAME_:exec-525qd,"
",Electron + cassette + *tape chain\"\"(auto),@non-arcade,install_system_mamedev electron electron -autoboot_delay*2*-autoboot_command*\'\\\x2a\'TAPE\'\\\n\'CHAIN\'\\\x22\'\'\\\x22\'\'\\\n\' cassette cass .wav*.csw*.uef*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.ssd*.bbc*.img*.dsd*.adf*.ads*.adm*.adl*.rom*.bin -autoboot-tape-chain,"
",Electron + cassette + *tape *run(auto),@non-arcade,install_system_mamedev electron electron -autoboot_delay*2*-autoboot_command*\'\\\x2a\'TAPE\'\\\n\'\'\\\x2a\'RUN\'\\\n\' cassette cass .wav*.csw*.uef*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.ssd*.bbc*.img*.dsd*.adf*.ads*.adm*.adl*.rom*.bin -autoboot-tape-tun,"
",MSX1 Philips VG-8020-20 + cassette + run\"cas:\" (auto),@non-arcade,install_system_mamedev vg802020 msx -autoboot_delay*6*-autoboot_command*run\'\\\x22\'cas\'\\\x3a\'\'\\\x22\'\'\\\x2c\'r\'\\\n\' cassette cass .wav*.tap*.cas*.mx1*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dm -autoboot-run,"
",MSX1 Philips VG-8020-20 + cassette + bload\"cas:\" + run (auto),@non-arcade,install_system_mamedev vg802020 msx -autoboot_delay*6*-autoboot_command*bload\'\\\x22\'cas\'\\\x3a\'\'\\\x22\'\'\\\x2c\'r\'\\\n\' cassette cass .wav*.tap*.cas*.mx1*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dm -autoboot-bload,"
",MSX2 Sony HB-F700P + disk + run\"%BASENAME%\" (auto),@non-arcade,install_system_mamedev hbf700p msx2 -autoboot_delay*5*-autoboot_command*run\'\\\x22\'%BASENAME%\'\\\x22\'\'\\\n\' floppydisk flop  .wav*.tap*.cas*.mx1*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk -autoboot-run_BASENAME_,"
",MSX2 Sony HB-F700P + disk + bload\"%BASENAME%\" + run (auto),@non-arcade,install_system_mamedev hbf700p msx2 -autoboot_delay*5*-autoboot_command*bload\'\\\x22\'%BASENAME%\'\\\x22\'\'\\\x2c\'r\'\\\n\' floppydisk flop  .wav*.tap*.cas*.mx1*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk -autoboot-bload_BASENAME_+run,"
",MSX2 Philips NMS8250 + disk + run\"%BASENAME%\" (auto),@non-arcade,install_system_mamedev nms8250 msx2 -autoboot_delay*5*-autoboot_command*run\'\\\x22\'%BASENAME%\'\\\x22\'\'\\\n\' floppydisk flop  .wav*.tap*.cas*.mx1*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk -autoboot-run_BASENAME_,"
",MSX2 Philips NMS8250 + disk + bload\"%BASENAME%\" + run (auto),@non-arcade,install_system_mamedev nms8250 msx2 -autoboot_delay*5*-autoboot_command*bload\'\\\x22\'%BASENAME%\'\\\x22\'\'\\\x2c\'r\'\\\n\' floppydisk flop  .wav*.tap*.cas*.mx1*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.dmk -autoboot-bload_BASENAME_+run,"
",Sam Coupe + floppy + boot (auto),@non-arcade,install_system_mamedev samcoupe samcoupe -autoboot_delay*2*-autoboot_command*\'\\\n\'boot\'\\\n\' floppydisk flop1  .wav*.tzx*.tap*.blk*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.mgt -autoboot-boot,"
",Sinclair ZX-81 + cassette + load\"\" (auto) > play tape (+ run) (manual),@non-arcade,install_system_mamedev zx81 zx81 -autoboot_delay*3*-autoboot_command*j\'\\\x22\'\'\\\x22\'\'\\\n\' cassette cass  *.wav*.p*.81*.tzx -autoboot-load-manual_run,"
	)
	
    build_menu_mamedev
}


function subgui_addons_mamedev () {
    [[ $1 != refresh ]] && local csv=()
    csv=(
",menu_item,,to_do,,,,,help_to_do,"
",Download a predefined emulationstation es_input.cfg,,download_from_github_mamedev  FollyMaddy/RetroPie-Share/tree/main/00-emulationstation-00 $rootdir/configs/all/emulationstation cfg,,,,,show_message_mamedev \"Annoyingly everytime when you start with a new $(echo $romdir|cut -d/ -f4) you have to setup your keyboard or joystick again in emulationstation. The es_input.cfg file mentioned in this option can be downloaded to skip the process of configuring the inputs when starting emulationstation for the first time. The es_input.cfg has already several predefined input devices like :\n- keyboard (basic keys : not all keys are added !)\n- Padix Co. Ltd. QZ 501 PREDATOR \n- Nintendo Wiimote\n- PSX controller\n- Usb Gamepad (BigBen_Interactive_Usb_Gamepad)\n- Padix Co. Ltd. 2-axis 8-button gamepad\n- Padix Co. Ltd. 4-axis 4-button joystick w/view finder\n- Padix Co Ltd. 4-axis 4-button joystick\n\nBeware : If your input device isn't in this es_input.cfg then you probably don't want to use this config file.\nHowever more input devices can be committed to the es_input.cfg in the future.\","
	)
	if [[ $scriptdir == *RetroPie* ]];then
		csv+=(
",$([[ $(sha1sum $rootdir/supplementary/runcommand/runcommand.sh 2>&-) != 739b6c7e50c6b4e2d048ea85f93ab8c71b1a1d74* ]] && echo Install patched runcommand.sh with extra replace tokens)$([[ $(sha1sum $rootdir/supplementary/runcommand/runcommand.sh 2>&-) == 739b6c7e50c6b4e2d048ea85f93ab8c71b1a1d74* ]] && echo Restore to original runcommand.sh),,install_or_restore_runcommand_script_mamedev;#refresh,subgui_addons_mamedev,,,,show_message_mamedev \"This option can do two things.\nIf the original runcommand.sh is detected then install the patched runcommand.sh with extra replace tokens.\nIf the patched runcommand.sh is detected then restore to the original runcommand.sh.\n\nIf the patched runcommand.sh is installed the runcommands that are installed by the script will automatically have the extra replace tokens inside.\nIf the original runcommand.sh is installed the runcommands that are installed by the script will not have the extra replace tokens inside !\n\nThe patched runcommand.sh will have the following extra replace tokens or improvements :\n\n%ROMDIR%\nThe %ROMDIR% token can be used to add the rompath in a runcommand.\nWhen using a runcommand using %BASENAME$ the rom can always be found even in a sub-directory. This also makes it possible to categorise roms in different folders within a roms directory.\n\n%DQUOTE% :\nThe %ROMDIR% token does not have double quoting.\nWhy? Because lr-mame and lr-mess can't cope with it.\nFor this reason the %DQUOTE% token is added.\nThe %DQUOTE% token can be placed in other places to get the runcommand working especially when using subdirectories that have spaces in them.\nFor MAME standalone this will work :\n-rompath $datadir/BIOS/mame;%DQUOTE%%ROMDIR%%DQUOTE%\nFor lr-mame and lr-mess this will work :\n-rompath %DQUOTE%$datadir/BIOS/mame;%ROMDIR%/%DQUOTE%\nAll other attempts to add double quotes to runcommands in a different way failed so using the %DQUOTE% token seems to only way to go.\n\n%CLEANBASENAME% :\nThe %CLEANBASENAME% token is needed for creating a proper per game config directory so mame system configs can be created per game.\nFor MAME standalone this would not be necessary but lr-mame and lr-mess can't cope with spaces and double quotes in the wrong places.\nTherefor the %CLEANBASENAME% token can be used which removes all spaces and special characters and is without any double quotes.\nThe %CLEANBASENAME% token could also be used to make a clean savestate file\n\n%SOFTLIST% :\nThe %SOFTLIST% token is needed to force proper softlist loading\nFor example pacmania is in msx1_cass and in msx2_cart.\nIf one loads a game with a basename loader for example pacmania which comes from msx2_cart then normally the soflist msx1_cass has priority over msx2_cart.\nSo mame thinks it's pacmania from msx1_cass but it is actually pacmania from msx2_cart.\nTo fix this issue we need to force the correct softlist before the %BASENAME% token.\nThe %SOFTLIST% token is the last folder name where the rom is in plus an extra => :.\nFor pacmania we will have to place it in the folder msx2_cart.\nIn the loader you will see it as %SOFTLIST%%BASENAME% eventually for pacmania it will look like this msx2_cart:pacmania.\nIf the rom is in a rompath without => _ then the %SOFTLIST% token will be empty and mame will guess the correct softlist.\nIf %SOFTLIST% token gets a value for some reason because a _ char is in the path then mame will refuse to load the game.\nA check in the runcommand.log will reveal the issue.\nAlthough it's an improvement for example msx1_bee_card softlist will not benefit from it as it needs the beepack to be inserted as a slot. So softlists that need slot options will still not work with the regular basename loaders.\","
		)
	else
		csv+=(
",$([[ $(sha1sum $rootdir/supplementary/runcommand/runcommand.sh 2>&-) != cd620d05484350afa6186ded4e5c3ca59c6d10bd* ]] && echo Install patched runcommand.sh with extra replace tokens)$([[ $(sha1sum $rootdir/supplementary/runcommand/runcommand.sh 2>&-) == cd620d05484350afa6186ded4e5c3ca59c6d10bd* ]] && echo Restore to original runcommand.sh),,install_or_restore_runcommand_script_mamedev;#refresh,subgui_addons_mamedev,,,,show_message_mamedev \"This option can do two things.\nIf the original runcommand.sh is detected then install the patched runcommand.sh with extra replace tokens.\nIf the patched runcommand.sh is detected then restore to the original runcommand.sh.\n\nIf the patched runcommand.sh is installed the runcommands that are installed by the script will automatically have the extra replace tokens inside.\nIf the original runcommand.sh is installed the runcommands that are installed by the script will not have the extra replace tokens inside !\n\nThe patched runcommand.sh will have the following extra replace tokens or improvements :\n\n%ROMDIR%\nThe %ROMDIR% token can be used to add the rompath in a runcommand.\nWhen using a runcommand using %BASENAME$ the rom can always be found even in a sub-directory. This also makes it possible to categorise roms in different folders within a roms directory.\n\n%DQUOTE% :\nThe %ROMDIR% token does not have double quoting.\nWhy? Because lr-mame and lr-mess can't cope with it.\nFor this reason the %DQUOTE% token is added.\nThe %DQUOTE% token can be placed in other places to get the runcommand working especially when using subdirectories that have spaces in them.\nFor MAME standalone this will work :\n-rompath $datadir/BIOS/mame;%DQUOTE%%ROMDIR%%DQUOTE%\nFor lr-mame and lr-mess this will work :\n-rompath %DQUOTE%$datadir/BIOS/mame;%ROMDIR%/%DQUOTE%\nAll other attempts to add double quotes to runcommands in a different way failed so using the %DQUOTE% token seems to only way to go.\n\n%CLEANBASENAME% :\nThe %CLEANBASENAME% token is needed for creating a proper per game config directory so mame system configs can be created per game.\nFor MAME standalone this would not be necessary but lr-mame and lr-mess can't cope with spaces and double quotes in the wrong places.\nTherefor the %CLEANBASENAME% token can be used which removes all spaces and special characters and is without any double quotes.\nThe %CLEANBASENAME% token could also be used to make a clean savestate file\n\n%SOFTLIST% :\nThe %SOFTLIST% token is needed to force proper softlist loading\nFor example pacmania is in msx1_cass and in msx2_cart.\nIf one loads a game with a basename loader for example pacmania which comes from msx2_cart then normally the soflist msx1_cass has priority over msx2_cart.\nSo mame thinks it's pacmania from msx1_cass but it is actually pacmania from msx2_cart.\nTo fix this issue we need to force the correct softlist before the %BASENAME% token.\nThe %SOFTLIST% token is the last folder name where the rom is in plus an extra => :.\nFor pacmania we will have to place it in the folder msx2_cart.\nIn the loader you will see it as %SOFTLIST%%BASENAME% eventually for pacmania it will look like this msx2_cart:pacmania.\nIf the rom is in a rompath without => _ then the %SOFTLIST% token will be empty and mame will guess the correct softlist.\nIf %SOFTLIST% token gets a value for some reason because a _ char is in the path then mame will refuse to load the game.\nA check in the runcommand.log will reveal the issue.\nAlthough it's an improvement for example msx1_bee_card softlist will not benefit from it as it needs the beepack to be inserted as a slot. So softlists that need slot options will still not work with the regular basename loaders.\","
		)
	fi
	csv+=(
",,,,"
",Experimental : CHANGE selected config options,,subgui_configs_settings_mamedev,,,,,help_to_do,"
",,,,"
",Download retroarch-joypad-autoconfigs (+/-1 min.),,download_from_github_mamedev  libretro/retroarch-joypad-autoconfig/tree/master/udev $rootdir/configs/all/retroarch-joypads cfg;download_from_github_mamedev  FollyMaddy/RetroPie-Share/tree/main/00-retroarch-00/retroarch-joypad-autoconfig $rootdir/configs/all/retroarch-joypads cfg,,,,,show_message_mamedev \"The autoconfig files mentioned in this option are used to recognize input devices and to automatically setup the default mappings between the physical device and the RetroPad virtual controller.\nThe configs come from :\nhttps://github.com/libretro/retroarch-joypad-autoconfig/tree/master/udev\nhttps://github.com/FollyMaddy/RetroPie-Share/tree/main/00-retroarch-00/retroarch-joypad-autoconfig\n\nThe configs are placed in :\n$rootdir/configs/all/retroarch-joypads\","
",Download lr-mess configs for better button mapping (+/-1 min.),,download_from_google_drive_mamedev 1Js34M6b8n97CUp_Bf_x4FfpG68oKL3I5 $rootdir/configs,,,,,show_message_mamedev \"Most handheld games don't use the same joystick layout. To make it more universal @bbilford83 made some custom configs. Basically it means that the shooter button is always the same in these games.\n\nThe added game button configs are for the categories :\n- konamih ($rootdir/configs/konamih/lr-mess)\n- tigerh ($rootdir/configs/tigerh/lr-mess)\n\nKnown compatible joypads are :\n- 8bitdo\n- BigBen\n- PiBoy\n\nFiles are downloaded from the google-drive of @bbilford83 :\n1RTxt9lZpGwtbNsrPRV9_FJChpk_iDiDE\","
",,,,"
",►Download cheatfile from list,,subgui_download_cheat_mamedev,,,,,show_message_mamedev \"When this script installs a system or category the cheat option in the configs will be turned on in lr-mess/lr-mame and MAME. Together with the cheat file you will be able to use cheats on certain games. The cheat file used can be found on http://www.mamecheat.co.uk\","
",►Download gamelists,,subgui_gamelists_mamedev,,,,,show_message_mamedev \"Here you will find the options to use use RetroScraper and to install predefined gamelists with videos and pictures. These are created to have a good preview in emulationstation of the games you can select. In contrary to where the gamelists are normally stored these gamelists are stored in :\n~$datadir/roms/<system>\nThis makes it easier to backup the gamelists together with your roms and it prevents from overwriting gamelist files in other locations.\n\nWhen selecting this option all available gamelists with media are downloaded.\","
	)
	[[ $(expr $rp_module_version_database + 0) -gt 273 ]] && \
    csv+=(
",Download/update mame audio samples,,download_extra_files_mamedev https://www.progettosnaps.net/samples/packs/ MAME_samples_278.zip samples samples.7z extract_7z,,,,,show_message_mamedev \"Nohelp\","
	)
	csv+=(
",Download/update mame artwork (+/-30 min.),,download_from_google_drive_mamedev 1sm6gdOcaaQaNUtQ9tZ5Q5WQ6m1OD2QY3 $datadir/roms/mame/artwork,,,,,show_message_mamedev \"Here you will find the artwork files needed for a lot of handheld games and it's basically only working on MAME standalone. Some artwork files are custom made others are from other sources. Though we changed the background and bezel filenames in the archives so the options 'Create RetroArch xxxxxxxxxxx-overlays' can make use of these artwork files by extracting the overlay pictures and use them for lr-mess and lr-mame in retroarch.\","
",Create RetroArch background-overlays from artwork,,create_background_overlays_mamedev,,,,,show_message_mamedev \"This option only works if you have downloaded the artwork files for MAME standalone earlier on. A selection of background filenames are extracted from the MAME artwork files and overlay configs are created for use with lr-mess/lr-mame in retroarch.\","
",Create RetroArch 16:9 bezel-overlays from artwork,,create_bezel_overlays_mamedev -16-9,,,,,show_message_mamedev \"This option only works if you have downloaded the artwork files for MAME standalone earlier on. A selection of bezel filenames are extracted from the MAME artwork files and overlay configs are created for use with lr-mess/lr-mame in retroarch.\","
",Create RetroArch 16:9 bezel-overlays from artwork (+alternatives),,create_bezel_overlays_mamedev -16-9;create_bezel_overlays_mamedev 2-16-9,,,,,show_message_mamedev \"This option only works if you have downloaded the artwork files for MAME standalone earlier on. A selection of bezel filenames are extracted from the MAME artwork files and overlay configs are created for use with lr-mess/lr-mame in retroarch.\n\nIn contrary to the regular option this option will get some alternative looking bezels.\","
",Setup Orionsangels Realistic Arcade Overlays > roms/realistic,@arcade,create_00index_file_mamedev '/@oro/' $datadir/roms/realistic;install_system_mamedev realistic realistic '' '' 'none' '';download_from_google_drive_mamedev 1m_8-LJpaUFxUtwHCyK4BLo6kiFsvMJmM $datadir/downloads;organise_realistic_overlays_mamedev,,,,,show_message_mamedev \"Orionsangels made a lot of realistic bezels for lr-mame in retroarch. Manually installing was a bit difficult as the files were for windows only. On top of that the configs also had fixed resolutions which is problematic when you don't use the same resolution.\n\nSelecting this option will install the category \"realistic\" in your roms directory. The bezels will be downloaded and patched for linux use and the resolutions will be converted to the resolution that is detected. If you change the resolution of your setup you have to select this option again so the configs are recreated again with the proper resolution settings. Selecting this a second time will skip downloading the bezels if they are still on your computer.\","
",,,,"
",$([[ ! -f $scriptdir/scriptmodules/run_mess.sh ]] && echo Install @valerino run_mess.sh script \(the RusselB version\))$([[ -f $scriptdir/scriptmodules/run_mess.sh ]] && echo Remove the Valerino run_mess.sh script \(the RusselB version\)),,install_or_remove_run_mess_script_mamedev;#refresh,subgui_addons_mamedev,,,,show_message_mamedev \"This option can do two things.\nIf run_mess.sh is not detected then install it.\nIf run_mess.sh is detected then remove it.\n\nThis is the history of the run_mess.sh script :\n@Valerino started the topic 'new scriptmodules for proper lr-mess integration'. For that purpose he made the run_mess.sh script. He also made module-scripts for various lr-mess drivers so they could be installed seperately.
The runcommands that were installed by the module-scripts used this run_mess.sh script. Basically collecting the options from the runcommand and then creating a .cmd file which can then be runned by lr-mess. Every time a .cmd file is made and removed afterwards when running a game.\n\nThis script used that same run_mess.sh to be backwards compatible with the work of @Valerino. Later @RusselB improved the script.\nHe said : My improvevement allowed me to specify custom configs including bezels and screen locations etc. per rom.\n\nBasically the run_mess.sh script isn't needed anymore as we now use direct runcommands.\nSo when this run_mess.sh script is not installed the runcommands are not created anymore\nIf however you still want to use the old runcommands using the run_mess.sh script then you can install it and the script will make these older runcommands when installing a driver.\","

    )
    [[ $1 != refresh ]] && build_menu_mamedev
}


function subgui_databases_mamedev() {
    local csv=()
    local database_read
    clear
    echo "reading the available databases"
    #the first value is reserved for the column descriptions and empty in the array rp_module_database_versions
    while read database_read;do csv+=("$database_read");done < <(IFS=$'\n'; echo "${rp_module_database_versions[*]}"|while read line;do echo "\",Set database to $line,,rp_module_version_database=$line;#break;mamedev_csv=(),\"";done;unset IFS)
    build_menu_mamedev
    #"break" after usage in function build_menu_mamedev
}


function subgui_download_cheat_mamedev() {
	show_message_mamedev "\
A list of cheats from mamecheats.co.uk will be presented.\n\
Selecting one will download the selected cheatfiles in /tmp/\n\
Then it will be extracted and overwritten in :\n\
- $datadir/BIOS/mame/cheat (for lr-mame/lr-mess)\n\
- $datadir/roms/mame/cheat (for mame)"
    local csv=()
    #the first value is reserved for the column descriptions
    csv=( ",,,," )
    local mamecheat_read
    clear
    echo "reading the available binaries"
    while read mamecheat_read;do csv+=("$mamecheat_read");done < <(IFS=$'\n'; curl https://www.mamecheat.co.uk/mame_downloads.htm|grep ">XML"|sed 's/</"/g;s/>/"/g;s/XML //g;s/Release Date: //g'|while read line;do echo "\",$(echo $line|cut -d\" -f7),,download_extra_files_mamedev https://www.mamecheat.co.uk $(echo $line|cut -d\" -f5) cheat cheat.7z,\"";done)
    build_menu_mamedev
}


function direct_install_mamedev() {
    local csv=()
    local driver_name
    local system_type
    local driver_info=()

    driver_name=$(dialog \
--no-cancel \
--default-item "$default" \
--backtitle "$__backtitle" \
--title "Give your driver name and install it directly" \
--form "" \
22 76 16 \
"Driver name:" 1 1 "" 1 22 76 100 \
2>&1 >/dev/tty \
)
clear
read_data_mamedev clear
#get non-arcade/arcade status from database
IFS=$'\n' driver_info=($(awk "/,$driver_name,/" <<<$(sed 's/" "/"\n"/g' <<<"${mamedev_csv[*]}")));unset IFS
if [[ ${driver_info[@]} == *@non-arcad* ]]
then system_type="non-arcade"
else system_type="arcade"
fi
if [[ -z $driver_info || -z $driver_name ]];then
	show_message_mamedev "The drivername you entered doesn't exist\n\nNot proceeding !"
else
	install_system_mamedev $driver_name "" "" "" "" "" "" "" "" "$system_type"
fi
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
    [[ $1 != refresh ]] && local csv=()
    #the first value is reserved for the column descriptions
    csv=( ",,,," )
    local installed_system_read
    clear
    echo "reading the installed systems"
    while read installed_system_read;do csv+=("$installed_system_read");done < <(grep -r ^mame- $rootdir/configs/*/emulators.cfg|cut -d/ -f5|uniq|while read line;do echo "\",Remove $line,,remove_installs_mamedev $line;#refresh,subgui_remove_installs_mamedev,,,,show_message_mamedev \"No help\",";done)
    if [[ -z ${csv[1]} ]]; then
    show_message_mamedev "No systems installed, use cancel to go back !"
    csv+=( ",,,," )
    fi
    [[ $1 != refresh ]] && build_menu_mamedev
}


function subgui_retroscraper_gamelists_mamedev() {
    #retroscraper_remote_depends_mamedev
    local csv=()
    local gamelists_csv=()
    local gamelists_read
    clear
    echo "reading the individual gamelist data"
    #we need to add 'echo \",,,,\";', because otherwise the first value isn't displayed as it is reserved for the column descriptions
    while read gamelists_read;do gamelists_csv+=("$gamelists_read");done < <(echo \",,,,\";ls -w1 $datadir/roms|while read line;do echo "\",Retroscrape/update only for $([[ $line == *º ]]&&echo ' ')$(if [[ -f $datadir/roms/$line/gamelist.xml ]];then printf '%-20s\\\Z2(has gamelist)\n' $line;else printf '%-20s(no  gamelist)\n' $line;fi),,retroscraper_remote_command_mamedev $line;#break,\"";done)
    IFS=$'\n' csv=($(sort -t"," -d -k 2 --ignore-case <<<"${gamelists_csv[*]}"));unset IFS
    build_menu_mamedev
}


function remove_installs_mamedev() {
    cat $rootdir/configs/$1/emulators.cfg|grep -v default|awk '/mame-/||/mess-/'|cut -d= -f1|while read line;do delEmulator $line $1;done
    [[ ! -f $rootdir/configs/$1/emulators.cfg ]] && delSystem $1
}


function retroscraper_remote_command_mamedev() {
    rm $datadir/roms/$1/gamelist.xml 2> /dev/null
    rm -r $datadir/roms/$1/media/emulationstation 2> /dev/null
    #use python_virtual_environment
    su $user -c "curl https://raw.githubusercontent.com/zayamatias/retroscraper-remote/main/retroscraper.py|/home/$user/.local/bin/uv run --python 3.11 --with 'httpimport==1.1.0' --with 'requests==2.21.0' --with 'wheel==0.40.0' --with 'setuptools==67.7.2' --with 'googletrans==4.0.0rc1' --with 'Pillow==9.2.0' - --recursive --relativepaths --mediadir media/emulationstation --nobackup --systems $1"
    #"break" after usage in function build_menu_mamedev so a good list of present gamelists can be viewed
}


function retroscraper_remote_depends_mamedev () {
    #install python modules when not detected as installed
    #retroscraper-remote needs httpimport as extra library so some dependancies can be used "online"
    #https://stackoverflow.com/questions/23106621/replace-multiple-consecutive-white-spaces-with-one-comma-in-unix
    #looking for latest versions then do : python3 -m pip list --outdated  
    #looking for installed packages and versions then do : python3 -m pip list 
    #if above doesn't work then go into the python virtual environment that is installed after trying retroscraper from the script and do the following :
    #cd /opt/retropie/python_virtual_environment/bin
    #/python -m pip list --outdated
    #(updating httpimport==1.4.0 did not work)
    local pip_list_output
    local retroscraper_remote_module
    local retroscraper_remote_modules=()
    retroscraper_remote_modules=(
    wheel==0.44.0
    setuptools==75.1.0
    googletrans==4.0.0rc1
    Pillow==10.4.0
    requests==2.32.3
    httpimport==1.3.1
    )
    #use a virtual python environment
    #https://stackoverflow.com/questions/60868540/cant-install-python-modules-with-pip-on-manjaro-linux
    [[ ! -d $rootdir/python_virtual_environment ]] && python3 -m venv $rootdir/python_virtual_environment
    [[ $($rootdir/python_virtual_environment/bin/python3 -m pip list 2>&1) == *"new release of pip"* ]] && $rootdir/python_virtual_environment/bin/python3 -m pip install --upgrade pip
    pip_list_output=$(su $user -c "$rootdir/python_virtual_environment/bin/python3 -m pip list|sed 's/ \{1,\}/==/g'")
    for retroscraper_remote_module in ${retroscraper_remote_modules[@]};do 
    [[ $pip_list_output != *$retroscraper_remote_module* ]] && $rootdir/python_virtual_environment/bin/python3 -m pip install $retroscraper_remote_module
    done
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
#has been locked#    local rompack_link_info=( "mame-merged \Zb\Z2NEWEST" ".zip" "mame-merged/mame-merged" )
    local rompack_link_info=( "mame-0.264-roms-non-merged" ".zip" "\"mame-0.264-roms-non-merged/MAME 0.264 ROMs (non-merged)\"" )
    local csv=()
	local rarfile 
    csv=(
",menu_item,,to_do,"
",▼\ZrBrowse BIOS files and download to BIOS/mame\ZR,,,"
",BIOS/mame < (OLD-SET)MAME_0.224_ROMs_merged,,subform_archive_download_mamedev '//' $datadir/BIOS/mame MAME_0.224_ROMs_merged download archive.???,,,,,show_message_mamedev \"NO HELP\","
",BIOS/mame < (NEW-SET)mame-0.240-roms-split_202201,,subform_archive_download_mamedev '//' $datadir/BIOS/mame mame-0.240-roms-split_202201/MAME%200.240%20ROMs%20%28split%29/ download archive.???,,,,,show_message_mamedev \"NO HELP\","
",BIOS/mame < (NEW-SET)mame-0.264-roms-non-merged,,subform_archive_download_mamedev '//' $datadir/BIOS/mame \"mame-0.264-roms-non-merged/MAME%200.264%20ROMs%20(non-merged)/\" download archive.???,,,,,show_message_mamedev \"NO HELP\","
",BIOS/mame < \Z1(NEW-SET)mame-merged  \Zb\Z2NEWEST,,subform_archive_download_mamedev '//' $datadir/BIOS/mame mame-merged/mame-merged/ download archive.???,,,,,show_message_mamedev \"NO HELP\","
",,,,"
",▼\ZrBrowse BIOS files < NOT FOUND in last runcommand.log,,,"
",BIOS/mame < BIOS(es) NOT FOUND < ${rompack_link_info[0]},,subform_archive_download_mamedev \"$(echo /$(cat /dev/shm/runcommand.log 2>&-|grep "NOT FOUND"|sed 's/.*in //g;s/)//g;s/ /\n/g'|sort -u)\\\./|sed 's/ /\\\.\/\|\|\//g')\" $datadir/BIOS/mame \"mame-0.264-roms-non-merged/MAME%200.264%20ROMs%20(non-merged)/\" download archive.???,,,,,show_message_mamedev \"When games don't work they probably miss rom files somewhere. Normally you can find these errors in the /dev/shm/runcommand.log when searching for the lines NOT FOUND. This part will do this automatically for you and it will add the roms in a list when applying the appropriate archive.xxx website information. Remember it will display roms you have and roms you don't have. Select the roms you don't have. These roms will be saved in the BIOS/mame directory. Now try loading the rom again and you will see that it works. ;-)\n\nFor those who run this for solving problems with more games without exiting the script (you can only do this from the X enviroment when you run games and also run the $(echo $romdir|cut -d/ -f4)-Setup simultaneously). To get fresh results you have to exit the restricted area and restart the line again.\","
",,,,"
",▼\ZrBrowse software files and download to $(echo $romdir|cut -d/ -f4)/downloads,,,"
",$(echo $romdir|cut -d/ -f4)/downloads < (OLD-SET)MAME_0.202_Software_List_ROMs_merged,,subform_archive_download_mamedev '//' $datadir/downloads/MAME_0.202_Software_List_ROMs_merged MAME_0.202_Software_List_ROMs_merged download archive.???,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/downloads < (OLD-SET)MAME_0.224_ROMs_merged,,subform_archive_download_mamedev '//' $datadir/downloads/MAME_0.224_ROMs_merged MAME_0.224_ROMs_merged download archive.???,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/downloads < (NEW-SET)mame-0.240-roms-split_202201,,subform_archive_download_mamedev '//' $datadir/downloads/mame-0.240-roms-split_202201 mame-0.240-roms-split_202201/MAME%200.240%20ROMs%20%28split%29/ download archive.???,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/downloads < \Z1(NEW-SET)mame-sl  \Zb\Z2NEWEST,,subform_archive_download_mamedev '//' $datadir/downloads/mame-sl mame-sl/mame-sl/ download archive.???,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/downloads < \Z1(NEW-SET)mame-merged  \Zb\Z2NEWEST,,subform_archive_download_mamedev '//' $datadir/downloads/mame-merged mame-merged/mame-merged/ download archive.???,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/downloads < UnRenamedFiles-Various,,subform_archive_download_mamedev '//' $datadir/downloads/UnRenamedFiles-Various UnRenamedFiles-Various download archive.???,,,,,show_message_mamedev \"NO HELP\","
",,,,"
    )
    [[ $(expr $rp_module_version_database + 0) -gt 261 ]] && \
    csv+=(
",▼\ZrGet all files from automated category lists,,,"
",►Show non-arcade  categories and get roms	< ${rompack_link_info[0]},,subformgui_categories_automated_mamedev \"show list to download category roms\" @non-arcade \"/@non-arcade@/ && /@no_media@/\" \"!/90º|bios|computer|good|new0*|no_media|@ma@|oro|working_arcade/\" \"yes\",,,,,,"
",►Show   arcade    categories and get roms	< ${rompack_link_info[0]},,subformgui_categories_automated_mamedev \"show list to download category roms\" @arcade \"!/@mechanical@/ && /@arcade@/\" \"!/90º|bios|computer|good|new0*|@ma@|oro|working_arcade/\" \"yes\",,,,,,"
",►Show  arcade90º  categories and get roms	< ${rompack_link_info[0]},,subformgui_categories_automated_mamedev \"show list to download category roms\" @arcade \"!/@mechanical@/ && /@arcade@/ && /@90º@/\" \"!/90º|bios|computer|good|new0*|@ma@|oro|working_arcade/\" \"yes\",,,,,,"
",,,,"
    )
    csv+=(
",▼\ZrGet all handheld and plug&play files per category,,,"
",$(echo $romdir|cut -d/ -f4)/roms/all_in1      < ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@all_in1/' ${rompack_link_info[1]} $datadir/roms/all_in1 ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/classich     < ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@classich/' ${rompack_link_info[1]} $datadir/roms/classich ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/gameandwatch < ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@gameandwatch/' ${rompack_link_info[1]} $datadir/roms/gameandwatch ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/jakks        < ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@jakks/' ${rompack_link_info[1]} $datadir/roms/jakks ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/konamih      < ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@konamih/' ${rompack_link_info[1]} $datadir/roms/konamih ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/tigerh       < ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@tigerh/' ${rompack_link_info[1]} $datadir/roms/tigerh ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/tigerrz      < ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@tigerrz/' ${rompack_link_info[1]} $datadir/roms/tigerrz ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",,,,"
",▼\ZrGet all files from a specific category,,,"
",$(echo $romdir|cut -d/ -f4)/roms/deco_cassette < (  60+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/DECO/' ${rompack_link_info[1]} $datadir/roms/deco_cassette ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/megaplay      < (  10+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/\(Mega Play\)/' ${rompack_link_info[1]} $datadir/roms/megaplay ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/neogeo        < ( 270+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@neogeo/' ${rompack_link_info[1]} $datadir/roms/neogeo ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/nintendovs    < (  50+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@nintendovs/' ${rompack_link_info[1]} $datadir/roms/nintendovs ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/playchoice10  < (  70+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/\(PlayChoice-10\)/' ${rompack_link_info[1]} $datadir/roms/playchoice10 ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",,,,"
",▼\ZrGet all files from a specific category,,,"
",$(echo $romdir|cut -d/ -f4)/roms/driving       < ( 600+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@driving@/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/driving ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/lightgun      < ( 320+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@lightgun/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/lightgun ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/maze          < ( 750+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@maze/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/maze ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/pinball       < (  40+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@pinball_arcade/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/pinball ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/puzzle        < ( 640+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@puzzle/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/puzzle ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/realistic     < ( 280+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@oro/' ${rompack_link_info[1]} $datadir/roms/realistic ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/shooter       < (2800+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@shooter@/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/shooter ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/slot_machine  < (1020+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@slot_machine/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/slot_machine ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/sports        < ( 980+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@sports/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/sports ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/upright       < (2440+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@upright/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/upright ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",,,,"
",▼\ZrGet all 90º orientated files from a specific category,,,"
",$(echo $romdir|cut -d/ -f4)/roms/deco_cassette90º < (  60+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/DECO/&&/90º/' ${rompack_link_info[1]} $datadir/roms/deco_cassette90º ${rompack_link_info[2]} download archive.???,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/playchoice10_90º < (  70+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/\(PlayChoice-10\)/' ${rompack_link_info[1]} $datadir/roms/playchoice10_90º ${rompack_link_info[2]} download archive.???,,,,,show_message_mamedev \"NO HELP\","
",,,,"
",▼\ZrGet all 90º orientated files from a specific category,,,"
",$(echo $romdir|cut -d/ -f4)/roms/driving90º    	 < ( 110+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@driving@/&&/@90º/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/driving90º ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/maze90º        	 < ( 410+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@maze/&&/@90º/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/maze90º ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/pinball90º     	 < (  20+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@pinball_arcade/&&/@90º/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/pinball90º ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/puzzle90º      	 < ( 100+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@puzzle/&&/@90º/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/puzzle90º ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/shooter90º     	 < (1030+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@shooter@/&&/@90º/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/shooter90º ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/slot_machine90º	 < (   5+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@slot_machine/&&/@90º/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/slot_machine90º ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/sports90º      	 < ( 170+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@sports/&&/@90º/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/sports90º ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/upright90º    	 < (1450+ ) ${rompack_link_info[0]},,subform_archive_multi_downloads_mamedev '/@upright/&&/@90º/&&/@working_arcade/' ${rompack_link_info[1]} $datadir/roms/upright90º ${rompack_link_info[2]} download archive.??? yes,,,,,show_message_mamedev \"NO HELP\","
",,,,"
",▼\ZrBrowse software files and download to $(echo $romdir|cut -d/ -f4)/roms/\ZR,,,"
",$(echo $romdir|cut -d/ -f4)/roms/3ds        < 1PokemonUltraSunEURMULTi83DSPUSSYCAT,,subform_archive_download_mamedev '//&&/cia/' $datadir/roms/3ds 1PokemonUltraSunEURMULTi83DSPUSSYCAT/More%203ds%20games/ download archive.??? '' y, ,,,,show_message_mamedev \NO HELP\,"
",$(echo $romdir|cut -d/ -f4)/roms/3ds        < 3ds-cia-eshop,,subform_archive_download_mamedev '//&&/rar/' $datadir/roms/3ds 3ds-cia-eshop download archive.??? '' y, ,,,,show_message_mamedev \NO HELP\,"
",$(echo $romdir|cut -d/ -f4)/roms/3ds        < 3DSCIA_testitem1,,subform_archive_download_mamedev '//&&/rar/' $datadir/roms/3ds 3DSCIA_testitem1 download archive.??? '' y, ,,,,show_message_mamedev \NO HELP\,"
",$(echo $romdir|cut -d/ -f4)/roms/3ds        < nintendo-3ds-complete-collection,,subform_archive_download_mamedev '//&&/7z/' $datadir/roms/3ds nintendo-3ds-complete-collection download archive.??? '' y, ,,,,show_message_mamedev \NO HELP\,"
",$(echo $romdir|cut -d/ -f4)/roms/atarist    < AtariSTRomCollectionByGhostware,,subform_archive_download_mamedev '//&&/zip/' $datadir/roms/atarist AtariSTRomCollectionByGhostware download archive.??? '' y, ,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/amiga/cdtv < commodore_amiga_cdtv,,subform_archive_download_mamedev '//&&/zip/' $datadir/roms/amiga/cdtv commodore_amiga_cdtv download archive.??? '' y, ,,,,show_message_mamedev \NO HELP\,"
",$(echo $romdir|cut -d/ -f4)/roms/amiga/cd32 < RedumpAmigaCD32,,subform_archive_download_mamedev '//&&/zip/' $datadir/roms/amiga/cd32 RedumpAmigaCD32 download archive.??? '' y, ,,,,show_message_mamedev \NO HELP\,"
",$(echo $romdir|cut -d/ -f4)/roms/apple2ee   < TotalReplay,,subform_archive_download_mamedev '//&&/hdv/' $datadir/roms/apple2ee TotalReplay download archive.??? '' y, ,,,,show_message_mamedev \"Get TotalReplay harddrive image for Apple //e (e)\n\nTotal Replay (version 4.01 - released 2021-02-18 - 32 MB disk image)\n\n100s of games at your fingertips as long as your fingertips are on an Apple ][\n\nTotal Replay is a frontend for exploring and playing classic arcade games on an 8-bit Apple ][.\nSome notable features:\n- UI for searching and browsing all games\n- Screensaver mode includes hundreds of screenshots and dozens of self-running demos\n- In-game protections removed (manual lookups / code wheels / etc.)\n- Integrated game help\n- Cheat mode available on most games\n- Super hi-res box art (requires IIgs)\n- All games run directly from ProDOS (no swapping floppies!)\n\nSystem requirements:\n- Total Replay runs on any Apple ][ with 64K RAM and Applesoft in ROM\n- Some games require 128K.\n- Some games require a joystick.\n- Total Replay will automatically filter out games that do not work on your machine.\n\nAdditionally:\n- You will need a mass storage device that can mount a 32 MB ProDOS hard drive image.\n- This is supported by all major emulators.\","
",$(echo $romdir|cut -d/ -f4)/roms/apple2gs   < TotalReplay,,subform_archive_download_mamedev '//&&/hdv/' $datadir/roms/apple2gs TotalReplay download archive.??? '' y, ,,,,show_message_mamedev \"Get TotalReplay harddrive image for Apple IIgs(ROM3)\n\nTotal Replay (version 4.01 - released 2021-02-18 - 32 MB disk image)\n\n100s of games at your fingertips as long as your fingertips are on an Apple ][\n\nTotal Replay is a frontend for exploring and playing classic arcade games on an 8-bit Apple ][.\nSome notable features:\n- UI for searching and browsing all games\n- Screensaver mode includes hundreds of screenshots and dozens of self-running demos\n- In-game protections removed (manual lookups / code wheels / etc.)\n- Integrated game help\n- Cheat mode available on most games\n- Super hi-res box art (requires IIgs)\n- All games run directly from ProDOS (no swapping floppies!)\n\nSystem requirements:\n- Total Replay runs on any Apple ][ with 64K RAM and Applesoft in ROM\n- Some games require 128K.\n- Some games require a joystick.\n- Total Replay will automatically filter out games that do not work on your machine.\n\nAdditionally:\n- You will need a mass storage device that can mount a 32 MB ProDOS hard drive image.\n- This is supported by all major emulators.\","
",$(echo $romdir|cut -d/ -f4)/roms/amstradcpc < R-TYPE 2012 (Easter-Egg),,subform_archive_download_mamedev '//&&/dsk/' $datadir/roms/amstradcpc r-type-128k download archive.??? '' y, ,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/bbcb       < AcornBBCMicroRomCollectionByGhostware,,subform_archive_download_mamedev '//&&/zip/' $datadir/roms/bbcb AcornBBCMicroRomCollectionByGhostware download archive.??? '' y, ,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/cdimono1   < cd-i-1g1r-chd-perfect-collection,,subform_archive_download_mamedev '//&&/chd/' $datadir/roms/cdimono1 philips-cd-i-1g1r-chd-perfect-collection download archive.??? '' y, ,,,,show_message_mamedev \NO HELP\,"
",$(echo $romdir|cut -d/ -f4)/roms/cdimono1   < non-redump_philips-cdi,,subform_archive_download_mamedev '//&&/zip/' $datadir/roms/cdimono1 non-redump_philips-cdi download archive.??? '' y, ,,,,show_message_mamedev \NO HELP\,"
",$(echo $romdir|cut -d/ -f4)/roms/cdimono1   < philips_cd-i,,subform_archive_download_mamedev '//&&/zip/' $datadir/roms/cdimono1 philips_cd-i download archive.??? '' y, ,,,,show_message_mamedev \NO HELP\,"
",$(echo $romdir|cut -d/ -f4)/roms/cdimono1   < redumpPhilipsCdi,,subform_archive_download_mamedev '//&&/zip/' $datadir/roms/cdimono1 redumpPhilipsCdi download archive.??? '' y, ,,,,show_message_mamedev \NO HELP\,"
",$(echo $romdir|cut -d/ -f4)/roms/dreamcast  < DreamcastCollectionByGhostwareMulti-region,,subform_archive_download_mamedev '//&&/zip/' $datadir/roms/dreamcast DreamcastCollectionByGhostwareMulti-region download archive.??? '' y, ,,,,show_message_mamedev \NO HELP\,"
",$(echo $romdir|cut -d/ -f4)/roms/dreamcast  < tosecdcus20190822,,subform_archive_download_mamedev '//&&/zip/' $datadir/roms/dreamcast tosecdcus20190822 download archive.??? '' y, ,,,,show_message_mamedev \NO HELP\,"
",$(echo $romdir|cut -d/ -f4)/roms/dreamcast  < rr-sega-dreamcast (Australia),,subform_archive_download_mamedev '//&&/7z/' $datadir/roms/dreamcast rr-sega-dreamcast/bin/australia/ download archive.??? '' y, ,,,,show_message_mamedev \NO HELP\,"
",$(echo $romdir|cut -d/ -f4)/roms/dreamcast  < rr-sega-dreamcast (Europe),,subform_archive_download_mamedev '//&&/7z/' $datadir/roms/dreamcast rr-sega-dreamcast/bin/europe/ download archive.??? '' y, ,,,,show_message_mamedev \NO HELP\,"
",$(echo $romdir|cut -d/ -f4)/roms/dreamcast  < rr-sega-dreamcast (-France),,subform_archive_download_mamedev '//&&/7z/' $datadir/roms/dreamcast rr-sega-dreamcast/bin/europe/france/ download archive.??? '' y, ,,,,show_message_mamedev \NO HELP\,"
",$(echo $romdir|cut -d/ -f4)/roms/dreamcast  < rr-sega-dreamcast (-Germany),,subform_archive_download_mamedev '//&&/7z/' $datadir/roms/dreamcast rr-sega-dreamcast/bin/europe/germany/ download archive.??? '' y, ,,,,show_message_mamedev \NO HELP\,"
",$(echo $romdir|cut -d/ -f4)/roms/dreamcast  < rr-sega-dreamcast (-Italy),,subform_archive_download_mamedev '//&&/7z/' $datadir/roms/dreamcast rr-sega-dreamcast/bin/europe/italy/ download archive.??? '' y, ,,,,show_message_mamedev \NO HELP\,"
",$(echo $romdir|cut -d/ -f4)/roms/dreamcast  < rr-sega-dreamcast (-Spain),,subform_archive_download_mamedev '//&&/7z/' $datadir/roms/dreamcast rr-sega-dreamcast/bin/europe/spain/ download archive.??? '' y, ,,,,show_message_mamedev \NO HELP\,"
",$(echo $romdir|cut -d/ -f4)/roms/dreamcast  < rr-sega-dreamcast (Japan),,subform_archive_download_mamedev '//&&/7z/' $datadir/roms/dreamcast rr-sega-dreamcast/bin/japan/ download archive.??? '' y, ,,,,show_message_mamedev \NO HELP\,"
",$(echo $romdir|cut -d/ -f4)/roms/dreamcast  < rr-sega-dreamcast (Usa),,subform_archive_download_mamedev '//&&/7z/' $datadir/roms/dreamcast rr-sega-dreamcast/bin/usa/ download archive.??? '' y, ,,,,show_message_mamedev \NO HELP\,"
",$(echo $romdir|cut -d/ -f4)/roms/electron   < AcornElectronRomCollectionByGhostware,,subform_archive_download_mamedev '//&&/zip/' $datadir/roms/electron AcornElectronRomCollectionByGhostware download archive.??? '' Y,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/gx4000     < Converted_GX4000_Software,,show_message_yesno_mamedev \"Would you like to proceed with downloading gx4000 files in $datadir/roms/gx4000 Converted_GX4000_Software ?\" \"subform_archive_multi_downloads_mamedev '//' rar $datadir/roms/gx4000 Converted_GX4000_Software index.php/Converted_GX4000_Software ???.cpcwiki.??\";show_message_yesno_mamedev \"Would you like to unrar the gx4000 files in $datadir/roms/gx4000/Converted_GX4000_Software ?\nThe rar files will be removed after extracting.\" \"eval for rarfile in $datadir/roms/gx4000/Converted_GX4000_Software/*.rar;do unar -f -D -o \$datadir/roms/gx4000/Converted_GX4000_Software \\\$rarfile;rm \\\$rarfile;done;chown -R $user:$user "$datadir/roms/gx4000"\",,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/nes        < NintendoMultiRomCollectionByGhostware,,subform_archive_download_mamedev '//&&/zip/' $datadir/roms/msx NintendoMultiRomCollectionByGhostware download archive.??? '' y,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/msx        < MSXRomCollectionByGhostware,,subform_archive_download_mamedev '//&&/zip/' $datadir/roms/msx MSXRomCollectionByGhostware download archive.??? '' Y,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/msx2       < MSX2RomCollectionByGhostware,,subform_archive_download_mamedev '//&&/zip/' $datadir/roms/msx2 MSX2RomCollectionByGhostware download archive.??? '' y,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/p2000t     < Software Preservation Project,,subform_archive_multi_downloads_mamedev '//' cas $datadir/roms/p2000t 'Software Preservation Project' p2000t/software/tree/master/cassettes/games github.???,,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/pc98       < NeoKobe-NecPc-98012017-11-17,,subform_archive_download_mamedev '//&&/zip/' $datadir/roms/pc98 NeoKobe-NecPc-98012017-11-17 download archive.???,,,,,show_message_mamedev \NO HELP\,"
",$(echo $romdir|cut -d/ -f4)/roms/ti99_4a    < TOSEC_2012_04_23,,subform_archive_download_mamedev '//&&/zip /' $datadir/roms/ti99_4a Texas_Instruments_TI-99_4a_TOSEC_2012_04_23 download archive.???;clear;unzip -o $datadir/roms/ti99_4a/Texas_Instruments_TI-99_4a_TOSEC_2012_04_23.zip -d $datadir/roms/ti99_4a/;chown -R $user:$user "$datadir/roms/ti99_4a",,,,,show_message_mamedev \"NO HELP\","
",$(echo $romdir|cut -d/ -f4)/roms/x68000     < SharpX68000RomCollectionByGhostware,,subform_archive_download_mamedev '//&&/zip/' $datadir/roms/x68000 SharpX68000RomCollectionByGhostware download archive.??? '' y,,,,,show_message_mamedev \"NO HELP\","
    )
    build_menu_mamedev
#single files, need different approach
#",$(echo $romdir|cut -d/ -f4)/roms/amiga/cdtv < Amiga_CDTV_TOSEC_2009_04_18,,subform_archive_download_mamedev '//&&/zip/' $datadir/roms/amiga Amiga_CDTV_TOSEC_2009_04_18 download archive.???,,,,,show_message_mamedev \NO HELP\,"
#",$(echo $romdir|cut -d/ -f4)/roms/fmtowns    < Neo_Kobe_Fujitsu_FM_Towns_2016-02-25,,subform_archive_download_mamedev '//&&/zip/' $datadir/roms/fmtowns Neo_Kobe_Fujitsu_FM_Towns_2016-02-25 download archive.???,,,,,show_message_mamedev \NO HELP\,"
#",$(echo $romdir|cut -d/ -f4)/roms/x1         < Neo_Kobe_Sharp_X1_2016-02-25,,subform_archive_download_mamedev '//&&/zip/' $datadir/roms/x1 Neo_Kobe_Sharp_X1_2016-02-25 download archive.???,,,,,show_message_mamedev \NO HELP\,"
#",$(echo $romdir|cut -d/ -f4)/roms/x1         < Sharp_X1_TOSEC_2012_04_23,,subform_archive_download_mamedev '//&&/zip/' $datadir/roms/x1 Sharp_X1_TOSEC_2012_04_23 download archive.???,,,,,show_message_mamedev \NO HELP\,"

}


function subform_archive_download_mamedev() {
    local csv=()
    local download_csv=()
    local download_read
    local decode_html="$7"
    local get_all="$6"
    local website_url="$5"
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
"get all >(y)es/(c)ompressed:" 6 1 "$get_all" 6 30 76 100 \
"decode html: >(y)es:" 7 1 "$decode_html" 7 30 76 100 \
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
    get_all=$(echo "$manual_input" | sed -n 6p)
    decode_html=$(echo "$manual_input" | sed -n 7p)
    
    clear
    if [[ $(echo $website_url|sha1sum) == 241013beb0faf19bf5d76d74507eadecdf45348e* ]];then
	#remove the earlier added space in the search pattern with sed as it needs the regular pattern here
	[[ $get_all == y ]] && curl https://$website_url/$website_path/$rompack_name|grep "<td><a href="|cut -d '"' -f2|grep -v "/"|grep -v "ia_thumb"|awk "$(echo $search_pattern|sed 's/ //g')"|while read line;do if [[ ! -f "$destination_path/$(echo -e $(echo $line|sed -r 's/%([[:xdigit:]]{2})/\\x\1/g'))" ]];then download_file_mamedev $line "$website_url/$website_path/$rompack_name" $destination_path;sleep 0.5;else echo $(echo -e $(echo $line|sed -r 's/%([[:xdigit:]]{2})/\\x\1/g')) [Exists, probably OK];sleep 0.02;fi;done
	if [[ $get_all == c ]];then
	    if [[ ! -f "$destination_path/$rompack_name.zip" ]];then
	    echo "getting your desired file : $rompack_name.zip"
	    wget -q --show-progress --progress=bar:force -t2 -c -w1 -O "$destination_path/$rompack_name.zip" $([[ $2 != http* ]] && echo https://)$website_url/compress/$rompack_name 2>&1
	    [[ $destination_path == */BIOS/* ]] && chown -R $user:$user "$(echo $destination_path|cut -d/ -f-5)"
	    [[ $destination_path == */downloads/* ]] && chown -R $user:$user "$(echo $destination_path|cut -d/ -f-5)"
	    [[ $destination_path == */roms/* ]] && chown -R $user:$user "$(echo $destination_path|cut -d/ -f-6)"
	else
	    echo $destination_path/$rompack_name.zip [Exists, probably OK]
	    sleep 5	
	fi
	fi
	if [[ $get_all != y ]] && [[ $get_all != c ]];then
	    echo "reading the website data"
	    #sed is used to convert html url encoding to utf-8 encoding, for example %20 becomes /x20
	    #this way you don't have to make a large list with codes in sed in order to convert them all
	    #using "echo -e" makes it possible to convert the backslash codes into readable characters again
	    #however, the comma is a problem when using a CSV and using a comma as separator 
	    #then the comma in the name will break the table
	    #therefor, the code for comma %2C is converted to a different comma code %E2%80%9A
	    #that way a proper lookalike name is presented when showing the list in dialog box
		if [[ $decode_html == y ]];then
			echo -e "\nhtml encoding will be replaced, will take a bit more time\n"
			while read download_read;do download_csv+=("$download_read");done < <(curl https://$website_url/$website_path/$rompack_name|grep "<td><a href="|cut -d '"' -f2|grep -v "/"|grep -v "ia_thumb"|while read line;do echo "\",Get '$(echo -e $(echo $line|sed -r 's/%2C/%E2%80%9A/g;s/%([[:xdigit:]]{2})/\\x\1/g'))',,download_file_mamedev $line \"$website_url/$website_path/$rompack_name\" $destination_path,\"";done)
		else
			while read download_read;do download_csv+=("$download_read");done < <(curl https://$website_url/$website_path/$rompack_name|grep "<td><a href="|cut -d '"' -f2|grep -v "/"|grep -v "ia_thumb"|while read line;do echo "\",Get '$line',,download_file_mamedev $line \"$website_url/$website_path/$rompack_name\" $destination_path,\"";done)
		fi
	    IFS=$'\n' csv=($(sort -t"," -k 2 --ignore-case <<<$(awk $search_pattern<<<"${download_csv[*]}")));unset IFS
	    #we need to add '",,,,"', because otherwise the first value isn't displayed as it is reserved for the column descriptions
	    csv=( ",,,," "${csv[@]}" )
	    [[ ${!csv[@]} == 0 ]] && csv=( ",,,," ",no search results found, try again,,," )

	    build_menu_mamedev
	fi
    else
    echo "-->> ERROR : WRONG INPUT : TRY AGAIN !"
    echo "Waiting for 5 seconds..."
    echo "If more commands exist they are executed now."
    echo "Atfer that it will go back to the menu."
    sleep 5
    fi
}


#in this function all vars are with curly brackets
function subformgui_categories_automated_mamedev() {    
	#make sure that there is a database file
    [[ ! -f ${emudir}/mame/mame${rp_module_version_database}_systems_sorted_info ]] && curl -s https://raw.githubusercontent.com/FollyMaddy/RetroPie-Share/main/00-databases-00/mame/mame${rp_module_version_database}_systems_sorted_info -o ${emudir}/mame/mame${rp_module_version_database}_systems_sorted_info
	if [[ $1 == *download* ]];then
		#has been locked#    local rompack_link_info=( "mame-merged \Zb\Z2NEWEST" ".zip" "mame-merged/mame-merged" )
		local rompack_link_info=( "mame-0.264-roms-non-merged" ".zip" "\"mame-0.264-roms-non-merged/MAME 0.264 ROMs (non-merged)\"" )
	else
		#use BIOS/mame folder containing all files to make links in the roms folders
		local rompack_link_info=( "$biosdir/mame" "$6" )
	fi
    [[ $6 != refresh ]] && local csv=()
    local action="$1"
    local driver_type="$2"
    local filter1="$3"
    local filter2="$4"
    local detect_clone_save="$5"    
    local manual_input=""
    local category_read
    
    #local category_compatible
    if [[ $6 != refresh ]];then
    echo -e "Hold 'LeftShift' to show message and form.\n(try tapping 'LeftShift' if holding doesn't work !)" ;sleep 2
    if [[ $(timeout 1 $([[ $scriptdir == *ArchyPie* ]] && echo tiny)xxd -a -c 1 $(ls /dev/input/by-path/*kbd|head -n 1)|grep ": 2a") == *2a* ]];then
	show_message_mamedev "\
After selecting ok a form will be presented with filter variables.\n\
You can see the earlier predefined variables.\n\
The variables can be changed if needed.\n\
After selecting ok a list with categories is shown.\n\
\n\
The first variable is just to let you know what it is going to do.\n\
It is used to install a category, download or link category roms.\n\
The first filter is used to present (non-)arcade categories.\n\
If you only want a selection of 'good' drivers,\n\
then add  '&& /@good@/' to the first filter.\n\
The second is used to eliminate unuseful categories from the list\n\
\n\
The 'detect and save clone name' part can be enabled with 'yes'\n\
When saving or linking it will use the clone name.\n\
Be aware that using this is a bit slower than using 'no' !.\n\
Remember : clones are inside the regular roms.\n\
Clones are only loaded, when loading against the softlist, if the rom has that clonename!\n\
\n\
Be aware that there can be similar categories in arcade and non-arcade.\n\
Like, for example, 'puzzle' is in both.\n\
Installing both can give problematic results.\n\
As basically :\n\
- lr-mess will only load non-arcade\n\
- lr-mame will only load arcade\n\
Advice for now is :\n\
If they exist in both then use and install only one.\
"
    manual_input=$(\
dialog \
--no-cancel \
--default-item "${default}" \
--backtitle "${__backtitle}" \
--title "Insert the options" \
--form "" \
22 76 16 \
"What to do:" 1 1 "${action}" 1 30 76 100 \
"Driver type:" 2 1 "${driver_type}" 2 30 76 100 \
"Filter 1:" 3 1 "${filter1}" 3 30 76 100 \
"Filter 2:" 4 1 "${filter2}" 4 30 76 100 \
"detect and save clone name:" 5 1 "${detect_clone_save}" 5 30 76 100 \
"" 6 1 "" 6 0 0 0 \
"" 7 1 "" 6 0 0 0 \
"" 8 1 "" 6 0 0 0 \
"" 9 1 "" 6 0 0 0 \
2>&1 >/dev/tty \
)

    action=$(echo "$manual_input" | sed -n 1p)
    driver_type=$(echo "$manual_input" | sed -n 2p)
    filter1=$(echo "$manual_input" | sed -n 3p)
    filter2=$(echo "$manual_input" | sed -n 4p)
    detect_clone_save=$(echo "$manual_input" | sed -n 5p) 

fi
fi
    clear
    echo "reading the available databases"
    #the first value is reserved for the column descriptions and empty in the array rp_module_database_versions
    csv=( "\",,,,\"" )
	#we want backwards compatibility to the old manual install lines
	#therfor we need to keep some @<tags>@/catergories in the database that aren't particurly usefull for the automatic lists
	#for example the tag @oro@ is used for the category realistic for the older install lines
	#oro doesn't say anything so the same tag is also added as @realistic@ now which will be presented in the automatic list
	#next part of the command will present the lines from the database which we want using filter1 :
	#cat $emudir/mame/mame${rp_module_version_database}_systems_sorted_info|awk "${filter1}"
	#then sed is used to filer out the categories :
	#sed 's/Driver.*: //;s/@/\n/g'
	#after that it is sorted and the duplicates are removed with uniq
	#with filter2 we filter out the catergories we don't want in the list
	#
	#if we also want the category 'arcade' then we need to add this category somehow to the database
	#'arcade' could be the equivalent of 'working_arcade'
	#that way we can install the arcade category from the automatic list
	#athough if somehow the tag @arcade@ is missing then building up the list should be no problem but will miss arcade
	if [[ $1 == *install* ]];then
		while read category_read;do csv+=("${category_read}");done < <(
		IFS=$'\n'
		cat $emudir/mame/mame${rp_module_version_database}_systems_sorted_info|awk "${filter1}"|sed 's/Driver.*: //;s/@/\n/g'|sort|uniq|awk "${filter2}"|while read line
		do
			[[ -n ${line} ]] && if [[ ${filter1} == *@90º@* ]];then
				echo "\",$(if [[ -f $configdir/${line}90º/emulators.cfg ]];then echo 'Update ';else echo 'Install';fi ) Category => ${line}90º,${driver_type},create_00index_file_mamedev '${filter1} && /@${line}@/ && /@90º@/' ${datadir}/roms/${line}90º;install_system_mamedev ${line}90º ${line}90º '' '' 'none' '';#refresh,subformgui_categories_automated_mamedev \"$1\" \"$2\" \"$3\" \"$4\" \"$5\" \"refresh\",,,,show_message_mamedev \"This help page gives more info on force installing the arcade category :\\\n${line}90º\\\n\\\nIt will :\\\n- create the rom folder\\\n- associate the mame and lr-mess/lr-mame loaders for this folder or category\\\n- create a rom index file (0 rom-index 0) inside the specific rom folder\\\n\\\nThe created index file contains the list of games.\"";\
			else
				echo "\",$(if [[ -f $configdir/${line}/emulators.cfg ]];then echo 'Update ';else echo 'Install';fi ) Category => ${line},${driver_type},create_00index_file_mamedev '${filter1} && /@${line}@/' ${datadir}/roms/${line};install_system_mamedev ${line} ${line} '' '' 'none' '';#refresh,subformgui_categories_automated_mamedev \"$1\" \"$2\" \"$3\" \"$4\" \"$5\" \"refresh\",,,,show_message_mamedev \"This help page gives more info on force installing the arcade category :\\\n${line}\\\n\\\nIt will :\\\n- create the rom folder\\\n- associate the mame and lr-mess/lr-mame loaders for this folder or category\\\n- create a rom index file (0 rom-index 0) inside the specific rom folder\\\n\\\nThe created index file contains the list of games.\"";\
			fi
		done
		)
	else
		while read category_read;do csv+=("${category_read}");done < <(
		IFS=$'\n'
		cat $emudir/mame/mame${rp_module_version_database}_systems_sorted_info|awk "${filter1}"|sed 's/Driver.*: //;s/@/\n/g'|sort|uniq|awk "${filter2}"|while read line
		do
			[[ $1 == *download* ]] && [[ -n ${line} ]] && echo "\",Download to $(echo ${romdir}|cut -d/ -f4)/roms/${line}$([[ ${filter1} == *90º* ]] && echo 90º),,subform_archive_multi_downloads_mamedev '${filter1} && /@${line}@/' ${rompack_link_info[1]} ${datadir}/roms/${line} ${rompack_link_info[2]} download archive.??? ${detect_clone_save},,,,,show_message_mamedev \"NO HELP\",\""
			[[ $1 == *link* ]] && [[ -n ${line} ]] && echo "\",Create link in $(echo ${romdir}|cut -d/ -f4)/roms/${line}$([[ ${filter1} == *90º* ]] && echo 90º),,subform_link_multi_downloads_mamedev '${filter1} && /@${line}@/' ${rompack_link_info[1]} ${datadir}/roms/${line} ${biosdir}/mame ${detect_clone_save},,,,,show_message_mamedev \"NO HELP\",\""
		done
		)
	fi
	#check first 2 lines for debugging, if needed
	#echo ${csv[0]}
	#echo ${csv[1]}
	#read
    [[ $6 != refresh ]] && build_menu_mamedev
}



function subgui_installs_mamedev() {
#for dialog colours see "man dialog"
	local csv=()
	csv=(
",,,,,,,,,"
",Install MAME    (required install) =>  ARCADE+NON-ARCADE,,package_setup mame,,,,,show_message_mamedev \"Required :\n\nMAME is a standalone emulator and is used to emulate :\n- ARCADE (about 34000)\n- NON-ARCADE (about 4000)\n\nThis script also depends on MAME to extract the media data.\nTherfor MAME must be installed.\n\nTry to install the binary.\nThis is the fastest solution.\n\nWarning : Building from source code can take many many hours.\","
",Install LR-MESS (optional install) =>   NON-ARCADE only,,if [[ -d $rootdir/emulators/retroarch ]];then package_setup lr-mess;else show_message_mamedev \"Please install RetroArch first !\";fi,,,,,show_message_mamedev \"Should be installed :\n\nLR-MESS is a RetroArch core and is used to emulate :\n- NON-ARCADE (about 4000).\n\nTry to install the binary.\nThis is the fastest solution.\n\nWarning : Building from source code can take many many hours.\","
",Install LR-MAME (optional install) =>     ARCADE only,,if [[ -d $rootdir/emulators/retroarch ]];then package_setup lr-mame;else show_message_mamedev \"Please install RetroArch first !\";fi,,,,,show_message_mamedev \"Should be installed :\n\nLR-MAME is a RetroArch core and is used to emulate :\n- ARCADE (about 34000).\n\nTry to install the binary.\nThis is the fastest solution.\n\nWarning : Building from source code can take many many hours.\","
",Install LR-GW   (optional install) => MADRIGALS  HANDHELD,,if [[ -d $rootdir/emulators/retroarch ]];then package_setup lr-gw;if [[ -f $rootdir/libretrocores/lr-gw/gw_libretro.so ]];then delEmulator lr-gw gameandwatch;addEmulator 0 lr-gw gameandwatch \"$emudir/retroarch/bin/retroarch -L $rootdir/libretrocores/lr-gw/gw_libretro.so --config $rootdir/configs/gameandwatch/retroarch.cfg %ROM%\";addSystem lr-gw gameandwatch \".cmd .zip .7z .mgw\";mkRomDir classich;addEmulator 0 lr-gw classich \"$emudir/retroarch/bin/retroarch -L $rootdir/libretrocores/lr-gw/gw_libretro.so --config $rootdir/configs/gameandwatch/retroarch.cfg %ROM%\";addSystem lr-gw classich \".cmd .zip .7z .mgw\";download_file_with_wget emulators.cfg raw.githubusercontent.com/FollyMaddy/RetroPie-Share/main/00-filesystem-00$rootdir/configs/all $rootdir/configs/all;else delEmulator lr-gw classich;fi;else show_message_mamedev \"Please install RetroArch first !\";fi,,,,,show_message_mamedev \"lr-gw is used for running the handheld from the MADrigals romset. (.mgw)\n\nYou can get the ROM list on the RetroPie forum :\nTutorial: Handheld and Plug & Play systems with MAME\n\nAfter installing lr-gw a few patches are applied :\n- lr-gw not being the default runcommand\n- add lr-gw as runcommand to the system category classich\n- add the mame file-extensions\n  (so both mame and lr-gw files can be viewed in emulationstation)\n\nIn order to run MADrigals and mame roms without changing the runcommand on startup we will also add the file $rootdir/all/emulators.cfg. You then will be able to run the mame roms as usual and also play the madigals without changing the runcommand at startup. If somehow you already have this file then be sure you do not overwrite your own config. In that case skip the downloading.\","
",,,,"
",\Z4►Show and install mame    from gdrive binary list,,subgui_gdrive_binaries_mamedev mame $emudir 1evd5_a2Ia118kf1aqB_cVSJFj2fp6oFQ,"
",\Z6►Show and install lr-mess from gdrive binary list,,if [[ -d $rootdir/emulators/retroarch ]];then subgui_gdrive_binaries_mamedev lr-mess $rootdir/libretrocores 19cs5cvBjo5dgKOzr2gs0BcPrzS1UboTg;else show_message_mamedev \"Please install RetroArch first !\";fi,"
",\Z5►Show and install lr-mame from gdrive binary list,,if [[ -d $rootdir/emulators/retroarch ]];then subgui_gdrive_binaries_mamedev lr-mame $rootdir/libretrocores 19LXbhNDSGTaf5OxYQo3ILuUp0UShPMbx;else show_message_mamedev \"Please install RetroArch first !\";fi,"
",,,,"
	)
sleep 0.1
[[ $(timeout 1 $([[ $scriptdir == *ArchyPie* ]] && echo tiny)xxd -a -c 1 $(ls /dev/input/by-path/*kbd|head -n 1)|grep ": 2a") == *2a* ]] &&\
if [[ $(curl https://stickfreaks.com/mame/ 2>&1) == *problem* ]];then
	csv+=(
",\Z1►Insecure:\Z4►Show and install mame from stickfreaks binary list,,show_message_yesno_mamedev \"Curl says that the connection to the strickfreaks website is insecure.\nProceed at your own risk or cancel by selecting no.\" \"subgui_stickfreaks_binaries_mamedev --insecure\","
",,,,"
	)
else
	csv+=(
",\Z4►Show and install mame from stickfreaks binary list,,subgui_stickfreaks_binaries_mamedev,"
",,,,"
	)
fi
sleep 0.1
[[ $(timeout 1 $([[ $scriptdir == *ArchyPie* ]] && echo tiny)xxd -a -c 1 $(ls /dev/input/by-path/*kbd|head -n 1)|grep ": 2a") == *2a* ]] &&\
	csv+=(
",▼\Zr\Z1Experimental : Usage is for your own risk !,,,"
",\Z3Install rpi1/0 mame0255 binary (only : channelf apfm1000 ...),,\
sed -i 's/ \!armv6//g' $scriptdir/scriptmodules/emulators/mame.sh;\
curl https://raw.githubusercontent.com/matthuisman/gdrivedl/master/gdrivedl.py | python3 - https://drive.google.com/file/d/1enP_Fkpj482JJ9LI7s5Y8bamJunwgOnL -m -P "/tmp";\
rm -d -r $emudir/mame;\
unzip /tmp/mame0255-debian10-_source_patched_for_gcc8.3-rpi1_channelf_apfm1000.zip -d $emudir/;\
$scriptdir/${rootdir##*/}_packages.sh mame depends;\
configure_mame_mamedev;\
sed -i 's/\!mali/\!mali \!armv6/g' $scriptdir/scriptmodules/emulators/mame.sh;\
,,,,,show_message_mamedev \"\
This menu item does the following :\n\
- patch the mame module-script for using it temporarily on rpi1/0\n\
- get the mame binary from google-drive\n\
- extract it from /tmp to $emudir\n\
- the binary will vanish from /tmp after next reboot\n\
- get depends for mame\n\
- configure mame for ${rootdir##*/}\n\
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
$scriptdir/${rootdir##*/}_packages.sh mame depends;\
configure_mame_mamedev;\
sed -i 's/\!mali/\!mali \!armv6/g' $scriptdir/scriptmodules/emulators/mame.sh;\
,,,,,show_message_mamedev \"\
This menu item does the following :\n\
- patch the mame module-script for using it temporarily on rpi1/0\n\
- get the mame binary from google-drive\n\
- extract it from /tmp to $emudir\n\
- the binary will vanish from /tmp after next reboot\n\
- get depends for mame\n\
- configure mame for ${rootdir##*/}\n\
- Restore the mame module-script\n\n\
After this you are able to install any driver from within this script.\n\
But remember most drivers will run too slow on the rpi1/0.\n\
Only use the mame standalone runcommands.\n\
(lr-mess can be installed but is too slow on the rpi1/0)\n\
If nessasary use the runcommands with -frameskip 10.\n\n\
This installs a Debian 10 / gcc8.3 / patched source binary.\n\
The binary should work on Debian 10/11 based OSes.\n\
\","
	)
#",▼\Zr\Z1Usage is for your own risk and very experimental !,,,"
#",\Z1Install lr-mame/lr-mess binary (x86/x86_64) <= libretro buildbot,,install-lr-mame-for-x86-or-x86_64,"
	build_menu_mamedev
}


function subform_archive_multi_downloads_mamedev() {

	local detect_clone_save="$7"
    local website_url="$6"
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
"detect and save clone name:" 7 1 "$detect_clone_save" 7 30 76 100 \
2>&1 >/dev/tty \
)

    website_url=$(echo "$manual_input" | sed -n 1p)
    website_path=$(echo "$manual_input" | sed -n 2p)
    rompack_name=$(echo "$manual_input" | sed -n 3p)
    destination_path=$(echo "$manual_input" | sed -n 4p)
    file_extension=$(echo "$manual_input" | sed -n 5p)
    search_input=$(echo "$manual_input" | sed -n 6p)
    detect_clone_save=$(echo "$manual_input" | sed -n 7p)   

    clear
    if [[ $(echo $website_url|sha1sum) == 241013beb0faf19bf5d76d74507eadecdf45348e* ]];then
    mkdir -p $destination_path
    read_data_mamedev clear
    IFS=$'\n' restricted_download_csv=($(cut -d "," -f 2 <<<$(awk $search_input<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))));unset IFS
    for rd in ${!restricted_download_csv[@]};do 
    #echo ${restricted_download_csv[$rd]}
    #sleep 0.3
    #show a wget progress bar => https://stackoverflow.com/questions/4686464/how-can-i-show-the-wget-progress-bar-only

    echo "busy with ${restricted_download_csv[$rd]}$file_extension"
    #display onle the lines "Nothing to do." "Not Found." and progress "%" using awk or grep command : awk '/do\./||/Found\./||/\%/' : grep -E 'do\.|Found\.|%'
	if [[ $detect_clone_save == yes ]];then
		if [[ -n $($emudir/mame/mame -listxml "${restricted_download_csv[$rd]}"|awk '/cloneof=/'|cut -d\" -f6) ]];then
		echo clone detected, saving $($emudir/mame/mame -listxml "${restricted_download_csv[$rd]}"|awk '/cloneof=/'|cut -d\" -f6)$file_extension as ${restricted_download_csv[$rd]}$file_extension
		wget -q --show-progress --progress=bar:force -t2 -c -w1 "https://$website_url/$website_path/$rompack_name/$($emudir/mame/mame -listxml "${restricted_download_csv[$rd]}"|awk '/cloneof=/'|cut -d\" -f6)$file_extension" -O $destination_path/${restricted_download_csv[$rd]}$file_extension 2>&1
		else 
		wget -q --show-progress --progress=bar:force -t2 -c -w1 -P $destination_path "https://$website_url/$website_path/$rompack_name/${restricted_download_csv[$rd]}$file_extension" 2>&1
		fi
	else 
	wget -q --show-progress --progress=bar:force -t2 -c -w1 -P $destination_path "https://$website_url/$website_path/$rompack_name/${restricted_download_csv[$rd]}$file_extension" 2>&1
	fi
    done
    elif [[ $(echo $website_url|sha1sum) == 91f709654529299145e9eb45ce1ca1e19796edab* ]];then
	wget -q --show-progress --progress=bar:force -t2 -c -w1 -r -l 1 https://$website_url/$website_path -P $destination_path/$rompack_name -A $file_extension -nd 2>&1
    elif [[ $(echo $website_url|sha1sum) == fb27d3b6f43131c8ad026024f3e3b9cfa0686d4c* ]];then
	download_from_github_mamedev $website_path $destination_path $file_extension
    else 
    echo "-->> ERROR : WRONG INPUT : TRY AGAIN !"
    echo "Waiting for 5 seconds..."
    echo "If more commands exist they are executed now."
    echo "Atfer that it will go back to the menu."
    sleep 5
    fi
    #chown commands are in the lines for : all_in1 - tigerrz
    [[ $destination_path == */BIOS/* ]] && chown -R $user:$user "$(echo $destination_path|cut -d/ -f-5)"
	[[ $destination_path == */downloads/* ]] && chown -R $user:$user "$(echo $destination_path|cut -d/ -f-5)"
	[[ $destination_path == */roms/* ]] && chown -R $user:$user "$(echo $destination_path|cut -d/ -f-6)"
}


function subform_link_multi_downloads_mamedev() {

	local detect_clone_save="$5"
    local rompack_path="$4"
    local destination_path="$3"
    local file_extension="$2"
    if [[ $1 == *jakks* ]];then
		show_message_mamedev "Jakks has been detected. To link most jakks roms the @no_media@ filter has been removed from the filter."
		#remove @no_media@ from filter to link most jakks roms as many seem to have media but are also in the jakks list
		#not removing would mean that only a few roms are linked
		local search_input="$(echo $1|sed 's/ && \/@no_media@\///g')"
		else
		local search_input="$1"
    fi
    local manual_input=""

    manual_input=$(\
dialog \
--no-cancel \
--default-item "$default" \
--backtitle "$__backtitle" \
--title "Insert the options" \
--form "" \
22 76 16 \
"rompack path:" 1 1 "$rompack_path" 1 30 76 100 \
"destination path:" 2 1 "$destination_path" 2 30 76 100 \
"file extension:" 3 1 "$file_extension" 3 30 76 100 \
"search input:" 4 1 "$search_input" 4 30 76 100 \
"detect and save clone name:" 5 1 "$detect_clone_save" 5 30 76 100 \
2>&1 >/dev/tty \
)

    rompack_path=$(echo "$manual_input" | sed -n 1p)
    destination_path=$(echo "$manual_input" | sed -n 2p)
    file_extension=$(echo "$manual_input" | sed -n 3p)
    search_input=$(echo "$manual_input" | sed -n 4p)
    detect_clone_save=$(echo "$manual_input" | sed -n 5p)   

    clear
    mkdir -p $destination_path
    read_data_mamedev clear
    IFS=$'\n' restricted_download_csv=($(cut -d "," -f 2 <<<$(awk $search_input<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))));unset IFS
	#echo ${mamedev_csv[1]}
	#echo ${restricted_download_csv[1]}
	#read
    for rd in ${!restricted_download_csv[@]};do 
    echo "busy with ${restricted_download_csv[$rd]}$file_extension"
    #display onle the lines "Nothing to do." "Not Found." and progress "%" using awk or grep command : awk '/do\./||/Found\./||/\%/' : grep -E 'do\.|Found\.|%'
	if [[ $detect_clone_save == yes ]];then
		if [[ -n $($emudir/mame/mame -listxml "${restricted_download_csv[$rd]}"|awk '/cloneof=/'|cut -d\" -f6) ]];then
		echo clone detected, saving $($emudir/mame/mame -listxml "${restricted_download_csv[$rd]}"|awk '/cloneof=/'|cut -d\" -f6)$file_extension as ${restricted_download_csv[$rd]}$file_extension
		[[ -f "$rompack_path/$($emudir/mame/mame -listxml "${restricted_download_csv[$rd]}"|awk '/cloneof=/'|cut -d\" -f6)$file_extension" ]] && \
		ln -f "$rompack_path/$($emudir/mame/mame -listxml "${restricted_download_csv[$rd]}"|awk '/cloneof=/'|cut -d\" -f6)$file_extension" "$destination_path/${restricted_download_csv[$rd]}$file_extension" 2>&1
		else
		echo "$rompack_path/${restricted_download_csv[$rd]}$file_extension"
		[[ -f "$rompack_path/${restricted_download_csv[$rd]}$file_extension" ]] && \
		ln -f "$rompack_path/${restricted_download_csv[$rd]}$file_extension" "$destination_path/${restricted_download_csv[$rd]}$file_extension" 2>&1
		fi
	else
		[[ -f "$rompack_path/${restricted_download_csv[$rd]}$file_extension" ]] && \
		ln -f "$rompack_path/${restricted_download_csv[$rd]}$file_extension" "$destination_path/${restricted_download_csv[$rd]}$file_extension" 2>&1
	fi
    done

    #chown commands are in the lines for : all_in1 - tigerrz
    [[ $destination_path == */BIOS/* ]] && chown -R $user:$user "$(echo $destination_path|cut -d/ -f-5)"
	[[ $destination_path == */downloads/* ]] && chown -R $user:$user "$(echo $destination_path|cut -d/ -f-5)"
	[[ $destination_path == */roms/* ]] && chown -R $user:$user "$(echo $destination_path|cut -d/ -f-6)"
}


function configure_mame_mamedev() {
    #customized parts of the function "configure_mame" of the mame.sh module-script from RetroPie to get mamedev.sh fully working on ArchyPie as that function does not do the job correctly
    local system="mame"

        mkRomDir "arcade"
        mkRomDir "$system"

        # Create required MAME directories underneath the ROM directory
        local mame_sub_dir
        for mame_sub_dir in artwork cfg comments diff inp nvram samples scores snap sta; do
            mkRomDir "$system/$mame_sub_dir"
        done

        # Create a BIOS directory, where people will be able to store their BIOS files, separate from ROMs
        mkUserDir "$biosdir/$system"

        # Create the configuration directory for the MAME ini files
        moveConfigDir "$home/.mame" "$configdir/$system"

        # Create new INI files if they do not already exist
        # Create MAME config file
        local temp_ini_mame="$(mktemp)"
        local mameinstalldir="$rootdir/emulators/mame"

        iniConfig " " "" "$temp_ini_mame"
        iniSet "rompath"            "$romdir/$system;$romdir/arcade;$biosdir/$system"
        iniSet "hashpath"           "$mameinstalldir/hash"
        iniSet "samplepath"         "$romdir/$system/samples;$romdir/arcade/samples"
        iniSet "artpath"            "$romdir/$system/artwork;$romdir/arcade/artwork"
        iniSet "ctrlrpath"          "$mameinstalldir/ctrlr"
        iniSet "pluginspath"        "$mameinstalldir/plugins"
        iniSet "languagepath"       "$mameinstalldir/language"

        iniSet "cfg_directory"      "$romdir/$system/cfg"
        iniSet "nvram_directory"    "$romdir/$system/nvram"
        iniSet "input_directory"    "$romdir/$system/inp"
        iniSet "state_directory"    "$romdir/$system/sta"
        iniSet "snapshot_directory" "$romdir/$system/snap"
        iniSet "diff_directory"     "$romdir/$system/diff"
        iniSet "comment_directory"  "$romdir/$system/comments"

        iniSet "skip_gameinfo" "1"
        iniSet "plugin" "hiscore"
        iniSet "samplerate" "44100"

        # Raspberry Pis show improved performance using accelerated mode which enables SDL_RENDERER_TARGETTEXTURE.
        # On RPI4 it uses OpenGL as a renderer, while on earlier RPIs it uses OpenGLES2 as the renderer. 
        # X86 Ubuntu by default uses OpenGL as a renderer, but SDL doesn't have target texture enabled as default.
        # Enabling accel will use target texture on X86 Ubuntu (and likely other X86 Linux platforms).
        iniSet "video" "accel"

        copyDefaultConfig "$temp_ini_mame" "$configdir/$system/mame.ini"
        rm "$temp_ini_mame"

        # Create MAME UI config file
        local temp_ini_ui="$(mktemp)"
        iniConfig " " "" "$temp_ini_ui"
        iniSet "scores_directory" "$romdir/$system/scores"
        copyDefaultConfig "$temp_ini_ui" "$configdir/$system/ui.ini"
        rm "$temp_ini_ui"

        # Create MAME Plugin config file
        local temp_ini_plugin="$(mktemp)"
        iniConfig " " "" "$temp_ini_plugin"
        iniSet "hiscore" "1"
        copyDefaultConfig "$temp_ini_plugin" "$configdir/$system/plugin.ini"
        rm "$temp_ini_plugin"

        # Create MAME Hi Score config file
        local temp_ini_hiscore="$(mktemp)"
        iniConfig " " "" "$temp_ini_hiscore"
        iniSet "hi_path" "$romdir/$system/scores"
        copyDefaultConfig "$temp_ini_hiscore" "$configdir/$system/hiscore.ini"
        rm "$temp_ini_hiscore"

    addEmulator 0 "mame" "arcade" "$mameinstalldir/mame %BASENAME%"
    addEmulator 1 "mame" "$system" "$mameinstalldir/mame %BASENAME%"

    addSystem "arcade"
    addSystem "$system"
}


function create_00index_file_mamedev() {

    local destination_path="$2"
    local search_input="$1"
    local index_file="0 rom-index 0"
    clear
    mkdir -p $destination_path
    read_data_mamedev clear
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
    read_data_mamedev clear
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
        local cmd=(dialog --colors --no-collapse --help-button --default-item "$default" --backtitle "$__backtitle" --menu "Version ${rp_module_version}                                    (using database ${rp_module_version_database})" 22 76 16)
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
	    #debug
	    #echo $run;echo press;read
	    
	    #break the running function
	    [[ $run == *#break* ]] && break
	    #refresh the csv array from the running function and update the menu
	    if [[ $run == *#refresh* ]];then
			local options=()
			IFS=","
			run="$(set ${csv[$choice]};echo $5)"
			eval $run refresh
			for i in ${!csv[@]}; do set ${csv[$i]}; options+=("$i" "$2");done
			#remove option 0 (value 0 and 1) so the menu begins with 1
			unset 'options[0]'; unset 'options[1]' 
	    fi

        else
            break
        fi
    done
    unset IFS
}


function install_binary_from_gdrive_mamedev () {
#$1=mame/lr-mess/lr-mame $2=destination-path $3=binary-name $4=gdrive_file_id
echo "remove current $1"
rm -r $2/$1 2>&-
mkdir -p $2/$1 2>&-
echo "get $1 binary from gdrive and install it"
su $user -c "curl https://raw.githubusercontent.com/matthuisman/gdrivedl/master/gdrivedl.py | /home/$user/.local/bin/uv run --python 3.11 - https://drive.google.com/file/d/$4 -m -P \"/tmp\"";\
[[ $3 == *zip ]] && unzip /tmp/$3 -d $2
[[ $3 == *7z ]] && 7za x /tmp/$3 -o$2
$scriptdir/${rootdir##*/}_packages.sh $1 depends
if [[ $1 == mame ]];then
	configure_$1_mamedev
	chmod -R 755 $rootdir/emulators/mame #fix permission issues with stickfreaks binaries
fi
[[ $1 == lr* ]] && $scriptdir/${rootdir##*/}_packages.sh $1 configure
}


function install_mame_from_stickfreaks_mamedev () {
echo "remove current mame"
rm -r $emudir/mame 2>&-
mkdir -p $emudir/mame 2>&-
echo "get mame binary from stickfreaks and install it"
#$1=mame-binary $2=folder (if older binary then "old/" otherwise empty)
wget -c https://stickfreaks.com/mame/$2$1 $emudir/mame -P $emudir/mame
7za x $emudir/mame/*.7z -o$emudir/mame/
strip $emudir/mame/mame
$scriptdir/${rootdir##*/}_packages.sh mame depends
configure_mame_mamedev
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
    rp_registerAllModules
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
		#install and use my patched runcommand.sh with extra replacement tokens or restore to the original without ...
		if [[ -f $rootdir/supplementary/runcommand/runcommand.sh ]];then
			if [[ $(sha1sum $rootdir/supplementary/runcommand/runcommand.sh 2>&-) != cd620d05484350afa6186ded4e5c3ca59c6d10bd* ]];then
			echo "install patched runcommand.sh script with extra replace tokens"
			wget -q -nv -O $rootdir/supplementary/runcommand/runcommand.sh https://raw.githubusercontent.com/FollyMaddy/RetroPie-Share/main/00-scriptmodules-00/runcommand-archypie.sh
			else
			rm $rootdir/supplementary/runcommand/runcommand.sh
			cp $scriptdir/scriptmodules/supplementary/runcommand/runcommand.sh $rootdir/supplementary/runcommand/runcommand.sh
			fi
		else
		show_message_mamedev "Something went wrong :\nNo runcommand.sh detected\n\nMake sure you install it from the core packages.\nIf this somehow doesn't work then try to remove it first before installing it again."
		fi
	fi
	rp_registerAllModules
}


function install_system_mamedev() {
#if this addon doesn't function correctly then revert to 274.01
#if it does function then the others from the function "install_system_proceed_mamedev" can probably be added over here too at a later stage
#might be that some from the extra can also be added over here

#this is a subfunction to add extra options to a driver by default before using the install_system_proceed_mamedev function
#it's created so extra media slotoptions can be added
#by using this extra media slotoptions are detected for creating proper runcommands
option1="$1"
option2="$2"
option3="$3"
option4="$4"
option5="$5"
option6="$6"
option7="$7"
option8="$8"
option9="$9"
option10="${10}"
#
if [[ -z $3 ]];then
	[[ $1 == aa5000 ]] && show_message_mamedev "\
By default some extras is added for the archimedes $1:\n\
- 4M of ram\n\
- an extra floppydrive\n\
- an extra ide harddrive\n\n\
This will make the extra media options in the runcommands.\n\
You can use -hard2 for adding an extra harddrive image.\n\n\
Use the application !Configure to add the extra devices.\n\
After reset you will notice that the devices have been added.\n\n\
Be aware of the fact that games with 2 floppies do not always work when using 2 floppy drives, in that case use 1 floppy drive.\
"
	[[ $1 == aa5000 ]] && option3="-ram 4M -upc:fdc:1 35hd -upc:ide:1 hdd"
	
	#make sure the script is not cheching for using other options anymore
	option8="0"
	clear
fi
#
install_system_proceed_mamedev \
"$option1" \
"$option2" \
"$option3" \
"$option4" \
"$option5" \
"$option6" \
"$option7" \
"$option8" \
"$option9" \
"$option10"
}


function install_system_proceed_mamedev() {
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
mediafilter="none\)|\(prin|quik\)|\(memc|\(rom1|\(cart|flop\)|flop1\)|flop3\)|\(cass|dump\)|cdrm\)|hard\)|\(hard1|\(hard2|\(min|\(mout|\(ssd|\(dpak"

#string for adding extra extensions 
addextensions=".zip .7z"

#string for adding extra extensions for retroarch cores
addextensionscmd=".cmd"

#check if the system is arcade or non-arcade for switching between lr-mess and lr-mame
#check also when doing a direct install and set when using option 10
if [[ ${csv[$choice]} == *@non-arcad* || ${10} == *non-arcade* ]]
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
#a system that can be detected (gameandwatch), already in RetroPie / ArchyPie naming for normal matching
#using @DTEAM naming for compatibitity with possible existing es-themes
#hoping this will be the future RetroPie / ArchyPie naming for these handhelds
#this is an example command to extract the systems and add them here to the array :
#classich=( "\"$(cat mame_systems_dteam_classich|cut -d " " -f2)\"" );echo ${classich[@]}|sed 's/ /\" \"/g'

if [[ ${csv[$choice]} != *@skip* ]];then
read_data_mamedev
echo "read the mame romset groups, used for $(echo $romdir|cut -d/ -f4) naming"
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
 sports=($(cut -d "," -f 2 <<<$(awk '/@sports/&&/@working_arcade/'<<<$(sed 's/\" \"/\"\n\"/g'<<<"${mamedev_csv[*]}"))))
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
echo "no option detected, nothing to do"
exit
fi


#part 4 : extract system data to array
#first part from the if function is meant for installing systems with extra options or special software cartridges,
#that can't be extracted from mame with -listslots
#if added more than one option then we have added extra information about extra predefined options and it's usable media
#then $1=system $2=RPsystemName $3=ExtraPredefinedOption(s) $4=mediadescription $5=media $6=extension(s)
if [[ -n "$2" ]]; then
echo "read the system driver name from the commandline options"
echo "read the $(echo $romdir|cut -d/ -f4) system name from commandline options"
echo "read the ExtraPredefinedOption(s) from the commandline options"
systems+=( "$1" )
#by using the systems name as a description we don't have matches in part 10
#therefor we can force our own RetroPie / ArchyPie name 
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
while read line; do 
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
if [[ -z $line ]]; then
systems+=( "${systems[-1]}" )
ExtraPredefinedOptions+=( "$3" )
##echo ${systems[-1]} $line
else
# use the first column if seperated by a space
systems+=( "$(echo $line)" )
ExtraPredefinedOptions+=( "$3" )
fi
#use extra predefined options to alter when installing a driver from DEFAULT not installing from the section EXTRAS
#here we just check if the last index number of the array systems combined to the ExtraPredefinedOptions is empty using ${ExtraPredefinedOptions[${#systems[@]}-1]} 
#we still need to calculate the last index of the systems array to see if that value of ExtraPredefinedOptions is empty
#${systems[${#systems[@]}-1]} is typically an old way so now the new way ${systems[-1]} is used
#in contrary to installs from the EXTRAS the DEFAULT ones get the added ExtraPredefinedOptions in all runcommands
#for the installs from EXTRAS only the runcommands with the media options get ExtraPredefinedOptions in part 12, basename runcommands are skipped in part 13
if [[ -z ${ExtraPredefinedOptions[${#systems[@]}-1]} ]];then
[[ ${systems[-1]} == c64gs ]] && ExtraPredefinedOptions+=( "-joy2 joybstr" )
if [[ ${systems[-1]} == coleco ]] || [[ ${systems[-1]} == colecop ]] && [[ $(expr $rp_module_version_database + 0) -gt 264 ]];then
echo opening yes/no dialog-box
sleep 3
dialog --colors --backtitle "$__backtitle" --yesno "Select (yes) to install coleco/colecop with Super Game Module as :\n'coleco_homebrew'\n\nSelect (no) to install just coleco/colecop as :\n'coleco'\n\nRemember : you have to do TWO installs to have them both installed !" 22 76 2>&1 >/dev/tty
# Get exit status
# 0 means user hit [yes] button.
# 1 means user hit [no] button.
response=$?
case $response in
   0) ExtraPredefinedOptions+=( "-exp sgm" );;
   1) ;;
esac
clear
echo proceed....
#in part 10 the description is changed to Coleco+SGM when installing coleco/colecop with Super Game Module
fi
[[ ${systems[-1]} == astrocd* ]] && ExtraPredefinedOptions+=( "-ctrl2 joy" )
[[ ${systems[-1]} == jupace  ]] && ExtraPredefinedOptions+=( "-ram 48k" )
# carmarty fmtmarty fmtmarty2
[[ ${systems[-1]} == *marty  ]] || \
[[ ${systems[-1]} == *marty2  ]] && ExtraPredefinedOptions+=( "-ram 4M" )
# fmtowns fmtownsftv fmtownshr fmtownsmx fmtownssj fmtownsux fmtownsv03
[[ ${systems[-1]} == fmtowns  ]] || \
[[ ${systems[-1]} == fmtowns*  ]] && ExtraPredefinedOptions+=( "-ram 6M" )
# philips p2000t and p2000m
[[ ${systems[-1]} == p2000*  ]] && ExtraPredefinedOptions+=( "-ram 102K" )
#next 2 sadly don't work with lr-mess, need to find another solution
#[[ ${systems[${#systems[@]}-1]} == cpc61 ]] && ExtraPredefinedOptions+=( "-gen1 ''" )
#[[ ${systems[${#systems[@]}-1]} == cpg120 ]] && ExtraPredefinedOptions+=( "-gen1 ''" )
#the idea was to add 2 c64gs joysticks but when loading robocop2 the game got confused
#[[ ${systems[${#systems[@]}-1]} == c64gs ]] && ExtraPredefinedOptions+=( "-joy1 joybstr -joy2 joybstr" )
#both don't work with cartridges as the cartridge has to be in the slot instead of the extra ram
#[[ ${systems[${#systems[@]}-1]} == coco ]] && ExtraPredefinedOptions+=( "-ext multi -ext:multi:slot1 ram" )
#[[ ${systems[${#systems[@]}-1]} == coco3 ]] && ExtraPredefinedOptions+=( "-ext multi -ext:multi:slot1 ram" )
fi
#
done < <($emudir/mame/mame -listmedia $1 $3| grep -v -E "$namesfilter" | grep -E "$mediafilter" | cut -d " " -f 1)
fi
[[ -n ${ExtraPredefinedOptions[@]} ]] && echo "use extra predefined options for ${systems[${#systems[@]}-1]}"

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
while read line; do
# if any?, remove earlier detected system(s) from the line
substitudeline=$(echo $line | sed "s/${systems[$index]}//g")
# use the first column if seperated by a space
mediadescriptions+=( "$(echo $substitudeline | cut -d " " -f 1)" )
# use the third column if seperated by a space and remove ( ) characters and add - for media
media+=( "$(echo $substitudeline | cut -d " " -f 2 | sed s/\(/-/g | sed s/\)//g)" )
# use the second column if seperated by a ) character and cut off the first space
extensions+=( "$(echo $substitudeline | cut -d ")" -f 2 | cut -c 2-)" )
index=$(( $index + 1 ))
done < <($emudir/mame/mame -listmedia $1 $3| grep -v -E "$namesfilter" | grep -E "$mediafilter")
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

#part 8 : read RetroPie / ArchyPie systems and descriptions from the platforms.cfg
echo "read and match $(echo $romdir|cut -d/ -f4) names with mamedev names"
while read line; do
# read retropie rom directory names 
systemsrp+=( "$(echo $line | cut -d '_' -f 1)" )
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
descriptionsrp+=( "$(echo $line | \
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


#part 9 : add extra possible future/unknown RetroPie / ArchyPie names
#added because of the @DTEAM in Handheld tutorial
#!!! this name "handheld" not used by @DTEAM in Handheld tutorial !!! <=> can't extract "konamih" and "tigerh" from mamedev database, for now
systemsrp+=( "handheld" ) # can be overruled by added @DTEAM name changing
descriptionsrp+=( "handheld" ) # can be overruled by added @DTEAM name changing
#this name "jakks" is used by @DTEAM in Handheld tutorial <=> "jakks" can be extracted from mamedev database
#because "jakks" is not in the RetroPie / ArchyPie platforms we add this here for later matching
systemsrp+=( "jakks" )
descriptionsrp+=( "JAKKS" )
#this name "tigerrz" is used by @DTEAM in Handheld tutorial <=> "tigerrz" can be extracted from mamedev database
#because "tigerrz" is not in the RetroPie / ArchyPie platforms we add this here for later matching
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
systemsrp+=( "c64gs" )
descriptionsrp+=( "Commodore 64 Games System (PAL)" )
systemsrp+=( "coleco_homebrew" )
descriptionsrp+=( "Coleco+SGM" )
systemsrp+=( "dragon64" )
descriptionsrp+=( "Dragon 64" )
systemsrp+=( "sega32-cd" )
descriptionsrp+=( "Mega-CD with 32X" )
systemsrp+=( "sega32-cd" )
descriptionsrp+=( "Sega CD with 32X" )
systemsrp+=( "scv" )
descriptionsrp+=( "Super Cassette Vision (PAL)" )
systemsrp+=( "msx2" )
descriptionsrp+=( "MSX2" )
systemsrp+=( "msx2+" )
descriptionsrp+=( "MSX2+" )
systemsrp+=( "msxturbor" )
descriptionsrp+=( "MSX Turbo-R" )
systemsrp+=( "neogeo-cd" )
descriptionsrp+=( "Neo-Geo CD" )
systemsrp+=( "zemmix" )
descriptionsrp+=( "Zemmix" )
systemsrp+=( "zemmix2" )
descriptionsrp+=( "Zemmix CPC-61" )
systemsrp+=( "zemmix2" )
descriptionsrp+=( "Zemmix CPG-120" )
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


#part 10 : match the RetroPie / ArchyPie descriptions to the mamedev descriptions
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
  #so now they can be detected changed into RetroPie / ArchyPie names
  for mamedevindex in "${!descriptions[@]}"; do
    [[ "${descriptions[$mamedevindex]}" == "Adam" ]] && descriptions[$mamedevindex]="ColecoVision Adam"
    [[ "${ExtraPredefinedOptions[$mamedevindex]}" == "-exp sgm" ]] && descriptions[$mamedevindex]="Coleco+SGM"   
  done

  #check the mamedev descriptions against the RetroPie / ArchyPie descriptions
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
        #echo "match - mamedev(romdir) - ${systems[$mamedevindex]} -- rp(romdir) - ${newsystems[$mamedevindex]} (RetroPie / ArchyPie name is used)"
	lastdescriptionmatch=${descriptionsrp[$rpindex]}
      fi
    done
  done
if [[ -n "$2" ]]; then
echo "MAME information -> (Skipped)"
else
echo "MAME information -> ${systems[$mamedevindex]} (${descriptions[$mamedevindex]})"
[[ -z ${systems[$mamedevindex]} ]] && echo -e "\n!!!\nThe system variable is empty !\nNothing will be installed !\nIf you see 'unknown system' then you probably have a mismatch.\nA mismatch between the versions of the database and standalone mame.\nElse ask the developper to add specific media to the mediafilter !\n!!!\n"
fi


#part 11 : match the added @DTEAM/RetroPie descriptions to the mamedev descriptions
#create a subarray "dteam_systems" containing the arrays that have to be used here
#now only two "for loops" can be use for checking multiple arrays against the RetroPie / ArchyPie names
#note:some systems are not added because they should be recognised in a normal way
dteam_systems=("all_in1" "classich" "konamih" "tigerh" "driving" "maze" "pinball" "puzzle" "shooter" "slot_machine" "sports" "neogeo" "nintendovs" "megaplay" "playchoice10" "deco_cassette")
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
	echo "$(echo $romdir|cut -d/ -f4) install -> ${newsystems[$mamedevindex]} (Using pseudo system name / category name)"
	lastcategorymatch=true
	fi
    done
  done
done
if [[ -n "$2" ]]; then
echo "$(echo $romdir|cut -d/ -f4) install -> $2 (Using predefined pseudo system name / category name)"
else
[[ $lastcategorymatch == false ]] && [[ -n $lastdescriptionmatch ]] && echo "$(echo $romdir|cut -d/ -f4) install -> ${newsystems[$mamedevindex]} ($lastdescriptionmatch)"
[[ $lastcategorymatch == false ]] && [[ -z $lastdescriptionmatch ]] && echo "$(echo $romdir|cut -d/ -f4) install -> ${newsystems[$mamedevindex]}"
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
	if [[ $scriptdir == *RetroPie* ]];then
	    ensureSystemretroconfig "$_system"
	else
	    defaultRAConfig "$_system"
	fi
	# ensure using a custom per-fake-core config for media loaders without using softlist
	iniConfig " = " "\"" "$_custom_coreconfig"
	iniSet "mame_alternate_renderer" "enabled"
	iniSet "mame_boot_from_cli" "enabled"
	iniSet "mame_mouse_enable" "enabled"
	iniSet "mame_rotation_mode" "internal"
	iniSet "mame_softlists_enable" "disabled"
	iniSet "mame_softlists_auto_media" "disabled"
	# ensure using a custom per-fake-core config for basename loaders using softlist
	iniConfig " = " "\"" "$_basename_coreconfig"
	iniSet "mame_alternate_renderer" "enabled"
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
	if [[ $scriptdir == *RetroPie* ]];then
	    ensureSystemretroconfig "$_system"
	else
	    defaultRAConfig "$_system"
	fi
	# ensure using a custom per-fake-core config for media loaders without using softlist
	iniConfig " = " "\"" "$_custom_coreconfig"
	iniSet "mame_alternate_renderer" "enabled"
	iniSet "mame_boot_from_cli" "enabled"
	iniSet "mame_mouse_enable" "enabled"
	iniSet "mame_rotation_mode" "internal"
	iniSet "mame_softlists_enable" "disabled"
	iniSet "mame_softlists_auto_media" "disabled"
	# ensure using a custom per-fake-core config for basename loaders using softlist
	iniConfig " = " "\"" "$_basename_coreconfig"
	iniSet "mame_alternate_renderer" "enabled"
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
	if [[ -n $(cat $rootdir/supplementary/runcommand/runcommand.sh|grep "extra replace") ]];then
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
	if [[ -n $(cat $rootdir/supplementary/runcommand/runcommand.sh|grep "extra replace") ]];then
	    if [[ -f $rootdir/libretrocores/lr-mess/mamemess_libretro.so ]];then
	    #addEmulator 0 "lr-mess-cmd" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config -v -L $_mess_core %ROM%"
	    addEmulator 0 "lr-mess$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config_basename -S %DQUOTE%%ROMDIR%%DQUOTE% -s %DQUOTE%%ROMDIR%%DQUOTE% -v -L $_mess_core 'mame $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) -cfg_directory $configdir/$_system/lr-mess -c -ui_active -rompath %DQUOTE%$datadir/BIOS/mame;%ROMDIR%/%DQUOTE% $([[ -z "$2" ]]  && [[ -n ${ExtraPredefinedOptions[@]} ]] && echo ${ExtraPredefinedOptions[${#ExtraPredefinedOptions[@]}-1]}) %ADDSLOT% '%SOFTLIST%%BASENAME%''"
	    addEmulator 0 "lr-mess$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename-autoframeskip" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config_basename -S %DQUOTE%%ROMDIR%%DQUOTE% -s %DQUOTE%%ROMDIR%%DQUOTE% -v -L $_mess_core 'mame $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) -cfg_directory $configdir/$_system/lr-mess -c -ui_active -autoframeskip -rompath %DQUOTE%$datadir/BIOS/mame;%ROMDIR%/%DQUOTE% $([[ -z "$2" ]]  && [[ -n ${ExtraPredefinedOptions[@]} ]] && echo ${ExtraPredefinedOptions[${#ExtraPredefinedOptions[@]}-1]}) %ADDSLOT% '%SOFTLIST%%BASENAME%''"
	    addEmulator 0 "lr-mess$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename-frameskip_10" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config_basename -S %DQUOTE%%ROMDIR%%DQUOTE% -s %DQUOTE%%ROMDIR%%DQUOTE% -v -L $_mess_core 'mame $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) -cfg_directory $configdir/$_system/lr-mess -c -ui_active -frameskip 10 -rompath %DQUOTE%$datadir/BIOS/mame;%ROMDIR%/%DQUOTE% $([[ -z "$2" ]]  && [[ -n ${ExtraPredefinedOptions[@]} ]] && echo ${ExtraPredefinedOptions[${#ExtraPredefinedOptions[@]}-1]}) %ADDSLOT% '%SOFTLIST%%BASENAME%''"
	    fi
	else
	    if [[ -f $rootdir/libretrocores/lr-mess/mamemess_libretro.so ]];then
	    #addEmulator 0 "lr-mess-cmd" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config -v -L $_mess_core %ROM%"
	    addEmulator 0 "lr-mess$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config_basename -S $datadir/roms/$_system -s $datadir/roms/$_system -v -L $_mess_core 'mame $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) -cfg_directory $configdir/$_system/lr-mess -c -ui_active -rompath $datadir/BIOS/mame;$datadir/roms/$_system/ $([[ -z "$2" ]]  && [[ -n ${ExtraPredefinedOptions[@]} ]] && echo ${ExtraPredefinedOptions[${#ExtraPredefinedOptions[@]}-1]}) '%BASENAME%''"
	    addEmulator 0 "lr-mess$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename-autoframeskip" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config_basename -S $datadir/roms/$_system -s $datadir/roms/$_system -v -L $_mess_core 'mame $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) -cfg_directory $configdir/$_system/lr-mess -c -ui_active -autoframeskip -rompath $datadir/BIOS/mame;$datadir/roms/$_system/ $([[ -z "$2" ]]  && [[ -n ${ExtraPredefinedOptions[@]} ]] && echo ${ExtraPredefinedOptions[${#ExtraPredefinedOptions[@]}-1]}) '%BASENAME%''"
	    addEmulator 0 "lr-mess$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename-frameskip_10" "$_system" "$_retroarch_bin --config $_config --appendconfig $_add_config_basename -S $datadir/roms/$_system -s $datadir/roms/$_system -v -L $_mess_core 'mame $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) -cfg_directory $configdir/$_system/lr-mess -c -ui_active -frameskip 10 -rompath $datadir/BIOS/mame;$datadir/roms/$_system/ $([[ -z "$2" ]]  && [[ -n ${ExtraPredefinedOptions[@]} ]] && echo ${ExtraPredefinedOptions[${#ExtraPredefinedOptions[@]}-1]}) '%BASENAME%''"
	    fi
	fi
else
	# if using a patched runcommand.sh use these runcommands with extra repace tokens if not use the others without extra repace tokens
	if [[ -n $(cat $rootdir/supplementary/runcommand/runcommand.sh|grep "extra replace") ]];then
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
	if [[ -n $(cat $rootdir/supplementary/runcommand/runcommand.sh|grep "extra replace") ]];then
	addEmulator 0 "mame$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename" "$_system" "$emudir/mame/mame -rompath $datadir/BIOS/mame\\;%DQUOTE%%ROMDIR%%DQUOTE% -v -c -ui_active -state_directory %DQUOTE%%ROMDIR%/mame/sta%DQUOTE% -statename %CLEANBASENAME% -state %CLEANBASENAME% $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) $([[ $_system == *90º ]]&&echo "-rol") $([[ -z "$2" ]]  && [[ -n ${ExtraPredefinedOptions[@]} ]] && echo ${ExtraPredefinedOptions[${#ExtraPredefinedOptions[@]}-1]}) %ADDSLOT% %SOFTLIST%%BASENAME% -view %BASENAME%"
	addEmulator 0 "mame$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename-autoframeskip" "$_system" "$emudir/mame/mame -rompath $datadir/BIOS/mame\\;%DQUOTE%%ROMDIR%%DQUOTE% -v -c -ui_active -state_directory %DQUOTE%%ROMDIR%/mame/sta%DQUOTE% -statename %CLEANBASENAME% -state %CLEANBASENAME% -autoframeskip $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) $([[ $_system == *90º ]]&&echo "-rol") $([[ -z "$2" ]]  && [[ -n ${ExtraPredefinedOptions[@]} ]] && echo ${ExtraPredefinedOptions[${#ExtraPredefinedOptions[@]}-1]}) %ADDSLOT% %SOFTLIST%%BASENAME%  -view %BASENAME%"
	addEmulator 0 "mame$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename-frameskip_10" "$_system" "$emudir/mame/mame -rompath $datadir/BIOS/mame\\;%DQUOTE%%ROMDIR%%DQUOTE% -v -c -ui_active -state_directory %DQUOTE%%ROMDIR%/mame/sta%DQUOTE% -statename %CLEANBASENAME% -state %CLEANBASENAME% -frameskip 10 $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) $([[ $_system == *90º ]]&&echo "-rol") $([[ -z "$2" ]]  && [[ -n ${ExtraPredefinedOptions[@]} ]] && echo ${ExtraPredefinedOptions[${#ExtraPredefinedOptions[@]}-1]}) %ADDSLOT% %SOFTLIST%%BASENAME%  -view %BASENAME%"
	else
	addEmulator 0 "mame$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename" "$_system" "$emudir/mame/mame -rompath $datadir/BIOS/mame\\;$datadir/roms/$_system -v -c -ui_active -statename $_system/%BASENAME% $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) $([[ $_system == *90º ]]&&echo "-rol") $([[ -z "$2" ]]  && [[ -n ${ExtraPredefinedOptions[@]} ]] && echo ${ExtraPredefinedOptions[${#ExtraPredefinedOptions[@]}-1]}) %BASENAME% -view %BASENAME%"
	addEmulator 0 "mame$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename-autoframeskip" "$_system" "$emudir/mame/mame -rompath $datadir/BIOS/mame\\;$datadir/roms/$_system -v -c -ui_active -statename $_system/%BASENAME% -autoframeskip $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) $([[ $_system == *90º ]]&&echo "-rol") $([[ -z "$2" ]]  && [[ -n ${ExtraPredefinedOptions[@]} ]] && echo ${ExtraPredefinedOptions[${#ExtraPredefinedOptions[@]}-1]}) %BASENAME% -view %BASENAME%"
	addEmulator 0 "mame$(if [[ ${media[$index]} != "-none" ]];then echo -${systems[$index]};else echo ;fi)-basename-frameskip_10" "$_system" "$emudir/mame/mame -rompath $datadir/BIOS/mame\\;$datadir/roms/$_system -v -c -ui_active -statename $_system/%BASENAME% -frameskip 10 $([[ ${media[$index]} != "-none" ]] && echo ${systems[$index]}) $([[ $_system == *90º ]]&&echo "-rol") $([[ -z "$2" ]]  && [[ -n ${ExtraPredefinedOptions[@]} ]] && echo ${ExtraPredefinedOptions[${#ExtraPredefinedOptions[@]}-1]}) %BASENAME% -view %BASENAME%"
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
if [[ $8 != 0 ]];then
echo
echo ------------------------------------
echo check for extra runcommands installs
echo ------------------------------------
#${10} will be filled with non-arcade or arcade
[[ -z "$2" ]] && [[ ${systems[-1]} == apple2 ]] && install_system_mamedev apple2 apple2 '-bios autostart -gameio joy' floppydisk1 flop1 '.mfi .dfi .dsk .do .po .rti .edd .woz .nib .wav .flac' -autostart_joy '0' '' ${10}
[[ -z "$2" ]] && [[ ${systems[-1]} == ep128 ]] && install_system_mamedev ep128 ep128 basic21*-exp*exdos floppydisk flop .wav*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.img -basic21_exdos 1 '' ${10}
[[ $8 == 1 ]] && [[ ${systems[-1]} == ep128 ]] && install_system_mamedev ep128 ep128 -exp*exdos*-exp:exdos:u1:1*35dd*-flop1*isdos floppydisk2 flop2 .wav*.bin*.rom*.mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.img -exdos_isdos '0' '' ${10}
fi
}


function show_message_mamedev() {
dialog --colors --backtitle "$__backtitle" --msgbox "$1" 22 76 2>&1 >/dev/tty
}


function show_message_yesno_mamedev() {
dialog --colors --backtitle "$__backtitle" --yesno "$1" 22 76 2>&1 >/dev/tty
# Get exit status
# 0 means user hit [yes] button.
# 1 means user hit [no] button.
# 255 means user hit [Esc] key.
response=$?
case $response in
   0) $2;;
   1) ;;
   255) echo "[ESC] key pressed.";;
esac
}


function download_extra_files_mamedev() {
#when used for cheats, see https://www.mamecheat.co.uk/
#when used for samples, see https://www.progettosnaps.net/samples/
clear
echo "get the $3 file and extract the files in the correct paths to :"
echo "- $datadir/roms/mame/$3"
echo "- $datadir/BIOS/mame/$3"
echo
#$1=weblink $2=filename $3=mame-folder $4=file_within_compressed_file_if_necessary $5=uncompress_extracted__7z_file
wget -N -P /tmp $1/$2
#folderpath for mame
#${2##*/} is used  to get rid of the extra extension for the cheatfile
unzip -o /tmp/${2##*/} $4 -d $datadir/roms/mame/$3
if [[ $5 == extract_7z ]];then
7za -y x $datadir/roms/mame/$3/$4 -o$datadir/roms/mame/$3
rm $datadir/roms/mame/$3/$4
fi
chown -R $user:$user "$datadir/roms/mame/$3" 
#folderpath for lr-mame/lr-mess
unzip -o /tmp/${2##*/} $4 -d $datadir/BIOS/mame/$3
if [[ $5 == extract_7z ]];then
7za -y x $datadir/BIOS/mame/$3/$4 -o$datadir/BIOS/mame/$3
rm $datadir/BIOS/mame/$3/$4
fi
chown -R $user:$user "$datadir/BIOS/mame/$3" 
rm /tmp/${2##*/}
}


function organise_realistic_overlays_mamedev() {
rm $datadir/downloads/Orionsangels_Realistic_Overlays_For_RetroPie/Retroarch/config/MAME/* 2>&1
#the original files are hosted here (checked on 16-01-2024):
#- http://www.mediafire.com/file/q14d077q2mhcoj9/Orionsangels_Arcade_Overlays_For_Retroarch_Part1.zip/file (594 Mb) (Apr 25, 2020, 4:39 PM)
#- http://www.mediafire.com/file/s2ps82u7y6ixrgw/Orionsangels_Arcade_Overlays_For_Retroarch_Part2.zip/file (241 Mb) (May 15, 2020, 9:53 PM)
#- https://www.mediafire.com/file/hccfnym0l26cn78/Orionsangels_Arcade_Overlays_For_Retroarch_Part3.zip/file (168 Mb) (Mar 30, 2021, 6:56 AM)
#- http://www.mediafire.com/file/5d47jcbkhawuw8v/Orionsangels_Retroarch_Bezel_Collection.zip/file (described as complete archive up until ???) (1.2 Gb)
#above files can probably be used to update things in the future when needed
#next file is hosted on gdrive and most likely a selection of parts that were available at the time of creation
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
 sed -i "s|[:]|\/home\/$user\/$(echo $romdir|cut -d/ -f4)\/downloads\/Orionsangels_Realistic_Overlays_For_RetroPie\/Retroarch|g;s|[\]|\/|g" "$cfg_file"
 echo input_overlay_enable = true  >> "$cfg_file"
 echo aspect_ratio_index = \"23\" >> "$cfg_file"
 if [[ -f $rootdir/configs/all/retroarch/shaders/fake-crt-geom.glslp ]];then
 echo video_shader = \"$rootdir/configs/all/retroarch/shaders/fake-crt-geom.glslp\" >> "$cfg_file"
 else
 echo video_shader = \"$rootdir/configs/all/retroarch/shaders/crt/crt-geom.glslp\" >> "$cfg_file"
 fi
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
su $user -c "curl https://raw.githubusercontent.com/matthuisman/gdrivedl/master/gdrivedl.py | \
/home/$user/.local/bin/uv run --python 3.11 - https://drive.google.com/drive/folders/$1 -m -P \"$2\""
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
curl -s https://github.com/$1|sed 's/name/name\n/g'|grep \.$3|cut -d\" -f 3|grep \.$3|while read github_file
do 
echo downloading $github_file to $2
curl https://raw.githubusercontent.com/$(echo $1|sed 's/\/tree//g')/$(echo $github_file|sed 's/ /%20/g') > "$2/$github_file"
chown $user:$user "$2/$github_file"
done
}


function download_file_mamedev() {
clear
echo "getting your desired file : $(echo -e $(echo $1|sed -r 's/%([[:xdigit:]]{2})/\\x\1/g'))"
mkdir -p $3
#show a wget progress bar => https://stackoverflow.com/questions/4686464/how-can-i-show-the-wget-progress-bar-only
#$1=filename $2=weblink $3=to_path
#sed is used to remove html url encoding, more is described in function subform_archive_download_mamedev
if [[ ! -f "$3/$(echo -e $(echo $1|sed -r 's/%([[:xdigit:]]{2})/\\x\1/g'))" ]]; then
    wget -q --show-progress --progress=bar:force -t2 -c -w1 -O "$3/$(echo -e $(echo $1|sed -r 's/%([[:xdigit:]]{2})/\\x\1/g'))" $([[ $2 != http* ]] && echo https://)$2/$1 2>&1
else 
    read -r -p "File exists or partly exists !, do you want to Overwrite or Continue ? [O/C] " response
    if [[ "$response" =~ ^([cC])$ ]];then 
        wget -q --show-progress --progress=bar:force -t2 -c -w1 -O "$3/$(echo -e $(echo $1|sed -r 's/%([[:xdigit:]]{2})/\\x\1/g'))" $([[ $2 != http* ]] && echo https://)$2/$1 2>&1
    else
        wget -q --show-progress --progress=bar:force -t2 -w1 -O "$3/$(echo -e $(echo $1|sed -r 's/%([[:xdigit:]]{2})/\\x\1/g'))" $([[ $2 != http* ]] && echo https://)$2/$1 2>&1
    fi
fi
[[ $3 == */BIOS/* ]] && chown -R $user:$user "$(echo $3|cut -d/ -f-5)"
[[ $3 == */downloads/* ]] && chown -R $user:$user "$(echo $3|cut -d/ -f-5)"
[[ $3 == */roms/* ]] && chown -R $user:$user "$(echo $3|cut -d/ -f-6)"
}


function create_background_overlays_mamedev() {
clear
echo "extract background files from mame artwork, if available, and create custom retroarch configs for overlay's"
echo
#added handheld arrays, used for overlays
#this is an example command to extract the systems and add them here to the array :
#classich=( "\"$(cat mame_systems_dteam_classich|cut -d " " -f2)\"" );echo ${classich[@]}|sed 's/ /\" \"/g'
read_data_mamedev clear
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
        mkdir -p "$datadir/roms/$system/media/retroarch/overlays"
	#extract Background files,if existing in zip, from mame artwork files // issue not all artwork files have Background.png
        unzip $datadir/roms/mame/artwork/$game.zip Background.png -d $datadir/roms/mame/artwork 2>/dev/null
        checkforbackground=$(ls $datadir/roms/mame/artwork/Background.png 2> /dev/null)
        if [[ -n $checkforbackground ]]
        then
        mv $datadir/roms/mame/artwork/Background.png  $datadir/roms/$system/media/retroarch/overlays/$game.png 2>/dev/null
	#create configs
	cat > "$datadir/roms/$system/$game.zip.cfg" << _EOF_
input_overlay =  ~/${datadir##*/}/roms/$system/media/retroarch/overlays/$game.cfg
input_overlay_enable = true
input_overlay_opacity = 0.500000
input_overlay_scale = 1.000000
_EOF_
        cp "$datadir/roms/$system/$game.zip.cfg" "$datadir/roms/$system/$game.7z.cfg"
        #
	cat > "$datadir/roms/$system/media/retroarch/overlays/$game.cfg" << _EOF_
overlays = 1
overlay0_overlay = $game.png
overlay0_full_screen = false
overlay0_descs = 0
_EOF_
        fi 
    done
chown -R $user:$user "$datadir/roms/$system"
done
}


function create_bezel_overlays_mamedev() {
clear
echo "extract bezel files from mame artwork, if available, and create custom retroarch configs for bezels"
echo
#added handheld arrays, used for overlays
#this is an example command to extract the systems and add them here to the array :
#classich=( "\"$(cat mame_systems_dteam_classich|cut -d " " -f2)\"" );echo ${classich[@]}|sed 's/ /\" \"/g'
read_data_mamedev clear
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
        mkdir -p "$datadir/roms/$system/media/retroarch/bezels"
	#extract Bezel files,if existing in zip, from mame artwork files // not all artwork files have Bezel-16-9.png or Bezel-4-3.png
        unzip $datadir/roms/mame/artwork/$game.zip Bezel$1.png -d $datadir/roms/mame/artwork 2>/dev/null
        checkforbezel=$(ls $datadir/roms/mame/artwork/Bezel$1.png 2> /dev/null)
        if [[ -n $checkforbezel ]]
        then
        mv $datadir/roms/mame/artwork/Bezel$1.png  $datadir/roms/$system/media/retroarch/bezels/$game.png 2>/dev/null
	#create configs
	cat > "$datadir/roms/$system/$game.zip.cfg" << _EOF_
input_overlay =  ~/${datadir##*/}/roms/$system/media/retroarch/bezels/$game.cfg
input_overlay_enable = true
input_overlay_opacity = 0.700000
input_overlay_scale = 1.000000
_EOF_
        cp "$datadir/roms/$system/$game.zip.cfg" "$datadir/roms/$system/$game.7z.cfg"
        #
	cat > "$datadir/roms/$system/media/retroarch/bezels/$game.cfg" << _EOF_
overlays = 1
overlay0_overlay = $game.png
overlay0_full_screen = true
overlay0_descs = 0
_EOF_
        fi 
    done
chown -R $user:$user "$datadir/roms/$system"
done
}


