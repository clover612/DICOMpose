# WELCOME TO DICOMpose

## Please make sure you have downloaded all of these programs before you run DICOMpose
1. FSL (instructions for download here: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation/Linux )
2. dcmtk (instructions for download here: https://dicom.offis.de/dcmtk.php.en)  
3. inotify (instructions for download here: https://github.com/rvoicilas/inotify-tools/wiki )

## Please follow these steps to process and summarize your DICOMs 
 
1. Download Chris Rorden's dcm2niix_mac.zip script from https://github.com/rordenlab/dcm2niix/releases and unzip the file. Please ensure that the dcm2niix file enclosed is
contained in your Downloads folder (~/Downloads) 
2. Drag and drop the DICOMpose folder into Terminal (a program that can be found by typing Terminal into Searchlight) 
3. In Terminal, type ./DICOMpose.sh and enter.
4. When prompted with "Please enter output folder", please drag and drop the destination folder for the converted niftis and summary files.


## OPTIONS/FLAGS to specify an action other than default 

### option_letter d
DEFAULT: DICOMS copied and organized from CD are retained on the user's drive  
To delete OrganizedDicoms directory please use this format: ./DICOMPOSE.sh -d 1 

### option_letter f
DEFAULT: File structure tree is retained (Patient ID --> Scan Date --> Modality)
To reduce file structure to (Patient ID) please use this format: ./DICOMPOSE.sh -f 1

To perform non-default for both of these options, please use this format ./DICOMPOSE.sh -d 1 -f 1 


