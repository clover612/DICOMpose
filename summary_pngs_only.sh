#!/bin/bash

outputdir=/Volumes/Srinidhi_Bh/Provenzano/trial/CD3/
mkdir $outputdir/summary_pngs
niifilepaths=$(find /Volumes/Srinidhi_Bh/Provenzano/trial/CD3/ -name "*.nii*")


while read -r img 
do
    if grep -q TOF <<<$img || grep -q MRV <<<$img; then
        continue
    fi
    foo=$(cut -d'.' -f1 <<<$img)
    img2=$(echo ${foo##*/})
    ~/Documents/Provenzano/DICOMpose/slices_5panel $img -L --o $outputdir/summary_pngs/$img2.png 
done <<< "$niifilepaths"