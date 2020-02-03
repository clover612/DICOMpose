#!/bin/bash

echo "Welcome to DICOMpose. Please indicate by pressing a 0 or 1 whether you would like to monitor and process a DICOM CD (0) or a file folder (1)."

read choice 

if [ "$choice" == "0" ]; then
    ~/DICOMpose/monitorCD.sh
elif [ "$choice" == "1" ]; then
    ~/DICOMpose/DICOMpose_files.sh
fi
