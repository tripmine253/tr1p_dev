#!/bin/bash
foo="/home/unknown/Desktop/working"
clear;echo -n "NO CHANGE: ${foo}";echo '       Format: ${foo}'
echo -n "SINGLE PERCENT: ${foo%/*} ";echo '         Format: ${foo%/*}  --- Percent deletes from the RIGHT  back to the 1ST marker'
echo -n "DOUBLE PERCENT: ${foo%%/*}";echo '                               Format: ${foo%%/*} --- Percent deletes from the RIGHT  back to the LAST marker'
echo -n "SINGLE HASH: ${foo#*/}";echo '      Format: ${foo#*/}  --- Hash deletes from the LEFT  back to the 1ST marker'
echo -n "DOUBLE HASH ${foo##*/}";echo '                            Format: ${foo##*/} --- Hash deletes from the LEFT  back to the LAST marker'



echo ""
echo 'for x in mymp3.mp3;do echo "${x} vs ${x%.*} vs ${x%.*}.wav vs ${x/*.}";done'
echo ""
for x in mymp3.mp3;do echo "${x} vs ${x%.*} vs ${x%.*}.wav vs ${x/*.}";done
