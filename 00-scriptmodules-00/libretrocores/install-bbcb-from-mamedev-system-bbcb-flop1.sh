#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="install-bbcb-from-mamedev-system-bbcb-flop1"
rp_module_name="BBC Micro Model B with floppydisk1 support"
rp_module_ext=".zip .7z .1dd .360 .adf .adl .adm .ads .bbc .bin .cqi .cqm .csw .d77 .d88 .dfi .dsd .dsk .fsd .hfe .ima .imd .img .ipf .mfi .mfm .prn .rom .ssd .td0 .uef .ufi .wav "
rp_module_desc="Use lr-mess/mame emulator for ($rp_module_name)"
rp_module_help="ROM Extensions: $rp_module_ext\n
Above extensions are included for compatibility between different media installs.\n\n
ROM extensions only supported by this install:\n
.zip .7z .ssd .bbc .img .dsd .adf .ads .adm .adl .fsd .dsk .ima .ufi .360 .d77 .d88 .1dd .dfi .hfe .imd .ipf .mfi .mfm .td0 .cqm .cqi\n\n
Put games in:\n
$romdir/bbcb\n\n
Put BIOS files in $biosdir/mame:\n
bbcb.zip\n
Note:\n
BIOS info is automatically generated,\n
but some systems don't need a BIOS file!\n\n"

rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/mame/master/LICENSE.md"
rp_module_section="exp"
rp_module_flags=""

function depends_install-bbcb-from-mamedev-system-bbcb-flop1() {
	local _mess=$(dirname "$md_inst")/lr-mess/mess_libretro.so
	if [[ ! -f "$_mess" ]]; then
		printMsgs dialog "cannot find '$_mess' !\n\nplease install 'lr-mess' package."
		exit 1
	fi
}

function sources_install-bbcb-from-mamedev-system-bbcb-flop1() {
	true
}

function build_install-bbcb-from-mamedev-system-bbcb-flop1() {
	true
}

function install_install-bbcb-from-mamedev-system-bbcb-flop1() {
	true
}

function configure_install-bbcb-from-mamedev-system-bbcb-flop1() {
	local _mess=$(dirname "$md_inst")/lr-mess/mess_libretro.so
	local _retroarch_bin="$rootdir/emulators/retroarch/bin/retroarch"
	local _system="bbcb"
	local _config="$configdir/$_system/retroarch.cfg"
	local _add_config="$_config.add"
	local _custom_coreconfig="$configdir/$_system/custom-core-options.cfg"
	local _script="$scriptdir/scriptmodules/run_mess.sh"

	# create retroarch configuration
	ensureSystemretroconfig "$_system"

	# ensure it works without softlists, using a custom per-fake-core config
	iniConfig " = " "\"" "$_custom_coreconfig"
	iniSet "mame_softlists_enable" "disabled"
	iniSet "mame_softlists_auto_media" "disabled"
	iniSet "mame_boot_from_cli" "disabled"
        iniSet "mame_mouse_enable" "enabled"

	# this will get loaded too via --append_config
	iniConfig " = " "\"" "$_add_config"
	iniSet "core_options_path" "$_custom_coreconfig"
	#iniSet "save_on_exit" "false"

	# set permissions for configurations
 	chown $user:$user "$_custom_coreconfig" 
 	chown $user:$user "$_add_config" 

	# setup rom folder # edit newsystem RetroPie name
	mkRomDir "$_system"

	# ensure run_mess.sh script is executable
	chmod 755 "$_script"

	# add the emulators.cfg as normal, pointing to the above script # use old mess name for booting
	addEmulator 0 "lr-mess-system-bbcb-flop1" "$_system" "$_script $_retroarch_bin $_mess $_config \bbcb $biosdir/mame -autoframeskip -flop1 %ROM%"
	addEmulator 0 "mame-system-bbcb-flop1" "$_system" "/opt/retropie/emulators/mame/mame -v -c bbcb -flop1 %ROM%"
        addEmulator 0 "mame-system-bbcb-flop1-autoframeskip" "$_system" "/opt/retropie/emulators/mame/mame -v -c -autoframeskip bbcb -flop1 %ROM%"

	# add system to es_systems.cfg
	#the line used by @valerino didn't work for the original RetroPie-setup 
	#therefore the information is added in a different way
	addSystem "$_system" "BBC Micro Model B" ".zip .7z .1dd .360 .adf .adl .adm .ads .bbc .bin .cqi .cqm .csw .d77 .d88 .dfi .dsd .dsk .fsd .hfe .ima .imd .img .ipf .mfi .mfm .prn .rom .ssd .td0 .uef .ufi .wav "	
}

