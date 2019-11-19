#!/bin/bash

echo "Please enter the path to the dcm2niix executable"
read dcm2niix 

echo "Please enter output folder"
read outputfol

~/DICOMpose/DICOMpose_linux/DICOMpose/DICOM_CD.sh $dcm2niix $outputfol

patients=$(find $outputfol -maxdepth 1 -mindepth 1 -type d)
while read -r sline
do
    if grep -q OrganizedDICOMs <<<$sline; then
   	continue
    fi
    echo "SUMMARY FILES BEING CREATED FOR PATIENT:" $sline
	/home/pliny/DICOMpose/DICOMpose_linux/DICOMpose/summary_pngs_only.sh $sline
	echo "SUMMARY PNGS CREATED"
	/home/pliny/DICOMpose/DICOMpose_linux/DICOMpose/mass_html_singlept.sh $sline /home/pliny/
	echo "SUMMARY HTML CREATED" 
done <<< "$patients"
