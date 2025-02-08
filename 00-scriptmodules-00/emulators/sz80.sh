#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="sz80"
rp_module_desc="Sinclair ZX80 emulator"
rp_module_help="ROM Extensions: .o .p .80\n\nCopy your ZX81 roms to $romdir/zx80\n\n
    Exit          - Exit emulator (F10)\n
    Reset         - Reset emulator (F12)\n\n
Read the README files for more information\n\n
First time the emulator will boot with the default settings, make sure you change the machine setting into ZX80 and save it afterwards\n
"
rp_module_licence="GPL2 https://github.com/SegHaxx/sz81/blob/main/README"
rp_module_repo="git https://github.com/SegHaxx/sz81.git main"
rp_module_section="exp"

function sources_sz80() {
    gitPullOrClone
    #patch and change the config directory for ZX80
    sed -i 's/\"\.sz81\"/\"\.sz80\"/g' "sdl_resources.h"
}

function build_sz80() {
    make clean
    make
    md_ret_require="$md_build/sz81"
}

function install_sz80() {
    md_ret_files=(
        "."
    )
}

function configure_sz80() {
    mkRomDir "zx80"
    defaultRAConfig "zx80"

    addEmulator 1 "$md_id" "zx80" "XINIT:pushd $md_inst; $md_inst/sz81 -f %ROM%; popd"
    addSystem "zx80" "ZX80" ".o .p .80"
}
