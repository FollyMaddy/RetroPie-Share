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
# INFORMATION ABOUT THE CSV STRUCTURE USED FOR GENERATING A GUI/SUB-GUI :
# - the first value isn't used for the menu, that way the menu begins with 1
# - this first value should be empty or contain a description of the specific column
# - make sure every line begins and ends with quotes because of possible spaces
# - just use the first and last column in excel/calc for the quotes and you should be fine
#----------------------------------------------------------------------------------------------------------------------------------------------


rp_module_id="add-ext-repos"
rp_module_desc="Add or update 3rd-party repositories"
rp_module_section="config"

function depends_add-ext-repos() {
    true
}


function gui_add-ext-repos() {
    local csv=()
    csv=(
",repository,path,to_do,"
",FollyMaddy/RetroPie-Share,FollyMaddy/RetroPie-Share/tree/main/00-scriptmodules-00,download_ext_module_scripts,"
",GeorgeMcMullen/rp-box86wine,GeorgeMcMullen/rp-box86wine/tree/main/scriptmodules,download_ext_module_scripts,"
",Exarkuniv/RetroPie-Extra,Exarkuniv/RetroPie-Extra/tree/master/scriptmodules,download_ext_module_scripts,"
",valerino/RetroPie-Setup,valerino/RetroPie-Setup/tree/master/scriptmodules,download_ext_module_scripts,"
    )
    build_menu_add-ext-repos
    rp_registerAllModules
}


function build_menu_add-ext-repos() {
    local options=()
    local default
    local i
    for i in ${!csv[@]}; do options+=("$i" "$(echo ${csv[$i]} | cut -d ',' -f 2)");done
    #remove option 0 (value 0 and 1) so the menu begins with 1
    unset 'options[0]'; unset 'options[1]' 
    while true; do
        local cmd=(dialog --default-item "$default" --backtitle "$__backtitle" --menu "Which 3rd-party repository would you like to add ?" 22 76 16)
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        default="$choice"
        if [[ -n "$choice" ]]; then
            joy2keyStop
            joy2keyStart 0x00 0x00 kich1 kdch1 0x20 0x71
            clear
            #run what's in the fourth "column"
            $(echo ${csv[$choice]} | cut -d ',' -f 4)
            #echo $choice $(echo ${csv[$choice]} | cut -d ',' -f 3)
            #sleep 4
            joy2keyStop
            joy2keyStart
        else
            break
        fi
    done
}


function download_ext_module_scripts() {
local map
local directory
local directories=()
local directories=( "emulators" "libretrocores" "ports" "supplementary" )
echo "get external module-scripts and place them in the correct path"
echo
for directory in "${directories[@]}"; do
 if [[ $(echo $(echo ${csv[$choice]} | cut -d ',' -f 2) | cut -d '/' -f 2) == "RetroPie-Setup" ]]; then
 map=$(echo $(echo ${csv[$choice]} | cut -d ',' -f 2) | cut -d '/' -f 2)_$(echo $(echo ${csv[$choice]} | cut -d ',' -f 3) | cut -d '/' -f 1)
 else
 map=$(echo $(echo ${csv[$choice]} | cut -d ',' -f 2) | cut -d '/' -f 2)
 fi
echo $map
 mkdir -p /home/$user/RetroPie-Setup/ext/$map/scriptmodules/$directory 2>&-
 curl https://github.com/$(echo ${csv[$choice]} | cut -d ',' -f 3)/$directory | sed 's/name/name\n/g'| grep "\.sh" | cut -d '"' -f 3 | while read file
  do
   #download if not in original RetroPie-Setup (-z if zero)
   if [[ -z $(find /home/$user/RetroPie-Setup/scriptmodules -name "$file") ]]; then
   curl "https://raw.githubusercontent.com/$(echo $(echo ${csv[$choice]} | cut -d ',' -f 3) | sed "s/tree\///g")/$directory/$file" > "/home/$user/RetroPie-Setup/ext/$map/scriptmodules/$directory/$file"
   fi
  done
done
chown -R $user:$user "/home/$user/RetroPie-Setup/ext/" 
rp_registerAllModules
}
