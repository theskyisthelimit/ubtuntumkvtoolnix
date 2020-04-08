#!/bin/bash
mkv () {
  if [ ! -z "$1" ]
  then
    echo "Starting conversion for $1"
    file=$(echo "$1")
    mkvmerge -I "$file"
    audio=$(mkvmerge -I "$file" | sed -ne '/^Track ID [0-9]*: audio .* language:\(ger\|eng\|jpn\|und\).*/ { s/^[^0-9]*\([0-9]*\):.*/\1/;H }; $ { g;s/[^0-9]/,/g;s/^,//;p }')
    audiocount=$(echo $audio | tr "," "\n" | wc -l)
    echo "1: found $audio ($audiocount) to keep"
    
	subs=$(mkvmerge -I "$file" | sed -ne '/^Track ID [0-9]*: subtitles (SubRip\/SRT).* language:\(ger\|eng\).*/ { s/^[^0-9]*\([0-9]*\):.*/\1/;H }; $ { g;s/[^0-9]/,/g;s/^,//;p }')
    subscount=$(echo $subs | tr "," "\n" | wc -l)
    echo "2: found $subs ($subscount) to keep"
        
    totalaudio=$(mkvmerge -I "$file" | grep audio | wc -l)
    totalsubs=$(mkvmerge -I "$file" | grep subtitles | wc -l)
  
    diffaudio=$(expr $totalaudio - $audiocount)
    diffsubs=$(expr $totalsubs - $subscount)

    echo "3: setting parameters"

    if [ -z "$subs" ]
    then
      subs="-S"
    else
      subs="-s $subs"
    fi
    
	audio="-a $audio"
	
    if [ $diffaudio -gt 0 -o $diffsubs -gt 0 ]
	then
	  mkvmerge $subs $audio -o "${file%.mkv}".edited.mkv "$file";
	  mv "${file%.mkv}".edited.mkv "$file"
	  echo "4: Unwanted audio or subtitles found and removed!"		
	  # mv "$1" /media/Trash/;
			
	else
	  echo "4: Nothing found to remove. Will exit script now."
	fi
	
  else
	echo "5: Nothing to do... exiting function"
  fi	 
}

if [ -d $1 ]
then
  cd "$1"
  for filename in *.mkv;
  do
    mkv "$filename"
  done
  
elif [ -f $1 ]
then
  mkv "$1"

else
  echo "6: Not a file nor a directory... exiting"
  exit
fi
exit