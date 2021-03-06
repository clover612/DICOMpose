#!/bin/bash 

############
# Created Spring 2020
# author:@sb3784
# 
# mount_iso.sh mounts a disk drive as a local iso
########### 

echo "MOUNTING ISO"
isopath=/mnt/iso;
disk=$(find /media/ -maxdepth 2 -mindepth 2 -type d); diskb=$(basename -- $disk)
sudo cat /dev/sr0 > /home/dicompose/$diskb.iso 
sudo mount -o loop /home/dicompose/$diskb.iso $isopath
echo "ISO MOUNTED"