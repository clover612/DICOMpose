#!/bin/bash 

##############
# Created in November 2019
# author:@sb3784 / clover612
# mass_html_singlept.sh creates a summary html file with information
# and summary images for each nifti in the destination
# INPUTS: $1 = patient destination folder 
#	  $2 = home (DICOMpose folder location) folder
#	  $3 = binary check to see whether CD has been uploaded to database
##############



htmlloc=$1/summary.html; 
touch $htmlloc; rm $htmlloc
#formatting for html file
cat $2/template_top.html >> $htmlloc;
#collecting all patient niftis
#niifilepaths=$(find $1 -name "*.nii*"|sort)
outputdir=$1; outputdir=${outputdir%/};
cd $outputdir
niifilepaths=$(find . -name "*.nii*"|sort -t/ -k3,3 -k2,2| sed "s?.?$outputdir?")
oldPROTNAME=0

# loop through images
while read -r img 
do
    # no summary info for time of flight images
    if grep -q TOF <<<$img || grep -q MRV <<<$img; then
        continue
    fi
    foo=$(cut -d'.' -f1 <<<$img)
    img2=$(echo ${foo##*/})
    # organize dropdowns by protocol name 
    PROTNAME=$(cut -d'_' -f1 <<<$img2)
    if [ "$PROTNAME" != "$oldPROTNAME" ]; then
        if [ "$oldPROTNAME" != "0" ]; then
            sed -i '0,/emma/s/emma//' "$htmlloc"
        else 
            ptid=$(awk -F/ '{print $(NF-3)}' <<< "$img"); sed -i -e "s^PATIENTID^$ptid^g" "$htmlloc";
	fi
        sed -i '0,/div>checksrin/s/<\/div>checksrin/potato\n&/' "$htmlloc" ###FOR UBUNTU
        sed -i "s/potato/$(sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' "$2/subnav_temp.html" | tr -d '\n')/" "$htmlloc" ###FOR UBUNTU
        echo "<h1 style=\"color:green;\">$PROTNAME</h1>">>$htmlloc
		sed -i -e "s^PROTNAME^$PROTNAME^g" "$htmlloc";
    fi

    # HTML BODY REPLACEMENT FOR EACH IMAGE 
    cat $2/template_wt.html >> $htmlloc;
    sed -i -e "s^IMGNAME^$img2^g" "$htmlloc"; IMGLIST+=("$img2"); 
    sed -i -e "s^IMGLOC^$img^g" "$htmlloc";
    sed -i -e "s^PROTNAM^$PROTNAME^g" "$htmlloc";
    acqdate=$(awk -F/ '{print $(NF-2)}' <<< "$img");
    sed -i -e "s^DATEACQ^$acqdate^g" "$htmlloc";
    if test -f "$outputdir/summary_pngs/$img2.png"; then
	     sed -i -e "s^PNGSOURCE^summary_pngs\/$img2.png^g" "$htmlloc";
    fi
    sizex=`fslval $img pixdim1`; sed -i -e "s^v1^$sizex^g" "$htmlloc";
    sizey=`fslval $img pixdim2`; sed -i -e "s^v2^$sizey^g" "$htmlloc";
    sizez=`fslval $img pixdim3`; sed -i -e "s^v3^$sizez^g" "$htmlloc";
    nx=`fslval $img dim1`; sed -i -e "s^i1^$nx^g" "$htmlloc" ;
    ny=`fslval $img dim2`; sed -i -e "s^i2^$ny^g" "$htmlloc";
    nz=`fslval $img dim3`; sed -i -e "s^i3^$nz^g" "$htmlloc";
    fovx=`echo "$sizex * $nx" | bc -l`; sed -i -e "s^fovx^$fovx^g" "$htmlloc" ;
    fovy=`echo "$sizey * $ny" | bc -l`; sed -i -e "s^fovy^$fovy^g" "$htmlloc" ;
    fovz=`echo "$sizez * $nz" | bc -l`; sed -i -e "s^fovz^$fovz^g" "$htmlloc" ;
    sed -i '0,/div>emma/s/<\/div>emma/<a href="#img2">img2<\/a>\n&/' "$htmlloc" ###FOR UBUNTU	
    sed -i -e "s^img2^$img2^g" "$htmlloc";
    oldPROTNAME=$PROTNAME
    
    ## prepare for database

    CD_check=$3; 
    if [ "$CD_check" == "1" ]; then
    ptid=$(awk -F/ '{print $(NF-3)}' <<< "$img");
    cd $outputdir; cd ..; parentdir=$(pwd);
    CDIdfoo=$(cat $parentdir/diskname.txt);
    CDId=$(echo ${CDIdfoo##*/}); 
    python $2/insert_values.py ~/Desktop/dicompose.db $ptid $acqdate $CDId $PROTNAME $img2 $img "$outputdir/summary_pngs/$img2.png" $sizex $sizey $sizez $nx $ny $nz $fovx $fovy $fovz sb3784 $(date) sb3784 $(date)
    fi

done <<< "$niifilepaths"



echo "</div>" >> $htmlloc
# some extra formatting 
cat $2/scripts.html >> $htmlloc;
echo "</body>" >> $htmlloc
echo "</html>" >> $htmlloc
sed -i '0,/checksrin/s/checksrin//' "$htmlloc"
sed -i '0,/emma/s/emma//' "$htmlloc"
