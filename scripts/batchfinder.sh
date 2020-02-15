#!/bin/sh
if [ -f /media/scripts/logfile.log ]]; then
  rm /media/scripts/logfile.log
fi
find "`pwd`" -type f -name "*.mkv" -size +1G -printf '\033[32m%p\033[0m\n'
find "`pwd`" -type f -name "*.mkv" -size +1G -exec /media/scripts/subtitlefinder.sh {} \;
