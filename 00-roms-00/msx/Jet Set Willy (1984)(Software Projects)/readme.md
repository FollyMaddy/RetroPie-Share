poke fix for : Jet Set Willy (1984)(Software Projects).dsk

md5sum : 50f8b3e89c4a75ec5b7c3fa12edfe13c

---

manually fix without IPS_patch : remove the "umb" (upper memmory block) in the config.sys

I altered the .dsk with openmsx.

You have to eject the disk on boot and later insert it again when you are in basic.

That way you can see the files on disk with the command files.

Then you have to load JETSET.BAS with load"jetset.bas".

Do list or in this case you can do list 0.

Alter the POKE -1,170 into POKE -1,(15-PEEK(-1)\16)*17 .

Then save the file again with save"jetset.bas"

Now the .dsk file is changed and you will be able to load it into the other emulators.

