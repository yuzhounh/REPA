# REPA
Resting-State fMRI Preprocessing and Analysis

REPA (Resting-state fMRI Preprocessing and Analysis) is a toolbox developed based on SPM and DPABI for processing resting-state fMRI data.

## Features

- User-friendly graphical interface
- Batch processing of multiple subjects
- Standard preprocessing pipeline including:
  - DICOM to NIfTI conversion (Optional)
  - Time points removal
  - Slice timing correction
  - Realignment
  - Normalization
  - Smoothing
  - Filtering
- Flexible parameter settings
- Support for DICOM and NIfTI formats

## Requirements

- MATLAB
- SPM12
- DPABI

## Installation

1. Download REPA from this repository
2. Add REPA folder to MATLAB path
3. Run `repa.m` to start the GUI

![REPA Interface](repa_utilities/repa_gui.png)

## Data Organization

REPA expects input data to be organized in a specific directory structure as shown below:

For DICOM format data, please organize your data in the following structure:

RootDir/
├── FunRaw/
│   ├── sub000001/
│   │   ├── 000001.dcm
│   │   ├── 000002.dcm
│   │   ├── 000003.dcm
│   │   └── ......
│   ├── sub000002/
│   │   ├── 000001.dcm
│   │   ├── 000002.dcm
│   │   ├── 000003.dcm
│   │   └── ......
│   ├── sub000003/
│   │   ├── 000001.dcm
│   │   ├── 000002.dcm
│   │   ├── 000003.dcm
│   │   └── ......
│   └── ......
└── T1Raw/
    ├── sub000001/
    │   ├── 000001.dcm
    │   ├── 000002.dcm
    │   ├── 000003.dcm
    │   └── ......
    ├── sub000002/
    │   ├── 000001.dcm
    │   ├── 000002.dcm
    │   ├── 000003.dcm
    │   └── ......
    ├── sub000003/
    │   ├── 000001.dcm
    │   ├── 000002.dcm
    │   ├── 000003.dcm
    │   └── ......
    └── ......

For NIFTI format data, please organize your data in the following structure:

RootDir/
├── FunImg/
│   ├── sub000001/
│   │   ├── sub000001_task-rest_bold.nii
│   │   └── sub000001_task-rest_bold.json
│   ├── sub000002/
│   │   ├── sub000002_task-rest_bold.nii
│   │   └── sub000002_task-rest_bold.json
│   ├── sub000003/
│   │   ├── sub000003_task-rest_bold.nii
│   │   └── sub000003_task-rest_bold.json
│   └── ......
└── T1Img/
    ├── sub000001/
    │   ├── sub000001_T1w.nii
    │   ├── sub000001_T1w_Crop_1.nii
    │   └── sub000001_T1w.json
    ├── sub000002/
    │   ├── sub000002_T1w.nii
    │   ├── sub000002_T1w_Crop_1.nii
    │   └── sub000002_T1w.json
    ├── sub000003/
    │   ├── sub000003_T1w.nii
    │   ├── sub000003_T1w_Crop_1.nii
    │   └── sub000003_T1w.json
    └── ......

For testing and demonstration purposes, you can download sample resting-state fMRI data in DICOM format from:
https://rfmri.org/content/demonstrational-data-resting-state-fmri

The data is already organized in the required directory structure and can be used directly with REPA after downloading and extracting.


## Usage Instructions

1. Organize your data according to the directory structure shown above
2. Open the REPA toolbox and set the following parameters in the interface:
   - Working directory: Set to the full path of your data root directory (RootDir)
   - Time points to remove: Set the number of initial time points to remove (default is 10)
   - Voxel size (mm): Set the voxel dimensions in [x, y, z] format (default is [3, 3, 3])
   - FWHM (mm): Set the spatial smoothing full-width at half maximum in [x, y, z] format (default is [6, 6, 6])
   - Filter band (Hz): Set the temporal filtering frequency range in [low, high] format (default is [0.01, 0.1])
3. Click the "RUN" button to start processing

## Processing Pipeline

1. Initial Volume Removal
   - First 10 volumes are discarded to allow for signal stabilization

2. Slice Timing Correction
   - Corrects for differences in slice acquisition timing

3. Head Motion Correction (Realignment)
   - Realigns functional volumes to correct for head movement

4. EPI Coverage Check
   - Automask generation for quality control
   - Group mask creation

5. Brain Extraction (BET)
   - Removes non-brain tissue from images

6. Structural-Functional Coregistration
   - T1 image is coregistered to mean functional image

7. Segmentation and DARTEL
   - New Segment for tissue classification
   - DARTEL for improved registration

8. Nuisance Regression
   - Polynomial trend removal
   - Head motion parameters
   - White matter signal
   - CSF signal
   - Global signal

9. DARTEL Normalization
   - Normalizes data to standard space

# Data Analysis Pipeline

1. ALFF/fALFF Analysis
   - Amplitude of low frequency fluctuations
   - Fractional ALFF

2. Temporal Filtering
   - Bandpass filter: 0.01-0.1 Hz

3. Regional Homogeneity (ReHo)
   - Local connectivity measure

4. Degree Centrality
   - Global connectivity measure

5. Template Normalization
   - Normalize to symmetric template
   - VMHC analysis

6. Spatial Smoothing
   - Final smoothing of derivative maps