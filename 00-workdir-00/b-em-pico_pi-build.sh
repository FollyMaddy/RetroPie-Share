#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="b-em-pico_pi-build"
rp_module_desc="b-em-pico_pi-build / the fork of kilograham"
rp_module_licence=""
rp_module_section="exp"
rp_module_flags=""


function depends_b-em-pico_pi-build() {
    getDepends xorg matchbox-window-manager build-essential cmake libdrm-dev libx11-xcb-dev libxcb-dri3-dev libepoxy-dev ruby libasound2-dev
}

function sources_b-em-pico_pi-build() {
    gitPullOrClone "$md_build/pico-sdk" https://github.com/raspberrypi/pico-sdk.git "master"
    gitPullOrClone "$md_build/pico-extras" https://github.com/raspberrypi/pico-extras.git "master"
    gitPullOrClone "$md_build/b-em-pico" https://github.com/kilograham/b-em.git "pico"
}

function build_b-em-pico_pi-build() {
    mkdir $md_build/b-em-pico/pi_build
    cd $md_build/b-em-pico/pi_build
    cmake -DPICO_SDK_PATH=$md_build/pico-sdk -DPI_BUILD=1 -DPICO_PLATFORM=host -DDRM_PRIME=1 -DX_GUI=1 -DPICO_EXTRAS_PATH=$md_build/pico-extras ..
    make -j4
}

function install_b-em-pico_pi-build() {
    md_ret_files=(        
        'pi_build/src/pico/xmaster'
        'pi_build/src/pico/xbeeb'
    )
}

function configure_b-em-pico_pi-build() {
    addPort "$md_id" "b-em-pico_pi-build-xmaster" "bbc-xmaster" "XINIT:pushd $md_inst; $md_inst/bbc-xmaster.sh"

    cat >"$md_inst/bbc-xmaster.sh" << _EOF_
#!/bin/bash
xset -dpms s off s noblank
matchbox-window-manager &
/opt/retropie/ports/b-em-pico_pi-build/xmaster
_EOF_
    chmod +x "$md_inst/bbc-xmaster.sh"

    addPort "$md_id" "b-em-pico_pi-build-xbeeb" "bbc-xbeeb" "XINIT:pushd $md_inst; $md_inst/bbc-xbeeb.sh"

    cat >"$md_inst/bbc-xbeeb.sh" << _EOF_
#!/bin/bash
xset -dpms s off s noblank
matchbox-window-manager &
/opt/retropie/ports/b-em-pico_pi-build/xbeeb
_EOF_
    chmod +x "$md_inst/bbc-xbeeb.sh"
}
