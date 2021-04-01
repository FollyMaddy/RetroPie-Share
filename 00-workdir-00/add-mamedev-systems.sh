#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="add"
rp_module_desc="RetroPie-Setup Docs Viewer"
rp_module_section="config"

function depends_add() {
    true
}

function choose_system_add() {
    #local path="$1"
    #local include="$2"
    #local exclude="$3"
    local systems=()
    local options=()
    local system
    local i=0
    while read system; do
        #system=${system//$path\//}
        systems+=("$system")
        options+=("$i" "$system")
        ((i++))
    done < <(/opt/retropie/emulators/mame/mame -listdevices | grep Driver | cut -d " " -f2 | sort)
    local default
    local file
    while true; do
        local cmd=(dialog --default-item "$default" --backtitle "$__backtitle" --menu "Which system would you like to view?" 22 76 16)
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        default="$choice"
        if [[ -n "$choice" ]]; then
            #file="${systems[choice]}"
            joy2keyStop
            joy2keyStart 0x00 0x00 kich1 kdch1 0x20 0x71
            #pandoc "$dir/docs/$file" | lynx -localhost -restrictions=all -stdin >/dev/tty
            curl https://raw.githubusercontent.com/FollyMaddy/RetroPie-Share/main/00-scripts-00/generate-systems-lr-mess_mame-2v0-alpha.sh | bash -s ${systems[$choice]} 
            echo $choice ${systems[$choice]}
            sleep 4
            joy2keyStop
            joy2keyStart
        else
            break
        fi
    done
}

function gui_add() {
    local dir="$rootdir/RetroPie-Docs"
    while true; do
        local cmd=(dialog --backtitle "$__backtitle" --menu "RetroPie-Setup Docs Viewer" 22 76 16)
        local options=()
#        if [[ -d "$dir" ]]; then
            options=(
                1 "Update RetroPie-Setup Docs"
                2 "View systems"
                3 "Remove RetroPie-Setup Docs"
            )
#        else
#            options+=("1" "Download RetroPie-Setup Docs")
#        fi
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        if [[ -n "$choice" ]]; then
            case "$choice" in
                1)
                    #gitPullOrClone "$dir" "https://github.com/RetroPie/RetroPie-Docs.git"
                    ;;
                2)
                    choose_system_add
                    ;;
                3)
                    #if [[ -d "$dir" ]]; then
                    #    rm -rf "$dir"
                    #fi
                    ;;
            esac
        else
            break
        fi
    done
}
