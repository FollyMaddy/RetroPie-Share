#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-bk"
rp_module_desc="BK - bk port for libretro"
rp_module_help="ROM Extensions: ..chd .iso .zip\n\nCopy your roms to $romdir/bk\n\nCopy your bios roms to $biosdir/bk\n\n"
rp_module_repo="git https://github.com/libretro/bk-emulator.git master"
rp_module_section="exp"

function sources_lr-bk() {
    gitPullOrClone
}

function build_lr-bk() {
    make -f Makefile.libretro clean
    make -f Makefile.libretro
    md_ret_require="$md_build/bk_libretro.so"
}

function install_lr-bk() {
    md_ret_files=(
        'COPYING'
        'bk_libretro.so'
    )
}

function configure_lr-bk() {
    mkRomDir "bk"
    ensureSystemretroconfig "bk"

    addEmulator 1 "$md_id" "bk" "$md_inst/bk_libretro.so"
    addSystem "bk" "BK-0010/BK-0011" ".bin .7z .zip"
}
