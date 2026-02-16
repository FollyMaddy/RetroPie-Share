#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="microtan"
rp_module_desc="Tangerine Microtan 65 emulator"
rp_module_help="ROM Extensions: .m65 .M65\n\nCopy your Microtan roms to $romdir/microtan\n\n"
rp_module_licence="Unknown"
rp_module_repo="git https://github.com/geo255/microtan65.git main"
rp_module_section="exp"

function sources_microtan() {
    gitPullOrClone
    applyPatch "$md_data/01_add-exit_fix-flicker-by-showing-help.patch"
}

function build_microtan() {
    make clean
    make
    md_ret_require="$md_build/microtan65"
}

function install_microtan() {
    md_ret_files=(
        "."
    )
}

function configure_microtan() {
    mkRomDir "microtan"
    defaultRAConfig "microtan"

    addEmulator 1 "$md_id" "microtan" "pushd $md_inst; $md_inst/microtan65 %ROM%; popd"
    addSystem "microtan" "Microtan 65" ".m65"
}
