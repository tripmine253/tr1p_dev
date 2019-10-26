#!/bin/bash
for x in *.mp4
do
./ffmpeg.exe -i "$x" -vn -acodec libmp3lame -ac 2 -ab 160k -ar 48000 "${x/.*}".mp3
done
mv *.mp3 ../Converted