#!/bin/bash
dcm2niix=$1; outputfol=$2;
## LOCATE AND MOUNT ISO FROM DISC
echo "MOUNTING ISO"
isopath=/mnt/iso;
disk=$(find /media/ -maxdepth 2 -mindepth 2 -type d); diskb=$(basename -- $disk)
echo $diskb > $outputfol/diskname.txt
sudo cat /dev/sr0 > /home/dicompose/$diskb.iso 
sudo mount -o loop /home/dicompose/$diskb.iso $isopath
echo "ISO MOUNTED"

## FIND FILE PATH OF ALL DICOMS TO BE CONVERTED
cd $isopath
imgfilepaths=$(dcmdump DICOMDIR | grep "ReferencedFileID" | sed 's/.*\[\([^]]*\)\].*/\1/g' | sed 's/\\/\//g')


echo "Organizing DICOMs based on SubjectID, Scan Date & Modality"
echo "====================================="
echo "====================================="
echo "====================================="

## LOOP THROUGH DICOMS AND ORGANIZE 
while read -r sline
do 
    j=$isopath/$sline
    if grep -q .DS_Store <<<$j || grep -q OrganizedDICOMs <<<$j; then
    	continue
    fi

    SubjID=$(dcmdump $j | grep " PatientID" | sed 's/.*\[\([^]]*\)\].*/\1/g');
    ScanDate=$(dcmdump $j | grep "StudyDate" | grep -Eo '[0-9]{8}');
    Modality=$(dcmdump $j | grep "SeriesDescription" | grep -o '\[.*]'| sed 's/[^a-zA-Z0-9]*//g');

    ## Make new dirs for scan date & scan type
    if [ ! -d "$outputfol/OrganizedDICOMs/$SubjID/$ScanDate/$Modality" ]; then
    	mkdir -p $outputfol/OrganizedDICOMs/$SubjID/$ScanDate/$Modality;
		echo "$Modality FOLDER CREATED"    
    fi

    ## copy DICOM to corresponding Subj/Scandate/Modality dir
    cp $j $outputfol/OrganizedDICOMs/$SubjID/$ScanDate/$Modality;

    ## cd to parent directory to start the loop over again
    cd ${ParentDir}      
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
sudo umount $isopath
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
		#move to parent director
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

