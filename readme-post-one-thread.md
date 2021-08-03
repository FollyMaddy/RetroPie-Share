# A very small instruction on how to use this :

This project has evolved in such a way that it's now possible to use a front-end module-script.

**Although this will work, you have to remember that this is still an early test version, so it can have issues !**

If you are able to paste a file into your /home/pi/RetroPie-Setup/scriptmodules/supplementary then you can simply copy the front-end script into the RetroPie-Setup.

Just do these few steps :
- Download this file and extract it :
https://github.com/FollyMaddy/RetroPie-Share/archive/refs/heads/main.zip

- Copy `00-workdir-00/add-mamedev-systems-test8.sh` to
`/home/pi/RetroPie-Setup/scriptmodules/supplementary/add-mamedev-systems-test8.sh`

- Be sure there are `no` other versions of `add-mamedev-systems` in the same directory, remove them !

- Run RetroPie-Setup and go to :
   - Configuration / tools
   - add-mamedev-systems 

Now you can install :
- lr-mess/mame **<-- make sure you do this first, otherwise you can't add systems !**
- lr-mess/mame systems
- the handhelds by @DTEAM  
[link to the handheld and plug & play systems of @DTEAM](https://retropie.org.uk/forum/topic/28462/tutorial-handheld-and-plug-play-systems-with-mame/2)
- special systems with added slot-devices
(for example : nes_datach,famicom_disksys,famicom_famibs3)
- other systems that are mentioned in the threads
- download retropie-gamelists 
- download mame-artwork 
- create overlays from mame-artwork for running handhelds with lr-mess

(make sure you put the BIOS files in **-->>** **`~/RetroPie/BIOS/mame`** **<<--**)

**WIP : As a reference, @dmmarti is making a google-sheet with useful information on the tested systems.**
**So after you have installed a system you can find the useful notes here :**
**https://docs.google.com/spreadsheets/d/1AQ28J9OUKg55R3d-TZkWO3GH50KjC2hHteCP1Bx59Ns/edit?usp=sharing**


![2021-06-09-080708_1600x900_scrot.png](https://retropie.org.uk/forum/assets/uploads/files/1623219164203-2021-06-09-080708_1600x900_scrot.png)  


**For those who want to use cli/terminal commands or want to know/learn more stuff then you are welcome to read more about this project.**

# About this project :

[This is the link](https://github.com/FollyMaddy/RetroPie-Share/tree/main/00-scripts-00) to my project :

I have created this project while I was busy with the RetroPie-setup fork from @valerino.
@valerino made modulescripts for systems running with lr-mess.
Some systems were not created by @valerino so i created 2 myself.
While doing that, creating such a script was basically the same everytime.
This is why I made this script to automate this process.
In version 1v8-alpha I also added mame.
It is also possible to create the handhelds used in [the handheld tutorial thread of @DTEAM](https://retropie.org.uk/forum/topic/28462/tutorial-handheld-and-plug-play-systems-with-mame).

Above is basically the the short explanation  of the script.

This thread is created to share ideas, discuss and improve the script.

This first post is used to summarize the discovery's and add more information about the project.

The project contains work of :
- @folly (https://github.com/FollyMaddy)
- @DTEAM (https://github.com/DTEAM-1)
- @valerino (https://github.com/valerino)
- @RussellB 
- @dmmarti 
- @JimmyFromTheBay 
- Matt Huisman (https://github.com/matthuisman)


# Global discoveries / issues / fixes / ideas :

**👍 closed :** Discovered by  @DTEAM / Fixed by @folly / ***(game roms directory is not changed in this fix !)***  :
Amiga CD32 system name in mame commandlines are not correct. [96](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/96)
The problem should be solved now for `amiga` and `other systems`. [97](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/97)

**👍 closed :** Discovered by  @folly / Fixed by @folly :
In the script generator I used the path `/home/pi` many times.
But if you use RetroPie with a different user this will conflict.
So I converted `/home/pi/` into `$HOME/`.

**👍 closed :** Tested by @DTEAM / Fixed by @folly / Fix tested by @DTEAM ( it should work with a good mess game rom set ):
(I hope this is a good solution and that there are no  conflicts )
Cheats for `lr-mess` in MAME UI (with hash files) work with **mame_cheats_enable = "enabled"** in `custom-core-options.cfg`. [22](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/22) etc.
I have updated the script so the `install-<system>-cmd module-script will add **mame_cheats_enable = "enabled"** in *retroarch-core-options.cfg* when installing in RetroPie-setup.

**👍 closed :** Noted by @DTEAM / Fixed by @folly / Fix not yet tested, but should work :
Get cheats working for `MAME` in MAME UI (with hash files).
Added : [51](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/51) [52](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/52)

**👉 open :** Discovered by @DTEAM :
C64 and Atari Jaguar not working with basename (Hash file). [12](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/12)
Basically this comes down to the mame-basename commands.
I Think we can only use basename lines for systems without media and where we have added the rompath in the commandline.
If other lines work also, like mame-cmd, we could consider to remove the mame-baseline commands. I did some tests. [108](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/108)
Second test with mame and supracan works [317]( https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/317)
**Earlier relevant backup !!! 👍 closed :** Discovered by  @DTEAM / Fixed by @folly :
This command will work for **gamate**, so added these addEmulator lines in  generate-systems-lr-mess_mame-1v8-alpha.sh and renamed the old ones to `*-test` :
addEmulator 0 "mame-basename" "\$_system" "/opt/retropie/emulators/mame/mame -v -c ${newsystems[$index]} %BASENAME%"
addEmulator 0 "mame-basename-autoframeskip" "\$_system" "/opt/retropie/emulators/mame/mame -v -c -autoframeskip ${newsystems[$index]} %BASENAME%"
(22-02-2021) Turned off the *-test commands. [33](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/33)
(28-05-20121) Removed the test lines in version 2v2

**👉 open :** Discovered by @folly : 
Coleco wants the bios in `/home/pi/RetroPie/roms/coleco/coleco.zip`, test again. [60](https://retropie.org.uk/forum/topic/28462/tutorial-handheld-and-plug-play-systems-with-mame/60)

**👉 open :** Discovered by @folly : 
Someone else is also busy with handhels.
Something to check, I think :
https://retropie.org.uk/forum/topic/30155/lcd-handhelds-mame-0-229-dat

**👍/👉 wip :** by @folly : 
Improving recognition and conversions of mamedev system naming to RetroPie naming adding :
- BBC Micro => bbcmicro (matching carbon theme now) [see commit](https://github.com/FollyMaddy/RetroPie-Share/commit/7b55a4770955f4ec18408bd032cc15fd255e413c)
- BBC Master => bbcmicro  (matching carbon theme now) [see commit](https://github.com/FollyMaddy/RetroPie-Share/commit/7b55a4770955f4ec18408bd032cc15fd255e413c)
- Adam  => coleco  (matching carbon theme now) [see commit](https://github.com/FollyMaddy/RetroPie-Share/commit/522be8d76adc9bb24c89fe471761ff6a82ff0c45)

**👉 wip :** Discovered by  @DTEAM / ~~Fixed by @folly~~ / ***(UI button does not always work, depending on the system !)***  :
It would be nice if we could always use the UI-button/TAB when we are in mame / lr-mess.  
We can do this by adding **-ui_active** to the mame / lr-mess lines. 
That way it's always on.
- @folly added -ui_active in the scripts [284](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/284)
- testing has to be done !

**👉 wip :** Idea by  @dmmarti 
Create a reference sheet with useful information on tested systems [471](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/471)


# The idea of making a frond-end script :

**👉 wip :**  By @valerino (initial idea) / @folly (ideas/creating script) / @DTEAM (ideas/googledrive_media/testing)  :
Create a front-end module-script in RetroPie-setup for our scripts.
- **(used)** Structure/plan [129](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/129) --> 136
- **(used)** Schematic menu structure something like this [207](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/207) 
- **(done)** Add a menu in RetroPie-setup using the dialog api [120](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/120)
- **(done, using or creating a csv structure for every menu page)** Try to use 1 existing array for the menu [125](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/125)
- **(not added, but you can install mame and lr-mess from the menu)** Dependencies check 
- **(ok)** Possibility to push the generated scripts in the normal /home/pi/RetroPie-Setup/scriptmodules/ directory ? 
- **(ok)** Push the generated scripts in /home/pi/RetroPie-Setup/ext/RetroPie-Share/scriptmodules/ ? 
- **(ok)** What about refreshing RetroPie-setup ? 
We want to install the generated module-script directly after generation ? 
We could use *retropie_packages.sh* for this purpose.[136](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/136)
- **(ok)** Add download part to download, for example, gamelists, images and videos etc. 
- **(possible to do manually or with a curl line or using module-script `add-ext-repos.sh`, but noting is included in the script though)** 
Download the repository in /home/pi/RetroPie-Setup/ext/RetroPie-Share or try to run the scripts online [140](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/140) ?
- **(now that we can be copy the updated generator-script into the frond-end as a function this part is not relevant here anymore)** 
Try to keep multiple emulator/lr-cores in 1 generated script module [125](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/125)
- **(done)** Show correctly sorted systems and descriptions in the sub-menus [290](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/290)(issue) [470](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/470)(fix)
- **(re-done in version test7 and version test8)** Adding a submenu to install our selection of systems, described from here [524](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/524) and here [link_xls_@dmmarti](https://docs.google.com/spreadsheets/d/1AQ28J9OUKg55R3d-TZkWO3GH50KjC2hHteCP1Bx59Ns/edit?usp=sharing)
- **(done in version test8)** Adding a submenu to install systems with slotdevices. 
In the links you can find some examples  [547 ](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/547) [548 ](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/548) [diff_thread_2](https://retropie.org.uk/forum/topic/31026/booting-the-dragon-32-in-lr-mess-without-a-disk-drive/2)
- **(--)** Separate Arcade from the rest [410](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/411)
- **(--)** Update mess doc when front-end module-script works [161](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/161)

Issues regarding front-end :
- We discovered an issue with mame [link_issue_1](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/430)
Temporary fix : the front-end script makes now use of our own database

# The ideas of downloading stuff and creating overlays :

**👍/👉 wip :**  By @DTEAM  @folly / get-cheats-artwork-overlays.sh does this trick for now / tested ok by @folly and @DTEAM  :
**( Todo : Can we also make it work from within the module scripts ? )**
 It would be nice if we could find a good way of automatically installing cheats, artwork, retroarch-overlays, gamelists and themes from within the module-scripts or some other way. [37](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/37)  **etc ---->41**
It doesn't work properly with above solutions.
*Edit : The first solution can be tested again, Matt has altered his code with my suggestions. (tested ok @folly) [63](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/63)*
It seems we have a solution now.  [46](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/46)

=>Add cheat file to the get script :
- @DTEAM shared the link
- @folly added the download part

=>Add artwork to the get script :
- @DTEAM shared the link
- @folly added the download part
- @folly added the background extraction part for lr-mess overlays [50](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/50)
- @DTEAM converted some artwork so the background extraction works [53](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/53)
- @folly added the config creation part for lr-mess overlays

=>Add gamelists files to the get script :
- @DTEAM shared the link
- @folly added .7z an .zip compatibility in the gamelists [81](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/81) [(link used script)](https://github.com/FollyMaddy/RetroPie-Share/blob/main/00-scripts-00/backup/gamelist-add-7z-zip.sh)
- @folly added the download part

=>Add  theme files to the get script :
Not done yet.

# The ideas in  generate-systems-lr-mess_mame.sh version 2v1 or earlier :

**👍 closed :** By @folly / fixed by @folly in 2v0 [(see commit)](https://github.com/FollyMaddy/RetroPie-Share/commit/6f4d53a81a362961ab5481fc8e503a0745ad1ac1) / tested ok @folly :
Instead of downloading the scripts, running bash scripts online could be a nice solution for the future and/or to add into the menu. 
Here it is used with the get-cheats-artwork-overlays.sh script. [66](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/66)
For the generator script I also tried this, including a solution to add the option string :
Note : it sees the option string but the program has a grep failure, perhaps this can be solved in the future.
Edit : OK after commit
```
curl https://raw.githubusercontent.com/FollyMaddy/RetroPie-Share/main/00-scripts-00/generate-systems-lr-mess_mame-2v0-alpha.sh | bash -s kgradius
```

**👍 closed :** By @folly / fixed by @folly in 2v0 [(see commit)](https://github.com/FollyMaddy/RetroPie-Share/commit/4c97b452520faa6822e84b1956145da3d310e467) / tested ok @folly :
When you run the generate-systems-lr-mess_mame-2v0-alpha.sh it will install the @valerino run_mess.sh script if not detected.



**👍 closed :**  By @RussellB / Improve the run_mess.sh script / added by @folly / tested by @folly, @DTEAM and @RussellB   :
This allows us to specify custom configs, including  bezels and screen locations, etc. per rom.
Here you can read what the run_mess.sh script does [173](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/273) .
- @RussellB added the idea  [146](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/246)
- @folly tested this idea [150](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/250)
- @folly added it to github and in the scripts [167](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/267)
- @folly and @DTEAM tested the generator scripts on general issues
- @RussellB tested it with configs and bezels [280](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/280)

# The ideas in  generate-systems-lr-mess_mame.sh version 2v2 or above :

**👍 closed :**  By @folly / added by @folly in 2v2 / tested  by @folly :
Add translation "ai" lines to retroarch.cfg when installing a module-script :
- Using hotkey "t" will translate the picture and pause the screen and translate
- Press "t" again to resume the game.
- You might want to make a save-state before translating, if you experience a crash while translating.

**👍 closed :**  By @folly / added by @folly in 2v2 / tested  by @folly :
Add cheats to the correct mame.ini when installing a module-script :
- version 2v1 added this in the wrong mame.ini 
- version 2v2 should be ok now

**👍 closed :** Idea by  @JimmyFromTheBay / added by @folly in 2v2 / tested  by @folly :
Create game specific lr-mess and mame config files so we have input configs per game [thread](https://retropie.org.uk/forum/topic/30949/are-per-game-control-mappings-possible-in-mess)
This is done by adding game-specific-config runcommand lines in the emulators.cfg when installing a module-script :
- if you load a game with the line containing "game-specific" then game-unique sub-directories are made with mame/lr-mess config files
- now it's possible to change the input per game in the mame-UI or lr-mess-UI
- to prevent conflicts between mame and lr-mess don't use the same config files, they get their own sub-directory
- config files for mame are save in /opt/retropie/configs/<RETROPIE-SYSTEM>/mame/<GAME>/<MAME-SYSTEM>.cfg
- config files for lr-mess are save in /opt/retropie/configs/<RETROPIE-SYSTEM>/lr-mess/<GAME>/<MAME-SYSTEM>.cfg

**👍 closed :**  By @folly / added by @folly in 2v2 / tested  by @folly :
Because more starter lines are being added in the emulators.cfg's it can get bit of a mess.
Therefor it would be nice if the starter lines in the emulators.cfg's could be sorted.
Sorting the content of an emulators.cfg should be done after new lines have been added. 
The generator script will add the sorting part in the generated module-scripts.
When these module-scripts are installed, sorting of the specific emulators.cfg will then take place. [332](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/332)

# The ideas in  generate-systems-lr-mess_mame.sh version 2v3 or above :

**👍 closed :**  By @folly / added by @folly in 2v3 / tested  by @folly :
Add the possibility to install systems with slotdevices and manual detected slotdevice configurations. 
In the links you can find some examples  of systems [547 ](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/547) [548 ](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/548) [diff_thread_2](https://retropie.org.uk/forum/topic/31026/booting-the-dragon-32-in-lr-mess-without-a-disk-drive/2)
If you want to install similar systems with this script then you have to make your own command.
The structure is as follows :
$1=system $2=RPsystemName $3=ExtraPredefinedDevice(s) $4=mediadescription $5=media $6=extension(s)
$3 and $6 can take multiple options seperated by a \*
Look for example lines in generate-desired-systems.sh .

**👍 closed :**  By @folly / added by @folly in 2v3 / tested  by @folly :
Prevent creating the same cmd module-scripts every time.
If a system has more media then it has more values of the same system in the array.
That is why it normally would create more cmd module-scripts.
To prevent this from happening, we have to use an if function to be sure it is only generated and installed once per system.
The if function will check if the last created system is not equal to the next system in the array.
It will speed up increasingly, now that it doesn't do the same multiple times.
\*installing only happens from within the front-end module-script
[link_to_commit_=>_lines_591-597](https://github.com/FollyMaddy/RetroPie-Share/commit/b707f00e4414e49cab4968bf3d2fe1dac9b7f50f)

**👍 closed :**  (low priority) :**  By @folly :
The help in the created module-scripts are automatically created and not always correct. 
It would be nice if we could add a database file that can be read during generating. 
So when good information is available it could use that instead of the automatically created help.
Edit : 
Perhaps this mame command can help to improve the help sections :
/opt/retropie/emulators/mame/mame -listroms <system>
Solution:
Most people, who are using this, know which bios files they have to use.
Therefor I didn't add more info to the help but I removed specific bios information from the help in 2v3.
This way no incorrect information is give anymore.
To get solutions users can always check the `/dev/runcommand.log` if something isn't working.

**`⚠` closed (low priority) :**  By @DTEAM / @folly :
*(Closed because of too much effort versus gain, I am quite happy how it works in 2v3)*
Join all media/cmd command lines of 1 system into 1 generated script [101](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/101) [102](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/102) [107](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/107)

**👉 open :**  By  @folly :
Improving the naming of the runcommand-lines to a more understandable standard.

**👉 open (low priority) :**  By @hhtien1408 / @folly :
Add support for lr-mame [327](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/327) --> 329

# Good to know :
By @folly :
Because mame is also added as emulator and because mame is using a different BIOS directory, $HOME/RetroPie/BIOS/mame ,
the lr-mess command is changed to use the same BIOS directory.

By @folly :
lr-mess doesn't load roms if mame artwork is present in :
`/home/pi/RetroPie/BIOS/mame/artwork`

By @folly / @DTEAM :
When there are multiple config/ini which one is used ? :
- mame.ini --> opt/retropie/configs/mame/mame.ini [364](https://retropie.org.uk/forum/topic/29682/development-of-module-script-generator-for-lr-mess-and-mame-standalone/364)

By @folly :
Here we can find autoboot lines :
https://forums.launchbox-app.com/topic/54987-autoboot-command-script-for-mame-swl-computer-systems/

# MAME Announcements :
[link_to_whats_new_in_mame](https://forum.mamedev.org/viewforum.php?f=12&sid=ac328e1cac5b6641e50776f5103e6aa0)
