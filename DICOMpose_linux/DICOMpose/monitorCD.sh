#!/bin/bash

############
# Created November 2019
# author:@sb3784
# 
# monitorCD.sh is always deployed and checks when the system has a disc inserted
########### 

TARGET=/dev/sr0

inotifywait -m --format "%f" $TARGET \
	  | echo "Hello!" 
	  sleep 20s #wait for computer to recognize CD
	  echo "Done sleeping"
	  dcpdir=$(pwd)
	  blkid /dev/sr0
	  cd_there=$(echo $?)
	  if [ $cd_there -le 1 ] 
	  then	
	        echo "Disk recognized, starting DICOM organization and conversion..."
       	        $dcpdir/DICOMpose_CD.sh
	  	eject
	  	sleep 20s
	  else 
	        echo "No disk recognized"
	  fi
	  $dcpdir/monitorCD.sh


