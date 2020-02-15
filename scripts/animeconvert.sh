#!/bin/bash
echo $1
cd "$1"
for file in *.mkv;
do
  audio=$(mkvmerge -I "$file" | sed -ne '/^Track ID [0-9]*: audio .* language:\(ger\|eng\|jpn\).*/ { s/^[^0-9]*\([0-9]*\):.*/\1/;H }; $ { g;s/[^0-9]/,/g;s/^,//;p }')
  echo "found $audio to keep"
  subs=$(mkvmerge -I "$file" | sed -ne '/^Track ID [0-9]*: subtitles (SubRip\/SRT).* language:\(ger\|eng\).*/ { s/^[^0-9]*\([0-9]*\):.*/\1/;H }; $ { g;s/[^0-9]/,/g;s/^,//;p }')
  echo "found $subs to keep"

    if [ -z "$subs" ]
    then

      echo "Nothing to remove, will look for ASS & PGS Files"
      audio=$(mkvmerge -I "$file" | sed -ne '/^Track ID [0-9]*: audio .* language:\(ger\|eng\|jpn\).*/ { s/^[^0-9]*\([0-9]*\):.*/\1/;H }; $ { g;s/[^0-9]/,/g;s/^,//;p }')
      echo "found $audio to keep"
      subs=$(mkvmerge -I "$file" | sed -ne '/^Track ID [0-9]*: subtitles [(SubStationAlpha)|(HDMV/PGS)|(VobSub)].*/ { s/^[^0-9]*\([0-9]*\):.*/\1/;H }; $ { g;s/[^0-9]/,/g;s/^,//;p }')
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
