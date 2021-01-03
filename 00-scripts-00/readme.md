#generate-lr-mess-systems.sh

Stable version to generate @valerine alike scripts with lr-mess system names.

It will not generate for systems that support no media.


#generate-lr-mess-systems-1v3-alpha.sh

Test version to generate @valerine alike scripts with RetroPie system names, if possible.

If not possible use lr-mess system names.

It will not generate for systems that support no media.

Only in the generated @valerino alike scripts, mouse and autoframeskipping is turned on for all systems.


#generate-lr-mess-systems-1v4-alpha.sh

Test version to generate @valerine alike and command scripts with RetroPie system names, if possible.

If not possible use lr-mess system names.

Only in the generated @valerino alike scripts, mouse and autoframeskipping is turned on for all systems.

It will generate command scripts for systems that support no media.


#generate-desired-systems.sh

This is a bash script to "batch" create single/multiple desired system(s)

Open the file with a text editor.

Uncomment the version you want to generate the scripts with.

Uncomment one or multiple systems to generate.


--


Introduction :

@valerino did a thread on proper lr-mess intergration for RetroPie.

In the https://retropie.org.uk/forum/topic/28345/old-computer-appreciation-thread we created 2 @valerino alike scripts for systems that had no @valerino script.

All the @valerino scripts are mostly the same.

So this is how I got this idea on 27-11-2020.


The idea :

We want to be able to generate all the scripts for all those systems that still have no @valerino script.

We extract all info from standalone MAME and use this information to create a @valerino alike script.

It's possible to create many, MAME/MESS/lr-mess can run thousands of systems.

The first version (generate-lr-mess-systems) will generate scripts with MAME/lr-mess names.

Explanation :

If you want to generate a script for the MSX type "hbf700p" the script will use hbf700p as module id.

It will also add the media type that can be run if the script is installed.

( -cart / -flop / -cass etc. ) 


Idea added in generate-lr-mess-systems-1v3-alpha and generate-lr-mess-systems-1v4-alpha :

Because there are no es-themes yet for lr-mess system names we came up with the next idea.

These versions generate scripts with RetroPie system names, if possible.

If RetroPie system names are used then existing es-themes will be used for the installed system.

It checks MAME system descriptions with RetroPie system descriptions.

If there is a match it will use the RetroPie system name.

Otherwise it will keeps using the MAME system name. 

Explanation :

If you want to generate a script for the MSX type "hbf700p" the script will use "msx" now as module id.

So it can use the existing msx es-theme.


Idea added in generate-lr-mess-systems-1v3-alpha and generate-lr-mess-systems-1v4-alpha:

Many systems use mouse.

In the @valerino scripts mouse is turned off.

Only in the generated @valerino alike scripts it's turned on as a test.

If all systems work well with mouse enabled, we will keep it on to support the systems with mouse.

Also autoframeskipping is enabled as a test. 

You can use F8,F9 and F11 to experiment with frameskipping.


Idea added generate-lr-mess-systems-1v4-alpha:

This version will also generate command-scripts.

This will act the same as if lr-mess is installed the original way in RetroPie.

Only now you can install for your desired system, which is not yet implemented in The original RetroPie.

It will use the standard core options, if not changed, it will use mame_softlists_enable = "enabled".

If used for running zip files, it tries to find the system in the mame softlist and will run accordingly.

You can also create and run your own .cmd file.

In this .cmd file you can customize or add many things on how you want to boot your rom.

Example (oilswell.cmd), including autoboot and media type cassette :

hbf700p -rp /home/pi/RetroPie/BIOS -autoboot_command load"cas:",r\n -autoboot_delay 8 -cass "/home/pi/RetroPie/roms/msx/cassettes/OILSWELL.CAS"


Idea added generate-lr-mess-systems-1v4-alpha:

Added the possibility to generate command scripts for handhelds described in @DTEAMS tutorial.

https://retropie.org.uk/forum/topic/28462/tutorial-handheld-and-plug-play-systems-with-mame?_=1609426789602

While not RetroPie standard, it will use @DTEAM naming as RetroPie naming.

This is done to match possible existing es-themes for these systems.

I am also hoping this naming will be used in future RetroPie versions.


install :

Go to the website and download it clicking on the button "code" -> "download zip" (https://github.com/FollyMaddy/RetroPie-Share)

Extract RetroPie-Share-main.zip. 

You will find the files in 00-script-00. 

Put these somewhere, in a seperate directory, on you pi.

Or you can do (on the pi) :

pi@raspberrypi:~ $ cd

pi@raspberrypi:~ $ git clone https://github.com/FollyMaddy/RetroPie-Share.git

pi@raspberrypi:~ $ cd RetroPie-Share/

pi@raspberrypi:~/RetroPie-Share $ cd 00-scripts-00/


Run :

Everything is explained in the help.

Do this to read the help :

bash generate-lr-mess-systems.sh -h

or

bash generate-lr-mess-systems-1v3-alpha -h

or

bash generate-lr-mess-systems-1v4-alpha -h
