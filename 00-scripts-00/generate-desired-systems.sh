#!/bin/bash


#uncomment the version you want to use

#version=generate-lr-mess-systems.sh
#version=generate-lr-mess-systems-1v3-alpha.sh
version=generate-lr-mess-systems-1v4-alpha.sh


# use 1 or more lines to create one system or more systems
# by uncommenting -> remove #

#bash $version x1 # bootable
#bash $version mz2500 # bootable
#bash $version fm77av # bootable
#bash $version pc6001 # bootable
#bash $version pc6001mk2 # bootable
#bash $version zx81 # bootable
#bash $version smc777 # bootable
#bash $version astrocde # bootable
#bash $version arcadia # Emerson # bootable # No bios needed 
#bash $version videopac #videopac g7000 # bios files missing
#bash $version g7400 #videopac g7400 # bios files missing
#bash $version apple2gs # bios files missing
#bash $version mtx512 # bios files missing

#handhelds (creates cmd scripts, systems have no "external media")
##such a cmd script can be created with one game and used for many ! 
#bash $version kgradius # creates cmd script for konamih # bootable
#bash $version gnw_ball # creates cmd script for gameandwatch #

#amiga
#bash $version a500 # bootable (needs extra keyboard rom), sometimes sluggish, not always good sound, mouse not working oob

#msx systems
#bash $version fsa1wsx # bootable # FS-A1WX / 1st released version (Japan) (MSX2+)
#bash $version hbf700p # bootable # HB-F700P / Sony (MSX2)