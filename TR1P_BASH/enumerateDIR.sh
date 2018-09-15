#!/bin/bash

# Create an array of items in a folder

declare -a mumbo

for file in *;do
mumbo+=(${file})
done

clear

filenumber=0
for item in *;do
echo ${mumbo[${filenumber}]}
filenumber=$(( ${filenumber} + 1 ))
done
