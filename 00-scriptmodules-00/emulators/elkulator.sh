#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="elkulator"
rp_module_desc="Acorn Electron emulator"
rp_module_help="ROM Extensions: .ssd\n\nCopy your games to $romdir/electron\n\n- use F11 for the gui\n- use shift+F12 to run the disc\n- exit the emulator from the qui\n"
rp_module_section="exp"
rp_module_flags=""

function depends_elkulator() {
    getDepends xorg matchbox-window-manager automake liballegro4-dev zlib1g-dev libalut-dev libopenal-dev autotools-dev xdotool
}

function sources_elkulator() {
    downloadAndExtract "https://github.com/stardot/elkulator/archive/refs/heads/master.zip" "$md_build"
}

function build_elkulator() {
    cd $md_build/elkulator-master
    aclocal -I m4
    automake -a
    autoconf
    ./configure
    make -j4
}

function install_elkulator() {
    md_ret_files=(        
        'elkulator-master/.'
    )
}

function configure_elkulator() {
    cat >"$md_inst/matchbox_key_shortcuts" << _EOF_
<ctrl>c=close
_EOF_

sed -i 's/win_resize = 0/win_resize = 1/g' $md_inst/elk.cfg
sed -i 's/plus3 = 0/plus3 = 1/g' $md_inst/elk.cfg

    cat >"$md_inst/elkulator-multiload.sh" << _EOF_
#!/bin/bash
#see for keylist codes => https://gitlab.com/cunidev/gestures/-/wikis/xdotool-list-of-key-codes
#see here for tips and tricks ==> https://github.com/damieng/BBCMicroTools/blob/master/tips-and-tricks.md
#if using a us keyboard you have to use "quotedbl" to get "*" and "at" to get '"', don't know, perhaps there is a better way
function load_rom() {
fullscreen=();fullscreen=( "F11" "Alt+s" "v" "Down" "Down" "Return" )
xset -dpms s off s noblank
matchbox-window-manager -use_titlebar no -use_cursor no -kbdconfig $md_inst/matchbox_key_shortcuts &
/opt/retropie/emulators/elkulator/elkulator -rom1 "\$1"|\
for index in \${!fullscreen[@]};do xdotool \$(if [[ \$index == 0 ]];then echo "sleep 1.5";fi) keydown \${fullscreen[\$index]} sleep 0.05 keyup \${fullscreen[\$index]};done
}
function load_tape() {
fullscreen_cassload=();fullscreen_cassload=( "F11" "Alt+s" "v" "Down" "Down" "Return" "quotedbl" "t" "a" "p" "e" "Return" "c" "h" "a" "i" "n" "at" "at" "Return" )
xset -dpms s off s noblank
matchbox-window-manager -use_titlebar no -use_cursor no -kbdconfig $md_inst/matchbox_key_shortcuts &
/opt/retropie/emulators/elkulator/elkulator -tape "\$1"|\
for index in \${!fullscreen_cassload[@]};do xdotool \$(if [[ \$index == 0 ]];then echo "sleep 1.5";fi) keydown \${fullscreen_cassload[\$index]} sleep 0.1 keyup \${fullscreen_cassload[\$index]};done
}
function load_disc() {
fullscreen_discload=();fullscreen_discload=( "F11" "Alt+s" "v" "Down" "Down" "Return" "quotedbl" "e" "x" "e" "c" "Space" "exclam" "b" "o" "o" "t" "Return" )
xset -dpms s off s noblank
matchbox-window-manager -use_titlebar no -use_cursor no -kbdconfig $md_inst/matchbox_key_shortcuts &
/opt/retropie/emulators/elkulator/elkulator -disc "\$1"|\
for index in \${!fullscreen_discload[@]};do xdotool \$(if [[ \$index == 0 ]];then echo "sleep 1.5";fi) keydown \${fullscreen_discload[\$index]} sleep 0.1 keyup \${fullscreen_discload[\$index]};done
}
[[ "\$1" == *.rom ]] && load_rom "\$1"
[[ "\$1" == *.uef ]] && load_tape "\$1"
[[ "\$1" == *.ssd ]] && load_disc "\$1"
_EOF_
    chmod +x "$md_inst/elkulator-multiload.sh"

    mkRomDir "electron"
    addEmulator 0 "elkulator-multiload" "electron" "XINIT:$md_inst/elkulator-multiload.sh %ROM%"
    addSystem "electron" "Acorn Electron" ".rom .uef .ssd"
}