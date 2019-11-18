#!/bin/bash

echo "Please enter the path to the dcm2niix executable"
read dcm2niix 

echo "Please enter output folder"
read outputfol

/Users/srinidhibharadwaj/Documents/Provenzano/DICOMpose/DICOM_CD.sh $dcm2niix $outputfol

patients=$(find $outputfol -type d -maxdepth 1 -mindepth 1)
while read -r sline
do
	if grep -q OrganizedDICOMs <<<$sline; then
    	continue
    fi
	/Users/srinidhibharadwaj/Documents/Provenzano/DICOMpose/summary_pngs_only.sh $sline
	/Users/srinidhibharadwaj/Documents/Provenzano/DICOMpose/mass_html_singlept.sh $sline
done <<< "$patients"