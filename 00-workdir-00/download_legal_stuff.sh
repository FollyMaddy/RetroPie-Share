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

#For downloading legal content from this thread :
#https://retropie.org.uk/forum/topic/10918/where-to-legally-acquire-content-to-play-on-retropie

rp_module_id="download_legal_stuff"
rp_module_desc="download legal stuff"
rp_module_section="config"

function depends_download_legal_stuff() {
    true
}


function gui_download_legal_stuff() {
    local csv=()
    csv=(
",Platform,path,to_do,"
",Atari 2600,,,gui_download_legal_stuff_atari2600,"
    )
    build_menu_download_legal_stuff
}


function gui_download_legal_stuff_atari2600() {
    local csv=()
    csv=(
",game_name,rom_directory,download_link,to_do,"
",Aardvark (2019).zip,atari2600,https://atariage.com/forums/applications/core/interface/file/attachment.php?id=833216,download_with_wget,"
",Bombs Away! (NTSC) 12-2017.bin,atari2600,https://atariage.com/forums/applications/core/interface/file/attachment.php?id=544819,download_with_wget,"
",Bombs Away! (PAL) 12-2017.bin,atari2600,https://atariage.com/forums/applications/core/interface/file/attachment.php?id=544820,download_with_wget,"
",Synthcart.zip,atari2600,http://www.qotile.net/files/snthcart.zip,download_with_wget,"
    )
    build_menu_download_legal_stuff
}


function download_with_wget() {
    mkdir -p "/home/pi/RetroPie/roms/$(echo ${csv[$choice]} | cut -d ',' -f 3)/00-Legal_Downloads-00"
    wget -q -nv -O "/home/pi/RetroPie/roms/$(echo ${csv[$choice]} | cut -d ',' -f 3)/00-Legal_Downloads-00/$(echo ${csv[$choice]} | cut -d ',' -f 2)" "$(echo ${csv[$choice]} | cut -d ',' -f 4)"
    chown -R $user:$user "/home/$user/RetroPie/roms/$(echo ${csv[$choice]} | cut -d ',' -f 3)"
}


function build_menu_download_legal_stuff() {
    local options=()
    local default
    local i
    for i in ${!csv[@]}; do options+=("$i" "$(echo ${csv[$i]} | cut -d ',' -f 2)");done
    #remove option 0 (value 0 and 1) so the menu begins with 1
    unset 'options[0]'; unset 'options[1]' 
    while true; do
        local cmd=(dialog --default-item "$default" --backtitle "$__backtitle" --menu "Which system would you like to add?" 22 76 16)
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        default="$choice"
        if [[ -n "$choice" ]]; then
            joy2keyStop
            joy2keyStart 0x00 0x00 kich1 kdch1 0x20 0x71
            clear
            #run what's in the fourth "column"
            $(echo ${csv[$choice]} | cut -d ',' -f 5)
            #echo $choice $(echo ${csv[$choice]} | cut -d ',' -f 3)
            #sleep 4
            joy2keyStop
            joy2keyStart
        else
            break
        fi
    done
}

