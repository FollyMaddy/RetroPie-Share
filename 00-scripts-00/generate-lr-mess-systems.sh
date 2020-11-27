#!/bin/bash

# Version : 1
#
# Author : @folly
# Date   : 27/11/2020
#
# Copyright 2020 @folly
#
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#--------------------------------------


echo start
date

systems=()
media=()
extensions=()
descriptions=()

echo "reading systems, media and extensions from listmedia into arrays"
while read LINE; do 
# use the first column if seperated by a space
systems+=( "$(echo $LINE | cut -d " " -f 1)" )
# use the third column if seperated by a space and remove ( ) characters and add - for media
media+=( "$(echo $LINE | cut -d " " -f 3 | sed s/\(/-/g | sed s/\)//g)" )
# use the second column if seperated by a ) character
extensions+=( "$(echo $LINE | cut -d ")" -f 2)" )
done < <(/opt/retropie/emulators/mame/mame -listmedia | grep -v -E '\(brief|------|\(none|\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s' | grep -E '\(cart|\(flop1|\(cass|\(dump|\(cdrm')

echo "reading computer descriptions from listdevices into array"
for index in "${!systems[@]}"; do descriptions+=( "$(/opt/retropie/emulators/mame/mame -listdevices ${systems[$index]} | grep Driver | sed s/Driver//g | sed s/${systems[$index]}//g | sed s/\://g)" ); done

#for index in "${!systems[@]}"; do echo ${descriptions[$index]} ${systems[$index]} ${media[$index]} ${extensions[$index]}; echo -ne '\n'; done

echo "generating and writing the generated-lr-mess-<system>.sh script files"
# put everything in a seperate directory
mkdir libretrocores 2>&-
for index in "${!systems[@]}"; do cat > libretrocores/generated-lr-mess-${systems[$index]}.sh << _EOF_
#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-mess-${systems[$index]}"
rp_module_name="${descriptions[$index]}"
rp_module_ext="${extensions[$index]}"
rp_module_desc="MESS emulator (\$rp_module_name) - MESS Port for libretro"
rp_module_help="ROM Extensions: \$rp_module_ext\n\n
Put games in:\n
\$romdir/${systems[$index]}.zip\n\n
Put BIOS files in \$biosdir:\n
${systems[$index]}.zip\n\n"

rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/mame/master/LICENSE.md"
rp_module_section="exp"
rp_module_flags=""

function depends_lr-mess-${systems[$index]}() {
	local _mess=\$(dirname "\$md_inst")/lr-mess/mess_libretro.so
	if [[ ! -f "\$_mess" ]]; then
		printMsgs dialog "cannot find '\$_mess' !\n\nplease install 'lr-mess' package."
		exit 1
	fi
}

function sources_lr-mess-${systems[$index]}() {
	true
}

function build_lr-mess-${systems[$index]}() {
	true
}

function install_lr-mess-${systems[$index]}() {
	true
}

function configure_lr-mess-${systems[$index]}() {
	local _mess=\$(dirname "\$md_inst")/lr-mess/mess_libretro.so
	local _retroarch_bin="\$rootdir/emulators/retroarch/bin/retroarch"
	local _system="${systems[$index]}"
	local _config="\$configdir/\$_system/retroarch.cfg"
	local _add_config="\$_config.add"
	local _custom_coreconfig="\$configdir/\$_system/custom-core-options.cfg"
	local _script="\$scriptdir/scriptmodules/run_mess.sh"

	# create retroarch configuration
	ensureSystemretroconfig "\$_system"

	# ensure it works without softlists, using a custom per-fake-core config
    iniConfig " = " "\"" "\$_custom_coreconfig"
    iniSet "mame_softlists_enable" "disabled"
	iniSet "mame_softlists_auto_media" "disabled"
	iniSet "mame_boot_from_cli" "disabled"

	# this will get loaded too via --append_config
	iniConfig " = " "\"" "\$_add_config"
	iniSet "core_options_path" "\$_custom_coreconfig"
	#iniSet "save_on_exit" "false"

	# set permissions for configurations
 	chown \$user:\$user "\$_custom_coreconfig" 
 	chown \$user:\$user "\$_add_config" 

	# setup rom folder
	mkRomDir "\$_system"

	# ensure run_mess.sh script is executable
	chmod 755 "\$_script"

	# add the emulators.cfg as normal, pointing to the above script
	addEmulator 1 "\$md_id" "\$_system" "\$_script \$_retroarch_bin \$_mess \$_config \$_system \$biosdir ${media[$index]} %ROM%"

	# add system to es_systems.cfg as normal
	addSystem "\$_system" "\$md_name" "\$md_ext"
}

_EOF_

done

echo stop
date
