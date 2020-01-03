#!/bin/bash 

set -e
htmlloc=$1/summary.html; 
touch $htmlloc; rm $htmlloc
cat ~/Documents/Provenzano/DICOMpose/DICOMpose_mac/DICOMpose/template_top.html >> $htmlloc;
niifilepaths=$(find $1 -name "*.nii*"|sort)
outputdir=$1
oldPROTNAME=0

while read -r img 
do
    if grep -q TOF <<<$img || grep -q MRV <<<$img; then
        continue
    fi
    foo=$(cut -d'.' -f1 <<<$img)
    img2=$(echo ${foo##*/})
    PROTNAME=$(cut -d'_' -f1 <<<$img2)
    if [ "$PROTNAME" != "$oldPROTNAME" ]; then
        sed -i '' 's/emma//g' $htmlloc
  		# sed -i $@'/div>checksrin/i \ 
  		# <a href="#PROTNAME">PROTNAME</a> \
  		# ' "$htmlloc"; 
        sed -i '' '/div>checksrin/i \ 
        potato \
        ' "$htmlloc";

        sed -i '' '/potato/{
        s/potato//g
        r /Users/srinidhibharadwaj/Documents/Provenzano/DICOMpose/subnav_temp.html
        }' $htmlloc

        echo "<h1 style=\"color:green;\">$PROTNAME</h1>">>$htmlloc

		sed -i -e "s^PROTNAME^$PROTNAME^g" "$htmlloc";
    fi

    cat ~/Documents/Provenzano/DICOMpose/DICOMpose_mac/DICOMpose/template_wt.html >> $htmlloc;
    sed -i -e "s^IMGNAME^$img2^g" "$htmlloc"; IMGLIST+=("$img2"); 
    sed -i -e "s^IMGLOC^$img^g" "$htmlloc";
    sed -i -e "s^PROTNAM^$PROTNAME^g" "$htmlloc";
    sed -i -e "s^PNGSOURCE^$outputdir\/summary_pngs\/$img2.png^g" "$htmlloc";
    sizex=`fslval $img pixdim1`; sed -i -e "s^v1^$sizex^g" "$htmlloc";
    sizey=`fslval $img pixdim2`; sed -i -e "s^v2^$sizey^g" "$htmlloc";
    sizez=`fslval $img pixdim3`; sed -i -e "s^v3^$sizez^g" "$htmlloc";
    nx=`fslval $img dim1`; sed -i -e "s^i1^$nx^g" "$htmlloc" ;
    ny=`fslval $img dim2`; sed -i -e "s^i2^$ny^g" "$htmlloc";
    nz=`fslval $img dim3`; sed -i -e "s^i3^$nz^g" "$htmlloc";
    fovx=`echo "$sizex * $nx" | bc -l`; sed -i -e "s^fovx^$fovx^g" "$htmlloc" ;
    fovy=`echo "$sizey * $ny" | bc -l`; sed -i -e "s^fovy^$fovy^g" "$htmlloc" ;
    fovz=`echo "$sizez * $nz" | bc -l`; sed -i -e "s^fovz^$fovz^g" "$htmlloc" ;
    sed -i '' '/div>emma/i \ 
    <a href="#img2">img2</a> \
    ' "$htmlloc"; 
    sed -i -e "s^img2^$img2^g" "$htmlloc";
    oldPROTNAME=$PROTNAME

    ## prepare for database

    CD_check=$3; 
    if [ "CD_check" == "1" ]; then
    ptid=$(awk -F/ '{print $(NF-3)}' <<< "$img");
    #echo $ptid
    acqdate=$(awk -F/ '{print $(NF-2)}' <<< "$img");
    CDIdfoo=$(cat $outputdir/diskname.txt);
    CDId=$(echo ${CDIdfoo##*/}); 
    python ~/Documents/Provenzano/DICOMpose/DICOMpose_mac/DICOMpose/insert_values.py ~/Desktop/dicompose.db $ptid $acqdate $CDId $PROTNAME $img2 $img "$outputdir/summary_pngs/$img2.png" $sizex $sizey $sizez $nx $ny $nz $fovx $fovy $fovz sb3784 $(date) sb3784 $(date)
    done

done <<< "$niifilepaths"

echo "</div>" >> $htmlloc
cat ~/Documents/Provenzano/DICOMpose/DICOMpose_mac/DICOMpose/scripts.html >> $htmlloc;
echo "</body>" >> $htmlloc
echo "</html>" >> $htmlloc
sed -i '' 's/checksrin//g' $htmlloc
sed -i '' 's/emma//g' $htmlloc