#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="add-ext-repos"
rp_module_desc="Add or update external repositories"
rp_module_section="config"

function depends_add-ext-repos() {
    true
}



function gui_add-ext-repos() {
    while true; do
        local cmd=(dialog --backtitle "$__backtitle" --menu "Add or update external repositories" 22 76 16)
        local options=()
            options=(
                0 "FollyMaddy/RetroPie-Share"
                1 "GeorgeMcMullen/rp-box86wine"
                2 "zerojay/RetroPie-Extra"
                3 "valerino/RetroPie-Setup"
                4 "-"
                5 "-"
            )
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        if [[ -n "$choice" ]]; then
            case "$choice" in
                0)
                    download_ext_module_scripts
                    ;;
                1)
                    download_ext_module_scripts
                    ;;
                2)
                    download_ext_module_scripts
                    ;;
                3)
                    download_ext_module_scripts
                    ;;
                4)
                    
                    ;;
                5)
                    
                    ;;
            esac
        else
            break
        fi
    done
}


function download_ext_module_scripts() {
clear
local repository
local repositories=()
local repositories=(
"FollyMaddy/RetroPie-Share/tree/main/00-scriptmodules-00"
"GeorgeMcMullen/rp-box86wine/tree/main/scriptmodules"
"zerojay/RetroPie-Extra/tree/master/scriptmodules"
"valerino/RetroPie-Setup/tree/master/scriptmodules"
)
local map
local directory
local directories=()
local directories=( "emulators" "libretrocores" "ports" "supplementary" )
echo "get external module-scripts and place them in the correct path"
echo
#for repository in "${!repositories[@]}"; do
 for directory in "${directories[@]}"; do
 if [[ $(echo "${repositories[$choice]}" | cut -d "/" -f 2) == "RetroPie-Setup" ]]; then
 map=$(echo "${repositories[$choice]}" | cut -d "/" -f 2)_$(echo "${repositories[$choice]}" | cut -d "/" -f 1)
 else
 map=$(echo "${repositories[$choice]}" | cut -d "/" -f 2)
 fi
 mkdir -p /home/$user/RetroPie-Setup/ext/$map/scriptmodules/$directory 2>&-
 curl https://github.com/${repositories[$choice]}/$directory | grep "\.sh" | cut -d '"' -f 6 | while read file
  do
   #download if not in original RetroPie-Setup (-z if zero)
   if [[ -z $(find /home/$user/RetroPie-Setup/scriptmodules -name "$file") ]]; then
   curl "https://raw.githubusercontent.com/$(echo ${repositories[$choice]} | sed "s/tree\///g")/$directory/$file" > "/home/$user/RetroPie-Setup/ext/$map/scriptmodules/$directory/$file"
   fi
  done
 done
#done
chown -R $user:$user "/home/$user/RetroPie-Setup/ext/" 
rp_registerAllModules
}
