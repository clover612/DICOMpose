
#!/bin/bash

######
# Created in October 2019
# @author: sb3784 / clover612
#
# DICOM_CD.sh finds the location of the DICOM_CD, organizes DICOMS in the destination folder, 
# and converts DICOMS to nii in the destination folder
# INPUTS: $1 = dcm2niix location, $2 = destination folder 
#####

dcm2niix=$1; outputfol=$2;


## USER INPUTS FOLDER WITH DICOMS
echo "Please enter the parent directory of dicoms. For faster processing, please remove files that are not dicoms from this directory."
read dicmdir
dicmdir="${dicmdir%\'}"; dicomdir="${dicmdir#\'}"
echo "NULL_$dicomdir" > $outputfol/diskname.txt

## FIND FILE PATH OF ALL DICOMS TO BE CONVERTED
imgfilepaths=$(file --separator : $(find $dicomdir -type f) | grep DICOM | cut -d':' -f1)
echo "Organizing DICOMs based on SubjectID, Scan Date & Modality"
echo "====================================="
echo "====================================="
echo "====================================="

count=0
total=$(file --separator : $(find $dicomdir -type f) | grep DICOM | cut -d':' -f1 | wc -l)
start=`date +%s`

## LOOP THROUGH DICOMS AND ORGANIZE 
while read -r sline
do 
    j=$sline
    if grep -q .DS_Store <<<$j || grep -q OrganizedDICOMs <<<$j || grep -q DICOMDIR <<<$j; then
    	continue
    fi

    SubjID=$(dcmdump $j | grep " PatientID" | sed 's/.*\[\([^]]*\)\].*/\1/g');
    ScanDate=$(dcmdump $j | grep "StudyDate" | grep -Eo '[0-9]{8}');
    Modality=$(dcmdump $j | grep "SeriesDescription" | grep -o '\[.*]'| sed 's/[^a-zA-Z0-9]*//g');

    ## Make new dirs for scan date & scan type
    if [ ! -d "$outputfol/OrganizedDICOMs/$SubjID/$ScanDate/$Modality" ]; then
    	mkdir -p $outputfol/OrganizedDICOMs/$SubjID/$ScanDate/$Modality;
    fi

    ## copy DICOM to corresponding Subj/Scandate/Modality dir
    cp $j $outputfol/OrganizedDICOMs/$SubjID/$ScanDate/$Modality;

    ## cd to parent directory to start the loop over again
    cd ${ParentDir} 
    cur=`date +%s`
    count=$(( $count + 1 ))
    pd=$(( $count * 73 / $total ))
    runtime=$(( $cur-$start ))
    estremain=$(( ($runtime * $total / $count)-$runtime ))
    printf "\r%d.%d%% complete ($count of $total) - est %d:%0.2d remaining\e[K" $(( $count*100/$total )) $(( ($count*1000/$total)%10)) $(( $estremain/60 )) $(( $estremain%60 ))   
     
done <<< "$imgfilepaths"


echo "DICOMS have been organized"
echo "====================================="
echo "====================================="
echo "====================================="


echo "CONVERTING DICOMS TO NII"
echo "====================================="
echo "====================================="
echo "====================================="

cd $outputfol/OrganizedDICOMs

## CONVERTING DICOMS TO NII WITH dcm2niix
all_fols=$(find . ! -path . -type d -mindepth 3)
while IFS= read -r line 
do 
	mkdir -p $outputfol/$line
	$dcm2niix -o $outputfol/$line $line 
done <<< "$all_fols"

echo "REMOVING ALL CREATED JSON FILES"
echo "====================================="
echo "====================================="
echo "====================================="

find $outputfol -cmin -10 -name "*.json" -delete

cd $outputfol
while getopts ":df:" opt; do
  case $opt in
  	d)
	  if [ $OPTARG -eq 1 ]	
	  then
		echo "REMOVING ORGANIZED DICOMS IN OUTPUT FOLDER"
		echo "====================================="
		echo "====================================="
		echo "====================================="
		rm -r $outputfol/OrganizedDICOMs
	  fi
	  ;;
    f)
      echo "-f was triggered, Parameter: $OPTARG" >&2
      if [ $OPTARG -eq 1 ]
      then
      	echo "MOVING FILE STRUCTURE..."
      	for d in `ls $outputfol`
      	do
		find $d -name '*.nii' -exec mv '{}' $d \;  #find all nii in output folder 
      		pwd
      		cd $d
      		pwd
		#move to parent directory
      		for file in *
      		do
	            foo=$(cut -d'.' -f1 <<<${file})
       		    mv ${file} ${foo}_${d}.nii
      		done
      		find . -type d -delete
      	done
      else 
      	echo "KEEPING FILE STRUCTURE, EXITING..."
      	exit 1
      fi
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done







