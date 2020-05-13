#!/bin/bash

##############
# Created in Winter 2020
# author:@sb3784 / clover612
# DICOMpose_CD.sh executes the full DICOMpose pipeline
# for a local file directory
############## 

set -e

### FILE DESIGNATIONS

# fsl dir designation
FSLDIR=/usr/local/fsl
. ${FSLDIR}/etc/fslconf/fsl.sh
PATH=${FSLDIR}/bin:${PATH}
export FSLDIR PATH

#dicompose directory designation
dcpdir=$(pwd)

#dcm2niix designation
cd ../Downloads/
dcm2niix=$(pwd)/dcm2niix
echo "The dcm2niix directory is $dcm2niix"

#output folder designation
cd ../Desktop/
dsktpdir=$(pwd)
mkdir temp_$(date "+%F-%T")
cd temp_$(date "+%F-%T")
outputfol=$(pwd)
echo "The destination folder is $outputfol"

$dcpdir/DICOM_files.sh $dcm2niix $outputfol 

## ERROR FILE CREATION
LOGFILE=$outputfol/errors.log
(
#### SQL DATABASE CREATION
## CREATE dicompose.db file if it does not exist with existing table structure
python $dcpdir/create_table.py $dsktpdir/dicompose.db
## CHECK if this file path has already been entered into db
CDIdfoo=$(cat $outputfol/diskname.txt);
CDId=$(echo ${CDIdfoo##*/}); 
CD_check=$(python $dcpdir/sqlNewCD.py $dsktpdir/dicompose.db CDId)
####

patients=$(find $outputfol -maxdepth 1 -mindepth 1 -type d)
while read -r sline
do
    if grep -q OrganizedDICOMs <<<$sline; then
   	continue
    fi
    echo "SUMMARY FILES BEING CREATED FOR PATIENT:" $sline
	$dcpdir/summary_pngs_only.sh $sline $dcpdir
	echo "SUMMARY PNGS CREATED"
	$dcpdir/mass_html_singlept.sh $sline $dcpdir $CD_check
	echo "SUMMARY HTML CREATED" 
done <<< "$patients"
) >& $LOGFILE

echo "Your folder has been DICOMposed. Check errors.log within output directory for errors."
