#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#


#----------------------------------------------------------------------------------------------------------------------------------------------
# INFORMATION ABOUT THE CSV STRUCTURE USED FOR GENERATING A GUI/SUB-GUI :
# - the first value isn't used for the menu, that way the menu begins with 1
# - this first value should be empty or contain a description of the specific column
# - make sure every line begins and ends with quotes because of possible spaces
# - just use the first and last column in excel/calc for the quotes and you should be fine
#----------------------------------------------------------------------------------------------------------------------------------------------

#For downloading legal content from this thread :
#https://retropie.org.uk/forum/topic/10918/where-to-legally-acquire-content-to-play-on-retropie

rp_module_id="download_legal_stuff"
rp_module_desc="download legal stuff"
rp_module_section="config"

function depends_download_legal_stuff() {
    true
}


function gui_download_legal_stuff() {
    local csv=()
    csv=(
",Platform,,,,,,,,to_do,"
",Arcade,,,,,,,,gui_download_legal_stuff_arcade,"
",Atari 2600,,,,,,,,gui_download_legal_stuff_atari2600,"
",Atari Lynx,,,,,,,,gui_download_legal_stuff_atarilynx,"
",ColecoVision,,,,,,,,gui_download_legal_stuff_coleco,"
    )
    build_menu_download_legal_stuff
}


function gui_download_legal_stuff_arcade() {
    local csv=()
    csv=(
",description,file_name,rom_directory,download_link,,,,,to_do,"
",Circus (Exidy 1977),circus.zip,arcade,https://www.mamedev.org/roms/circus/circus.zip,,,,,download_with_wget,"
",Circus (Exidy 1977)(older version),circuso.zip,arcade,https://www.mamedev.org/roms/circus/circuso.zip,,,,,download_with_wget,"
",Robot Bowl (Exidy 1977),robotbwl.zip,arcade,https://www.mamedev.org/roms/robotbwl/robotbwl.zip,,,,,download_with_wget,"
",Car Polo (Exidy 1977),carpolo.zip,arcade,https://www.mamedev.org/roms/carpolo/carpolo.zip,,,,,download_with_wget,"
",Side Trak (Exidy 1979),sidetrac.zip,arcade,https://www.mamedev.org/roms/sidetrac/sidetrac.zip,,,,,download_with_wget,"
",Rip Cord (Exidy 1979),ripcord.zip,arcade,https://www.mamedev.org/roms/ripcord/ripcord.zip,,,,,download_with_wget,"
",Fire One (Exidy 1979),fireone.zip,arcade,https://www.mamedev.org/roms/fireone/fireone.zip,,,,,download_with_wget,"
",Crash (Exidy 1979),crash.zip,arcade,https://www.mamedev.org/roms/crash/crash.zip,,,,,download_with_wget,"
",Star Fire (Exidy 1979)(set 1),starfire.zip,arcade,https://www.mamedev.org/roms/starfire/starfire.zip,,,,,download_with_wget,"
",Star Fire (Exidy 1979)(set 2),starfirea.zip,arcade,https://www.mamedev.org/roms/starfire/starfirea.zip,,,,,download_with_wget,"
",Star Fire 2 (Exidy 1979),starfir2.zip,arcade,https://www.mamedev.org/roms/starfire/starfir2.zip,,,,,download_with_wget,"
",Targ (Exidy 1980),targ.zip,arcade,https://www.mamedev.org/roms/targ/targ.zip,,,,,download_with_wget,"
",Spectar (Exidy 1980),spectar.zip,arcade,https://www.mamedev.org/roms/spectar/spectar.zip,,,,,download_with_wget,"
",Hard Hat (Exidy 1982),hardhat.zip,arcade,https://www.mamedev.org/roms/hardhat/hardhat.zip,,,,,download_with_wget,"
",Victory (Exidy 1982),victory.zip,arcade,https://www.mamedev.org/roms/victory/victory.zip,,,,,download_with_wget,"
",Victor Banana (Exidy 1982),victorba.zip,arcade,https://www.mamedev.org/roms/victory/victorba.zip,,,,,download_with_wget,"
",Teeter Torture (Exidy 1982),teetert.zip,arcade,https://www.mamedev.org/roms/teetert/teetert.zip,,,,,download_with_wget,"
",FAX (Exidy 1983),fax.zip,arcade,https://www.mamedev.org/roms/fax/fax.zip,,,,,download_with_wget,"
",FAX 2 (Exidy 1983),fax2.zip,arcade,https://www.mamedev.org/roms/fax/fax2.zip,,,,,download_with_wget,"
",Falcons Wild - World Wide Poker (Video Klein 1990)(set 1),falcnwlda.zip,arcade,https://www.mamedev.org/roms/falcnwld/falcnwlda.zip,,,,,download_with_wget,"
",Falcons Wild - World Wide Poker (Video Klein 1990)(set 2),falcnwldb.zip,arcade,https://www.mamedev.org/roms/falcnwld/falcnwldb.zip,,,,,download_with_wget,"
",Witch Card (Video Klein 1991),witchcrde.zip,arcade,https://www.mamedev.org/roms/witchcrd/witchcrde.zip,,,,,download_with_wget,"
",Witch Game (Video Klein 1991),witchgme.zip,arcade,https://www.mamedev.org/roms/witchgme/witchgme.zip,,,,,download_with_wget,"
",Witch Strike (Video Klein 1992)(Version A),wstrike.zip,arcade,https://www.mamedev.org/roms/wstrike/wstrike.zip,,,,,download_with_wget,"
",Witch Strike (Video Klein 1992)(Version B),wstrikea.zip,arcade,https://www.mamedev.org/roms/wstrike/wstrikea.zip,,,,,download_with_wget,"
",Jolli Witch (Video Klein 1994),witchjol.zip,arcade,https://www.mamedev.org/roms/witchjol/witchjol.zip,,,,,download_with_wget,"
",Witch Jack (Video Klein 1996)(Version 0.87-89),wtchjack.zip,arcade,https://www.mamedev.org/roms/wtchjack/wtchjack.zip,,,,,download_with_wget,"
",Witch Jack (Video Klein 1996)(Version 0.87-88),wtchjacka.zip,arcade,https://www.mamedev.org/roms/wtchjack/wtchjacka.zip,,,,,download_with_wget,"
",Witch Jack (Video Klein 1996)(Version 0.87),wtchjackb.zip,arcade,https://www.mamedev.org/roms/wtchjack/wtchjackb.zip,,,,,download_with_wget,"
",Robby Roto (Bally/Midway 1981),robby.zip,arcade,https://www.mamedev.org/roms/robby/robby.zip,,,,,download_with_wget,"
",Super Tank (Video Games GmbH 1981),supertnk.zip,arcade,https://www.mamedev.org/roms/supertnk/supertnk.zip,,,,,download_with_wget,"
",Looping (Video Games GmbH 1982),looping.zip,arcade,https://www.mamedev.org/roms/looping/looping.zip,,,,,download_with_wget,"
",Gridlee (Videa 1982),gridlee.zip,arcade,https://www.mamedev.org/roms/gridlee/gridlee.zip,,,,,download_with_wget,"
",Alien Arena (Duncan Brown 1985),alienar.zip,arcade,https://www.mamedev.org/roms/alienar/alienar.zip,,,,,download_with_wget,"
    )
    build_menu_download_legal_stuff
}


function gui_download_legal_stuff_atari2600() {
    local csv=()
    csv=(
",description,file_name,rom_directory,download_link,,,,,to_do,"
",Aardvark (2019),Aardvark (2019).zip,atari2600,https://atariage.com/forums/applications/core/interface/file/attachment.php?id=833216,,,,,download_with_wget,"
",Bombs Away! (NTSC) 12-2017 Version,Bombs Away! (NTSC) 12-2017.bin,atari2600,https://atariage.com/forums/applications/core/interface/file/attachment.php?id=544819,,,,,download_with_wget,"
",Bombs Away! (PAL) 12-2017 Version,Bombs Away! (PAL) 12-2017.bin,atari2600,https://atariage.com/forums/applications/core/interface/file/attachment.php?id=544820,,,,,download_with_wget,"
",Synthcart,snthcart.zip,atari2600,http://www.qotile.net/files/snthcart.zip,,,,,download_with_wget,"
    )
    build_menu_download_legal_stuff
}


function gui_download_legal_stuff_atarilynx() {
    local csv=()
    csv=(
",description,file_name,rom_directory,download_link,,,,,to_do,"
",30th Birthday Programming Competition Roms,30th Birthday ROMs.zip,atarilynx,https://atariage.com/forums/applications/core/interface/file/attachment.php?id=661460,,,,,download_with_wget_and_extract,"
    )
    build_menu_download_legal_stuff
}

#coleco-csv.sh script is used for making this CSV, see https://github.com/FollyMaddy/RetroPie-Share/tree/main/00-scripts-00/backup/coleco-csv.sh
#some are done/improved manually
#these don't work / these seem not archived in waybackmachine
#",Black Onyx - The (2013 Team Pixelboy) [SAVEGAME],Black Onyx - The (2013 Team Pixelboy) [SAVEGAME].rom,coleco,http://web.archive.org/web/20200122193402/http://www.colecovision.ca/roms/homebrews/Black%20Onyx,%20The%20(2013%20Team%20Pixelboy)%20[SAVEGAME].rom,,,,,download_with_wget,"
#",Breakout (2001 Daniel Bienvenu) [Paddle Version Demo],Breakout (2001 Daniel Bienvenu) [Paddle Version Demo].zip,coleco,http://web.archive.org/web/20200122193402/http://www.colecovision.ca/roms/homebrews/Breakout%20(2001%20Daniel%20Bienvenu)%20[Paddle%20Version%20Demo].zip,,,,,download_with_wget,"
#",Canadian Minigames (2008 Wick-Foster-Bienvenu),Canadian Minigames (2008 Wick-Foster-Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Canadian%20Minigames%20(2008%20Wick-Foster-Bienvenu).rom,,,,,download_with_wget,"
#",Chateau Du Dragon (2001 Daniel Bienvenu) [WIP],Chateau Du Dragon (2001 Daniel Bienvenu) [WIP].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Chateau%20Du%20Dragon%20(2001%20Daniel%20Bienvenu)%20[WIP].rom,,,,,download_with_wget,"
#",Circus Charlie (2011 Team Pixelboy),Circus Charlie (2011 Team Pixelboy).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Circus%20Charlie%20(2011%20Team%20Pixelboy).rom,,,,,download_with_wget,"
#",ColecoVision RPG v023 (2006 Bruce Tomlin) [DEMO],ColecoVision RPG v023 (2006 Bruce Tomlin) [DEMO].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/ColecoVision%20RPG%20v023%20(2006%20Bruce%20Tomlin)%20[DEMO].rom,,,,,download_with_wget,"
#",Colored Gravity (2008 Philip Klaus Krause),Colored Gravity (2008 Philip Klaus Krause).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Colored%20Gravity%20(2008%20Philip%20Klaus%20Krause).rom,,,,,download_with_wget,"
#",Commando Returns (2012 Michel Louvet) [WIP],Commando Returns (2012 Michel Louvet) [WIP].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Commando%20Returns%20(2012%20Michel%20Louvet)%20[WIP].rom,,,,,download_with_wget,"
#",Cosmo Challenge (1997 Marcel de Kogel),Cosmo Challenge (1997 Marcel de Kogel).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Cosmo%20Challenge%20(1997%20Marcel%20de%20Kogel).rom,,,,,download_with_wget,"
#",Cosmo Fighter 2 (1997 Marcel de Kogel),Cosmo Fighter 2 (1997 Marcel de Kogel).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Cosmo%20Fighter%202%20(1997%20Marcel%20de%20Kogel).rom,,,,,download_with_wget,"
#",Cosmo Fighter 3 (2001 Marcel de Kogel) [Playable Demo],Cosmo Fighter 3 (2001 Marcel de Kogel) [Playable Demo].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Cosmo%20Fighter%203%20(2001%20Marcel%20de%20Kogel)%20[Playable%20Demo].rom,,,,,download_with_wget,"
#",Cosmo Trainer (1997 Marcel de Kogel),Cosmo Trainer (1997 Marcel de Kogel).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Cosmo%20Trainer%20(1997%20Marcel%20de%20Kogel).rom,,,,,download_with_wget,"
#",Cye 1.0 (2007 Philip Klaus Krause) [Playable Demo],Cye 1.0 (2007 Philip Klaus Krause) [Playable Demo].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Cye%201.0%20(2007%20Philip%20Klaus%20Krause)%20[Playable%20Demo].rom,,,,,download_with_wget,"
#",Pac-Man Collection (2008 Opcode),Pac-Man Collection (2008 Opcode).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Pac-Man%20Collection%20(2008%20Opcode).rom,,,,,download_with_wget,"
#",Peek-A-Boo (2010 Team Pixelboy),Peek-A-Boo (2010 Team Pixelboy).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Peek-A-Boo%20(2010%20Team%20Pixelboy).rom,,,,,download_with_wget,"
#",Pere Noel (2000 Daniel Bienvenu) [DEMO],Pere Noel (2000 Daniel Bienvenu) [DEMO].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Pere%20Noel%20(2000%20Daniel%20Bienvenu)%20[DEMO].rom,,,,,download_with_wget,"
#",Pitfall II Arcade (2010 Team Pixelboy),Pitfall II Arcade (2010 Team Pixelboy).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Pitfall%20II%20Arcade%20(2010%20Team%20Pixelboy).rom,,,,,download_with_wget,"
#",Pong (2007 Alfonso DC),Pong (2007 Alfonso DC).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Pong%20(2007%20Alfonso%20DC).rom,,,,,download_with_wget,"
#",Princess Quest (2012 Team Pixelboy),Princess Quest (2012 Team Pixelboy).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Princess%20Quest%20(2012%20Team%20Pixelboy).rom,,,,,download_with_wget,"
#",Purple Dinosaur Massacre (1996 John Dondzilla),Purple Dinosaur Massacre (1996 John Dondzilla).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Purple%20Dinosaur%20Massacre%20(1996%20John%20Dondzilla).rom,,,,,download_with_wget,"
#",PV2000 (2012 Nicolas Campion),PV2000 (2012 Nicolas Campion).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/PV2000%20(2012%20Nicolas%20Campion).rom,,,,,download_with_wget,"
#",Space Invaders (2002 Eduardo Mello) [DEMO],Space Invaders (2002 Eduardo Mello) [DEMO].zip,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Space%20Invaders%20(2002%20Eduardo%20Mello)%20[DEMO].zip,,,,,download_with_wget,"
function gui_download_legal_stuff_coleco() {
    local csv=()
    csv=(
",description,file_name,rom_directory,download_link,,,,,to_do,"
",421 (2002 Mathieu Proulx),421 (2002 Mathieu Proulx).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/421%20(2002%20Mathieu%20Proulx).rom,,,,,download_with_wget,"
",Adventure Of A Witch - The Flightful Night (2015 Chris Derrig) [WIP],Adventure Of A Witch - The Flightful Night (2015 Chris Derrig) [WIP].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Adventure%20Of%20A%20Witch%20-%20The%20Flightful%20Night%20(2015%20Chris%20Derrig)%20[WIP].rom,,,,,download_with_wget,"
",Air Battle (2000 Daniel Bienvenu) [DEMO],Air Battle (2000 Daniel Bienvenu) [DEMO].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Air%20Battle%20(2000%20Daniel%20Bienvenu)%20[DEMO].rom,,,,,download_with_wget,"
",Amazing Snake (2001 Serge-Eric Tremblay) [BETA],Amazing Snake (2001 Serge-Eric Tremblay) [BETA].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Amazing%20Snake%20(2001%20Serge-Eric%20Tremblay)%20[BETA].rom,,,,,download_with_wget,"
",Amazing Snake (2001 Serge-Eric Tremblay),Amazing Snake (2001 Serge-Eric Tremblay).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Amazing%20Snake%20(2001%20Serge-Eric%20Tremblay).rom,,,,,download_with_wget,"
",AntiISDA Warrior (2004 Ventzislav Tzvetkov),AntiISDA Warrior (2004 Ventzislav Tzvetkov).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/AntiISDA%20Warrior%20(2004%20Ventzislav%20Tzvetkov).rom,,,,,download_with_wget,"
",Bank Panic (2011 Team Pixelboy),Bank Panic (2011 Team Pixelboy).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Bank%20Panic%20(2011%20Team%20Pixelboy).rom,,,,,download_with_wget,"
",Bankruptcy Builder (2008 Philip Klaus Krause),Bankruptcy Builder (2008 Philip Klaus Krause).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Bankruptcy%20Builder%20(2008%20Philip%20Klaus%20Krause).rom,,,,,download_with_wget,"
",Battleship (2003 Mathieu Proulx) [DEMO],Battleship (2003 Mathieu Proulx) [DEMO].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Battleship%20(2003%20Mathieu%20Proulx)%20[DEMO].rom,,,,,download_with_wget,"
",Bejeweled (2002 Daniel Bienvenu),Bejeweled (2002 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Bejeweled%20(2002%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",Beyond Terra (2009 Scott Huggins) [DEMO],Beyond Terra (2009 Scott Huggins) [DEMO].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Beyond%20Terra%20(2009%20Scott%20Huggins)%20[DEMO].rom,,,,,download_with_wget,"
",BombJack (2012 Michel Louvet) [Playable Demo],BombJack (2012 Michel Louvet) [Playable Demo].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/BombJack%20(2012%20Michel%20Louvet)%20[Playable%20Demo].rom,,,,,download_with_wget,"
",Breakout (1999 Daniel Bienvenu),Breakout (1999 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Breakout%20(1999%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",BUsTin-Out Volume 0 (2000 Daniel Bienvenu),BUsTin-Out Volume 0 (2000 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/BUsTin-Out%20Volume%200%20(2000%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",BUsTin-Out Volume 1 (2000 Daniel Bienvenu),BUsTin-Out Volume 1 (2000 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/BUsTin-Out%20Volume%201%20(2000%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",BUsTin-Out Volume 2 (2000 Daniel Bienvenu),BUsTin-Out Volume 2 (2000 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/BUsTin-Out%20Volume%202%20(2000%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",BUsTin-Out Volume 3 (2000 Daniel Bienvenu),BUsTin-Out Volume 3 (2000 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/BUsTin-Out%20Volume%203%20(2000%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",DacMan (2000 Daniel Bienvenu),DacMan (2000 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/DacMan%20(2000%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",Death Race (2004 Dav) [Playable Demo],Death Race (2004 Dav) [Playable Demo].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Death%20Race%20(2004%20Dav)%20[Playable%20Demo].rom,,,,,download_with_wget,"
",Deflektor Kollection (2005 Daniel Bienvenu),Deflektor Kollection (2005 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Deflektor%20Kollection%20(2005%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",Demon 2 (2001 Yannick Proulx) [DEMO],Demon 2 (2001 Yannick Proulx) [DEMO].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Demon%202%20(2001%20Yannick%20Proulx)%20[DEMO].rom,,,,,download_with_wget,"
",Destructor (2010 Daniel Bienvenu) [Standard Controller Hack],Destructor (2010 Daniel Bienvenu) [Standard Controller Hack].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Destructor%20(2010%20Daniel%20Bienvenu)%20[Standard%20Controller%20Hack].rom,,,,,download_with_wget,"
",Destructor SCE (2010 Team Pixelboy),Destructor SCE (2010 Team Pixelboy).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Destructor%20SCE%20(2010%20Team%20Pixelboy).rom,,,,,download_with_wget,"
",Diamond Dash (2004 Daniel Bienvenu),Diamond Dash (2004 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Diamond%20Dash%20(2004%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",Digger (2014 Mystery Man),Digger (2014 Mystery Man).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Digger%20(2014%20Mystery%20Man).rom,,,,,download_with_wget,"
",Double Breakout (2003 Daniel Bienvenu),Double Breakout (2003 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Double%20Breakout%20(2003%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",DP's Valentine Game (2002 Daniel Bienvenu),DP's Valentine Game (2002 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/DP's%20Valentine%20Game%20(2002%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",DP's Valentine Game (2002 Daniel Bienvenu) [No Alien]',DP's Valentine Game (2002 Daniel Bienvenu) [No Alien].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/DP's%20Valentine%20Game%20(2002%20Daniel%20Bienvenu)%20[No%20Alien].rom,,,,,download_with_wget,"
",Easter Bunny (2007 Daniel Bienvenu),Easter Bunny (2007 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Easter%20Bunny%20(2007%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",Easter Bunny (2007 Daniel Bienvenu) [Title Screen],Easter Bunny (2007 Daniel Bienvenu) [Title Screen].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Easter%20Bunny%20(2007%20Daniel%20Bienvenu)%20[Title%20Screen].rom,,,,,download_with_wget,"
",Frantic (2008 Scott Huggins) [Playable Demo],Frantic (2008 Scott Huggins) [Playable Demo].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Frantic%20(2008%20Scott%20Huggins)%20[Playable%20Demo].rom,,,,,download_with_wget,"
",Frog Feast (20XX Robert),Frog Feast (20XX Robert).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Frog%20Feast%20(20XX%20Robert).rom,,,,,download_with_wget,"
",Frog Magi (200X Dale Wick),Frog Magi (200X Dale Wick).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Frog%20Magi%20(200X%20Dale%20Wick).rom,,,,,download_with_wget,"
",Game Pack 1 (2002 Daniel Bienvenu),Game Pack 1 (2002 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Game%20Pack%201%20(2002%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",Game Pack 2 (2004 Daniel Bienvenu),Game Pack 2 (2004 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Game%20Pack%202%20(2004%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",Game Pack Vic-20 (2003 Daniel Bienvenu),Game Pack Vic-20 (2003 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Game%20Pack%20Vic-20%20(2003%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",Get Booty (2005 Dale Wick) [4K],Get Booty (2005 Dale Wick) [4K].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Get%20Booty%20(2005%20Dale%20Wick)%20[4K].rom,,,,,download_with_wget,"
",GhostBlaster (2009 Daniel Bienvenu) [Rev.A NTSC],GhostBlaster (2009 Daniel Bienvenu) [Rev.A NTSC].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/GhostBlaster%20(2009%20Daniel%20Bienvenu)%20[Rev.A%20NTSC].rom,,,,,download_with_wget,"
",GhostBlaster (2009 Daniel Bienvenu) [Rev.B PAL],GhostBlaster (2009 Daniel Bienvenu) [Rev.B PAL].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/GhostBlaster%20(2009%20Daniel%20Bienvenu)%20[Rev.B%20PAL].rom,,,,,download_with_wget,"
",GhostBlaster (2009 Daniel Bienvenu) [Rev.B2 PAL],GhostBlaster (2009 Daniel Bienvenu) [Rev.B2 PAL].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/GhostBlaster%20(2009%20Daniel%20Bienvenu)%20[Rev.B2%20PAL].rom,,,,,download_with_wget,"
",Girl's Garden (2010 Team Pixelboy),Girl's Garden (2010 Team Pixelboy).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Girl's%20Garden%20(2010%20Team%20Pixelboy).rom,,,,,download_with_wget,"
",Golgo 13 (2011 Team Pixelboy),Golgo 13 (2011 Team Pixelboy).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Golgo%2013%20(2011%20Team%20Pixelboy).rom,,,,,download_with_wget,"
",Gulkave (2010 Team Pixelboy),Gulkave (2010 Team Pixelboy).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Gulkave%20(2010%20Team%20Pixelboy).rom,,,,,download_with_wget,"
",Happy Halloween (2001 Daniel Bienvenu),Happy Halloween (2001 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Happy%20Halloween%20(2001%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",Haunted Caves (2013 Nicolas Campion),Haunted Caves (2013 Nicolas Campion).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Haunted%20Caves%20(2013%20Nicolas%20Campion).rom,,,,,download_with_wget,"
",Insane Pickin' Sticks VIII (2009 Daniel Bienvenu) [4K],Insane Pickin' Sticks VIII (2009 Daniel Bienvenu) [4K].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Insane%20Pickin'%20Sticks%20VIII%20(2009%20Daniel%20Bienvenu)%20[4K].rom,,,,,download_with_wget,"
",Insane Pickin' Sticks VIII (2009 Daniel Bienvenu) [Over 9000],Insane Pickin' Sticks VIII (2009 Daniel Bienvenu) [Over 9000].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Insane%20Pickin'%20Sticks%20VIII%20(2009%20Daniel%20Bienvenu)%20[Over%209000].rom,,,,,download_with_wget,"
",Jeepers Creepers (2007 Daniel Bienvenu),Jeepers Creepers (2007 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Jeepers%20Creepers%20(2007%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",JetP4K! (2006 Harvey deKleine) [DEMO],JetP4K! (2006 Harvey deKleine) [DEMO].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/JetP4K!%20(2006%20Harvey%20deKleine)%20[DEMO].rom,,,,,download_with_wget,"
",Jump Or Die (2006 Daniel Bienvenu),Jump Or Die (2006 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Jump%20Or%20Die%20(2006%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",Kevtris (1996 Kevin Horton),Kevtris (1996 Kevin Horton).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Kevtris%20(1996%20Kevin%20Horton).rom,,,,,download_with_wget,"
",Kick Gas (2008 Dvik & Joyrex) [Playable Demo],Kick Gas (2008 Dvik & Joyrex) [Playable Demo].rom,coleco,http://web.archive.org/web/20200123123615/http://www.colecovision.ca/roms/homebrews/Kick%20Gas%20(2008%20Dvik%20&%20Joyrex)%20[Playable%20Demo].rom,,,,,download_with_wget,"
",Kill Barney In Tokyo (1997 Daniel Bienvenu) [Playable Demo],Kill Barney In Tokyo (1997 Daniel Bienvenu) [Playable Demo].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Kill%20Barney%20In%20Tokyo%20(1997%20Daniel%20Bienvenu)%20[Playable%20Demo].rom,,,,,download_with_wget,"
",Killer Instinct (1997 Daniel Bienvenu) [Playable Demo],Killer Instinct (1997 Daniel Bienvenu) [Playable Demo].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Killer%20Instinct%20(1997%20Daniel%20Bienvenu)%20[Playable%20Demo].rom,,,,,download_with_wget,"
",Knight Quest (2013 Nicolas Campion) [WIP],Knight Quest (2013 Nicolas Campion) [WIP].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Knight%20Quest%20(2013%20Nicolas%20Campion)%20[WIP].rom,,,,,download_with_wget,"
",Kobashi (2008 Dvik & Joyrex) [Playable Demo],Kobashi (2008 Dvik & Joyrex) [Playable Demo].rom,coleco,http://web.archive.org/web/20200123123615/http://www.colecovision.ca/roms/homebrews/Kobashi%20(2008%20Dvik%20&%20Joyrex)%20[Playable%20Demo].rom,,,,,download_with_wget,"
",Konami's Ping Pong (2011 Team Pixelboy),Konami's Ping Pong (2011 Team Pixelboy).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Konami's%20Ping%20Pong%20(2011%20Team%20Pixelboy).rom,,,,,download_with_wget,"
",Maid Of The Mist (2007 Dale Wick),Maid Of The Mist (2007 Dale Wick).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Maid%20Of%20The%20Mist%20(2007%20Dale%20Wick).rom,,,,,download_with_wget,"
",Maze Maniac (2005 Charles-Mathieu Boyer),Maze Maniac (2005 Charles-Mathieu Boyer).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Maze%20Maniac%20(2005%20Charles-Mathieu%20Boyer).rom,,,,,download_with_wget,"
",MazezaM (200X Ventzislav Tzvetkov),MazezaM (200X Ventzislav Tzvetkov).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/MazezaM%20(200X%20Ventzislav%20Tzvetkov).rom,,,,,download_with_wget,"
",Module Man (2013 Team Pixelboy),Module Man (2013 Team Pixelboy).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Module%20Man%20(2013%20Team%20Pixelboy).rom,,,,,download_with_wget,"
",Mopiranger (2012 Team Pixelboy),Mopiranger (2012 Team Pixelboy).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Mopiranger%20(2012%20Team%20Pixelboy).rom,,,,,download_with_wget,"
",Ms. Space Fury (2001 Daniel Bienvenu),Ms. Space Fury (2001 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Ms.%20Space%20Fury%20(2001%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",NIM (2000 Daniel Bienvenu),NIM (2000 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/NIM%20(2000%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",Ninja Princess (2011 Team Pixelboy),Ninja Princess (2011 Team Pixelboy).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Ninja%20Princess%20(2011%20Team%20Pixelboy).rom,,,,,download_with_wget,"
",Old Skool 01 (2005 Guy Foster) [DEMO],Old Skool 01 (2005 Guy Foster) [DEMO].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Old%20Skool%2001%20(2005%20Guy%20Foster)%20[DEMO].rom,,,,,download_with_wget,"
",Old Skool 02 (2005 Guy Foster) [DEMO],Old Skool 02 (2005 Guy Foster) [DEMO].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Old%20Skool%2002%20(2005%20Guy%20Foster)%20[DEMO].rom,,,,,download_with_wget,"
",Quatre (2013 Nicolas Campion),Quatre (2013 Nicolas Campion).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Quatre%20(2013%20Nicolas%20Campion).rom,,,,,download_with_wget,"
",Quest For The Golden Chalice (2012 Team Pixelboy),Quest For The Golden Chalice (2012 Team Pixelboy).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Quest%20For%20The%20Golden%20Chalice%20(2012%20Team%20Pixelboy).rom,,,,,download_with_wget,"
",Quiz Wiz ColecoVision 30th Anniversary (2012 CollectorVision),Quiz Wiz ColecoVision 30th Anniversary (2012 CollectorVision).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Quiz%20Wiz%20ColecoVision%2030th%20Anniversary%20(2012%20CollectorVision).rom,,,,,download_with_wget,"
",Reversi (2003 Daniel Bienvenu),Reversi (2003 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Reversi%20(2003%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",Reversi - Diamond Dash (2004 Daniel Bienvenu),Reversi - Diamond Dash (2004 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Reversi%20-%20Diamond%20Dash%20(2004%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",Robobug (2012 Nicolas Campion),Robobug (2012 Nicolas Campion).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Robobug%20(2012%20Nicolas%20Campion).rom,,,,,download_with_wget,"
",Santa Must Save Christmas (2011 Michel Louvet),Santa Must Save Christmas (2011 Michel Louvet).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Santa%20Must%20Save%20Christmas%20(2011%20Michel%20Louvet).rom,,,,,download_with_wget,"
",Santa's Gift Run (2004 Dale Wick),Santa's Gift Run (2004 Dale Wick).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Santa's%20Gift%20Run%20(2004%20Dale%20Wick).rom,,,,,download_with_wget,"
",Schlange CV 1,Schlange CV 1.0 (2006 Philip Klaus Krause) [Playable Demo].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Schlange%20CV%201.0%20(2006%20Philip%20Klaus%20Krause)%20[Playable%20Demo].rom,,,,,download_with_wget,"
",Search For The Stolen Crown Jewels (2006 Philip Klaus Krause) [Playable Demo],Search For The Stolen Crown Jewels (2006 Philip Klaus Krause) [Playable Demo].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Search%20For%20The%20Stolen%20Crown%20Jewels%20(2006%20Philip%20Klaus%20Krause)%20[Playable%20Demo].rom,,,,,download_with_wget,"
",Search For The Stolen Crown Jewels II (2007 Philip Klaus Krause) [Playable Demo],Search For The Stolen Crown Jewels II (2007 Philip Klaus Krause) [Playable Demo].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Search%20For%20The%20Stolen%20Crown%20Jewels%20II%20(2007%20Philip%20Klaus%20Krause)%20[Playable%20Demo].rom,,,,,download_with_wget,"
",Search For The Stolen Crown Jewels III (2010 Philip Klaus Krause) [Playable Demo],Search For The Stolen Crown Jewels III (2010 Philip Klaus Krause) [Playable Demo].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Search%20For%20The%20Stolen%20Crown%20Jewels%20III%20(2010%20Philip%20Klaus%20Krause)%20[Playable%20Demo].rom,,,,,download_with_wget,"
",Shunting Puzzle (2007 Philip Klause Krause),Shunting Puzzle (2007 Philip Klause Krause).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Shunting%20Puzzle%20(2007%20Philip%20Klause%20Krause).rom,,,,,download_with_wget,"
",Sky Jaguar (2004 Opcode),Sky Jaguar (2004 Opcode).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Sky%20Jaguar%20(2004%20Opcode).rom,,,,,download_with_wget,"
",Slither (2010 Daniel Bienvenu) [Standard Controller Hack],Slither (2010 Daniel Bienvenu) [Standard Controller Hack].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Slither%20(2010%20Daniel%20Bienvenu)%20[Standard%20Controller%20Hack].rom,,,,,download_with_wget,"
",Smash (2004 Daniel Bienvenu),Smash (2004 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Smash%20(2004%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",Space Caverns (2004 Scott Huggins) [Playable Demo],Space Caverns (2004 Scott Huggins) [Playable Demo].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Space%20Caverns%20(2004%20Scott%20Huggins)%20[Playable%20Demo].rom,,,,,download_with_wget,"
",Space Harrier Version 7 (2009 HardHat) [DEMO],Space Harrier Version 7 (2009 HardHat) [DEMO].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Space%20Harrier%20Version%207%20(2009%20HardHat)%20[DEMO].rom,,,,,download_with_wget,"
",Space Hunter (2005 Guy Foster) [Playable Demo],Space Hunter (2005 Guy Foster) [Playable Demo].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Space%20Hunter%20(2005%20Guy%20Foster)%20[Playable%20Demo].rom,,,,,download_with_wget,"
",Space Invaders Collection (2003 Opcode),Space Invaders Collection (2003 Opcode).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Space%20Invaders%20Collection%20(2003%20Opcode).rom,,,,,download_with_wget,"
",Space Invasion (1998 John Dondzilla) [Playable Demo],Space Invasion (1998 John Dondzilla) [Playable Demo].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Space%20Invasion%20(1998%20John%20Dondzilla)%20[Playable%20Demo].rom,,,,,download_with_wget,"
",Space Invasion (1998 John Dondzilla),Space Invasion (1998 John Dondzilla).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Space%20Invasion%20(1998%20John%20Dondzilla).rom,,,,,download_with_wget,"
",Space Trainer (2005 Daniel Bienvenu),Space Trainer (2005 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Space%20Trainer%20(2005%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",Spectank (2000 Daniel Bienvenu) [Unfinished],Spectank (2000 Daniel Bienvenu) [Unfinished].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Spectank%20(2000%20Daniel%20Bienvenu)%20[Unfinished].rom,,,,,download_with_wget,"
",Squares! (2007 Harvey deKleine) [Playable Demo],Squares! (2007 Harvey deKleine) [Playable Demo].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Squares!%20(2007%20Harvey%20deKleine)%20[Playable%20Demo].rom,,,,,download_with_wget,"
",Terra Attack (2007 Scott Huggins),Terra Attack (2007 Scott Huggins).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Terra%20Attack%20(2007%20Scott%20Huggins).rom,,,,,download_with_wget,"
",Text Adventure (2015 Chris Derrig),Text Adventure (2015 Chris Derrig).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Text%20Adventure%20(2015%20Chris%20Derrig).rom,,,,,download_with_wget,"
",Text Adventure (2015 Chris Derrig) [Dragon Option],Text Adventure (2015 Chris Derrig) [Dragon Option].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Text%20Adventure%20(2015%20Chris%20Derrig)%20[Dragon%20Option].rom,,,,,download_with_wget,"
",Tic Tac Toe (1996 Norman Nithman),Tic Tac Toe (1996 Norman Nithman).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Tic%20Tac%20Toe%20(1996%20Norman%20Nithman).rom,,,,,download_with_wget,"
",Track &  Field (2010 Team Pixelboy),Track &  Field (2010 Team Pixelboy).rom,coleco,http://web.archive.org/web/20200122193234/http://www.colecovision.ca/roms/homebrews/Track%20&%20Field%20(2010%20Team%20Pixelboy).rom,,,,,download_with_wget,"
",Tune Layer (2002 Daniel Bienvenu),Tune Layer (2002 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Tune%20Layer%20(2002%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",Turbo (2010 Daniel Bienvenu) [Standard Controller Hack],Turbo (2010 Daniel Bienvenu) [Standard Controller Hack].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Turbo%20(2010%20Daniel%20Bienvenu)%20[Standard%20Controller%20Hack].rom,,,,,download_with_wget,"
",Venture (200X Daniel Bienvenu) [Vampire Hack],Venture (200X Daniel Bienvenu) [Vampire Hack].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Venture%20(200X%20Daniel%20Bienvenu)%20[Vampire%20Hack].rom,,,,,download_with_wget,"
",Victory (2010 Daniel Bienvenu) [Standard Controller Hack],Victory (2010 Daniel Bienvenu) [Standard Controller Hack].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Victory%20(2010%20Daniel%20Bienvenu)%20[Standard%20Controller%20Hack].rom,,,,,download_with_wget,"
",Warm Fuzzy - Quest For Salad (2005 Dale Wick),Warm Fuzzy - Quest For Salad (2005 Dale Wick).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Warm%20Fuzzy%20-%20Quest%20For%20Salad%20(2005%20Dale%20Wick).rom,,,,,download_with_wget,"
",Waterville Rescue (2009 Mike Brent),Waterville Rescue (2009 Mike Brent).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Waterville%20Rescue%20(2009%20Mike%20Brent).rom,,,,,download_with_wget,"
",Wild Western! (200X Opcode) [DEMO],Wild Western! (200X Opcode) [DEMO].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Wild%20Western!%20(200X%20Opcode)%20[DEMO].rom,,,,,download_with_wget,"
",Winky Trap (1997 Jean-Francois Dupuis) [Mouse Trap Hack],Winky Trap (1997 Jean-Francois Dupuis) [Mouse Trap Hack].rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Winky%20Trap%20(1997%20Jean-Francois%20Dupuis)%20[Mouse%20Trap%20Hack].rom,,,,,download_with_wget,"
",Wizard (2003 Daniel Bienvenu),Wizard (2003 Daniel Bienvenu).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Wizard%20(2003%20Daniel%20Bienvenu).rom,,,,,download_with_wget,"
",Wonder Boy (2012 Team Pixelboy),Wonder Boy (2012 Team Pixelboy).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Wonder%20Boy%20(2012%20Team%20Pixelboy).rom,,,,,download_with_wget,"
",Yank Bash (2004 Rich Drushel),Yank Bash (2004 Rich Drushel).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Yank%20Bash%20(2004%20Rich%20Drushel).rom,,,,,download_with_wget,"
",Yie-Ar Kung Fu (2005 Opcode),Yie-Ar Kung Fu (2005 Opcode).rom,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/Yie-Ar%20Kung%20Fu%20(2005%20Opcode).rom,,,,,download_with_wget,"
    )
    build_menu_download_legal_stuff
}


function download_with_wget() {
    mkdir -p "/home/pi/RetroPie/roms/$(echo ${csv[$choice]} | cut -d ',' -f 4)/00-Legal_Downloads-00"
    wget -nv -O "/home/pi/RetroPie/roms/$(echo ${csv[$choice]} | cut -d ',' -f 4)/00-Legal_Downloads-00/$(echo ${csv[$choice]} | cut -d ',' -f 3)" "$(echo ${csv[$choice]} | cut -d ',' -f 5)"
    chown -R $user:$user "/home/$user/RetroPie/roms/$(echo ${csv[$choice]} | cut -d ',' -f 4)"
}


function download_with_wget_and_extract() {
    download_with_wget
    unzip "/home/pi/RetroPie/roms/$(echo ${csv[$choice]} | cut -d ',' -f 4)/00-Legal_Downloads-00/$(echo ${csv[$choice]} | cut -d ',' -f 3)" -d "/home/pi/RetroPie/roms/$(echo ${csv[$choice]} | cut -d ',' -f 4)/00-Legal_Downloads-00"
    rm "/home/pi/RetroPie/roms/$(echo ${csv[$choice]} | cut -d ',' -f 4)/00-Legal_Downloads-00/$(echo ${csv[$choice]} | cut -d ',' -f 3)"
    chown -R $user:$user "/home/$user/RetroPie/roms/$(echo ${csv[$choice]} | cut -d ',' -f 4)"
}


function build_menu_download_legal_stuff() {
    local options=()
    local default
    local i
    for i in ${!csv[@]}; do options+=("$i" "$(echo ${csv[$i]} | cut -d ',' -f 2)");done
    #remove option 0 (value 0 and 1) so the menu begins with 1
    unset 'options[0]'; unset 'options[1]' 
    while true; do
        local cmd=(dialog --default-item "$default" --backtitle "$__backtitle" --menu "What is your choice ?" 22 76 16)
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        default="$choice"
        if [[ -n "$choice" ]]; then
            joy2keyStop
            joy2keyStart 0x00 0x00 kich1 kdch1 0x20 0x71
            clear
            #run what's in the specific "column"
            $(echo ${csv[$choice]} | cut -d ',' -f 10)
            joy2keyStop
            joy2keyStart
        else
            break
        fi
    done
}

