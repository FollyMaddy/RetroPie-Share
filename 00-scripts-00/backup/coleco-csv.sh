#!/usr/bin/env bash

maplist='
http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms_homebrew_0-9.php
http://web.archive.org/web/20200122144009/http://www.colecovision.ca/roms_homebrew_a.php
http://web.archive.org/web/20200122193402/http://www.colecovision.ca/roms_homebrew_b.php
http://web.archive.org/web/20191222150914/http://www.colecovision.ca/roms_homebrew_c.php
http://web.archive.org/web/20200123123643/http://www.colecovision.ca/roms_homebrew_d.php
http://web.archive.org/web/20200123124748/http://www.colecovision.ca/roms_homebrew_e.php
http://web.archive.org/web/20200123122613/http://www.colecovision.ca/roms_homebrew_f.php
http://web.archive.org/web/20200122193407/http://www.colecovision.ca/roms_homebrew_g.php
http://web.archive.org/web/20200121182728/http://www.colecovision.ca/roms_homebrew_h.php
http://web.archive.org/web/20200123123648/http://www.colecovision.ca/roms_homebrew_i.php
http://web.archive.org/web/20200121182646/http://www.colecovision.ca/roms_homebrew_j.php
http://web.archive.org/web/20200123123615/http://www.colecovision.ca/roms_homebrew_k.php
http://web.archive.org/web/20200123122618/http://www.colecovision.ca/roms_homebrew_l.php
http://web.archive.org/web/20200124144626/http://www.colecovision.ca/roms_homebrew_m.php
http://web.archive.org/web/20200122193212/http://www.colecovision.ca/roms_homebrew_n.php
http://web.archive.org/web/20200122144040/http://www.colecovision.ca/roms_homebrew_o.php
http://web.archive.org/web/20191222150850/http://www.colecovision.ca/roms_homebrew_p.php
http://web.archive.org/web/20200122193412/http://www.colecovision.ca/roms_homebrew_q.php
http://web.archive.org/web/20200123123943/http://www.colecovision.ca/roms_homebrew_r.php
http://web.archive.org/web/20191221212646/http://www.colecovision.ca/roms_homebrew_s.php
http://web.archive.org/web/20200122193234/http://www.colecovision.ca/roms_homebrew_t.php
http://web.archive.org/web/20200122193427/http://www.colecovision.ca/roms_homebrew_u.php
http://web.archive.org/web/20200122144437/http://www.colecovision.ca/roms_homebrew_v.php
http://web.archive.org/web/20200123124418/http://www.colecovision.ca/roms_homebrew_w.php
http://web.archive.org/web/20200122193255/http://www.colecovision.ca/roms_homebrew_x.php
http://web.archive.org/web/20200122193324/http://www.colecovision.ca/roms_homebrew_y.php
http://web.archive.org/web/20200122193244/http://www.colecovision.ca/roms_homebrew_z.php
'


for map in $maplist
do

curl -s "$map"|\
sed 's/href=/\n/g'|grep -s -v 'ColecoVision North Homebrew ROM Collection.zip'|grep roms/homebrews/|\
cut -d '"' -f2|\
cut -d '/' -f3|while read line;do
 echo \",$(echo $line|cut -d "." -f1),$line,coleco,http://web.archive.org/web/20200130163128/http://www.colecovision.ca/roms/homebrews/$(echo $line|sed 's/ /%20/g'),,,,,download_with_wget,\"
done

done
