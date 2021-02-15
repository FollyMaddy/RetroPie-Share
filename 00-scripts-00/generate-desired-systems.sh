#!/bin/bash


#uncomment the version you want to use

#versions
#version=generate-lr-mess-systems.sh
#version=generate-lr-mess-systems-1v3-alpha.sh
#version=generate-lr-mess-systems-1v4-alpha.sh
#version=generate-lr-mess-systems-1v5-alpha.sh
version=generate-systems-lr-mess_mame-1v8-alpha.sh

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
#bash $version apple2gs # bootable
#bash $version mtx512 # bios files missing
#bash $version vectrex 
#bash $version nes 

#handhelds (use version 1v4-alpha or above)(creates only cmd scripts)(these systems have no external media)
##such a cmd script can be created with one game and used for many ! 
#bash $version ablmini # creates cmd script for all_in1 # bootable 
#bash $version alnattck # creates cmd script for classich # bootable
#bash $version gnw_ball # creates cmd script for gameandwatch # bootable 
#bash $version jak_batm # creates cmd script for jakks # bootable
#bash $version kgradius # creates cmd script for konamih # bootable
#bash $version taddams # creates cmd script for tigerh # bootable
#bash $version rzbatfor # creates cmd script for tigerrz # bootable

#amiga
#bash $version a500 # bootable (needs extra keyboard rom), sometimes sluggish, not always good sound, mouse not working oob

#msx systems
#bash $version fsa1wsx # bootable # FS-A1WX / 1st released version (Japan) (MSX2+)
#bash $version hbf700p # bootable # HB-F700P / Sony (MSX2)