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
rp_module_help="\
Use F11 for the GUI !\n\
Use ESC key to exit the emulator !\n\n\
Supported ROMS/MEDIA : .rom .uef .ssd .adm .dsd .adf\n\
ROMS/MEDIA have to be in $romdir/electron\n\n\
BIOS files are in /opt/retropie/emulators/elkulator/roms\n\
If needed, there are readme's in the sourcode\n\
Check them about the BIOS files and the emulator !\n\
The sha1sums of the BIOS roms are :\n\
2863b45dc880a7ed91ad9828795a3eb5ed0bcdd4  os\n\
e7c7a1094d50a3579751df2007269067c8ff6812  adfs.rom\n\
4a7393f3a45ea309f744441c16723e2ef447a281  basic.rom\n\
eaf340b64a0a747ec479e575cc7b07cf928fd845  dfs.rom\n\
e759e77efd8073c74a04b3907adcca4c6edd1cc8  os300.rom\n\
2de04ab7c81414d6c9c967f965c53fc276392463  plus1.rom\n\
2e409b92c97cda34ff25c2951e5f799125fe7e32  sndrom\n\n\
"
rp_module_section="exp"
rp_module_flags=""

function depends_elkulator() {
    getDepends xorg matchbox-window-manager automake liballegro4-dev zlib1g-dev libalut-dev libopenal-dev autotools-dev xdotool
}

function sources_elkulator() {
    downloadAndExtract "http://elkulator.acornelectron.co.uk/ElkulatorV1.0Linux.tar.gz" "/tmp/elkulator"
    mkdir -p "$md_build/elkulator-master/roms" 2>&-
    cp -r /tmp/elkulator/roms/* $md_build/elkulator-master/roms
    #no need to remove "/tmp/elkulator", it will be removed after a reboot
    #using now my RetroPie improved version (boot in fullscreen, exit with ESC key)
    downloadAndExtract "https://github.com/FollyMaddy/elkulator/archive/refs/heads/master.zip" "$md_build"
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

#this part is rejected with a fresh install
#but to be able to use `sudo retropie_packages.sh electron configure` for testing the module-script we need a fresh elk.cfg as an earlier created a link and than will not refresh
#so if there is a elk.cfg.bak then we will use this one to make use of `sudo retropie_packages.sh electron configure` possible
#the if function wil remove the link of elk.cfg if the elk.cfg.bak exists and recreate it from the backup file so we can redo the configuration withoun missing a file
#(perhaps this part can be removed or done in a better way, but I like to keep it in for now)
if [[ -n $(ls $md_inst/elk.cfg.bak 2>&-) ]];then
rm $md_inst/elk.cfg 2>&-
cp $md_inst/elk.cfg.bak $md_inst/elk.cfg 2>&-
fi

#we want push a fresh elk.cfg to the electron config directory
#then it's in the correct place and then we can also change the cfg on the fly when starting a rom
#then have to create a link to that file
#before we make a link we preserve the elk.cfg as a elk.cfg.bak for later use if needed
cp $md_inst/elk.cfg $configdir/electron/elk.cfg 2>&-
sed -i 's/win_resize = 0/win_resize = 1/g' $configdir/electron/elk.cfg
sed -i 's/plus3 = 0/plus3 = 1/g' $configdir/electron/elk.cfg
chown $user:$user $configdir/electron/elk.cfg
mv $md_inst/elk.cfg $md_inst/elk.cfg.bak 2>&-
ln -s $configdir/electron/elk.cfg $md_inst/elk.cfg

    cat >$md_inst/elkulator-multiload.sh << _EOF_
#!/bin/bash
#see for keylist codes => https://gitlab.com/cunidev/gestures/-/wikis/xdotool-list-of-key-codes
#see here for tips and tricks ==> https://github.com/damieng/BBCMicroTools/blob/master/tips-and-tricks.md
#if using a us keyboard you have to use "quotedbl" to get "*" and "at" to get '"', don't know, perhaps there is a better way
function load_rom() {
sed -i 's/adfsena = 1/adfsena = 0/g' $configdir/electron/elk.cfg
xset -dpms s off s noblank
#add rom2 if exists, a pair of roms have both basename_1.rom and basename_2.rom,
#check if "_1.rom" exists, do a reverse cut to get the basename, parse the $1 on how the 2nd file has to look like, search for that and add if exists
matchbox-window-manager -use_titlebar no -use_cursor no &
/opt/retropie/emulators/elkulator/elkulator -rom1 "\$1" \$(if [[ \$1 == *_1.rom ]];then basename=\$(echo \$rom1|rev|cut -d "/" -f 1|rev|cut -d "_" -f 1); [[ -n \$(ls \$(echo \$1|sed s/\$basename\_1\.rom/\$basename\_2\.rom/g)) ]] && echo -rom2 "\$(echo \$1|sed s/\$basename\_1\.rom/\$basename\_2\.rom/g)";fi)
}
function load_tape() {
sed -i 's/adfsena = 1/adfsena = 0/g' $configdir/electron/elk.cfg
cassload=();cassload=( "quotedbl" "t" "a" "p" "e" "Return" "c" "h" "a" "i" "n" "at" "at" "Return" )
xset -dpms s off s noblank
matchbox-window-manager -use_titlebar no -use_cursor no &
/opt/retropie/emulators/elkulator/elkulator -tape "\$1"|\
for index in \${!cassload[@]};do xdotool \$(if [[ \$index == 0 ]];then echo "sleep 1.5";fi) keydown \${cassload[\$index]} sleep 0.1 keyup \${cassload[\$index]};done
}
function load_disc_dfs() {
sed -i 's/adfsena = 1/adfsena = 0/g' $configdir/electron/elk.cfg
#dfs autoload with Shift_L+F12
xset -dpms s off s noblank
matchbox-window-manager -use_titlebar no -use_cursor no &
/opt/retropie/emulators/elkulator/elkulator -disc "\$1" | xdotool sleep 1.5 keydown Shift_L+F12 sleep 1 keyup Shift_L+F12
}
function load_disc_adfs() {
sed -i 's/adfsena = 0/adfsena = 1/g' $configdir/electron/elk.cfg
#adfs autoload with Shift_L+F12
xset -dpms s off s noblank
matchbox-window-manager -use_titlebar no -use_cursor no &
/opt/retropie/emulators/elkulator/elkulator -disc "\$1" | xdotool sleep 1.5 keydown Shift_L+F12 sleep 1 keyup Shift_L+F12
}
[[ "\$1" == *.rom ]] && load_rom "\$1"
[[ "\$1" == *.uef ]] && load_tape "\$1"
[[ "\$1" == *.ssd ]] && load_disc_dfs "\$1"
[[ "\$1" == *.adm ]] && load_disc_dfs "\$1"
[[ "\$1" == *.dsd ]] && load_disc_dfs "\$1"
[[ "\$1" == *.adf ]] && load_disc_adfs "\$1"
_EOF_
    chmod +x $md_inst/elkulator-multiload.sh

    mkRomDir "electron"
    addEmulator 0 "elkulator-multiload" "electron" "XINIT:$md_inst/elkulator-multiload.sh %ROM%"
    addSystem "electron" "Acorn Electron" " .rom .uef .ssd .adm .dsd .adf"
}