#!/bin/bash
for file in "$1"
do
  echo -e "\033[31m $1"'\033[0m' >> /media/scripts/logfile.log
  mkvmerge -I "$file" | grep 'SubStationAlpha\|HDMV\/PGS\|VobSub' >> /media/scripts/logfile.log
#  mkvmerge -I "$file" | grep 'SubRip' >> /media/scripts/logfile.log
  echo >> /media/scripts/logfile.log
done
