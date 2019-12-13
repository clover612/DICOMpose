#!/bin/bash

set -e

FSLDIR=/usr/local/fsl
. ${FSLDIR}/etc/fslconf/fsl.sh
PATH=${FSLDIR}/bin:${PATH}
export FSLDIR PATH


dcpdir=$(pwd)
blkid /dev/sr0
CD_in=$(echo $?)
if [ "$CD_in" != "0" ]
then
    exit
fi
cd ../Downloads/
dcm2niix=$(pwd)/dcm2niix
echo "The dcm2niix directory is $dcm2niix"
cd ../Desktop/
mkdir temp_$(date "+%F-%T")
cd temp_$(date "+%F-%T")
outputfol=$(pwd)
echo "The destination folder is $outputfol"

cd $dcpdir 
time $dcpdir/DICOM_CD.sh $dcm2niix $outputfol --takeyourtime

patients=$(find $outputfol -maxdepth 1 -mindepth 1 -type d)
while read -r sline
do
    if grep -q OrganizedDICOMs <<<$sline; then
   	continue
    fi
    echo "SUMMARY FILES BEING CREATED FOR PATIENT:" $sline
	$dcpdir/summary_pngs_only.sh $sline $dcpdir
	echo "SUMMARY PNGS CREATED"
	$dcpdir/mass_html_singlept.sh $sline $dcpdir
	echo "SUMMARY HTML CREATED" 
done <<< "$patients"
