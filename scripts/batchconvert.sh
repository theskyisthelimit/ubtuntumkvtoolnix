#!/bin/sh
find -type f ! -name "*edited.mkv" -size +2G -printf '\033[32m%p\033[0m\n'
find -type f ! -name "*edited.mkv" -size +2G -exec /media/scripts/oneconverter.sh {} \;
