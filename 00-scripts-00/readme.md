# BACKUPED / OLD / NOT USED ANYMORE

# Searching for the files ? Look in the backup folder !

# Everything is now merged inside : https://github.com/FollyMaddy/RetroPie-Share/blob/main/00-scriptmodules-00/supplementary/add-mamedev-systems.sh

# --------------------------------------------------------------

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

- using this BIOS directory for both lr-mess and MAME : /home/user_name/RetroPie/BIOS/mame

- turning lr-mess / MAME system-types into RetroPie system names so the RetroPie themes can match

- adding the handheld systems of @DTEAM found here : 
 
  https://retropie.org.uk/forum/topic/28462/tutorial-handheld-and-plug-play-systems-with-mame

- creation of module-scripts that will work with the original RetroPie-setup

  (from 1v8 not needed anymore)

  ~~For lr-mess only the run_mess.sh from valerino is needed, install this with :~~

  ~~```wget -nv -O /home/pi/RetroPie-Setup/scriptmodules/run_mess.sh https://raw.githubusercontent.com/valerino/RetroPie-Setup/master/scriptmodules/run_mess.sh```~~ 

- creation of module-scripts that will work with the @valerino fork of the RetroPie-setup

- adding the rompaths for MAME in the cmd module-scripts

- saving generated files directly in (/home/user_name/RetroPie-setup) or saving it in the new possible external directory (/home/user_name/RetroPie-setup/ext/<external_repository_name>)

Above additions are mainly in the latest version.

In this thread the ideas, discoveries, issues, fixes and improvements are being discussed :

https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone

( @DTEAM is helping out a lot ! Thank you ! )


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

NOTE: 

This part is outdated !

We are now working on a front-end script.

The help part is therefor removed from 2v0 and above.

This way we can paste the generator script better into the front-end script.

I am not sure if I will put back the help part inside again !

END NOTE.

--------

This is still relevant for this version :

Everything is explained in the help.

Do this to read the help :

```bash generate-lr-mess-systems-1v8-alpha -h```

--------

Basically it always works like this :

Find a system that you want to install using, for example, the next command.

It will create a text file with possible systems.

```/opt/retropie/emulators/mame/mame -listdevices | grep Driver > possiblesystems.txt```

If you found a system,for example coleco, then run the next cmd with the added "system" like this.
 

```bash generate-systems-lr-mess_mame-2v1.sh coleco```

Above command will generate the module-scripts into (/home/user_name/RetroPie-setup).

If you want to generate into the external repositories directory (/home/user_name/RetroPie-setup/ext/external_repository_name) use :

```bash generate-systems-lr-mess_mame-2v1.sh-ext coleco```

You can do the same without even downloading my repository or scripts  !

You can just run them online ! (make sure you have "curl" installed (sudo apt install curl))

```curl "https://raw.githubusercontent.com/FollyMaddy/RetroPie-Share/main/00-scripts-00/backup/generate-systems-lr-mess_mame-2v1.sh" | bash -s coleco```

or

```curl "https://raw.githubusercontent.com/FollyMaddy/RetroPie-Share/main/00-scripts-00/backup/generate-systems-lr-mess_mame-2v1-ext.sh" | bash -s coleco```


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

Note :

Now that @russelb has improve the @valerino run_mess.sh script.

Game specific configs should are now possible with lr-mess !

I leave next part in here, as it can be a solution for something not foreseen yet.

--------

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
