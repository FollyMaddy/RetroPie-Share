#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-m2000"
rp_module_desc="P2000T emu - M2000 port for libretro"
rp_module_help="ROM Extensions: .cas\n\nCopy your P2000T games to :\n$romdir/p2000t\n"
rp_module_licence="GPL3 https://git.libretro.com/libretro/M2000/-/raw/main/LICENSE"
rp_module_repo="git https://github.com/p2000t/M2000.git main"
rp_module_section="exp"

function sources_lr-m2000() {
    gitPullOrClone
}

function build_lr-m2000() {
    make clean
    make libretro
    md_ret_require="$md_build/src/libretro/m2000_libretro.so"
}

function install_lr-m2000() {
    md_ret_files=(
        'src/libretro/m2000_libretro.so'
        'README.md'
    )
}

function configure_lr-m2000() {
    addEmulator 1 "$md_id" "p2000t" "$md_inst/m2000_libretro.so"
    addSystem "p2000t"

    mkRomDir "p2000t"
    defaultRAConfig "p2000t"
}
