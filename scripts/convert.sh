#for file in "$@"*.mkv; do
if [[ "${sonarr_eventtype}" = "Test" ]];
then
  echo "nothing to see here"
  exit
else
    for file in "$1";
    do
      subs=$(mkvmerge -I "$file" | sed -ne '/^Track ID [0-9]*: subtitles (SubRip\/SRT).* language:[eg].*/ { s/^[^0-9]*\([0-9]*\):.*/\1/;H }; $ { g;s/[^0-9]/,/g;s/^,//;p }')
      audio=$(mkvmerge -I "$file" | sed -ne '/^Track ID [0-9]*: audio.* language:[eg].*/ { s/^[^0-9]*\([0-9]*\):.*/\1/;H }; $ { g;s/[^0-9]/,/g;s/^,//;p }')

        if [ -z "$subs" ]
        then

          echo "Nothing to remove, will look for ASS Files"
          subs=$(mkvmerge -I "$file" | sed -ne '/^Track ID [0-9]*: subtitles (SubStationAlpha).*/ { s/^[^0-9]*\([0-9]*\):.*/\1/;H }; $ { g;s/[^0-9]/,/g;s/^,//;p }')
          echo "found $subs to remove"
          audio=$(mkvmerge -I "$file" | sed -ne '/^Track ID [0-9]*: audio.* language:[eg].*/ { s/^[^0-9]*\([0-9]*\):.*/\1/;H }; $ { g;s/[^0-9]/,/g;s/^,//;p }')
          echo "found $audio to keep"

          subs="-S";
          audio="-a $audio";

          mkvmerge $subs $audio -o "${file%.mkv}".edited.mkv "$file";
          mv "$1" /media/Trash/;
        else
          subs="-s $subs";
          audio="-a $audio";

          mkvmerge $subs $audio -o "${file%.mkv}".edited.mkv "$file";
          echo "Remove"
          mv "$1" /media/Trash/;
        fi
    done
fi
