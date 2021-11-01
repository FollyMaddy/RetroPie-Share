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


rp_module_id="add-mamedev-systems"
rp_module_desc="Add lr-mess/MAME systems"
rp_module_section="config"


local mamedev_csv=()
local mamedev_forum_csv=()
local gamelists_csv=()


local system_read


function depends_add-mamedev-systems() {
    getDepends curl python3
}


function gui_add-mamedev-systems() {
    local csv=()
    csv=(
",menu_item,empty,to_do,"
",v HELP > required : install both (advice : install the binaries),,,"
",Install mame,,package_setup mame,"
",Install lr-mess,,package_setup lr-mess,"
",,,,"
",v HELP > optional : to use the script offline,,,"
",Save or update database locally (get data offline),,curl https://raw.githubusercontent.com/FollyMaddy/RetroPie-Share/main/00-databases-00/mame/mame0237_systems_sorted_info -o /opt/retropie/emulators/mame/mame0237_systems_sorted_info,"
",Delete database locally         (get data on-line),,rm /opt/retropie/emulators/mame/mame0237_systems_sorted_info,"
",,,,"
",v HELP > install handheld / plug&play and the required downloads,,,"
",Handheld / plug&play and downloads > Submenu,,subgui_add-mamedev-systems_forum,"
",,,,"
",v HELP > install systems with extra functions,,,"
",Systems with extras > Submenu,,subgui_add-mamedev-systems_extras,"
",,,,"
",v HELP > install from predefined sorted lists,,,"
",Systems sorted > Submenu,,subgui_add-mamedev-systems_sort,"
",,,,"
",v HELP > search on pattern(s) and install from your own list,,,"
",SEARCH and display upon descriptions,,subgui_add-mamedev-systems_search descriptions,"
",SEARCH and display upon system names,,subgui_add-mamedev-systems_search systems,"
",,,,"
",v HELP > install from lists with all systems,,,"
",All systems > Submenu,,subgui_add-mamedev-systems_all,"
",,,,"
",v HELP > browse and get online files ),,,"
",Restricted browser/downloader > Submenu,,subgui_add-mamedev-systems_downloads_wget_A,"
",^ HELP > only available with the correct input !),,,"
    )
    build_menu_add-mamedev-systems
}


function mame_data_read() {
    #here we read the systems and descriptions from mame into an array
    #by using the if function the data can be re-used, without reading it every time
    if [[ -z ${mamedev_csv[@]} ]]; then
        if [[ -f /opt/retropie/emulators/mame/mame0237_systems_sorted_info ]]; then 
    clear
    echo "Get mame0237 data:/opt/retropie/emulators/mame/mame0237_systems_sorted_info"
    echo "For speed, data will be re-used within this session"
    echo "Be patient for 20 seconds" 
    # get only the lines that begin with Driver was an issue with "grep Driver" because lines are not starting with "Driver" are detected 
    # found a solution here : https://stackoverflow.com/questions/4800214/grep-for-beginning-and-end-of-line
    # Now using this : lines that start with "D" using => grep ^[D]
    #here we use sed to convert the line to csv : the special charachter ) has to be single quoted and backslashed '\)'
    #we need to add 'echo \",,,,\";', because otherwise the first value isn't displayed as it is reserved for the column descriptions
    while read system_read;do mamedev_csv+=("$system_read");done < <(echo \",,,,\";cat /opt/retropie/emulators/mame/mame0237_systems_sorted_info|sed 's/,//g;s/Driver /\",/g;s/ ./,/;s/'\)':/,run_generator_script,/;s/\r/,,,\"/')
        else
    echo "Get mame0237 data:RetroPie-Share repository"
    echo "For speed, data will be re-used within this session"
    echo "Be patient for 20 seconds" 
    while read system_read;do mamedev_csv+=("$system_read");done < <(echo \",,,,\";curl https://raw.githubusercontent.com/FollyMaddy/RetroPie-Share/main/00-databases-00/mame/mame0237_systems_sorted_info|sed 's/,//g;s/Driver /\",/g;s/ ./,/;s/'\)':/,run_generator_script,/;s/\r/,,,\"/')
        fi
    fi
}


function subgui_add-mamedev-systems_forum() {
    local csv=()
    csv=(
",menu_item_handheld_description,to_do driver_used_for_installation,"
",All in One Handheld and Plug and Play,,run_generator_script ablmini,"
",Classic Handheld Systems,,run_generator_script alnattck,"
",Game and Watch,,run_generator_script gnw_ball,"
",JAKKS Pacific TV Games,,run_generator_script jak_batm,"
",Konami Handheld,,run_generator_script kbilly,"
",Tiger Handheld Electronics,,run_generator_script taddams,"
",Tiger R-Zone,,run_generator_script rzbatfor,"
",,,,"
",Select downloads,,subgui_add-mamedev-systems_downloads,"
    )
    build_menu_add-mamedev-systems
}


function subgui_add-mamedev-systems_extras() {
    local csv=()
    csv=(
",menu_item,empty,to_do,"
",v HELP > systems + extra hardware (working better than default),,,"
",Systems: with extra options,,choose_extra_options_add descriptions,"
",,,,"
",v HELP > experimental ! : install systems with autoboot function,,,"
",Systems: full/semi automatic boot (with/without extra options),,choose_autoboot_add descriptions,"
    )
    build_menu_add-mamedev-systems
}


function subgui_add-mamedev-systems_all() {
    local csv=()
    csv=(
",menu_item,empty,to_do,"
",All (alphabetical) upon descriptions,,subgui_add-mamedev-systems_alphabetical_order_selection descriptions,"
",All (alphabetical) upon system names,,subgui_add-mamedev-systems_alphabetical_order_selection systems,"
",,,,"
",All upon descriptions,,choose_add descriptions,"
",All upon system names,,choose_add,"
    )
    build_menu_add-mamedev-systems
}


function subgui_add-mamedev-systems_sort() {
#we can add up to 5 options per list to sort on
#
    local csv=()
    csv=(
",menu_item,empty,to_do,"
",Forum list upon descriptions,,choose_add descriptions @forum,"
",Forum list upon system names,,choose_add systems @forum,"
",,,,"
",Non-arcade upon descriptions,,choose_add descriptions @non-arcade,"
",Non-arcade upon system names,,choose_add systems @non-arcade,"
",,,,"
",Game consoles upon descriptions,,choose_add descriptions @game-console,"
",Game consoles upon system names,,choose_add systems @game-console,"
",,,,"
",Atari upon descriptions,,choose_add descriptions @non-arcade Atari,"
",Atari upon system names,,choose_add systems @non-arcade Atari,"
",,,,"
",Commodore upon descriptions,,choose_add descriptions @non-arcade Commodore,"
",Commodore upon system names,,choose_add systems @non-arcade Commodore,"
",,,,"
",Nintendo upon descriptions,,choose_add descriptions @non-arcade Nintendo,"
",Nintendo upon system names,,choose_add systems @non-arcade Nintendo,"
",,,,"
",MSX upon descriptions,,choose_add descriptions @non-arcade MSX,"
",MSX upon system names,,choose_add systems @non-arcade MSX,"
",,,,"
",Sega upon descriptions,,choose_add descriptions @non-arcade Sega,"
",Sega upon system names,,choose_add systems @non-arcade Sega,"
    )
    build_menu_add-mamedev-systems

#preserved-test-lines
#",Cabinets upon descriptions,,choose_add descriptions @cabinets,"
#",Cabinets upon systems,,choose_add systems @cabinets,"
#",(and equal test 2 opt.)SONY MSX upon descriptions,,choose_add descriptions MSX HB-F,"
#",(and equal test 2 opt.)SONY MSX upon systems,,choose_add systems MSX HB-F,"
#",(not equal test 2 opt.)MSX but no HB types upon descriptions,,choose_add descriptions HB! MSX,"
#",(not equal test 2 opt.)MSX but no HB types upon systems,,choose_add systems HB! MSX,"
#",(not equal test 1 opt.)arcade upon descriptions,,choose_add descriptions @non-arcade!,"
#",(not equal test 1 opt.)arcade upon systems,,choose_add systems @non-arcade!,"

}


function choose_extra_options_add() {
#With this csv style we can't use quotes or double quotes 
#so if we want to add more options , slotdevices or extensions we replace spaces with *
#later in the run_generator_script they are replaced again with spaces
#the options after run_generator_script are $1=system $2=RPsystemName $3=ExtraPredefinedOption(s) $4=mediadescription $5=media $6=extension(s)
    local csv=()
    csv=(
",menu_item_handheld_description,to_do driver_used_for_installation,"
",Acorn Archimedes 305 booting RISC-OS 3.10 with floppy support,,run_generator_script aa305 archimedes -bios*310 floppydisk flop .mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.ima*.img*.ufi*.360*.ipf*.adf*.ads*.adm*.adl*.apd*.jfd,"
",Acorn Archimedes 310 booting RISC-OS 3.10 with floppy support,,run_generator_script aa310 archimedes -bios*310 floppydisk flop .mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.ima*.img*.ufi*.360*.ipf*.adf*.ads*.adm*.adl*.apd*.jfd,"
",Acorn Archimedes 440+4Mb booting RISC-OS 3.10 with floppy support,,run_generator_script aa440 archimedes -bios*310*-ram*4M floppydisk flop .mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.ima*.img*.ufi*.360*.ipf*.adf*.ads*.adm*.adl*.apd*.jfd,"
",Acorn Archimedes 440/1+4Mb booting RISC-OS 3.10 with floppy support,,run_generator_script aa4401 archimedes -bios*310*-ram*4M floppydisk flop .mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.ima*.img*.ufi*.360*.ipf*.adf*.ads*.adm*.adl*.apd*.jfd,"
",APF Imagination Machine with basic and cassette support,,run_generator_script apfimag apfimag_cass basic cassette cass .wav,"
",Dragon 32 with ram and cassette only support,,run_generator_script dragon32 dragon32 -ext*ram cassette cass .wav*.cas,"
",Famicom Family BASIC (V3.0) (J) with cassette support,,run_generator_script famicom famicom_famibs30 famibs30*-exp*fc_keyboard cassette cass .wav,"
",Famicom Playbox BASIC (Prototype V0.0) with cassette support,,run_generator_script famicom famicom_pboxbas pboxbas*-exp*fc_keyboard cassette cass .wav,"
",Famicom Family BASIC (V2.1a) (J) with cassette support,,run_generator_script famicom famicom_famibs21a -cart1*'~/RetroPie/BIOS/mame/Family*BASIC*(V2.1a)*(J).zip'*-exp*fc_keyboard cassette cass .wav,"
",Famicom Disk System with floppy support,,run_generator_script famicom famicom_disksys disksys floppydisk flop .fds,"
",FM-Towns + 6M ram with floppy1 support,,run_generator_script fmtowns fmtowns -ram*6M floppydisk1 flop1 .mfi*.dfi*.hfe*.mfm*.td0*.imd*.d77*.d88*.1dd*.cqm*.cqi*.dsk*.bin,"
",FM-Towns + 6M ram with cdrom support,,run_generator_script fmtowns fmtowns -ram*6M cdrom cdrm .chd*.cue*.toc*.nrg*.gdi*.iso*.cdr,"
",Nintendo Datach with cartridge2 support,,run_generator_script nes nes_datach datach cartridge2 cart2 .prg,"
",MSX2 Sony HB-F700P + fmpac with cartridge2 support,,run_generator_script hbf700p msx fmpac cartridge2 cart2 .rom,"
",MSX2 Sony HB-F700P + fmpac with disk support,,run_generator_script hbf700p msx fmpac floppydisk flop .dsk,"
",Tandy MC-10 micro color computer + 16k with cass support,,run_generator_script mc10 mc10 -ext*ram cassette cass .wav*.cas*.c10*.k7,"
",Tandy MC-10 micro color computer + MCX-128k with cass support,,run_generator_script mc10 mc10 -ext*mcx128 cassette cass .wav*.cas*.c10*.k7,"
",Tandy TRS-80 Model III + DOS in flop1 with flop2 support,,run_generator_script trs80m3 trs80m3 -flop1*~/RetroPie/BIOS/mame/trsdos.zip floppydisk2 flop2 .mfi*.dfi*.imd*.jv3*.dsk*.dmk*.jv1,"
    )
    build_menu_add-mamedev-systems
}


function choose_autoboot_add() {
#With this csv style we can't use quotes or double quotes 
#so if we want to add more options , slotdevices or extensions we replace spaces with *
#later in the run_generator_script they are replaced again with spaces
#the options after run_generator_script are $1=system $2=RPsystemName $3=ExtraPredefinedOption(s) $4=mediadescription $5=media $6=extension(s)
    local csv=()
    csv=(
",menu_item_handheld_description,to_do driver_used_for_installation,"
",Dragon 32 + ram + cassette + cload (auto) > run (manual),,run_generator_script dragon32 dragon32-autoboot-cload -ext*ram*-autoboot_delay*2*-autoboot_command*cload\\\\\\n cassette cass .wav*.cas,"
",Dragon 32 + ram + cassette + cloadm:exec (auto),,run_generator_script dragon32 dragon32-autoboot-cloadm -ext*ram*-autoboot_delay*2*-autoboot_command*cloadm:exec\\\\\\n cassette cass .wav*.cas,"
    )
    build_menu_add-mamedev-systems
}


function subgui_add-mamedev-systems_downloads() {
    local csv=()
    csv=(
",menu_item,empty,to_do,"
",Download/update cheats,,download_cheats,"
",,,,"
",Download/update all ES gamelists with media (+/-30 min.),,download_from_google_drive 1f_jXMG0XMBdyOOBpz8CHM6AFj9vC1R6m /home/$user/RetroPie/roms,"
",Download/update gamelists with media per system > Submenu,,subgui_add-mamedev-systems_downloads_gamelists,"
",,,,"
",Download/update mame artwork (+/-30 min.),,download_from_google_drive 1sm6gdOcaaQaNUtQ9tZ5Q5WQ6m1OD2QY3 /home/$user/RetroPie/roms/mame/artwork,"
",Create lr-mess overlays from mame artwork,,create_lr-mess_overlays,"
    )
    build_menu_add-mamedev-systems
}


function subgui_add-mamedev-systems_downloads_gamelists() {
    local csv=()
    #here we read the systems and descriptions from mame into an array
    #by using the if function the data can be re-used, without reading it every time
    if [[ -z ${gamelists_csv[@]} ]]; then
    local gamelists_read
    clear
    echo "reading the individual gamelist data"
    #we need to add 'echo \",,,,\";', because otherwise the first value isn't displayed as it is reserved for the column descriptions
    while read gamelists_read;do gamelists_csv+=("$gamelists_read");done < <(echo \",,,,\";curl https://drive.google.com/embeddedfolderview?id=1f_jXMG0XMBdyOOBpz8CHM6AFj9vC1R6m#list|sed 's/https/\nhttps/g'|grep folders|sed 's/folders\//folders\"/g;s/>/"/g;s/</"/g'|while read line;do echo "\",Download/update only for '$(echo $line|cut -d '"' -f50)',,download_from_google_drive $(echo $line|cut -d '"' -f2) /home/$user/RetroPie/roms/$(echo $line|cut -d '"' -f50),\"";done)
    fi
    IFS=$'\n' csv=($(sort -t"," -d -k 2 --ignore-case <<<"${gamelists_csv[*]}"));unset IFS
    build_menu_add-mamedev-systems
}


function subgui_add-mamedev-systems_alphabetical_order_selection() {
    local csv=()
    local system_or_description=$1
    csv=( ",menu_item,empty,to_do," )
    for letter in {#,{A..Z}}
    do 
      csv+=( "\",$letter upon $system_or_description,,choose_add $system_or_description$letter,\"" )
      #echo ${csv[@]}; sleep 10
    done
    build_menu_add-mamedev-systems
}


function subgui_add-mamedev-systems_search() {
    local csv=()
    local system_or_description=$1
    local search

    search=$(dialog \
--default-item "$default" \
--backtitle "$__backtitle" \
--title "Insert up to 5 search patterns" \
--form "" \
22 76 16 \
"Search pattern(s):" 1 1 "" 1 22 76 100 \
2>&1 >/dev/tty \
)

    csv=(
",menu_item,empty,to_do,"
",Display your own sorted list,,choose_add $system_or_description $search,"
    )
    build_menu_add-mamedev-systems
}


function subgui_add-mamedev-systems_downloads_wget_A() {
#we can add up to 5 options per list to sort on
#
    local csv=()
    csv=(
",menu_item,empty,to_do,"
",mame-0.231-merged > RetroPie/BIOS/mame,,subform_add-mamedev-systems_downloads_wget_A /home/$user/RetroPie/BIOS/mame mame-0.231-merged download,"
",mame-sl > RetroPie/downloads/mame-sl,,subform_add-mamedev-systems_downloads_wget_A /home/$user/RetroPie/download/mame-sl mame-sl/mame-sl/ download,"
    )
    build_menu_add-mamedev-systems

#preserve the one file links
#",MESS-0.151.BIOS.ROMs > RetroPie/downloads,,subform_add-mamedev-systems_downloads_wget_A /home/$user/RetroPie/download MESS-0.151.BIOS.ROMs download,"
#",MAME_0.193_ROMs_bios-devices > RetroPie/downloads,,subform_add-mamedev-systems_downloads_wget_A /home/$user/RetroPie/download MAME_0.193_ROMs_bios-devices download,"
#",Mame0228 + SL > RetroPie/downloads/mame0228-sl,,subform_add-mamedev-systems_downloads_wget_A /home/$user/RetroPie/download/mame0228-sl MAME_0.228_Software_List_ROMs_machines-bios-devices download,"

}


function subform_add-mamedev-systems_downloads_wget_A() {
    local csv=()
    local download_csv=()
    local download_read
    local website_url="$4"
    local website_path="$3"
    local rompack_name="$2"
    local destination_path="$1"
    local reserved=""
    local manual_input=""

    manual_input=$(\
dialog \
--default-item "$default" \
--backtitle "$__backtitle" \
--title "Insert the options" \
--form "" \
22 76 16 \
"Website url >X (https://X/):" 1 1 "$website_url" 1 30 76 100 \
"Website path >X (/X):" 2 1 "$website_path" 2 30 76 100 \
"rompack name:" 3 1 "$rompack_name" 3 30 76 100 \
"destination path:" 4 1 "$destination_path" 4 30 76 100 \
"reserved:" 5 1 "$reserved" 5 30 76 100 \
2>&1 >/dev/tty \
)

    website_url=$(echo "$manual_input" | sed -n 1p)
    website_path=$(echo "$manual_input" | sed -n 2p)
    rompack_name=$(echo "$manual_input" | sed -n 3p)
    destination_path=$(echo "$manual_input" | sed -n 4p)
    reserved=$(echo "$manual_input" | sed -n 5p)

    clear
    if [[ $(echo $website_url|sha1sum) == 241013beb0faf19bf5d76d74507eadecdf45348e* ]];then
    echo "reading the website data"
    #we need to add 'echo \",,,,\";', because otherwise the first value isn't displayed as it is reserved for the column descriptions
    while read download_read;do download_csv+=("$download_read");done < <(echo \",,,,\";curl https://$website_url/$website_path/$rompack_name|grep "View Contents"|cut -d '"' -f2|while read line;do echo "\",Get '$line',,download_file_with_wget $line $website_url/$website_path/$rompack_name $destination_path,\"";done)
    IFS=$'\n' csv=($(sort -t"," -k 2 --ignore-case <<<"${download_csv[*]}"));unset IFS
    else
    csv=( 
",,,,"
",error : insert the correct website : try again !,,," 
)
    fi
    build_menu_add-mamedev-systems
}


function choose_add() {
    local csv=()
    mame_data_read
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
    IFS=$'\n' csv=($(sort -t"," -d -k 3 --ignore-case<<<$(awk "{IGNORECASE = 1} $([[ $2 == *\! ]] && echo \!)/"$(echo $2|sed 's/\!//')"/ && /$3/ && /$4/ && /$5/ && /$6/ || /\",,,,\"/"<<<$(sed 's/" "/"\n"/g' <<<"${mamedev_csv[*]}"))));unset IFS
    #this is an aternative but much slower
    #while read system_read; do csv+=("$system_read");done < <(IFS=$'\n';echo "${mamedev_csv[*]}"|sort -t"," -d -k 3 --ignore-case;unset IFS)
    else
    #here we store the sorted mamedev_csv values in the csv array
    #we sort on the second colunm which contain the system names
    IFS=$'\n' csv=($(sort -t"," -d -k 2 --ignore-case<<<$(awk " {IGNORECASE = 1} $([[ $2 == *\! ]] && echo \!)/"$(echo $2|sed 's/\!//')"/ && /$3/ && /$4/ && /$5/ && /$6/ || /\",,,,\"/"<<<$(sed 's/" "/"\n"/g' <<<"${mamedev_csv[*]}"))));unset IFS
    #this is an aternative but much slower
    #while read system_read; do csv+=("$system_read");done < <(IFS=$'\n';echo "${mamedev_csv[*]}"|sort -t"," -d -k 2 --ignore-case;unset IFS)
    fi

    #when the csv array is not filled, if searching patterns are not found, index 1 and above are empty
    #here we add an extra line into index 1, so an empty dialog will appear without any errors  
    [[ -z ${csv[1]} ]] && csv+=( "\",error : search pattern is not found : try again !,,,\"" )

    build_menu_add-mamedev-systems $1
}


function choose_add_forum() {
    local csv=()
    #here we read the systems and descriptions from mame into an array
    #by using the if function the data can be re-used, without reading it every time
    if [[ -z ${mamedev_forum_csv[@]} ]]; then
    local system_read
    # get only the lines that begin with Driver was an issue with "grep Driver" because lines are not starting with "Driver" are detected 
    # found a solution here : https://stackoverflow.com/questions/4800214/grep-for-beginning-and-end-of-line
    # Now using this : lines that start with "D" using => grep ^[D]
    clear
    echo "Now we are reading a forum list from the RetroPie-Share"
    echo "For speed, data will be re-used within this session"
    echo "Be patient" 
    #here we use sed to convert the line to csv : the special charachter ) has to be single quoted and backslashed '\)'
    #we need to add 'echo \",,,,\";', because otherwise the first value isn't displayed as it is reserved for the column descriptions
    while read system_read;do mamedev_forum_csv+=("$system_read");done < <(echo \",,,,\";curl https://raw.githubusercontent.com/FollyMaddy/RetroPie-Share/main/00-databases-00/mame/mame_systems_selection|sed 's/,//g;s/Driver /\",/g;s/ ./,/;s/'\)':/,run_generator_script,,,,\"/')
    fi
    #we have to do a global comparison as the alfabetical order contains also a letter in the $1
    if [[ $1 == descriptions* ]];then
    #here we store the sorted mamedev_forum_csv values in the csv array
    #we sort on the third column which contain the descriptions of the sytems
    IFS=$'\n' csv=($(sort -t"," -d -k 3 --ignore-case <<<"${mamedev_forum_csv[*]}"));unset IFS
    else
    #here we store the sorted mamedev_forum_csv values in the csv array
    #we sort on the second column which contain the system names
    IFS=$'\n' csv=($(sort -t"," -d -k 2 --ignore-case <<<"${mamedev_forum_csv[*]}"));unset IFS
    fi
    build_menu_add-mamedev-systems $1
}


function build_menu_add-mamedev-systems() {
    local options=()
    local default
    local i
    local run
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
        local cmd=(dialog --default-item "$default" --backtitle "$__backtitle" --menu "What would you like to select or install ?" 22 76 16)
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        default="$choice"
        if [[ -n "$choice" ]]; then
            joy2keyStop
            joy2keyStart 0x00 0x00 kich1 kdch1 0x20 0x71
            clear
            #run what's in the fourth "column", but with run_generator_script add the selected system
            #this is done because adding the string in the `sed` function will not work
            #and now we can paste the standalone run_generator_script within the function
            #so we can work on one run_generator_script and paste it in when it is updated
            IFS=","
            if [[ "$(set ${csv[$choice]};echo $4)" == run_generator_script ]];then 
            run="$(set ${csv[$choice]};echo $4) $(set ${csv[$choice]};echo $2)"
            else
            run="$(set ${csv[$choice]};echo $4)"
            fi
            joy2keyStop
            joy2keyStart
            unset IFS
            $run
            #next function is done inside the run_generator_script
            #rp_registerAllModules
            #sleep 4
        else
            break
        fi
    done
    unset IFS
}


function run_generator_script() {
#!/bin/bash

#
# Author : @folly
# Date   : 15/10/2021
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
generator_script_status=standalone
fi

#uncomment if the scriptmodules have to be created in the `ext` directory, it will use the normal directory if commented
#ext=/ext/RetroPie-Share

#mamedev arrays
systems=(); uniquesystems=(); mediadescriptions=(); media=(); extensions=(); allextensions=(); descriptions=()
#added for systems with a extra predefined options, slotdevices and media
ExtraPredefinedOptions=(); RPsystemNames=()

#retropie arrays
systemsrp=(); descriptionsrp=()

#create new array while matching
newsystems=()

#filter out column names and <none> media
namesfilter="\(brief|------"

#filter on usefull media, otherwise we also get many unusefull scripts
mediafilter="none\)|prin\)|quik\)|\(memc|\(rom1|\(cart|\(flop|\(cass|dump\)|cdrm\)|\(hard1|\(min|\(mout"

#string for adding extra extensions in all generated scripts
addextensions=".zip .7z"

#string for adding extra extensions in all generated command scripts
addextensionscmd=".cmd"

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
all_in1=( "ablmini" "ablpinb" "bittboy" "cybar120" "dgun2573" "dnv200fs" "fapocket" "fcpocket" "fordrace" "gprnrs1" "gprnrs16" "ii32in1" "ii8in1" "intact89" "intg5410" "itvg49" "lexiseal" "lexizeus" "lx_jg7415" "m505neo" "m521neo" "majkon" "mc_105te" "mc_110cb" "mc_138cb" "mc_7x6ss" "mc_89in1" "mc_8x6cb" "mc_8x6ss" "mc_9x6ss" "mc_aa2" "mc_cb280" "mc_dcat8" "mc_dg101" "mc_dgear" "mc_hh210" "mc_sam60" "mc_sp69" "mc_tv200" "megapad" "mgt20in1" "miwi2_7" "mysprtch" "mysprtcp" "mysptqvc" "njp60in1" "oplayer" "pdc100" "pdc150t" "pdc200" "pdc40t" "pdc50" "pjoyn50" "pjoys30" "pjoys60" "ppgc200g" "react" "reactmd" "rminitv" "sarc110" "sudopptv" "sy888b" "sy889" "techni4" "timetp36" "tmntpdc" "unk1682" "vgcaplet" "vgpmini" "vgpocket" "vjpp2" "vsplus" "zdog" "zone7in1" "zudugo" "namcons1" "namcons2" "taitons1" "taitons2" "tak_geig" "namcons1" "namcons2" "taitons1" "taitons2" "tak_geig" "tomcpin" )
classich=( "alnattck" "alnchase" "astrocmd" "bambball" "bankshot" "bbtime" "bcclimbr" "bdoramon" "bfriskyt" "bmboxing" "bmcfball" "bmsafari" "bmsoccer" "bpengo" "bultrman" "bzaxxon" "cdkong" "cfrogger" "cgalaxn" "cmspacmn" "cmsport" "cnbaskb" "cnfball" "cnfball2" "cpacman" "cpacmanr1" "cqback" "ebaskb2" "ebball" "ebball2" "ebball3" "ebknight" "edracula" "efball" "efootb4" "egalaxn2" "einvader" "einvader2" "einvaderc" "epacman2" "epacman2r" "esbattle" "esoccer" "estargte" "eturtles" "flash" "funjacks" "galaxy2" "gckong" "gdigdug" "ghalien" "ginv" "ginv1000" "ginv2000" "gjungler" "gpoker" "h2hbaseb" "h2hbaskb" "h2hfootb" "h2hhockey" "h2hsoccerc" "hccbaskb" "invspace" "kingman" "machiman" "mbaskb" "mchess" "mcompgin" "mfootb2" "mhockey" "msoccer" "msthawk" "mwcbaseb" "packmon" "pairmtch" "pbqbert" "phpball" "raisedvl" "rockpin" "splasfgt" "splitsec" "ssfball" "tbaskb" "tbreakup" "tcaveman" "tccombat" "tmpacman" "tmscramb" "tmtennis" "tmtron" "trshutvoy" "trsrescue" "ufombs" "us2pfball" "vinvader" "zackman" )
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
#first part from the if function is meant for installing systems with extra options or special software cartridges,
#that can't be extracted from mame with -listslots
#if added more than one option then we have added extra information about extra predefined options and it's usable media
#then $1=system $2=RPsystemName $3=ExtraPredefinedOption(s) $4=mediadescription $5=media $6=extension(s)
if [[ -n "$6" ]]; then
echo "read the system/description, ExtraPredefinedOption(s) and RetroPie system name from commandline options"
systems+=( "$1" )
#by using the systems name as a description we don't have matches in part 10
#therefor we can force our own RetroPie name 
#and therefor we probably have no conflict with the newsystems name
descriptions+=( "$1" )
RPsystemNames+=( "$2" )
#normally we would use this :
#ExtraPredefinedOptions+=( "$3" )
#but with using the front-end quotes can't be used in the csv style used there
#so, in the front-end, we replace the spaces with a * and filter them out here again
ExtraPredefinedOptions+=( "$(echo $3|sed 's/*/ /g')" )
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
done < <(/opt/retropie/emulators/mame/mame -listmedia $1 | grep -v -E "$namesfilter" | grep -E "$mediafilter" | cut -d " " -f 1)
fi


#part 5 : extract all extension data per system to array
#first part from the if function is meant for installing systems with extra options or special software cartridges,
#that can't be extracted from mame with -listslots
#if added more than one option then we have added extra information about extra predefined options and it's usable media
#then $1=system $2=RPsystemName $3=ExtraPredefinedOption(s) $4=mediadescription $5=media $6=extension(s)
if [[ -n "$6" ]]; then
echo read the media extension from commandline options
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
allextensions+=( "$(/opt/retropie/emulators/mame/mame -listmedia ${systems[$index]} | grep -o "\...." | tr ' ' '\n' | sort -u | tr '\n' ' ')" )
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
if [[ -n "$6" ]]; then
echo read the media data from commandline options
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
done < <(/opt/retropie/emulators/mame/mame -listmedia $1 | grep -v -E "$namesfilter" | grep -E "$mediafilter")
fi
#testline
#echo testline ${mediadescriptions[@]} ${media[@]} ${extensions[@]} 


#part 7 : do some filtering and read mamedev system descriptions into (descriptions)
#first part from the if function is meant for installing systems with extra options or special software cartridges,
#that can't be extracted from mame with -listslots
#if added more than one option then we have added extra information about extra predefined options and it's usable media
#then $1=system $2=RPsystemName $3=ExtraPredefinedOption(s) $4=mediadescription $5=media $6=extension(s)
if [[ -n "$6" ]]; then
echo skip reading computer description from mame
else
echo "read computer description(s)"
#a manual command example would be :
#/opt/retropie/emulators/mame/mame -listdevices hbf700p | grep Driver | sed s/hbf700p//g | cut -c 10- | sed s/\)\://g
#the output, stored in the (descriptions) would be :
#HB-F700P (MSX2)
#
# keep the good info and delete text in lines ( "Driver"(cut), "system"(sed), "):"(sed) )
for index in "${!systems[@]}"; do descriptions+=( "$(/opt/retropie/emulators/mame/mame -listdevices ${systems[$index]} | grep Driver | sed s/$(echo ${systems[$index]})//g | cut -c 10- | sed s/\)\://g)" ); done
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
for index in "${!systems[@]}"; do sleep 0.001; [[ -n ${allextensions[$index]} ]] && cat > "/home/$user/RetroPie-Setup$ext/scriptmodules/libretrocores/install-${newsystems[$index]}-from-mamedev-system-${systems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))${media[$index]}.sh" << _EOF_
#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="install-${newsystems[$index]}-from-mamedev-system-${systems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))${media[$index]}"
rp_module_name="${descriptions[$index]} $([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo with ${ExtraPredefinedOptions[$index]}) ${mediadescriptions[$index]} support"
rp_module_ext="$addextensions ${allextensions[$index]}"
rp_module_desc="Use lr-mess/mame emulator for (\$rp_module_name)"
rp_module_help="ROM Extensions: \$rp_module_ext\n
Above extensions are included for compatibility between different media installs.\n\n
ROM extensions only supported by this install:\n
$addextensions ${extensions[$index]}\n\n
Put games in :\n
\$romdir/$(if [[ -n ${RPsystemNames[$index]} ]];then echo ${RPsystemNames[$index]};else echo ${newsystems[$index]};fi)\n
Notes:\n
No specific BIOS info can be given here.\n
If BIOS files are needed, put them in :\n
\$biosdir/mame\n
If the system doesn't boot then check :\n
/dev/runcommand.log\n\n"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/mame/master/LICENSE.md"
rp_module_section="exp"
rp_module_flags=""

function depends_install-${newsystems[$index]}-from-mamedev-system-${systems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))${media[$index]}() {
	local _mess=\$(dirname "\$md_inst")/lr-mess/mess_libretro.so
	if [[ ! -f "\$_mess" ]]; then
		printMsgs dialog "cannot find '\$_mess' !\n\nplease install 'lr-mess' package."
		exit 1
	fi
}

function sources_install-${newsystems[$index]}-from-mamedev-system-${systems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))${media[$index]}() {
	true
}

function build_install-${newsystems[$index]}-from-mamedev-system-${systems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))${media[$index]}() {
	true
}

function install_install-${newsystems[$index]}-from-mamedev-system-${systems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))${media[$index]}() {
	true
}

function configure_install-${newsystems[$index]}-from-mamedev-system-${systems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))${media[$index]}() {
	local _mess=\$(dirname "\$md_inst")/lr-mess/mess_libretro.so
	local _retroarch_bin="\$rootdir/emulators/retroarch/bin/retroarch"
	#local _system="${newsystems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))"
	local _system="$(if [[ -n ${RPsystemNames[$index]} ]];then echo ${RPsystemNames[$index]};else echo ${newsystems[$index]};fi)"
	local _config="\$configdir/\$_system/retroarch.cfg"
	local _add_config="\$_config.add"
	local _custom_coreconfig="\$configdir/\$_system/custom-core-options.cfg"
	local _script="\$scriptdir/scriptmodules/run_mess.sh"
	local _emulatorscfg="\$configdir/\$_system/emulators.cfg"

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

	echo "enable translation ai_service for RetroArch in \$configdir/all/retroarch.cfg"
	iniConfig " = " "\"" "\$configdir/all/retroarch.cfg"
	iniSet "ai_service_enable" "true"
	iniSet "ai_service_mode" "0"
	iniSet "ai_service_pause" "true"
	iniSet "ai_service_source_lang" "0"
	iniSet "ai_service_target_lang" "1"
	iniSet "ai_service_url" "http://ztranslate.net/service?api_key=HEREISMYKEY"
	iniSet "input_ai_service" "t"
	iniSet "#input_ai_service_btn" "11"
	chown \$user:\$user "\$configdir/all/retroarch.cfg"

	# add the emulators.cfg as normal, pointing to the above script # use old mess name for booting
	# all option should work with both mame and lr-mess, although -autoframeskip is better with mame
	addEmulator 0 "lr-mess-system-${systems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))${media[$index]}" "\$_system" "\$_script \$_retroarch_bin \$_mess \$_config \\${systems[$index]} \$biosdir/mame -autoframeskip -ui_active ${ExtraPredefinedOptions[$index]} ${media[$index]} %ROM%"
	addEmulator 0 "lr-mess-system-${systems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))-game-specific${media[$index]}" "\$_system" "\$_script \$_retroarch_bin \$_mess \$_config \\${systems[$index]} \$biosdir/mame -cfg_directory \$configdir/${newsystems[$index]}/lr-mess/%BASENAME% -autoframeskip -ui_active ${ExtraPredefinedOptions[$index]} ${media[$index]} %ROM%"
	#
	addEmulator 0 "mame-system-${systems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))${media[$index]}" "\$_system" "/opt/retropie/emulators/mame/mame -v -c -ui_active ${systems[$index]} ${ExtraPredefinedOptions[$index]} ${media[$index]} %ROM%"
        addEmulator 0 "mame-system-${systems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))${media[$index]}-autoframeskip" "\$_system" "/opt/retropie/emulators/mame/mame -v -c -autoframeskip -ui_active ${systems[$index]} ${ExtraPredefinedOptions[$index]} ${media[$index]} %ROM%"
	addEmulator 0 "mame-system-${systems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))-game-specific${media[$index]}" "\$_system" "/opt/retropie/emulators/mame/mame -cfg_directory \$configdir/\$_system/mame/%BASENAME% -v -c -ui_active ${systems[$index]} ${ExtraPredefinedOptions[$index]} ${media[$index]} %ROM%"
        addEmulator 0 "mame-system-${systems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))-game-specific${media[$index]}-autoframeskip" "\$_system" "/opt/retropie/emulators/mame/mame -cfg_directory \$configdir/\$_system/mame/%BASENAME% -v -c -autoframeskip -ui_active ${systems[$index]} ${ExtraPredefinedOptions[$index]} ${media[$index]} %ROM%"

	# add system to es_systems.cfg
	#the line used by @valerino didn't work for the original RetroPie-setup 
	#therefore the information is added in a different way
	addSystem "\$_system" "${descriptions[$index]} $([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo with extra ExtraPredefinedOptions)" "$addextensions ${allextensions[$index]}"

	#sort the emulators.cfg file
	sort -o \$_emulatorscfg \$_emulatorscfg
	#if containing a default line then remember the default line,
	#delete it, remove the empty line and put it back at the end of the file
	cat \$_emulatorscfg|while read line
	do if [[ \$line == default* ]]; then 
	sed -i "s/\$line//g" \$_emulatorscfg
	#https://stackoverflow.com/questions/16414410/delete-empty-lines-using-sed
	sed -i -r "/^\s*$/d" \$_emulatorscfg
	echo \$line >> \$_emulatorscfg
	fi
	done
        chown \$user:\$user "\$_emulatorscfg"	
}

_EOF_

#change ownership to normal user
chown $user:$user "/home/$user/RetroPie-Setup$ext/scriptmodules/libretrocores/install-${newsystems[$index]}-from-mamedev-system-${systems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))${media[$index]}.sh" 2>&-

#install directly after generation if the script runs as a function within the front-end module script
if [[ $generator_script_status != standalone ]];then
#if not empty (-n) : change ownership to normal user and install 
   if [[ -n $(ls /home/$user/RetroPie-Setup$ext/scriptmodules/libretrocores/install-${newsystems[$index]}-from-mamedev-system-${systems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))${media[$index]}.sh 2>&-) ]]; then
   $scriptdir/retropie_packages.sh install-${newsystems[$index]}-from-mamedev-system-${systems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))${media[$index]}
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
##we have to use an if function to be sure this is only generated and installed once per system
##the if function will check if the last created system is not equal to the next system in the array
for index in "${!newsystems[@]}"; do if [[ $creating != ${newsystems[$index]} ]];then 
sleep 0.001
creating=${newsystems[$index]}
platformextensionsrp=$(grep ${newsystems[$index]}_exts /home/$user/RetroPie-Setup/platforms.cfg /home/$user/RetroPie-Setup/ext/RetroPie-Share/platforms.cfg | cut -d '"' -f 2)
cat > "/home/$user/RetroPie-Setup$ext/scriptmodules/libretrocores/install-${newsystems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))-cmd.sh" << _EOF_
#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#


rp_module_id="install-${newsystems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))-cmd"
rp_module_name="${newsystems[$index]} $([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo with ${ExtraPredefinedOptions[$index]}) with command and game-BIOS support"
rp_module_ext="$addextensionscmd $addextensions ${allextensions[$index]}$platformextensionsrp"
rp_module_desc="Use lr-mess and mame emulator for ${newsystems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))"
rp_module_help="ROM Extensions: \$rp_module_ext\n
Above extensions are included for compatibility between different media installs.\n\n
ROM extensions only supported by this install:\n
$addextensionscmd $addextensions ${extensions[$index]}\n\n
Put games or game-BIOS files in :\n
\$romdir/$(if [[ -n ${RPsystemNames[$index]} ]];then echo ${RPsystemNames[$index]};else echo ${newsystems[$index]};fi)\n
Notes:\n
No specific BIOS info can be given here.\n
When using game-BIOS files,/n
no BIOS is needed in the BIOS directory.\n
If BIOS files are needed put them in :\n
\$biosdir/mame\n
If the system doesn't boot then check :\n
/dev/runcommand.log\n\n"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/mame/master/LICENSE.md"
rp_module_section="exp"
rp_module_flags=""

function depends_install-${newsystems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))-cmd() {
	local _mess=\$(dirname "\$md_inst")/lr-mess/mess_libretro.so
	if [[ ! -f "\$_mess" ]]; then
		printMsgs dialog "cannot find '\$_mess' !\n\nplease install 'lr-mess' package."
		exit 1
	fi
}

function sources_install-${newsystems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))-cmd() {
	true
}

function build_install-${newsystems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))-cmd() {
	true
}


function install_install-${newsystems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))-cmd() {
	true
}


function configure_install-${newsystems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))-cmd() {
	local _retroarch_bin="\$rootdir/emulators/retroarch/bin/retroarch"
	local _mess=\$(dirname "\$md_inst")/lr-mess/mess_libretro.so
	#local _system="${newsystems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))"
	local _system="$(if [[ -n ${RPsystemNames[$index]} ]];then echo ${RPsystemNames[$index]};else echo ${newsystems[$index]};fi)"
	local _config="\$configdir/\$_system/retroarch.cfg"
	local _emulatorscfg="\$configdir/\$_system/emulators.cfg"
	local _mameini="/opt/retropie/configs/mame/mame.ini"
    
	mkRomDir "\$_system"
	ensureSystemretroconfig "\$_system"
    
	echo "enable cheats for lr-mess in \$configdir/all/retroarch-core-options.cfg"
	iniConfig " = " "\"" "\$configdir/all/retroarch-core-options.cfg"
	iniSet "mame_cheats_enable" "enabled"
	chown \$user:\$user "\$configdir/all/retroarch-core-options.cfg"

	echo "enable cheats for mame in /opt/retropie/configs/mame/mame.ini"    
	iniConfig " " "" "\$_mameini"
	iniSet "cheatpath"  "\$romdir/mame/cheat"
	iniSet "cheat" "1"
	chown \$user:\$user "\$_mameini"

	echo "enable translation ai_service for RetroArch in \$configdir/all/retroarch.cfg"
	iniConfig " = " "\"" "\$configdir/all/retroarch.cfg"
	iniSet "ai_service_enable" "true"
	iniSet "ai_service_mode" "0"
	iniSet "ai_service_pause" "true"
	iniSet "ai_service_source_lang" "0"
	iniSet "ai_service_target_lang" "1"
	iniSet "ai_service_url" "http://ztranslate.net/service?api_key=HEREISMYKEY"
	iniSet "input_ai_service" "t"
	iniSet "#input_ai_service_btn" "11"
	chown \$user:\$user "\$configdir/all/retroarch.cfg"
        
	addEmulator 0 "lr-mess-cmd" "\$_system" "\$_retroarch_bin --config \$_config -v -L \$_mess %ROM%"
	addEmulator 0 "lr-mess-basename" "\$_system" "\$_retroarch_bin --config \$_config -v -L \$_mess %BASENAME%"
	addEmulator 0 "mame-cmd" "\$_system" "/opt/retropie/emulators/mame/mame -rompath /home/$user/RetroPie/roms/\$_system -v -c %BASENAME%"
	addEmulator 0 "mame-cmd-autoframeskip" "\$_system" "/opt/retropie/emulators/mame/mame -rompath /home/$user/RetroPie/roms/\$_system -v -c -autoframeskip %BASENAME%"
	addEmulator 0 "mame-basename" "\$_system" "/opt/retropie/emulators/mame/mame -v -c \$_system %BASENAME%"
	addEmulator 0 "mame-basename-autoframeskip" "\$_system" "/opt/retropie/emulators/mame/mame -v -c -autoframeskip \$_system %BASENAME%"
	#turned these off, seems these commands will not work, but kept for future testing : https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/33
	##addEmulator 0 "mame-basename-test" "\$_system" "/opt/retropie/emulators/mame/mame -rompath /home/$user/RetroPie/roms/${newsystems[$index]} -v -c %BASENAME%"
	##addEmulator 0 "mame-basename-autoframeskip-test" "\$_system" "/opt/retropie/emulators/mame/mame -rompath /home/$user/RetroPie/roms/${newsystems[$index]} -v -c -autoframeskip %BASENAME%"

	# add system to es_systems.cfg
	#the line used by @valerino didn't work for the original RetroPie-setup 
	#therefore the information is added in a different way
	#the system name is also used as description because, for example, handhelds are generated with game system names
	addSystem "\$_system" "${descriptions[$index]} $([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo with extra ExtraPredefinedOptions)" "$addextensionscmd $addextensions ${allextensions[$index]}$platformextensionsrp"

	#sort the emulators.cfg file
	sort -o \$_emulatorscfg \$_emulatorscfg
	#if containing a default line then remember the default line,
	#delete it, remove the empty line and put it back at the end of the file
	cat \$_emulatorscfg|while read line
	do if [[ \$line == default* ]]; then 
	sed -i "s/\$line//g" \$_emulatorscfg
	#https://stackoverflow.com/questions/16414410/delete-empty-lines-using-sed
	sed -i -r "/^\s*$/d" \$_emulatorscfg
	echo \$line >> \$_emulatorscfg
	fi
	done
        chown \$user:\$user "\$_emulatorscfg"
}

_EOF_

#change ownership to normal user
chown $user:$user "/home/$user/RetroPie-Setup$ext/scriptmodules/libretrocores/install-${newsystems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))-cmd.sh" 2>&-

#install directly after generation if the script runs as a function within the front-end module script
if [[ $generator_script_status != standalone ]];then
   if [[ -n $(ls /home/$user/RetroPie-Setup$ext/scriptmodules/libretrocores/install-${newsystems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))-cmd.sh 2>&-) ]]; then 
   $scriptdir/retropie_packages.sh install-${newsystems[$index]}$([[ -n ${ExtraPredefinedOptions[$index]} ]] && echo $(echo _${ExtraPredefinedOptions[$index]} | sed "s/\\\n//g;s/\/.*\///g;s/~//g;s/ /_/g;s/[\(]//g;s/[\)]//g;s/[\"]//g;s/[\']//g;s/-autoboot_delay_._//g;s/-autoboot_command/auto/g;"))-cmd
   fi
fi

#end if, preventing to create and install a module-script multiple times
fi

done

#update the packages if the script runs as a function within the front-end module script
if [[ $generator_script_status != standalone ]];then
   echo refreshing RetroPie packages
   rp_registerAllModules
fi
#end run_generator_script
}


function download_cheats() {
clear
echo "get the cheat.7z and place it in the correct path"
echo
wget -N -P /tmp http://cheat.retrogames.com/download/cheat0221.zip
unzip -o /tmp/cheat0221.zip cheat.7z -d /home/$user/RetroPie/BIOS/mame/cheat
chown -R $user:$user "/home/$user/RetroPie/BIOS/mame/cheat" 
rm /tmp/cheat0221.zip
}

function download_from_google_drive() {
clear
echo "get all gamelist files and put these in the correct path"
echo
curl https://raw.githubusercontent.com/matthuisman/gdrivedl/master/gdrivedl.py | \
python3 - https://drive.google.com/drive/folders/$1 -m -P "$2"
#wget -nv -O /tmp/gdrivedl.py https://raw.githubusercontent.com/matthuisman/gdrivedl/master/gdrivedl.py
#python /tmp/gdrivedl.py https://drive.google.com/drive/folders/1f_jXMG0XMBdyOOBpz8CHM6AFj9vC1R6m -P /opt/retropie/configs/all/emulationstation/gamelists
chown -R $user:$user "$2"
#rm /tmp/gdrivedl.py
}


function download_file_with_wget() {
clear
echo "getting your desired file"
mkdir -p $3
#$1=filename $2=from_link $3=to_path
if [ ! -f "$3/$1" ]; then
    wget -nv -O $3/$1 https://$2/$1
    #doesn't work, perhaps the command or redirecting is the problem
    # curl -L -O https://$2/$1 --create-dirs -o $3/$1
    sleep 10
else 
    read -r -p "File exists !, do you want to overwrite it ? [Y/N] " response
       if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]];then 
           wget -nv -O $3/$1 https://$2/$1
       fi
fi
chown -R $user:$user "$3"
}


function create_lr-mess_overlays() {
clear
echo "extract background files from mame artwork, if available, and create custom retroarch configs for overlay's"
echo
#added handheld arrays, used for overlays
#this is an example command to extract the systems and add them here to the array :
#classich=( "\"$(cat mame_systems_dteam_classich|cut -d " " -f2)\"" );echo ${classich[@]}|sed 's/ /\" \"/g'
classich=( "alnattck" "alnchase" "astrocmd" "bambball" "bankshot" "bbtime" "bcclimbr" "bdoramon" "bfriskyt" "bmboxing" "bmcfball" "bmsafari" "bmsoccer" "bpengo" "bultrman" "bzaxxon" "cdkong" "cfrogger" "cgalaxn" "cmspacmn" "cmsport" "cnbaskb" "cnfball" "cnfball2" "cpacman" "cpacmanr1" "cqback" "ebaskb2" "ebball" "ebball2" "ebball3" "ebknight" "edracula" "efball" "efootb4" "egalaxn2" "einvader" "einvader2" "einvaderc" "epacman2" "epacman2r" "esbattle" "esoccer" "estargte" "eturtles" "flash" "funjacks" "galaxy2" "gckong" "gdigdug" "ghalien" "ginv" "ginv1000" "ginv2000" "gjungler" "gpoker" "h2hbaseb" "h2hbaskb" "h2hfootb" "h2hhockey" "h2hsoccerc" "hccbaskb" "invspace" "kingman" "machiman" "mbaskb" "mchess" "mcompgin" "mfootb2" "mhockey" "msoccer" "msthawk" "mwcbaseb" "packmon" "pairmtch" "pbqbert" "phpball" "raisedvl" "rockpin" "splasfgt" "splitsec" "ssfball" "tbaskb" "tbreakup" "tcaveman" "tccombat" "tmpacman" "tmscramb" "tmtennis" "tmtron" "trshutvoy" "trsrescue" "ufombs" "us2pfball" "vinvader" "zackman" )
konamih=( "kbilly" "kblades" "kbucky" "kcontra" "kdribble" "kgarfld" "kgradius" "kloneran" "knfl" "ktmnt" "ktopgun" )
tigerh=( "taddams" "taltbeast" "tapollo13" "tbatfor" "tbatman" "tbatmana" "tbtoads" "tbttf" "tddragon" "tddragon3" "tdennis" "tdummies" "tflash" "tgaiden" "tgaunt" "tgoldeye" "tgoldnaxe" "thalone" "thalone2" "thook" "tinday" "tjdredd" "tjpark" "tkarnov" "tkazaam" "tmchammer" "tmkombat" "tnmarebc" "topaliens" "trobhood" "trobocop2" "trobocop3" "trockteer" "tsddragon" "tsf2010" "tsfight2" "tshadow" "tsharr2" "tsjam" "tskelwarr" "tsonic" "tsonic2" "tspidman" "tstrider" "tswampt" "ttransf2" "tvindictr" "twworld" "txmen" "txmenpx" )
gameandwatch=( "bassmate" "gnw_ball" "gnw_bfight" "gnw_bfightn" "gnw_bjack" "gnw_boxing" "gnw_bsweep" "gnw_cgrab" "gnw_chef" "gnw_climber" "gnw_climbern" "gnw_egg" "gnw_dkcirc" "gnw_dkhockey" "gnw_dkjr" "gnw_dkjrp" "gnw_dkong" "gnw_dkong2" "gnw_dkong3" "gnw_fire" "gnw_fireatk" "gnw_fires" "gnw_flagman" "gnw_gcliff" "gnw_ghouse" "gnw_helmet" "gnw_judge" "gnw_lboat" "gnw_lion" "gnw_manhole" "gnw_manholeg" "gnw_mario" "gnw_mariocm" "gnw_mariocmt" "gnw_mariotj" "gnw_mbaway" "gnw_mickdon" "gnw_mmouse" "gnw_mmousep" "gnw_octopus" "gnw_opanic" "gnw_pchute" "gnw_pinball" "gnw_popeye" "gnw_popeyep" "gnw_rshower" "gnw_sbuster" "gnw_smb" "gnw_smbn" "gnw_snoopyp" "gnw_squish" "gnw_ssparky" "gnw_stennis" "gnw_tbridge" "gnw_tfish" "gnw_vermin" "gnw_zelda" )

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
        mkdir -p "/home/$user/RetroPie/roms/$system"
        chown $user:$user "/home/$user/RetroPie/roms/$system" 
	#extract Background files,if existing in zip, from mame artwork files // issue not all artwork files have Background.png
        unzip /home/$user/RetroPie/roms/mame/artwork/$game.zip Background.png -d /home/$user/RetroPie/roms/mame/artwork 2>/dev/null
        checkforbackground=$(ls /home/$user/RetroPie/roms/mame/artwork/Background.png 2> /dev/null)
        if [[ -n $checkforbackground ]]
        then
        mv /home/$user/RetroPie/roms/mame/artwork/Background.png  /opt/retropie/configs/all/retroarch/overlay/$game.png 2>/dev/null
        chown $user:$user "/opt/retropie/configs/all/retroarch/overlay/$game.png" 
	#create configs
	cat > "/home/$user/RetroPie/roms/$system/$game.zip.cfg" << _EOF_
input_overlay =  /opt/retropie/configs/all/retroarch/overlay/$game.cfg
input_overlay_enable = true
input_overlay_opacity = 0.500000
input_overlay_scale = 1.000000
_EOF_
        cp "/home/$user/RetroPie/roms/$system/$game.zip.cfg" "/home/$user/RetroPie/roms/$system/$game.7z.cfg"
        chown $user:$user /home/$user/RetroPie/roms/$system/$game.*.cfg
        #
	cat > "/opt/retropie/configs/all/retroarch/overlay/$game.cfg" << _EOF_
overlays = 1
overlay0_overlay = $game.png
overlay0_full_screen = false
overlay0_descs = 0
_EOF_
        chown $user:$user "/opt/retropie/configs/all/retroarch/overlay/$game.cfg" 
        fi 
    done
done
}
