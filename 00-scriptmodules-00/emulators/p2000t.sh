#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="p2000t"
rp_module_desc="Philips P2000T/P2000M emulator by Marcel de Kogel"
rp_module_help="\
ROM Extensions: .cas\n\nCopy your games to $romdir/p2000t\n\n\
Default video mode is set to 640x480@75hz.\n\
If you need a different video mode,\n\
change this within the boot menu !\n\
"
rp_module_section="exp"
rp_module_flags=""

function depends_p2000t() {
    getDepends xorg matchbox-window-manager alsa-oss
}

function sources_p2000t() {
    wget http://www.komkon.org/~dekogel/files/p2000/M2000.tar.gz -P $md_build
    cd $md_build
    tar -xf M2000.tar.gz
}

function build_p2000t() {
    cd $md_build/P2000

    #unix/x version will only compile if 24 Bits Per Pixel is added to the file X.c
    sed -i 's/bpp!=16 \&\& bpp!=32/bpp!=16 \&\& bpp!=24 \&\& bpp!=32/g' X.c
    sed -i 's/16 and/16,24 and/g' X.c
    
    #unix/x version fix the file X.c with the resolution 640x480
    #in the configure function the video mode 640x480@75hz is added as default
    sed -i 's/520x490/640x480/g' X.c
    sed -i 's/width=520/width=640/g' X.c
    sed -i 's/height=490/height=480/g' X.c
  
    make -f Makefile.X
    rm *.c *.h *.o *.S Make*.* Make* 2>&-
}

function install_p2000t() {
    md_ret_files=(        
        'P2000/.'
    )
}

function configure_p2000t() {
    cat >"$md_inst/p2000t.sh" << _EOF_
#!/bin/bash
xset -dpms s off s noblank
matchbox-window-manager -use_titlebar no -use_cursor no &
aoss ./m2000 -video 1 -boot 1 -tape \$1
_EOF_
    chmod +x "$md_inst/p2000t.sh"

    #insert the video mode 640x480@75hz for m2000 if not present
    if [[ -z $(cat "/opt/retropie/configs/all/videomodes.cfg"|grep m2000) ]];then
    echo "Adding video mode for m2000 640x480@75hz"
    echo "m2000 = \"87-19\"" >> "/opt/retropie/configs/all/videomodes.cfg"
    fi

    mkRomDir "p2000t"
    addEmulator 0 "m2000" "p2000t" "XINIT:pushd $md_inst;$md_inst/p2000t.sh %ROM%"
    addSystem "p2000t" "Philips P2000t" ".cas"
}