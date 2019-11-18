#!/bin/bash

outputdir=$1
mkdir $outputdir/summary_pngs
niifilepaths=$(find $1 -name "*.nii*")


while read -r img 
do
    if grep -q TOF <<<$img || grep -q MRV <<<$img; then
        continue
    fi
    foo=$(cut -d'.' -f1 <<<$img)
    img2=$(echo ${foo##*/})
    ~/DICOMpose/slices_5panel $img -L --o $outputdir/summary_pngs/$img2.png 
done <<< "$niifilepaths"