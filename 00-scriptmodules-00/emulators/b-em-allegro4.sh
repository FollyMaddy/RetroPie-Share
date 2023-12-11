#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="b-em-allegro4"
rp_module_desc="Acorn BBC emulator"
rp_module_help="\
Supported ROMS/MEDIA : .uef .ssd\n\
ROMS/MEDIA have to be in $romdir/bbcmicro\n\n\
Press F11 to go into the menu\n\n\
Exit with Alt + Escape\n\
"
rp_module_section="exp"
rp_module_flags=""

function depends_b-em-allegro4() {
    getDepends xorg matchbox-window-manager automake liballegro4-dev zlib1g-dev libalut-dev libopenal-dev autotools-dev xdotool
}

function sources_b-em-allegro4() {
    rm -d -r $md_build
    downloadAndExtract "https://github.com/stardot/b-em/archive/263d2d44e53e593d1f51c0be9b9f404447fb33a3.zip" "$md_build"
    
}

function build_b-em-allegro4() {
    cd $md_build/b-em-263d2d44e53e593d1f51c0be9b9f404447fb33a3
    
    if [[ ! -f PatchFile.done ]];then
    # workaround for starting in full-screen and adding the Alt + Esc combination to exit with restoring to the original resolution by leaving full-screen first
    echo patching file src/video.c
    sed -i 's/int fullscreen = 0;/int fullscreen = 1;/g' src/video.c;
    cat >"PatchFile" << _EOF_
--- main.c	2023-12-11 17:24:19.391903834 +0100
+++ main.c	2023-12-11 16:21:55.700289167 +0100
@@ -220,6 +220,7 @@
         }
 
         video_init();
+	video_enterfullscreen();
         mode7_makechars();
 
 #ifndef WIN32
@@ -350,6 +351,11 @@
                         tube_reset();
                 }
                 resetting = key[KEY_F12];
+                if (key[KEY_ALT] && key[KEY_ESC])
+                {
+                        video_leavefullscreen();
+                        main_close();
+                }
         }
         else
         {
_EOF_
    patch src/main.c < PatchFile
    mv PatchFile PatchFile.done
    else
    echo no patch for video.c and main.c is needed !
    fi
    
    ./autogen.sh
    ./configure
    # workaround for compiling with gcc-10/g++-10
    echo patching file src/Makefile
    sed -i 's/-mcpu/-fcommon -mcpu/g' src/Makefile;
    make -j4
}

function install_b-em-allegro4() {
    md_ret_files=(        
        'b-em-263d2d44e53e593d1f51c0be9b9f404447fb33a3/.'
    )
}

function configure_b-em-allegro4() {

    cat >"$configdir/bbcmicro/b-em.cfg" << _EOF_
video_resize = 0
fullborders = 1
fasttape = 1
_EOF_
    ln -s "$configdir/bbcmicro/b-em.cfg" "$md_inst/b-em.cfg"
#
    mv $md_inst/*.bin $configdir/bbcmicro
    ln -s "$configdir/bbcmicro/cmos.bin" "$md_inst/cmos.bin"
    ln -s "$configdir/bbcmicro/cmos350.bin" "$md_inst/cmos350.bin"
    ln -s "$configdir/bbcmicro/cmosa.bin" "$md_inst/cmosa.bin"
    ln -s "$configdir/bbcmicro/cmosc.bin" "$md_inst/cmosc.bin"
#
    chown $user:$user -R "$configdir/bbcmicro"

    cat >"$md_inst/matchbox_key_shortcuts" << _EOF_
<ctrl>c=close
_EOF_

    cat >"$md_inst/b-em-allegro4-multiload.sh" << _EOF_
#!/bin/bash
function load_tape() {
cassload=();cassload=( "Shift_L+quoteright" "t" "a" "p" "e" "Return" "c" "h" "a" "i" "n" "at" "at" "Return" )
xset -dpms s off s noblank
matchbox-window-manager -use_titlebar no -use_cursor no -kbdconfig $md_inst/matchbox_key_shortcuts &
/opt/retropie/emulators/b-em-allegro4/b-em \$1 -tape "\$2"|\
for index in \${!cassload[@]};do xdotool \$(if [[ \$index == 0 ]];then echo "sleep 1.5";fi) keydown \${cassload[\$index]} sleep 0.1 keyup \${cassload[\$index]};done
}
function load_disc() {
#dfs autoload with Shift_L+F12
xset -dpms s off s noblank
matchbox-window-manager -use_titlebar no -use_cursor no -kbdconfig $md_inst/matchbox_key_shortcuts &
/opt/retropie/emulators/b-em-allegro4/b-em \$1 -disc "\$2" -autoboot
}
[[ "\$2" == *.uef ]] && load_tape \$1 "\$2"
[[ "\$2" == *.ssd ]] && load_disc \$1 "\$2"
_EOF_
    chmod +x "$md_inst/b-em-allegro4-multiload.sh"


    mkRomDir "bbcmicro"
    addEmulator 0 "b-em-allegro4-BBC_B_8271_FDC-multiload" "bbcmicro" "XINIT:$md_inst/b-em-allegro4-multiload.sh -m3 %ROM%"
    addEmulator 0 "b-em-allegro4-Master_128-multiload" "bbcmicro" "XINIT:$md_inst/b-em-allegro4-multiload.sh -m10 %ROM%"
    addSystem "bbcmicro" "Acorn BBC micro" ".uef .ssd"
}
