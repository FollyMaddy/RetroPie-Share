# generate-lr-mess-systems-1v2-alpha.sh

Stable version to generate @valerine alike scripts with lr-mess system names.

It will not generate for systems that support no media.


# generate-lr-mess-systems-1v3-alpha.sh

Test version to generate @valerine alike scripts with RetroPie system names, if possible.

If not possible use lr-mess system names.

It will not generate for systems that support no media.

Only in the generated @valerino alike scripts, mouse and autoframeskipping is turned on for all systems.


# generate-lr-mess-systems-1v4-alpha.sh / generate-lr-mess-systems-1v5-alpha.sh

Test version to generate @valerine alike and command scripts with RetroPie system names, if possible.

If not possible use lr-mess system names.

Only in the generated @valerino alike scripts, mouse and autoframeskipping is turned on for all systems.

It will also generate command scripts.


# generate-overlay-configs.sh

This script is created for making config files, that will run the background overlays.

The .png files are not yet included !

Goal is to add these .png files in the future.

You can read about these configs and how they work, in this readme.

# The idea :

We want to be able to generate all the scripts for all those systems that still have no @valerino script.

We extract all info from standalone MAME and use this information to create a @valerino alike script.

It's possible to create many, MAME/MESS/lr-mess can run thousands of systems.

The first version (generate-lr-mess-systems) will generate scripts with MAME/lr-mess names.

Explanation :

If you want to generate a script for the MSX type "hbf700p" the script will use hbf700p as module id.

It will also add the media type that can be run if the script is installed.

( -cart / -flop / -cass etc. ) 


# Idea added in generate-lr-mess-systems-1v3-alpha and generate-lr-mess-systems-1v4-alpha :

Because there are no es-themes yet for lr-mess system names we came up with the next idea.

These versions generate scripts with RetroPie system names, if possible.

If RetroPie system names are used then existing es-themes will be used for the installed system.

It checks MAME system descriptions with RetroPie system descriptions.

If there is a match, it will use the RetroPie system name.

Otherwise it will keep using the MAME system name. 

Explanation :

If you want to generate a script for the MSX type "hbf700p" the script will use "msx" now as module id.

So now it uses the existing msx es-theme, if installed.


# Idea added in generate-lr-mess-systems-1v3-alpha and generate-lr-mess-systems-1v4-alpha:

Many systems use mouse.

In the @valerino scripts mouse is turned off.

In the generated @valerino alike scripts it's turned on as a test.

If all systems work well with mouse enabled, we will keep it on to support the systems with mouse.

Also autoframeskipping is enabled as a test. 

You can use F8,F9,F10 and F11 to experiment with frameskipping.


# Idea added in generate-lr-mess-systems-1v4-alpha:

This version will also generate command-scripts.

This will act the same as if lr-mess is installed the original way in RetroPie.

Only now you can install for your desired system, which is not yet implemented in The original RetroPie.

It will use the standard core options, if not changed, it will use mame_softlists_enable = "enabled".

If used for running zip files, it tries to find the system in the mame softlist and will run accordingly.

You can also create and run your own .cmd file.

In this .cmd file you can customize or add many things on how you want to boot your rom.

Example (oilswell.cmd), including autoboot and media type cassette :

hbf700p -rp /home/pi/RetroPie/BIOS -autoboot_command load"cas:",r\n -autoboot_delay 8 -cass "/home/pi/RetroPie/roms/msx/cassettes/OILSWELL.CAS"


# Idea added in generate-lr-mess-systems-1v4-alpha:

Added the possibility to generate command scripts.

It can also generate command scripts for handhelds described in @DTEAMS tutorial :

https://retropie.org.uk/forum/topic/28462/tutorial-handheld-and-plug-play-systems-with-mame?_=1609426789602

While not a RetroPie standard, it will use @DTEAM naming as RetroPie naming.

This is done to match possible existing es-themes for these systems.

# generate directly in the RetroPie-Setup

Copy the scripts to :

/home/pi/RetroPie-Setup

Run the script from above location.

I am also hoping this naming will be used in the future RetroPie versions.


# Improved in generate-lr-mess-systems-1v5-alpha:

Match @DTEAM handheld naming with less loops.


# After installing a script 
## Run with a background/overlay picture for handheld or vextrex with Retroarch in lr-mess

Basically if artwork is used, the MAME way, games becoming slow in lr-mess.


So if we want to add an overlay, we have to do this another way.

With lr-vecx and Retroarch this can already be done.

For more information look here : https://retropie.org.uk/forum/topic/2638/vectrex-overlay-artwork

So here we do the exact same thing.


But how is such config for an overlay appended ?

After a succesfull run you can see how a config is appended in the /dev/shm/runcommand.log.

So I searching for '|' in the runcommand script (first with grep then in a texteditor).

That's when i found runcommand.sh appends configs if the module-id of the installed script begins with "lr-*" .

If such config if created it can be used, for example, for loading an overlay.


:-(

Tested this to see if such config appending works when the rom is loaded through the valerino run_mess.sh script,

with a valerino or valerino alike script.

It seems the game specific retroarch config is added in the commandline.

But trouble is, run_mess.sh creates a temporary .cmd file and will run this .cmd again with lr-mess. 

Because this is done from within the run_mess.sh the config isn't added anymore. Presumably.


:-)

Tested this also with a generated command script created with generate-lr-mess-systems-1v4-alpha,

running a .zip and also a .cmd when using a system that uses no media, but only a game-bios.

Both work with such a system.

But remember, you have to match the config file with the game file like this :

1 - (konamih handheld example working with lr-mess command script running .zip file)

/home/pi/RetroPie/roms/konamih/kgradius.zip

/home/pi/RetroPie/roms/konamih/kgradius.zip.cfg

/home/pi/RetroPie/overlays/konamih/kgradius.cfg

/home/pi/RetroPie/overlays/konamih/kgradius.png


or


2 - (konamih handheld example working with lr-mess command script running .cmd file)

/home/pi/RetroPie/roms/konamih/kgradius.cmd  (containing the text : kgradius)

/home/pi/RetroPie/roms/konamih/kgradius.cmd.cfg

/home/pi/RetroPie/roms/konamih/kgradius.zip 

/home/pi/RetroPie/overlays/konamih/kgradius.cfg

/home/pi/RetroPie/overlays/konamih/kgradius.png


This is what the .cmd and .cfg files contain :

*/kgradius.cmd :

kgradius


*/kgradius.zip.cfg and */kgradius.cmd.cfg (# uncommented commands can be used for experimenting) :

input_overlay = /home/pi/RetroPie/overlays/konamih/kgradius.cfg

input_overlay_enable = true

input_overlay_opacity = 0.500000

input_overlay_scale = 1.000000

#custom_viewport_width = "600"

#custom_viewport_height = "800"

#custom_viewport_width = "846"

#custom_viewport_height = "1080"

#custom_viewport_x = "0"

#custom_viewport_y = "0"

#aspect_ratio_index = "22"


*/overlay/kgradius.cfg :

#video_scale_integer = true

overlays = 1

overlay0_overlay = kgradius.png

overlay0_full_screen = false

overlay0_descs = 0



For systems that also have to run media, a cartridge for example, like vectrex, this works a bit different.

Both work with such a system, but the first option is not ideal.

1 - (vectrex example working with lr-mess command script running the .7z)

   The first option will only work, if :
    
   - the bios is in the same directory as the game
    
   - the <system>.xml or, in this case, vectrex.xml is in /home/pi/RetroPie/BIOS/mame/hash 
    
   - you use the software_name of the game from the hash table.
    
Example :

/home/pi/RetroPie/BIOS/mame/vectrex.xml

/home/pi/RetroPie/roms/vectrex/vectrex.zip

/home/pi/RetroPie/roms/vectrex/spike.7z

/home/pi/RetroPie/roms/vectrex/spike.7z.cfg 

/home/pi/RetroPie/overlays/vectrex/spike.cfg

/home/pi/RetroPie/overlays/vectrex/spike.png


or


2 - this option will work directly, and you are more flexible with game names.

  - The name "spike" does not have to match with the mame software_name, it can be, for example "spike_(1983)_usa"
  
Example :  

/home/pi/RetroPie/BIOS/vectrex.zip

/home/pi/RetroPie/roms/vectrex/spike.cmd or /home/pi/RetroPie/roms/vectrex/spike_(1983)_usa.cmd

/home/pi/RetroPie/roms/vectrex/spike.cmd.cfg  or /home/pi/RetroPie/roms/vectrex/spike_(1983)_usa.cmd.cfg

/home/pi/RetroPie/overlays/vectrex/spike.cfg

/home/pi/RetroPie/overlays/vectrex/spike.png


This is what the .cmd and .cfg files contain :

*/spike.cmd :

vectrex -rp /home/pi/RetroPie/BIOS -cart /home/pi/RetroPie/roms/vectrex/spike_(1983)_usa.7z


*/spike.cmd.cfg :

input_overlay = /home/pi/RetroPie/overlays/vectrex/spike.cfg

input_overlay_enable = true

input_overlay_opacity = 0.375000

input_overlay_scale = 1.000000

custom_viewport_width = "846"

custom_viewport_height = "1080"

custom_viewport_x = "0"

custom_viewport_y = "0"

aspect_ratio_index = "22"

video_scale_integer = true


*/overlays/spike.cfg :

overlays = 1

overlay0_overlay = spike.png

overlay0_full_screen = false

overlay0_descs = 0


