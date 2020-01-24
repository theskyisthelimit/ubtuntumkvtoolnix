#!/bin/bash
for file in "$1"
do
  audio=$(mkvmerge -I "$file" | sed -ne '/^Track ID [0-9]*: audio .* language:\(ger\|eng\|und\).*/ { s/^[^0-9]*\([0-9]*\):.*/\1/;H }; $ { g;s/[^0-9]/,/g;s/^,//;p }')
  echo "found $audio audio to keep"
  subs=$(mkvmerge -I "$file" | sed -ne '/^Track ID [0-9]*: subtitles (SubRip\/SRT).* language:\(ger\|eng\).*/ { s/^[^0-9]*\([0-9]*\):.*/\1/;H }; $ { g;s/[^0-9]/,/g;s/^,//;p }')
  echo "found $subs subs to keep"

    if [ -z "$subs" ]
    then

      echo "Nothing to remove, will look for ASS & PGS Files"
      audio=$(mkvmerge -I "$file" | sed -ne '/^Track ID [0-9]*: audio .* language:\(ger\|eng\|jpn\|und\).*/ { s/^[^0-9]*\([0-9]*\):.*/\1/;H }; $ { g;s/[^0-9]/,/g;s/^,//;p }')
      echo "found $audio to keep"
      subs=$(mkvmerge -I "$file" | sed -ne '/^Track ID [0-9]*: subtitles [(SubStationAlpha)|(ASS)|(HDMV/PGS)|(VobSub)].*/ { s/^[^0-9]*\([0-9]*\):.*/\1/;H }; $ { g;s/[^0-9]/,/g;s/^,//;p }')
      echo "found $subs to remove"

      subs="-S";
      audio="-a $audio";

      mkvmerge $subs $audio -o "${file%.mkv}".edited.mkv "$file";
      mv "${file%.mkv}".edited.mkv "$file"
      # mv "$1" /media/Trash/;
    else
      subs="-s $subs";
      audio="-a $audio";

      mkvmerge $subs $audio -o "${file%.mkv}".edited.mkv "$file";
      echo "Remove"
      mv "${file%.mkv}".edited.mkv "$file"
      # mv "$1" /media/Trash/;
    fi
    done
exit
