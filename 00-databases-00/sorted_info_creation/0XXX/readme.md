This is a readme which I created when creating the database for mame version 0271.
I made this so people can read how to make their own database and maybe help in the future to keep the mamedev.sh module-script updated.

For speed I use my minimac with M1 (8GB) and VMware for updating the database and creating most aarch64 binaries.
I have a debian12 (aarch64) installed as VM.
I use 3 cores and 5632MB of ram otherwise mame will not compile correctly due to lack of memory.

Before I begin I always update the OS with :

sudo apt update

sudo apt upgrade

I should also check if I need an updated retropie-setup.
I did not update this time as not much changes for mame these days.

Then I need to make a mame binary to extract all the data from mame.
I make sure I use a 64 bit binary because you can't extract all data from a 32 bit binary.
An aarch64 binary is always compiled when using an aarch64 OS which I am using now.
To make a resonably compatible binary for rapsberry pi's I compile/install it like this (takes about 50 min):

cd \~/RetroPie-Setup

sudo __platform=rpi3 ./retropie_packages.sh mame 

Make sure that there is no source code still in \~/RetroPie-Setup/temp/build/mame otherwise it will not work.
Normally there should be no source code but if so then you can remove it from within the retropie-setup (manage packages->experimental packages->mame->clean source folder)
or

sudo ./retropie_packages.sh mame clean

might also work.

Using above we know that we have a binary that will work on RPI3,4 and 5 with 64 bit "debian12" alike OS installed.

Then I create a 7z file of the folder mame in /opt/retropie/emulators.
I can then rename it an place it on my googledrive for sharing it within the script.

I get my latest retropie-share files and extract them and rename the folder like this RetroPie-Share-main271.
So now I can make no mistake knowing which version I am working on.
I change to that directory and create new ini files:

cd '\~/Downloads/RetroPie-Share-main271/00-databases-00/sorted_info_creation/0XXX'

bash 00-create-inis

The script 00-create-inis will extract the appropriate data from mame and overwrite the ini files one by one, on which it is working on.
It gives some errors like, Warning: unknown option in INI:, but this should be no problem.
(I might need to redirect the errors so that they are not visible anymore.)
Creating the inis can take more than 4 hours.
It is not perfect for all inis so things need to be checked afterwards.
BTW not all inis are created automatically.
After running the 00-create-inis script the date of the ini files can be checked to know which ones are created automatically or you can just check the script itself.
As for all_in1.ini is also not created automatically.
For version 271 I needed to add (265-in-1 Handheld Game (SPG2xx based) manually as suggested by @DTEAM.
Doing next command I can find the driver name that needs to be added :

/opt/retropie/emulators/mame/mame -listdevices|grep ^D|grep SPG2xx

The output will give that the driver is called '265games' and that one needs to be added.
Some inis like realistic.ini will most likely always be the same unless some drivers will be removed or renamed in future mame versions.
Now I will check all inis against the older ones with the program 'meld' (install it with :sudo apt install meld)
I am still in the folder where the new inis are, then I can run this command and check against the older 267 inis (which I still have on my drive) :

for file in *.ini;do meld $file \~/Downloads/RetroPie-Share-main267/00-databases-00/sorted_info_creation/0XXX/$file;done

After every ini check I can just alter the newest ini and save the changes.
When I close 'meld','meld' will be opened with another ini for checking until I did all the inis.

90º.ini seems ok

classich.ini :
nstarfox and mchess, which are not detected automatically, need to be added.
taddams, tbtoads, tinday, tmchammer and tnmarebc are tiger handheld and are in tigerh.ini and can be removed from classich. 
(I have added commands to remove above tiger drivers but that doesn't seem to work so I still need to do this manually)
For now classich.ini is after adding and removing still the same as older versions.

good.ini seems ok

lightgun.ini seems ok

neogeo.ini seems ok

no_media.ini seems ok

other inis are identical with older versions

So now these inis can be used for creating the new database and so I will add these inis to my repository.
This commit can be viewed on what changes there are for now:

https://github.com/FollyMaddy/RetroPie-Share/commit/d56a97ceacca213d2c069e89a6814ff04bd70137

Before we can create the new database we also want the arcade and non-arcade info in the database.
The info from progrettosnaps doesn't seem to be accurate and also the filters for compiling lr-mame and lr-mess aren't correct on the mame libretro repository.
So before we proceed we can create these subtarget filter files and arcade and non-arcade.ini files in one go first before creating the database.
We copy '\~/Downloads/RetroPie-Share-main271/00-databases-00/subtarget-filters/subtarget-0267-filters'
to 
'\~/Downloads/RetroPie-Share-main271/00-databases-00/subtarget-filters/subtarget-0271-filters'
then do the command :

cd '\~/Downloads/RetroPie-Share-main271/00-databases-00/subtarget-filters/subtarget-0271-filters'

And start the script to create these files (takes about 40 min):

bash 0-bashline-0

Above script will read if a driver uses coins or not.
If so, it's arcade.
If not, it's non-arcade.
If the script is done we can then upload the folder to the repository for backup.
Then we can put the ini files also in the folder \~/Downloads/RetroPie-Share-main271/00-databases-00/sorted_info_creation/0XXX

Now we can do the next step if the extra needed files are on progettosnaps.net.
We check on that page for these 4 files for version 271 :

Category

CatVer

renameSET

Version

If they are there we can just do the next step and create the database.
Before I do I always remove the older progettosnap files in /\~/Downloads/RetroPie-Share-main271/00-databases-00/sorted_info_creation/0XXX/progettosnaps.net/original-data
so there will be no way that the script will use older files.
then I goto the next folder :

cd '\~/Downloads/RetroPie-Share-main271/00-databases-00/sorted_info_creation/0XXX/progettosnaps.net' 

And run the command to create the new database (takes about 1 hour) :

bash 00-automate.sh

If all goes well the database mame0271_systems_sorted_info is created correctly.
After a check I saw that these 2 inis are created :
ome_system.ini and omputer.ini
While the script was busy I added these quickly to the correct inis:
home_system.ini and computer.ini
I removed the ones missing h an c.
(Seems there is an error in the script when extracting inis so will look into that later.)
When done I do a last file check and I can move it then to the folder '\~/Downloads/RetroPie-Share-main271/00-databases-00/mame' and or add it to the repository in that folder.
Now when the mamedev.sh module-script is updated it will read that database from the repository automatically.
Here you can see what has been changed to the mamedev.sh script in order to udate it to the latest database and you can also se how to eliminate the database versions if skipped :

https://github.com/FollyMaddy/RetroPie-Share/commit/6d97d9da0f8ff6949ddb59ed06a465bdf6af203d


