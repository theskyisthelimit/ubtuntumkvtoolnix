#!/bin/sh
#for file in "$@"*.mkv; do
for file in "$1";
do
    subs=$(mkvmerge -I "$file" | sed -ne '/^Track ID [0-9]*: subtitles (SubRip\/SRT).* language:[eg].*/ { s/^[^0-9]*\([0-9]*\):.*/\1/;H }; $ { g;s/[^0-9]/,/g;s/^,//;p }')
    audio=$(mkvmerge -I "$file" | sed -ne '/^Track ID [0-9]*: audio.* language:[eg].*/ { s/^[^0-9]*\([0-9]*\):.*/\1/;H }; $ { g;s/[^0-9]/,/g;s/^,//;p }')

    subs="-s $subs";
    audio="-a $audio";

    mkvmerge $subs $audio -o "${file%.mkv}".edited.mkv "$file";
    rm "$1";
done
