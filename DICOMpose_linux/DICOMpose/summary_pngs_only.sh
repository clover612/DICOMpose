###############
# Created in November 2019
# author:@sb3784 / clover612
#
# summary_pngs_only.sh creates summary images for each nifti created from the DICOM_CD.sh script
# with a modified version of fsl slices in destination folder 
# INPUTS: $1 = destination folder
###############

#!/bin/bash

outputdir=$1
mkdir $outputdir/summary_pngs
niifilepaths=$(find $1 -name "*.nii*") #find all niftis in destination folder 

# for all niftis found
while read -r img 
do
    if grep -q TOF <<<$img || grep -q MRV <<<$img; then
        continue
    fi
    foo=$(cut -d'.' -f1 <<<$img) 
    img2=$(echo ${foo##*/}) #summary image name
    ~/DICOMpose/DICOMpose_linux/DICOMpose/slices_5panel $img -L --o $outputdir/summary_pngs/$img2.png #-L prints slice number information on images
done <<< "$niifilepaths"
