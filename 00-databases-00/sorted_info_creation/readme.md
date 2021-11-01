---

#adb.arcadeitalia.net data

create .ini files from .csv files (adb.arcadeitalia.net)

for file in *.csv;do cat $file|cut -d "," -f1|sed 's/"//g' > $(basename $file .csv).ini ;done

---

#rename adb.arcadeitalia.net and progettosnaps.net files

rename the ini files from progettosnaps.net to keep a small data file and remove issues with spaces in the name

use only the needed ini files to keep the data file small

arcade.ini is quite big and adding takes about 3 hours so we can use non-arcade.ini only that is smaller and can be added quicker

we can get all arcade whn using "@non-arcade!" in the search, so arcade.ini is not needed 

adb.arcadeitalia.net :

TTL-ball-and-paddle.ini           computer.ini           not-classified.ini

TTL-driving.ini                   digital-simulator.ini  platform.ini

TTL-maze.ini                      driving.ini            printer.ini

TTL-quiz.ini                      fighter.ini            puzzle.ini

TTL-shooter.ini                   game-console.ini       quiz.ini

TTL-sports.ini                    handheld.ini           rhythm.ini

adb-arcade.ini                    maze.ini               shooter.ini

ball-and-paddle.ini               medal-game.ini         simulation.ini

board-game.ini                    medical-equipment.ini  sports.ini

calculator.ini                    misc.ini               tablet.ini

casino.ini                        multigame.ini          tabletop.ini

climbing.ini                      multiplay.ini          telephone.ini

computer-graphic-workstation.ini  music.ini              whac-a-mole.ini

progettosnaps.net :

bootlegs.ini  mechanical.ini  new0237.ini     screenless.ini

cabinets.ini  monochrome.ini  non-arcade.ini  working_arcade.ini

clones.ini    new0236.ini 


---

#check our own ini files

all_in1.ini   forum.ini         jakks.ini    tigerh.ini

classich.ini  gameandwatch.ini  konamih.ini  tigerrz.ini

---

#add all search patterns to the data file

first : add one space behind each driver line (do this only one time !) :

(the fresh mame0237_systems(renamed to mame0237_systems_sorted_info) is used)

sed -i 's/)\:/)\: /g' mame0237_systems_sorted_info

then : add or append more entry's, if there is already a space behing the pattern "): " :

(from 0237 : adding a "@" instead of a "*" because of compatibitity issus lubuntu)

for file in $(ls -r *.ini);do echo busy with $file;cat $file |sed 's/\r//g'|while read line;do grep -i "Driver $line " mame0237_systems_sorted_info|sed -i "s/Driver $line .*)\: /&@$(basename $file .ini)/" mame0237_systems_sorted_info ;done;done

---