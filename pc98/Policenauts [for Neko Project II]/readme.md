memory fix for : Policenauts (User boot disk) [for Neko Project II].hdm

md5sum : 9dec4162320ec70fa8701a270cd36124

fix without IPS_patch : remove the "umb" (upper memmory block) in the config.sys

- boot with "Policenauts [for Neko Project II].hdi" to get into DOS 

- go into the menu "F12"

- insert fdd1 : "Policenauts (User boot disk) [for Neko Project II].hdm"

- press "enter" to get the prompt again

- type -> b: ( use " for : )

- type -> sedit config.sys

- remove the "umb" (upper memmory block)

- press "F1" -> select "S" for saving -> select "Q" to quit

- type -> del config.bak (to remove the backup file)

- quit the emulator and boot with the .cmd file

tested emulator(s) : lr-np2kai

works with : sound-board = PC9801-86

added : .cmd file for booting
