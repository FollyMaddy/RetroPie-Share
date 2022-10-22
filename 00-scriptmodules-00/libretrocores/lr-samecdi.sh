#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-same_cdi"
rp_module_desc="Philips CDI - same_cdi port for libretro"
rp_module_help="ROM Extensions: ..chd .iso .zip\n\nCopy your roms to $romdir/cdimono1\n\nCopy your mame/mess bios (cdimono1.zip) to $biosdir/same_cdi/bios\n\n"
rp_module_repo="git https://github.com/libretro/same_cdi.git master"
rp_module_section="exp"

function sources_lr-same_cdi() {
    gitPullOrClone
}

function build_lr-same_cdi() {
    make -f Makefile.libretro clean
    make -f Makefile.libretro
    md_ret_require="$md_build/same_cdi_libretro.so"
}

function install_lr-same_cdi() {
    md_ret_files=(
        'COPYING'
        'same_cdi_libretro.so'
    )
}

function configure_lr-same_cdi() {
    mkRomDir "cdimono1"
    ensureSystemretroconfig "cdimono1"

    addEmulator 1 "$md_id" "cdimono1" "$md_inst/same_cdi_libretro.so"
    addSystem "cdimono1" "Philips CDI" ".chd .iso .7z .zip"
}
