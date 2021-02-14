#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="box86winegooniesremake"
rp_module_desc="Box86wine : A Remake Of Konami's Goonies"
rp_module_help=""
rp_module_licence="no licence"
rp_module_section="exp"
rp_module_flags="rpi4 x86"

function depends_box86winegooniesremake() {
    if ! rp_isInstalled "wine" ; then
        md_ret_errors+=("Sorry, you need to install the wine scriptmodule")
        return 1
    fi
}

function install_bin_box86winegooniesremake() {
    #
    # Download and extract A Remake Of Konami's Goonies ZIP file to Program Files.
    #
    local _zipfile="theGoonies.zip"

    mkdir -p /home/pi/.wine/drive_c/Program\ Files/remakes/

    wget -nv -O "$__tmpdir/$_zipfile" http://braingames.jorito.net/goonies/downloads/$_zipfile
    pushd /home/pi/.wine/drive_c/Program\ Files/remakes/
    unzip "$__tmpdir/$_zipfile"
    popd
    
    chown -R pi:pi /home/pi/.wine/drive_c/Program\ Files/remakes/
}

function configure_box86winegooniesremake() {
    local system="box86winegooniesremake"
    local box86winegooniesremake="$md_inst/box86winegooniesremake_xinit.sh"

    #
    # Add A Remake Of Konami's Goonies entry to Ports in Emulation Station
    #
    cat > "$box86winegooniesremake" << _EOFSP_
#!/bin/bash
xset -dpms s off s noblank
cd "/home/pi/.wine/drive_c/Program Files/remakes/theGoonies/"
matchbox-window-manager &
WINEDEBUG=-all LD_LIBRARY_PATH="/opt/retropie/supplementary/mesa/lib/" setarch linux32 -L /opt/retropie/ports/wine/bin/wine '/home/pi/.wine/drive_c/Program Files/remakes/theGoonies/goonies.exe' -fullscreen
_EOFSP_
        chmod +x "$box86winegooniesremake"

    addPort "$md_id" "box86winegooniesremake" "A Remake Of Konami's Goonies (Box86wine)" "XINIT:$box86winegooniesremake"
}
