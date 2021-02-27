# Introduction :

This is how I got started on with this project on 27-11-2020.

@valerino made a thread on the proper lr-mess intergration for RetroPie here :

https://retropie.org.uk/forum/topic/25576/new-scriptmodules-lr-vice-xvic-gsplus-proper-lr-mess-integration

@valerino made a fork of the RetroPie-setup with added module-scripts for running about 80 systems with lr-mess.

But lr-mess / MAME can emulate litteraly thousands of systems for where there are no module-scripts in the @valerino fork.

So I manually created 2 @valerino alike scripts for systems that had no @valerino script in this thread :

https://retropie.org.uk/forum/topic/28345/old-computer-appreciation-thread

All the @valerino scripts are mostly the same, so it's possible to automate this.

The idea behind this project is be able to generate module-scripts for the desired systems that lr-mess / MAME can emulate.

Information about the supported system-types in lr-mess / MAME can be extracted from MAME.

We can use this information to create module-scripts that we want to create.

Once created, we can install these module-scripts in the RetroPie-setup.

While busy with this project, I also added more things like :

- using this BIOS directory for both lr-mess and MAME : /home/pi/RetroPie/BIOS/mame

- turning lr-mess / MAME system-types into RetroPie system names so the RetroPie themes can match

- adding the handheld systems of @DTEAM found here : 
 
  https://retropie.org.uk/forum/topic/28462/tutorial-handheld-and-plug-play-systems-with-mame

- creation of module-scripts that will work with the original RetroPie-setup

  For lr-mess only the run_mess.sh from valerino is needed, install this with :

  ```wget -nv -O /home/pi/RetroPie-Setup/scriptmodules/run_mess.sh https://raw.githubusercontent.com/valerino/RetroPie-Setup/master/scriptmodules/run_mess.sh```

- creation of module-scripts that will work with the @valerino fork of the RetroPie-setup

- adding the rompaths for MAME in the cmd module-scripts

- saving generated files directly in RetroPie-setup

Above additions are mainly in the latest version.

In this thread the ideas, discoveries, issues, fixes and improvements are being discussed :

https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone

( @DTEAM is helping a lot ! )


# How to install :

Go to the website and download it clicking on the button "code" -> "download zip" (https://github.com/FollyMaddy/RetroPie-Share)

Extract RetroPie-Share-main.zip. 

You will find the files in 00-script-00. 

Put these somewhere, in a seperate directory, on you pi.

Or you can do (on the pi) :

pi@raspberrypi:~ $ cd

pi@raspberrypi:~ $ git clone https://github.com/FollyMaddy/RetroPie-Share.git

pi@raspberrypi:~ $ cd RetroPie-Share/

pi@raspberrypi:~/RetroPie-Share $ cd 00-scripts-00/


# How to run :

Everything is explained in the help.

Do this to read the help :

bash generate-lr-mess-systems-1v8-alpha -h


# File descriptions :

## generate-systems-lr-mess_mame-1v8-alpha.sh

This is a bash script for generating module-scripts for RetroPie-setup.


## generate-desired-systems.sh

This is a bash script to "batch" create single/multiple desired system(s).

Open the file with a text editor.

Uncomment the version you want to generate the scripts with.

Uncomment one or multiple systems to generate.

## get-cheats-artwork-overlays.sh

Does this in one go :

 * Download cheats for MAME standalone/lr-mess

 * Download artwork for MAME standalone (@DTEAM handhelds)
 
 * create custom configs for retroarch overlays and extract backgrounds for running with lr-mess (@DTEAM handhelds)

You can run it directly without even downloading it as a file, with this command :

```curl https://raw.githubusercontent.com/FollyMaddy/RetroPie-Share/main/00-scripts-00/get-cheats-artwork-overlays.sh | bash```


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
