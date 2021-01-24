#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="roadfighter"
rp_module_desc="RoadFighter Remake"
rp_module_licence="sge:GNU GENERAL PUBLIC LICENSE, RoadFighter:None"
rp_module_section="exp"
rp_module_flags=""


function depends_roadfighter() {
    getDepends xorg matchbox-window-manager libsdl-image1.2-dev libsdl-mixer1.2-dev libsdl-sound1.2-dev libsdl-ttf2.0-dev
}

function sources_roadfighter() {
    downloadAndExtract "https://braingames.jorito.net/nightlies/roadfighter-svn-20120302.zip" "$md_build"
}

function build_roadfighter() {
    cp "$md_build/nightlies/roadfighter-svn-20120302/build/linux/Makefile" "$md_build/nightlies/roadfighter-svn-20120302/Makefile"
    sed -i 's/if..tmp\=\=0...//g;s/mask\=\=0..*//g' $md_build/nightlies/roadfighter-svn-20120302/src/auxiliar.cpp
    sed -i 's/bool fullscreen=false\;/bool fullscreen=true\;/g' $md_build/nightlies/roadfighter-svn-20120302/src/main.cpp
    cd "$md_build/nightlies/roadfighter-svn-20120302"
    make
}

function install_roadfighter() {
    md_ret_files=(        
        'nightlies/roadfighter-svn-20120302'
    )
}

function configure_roadfighter() {
    addPort "$md_id" "roadfighter" "RoadFighterRemake" "XINIT:pushd $md_inst/roadfighter-svn-20120302; $md_inst/roadfighter-svn-20120302/roadfighter.sh"

    cat >"$md_inst/roadfighter-svn-20120302/roadfighter.sh" << _EOF_
#!/bin/bash
xset -dpms s off s noblank
matchbox-window-manager &
/opt/retropie/ports/roadfighter/roadfighter-svn-20120302/roadfighter
_EOF_
    chmod +x "$md_inst/roadfighter-svn-20120302/roadfighter.sh"
}
