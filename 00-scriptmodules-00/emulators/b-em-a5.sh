#!/usr/bin/env bash

# Scriptmodule to deploy the b-em BBC Micro emulator, using Allegro5 gaming library.
# Based on b-em-allegro4.sh by FollyMaddy @ GitHub
#
# Copyright 2026, Gemba @ GitHub
# SPDX-License-Identifier: GPL-3.0-only

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="b-em-a5"
rp_module_desc="Acorn BBC Micro emulator (Allegro5 libs)"
rp_module_help="Supported ROM/media extensions : *.uef and *.ssd. Store them in $romdir/bbcmicro\n\
Exit emulator with Alt+ESC\n\
In the runcommand menu choose 'Select video mode for this emulator and set a resolution \
once to 800x600 (or 720x576 on 16:9 displays) but not lower or higher.\n
b-em config file is at ~/.config/b-em/b-em.cfg\n\
Consult also README.md at $md_inst for details."
rp_module_licence="GPL2 https://raw.githubusercontent.com/stardot/b-em/refs/heads/master/COPYING"
#rp_module_repo="git https://github.com/stardot/b-em.git :_get_latest_tag_b-em-a5"
rp_module_repo="git https://github.com/stardot/b-em.git master"
rp_module_section="exp"
rp_module_flags=""


function _get_latest_tag_b-em-a5() {
    download https://api.github.com/repos/stardot/b-em/releases - | grep -m 1 tag_name | cut -d\" -f4
}

function depends_b-em-a5() {
    local deps=(
        automake
        autotools-dev
        liballegro5-dev
        liballegro-audio5-dev
        liballegro-dialog5-dev
        liballegro-acodec5-dev
        liballegro-image5-dev
        xdotool
        xorg
        zlib1g-dev
    )
    getDepends "${deps[@]}"
}

function sources_b-em-a5() {
    gitPullOrClone
    if isPlatform rpi; then
        applyPatch "$md_data/01-Set-fullscreen.patch"
        applyPatch "$md_data/02-Add-Alt-ESC-to-quit-emulator.patch"
        applyPatch "$md_data/03-Use-monitor-resolution-for-screen-size-calculation.patch"
        applyPatch "$md_data/04-debug-log-output.patch"
    fi
}

function build_b-em-a5() {
    ./autogen.sh && ./configure
    # workaround for compiling with gcc-10/g++-10, prevalent on Bullseye
    [[ "$__os_debian_ver" -eq 11 ]] && sed -i 's/-mcpu/-fcommon -mcpu/g' src/Makefile
    make clean
    make
}

function install_b-em-a5() {
    md_ret_files=(
        b-em
        b-em.cfg
        ddnoise/
        fonts/
        roms/
        COPYING
        README.md
    )
}

function configure_b-em-a5() {
    local sys_name="bbcmicro"

    addSystem "$sys_name" "Acorn BBC micro" ".uef .ssd"
    addEmulator 0 "$md_id--BBC_B_8271_FDC"     "$sys_name" "XINIT:$md_inst/b-em-a5-launcher.sh  -m4 %ROM% %XRES% %YRES%"
    addEmulator 0 "$md_id--Master_128_MOS3.20" "$sys_name" "XINIT:$md_inst/b-em-a5-launcher.sh -m10 %ROM% %XRES% %YRES%"

    [[ "$md_mode" == "remove" ]] && return

    mkRomDir "$sys_name"
    # disable led bar
    sed -i 's/ledlocation=1/ledlocation=0/' "$md_inst/b-em.cfg"
    #  displaymode, cf. video_render.h: 0=scale, 1=interlace, 2=scanlines, 3=linedouble
    sed -i 's/displaymode=1/displaymode=0/' "$md_inst/b-em.cfg"
    sed -i 's/fasttape=false/fasttape=true/' "$md_inst/b-em.cfg"
    if grep -q "allegro_vsync=" "$md_inst/b-em.cfg"; then
        sed -i 's/allegro_vsync=0/allegro_vsync=1/' "$md_inst/b-em.cfg"
    else
        sed -i '/^\[video\]/a allegro_vsync=1' "$md_inst/b-em.cfg"
    fi
    chown "$__user":"$__group" "$md_inst/b-em.cfg"
    mv "$md_inst/b-em.cfg" "$configdir/$sys_name/$md_id.cfg"
    moveConfigFile "$home/.config/b-em/b-em.cfg" "$configdir/$sys_name/$md_id.cfg"

    cat >"$md_inst/b-em-a5-launcher.sh" <<_EOF_
#! /bin/bash

_model="\$1"
_rom_path="\$2"
_rom_fn="\$(basename \$_rom_path)"
_rom_ext="\${_rom_fn##*.}"
_center_x="\$((\$3 >> 1))"
_center_y="\$((\$4 >> 1))"

_common_opts=(
    "\$_model"
    "-fullscreen"
)

function load_tape() {
    # TODO: cassload possibly may be replace with 'b-em -pastek ...'
    cassload=()
    cassload=( "Shift_L+quoteright" "t" "a" "p" "e" "Return" "c" "h" "a" "i" "n" "at" "at" "Return" )
    xset -dpms s off s noblank
    echo "\$(basename \$0): Running $md_inst/b-em \${_common_opts[*]} -tape "\$_rom_path"" >> /dev/shm/runcommand.log
    $md_inst/b-em \${_common_opts[*]} -tape "\$_rom_path"|\
    for index in \${!cassload[@]}; do\
        xdotool \$(if [[ \$index == 0 ]];then echo "sleep 1.5";fi) keydown \${cassload[\$index]} sleep 0.1 keyup \${cassload[\$index]};\
    done
}

function load_disc() {
    #dfs autoload with Shift_L+F12
    xset -dpms s off s noblank
    echo "\$(basename \$0): Running $md_inst/b-em -autoboot \${_common_opts[*]} -disc "\$_rom_path"" >> /dev/shm/runcommand.log
    $md_inst/b-em -autoboot \${_common_opts[*]} -disc "\$_rom_path" | xdotool mousemove \$_center_x \$_center_y
}

rm -f "\$HOME/.config/b-em/b-emlog.txt"

case "\$_rom_ext" in
    "ssd")
        load_disc
        ;;
    "uef")
        load_tape
        ;;
    *)
        echo "\$(basename \$0): Unrecognized file extension of \$_rom_fn" >> /dev/shm/runcommand.log
        ;;
esac
_EOF_
    chmod +x "$md_inst/b-em-a5-launcher.sh"
}
