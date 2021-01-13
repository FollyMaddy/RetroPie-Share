#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="box86wineroadfighterremake"
rp_module_desc="Box86wine : A Remake Of Konami's RoadFighter"
rp_module_help=""
rp_module_licence="no licence"
rp_module_section="exp"
rp_module_flags="rpi4 x86"

function depends_box86wineroadfighterremake() {
    local dep_idx="$(rp_getIdxFromId "wine")"
    if [ "$dep_idx" == "" ] || ! rp_isInstalled "$dep_idx" ; then
        md_ret_errors+=("Sorry, you need to install the wine scriptmodule")
        return 1
    fi
}

function install_bin_box86wineroadfighterremake() {
    #
    # Download and extract A Remake Of Konami's RoadFighter ZIP file to Program Files.
    #
    local _zipfile="RoadFighter.zip"

    mkdir -p /home/pi/.wine/drive_c/Program\ Files/remakes/

    wget -nv -O "$__tmpdir/$_zipfile" http://braingames.jorito.net/roadfighter/downloads/$_zipfile
    pushd /home/pi/.wine/drive_c/Program\ Files/remakes/
    unzip "$__tmpdir/$_zipfile"
    popd
    
    chown -R pi:pi /home/pi/.wine/drive_c/Program\ Files/remakes/
}

function configure_box86wineroadfighterremake() {
    local system="box86wineroadfighterremake"
    local box86wineroadfighterremake="$md_inst/box86wineroadfighterremake_xinit.sh"

    #
    # Add A Remake Of Konami's RoadFighter entry to Ports in Emulation Station
    #
    cat > "$box86wineroadfighterremake" << _EOFSP_
#!/bin/bash
xset -dpms s off s noblank
cd "/home/pi/.wine/drive_c/Program Files/remakes/RoadFighter/"
matchbox-window-manager &
WINEDEBUG=-all LD_LIBRARY_PATH="/opt/retropie/supplementary/mesa/lib/" setarch linux32 -L /opt/retropie/ports/wine/bin/wine '/home/pi/.wine/drive_c/Program Files/remakes/RoadFighter/Roadfighter.exe' -fullscreen
_EOFSP_
        chmod +x "$box86wineroadfighterremake"

    addPort "$md_id" "box86wineroadfighterremake" "A Remake Of Konami's RoadFighter (Box86wine)" "XINIT:$box86wineroadfighterremake"
}
