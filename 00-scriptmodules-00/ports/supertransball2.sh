#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="supertransball2"
rp_module_desc="Super Transball 2"
rp_module_licence="GNU GENERAL PUBLIC LICENSE - Version 2"
rp_module_section="exp"
rp_module_flags=""


function depends_supertransball2() {
    getDepends xorg matchbox-window-manager libsdl-image1.2-dev libsdl-mixer1.2-dev libsdl-sound1.2-dev
}

function sources_supertransball2() {
    gitPullOrClone "$md_build" https://github.com/santiontanon/stransball2.git
}

function build_supertransball2() {
    sed -i 's/if..tmp\=\=0...//g;s/mask\=\=0. return false.//g' $md_build/sources/auxiliar.cpp
    cd "$md_build/sources/"
    make
}

function install_supertransball2() {
    md_ret_files=(        
        '.'
    )
}

function configure_supertransball2() {
    addPort "$md_id" "supertransball2" "SuperTransball2" "XINIT:pushd $md_inst; $md_inst/supertransball2.sh"

    cat >"$md_inst/transball.cfg" << _EOF_
113 97 111 112 32 13 282
1 1
_EOF_

    cat >"$md_inst/supertransball2.sh" << _EOF_
#!/bin/bash
xset -dpms s off s noblank
matchbox-window-manager &
/opt/retropie/ports/supertransball2/stransball2
_EOF_
    chmod +x "$md_inst/supertransball2.sh"

chown -R $user:$user $md_inst
}

