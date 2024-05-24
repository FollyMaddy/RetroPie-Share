#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-vircon32"
rp_module_desc="Vircon32 game console - port of vircon32 for libretro"
rp_module_help="ROM Extensions: .v32 .zip\n\nCopy your roms to $romdir/vircon32\n\nCopy the bios to $biosdir"
rp_module_licence="3-Clause BSD https://raw.githubusercontent.com/vircon32/vircon32-libretro/main/LICENSE.md"
rp_module_repo="git https://github.com/vircon32/vircon32-libretro.git main"
rp_module_section="exp"

function sources_lr-vircon32() {
    gitPullOrClone
}

function build_lr-vircon32() {
	cmake .
    make
    md_ret_require="$md_build/vircon32_libretro.so"
}

function install_lr-vircon32() {
    md_ret_files=(
        'vircon32_libretro.so'
        'README.md'
        'LICENSE.md'
    )
}

function configure_lr-vircon32() {
    mkRomDir "vircon32"

    addEmulator 1 "$md_id" "vircon32" "$md_inst/vircon32_libretro.so"
    addSystem "vircon32" "Vircon32 game console" ".v32 .zip .V32 .ZIP"

    [[ "$md_mode" == "remove" ]] && return
}
