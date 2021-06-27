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
rp_module_desc="Sega supermodel 3 version by Mechafatnick and Pi-friendly"
rp_module_help="\
WARNING: Still under construction\n\n\
Notes:\n\
- Created in such a way so it should not conflict with other supermodel installs\n\
- Select a good video mode in the RetroPie boot menu to get fullscreen\n\n\
ROM Extensions: .zip\n\n\
Copy your games to $romdir/supermodel\n\n\
Supermodel emulator directories and files are added in:\n\
~/RetroPie/roms/supermodel/model3emu/mechafatnick\n\
(NVRAM, Saves, Supermodel.ini and Supermodel.log)\n\n\
Add these lines to your Supermodel.ini,\n\
and alter them to your needs:\n\
XResolution=800 ; Default value 496\n\
YResolution=600 ; Default value 384\n\
FullScreen=0\n\
WideScreen=0\n\
Stretch=1\n\
WideBackground=0\n\
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
    #note: it should remove all files in $md_inst if there are any, so no need to remove links or files
    #note: command "mv" and "cp" won't work here, you get a "cannot stat error" in this function
    #prevent an error if the NVRAM and Saves directory are not in the source!
    if [[ -d "$md_build/SuperModelPi-master/NVRAM" ]] && [[ -d "$md_build/SuperModelPi-master/Saves" ]] ;then
    md_ret_files=(        
        'SuperModelPi-master/bin/supermodel'
        'SuperModelPi-master/Config'
        'SuperModelPi-master/NVRAM'
        'SuperModelPi-master/Saves'
    )
    else
    md_ret_files=(        
        'SuperModelPi-master/bin/supermodel'
        'SuperModelPi-master/Config'
    ) 
    fi
}

function configure_supermodel-mechafatnick() {
    mkRomDir "supermodel"
    mkRomDir "supermodel/model3emu"
    mkRomDir "supermodel/model3emu/mechafatnick"
  
    addEmulator 0 "Supermodel-mechafatnick-normal" "supermodel" "XINIT:pushd /opt/retropie/emulators/supermodel-mechafatnick;./supermodel -wide-screen -legacy3d -sound-volume=50 -music-volume=60 -no-vsync -no-throttle -no-dsb -load-state=$romdir/supermodel/model3emu/mechafatnick/Saves/%BASENAME%.st %ROM%"
    addEmulator 0 "Supermodel-mechafatnick-40-hz-PPC-Underclock" "supermodel" "XINIT:pushd /opt/retropie/emulators/supermodel-mechafatnick;./supermodel -wide-screen -ppc-frequency=40 -legacy3d -sound-volume=50 -music-volume=60 -no-vsync -no-throttle -load-state=$romdir/supermodel/model3emu/mechafatnick/Saves/%BASENAME%.st %ROM%"
    addEmulator 0 "Supermodel-mechafatnick-45-hz-PPC-Underclock" "supermodel" "XINIT:pushd /opt/retropie/emulators/supermodel-mechafatnick;./supermodel -wide-screen -ppc-frequency=45 -legacy3d -sound-volume=50 -music-volume=60 -no-vsync -no-throttle -load-state=$romdir/supermodel/model3emu/mechafatnick/Saves/%BASENAME%.st %ROM%"
    addEmulator 0 "Supermodel-mechafatnick-48-hz-PPC-Underclock" "supermodel" "XINIT:pushd /opt/retropie/emulators/supermodel-mechafatnick;./supermodel -wide-screen -ppc-frequency=48 -legacy3d -sound-volume=50 -music-volume=60 -no-vsync -no-throttle -load-state=$romdir/supermodel/model3emu/mechafatnick/Saves/%BASENAME%.st %ROM%"

    addSystem "supermodel" "Sega supermodel 3" ".zip"

    #using "sudo ./retropie_packages.sh supermodel-mechafatnick install" for testing this function,
    #you have to prevent nested links within the linked directories !
    #if the link NVRAM doesn't exist, others will too, like: Saves,bin/Supermodel.ini and Supermodel.log
    #then we can assume the installed directories are in place and we can move them and create symlinks
    #else we do nothing otherwise we are going to push links into links!
    if [[ ! -L "$md_inst/NVRAM" ]];then
    mv "$md_inst/NVRAM" "$romdir/supermodel/model3emu/mechafatnick" 2>&-
    mv "$md_inst/Saves" "$romdir/supermodel/model3emu/mechafatnick" 2>&-
    #we don't want to overwrite an existing Supermodel.ini
    [[ ! -f "$romdir/supermodel/model3emu/mechafatnick/Supermodel.ini" ]] && mv "$md_inst/Config/Supermodel.ini" "$romdir/supermodel/model3emu/mechafatnick/Supermodel.ini"
    #If it can't be copied then remove te file, otherwise we can't make a symlink
    [[ -f "$romdir/supermodel/model3emu/mechafatnick/Supermodel.ini" ]] && rm "$md_inst/Config/Supermodel.ini"
    #fix permissions
    chown $user:$user -R "$romdir/supermodel/model3emu/mechafatnick"
    #make symlinks
    ln -sv "$romdir/supermodel/model3emu/mechafatnick/NVRAM" "$md_inst/NVRAM"
    ln -sv "$romdir/supermodel/model3emu/mechafatnick/Saves" "$md_inst/Saves"
    ln -sv "$romdir/supermodel/model3emu/mechafatnick/Supermodel.ini" "$md_inst/Config/Supermodel.ini"
    ln -sv "$romdir/supermodel/model3emu/mechafatnick/Supermodel.log" "$md_inst/Supermodel.log" 2>&-
    fi
}