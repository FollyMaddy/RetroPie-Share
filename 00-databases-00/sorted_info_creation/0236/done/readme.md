#create .ini files from .csv files

for file in *.csv;do cat $file|cut -d "," -f1|sed 's/"//g' > $(basename $file .csv).ini ;done
