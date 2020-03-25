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
  
     if [ -z "$subs" ]
     then
       echo "3: Nothing to remove, will look for ASS & PGS Files"
       audio=$(mkvmerge -I "$file" | sed -ne '/^Track ID [0-9]*: audio .* language:\(ger\|eng\|jpn\|und\).*/ { s/^[^0-9]*\([0-9]*\):.*/\1/;H }; $ { g;s/[^0-9]/,/g;s/^,//;p }')
       echo "4: found $audio to keep"
       subs=$(mkvmerge -I "$file" | sed -ne '/^Track ID [0-9]*: subtitles [(SubStationAlpha)|(ASS)|(HDMV/PGS)|(VobSub)].*/ { s/^[^0-9]*\([0-9]*\):.*/\1/;H }; $ { g;s/[^0-9]/,/g;s/^,//;p }')
       echo "5: found $subs to remove"

       if [ -z "$subs" ]
       then
         if [ $diffaudio -gt 0 ]
		then
			echo "6: Only needed audio found."
			subs="-S";
			audio="-a $audio";
			mkvmerge $subs $audio -o "${file%.mkv}".edited.mkv "$file";
			mv "${file%.mkv}".edited.mkv "$file"
			echo "7: Unwanted audio found and removed!"
			# mv "$1" /media/Trash/;
		else
			echo "6: Nothing found to remove. Will exit script now."
		fi

       else
         subs="-S";
         audio="-a $audio";
         mkvmerge $subs $audio -o "${file%.mkv}".edited.mkv "$file";
         mv "${file%.mkv}".edited.mkv "$file"
         echo "7: PGS/ASS/VobSub Subtitles found and removed!"
         # mv "$1" /media/Trash/;
       fi
	
	 elif [ $diffsubs -eq 0 -a $diffaudio -eq 0 ]
	 then
	   echo "8: Only needed audio and subtitles found" 
	  
     else
       echo "8: Found Subtitles. Will multiplex now"
       subs="-s $subs";
       audio="-a $audio";

       mkvmerge $subs $audio -o "${file%.mkv}".edited.mkv "$file";
       mv "${file%.mkv}".edited.mkv "$file"
       # mv "$1" /media/Trash/;
     fi
	
  else
	echo "9: Nothing to do... exiting function"
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
  echo "9: Not a file nor a directory... exiting"
  exit
fi
exit
