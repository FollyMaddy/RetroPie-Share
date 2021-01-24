#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="goonies"
rp_module_desc="Goonies Remake"
rp_module_licence="None"
rp_module_section="exp"
rp_module_flags=""


function depends_goonies() {
    getDepends xorg matchbox-window-manager libsdl-image1.2-dev libsdl-mixer1.2-dev libsdl-sound1.2-dev libsdl-ttf2.0-dev libstdc++6 libstdc++-6-dev
}

function sources_goonies() {
    downloadAndExtract "https://braingames.jorito.net/nightlies/goonies-svn-20120216.zip" "$md_build"
}

function build_goonies() {
    cp "$md_build/nightlies/goonies-svn-20120216/build/linux/Makefile" "$md_build/nightlies/goonies-svn-20120216/src/Makefile"
    sed -i 's/if..tmp \=\= 0...//g;s/mask \=\= 0.//g' $md_build/nightlies/goonies-svn-20120216/src/auxiliar.cpp
    sed -i '0,/return.false./! {0,/return.false./ s/return.false.//}' $md_build/nightlies/goonies-svn-20120216/src/auxiliar.cpp
    sed -i 's/bool fullscreen=false\;/bool fullscreen=true\;/g' $md_build/nightlies/goonies-svn-20120216/src/main.cpp
    sed -i 's/lGLU/lGLU \-lm \-lstdc\+\+/g' $md_build/nightlies/goonies-svn-20120216/src/Makefile
    cd "$md_build/nightlies/goonies-svn-20120216/src/"
    make
    cp "$md_build/nightlies/goonies-svn-20120216/src/goonies" "$md_build/nightlies/goonies-svn-20120216/goonies"
}

function install_goonies() {
    md_ret_files=(        
        'nightlies/goonies-svn-20120216'
    )
}

function configure_goonies() {
    addPort "$md_id" "goonies" "GooniesRemake" "XINIT:pushd $md_inst/goonies-svn-20120216; $md_inst/goonies-svn-20120216/goonies.sh"

    cat >"$md_inst/goonies-svn-20120216/goonies.sh" << _EOF_
#!/bin/bash
xset -dpms s off s noblank
matchbox-window-manager &
/opt/retropie/ports/goonies/goonies-svn-20120216/goonies
_EOF_
    chmod +x "$md_inst/goonies-svn-20120216/goonies.sh"
}

