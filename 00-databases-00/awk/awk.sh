#for mame version 283

#Make sure you are running a 64 bit version of mame !

#output sorted data from a specific driver, for example galaga
#bash awk.sh galaga or ./awk.sh galaga (with execution rights)
#output sorted data from all drivers
#bash awk.sh or ./awk.sh (with execution rights)
#output sorted data from all drivers
#bash awk.sh > mame0283_systems_sorted_info or ./awk.sh > mame0283_systems_sorted_info (with execution rights)
#
#or get the version from the installed mame without retyping
#bash awk.sh > $(/opt/retropie/emulators/mame/mame -version|awk -F '[()]' '{print $2}')_systems_sorted_info

#example on how to get all predefined drivers of a category in one line with awk from a created database :
#cat '/opt/retropie/emulators/mame/mame0282_systems_sorted_info' |awk '{ORS = " "} /@samples@/ {print $2}'
#
#or get the version from the installed mame without retyping
#cat /opt/retropie/emulators/mame/$(/opt/retropie/emulators/mame/mame -version|awk -F '[()]' '{print $2}')_systems_sorted_info |awk '{ORS = " "} /@samples@/ {print $2}'



#create ini files from a created database file 
#(needs 2 awk commands to cut out the drivers, not sure why !, could be improved somehow)
#try to make sure there is no old inis folder or rename the old one
#mkdir inis;cat awk.sh |awk '/^# /{print $2}'|while read category;do cat mame0282_systems_sorted_info|awk "/@$category@/"|awk '{print $2}' > inis/$category.ini;done
#
#or get the version from the installed mame without retyping
#mkdir inis;cat awk.sh |awk '/^# /{print $2}'|while read category;do cat $(/opt/retropie/emulators/mame/mame -version|awk -F '[()]' '{print $2}')_systems_sorted_info|awk "/@$category@/"|awk '{print $2}' > inis/$category.ini;done


/opt/retropie/emulators/mame/mame -listdevices $1|\
awk -F '[ ]' '
#next lines use the lineNR for getting the info instead of using filter matching

#{if (NR == 1) print $3}
/^Dr/{print $2}
'|while read driver
do
/opt/retropie/emulators/mame/mame -listxml $driver|\
awk -F '[<>"]' '
#/<machine name/ || /<descr/ {if (NR < 200) print $3 NR}
#next lines use the lineNR for getting the info instead of using filter matching

#base info
#machine name
{if (NR == 164) _driverinfo = _driverinfo $3 "□"}
#sourcefile
{if (NR == 164) _driverinfo = _driverinfo $5 "□"}
#sampleof
{if (NR == 164) _sampleof = _sampleof $7}
#description
{if (NR == 165) _driverinfo = _driverinfo $3 "□"}
#manufacturer
{if (NR == 167) _driverinfo = _driverinfo $3 "□"}

#tags
#begin the tags with a @, mameconfig is at the beginning was just a regular choice can be something else !!!
/mameconfig=/{_tags = _tags "@"}
# good
/emulation=/{_tags = _tags $5 "@"}
# clones
/cloneof=/{_tags = _tags "clones" "@"}
#arcade
#add filters /input coins/ and /input players/ to reject lines presented by j2coinsh, secoinsa20, design6 and designe
#/input coins/ || /coins/ && /input players/ {print match($0,"coins") $0}#find nr for if function
/input coins/ || /coins/ && /input players/ {if (match($0,"coins") <= 20) _arcade = "non-arcade";else _arcade = "arcade"}
# bios
/isbios=/ {if ($7 ~ "yes") _tags = _tags "bios" "@"}
# electromechanical
/Electromechanical/ {if ($3 ~ "Electromechanical") _tags = _tags "electromechanical" "@"}
#mechanical
#/mechanical/{print match($0,"mechanical") $0}#find nr for if function
#/mechanical/{if (match($0,"mechanical") == 14) _mechanical = "mechanical";else _mechanical = ""}
# mechanical
/ismechanical=/ {if ($7 ~ "yes") _tags = _tags  "mechanical" "@"}
#softwarelist (used for media before but some drivers have media but not a softwarelist)
#backup#/softwarelist tag/{print match($0,"softwarelist tag") $0 "/" NR}#find nr for if function
#backup#/softwarelist tag/{if (match($0,"softwarelist tag") == 4) _softlist = "has_softlist";else _media = "no_softlist"}
#media /imagedev/ filer was not perfect
#backup#/imagedev/ {print match($0,"imagedev") $0}#find nr for if function
#backup#/imagedev/ && ! /bitbngr/ && ! /printer/ {if (match($0,"imagedev") > 0) _media = "media"}
#backup#{if (_media !~ "media") _media = "no_media"}
#media /imagedev/ filer was not perfect
#/briefname/ {print match($0,"briefname") $0}#find nr for if function
/briefname/ && ! /midi/ && ! /bitbanger/ && ! /printout/ {if (match($0,"briefname") == 24) _media = "no_media";else _media = "media"}
#{if (_media !~ "media") _media = "no_media"}
#handheld
/sourcefile=/ {_cache = _cache  $5 " "}
/tag="screen" type="lcd"/ {if ($5 ~ "lcd") _cache = _cache  $5 " "}
/tag="screen" type="svg"/ {if ($5 ~ "svg") _cache = _cache  $5 " "}
/tag="screen" type="raster"/ {if ($5 ~ "raster") _cache = _cache  $5 " "}
#rotate (270 needs to be checked)
/rotate=/ {if ($7 ~ "90" || $7 ~ "270") _rotate = "90º"}
#lightgun
/lightgun/ {_cache = _cache  $3 " "}
#screenless
#/display tag/{print match($0,"display tag") $0}#find nr for if function
/display tag/{if (match($0,"display tag") == 14) _screenless = "screenless";else _screenless = ""}

END\
{
#slit into an array so we can match the drivername with the predefined driverset of a specific category
split ( _driverinfo, _driverarr , "□")


# arcade
_tags = _tags _arcade "@"
# working_arcade
if (_tags ~ "@good.*@arcade") _tags = _tags "working_arcade" "@"
# no_media
_tags = _tags _media "@"
# 90º
if (_rotate ~ "90º") _tags = _tags _rotate "@"
# screenless
if (_screenless ~ "screenless") _tags = _tags "screenless" "@"

##predefined categories
# all_in1
if ( " 265games 88in1joy ablmini ablpinb arcade10 backybbs ban_krkk barbpet bittboy brke23p2 carled99 cmpmx10 cmpmx11 cybar120 cybrtvfe d12power dgun2573 dgun2953 dgun2959 disppal dnv200fs dphh8630 dreamlif dsgnwrld fapocket fccomp88 fcpocket fordrace ga888 gamezn2 gon100 gprnrs1 gprnrs16 gujtv108 hotwhls ii32in1 ii8in1 intact89 intg5410 itvg49 lexiseal lexizeus lpetshop lx_jg7415 lxairjet lxnoddy m505neo m521neo majkon marc101 marc250 mc_105te mc_110cb mc_138cb mc_7x6ss mc_89in1 mc_8x6cb mc_8x6ss mc_9x6ss mc_aa2 mc_cb280 mc_dcat8 mc_dg101 mc_dgear mc_hh210 mc_sam60 mc_sp69 mc_tv200 megapad mgt20in1 miwi2_7 mpntball mpntbalt mylpony mysprtch mysprtcp mysptqvc namcons1 namcons2 njp60in1 oplayer ouipdc pballpup pdc100 pdc150t pdc200 pdc30p pdc40t pdc50 pdcj pgs268 pjoyn50 pjoys30 pjoys60 ppgc200g racechl8 ragc153 react reactmd rhhc152 rminitv rocksock sarc110 spidm2 sudopptv supr200 supreme swclone sy888b sy889 taitons1 taitons2 tak_geig tak_wdg techni4 throwbck tiger108 timetp36 tmntmutm tmntpdc tomcpin typo240 unk1682 vgcaplet vgpmini vgpocket vgtablet vjpp1 vjpp2 vjpp3 vjpp4 vsplus wfmotor whacmole zdog zone7in1 zudugo " ~ " " _driverarr[1] " " ) _tags = _tags "all_in1" "@"
# realistic
# oro
if ( " 1941u 1943u 20pacgalr1 3stooges 720 aburner alien3 aliensu altbeast amidar aof aof2 aof3 arkanoidu asteroid astyanax atetris baddudes batcir berzerk bjourney blazstar blueprnt bnj btime bubbles bublbobl burnforc burningf cadash cadashf captavenu captavenuu centiped2 chasehq cheekyms circus cninjabl columns commando congoa crkdown crusnusa crusnwld cstlevna ctribe cyberlip darkadv dbreed ddonpach ddragon ddragon2 ddragon3 ddribble ddsomu ddtodu defender digdug djboy dkong3 dkongjo1 dkongjrj dkongpe dkongx domino dotron drmario dspirit dstlkur1 duckhunt elevator eswatu excitebkj fatfursp fatfury1 fatfury2 fatfury3 ffightu foodf2 forgottnua friskyt frogger gaiden galaga galaxian gaplus garou gauntletr5 ghostb ghoulsu gng goldnaxe gorf gradius3 guardian gyruss hcastle hogalley iceclimba ikari3 inthuntu invaders joust joust2r1 jrpacman jungleh junglek kangaroo kchamp kick kingofb kizuna klax knightsu kof2000 kof2001 kof2002 kof2003 kof94 kof95 kof96 kof97 kof98 kof99 kotm kotm2 kungfum ladybug lastblad lnc lresort lwings maglord mappy marble mario matmania mercsu midres milliped missile2 mk mk2 mk3 mk4 mpatrolw mrdofix mshu mslug mslug2 mslug3 mslug4 mslug5 mslugx mspacman mushisam mvscu mwalku nam1975 narc natodef nbbatman ncombat ncommand neckneck nibbler nvs_machrider orunners oscar osman outrun p47 pacman pacmania pacnchmp pacnpal pang panic paperboy pdrift pengo pitfall2 pitfight polepos pong popeye pow preisle2 puckmod pulstar punchout punisher qbert qbertqub qix rampage rastanu rbff2 rbibb rbtapper redalert ridgerac rmpgwt robocop2 robocopu robotron rocnrope rthunder rtypeu rushatck rygar samsho samsho2 samsho3 samsho4 samsho5 scontra scramble sdodgeb sf2ceuc sf2ua sfa3ur1 shadfrce sharrier shdancer1 shinobi simpsons simpsons4pa sinistar skyskipr smashtv smgolf smgp5 snapjack spidman spyhunt srumbler ssf2t ssf2u stargate stratvox strider superchs superpac suprmrioa svc swimmer tapper tazmania tempest1 timber tkoboxng tmnt tmnt2 toki toobin topgun tron truxton turbo twocrude umk3 vanguard vf viewpoin vigilant vr vsbball vsgradus vsgshoe vsskykid vstennis warlords wh1 wh2 whp wow wrecking xeviousc xmcotau zaxxon zookeep zzyzzyxx " ~ " " _driverarr[1] " " ) _tags = _tags "realistic" "@" "oro" "@"
# samples
if ( " 005 3bagfull astrof battles bbc blockade bowl3d buckrog carnival circus clowns congo cosmica cosmicg crash dai3wksi depthch equites fantasy fruitsamples ftaerobi gaplus genpin gmissile gridlee homerun ifslots invaders invinco ipminvad journey kst25 ktmnt2 ktopgun2 lrescue lupin3 m4 midiverb MM1_keyboard mmagic moepro88 moepro90 moepro monsterb mpsaikyo mptennis natodef nsub ozmawars panic phantom2 ptrmj pulsar qbert rallyx redclash relay ripcord robotbwl safarir samples sasuke seawolf sharkatt smoepro spacefb spaceod subroc3d targ tattack terao thehand thief triplhnt turbo twotiger vanguard zaxxon zerohour " ~ " " _sampleof " " ) _tags = _tags "samples" "@"

##predefined categories progettosnaps


##categories by filters

# atari, rule out drivers that are tagged non-arcade or mechanical
if (_cache ~ "atari/" && _tags ~ "@arcade@" && _tags !~ "@mechanical@" && _tags !~ "@screenless@" && _tags !~ "@bios@") _tags = _tags "atari" "@"

# bootlegs
if (_driverarr[3] ~ "bootleg" || _driverarr[4] ~ "bootleg") _tags = _tags "bootlegs" "@"

##capcom
# capcom, rule out drivers that are tagged non-arcade or mechanical
if (_cache ~ "capcom/" && _tags ~ "@arcade@" && _tags !~ "@mechanical@" && _tags !~ "@screenless@" && _tags !~ "@bios@" && _cache !~ "capcom/cps") _tags = _tags "capcom" "@"
# cps1, rule out drivers that are tagged non-arcade or mechanical
if (_cache ~ "capcom/cps1" && _tags ~ "@arcade@" && _tags !~ "@mechanical@" && _tags !~ "@screenless@" && _tags !~ "@bios@") _tags = _tags "cps1" "@"
# cps2, rule out drivers that are tagged non-arcade or mechanical
if (_cache ~ "capcom/cps2" && _tags ~ "@arcade@" && _tags !~ "@mechanical@" && _tags !~ "@screenless@" && _tags !~ "@bios@") _tags = _tags "cps2" "@"
# cps3, rule out drivers that are tagged non-arcade or mechanical
if (_cache ~ "capcom/cps3" && _tags ~ "@arcade@" && _tags !~ "@mechanical@" && _tags !~ "@screenless@" && _tags !~ "@bios@") _tags = _tags "cps3" "@"
# dataeast, rule out drivers that are tagged non-arcade or mechanical
if (_cache ~ "dataeast/" && _tags ~ "@arcade@" && _tags !~ "@mechanical@" && _tags !~ "@screenless@" && _tags !~ "@bios@") _tags = _tags "dataeast" "@"

# tigerrz
#do before tigerh and classich
if (_cache ~ "handheld/rzone" && _tags ~ "@good@") _tags = _tags "tigerrz" "@"

# tigerh
#do before classich
if (_cache ~ "handheld/hh_sm510.*svg" && _driverinfo ~ "Tiger Electronics" && _tags ~ "@good@") _tags = _tags "tigerh" "@"
# classich
if (_cache ~ "handheld" && _driverinfo ~ "Bambino" && _tags ~ "@good@") _tags = _tags "classich" "@"
if (_cache ~ "handheld" && _driverinfo ~ "Bandai" && _tags ~ "@good@") _tags = _tags "classich" "@"
#will not add (quizwizc tc4)
if (_cache ~ "handheld" && _driverinfo ~ "Coleco" && _tags ~ "@good@" && _driverinfo !~ "quizwizc" && _driverinfo !~ "tc4") _tags = _tags "classich" "@"
#if (_cache ~ "handheld" && _driverinfo ~ "Coleco / Konami" && _tags ~ "@good@") _tags = _tags "classich" "@"
if (_cache ~ "handheld" && _driverinfo ~ "Conic" && _tags ~ "@good@") _tags = _tags "classich" "@"
if (_cache ~ "handheld" && _driverinfo ~ "Entex" && _tags ~ "@good@") _tags = _tags "classich" "@"
if (_cache ~ "handheld" && _driverinfo ~ "Epoch" && _tags ~ "@good@") _tags = _tags "classich" "@"
#epo_tetr (needs a check if there are more with this info)
if (_cache ~ "tvgames/spg2xx.*raster" && _driverinfo ~ "Epoch" && _tags ~ "@good@") _tags = _tags "classich" "@"
if (_cache ~ "handheld" && _driverinfo ~ "Gakken" && _tags ~ "@good@") _tags = _tags "classich" "@"
#if (_cache ~ "handheld" && _driverinfo ~ "Gakken / Konami" && _tags ~ "@good@") _tags = _tags "classich" "@"
if (_cache ~ "handheld" && _driverinfo ~ "Kmart Corporation" && _tags ~ "@good@") _tags = _tags "classich" "@"
if (_cache ~ "handheld" && _driverinfo ~ "Hasbro" && _tags ~ "@good@") _tags = _tags "classich" "@"
#gigapets (needs a check if there are more with this info)
if (_cache ~ "tvgames/spg2xx.*raster" && _driverarr[4] == "Hasbro" && _tags ~ "@good@"  && _tags !~ "@all_in1") _tags = _tags "classich" "@"
if (_cache ~ "handheld" && _driverinfo ~ "Ideal Toy Corporation" && _tags ~ "@good@") _tags = _tags "classich" "@"
if (_cache ~ "handheld" && _driverinfo ~ "Mattel Electronics" && _tags ~ "@good@") _tags = _tags "classich" "@"
if (_cache ~ "svg" && _driverinfo ~ "Mattel Electronics / Teletape Productions" && _tags ~ "@good@") _tags = _tags "classich" "@"
if (_cache ~ "handheld" && _driverinfo ~ "Nelsonic" && _tags ~ "@good@") _tags = _tags "classich" "@"
#if (_cache ~ "handheld" && _driverinfo ~ "Nelsonic (licensed from Nintendo)" && _tags ~ "@good@") _tags = _tags "classich" "@"
if (_cache ~ "handheld" && _driverinfo ~ "Parker Brothers" && _tags ~ "@good@") _tags = _tags "classich" "@"
#do not add : comparc comparca monkeysee vclock3
if (_cache ~ "handheld" && _driverinfo ~ "Tandy Corporation"  && _tags ~ "@good@" && _driverinfo !~ "comparc" && _driverinfo !~ "monkeysee" && _driverinfo !~ "vclock3") _tags = _tags "classich" "@"
if (_cache ~ "handheld" && _driverinfo ~ "Tiger Electronics"  && _tags ~ "@good@" && _tags !~ "@tiger" && _driverinfo !~ "hh_sm510") _tags = _tags "classich" "@"
if (_cache ~ "handheld" && _driverinfo ~ "Tomy" && _tags ~ "@good@") _tags = _tags "classich" "@"
if (_cache ~ "handheld" && _driverinfo ~ "Tronica" && _tags ~ "@good@") _tags = _tags "classich" "@"
if (_cache ~ "handheld" && _driverinfo ~ "U.S.Games" && _tags ~ "@good@") _tags = _tags "classich" "@"
if (_cache ~ "handheld" && _driverinfo ~ "VTech" && _tags ~ "@good@") _tags = _tags "classich" "@"

# deco_cassette
if (_cache ~ "dataeast/decocass") _tags = _tags "deco_cassette" "@"

# dynarec 
#most likely drivers that will use arm dynarec
if (_cache ~ "cpu/mips" || _cache ~ "cpu/sh" || _cache ~ "cpu/powerpc" || _cache ~ "cpu/risc") _tags = _tags "dynarec" "@"

# elektronikah
#will also add screenless driver elbaskb
if (_cache ~ "handheld.*svg" && _driverinfo ~ "Elektronika" && _tags ~ "@good@" || _cache ~ "handheld.*lcd" && _driverinfo ~ "Elektronika" && _tags ~ "@good@" || _driverinfo ~ "elbaskb" ) _tags = _tags "elektronikah" "@"
# gameandwatch
if (_driverinfo ~ "bassmate") _tags = _tags "gameandwatch" "@"
if (_cache ~ "handheld" && _driverinfo ~ "gnw_" && _tags ~ "@good@") _tags = _tags "gameandwatch" "@"

# jakks
#jak_pacg jak_rapm jak_spac
#will also add preliminary driver jak_sdoo
if (_driverinfo ~ "JAKKS Pacific TV Game" && _tags ~ "@good@" || _driverinfo ~ "JAKKS Pacific Inc / Namco / HotGen Ltd" && _tags ~ "@good@" || _driverinfo ~ "jak_sdoo") _tags = _tags "jakks" "@"

# konamih
#ktmntbb (ok)
if (_cache ~ "handheld/hh_sm510.*svg" && _driverinfo ~ "Konami"  && _tags ~ "@good@" && _tags !~ "classich" || _cache ~ "handheld.*lcd" && _driverinfo ~ "Konami"  && _tags ~ "@good@" && _tags !~ "classich") _tags = _tags "konamih" "@"
# lightgun
if (_cache ~ "lightgun") _tags = _tags "lightgun" "@"

##konami
# konami , rule out drivers that are tagged non-arcade or mechanical
if (_cache ~ "konami/" && _tags ~ "@arcade@" && _tags !~ "@mechanical@" && _tags !~ "@screenless@" && _tags !~ "@bios@") _tags = _tags "konami" "@"

##midway
# midway, rule out drivers that are tagged non-arcade or mechanical and already categorised midway systems
if (_cache ~ "midway/" && _tags ~ "@arcade@" && _tags !~ "@mechanical@" && _tags !~ "@screenless@" && _tags !~ "@bios@" && _cache !~ "midway/astrocde") _tags = _tags "midway" "@"

##namco
# namco, rule out drivers that are tagged non-arcade or mechanical
if (_driverinfo ~ "Namco" && _tags ~ "@arcade@" && _tags !~ "@mechanical@" && _tags !~ "@bios@" && _tags !~ "@screenless@" && _cache !~ "namco/namcos") _tags = _tags "namco" "@"
# namcosystem1
if (_cache ~ "namco/namcos1.cpp" && _tags !~ "@bios@") _tags = _tags "namcosystemxx@namcosystem01" "@"
# namcosystem2
if (_cache ~ "namco/namcos2.cpp" && _tags !~ "@bios@") _tags = _tags "namcosystemxx@namcosystem02" "@"
# namcosystem10
if (_cache ~ "namco/namcos10" && _tags !~ "@bios@") _tags = _tags "namcosystemxx@namcosystem10" "@"
# namcosystem11
if (_cache ~ "namco/namcos11" && _tags !~ "@bios@") _tags = _tags "namcosystemxx@namcosystem11" "@"
# namcosystem12
if (_cache ~ "namco/namcos12" && _tags !~ "@bios@") _tags = _tags "namcosystemxx@namcosystem12" "@"
# namcosystem21 , rule out one driver that is tagged non-arcade (gal3)
if (_cache ~ "namco/namcos21" && _tags ~ "@arcade@" && _tags !~ "@bios@") _tags = _tags "namcosystemxx@namcosystem21" "@"
# namcosystem22
if (_cache ~ "namco/namcos22" && _tags !~ "@bios@") _tags = _tags "namcosystemxx@namcosystem22" "@"
# namcosystem23
if (_cache ~ "namco/namcos23" && _tags !~ "@bios@") _tags = _tags "namcosystemxx@namcosystem23" "@"

##sega
# atomiswave, rule out drivers that are tagged non-arcade or mechanical
if (_cache ~ "sega/dc_atomiswave" && _tags ~ "@arcade@" && _tags !~ "@mechanical@" && _tags !~ "@screenless@" && _tags !~ "@bios@") _tags = _tags "atomiswave" "@"
# megaplay
if (_cache ~ "sega/megaplay" && _tags !~ "@bios@") _tags = _tags "megaplay" "@"
# model1
if (_cache ~ "sega/model1.cpp") _tags = _tags "model1" "@"
# model2
if (_cache ~ "sega/model2.cpp") _tags = _tags "model2" "@"
# model3
if (_cache ~ "sega/model3.cpp") _tags = _tags "model3" "@"
# segasystem16, rule out drivers that are tagged non-arcade or mechanical
if (_cache ~ "sega/segas16" && _tags ~ "@arcade@" && _tags !~ "@mechanical@" && _tags !~ "@screenless@" && _tags !~ "@bios@") _tags = _tags "segasystemxx@segasystem16" "@"
# segasystem18, rule out drivers that are tagged non-arcade or mechanical
if (_cache ~ "sega/segas18" && _tags ~ "@arcade@" && _tags !~ "@mechanical@" && _tags !~ "@screenless@" && _tags !~ "@bios@") _tags = _tags "segasystemxx@segasystem18" "@"
# segasystem24, rule out drivers that are tagged non-arcade or mechanical
if (_cache ~ "sega/segas24" && _tags ~ "@arcade@" && _tags !~ "@mechanical@" && _tags !~ "@screenless@" && _tags !~ "@bios@") _tags = _tags "segasystemxx@segasystem24" "@"
# segasystem32, rule out drivers that are tagged non-arcade or mechanical
if (_cache ~ "sega/segas32" && _tags ~ "@arcade@" && _tags !~ "@mechanical@" && _tags !~ "@screenless@" && _tags !~ "@bios@") _tags = _tags "segasystemxx@segasystem32" "@"
# naomi, rule out drivers that are tagged non-arcade or mechanical
if (_cache ~ "sega/naomi" && _tags ~ "@arcade@" && _tags !~ "@mechanical@" && _tags !~ "@screenless@" && _tags !~ "@bios@") _tags = _tags "naomi" "@"
# sega, rule out drivers that are tagged non-arcade or mechanical and already categorised sega systems
if (_cache ~ "sega/" && _tags ~ "@arcade@" && _tags !~ "@mechanical@" && _tags !~ "@screenless@" && _tags !~ "@bios@" && _cache !~ "sega/dc_atomiswave" && _cache !~ "sega/model" && _cache !~ "sega/naomi" && _cache !~ "sega/segas1" && _cache !~ "sega/segas2" && _cache !~ "sega/segas3") _tags = _tags "sega" "@"

# neogeo
#not added (neogeo/midas.cpp (hammer livequiz))
#not added (ng_mv*), all marked good but do not start
if (_cache ~ "neogeo/neogeo.cpp" && _tags ~ "@arcade@" && _tags !~ "@bios@" && _driverinfo !~ "ng_mv1" || _cache ~ "neogeo/neopcb.cpp" && _tags ~ "@arcade@" && _tags !~ "@bios@"  && _driverinfo !~ "ng_mv1") _tags = _tags "neogeo" "@"

# nintendovs
if (_driverarr[3] ~ "^Vs. ") _tags = _tags "nintendovs" "@"

# playchoice10
if (_cache ~ "nintendo/playch10" && _tags !~ "@bios@") _tags = _tags "playchoice10" "@"

#samples
#drivers that use audio samples
#use predefined selection instead that match the available sample files !
#if (_cache ~ "sampleof=") _tags = _tags "samples" "@"

#print _cache
#print _driverinfo _tags

#print "Driver" " " _driverarr[1] " (" _driverarr[3] ") (" _driverarr[4] "): " _driverarr[5] _tags
#remove amp;
gsub(/amp;/, "", _driverarr[3])
print "Driver" " " _driverarr[1] " (" _driverarr[3] "): " _tags
}
'	
#echo;sleep 1
done
