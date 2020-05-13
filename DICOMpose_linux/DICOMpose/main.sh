#!/bin/bash

##############
# Created in Spring 2020
# author:@sb3784 / clover612
# main.sh signals to the DICOMpose pipeline whether the user
# is entering a disk drive or local folder for processing
# INPUTS: user input of 0 or 1
##############


echo "Welcome to DICOMpose. Please indicate by pressing a 0 or 1 whether you would like to monitor and process a DICOM CD (0) or a file folder (1)."

read choice 

if [ "$choice" == "0" ]; then #disk drive
    ~/DICOMpose/monitorCD.sh
elif [ "$choice" == "1" ]; then #local folder
    ~/DICOMpose/DICOMpose_files.sh
fi
