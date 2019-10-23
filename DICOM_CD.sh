
#!/bin/bash

#CHECK WHERE DCM2NIIX IS INSTALLED
echo "Please enter the path to the dcm2niix executable"
read dcm2niix 

echo "Please enter output folder"
read outputfol

diskname=$(df -h | grep Volumes | grep 100% | rev | cut -d '/' -f1 | rev)
if [ -z "$diskname" ]
	then
	echo "NO CD MOUNTED, exiting..."
	exit
fi
echo $diskname "MOUNTED"
ParentDir=/Volumes/$diskname/
cd $ParentDir
echo "CD FOLDER:" $ParentDir

imgfilepaths=$(dcmdump DICOMDIR | grep "ReferencedFileID" | sed 's/.*\[\([^]]*\)\].*/\1/g' | sed 's/\\/\//g')

echo "Organizing DICOMs based on SubjectID, Scan Date & Modality"
echo "====================================="
echo "====================================="
echo "====================================="

# Assign SubjID to be initial directory name ##

# for i in $(find . ! -path . -type d -maxdepth 1)
# do
# 	SubjID=`echo "${i}"| sed 's|^./||'`
# 	echo "Organizing DICOMs for $SubjID"
# 	echo "============================="

## loop through files in each subject dir
while read -r sline
do 
    j=$ParentDir/$sline
    #echo $j
    if grep -q .DS_Store <<<$j || grep -q OrganizedDICOMs <<<$j; then
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
done <<< "$imgfilepaths"
# done

echo "DICOMS have been organized"
echo "====================================="
echo "====================================="
echo "====================================="


echo "CONVERTING DICOMS TO NII"
echo "====================================="
echo "====================================="
echo "====================================="

cd $outputfol/OrganizedDICOMs

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
      		find $d -name '*.nii' -exec mv '{}' $d \; 
      		pwd
      		cd $d
      		pwd
      		for file in *
      		do
      			mv $file ${d}_${file}
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







