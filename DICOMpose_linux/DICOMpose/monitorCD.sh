#!/bin/bash

############
# Created November 2019
# author:@sb3784
# 
# monitorCD.sh is always deployed and checks when the system has a disc inserted
########### 

TARGET=/dev/sr0

inotifywait -m --format "%f" $TARGET \
	| sleep 8s #wait for computer to recognize CD
	  blkid_info=$(blkid /dev/sr0)
	  CD_in=$(echo $?) # VALUE = 0 if CD is recognized properly, 2 if no CD, other numbers if mishap
	  if [ "$CD_in" == "0" ]
	  then	
		echo "Disk recognized, starting DICOM organization and conversion..."
		~/DICOMpose/DICOMpose_linux/DICOMpose/DICOMpose.sh
		~/DICOMpose/DICOMpose_linux/DICOMpose/monitorCD.sh
	  else 
	  	~/DICOMpose/DICOMpose_linux/DICOMpose/monitorCD.sh
	  fi

