#!/bin/bash

outputdir=/Volumes/Srinidhi_Bh/Provenzano/trial/CD1
mkdir $outputdir/summary_pngs
mkdir $outputdir/summary_html
niifilepaths=$(find /Volumes/Srinidhi_Bh/Provenzano/trial/CD1/ -name "*.nii*")


while read -r img 
do
    if grep -q TOF <<<$img || grep -q MRV <<<$img; then
        continue
    fi
    foo=$(cut -d'.' -f1 <<<$img)
    img2=$(echo ${foo##*/})
    PROTNAME=$(cut -d'_' -f1 <<<$img2)
    ~/Documents/Provenzano/DICOM_CD_scripts/slices_5panel $img -L --o $outputdir/summary_pngs/$img2.png 
    htmlloc=$outputdir/summary_html/$img2.html
    cp ~/Documents/Provenzano/DICOM_CD_scripts/template.html $htmlloc;
    sed -i -e "s+IMGNAME+$img2+g" "$htmlloc";
    sed -i -e "s+IMGLOC+$img+g" "$htmlloc";
    sed -i -e "s+PROTNAM+$PROTNAME+g" "$htmlloc";
    sed -i -e "s+PNGSOURCE+$outputdir\/summary_pngs\/$img2.png+g" "$htmlloc";
    sizex=`fslval $img pixdim1`; sed -i -e "s+v1+$sizex+g" "$htmlloc";
    sizey=`fslval $img pixdim2`; sed -i -e "s+v2+$sizey+g" "$htmlloc";
    sizez=`fslval $img pixdim3`; sed -i -e "s+v3+$sizez+g" "$htmlloc";
    nx=`fslval $img dim1`; sed -i -e "s+i1+$nx+g" "$htmlloc" ;
    ny=`fslval $img dim2`; sed -i -e "s+i2+$ny+g" "$htmlloc";
    nz=`fslval $img dim3`; sed -i -e "s+i3+$nz+g" "$htmlloc";
    fovx=`echo "$sizex * $nx" | bc -l`; sed -i -e "s+fovx+$fovx+g" "$htmlloc" ;
    fovy=`echo "$sizey * $ny" | bc -l`; sed -i -e "s+fovy+$fovy+g" "$htmlloc" ;
    fovz=`echo "$sizez * $nz" | bc -l`; sed -i -e "s+fovz+$fovz+g" "$htmlloc" ;

done <<< "$niifilepaths"