#!/bin/bash 
set -e
htmlloc=/Volumes/Srinidhi_Bh/Provenzano/trial/CD3/summary.html; 
touch $htmlloc; rm $htmlloc
cat ~/Documents/Provenzano/DICOMpose/template_top.html >> $htmlloc;
niifilepaths=$(find /Volumes/Srinidhi_Bh/Provenzano/trial/CD3/8302035 -name "*.nii*")
outputdir=/Volumes/Srinidhi_Bh/Provenzano/trial/CD3
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
  		sed -i '' '/div>checksrin/i \ 
  		<a href="#PROTNAME">PROTNAME</a> \
  		' "$htmlloc"; 
		sed -i -e "s^PROTNAME^$PROTNAME^g" "$htmlloc";
		if [ "$oldPROTNAME" != "0" ]; then
			echo "</div>" >> $htmlloc
		fi
		echo "<div id=\"$PROTNAME\">" >> $htmlloc
		echo "<h1>$PROTNAME</h1>">>$htmlloc
    fi

    cat ~/Documents/Provenzano/DICOMpose/template_wt.html >> $htmlloc;
    sed -i -e "s^IMGNAME^$img2^g" "$htmlloc";
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
    oldPROTNAME=$PROTNAME

done <<< "$niifilepaths"

echo "</div>" >> $htmlloc
echo "</body>" >> $htmlloc
echo "</html>" >> $htmlloc
sed -i '' 's/checksrin//g' $htmlloc