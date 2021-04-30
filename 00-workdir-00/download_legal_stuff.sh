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
",Platform,,,,,,,,to_do,"
",Arcade,,,,,,,,gui_download_legal_stuff_arcade,"
",Atari 2600,,,,,,,,gui_download_legal_stuff_atari2600,"
    )
    build_menu_download_legal_stuff
}


function gui_download_legal_stuff_arcade() {
    local csv=()
    csv=(
",description,file_name,rom_directory,download_link,,,,,to_do,"
",Circus (Exidy 1977),circus.zip,arcade,https://www.mamedev.org/roms/circus/circus.zip,,,,,download_with_wget,"
",Circus (Exidy 1977)(older version),circuso.zip,arcade,https://www.mamedev.org/roms/circus/circuso.zip,,,,,download_with_wget,"
",Robot Bowl (Exidy 1977),robotbwl.zip,arcade,https://www.mamedev.org/roms/robotbwl/robotbwl.zip,,,,,download_with_wget,"
",Car Polo (Exidy 1977),carpolo.zip,arcade,https://www.mamedev.org/roms/carpolo/carpolo.zip,,,,,download_with_wget,"
",Side Trak (Exidy 1979),sidetrac.zip,arcade,https://www.mamedev.org/roms/sidetrac/sidetrac.zip,,,,,download_with_wget,"
",Rip Cord (Exidy 1979),ripcord.zip,arcade,https://www.mamedev.org/roms/ripcord/ripcord.zip,,,,,download_with_wget,"
",Fire One (Exidy 1979),fireone.zip,arcade,https://www.mamedev.org/roms/fireone/fireone.zip,,,,,download_with_wget,"
",Crash (Exidy 1979),crash.zip,arcade,https://www.mamedev.org/roms/crash/crash.zip,,,,,download_with_wget,"
",Star Fire (Exidy 1979)(set 1),starfire.zip,arcade,https://www.mamedev.org/roms/starfire/starfire.zip,,,,,download_with_wget,"
",Star Fire (Exidy 1979)(set 2),starfirea.zip,arcade,https://www.mamedev.org/roms/starfire/starfirea.zip,,,,,download_with_wget,"
",Star Fire 2 (Exidy 1979),starfir2.zip,arcade,https://www.mamedev.org/roms/starfire/starfir2.zip,,,,,download_with_wget,"
",Targ (Exidy 1980),targ.zip,arcade,https://www.mamedev.org/roms/targ/targ.zip,,,,,download_with_wget,"
",Spectar (Exidy 1980),spectar.zip,arcade,https://www.mamedev.org/roms/spectar/spectar.zip,,,,,download_with_wget,"
",Hard Hat (Exidy 1982),hardhat.zip,arcade,https://www.mamedev.org/roms/hardhat/hardhat.zip,,,,,download_with_wget,"
",Victory (Exidy 1982),victory.zip,arcade,https://www.mamedev.org/roms/victory/victory.zip,,,,,download_with_wget,"
",Victor Banana (Exidy 1982),victorba.zip,arcade,https://www.mamedev.org/roms/victory/victorba.zip,,,,,download_with_wget,"
",Teeter Torture (Exidy 1982),teetert.zip,arcade,https://www.mamedev.org/roms/teetert/teetert.zip,,,,,download_with_wget,"
",FAX (Exidy 1983),fax.zip,arcade,https://www.mamedev.org/roms/fax/fax.zip,,,,,download_with_wget,"
",FAX 2 (Exidy 1983),fax2.zip,arcade,https://www.mamedev.org/roms/fax/fax2.zip,,,,,download_with_wget,"
",Falcons Wild - World Wide Poker (Video Klein 1990)(set 1),falcnwlda.zip,arcade,https://www.mamedev.org/roms/falcnwld/falcnwlda.zip,,,,,download_with_wget,"
",Falcons Wild - World Wide Poker (Video Klein 1990)(set 2),falcnwldb.zip,arcade,https://www.mamedev.org/roms/falcnwld/falcnwldb.zip,,,,,download_with_wget,"
",Witch Card (Video Klein 1991),witchcrde.zip,arcade,https://www.mamedev.org/roms/witchcrd/witchcrde.zip,,,,,download_with_wget,"
",Witch Game (Video Klein 1991),witchgme.zip,arcade,https://www.mamedev.org/roms/witchgme/witchgme.zip,,,,,download_with_wget,"
",Witch Strike (Video Klein 1992)(Version A),wstrike.zip,arcade,https://www.mamedev.org/roms/wstrike/wstrike.zip,,,,,download_with_wget,"
",Witch Strike (Video Klein 1992)(Version B),wstrikea.zip,arcade,https://www.mamedev.org/roms/wstrike/wstrikea.zip,,,,,download_with_wget,"
",Jolli Witch (Video Klein 1994),witchjol.zip,arcade,https://www.mamedev.org/roms/witchjol/witchjol.zip,,,,,download_with_wget,"
",Witch Jack (Video Klein 1996)(Version 0.87-89),wtchjack.zip,arcade,https://www.mamedev.org/roms/wtchjack/wtchjack.zip,,,,,download_with_wget,"
",Witch Jack (Video Klein 1996)(Version 0.87-88),wtchjacka.zip,arcade,https://www.mamedev.org/roms/wtchjack/wtchjacka.zip,,,,,download_with_wget,"
",Witch Jack (Video Klein 1996)(Version 0.87),wtchjackb.zip,arcade,https://www.mamedev.org/roms/wtchjack/wtchjackb.zip,,,,,download_with_wget,"
",Robby Roto (Bally/Midway 1981),robby.zip,arcade,https://www.mamedev.org/roms/robby/robby.zip,,,,,download_with_wget,"
",Super Tank (Video Games GmbH 1981),supertnk.zip,arcade,https://www.mamedev.org/roms/supertnk/supertnk.zip,,,,,download_with_wget,"
",Looping (Video Games GmbH 1982),looping.zip,arcade,https://www.mamedev.org/roms/looping/looping.zip,,,,,download_with_wget,"
",Gridlee (Videa 1982),gridlee.zip,arcade,https://www.mamedev.org/roms/gridlee/gridlee.zip,,,,,download_with_wget,"
",Alien Arena (Duncan Brown 1985),alienar.zip,arcade,https://www.mamedev.org/roms/alienar/alienar.zip,,,,,download_with_wget,"
    )
    build_menu_download_legal_stuff
}


function gui_download_legal_stuff_atari2600() {
    local csv=()
    csv=(
",description,file_name,rom_directory,download_link,,,,,to_do,"
",Aardvark (2019),Aardvark (2019).zip,atari2600,https://atariage.com/forums/applications/core/interface/file/attachment.php?id=833216,,,,,download_with_wget,"
",Bombs Away! (NTSC) 12-2017 Version,Bombs Away! (NTSC) 12-2017.bin,atari2600,https://atariage.com/forums/applications/core/interface/file/attachment.php?id=544819,,,,,download_with_wget,"
",Bombs Away! (PAL) 12-2017 Version,Bombs Away! (PAL) 12-2017.bin,atari2600,https://atariage.com/forums/applications/core/interface/file/attachment.php?id=544820,,,,,download_with_wget,"
",Synthcart,snthcart.zip,atari2600,http://www.qotile.net/files/snthcart.zip,,,,,download_with_wget,"
    )
    build_menu_download_legal_stuff
}


function download_with_wget() {
    mkdir -p "/home/pi/RetroPie/roms/$(echo ${csv[$choice]} | cut -d ',' -f 4)/00-Legal_Downloads-00"
    wget -nv -O "/home/pi/RetroPie/roms/$(echo ${csv[$choice]} | cut -d ',' -f 4)/00-Legal_Downloads-00/$(echo ${csv[$choice]} | cut -d ',' -f 3)" "$(echo ${csv[$choice]} | cut -d ',' -f 5)"
    chown -R $user:$user "/home/$user/RetroPie/roms/$(echo ${csv[$choice]} | cut -d ',' -f 4)"
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
            #run what's in the specific "column"
            $(echo ${csv[$choice]} | cut -d ',' -f 10)
            joy2keyStop
            joy2keyStart
        else
            break
        fi
    done
}

