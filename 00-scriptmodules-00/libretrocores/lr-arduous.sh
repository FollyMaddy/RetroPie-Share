#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-arduous"
rp_module_desc="ArduBoy emulator - arduous port for libretro"
rp_module_help="ROM Extensions: .ghex .zip\n\nCopy your ArduBoy roms to $romdir/arduboy"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/arduous/master/license.txt"
rp_module_repo="git https://github.com/libretro/arduous main"
rp_module_section="exp"

function sources_lr-arduous() {
    gitPullOrClone
}

function build_lr-arduous() {
    cd build
    cmake ..
    make clean
    make
    md_ret_require="$md_build/build/arduous_libretro.so"
}

function install_lr-arduous() {
    md_ret_files=(
        'build/arduous_libretro.so'
    )
}

function configure_lr-arduous() {
    mkRomDir "arduboy"

    defaultRAConfig "arduboy"

    addEmulator 1 "$md_id" "arduboy" "$md_inst/arduous_libretro.so"

    addSystem "arduboy" "ArduBoy" ".hex .7z .zip"
}
