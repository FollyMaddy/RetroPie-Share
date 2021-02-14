#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="box86winef1spiritremake"
rp_module_desc="Box86wine : A Remake Of Konami's F1Spirit"
rp_module_help=""
rp_module_licence="no licence"
rp_module_section="exp"
rp_module_flags="rpi4 x86"

function depends_box86winef1spiritremake() {
    if ! rp_isInstalled "wine" ; then
        md_ret_errors+=("Sorry, you need to install the wine scriptmodule")
        return 1
    fi
}

function install_bin_box86winef1spiritremake() {
    #
    # Download and extract A Remake Of Konami's F1Spirit ZIP file to Program Files.
    # f1spirit-1615.zip
    local _zipfile="f1spirit-1615.zip"

    mkdir -p /home/pi/.wine/drive_c/Program\ Files/remakes/

    wget -nv -O "$__tmpdir/$_zipfile" https://braingames.jorito.net/f1spirit/$_zipfile
    pushd /home/pi/.wine/drive_c/Program\ Files/remakes/
    unzip "$__tmpdir/$_zipfile"
    popd

# create config for fullscreen    
    cat > "/home/pi/.wine/drive_c/Program Files/remakes/F-1 Spirit/f1spirit.cfg" << _EOF_
1
_EOF_

    chown -R pi:pi /home/pi/.wine/drive_c/Program\ Files/remakes/
}

function configure_box86winef1spiritremake() {
    local system="box86winef1spiritremake"
    local box86winef1spiritremake="$md_inst/box86winef1spiritremake_xinit.sh"

    #
    # Add A Remake Of Konami's F1Spirit entry to Ports in Emulation Station
    #
    cat > "$box86winef1spiritremake" << _EOFSP_
#!/bin/bash
xset -dpms s off s noblank
cd "/home/pi/.wine/drive_c/Program Files/remakes/F-1 Spirit/"
matchbox-window-manager &
WINEDEBUG=-all LD_LIBRARY_PATH="/opt/retropie/supplementary/mesa/lib/" setarch linux32 -L /opt/retropie/ports/wine/bin/wine '/home/pi/.wine/drive_c/Program Files/remakes/F-1 Spirit/F1Spirit.exe' -fullscreen
_EOFSP_
        chmod +x "$box86winef1spiritremake"

    addPort "$md_id" "box86winef1spiritremake" "A Remake Of Konami's F1Spirit (Box86wine)" "XINIT:$box86winef1spiritremake"
}
