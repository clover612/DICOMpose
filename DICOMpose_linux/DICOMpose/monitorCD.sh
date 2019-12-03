#!/bin/bash

############
# Created November 2019
# author:@sb3784
# 
# monitorCD.sh is always deployed and checks when the system has a disc inserted
########### 

TARGET=/dev/cdrom

inotifywait -m --format "%f" $TARGET \
	  | echo "Hello!" 
	  sleep 10s #wait for computer to recognize CD
	  echo "Done sleeping"
	  dcpdir=$(pwd)
	  cd_there=$(isoinfo -d -i /dev/cdrom)
	  if echo $cd_there | grep -Eq 'Volume id'
	  then	
	        echo "Disk recognized, starting DICOM organization and conversion..."
       	        $dcpdir/DICOMpose.sh
	  	eject
	  	sleep 20s
	  else 
	        echo "No disk recognized"
	  fi
	  $dcpdir/monitorCD.sh


