#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="mog"
rp_module_desc="Maze Of Galious Remake"
rp_module_licence="GNU GENERAL PUBLIC LICENSE - Version 2"
rp_module_section="exp"
rp_module_flags=""


function depends_mog() {
    getDepends libsdl-image1.2-dev libsdl-mixer1.2-dev libsdl-sound1.2-dev
}

function sources_mog() {
    downloadAndExtract "https://braingames.jorito.net/nightlies/mog-svn-20120228.zip" "$md_build"
}

function build_mog() {
    cp "$md_build/nightlies/mog-svn-20120228/build/linux/Makefile" "$md_build/nightlies/mog-svn-20120228/Makefile"
    cd "$md_build/nightlies/mog-svn-20120228"
    make
}

function install_mog() {
    md_ret_files=(        
        'nightlies/mog-svn-20120228'
    )
}

function configure_mog() {
    addPort "$md_id" "mog" "MazeOfGaliousRemake" "$md_inst/mog-svn-20120228/mog"
}