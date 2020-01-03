#!/bin/bash

echo "Please enter the path to the dcm2niix executable"
read dcm2niix 

echo "Please enter output folder"
read outputfol

/Users/srinidhibharadwaj/Documents/Provenzano/DICOMpose/DICOM_CD.sh $dcm2niix $outputfol

#### SQL DATABASE CREATION
## CREATE dicompose.db file if it does not exist with existing table structure
python $2/create_table.py $1/dicompose.db
## CHECK if this CD has already been entered into db
CDIdfoo=$(cat $outputdir/diskname.txt);
CDId=$(echo ${CDIdfoo##*/}); 
CD_check=$(python $2/sqlNewCD.py $1/dicompose.db CDId)
####


patients=$(find $outputfol -type d -maxdepth 1 -mindepth 1)
while read -r sline
do
	if grep -q OrganizedDICOMs <<<$sline; then
    	continue
    fi
	/Users/srinidhibharadwaj/Documents/Provenzano/DICOMpose/summary_pngs_only.sh $sline
	/Users/srinidhibharadwaj/Documents/Provenzano/DICOMpose/mass_html_singlept.sh $sline $CD_check
done <<< "$patients"