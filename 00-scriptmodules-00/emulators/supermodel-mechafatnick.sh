#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="supermodel-mechafatnick"
rp_module_desc="Sega supermodel 3 (Pi-friendly by Mechafatnick)"
rp_module_help="\
WARNING: Still under construction\n\n\
Notes:\n\
- Created in such a way so it should not conflict with other supermodel installs\n\
- Select video mode 800x600 in the RetroPie boot menu to get fullscreen\n\n\
ROM Extensions: .zip\n\n\
Copy your games to $romdir/supermodel\n\n\
Supermodel emulator directories and files are added in:\n\
~/RetroPie/roms/supermodel/model3emu/mechafatnick\n\
(NVRAM, Saves, Supermodel.ini and Supermodel.log)\n\n\
\n\n\
"
rp_module_section="exp"
rp_module_flags=""

function depends_supermodel-mechafatnick() {
    getDepends xorg subversion libsdl2-dev libsdl2-net-dev
}

function sources_supermodel-mechafatnick() {
    downloadAndExtract https://github.com/Mechafatnick/SuperModelPi/archive/refs/heads/master.zip $md_build
}

function build_supermodel-mechafatnick() {
    cd $md_build/SuperModelPi-master
    cp Makefiles/Makefile.UNIX Makefile
    make
}

function install_supermodel-mechafatnick() {
    md_ret_files=(        
        'SuperModelPi-master/bin'
        'SuperModelPi-master/Config'
    )
    #note: command "mv" and "cp" won't work here, you get a "cannot stat error" in this function
}

function configure_supermodel-mechafatnick() {
    mkRomDir "supermodel"
    mkRomDir "supermodel/model3emu"
    mkRomDir "supermodel/model3emu/mechafatnick"
    mkRomDir "supermodel/model3emu/mechafatnick/NVRAM"
    mkRomDir "supermodel/model3emu/mechafatnick/Saves"    

    addEmulator 0 "Supermodel-mechafatnick-normal" "supermodel" "XINIT:pushd /opt/retropie/emulators/supermodel-mechafatnick;/opt/retropie/emulators/supermodel-mechafatnick/bin/supermodel -wide-screen -stretch -legacy3d -sound-volume=50 -music-volume=60 -no-vsync -no-throttle -no-dsb -res=800,600 %ROM%"
    addEmulator 0 "Supermodel-mechafatnick-40-hz-PPC-Underclock" "supermodel" "XINIT:pushd /opt/retropie/emulators/supermodel-mechafatnick;/opt/retropie/emulators/supermodel-mechafatnick/bin/supermodel -wide-screen -stretch -ppc-frequency=40 -legacy3d -sound-volume=50 -music-volume=60 -no-vsync -no-throttle -no-dsb -res=800,600 %ROM%"
    addEmulator 0 "Supermodel-mechafatnick-45-hz-PPC-Underclock" "supermodel" "XINIT:pushd /opt/retropie/emulators/supermodel-mechafatnick;/opt/retropie/emulators/supermodel-mechafatnick/bin/supermodel -wide-screen -stretch -ppc-frequency=45 -legacy3d -sound-volume=50 -music-volume=60 -no-vsync -no-throttle -no-dsb -res=800,600 %ROM%"
    addEmulator 0 "Supermodel-mechafatnick-48-hz-PPC-Underclock" "supermodel" "XINIT:pushd /opt/retropie/emulators/supermodel-mechafatnick;/opt/retropie/emulators/supermodel-mechafatnick/bin/supermodel -wide-screen -stretch -ppc-frequency=48 -legacy3d -sound-volume=50 -music-volume=60 -no-vsync -no-throttle -no-dsb -res=800,600 %ROM%"

    addSystem "supermodel" "Sega supermodel 3" ".zip"

    #to prevent nested links within the directories, previously created links are removed before creating new ones !
    rm "$md_inst/NVRAM" 2>&-
    rm "$md_inst/Saves" 2>&-

    ln -sv "$romdir/supermodel/model3emu/mechafatnick/NVRAM" "$md_inst/NVRAM"
    ln -sv "$romdir/supermodel/model3emu/mechafatnick/Saves" "$md_inst/Saves"
    ln -sv "$romdir/supermodel/model3emu/mechafatnick/Supermodel.log" "$md_inst/Supermodel.log" 2>&-

    #check if file exists and check if file is a not symlink
    #if so, then : 
    #- move the Supermodel.ini to the desired directory
    #- fix the permissions of that file to the normal user
    #- make a symlink to that file
    if [[ -f "$md_inst/Config/Supermodel.ini" ]] && [[ ! -L "$md_inst/Config/Supermodel.ini" ]]; then
    mv "$md_inst/Config/Supermodel.ini" "$romdir/supermodel/model3emu/mechafatnick/Supermodel.ini"
    chown $user:$user "$romdir/supermodel/model3emu/mechafatnick/Supermodel.ini"
    ln -sv "$romdir/supermodel/model3emu/mechafatnick/Supermodel.ini" "$md_inst/Config/Supermodel.ini"
    fi
}