#!/bin/bash 

# Echos a random file name
# The name is selected by creating an array of all the files in the folder
# and chosen by selecting a random number less than the maximum files in that folder.

# This utility script should help with random song selection or photo selection for wallpaper.
# Created by Tim Gomez
# Date: 8/26/2010
# The Last Patrol of Operation Iraqi Freedom

declare -a mumbo

filenumber=0
for filename in *;do
mumbo+=($filename)
filenumber=$(( $filenumber + 1 ))
done
topnum="${filenumber}"

if [ $topnum -gt 9 ];then
digit=2
elif [ $topnum -gt 99];then
digit=3
else
digit=4
fi


numgen(){
myrandomnum="${RANDOM::$digit}"
myrandomnum=$(( 10#$myrandomnum ))
}

numgen

until [ $myrandomnum -lt $topnum ];do
numgen
done

echo "${mumbo[${myrandomnum}]}"
