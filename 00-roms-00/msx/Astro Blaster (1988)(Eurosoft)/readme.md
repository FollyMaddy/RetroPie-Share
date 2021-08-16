poke fix for : Astro Blaster (1988)(Eurosoft).dsk

md5sum : 6a65f8df7b188c4cc5d1c52a3b63a46e  

---

manually fix without IPS_patch : 

I altered the .dsk with openmsx.

You have to eject the disk on boot and later insert it again when you are in basic.

That way you can see the files on disk with the command files.

Then you have to load astro.ldr with load"astro.ldr".

Do list or in this case you can do list 1-2.

Alter the POKE -1,255 into POKE -1,(15-PEEK(-1)\16)*17 .

Remove WITDH40

Do list or in this case you can do list 20.

Leave only RETURN

Then save the file again with save"astro.ldr"

Now the .dsk file is changed and you will be able to load it into the other emulators.

