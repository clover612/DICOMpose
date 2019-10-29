# WELCOME TO DICOMpose

## Please follow these steps to process and summarize your DICOMs 
 
1. Download Chris Rorden's dcm2niix_mac.zip script from https://github.com/rordenlab/dcm2niix/releases and unzip the file. Note the location of the dcm2niix file. 
2. Drag and drop the DICOMpose folder into Terminal (a program that can be found by typing Terminal into Searchlight) 
3. In Terminal, type ./DICOMpose.sh and enter.
4. When prompted with "Please enter the path to the dcm2niix executable", please drag the dcm2niix downloaded earlier.
5. When prompted with "Please enter output folder", please drag and drop the destination folder for the converted niftis and summary files.


## OPTIONS/FLAGS to specify an action other than default 

### option_letter d
DEFAULT: DICOMS copied and organized from CD are retained on the user's drive  
To delete OrganizedDicoms directory please use this format: ./DICOMPOSE.sh -d 1 

### option_letter f
DEFAULT: File structure tree is retained (Patient ID --> Scan Date --> Modality)
To reduce file structure to (Patient ID) please use this format: ./DICOMPOSE.sh -f 1

To perform non-default for both of these options, please use this format ./DICOMPOSE.sh -d 1 -f 1 


