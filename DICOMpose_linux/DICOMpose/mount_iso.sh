#!/bin/bash 


echo "MOUNTING ISO"
isopath=/mnt/iso;
disk=$(find /media/ -maxdepth 2 -mindepth 2 -type d); diskb=$(basename -- $disk)
#echo $diskb > $outputfol/diskname.txt
sudo cat /dev/sr0 > /home/dicompose/$diskb.iso 
sudo mount -o loop /home/dicompose/$diskb.iso $isopath
echo "ISO MOUNTED"