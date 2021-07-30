#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-retro8"
rp_module_desc="PICO-8 emulator port for libretro"
rp_module_help="ROM Extensions: .zip .ZIP\n\nCompress your .p8.png games to .zip\n\nCopy your compressed roms to $romdir/pico8"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/retro8/master/COPYING"
rp_module_repo="git https://github.com/libretro/retro8.git master"
rp_module_section="exp"

function sources_lr-retro8() {
    gitPullOrClone
}

function build_lr-retro8() {
    make
    md_ret_require="$md_build/retro8_libretro.so"
}

function install_lr-retro8() {
    md_ret_files=(
        'retro8_libretro.so'
        'README.md'
    )
}

function configure_lr-retro8() {
    mkRomDir "pico8"
    ensureSystemretroconfig "pico8"
    addEmulator 1 "$md_id" "pico8" "$md_inst/retro8_libretro.so"
    addSystem "pico8" "PICO-8" ".zip"
}