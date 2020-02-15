#!/bin/sh
find -type f ! -name "*edited.mkv" -size +100M -printf '\033[32m%p\033[0m\n'
find -type f ! -name "*edited.mkv" -size +100M -exec /media/scripts/oneconverter.sh {} \;
