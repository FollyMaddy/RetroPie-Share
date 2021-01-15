#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="box86winemogremake"
rp_module_desc="Box86wine : A Remake Of Konami's Maze Of Galoius"
rp_module_help=""
rp_module_licence="no licence"
rp_module_section="exp"
rp_module_flags="rpi4 x86"

function depends_box86winemogremake() {
    local dep_idx="$(rp_getIdxFromId "wine")"
    if [ "$dep_idx" == "" ] || ! rp_isInstalled "$dep_idx" ; then
        md_ret_errors+=("Sorry, you need to install the wine scriptmodule")
        return 1
    fi
}

function install_bin_box86winemogremake() {
    #
    # Download and extract A Remake Of Konami's Maze Of Galoius ZIP file to Program Files.
    #
    local _zipfile="mog_20080415.zip"

    mkdir -p /home/pi/.wine/drive_c/Program\ Files/remakes/

    wget -nv -O "$__tmpdir/$_zipfile" http://braingames.jorito.net/mog/downloads/$_zipfile
    pushd /home/pi/.wine/drive_c/Program\ Files/remakes/
    unzip "$__tmpdir/$_zipfile"
    popd

# create config for other graphics and sound    
    sed -i 's/NARAMURA/ALFONSO/g;s/JORITO/WOLF/g' "/home/pi/.wine/drive_c/Program Files/remakes/mog_20080415/MoG.cfg"
    
    chown -R pi:pi /home/pi/.wine/drive_c/Program\ Files/remakes/
}

function configure_box86winemogremake() {
    local system="box86winemogremake"
    local box86winemogremake="$md_inst/box86winemogremake_xinit.sh"

    #
    # Add A Remake Of Konami's Maze Of Galoius entry to Ports in Emulation Station
    #
    cat > "$box86winemogremake" << _EOFSP_
#!/bin/bash
xset -dpms s off s noblank
cd "/home/pi/.wine/drive_c/Program Files/remakes/mog_20080415/"
matchbox-window-manager &
WINEDEBUG=-all LD_LIBRARY_PATH="/opt/retropie/supplementary/mesa/lib/" setarch linux32 -L /opt/retropie/ports/wine/bin/wine '/home/pi/.wine/drive_c/Program Files/remakes/mog_20080415/Maze of Galious.exe' -fullscreen
_EOFSP_
        chmod +x "$box86winemogremake"

    addPort "$md_id" "box86winemogremake" "A Remake Of Konami's Maze Of Galoius (Box86wine)" "XINIT:$box86winemogremake"
}
