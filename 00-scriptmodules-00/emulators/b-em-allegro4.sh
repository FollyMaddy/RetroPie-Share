#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="b-em-allegro4"
rp_module_desc="Acorn BBC emulator"
rp_module_help="\
Use F11 for the GUI !\n\
EXIT the emulator in the GUI or use ctrl+c !\n\n\
Supported ROMS/MEDIA : .uef .ssd\n\
ROMS/MEDIA have to be in $romdir/bbcmicro\n\n\
"
rp_module_section="exp"
rp_module_flags=""

function depends_b-em-allegro4() {
    getDepends xorg matchbox-window-manager automake liballegro4-dev zlib1g-dev libalut-dev libopenal-dev autotools-dev xdotool
}

function sources_b-em-allegro4() {
    downloadAndExtract "https://github.com/stardot/b-em/archive/263d2d44e53e593d1f51c0be9b9f404447fb33a3.zip" "$md_build"
}

function build_b-em-allegro4() {
    cd $md_build/b-em-263d2d44e53e593d1f51c0be9b9f404447fb33a3
    ./autogen.sh
    ./configure
    sed -i 's/-mcpu/-fcommon -mcpu/g' src/Makefile; # workaround for compiling with gcc-10/g++-10
    make -j4
}

function install_b-em-allegro4() {
    md_ret_files=(        
        'b-em-263d2d44e53e593d1f51c0be9b9f404447fb33a3/.'
    )
}

function configure_b-em-allegro4() {

    cat >"$configdir/bbcmicro/b-em.cfg" << _EOF_
video_resize = 0
fullborders = 1
fasttape = 1
_EOF_
    ln -s "$configdir/bbcmicro/b-em.cfg" "$md_inst/b-em.cfg"
#
    mv $md_inst/*.bin $configdir/bbcmicro
    ln -s "$configdir/bbcmicro/cmos.bin" "$md_inst/cmos.bin"
    ln -s "$configdir/bbcmicro/cmos350.bin" "$md_inst/cmos350.bin"
    ln -s "$configdir/bbcmicro/cmosa.bin" "$md_inst/cmosa.bin"
    ln -s "$configdir/bbcmicro/cmosc.bin" "$md_inst/cmosc.bin"
#
    chown $user:$user -R "$configdir/bbcmicro"

    cat >"$md_inst/matchbox_key_shortcuts" << _EOF_
<ctrl>c=close
_EOF_

    cat >"$md_inst/b-em-allegro4-multiload.sh" << _EOF_
#!/bin/bash
function load_tape() {
cassload=();cassload=( "quotedbl" "t" "a" "p" "e" "Return" "c" "h" "a" "i" "n" "at" "at" "Return" )
xset -dpms s off s noblank
matchbox-window-manager -use_titlebar no -use_cursor no -kbdconfig $md_inst/matchbox_key_shortcuts &
/opt/retropie/emulators/b-em-allegro4/b-em \$1 -tape "\$2"|\
for index in \${!cassload[@]};do xdotool \$(if [[ \$index == 0 ]];then echo "sleep 1.5";fi) keydown \${cassload[\$index]} sleep 0.1 keyup \${cassload[\$index]};done
}
function load_disc() {
#dfs autoload with Shift_L+F12
xset -dpms s off s noblank
matchbox-window-manager -use_titlebar no -use_cursor no -kbdconfig $md_inst/matchbox_key_shortcuts &
/opt/retropie/emulators/b-em-allegro4/b-em \$1 -disc "\$2" | xdotool sleep 1.5 keydown Shift_L+F12 sleep 1 keyup Shift_L+F12
}
[[ "\$2" == *.uef ]] && load_tape \$1 "\$2"
[[ "\$2" == *.ssd ]] && load_disc \$1 "\$2"
_EOF_
    chmod +x "$md_inst/b-em-allegro4-multiload.sh"


    mkRomDir "bbcmicro"
    addEmulator 0 "b-em-allegro4-BBC_B+8271_FDC" "bbcmicro" "XINIT:$md_inst/b-em-allegro4-multiload.sh -m3 %ROM%"
    addEmulator 0 "b-em-allegro4-Master_128" "bbcmicro" "XINIT:$md_inst/b-em-allegro4-multiload.sh -m10 %ROM%"
    addSystem "bbcmicro" "Acorn BBC micro" ".uef .ssd"
}