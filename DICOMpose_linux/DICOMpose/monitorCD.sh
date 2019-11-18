#!/bin/bash

TARGET=/dev/sr0
PROCESSED=~/processed/

inotifywait -m --format "%f" $TARGET \
	| sleep 5s
	  blkid_info=$(blkid /dev/sr0)
	  CD_in=$(echo $?)
	  if [ "$CD_in" == "0" ]
	  then	
		echo "Disk recognized, starting DICOM organization and conversion..."
		~/DICOMpose/DICOMpose.sh
		~/monitorCD.sh
	  else 
	  	~/monitorCD.sh
	  fi

