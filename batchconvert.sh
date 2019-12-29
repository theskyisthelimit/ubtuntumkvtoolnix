#!/bin/sh
find . -name '*.mkv' -printf '\033[32m%p\033[0m\n'
find . -name '*.mkv' -exec /media/convert.sh {} \;
