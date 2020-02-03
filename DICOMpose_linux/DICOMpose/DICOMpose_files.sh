#!/bin/bash

set -e

FSLDIR=/usr/local/fsl
. ${FSLDIR}/etc/fslconf/fsl.sh
PATH=${FSLDIR}/bin:${PATH}
export FSLDIR PATH
dcpdir=$(pwd)

cd ../Downloads/
dcm2niix=$(pwd)/dcm2niix
echo "The dcm2niix directory is $dcm2niix"
cd ../Desktop/
dsktpdir=$(pwd)
mkdir temp_$(date "+%F-%T")
cd temp_$(date "+%F-%T")
outputfol=$(pwd)
outputfol=/home/dicompose/Desktop/mstemp_files
echo "The destination folder is $outputfol"

#cd $dcpdir 
#$dcpdir/DICOM_files.sh $dcm2niix $outputfol 

LOGFILE=$outputfol/errors.log
(
#### SQL DATABASE CREATION
## CREATE dicompose.db file if it does not exist with existing table structure
python $dcpdir/create_table.py $dsktpdir/dicompose.db
## CHECK if this CD has already been entered into db
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

echo "Your folder has been DICOMposed."
