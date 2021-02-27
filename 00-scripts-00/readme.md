# generate-systems-lr-mess_mame-1v8-alpha.sh

This is a bash script for generating module-scripts for RetroPie-setup.


# generate-desired-systems.sh

This is a bash script to "batch" create single/multiple desired system(s).

Open the file with a text editor.

Uncomment the version you want to generate the scripts with.

Uncomment one or multiple systems to generate.


# Introduction :

@valerino did a thread on proper lr-mess intergration for RetroPie.

In the https://retropie.org.uk/forum/topic/28345/old-computer-appreciation-thread we manually created 2 @valerino alike scripts for systems that had no @valerino script.

All the @valerino scripts are mostly, so it's possible to automate this in a script.

This is how I got this idea on 27-11-2020.


# install :

Go to the website and download it clicking on the button "code" -> "download zip" (https://github.com/FollyMaddy/RetroPie-Share)

Extract RetroPie-Share-main.zip. 

You will find the files in 00-script-00. 

Put these somewhere, in a seperate directory, on you pi.

Or you can do (on the pi) :

pi@raspberrypi:~ $ cd

pi@raspberrypi:~ $ git clone https://github.com/FollyMaddy/RetroPie-Share.git

pi@raspberrypi:~ $ cd RetroPie-Share/

pi@raspberrypi:~/RetroPie-Share $ cd 00-scripts-00/


# Run :

Everything is explained in the help.

Do this to read the help :

bash generate-lr-mess-systems.sh -h

or

bash generate-lr-mess-systems-1v3-alpha -h

or

bash generate-lr-mess-systems-1v4-alpha -h


# Solution for game specific configs with lr-mess :

Perhaps others have a better idea.

But I think this is still an issue, in the way valarino's scripts setup the config files.

All lr-mess configs are stored in :

/opt/retropie/configs/\<system\>

This is done to clean it all up, and try to intergrade the configs into the Retropie structure.

This is ofcourse really nice !

Drawback is that you can't configure per game.

It's possible that the configs are stored in the same directory as where the game is in. (mame/cfg)

So it's possible to use different directory's for different joystick settings.

The solution is described in this thread :

https://retropie.org.uk/forum/topic/25576/new-scriptmodules-lr-vice-xvic-gsplus-proper-lr-mess-integration/377

With this solution it's possible to configure configs per game.

Just comment these lines in the valerino run_mess script /home/pi/RetroPie-Setup/scriptmodules/run_mess.sh

change :

_cmdarr+=( "-cfg_directory" )

_cmdarr+=( "$_cfgdir" )

into :

#_cmdarr+=( "-cfg_directory" )

#_cmdarr+=( "$_cfgdir" )

If you then put every game in a seperate directory.

You get a game(s) specific config (mame/cfg/apple2gs.cfg) in the same directory.

Example structure for one game :

/home/pi/RetroPie/roms/apple2gs/airball/airball.zip

/home/pi/RetroPie/roms/apple2gs/airball/mame/cfg/apple2gs.cfg

Example structure for multiple games that use the same config :

/home/pi/RetroPie/roms/apple2gs/your_specific_config/airball.zip

/home/pi/RetroPie/roms/apple2gs/your_specific_config/<other_game>.zip (etc.)

/home/pi/RetroPie/roms/apple2gs/your_specific_config/mame/cfg/apple2gs.cfg

You will be able to copy configs between directory's so you don't have to configure twice for the buttons that are the same.

And then reconfigure again.
