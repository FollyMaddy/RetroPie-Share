#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="elkulator"
rp_module_desc="Acorn Electron emulator"
rp_module_help="ROM Extensions: .ssd\n\nCopy your games to $romdir/electron\n\n- use F11 for the gui\n- use shift+F12 to run the disc\n- exit the emulator from the qui\n"
rp_module_section="exp"
rp_module_flags=""

function depends_elkulator() {
    getDepends xorg matchbox-window-manager automake liballegro4-dev zlib1g-dev libalut-dev libopenal-dev autotools-dev
}

function sources_elkulator() {
    downloadAndExtract "https://github.com/stardot/elkulator/archive/refs/heads/master.zip" "$md_build"
}

function build_elkulator() {
    cd $md_build/elkulator-master
    aclocal -I m4
    automake -a
    autoconf
    ./configure
    make -j4
}

function install_elkulator() {
    md_ret_files=(        
        'elkulator-master/.'
    )
}

function configure_elkulator() {
    cat >"$md_inst/matchbox_key_shortcuts" << _EOF_
<ctrl>c=close
_EOF_

sed -i 's/win_resize = 0/win_resize = 1/g' $md_inst/elk.cfg
sed -i 's/plus3 = 0/plus3 = 1/g' $md_inst/elk.cfg

    cat >"$md_inst/elkulator-rom1.sh" << _EOF_
#!/bin/bash
xset -dpms s off s noblank
matchbox-window-manager -use_titlebar no -use_cursor no -kbdconfig $md_inst/matchbox_key_shortcuts &
/opt/retropie/emulators/elkulator/elkulator -rom1 "\$1"
_EOF_
    chmod +x "$md_inst/elkulator-rom1.sh"

    cat >"$md_inst/elkulator-tape.sh" << _EOF_
#!/bin/bash
xset -dpms s off s noblank
matchbox-window-manager -use_titlebar no -use_cursor no -kbdconfig $md_inst/matchbox_key_shortcuts &
/opt/retropie/emulators/elkulator/elkulator -tape "\$1"
_EOF_
    chmod +x "$md_inst/elkulator-tape.sh"

    cat >"$md_inst/elkulator-disc.sh" << _EOF_
#!/bin/bash
xset -dpms s off s noblank
matchbox-window-manager -use_titlebar no -use_cursor no -kbdconfig $md_inst/matchbox_key_shortcuts &
/opt/retropie/emulators/elkulator/elkulator -disc "\$1"
_EOF_
    chmod +x "$md_inst/elkulator-disc.sh"

    mkRomDir "electron"
    addEmulator 0 "elkulator-rom1" "electron" "XINIT:$md_inst/elkulator-rom1.sh %ROM%"
    addEmulator 0 "elkulator-tape" "electron" "XINIT:$md_inst/elkulator-tape.sh %ROM%"
    addEmulator 0 "elkulator-disc" "electron" "XINIT:$md_inst/elkulator-disc.sh %ROM%"
    addSystem "electron" "Acorn Electron" ".rom .uef .ssd"
}